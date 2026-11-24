# Padé Approximation — animation review (round 8)

Page: `pages/numerical-methods/pade-approximation/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every check below passed. I found no Error, no Misleading and no Minor finding.

The two observations that came closest (neither is a finding):

- *Pole rendering with a small residue* (e.g. Case 27 `[1/1]`, pole near x = 1.6). On the
  900-point grid, the sample next to the pole on one side is only about -0.25, so the
  curve shows a one-sided spike rather than a full ±∞ asymptote. This is a sampling
  limitation of the plot. It is not wrong, and the page makes no claim about it.
- *MATLAB timing sentence.* The page says `[1/15]`, `[1/16]`, `[1/17]` for `e^x` about 0 take
  "about 7, 31 and 134 seconds in MATLAB R2026a". Re-running the same call
  (`digits(20)`, `vpa`, `pade(f,x,0,'order',[1 n])`) on this machine gave 9.3 s, 43.2 s and
  217.2 s (and 2.3 s for `[1/14]`). Every entry ran 1.3-1.6x slower than the page's figure, which is consistent with a slower or busier
  machine (other jobs were running). The growth of about 4-5x per step matches. Timings depend on
  the machine, so this is not a finding.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `pade_animations_all.jl` | 0 | 115.5 | 27 GIFs (pade01.gif … pade27.gif) | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `pade01.gif` | 66 | byte-identical | pade_animations_all |
| `pade02.gif` | 66 | byte-identical | pade_animations_all |
| `pade03.gif` | 66 | byte-identical | pade_animations_all |
| `pade04.gif` | 66 | byte-identical | pade_animations_all |
| `pade05.gif` | 66 | byte-identical | pade_animations_all |
| `pade06.gif` | 66 | byte-identical | pade_animations_all |
| `pade07.gif` | 66 | byte-identical | pade_animations_all |
| `pade08.gif` | 66 | byte-identical | pade_animations_all |
| `pade09.gif` | 66 | byte-identical | pade_animations_all |
| `pade10.gif` | 66 | byte-identical | pade_animations_all |
| `pade11.gif` | 66 | byte-identical | pade_animations_all |
| `pade12.gif` | 45 | byte-identical | pade_animations_all |
| `pade13.gif` | 66 | byte-identical | pade_animations_all |
| `pade14.gif` | 66 | byte-identical | pade_animations_all |
| `pade15.gif` | 66 | byte-identical | pade_animations_all |
| `pade16.gif` | 66 | byte-identical | pade_animations_all |
| `pade17.gif` | 45 | byte-identical | pade_animations_all |
| `pade18.gif` | 66 | byte-identical | pade_animations_all |
| `pade19.gif` | 66 | byte-identical | pade_animations_all |
| `pade20.gif` | 66 | byte-identical | pade_animations_all |
| `pade21.gif` | 66 | byte-identical | pade_animations_all |
| `pade22.gif` | 45 | byte-identical | pade_animations_all |
| `pade23.gif` | 45 | byte-identical | pade_animations_all |
| `pade24.gif` | 45 | byte-identical | pade_animations_all |
| `pade25.gif` | 45 | byte-identical | pade_animations_all |
| `pade26.gif` | 45 | byte-identical | pade_animations_all |
| `pade27.gif` | 45 | byte-identical | pade_animations_all |

### Page references

- Scripts linked: `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`
- GIFs embedded: 27
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

### Description

| # | Claim (page's words) | Verdict | Evidence |
|---|---|---|---|
| D1 | "R_{m,n}(x)=P_m(x)/Q_n(x), Q_n(x_0)=1" | confirmed | `pade_linear` sets q0 = 1 and p has m+1 coefficients, q has n+1 (lines 340-373) |
| D2 | "chooses coefficients so the Taylor expansion of R_{m,n} about x_0 matches the target function through order m+n" / "f^(k)(x0)=R^(k)(x0) for k=0..m+n" | confirmed | Toeplitz rows k = m+1..m+n plus the convolution for p. My exact Baker-form construction (sympy) agrees with every non-degenerate frame (section 3) |
| D3 | "When Taylor coefficients vanish, as for even or odd functions or when f(x0)=0, some entries [m/n] have no such R_{m,n}" | confirmed | Degenerate (non-existent) entries occur in exactly cases 05 (log x, f(1)=0: 10), 07 (log(1+x): 10), 08 (20), 09 (15), 12 (14), 14 (e^{-x}cos x, a2=a6=a10=0: 2), 15 (15), 16 (20), 17 (14), 18 (15), 19 (20), 20 (15), 21 (6), for 176 in all. No other case has any. All agree with the exact existence test |
| D4 | "Those frames show the lower-order entry that takes their place in the Padé table, which matches f only to a lower order, and the legend says so" | confirmed | For all 176 degenerate frames, the drawn rational equals the exact reduced (Frobenius) form. The legend's `= [l/mu]` equals its exact numerator/denominator degrees, with l+mu < m+n. The exact test shows that it does not reach order m+n |
| D5 | Example legend "Padé [2/1] = [1/0] (degenerate)" | confirmed | Appears in cases 08, 12, 14, 16, 17, 19, 21 (dump `PQ 2 1`); seen in the pade12 frame |
| D6 | Rational functions can have poles and horizontal asymptotes; polynomials cannot | confirmed | elementary |
| D7 | "for √x about x0=5, the [4/6] system has condition number about 1.5×10^11" | confirmed | script `cond(B)` = 1.5109e11; numpy `np.linalg.cond` on independently built B = 1.51092e11 |
| D8 | Denominator system "is singular for some entries [m/n], the degenerate entries described above" | confirmed | All 176 exactly singular B (exact det = 0, cases 1-21; none in 22-27, whose smallest singular value ratio at 60 digits is far from 0) are exactly the 176 degenerate entries. No singular-but-consistent entry exists in this table |
| D9 | MATLAB `pade` timings 7 / 31 / 134 s for [1/15], [1/16], [1/17] | confirmed approximately | 9.3 / 43.2 / 217.2 s here (uniformly 1.3-1.6x slower) (`review/padetime.m`, `review/matlab_time.txt`). Depends on the machine |
| D10 | "`padeapprox` from chebfun also struggles"; general accuracy remarks | could not determine / opinion | chebfun not run. Not a checkable numerical claim |

### Animations section

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| A1 | "Each animation shows one Padé order per frame for a fixed center x0, overlaid on the target function" | confirmed | `render_case`: one frame per (m,n), magenta f, blue R, red dot at (x0, f(x0)) |
| A2 | Mathews' surviving animations "stepped along the diagonal (or next-to-diagonal) entries ... up to total order 18, and marked a tolerance interval" | confirmed | 11 surviving legacy GIFs: labels S_{k,k} / S_{k,k-1}, last frames S9,9 (aa, qq, hh), S9,8 (rr, kk), S8,8 (pp), S5,5 (ll), each with a "Tolerance ±0.001/0.01" green bar |
| A3 | "step through every entry [m/n] with m+n≤10 (m+n≤8 in Cases 12, 17 and 22–27)" | confirmed | `max_total` column; `order_pairs`. Frame counts 66 (=C(12,2)) for 19 GIFs and 45 (=C(10,2)) for pade12, 17, 22-27 (manifest and dump) |
| A4 | Case 01 √x, x0=1, [0,10.5] | confirmed | row 24; title "Case 01: f(x) = sqrt(x), x0 = 1.0"; archive row 1 |
| A5 | Case 02 √x, x0=4, [0,10.5] | confirmed | row 25; title; archive |
| A6 | Case 03 √x, x0=5, [0,10.5] | confirmed | row 26; title; archive |
| A7 | Case 04 1/√(1-x), x0=0, [-1.5,1.5] | confirmed | row 27; title; archive |
| A8 | Case 05 log x, x0=1, [-0.5,4.1] | confirmed | row 28; title; archive |
| A9 | Case 06 log x, x0=2, [-0.5,4.1] | confirmed | row 29; title; archive |
| A10 | Case 07 log(1+x), x0=0, [-1.5,1.5] | confirmed | row 30; title; archive |
| A11 | Case 08 sin x, x0=0, [-3π,3π] | confirmed | row 31; title; archive |
| A12 | Case 09 cos x, x0=0, [-3π,3π] | confirmed | row 32; title; archive |
| A13 | Case 10 sin x, x0=π/4, [-7π/4,9π/4] | confirmed | row 33; title "x0 = 0.7854"; archive |
| A14 | Case 11 cos x, x0=π/3, [-5π/3,7π/3] | confirmed | row 34; title "x0 = 1.0472"; archive |
| A15 | Case 12 tan x, x0=0, [-π,π] | confirmed | row 35; title; archive |
| A16 | Case 13 e^x, x0=0, [-2,3] | confirmed | row 36; title; archive |
| A17 | Case 14 e^{-x}cos x, x0=0, [-2,4] | confirmed | row 37; title; archive |
| A18 | Case 15 cosh x, x0=0, [-4,4] | confirmed | row 38; title; archive |
| A19 | Case 16 arctan x, x0=0, [-2,2] | confirmed | row 39; title; archive |
| A20 | Case 17 arcsin x, x0=0, [-1.5,1.5] | confirmed | row 40; title; archive |
| A21 | Case 18 J0, x0=0, [-10.2,10.2] | confirmed | row 41; title; archive |
| A22 | Case 19 J1, x0=0, [-10.2,10.2] | confirmed | row 42; title; archive |
| A23 | Case 20 normal pdf, x0=0, [-3,3] | confirmed | row 43; title "normal_pdf(x)"; archive |
| A24 | Case 21 ½+½erf(x/√2), x0=0, [-3,3] | confirmed | row 44; title "normal_cdf(x)"; archive |
| A25 | Case 22 Γ, x0=1, [-0.2,5.2] | confirmed | row 45; title; archive |
| A26 | Case 23 Γ, x0=2, [-0.2,5.2] | confirmed | row 46; title; archive |
| A27 | Case 24 Γ, x0=3, [-0.2,5.2] | confirmed | row 47; title; archive |
| A28 | Case 25 Y0, x0=10, [0,22] | confirmed | row 48; title; archive |
| A29 | Case 26 Y0, x0=5, [0,22] | confirmed | row 49; title; archive |
| A30 | Case 27 Y0, x0=2, [0,22] | confirmed | row 50; title; archive |
| A31 | 27 alt texts (function, centre, interval where stated) | confirmed | each matches its heading and row |
| A32 | Wiring: each "Julia source" link → `pade_animations_all.jl`; each embed `padeNN.gif` is Case NN | confirmed | the title of each GIF's first frame reads "Padé Case NN" with the matching function and x0 (`review/titles.png`). All committed GIFs are byte-identical to a fresh run (manifest) |

Fidelity: the 27 cases are in the archive's order, with the archive's functions, centres and intervals
(`review/legacy/cases_1.png`, `cases_2.png`). The page states its one deliberate departure (it steps
through the full table to m+n≤10 or 8 rather than the diagonal to 18, with no tolerance bar).
No fidelity finding.

### 3. Implementation checks (`pade_animations_all.jl`)

Method: instrumented copy `review/dump.jl` (plotting removed, otherwise the same code) prints,
for every case and every (m,n), the Taylor coefficients, p, q, cond(B) and the legend note
(`review/dump.txt`, 1614 entries). Independent check `review/indep.py` / `indep2.py`:

- Taylor coefficients come from `sympy.series` of the actual function about x0 (cases 1-21, exact),
  and from `mpmath.taylor` at 60 digits (Γ and Y0, cases 22-27).
- Padé (cases 1-21): the exact Baker form. A nullspace vector q of the n×(n+1) homogeneous system
  gives p from the convolution, and `sympy.cancel` gives the reduced rational. **Existence** means
  the reduced form fits in [m/n] and its series matches f through order m+n (exact). **Singularity**
  of B is decided by the exact determinant. For case 06 log 2, and for case 21 1/√(2π), each was
  replaced by a symbol (each is transcendental, so the rank and the identities are those at the true value).
- Padé (cases 22-27): the same linear system solved in 60-digit mpmath, with singular values reported.
- Comparison: R evaluated at 10 offsets z ∈ [-0.9, 2.1], with relative difference max(|ΔR|/max(1,|R|)).
  The legend note and the singular/regular classification were compared exactly.

**It is the method it claims to be.** The script runs the standard linearised Padé construction
(Q(x0)=1, the Toeplitz system for q1..qn, p by convolution). For singular systems it shows the
reduced block entry, which is the standard Padé-table (Frobenius) convention, and labels it. This
is what the Description says.

**The numbers are right.**

| Case | max rel. error of Taylor coeffs (script vs mine) | worst R difference | note / singularity mismatches |
|---|---|---|---|
| 01 | 0 | 1.4e-14 | 0 |
| 02 | 0 | 3.6e-16 | 0 |
| 03 | 0 | 3.9e-16 | 0 |
| 04 | 0 | 2.5e-8 * | 0 |
| 05 | 0 | 3.1e-14 | 0 |
| 06 | 0 | 6.5e-16 ‡ | 0 |
| 07 | 0 | 3.1e-14 | 0 |
| 08 | 0 | 2.2e-16 | 0 |
| 09 | 0 | 1.1e-16 | 0 |
| 10 | 1.5e-15 | 1.7e-15 | 0 |
| 11 | 3.3e-15 | 3.8e-13 | 0 |
| 12 | 0 | 5.7e-16 | 0 |
| 13 | 0 | 1.6e-14 | 0 |
| 14 | 0 | 7.8e-15 | 0 |
| 15 | 0 | 4.3e-16 | 0 |
| 16 | 0 | 9.4e-16 | 0 |
| 17 | 0 | 8.0e-15 | 0 |
| 18 | 0 | 1.1e-16 | 0 |
| 19 | 0 | 1.1e-16 | 0 |
| 20 | 2.1e-16 | 1.1e-16 | 0 |
| 21 | 2.1e-16 | 2.7e-14 ‡ | 0 |
| 22 | 0 | 1.7e-10 † | 0 |
| 23 | 0 | 2.9e-14 | 0 |
| 24 | 0 | 6.9e-14 | 0 |
| 25 | 0 | 3.6e-16 | 0 |
| 26 | 0 | 7.2e-15 | 0 |
| 27 | 0 | 5.3e-15 | 0 |

\* Case 04 `[2/8]`: the sample point z = 1.3 lies 2e-6 from a pole of R (an exact root of Q at
1.2999979). The coefficients agree to about 1e-13 (script q8 = -3.0517578125026e-5, exact -3.0517578125e-5).
This is amplification at the pole, not an error.
‡ Cases 06 and 21: the symbolic run of every entry was slow. These two cases were completed by
`review/fast621.py`. It decides existence, degrees and singularity exactly, with the transcendental
constant replaced by two different rationals (7/10 and 13/29, which give identical results). It
then computes the [m/n] (or reduced [l/mu]) values in 60-digit mpmath with the true log 2 or
1/√(2π). Result: all 66+66 entries match, and the 6 degenerate labels in case 21 are correct.
† Case 22: the largest difference also occurs at a sample point next to a pole. All other entries are ≤ 1e-13.

The script's comment at lines 375-376 also holds: the largest regular cond(B) is 1.511e11
(case 03 [4/6]) and the smallest singular cond(B) is 4.73e16 (case 20 [1/5]), so the 1e14 threshold
classifies every entry correctly. No entry takes the "singular but consistent" branch (line 434-435).
Exactly, the table has no such entry, because all blocks have size ≤ 2.

**Reference values are right.** The "true" curves are the Julia functions `sqrt, log, sin, cos, tan,
exp, cosh, atan, asin, besselj, bessely, gamma, erf` on the stated formulas. Each row's lambda matches
its heading (read line by line, rows 24-50). Off-domain values (sqrt and log for x ≤ 0,
1/√(1-x) for x > 1, asin for |x| > 1, Y0(0) = -Inf) become NaN through `safe_eval`. The Taylor
coefficients are independently exact (table above).

**The picture shows what was computed.** I viewed the contact sheets for pade01, 04, 05, 08, 12, 14, 21,
22 and 27, and the first-frame titles of all 27 (`review/titles.png`). In every frame:
- the blue curve is P(x-x0)/Q(x-x0) of the dumped p, q;
- the red dot is (x0, f(x0));
- the legend `[m/n]` matches the frame order of `order_pairs`;
- degenerate labels appear where the exact test says they should (e.g. sin `[0/3] = [0/0]`
  draws y = 0, and sin `[2/2]` = x/(1+x²/6) peaks at √6/2 ≈ 1.22 at x = √6, as drawn).

Off-scale values are clamped to one y-span beyond the axes, so curves leave the frame and are never
drawn along an edge. Poles show as near-vertical connecting lines, the usual asymptote look. The
NaN mask (|Q| < 1e-8) almost never fires on this grid. None of these display devices changes what a
reader would conclude.

