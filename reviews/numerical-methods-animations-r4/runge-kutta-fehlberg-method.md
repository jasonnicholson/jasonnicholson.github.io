# Runge-Kutta-Fehlberg Method — animation review (round 4)

Page: `pages/numerical-methods/runge-kutta-fehlberg-method/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1. Fidelity, Minor: Case 1 says it "reconstructs" Mathews' Example 1, but its step controller is not the module's, so at the same tolerance its numbers differ from Mathews' Examples 4/5 by 15-20x, and the page never says so

- **Location:** index.qmd lines 25-28 ("The first animation below reconstructs the legacy Example 1 setup from the Mathews module ...") and line 19 together with `rungekuttafehlbergaa.jl` lines 11 and 37-45.
- **What is there now:** The script uses the Burden-Faires controller:
  - it accepts a step when `|y5-y4| <= tol*h` (error per unit step), with no clamp on `s`;
  - `h0 = 0.1`, `hmin = 1e-6`, `tol = 1e-6`.

  Mathews' RKF45/RKF54 subroutines (archive images gr_15 and gr_26) are different:
  - they accept when `err < ε` (absolute error per step);
  - they clamp `s` to [0.1, 4];
  - `h0 = 0.25`, `hmin = 0.001`.
- **What is true:**
  - **Mathews' run.** Re-implemented from the images (`python3 -I review/mathews.py`), his subroutine on Example 1 reproduces his published final errors only at ε = 1e-6. RKF45 gives 7.041e-2 and RKF54 gives 6.450e-2, against 0.0704102 and 0.0645005 in gr_78 and gr_93. Each run has 120 points.
  - **The page's run.** The same ε = 1e-6 gives 259 points and final errors of 4.517e-3 (RKF45) and 3.154e-3 (RKF54).
  - **The consequence.** The tolerance is Mathews', but the acceptance test is not. A reader who compares the page's "errors 3.2e-3 against 4.5e-3" with the module's Examples 4/5 finds an unexplained factor of about 15-20.
  - The page's own numbers are correct for its controller (see the ledger). Both controllers are legitimate. Note that Mathews' rule mixes an absolute acceptance test with a per-unit-step scale factor.
- **Suggested correction:** Add one sentence after line 28. For example: "The step controller here uses the per-unit-step test above; Mathews' subroutine accepts a step when $|y_5-y_4|<\varepsilon$ (with $h_0=0.25$, $s$ clamped to $[0.1,4]$), so at the same $\varepsilon=10^{-6}$ his run takes 120 points and ends with errors of about $7.0\times10^{-2}$ (RKF45) and $6.4\times10^{-2}$ (RKF54)."

I found no other findings.

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `rungekuttafehlbergaa.jl` | 0 | 10.2 | rungekuttafehlbergaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `rungekuttafehlbergbb.jl` | 0 | 18.6 | rungekuttafehlbergbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `rungekuttafehlbergaa.gif` | 66 | byte-identical | rungekuttafehlbergaa |
| `rungekuttafehlbergbb.gif` | 81 | byte-identical | rungekuttafehlbergbb |

### Page references

- Scripts linked: `rungekuttafehlbergaa.jl`, `rungekuttafehlbergbb.jl`
- GIFs embedded: 2
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

### Description (lines 12-21)

| # | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|
| D1 | "computes embedded 4th- and 5th-order approximations from the same stage evaluations" | Code lines 24-32 (aa) and 42-50 (bb) use 6 shared stages. The order test in 60-digit arithmetic gives local-error ratios on halving h of 32.08 for y4 (that is, h^5, order 4) and 64.00 for y5 (h^6, order 5) on y'=1+y², with the same result on y'=-2ty² and y'=y-t²+1. | confirmed |
| D2 | "\|y5 − y4\| estimates the local error of y4. It shrinks like h^5" | Follows from D1: y4 has local error O(h^5) and y5 has O(h^6). | confirmed |
| D3 | "\|y5−y4\|/h is an error per unit step that shrinks like h^4" | Follows from D2. | confirmed |
| D4 | "A step is accepted when \|y5−y4\|/h ≤ ε" | Code line 37: `err <= tol*h`. The hmin forced-accept branch never fired: 0 forced accepts in all four runs. | confirmed |
| D5 | "h_new = s h with s = 0.84 (ε h/\|y5−y4\|)^{1/4}" | Code line 44. 0.84 ≈ 2^{-1/4} = 0.8409, which matches Mathews' gr_5. | confirmed |

### Animations introduction (lines 25-44)

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| I1 | First animation reconstructs legacy Example 1: y'=1+y², y(0)=0.5, [0,1.1] | Archive gr_27/28/29 give the same three items. The script has f, y0=0.5, tf=1.1. The controller differs (F1). | confirmed (IVP); see F1 |
| I2 | Dashed black curve is the exact solution y=tan(t+arctan 0.5) | Central-difference ODE residual of tan(t+atan .5) is 1.9e-8 relative, and y(0)=0.5. Script line 90: black dashed line, labelled "Exact y(t)". | confirmed |
| I3 | Examples 6-8 solve the Riccati y'=t²+y² (Example 6 with RKF45/RKF54, Example 7 compares with the closed-form Bessel solution, Example 8 uses DSolve) and are not animated | Archive text of Links 7-9 and images gr_103/144 (y'=t²+y²) and gr_123 (the Bessel-J solution). | confirmed |
| I4 | Second IVP y'=1−t∛y, y(0)=1, [0,5] is the same IVP as on the Euler (forward and modified), Runge-Kutta, Taylor Series and ABM pages | grep of those pages' index.qmd: all state y'=1−t∛y, y(0)=1 on [0,5]. Euler has cases for forward Euler (aa) and modified Euler (bb). | confirmed |
| I5 | Dashed reference is fixed-step RK4 at h=1e-4 | bb lines 10-27 and 76 implement classical RK4 with h=1e-4. Its maximum difference from scipy DOP853 (rtol 1e-13) over [0,5] is 9.7e-13, and y(5)=0.0081199205 in both. | confirmed |
| I6 | The IVP is not one of the module's examples | The module's examples use y'=1+y² and y'=t²+y² only. | confirmed |

### Case 1 (lines 46-61)

| # | Claim | Evidence (Julia run; independent Python run beside it) | Verdict |
|---|---|---|---|
| C1.1 | Heading: RKF45 vs RKF54, y'=1+y², y(0)=0.5, t∈[0,1.1] | Script lines 8, 51-57. | confirmed |
| C1.2 | Both traces within relative error 3.3e-5 all the way | Max relative error: RKF45 3.229e-5 and RKF54 2.255e-5 (Julia). Python gives the same. 3.3e-5 holds as a bound. | confirmed |
| C1.3 | y(1.1)=139.88 | tan(1.1+atan .5) = 139.8828. | confirmed |
| C1.4 | Pole of tan at t=1.1071 | π/2 − atan(0.5) = 1.107149. | confirmed |
| C1.5 | The log y-axis keeps the whole run in view | ylims (0.4, 200) against y∈[0.5, 139.89]. In frame 66 the end marker sits at about 140, inside the box. | confirmed |
| C1.6 | Step shrinks from 0.136 near t=0.1 to 5e-5 near t=1.1 | The step from t=0.1 is 0.13600, which is also the largest step. The last full steps are 5.13e-5, 5.08e-5, 5.02e-5 and 4.97e-5, followed by a final truncated step of 2.82e-5. | confirmed |
| C1.7 | 187 of the 259 computed points lie in t ≥ 1.05 | Julia: n45 = n54 = 259, and 187 points have t≥1.05 (Python gives 187/259 too). | confirmed |
| C1.8 | Marker slows as it nears the pole | Contact sheet: frame 2 is at t≈0.9 and frame 3 at t≈1.0. Frames 4-66 all fall in t>1.05. | confirmed |
| C1.9 | Each frame adds up to four accepted steps | stride = 4, frames = 1:4:259 ∪ {259}, which gives 66 frames, as does the committed GIF. The last frame adds 2 steps. | confirmed |
| C1.10 | Steps agree to within 0.05% | Julia, index-wise: the maximum relative step difference is 0.041%, and the final step differs by 0.019%. Note that this is sensitive to roundoff in the last digits: my Python run reproduces the points to about 1e-5 relative but gives 0.22% on the final, truncated step. The claim holds for the run that is drawn. | confirmed |
| C1.11 | Curves coincide (blue over magenta) | Code lines 92-93: RKF45 is magenta at lw 5 underneath, RKF54 is royal blue at lw 2 on top. The frames show this. | confirmed |
| C1.12 | They differ only in whether y4 or y5 is carried forward | Code line 39 is the only mode-dependent line. | confirmed |
| C1.13 | RKF54 ends closer: errors 3.2e-3 against 4.5e-3 at t=1.1 | Final errors are RKF54 +3.154e-3 and RKF45 +4.517e-3 (Julia and Python agree). | confirmed |
| C1.14 | Source link `rungekuttafehlbergaa.jl` and embed `rungekuttafehlbergaa.gif` are this case | Script title line 83 matches the heading. The manifest shows the GIF is byte-identical to a fresh regeneration. | confirmed |
| C1.15 | Alt text: RKF45/RKF54 versus exact, y'=1+y², y(0)=0.5 on [0,1.1], log y axis | Matches the code and the frames. | confirmed |

### Case 2 (lines 63-80)

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| C2.1 | Heading: y'=1−t∛y, y(0)=1, t∈[0,5] | Script lines 8, 69-75 (`cbrt` is the real cube root). | confirmed |
| C2.2 | Both match the reference to within 7e-7 at every accepted point | Maximum absolute error against DOP853: RKF45 6.58e-7 at t=2.01, RKF54 9.4e-8. | confirmed |
| C2.3 | Maximum step h=0.25 over the hump (0.1 ≤ t ≤ 1.35) | Steps of exactly 0.25 start at 0.1, 0.35, 0.6, 0.85 and 1.1 and end at 1.35. | confirmed |
| C2.4 | h between 0.189 and 0.25 until t≈2.4 | The steps from 1.35 to 2.399 are 0.2435, 0.2176, 0.1989, 0.1891 and 0.2001, with a minimum of 0.1891. The next step, from 2.399, is 0.103. | confirmed |
| C2.5 | Steepest point y'=−0.930 at t=2.19 | On the reference, the minimum of y' is −0.9303 at t=2.1945. | confirmed |
| C2.6 | Step below 0.04 from t=3 on | The largest step starting at t≥3 is 0.0399. | confirmed |
| C2.7 | Smallest step it chooses is 0.027, near t=3.27 | The smallest controller-chosen step is 0.0274 at t=3.272 (both modes). RKF54's final step is a 6.4e-4 sliver forced by truncation at tf (code lines 38-40). The controller does not choose that step, so the wording holds. | confirmed |
| C2.8 | Corners on the hump are chords up to 0.0091 below the curve, near t=0.48 | The maximum of the reference minus the RKF45 polyline is 0.00911 at t=0.475, with the curve above the chord. | confirmed |
| C2.9 | ∂f/∂y = −t/(3y^{2/3}) reaches −41.3 at t=5 | −5/(3·0.0081199^{2/3}) = −41.255. | confirmed |
| C2.10 | The 4th-order RKF update's stability limit is 3.02 | sympy gives R(z) = 1+z+z²/2+z³/6+z⁴/24+z⁵/104, and R(z) = −1 at z = −3.02002. | confirmed |
| C2.11 | Fixed steps longer than about h=0.0732 would exceed it before t=5 | 3.02/41.255 = 0.07320. | confirmed |
| C2.12 | Every accepted step keeps h\|∂f/∂y\| below 1.3 | Taking the maximum over each step's endpoints along the computed solution gives 1.270 (RKF45) and 1.274 (RKF54), both near t≈4.97. | confirmed |
| C2.13 | The steps are set by the tolerance, not by stability | Follows from C2.10 and C2.12: the largest value, 1.27, is well below 3.02. | confirmed |
| C2.14 | Source and embed wiring | Script title line 93 matches the heading. The GIF is byte-identical on regeneration, with 81 frames, which equals max(n45=80, n54=81). | confirmed |
| C2.15 | Alt text: RKF45/RKF54 versus high-accuracy RK4 reference, y'=1−t cbrt(y), y(0)=1 on [0,5] | Matches. | confirmed |

---

### 3. Implementation checks

### `rungekuttafehlbergaa.jl`

- **It is the method it claims to be.** The script runs Fehlberg 4(5) with the Burden-Faires per-unit-step controller. "RKF45" carries y4 forward. "RKF54" carries y5 forward, which is local extrapolation and is the same as Mathews' RKF54 subroutine (gr_26). The coefficients match Mathews' gr_15 and gr_26 exactly. Independently of that table, the order test above confirms local orders 5 and 6 and that the row sums equal c. The controller is a legitimate variant, but it differs from Mathews' (F1).
- **The numbers are right.** I re-implemented the method independently in Python and ran it beside the Julia run:

  | Quantity | Julia | Python |
  |---|---|---|
  | Accepted points | 259 / 259 | 259 / 259 |
  | Rejected steps | — | 4 per mode |
  | Final y, RKF45 | 139.887359 | 139.887359 |
  | Final y, RKF54 | 139.885997 | 139.885997 |
  | Max relative error, RKF45 | 3.229e-5 | 3.229e-5 |
  | Max relative error, RKF54 | 2.255e-5 | 2.255e-5 |

  Index-wise, the maximum t difference between the two runs is 8.6e-8. This is roundoff in `err`: near the pole, `err` is computed by cancellation of quantities of size about 100.
- **Its reference values are right.** The exact solution satisfies the ODE (residual 2e-8 relative, at the level of the finite difference) and y(0)=0.5.
- **The picture shows what was computed.** I checked frames 1, 2-11 from the contact sheet, and 66. The marker is at the current accepted point. The title has the right f, y0 and tol. The legend is correct. The log axis does not clip anything. There is no clamping and no NaN masking.

### `rungekuttafehlbergbb.jl`

- **It is the method it claims to be.** The RKF routine is identical to aa's. The reference is classical RK4 (lines 19-23).
- **The numbers are right.** Python and Julia agree:

  | Quantity | Julia | Python |
  |---|---|---|
  | Accepted points, RKF45 / RKF54 | 80 / 81 | 80 / 81 |
  | Max \|Δt\| between the runs | 1.8e-10 | — |
  | Max \|Δy\| between the runs | 1.6e-10 | — |
  | Rejected steps per mode | — | 3 |
  | Forced accepts per mode | 0 | 0 |
  | y(5), RKF45 | 0.0081198889 | — |
  | y(5), RKF54 | 0.0081199107 | — |
  | y(5), reference | 0.0081199205 | — |

- **Its reference values are right.** RK4 at h=1e-4 agrees with DOP853 (rtol 1e-13, atol 1e-15) to 9.7e-13 everywhere on [0,5]. y stays positive (minimum 0.00812), so `cbrt` never sees a negative argument.
- **The picture shows what was computed.** I checked frames 1, the contact sheet and 81. The polyline goes through the accepted points, and the chords sag below the concave hump by up to 0.0091, as the page says. The end point (5, 0.0081) is inside xlims and ylims. There is no clamping. With 81 frames, each frame adds one accepted step.

### Not findings (noted for completeness)

- **Controller details the Description does not mention.** The script has `hmin` forced acceptance, `hmax = 0.25`, and `s = 2` when err = 0. None of these fired except `hmax`, which C2.3 describes.
- **Archive coverage.** Mathews' Examples 2-3 (Mathematica NDSolve and DSolve on Example 1) are not mentioned on the page. They demonstrate Mathematica built-ins, not the method. Examples 4-5 (the error of Example 1) correspond to the page's final-error statement; F1 covers how the numbers differ.

