# Review: Shooting Methods for ODE's (batch 4, round 1)

**Findings: 0 Error, 0 Misleading, 1 Minor (unverified).**

Legacy archive consulted: `ShootingMod.html`, example pages lnk_2–7 with their equation, output and graph images, and the `a2001/Animations` folders. Independent computation (`indep.py`): sympy derivation of the exact solution and the constants for the BVP and for u; a fresh NumPy RK4 sharing no code with the scripts; mpmath (50 digits) for references, extrema and the zero; the refinement study and the b-sweep. Frames viewed: shootingaa 2, 5 and contact sheet; shootingbb 1, 5; shootingcc 1, 3, 9, 10.

## Findings

### F1 — Page match — Minor (unverified): in Case 3 the u, v and fan curves are drawn from the closed form, not computed with Runge2D

- **Location:** `index.qmd` line 24, Animations introduction: "Like Mathews, the scripts compute $u$ and $v$ with *Runge2D* … The exact solution of Example 6 is dashed black, and red marks the boundary values."
- **Now:** in `shootingcc.jl` the green u, blue v and gray fan of shots s = −3…3 are the closed-form exact u and v (lines 99–101, 112–118: `uf = uex.(…)`, `vf = vex.(…)`), the gray landing dots at b are exact (line 120), and the left-panel title reports the exact v(b) and C (line 130). Only the magenta solution and the right panel use the Runge2D values. Case 3 also marks only the right boundary value in red (no red marker at (1, 1)). The script header says this ("gray, exact u and v of Example 6"); the page does not.
- **Consequence:** small: exact and RK curves cannot be told apart at plot scale (max |u_j − u| = 4.2e−7, max |v_j − v| = 7.2e−8), and 4-figure titles agree (e.g. at b = 4.15, RK C = −455.7757 vs exact −455.7749). It matters in the last frame, where the left panel shows exact shots meeting exactly at (1 + π, u(1 + π)) under "v(b) = 0" while the right panel shows the RK value v₁₀₀ = 7.06e−9; the Behavior text explains the contrast but never says which panel is exact.
- **Fix:** add to the Case 3 Behavior paragraph: "In the left panel the fan, u and v are drawn from the exact formulas of Example 6, and the left title gives the exact v(b) and C; the magenta solution and the right panel use the Runge2D values." Optionally: "red marks the boundary values (in Case 3, the target x(b) = −0.5)".

No Fidelity findings: Mathews' equation, interval, boundary values, n = 100, Runge2D (RK4) and colours are kept; all six examples are covered and what is not animated is disclosed.

## Inventory (Phase 1)

3 scripts, 3 GIFs (7, 7, 12 frames); all run; every GIF byte-identical to what its script produces; every reference resolves; no unreferenced file; the section index links the page.

## Claim ledger (whole page; reviewer's verdicts)

- **Description (D1–D4):** confirmed (archive gr_58, gr_88, gr_57; sympy residual of (8) is 0).
- **Animations introduction (A1–A12):** confirmed, except A3 and A6 partly (F1): Mathews' colours (gr_117, gr_134), exact solution dashed in Cases 1–2, right panels, `ydraw` behaviour (no curve leaves the window in Cases 1–2: shots range −3.40 to 1.95), timing, 256-bit exact solutions, no Mathews animation (`a2001/Animations/OrdinaryDE` has Adams, Euler, Heun, MEuler, Milne, RungeKutta, Taylor only), coverage and wiring.
- **Case 1 (1a–1k):** all confirmed: u₁₀₀ = −0.3704824638, landings −0.7619617321, 0.0209968045, −1.1534410003, v₁₀₀ = −0.3914792683, C = 0.3308413669, exact slope 0.330842489907664 (sympy), C-shot lands on −0.5, all shots cross near 1 + π.
- **Case 2 (2a–2i):** all confirmed: end errors exactly 0 in double, maximum near t = 2.2–2.3 (1.5379e−4 at 2.2; 2.5642e−9 at 2.275), ratios 15.1854, 15.6552, 15.8415, 15.9256, one interior sign change between 3.8 and 4 for every m, the C sequence.
- **Case 3 (3a–3m):** all confirmed: fan fixed, every shot through (1 + π, −2.36961393412), |v(b)| 0.3915 → 1.673606e−3 monotone, C 0.3308, −6.558190769, −1119.8735 (exact) / −1119.8782 (RK), node minima −2.90521, −6.68805, −712.336 (exact minimum −2.9057 at b = 6), RK error in C 8.996e−8 → 4.725e−3 monotone from b = 5, the 1/v(b) magnification, v₁₀₀ = 7.060078e−9, C = 2.648e8, largest value 1.68554e8.
- **Theory (T1–T13):** all confirmed, including Mathews' "α = β" slip in the footnote counterexample (gr_32) and his α ≠ β premise (gr_55, gr_56).
- **Worked examples (E1–E6j):** all confirmed, including q from −3/4 to −0.9930556, u(6) exact −0.370482048109 and RK −0.3704824638 (max node error 4.157e−7), v = sin(t − 1)/√t with v(6) = −0.391479195816 (max error 7.247e−8), the t = 1…6 table, C, x(6) = −0.5 (gr_144), extrema 1.086067 at 1.482791, zero 2.871102, minimum −2.905675 at 4.782454, verification differences, largest error 6.469e−7 at 2.25, the refinement table, the substitution x = w/√t, w_p, Mathematica's particular part differing by −sin t/(8√t) (simplified by hand from gr_151), the 2×2 system with determinant sin 5, c₁ = 0.0588713451553, c₂ = 0.740071095780 (gr_178), u's constants. Mathematica output quoted as transcription (not re-run).

## Implementation checks

- **shootingaa.jl:** linear shooting with classical RK4 identical in form to Mathews' Runge2D (gr_57); Fu, Fv encode p = −1/t, q = −(1 − 1/(4t²)) (gr_67); u₁₀₀, v₁₀₀, C and all landing points identical to the independent run; the exact u verified by hand (u(1) = 1, u'(1) = 0) and sympy residuals 0; frames: correct shots, labels, right-panel line, titles; 7 frames.
- **shootingbb.jl:** C, maximum error, location and ratios match to every printed digit; zero end errors drawn below the panel by `logdraw`, consistent with the text; the m = 400 notch reaches the bottom because the true interior minimum is 9.3e−12; 7 frames.
- **shootingcc.jl:** for all 10 values of b the independent RK4 reproduces v_m, C_m, the RK error in C and the extremes (at the double nearest 1 + π, C_m differs in the 9th figure, expected when dividing by 7e−9; the shown 2.648e8 is unaffected); `@assert |vex(1 + π)| < 1e−70` holds; right panel and titles correct; left panel exact, as F1 says; magenta RK curve clamped by `ydraw` with its true extreme in the legend; 12 frames.
