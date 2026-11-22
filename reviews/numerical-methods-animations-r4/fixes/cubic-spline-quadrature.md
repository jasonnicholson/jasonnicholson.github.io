# Fix record: cubic-spline-quadrature

Scratch evidence: `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r4fix/cubic-spline-quadrature/fix/` (`inst.jl`, `indep.py`).

## Findings

### F1 — Minor — fixed
- **Reproduced:** `julia inst.jl` is an instrumented copy of the script's `natural_spline_M`, `spline_eval` and `spline_integral` with the plotting removed. It evaluates S − f on a 200 001-point grid for each m = 3:2:41. `/usr/bin/python3 -I indep.py` runs the same check independently with SciPy `CubicSpline(bc_type='natural')`. The two agree on every row:
  - Peak of f: x = 0.08038, f = 1.919756.
  - Largest |S − f| and where it occurs:

    | m | gap | x |
    |---|---|---|
    | 3 | 0.877303 | 0.07677 |
    | 5 | 1.110844 | 0.09648 |
    | 7 | 1.089948 | 0.09446 |
    | 9 | 0.860458 | 0.07649 |
    | 11 | 0.673649 | 0.06162 |
    | 21 | 0.304823 | 0.02837 |
    | 41 | 0.156876 | 0.01285 |

  - From m = 5 to 41, x moves left at every step (SciPy run, "left" flag on every row from m = 7).
  - S − f < 0 at the maximum for every m.
  - At m = 41, max S − max f = +0.0267 (S = 1.9464 against f = 1.9198), and S − f at the peak x is +0.0241.
  - sympy: f′ = −e^{−x}sin(8x^{2/3}) + 16e^{−x}cos(8x^{2/3})/(3x^{1/3}), and the limit as x → 0⁺ is ∞.
  - The finding holds. Every number on the page was right; the text only implied the wrong location for the later gaps.
- **Change:** `index.qmd`, the Case 1 Behavior paragraph.
  - Before: "From $m=5$ on it falls at every step, to 0.16 at $m=41$."
  - After: "From $m=5$ on it falls at every step, to 0.16 at $m=41$, but it does not stay at the peak: it moves left onto the steep rise next to $x=0$, where the $x^{2/3}$ term gives $f$ an infinite slope, to $x\approx0.06$ at $m=11$, $0.03$ at $m=21$ and $0.013$ at $m=41$. At $m=41$ the spline's overshoot of the peak value is only 0.03."
- **Check:** I compared every number and quantifier in the new text with the outputs above (see the ledger). The sentence states only where the gap is and that the slope there is infinite. It does not claim that the infinite slope causes the gap, because I did not isolate that mechanism.

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| Behavior, Case 1 | "it does not stay at the peak: it moves left" (from m=5 on) | `indep.py` → argmax x strictly decreasing from m=5 (0.09648) to m=41 (0.01285); `inst.jl` gives the same x values | yes |
| Behavior | "onto the steep rise next to $x=0$" | `inst.jl` → for m≥11 the argmax x < x_peak = 0.08038, and f there is below the peak (1.8917 at m=11, 1.6584 at m=21, 1.4195 at m=41). f is increasing on (0, x_peak) | yes |
| Behavior | "the $x^{2/3}$ term gives $f$ an infinite slope" | `indep.py` sympy → lim_{x→0+} f′ = oo; the singular term is 16e^{−x}cos(8x^{2/3})/(3x^{1/3}) | yes |
| Behavior | $x\approx0.06$ at $m=11$ | 0.06162 (Julia and SciPy) | yes |
| Behavior | $0.03$ at $m=21$ | 0.02837 | yes |
| Behavior | $0.013$ at $m=41$ | 0.01285 | yes |
| Behavior | "At $m=41$ the spline's overshoot of the peak value is only 0.03" | `indep.py` → max S − max f = +0.0267 at m=41; `inst.jl` → max S = 1.9464, f_peak = 1.919756 | yes |
| Behavior (unchanged) | 0.16 at m=41, 1.11, 1.09, 0.88, 0.71, 0.0061 | `inst.jl` → 0.156876, 1.110844, 1.089948, 0.877303. The L1 values are from the review ledger, which I did not re-run because the text is unchanged | (unchanged) |

## Scripts and GIFs
- No script changed and no GIF regenerated. The animation was right; only the text was fixed (D7).
- `git status --short -- pages/numerical-methods/cubic-spline-quadrature` → ` M pages/numerical-methods/cubic-spline-quadrature/index.qmd` only.

