# Review: Milne-Simpson's Method (batch 1, round 1)

**Result: 0 Error, 0 Misleading, 3 Minor** (Minor findings are unverified, as the review skill allows). Both scripts are correct, and every other number and behaviour statement on the page was confirmed by independent computation.

**How this page was reviewed.** This was the calibration page. The reviewer worked on a scratch copy of the page folder that differed from the committed page in exactly two lines (60 and 96), where the director had planted two errors. The reviewer reported both planted errors as Error findings, with computed evidence, so the brief was judged adequate. Those two planted findings are not findings about this page and are omitted here. For both lines the reviewer's own numbers confirm the committed text: the reference y(5) = 0.00811992046486796 (mpmath `odefun`) matches the page's 0.008119920. The h = 0.1 error rises at 13 of the 44 steps after its peak, which matches the page's "dies out, with ups and downs". The scripts in the copy were byte-identical to the committed scripts. Line numbers below are those of the committed `index.qmd`.

The legacy archive was consulted: the module HTML, all 12 Links pages, the surviving images (including the Mathematica subroutine gr_41) and all 22 distinct frames of `Milneaa.gif`.

## Findings

### F1. Minor (page match, unverified): two values are rounded the wrong way
- **Line 294**, the $k = 25$ row of the Example 1 table: the page shows $4.85\times10^{-6}$. The true value is 4.84485e-6 (mpmath, 30 digits), which rounds to $4.84\times10^{-6}$.
- **Line 346**, the $(4,5]$ entry of the $h = 0.1$ row in the Example 2 table: the page shows $8.55\times10^{-8}$. The true maximum is 8.5447e-8, at t = 4.4, which rounds to $8.54\times10^{-8}$.
- Both look like double rounding.
- **Fix:** use $4.84\times10^{-6}$ and $8.54\times10^{-8}$. Line 255 ($e_3 = 4.8486\times10^{-6}$) is correct as it stands.

### F2. Minor (page match, unverified): the principal-root expansion is understated
- **Lines 205–206** say the principal root "matches $e^z$ through $z^3$".
- **What is true:** the reviewer derived the root's series in sympy (`stab.py`): its coefficients are $[1, 1/2, 1/6, 1/24, 1/72]$, against $e^z$'s $[1, 1/2, 1/6, 1/24, 1/120]$. So the root matches $e^z$ through $z^4$.
- As written, on a page that says the method is $O(h^4)$, the statement reads like third order.
- **Fix:** "$1+z+z^2/2+z^3/6+z^4/24+\cdots$, which matches $e^z$ through $z^4$, as a fourth-order method must."

### F3. Minor (fidelity, unverified): Mathews' Example 8 plots
- **Lines 89–90** say "Mathews' Examples 7 and 8 plot $|e_k|$ on a linear scale, one step size per plot".
- **What the archive shows:** Example 7 (gr_109) and the first plot of Example 8 (gr_115) each show one step size. Example 8 then overlays both step sizes: gr_120 reads "Show[graph4, graph6 ...]" and "...using 50 and 100 subintervals", and gr_121 is the combined plot.
- The page's point, that a linear plot of $|e_k|$ hides the sign, still holds.
- **Fix:** "(each step size alone, then both together)".

## Unresolved

None.

## Inventory (Phase 1)

- **Scripts:** `milneaa.jl` and `milnebb.jl`. **GIFs:** `milneaa.gif` (23 frames decoded, 21 distinct) and `milnebb.gif` (58 decoded, 50 distinct).
- Every file is referenced by the page and no reference is missing. The section index links `milne-simpsons-method/`.
- Both scripts run, and both GIFs regenerate byte-identically from scratch copies. The director also regenerated them byte-identically while building the page.

## Claim ledger (whole page)

C = confirmed. Every entry was checked against the reviewer's own computation or the frames.

**Description (lines 12–34)**
- The grid, the multistep structure, the predictor and corrector formulas (weights $[0, 8/3, -4/3, 8/3]$; `lte.py`), two evaluations of f per step, RK4 starting values, local error $O(h^5)$ and global $O(h^4)$ (local error constants $14h^5/45$ and $-h^5/90$), and weak stability with a sign-alternating error. **C**

