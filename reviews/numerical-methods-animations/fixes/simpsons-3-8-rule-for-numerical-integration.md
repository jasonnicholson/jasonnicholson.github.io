# Fix record: simpsons-3-8-rule-for-numerical-integration

Scratch folder (all evidence, re-runnable):
`/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/work/simpsons-3-8-rule-for-numerical-integration/fix/`
(below written as `$FIX`). Scripts are in `$FIX/scripts/`, outputs in `$FIX/*.out`.

## Findings

### F1 — Error — fixed

- **Reproduced:** `cd $FIX/scripts && /usr/bin/python3 -I order.py` (output `$FIX/order.out`). This is independent of the repo script: mpmath at 40 digits, composite 3/8 sums at exact nodes `i*2/n`.
  - Reference integral $I = 2.01627971961709632788727442192$. Two mpmath methods agree: substitution $x=t^3$ then tanh-sinh, and direct tanh-sinh on 80 panels, differing by $-4.6\times10^{-41}$. scipy `quad` gives 2.016279719617097.
  - sympy: $f = 1 + 8x^{2/3} + O(x)$ and $f' = \tfrac{16}{3}x^{-1/3} + O(1)$ at $0$.
  - Error ratios $E(n/2)/E(n)$ under doubling $n$ ($n=3\cdot2^k$), with $p=\log_2$ of the ratio:

    | n | E(n) | ratio | p |
    |---|---|---|---|
    | 12 | $-3.97\times10^{-2}$ | 5.695 | 2.510 |
    | 24 | $-7.88\times10^{-3}$ | 5.030 | 2.331 |
    | 48 | $-2.22\times10^{-3}$ | 3.550 | 1.828 |
    | 96 | $-6.83\times10^{-4}$ | 3.252 | 1.702 |
    | 192 | $-2.14\times10^{-4}$ | 3.195 | 1.676 |
    | 384 | $-6.71\times10^{-5}$ | 3.182 | 1.670 |
    | 768 | $-2.11\times10^{-5}$ | 3.178 | 1.668 |
    | 3072 | $-2.10\times10^{-6}$ | 3.1755 | 1.667 |
    | 12288 | $-2.08\times10^{-7}$ | 3.17497 | 1.6667 |

    For comparison, $2^{5/3} = 3.1748$. The ratios approach it from above. At coarse $n$ (12, 24) they are larger, but this is the pre-asymptotic range, still far from 16.
  - In-animation halving pairs: 30→60 ratio 3.396 (p 1.764), 36→72 3.321, 54→108 3.236, 60→120 3.2238 (p 1.689). The pair 3→6 has ratio 0.585, because the error grows.
  - Least-squares slope of $\log|E|$ against $\log h$ over the animation's frames: 1.819 (n=3..120), 1.741 (n=24..120).
  - Error on the frames: all 23 approximations are below $I$. $|E|$ grows from n=3 (−0.132066) to n=6 (−0.225809), then decreases strictly through n=120. At n=120 the approximation is 2.01581041086, with $E=-4.69309\times10^{-4}$.
  - Control: the same sums on the smooth $e^x$ over $[0,2]$ give ratios 15.690, 15.921, 15.980, 15.995, 15.9988, so the routine is fourth order on a smooth $f$.
  - The finding holds as corrected by the independent check: fourth order and "rapidly" are false for this integrand, and the measured order tends to $5/3$.
  - One small slip in the review's evidence lines: it attaches ratio 3.25241 to n=48, but that ratio belongs to the 48→96 step (row n=96 above). This does not affect the finding.
- **Change:** text only, in `index.qmd`. The animation is right (all labels verified, see below), so per D1/D7 the script and GIF are unchanged.
  - Line 17: "The method is fourth-order accurate for smooth integrands, $S^{3/8}_n - I = O(h^4)$, and can be viewed …" → "For smooth $f$ (four times continuously differentiable on $[a,b]$), the global truncation error is fourth order: $S^{3/8}_n - I = O(h^4)$. The method can be viewed …"
  - Line 28 (Behavior): "The approximation converges rapidly with fourth-order global error." is replaced by four sentences:
    - every approximation shown lies below $I\approx 2.016280$;
    - the error grows from 4 to 7 points and then shrinks at every later frame, ending at 2.01581 (121 points), about 0.00047 low;
    - the D1 cause sentence, verbatim;
    - the measured $O(h^{5/3})$ rate with the halving factor 3.22 (60→120).
