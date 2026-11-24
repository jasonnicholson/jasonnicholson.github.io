# Review: Fourier series (batch 1, round 1)

**Result: 0 Error, 0 Misleading, 8 Minor** (unverified, as the review skill allows for Minor findings).

The page was split between two reviewers:
- the continuous Fourier series: the Description's series part, Cases 1–5 and Examples 1–2;
- the discrete series / FFT: Cases 6–8, Examples 3–7 and the Implementation Notes.

Each reviewer confirmed the other's numbers in spot checks. Two findings were raised by both reviewers and are merged below (M1 and M4). All eight scripts run the method the page names. Every coefficient, maximum, location and residual in both halves matches independent computation (sympy, mpmath, scipy, numpy FFT), except the rounding-level residuals of M5.

The legacy archive was consulted:
- the module page and Links lnk_2–6 with their output images;
- both animation index pages and their `Images/` folders;
- every frame of the four surviving GIFs (`FourierSeriesee`, `FourierFFTcc`, `FourierFFTdd`, `FourierFFTee`).

## Findings

### M1. Minor (page match): the frame description in the introduction (both reviewers)
- **Where:** line 36, "Each animation … adds one degree per frame. The first frame shows the function or the data alone, and the last frame is held."
- **Degrees:** Cases 1, 3 and 6 step through odd m only (1, 3, …, 25 or 1, 3, …, 17), so they add two degrees per frame. The frames vectors are `[0,0,1,3,5,…]`, and `fourierfftcc.jl` line 36 has `ms = collect(1:2:17)`.
- **First frame:** in Cases 6–8 the first frame also draws the grey graph of f, not only the samples.
- The headings and line 38 do say "odd m", so the harm is small.
- **Fix:** "adds one term per frame (one odd degree at a time in Cases 1, 3 and 6)", and for Cases 6–8, "the first frame shows the samples and f".

### M2. Minor (page match): "the excess is the Gibbs overshoot" does not fit Case 2 at finite m
- **Where:** line 36, "…the largest value max_x S_m(x), to compare with the least upper bound of f; the excess is the Gibbs overshoot."
- **What is true for Case 2** (f = x−π):

  | m | 1 | 2 | 3 | 4 | 5 | 25 |
  |---|---|---|---|---|---|---|
  | max S_m − π | −1.14 (2 − π) | −0.54 (2.598 − π) | −0.26 (2.886 − π) | −0.09 (3.055 − π) | 0.0241 | 0.4407 |

- The Case 2 Behavior paragraph (line 52) and alt text (line 56) quote the overshoot measured from the line: 0.5477 at m=5 and 0.5615 at m=25.
- A reader who applies the intro's rule to the Case 2 title ("max S₂₅ = 3.582 (sup f = π)") gets 0.44, not 0.56. The gap is about π/(m+1) and closes only as m→∞.
- The director confirmed max S₂₅ = 3.58227 independently.
- **Fix:** "…the excess approaches the Gibbs overshoot as m grows; for Case 2, whose f rises to the jump, the Behavior paragraph measures it from the line instead."

### M3. Minor (display): Case 3's labels cannot show the decrease the text describes
- **Where:** `fourierseriescc.jl` line 19 (`fmt(x)=@sprintf("%.4g",x)`), in the frame titles.
- max S_15 … S_23 are 1.180284, 1.180010, 1.179814, 1.179669 and 1.179559. All five print as "1.18".
- Line 60 says the peak "falls at every frame". That is true (strictly decreasing), but the labels cannot show it.
- **Fix:** use `%.5g` for Case 3's label.

### M4. Minor (fidelity wording): the lost discrete-series animations (both reviewers)
- **Where:** line 38. It says the ten animations are "for the functions |x−π|, x−π, a unit step, (x−π)² and x−|x−π|", then says the first two discrete animations are not rebuilt because "their functions cannot be read".
- **What is true:** the FFT index page's formula images gr_1–4 and the GIFs FourierFFTaa and bb are lost. The functions can still be inferred with high confidence:
  - The FFT index page has the same layout as the Fourier-series index.
  - Its formula images have the same declared sizes in the same order (97, 80, 167, 94 and 113 × 17 px).
  - The one surviving image, `FourierFFT_gr_5.gif`, is byte-identical to `FourierSeries_gr_5.gif` (md5 c317aa9d…).
  - The surviving FFT cases use the step, (x−π)² and x−|x−π|.
  - So FFT1 and FFT2 were almost certainly |x−π| and x−π.