## Legacy archive
I consulted it. `n2003/splinequad/SplineQuadMod/Links/SplineQuadMod_lnk_7.html` (Example 6, Animation 1, "Natural Cubic Spline Quadrature") lists m = 3, 5, …, 41 sample points, which matches the script's `m_seq`. The archive says nothing about where the interpolation error is largest, so it has no bearing on this fix. The review had already found that the archive's tabulated integrals match the GIF.

## Notes
- I did not add the review's optional convergence-rate sentence (the m=21→41 error ratio of 3.87, about O(h²)). The page claims no rate, the finding does not require one, and D1's "correct the Behavior using a measured order" is about pages that state a textbook rate. If Jason wants every quadrature page to carry D1's cause sentence, this page would need it added: the integral error falls by about 3.9 when h is halved from m = 21 to m = 41 (review figure, not re-run here).
- The intro still says "Each animation below" although there is only one case. This is wording only and not a finding (review ledger #8). I left it unchanged.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- The fix leaves the original sentence as it was (every number in it was right) and adds a clause. The clause says the largest gap leaves the peak and moves left onto the steep rise next to x=0, at x≈0.06 (m=11), 0.03 (m=21) and 0.013 (m=41). It then says the spline overshoots the peak value at m=41 by only 0.03. The reader can no longer take the 0.16 at m=41 for an error at the peak.
- Independent computation (`check/indep.py`, SciPy `CubicSpline(bc_type='natural')` on a 2 000 001-point grid of [0,2]) for every m = 3, 5, …, 41. The location of the largest |S−f| is 0.0768, 0.0965, 0.0945, 0.0765 for m=3–9, then 0.0616 (m=11), 0.0507, 0.0427, 0.0367, 0.0320, 0.0284 (m=21), …, 0.0129 (m=41). It falls at every step from m=5 on. S<f at the largest gap for every m. The values match the original review's ledger exactly.
- Peak of f, from mpmath `findroot` on f′: x=0.080384, f=1.919756. The largest gap at m=11 (x=0.062) is therefore left of the peak, on the rising flank.
- At m=41, max S − max f = 0.02666. Max S is at x=0.0757 (S−f = 0.028 there), and S−f at the f-peak is 0.024. All of these round to 0.03.
- "Infinite slope" holds: f′(x) ≈ (16/3)x^{−1/3} as x→0. The mpmath derivative gives f′(1e-2)=22.5, f′(1e-4)=114.9 and f′(1e-6)=533.3, which grows like x^{−1/3}.
- The GIF is unchanged and consistent with the new text. Full-size frame 21 (m=41) shows the red spline separated from the magenta curve just right of x=0, plus a small overshoot at the peak. In frame 11 (m=21) the visible gap lies on the rising flank left of the peak.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd Case 1 Behavior | "From m=5 on it falls at every step, to 0.16 at m=41" (unchanged part) | max gaps 1.1108, 1.0899, 0.8605, 0.6736, …, 0.1569, strictly decreasing from m=5 | true |
| same | "it does not stay at the peak: it moves left onto the steep rise next to x=0" | argmax x moves monotonically from 0.0965 (m=5) to 0.0129 (m=41), left of the peak at 0.0804 from m=11 on (0.0765 at m=9 is still essentially at the peak) | true |
| same | "the x^{2/3} term gives f an infinite slope" | f′ ~ (16/3)x^{−1/3}; numerical f′ at 1e-2, 1e-4, 1e-6 = 22.5, 115, 533 | true |
| same | x≈0.06 at m=11 | 0.06162 | true |
| same | 0.03 at m=21 | 0.02837 | true (rounded) |
| same | 0.013 at m=41 | 0.01285 | true |
| same | "At m=41 the spline's overshoot of the peak value is only 0.03" | max S − max f = 0.0267; S−f near the peak is 0.024–0.028 | true (rounded) |

### New problems
None. This rests on the following:
- Each number and qualitative claim in the added clause was recomputed independently with SciPy and mpmath.
- The GIF and script are byte-unchanged against HEAD (`git diff --quiet`).
- The full-size frames 6, 11 and 21 agree with the text.
- A small nuance that is not a defect: at m=11 the gap is broad, and S−f at the peak (≈0.65) is close to the maximum (0.67 at x=0.062). So the "moved left" at m=11 is correct but cannot be seen in the frame. The text does not claim that it can.

### Reproducibility and conventions
- Only `index.qmd` changed in the page folder. `splinequadaa.jl` and `splinequadaa.gif` are identical to HEAD, so there is no script to re-run and no regeneration to compare. The changed text is checked against the committed GIF (21 frames extracted).
- The fix changed nothing outside the page folder. The other modified pages and the untracked review files in the working tree belong to other fixers' work packages, not to this diff.
- Conventions are kept: Description before Animations, one Julia source link and one GIF embed for the single case, descriptive alt text unchanged, no code blocks (0 fences).

**Final status:** committed
