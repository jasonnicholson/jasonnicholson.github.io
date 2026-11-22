# Fix record: midpoint-rule

Scratch folder (all evidence, re-runnable):
`/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/work/midpoint-rule/fix/`
(below written as `$FIX`). Scripts are in `$FIX/scripts/`, outputs in `$FIX/*.out`.

- `order.py`: run as `/usr/bin/python3 -I order.py > ../order.out`. Reference integral, sympy series, frame table (midpoint, left and right errors), in-animation doubling pairs, the doubling sequence n = 8..16384, LS slope, and a smooth control.
- `behavior.py`: run as `/usr/bin/python3 -I behavior.py > ../behavior.out`. One check per behaviour claim in the new Behavior paragraph.
- `script_values.jl`: run as `julia script_values.jl > ../script_values.out`. An instrumented copy of the script's `midpoint_sum`, with no plotting. It prints each frame's label value.

## Findings

### F1 — Misleading — fixed

- **Reproduced:** with `order.py` (mpmath at 40 digits, midpoint sums at exact nodes $(i+\tfrac12)h$). This is independent of the repo script.
  - Reference integral: $I = 2.0162797196170963278872744219151$. The substitution $x=t^3$ and a direct tanh-sinh on 80 panels agree, differing by $-4.59\times10^{-41}$.
  - sympy at $0$: $f = 1 + 8x^{2/3} + O(x)$ and $f' = \tfrac{16}{3}x^{-1/3} + O(1)$. As a check, $f'(10^{-6}) = 533.33183$, against $\tfrac{16}{3}(10^{-6})^{-1/3} = 533.33333$.
  - Under doubling $n$, the ratio $E(n/2)/E(n)$ and the observed order $p$ are:

    | n | E(n) | ratio | p |
    |---|---|---|---|
    | 16 | $1.33\times10^{-2}$ | 2.644 | 1.403 |
    | 32 | $4.36\times10^{-3}$ | 3.054 | 1.611 |
    | 64 | $1.39\times10^{-3}$ | 3.132 | 1.647 |
    | 128 | $4.42\times10^{-4}$ | 3.154 | 1.657 |
    | 1024 | $1.39\times10^{-5}$ | 3.1685 | 1.664 |
    | 16384 | $1.38\times10^{-7}$ | 3.1727 | 1.6657 |

    For comparison, $2^{5/3} = 3.1748$. The ratios increase at every step of the table toward that value.
  - In-animation pairs:
    - 8→16 gives 2.644, 16→32 gives 3.054, 24→48 gives 3.1125 ($p=1.638$) and 32→64 gives 3.132.
    - 5→10 gives 1.40 and 6→12 gives 2.08.
    - For n ≤ 4 the error changes sign, so those ratios mean nothing.
  - Least-squares slope of $\log|E|$ against $\log h$ is 1.604 over the frames n=8..120, and 1.641 over n=16..120.
  - Control: the same routine on the smooth $e^x$ over $[0,2]$ gives ratios 3.99454, 3.99863, …, 4.0, so it is second order when $f$ is smooth.
  - These match the corrected finding: the factor tends to 3.17 asymptotically, and within the animation it is smaller still (1.4–3.13). Line 37's smooth-case statement is true but was the only rate given, so a reader would apply it to the animated integrand.
- **Change:** text only, in `index.qmd`. The animation is correct (see Scripts and GIFs), so per D1 and D7 the script and GIF are unchanged.
  - Line 29 (Behavior) now has the D1 cause sentence (verbatim) and the page-specific rate sentence. The rate sentence uses $\Delta x$, which is this page's notation for $h$, and states R = 3.11 (24→48).
  - Line 37 (Derivation Notes): "For smooth $f$, midpoint rule has …" → "For smooth $f$ (twice continuously differentiable on $[a,b]$), the midpoint rule has …". The factor-of-4 statement stays, now with its hypothesis explicit.
