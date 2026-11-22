# Brent's Method — animation review

Page: [`pages/numerical-methods/brents-method/index.qmd`](../../pages/numerical-methods/brents-method/index.qmd) · Scripts: `brentsaa.jl`, `brentsbb.jl` · GIFs: 2

**Result:** 3 error, 2 misleading, 2 minor.

Errors and misleading findings were each re-checked by an independent subagent given only the allegation (not the reviewer's reasoning). Minor findings were not independently re-checked. Finding IDs (F1, F2, …) are the reviewer's and match the claim ledger below.

## Findings

### F1 — Error — Page match — Case 1 root is quoted as 0.3268; the true root is 0.32854

- **Location:** index.qmd:66, "The true root is $x^* \approx 0.3268$". index.qmd:70, alt text "to the root at x≈0.3268". Also brentsaa.jl:3 (comment), "Root (i) ≈ 0.3224".
- **Now:** The page gives 0.3268 and the script header gives 0.3224.
- **True:** The root of $4x^3-16x^2+17x-4$ in [0,1] is $x^* = 0.32853845861141\ldots$. The other two roots are 1.26466 and 2.40680. The GIF's own last frame (frame_011) shows "b = 0.328538", which contradicts the page.
- **Evidence:** `brent_compare.py` gives the mpmath root 0.32853845861141489597 (residual 0) and `polyroots` gives [0.328538458611415, 1.26465829006442, 2.40680325132417]. The script's final iterate is 0.32853845861121722, an error of 2.0e-13.
- **Suggested fix:** Use $x^* \approx 0.3285$ at line 66 and "x≈0.3285" at line 70. Fix the comment at brentsaa.jl:3 to "Root ≈ 0.3285".

- **Independent check:** confirmed.

### F2 — Error — Page match — Case 1 Behavior misstates the sequence of steps

- **Location:** index.qmd:66, "Brent's method begins with secant steps and quickly switches to IQI, converging superlinearly."
- **Now:** The page describes a run that starts with several secant steps and then settles into IQI.
- **True:** The frames are labelled, in order: Secant, Bisection, IQI, Secant, Bisection, Bisection, Bisection, Secant, Secant, IQI (10 steps).
  - Only step 1 is a secant step before the first bisection.
  - IQI is accepted only at steps 3 and 10.
  - In between come three consecutive bisections (steps 5–7).
  - The fast convergence happens only in the last three steps (8–10).
- **Evidence:** `julia instr_aa.jl` printed the step labels above. Steps 5–7 rejected interpolation candidates 0.328215 (IQI), 0.329259 and 0.328822 (secant), which were already within 7e-4 of the root. They bisected to 0.28345, 0.31137 and 0.32533 instead. See F4 for why.
- **Suggested fix:** Describe what the animation shows. For example: "After an initial secant step and a bisection, the method alternates interpolation and bisection steps (including three bisections in a row at steps 5–7). It then converges rapidly with secant, secant and IQI steps, reaching $|f(b)| \approx 1.5\times10^{-12}$ after 10 steps." Alternatively, change the algorithm (F4) and rewrite the paragraph from the new run. ZEROIN's sequence is S, B, I, S, I, S, S, I in 8 steps.

- **Independent check:** confirmed.

### F3 — Error — Page match — The Description says a rejected IQI step falls back to the secant step

- **Location:** index.qmd:34, "otherwise bisection or secant is used instead". index.qmd:38, "When only two distinct function values are available (or IQI is rejected), the method falls back to the secant step".
- **Now:** The page says that when an IQI step is rejected, the method falls back to the secant step.
- **True:** In the scripts, and in Brent's algorithm, the candidate is IQI if three distinct f-values are available and secant otherwise. If that one candidate fails the acceptance test, the step is a **bisection**. No IQI→secant fallback exists. Secant is used only when IQI cannot be formed (`fa == fc` or `fb == fc`, brentsaa.jl:51–61).
- **Evidence:** `instr_aa.jl` and `instr_bb.jl` print `cand=IQI ... final=Bisection` at Case 1 steps 2 and 5 and at Case 2 steps 2 and 3. No step anywhere goes from an IQI candidate to a secant step.
- **Suggested fix:** At line 34, write "...otherwise a bisection step is taken instead." At line 38, write "When only two distinct function values are available, the method uses the secant step". Delete "(or IQI is rejected)".

- **Independent check:** confirmed. Checker: line 38 is wrong; line 34 is partly wrong.

### F4 — Misleading — Implementation — The scripts run a modified Wikipedia pseudocode variant, not Brent's algorithm, and its step labels differ from Brent's

- **Location:** brentsaa.jl:44–94 and brentsbb.jl:41–91, in particular brentsaa.jl:66 (`cond1 = !(lo < s < hi)`), brentsaa.jl:69–70 (cond4 and cond5) and brentsaa.jl:80–81 (`d = c; c = b`). The same logic is at brentsbb.jl:63, 66–67 and 77–78. Page line 60 says the annotation shows "which sub-method ... was selected".
- **Now:** The code is the Wikipedia "Brent's method" pseudocode: `mflag`, conditions 1–5, `c` = previous b, `d` = previous c. It has one further change. Condition 1 tests "s strictly inside (a,b)" where Wikipedia tests "s between (3a+b)/4 and b", which corresponds to Brent's own 3/4 test. The page presents the run as Brent's method without naming the variant.
- **True:** The Wikipedia scheme is a reformulation of Brent's method, not Brent's ZEROIN, and the two pick different step types on both page cases.
  - In this scheme, a step that moves only the contrapoint `a` leaves `b` unchanged. The next iteration then has `c == b`, or `c == d`. Condition 4 (`mflag && |b−c| < tol`) or condition 5 (`!mflag && |c−d| < tol`) is then true whatever the candidate, so a bisection is forced.
  - ZEROIN has no such rule. It accepts an interpolation step if the step is less than 3/4 of the way to the contrapoint and less than half the step before last.

  Step-by-step comparison from the same start, with tol = 1e-10:

  | Case | step | script (Wikipedia variant) | Brent ZEROIN (= scipy brentq) |
  |---|---|---|---|
  | 1 | 1–4 | S, B, I, S (identical iterates) | S, B, I, S |
  | 1 | 5 | **Bisection** (rejected IQI 0.328215 by cond3+cond5) | **IQI** → 0.328215 |
  | 1 | 6 | **Bisection** (rejected secant 0.329259 by cond2+cond4) | **Secant** → 0.328544 |
  | 1 | 7 | **Bisection** (rejected secant 0.328822) | **Secant** → 0.32853846 |
  | 1 | total | 10 steps, ends with S, S, I | 8 steps (10 f-evals), ends with I |
  | 2 | 1–3 | S, B, B (identical iterates) | S, B, B |
  | 2 | 4 | **Bisection** (rejected secant 1.118293 by cond2+cond4) | **Secant** → 1.118293 |
  | 2 | total | 9 steps: S B B B I S S I S | 10 steps: S B B S I S S I S S |

  The three-bisection run in Case 1 (F2) is an artifact of this variant: real Brent would not take those steps. The looser condition 1 has no effect on these two runs. A faithful Wikipedia implementation with the (3a+b)/4 test gives identical iterates on both cases. It does make the code differ from both Wikipedia and Brent.
- **Evidence:** `/usr/bin/python3 brent_compare.py`, with output in `brent_compare.out`. The section "script variant re-implemented" reproduces the Julia iterates to all printed digits. The "Brent ZEROIN" and "scipy brentq" sections agree on the final root and on the function-call count (10 and 12).
- **Suggested fix:** There are two options.
  - (a) Replace `run_brents` with a ZEROIN-style loop: contrapoint `c`, previous iterate `a`, step sizes `d`/`e`, acceptance test `2p < 3·xm·q − |tol1·q|` and `p < |e·q/2|`. Then regenerate the GIFs and redo the Behavior paragraphs (F2).
  - (b) Keep the code but say on the page that it is the Wikipedia formulation of Brent's method. Restore condition 1 to "s not between (3a+b)/4 and b".

  Option (a) makes the labels match what Brent's method chooses.

- **Independent check:** confirmed. Checker: a faithful ZEROIN port evaluates exactly the same points as scipy brentq; the script matches it through step 4 (Case 1) / step 3 (Case 2), then forces bisections where Brent accepts the same candidate. Frames 5–7 of brentsaa.gif and frame 4 of brentsbb.gif carry labels Brent's method would not produce.

### F5 — Misleading — Page match — The Description's convergence guarantee is false

- **Location:** index.qmd:44, "**Guaranteed**: At worst, the method halves the bracket at every other step (like bisection), ensuring $O(2^{-n})$ convergence."
- **Now:** The page claims the bracket at least halves every two steps.
- **True:** Brent's safeguard guarantees that the *step size* halves every two steps. It does not guarantee that the *bracket* does. Brent's worst-case bound is about $(\log_2((b-a)/\delta))^2$ evaluations, not 2× bisection. On flat functions both the script's variant and genuine Brent take far more steps than bisection, and have many two-step windows where the bracket does not halve. (The claim does hold on the two page cases.)
- **Evidence:** `/usr/bin/python3 halving_check2.py`. On $(x-0.3)^9$ over [0,2], the script's variant takes 82 steps with 28 two-step windows that do not halve (e.g. width 2 → 1.97, 0.492 → 0.403). Brent ZEROIN takes 97 steps, scipy brentq makes 99 calls, and bisection needs 35 steps. On $x^5$ over [−1,4]: the variant takes 63 steps, ZEROIN 92, bisection 36. `halving_check.py` confirms that the bracket does halve every two steps on both page cases and on three smooth test functions.
- **Suggested fix:** "Guaranteed: Brent's method always keeps a valid bracket and converges. Its safeguards force a bisection whenever interpolation is not making enough progress, so in the worst case it needs at most about $(\log_2((b-a)/\delta))^2$ function evaluations, compared with $\log_2((b-a)/\delta)$ for bisection."

- **Independent check:** confirmed. Checker: on x^9 over [−1,2] both ZEROIN and the script halve the bracket only about once every three steps (width 1.25e−4 after 40 steps vs claimed bound 2.9e−6); ZEROIN needs 116 evaluations vs ≈42 for bisection.

### F6 — Minor — Page match — Case 2's comparison with regula falsi: "≈ 243 iterations" cannot be reproduced, and "chord always lands near x = 0.5" is wrong

- **Location:** index.qmd:74, "the Regula Falsi method requires ≈ 243 iterations on this same interval — because $f(1.5)$ is so large that the chord always lands near $x = 0.5$, leaving the right endpoint stationary."
- **Now:** The page gives 243 iterations with no tolerance, and says the chord always lands near 0.5.
- **True:** The right endpoint does stay at 1.5 throughout. f is convex on the interval, and after 1000 iterations b is still 1.5. Convergence is linear with error ratio 0.866.
  - The chord points do not stay near 0.5. They march steadily rightward: 0.539, 0.579, 0.619, 0.659, 0.698, … → 1.1656.
  - The iteration count depends on a tolerance the page does not give:

    | Stopping rule | tol = 1e-6 | tol = 1e-8 | tol = 1e-10 | tol = 1e-12 | tol = 1e-14 |
    |---|---|---|---|---|---|
    | \|x−x*\| < tol | 100 | 133 | 165 | 197 | 229 |
    | \|f\| < tol | 111 | 143 | 175 | 207 | 240 |
    | \|Δx\| < tol | 87 | 119 | 152 | 184 | 216 |

    No standard tolerance gives 243. The nearest is \|f\| < 1e-14, which gives 240.
- **Evidence:** `/usr/bin/python3 regula_falsi_counts.py`.
- **Suggested fix:** "…while Regula Falsi needs about 165 iterations to get within $10^{-10}$ of the root on this same interval. f is convex here, so every chord lands left of the root, the right endpoint stays fixed at 1.5, and the left endpoint creeps toward the root (error shrinking only by a factor of ≈ 0.87 per step)."

- **Independent check:** not run (minor finding, unverified).

### F7 — Minor — Page match — The Description mixes two incompatible labelings of a, b, c

- **Location:** index.qmd:24–26, "$f(b)\cdot f(c)\le 0,\ |f(b)|\le|f(c)|$ … $a$ is the previous value of $b$. The root is guaranteed to lie in either $[b, c]$ or $[a, b]$". Compare index.qmd:60, "The shaded region marks the current bracket $[a, b]$".
- **Now:** Lines 24–26 use Brent's original labelling: c is the contrapoint and a is the previous b. Line 60 and the scripts use the Wikipedia labelling: a is the contrapoint, so the bracket is [a,b], and c is the previous b.
- **True:** Under the invariant stated at line 24, the root lies in [b, c]. "Either [b,c] or [a,b]" is not a property of either labelling; it comes from mixing the two. With line 60's labelling, the root is in [a,b] and c is the previous b. A reader who follows the Description will misread the animation's [a,b]. The two-point secant formula at line 40 also means different things in the two labellings: previous iterate versus contrapoint.
- **Evidence:** brentsaa.jl:80–91 (`c = b`; b or a replaced so that f(a)f(b)<0; then the swap to keep |f(b)| ≤ |f(a)|), compared with page lines 24–26.
- **Suggested fix:** Adopt the script's labelling throughout. Write "$f(a)\,f(b) < 0$, $|f(b)| \le |f(a)|$; $b$ is the current best approximation, $a$ is the contrapoint, and $c$ is the previous value of $b$. The root lies in $[a,b]$." Alternatively, keep Brent's labelling and change line 60 to $[b,c]$.

- **Independent check:** not run (minor finding, unverified).

## Inventory (Phase 1)

Every script was copied to scratch and run with the global Julia environment (Plots 1.41.2, SpecialFunctions 2.9.2); each was also run alone to map scripts to GIFs.

| Script | Ran | Time (s) | GIFs produced |
|---|---|---|---|
| `brentsaa.jl` | yes | 3.7 | brentsaa.gif |
| `brentsbb.jl` | yes | 3.6 | brentsbb.gif |

Committed GIFs byte-identical to their regenerated output: **2 of 2**. Decoded frames were also compared; all match.

Inventory findings: none (every script runs, every GIF is produced by a script and embedded by the page, every page reference exists, and the section index links the page).

## Claim ledger

| # | index.qmd line | Claim (page's own words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | 12 | "requires only that the function $f$ be continuous on $[a, b]$ with $f(a)$ and $f(b)$ of opposite sign — no derivatives are needed" | Code uses only f-values | confirmed |
| 2 | 14 | maintains a bracket that always contains a root, selects among three sub-methods | Code keeps f(a)f(b)<0 (lines 83–91); IQI, secant and bisection branches | confirmed |
| 3 | 16 | IQI "fits a quadratic through the three most recent points (a,f(a)),(b,f(b)),(c,f(c)) and uses the x-intercept" | The formula is inverse (x as a quadratic in y), and its result equals ZEROIN's IQI exactly (0.2276058019715, 3.829009299). "Three most recent" is loose because a is the contrapoint. | confirmed (wording loose) |
| 4 | 16 | IQI "Converges superlinearly near a simple root" | Standard; order 1.839 | confirmed |
| 5 | 17 | Secant "used as a fallback when inverse quadratic interpolation cannot be used" | brentsaa.jl:51–61 | confirmed |
| 6 | 18 | Bisection "used as a safeguard ... guarantees the bracket shrinks by at least half" | Every Bisection frame exactly halves the width (e.g. 0.112 → 0.0558 → 0.0279 → 0.0140) | confirmed |
| 7 | 24–26 | invariant f(b)f(c) ≤ 0, \|f(b)\| ≤ \|f(c)\|; a = previous b; "root ... in either [b,c] or [a,b]" | Conflicts with the [a,b] labelling at line 60 and in the scripts | wrong (→ F7) |
| 8 | 32 | IQI formula (Lagrange form in a, b, c) | Identical to brentsaa.jl:53–55; values agree with ZEROIN's IQI | confirmed |
| 9 | 34 | IQI "accepted only if s falls inside the current bracket and the method is making adequate progress; otherwise bisection or secant is used instead" | Rejected IQI always becomes a bisection | wrong (→ F3) |
| 10 | 38 | "(or IQI is rejected), the method falls back to the secant step" | Same as #9 | wrong (→ F3) |
| 11 | 40 | Secant formula $s = b - f(b)(b-a)/(f(b)-f(a))$ | Identical to brentsaa.jl:59 | confirmed |
| 12 | 44 | "halves the bracket at every other step ... ensuring $O(2^{-n})$ convergence" | Counterexamples in halving_check2.py | wrong (→ F5) |
| 13 | 45 | IQI order ≈ 1.839, the positive real root of $t^3=t^2+t+1$ | numpy root 1.839286755 | confirmed |
| 14 | 46 | "cannot fail to converge as long as the initial bracket is valid and f is continuous" | Bracket preserved; every test converged (up to 82 or 97 steps) | confirmed |
| 15 | 50–56 | Table of guarantees and orders (bisection 1, regula falsi linear, secant ≈1.618, IQI ≈1.839, Brent up to ≈1.839) | Standard values | confirmed |
| 16 | 60 | "shaded region marks the current bracket [a, b] known to contain a root" | brentsaa.jl:126–129 shades from st.a to st.b; f(a)f(b)<0 at every recorded step | confirmed |
| 17 | 60 | "red dot tracks b, the best current approximation (the endpoint with the smallest \|f\| value)" | brentsaa.jl:132; the label values match the instrumented b | confirmed |
| 18 | 60 | "step annotation indicates which sub-method — Bisection, Secant, or IQI — was selected at that iteration" | True of the code's own choice. These choices are not Brent's at Case 1 steps 5–7 and Case 2 step 4. | confirmed for the code; see F4 |
| 19 | 62 | Julia scripts linked under each case | Lines 68 and 76 link brentsaa.jl and brentsbb.jl; each produces its GIF (manifest) | confirmed |
| 20 | 64 | Case 1: $f(x)=4x^3-16x^2+17x-4$, $[0,1]$ | brentsaa.jl:10, 12–13; title in frames | confirmed |
| 21 | 66 | $f(0)=-4<0$, $f(1)=1>0$ | Computed −4 and 1 | confirmed |
| 22 | 66 | "The true root is $x^*\approx 0.3268$" | 0.328538458611415 | wrong (→ F1) |
| 23 | 66 | "begins with secant steps and quickly switches to IQI, converging superlinearly" | S,B,I,S,B,B,B,S,S,I | wrong (→ F2) |
| 24 | 66 | "far fewer iterations than bisection or regula falsi would require" | Script: 10 steps to error 2e-13. Regula falsi: 24 steps to \|x−x*\|<1e-10. Bisection: 34 steps. | confirmed |
| 25 | 70 | Alt text: "bracket narrows from [0,1] to the root at x≈0.3268, with step labels showing bisection, secant, and IQI" | Narrowing and labels confirmed; root value is wrong | wrong (→ F1) |
| 26 | 70 | Embed of brentsaa.gif under Case 1 | Manifest: produced by brentsaa.jl, byte-identical | confirmed |
| 27 | 72 | Case 2: $f(x)=\tan x-2x$, $[0.5,1.5]$ | brentsbb.jl:10, 12–13; title in frames | confirmed |
| 28 | 74 | Root of $\tan x=2x$ at $x^*\approx1.1656$ | mpmath 1.16556118520721 | confirmed |
| 29 | 74 | $f(0.5)\approx-0.454$, $f(1.5)\approx11.1$ | −0.453698, 11.1014 | confirmed |
| 30 | 74 | "Brent's method converges in a handful of steps" | 9 steps to \|f\| = 6.7e-14 | confirmed |
| 31 | 74 | "Regula Falsi method requires ≈ 243 iterations on this same interval" | 152–240 depending on the unstated tolerance; 243 not reproduced | could not determine: the tolerance is not stated, and no standard criterion gives 243 (→ F6) |
| 32 | 74 | "the chord always lands near x = 0.5" | Chord points 0.539, 0.579, 0.619, … → 1.1656 | wrong (→ F6) |
| 33 | 74 | "leaving the right endpoint stationary" | b = 1.5 after 1000 iterations | confirmed |
| 34 | 74 | "Brent's safeguards against exactly this pathology" | 9 steps against 150+ for regula falsi | confirmed |
| 35 | 78 | Alt text: "bracket narrows from [0.5,1.5] to the root at x≈1.1656, converging in a few steps despite the function blowing up near the π/2 asymptote" | Frames 1–10; asymptote dotted line at π/2 | confirmed |
| 36 | 78 | Embed of brentsbb.gif under Case 2 | Manifest: produced by brentsbb.jl, byte-identical | confirmed |

## Implementation checks

### brentsaa.jl
- **Method:** The Wikipedia "Brent's method" pseudocode, with condition 1 loosened from "between (3a+b)/4 and b" to "inside (a,b)" (F4). It is a legitimate bracketing hybrid. The IQI and secant formulas are correct and give candidate values identical to ZEROIN's in the same state. The acceptance logic is not Brent's, and the step types differ from ZEROIN at steps 5–7.
- **Numbers (script beside independent):**

  | step | script label | script b | Python re-implementation of the variant | ZEROIN type | ZEROIN b |
  |---|---|---|---|---|---|
  | 1 | Secant | 0.8 | 0.8 | Secant | 0.8 |
  | 2 | Bisection | 0.4 | 0.4 | Bisection | 0.4 |
  | 3 | IQI | 0.4 (a→0.2276058019715) | same | IQI | 0.2276058019715 |
  | 4 | Secant | 0.339287812174893 | same | Secant | 0.339287812174893 |
  | 5 | Bisection | 0.339288 (a→0.283447) | same | IQI | 0.328214739745625 |
  | 6 | Bisection | 0.339288 (a→0.311367) | same | Secant | 0.328543919449143 |
  | 7 | Bisection | 0.325327560899469 | same | Secant | 0.328538461349364 |
  | 8 | Secant | 0.328592430741299 | same | IQI | 0.328538458611415 (stop) |
  | 9 | Secant | 0.328538726094048 | same | | |
  | 10 | IQI | 0.32853845861121722 | same | | |

  The script stops after step 10 because \|f(b)\| = 1.5e-12 < tol, with n_iters = 14 not reached. The final error is 2.0e-13.
- **Reference values:** No true root is computed in the script. The header comment value 0.3224 is wrong (F1). The mpmath root is 0.32853845861141490.
- **Picture:** I viewed the contact sheet (all 11 frames) and full-size frame_011.
  - The title function matches the code.
  - The shaded band and dashed lines sit at st.a and st.b.
  - The red dot is at b, with f(b) on the curve, and its legend value matches the instrumented b at every step (1.0, 0.8, 0.4, 0.4, 0.339288, …, 0.328538).
  - The step labels match the instrumented labels.
  - The x-window (−0.15, 3.1) shows all three roots. From step 8 on, the bracket is narrower than about 0.1 % of the window, so frames 9–11 differ only in their labels. This is acceptable because the legend value carries the progress, so it is not listed as a finding.
  - No clamping affects any plotted iterate.

### brentsbb.jl
- **Method:** Same variant as brentsaa.jl (F4). The step types differ from ZEROIN at step 4.
- **Numbers (script beside independent):**

  | step | script label | script b | Python re-implementation of the variant | ZEROIN type | ZEROIN b |
  |---|---|---|---|---|---|
  | 0 | init | 0.5 (swapped, \|f(0.5)\| < \|f(1.5)\|) | same | | |
  | 1 | Secant | 0.539263773114525 | same | Secant | 0.539263773114525 |
  | 2 | Bisection | 1.019631886557262 | same | Bisection | 1.019631886557262 |
  | 3 | Bisection | 1.019632 (a→1.259816) | same | Bisection | 1.259815943278631 |
  | 4 | Bisection | 1.139723914917947 | same | Secant | 1.118293027278579 |
  | 5 | IQI | 1.171380337436373 | same | IQI | 1.176660329525970 |
  | 6 | Secant | 1.165043377068607 | same | Secant | 1.163728583454331 |
  | 7 | Secant | 1.165551041766952 | same | Secant | 1.165492960334821 |
  | 8 | IQI | 1.165561185647063 | same | IQI | 1.165561205052423 |
  | 9 | Secant | 1.1655611852071963 | same | Secant | 1.165561185202631 |

  The script stops after step 9 with \|f(b)\| = 6.7e-14. ZEROIN takes one more step (10 steps, 12 f-evals, matching scipy brentq).
- **Reference values:** The comment value 1.1656 is correct; mpmath gives 1.16556118520721.
- **Picture:** I viewed the contact sheet (all 10 frames).
  - The title matches the code.
  - The tan curve is masked within 0.04 of π/2, and a dotted line marks the asymptote. This is acceptable: it is labelled and does not affect any iterate.
  - The red dot is clamped to the y-limits (brentsbb.jl:133). This never takes effect, because every b has \|f(b)\| < 0.6.
  - The legend values match the instrumented b at each step.
  - The bracket band matches st.a and st.b.
  - The step labels match the instrumented labels.

## Evidence

The reviewer's and checker's computation scripts are copied to [`evidence/brents-method/`](evidence/brents-method/) (`reviewer/` and `verify/`). They were run from a scratch directory; paths inside them point at that scratch area and will need adjusting to re-run.