- The page's two sentences are inconsistent, and the reason given for leaving those animations out is weak.
- **Fix:** either rebuild them (|x−π|, and x−π with midpoint y₀ = 0, at n = 36), or reword: "…their GIFs and formula images are lost, though the index page's layout indicates they used |x−π| and x−π", and remove the attribution of all five functions to the FFT set in the first sentence.

### M5. Minor (page match): rounding-level residuals quoted to two digits
- **Where:** Example 7, Step 2 table, lines 492 and 494: "$1.1\times10^{-15}$" (step) and "$2.2\times10^{-15}$" (x−|x−π|).
- **What is true:** these residuals are rounding noise, and their size depends on how P₁₇ is evaluated.

  | Method | Step | x−\|x−π\| |
  |---|---|---|
  | The page's own scripts (direct sums) | 5.88e-15 | 1.60e-14 |
  | numpy FFT coefficients, then direct evaluation | 1.11e-15 | 1.78e-15 |
  | numpy `ifft` | 4.4e-16 | 1.3e-15 |
  | Page | 1.1e-15 | 2.2e-15 |

  The x−|x−π| value is not reproduced by any method tried.
- Example 5's "1.3×10⁻¹⁵" (line 437) is reproduced by `numpy.linalg.lstsq` (1.33e-15), but the normal equations give 5.6e-16.
- **Fix:** write "rounding level (below 10⁻¹³)" rather than two-digit values. Optionally do the same at line 437.

### M6. Minor (page match): the sine–sine orthogonality relation fails at j = l = 0
- **Where:** line 311 ("For $0 \le j, l \le m$") with line 316, $\sum_k \sin(jx_k)\sin(lx_k)=\tfrac n2\delta_{jl}$.
- **What is true:** at j = l = 0 the sum is 0, not n/2. The relation holds for 1 ≤ j, l ≤ m.
- No consequence, since b₀ is never used.
- **Fix:** state the sine relation for $1\le j,l\le m$.

### M7. Minor (picture): the first-frame title says yₖ = f(xₖ) where the samples are midpoints
- **Where:** `fourierfftcc.jl` line 99 and `fourierfftee.jl` line 96, which build the title "n = 36 samples yₖ = f(xₖ), xₖ = kπ/18 …" seen in frames 1–2 of those GIFs.
- **What is true:**
  - For the step, y₀ = y₁₈ = 0, while the script's own `f` gives −1 at 0 and +1 at π.
  - For x−|x−π|, y₀ = 0, while the title's own formula gives f(0) = −π.
  - The page text (lines 84, 100 and 473) states the midpoint convention correctly.
- **Fix:** for cc and ee, title the frame "yₖ = f(xₖ), midpoint value at the jumps" or similar. The dd title is correct.

### M8. Minor (page match): the aliasing theorem's hypothesis is narrower than its use
- **Where:** line 333 ("If the Fourier series of f converges absolutely, …") and line 486 ("…the discrete b₁₇ of the two discontinuous functions are much smaller than their Fourier values" because of aliasing).
- **What is true:** the step and x−|x−π| have b_j ~ 1/j, so their series do not converge absolutely and the theorem as stated does not cover them.
- The folding formula still holds for them with midpoint samples. mpmath `nsum` of the folded series gives:

  | Function | Coefficient | Folded sum | Discrete value |
  |---|---|---|---|
  | Step | b₁₇ | −0.009720962614 | −0.009721 |
  | Step | b₁ | −1.270005811 | −1.270006 |
  | x−\|x−π\| | b₁₇ | −0.01526965237 | −0.015270 |
  | x−\|x−π\| | b₁ | −1.994920464 | −1.994920 |

- So line 486 is true, and only the stated hypothesis is too narrow.
- **Fix:** add "(or if f is piecewise smooth and sampled at the midpoints of its jumps, with the folded terms paired)".

## Unresolved

None.

## Inventory (Phase 1)

- **Scripts:** `fourierseries{aa,bb,cc,dd,ee}.jl` and `fourierfft{cc,dd,ee}.jl`, one per GIF.
- **Frame counts (decoded / distinct):**
  - fourierseries aa and cc: 18 / 14
  - fourierseries bb, dd and ee: 30 / 26
  - fourierfft cc: 14 / 10
  - fourierfft dd and ee: 22 / 18
- Every file is referenced by the page and no reference is missing. The section index links `fourier-series/`.
- All eight GIFs regenerate byte-identically.

