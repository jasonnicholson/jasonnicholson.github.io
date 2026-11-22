# Fix record: trapezoidal-rule-for-numerical-integration

Scratch folder (all evidence, re-runnable):
`/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/work/trapezoidal-rule-for-numerical-integration/fix/`
(below written as `$FIX`). Scripts are in `$FIX/scripts/`, outputs in `$FIX/*.out`.

## Findings

### F1 — Error — fixed

- **Reproduced:** `cd $FIX/scripts && /usr/bin/python3 -I order.py` (output `$FIX/order.out`). Independent of the repo script: mpmath at 40 digits, trapezoid sums at exact nodes `i*2/n`.
  - Reference integral $I = 2.01627971961709632788727442192$. Two mpmath methods agree (substitution $x=t^3$ then tanh-sinh, and direct tanh-sinh on 80 panels; they differ by $-4.6\times10^{-41}$). scipy `quad` in double precision gives 2.016279719617097.
  - sympy: $f = 1 + 8x^{2/3} + O(x)$ and $f' = \tfrac{16}{3}x^{-1/3} + O(1)$ at $0$. Check value: $f'(10^{-6}) = 533.3318$ against $\tfrac{16}{3}(10^{-6})^{-1/3} = 533.3333$.
  - Error ratios $E(n/2)/E(n)$ under doubling $n$, with observed order $p=\log_2$ of the ratio:

    | n | E(n) | ratio | p |
    |---|---|---|---|
    | 16 | $-3.72\times10^{-2}$ | 2.947 | 1.559 |
    | 32 | $-1.19\times10^{-2}$ | 3.115 | 1.639 |
    | 64 | $-3.79\times10^{-3}$ | 3.151 | 1.656 |
    | 128 | $-1.20\times10^{-3}$ | 3.162 | 1.661 |
    | 1024 | $-3.77\times10^{-5}$ | 3.170 | 1.665 |
    | 16384 | $-3.72\times10^{-7}$ | 3.1733 | 1.666 |

    For comparison, $2^{5/3} = 3.1748$.
  - Least-squares slope of $\log|E|$ against $\log h$ over the animation's frames $n=8..120$ is 1.637.
  - Control: the same sums on the smooth $e^x$ over $[0,2]$ give ratios 3.997, 3.9992, 3.9998, 3.99995, so the sums are second order when $f$ is smooth.
  - The finding holds: $O(h^2)$ is false for this integrand, and the measured order tends to $5/3$.
- **Change:** text only, in `index.qmd`. The animation is right, so per D7 and D1 the script and GIF are unchanged.
  - Line 18: "For smooth functions, the global truncation error is second order" → "For smooth $f$ (twice continuously differentiable on $[a,b]$), the global truncation error is second order". This labels the textbook order with the hypothesis of Mathews' corollary, $f\in C^2[a,b]$.
  - Line 29 (Behavior): "converges toward the true integral with $O(h^2)$ global error" → three sentences:
    - the reference value and the last frame's value;
    - the D1 cause sentence;
    - the measured $O(h^{5/3})$ rate with the halving factor.

    Full text is in the ledger.
- **Check:** every number in the new text was recomputed. See the ledger. `git diff` shows only lines 18 and 29 of `index.qmd` changed.

## Ledger of changed text