**Animations introduction (lines 38–48)**
- The scripts run the Algorithm; $e_k$ is exact minus computed; eleven examples and one animation; the mapping of Mathews' examples; Case 2 is new; the images of Example 11 are lost (gr_169–189 are absent). **C**

**Case 1 (lines 52–82)**
- The 21 values of m match the legacy labels. The opening frame is left out and the last frame is held (23 frames, 21 distinct). **C**
- The reference value 0.008119920 (line 60). **C**: mpmath `odefun` gives 0.00811992046486796, DOP853 gives …977, and the script gives …794.
- Mathews' window was about −0.2 to 1.72. Only m = 12, 14 and 16 leave it (extremes 1.927, −0.652, −0.757). The window −0.9 to 2.1 holds every value. **C**
- All 21 printed values are reproduced with the real cube root. **C**
- Every run is within 5e-4 up to t = 2.5 (the worst is 4.90e-4). **C**
- For $m\le56$, $|e_k|$ crosses 0.01 after t = 3.2. **C**
- The end values range from 1.9270743 to −0.7571300. **C**
- The list of runs that go negative. **C**
- The non-monotone pairs: 18 vs 16 (0.794 > 0.765), 36 vs 32, 52 vs 48, and 70 vs 60. **C**
- For m = 40–56 the tail error is at most 0.082 (the maximum is 0.0812). **C**
- From m = 60 on, the error is below 0.01 everywhere. **C**
- At m = 60, the end-value error is 1.105e-5 while the error at t = 4.917 is 3.530e-3. **C**
- For m = 100, 120 and 150 the largest error is 3.395e-6, 1.342e-6 and 4.41e-7, at t ≈ 3.3. **C**
- The source link, the embed and the alt text. **C**

**Case 2 (lines 84–105)**
- The parameters, colours, log scale, exact solution, frame pacing (50 frames plus 8 held), marker fill matching the sign, and RK4 points. **C**
- "One step size per plot". This is F3.
- $h\lambda = -0.5$ lies inside the stable interval (the largest root modulus is 0.7758). **C**
- The peak $|e_6| = 3.30\times10^{-3}$ at t = 0.6. **C**
- "Dies out, with ups and downs, to $2.25\times10^{-8}$" (2.2454e-8). **C**
- For h = 0.05:
  - its error is smaller at every common point up to t = 0.6, and alternates in sign from t = 0.6. **C**
  - it grows at every step from t = 2 (in fact from t = 1.65). **C**
  - the growth factor is 1.0182308, which equals the parasitic root, and $e_{100} = -2.9671\times10^{-4}$. **C**
  - its error is the larger from t = 1.8 on. **C**

**The method, weak stability and the Algorithm (lines 111–228)**
- Equations (1)–(3), the theorem, the constants 28/90 and −1/90, equation (5), the modifier, and the Algorithm, which matches gr_41 and both scripts. **C**
- Equation (6) is exactly 3 times the reviewer's polynomial. **C**
- The roots at z = 0 are 1, −1, 0, 0. **C**
- "Through $z^3$". This is F2.
- Expansion (7). **C**
- The growth $\approx e^{|\lambda|t/3}$. **C**
- The stable interval is (−0.8442699, −0.3), the root is exactly −1 at z = −0.3, and the complex pair leaves the unit circle below −0.8443. **C**

**Example 1 (lines 237–321)**
- The exact solution (residual ≤ 1e-40). **C**
- Every intermediate value agrees to 10 digits. **C**
- Every table entry is right except row 25 (F1).
- The maximum $e_8$ = 1.3196e-4, the sign pattern, and the minimum −4.82e-5 at t = 3. **C**
- The m = 50 values. **C**
- The order table: 1.320e-4 down to 2.922e-11, with ratios 27.44, 24.00, 20.86, 18.78 and 17.50. **C**