## Continuous half: claim ledger and implementation checks

### Claim ledger (continuous half): 93 entries
- 89 confirmed.
- Entry 6: wrong (M1). Entry 12: Minor (M2). Entry 14: could not determine (M4).
- Entry 63, "around the Gibbs value 3.704": confirmed. For m ≥ 8 every value lies below it (3.6948–3.7028), which the wording allows.

Confirmed, with the reviewer's values:

**Description**
- The Euler formulas.
- The overshoot Si(π)/π − ½ = 0.0894899.

**Case 1**
- 0.2976, 0.1052 and 0.02447 (0.29755678, 0.10515614, 0.02447333).
- The error equals the tail sum, falls strictly, and is largest at 0, π and 2π.

**Case 2**
- b_j = −2/j.
- The zeros at 0, π and 2π.
- The peak at 2π − π/(m+1), rising strictly from 2 to 3.582269.
- The overshoot from the line: 0.547711 and 0.561507.
- 0.0895·2π = 0.562281.

**Case 3**
- 1.2732395, 1.1883569 and 1.1794732.
- The Gibbs value 1.1789797.
- The peak π/(m+1) from the jump.
- The NaN break at π.

**Case 4**
- a_j = 4/j².
- 2.5797363, 0.7252918 and 0.1568427.

**Case 5**
- S_m(0) from 0.2976 to 0.02447.
- max S₁ = 3.9416904.
- The range 3.6731425 (m=2) to 3.7341916 (m=3).
- S₂₅ peak 3.7018934 at 6.15955.
- The alt text's 0.53–0.59 (0.5316–0.5926).

**Fourier Series section**
- Example 1:
  - a_j = 2(1−(−1)^j)/(πj²);
  - S₅'s coefficients 1.570796, 1.273240, 0.141471 and 0.050930 (these match Mathews' gr_65/66);
  - quadrature agreement 6.8e-16;
  - every table entry to 6 decimals;
  - the tail-sum errors 0.10515614, 0.02447333 and 0.00636599 against 2/(πm), with the ratio approaching 1.
- Example 2: the coefficient table (sympy symbolic equality for j ≤ 12, quadrature agreement ≤ 1.7e-15).
- The x−|x−π| values:
  - S₂₅(0) = 0.024473;
  - S₂₅(π) = 3.1171193;
  - S₂₅ maximum 3.7018934, which is 0.560301 above π;
  - just right of 0, S₂₅ falls 0.565145 below f, at x = 0.12277;
  - at m = 400, 0.562096 and 0.562471.
- The step function: 1.1789797, 1.1800100 and 1.1790118.

### Implementation checks (fourierseriesaa–ee.jl)
- All five scripts share one template and differ only in the parameter block (checked with `diff`).
- **Method.** Each computes the Fourier partial sum (3) with closed-form Euler coefficients, all proved by sympy and checked by quadrature.
- **Numbers.** Instrumented copies print every frame value, and these agree to every printed digit with `framevals.py` (a numpy grid plus 30-digit mpmath roots of the analytic derivative). For example:
  - aa: m = 25 gives 0.0244733271;
  - bb: m = 25 gives 3.5822689890;
  - cc: m = 25 gives 1.1794731707;
  - dd: m = 1 gives 2.5797362674;
  - ee: m = 1, 2, 3, 25 give 3.9416904489, 3.6731425033, 3.7341916341 and 3.7018934177.
- **Picture.**
  - f is drawn from its exact formula, with one-sided limits at the jumps.
  - There is no clamping: the y-limits cover every S_m plus 6%.
  - The legends sit in empty regions.
  - Frame counts are 18/14 distinct (aa, cc) and 30/26 distinct (bb, dd, ee).
  - Case 5 matches the legacy GIF in function, degree sequence and colours.
- **Spot checks outside this half** agree with the page: the Example 7 b_j, the P₁₇ peak 1.065022, a_18 = 0.030462, max|f−P₁₇| = 0.2042, the P₁₇ range −2.880372 to 3.365465, and the Example 3 a_j.
- **Scratch:** `reviewer-series/` (`coeffs.py`, `framevals.py`, `examples.py`, `inst_*.jl`, `outside_quick.py`).


## Discrete half: claim ledger and implementation checks

### Claim ledger (discrete half): 96 entries
- 90 confirmed.
- 6 are Minor findings or partly wrong: I2/I3 (M1), I11 (M4), S5 (M6), S10 (M8), E5.4 and E7.12 (M5).

