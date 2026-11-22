# Verification: brents-method

All scripts/outputs are in `verify/`. Key files: `brentsaa_steps.jl`, `brentsbb_steps.jl` (the scripts' own `run_brents` with the plotting stripped, printing every step), `compare.py` (a line-for-line Python port of the script's algorithm plus a faithful Brent ZEROIN, from netlib zeroin.f / Brent 1973 ch. 4), `scipy_check.py` (checks that ZEROIN port evaluates the same points as `scipy.optimize.brentq`), `why.py` (the script loop with instrumentation showing which rejection condition fired), `halving.py`/`halving2.py` (bracket-halving test). Outputs are in `*_out.txt`.

## A1 — confirmed
- What I checked: the real roots of 4x^3 − 16x^2 + 17x − 4 (numpy.roots, sympy nroots at 25 digits), the residual at the quoted values, and the committed GIF's last frame.
- Evidence: roots = 0.32853845861141489597, 1.26465829006, 2.40680325132. The only root in [0,1] is 0.328538. f(0.3268) = −0.0136 and f(0.3224) = −0.0482, so neither value is a root. The script's own final iterate (frame 10 legend "b = 0.328538") contradicts the page's 0.3268 (index.qmd lines 66 and 70) and the comment's 0.3224 (brentsaa.jl line 3).
- Severity: Error is fair for the page text and alt text. The script comment is a lesser issue because readers don't see it, but it is still wrong.
- Correction: none. The correct value is x* ≈ 0.328538.

## A2 — confirmed
- What I checked: I reran the committed `run_brents` in Julia (brentsaa_steps.jl) and viewed the contact sheet / frame labels.
- Evidence: the step labels are 1 Secant, 2 Bisection, 3 IQI, 4 Secant, 5 Bisection, 6 Bisection, 7 Bisection, 8 Secant, 9 Secant, 10 IQI. The frames show the same labels. The run does not "begin with secant steps": there is one secant and then a bisection. It also does not "quickly switch to IQI": the only IQI before the final step is at step 3, and it is followed by a secant and three consecutive bisections. Convergence is fast only in the last three steps (8–10). Of the 10 steps, 4 are bisections.
- Severity: Error is fair. The sentence is a factual description of what the animation shows, and it is false.

## A3 — confirmed
- What I checked: the script's control flow and Brent's ZEROIN logic.
- Evidence: in the script (brentsaa.jl 51–61, 72–75; brentsbb.jl 51–59, 69–72), the interpolation type depends only on whether three distinct f-values exist (IQI if they do, secant if not). Any rejected candidate becomes `s = mid`, labelled "Bisection". why_out.txt shows rejected IQI candidates (case 1 steps 2 and 5; case 2 steps 2 and 3) becoming bisections and never secant steps. Brent's ZEROIN works the same way: it uses linear interpolation when a == c (only two distinct points) and IQI otherwise. If the candidate fails `2p < 3·xm·q − |tol1·q|` or `p < |e·q|/2`, the step becomes `d = xm`, a bisection. My ZEROIN port logs "Bisection(rejected IQI)" and never falls back from IQI to secant. So the page is wrong on line 38 ("or IQI is rejected") and partly wrong on line 34 ("bisection or secant"). Line 17's wording, that secant is used "when inverse quadratic interpolation cannot be used", is consistent with the correct behaviour.
- Severity: Error is fair.

## A4 — confirmed
- What I checked: I compared the script's algorithm with Brent's ZEROIN step by step. I validated my ZEROIN port against scipy.optimize.brentq: both evaluate exactly the same sequence of points on both cases (scipy_check.py).
- Evidence: the script is the Wikipedia pseudocode (mflag, d, `|s−b| ≥ |b−c|/2` or `|c−d|/2`, `|b−c|<tol` / `|c−d|<tol`) with one modification: cond1 tests s ∉ (a,b) instead of Wikipedia's "s not between (3a+b)/4 and b". Brent's own algorithm instead compares against e, the step before last.
  - Case 1: both evaluate the identical points 0.8, 0.4, 0.227606, 0.339288 through step 4. At step 5, the script computes the IQI candidate 0.328215, which is exactly the point Brent accepts. The script rejects it only because c == d makes the threshold `|c−d|/2 = 0` (conditions c3/c5). At steps 6–7 it forces bisection again because b == c makes `|b−c| = 0` (c2/c4). Brent's sequence is Secant, Bisect, IQI, Secant, IQI, Secant, Secant, IQI (f(b) = 0 after 8 evaluations). The script's is Secant, Bisect, IQI, Secant, Bisect, Bisect, Bisect, Secant, Secant, IQI (10).
  - Case 2: both are identical through step 3 (Secant, Bisect, Bisect). At step 4, Brent accepts the secant step to 1.118293. The script computes that same candidate and rejects it because `|b−c| = 0`, so it labels the step "Bisection".
  - So frames 5, 6 and 7 of brentsaa.gif and frame 4 of brentsbb.gif label a sub-method that Brent's algorithm would not choose.
- Severity: Misleading is fair, not Error. The Wikipedia variant is widely called "Brent's method" and does converge, but the labels in the frames misrepresent Brent's selection logic, and the extra bisections are artifacts of the variant's degenerate tests.
- Correction: the line ranges (brentsaa.jl ~44–94, brentsbb.jl ~41–91) are about right. The loop proper is 44–94 and 44–91, and state initialisation starts at 36/36.

## A5 — confirmed
- What I checked: I measured the bracket width after n steps against W0·2^(−⌊n/2⌋) for f(x) = x^9 on [−1, 2], (x−1/3)^15 on [0, 1] and x^25 on [−1, 4], running both the faithful ZEROIN and the script's variant.
- Evidence (halving2_out.txt): for x^9, ZEROIN's width after 10 steps is 0.263, where the claim's bound is 0.094. After 40 steps it is 1.25e−4 against a bound of 2.9e−6, and after 80 steps 1.1e−8 against 2.7e−12. The typical pattern is Secant, IQI, Bisection, so the bracket halves about once every three steps, and sometimes less often. Reaching tol = 1e−12 takes 116 evaluations, compared with about 42 for plain bisection. The script variant behaves the same way (step 12: width 0.254 against a bound of 0.047). The claimed O(2^(−n)) rate therefore isn't guaranteed. Brent's actual guarantee is convergence within roughly (log2(W0/δ))^2 evaluations: it can never be worse than that, but it can be far worse than bisection.
- Severity: Misleading is acceptable, but Error is arguable. "Guaranteed convergence" is true, but the specific rate is stated as a guarantee and it is false.