- **Check:** every number in the new text was recomputed. See the ledger. `git diff` shows only lines 17 and 28 of `index.qmd` changed.

## Ledger of changed text

Commands run from `$FIX/scripts`:

- `/usr/bin/python3 -I order.py` writes `$FIX/order.out`.
- `julia script_values.jl` writes `$FIX/script_values.out`. It is the repo script's own `f` and `simpson38_sum` with the plotting removed, printing the label value for each frame.

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd:17 | "For smooth $f$ (four times continuously differentiable on $[a,b]$), the global truncation error is fourth order: $S^{3/8}_n - I = O(h^4)$" | Hypothesis of Mathews' corollary: archive image `Simpson38RuleMod_gr_40.gif` reads "f(x) ∈ C⁴[a,b]". Numerical control in `order.py` on $e^x$: ratios 15.690 → 15.9988 ≈ 16 = 2⁴. | yes |
| index.qmd:17 | "The method can be viewed as a higher-order refinement …" | Unchanged wording, only split into its own sentence. | n/a |
| index.qmd:28 | "Every approximation shown lies below the true integral" | `order.py`: "signs of E over frames: -----------------------" (all 23 frames with an approximation; the first frame shows only the curve). | yes |
| index.qmd:28 | $\int_0^2 f\,dx \approx 2.016280$ | `order.py` → I = 2.01627971961709632788727442192 (two mpmath methods agree to $10^{-40}$; scipy 2.016279719617097) | yes |
| index.qmd:28 | "The error grows from 4 to 7 sample points" | `order.py`: n=3 (4 points) E = −0.132066; n=6 (7 points) E = −0.225809. "frame pairs where \|E\| does not decrease: [(3, 6)]" | yes |
| index.qmd:28 | "then shrinks at every later frame" | `order.py`: "\|E\| strictly decreasing from n = 6 to 120" | yes |
| index.qmd:28 | "the last frame (121 sample points) gives 2.01581" | `order.py`: n=120 → 2.01581041086. `script_values.jl`: `120 121 2.01581`. Frame `$FIX/orig_frames/frame_024.png` reads "Sample Points = 121 / Approximation = 2.01581". | yes |
| index.qmd:28 | "about 0.00047 low" | `order.py`: E(120) = −0.000469309 | yes |
| index.qmd:28 | "The $x^{2/3}$ term makes $f'$ unbounded at $x=0$ ($f'(x)\approx\tfrac{16}{3}x^{-1/3}$ near $0$)" | `order.py` (sympy): f' series at 0 = `16/(3*x**(1/3)) + O(1)` | yes |
| index.qmd:28 | "so the textbook error order, which assumes smooth $f$, does not hold for this integrand" | $f\notin C^1[0,2]$ (previous row), so not $C^4$. Measured p → 1.6667 ≠ 4 (doubling table). | yes |
| index.qmd:28 | "measured error shrinks like $O(h^{5/3})$ rather than $O(h^4)$" | `order.py`: p = 1.828 (n=48), 1.702, 1.676, 1.670, 1.668, 1.667, 1.667, 1.6668, 1.6667 (n=12288). | yes |
| index.qmd:28 | "halving $h$ divides it by about 3.22 (from 60 to 120 subintervals)" | `order.py` pairs: `60 120 3.2238 p= 1.689`. Both n=60 and n=120 are frames of the animation. | yes |
| index.qmd:28 | "tending to $2^{5/3}\approx 3.17$, instead of 16" | `order.py`: 2^(5/3) = 3.1748. The doubling ratio is 3.17497 at n=12288 and decreasing toward it. The smooth control gives 15.9988 → 16. | yes |

