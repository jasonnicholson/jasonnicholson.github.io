# Verification: runge-kutta-method

## A1 — confirmed
- What I checked: Re-implemented RK4 independently in Python (verify/check.py) with the script's parameters (n=20, h=0.25, cbrt), compared against two independent high-accuracy references (scipy Radau rtol 1e-12 and mpmath odefun at 30 digits, which agree to 12+ digits), ran step-halving n=20..640, and computed the local stiffness h*J with J = df/dy = -t/(3 y^(2/3)) along the true solution versus the RK4 real-axis stability limit.
- Evidence: verify/check.py -> verify/check.out.
  - My RK4 reproduces the committed final frame exactly (frame_021: "t=5.0 y≈0.2891"; Python 0.289107), so the GIF shows plain RK4 output. The RK4 code (script lines 24-32) is the textbook scheme; nothing is wrong in it.
  - True y(5) = 0.0081199 (Radau and mpmath agree). Script value 0.2891, about 35 times too large (error 0.281).
  - Errors are ~1e-6 up to t=2 and 1.5e-3 at t=3, then jump: t=3.25 1.2e-2, t=3.5 7.2e-2, t=4 0.118, t=4.5 0.235, t=4.75 0.151, t=5 0.281. The true solution falls monotonically (0.038 → 0.0081) while RK4 bottoms out at t=3.25 (0.050) and then climbs with a zig-zag at 4.25/4.5/4.75 (0.157, 0.246, 0.160), visible in frame_021.
  - Cause: near the attracting curve y≈1/t³ the problem is stiff, J ≈ -t³/3. RK4's real stability limit is h*J = -2.785; along the true solution h*J crosses it at t≈3.34 and reaches -10.3 at t=5. Step-halving confirms this is the method, not a bug: with n=80 the t=5 error is 6.8e-6, and the ratios settle to ~16-19 (fourth order) once h is small enough to be stable.
- Severity: Error is fair. The animation's second half shows a numerical artifact (instability) that the page does not mention, and the last labelled value is wrong by a factor of ~35.
- Correction to the allegation: none. The detail is that the solution is still accurate (error < 2e-3) up to t=3. Things go wrong from t≈3.25, which matches the stability crossing at t≈3.34.

## A2 — confirmed with correction
- What I checked: errors and step-halving ratios over subintervals (same script). I also checked whether y=1/t³ is a solution or a nullcline.
- Evidence (verify/check.out):
  - Max |err| on [0,2]: n=20 4.2e-6, ratios 14.3, 15.4, 15.8, so fourth order holds there. On [0,3]: 1.5e-3, ratios 18.8, 18.4, 17.4, close to fourth order.
  - On [0,5]: max |err| 0.281 (n=20), 6.17e-2 (n=40), 1.29e-5 (n=80); ratios 4.6, 4788, 19.4. At t=5 alone: 0.281, 0.0617, 6.8e-6, ratios 4.6, 9072, 52, 22, 18.6. At h=0.25 RK4 is outside its asymptotic (and stability) regime on the latter part of [0,5]. The claim "tracks this with fourth-order accuracy even with the relatively coarse step size h=0.25" is false for the animation as shown: the final value is 35 times the true one.
  - "Fixed curve": d/dt(1/t³) = -3/t⁴ ≠ 0 = f(t,1/t³), so y=1/t³ is not a solution or an invariant/fixed curve. It is the nullcline (the locus where y'=0). The true solution is attracted toward it (y(4)=0.01624 vs 1/64=0.01563; y(5)=0.00812 vs 0.008), so "pulls y toward" is correct in substance. Only the word "fixed" is wrong.
- Severity: Error is fair for the fourth-order-accuracy sentence. The "fixed curve" wording is better graded Misleading/minor terminology than Error: the qualitative statement (the solution is drawn toward y=1/t³) is true, and "fixed curve" should read "nullcline (where y'=0), which the solution approaches".
- Correction to the allegation: the nullcline sub-claim is right that "fixed curve" is the wrong term, but the sentence's physics is not false, so on its own it is lower severity than the accuracy claim. (Aside, not alleged: line 12 says RK4 gives "O(h^4) local accuracy"; the local truncation error is O(h^5) and the global error is O(h^4).)