All commands run from `$FIX/scripts`. `order.py` is run as `/usr/bin/python3 -I order.py` and writes `$FIX/order.out`. `script_values.jl` is run as `julia script_values.jl` (an instrumented copy of the script's `trapezoid_sum`, no plotting) and writes `$FIX/script_values.out`.

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd:18 | "For smooth $f$ (twice continuously differentiable on $[a,b]$), … second order: $T_n - I = O(h^2)$" | Hypothesis of Mathews' corollary: archive image `TrapezoidalRuleMod_gr_29.gif` reads "f(x) ∈ C²[a,b]". The error is $-(b-a)f''(c)h^2/12$. Numerical control in `order.py` on $e^x$: ratios → 3.99995 ≈ 4. | yes |
| index.qmd:29 | "approximation converges toward the true integral" | `order.py`: from $n=4$ (5 points) to $n=120$, $T_n < I$, $T_n$ is increasing and $\lvert E\rvert$ is decreasing over every frame. Asymptotically $E\to0$ (doubling table). | yes |
| index.qmd:29 | $\int_0^2 f\,dx \approx 2.016280$ | `order.py` → I = 2.01627971961709632788727442192 (two mpmath methods agree to $10^{-40}$; scipy 2.016279719617097) | yes |
| index.qmd:29 | "the last frame (121 sample points) gives 2.014944" | `order.py`: n=120 → T = 2.01494446462. `script_values.jl`: `120 121 2.014944`. Frame `orig_frames/frame_024.png` reads "Sample Points = 121, Approximation = 2.014944". | yes |
| index.qmd:29 | "about 0.0013 low" | `order.py`: E(120) = −0.00133525 | yes |
| index.qmd:29 | "The $x^{2/3}$ term makes $f'$ unbounded at $x=0$ ($f'(x)\approx\tfrac{16}{3}x^{-1/3}$ near $0$)" | `order.py` (sympy): f' series at 0 = `16/(3*x**(1/3)) + O(1)`. Also f'(1e-6) = 533.3318 vs 533.3333. | yes |
| index.qmd:29 | "so the textbook error order, which assumes smooth $f$, does not hold for this integrand" | $f\notin C^1[0,2]$ (previous row). Measured p → 1.666 ≠ 2 (doubling table). | yes |
| index.qmd:29 | "measured error shrinks like $O(h^{5/3})$ rather than $O(h^2)$" | `order.py`: p = 1.559, 1.639, 1.656, 1.661, …, 1.666 at n=16384. LS slope over the frames is 1.637. | yes |
| index.qmd:29 | "halving $h$ divides it by about 3.14 (from 24 to 48 subintervals)" | `order.py` pairs: 24→48 ratio 3.1415 (p = 1.651). Both n=24 and n=48 are frames of the animation. | yes |
| index.qmd:29 | "tending to $2^{5/3}\approx 3.17$, instead of 4" | `order.py`: 2^(5/3) = 3.1748. Ratio at n=16384 is 3.17325 and still rising. The smooth control gives 4. | yes |

Alt text, case heading and GIF title are unchanged. They make no rate or order claim. The alt text says each frame "uses a denser partition and updates the global approximation", which the frames confirm.

## Scripts and GIFs

- No script was changed and no GIF was regenerated: the animation is correct.
  - All 23 labelled values of the script were reproduced: `script_values.jl` matches `order.py` rounded to 6 digits for every n.
  - The labels show "Sample Points = n+1" correctly.
- Frames of the committed GIF were extracted to `$FIX/orig_frames/` (24 frames).
  - Checked the contact sheet and the last frame at full size.
  - The trapezoids are built from $f$ at the nodes $a+ih$.
  - The labels match the computed values: frame 24 shows 121 points and 2.014944.
  - The approach to the curve is visible.
- `git status --short -- pages/numerical-methods/trapezoidal-rule-for-numerical-integration` →
  ` M pages/numerical-methods/trapezoidal-rule-for-numerical-integration/index.qmd` (only).

## Legacy archive

Consulted.

- `n2003/TrapezoidalRuleMod.html` links its animation to `a2001/Animations/Quadrature/Trapezoidal/Trapezoidalaa.gif`. Its frames were extracted to `$FIX/legacy_frames/`.
  - Mathews' animation uses the same $y=e^{-x}\sin(8x^{2/3})+1$ on $[0,2]$, with "Sample Points" from 2 to 121.
  - Its labels agree with ours to 6 digits: 2.017925, 1.802071, 1.906595, 1.957234, 1.979056, 1.997086, 2.004331, 2.010570 (51 points; not one of our frames), 2.013011 (71 points), 2.014472 (101 points), and 2.014944 (121 points).
  - The repo's script uses a slightly different sequence of n (it includes 3, 7, 11, 15, … points), which is harmless.
- The module states the remainder for $f\in C^2[a,b]$ (image `TrapezoidalRuleMod_gr_29.gif`) and has a Remark that halving $h$ should cut the error by about 4. That remark assumes $C^2$ and does not hold for the animated integrand, whose measured factor is 3.14–3.17.
- Where the two differ, the page follows the mathematics and says so. The archive's choice of integrand is kept, per D1.

## Notes

- No D1 ambiguity on this page.
  - The Description already qualified the order with "for smooth functions". I made the hypothesis explicit ($C^2$), matching Mathews' corollary.
  - The alt text had no order claim, so it was left alone.
- Nothing outside the page folder was touched.

### D1 pattern for other pages

**(a) Cause sentence.** Use this verbatim, on its own, in the Behavior paragraph:

> The $x^{2/3}$ term makes $f'$ unbounded at $x=0$ ($f'(x)\approx \tfrac{16}{3}x^{-1/3}$ near $0$), so the textbook error order, which assumes smooth $f$, does not hold for this integrand.