**Example 2 (lines 323–376)**
- The exact solution, the RK4 values, $p_4$ and $y_4$. **C**
- All 51 values match Mathews' gr_91. **C**
- The $h = 0.1$ row is right except $(4,5]$ (F1).
- The $h = 0.05$ row. **C**
- $y_{50}$, $e_{50}$, $y_{100}$ = 6.00029671, the ratio 13214, the alternation and the factor 1.01823. **C**
- The root moduli. **C**
- The refinement table, −2.967e-4 down to −2.209e-6. **C**
- The alternation onsets. **C**

**Example 3 (lines 378–418)**
- The Bessel solution and its series. **C**
- y(0.5) = 2.0669997121 and y(0.9) = 14.3048643328. **C**
- $t^*$ = 0.96981065. **C**
- The whole table, including 4.08e7, 6.85e50 and the overflow. **C**
- The ratios 10.2 and 13.2, and the shortfalls 17.5%, 4.59% and 0.620%. **C**
- The overflow behaviour, and the comparison with Mathews' point counts. **C**

**Example 4 (lines 420–470)**
- The reference (DOP853 and mpmath agree to 1e-17). **C**
- The peak 1.449767 at t = 0.8836. **C**
- The m = 20 starting values, and all 21 $y_m$ and $e_m$. **C**
- The crossing times, the negative runs, 27.7%, the monotone decrease from m = 80, and the bound 3.4e-6. **C**
- $f_y(5)$ = −41.255. **C**
- The crossings at 2.646 and 4.263. **C**

**Implementation Notes (lines 474–488)**
- All five bullets. **C**

## Implementation checks

**milneaa.jl**
- **Method.** It runs the unmodified Milne-Simpson predictor-corrector in predict-evaluate-correct-evaluate form after an RK4 start (lines 50–52). This matches Mathews' gr_41.
- **Numbers.** All 21 runs agree with the reviewer's own Python code:

  | m | script $y_m$ | reviewer | script max $\|e\|$ | reviewer |
  |---|---|---|---|---|
  | 12 | 1.927074 | 1.9270743479 | 1.919 at t = 5 | same |
  | 16 | −0.7571300 | −0.7571299626 | 1.314 at t = 4.688 | same |
  | 36 | −0.08058300 | −0.0805829978 | 0.3249 at t = 4.861 | same |
  | 60 | 0.008130975 | 0.0081309748 | 0.00353 at t = 4.917 | same |
  | 100 | 0.008119240 | 0.0081192402 | 3.395e-6 at t = 3.3 | same |
  | 150 | 0.008119920 | 0.0081199204 | 4.408e-7 at t = 3.3 | same |

- **Reference.** BigFloat RK4 with Richardson extrapolation gives y(5) = 0.00811992046486794, against 0.00811992046486796 from mpmath. The drawn curve is within 2.3e-11 of the reference at the grid points.
- **Picture.** Frames 001, 010, 015 and 021 were checked. The titles, markers, labels and error-panel title match the computed values. The script's asserts pass, so nothing is clipped.

**milnebb.jl**
- **Method.** The same routine, applied to $f = 30 - 5y$.
- **Numbers:**

  | quantity | script | reviewer |
  |---|---|---|
  | $e_{50}$ | 2.245e-8 | 2.2454e-8 |
  | max $\|e\|$ | 3.298e-3 | 3.2983e-3 |
  | min $\|e\|$ | 6.903e-9 | 6.903e-9 |
  | $e_{100}$ | −2.967e-4 | −2.9671e-4 |
  | h = 0.1 value at frame 7 | −2.397e-6 | −2.3967e-6 |

  The growth ratio of 1.0182308 equals the independently derived root.
- **Reference.** $6-5e^{-5t}$ satisfies the equation and y(0) = 1. The error is formed in BigFloat.
- **Picture.** Frames 012 and 058 were checked. The marker fill matches the sign of $e_k$, the labels use the correct index, and the window holds every value.

The reviewer's scratch work is in `$WORK/review-batch-1/milne-simpsons-method/reviewer-calib/` (session scratchpad): `ms.py`, `ex1.py`–`ex4b.py`, `stab.py`, `lte.py` and the instrumented `aa_instr.jl` and `bb_instr.jl`.
