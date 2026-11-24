# Review: Fourier series (batch 1, round 2)

**Result: 0 Error, 0 Misleading, 4 Minor** (unverified, as the review skill allows for Minor findings). This was a fresh, independent review; no earlier report was read.

As in round 1, the page was split between two reviewers:
- the continuous series: the Description's series part, Cases 1–5 and Examples 1–2;
- the discrete series: Cases 6–8, Examples 3–7 and the Implementation Notes.

All eight scripts run the methods the page names. Every per-frame value and every tabled number matches independent computation (sympy, mpmath, scipy, numpy FFT). All eight GIFs regenerate byte-identically.

The legacy archive was consulted by both reviewers: the module page and Links, both animation index pages and their formula images, and the frames of all four surviving GIFs.

The discrete reviewer queried line 266's "3.70189" in passing, having computed 3.70185 with a derivative-root refinement it flagged as possibly imprecise. The continuous reviewer got 3.7018934 at x = 6.15955, and the director independently got 3.70189341767565 at x = 6.15955207 (mpmath at 30 digits: coefficients by quadrature, root of S′). The page is right; this is not a finding.

## Findings

### S1. Minor (page match): "does not shrink" should be "does not tend to zero"
- **Where:** line 165, "the largest overshoot of $S_m$ beside the jump does not shrink as $m$ grows; it tends to … ≈ 0.0895 J".
- **What is true:**
  - In Case 3 on the same page (the step), max S_m − 1 falls at every frame: 0.2732, 0.2004, 0.1884, …, 0.1795. It tends to 0.17898 from above.
  - Line 60 says correctly that it "falls at every frame".
  - The overshoot does not tend to zero, but it can shrink.
- **Fix:** "…does not tend to zero as $m$ grows; it tends to …".

### S2. Minor (page match): "1 + 0.0895 × 2 = 1.17898" does not compute as written
- **Where:** line 268, "the same theorem predicts a peak of $1 + 0.0895 \times 2 = 1.17898$".
- **What is true:** the written arithmetic gives 1.1790. The value 1.17898 needs the unrounded constant: 1 + 2(Si(π)/π − ½) = 1.1789797.
- **Fix:** "$1 + 2\left(\tfrac1\pi\operatorname{Si}(\pi)-\tfrac12\right) = 1.17898$", or use ≈ in both places.

### D1. Minor (fidelity of a quotation): the quoted FFT list hides nonzero entries
- **Where:** line 463, "That is why Mathews' list of twelve values reads $3.14159, 1.30273, 0, \ldots, 0, 1.30273$ symmetrically."
- **What is true:** Mathews' printed list (gr_258) is {3.14159, 1.30273, 0, 0.174533, 0, 0.0935319, 0, 0.0935319, 0, 0.174533, 0, 1.30273}. The elision "0, …, 0" hides the nonzero j = 3 and j = 5 entries, which the page's own Y_j table shows.
- **Evidence:** numpy FFT, (2/12)Y = [3.141593, 1.302731, 0, 0.174533, 0, 0.093532, 0, 0.093532, 0, 0.174533, 0, 1.302731].
- **Fix:** quote the full list.

### D2. Minor (page text): the Description leaves out the scale and sign
- **Where:** line 32, "These sums are the real and imaginary parts of the discrete Fourier transform of the data…"
- **What is true:** a_j = (2/n) Re Y_j and b_j = −(2/n) Im Y_j in the numpy/MATLAB/FFTW convention. Equation (10) and the Implementation Notes (line 504) state this exactly; only the Description omits the factor and the sign. Without the minus sign, b_j would come out with the wrong sign.
- **Fix:** "These sums are, up to the factor 2/n and the sign of the imaginary part, the real and imaginary parts of the discrete Fourier transform of the data (see (10))…".

## Unresolved

None.

## Inventory (Phase 1)

- **Scripts:** 8 scripts, one per GIF.
- **Frame counts (decoded / distinct):**
  - fourierseries aa and cc: 18 / 14
  - fourierseries bb, dd and ee: 30 / 26
  - fourierfft cc: 14 / 10
  - fourierfft dd and ee: 22 / 18
- Every file is referenced by the page and no reference is missing. The section index links the page.
- All eight GIFs regenerate byte-identically.

