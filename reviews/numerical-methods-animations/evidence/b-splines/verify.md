# Verification: b-splines

## A1 — confirmed
- What I checked: The knot vector bsplinebb.jl builds (k=4 order, n_ctrl=7): vcat(zeros(4), 1:3, fill(4,4)) = [0,0,0,0,1,2,3,4,4,4,4]. I computed the support of each of the 7 cubic basis functions independently with scipy.interpolate.BSpline (degree 3), and looked at the committed final frame.
- Evidence: verify/support.py (`/usr/bin/python3 -I verify/support.py`):
  - N_1 on [0,1]: 1 span; N_2 on [0,2]: 2; N_3 on [0,3]: 3; N_4 on [0,4]: 4; N_5 on [1,4]: 3; N_6 on [2,4]: 2; N_7 on [3,4]: 1.
  - The sum of all of them is 1 to within 3.3e-16, so partition of unity holds. The functions are non-negative. N_4 peaks at 0.6667 (at t=2), which matches the frame.
  - committed/bsplinebb/frame_007.png shows the same thing: blue N_1 is nonzero only on [0,1] and teal N_7 only on [3,4]. Only orange N_4 covers all 4 unit spans.
- Severity: Misleading is fair. In the strict Piegl & Tiller sense, each N_{i,p} is supported on [u_i, u_{i+p+1}), which is 4 knot intervals *if zero-length intervals from the repeated end knots are counted*, so the sentence is defensible narrowly. But the page describes this specific animation, and a reader who checks the GIF sees supports of 1, 2, 3, 4, 3, 2 and 1 nonzero spans. Only 1 of the 7 functions actually spans 4 spans. "At most 4 spans (exactly 4 for basis functions away from clamped ends)" would be correct.
- Correction to the allegation: none. The line number (38) and the script are correct. To be precise, 6 of the 7 functions (all except N_4) span fewer than 4 non-degenerate spans.

## A2 — confirmed
- What I checked: The notation in index.qmd and in both scripts.
- Evidence:
  - index.qmd line 12 says "B-spline curve of degree $p$", and line 15 uses N_{i,p}. So the second subscript is the degree.
  - Line 24 has "cubic B-splines ... $N_{i,4}(t)$", line 36 has "$N_{1,4}, \ldots, N_{7,4}$", and line 38 has "Each cubic B-spline basis function $N_{i,4}(t)$". The alt text at line 42 also uses N_{i,4}.
  - In bsplinebb.jl, k=4 is the order (line 22 `k = 4 # cubic`). The GIF title reads "Cubic B-Spline Basis Functions N₁,₄ … N_7,₄", the legend uses N_i,₄ and the y-label is N_{i,4}(t) (frame_007.png). bsplineaa.jl line 35 says outright "order = degree + 1".
  - Under the page's own definition, N_{i,4} would mean a quartic basis.
- Severity: Misleading is fair. The word "cubic" next to every N_{i,4} limits the confusion. And order-indexed notation (de Boor's N_{i,k}) is a legitimate convention, so this is not an Error. But the page defines the subscript as the degree and then switches to order without saying so, which is inconsistent for a teaching page. It also matters downstream: with the degree reading, "4 knot spans" = p+1 would not fit p=4.
- Correction to the allegation: none. Lines 24, 36 and 38 are correct. Line 42 (alt text) also uses N_{i,4}.
