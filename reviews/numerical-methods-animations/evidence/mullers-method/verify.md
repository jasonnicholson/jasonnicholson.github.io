# Verification: mullers-method

## A1 — confirmed
- What I checked: Re-implemented the script's step (Float64, `verify/f64.py`) and ran true complex Muller vs. the script's "take real part" variant at 60 digits (`verify/muller.py`). Recorded the discriminant b^2 - 4 f2 d at each step.
- Evidence: For Case 1 the discriminant is negative at every one of the 8 animated steps (-20.16, -3.909, -0.5667, -0.03021, -1.007e-3, -1.097e-5, -2.157e-8, -6.52e-12), so p2 - 2f2/E is complex every time. The imaginary parts the script throws away are 0.356, 0.183, 0.0847, 0.0248, 4.9e-3, 5.4e-4, 2.4e-5, 4.3e-7. Real Muller (keeping the complex iterate) gives 1.2873+0.3563i, 1.0535+0.2872i, 0.9107+0.1536i, 0.8996-0.0110i, ..., and every iterate has a nonzero imaginary part (still ~1e-13 at step 14). From step 2 onward this is a different sequence from the script's 1.2873, 1.15809, 1.05520, 1.01000, 1.00168, 1.00011, 1.000003, 1.00000003, which are exactly the values in the frame legends (committed/mullersaa/sheet.png). Cases 2 and 3 have a positive discriminant at every step, so there `real()` changes nothing.
- Severity: Error is fair. The page presents the frames as Muller's method, but the sequence shown is a real-part-projected variant, not Muller's iterates. The variant does still converge to 1.
- Correction: none. Strictly, the step-1 real part is the same in both, and the sequences only differ from step 2. That does not change the conclusion.

## A2 — confirmed
- What I checked: The sign of the discriminant of the interpolating parabola at each Case 1 step (same runs as A1), and the committed frames.
- Evidence: The discriminant is < 0 at all 8 steps, so the dashed parabola through (p0,p1,p2) has no real x-intercept in any Case 1 frame. f = (x-1)^2(x+2) >= 0 near the root, and the parabola sits above the axis. The new p2 is the real part of a complex root (the parabola's vertex x), not an axis crossing. The statement does hold for Cases 2 and 3, where the discriminant is > 0 throughout.
- Severity: Error is fair for Case 1. Line 12 is written as a general statement covering all three animations, and it is false for every frame of Case 1.
- Correction: none. Scope: the sentence is false only for Case 1.

## A3 — confirmed
- What I checked: Empirical order log(e_{k+1}/e_k)/log(e_k/e_{k-1}) from 60-digit runs against the exact roots.
- Evidence (`verify/muller.py`): Case 1, true Muller: the order settles at 1.234 (1.232, 1.233, 1.234, 1.234, ...). Case 3 (both variants, since they coincide): 1.225, 1.229, 1.233, 1.234, 1.234. Case 2: also 1.234. The script's real-part variant on Case 1 gives roughly 1.3 (1.29 to 1.39), still far below 1.84. 1.84 is Muller's order at simple roots. At a double root the order drops to about 1.23.
- Severity: Error is fair. The number on lines 18 and 34 is wrong. The surrounding qualitative claim (superlinear, so better than Newton's linear rate on a double root) is still true.
- Correction: none. Lines 18 and 34 are the right places, and the true order is about 1.23.
