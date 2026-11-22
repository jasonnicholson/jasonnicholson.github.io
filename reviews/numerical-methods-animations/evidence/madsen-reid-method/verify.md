# Verification: madsen-reid-method

## A1 — confirmed
- What I checked: every use of `r0` in madsreidaa.jl (lines 44–48), madsreidab.jl (41–45), madsreidac.jl (42–46). `r0` appears only in `if r > r0` which *shrinks* the step to length r0 (ac: rotates via alterdirection and scales by r0/r < 1); then `r0 = 5r`. No code path ever takes a step longer than the Newton step, and no path takes repeated steps in the same direction (the Madsen–Reid acceleration the page describes at lines 12–18). Instrumented copy of the loop logged r0, |Newton step|, capped?, |taken|/|Newton|.
- Evidence: verify/trace.jl. Case 1: capped=false on all 6 steps, |taken|/|Newton| = 1.000000 every step, r0 *decreases* 7.5 → 3.54 → 1.63 → 0.41 → 0.025 → 9.3e-5. Case 2: capped=false on all 14 steps, ratio 1.000000 throughout, r0 decreases 10 → 6 → 3.79 → … → 0.0034. Case 3 (log in manifest): escape from the real axis comes from the halving-failure alterdirection branch, not from r0.
- Severity: Error is fair — the section headline mechanism ("quadratic convergence even at multiple roots" via acceleration) does not exist in any script; also "r0 increased fivefold after each accepted step" is wrong in the scripts' own terms (r0 is reset to 5× the raw Newton step length every iteration regardless of acceptance, and in practice shrinks).
- Correction to the allegation: none; line ranges are accurate.

## A2 — confirmed
- What I checked: case-2 trajectory, labels, step lengths and error ratios from the same instrumented loop; viewed committed frames (sheet.png, frame_014.png, frame_015).
- Evidence: verify/trace.jl. labels = 14 × :newton, 0 × :damped; no step capped or halved (pure undamped Newton x_{k+1} = x_k − f/f'). Error ratio e_{k+1}/e_k = 0.600, 0.579, 0.557, … → 0.50006 — textbook linear convergence with rate (m−1)/m = 1/2. Run ends at the 14-iteration cap with x14 ≈ 1.00034 (error 3.4e-4), never meeting |f|<1e-10. Frames: all segments steelblue, no orange anywhere; legend shows an orange entry but no orange segment drawn. Also the root x = −2 is never approached (minor).
- Severity: Error is fair — the caption and alt text describe damped frames and super-linear acceleration that the GIF does not show; the GIF in fact shows exactly what the page says "standard Newton would" do.
- Correction to the allegation: none.

## A3 — confirmed
- What I checked: analytically, for P=(x−1)²(x+2), Newton step f/f' = (x−1)(x+2)/(3(x+1)) so step/(x−1) → 1/2 = 1/m as x→1 (sympy). Numerically, |Newton step|/error in case 2 = 0.40, 0.42, … → 0.4999.
- Evidence: sympy one-liner (output in verify session); trace.jl column `newton/err`.
- Severity: Misleading is fair (arguably Error): f'(x*)=0 is the right root cause, but the effect is the opposite of what is said — the Newton step is only ~1/m of the distance to the root (too short / undershooting), not inflated. A reader would infer the wrong cure (shrink steps) whereas the page's own remedy (lengthen steps) only makes sense for too-short steps.
- Correction to the allegation: none.
