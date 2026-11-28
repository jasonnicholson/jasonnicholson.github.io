# Adams-Bashforth-Moulton Method — batch 22 review, round 2 (overview mode)

SUMMARY: 0 Error, 1 Misleading, 1 Minor

Review of `pages/numerical-methods/adams-bashforth-moulton-method/index.qmd` (light-pass batch 22, overview page, action *extend*). The diff changes only `index.qmd`. No script or GIF changed, so the animations are out of scope. I consulted the Mathews archive: `n2003/AdamsBashforthMod.html` text, plus images `_gr_16` to `_gr_30` (the theorem formulas). I did not read anything under `reviews/`, and I did not run MATLAB or quarto. My scratch files are in `EV/reviewer/`: `chk.py`, `chk2.py`, `wc.py` and `thm.png`.

## 1. Findings

**F1: Page text, Misleading.** Description line 32: "[Case 1](#case-1) does not show the $h^4$ rate: on its frames stability, not truncation, sets the error, and the error in $y(5)$ falls by a factor of 190 from $m = 70$ to $m = 80$, where $h^4$ falls by only 1.7."

- **What is right.** The main claim is correct: Case 1 does not show $h^4$. The quoted numbers are also correct: 190.3 against 1.706.
- **What is wrong.** The clause "on its frames stability, not truncation, sets the error" says this holds for every frame. It is false for the last three frames, m = 100, 120 and 150.
- **Contradiction with the Animations section.** The clause contradicts the page's own Animations paragraph at lines 73–76: "for m=100, 120 and 150 it is below 10^-8 there, and the error at t=5 is smaller still". The Animations side is the correct one.
- **Evidence.** I ran `EV/reviewer/chk.py`, which uses my own ABM4 implementation and a DOP853 reference at rtol 1e-13. Below, "growth" means |error at t=5| divided by |error at the last grid point before the shaded onset |:

  | m | Growth after onset | What it means |
  |---|---|---|
  | 70 | 186 | instability amplifies the error |
  | 80 | 9.3 | instability amplifies the error |
  | 90 | 4.3 | instability amplifies the error |
  | 100 | 0.54 | error shrinks after onset |
  | 120 | 0.51 | error shrinks after onset |
  | 150 | 0.82 | error shrinks after onset |

  For every m ≥ 80, the largest error of the run occurs before the onset, at t ≈ 3.3–3.4. It is 2.6e-5 at m = 80, 8.5e-6 at m = 100, 3.5e-6 at m = 120 and 1.2e-6 at m = 150. That error is truncation error, not instability.
- **Suggested fix.** Restrict the clause to the frames where it holds, for example: "Case 1 does not show the $h^4$ rate: up to $m = 90$ the instability in the shaded tail amplifies the error in $y(5)$ (by a factor of 186 at $m = 70$), so it falls by a factor of 190 from $m = 70$ to $m = 80$, where $h^4$ falls by only 1.7."

**F2: Page text, Minor.** Line 37: "at $m = 12$, $y(5)$ is off by only $0.013$".

- **What is there.** The number is correct (1.33e-2). However, the exact value is 0.0081199, so this error is 1.64 times the exact value, and the computed y(5) = 0.0214 is 2.64 times it.
- **Why it matters a little.** The Animations section (lines 61–62) states this caveat. The Description does not, so "only" can suggest a good end value. The sentence's real point still holds: the end value hides the 0.74 error at t ≈ 4.17.
- **Suggested fix.** "is off by only $0.013$ in absolute terms", or drop "only".

## 2. Claim ledger (the + lines of the diff)