The alt text, the case heading and the GIF title are unchanged. They make no rate or order claim. The alt text says "each frame updates piecewise cubic panels and the global approximation", which the frames confirm.

## Scripts and GIFs

- No script was changed and no GIF was regenerated: the animation is correct.
  - All 23 labelled values were reproduced. `script_values.out` matches `order.py`'s `round(S,6)` column for every n.
  - "Sample Points = n+1" is correct.
  - Labels use `round(…; digits=6)`, so trailing zeros are dropped (for example 1.79047 and 2.01581). These are still correct values, not false ones.
- Frames of the committed GIF were extracted to `$FIX/orig_frames/` (24 frames).
  - Viewed the contact sheet (every second frame: the curve-only first frame, then 7, 13, 19, 25, 31, 37, 49, 61, 73, 91, 109 points) and the last frame at full size.
  - The cubic panels interpolate $f$ at the four nodes of each block of three subintervals. In the n=6 frame the cubic visibly misses the peak near $x\approx0.08$, which is consistent with that frame's larger error.
  - The labels match the computed values.
- `git status --short -- pages/numerical-methods/simpsons-3-8-rule-for-numerical-integration` →
  ` M pages/numerical-methods/simpsons-3-8-rule-for-numerical-integration/index.qmd` (only).

## Legacy archive

Consulted.

- `n2003/Simpson38RuleMod.html`:
  - the corollary hypothesis is $f\in C^4[a,b]$ (`Simpson38RuleMod_gr_40.gif`);
  - Example 11 (`Links/Simpson38RuleMod_lnk_12.html`, code image `gr_185.gif`) uses $f(x)=1+e^{-x}\sin(8x^{2/3})$ on $[0,2]$ with $m = 1,2,3,4,5,6,8,10,\dots,30,35,40$, i.e. $n=3m$ up to 120.
- The animation `a2001/Animations/Quadrature/Simpson38/Simpsonaa.gif` **is present** in this archive. Its frames were extracted to `$FIX/legacy_frames/` (24 frames).
  - It uses the same integrand.
  - It shows Sample Points 4, 10, 16, 25, 37, 49, 61, 73, 85, 106, 121 among others.
  - Its labels agree with independent values (`$FIX/scripts/legacy_values.py` → `$FIX/legacy_values.out`): 1.884214, 1.927234, 1.994094, 2.008397, 2.012595, 2.014059, 2.014767, 2.015170, 2.015425 (85 points, not one of our frames), 2.015692 (106 points, not one of our frames), and 2.015810 (121 points).
- The repo script's n sequence differs slightly from Mathews' (it adds 21, 27, 33, 81, 99, 108 and omits 78, 84, 105). This is harmless, and the endpoint n=120 is the same.
- The module's textbook $O(h^4)$ statement assumes $C^4$ and does not apply to the animated integrand. The page now says so and gives the measured order, keeping the archive's integrand per D1.

## Notes

- **Legacy note on the page (index.qmd:34)** says "the referenced `Simpsonaa.gif` is missing in the snapshot". In the archive available now, `a2001/Animations/Quadrature/Simpson38/Simpsonaa.gif` exists, and our reconstruction matches its integrand and values. No finding names this line, and the brief treats legacy-inventory notes as out of scope, so I left it unchanged. Jason may want to update or drop that note.
- The page has no other convention gaps named by findings. Nothing outside the page folder was touched.

### Director note

