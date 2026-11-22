# Verification: legendre-polynomials

## A1 — confirmed
- What I checked: `legendre_coeff` (legendrepolybb.jl lines 27–36) says "Gauss-Legendre quadrature" in its comment, but the body is a 1000-point uniform trapezoid rule. I ran the script's own coefficient and error code without plotting, and compared it with c_n = (2n+1)/2 ∫ f P_n computed by mpmath at 40 digits. The max error uses the same 500-point grid as the script, and that grid includes the endpoints.
- Evidence: `verify/script_coeffs.jl` (the script's code, plotting removed) and `verify/ref.py` (mpmath reference).

  | N | script c_N | true c_N | title "max err" | true max err |
  |---|---|---|---|---|
  | 0 | 0.636619248 | 0.636619772 (=2/π) | 0.637 | 0.63662 |
  | 2 | -0.687087893 | -0.687085270 | 0.0505 | 0.0504655 |
  | 4 | 0.0517742319 | 0.0517789537 | 0.00131 | 0.00131346 |
  | 6 | -0.00133727652 | -0.00133045639 (0.5% off) | 3.17e-5 | 1.70005e-5 |
  | 8 | 8.2143e-6 | 1.71322e-5 (52% off, about half) | 2.35e-5 | 1.31692e-7 |

  Odd-N frames repeat the previous error (the script's odd c_N are about 1e-17). Every coefficient has an absolute error of about 1e-6 to 1e-5, which is the O(h²) error of the trapezoid rule; it matters once |c_N| is that small. The committed frames 7–8 show "max err = 3.17e-5" when the truth is 1.70e-5. Frame 9 shows "2.35e-5" when the truth is 1.32e-7, which is 180 times too large. Going from N=6 to N=8 the shown error falls only 1.35-fold, while the true error falls about 130-fold, after earlier steps of about 13, 38 and 77 times. So the animation does look like it stalls at the end, which is wrong. I checked the titles by eye in committed frame_008.png and frame_009.png. The curves are visually the same at this scale, so only the titles carry the error.
- Severity: Error is fair. The titles state numbers that were computed wrongly. The last frame is off by more than two orders of magnitude, and the shape of the convergence it shows is wrong.
- Correction to the allegation: none of substance. The wrong values are in the last three frames (7, 8 and 9). Frames 7–8 are off by about 2 times and frame 9 by about 180 times. The highest coefficient c_8 is off by about 52%; c_6 is off by only 0.5%, but that is enough to roughly double the error shown at N=6.

## A2 — confirmed
- What I checked: I computed the coefficients (exact odd c_n = 0; the script's are about 1e-17) and the per-frame errors. I also compared consecutive committed frames pixel by pixel (`verify/framediff.py`).
- Evidence: The changes from frame 1→2, 3→4, 5→6 and 7→8 lie only in rows 2–76, which hold the title and legend. The 3→4, 5→6 and 7→8 changes are each about 200 pixels. The 1→2 change is about 5800 pixels because "term" becomes "terms" and the title shifts. The plotted S_N curve and the "max err" value do not change, for example 0.637 in both frame 1 and frame 2 (frame_002.png shows a flat line titled "2 terms"). The titles count 2, 4, 6 and 8 "terms", but those frames add nothing. The sentence before it on line 26 does say "Only even-n terms contribute", so the page half-admits this. Even so, "Each added term refines the fit" is false for 4 of the 8 steps.
- Severity: Misleading is fair, and it is minor. A careful reader can reconcile it with the previous sentence, but the sentence and the titles that count terms together suggest a gain at every step.
- Correction to the allegation: "several frames are identical" should read "the curves and errors are identical"; the frames themselves differ in the title count and the legend label (S_1 vs S_0, and so on).
