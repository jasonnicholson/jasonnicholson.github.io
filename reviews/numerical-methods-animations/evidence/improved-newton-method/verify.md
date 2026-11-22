# Verification: improved-newton-method

## A1 — confirmed with correction
- What I checked: Re-ran the Method A (m=3) iteration from newtonimpdd.jl exactly (expanded quartic f, fp; x0=1.3; n_iters=5) in Float64. I also ran it in 256-bit BigFloat and in Float64 using the factored form (x-1)^3(x+2). Then I viewed committed frames frame_004 to frame_006.
- Evidence: `verify/iterates.jl`
  - Float64 with the expanded form (what the GIF shows): x1=1.0088235, x2=1.0000086, **x3=1.000000642, x4=1.000719377, x5=1.0000000577**. The labels read 1.000001, 1.000719 and 1.0.
  - BigFloat reference: x3 = 1 + 8.25e-12, x4 = 1 + 7.6e-24, x5 = 1 + 1.0e-31. That is quadratic convergence, with error ratio e_{n+1}/e_n^2 of about 0.11. The correct labels would be 1.0, 1.0 and 1.0.
  - Float64 with the factored form matches the reference up to x3 = 1 + 8.2e-12, then hits x4 = 1.0 exactly. (x5 would then be NaN from 0/0, which is a separate pitfall.)
  - Cause: near x = 1+e the expanded quartic is about 3e^3. At x2 (e ≈ 8.6e-6) that is about 1.9e-15, the same size as the rounding noise from evaluating the expanded form (computed f(x2)=1.78e-15 vs true 1.92e-15; computed f(x3)=-8.9e-16 vs true 1.7e-33). So x3 onward is driven by noise. At x3, f' ≈ 3.7e-12 divides a noise-level f, which throws x4 out to 1 + 7.2e-4. That is about 84 times farther from the root than x2.
  - Frames: frame_004 shows "x₍3₎ = 1.000001", frame_005 shows "x₍4₎ = 1.000719" and frame_006 shows "x₍5₎ = 1.0". In the plot itself the red marker stays on x=1 in all three frames. A shift of 7e-4 on a 0.5–1.6 axis is under one pixel.
- Severity: Error is fair. The legend values for x3 and x4 are computed wrongly. The x4 label shows the iterate moving away from the root, which contradicts the page's caption and text ("quadratic convergence").
- Correction to the allegation:
  - The jump away from the root is visible only in the legend text (x₍4₎ = 1.000719). It is not visible in the plot geometry.
  - frame_006's label "1.0" is only right because of rounding (the actual value is 1 + 5.8e-8).
  - The f definition is on line 12, not 11. The other line numbers (n_iters 17, iteration 29, label 55–56) are correct.
  - "Frames ~4–6" means the 1-based frame files 004–006, which show iterates x3–x5.

## A2 — confirmed (depends on how Method B is read)
- What I checked:
  - What the page defines: Method A on line 30 (x - m f/f') and Method C on line 65 (a search over m = 1, 2, 3, … for a step that gets closer). **Method B is never defined on this page.**
  - The standard meaning of Method B: Mathews' modules (the cited source) and this site's sibling page `pages/numerical-methods/accelerated-and-modified-newton-raphson/index.qmd` line 18 both define it as Modified Newton-Raphson, which is Newton's method applied to u = f/f': x_{n+1} = x_n - f f'/(f'^2 - f f'').
  - I ran that iteration on arctan from x0 = 1.4 in 50-digit mpmath. I also checked A and C on the same case.
- Evidence: `verify/methodB_arctan.py`
  - Method B: x = 1.4 → 0.6316 → 0.1712 → 6.2e-3 → 3.3e-7 → 4.6e-20 → 1.3e-58. It converges quadratically to 0.
  - A scan of 2001 starting points in [-50, 50] found no failures for Method B. For arctan, u = (1+x^2)·atan(x) is monotone, with u' = 1 + 2x·atan(x) > 0.
  - Method A with m=1 (the correct multiplicity for this simple root) is plain Newton, which diverges.
  - Method C: the m=1 step lands at -1.4136, and m = 2, 3, 4 land at -4.23, -7.04, -9.85. Under the page's own description the search never succeeds, so line 65 is correct.
- Severity: Error is fair. "Methods A, B, and C do not fix this case" is false for B under the standard definition. Line 66 ("even the improved methods have limits…") overgeneralizes from this example, because one of the three improved methods fixes it.
- Correction to the allegation: the statement is wrong only for B. It holds for A and C. The verdict depends on reading B as Modified Newton-Raphson (Newton on f/f'), since this page never defines B. That is the cited source's definition and the one this site uses on its sibling page.