Not changed (not a finding): the legacy note at index.qmd:34 says the archive GIF is missing, but a2001/.../Simpson38/Simpsonaa.gif exists and its values match the page's. Flagged for Jason.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: The false sentence at index.qmd:28 ("converges rapidly with fourth-order global error") is gone. Its replacement states the $x^{2/3}$ singularity, the unbounded $f'$, the measured $O(h^{5/3})$ rate and the concrete error figures. Every one of these checks out against an independent mpmath computation at 40 digits (`check/ref.py`). In that script the integral is computed two ways: by direct adaptive quadrature and by the substitution $x=t^3$. Both give the same value. The 3/8 sums were written independently of the Julia script.
- Line 17 now limits the $O(h^4)$ claim to $f \in C^4[a,b]$, which is the correct scope.
- The script and GIF were not changed, and they did not need to be. F1 was a text-only finding, and the GIF shows the right quantities. Its displayed approximations match my sums: 1.884214 at 4 points, 1.79047 at 7, 2.011968 at 34 and 2.01581 at 121.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd:17 | "For smooth $f$ (four times continuously differentiable on $[a,b]$), the global truncation error is fourth order: $O(h^4)$" | Standard sufficient condition for the composite 3/8 error term $-\frac{(b-a)}{80}h^4 f^{(4)}(\xi)$. Earlier control in the findings: the rule gives ratios approaching 16 on $e^x$. | True |
| index.qmd:17 | "higher-order refinement of trapezoidal geometry using piecewise cubic panels" | Unchanged in meaning (only reflowed) | OK |
| index.qmd:28 | "Every approximation shown lies below the true integral" | All 23 errors for n=3..120 are negative. The smallest in magnitude is −4.69e−4. Frame 0 shows no approximation. | True |
| index.qmd:28 | $\int_0^2 f\,dx \approx 2.016280$ | I = 2.0162797196170963 (two methods agree) | True |
| index.qmd:28 | "error grows from 4 to 7 sample points" | n=3: −0.132066; n=6: −0.225809 | True |
| index.qmd:28 | "then shrinks at every later frame" | \|e\| decreases monotonically at every step over n = 9, 12, …, 120 (checked all 21 later frames) | True |
| index.qmd:28 | "last frame (121 sample points) gives 2.01581" | S(120) = 2.01581041086. The frame displays "2.01581". | True |
| index.qmd:28 | "about 0.00047 low" | error = −4.69309e−4 | True |
| index.qmd:28 | "$f'(x)\approx \tfrac{16}{3}x^{-1/3}$ near 0" | $f \approx 1+8x^{2/3}$ near 0, so $f' \approx \tfrac{16}{3}x^{-1/3}$, which is unbounded | True |
| index.qmd:28 | "textbook error order, which assumes smooth $f$, does not hold" | Measured order is 1.667, not 4 | True |
| index.qmd:28 | "shrinks like $O(h^{5/3})$" | Halving-ratio log2 values: 1.676 (n=96), 1.670, 1.668, 1.667, 1.667, 1.6668 (n=3072) | True |
| index.qmd:28 | "halving $h$ divides it by about 3.22 (from 60 to 120 subintervals)" | e(60)/e(120) = 3.22384 | True |
| index.qmd:28 | "tending to $2^{5/3}\approx 3.17$" | 2^{5/3} = 3.1748. The ratios approach it: 3.195, 3.182, 3.178, 3.176, 3.1755, 3.17514 | True |
| index.qmd:28 | "instead of 16" | $2^4 = 16$ is the smooth-case ratio | True |

### New problems
None. This rests on the following:
- Every changed sentence and number was verified independently (see the ledger).
- The GIF and script are unchanged against HEAD, and the regenerated GIF is byte-identical to the committed one.
- I viewed frames 2 (4 pts), 3 (7 pts), 12 (34 pts) and 24 (121 pts) at full size. The labels are legible, and the displayed values match my independent sums. The 7-point frame shows visibly worse panels than the 4-point frame, which agrees with the text's "error grows from 4 to 7 sample points".

### Reproducibility and conventions
- `simpson38aa.jl` was copied to `check/run/` and run with the global Julia environment. Its output `simpson38aa.gif` is byte-identical to the committed GIF (`cmp`). The `git diff HEAD` for the .jl and .gif files is empty, and the GIF has 24 frames.
- In the page folder, only `index.qmd` changed (git status of the page folder).
- Conventions are intact: Description comes before Animations, the case keeps its `[Julia source](simpson38aa.jl)` link and its embed, the alt text is descriptive, and there are no code blocks.
- The fix diff touches only the page folder. Other modified files in the working tree belong to other pages' fixes on this branch, not to this fix.

**Final status:** committed
