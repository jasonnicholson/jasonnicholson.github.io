# Simpson's 3/8 Rule for Numerical Integration — animation review

Page: [`pages/numerical-methods/simpsons-3-8-rule-for-numerical-integration/index.qmd`](../../pages/numerical-methods/simpsons-3-8-rule-for-numerical-integration/index.qmd) · Scripts: `simpson38aa.jl` · GIFs: 1

**Result:** 1 error, 0 misleading, 0 minor.

Errors and misleading findings were each re-checked by an independent subagent given only the allegation (not the reviewer's reasoning). Minor findings were not independently re-checked. Finding IDs (F1, F2, …) are the reviewer's and match the claim ledger below.

## Findings

### F1 — Error — Page match — "fourth-order global error" and "converges rapidly" are false for this integrand; the measured order is 5/3

- **Location:** index.qmd:28, "The approximation converges rapidly with fourth-order global error." (The Description at index.qmd:17 sets this up with "fourth-order accurate for smooth integrands, $S^{3/8}_n - I = O(h^4)$". That sentence is true as stated, but the integrand animated here is not smooth.)
- **Now:** The page says the animated case converges at fourth order and does so rapidly.
- **True:** $f(x)=e^{-x}\sin(8x^{2/3})+1$ has $f(x)\approx 1+8x^{2/3}$ near $x=0$, so $f'(x)\sim \tfrac{16}{3}x^{-1/3}$ is unbounded at the left endpoint. The $x^{2/3}$ singularity limits composite Newton–Cotes error to $O(h^{1+2/3})=O(h^{5/3})$. That is what the measurements show:
  - Halving $h$ divides the error by 3.175 (log2 = 1.667), not 16. At n=3072→6144 the ratio is 3.17514, log2 1.6668, against the theoretical 5/3.
  - Using the animation's own frames: n=60→120 gives an error ratio of 3.22 (log2 1.69), and n=30→60 gives 3.40 (log2 1.76). Fourth order would give 16.
  - At the last frame (n=120, 121 points) the shown approximation is 2.01581. The true value is 2.016279720 (error −4.69e−4), so only three significant digits are correct after 120 subintervals. That is not rapid convergence.
  - The early frames do not converge monotonically. The error grows from −0.132 (n=3) to −0.226 (n=6) before it starts shrinking.
  - Control: the script's own `simpson38_sum` with $f=e^x$ gives ratios 15.69, 15.92, 15.98, 15.995, 15.999 (log2 → 4.000). So the routine is correct, and the reduced rate comes from the integrand.
- **Evidence:** `reviewer/ref.py` (mpmath, 40 digits; independent 3/8 sums and halving ratios; output in `reviewer/ref.out`). `reviewer/exact.jl` (the script's routine on monomials and on exp; output in `reviewer/exact.out`). Key lines:
  - `48 -0.00222053 ratio 3.25241 log2 1.7015`
  - `384 -6.71495e-5 ratio 3.17782 log2 1.668`
  - `3072 -2.09504e-6 ratio 3.17514 log2 1.6668`
  - `120 121 2.01581041086 -0.000469309`
  - `exp: n=96 ... ratio=15.999 log2=4.000`
- **Suggested fix:** Replace line 28's second sentence with something like: "Because $f$ behaves like $x^{2/3}$ near $x=0$ (its derivative is unbounded there), the error shrinks only like $h^{5/3}$, not the textbook $h^4$. Halving $h$ cuts the error by about 3.2 rather than 16, and at $n=120$ the approximation 2.01581 still differs from $I\approx 2.016280$ by about $5\times10^{-4}$." Optionally, add a clause to line 17 saying the $O(h^4)$ rate needs $f\in C^4[a,b]$ and that the animated integrand does not satisfy this. The alternative is to switch to a smooth integrand if the page should demonstrate $O(h^4)$.

- **Independent check:** confirmed. Checker: measured order settles at 1.6667 (≈1.5–1.7 over the animation's n=3..120); the same rule gives 4.00 on a smooth integrand.

## Inventory (Phase 1)

Every script was copied to scratch and run with the global Julia environment (Plots 1.41.2, SpecialFunctions 2.9.2); each was also run alone to map scripts to GIFs.

| Script | Ran | Time (s) | GIFs produced |
|---|---|---|---|
| `simpson38aa.jl` | yes | 3.6 | simpson38aa.gif |

Committed GIFs byte-identical to their regenerated output: **1 of 1**. Decoded frames were also compared; all match.

Inventory findings: none (every script runs, every GIF is produced by a script and embedded by the page, every page reference exists, and the section index links the page).

## Claim ledger

| # | index.qmd line | Claim (page's own words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | 12 | "Composite Simpson's 3/8 rule applies cubic interpolation on blocks of three subintervals" | Script lines 40–55 fit a cubic through 4 equally spaced nodes per 3-subinterval block. Each drawn cubic reproduces its nodes (max residual 1.3e−14) and equals an independent Lagrange cubic (max difference 2.0e−14). The sum of the exact cubic-panel areas equals `simpson38_sum` to within 4e−15 for every n (check.out). | confirmed |
| 2 | 12 | "$h=(b-a)/n$ and $n$ divisible by 3" | Script: `dx=(b-a)/n`, and every n in `n_seq` is a multiple of 3 | confirmed |
| 3 | 14 | Composite formula: weights 1, 3 (i not ≡ 0 mod 3), 2 (i ≡ 0 mod 3, 0<i<n), times 3h/8 | Script lines 25–30 implement exactly this. Exact for $x^0..x^3$ (errors ≤ 9e−16). Not exact for $x^4$: error 0.11852 at n=3, which matches the theoretical $3h^5 f^{(4)}/80 = 0.11852$ with h=2/3. | confirmed |
| 4 | 17 | "fourth-order accurate for smooth integrands, $S^{3/8}_n - I = O(h^4)$" | Script's routine on $e^x$: halving ratio → 15.999, log2 4.000 | confirmed (as a statement about smooth integrands; see F1 for its use here) |
| 5 | 17 | "can be viewed as a higher-order refinement of trapezoidal geometry using piecewise cubic panels" | Qualitative framing; the panels are piecewise cubics (claim 1) | confirmed (loose wording, not checkable further) |
| 6 | 21–22 | Diagram over $[0,2]$ for $y=e^{-x}\sin(8x^{2/3})+1$ | Script line 8 `f(x)=exp(-x)*sin(8*x^(2/3))+1`, a,b=0,2. xlims (0,2) in frames. | confirmed |
| 7 | 22 | "Each frame recomputes the approximation across the full interval with a denser partition where $n$ remains a multiple of 3" | n_seq = 3,6,…,36,42,…,72,81,…,108,120, all multiples of 3 and increasing. Last panel ends at 2.000000000000000 for every n. Frame 1 (n=0) shows only the curve, with no approximation. | confirmed |
| 8 | 26 | Case 1 heading: composite 3/8, $f=e^{-x}\sin(8x^{2/3})+1$ on $[0,2]$ | Same as 6 | confirmed |
| 9 | 28 | "Piecewise cubic panels over triplets of subintervals are rebuilt at increasing density" | Frames 2, 3, 4, 24 inspected. Frame 2 shows a single cubic over [0,2]. Frame 4 (n=9) shows 3 panels with joins at 2/3 and 4/3. Panels refine thereafter. | confirmed |
| 10 | 28 | "The approximation converges rapidly" | Error −0.132 (n=3), −0.226 (n=6), …, −4.69e−4 (n=120). Not monotone at the start, and only 3 correct digits at n=120. | wrong (→ F1) |
| 11 | 28 | "with fourth-order global error" | Measured order 5/3 (ratio 3.175 per halving, log2 1.6668). Frames n=60→120: log2 1.69. | wrong (→ F1) |
| 12 | 30 | Link `simpson38aa.jl` is the source | Manifest: the script produces simpson38aa.gif byte-identically | confirmed |
| 13 | 32 | Embed `simpson38aa.gif` | Exists, 24 frames, produced by simpson38aa.jl | confirmed |
| 14 | 32 | Alt text: "over [0,2] with full-interval density refinement: each frame updates piecewise cubic panels and the global approximation" | Frames show the panels and the "Approximation = …" annotation updating each frame (except the curve-only frame 1) | confirmed |

## Implementation checks

### simpson38aa.jl
- **Method:** Standard composite Simpson's 3/8 rule (closed Newton–Cotes, 4 points per panel, weights 3h/8·[1,3,3,1]; shared panel endpoints get weight 2). It is not a neighbouring rule: it is exact through cubics and fails on quartics with exactly the 3/8-rule error constant $-\tfrac{3}{80}h^5 f^{(4)}$ (x^4, n=3: 0.118519 vs 0.118519). Its convergence on a smooth function is fourth order (exp: log2 ratio 3.972, 3.993, 3.998, 4.000, 4.000).
- **Numbers (script's value vs independent mpmath 3/8 sum):** All 23 frames agree to ≥ 11 digits. For example:
  - n=3: 1.884214099419 vs 1.88421409942
  - n=6: 1.790470481305 vs 1.7904704813
  - n=60: 2.014766741569 vs 2.01476674157
  - n=120: 2.015810410864 vs 2.01581041086
  
  The displayed annotations are the script values rounded to 6 decimals. `round` drops trailing zeros, so some frames show 5 decimals (2.01517, 2.01572, 2.01581); this is cosmetic.
- **Reference values:** The script draws no reference integral. I computed it with mpmath at 40 digits in two independent ways: direct `quad` with breakpoints, and after the substitution x=t³ (which removes the singularity). Both give $I = 2.01627971961709632788727442192$; they differ by 5e−41. The page quotes no reference value.
- **Picture:** I inspected the contact sheet and full-size frames 2 (n=3), 4 (n=9) and 24 (n=120).
  - Each red curve is the cubic through the correct four nodes. This was verified numerically for every frame: node residual ≤ 1.3e−14, agreement with an independent Lagrange evaluation ≤ 2e−14, and the integral of the drawn cubics equals the displayed approximation (≤ 4e−15). So the shaded area is exactly the quantity reported.
  - Frame 2's single cubic passes through f(0)=1, f(2/3)≈0.91, f(4/3), f(2)≈1.02, as seen.
  - Frame 4 shows the panel joins at x=2/3 and 4/3.
  - "Sample Points = n+1" is correct.
  - The magenta curve is the stated f.
  - No cubic leaves the y-window [0, 2.1], and no clamping or masking is used.
  - The steep $x^{2/3}$ rise at x=0, which causes the reduced order in F1, is visible in every frame.
  - Frame 1 (n=0) is curve-only by design.
- **Evidence files:** `reviewer/check.jl` (script head with prints, plus panel checks; `check.out`), `reviewer/exact.jl` (monomial exactness and smooth-function order; `exact.out`), `reviewer/ref.py` (mpmath reference, independent sums and halving ratios; `ref.out`).

## Evidence

The reviewer's and checker's computation scripts are copied to [`evidence/simpsons-3-8-rule-for-numerical-integration/`](evidence/simpsons-3-8-rule-for-numerical-integration/) (`reviewer/` and `verify/`). They were run from a scratch directory; paths inside them point at that scratch area and will need adjusting to re-run.