| # | Claim (page's words, condensed) | Verdict | Evidence |
|---|---|---|---|
| L1 | ABM is a predictor-corrector multistep scheme for $y'=f(t,y)$, $y(t_0)=y_0$, on the grid $t_n=t_0+nh$ | confirmed | script uses a uniform grid; Mathews uses the same setup |
| L2 | One-step methods (Euler, Heun, RK) use only the current point; ABM reuses the slopes $f_k$ at the four latest points | confirmed | Mathews' introduction; the predictor uses $f_{n-3}..f_n$ |
| L3 | Predictor $p_{n+1}=y_n+\frac{h}{24}(55f_n-59f_{n-1}+37f_{n-2}-9f_{n-3})$ | confirmed | matches script line 57 and Mathews image 17; sympy check below |
| L4 | Corrector $y_{n+1}=y_n+\frac{h}{24}(9f(t_{n+1},p_{n+1})+19f_n-5f_{n-1}+f_{n-2})$ | confirmed | matches script line 60 and Mathews image 18 |
| L5 | Both formulas integrate a cubic that interpolates the slopes over $[t_n,t_{n+1}]$: the predictor through the four past slopes, the corrector through three past slopes and the predicted one | confirmed | sympy integration of the Lagrange basis gives [55,−59,37,−9] at nodes {0,−1,−2,−3} and [9,19,−5,1] at nodes {1,0,−1,−2} (`chk2.py`) |
| L6 | With past slopes stored, a step needs only two new f evaluations, at $p_{n+1}$ and $y_{n+1}$ | confirmed | true of PECE; Mathews says the same. The script recomputes the stored slopes each step, which is a performance matter only and not a contradiction |
| L7 | Mathews' theorem assumes f is continuous and Lipschitz in y | confirmed | Mathews' theorem text |
| L8 | The coefficients assume a fixed step h | confirmed | the formulas are derived on a uniform grid |
| L9 | Not self-starting; $y_1,y_2,y_3$ come from a one-step method accurate to $O(h^4)$, usually RK4 | confirmed | Mathews' remark; script lines 40–49 use RK4; starting errors of $O(h^4)$ keep the global error at $O(h^4)$ |
| L10 | If $y\in C^5[t_0,b]$, the local truncation error is $O(h^5)$ and the global error is $O(h^4)$; halving h divides the error by about 16 | confirmed (general) | Mathews' precision theorem (images 25, 27, 29) matches, hypothesis included |
| L11 | The predictor and corrector have the same order; $y(t_{n+1})-y_{n+1}\approx-\frac{19}{270}(y_{n+1}-p_{n+1})$ when $y^{(5)}$ changes little | confirmed | error constants 251/720 and −19/720 give −19/270. Numerically on y′=y with exact history, the ratio of true error to estimate is 0.60, 0.80, 0.90 at h = 0.1, 0.05, 0.025, tending to 1 |
| L12 | The error estimate can steer the choice of h | confirmed | standard use; Mathews' introduction says the same |
| L13 | Case 1 does not show the $h^4$ rate | confirmed | y(5) error ratios: 70→80 190, 80→90 37, 90→100 65, 100→120 7.9, 120→150 4.2; $h^4$ ratios: 1.71, 1.60, 1.52, 2.07, 2.44 |
| L14 | "on its frames stability, not truncation, sets the error" | wrong for m = 100–150 | **F1** |
| L15 | The error in y(5) falls by a factor of 190 from m = 70 to 80; $h^4$ falls by 1.7 | confirmed | 2.081e-3 / 1.094e-5 = 190.3; (80/70)^4 = 1.706 |
| L16 | Conditionally stable: on $y'=\lambda y$ with real λ<0, errors are damped only while $h|\lambda|\le1.285$ | confirmed | my own companion matrix built from the PECE recurrence gives the limit z = −1.284816; the stable set on [−3,0) is contiguous, so "only while" is right |
| L17 | Case 1: $y'=1-t\sqrt[3]{y}$, y(0)=1, decays to y(5)=0.0081199 | confirmed | DOP853: 0.0081199205; matches script header and frames |
| L18 | $\partial f/\partial y=-t/(3y^{2/3})$ reaches −41.3 at t=5 | confirmed | −41.255; |∂f/∂y| increases monotonically in the tail (t up, y down), so t=5 is the extreme |
| L19 | By frozen-coefficient analysis, $h|\partial f/\partial y|$ passes 1.285 before t=5 in every frame | confirmed | onset at t = 2.826 (m=12) through 4.890 (m=150); every frame shows the shaded band |
| L20 | For m = 12 to 60 the run leaves the reference in the tail | confirmed | frames 1–15; max errors 0.096–0.736 |
| L21 | Largest error is between 0.096 and 0.74 | confirmed | min 0.0956 (m=60), max 0.736 (m=12) |
| L22 | y(5) jumps between −0.363 and 0.632 | confirmed | min −0.36284 (m=20), max 0.63215 (m=16) |
| L23 | At m=12, y(5) is off by only 0.013 | confirmed numerically; wording is F2 | error +1.33e-2, i.e. 1.64 times the exact value |
| L24 | At m=12 the run is off by 0.74 at t≈4.17 | confirmed | 0.736 at t = 4.1667; frame 1 shows the spike |
| L25 | Predictor-Corrector Methods gives the general framework; Milne-Simpson is the other fourth-order PC pair; RK supplies starting values; RKF is a one-step adaptive alternative | confirmed | all four pages exist. The Milne-Simpson page is fourth order. No Hamming page exists on the site, so "the other" holds within the site |
| L26 | Heading id `{#case-1}` added to the Case 1 heading | confirmed | the only edit outside the Description; the heading text is unchanged; `[Case 1](#case-1)` resolves |

## 3. Checks

**Six points of the overview standard: all present, in order.**

1. The problem: line 12.
2. The core formula: lines 16–22, in display math, in the script's notation.
3. What it assumes: lines 27–28.
4. How accurate it is: lines 30–32, stated as a general result with $C^5$, and the link to Case 1 is qualified correctly as not showing the rate.
5. When it fails or misleads: lines 34–37, linked to Case 1 and checked against my own runs.
6. Where it fits: line 39.

There are no proofs, callout or theorem boxes, or MATLAB or Mathematica procedures.

**Word count.** Prose is 399 words with each inline math expression counted as one word, ignoring bare punctuation left after removing the math (`wc.py`). This is within the 150–400 limit, at the top of it.