It is checked for $f(x)=1+e^{-x}\sin(8x^{2/3})$. sympy gives `series(diff(f), x, 0, 0)` = `16/(3*x**(1/3)) + O(1)`.

Follow it with one page-specific sentence giving that page's measured rate, in this form:

> The measured error shrinks like $O(h^{5/3})$ rather than $O(h^{p_{\text{textbook}}})$: halving $h$ divides it by about R (from n₁ to 2n₁ subintervals), tending to $2^{5/3}\approx 3.17$, instead of $2^{p_{\text{textbook}}}$.

Each page must measure its own R and its own limiting order with its own rule. Do not copy 3.14: that number is the trapezoid rule's ratio at 24→48.

**(b) Labelling the textbook order.** In the Description, the general statement keeps the textbook order with the smoothness hypothesis made explicit, for example:

> For smooth $f$ (twice continuously differentiable on $[a,b]$), the global truncation error is second order: $T_n - I = O(h^2)$.

Use the hypothesis that matches the rule:

- $C^2$ for trapezoid and midpoint;
- $C^4$ for Simpson and 3/8;
- $C^6$ for Boole.

Check the hypothesis against that topic's archive corollary. The animated example gets no textbook order attached; it gets only the measured order.

**(c) How the order was measured.**

- **Method.** Composite-rule sums in mpmath at 40 digits, at exact nodes $a+i\,h$.
  - Errors are $E(n)=T_n-I$ against a high-precision reference.
  - Observed order is $p=\log_2\big(E(n/2)/E(n)\big)$ under doubling $n$.
  - Also report a least-squares slope of $\log|E|$ against $\log h$ over the n values the animation shows.
  - Run a control on a smooth integrand ($e^x$ on $[0,2]$) to confirm that the routine attains its textbook order.
- **h sequence.** $n=8,16,32,\dots,16384$ ($h=2/n$). Also the in-animation pairs (24,48), (28,56), (48,96).
- **Numbers (trapezoid).**
  - Under doubling, p = 1.559 (n=16), 1.639 (32), 1.656 (64), 1.661 (128), 1.663 (256), 1.664 (512), 1.665 (1024), 1.6652 (2048), 1.6655 (4096), 1.6658 (8192), 1.666 (16384).
  - Ratios 2.947 → 3.1733, against $2^{5/3}=3.1748$.
  - In-animation pairs: 24→48 gives 3.1415 (p=1.651) and 48→96 gives 3.1583 (p=1.659).
  - LS slope over frames n=8..120 is 1.637.
