# Verification: riemann-sums

Reference integral: I = ∫₀² (e^{-x} sin(8x^{2/3}) + 1) dx = 2.0162797196171 (mpmath quad, and scipy quad after the substitution x = t³; the two agree to 1e-15). The interior critical points of f on (0,2) are at x ≈ 0.080384 (max, 1.91976), 0.431982 (min, 0.35720), 0.939205 (max, 1.38451) and 1.564476 (min, 0.79559). I found them with mpmath findroot on f′ after a sign scan of f′ on 200 001 points. To get the true inf/sup on each subinterval I compared the endpoint values with f at every critical point inside the subinterval. A dense sampling with 200 001 points per subinterval gave the same results for n = 1, 3, 7 and 16.
Script: verify/check.py (output in verify/check_out.txt), verify/integral_check.txt.

## A1 — confirmed
- What I checked: riemanncc.jl lines 20/36 use `min(f(xl), f(xr))` and riemanndd.jl lines 20/36 use `max(f(xl), f(xr))`. These take only the two endpoint values, not the inf/sup over the subinterval. Line 15 of index.qmd says "bounds from interval minima/maxima". I compared the displayed sums with the true lower and upper sums.
- Evidence (displayed vs true): n=1: lower 2.000000 vs 0.714407, upper 2.035850 vs 3.839512. n=2: 2.017925 vs 1.152792, 2.727929 vs 3.283721. n=3: 1.832477 vs 1.374576, 1.965664 vs 2.881460. n=4: 1.231216 vs 1.192004, 2.372927 vs 2.843078. n=8: 1.621167 vs 1.601561, 2.192023 vs 2.427098. By n≥24 the differences are below about 1e-3. Frames riemanncc/frame_003.png and riemanndd/frame_004.png show it directly: the rectangles sit above the curve's dip (Lower) and below its peaks (Upper).
- Severity: Error is fair. The curves are labelled "Lower/Upper Riemann Sum", line 15 promises minima/maxima, and the values at small n are badly wrong (n=1 is off by 1.29 for lower and 1.80 for upper).
- Correction: none needed. One mitigating point: lines 44 and 52 do honestly say "minimum/maximum **endpoint** value". So the code matches those lines. The conflict is with line 15 and with the "Lower/Upper Riemann Sum" titles, and the bound claims at lines 44/52 then fail (see A2).

## A2 — confirmed
- What I checked: compared each displayed value with I = 2.016280.
- Evidence: "Lower" at n=2 is 2.017925, which is greater than I (frame riemanncc/frame_003.png reads "Approximation = 2.017925"). "Upper" at n=3 is 1.965664, which is less than I (frame riemanndd/frame_004.png reads "Approximation = 1.965664"). These are the only violations; every other frame is on the correct side of I. The true inf/sup sums are on the correct side for every n.
- Severity: Error is fair. Lines 44/52 state a bound, and the animation itself contradicts it. The hypothesis "for nonnegative f" holds (f ≥ 0.357), so it does not rescue the claim: endpoint min/max gives a bound only when f is monotone on each subinterval, and here it is not.
- Correction: the claim is accurate as stated; the specific violations are one "Lower" value (n=2) and one "Upper" value (n=3).

## A3 — confirmed
- What I checked: whether the displayed sequences are monotone across n_seq.
- Evidence: the displayed "Lower" sequence decreases at n 2→3 (2.0179→1.8325), 3→4 (1.8325→1.2312) and 7→8 (1.6250→1.6212). The displayed "Upper" sequence increases at 1→2 (2.0359→2.7279), 3→4, 7→8, 8→10 and 12→14. Taken together with A2, this means "rises toward" and "squeeze" do not describe what is shown.
- Severity: Misleading is fair, and arguably mild. Even the true lower and upper sums are not monotone for this n_seq (true lower drops at 3→4, true upper rises at 7→8), because consecutive partitions are not refinements of each other. Monotonicity is guaranteed only under refinement. The "squeeze" as n→∞ is correct in the limit. So the text is narrowly defensible, but the displayed sequences visibly jump around at small n, and they cross I.
- Correction: none. One note for whoever fixes this: switching to true inf/sup alone will not make the sequences monotone. The n values would also have to be nested (for example powers of 2), or the wording softened.