- **Check:** all numbers are in the ledger. `git diff` shows only lines 29 and 37 of `index.qmd` changed.

### F2 — Minor — fixed

- **Reproduced:** with `order.py` and `behavior.py`.
  - The frame values are:
    - n = 1: 2.727929 (E = +0.712);
    - n = 2: 1.231216 (−0.785);
    - n = 3: 1.811305 (−0.205);
    - n = 4: 2.011118 (−0.0052);
    - n = 5: 2.053636 (+0.0374);
    - n = 6: 2.059280 (+0.0430);
    - n = 10: 2.043030 (+0.0268).
  - From n=6 the estimates decrease in every frame, but the third decimal is still changing at n=64 (2.017673, then 2.017426 at n=72). The last frame, n=120, gives 2.016771, which is $E=+4.917\times10^{-4}$.
  - "Stabilizes quickly" is therefore not what the animation shows.
  - The comparison clause, "tracks local curve height better than endpoint samples", is not true at every frame. At n = 1, 2 and 3, the left and right endpoint sums are closer to $I$ than the midpoint sum; for example at n=1, $|E_M| = 0.712$ against $|E_L| = 0.0163$.
  - From n = 4 on, the midpoint is closer than both endpoint sums at every frame. At n=120 the left and right errors are 3.02 and 2.41 times the midpoint error.
  - The finding holds.
- **Change:** line 29, "The midpoint sample in each subinterval tracks local curve height better than endpoint samples, so the estimate stabilizes quickly as density increases." was replaced by two sentences:
  - one describing the actual sequence: it jumps across $I$ at first, stays above and decreases from 6 sample points on, and ends at 2.016771, about 0.00049 high;
  - one giving the midpoint-against-endpoint comparison with its exact range, from 4 sample points on.
- **Check:** every claim in the new text is checked by `behavior.py` over all 24 frames. See the ledger.

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd:29 | "Over the first few frames the estimate jumps above and below the integral" | `behavior.py`: signs of E for n=1..5 are +, −, −, −, + | yes |
| index.qmd:29 | "from 6 sample points on it stays above … and decreases toward it in every frame" | `behavior.py`: "E>0 for every frame n>=6: True"; "M strictly decreasing over every frame from n=6: True". The range starts at 6, not 5, because M5 = 2.053636 < M6 = 2.059280. Label "Sample Points = n" equals the number of subintervals (script line 44) | yes |
| index.qmd:29 | $\int_0^2 f(x)\,dx \approx 2.016280$ | `order.py`: I = 2.0162797196170963278872744219151 (two mpmath methods agree to 4.6e-41). `behavior.py`: "I to 6 dp: 2.016280" | yes |
| index.qmd:29 | "but slowly" | `order.py`: E = 0.0430 (n=6) → 0.00139 (n=64) → 0.000492 (n=120); the third decimal still changes between n=64 and 72 (2.017673 → 2.017426) | yes |
| index.qmd:29 | "the last frame (120 sample points) gives 2.016771" | `order.py`: M_120 = 2.0167714555. `script_values.jl`: `120 2.016771`. Frame `$FIX/orig_frames/frame_025.png` (viewed full size) reads "Sample Points = 120 / Approximation = 2.016771" | yes |
| index.qmd:29 | "still about 0.00049 high" | `behavior.py`: E(120) = +0.0004917 | yes |
| index.qmd:29 | "From 4 sample points on, the midpoint estimate is closer to the integral than the left- or right-endpoint sum with the same number of subintervals" | `behavior.py`: "better for every frame n>=4: True"; "frames where not better: [1, 2, 3]" (so the range is stated as 4 on) | yes |
| index.qmd:29 | D1 cause sentence (verbatim): "$x^{2/3}$ term makes $f'$ unbounded at $x=0$ ($f'(x)\approx\tfrac{16}{3}x^{-1/3}$ near $0$) … does not hold for this integrand" | `order.py` (sympy): f' series at 0 = `16/(3*x**(1/3)) + O(1)`; f'(1e-6) = 533.33183 vs 533.33333. Measured p → 1.6657 ≠ 2 | yes |
| index.qmd:29 | "measured error shrinks like $O(\Delta x^{5/3})$ rather than $O(\Delta x^2)$" | `order.py`: p = 1.403, 1.611, 1.647, 1.657, 1.661, 1.663, 1.664, 1.6646, 1.6651, 1.6654, 1.6657 (n = 16..16384); LS slope 1.604 (frames n=8..120), 1.641 (n=16..120). Smooth control gives 4.0 | yes |
| index.qmd:29 | "halving $\Delta x$ divides it by about 3.11 (from 24 to 48 subintervals)" | `order.py` / `behavior.py`: 24→48 ratio 3.1125 (p = 1.638). n=24 and n=48 are both frames (frame_015 and frame_019; the contact sheet shows "Sample Points = 48") | yes |
| index.qmd:29 | "tending to $2^{5/3}\approx 3.17$, instead of 4" | `order.py`: 2^(5/3) = 3.1748. The doubling ratios rise from 2.644 to 3.17269 at n=16384, increasing at every step. The smooth control gives 4 | yes |
| index.qmd:37 | "For smooth $f$ (twice continuously differentiable on $[a,b]$), the midpoint rule has global error order $O(\Delta x^2)$, … roughly a factor of 4" | The archive corollary image `MidpointRuleMod_gr_29.gif` reads "f(x) ∈ C²[a,b]", and its Remark image `MidpointRuleMod_gr_36.gif` reads "(1/2)² = 0.25". Numerical control in `order.py`: midpoint on e^x gives ratios 3.99454 → 4.0 | yes |