- **Reference integral.**
  - $I=\int_0^2 \big(1+e^{-x}\sin(8x^{2/3})\big)\,dx = 2.016279719617096327887274421915$ (30 digits).
  - Command:

    ```
    /usr/bin/python3 -I -c "import mpmath as mp; mp.mp.dps=40; f=lambda x: mp.exp(-x)*mp.sin(8*mp.cbrt(x)**2)+1; print(mp.quad(lambda t: f(t**3)*3*t**2, [0, mp.cbrt(2)], maxdegree=14)); print(mp.quad(f, mp.linspace(0,2,81), maxdegree=14))"
    ```

  - The substitution $x=t^3$ makes the integrand smooth. The two printed values agree to about $10^{-40}$.
  - The full script is `$FIX/scripts/order.py`.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: The false claim "converges ... with $O(h^2)$ global error" (old line 29) is gone. The new Behavior paragraph says the textbook order does not hold here and that the error shrinks like $O(h^{5/3})$. Independent check (`check/ind.py`, mpmath at 40 digits): $I=2.0162797196170963\ldots$, the same value from adaptive quadrature and from the substitution $x=t^3$. $E(n)/E(2n)$: 24→48 3.14152 (p=1.651), 48→96 3.15833, 60→120 3.16095, 1024 3.17148, 8192 3.17325 (p=1.66596). These rise steadily toward $2^{5/3}=3.17480$. $f'(x)/(\tfrac{16}{3}x^{-1/3}) \to 1$ as $x\to0$ (0.999997 at 1e-6, 1.0 at 1e-12). Line 18 now says "smooth $f$ (twice continuously differentiable on $[a,b]$)". That is the correct hypothesis for the $O(h^2)$ bound (error $=-\tfrac{(b-a)h^2}{12}f''(\xi)$). The script and GIF were not changed, and they did not need to be: the finding was about page text only, and the routine is a correct composite trapezoid sum.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd:18 | "smooth $f$ (twice continuously differentiable on $[a,b]$) ... $T_n-I=O(h^2)$" | Standard $C^2$ error formula | correct |
| index.qmd:29 | $\int_0^2 f\,dx \approx 2.016280$ | mpmath: 2.01627972 (two methods agree) | correct |
| index.qmd:29 | "last frame (121 sample points)" | n_seq ends at 120 → 121 points; frame_024 shows "Sample Points = 121" | correct |
| index.qmd:29 | last frame gives 2.014944 | mpmath $T_{120}=2.01494446$; frame_024 shows "Approximation = 2.014944" | correct |
| index.qmd:29 | "about 0.0013 low" | $T_{120}-I=-0.00133525$ | correct |
| index.qmd:29 | $f'$ unbounded at 0, $f'(x)\approx\tfrac{16}{3}x^{-1/3}$ | numeric ratio → 1 | correct |
| index.qmd:29 | textbook order assumes smooth $f$, does not hold here | measured p ≈ 1.65–1.666 ≠ 2 | correct |
| index.qmd:29 | $O(h^{5/3})$ rather than $O(h^2)$ | measured p → 1.666 | correct |
| index.qmd:29 | "divides it by about 3.14 (from 24 to 48 subintervals)" | 3.14152; n=24 and n=48 are both frames (25 and 49 sample points, frames 16 and 20) | correct |
| index.qmd:29 | "tending to $2^{5/3}\approx3.17$, instead of 4" | $2^{5/3}=3.1748$; ratios increase monotonically toward it | correct |

### New problems
None. This rests on: every number and claim in the two changed lines was recomputed independently (table above), with nothing else changed in the page folder; the GIF is unchanged and still matches the new text (frames 1, 16, 20 and 24 were viewed at full size, along with the contact sheet); and the page structure is intact.

### Reproducibility and conventions
- The fix changed only `index.qmd` in the page folder (`git diff --stat HEAD` on the folder: 2 lines changed). `trapezoidalaa.jl` is unchanged. `trapezoidalaa.gif` is unchanged: its sha256 7c96e327… matches the LFS pointer at HEAD, and its size is 362461 bytes.
- A scratch copy of `trapezoidalaa.jl`, regenerated, is byte-identical to the committed GIF (`cmp`). That GIF has 24 frames.
- Conventions: Description comes before Animations; there is one case with a `[Julia source]` link and an embed; the alt text is descriptive; there are no code blocks.
- Other files are modified on the branch, but they belong to other pages' fixes (bisection, fixed-point, newton, runge-kutta, and the section index). None of them mentions the trapezoidal page.

**Final status:** committed
