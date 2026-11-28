# Brent's Method — batch 17 review, round 1 (overview mode)

SUMMARY: 0 Error, 0 Misleading, 2 Minor

Report: brents-method (light-pass batch 17, overview page, action *check*)

Scope: `EV/diff.patch` is the same as `git diff` of the working tree for this page. Only `pages/numerical-methods/brents-method/index.qmd` changed: 6 insertions and 3 deletions. No script or GIF changed, so the animations are not under review. I consulted the Mathews archive (`n2003/BrentMethodMod.html`, read as text). I did not run MATLAB or quarto and modified nothing in the repository. My scratch work is in `EV/reviewer/brent_check.py`.

## 1. Findings

**F1 — Page text, Minor — the Description is longer than the limit.**
- **Where:** Description, lines 10–60.
- **What is there now:** 502 words of prose by the manifest's count, against the standard's 150–400. The text this batch added is about 130 words (my rough count of the `+` lines, with inline math counted as 1 word), so the page was close to the limit before and the batch pushed it over.
- **Correction:** The director has decided not to trim previously reviewed text on check pages, so I suggest no cuts to the old text. If any trimming is wanted, the only new candidate is the clause in the Fast case bullet ("though, with secant and IQI steps mixed, …"). I don't recommend cutting it, because it correctly heads off a reader expecting to see 1.839 in Case 1.

**F2 — Page text, Minor — "can slow to linear" misstates False Position's rate.**
- **Where:** line 59, "[False Position](...) also keeps a bracket, but its convergence can slow to linear with one endpoint fixed ([Case 2](#case-2))".
- **What is there now:** "Slow to linear" implies False Position is normally faster than linear and drops to linear only sometimes.
- **What is true instead:** Its order is 1.
  - The table directly above (line 53) gives Regula Falsi order "1 (linear; slow for flat f)".
  - The False Position page (lines 27–34) says that when f″ keeps one sign, one endpoint stays and "the convergence is only linear".
  - On Case 2 it is linear with a slow constant. I recomputed regula falsi on tan x − 2x over [0.5, 1.5]: it takes 165 iterations to reach an error of 1e-10, the right end stays at b = 1.5 throughout, and the last error ratios are 0.8664.
- **Correction:** Change it to "… also keeps a bracket, but with one endpoint fixed it converges only linearly, and can be very slow ([Case 2](#case-2))".

## 2. Claim ledger (the `+` lines of the diff)