**Links and anchors.**
- `../eulers-method-for-odes/`, `../heuns-method/`, `../predictor-corrector-methods/`, `../milne-simpsons-method/`, `../runge-kutta-method/` and `../runge-kutta-fehlberg-method/` all exist as folders with an `index.qmd`.
- `#case-1` matches the explicit id added to the Case 1 heading.

**Scope of the diff.**
- The Description is rewritten. The removed old sentences were Description text, so removing them is allowed.
- Outside the Description, the only change is `{#case-1}` on the Case 1 heading, which the standard allows.
- No script or GIF changed.

**Consistency with the rest of the page.**
- All figures agree with the Animations Behavior paragraphs (lines 54–80): 0.0081199, −41.3, 1.285, 0.096/0.74, −0.363/0.632, 0.013, 0.74 at 4.17.
- The one exception is F1's clause, which contradicts lines 73–76.

**Frames checked.** I looked at frame 1 (m=12), frame 16 (m=70), frame 17 (m=80) and frame 21 (m=150). Their labels match my computation:
- m=12: y(5)=0.0214088, error +1.3e-2.
- m=70: error +2.1e-3.
- m=80: error −1.1e-5.
- m=150: error −1.4e-10. My value is −1.36e-10.
- The shaded onsets in the frames are 2.83, 3.82, 3.99 and 4.89, which match my computation.

**Fidelity to Mathews.** The formulas, the Lipschitz hypothesis, the $C^5$ precision theorem and RK starting values all match the module. There is no fidelity finding.


## Independent check of F1

**F1: confirmed. The Misleading severity fits.**

**Method.** I reimplemented the page's ABM4 scheme in Python, following `adamsbashforthmoultonaa.jl`: RK4 start, then PECE (predict, evaluate, correct, evaluate). My reference was scipy DOP853 at rtol 2.2e-14 with dense output. I did not use the script's RK4 grid, because for m = 90, 120 and 150 the run's grid points don't land on it and the reference picks up spurious errors of about 1e-5. Script: `/tmp/claude-1001/-home-jason--claude-spares-spare-0ogoFf/f6c51b48-3d53-4b4d-8872-653429a6389a/scratchpad/work/review-22r2/adams-bashforth-moulton-method/checker/chk2.py`. My y(5) errors match the page: 2.08e-3 (m=70), -1.09e-5 (m=80), -4.49e-9 (m=100), -1.36e-10 (m=150).

**Per frame.** Columns: error at the last step before the shaded onset; largest error after onset; error at t=5; largest error of the whole run and where it occurs.

| m | pre-onset | max post-onset | e(5) | largest error |
|---|---|---|---|---|
| 70 | 1.1e-5 | 2.1e-3 | 2.1e-3 | in the tail |
| 80 | 1.2e-6 | 1.1e-5 | 1.1e-5 | 2.6e-5 at t≈3.38, before onset |
| 90 | 6.9e-8 | 2.9e-7 | 2.9e-7 | 1.5e-5 at t≈3.33 |
| 100 | 8.3e-9 | 8.3e-9 | 4.5e-9 | 8.5e-6 at t≈3.35 |
| 120 | 1.1e-9 | 1.1e-9 | 5.7e-10 | 3.5e-6 at t≈3.33 |
| 150 | 1.7e-10 | 1.7e-10 | 1.4e-10 | 1.2e-6 at t≈3.30 |

- **m = 12 to 70:** errors grow by 2 to 3 orders of magnitude after onset, so stability does set the error. The factor of 190 between m=70 and m=80 is right, and so is the h^4 factor of 1.7.
- **m = 100, 120, 150:** the error does not grow after onset; it shrinks from its pre-onset value to t=5. The largest error of each run occurs before onset, near t≈3.3, which is truncation error. It falls roughly like h^4: 2.44 vs 2.07 from m=100 to 120, and 2.9 vs 2.44 from m=120 to 150. Stability does not set the error in these three frames.
- **m = 80, 90:** the y(5) error is amplified after onset, but each run's largest error is still the pre-onset truncation error.
- **Why y(5) still falls faster than h^4 for large m:** this is a property of the strongly damped tail, not of instability. With no unstable region at all (m = 200 to 800), the y(5) error still drops by about 38 from m=200 to 400 and about 28 from m=400 to 800, against 16 for h^4.

**Contradiction with the Animations section.** That section (lines 75–76) says the error at the last step before onset is below 1e-8 for m = 100, 120 and 150, that the t=5 error is smaller still, and that h=0.0311 is "a linear stability bound, not an accuracy threshold". That means crossing the bound does not spoil those frames, which is the opposite of the Description's blanket "on its frames stability, not truncation, sets the error".

**Severity.** The first clause, that Case 1 does not show the h^4 rate in its displayed y(5) errors, holds for every pair of neighbouring frames, and the m=70→80 example is correct. The stated reason is true for m=12 to 70 and false for m=100 to 150. A reader would conclude that every frame is limited by stability, which the page's own Animations section refutes. That is Misleading; Error is arguable, since "its frames" reads as all of them.

**Suggested fix:** narrow it to something like "on the frames up to m≈80, stability, not truncation, sets the error in y(5) …", and for the finest frames say that the damped tail, not stability, keeps the y(5) error falling faster than h^4.