## Continuous half: claim ledger and implementation checks

### Claim ledger (continuous half): 102 entries
100 confirmed and 2 Minor (S1, S2). None is wrong at its stated precision, and none is "could not determine".

**Description and introduction (entries 1–29)**
- Euler's formulas: mpmath quadrature agrees to 1e-30.
- The overshoot constant Si(π)/π − ½ = 0.089490.
- The degree steps by one or two, with even-j terms (j ≥ 2) zero.
- The first frame shows f alone, and the last frame is held.
- Colours as Mathews drew them.
- The excess tends to the Gibbs overshoot, and for Case 2 it is 0.440676 at m = 25.
- The legacy facts: 5 + 5 animations; the formula images |x−π|, x−π, step, (x−π)², x−|x−π|; four GIFs survive; the FFT index list matches the Fourier-series list entry for entry; the md5 of gr_5 is c317aa9d…

**Cases 1–5 (entries 30–69)** — every value in the text, titles and alt text:
- Case 1: 0.297557, 0.105156, 0.024473, monotone.
- Case 2:
  - the peak lies at 2π − π/(m+1) for every m and rises every frame from 2 to 3.582269;
  - the overshoot from the line is 0.547711 and 0.561507;
  - the Gibbs value is 0.562281.
- Case 3:
  - 1.273240, 1.188357, 1.179473, falling every frame;
  - the peaks lie π/(m+1) from the jumps;
  - 8.97% of the jump remains.
- Case 4: 2.579736, 0.725292, 0.156843, with the maximum at x = 0, which equals the tail sum.
- Case 5:
  - S_m(0) falls from 0.297557 to 0.024473;
  - max S₁ = 3.941690;
  - the range is 3.673143 to 3.734192, alternating;
  - 3.703874 for the Gibbs value;
  - 3.701893 at 6.15955;
  - the alt text's 0.5316–0.5926.

**Fourier Series section (entries 70–102)**
- The definitions and the theorem.
- Example 1:
  - a₀ = π and b_j = 0;
  - a_j = 2(1−(−1)^j)/(πj²);
  - the S₅ decimals;
  - quadrature agreement 6.8e-16;
  - the table to 6 decimals;
  - the tail sums 0.10515614, 0.024473327 and 0.0063659855 against 2/(πm), with the ratio 0.990 at m = 99.
- Example 2:
  - the five-row coefficient table (sympy);
  - S₂₅(0) = 0.024473 and S₂₅(π) = 3.117119;
  - 3.701893, which is 0.560301 above π;
  - 0.565145 at 0.12277;
  - at m = 400, 0.562096 and 0.562471.
- The step function: 1.180010 and 1.179012.

### Implementation checks (fourierseriesaa–ee.jl)
- **Method.** Each script evaluates the Fourier partial sum (3) with closed-form Euler coefficients, which match sympy exactly.
- **Numbers.** Every per-frame title value (13 + 25 + 13 + 25 + 25 of them) agrees to at least 6 decimals with `check_cases.py`, which uses a 200001-point grid plus scipy refinement. For example:
  - cc: m = 17 gives 1.1800099870;
  - dd: m = 17 gives 0.2285093032;
  - ee: m = 25 gives 3.7018934177.
- **Reference.** f is drawn from its definition, with a NaN break at π in Case 3. The Gibbs constants come from mpmath.
- **Picture.**
  - The contact sheets of all five GIFs were checked, plus the full-size frames aa/005, bb/030, cc/018, dd/003 and ee/030.
  - Titles and legends are correct.
  - The y-limits hold everything; for Case 5 they are (−3.909, 4.386).
  - The `%.4g` and `%#.5g` labels never print 0.0.
  - All five GIFs regenerate byte-identically.
- **Outside this half.** The cross-references (S₁₇ peak 1.180010, 0.2285, 3.702, and the Fourier b₁₇ and a₁₇ values) are consistent.
- **Scratch.** `reviewer-series/`: `check_coeffs.py`, `check_cases.py`, `check_examples.py`, `check_quad.py`, `instr_*.jl`.


## Discrete half: claim ledger and implementation checks

### Claim ledger (discrete half): 98 entries
- 96 confirmed.
- 2 are Minor findings: entry 3 (D2) and entry 80 (D1).

