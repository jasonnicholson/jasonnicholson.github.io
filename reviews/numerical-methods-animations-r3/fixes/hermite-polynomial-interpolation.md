# Fix record: hermite-polynomial-interpolation

Scratch folder (evidence, re-runnable): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r3fix/hermite-polynomial-interpolation/fix/`
(`checks.py`: independent sympy/scipy checks; `bb_instr.jl`: instrumented copy of the new Case 2 script; `frames_bb/`: frames of the new GIF; `old_aa.gif`, `old_bb.gif`: the GIFs before this fix.)

## Findings

### F1 — Minor — fixed
- Reproduced: `/usr/bin/python3 -I checks.py` (scipy `CubicHermiteSpline` on the Case 1 data, n = 4). At the interior nodes the one-sided first derivatives agree and equal cos xᵢ (π/2: 0 / 0; π: −1.00000000 / −1.00000000; 3π/2: 0 / 0), so the piecewise interpolant is C¹. The second derivative jumps at x = π (−0.114771 → +0.114771), so it is not C²; at π/2 and 3π/2 it is continuous (∓1.158469 both sides). An ordinary (Lagrange) interpolating polynomial is a single polynomial, hence C^∞, so "giving a smoother fit" is wrong as a comparison with ordinary interpolation. The first half of the sentence (slopes are matched) is right.
- Change: `index.qmd` Animations intro: "Unlike ordinary polynomial interpolation, Hermite interpolation matches the slope at each node, giving a smoother fit." → "Unlike ordinary (Lagrange) interpolation, which uses only function values, Hermite interpolation also matches the slope at each node." The review's suggested consequence clause ("follows the function's shape more closely between nodes") was not added: it is a comparative claim that would need its own check, and Case 2 now has no underlying function to compare against.
- Check: the new sentence states only definitions (Lagrange uses values; Hermite adds slopes) plus the slope matching confirmed above and by the r3 review (D1, D5, B4).

### F2 — Minor — fixed (Case 2 switched to Mathews' Example 1, per R3-B / R2-A)
- Reproduced: read `n2003/HermitePolyMod.html` and `Links/HermitePolyMod_lnk_2.html` as text; viewed gr_18 (data p(1)=2, p′(1)=1, p(3)=1, p′(3)=2), gr_28 (solved coefficients a=1, b=−23/4, c=19/2, d=−11/4), gr_30 (plot code: interval [1,3], red endpoint dots), gr_31 (graph), gr_32 (printed y = −11/4 + 19x/2 − 23x²/4 + x³). Case 2 on the page used eˣ on [0,1] instead. Independent check (`checks.py`): the Hermite-basis form with h = 2 and weights (y₀, h y₀′, y₁, h y₁′) = (2, 2, 1, 4) gives x³ − 23x²/4 + 19x/2 − 11/4; a direct sympy solve of the four conditions on a general cubic gives {A: −11/4, B: 19/2, C: −23/4, D: 1}; the two agree (`p == Mathews: True`). Critical points: max 2.098047 at x = 1.204666, min 0.654268 at x = 2.628667, consistent with gr_31.
- Decision: R3-B applies R2-A to fidelity findings; the departure is in the function/interval/data of an existing case (Case 2 is the subject of Example 1), so "follow Mathews" applies. Following Mathews does not make anything wrong.
- Change:
  - `hermitepolybb.jl`: data a, b = 1, 3; y₀, y₁ = 2, 1; y₀′, y₁′ = 1, 2 (h = 2); eˣ reference curve removed (Example 1 has no f); short dotted tangent segments of the prescribed slopes added at both endpoints (half-width 0.25 in x), as in Mathews' background figure gr_6; x-limits (0.7, 3.3) so both segments show in full; y-limits unchanged (−0.2, 3.0); legend moved to top right (the curve occupies the top left); legend labels "prescribed slopes y₀' = 1, y₁' = 2" and "endpoints (1, 2), (3, 1)"; header comments updated. The basis functions, the weighted terms and the four running-sum stages are unchanged.
  - `index.qmd`: Case 2 heading, Behavior paragraph and alt text rewritten for the new data (see ledger); old closing paragraph removed and the "not animated here" sentence rewritten in the intro (R3-D item below).
- Check: instrumented copy `julia bb_instr.jl` (the script's own arrays): S1: S(1)=2.0, S(3)=0.0, right-end FD slope −0.0075; S2: S(1)=2.0, S(3)=0.0, right-end FD slope −0.01, max 2.10699; S3: S(1)=2.0, S(3)=1.0, max 2.1574; S4: S(1)=2.0, S(3)=1.0, FD end slopes 0.9862 / 1.9837 (step 2/399), min 0.65427, max 2.09805 at x ≈ 1.206; weights (2.0, 2.0, 1.0, 4.0). Sympy exact (`checks.py`): S1(3)=0, S1′(3)=0; S2(3)=0, S2′(3)=0; S4(1)=2, S4′(1)=1, S4(3)=1, S4′(3)=2. All partial sums lie in [0, 2.157407] ⊂ y-limits.

### R3-D — placement of the "not animated here" sentence — done
- The sentence (previously after the Case 2 embed) now sits in the Animations intro, after "Julia source scripts … linked under each case." and before Case 1. Its content changed because of F2 (Example 1 is now animated as Case 2).
- List checked against every example of the module: `grep -n -i -E 'Example|Exploration' HermitePolyMod.html` → Examples 1, 2, 3 only, no Explorations. Example 2 (gr_38): S₁(1)=2, S₁′(1)=1, S₁(2)=1, S₁(2)=S₂(2), S₁′(2)=S₂′(2), S₁″(2)=S₂″(2), S₂(3)=1, S₂′(3)=2 — a two-piece clamped cubic spline through the knots (1,2), (2,1), (3,1). Example 3 (gr_77): same knots with S₁″(1)=0, S₂″(3)=0 — a natural cubic spline. Neither is animated on the page; Example 1 is (Case 2). Other module items (background, Old Lab Project, REU links, notebook download) are not examples.

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd intro | "Unlike ordinary (Lagrange) interpolation, which uses only function values, Hermite interpolation also matches the slope at each node." | Definition; slope match: `checks.py` → p′ left/right = cos xᵢ at all interior nodes (n = 4) | yes |
| index.qmd intro | "Mathews' Hermite polynomial module has no animation." | No Hermite entry in `a2001/Animations/` (`find -iname '*herm*'`, `grep -ril hermite` → nothing); module images scanned for multiple graphic-control blocks / NETSCAPE loop → none animated. (The program page's `constr00/01.gif` are animated 288×40 / 108×70 "under construction" banners, not math animations.) | yes |
| index.qmd intro | "Case 1, piecewise interpolation of $\sin x$ on $[0, 2\pi]$, is this site's own example" | `hermitepolyaa.jl` uses sin on [0, 2π]; module has no such example (Examples 1–3 read above) | yes |
| index.qmd intro | "Case 2 uses the endpoint data of the module's Example 1." | gr_18 data = script data (a=1, b=3, 2, 1, 1, 2) | yes |
| index.qmd intro | "The module's Examples 2 and 3, a clamped and a natural cubic spline through given knots, are not animated here." | gr_38 / gr_77 conditions above; page has only Cases 1–2 | yes |
| Case 2 heading | "Hermite basis functions building the cubic with $p(1)=2$, $p'(1)=1$, $p(3)=1$, $p'(3)=2$" | gr_18; script data; sympy S4 values/slopes 2, 1, 1, 2 | yes |
| Case 2 Behavior | "takes the prescribed values and slopes at both endpoints" | sympy S4(1)=2, S4′(1)=1, S4(3)=1, S4′(3)=2 | yes |
| Case 2 Behavior | "$h = 2$", "$h y_0' = 2$", "$h y_1' = 4$" | `checks.py` weights [2, 2, 1, 4]; `bb_instr.jl` → (2.0, 2.0, 1.0, 4.0) | yes |
| Case 2 Behavior | "$H(x) = x^3 - \tfrac{23}{4}x^2 + \tfrac{19}{2}x - \tfrac{11}{4}$, the cubic of Mathews' solution" | `checks.py` S4 expansion; direct solve; `p == Mathews: True`; gr_28/gr_32 | yes |
| Case 2 Behavior | "with the prescribed tangent lines as short dotted segments" | script: `tan0_y = y0 + dy0*(x−a)`, `tan1_y = y1 + dy1*(x−b)`, dotted gray; visible in all 4 frames | yes |
| Case 2 Behavior | "the first two partial sums fall to 0 with zero slope at $x = 3$, because $H_{00}$ and $H_{10}$ have zero value and zero slope there" | sympy S1(3)=S1′(3)=S2(3)=S2′(3)=0; H₀₀, H₁₀ and their t-derivatives vanish at t = 1 (x = 3); script FD −0.0075, −0.01 | yes |
| Case 2 alt text | "…for the endpoint data p(1)=2, p'(1)=1, p(3)=1, p'(3)=2, adding one term per frame until it forms the complete cubic Hermite polynomial, which meets the dotted tangent segments at both endpoints" | 4 frames, one term each (frame titles); frame 4: orange curve tangent to both dotted segments | yes |
| GIF legend | "prescribed slopes y₀' = 1, y₁' = 2"; "endpoints (1, 2), (3, 1)" | script data; readable in full-size frames | yes |
| GIF titles | unchanged ("Hermite basis: y₀ · H₀₀(t)" … "+ h·y₁' · H₁₁(t) = H(x)") | frames 1–4 | yes |

## Scripts and GIFs
- `hermitepolybb.jl` changed; `hermitepolybb.gif` regenerated (`julia hermitepolybb.jl`, 4 frames).
- `hermitepolyaa.jl` unchanged; re-run as a control → `hermitepolyaa.gif` byte-identical to the committed file (`cmp` with `old_aa.gif`).
- Frames viewed at full size (all 4, `frames_bb/frame_001..004.png`): frame 1 blue y₀H₀₀ from (1,2) with zero slope to 0 at x = 3 with zero slope; frame 2 red sum leaves (1,2) along the left tangent, peaks ≈ 2.1 near x ≈ 1.2, ends at 0 flat; frame 3 green sum ends at (3,1) flat (crossing the right tangent segment); frame 4 orange cubic tangent to both segments, dips to ≈ 0.65 near x ≈ 2.6 — same shape as Mathews' gr_31. Legend (top right) does not cover the curve; titles legible; nothing clipped.
- `git status --short -- pages/numerical-methods/hermite-polynomial-interpolation`:
  ```
   M pages/numerical-methods/hermite-polynomial-interpolation/hermitepolybb.gif
   M pages/numerical-methods/hermite-polynomial-interpolation/hermitepolybb.jl
   M pages/numerical-methods/hermite-polynomial-interpolation/index.qmd
  ```

## Legacy archive
- Consulted: `n2003/HermitePolyMod.html`, `hermitepoly/HermitePolyMod/Links/HermitePolyMod_lnk_1..4.html`, images gr_6, gr_18, gr_28, gr_30, gr_31, gr_32, gr_38, gr_77; `HermitePolyProg.html`; `a2001/Animations/` (no Hermite entry; Interpolation has Chebyshev, FourierSeries, Lagrange, Pade, Series only).
- The module has no animation. Example 1 is the clamped cubic p(1)=2, p′(1)=1, p(3)=1, p′(3)=2 with answer x³ − 23x²/4 + 19x/2 − 11/4 (computed independently and matching). Examples 2 and 3 are two-piece clamped and natural cubic splines on the knots (1,2), (2,1), (3,1). The solution images for Example 3 (gr_78–gr_109 referenced from lnk_4) are not in the archive; the statement image gr_77 is.
- The fixed page follows Mathews for Case 2 (same data, same answer). Mathews' plot used x-range [0, 3]; the page's GIF uses [0.7, 3.3] to show the tangent segments around both endpoints — a framing choice only. Case 1 (piecewise Hermite for sin) remains the site's own example, now stated as such.

## Notes
- The Animations intro still says the animations interpolate "at the endpoint nodes"; for Case 1 the nodes include interior mesh points. No finding names it, so it was left as is.
- Case 2 no longer has an underlying f, so the Description's general formula (with y₀, y₀′, y₁, y₁′) is unaffected; Case 1 still illustrates approximation error.
- Nothing outside the page folder and this record was touched.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: "giving a smoother fit" is gone. The replacement reads "Unlike ordinary (Lagrange) interpolation, which uses only function values, Hermite interpolation also matches the slope at each node." Both halves are true. Lagrange interpolation is determined by node values alone. Hermite matches slopes: for Case 2, sympy gives H'(1) = 1 and H'(3) = 2, and Case 1's C¹ slope matching was confirmed in the original finding. The new sentence makes no smoothness claim, so it no longer conflicts with the Description's "C¹" statement, which is unchanged.

### F2 — resolved
- Evidence: Case 2 now uses Mathews' Example 1 data (a = 1, b = 3, y₀ = 2, y₀' = 1, y₁ = 1, y₁' = 2). This follows the finding's first option and R2-A/R3-B.
- Script: the eˣ curve is gone, and short dotted tangent segments are drawn instead.
- Independent sympy check (`check/sym.py`):
  - The Hermite-basis sum with h = 2 gives x³ − 23x²/4 + 19x/2 − 11/4.
  - Solving the general cubic's 4×4 system directly gives the same polynomial.
  - That polynomial matches Mathews' printed solution (archive gr_32: −11/4 + 19x/2 − 23x²/4 + x³).
  - It satisfies p(1) = 2, p'(1) = 1, p(3) = 1 and p'(3) = 2.
  - Its critical points are (1.2047, 2.0980) and (2.6287, 0.6543), which agree with Mathews' graph gr_31.
- The last GIF frame shows this curve. It peaks near x ≈ 1.2 at y ≈ 2.1, dips to about 0.65 near x ≈ 2.6, and meets both tangent segments tangentially.
- The h-scaling is now visible: without h the slope at x = 1 would be 1/2, not 1.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| Animations intro ¶1 | "Unlike ordinary (Lagrange) interpolation, which uses only function values, Hermite interpolation also matches the slope at each node." | Definition. sympy slopes match at both nodes | True |
| Animations intro ¶3 (new placement, R3-D) | "Mathews' Hermite polynomial module has no animation." | No Hermite entry under `a2001/Animations` (`find -iname '*herm*'` and `grep -ril hermite` both empty). HermitePolyMod.html has no animation link | True |
| same | "Case 1, piecewise interpolation of sin x on [0, 2π], is this site's own example" | hermitepolyaa.jl: f = sin, nodes on range(0, 2π). No such example in the module | True |
| same | "Case 2 uses the endpoint data of the module's Example 1" | gr_18: p(1)=2, p'(1)=1, p(3)=1, p'(3)=2. Same as the script | True |
| same | "The module's Examples 2 and 3, a clamped and a natural cubic spline through given knots, are not animated here." | The module has exactly three examples (Examples 1–3). Ex 2 (gr_38) is a clamped spline with S₁(1)=2, S₁'(1)=1, S(2)=1, S(3)=1, S₂'(3)=2. Ex 3 (gr_77) is a natural spline with S''(1)=S''(3)=0. The Prog and Proof pages are "under construction" stubs with no examples. The module's other content is the theorem, the remark on higher-degree generalization and the old lab project link; none of these is an example. Every example is accounted for | True |
| same | Placement | After "Julia source scripts…" and before Case 1, as on Improved Newton, Least-Squares Polynomials, Rational and Richardson. The old trailing paragraph after Case 2 is removed | Conforms to R3-D |
| Case 2 heading | "building the cubic with p(1)=2, p'(1)=1, p(3)=1, p'(3)=2" | gr_18 | True |
| Case 2 Behavior | "takes the prescribed values and slopes at both endpoints" | sympy [2, 1, 1, 2] | True |
| same | "h = 2", "h y₀' = 2", "h y₁' = 4" | 3 − 1 = 2; 2·1; 2·2 | True |
| same | "H(x) = x³ − 23/4 x² + 19/2 x − 11/4, the cubic of Mathews' solution" | sympy two ways; gr_32 | True |
| same | "with the prescribed tangent lines as short dotted segments" | Script: segments y₀ + y₀'(x − a) on [0.75, 1.25] and y₁ + y₁'(x − b) on [2.75, 3.25]. Frames show them with the correct slopes | True |
| same | "first two partial sums fall to 0 with zero slope at x = 3, because H₀₀ and H₁₀ have zero value and zero slope there" | sympy: S₁(3)=0, S₁'(3)=0; S₂(3)=0, S₂'(3)=0. H₀₀'(1) = H₁₀'(1) = 0 in t | True |
| Case 2 alt text | Data, one term per frame, complete cubic "meets the dotted tangent segments at both endpoints" | Frames 1–4 viewed | True |
| Script header/comments | Example 1 data, "so h = 2". "no underlying f is given" | gr_18 gives conditions only | True |
| Script comment | x-limits a little beyond [1, 3]; lower y-limit below 0 because the first two partial sums fall to 0 at x = 3 | xlims (0.7, 3.3) contain the segments [0.75, 3.25]. Partial-sum ranges [0, 2], [0, 2.107], [1, 2.157] and [0.654, 2.098], plus segment y in [0.5, 2.25], all lie inside ylims (−0.2, 3) | True |
| GIF legend | "prescribed slopes y₀' = 1, y₁' = 2", "endpoints (1, 2), (3, 1)" | Data | True |
| GIF titles | "y₀ · H₀₀(t)", "+ h·y₀' · H₁₀(t)", "+ y₁ · H₀₁(t)", "+ h·y₁' · H₁₁(t) = H(x)" | Unchanged, and they match the terms | True |

### New problems
None. This rests on the following checks:
- Every changed sentence, number, label and comment was checked by sympy or against the archive images gr_18, gr_31, gr_32, gr_38 and gr_77.
- All 4 frames were viewed at full size. Labels are legible, the legend clears the curves, and nothing is clipped.
- The last frame matches Mathews' graph.
- Case 1 text and GIF are untouched.

(Cosmetic only, not a finding: the Case 2 heading calls the polynomial p, while the Behavior text calls it H(x).)

### Reproducibility and conventions
- I ran hermitepolybb.jl from the scratch copy `check/run/`. Its output is byte-identical to the committed GIF: sha256 4e09cd0a…f8a7 for both, matching the LFS pointer in the diff. The decoded frame MD5s are identical too. The GIF is real GIF data (700×500, 4 frames).
- I extracted the pre-fix GIF with `git show | git lfs smudge` (read-only) and compared it. The only differences are the intended ones: the data, the tangent segments, the legend position and the x-limits.
- Conventions hold:
  - the Description comes before the Animations section;
  - each case has a source link and an embed;
  - the alt texts are descriptive;
  - the page has no code blocks;
  - the GIF path uses `@__DIR__`.
- The diff touches only files in the page folder: hermitepolybb.jl, hermitepolybb.gif and index.qmd. The other modified pages in the working tree and the untracked fix records belong to the parallel round-3 run, not to this page's diff.

**Final status:** committed