1. Line 45: "[Case 1](#case-1) shows the superlinear phase". **Confirmed.**
   - My independent zeroin run gives b-errors for steps 4–7 of 1.075e-2, 3.237e-4, 5.461e-6 and 2.738e-9.
   - The ratio of successive errors falls steadily: 0.1504 at step 3→4 (step 3's IQI leaves b unchanged), then 0.0301, 0.0169 and 5.01e-4.
   - The frames show the b values: the legends of frames 5–8 read 0.3392878122, 0.3282147397, 0.3285439194 and 0.3285384613, which match my values to the digits shown.
2. Line 45: "from step 4 to step 7 each step multiplies the error in b by a smaller factor (0.030, 0.017, then 5.0×10⁻⁴)". **Confirmed.** I computed 0.03012, 0.01687 and 5.014e-4, which are the step 4→5, 5→6 and 6→7 factors.
3. Line 45: "with secant and IQI steps mixed, the observed order does not settle at 1.839". **Confirmed.**
   - The order estimates log(e_{k+1}/e_k)/log(e_k/e_{k−1}) at steps 5, 6 and 7 are 1.849, 1.165 and 1.861.
   - Step 8 gives 2.98, but that step is limited by roundoff.
   - Steps 4–8 are labelled Secant, IQI, Secant, Secant, IQI, both in my run and in the frame annotations.
4. Line 45 (context, existing text): "1.839 … positive real root of t³ = t² + t + 1". **Confirmed:** 1.8392867552.
5. Line 58: "Brent's method combines Bisection with the Secant Method and inverse quadratic interpolation". **Confirmed** against the script (brentsaa.jl selects among Secant when a == c, IQI and Bisection).
   - Mathews names the components "bisection, regula falsi, and inverse quadratic interpolation".
   - Both are valid: in zeroin the secant step is taken only when a == c, so it is the chord through the bracket ends. Line 17 already calls it "Secant method (regula falsi)". Not a fidelity finding.
6. Line 59: "False Position also keeps a bracket". **Confirmed.**
7. Line 59: "its convergence can slow to linear with one endpoint fixed". **Wrong in emphasis** (see F2). The rate is linear; "slow to" suggests it is otherwise superlinear.
8. Line 59: the "(Case 2)" link supports the False Position claim. **Confirmed.** Case 2's Behavior text (line 77) states that regula falsi needs 165 iterations, keeps the right end at 1.5 and shrinks the error by about 0.87 per step. I recomputed all three: 165, b = 1.5 throughout, ratio 0.8664. The animation itself shows Brent's run; the regula falsi comparison is in that case's text.
9. Line 59: "Muller's Method fits y as a quadratic in x rather than x as a quadratic in y". **Confirmed.** The Muller page fits P(x) = f(p₂) + b(x − p₂) + d(x − p₂)², and its line 50 describes Brent the same way in reverse.
10. Line 59: "Newton-Raphson converges quadratically at a simple root but needs f′ and keeps no bracket". **Confirmed.** This is the standard local result; the Newton page (line 24) states the C² hypothesis, and the shorthand matches the wording used elsewhere on the site.
11. Line 67: heading id `{#case-1}`. **Confirmed.** It matches the link `#case-1` on line 45.
12. Line 75: heading id `{#case-2}`. **Confirmed.** It matches the link `#case-2` on line 59.
13. Line 58 link targets: `../bisection-method/`, `../secant-method/`. **Confirmed:** both folders exist with an index.qmd.
14. Line 59 link targets: `../false-position-or-regula-falsi-method/`, `../mullers-method/`, `../newton-raphson-method/`. **Confirmed:** all three folders exist with an index.qmd.

Checked for consistency with the rest of the page:
- Case 1's Behavior errors for steps 5–8 (3.2e-4, 5.5e-6, 2.7e-9, 4.0e-19) agree with my values (3.237e-4, 5.461e-6, 2.738e-9, 3.98e-19). The step-8 b is the double nearest the root, with f(b) = 0.0.
- The Case 2 sequence (10 steps, ending in Min step, b = 1.1655611852, width 5.0e-11) also matches my run.
- I found no contradiction between the new text and the Animations sections or the table.

## 3. Checks

**Independent computation.** I wrote my own transcription of Brent's zeroin in Python and found the reference roots with mpmath at 50 digits:
- Case 1 root: 0.328538458611414896.
- Case 2 root: 1.165561185207211307.

My implementation reproduces the script's legend values in the frames step for step.

**The six points of the standard:**
1. The problem: present (line 12, a bracketed root of a continuous f).
2. The core formula: present. The IQI and secant displays use the page's a, b, c notation, and the script's p/q form is algebraically the same step.
3. What it assumes: present (f continuous, sign change, no derivatives).
4. How accurate it is: present. Guaranteed convergence, plus order ≈1.839 "when IQI applies consistently near a simple root"; the new link to Case 1 is checked and qualified correctly.
5. When it fails or misleads: present. The x⁹ example is slower than bisection; it is not animated, so there is no case link, which is acceptable.
6. Where it fits: present (added by this batch, lines 58–59).

Nothing the standard leaves out (proofs, callout boxes) is present. The comparison table is not a worked example.

**Word count:** 502, over the 400 limit (F1).

**Links and anchors:** all 5 page links resolve, and both explicit ids match their links.

**Diff scope:** inside the Description there are additions only. Outside it, the only changes are the two heading ids. The Animations introduction and the Behavior text are unchanged, and no sentence was moved. All of this is allowed.

**Fidelity:** I consulted Mathews' module. It has nothing that conflicts with the new text; the bisection/regula falsi/IQI naming is discussed under claim 5.
