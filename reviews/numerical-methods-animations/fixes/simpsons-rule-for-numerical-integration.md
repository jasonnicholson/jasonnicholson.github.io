# Fix record: simpsons-rule-for-numerical-integration

Scratch folder (all evidence, re-runnable):
`/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/work/simpsons-rule-for-numerical-integration/fix/`
(below written as `$FIX`). Scripts are in `$FIX/scripts/`, outputs in `$FIX/*.out`.

## Findings

### F1 — Error — fixed

- **Reproduced:** `cd $FIX/scripts && /usr/bin/python3 -I order.py` (output `$FIX/order.out`). It does not use the repo script: mpmath at 40 digits computes composite Simpson sums at the exact nodes `i*2/n`.
  - Reference integral: $I = 2.01627971961709632788727442192$. The substitution $x=t^3$ followed by tanh-sinh and direct tanh-sinh on 80 panels differ by $-4.6\times10^{-41}$. scipy `quad` gives 2.016279719617097.
  - sympy: `series(diff(f), x, 0, 0)` = `16/(3*x**(1/3)) + O(1)`.
  - Error ratios under doubling $n$, $E(n/2)/E(n)$, with $p=\log_2$ of the ratio:

    | n | E(n) | ratio | p |
    |---|---|---|---|
    | 8 | $-7.48\times10^{-2}$ | 5.405 | 2.434 |
    | 16 | $-1.31\times10^{-2}$ | 5.726 | 2.518 |
    | 32 | $-3.52\times10^{-3}$ | 3.709 | 1.891 |
    | 64 | $-1.07\times10^{-3}$ | 3.283 | 1.715 |
    | 128 | $-3.35\times10^{-4}$ | 3.202 | 1.679 |
    | 1024 | $-1.04\times10^{-5}$ | 3.1765 | 1.6674 |
    | 16384 | $-1.03\times10^{-7}$ | 3.1749 | 1.6667 |

    For comparison, $2^{5/3}=3.1748$. From $n=32$ on, the ratios decrease toward it from above.
  - Pairs inside the animation:

    | Pair | Ratio | p |
    |---|---|---|
    | 12→24 | 4.235 | 2.082 |
    | 24→48 | 3.380 | 1.757 |
    | 48→96 | 3.221 | 1.688 |

    The least-squares slope of $\log|E|$ against $\log h$ is 1.798 over frames $n=12..108$ and 1.888 over $n=8..108$.
  - Control: the same routine on the smooth $e^x$ over $[0,2]$ gives ratios 15.91, 15.98, 15.994 and 15.999, so the routine is fourth order.
  - The finding holds. "Fourth-order global accuracy" is false for this integrand: the measured order tends to $5/3$. The independent-check note (order about 1.8 over n=12..108) also agrees.
- **Change:** text only, in `index.qmd`. The animation is right (see Scripts and GIFs), so under D1 and D7 the script and GIF are unchanged.
  - Line 18: "the composite error for smooth functions is $O(h^4)$" → "the composite error for smooth $f$ (four times continuously differentiable on $[a,b]$) is $O(h^4)$". This is D1(b), with the $C^4$ hypothesis taken from Mathews' corollary.
  - Line 29 (Behavior): "and the approximation converges rapidly with fourth-order global accuracy." → three parts:
    - the reference value and the last frame's value;
    - the D1 cause sentence, verbatim;
    - the measured $O(h^{5/3})$ sentence with this page's own R (3.38, from 24→48).
- **Check:** every number in the new text was recomputed (see the ledger). `git diff --stat` shows only `index.qmd`, with 2 lines changed.

## Ledger of changed text

All commands were run from `$FIX/scripts`:

- `order.py` is run as `/usr/bin/python3 -I order.py` and writes `$FIX/order.out`.
- `script_values.jl` is run as `julia script_values.jl` and writes `$FIX/script_values.out`. It is a copy of the script's `simpson_sum` with the same `n_seq` and no plotting.

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd:18 | "smooth $f$ (four times continuously differentiable on $[a,b]$) is $O(h^4)$" | Mathews' corollary hypothesis is image `SimpsonRuleMod_gr_39.gif`, which reads "f(x) ∈ C⁴[a,b]". The control in `order.py` on $e^x$ gives ratios 15.91 → 15.999, which is about $2^4$. | yes |
| index.qmd:29 | "the approximation converges toward the true integral" | `order.py`: $\lvert E\rvert$ decreases at every one of the 22 frame-to-frame steps (n=2..108), from 0.475 to 4.46e-4. $S_n<I$ for every frame from n=4 on. Under doubling, $E\to0$ (1.03e-7 at n=16384). | yes |
| index.qmd:29 | $\int_0^2 f\,dx \approx 2.016280$ | `order.py`: I = 2.01627971961709632788727442192 from two mpmath methods; scipy gives 2.016279719617097. | yes |
| index.qmd:29 | "the last frame (109 sample points) gives 2.015834" | `order.py`: n=108 gives S = 2.015834216. `script_values.jl` prints `108 109 2.015834`. Frame `$FIX/orig_frames/frame_024.png` reads "Sample Points = 109, Approximation = 2.015834". | yes |
| index.qmd:29 | "about 0.00045 low" | `order.py`: E(108) = −0.000445504 | yes |
| index.qmd:29 | D1 cause sentence: "$x^{2/3}$ term makes $f'$ unbounded at $x=0$ ($f'(x)\approx\tfrac{16}{3}x^{-1/3}$ near $0$) … does not hold for this integrand" | `order.py` (sympy): the f' series at 0 is `16/(3*x**(1/3)) + O(1)`. The measured p tends to 1.6667, not 4. | yes |
| index.qmd:29 | "measured error shrinks like $O(h^{5/3})$ rather than $O(h^4)$" | `order.py` doubling table: p = 1.891 (n=32), 1.715 (64), 1.679 (128), 1.671 (256), 1.668 (512), 1.6674 (1024), 1.6669 (4096), 1.6667 (16384) | yes |
| index.qmd:29 | "halving $h$ divides it by about 3.38 (from 24 to 48 subintervals)" | `order.py` pairs: 24→48 gives 3.3803 (p = 1.757). n=24 and n=48 are both frames: frame_012 shows "Sample Points = 25" and frame_018 shows "Sample Points = 49". | yes |
| index.qmd:29 | "tending to $2^{5/3}\approx 3.17$, instead of 16" | `python3 -c "print(2**(5/3), 2**4)"` → 3.1748, 16. The doubling ratio is 3.1749 at n=16384. The smooth control gives 15.999. | yes |

The alt text, case heading and GIF title are unchanged. None of them makes a rate or order claim. The alt text says each frame "updates piecewise quadratic panels and the global approximation", and the frames show this.

## Scripts and GIFs

- No script was changed and no GIF was regenerated: the animation is correct.
  - `script_values.jl` reproduces all 23 labelled values, and they agree with `order.py` rounded to 6 digits.
  - "Sample Points = n+1" is correct.
  - The panels are quadratics through $f$ at $x_{2k}, x_{2k+1}, x_{2k+2}$ (`poly_coeffs` on the three nodes). In the frames, the panels match the curve.
- Frames of the committed GIF were extracted to `$FIX/orig_frames/` (24 frames).
  - I viewed the contact sheet and frames 12, 18 and 24 at full size.
  - The labels match the computed values: 25 points and 2.01037; 49 points and 2.014531; 109 points and 2.015834.
  - The visible mismatch between the panels and the curve near $x=0$ shrinks over the frames. This is the region the cause sentence refers to.
- `git status --short -- pages/numerical-methods/simpsons-rule-for-numerical-integration` →
  ` M pages/numerical-methods/simpsons-rule-for-numerical-integration/index.qmd` (only).

## Legacy archive

Consulted.

- `n2003/simpsonsrulemod.html` links to `a2001/Animations/Quadrature/Simpson/Simpson.html`, whose animation is `Simpsonaa.gif`. Its frames were extracted to `$FIX/legacy_frames/` (24 frames).
  - Mathews uses the same $y=e^{-x}\sin(8x^{2/3})+1$ on $[0,2]$. Sample Points run 3, 7, 11, …, 41: every 4 points after the 3- and 7-point frames, ending at n=40.
  - His labels agree with mpmath to 6 digits (`$FIX/legacy_values.out` and `order.out`):

    | Points | Mathews' label | mpmath |
    |---|---|---|
    | 3 | 2.491261 | 2.491261 |
    | 7 | 1.840560 | 1.840560 |
    | 11 | 1.976389 | 1.976389 |
    | 15 | 1.998814 | 1.998814 |
    | 19 | 2.006018 | 2.006018 |
    | 23 | 2.009329 | 2.009328945 |
    | 27 | 2.011175 | 2.011174878 |
    | 31 | 2.012331 | 2.012330593 |
    | 35 | 2.013112 | 2.0131116 |
    | 39 | 2.013669 | 2.013668707 |
    | 41 | 2.013890 | 2.013890041 |

  - The repo's script uses a different n sequence (up to 109 points). This is harmless.
- The module states the remainder for $f\in C^4[a,b]$ (image `SimpsonRuleMod_gr_39.gif`). Its Remark and Example 5 say that reducing the step size should reduce the error by a fixed factor. In the module that factor is shown as an image; for $O(h^4)$ it is 16 when $h$ is halved.
  - That holds only under the $C^4$ hypothesis. It does not hold for the animated integrand, where halving $h$ divides the error by 3.38 at 24→48, tending to 3.17.
  - The page follows the mathematics and keeps Mathews' integrand, per D1.

## Notes

- No D1 ambiguity on this page.
  - The Description already qualified the order with "for smooth functions". I made the hypothesis explicit ($C^4$).
  - The alt text has no order claim, so it was left unchanged.
