# Fix record: aitkens-and-nevilles-interpolation

Scratch evidence folder (re-runnable): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/work/aitkens-and-nevilles-interpolation/fix/` (below: `$FIX`).

- `check.py` (run `cd $FIX && /usr/bin/python3 -I check.py`, output `check.out`): sympy exact interpolants P_{0,0}..P_{0,4} of cos at 0, π/4, π/2, 3π/4, π, and their exact degrees; P4 − P3; P3(π); x⁴ coefficient of P4; max |P_{0,j} − cos| on [0, π] (100001 points), on the plot window [−0.1, π+0.1] (500 and 100001 points); Neville and Aitken tableaux at x = 1, with every Aitken entry checked against scipy `lagrange` on the node set {x_0..x_{k−1}, x_j}.
- `inst.jl` (run `cd $FIX && julia inst.jl`, output `inst.out`): the committed script's own `neville_table`/`interp_degree` code (plotting removed), printing max error on the script's plot grid per degree and max |P_{0,4} − P_{0,3}|.
- `frames/`: frames of the committed (unchanged) `nevilleaa.gif` from `giftools.jl`; `framediff.py` (output `framediff.out`) compares frames 4 and 5 pixel by pixel.

## Findings

### F1 — Error — fixed
- **Reproduced:** `check.py`, x = 1. Neville columns (degree 1, 2, 3, 4): [0.627077, 0.513897, 0.513897, −0.201350]; [0.555024, 0.513897, 0.773804]; [0.537570, 0.537570]; [0.537570]. Aitken columns: [0.627077, 0.363380, 0.275481, 0.363380]; [0.555024, 0.579042, 0.603059]; [0.537570, 0.537570]; [0.537570]. "Aitken entries match Lagrange on {x0..x_{k-1},x_j}: True". Final value 0.537569521354321 from both, equal to exact P_4(1) = 0.5375695213543209. The intermediate entries differ, so the two are different recursions, and "between neighboring approximants" describes Neville, not Aitken. The finding holds.
- **Change:** index.qmd:21. "Aitken's process is the same recursion viewed as repeated linear interpolation between neighboring approximants; Neville's table is the standard tabular form used for robust numerical evaluation." → "Aitken's scheme is a different arrangement of the same idea, repeated linear interpolation. At stage $k$ it combines the interpolant on $x_0,\dots,x_{k-1}$ with the interpolant on $x_0,\dots,x_{k-2},x_j$, so every entry in a column shares the same leading nodes, whereas Neville's scheme combines interpolants on neighbouring runs of consecutive nodes. The intermediate entries differ, but both schemes end with the same interpolated value. The animation below uses Neville's scheme."
- **Check:** `check.py` Aitken recursion A_{k,j} = [(x−x_{k−1})A_{k−1,j} − (x−x_j)A_{k−1,k−1}]/(x_j−x_{k−1}). Its entries equal Lagrange on {x_0..x_{k−1}, x_j} (True), so the two combined entries are on {x_0..x_{k−2}, x_j} and {x_0..x_{k−1}}, and each column k shares x_0..x_{k−1}. Neville's formula on the page (line 17) and in nevilleaa.jl:21–22 combines P_{i+1,j} (nodes i+1..j) and P_{i,j−1} (nodes i..j−1), runs of consecutive nodes. The script runs Neville's formula. The legacy module says the same: Aitken uses "{same row, preceding column} and {top row, preceding column}", Neville uses "{same row, preceding column} and {preceding row, preceding column}".

### F2 — Misleading — fixed (option a, text only, per D7 and the checker's correction)
- **Reproduced:** `check.py`: exact degrees of P_{0,0}..P_{0,4} are 0, 1, 2, 3, **3**; `simplify(P4 − P3) = 0`; P3(π) = −1; x⁴ coefficient of P4 = 0. Max |P − cos| on [0, π]: 2.000000, 0.898805, 1.656854, 0.008068, 0.008068. On the plot window (500 points): 2.000000, 0.898805, 1.887087, 0.008519, 0.008519. `inst.jl` (the script's own code): plot-grid errors 1.99999990, 0.89880475, 1.88708748, 0.00851874, 0.00851874; max |P_{0,4} − P_{0,3}| = 6.66e−16. `framediff.py`: frames 4 and 5 differ only in the title digits, the legend label and the dot at x = π (rows 387–399); the red-curve pixels differ only at that dot. The finding holds. The checker's extra point also holds: error rises from degree 1 to degree 2.
- **Change:** index.qmd only, no script or GIF change.
  - Line 25: "Each frame adds one node, building successively higher-degree interpolants $P_{0,j}(x)$." → "Each frame adds one node and shows $P_{0,j}(x)$, the interpolant of degree at most $j$ through the first $j+1$ nodes, for $j=0,\dots,4$."
  - Line 29 heading: "degree 0 through 4" → "$P_{0,0}$ through $P_{0,4}$".
  - Line 31: "Adding each node refines the polynomial. By degree 4 (using all 5 nodes) the interpolant closely matches $\cos(x)$ on the whole interval." → "Adding a node does not always reduce the error: the largest error $|P_{0,j}(x)-\cos x|$ on $[0,\pi]$ falls from 2.00 at $j=0$ to 0.90 at $j=1$, rises to 1.66 at $j=2$, then drops to $8.1\times10^{-3}$ at $j=3$. With these symmetric nodes the cubic $P_{0,3}$ already passes through $(\pi,-1)$, because $\cos$ is odd about $\pi/2$, so the fifth node leaves the polynomial unchanged: $P_{0,4}=P_{0,3}$, and the last two frames show the same curve."
  - Line 35 alt text: "from degree 0 constant to degree 4 at 5 nodes at …" → "at nodes 0, pi/4, pi/2, 3pi/4, pi, from the degree-0 constant to the five-node interpolant P_{0,4}, which is the same cubic as P_{0,3}".
- **Check:** see the ledger. Every number comes from `check.out`, and the curve identity from `inst.out` and `framediff.out`.

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd:21 | Aitken "at stage k combines the interpolant on x_0..x_{k−1} with the interpolant on x_0..x_{k−2}, x_j" | `check.py` → Aitken entries equal Lagrange on {x0..x_{k−1}, x_j}: True (the operands are A_{k−1,k−1} on {x0..x_{k−1}} and A_{k−1,j} on {x0..x_{k−2}, x_j}) | yes |
| index.qmd:21 | "every entry in a column shares the same leading nodes" | same check: column k entries are on {x0..x_{k−1}} ∪ {x_j} | yes |
| index.qmd:21 | Neville "combines interpolants on neighbouring runs of consecutive nodes" | page formula line 17, nevilleaa.jl:21–22: P_{i+1,j} on {i+1..j}, P_{i,j−1} on {i..j−1} | yes |
| index.qmd:21 | "intermediate entries differ, but both … end with the same interpolated value" | `check.py` → degree-2 column Neville [0.555024, 0.513897, 0.773804] vs Aitken [0.555024, 0.579042, 0.603059]; finals 0.537569521354321 and 0.5375695213543212 (exact 0.5375695213543209) | yes |
| index.qmd:21 | "The animation below uses Neville's scheme" | nevilleaa.jl:12–26 implements P_{i,j} = [(x−x_i)P_{i+1,j} − (x−x_j)P_{i,j−1}]/(x_j−x_i) | yes |
| index.qmd:25 | "Each frame adds one node and shows P_{0,j}, degree at most j through the first j+1 nodes, j = 0..4" | nevilleaa.jl:36–44 (`xs[1:deg+1]`, `deg in 0:4`); giftools → 5 frames; `check.py` exact degrees 0,1,2,3,3 (all ≤ j) | yes |
| index.qmd:29 | heading "$P_{0,0}$ through $P_{0,4}$" | frames 1–5 legend labels P_{0,0}..P_{0,4} (viewed frame_005: "P_{0,4}(x)") | yes |
| index.qmd:31 | "Adding a node does not always reduce the error" | `check.py` → max err on [0,π] rises 0.898805 (j=1) → 1.656854 (j=2), and is unchanged j=3 → j=4 | yes |
| index.qmd:31 | 2.00 at j=0 | `check.py` → 2.000000 | yes |
| index.qmd:31 | 0.90 at j=1 | `check.py` → 0.898805 | yes |
| index.qmd:31 | 1.66 at j=2 | `check.py` → 1.656854 (on [0,π]; 1.887 on the wider plot window, so "rises" holds on both) | yes |
| index.qmd:31 | 8.1×10⁻³ at j=3 | `check.py` → 0.008068 on [0,π] | yes |
| index.qmd:31 | "the cubic P_{0,3}" | `check.py` → exact degree 3 | yes |
| index.qmd:31 | "already passes through (π,−1)" | `check.py` → P3(π) = −1 | yes |
| index.qmd:31 | "because cos is odd about π/2" (with symmetric nodes) | cos(π−x) = −cos x and the nodes are symmetric, so −Q(π−x) interpolates the same data as the five-node Q; uniqueness gives Q odd about π/2, hence no quartic term (`check.py` x⁴ coeff = 0), so Q is the cubic through the first four nodes | yes |
| index.qmd:31 | "P_{0,4} = P_{0,3}" | `check.py` → simplify(P4 − P3) = 0; `inst.jl` → max \|P04 − P03\| = 6.66e−16 | yes |
| index.qmd:31 | "the last two frames show the same curve" | `framediff.py` → frames 4/5 differ only in title digits, legend label and the dot at x = π; red pixels differ only under that dot | yes |
| index.qmd:35 alt | "five-node interpolant P_{0,4}, which is the same cubic as P_{0,3}" | as above | yes |

## Scripts and GIFs
- No script changed and no GIF regenerated: F2 was fixed in the text (D7, and the checker found the animation itself correct, with the frame title only a label).
- Committed GIF frames extracted to `$FIX/frames/` (5 frames). frame_005 viewed at full size: title "degree 4 (5 nodes)", legend "P_{0,4}(x)", red dashed curve lies on cos, and five nodes.
- `git status --short -- pages/numerical-methods/aitkens-and-nevilles-interpolation` → ` M pages/numerical-methods/aitkens-and-nevilles-interpolation/index.qmd` only.

## Legacy archive
Consulted: `/home/jason/Desktop/math-fullerton/baseline/mathews/n2003/NevilleAlgorithmMod.html` (the module is at the archive's top level, not inside `nevillealgorithm/`) and its `Links/NevilleAlgorithmMod_lnk_*.html`. The module covers both Aitken's and Neville's tableaux. In the text, Neville's entries use "{same row, preceding column} and {preceding row, preceding column}" and Aitken's use "{same row, preceding column} and {top row, preceding column}". It says "Aitken's and Neville's methods agree on the diagonal". This supports F1's fix. The functions, nodes and query points of Mathews' examples are in formula images and were not needed. The module has no animation that corresponds to the cos/5-node example, so there is nothing to be faithful to for F2.

## Notes
- The GIF's last frame title still reads "degree 4 (5 nodes)" for a curve whose exact degree is 3. The checker judged this defensible as the label of P_{0,4}, and D7 keeps the animation. The page now says plainly that P_{0,4} = P_{0,3} is a cubic. If Jason prefers, the title could read "P_{0,$deg} ($(deg+1) nodes)". That would change all five frames.
- The legend shows "P_{0,4}(x)" literally, with braces, because GR does not render it as a subscript. This is cosmetic, pre-existing and not a finding, so it was left alone.
- Behavior's first sentence ("builds the degree-n interpolating polynomial by combining two polynomials of degree n−1") was not a finding and was left unchanged. It is a general statement where "degree" means "degree at most".

### Director note

Residual nit accepted by the checker and not changed: the frame-5 GIF title still reads 'degree 4 (5 nodes)' although P_{0,4} equals the cubic P_{0,3}; the page text now explains this. Retitling to 'degree ≤ 4' would remove the nit; left for the round-2 review.

## Resolution check (independent checker, not shown this record)

Scope of the fix: only `index.qmd` changed (5 lines). `nevilleaa.jl` and `nevilleaa.gif` are unchanged against HEAD (`git diff HEAD --quiet` on both).

Work files: `check/verify.py` (sympy exact interpolants, error maxima on a 200001-point grid, Neville and Aitken tableaux at x = 1, with each Aitken entry checked against a direct interpolant), `check/run/` (scratch rerun), `check/frames/` (decoded frames).

### Original findings

### F1 — resolved
- Evidence: The sentence "Aitken's process is the same recursion ... between neighboring approximants" is gone. The replacement says that Aitken's scheme is a different arrangement of repeated linear interpolation, and that at stage k it combines the interpolant on x_0..x_{k-1} with the interpolant on x_0..x_{k-2},x_j. It also says Neville combines interpolants on neighbouring runs of consecutive nodes, that the intermediate entries differ, that the final value is the same, and that the animation uses Neville.
- I built Aitken's tableau with A_{k,j} = [(x−x_{k-1})A_{k-1,j} − (x−x_j)A_{k-1,k-1}]/(x_j−x_{k-1}). For every k, j I checked numerically that A_{k,j} equals the sympy interpolant on {x_0..x_{k-1}, x_j} (all agree to 1e-12). So the page's description of what gets combined at stage k is correct, and so is "every entry in a column shares the same leading nodes".
- The intermediate entries differ. At degree 1, Neville gives [0.62708, 0.51390, 0.51390, −0.20135] and Aitken gives [0.62708, 0.36338, 0.27548, 0.36338]. The final values match: Neville 0.537569521354321, Aitken 0.5375695213543212, Lagrange 0.5375695213543209.

### F2 — resolved
- Evidence: Both false claims are gone: "building successively higher-degree interpolants" (line 25) and "Adding each node refines ... By degree 4 ... closely matches" (line 31). Line 25 now says "the interpolant of degree at most j through the first j+1 nodes". The Behavior text now says error does not decrease monotonically, gives the maxima, and states P_{0,4} = P_{0,3} with the symmetry reason. The heading and the alt text no longer call the last curve "degree 4". The alt text names P_{0,4} as the same cubic as P_{0,3}.
- Sympy, exact: deg P_{0,4} = 3, P_{0,4} − P_{0,3} = 0, P_{0,3}(π) = −1, and P_{0,4}(π/2+t) + P_{0,4}(π/2−t) = 0 (odd about π/2).
- The fix also covers the reviewer-checker's extra point that error rises at j = 2.
- Residual, not counted as a new problem: the script and GIF were not changed, so frame 5's title still reads "degree 4 (5 nodes)" while the curve is a cubic. The legend says P_{0,4}, and the page text now states plainly that the last two frames show the same curve. The finding's own checker judged this label defensible. I agree, but it would be slightly cleaner as "P_{0,4}" or "degree ≤ 4".

### Changed-text ledger

| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd:21 | "Aitken's scheme is a different arrangement of the same idea, repeated linear interpolation" | Both are two-term linear-interpolation recursions with different tableaux (verify.py) | True |
| index.qmd:21 | "At stage k it combines the interpolant on x_0..x_{k-1} with the interpolant on x_0..x_{k-2},x_j" | A_{k,j} checked against direct interpolants on {x_0..x_{k-1},x_j} for all k, j | True |
| index.qmd:21 | "every entry in a column shares the same leading nodes" | Column k entries all contain x_0..x_{k-1} | True |
| index.qmd:21 | "Neville's scheme combines interpolants on neighbouring runs of consecutive nodes" | P_{i,j} from P_{i+1,j}, P_{i,j-1} (consecutive index ranges) | True |
| index.qmd:21 | "intermediate entries differ, but both ... end with the same interpolated value" | Degree-1 columns differ; finals 0.5375695213543 for both | True |
| index.qmd:21 | "The animation below uses Neville's scheme" | Script's `neville_table` is Neville's recursion | True |
| index.qmd:25 | "Each frame adds one node and shows P_{0,j}(x), the interpolant of degree at most j through the first j+1 nodes, for j=0,…,4" | Script uses xs[1:deg+1], deg 0:4, 5 frames (frame tool: 5 frames) | True |
| index.qmd:29 | Heading "P_{0,0} through P_{0,4} for cos(x)" | Matches frames 1–5 legends | True |
| index.qmd:31 | "largest error on [0,π] ... 2.00 at j=0" | max = 2.000000 at x = π | True |
| index.qmd:31 | "0.90 at j=1" | 0.898805 at x = 2.759 | True |
| index.qmd:31 | "rises to 1.66 at j=2" | 1.656854 at x = π (numerically equal to 4√2 − 4) | True |
| index.qmd:31 | "drops to 8.1×10⁻³ at j=3" | 0.008068 at x = 0.283 | True |
| index.qmd:31 | "Adding a node does not always reduce the error" | 0.90 → 1.66 | True |
| index.qmd:31 | "cubic P_{0,3} already passes through (π,−1)" | P_{0,3}(π) = −1 exactly | True |
| index.qmd:31 | "because cos is odd about π/2" (with "these symmetric nodes") | 5-point interpolant is odd about π/2, so it has no t⁴ term, so it is a cubic, so it equals P_{0,3} | True (compressed but correct) |
| index.qmd:31 | "P_{0,4}=P_{0,3}, and the last two frames show the same curve" | symbolic difference 0; frames 4 and 5 show the same red curve, and only the fifth dot is new | True |
| index.qmd:35 | Alt text: nodes 0, π/4, π/2, 3π/4, π; degree-0 constant to P_{0,4}, "the same cubic as P_{0,3}" | Matches script and frames | True |

### New problems

None. This rests on the following:
- every changed sentence and number was checked independently (table above);
- the script and GIF are unchanged and reproduce exactly;
- frames 1, 3, 4 and 5 were viewed at full size and agree with the text (constant at y = 1; quadratic diverging past π/2; cubic on cos; identical curve plus fifth node).

The unchanged Behavior clause "builds the degree-n interpolating polynomial by combining two polynomials of degree n−1" is the standard description, and the fix did not touch it.

### Reproducibility and conventions

- `nevilleaa.jl` was copied to `check/run/` and run there with `julia`. The output `nevilleaa.gif` is byte-identical to the committed GIF (`cmp`). It has 5 frames, and the frame md5s are in `check/frames/frames.md5`.
- Conventions: Description comes before Animations, there is one case with a `[Julia source](nevilleaa.jl)` link and a GIF embed, the alt text is descriptive, and there are no code blocks. The section index still links the page (pages/numerical-methods/index.qmd:67).
- The fix diff touches only `pages/numerical-methods/aitkens-and-nevilles-interpolation/index.qmd`. Working-tree changes outside this page folder belong to other pages on the branch, not to this fix (fix.diff lists only index.qmd for this folder).

**Final status:** committed