The alt text, case heading and GIF title are unchanged; none of them makes a rate or stabilization claim. The alt text says each frame "increases partition density and recomputes midpoint-rectangle area", which the frames confirm. Worked Example line 41 ("converges as $n$ grows") was left as it is: it is true in the limit ($E\to0$, as the doubling table shows), and the Behavior paragraph now gives the rate.

## Scripts and GIFs

- No script was changed and no GIF was regenerated, because the animation is correct.
  - All 24 labelled values match: `script_values.jl` agrees with mpmath rounded to 6 decimals for every n (comparison in this session's run; all "match").
  - The rectangles are built from $f$ at the midpoints $a+(i+\tfrac12)\Delta x$ (script lines 33–38).
- Frames of the committed GIF were extracted to `$FIX/orig_frames/` (25 frames: one blank frame, then n = 1…120).
  - I viewed the contact sheet, frame_005 (n=4, 2.011118) and frame_025 (n=120, 2.016771) at full size. The labels match the computed values.
  - The committed GIF's sha256 is `ec06a387…f0d2a4`, unchanged.
- `git status --short -- pages/numerical-methods/midpoint-rule` → ` M pages/numerical-methods/midpoint-rule/index.qmd` (only).

## Legacy archive

Consulted.

- `n2003/MidpointRuleMod.html` links its animation to `a2001/Animations/Quadrature/Midpoint/Midpoint.html`, and that animation exists as `a2001/Animations/Quadrature/Midpoint/Midpointaa.gif`. Its frames were extracted to `$FIX/legacy_frames/` (24 frames); the label strips are tiled in `$FIX/legacy_odd_labels.png`.
  - It uses the same $y=e^{-x}\sin(8x^{2/3})+1$ on $[0,2]$, with "Sample Points" running 1, 2, 4, 6, 8, 10, 12, 14, 16, 20, 24, 28, 32, 40, 50, 60, 70, 80, 100, 120.
  - Every legacy label checked agrees with mpmath to 6 decimals (`$FIX/legacy_check.out` and `order.out`). Examples: 2.727929 (1), 1.231216 (2), 2.011118 (4), 2.059280 (6), 2.043030 (10), 2.018375 (50), 2.017830 (60), 2.017481 (70), 2.017243 (80), 2.016945 (100), 2.016771 (120).
  - Mathews' animation shows the same rise to 2.059280 at 6 points followed by a slow decrease.
- The module's corollary states the remainder for $f\in C^2[a,b]$ (`MidpointRuleMod_gr_29.gif`). Its Remark (`gr_36`: "(1/2)² = 0.25") says halving the step should cut the error by about 4. That assumes $C^2$ and does not hold for the animated integrand, whose measured factor is 3.11 at 24→48 and tends to 3.17. The page follows the mathematics; the integrand is kept, per D1.

## Notes

- **D1 placement.** D1 says the textbook order stays in the Description. On this page the textbook order lives in "Derivation Notes", not in the Description. I labelled it where it is rather than moving it, to avoid reorganising the page.
- **Rate notation.** The rate sentence uses $\Delta x$ instead of the pattern's $h$, to match this page's own notation (line 12).
- **Not changed (outside the findings), for Jason:**
  - Line 25 says "Legacy midpoint animation assets are partially missing from the archive". That is not accurate for the archive as present now: `a2001/Animations/Quadrature/Midpoint/Midpointaa.gif` exists, and our script reproduces its labels. No finding names it, so it is left as is.
  - The script's labels use `round(x; digits=6)`, so trailing zeros drop: the GIF shows "2.05928" (n=6) and "2.04303" (n=10), where the legacy GIF shows 2.059280 and 2.043030. The numbers are not false, only shown to 5 decimals, so this is cosmetic and was not changed.
  - The page has "Derivation Notes", "Worked Example" and "Implementation Notes" sections with short content rather than the "(Planned)" stubs used elsewhere. This is pre-existing and was left alone.
- Nothing outside the page folder and this record was touched.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- The smooth-case statement (Derivation Notes, index.qmd:37) is kept and now names its hypothesis precisely: "twice continuously differentiable on [a,b]". That is the standard sufficient condition for the O(Δx²) midpoint error bound, so the sentence is true.
- The Case 1 Behavior paragraph now says outright that the x^{2/3} term makes f' unbounded at 0, that the textbook order does not hold here, and that the error behaves like O(Δx^{5/3}), with the ratio 3.11 (24→48) tending to 2^{5/3}≈3.17 instead of 4.
- Independent check (`check/verify.py`, mpmath 40 digits; I computed by substituting x=t³ and confirmed with a split-interval quad: I = 2.016279719617096327887274): halving ratios are 2.644 (8→16), 2.962 (12→24), 3.054 (16→32), **3.1125 (24→48)**, 3.132 (32→64), 3.161 (120→240), 3.1712 (1920→3840), 3.1720 (3840→7680). The observed order rises from 1.40 to 1.6654, which tends to 5/3. 2^{5/3} = 3.1748. The claim f'(x) ≈ (16/3)x^{-1/3} near 0 also checks out: the ratio f'(x)/((16/3)x^{-1/3}) is 0.9943, 0.999997 and 1.0000 at x = 1e-3, 1e-6 and 1e-9.
- The reader now sees the factor of 4 only as the smooth case and gets the correct rate for the animated integrand.

### F2 — resolved
- "stabilizes quickly" is gone. In its place is a frame-by-frame description, and I checked every number in it against my own M_n table (see ledger). The estimates for n = 1, 2, 3, 4 and 5 are 2.7279 (+), 1.2312 (−), 1.8113 (−), 2.0111 (−) and 2.0536 (+), so they do jump above and below the integral. From n=6 on, every estimate is above I and smaller than the one before it: 6 → 2.059280, 7 → 2.056230, …, 120 → 2.016771. Note that n=5→6 increases, so "from 6 on" is the right place to start the claim. The last frame's error is +4.917e-4.
- The midpoint-vs-endpoint claim is now stated with its true range. For n = 1, 2 and 3 the midpoint sum is not closer than both endpoint sums. For every n from 4 to 120 in n_seq it is closer than both. At n=120: |L err| = 1.485e-3, |R err| = 1.186e-3, |M err| = 4.92e-4.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd:29 | "Over the first few frames the estimate jumps above and below the integral" | M_n − I for n=1..5: +0.712, −0.785, −0.205, −0.0052, +0.0374 | True |
| index.qmd:29 | "from 6 sample points on it stays above … and decreases toward it in every frame" | Every n_seq entry ≥6 has a positive error and M_n strictly decreasing (verify.py "dec" column) | True |
| index.qmd:29 | ∫₀² f dx ≈ 2.016280 | I = 2.0162797196… (two independent quad evaluations agree to 40 digits) | True |
| index.qmd:29 | last frame "120 sample points", 2.016771 | M_120 = 2.016771455; frame_025 shows "Sample Points = 120 / Approximation = 2.016771" | True |
| index.qmd:29 | "still about 0.00049 high" | +4.9174e-4 | True |
| index.qmd:29 | "From 4 sample points on, the midpoint estimate is closer … than the left- or right-endpoint sum" | Holds for every n_seq entry 4..120, and fails for n=1,2,3, so "from 4" is exact | True |
| index.qmd:29 | "x^{2/3} term makes f' unbounded at x=0", "f'(x) ≈ (16/3)x^{-1/3} near 0" | Numerical ratio → 1 as x→0 | True |
| index.qmd:29 | "textbook error order, which assumes smooth f, does not hold" | Measured order 1.40 → 1.665 < 2 | True |
| index.qmd:29 | "O(Δx^{5/3}) rather than O(Δx²)" | Measured order tends to 1.6667 (1.6654 at 3840→7680) | True |
| index.qmd:29 | "divides it by about 3.11 (from 24 to 48 subintervals)" | 3.1125 | True |
| index.qmd:29 | "tending to 2^{5/3} ≈ 3.17, instead of 4" | 2^{5/3} = 3.1748; ratios increase monotonically toward it | True |
| index.qmd:37 | "smooth f (twice continuously differentiable on [a,b]) … O(Δx²) … factor of 4" | This is the standard composite midpoint bound (b−a)Δx² max\|f''\|/24, and it requires f ∈ C² | True |

Terminology: the paragraph counts frames in "sample points", which matches the GIF label, and counts in "subintervals" for the endpoint comparison and the halving ratio. For the midpoint rule the two numbers are the same, so the two terms are consistent.

### New problems
None. This rests on three things: every sentence and number the fix changed was checked independently (table above); the script and GIF are unchanged and reproduce exactly; and the unchanged text that remains ("often much more accurate than left/right endpoint sums", Worked Example "converges as n grows") is consistent with the computed data (midpoint 2.5–3× better than the endpoint sums at n=120, and monotone convergence from n=6).

### Reproducibility and conventions
- The fix changed only `index.qmd` in this page folder (`git diff HEAD --name-only` on the folder). `midpointaa.jl` and `midpointaa.gif` are unchanged against HEAD. HEAD stores the GIF as a Git LFS pointer, and git reports no modification.
- I ran a scratch copy of `midpointaa.jl` (check/run/). Its output is byte-identical to the committed `midpointaa.gif`.
- I extracted the frames: 25 in total (one blank frame with n=0, then the 24 values of n_seq). Frames 7 (n=6, 2.05928), 14 (n=20, 2.025636) and 25 (n=120, 2.016771) are legible. The rectangles are centred on midpoint heights, the axes are fixed, and the labels match my computed values.
- Conventions are kept: Description comes before Animations, the case has a source link and an embed, the alt text is descriptive, and there are no code blocks.
- No file outside the page folder belongs to this fix. The working tree has many other pages modified, and untracked fix notes under `reviews/numerical-methods-animations/fixes/` (including `midpoint-rule.md`). These come from the wider fix pipeline, not from this page's diff.

**Final status:** committed