Highlights:

**Description and introduction**
- The formulas match the scripts.
- The normal matrix is diag(12, 6, …) with off-diagonal entries of at most 5.6e-15.
- Script and numpy FFT coefficients differ by at most 1.6e-15, 6.0e-15 and 4.6e-15.
- Mathews' degree sequences and midpoint samples were read from his frames.
- The FFT index list matches the Fourier-series index entry for entry (dots cya/pur/red/bro/ora; widths 97, 80, 167, 94, 113), and both gr_5 images have md5 c317aa9d…

**Case 6**
- a_j and even b_j are zero.
- max P_m is 1.2700058, …, 1.0650223, strictly decreasing.
- a₁₈ = 0, so P₁₇ interpolates.
- S₁₇ peaks at 1.1800100.

**Case 7**
- a₁₈ = 0.0304617420.
- The residual is ±0.0152308710, alternating.
- The error falls monotonically to 0.18556 at m = 12, then rises at every frame to 0.20416 at x = 0.0743.
- S₁₇ error 0.228509.

**Case 8**
- y₀ = 0.
- 3.9392, 3.6624, 3.7159, 3.6539, 3.6647, then strictly decreasing to 3.3655.
- S₁₇ max 3.701615.
- The minimum is −2.8803723 at 0.2150.

**Discrete section**
- The orthogonality relations, now stated as $1 \le j, l$ for the sine relation.
- Residual (9).
- The aliasing formulas, including the midpoint case summed pair by pair. `alias7.py` reproduces every Example 7 coefficient to 15 or more digits.

**Example 3**
- Exact in sympy.
- Mathews' gr_122 matches.
- P₅ interpolates exactly.
- The comparison gaps: 0.0294919, 0.0330619, 0.0426023.
- The aliasing sums agree to 8.8e-8.
- max|P₅−S₅| = 0.1051561.
- max|f−P₅| = 0.1009092, attained at four symmetric points.

**Example 4**
- The 13-term sums are shifted by π/6.
- Mathews' gr_195 matches.

**Example 5**
- The normal matrix.
- The residual is 1.3e-15, which is below 1e-13.
- Mathews' "wrong" polynomial is reproduced to every printed digit by his own nodes 2πk/13 for k = 0..11 (gr_224, gr_230).
- The endpoint shift for (x−π)² is 0.0119198.

**Example 6**
- (10).
- The Y_j table.
- Mathematica's convention (gr_256/257).
- (2/13)Y₁ = 1.3457985 + 0.3317095i.

**Example 7**
- All 24 coefficients.
- a₀ = 6.5898902 and a₁ = −1.2764766.
- The residuals are at rounding level, below 1e-13.
- The P₁₇ extremes: 1.0650223, −2.8803723 and 3.3654650.
- 0.2042 against 0.2285.

**Implementation Notes**
- All six notes are confirmed.

### Implementation checks (fourierfftcc/dd/ee.jl)
- **Method.** Each script evaluates the discrete sums (6)–(7) directly with n = 36 and the polynomial (8), as the page states.
- **Numbers.**
  - Coefficients agree with numpy FFT to within 6e-15.
  - Every frame value agrees to all printed digits with scipy's bounded minimiser.
  - The mpmath aliasing sums give the same coefficients independently.
- **Reference.** The grey f is drawn with NaN breaks at the jumps. The midpoint samples y₀ (and y₁₈ for the step) are correct.
- **Picture.**
  - Frame sequences: cc has 14 frames (10 distinct); dd and ee have 22.
  - The titles state the midpoint convention.
  - The y-range covers every P_m, so nothing is clamped.
  - The pink periodic-copy dot sits at (2π, y₀).
  - Cosmetic only: `%.4g` prints dd's m = 3 value 1.0995 as "1.1".
- **Fidelity.** The three surviving Mathews FFT animations are rebuilt with his n, degree sequences and picture elements. His Examples 2–5 are all present, with his printed numbers reproduced. The lost FFT1 and FFT2 are acknowledged, with the evidence stated.
- **Scratch.** `reviewer-discrete/`: `ex7.py`, `fourier_S.py`, `ex3to6.py`, `alias7.py`, `cmpfft.py`, `inst_*.jl`, `coef_*.jl`, plus the legacy frames.