- The Description's general clause "typically much smaller than trapezoidal error at the same spacing" was kept: it sits under the smoothness label.
  - It also happens to hold here: at n=32, Simpson's error is −3.52e-3 against −1.19e-2 for the trapezoid rule (trapezoid value from that page's record).
- Seen but not a finding, so left unchanged:
  - The n=72 frame shows "Approximation = 2.0154", because `round(…; digits=6)` drops trailing zeros. The true value is 2.01539967 → 2.015400, so the shown number is correct, only shorter.
  - Overlapping semi-transparent fills leave faint vertical seams in the pink area.
- Nothing outside the page folder was touched, apart from this record.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: The false sentence ("converges rapidly with fourth-order global accuracy") is gone from `index.qmd` Case 1 Behavior. The replacement states the true integral (~2.016280), the last-frame value (2.015834, about 0.00045 low), the cause (f' unbounded at 0, f'(x) ~ (16/3)x^{-1/3}), and the measured order O(h^{5/3}) with a halving ratio of 3.38 (24 to 48) tending to 2^{5/3} ~ 3.17. I checked all of these independently (`check/ref.py`, mpmath at 40 digits). Reference I = 2.016279719617096327887274, the same from three routes: 40-panel Gauss-Legendre, the substitution x = t^3, and tanh-sinh. Composite Simpson errors: n=24 -5.910e-3, n=48 -1.748e-3, n=108 -4.455e-4. Halving ratios: 12→24 4.235, 24→48 3.380, 48→96 3.221, 96→192 3.189, ..., 3072→6144 3.1751, so log2 tends to 1.667 = 5/3. The Description sentence now states the C^4 hypothesis, so the general O(h^4) statement no longer reads as if it covers this integrand. The script and GIF were correct already and were not changed, so they needed no change. The finding was text-only.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd:18 | "smooth $f$ (four times continuously differentiable on $[a,b]$) is $O(h^4)$" | Standard hypothesis for the composite Simpson error term -(b-a)h^4 f''''(xi)/180. A smooth control was confirmed fourth order in the original review. | Correct |
| index.qmd:29 | "converges toward the true integral ... ≈ 2.016280" | I = 2.0162797196... rounds to 2.016280 | Correct |
| index.qmd:29 | "last frame (109 sample points)" | n_seq ends at 108, so there are 109 points. Last frame reads "Sample Points = 109". | Correct |
| index.qmd:29 | "gives 2.015834" | S_108 = 2.015834216, which rounds to 2.015834. The last frame shows the same. | Correct |
| index.qmd:29 | "about 0.00045 low" | I - S_108 = 4.455e-4 > 0 | Correct |
| index.qmd:29 | "f' unbounded at x=0 ($f'(x)\approx \tfrac{16}{3}x^{-1/3}$ near 0)" | Numerical f'(x) / ((16/3)x^{-1/3}) = 0.9999972 at x=1e-6 and 0.9999999975 at x=1e-9 | Correct |
| index.qmd:29 | "textbook error order, which assumes smooth f, does not hold" | Measured order is 5/3, not 4 | Correct |
| index.qmd:29 | "error shrinks like $O(h^{5/3})$ rather than $O(h^4)$" | log2 of the halving ratio goes 1.757, 1.688, 1.673, 1.669, 1.668, 1.667, 1.667 | Correct |
| index.qmd:29 | "divides it by about 3.38 (from 24 to 48 subintervals)" | E24/E48 = 3.3803. Both n=24 and n=48 are frames in the GIF. | Correct |
| index.qmd:29 | "tending to $2^{5/3}\approx 3.17$" | 2^{5/3} = 3.1748. The ratio at 3072→6144 is 3.1751. | Correct |
| index.qmd:29 | "instead of 16" | 2^4 = 16 for fourth order | Correct |

### New problems
None. This rests on three checks:
- Every changed sentence and number was verified above.
- The fix changed only `index.qmd`. The script and GIF are byte-unchanged from HEAD (`git diff --quiet HEAD` on the GIF).
- I looked at frames 1, 12 and 24 at full size:
  - Frame 1 (n=0) shows only the curve.
  - Frame 12 (n=24) shows "Sample Points = 25" and "Approximation = 2.01037", which matches S_24 = 2.0103696.
  - Frame 24 (n=108) shows "Sample Points = 109" and "Approximation = 2.015834".
  - The quadratic panels follow the magenta curve, with a visible overshoot near the x^{2/3} cusp at coarse n. This is consistent with the new text.

### Reproducibility and conventions
- I ran `simpsonsaa.jl` from a scratch copy (`check/run/`). The output `simpsonsaa.gif` is byte-identical to the committed GIF (`cmp`). The GIF has 24 frames.
- The page keeps its conventions:
  - Description comes before Animations.
  - Case 1 has the "[Julia source](simpsonsaa.jl)" link and an embed of `simpsonsaa.gif`.
  - The alt text is descriptive and unchanged.
  - There are no code blocks.
- No file outside the page folder was changed by this fix. The page-folder status shows only `index.qmd` modified. Other modified files on the branch belong to other pages' fixes.

**Final status:** committed
