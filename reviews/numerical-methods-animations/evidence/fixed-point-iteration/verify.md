# Verification: fixed-point-iteration

Scripts: verify/orbits.py (true vs clamped orbits, fixed points, 2-cycle of Case 6 via exact polynomial roots), verify/case6_long.py (400 iterates of Case 6 at 50 digits). Frames viewed: committed/fixpointff/frame_011.png, committed/fixpointee/sheet.png, committed/fixpointdd/frame_009.png.

## A1 — confirmed
- What I checked: I iterated g(x) = -x²/4 - x/2 + 4 from x0 = 1.5 twice: once exactly as written and once with the script's clamp to [0,4] (fixpointff.jl lines 20-26 clamp, lines 62-63 label). I also looked at the last frame of the GIF.
- Evidence (verify/orbits.py): the true orbit is 1.5, 2.6875, 0.8506, 3.3938, **-0.5764, 4.2051, -2.5234, 3.6698, -1.2018, 4.2398, -2.6139**. The clamped orbit agrees through x3, then gives 0, 4, 0, 4, 0, 4, 0. The two differ from x4 on, and the clamped values are fed back into g, so this is not just a display cut-off. In frame_011 the legend reads "x_10 = 0.0" (true value -2.614), and the staircase runs around the box edges between (0,0) and (4,4). That 0 to 4 rectangle is a fake 2-cycle made by the clamp. The real long-run behaviour is an attracting 4-cycle (see A5).
- Line numbers: the clamp is at lines 155-161 and the label at 197-199 of the combined listing, which are lines 20-26 and 62-63 of fixpointff.jl itself, as the allegation says.
- Severity: Error is fair. Seven of the eleven frames show wrong iterate values and a wrong path.

## A2 — confirmed
- What I checked: the same true vs clamped comparison for g(x) = x²/4 + x/2 from x0 = 2.5, plus the GIF contact sheet.
- Evidence: the true orbit is 2.5, 2.8125, 3.3838, 4.5544, 7.4628, 17.65, 86.75, 1924.8, 9.27e5. The clamped orbit is 2.5, 2.8125, 3.3838, then 4, 4, 4, 4, 4, 4. On the sheet, frames x_3 to x_8 (six frames) put the marker at the corner (4,4) with the label "x_n = 4.0". The vertical segment from 3.38 stops at y = 4 instead of 4.55. After that the path stops moving, which looks like a fixed point at 4. But 4 is not a fixed point: g(4) = 6.
- Severity: Error is fair. The labels are false. The page text ("moves monotonically rightward and diverges") is correct, but the GIF makes it look as if the orbit stalls.

## A3 — confirmed
- What I checked: g(x) - x = x(x-2)/4 (sympy), and g'(2) = 3/2.
- Evidence: g(2) = 2, but g'(2) = 3/2, not 1, so the curve crosses y = x at x = 2 rather than touching it. g(x) - x changes sign at 2: it is negative on (0,2) and positive for x > 2. The curve crosses from below to above. It is not tangent from below. The next sentence on the page, "g'(2) = 3/2 > 1", contradicts the tangency claim.
- Severity: Error is fair. Line 48 is correct.

## A4 — confirmed
- What I checked: the fixed points of g(x) = x²/4 + x/2 and the orbit from 1.5.
- Evidence: the fixed points are 0 (g' = 1/2, attracting) and 2 (g' = 3/2, repelling). From 1.5 the orbit decreases monotonically: 1.3125, 1.0869, 0.8388, ..., 0.0684 at n = 8, and 1.7e-11 at n = 40. It converges linearly to x* = 0 with ratio 1/2. The final frame (x_8 = 0.0684) shows the staircase closing in on the origin. The body text ("walks away from the fixed point toward the left") is narrowly true with respect to x* = 2. But the heading "Divergent" (line 46) and the alt text "divergent fixed point iteration" are wrong about the iteration: the sequence converges. The page never mentions the second fixed point at 0.
- Severity: Misleading is fair at minimum. It could reasonably be raised to Error, since "divergent" in numerical-methods usage means the sequence does not converge, and this one converges.

## A5 — confirmed with correction
- What I checked: 400 iterates at 50 digits, the 2-cycle and its multiplier, and conjugacy to z² + c.
- Evidence: the orbit does move outward while oscillating for the first few steps. The distances x_n - 2 are -0.5, +0.69, -1.15, +1.39, -2.58, +2.21, -4.52. After that it stays bounded: min -2.6405, max 4.2500, and every iterate stays inside [-8, 6], which g maps into itself. It converges to an **attracting 4-cycle {4.2500, -2.6405, 3.5772, -0.9876}** with multiplier -0.0305. The 2-cycle {-2, 4} exists but is repelling, with (g∘g)' = -1.25. Consistent with this, the map is conjugate to z² + c with c = -1.3125, which lies in the period-4 window. So "diverges" is true only in the sense of "does not converge to x* = 2". It does not escape, and the outward spiral is a transient of about 6 steps that ends on a 4-cycle.
- Correction: "the true orbit does not do that" overstates it. The orbit really does spiral outward from x* = 2 for the first several iterates. What is misleading is the implication of an unbounded outward spiral, which the clamped GIF reinforces with its fake 0 to 4 box (A1).
- Severity: Misleading is fair.
