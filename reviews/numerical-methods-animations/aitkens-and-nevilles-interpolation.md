# Aitken's and Neville's Interpolation — animation review

Page: [`pages/numerical-methods/aitkens-and-nevilles-interpolation/index.qmd`](../../pages/numerical-methods/aitkens-and-nevilles-interpolation/index.qmd) · Scripts: `nevilleaa.jl` · GIFs: 1

**Result:** 1 error, 1 misleading, 0 minor.

Errors and misleading findings were each re-checked by an independent subagent given only the allegation (not the reviewer's reasoning). Minor findings were not independently re-checked. Finding IDs (F1, F2, …) are the reviewer's and match the claim ledger below.

## Findings

### F1 — Error — Page match — Aitken's scheme is described as "the same recursion" as Neville's; it is a different recursion

- **Location:** index.qmd:21, "Aitken's process is the same recursion viewed as repeated linear interpolation between neighboring approximants; Neville's table is the standard tabular form used for robust numerical evaluation."
- **Now:** The page says Aitken's process is the same recursion as Neville's, and characterizes it as interpolating between *neighboring* approximants.
- **True:** Aitken's and Neville's schemes are different recursions that produce the same final value (the unique interpolant). Neville combines two approximants on *neighbouring/overlapping consecutive* node sets, P_{i,j} from P_{i+1,j} and P_{i,j-1} (the formula on lines 17 and 31, and what the script runs). Aitken's scheme instead keeps a fixed leading block of nodes: at stage k it combines the interpolant on {x_0..x_{k-1}} with the interpolant on {x_0..x_{k-2}, x_j}, i.e. A_{k,j} = [(x−x_{k-1})A_{k-1,j} − (x−x_j)A_{k-1,k-1}]/(x_j−x_{k-1}). "Between neighboring approximants" is the defining property of Neville's scheme, not Aitken's. Both are "repeated linear interpolation". The intermediate entries differ, which shows they are not the same recursion.
- **Evidence:** `cd reviewer && /usr/bin/python3 -I indep.py` builds both tableaux at x = 1 for cos at nodes 0, π/4, π/2, 3π/4, π.
  - Neville columns (degree 1, 2, 3): 0.627076771422, 0.513897246216, …; 0.555024447849, 0.513897246216, 0.77380408175; 0.537569521354, 0.537569521354.
  - Aitken columns (degree 1, 2, 3): 0.627076771422, 0.363380227632, 0.275481379703, 0.363380227632; 0.555024447849, 0.57904188904, 0.603059330231; 0.537569521354, 0.537569521354.
  - Final value from both: 0.537569521354 (= exact Lagrange P_4(1) = 0.537569521354321).
- **Suggested fix:** Replace the sentence with, for example: "Aitken's scheme is a different arrangement of the same idea, repeated linear interpolation. At stage k it combines the interpolant on $x_0,\dots,x_{k-1}$ with the interpolant on $x_0,\dots,x_{k-2},x_j$, so every entry in a column shares the same leading nodes. Neville's scheme combines interpolants on neighbouring consecutive node sets. The intermediate entries differ, but both end with the same interpolated value. The animation below uses Neville's scheme." Optionally give Aitken's formula.

- **Independent check:** confirmed.

### F2 — Misleading — Page match — The "degree 4" interpolant is the same cubic as degree 3; adding the fifth node changes nothing

- **Location:** index.qmd:25, "Each frame adds one node, building successively higher-degree interpolants $P_{0,j}(x)$."; index.qmd:31, "Adding each node refines the polynomial. By degree 4 (using all 5 nodes) the interpolant closely matches $\cos(x)$ on the whole interval."; also the case heading (line 29, "degree 0 through 4"), the alt text (line 35, "to degree 4"), and the GIF's last frame title "degree 4 (5 nodes)" (nevilleaa.jl:50).
- **Now:** The page presents frame 5 as a further refinement, a degree-4 polynomial that finally matches cos(x).
- **True:** For these nodes, P_{0,4} ≡ P_{0,3} exactly. cos is odd about π/2 and the nodes are symmetric about π/2, so the 5-point interpolant is odd about π/2. That makes its quartic coefficient zero, and the cubic through the first four nodes already passes through (π, −1). The fifth node therefore adds nothing. Frames 4 and 5 show the identical red curve, and only the fifth black dot differs. The max error against cos is the same for both (0.008068 on [0, π], 0.008519 on the plot window), so the close match is already reached at degree 3. Nothing about this is computed wrongly. But a reader told that "adding each node refines the polynomial" and that degree 4 gives the close fit will draw a false lesson from the last frame.
- **Evidence:** `reviewer/indep.py` (sympy `interpolate`, exact):
  - deg 3: exact degree 3, leading coeff 32(√2−1)/(3π³) ≈ 0.142496.
  - deg 4: exact degree **3**, same leading coeff.
  - `simplify(P4 − P3) = 0`; `P3(π) = −1`.
  - The script's own values agree: `reviewer/inst.jl` gives P[1,4] = P[1,5] = 0.5375695213543210 at x = 1, −0.8039294860949013 vs −0.8039294860949012 at x = 2.5. Max |P−cos| on the plot grid is 8.519e-03 for both deg 3 and deg 4.
  - Frames 004 and 005 viewed at full size show the same red curve.
- **Suggested fix:** Either (a) keep the animation and correct the text. For example, in Behavior: "With these symmetric nodes the degree-3 interpolant already passes through $(\pi,-1)$, because $\cos$ is odd about $\pi/2$. The fifth node therefore leaves the polynomial unchanged: $P_{0,4}=P_{0,3}$, which is a cubic, and both match $\cos(x)$ to within about $8\times10^{-3}$ on $[0,\pi]$." Also say "degree at most 4" where "degree 4" is used. Or (b) change the data so that each added node matters. Asymmetric nodes such as 0, 0.6, 1.5, 2.2, π would do, as would a function without the odd symmetry about π/2. Then re-check the Behavior text.

- **Independent check:** confirmed with correction. Checker: P4 − P3 = 0 symbolically (max error 0.0085 for both). Correction: the false claims are chiefly lines 25 and 31; lines 29, 35 and the frame title only use 'degree 4' as the label of P_{0,4}, which is defensible alone. Also (not alleged): line 31's 'adding each node refines' already fails at degree 2, where max error on the plot range rises from 0.90 (degree 1) to 1.89.

## Inventory (Phase 1)

Every script was copied to scratch and run with the global Julia environment (Plots 1.41.2, SpecialFunctions 2.9.2); each was also run alone to map scripts to GIFs.

| Script | Ran | Time (s) | GIFs produced |
|---|---|---|---|
| `nevilleaa.jl` | yes | 2.7 | nevilleaa.gif |

Committed GIFs byte-identical to their regenerated output: **1 of 1**. Decoded frames were also compared; all match.

Inventory findings: none (every script runs, every GIF is produced by a script and embedded by the page, every page reference exists, and the section index links the page).

## Claim ledger

| # | index.qmd line | Claim (page's own words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | 12 | "evaluates the unique degree-$(n-1)$ polynomial through data points $(x_i,y_i)$" | It is the unique polynomial of degree *at most* n−1. Here the 5-point one has degree 3 (sympy). Standard looseness, relevant only through F2. | confirmed (wording "at most" is better; see F2) |
| 2 | 12 | "without first converting to expanded polynomial coefficients" | Script evaluates the tableau pointwise at each query xq (nevilleaa.jl:12-26, 36-42); no coefficients are formed. | confirmed |
| 3 | 15-18 | $P_{i,i}=y_i$, $P_{i,j}=\frac{(x-x_i)P_{i+1,j}-(x-x_j)P_{i,j-1}}{x_j-x_i}$ | Matches nevilleaa.jl:16, 21-22 exactly (1-based indices). The recursion is correct: at x=x_i it gives P_{i,j-1}(x_i)=y_i, at x=x_j it gives P_{i+1,j}(x_j)=y_j. Script output equals the exact Lagrange values to ≤ 7.8e-16 (indep.py). | confirmed |
| 4 | 21 | "The final interpolated value at a query point $x$ is $P_{0,n-1}(x)$" | Script returns P[1, deg+1] (line 41). That equals the exact Lagrange interpolant at every plotted point, all degrees (max diff 7.8e-16). | confirmed |
| 5 | 21 | "Aitken's process is the same recursion viewed as repeated linear interpolation between neighboring approximants" | Independent Aitken and Neville tableaux at x=1 have different intermediate entries and the same final value. "Neighboring" describes Neville. | wrong (→ F1) |
| 6 | 21 | "Neville's table is the standard tabular form used for robust numerical evaluation" | A general characterization, not tied to anything computed on the page. | could not determine (not a checkable claim about this page's computation) |
| 7 | 25 | animation illustrates "Neville's algorithm" | Code runs Neville's recursion (claim 3), not Aitken's. | confirmed |
| 8 | 25 | "$f(x) = \cos(x)$" | nevilleaa.jl:29. GIF title "for cos(x)", legend "f(x) = cos(x)". | confirmed |
| 9 | 25 | "at 5 nodes $x_0 = 0, \pi/4, \pi/2, 3\pi/4, \pi$" | nevilleaa.jl:30. Dots in frame 5 at 0, 0.785, 1.571, 2.356, 3.142. | confirmed |
| 10 | 25 | "Each frame adds one node" | 5 frames, nodes used = xs[1:deg+1] for deg 0..4 (line 57). Frames show 1, 2, 3, 4, 5 dots. | confirmed |
| 11 | 25 | "building successively higher-degree interpolants $P_{0,j}(x)$" | Degrees are 0, 1, 2, 3, 3. P_{0,4} ≡ P_{0,3}. | wrong (→ F2) |
| 12 | 29 | Heading "Neville's algorithm: degree 0 through 4 for $\cos(x)$" | Frames are titled degree 0..4 and use 1..5 nodes, but the "degree 4" curve is a cubic. | confirmed as labelling; misleading via F2 |
| 13 | 31 | "builds the degree-$n$ interpolating polynomial by combining two polynomials of degree $n-1$" + formula | Same as claim 3. Each P_{i,j} combines P_{i+1,j} and P_{i,j-1}, both on one fewer node. | confirmed |
| 14 | 31 | "Adding each node refines the polynomial." | True for nodes 2-4 (max error 2.0 → 0.899 → 1.887 [worse on the plot window] → 0.0085). False for node 5: the curve is unchanged. | wrong (→ F2) |
| 15 | 31 | "By degree 4 (using all 5 nodes) the interpolant closely matches $\cos(x)$ on the whole interval." | Max error 0.008068 on [0,π], 0.008519 on [−0.1, π+0.1]. Visually indistinguishable in frame 5. True in itself, but the same fit is already reached at degree 3. | confirmed as stated; misleading in context (→ F2) |
| 16 | 33 | "[Julia source](nevilleaa.jl)" | File exists. Manifest says it produces nevilleaa.gif. | confirmed |
| 17 | 35 | Embed `nevilleaa.gif` | Committed GIF byte-identical to the script's output (manifest). | confirmed |
| 18 | 35 | Alt text: "building successive polynomial interpolants of cos(x) from degree 0 constant to degree 4 at 5 nodes at 0, pi/4, pi/2, 3pi/4, pi" | Frame 1 is the constant y=1. Nodes are as stated. The "degree 4" end state is a cubic (F2). | confirmed except the degree-4 wording (→ F2) |
| 19 | 27 | "Julia source scripts that generated these animations are linked under each case." | One case, one link. | confirmed |

## Implementation checks

### nevilleaa.jl
- **Method:** Neville's scheme. `neville_table` (lines 12-26) fills P[i,i]=y_i, then the diagonals len = 2..n with P[i,j] = ((xq−x_i)P[i+1,j] − (xq−x_j)P[i,j−1])/(x_j−x_i). This combines approximants on consecutive overlapping node sets, which is Neville, not Aitken. Aitken's scheme (fixed leading nodes) is not implemented anywhere, and the page does not claim the animation shows it, apart from the inaccurate equivalence statement in F1. `interp_degree` uses the first deg+1 nodes and returns P[1,deg+1] = P_{0,deg}.
- **Numbers:** These are the script's values (`reviewer/inst.jl`) beside my independent values (`reviewer/indep.py`, mpmath 40 digits).
  - Full Neville tableau at x = 1, script: row 1 = 1, 0.6270767714219434, 0.5550244478486578, 0.5375695213543210, 0.5375695213543210; row 2 = 0.7071067811865476, 0.5138972462159890, 0.5138972462159890, 0.5375695213543210; row 3 = 1e-16, 0.5138972462159890, 0.7738040817504608; row 4 = −0.7071067811865475, −0.2013503533242466; row 5 = −1.
  - Independent tableau at x = 1: 1, 0.627076771422, 0.555024447849, 0.537569521354, 0.537569521354 / 0.707106781187, 0.513897246216, 0.513897246216, 0.537569521354 / 0, 0.513897246216, 0.77380408175 / −0.707106781187, −0.201350353324 / −1. All entries agree.
  - Final value at x = 1: script 0.5375695213543210, exact Lagrange 0.537569521354321.
  - Tableaux at x = 2.5, −0.1 and π+0.1 were also printed by inst.jl (final values −0.80392948609490, 0.98648542530062, −0.98648542530062). These are consistent with the exact polynomial, which the grid comparison below covers.
  - All 2500 plotted values (5 degrees × 500 points) compared with the exact sympy Lagrange interpolant of the same nodes: max |diff| is 0, 4.1e-16, 7.8e-16, 7.2e-16 and 4.4e-16 for degrees 0-4.
  - Nodal reproduction: each exact interpolant reproduces cos at its nodes (sympy residuals exactly 0).
  - Exact degrees: 0, 1, 2, 3, 3. P_{0,4} ≡ P_{0,3} (F2).
  - Max |P−cos| on the plot window: 2.0, 0.8988, 1.887, 0.008519, 0.008519. On [0,π]: 2.0, 0.8988, 1.657, 0.008068, 0.008068.
- **Reference values:** The reference curve is `cos` itself (line 54) on the same grid. Node values are cos at the nodes. Nothing here needs independent verification beyond that.
- **Picture:** I viewed the contact sheet and frames 001, 004 and 005 at full size.
  - The blue curve is cos and the red dashed curve is P_{0,deg}. The black dots are exactly the nodes used for that frame: 1, 2, 3, 4, 5 dots.
  - Frame 2 is the line through (0,1) and (π/4, 0.707), ending near −0.21 at x = π+0.1, which matches the computed −0.2089.
  - Frame 3's parabola leaves the bottom of the window (ylims −1.4) near x ≈ 2.5, because its computed minimum is −2.88. This is just the axis limit. The curve is visibly diverging, so a viewer would not be misled.
  - Frames 4 and 5 show the identical red curve (F2).
  - The titles read "degree d (d+1 node(s))", consistent with the code.
  - The legend shows the literal text `P_{0,j}(x)`, because GR does not render the braces as a subscript. It is cosmetic, still readable, and not counted as a finding.
  - Frame count is 5 and fps is 1.

## Evidence

The reviewer's and checker's computation scripts are copied to [`evidence/aitkens-and-nevilles-interpolation/`](evidence/aitkens-and-nevilles-interpolation/) (`reviewer/` and `verify/`). They were run from a scratch directory; paths inside them point at that scratch area and will need adjusting to re-run.
