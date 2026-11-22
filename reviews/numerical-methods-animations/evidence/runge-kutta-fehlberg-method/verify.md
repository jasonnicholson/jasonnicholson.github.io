# Verification: runge-kutta-fehlberg-method

## A1 — confirmed
- What I checked: I took the `rkf_integrate` function verbatim from rungekuttafehlbergbb.jl and ran it with the script's parameters (tol=1e-6, h0=0.1, hmax=0.25), listing every accepted t, h and |y'| for both modes. As an independent check I solved the IVP with scipy DOP853 (rtol=1e-12) and found where |y'| and the higher derivatives peak.
- Evidence: verify/steps_bb.jl -> verify/steps_bb.txt; verify/indep_bb.py -> verify/indep_bb.txt.
  - The steepest part of the descent is t ≈ 1.85–2.35, where |y'| = 0.84–0.92 (peak ≈0.925 near t≈2.2). Every step there is h = 0.25 = hmax, the largest step allowed. Steps first drop below hmax only after t=2.35.
  - The smallest steps (h ≈ 0.054–0.056, leaving out the final step that is cut to land on tf) fall at t ≈ 3.22–3.44, where |y'| is only 0.03–0.08. This is the "knee", where y → 0 and the higher derivatives peak: the independent solve gives max |y^(5)| ≈ 189 at t ≈ 3.19 and max |y''| at t ≈ 2.95. Steps then grow again to about 0.06–0.07 in the flat tail.
  - Both modes take essentially the same steps.
- Severity: Error is fair. Read literally, "adaptive steps tighten through the steeper part" is false: the steepest stretch runs at the maximum step. The steps shrink where curvature and higher derivatives are large (the transition into the flat tail), not where the slope is large. One mitigating detail: the steps do start shrinking during the lower, still fairly steep part of the descent (t ≈ 2.5–3.0, |y'| from 0.85 down to 0.3). The sentence is therefore a wrong explanation rather than a wholly invented one.
- Correction to the allegation: none. As a side note, the same sentence's "small visible differences" between RKF45 and RKF54 is also doubtful: the two runs differ by about 1e-6 in y, which cannot be seen at this scale.

## A2 — confirmed
- What I checked: I ran rungekuttafehlbergaa.jl's `rkf_integrate` verbatim in both modes and compared the accepted t_i and y_i pairwise. I also looked at committed frames 12, 29 and 60.
- Evidence: verify/steps.jl -> verify/steps_aa.txt. Both runs accept 60 points. The accepted times agree to within 7.6e-7 at every index, so the step distributions are the same to about 6 significant figures. The y differences are at most 2.3e-4 up to index 59 (where y ≈ 138), and 1.5e-2 at the last point (where y ≈ 140, far off the plot). In every inspected frame the royalblue RKF54 line and marker sit exactly on top of the magenta RKF45 line and marker; only one coloured curve is visible.
- Severity: Misleading is fair. "Differ slightly, reflecting the 4th- vs 5th-order accepted update choice" leads a reader to expect a visible or meaningful difference in step choice. In fact the step-size controller is the same and the error estimate |y5−y4| is almost identical, so the steps match to about 1e-6.
- Correction to the allegation: none. "Every frame" holds for the frames I inspected, and it follows from the numbers: a 1e-4 difference in y is far below one pixel at a 0–20 y-range.

## A3 — confirmed
- What I checked: the accepted points from rungekuttafehlbergaa.jl (as in A2) against ylims=(0,20) (script line 62), plus committed frames 29 and 60.
- Evidence: verify/steps_aa.txt. Point 29 has t=1.0551, y=19.18, the last point inside the window. Point 30 has t=1.0591, y=20.82, already outside. Frame n shows points 1..n, so frames 30–60 (31 of the 60 frames, about 52%) have their current marker off the plot. Frame 060.png looks the same as frame 029.png apart from the marker disappearing. The run ends at t=1.1 with y ≈ 140, about 7× the top of the plot. The steps in that unseen stretch are the smallest of the run (h ≈ 3.7e-3 down to 4e-4), so the step behaviour near the end is never shown. At fps=2 that is about 15.5 s of frozen animation.
- Severity: Misleading is fair. The page text even points to the curve steepening "near t=1.1", a region the window cuts off from t≈1.057 onward.
- Correction to the allegation: none. "Roughly the second half of the frames" is accurate (31/60).
