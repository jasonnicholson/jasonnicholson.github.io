# Adams-Bashforth-Moulton Method — batch 22 review, round 1 (overview mode)

SUMMARY: 0 Error, 0 Misleading, 1 Minor

# Review: adams-bashforth-moulton-method (light-pass batch 22, overview page, action *extend*)

Scope: the `+` lines of EV/diff.patch, which are the rewritten `## Description` (index.qmd lines 12–39) and the `{#case-1}` id added to the Case 1 heading (line 52). The diff changes no script and no GIF (`git status` shows only index.qmd modified), so the animation itself was not re-reviewed. I looked at frames 1, 16, 17 and 21 to check the Description's claims about Case 1.

Mathews archive consulted: yes. I read `n2003/AdamsBashforthMod.html` as text and viewed its formula images gr_10–gr_31 (predictor, corrector, the ABM theorem, the precision theorem). Evidence scripts are in `EV/reviewer/`: check.py, check2.py, and thm.png (the module's formula images).

I did not run MATLAB, quarto or the page's script. All computation was independent Python.

## 1. Findings

**F1: Minor, Page text (the general accuracy result is missing a hypothesis on the starting values)**
- **Location:** index.qmd lines 28 and 30.
  - Line 28: "the three starting values $y_1$, $y_2$, $y_3$ must come from a one-step method, usually Runge-Kutta."
  - Line 30: "…the local truncation error is $O(h^5)$ and the global error $|y(t_n) - y_n|$ is $O(h^4)$, so … halving $h$ typically divides the error by about 16."
- **What is there now:** Line 30 states the $O(h^4)$ global error with only $y \in C^5$ as its hypothesis (and the Lipschitz condition on line 27). Line 28 allows any one-step method as the starter.
- **What is true instead:** The global $O(h^4)$ rate also needs starting values accurate enough, $O(h^4)$ globally, which in practice means a fourth-order starter. A low-order one-step starter caps the order.
- **Evidence:** ABM4 on $y'=-y+t$, $y(0)=1$, over [0,1], with $m = 10, 20, 40, 80, 160$:
  - RK4 starter: the error ratios under halving are 16.3, 16.5, 16.4, 16.2.
  - Euler starter: the ratios are 4.12, 4.06, 4.03, 4.02, which is second order.
- **Why only Minor:** The sentence is attributed to Mathews' precision theorem, whose own statement leaves this implicit (its Remark says the starting values are "usually computed using the Runge-Kutta method"). The page's script uses RK4, so no number on the page is affected.
- **Suggested fix:** On line 28, write "…must come from a one-step method of fourth order, usually the fourth-order Runge-Kutta method". Alternatively, add "with starting values accurate to $O(h^4)$" to line 30.

No other findings.

## 2. Claim ledger (text added or changed by the diff)

| # | Claim (page's words, abridged) | Verdict | Evidence |
|---|---|---|---|
| 1 | L12: ABM is a predictor-corrector multistep scheme for $y'=f(t,y)$, $y(t_0)=y_0$, on grid $t_n=t_0+nh$ | confirmed | The script uses a uniform grid, `range(t0, tf, length=m+1)`. |
| 2 | L13: Euler, Heun and Runge-Kutta use only the current point; ABM reuses the slopes $f_k$ at the four latest points | confirmed | Matches Mathews' module text and the script (fn, fn1, fn2, fn3). |
| 3 | L14: explicit AB predictor and implicit AM corrector, 4-step form | confirmed | |
| 4 | L17: predictor $p_{n+1}=y_n+\frac{h}{24}(55f_n-59f_{n-1}+37f_{n-2}-9f_{n-3})$ | confirmed | sympy (integrating the Lagrange cubic through $s=0,-1,-2,-3$ over [0,1]) gives [55,−59,37,−9]. Same as the script line `y_pred` and Mathews gr_17. |
| 5 | L21: corrector $y_{n+1}=y_n+\frac{h}{24}(9f(t_{n+1},p_{n+1})+19f_n-5f_{n-1}+f_{n-2})$ | confirmed | sympy, nodes $1,0,-1,-2$, gives [9,19,−5,1]. Same as the script and Mathews gr_18. |
| 6 | L24: both formulas integrate an interpolating cubic over $[t_n,t_{n+1}]$; the predictor's goes through the four past slopes, the corrector's through three past slopes and the predicted one | confirmed | The same sympy construction reproduces both coefficient sets. |
| 7 | L25: with past slopes stored, a step needs only two new $f$ evaluations | confirmed (as a statement about the method) | PECE uses $f(t_{n+1},p_{n+1})$ and $f(t_{n+1},y_{n+1})$. Mathews says the same. The script recomputes the stored slopes each step, but that is implementation efficiency, not a mismatch: the results are identical. |
| 8 | L27: Mathews' theorem assumes $f$ continuous and Lipschitz in $y$; the coefficients assume a fixed $h$ | confirmed | Module text: "Assume that f(t,y) is continuous and satisfies a Lipschits condition in the variable y". The coefficients are derived for equal spacing. |
| 9 | L28: not self-starting; $y_1,y_2,y_3$ from a one-step method, usually Runge-Kutta | confirmed, with the caveat in F1 | Mathews Remark; the script starts with RK4. |
| 10 | L30: if $y\in C^5[t_0,b]$, local truncation error $O(h^5)$ and global error $O(h^4)$; halving $h$ divides the error by about 16 | confirmed as Mathews' theorem; hypothesis gap in F1 | Mathews gr_25–gr_31: $y(t)\in C^5[t_0,b]$, $O(h^5)$, $\|e_k\|=O(h^4)$. Ratios of about 16 confirmed (16.2–16.5) on a test problem with an RK4 start. |
| 11 | L31: predictor and corrector have the same order; $y(t_{n+1})-y_{n+1}\approx-\tfrac{19}{270}(y_{n+1}-p_{n+1})$ when $y^{(5)}$ changes little | confirmed | sympy on $y=s^5$: predictor error constant 251/720, corrector −19/720. The ratio $C_c/(C_p-C_c) = -19/270$. The hypothesis is correctly stated. |
| 12 | L32: Case 1 does not show the $h^4$ rate | confirmed | Error ratios in $y(5)$ between successive frames: 70→80 is 190.3 (where $h^4$ falls by 1.71); 80→90 is 37.2 (1.60); 90→100 is 65.5 (1.52); 100→120 is 7.94 (2.07); 120→150 is 4.17 (2.44). None is near $h^4$. |
| 13 | L32: on its frames, stability, not truncation, sets the error | confirmed (defensible) | Along the reference, $\exp(\int f_y\,dt)$ from the last step before the shaded region to $t=5$ is between 1e−13 and 1e−20, so the ODE itself would wipe out any earlier error. The computed $y(5)$ errors are instead about the size of the error at shading onset (m=100: −8.25e−9 before onset, −4.49e−9 at t=5; m=150: −1.66e−10 and −1.36e−10), or grow (m≤70). So the end error is set by how the method propagates errors in the stiff tail. |
| 14 | L32: the error in $y(5)$ falls by a factor of 190 from m=70 to m=80; $h^4$ falls by only 1.7 | confirmed | Errors 2.081e−3 and −1.094e−5 in my computation, ratio 190.3 in magnitude. $(80/70)^4=1.706$. Frames 16 and 17 show +2.1e−03 and −1.1e−05. |
| 15 | L34: conditionally stable; on $y'=\lambda y$ with real $\lambda<0$ it damps errors only while $h\|\lambda\|\le1.285$ | confirmed | My own 4×4 companion matrix for PECE on $y'=\lambda y$, built directly from the two formulas, has spectral radius ≤1 on all of (−1.2848, 0) (scan with step 1e−4). Root finding gives a limit of −1.284816. |
| 16 | L35: Case 1 is $y'=1-t\sqrt[3]{y}$, $y(0)=1$ | confirmed | Script `f`; frame titles. |
| 17 | L35: the solution decays to $y(5)=0.0081199$ | confirmed | DOP853 with rtol 1e−13 gives 0.0081199205. |
| 18 | L35: $\partial f/\partial y=-t/(3y^{2/3})$ reaches −41.3 at $t=5$ | confirmed | The formula is correct; the value is −41.255. |
| 19 | L35: by frozen-coefficient analysis, $h\|\partial f/\partial y\|$ passes 1.285 before $t=5$ in every frame | confirmed | The largest $m$ with an onset before $t=5$ is 160. Onsets range from t=2.83 (m=12) to t=4.89 (m=150), matching the frame annotations (frames 1 and 21 show 2.83 and 4.89). |
| 20 | L36: for m=12 to 60 the run leaves the reference in the tail | confirmed | Maximum errors are 0.096–0.74, located at t=4.17–5.0. Consistent with the Animations text (m=12–52 break away; m=56 and 60 rise above the reference near t=4.8–4.9). |
| 21 | L36: largest error between 0.096 and 0.74 | confirmed | Smallest maximum error 0.09555 (m=60), largest 0.7364 (m=12). |
| 22 | L36: $y(5)$ jumps between −0.363 and 0.632 | confirmed | Minimum −0.36284 (m=20), maximum 0.63215 (m=16). |
| 23 | L37: at m=12, $y(5)$ is off by only 0.013, while the run is off by 0.74 at $t\approx4.17$ | confirmed | $y(5)$=0.0214088, error +1.33e−2. The largest error, 0.736, is at t=4.167. Frame 1 shows the spike there. |
| 24 | L39: Predictor-Corrector Methods sets out the general framework | confirmed | That page (line 21) says it "sets out the general framework". |
| 25 | L39: Milne-Simpson's Method is "the other fourth-order predictor-corrector pair" | confirmed (in site context) | The predictor-corrector page says "Two fourth-order pairs have their own pages: Adams-Bashforth-Moulton and Milne-Simpson". Hamming's method has no page on the site and no module in n2003, so this is not a finding. |
| 26 | L39: Runge-Kutta supplies the starting values; RKF is a one-step adaptive alternative | confirmed | The script uses an RK4 start. |
| 27 | L52: `{#case-1}` id on the Case 1 heading; L32 links to `[Case 1](#case-1)` | confirmed | The explicit id makes the anchor `case-1`. |

## 3. Checks

**The six points of the overview standard**
1. The problem: present, line 12.
2. The core formula: present, as display math on lines 16–22, in the script's notation ($p_{n+1}$, $f_n$, $h$).
3. What it assumes: present, lines 27–28 (Lipschitz, fixed $h$, starting values). See F1.
4. How accurate it is: present, lines 30–32. It is labelled as a general result with its $C^5$ hypothesis, and it says correctly that Case 1 does *not* show the rate, with numbers.
5. When it fails or misleads: present, lines 34–37 (conditional stability; a small end error hiding a bad run), tied to Case 1 and checked.
6. Where it fits: present, line 39.

There are no proofs, theorem boxes or procedures, and no worked-example table.

**Word count.** 400 words of prose by my count (inline math counted as one word, display math excluded, punctuation-only tokens dropped). This matches the manifest and is exactly at the 400 cap, which is within the limit.

**Consistency with the rest of the page.** Nothing in the new Description contradicts the Animations introduction or the Case 1 Behavior text (lines 43–80). All shared numbers agree: 0.0081199, −41.3, 1.285, −0.363, 0.632, 0.013, 0.74 at t≈4.17, the 0.096–0.74 range, and 190 = 2.1e−3 / 1.1e−5. The page has no other sections (Derivation Notes and so on) that could conflict.

**Links and anchors.** These relative links all resolve to existing folders under pages/numerical-methods/: `../eulers-method-for-odes/`, `../heuns-method/`, `../predictor-corrector-methods/`, `../milne-simpsons-method/`, `../runge-kutta-method/`, `../runge-kutta-fehlberg-method/`. `#case-1` matches the explicit heading id. The manifest's mechanical checks found nothing.

**Scope of the diff.** Outside the Description, the only change is the `{#case-1}` id on the Case 1 heading, which is an allowed cross-reference edit. No sentence was moved out of the Animations introduction, and the old two-paragraph Description was entirely inside the Description. No script or GIF changed.

**Fidelity to Mathews.**
- The predictor and corrector match gr_17 and gr_18 term by term.
- The theorem hypotheses (continuity, Lipschitz) and the precision theorem ($C^5$, $O(h^5)$ local, $O(h^4)$ global) match the module.
- The starting values match the module's Remark.
- The $-19/270$ estimate is not spelled out in the module text, which only says a correction term "can be included". It is the standard Milne-device result and I verified it independently.

No Fidelity findings.

**Reference value.** The script's RK4 reference at h=1e−4 (frame annotation 0.0081199) agrees with my DOP853 value of 0.0081199205 at rtol 1e−13. My independent ABM4 values match every frame annotation I checked:

| Frame | m | $y(5)$ | Error |
|---|---|---|---|
| 1 | 12 | 0.0214088 | +1.3e−02 |
| 16 | 70 | 0.0102009 | +2.1e−03 |
| 17 | 80 | 0.0081090 | −1.1e−05 |
| 21 | 150 | 0.0081199 | −1.4e−10 |