Key confirmed values:

**Description and introduction**
- D1–D4: the formulas (6)–(7) match the scripts; the DFT relation is given precisely in (10).
- I4–I10, I12: the samples, colours, pink periodic-copy dot and grey f.
- The coefficients agree with numpy FFT to 6 digits.
- Mathews' degree sequences: cc has 10 distinct frames; dd and ee have 18.
- His midpoint samples at (0, 0) and (π, 0).

**Case 6**
- a_j = 0 and even b_j = 0.
- P_m(0) = P_m(π) = 0.
- max P_m falls strictly: 1.270006, 1.191295, 1.169133, 1.151135, 1.132080, 1.111505, 1.090720, 1.073063, 1.065022.
- S₁₇ max = 1.1800100.

**Case 7**
- a₁₈ = 0.030462, and the residual ±0.015231 = a₁₈/2 alternates.
- max|f−P_m| falls monotonically from 2.564490 to 0.185557 (m = 12), then rises to 0.204156 at x = 0.0743.
- S₁₇ = 0.228509.

**Case 8**
- y₀ = 0, P₁₇(0) = 4e-16.
- max P₁ = 3.939150.
- Not monotone for m ≤ 5, then strictly decreasing to 3.365465 at x = 6.0419.
- min −2.880372 at x = 0.21495.
- S₁₇ max = 3.701615.

**Discrete section**
- S1–S4, S6–S9: the trapezoid derivation, the cos·cos relation, the diagonal normal equations, residual (9), and the aliasing identity.

**Example 3**
- a₁ = π(2+√3)/9, a₃ = π/18, a₅ = π(2−√3)/9, all exact in sympy.
- Mathews' gr_102/106.
- P₅ interpolates exactly.
- The comparison table.
- The folded sums agree to 8.8e-8.
- max|P₅−S₅| = 0.1051561.
- max|f−P₅| = 0.100909 at 3.3555. This is one of four symmetric maximisers.

**Example 4**
- The 13-term sums are each shifted by π/6 = 0.523599, which matches Mathews' gr_191/195.

**Example 5**
- MᵀM = diag(12, 6, …), with off-diagonal entries below 5.61e-15.
- Mathews' "wrong" polynomial is reproduced to every digit by fitting the 12 points 2πk/13: 1.5962, 1.30798, 0.0380189, …
- His table lists exactly those points (gr_224, gr_227).
- The (x−π)² endpoint shift is 0.011920.

**Example 6**
- The numpy Y_j table, with conjugate symmetry.
- Mathews' full list (gr_258) and Mathematica's convention (gr_257).
- (2/13)Y₁ = 1.345798 + 0.331710i.

**Example 7**
- Every coefficient in the three rows.
- a₀ = 6.589890 and a₁ = −1.276477.
- The step's P₁₇ peak is 1.065022 at 3.3817.
- The P₁₇ range for x−|x−π|.
- 0.204156 against 0.228509.

**Implementation Notes**
- N1–N6 are all confirmed.

### Implementation checks (fourierfftcc/dd/ee.jl)
- **Method.** Each script computes the discrete sums (6)–(7) directly, O(n²), and evaluates (8) on x_k = 2πk/36 for k = 0..35, without x_n. No FFT package is used, and the page says so.
- **Numbers.** Instrumented copies match numpy FFT for every tabled coefficient, and for max P_m or max|f−P_m| at every m to 6 decimals. Interpolation residuals are 5.9e-15, 0.0152309 and 1.6e-14 (see M5). The scripts' `gridmax` (20,001-point grid plus golden section) agrees with a 2,000,001-point grid refined by scipy.
- **Reference.** f is drawn exactly, with one-sided limits at the jumps. The midpoint samples match Mathews' frames.
- **Picture.** Frames 1, 3, 8, 14 and 22 were checked.
  - Titles and legends show the correct degree and value, for example "max P₁₇ = 1.065", "max |f − P₁₂| = 0.1856" and "max P₆ = 3.626".
  - The y-limits enclose everything: cc ±1.42; dd −1.35 to 10.50; ee −3.57 to 4.36.
  - The frame sequences match Mathews'.
  - The 0.015 miss of P₁₇ in dd is below pixel resolution, and the page does not claim it is visible.
- **Scratch.** `reviewer-discrete/`: `inst_fourierfft*.jl`, `check_ex7.py`, `check_ex3_6.py` and `check_alias.py`, plus extracted legacy frames.
