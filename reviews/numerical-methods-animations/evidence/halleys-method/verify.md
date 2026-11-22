# Verification: halleys-method

## A1 — confirmed
- What I checked: compared the Halley iterate x - 2ff'/(2f'^2 - ff'') (page line 18, scripts line 32) with the root of the second-order Taylor parabola P(t)=f+f'(t-x)+f''/2(t-x)^2 nearest x, in 40-digit mpmath, for both page examples.
- Evidence: verify/check.py. f=x^2-2, x0=2: Halley x1=1.428571428..., parabola root nearest x0 = 1.414213562... (= sqrt 2 exactly, because the Taylor parabola of a quadratic is f itself). f=x^3-3x+2, x0=-2.2: Halley x1=-2.0020619, parabola root = -1.9990985 (on the opposite side of the root -2). The two are different iterates. (The parabola-root iteration is the Euler/Cauchy method, also cubic but distinct; Halley's iterate is the zero of the osculating rational/hyperbola 
  t -> (a + b(t-x))/(1 + c(t-x)), or equivalently what you get by substituting the Newton step into the quadratic term of the Taylor parabola.)
- Severity: Error is fair: line 12 states a false geometric definition of the method.
- Correction to the allegation: none.

## A2 — confirmed with correction
- What I checked: halleysab.jl / halleysba.jl lines 53–56 draw P(t) (Taylor parabola) labeled "osculatory parabola", and lines 81–83 (ab) / 78–79 (ba) mark xs[n+1] from the Halley formula; the line-81 comment calls it "lower root of parabola". Numbers above; zoomed frames.
- Evidence: Case 1b: P coincides with f (fpp=2 constant), so the drawn dashed curve crosses at sqrt 2 = 1.41421, while the orange Halley diamond is at 1.42857; verify/ab1_zoom.png (crop of committed halleysab/frame_001.png) shows the diamond visibly a few pixels right of where the magenta/orange curve crosses the axis. Later frames: offsets 3.6e-7 etc., invisible. Case 2: parabola crosses at -1.99910, Halley marker at -2.00206: mathematically different (and on opposite sides of the root) but ~0.4 px apart in the frame, so not visible.
- Severity: Error is fair for the construction drawn/described (lines 44, 62, 70 and the script comment at line 81 present a construction that does not produce the marked iterate); the plotted iterate values themselves are correct Halley iterates.
- Correction to the allegation: the mismatch is only visually perceptible in Case 1b frame 1 (~0.014 in x); in Case 2 it is sub-pixel. The substance (wrong construction) holds in both.

## A3 — confirmed
- What I checked: positions of x0, Newton x1, Halley x1 relative to the root -2; committed halleysba frame_001.png zoomed.
- Evidence: x0=-2.2 < root -2; Newton x1=-2.02222 (still left of the root: undershoot, as expected since f<0, f'>0, f''<0 there, concave, so the tangent reaches zero before the curve). Halley x1=-2.00206 also on the same side. No overshoot. In verify/ba1_zoom.png the blue Newton diamond is completely hidden under the orange Halley diamond (0.020 apart in x, ~2 px at this scale); only the legend values distinguish them. Further, the dashed parabola itself crosses at -1.99910, i.e. it is the parabola that lands on the far side of the root.
- Severity: Error is fair: "corrects the Newton overshoot" describes something that does not happen and cannot be seen in the frame.
- Correction to the allegation: none.
