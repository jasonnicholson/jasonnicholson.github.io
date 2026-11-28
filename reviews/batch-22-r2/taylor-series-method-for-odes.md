# Taylor Series Method for ODE's — batch 22 review, round 2 (overview mode)

SUMMARY: 0 Error, 0 Misleading, 1 Minor

Overview review of `taylor-series-method-for-odes` (light-pass batch 22, overview page, action *write*).
Page: /home/jason/Desktop/jasonhnicholson.com/pages/numerical-methods/taylor-series-method-for-odes/index.qmd
Evidence: /tmp/claude-1001/-home-jason--claude-spares-spare-0ogoFf/f6c51b48-3d53-4b4d-8872-653429a6389a/scratchpad/work/review-22r2/taylor-series-method-for-odes/ (my scripts are in reviewer/: sym.py, num.py, num2.py, num3.py, num4.py)

I did not run MATLAB or quarto, and I did not modify the repository. I did not read anything under reviews/. I did consult the Mathews archive: n2003/TaylorDEMod.html (the theorem text) and the formula images gr_4, 5, 7, 8, 14, 16–19 under n2003/taylorde/TaylorDEMod/Images/.

The diff changes only index.qmd. No script or GIF changed, so the animations are not under review. I still used both scripts' routines (re-implemented in Python, with the y'''/y'''' expressions checked symbolically against the scripts) and the committed frames to check the Description's claims.

---

## Part 1: Findings

### F1 — Minor — Page text: the global-error result is stated without the smoothness hypothesis that the standard proof uses
- **Location:** Description, the accuracy paragraph: "In general, if the solution $y$ is in $C^{p+1}[t_0, b]$, the local truncation error is $O(h^{p+1})$ and the global error $|y(t_n) - y_n|$ is $O(h^p)$, including at $t = b$." The earlier assumptions sentence adds only that "the method also needs the partial derivatives of $f$ through order $p-1$".
- **What is there now:** The hypothesis is $y \in C^{p+1}$ plus the existence of the partials of $f$ through order $p-1$. This is Mathews' Precision Theorem word for word: his gr_14 is "y(t) ∈ C^{n+1}[t0, b]", gr_17 is "|e_k| = |y(t_k) − y_k| = O(h^n)", and the stated condition is the same. So this is not a Fidelity departure.
- **What is true instead:**
  - The local $O(h^{p+1})$ result follows from $y\in C^{p+1}$ alone, through the Taylor remainder.
  - The global $O(h^p)$ result is a different matter. The usual proof needs the increment function $\Phi(t,y,h)=\sum_{k=1}^{p} h^{k-1}d_k(t,y)/k!$ to be Lipschitz in $y$ near the solution.
  - The top term $d_p$ is built from the partials of $f$ of order $p-1$. If those partials only exist and are continuous, $d_p$ need not be Lipschitz.
  - So as a general statement, the result leans on a hypothesis the page leaves out.
  - I could not construct a concrete counterexample, which is why this is Minor and not Error. For this page's problem the gap does no harm: $y \ge 0.00812$ on $[0,5]$, so $f$ is $C^\infty$ near the solution.
- **How I know:** This follows from the structure of the standard one-step convergence proof. The page's own runs do behave at order $p$: the max-node-error ratios are 8.80 and 17.86 (see L13).
- **Suggested correction (optional):** Use the hypothesis the batch's Runge-Kutta page already uses. For example: "In general, if $f$ has continuous partial derivatives through order $p$ near the solution (which makes $y \in C^{p+1}[t_0,b]$), the local truncation error is …". Alternatively, change "the method also needs the partial derivatives of $f$ through order $p-1$" to "continuous partial derivatives through order $p$" so that it covers the global result.

No other findings.

---

## Part 2: Claim ledger (the `+` lines of the diff, plus the moved sentence)

| # | Claim (page's words) | Verdict | Evidence |
|---|---|---|---|
| L1 | Solves $y'=f(t,y)$, $y(t_0)=y_0$ on $[t_0,b]$ at nodes $t_n=t_0+nh$ | confirmed | Scripts use `ts = t0 + i*h`, with $h=5/m$ |
| L2 | (moved sentence) "The Taylor method uses the ODE to compute higher derivatives analytically, then advances via a truncated Taylor series $y_{n+1}=y_n+hy'_n+\frac{h^2}{2}y''_n+\cdots$" | confirmed; words unchanged | Before the diff, the same sentence sat in the Animations intro and ended "— giving local accuracy of $O(h^{p+1})$ for order $p$". That trailing clause was dropped from the move, and its content is restated (with a hypothesis) in the accuracy paragraph. Meaning preserved. |
| L3 | Display formula: order $p$ keeps the terms through $h^p$, $y_{n+1}=y_n+h y'_n+\dots+\frac{h^p}{p!}y^{(p)}_n$ | confirmed | Matches `taylor3_step` (h, h²/2, h³/6) and `taylor4_step` (+h⁴/24). Matches Mathews' gr_5 (d_k/k! h^k). |
| L4 | Each $y^{(k)}_n$ comes from differentiating the ODE with the chain rule, evaluated at $(t_n,y_n)$; $y'=f$, $y''=f_t+f_y f$ | confirmed | sympy: D(g)=g_t+g_y f. Matches Mathews' gr_7/8 (d_k = y^(k) evaluated at (t_k, y_k)). |
| L5 | For $f=1-t\sqrt[3]{y}$, $y''=-\sqrt[3]{y}-\tfrac t3 y^{-2/3}y'$ | confirmed | sympy difference = 0. Equals script `yd2`. |
| L6 | Mathews assumes $f$ continuous and Lipschitz in $y$ | confirmed | TaylorDEMod.html: "Assume that f(t,y) is continuous and satisfies a Lipschits condition in the variable y" |
| L7 | The method also needs the partials of $f$ through order $p-1$ | confirmed (as a necessity; see F1 on sufficiency) | $y^{(p)}=d_p$ involves partials of order $p-1$ |
| L8 | $f$ is smooth wherever $y>0$ | confirmed | Real cube root is smooth for $y\neq0$ |
| L9 | The solution stays positive on $[0,5]$ and decreases after its peak | confirmed | mpmath odefun (30 digits) on 501 points: min $y$ = 0.0081199 at $t=5$, peak 1.44976 at $t\approx0.88$, monotone decreasing for $t>0.9$ |
| L10 | $y(5)\approx0.00812$ | confirmed | mpmath: $y(5)=0.008119920464867961$. Script's reference (Taylor, 50 000 steps) differs by $-1.7\times10^{-18}$ |
| L11 | In general, if $y\in C^{p+1}[t_0,b]$: LTE $O(h^{p+1})$ | confirmed | Taylor remainder |
| L12 | …and global error $O(h^p)$, including at $t=b$ | confirmed as Mathews' theorem; hypothesis incomplete as a general result | F1 |
| L13 | Case 1 ($p=3$) and Case 2 ($p=4$): halving $h$ from 5/60 to 5/120 divides the largest node error by 8.8 and 17.9 | confirmed | p=3: 6.719e-5 / 7.640e-6 = 8.795. p=4: 6.723e-6 / 3.765e-7 = 17.86 (node errors against the mpmath exact solution) |
| L14 | …close to $2^3=8$ and $2^4=16$ | confirmed | as above |
| L15 | The error in $y(5)$ printed in the frames falls by 4.0 (order 3) and 580 (order 4) over the same halving | confirmed | True ratios are 4.019 and 578.8. Ratios of the printed (rounded) values: −2.9e-09/−7.3e-10 = 3.97, and +8.2e-09/+1.4e-11 = 586. Frames 15 and 20 of both GIFs show exactly these printed errors. |
| L16 | …"partly because at $m=60$ the last steps lie in the shaded region" | confirmed | Frames at m=60 print "h·\|∂f/∂y\| > 2.513 from t ≈ 4.51" (p=3) and "> 2.785 from t ≈ 4.67" (p=4). At m=120 both print "< … up to t = 5". |
|  | (mechanism behind L16) | confirmed | Step error factors at m=60 (finite difference of the step map): p=3: −1.10, −1.37, −1.70, −2.09, −2.55 for the steps from t=4.58 to 4.92. p=4: 1.08, 1.37, 1.75 for t=4.75 to 4.92. None at m=120. For p=4 the tail error visibly grows (2.0e-9 at t=4.58 to 8.2e-9 at t=5). For p=3 the tail error is a quasi-steady balance $\tau/(1-g)$, and the change in $g$ between h=5/60 and 5/120 accounts for most of the drop from 8 to 4 (rough estimate 4.9). The hedged "partly" holds. |
| L17 | The method is explicit, so stability limits its step | confirmed | — |
| L18 | On $y'=\lambda y$, one step multiplies $y_n$ by $1+h\lambda+\dots+(h\lambda)^p/p!$ | confirmed | Taylor method on a linear ODE |
| L19 | This exceeds 1 in size once $h\|\lambda\|$ passes 2.513 (p=3) or 2.785 (p=4) | confirmed | sympy: p=3, R=−1 at z=−2.512745; p=4, R=1 at z=−2.785294. No other real crossings. Matches script `zlim` and the frame legends. |
| L20 | $\partial f/\partial y=-t/(3y^{2/3})$ reaches −41.3 at $t=5$ | confirmed | −41.2554 |
| L21 | Coarse steps pass the limit in the tail (the shaded regions) | confirmed | Shading onsets: p=3, from t=3.066 at m=12 to 4.958 at m=80, none from m=90. p=4, from 3.103 at m=12 to 4.908 at m=70, none from m=80. |
| L22 | Runs with $m=12$ to 36 (order 3, Case 1) leave the reference there | confirmed | Max node error: m=36 0.029 (visible), m=40 2.5e-4. Consistent with the Case 1 text. |
| L23 | Runs with $m=12$ to 32 (order 4, Case 2) leave the reference there | confirmed | Max node error: m=32 0.089, m=36 0.0027 (Case 2: "too little to see"). Consistent with the Case 2 text. |
| L24 | At $m=16$ the order-3 run ends at $y(5)\approx0.156$ | confirmed | 0.1563161. Frame 3 of aa prints 0.1563161. |
| L25 | At $m=16$ the order-4 run ends at $y(5)\approx-7666$ | confirmed | −7665.8734. Frame 3 of bb prints −7665.8734003. |
| L26 | The derivatives must be redone for every new $f$ and grow quickly with $p$ | confirmed (qualitative) | — |
| L27 | This page's $y''''$ has eight terms over $27y^{8/3}$ | confirmed | sympy: the numerator in $c=y^{1/3}$ expands to 8 terms over 27c⁸ (= 27y^{8/3}), and it equals the script's `yd4_f` exactly (difference 0) |
| L28 | Euler's method is the case $p=1$ | confirmed | — |
| L29 | Heun's method and the Runge-Kutta method reach orders 2 and 4 from values of $f$ alone | confirmed | heuns-method/index.qmd says order 2; runge-kutta-method/index.qmd is RK4 |
| L30 | All three animate a step-refinement sweep on the same problem | confirmed | Euler Case 1 (l.66), Heun Case 1 (l.59) and RK Case 1 (l.49) are each a step-refinement sweep of $y'=1-t\sqrt[3]{y}$, $y(0)=1$ on [0,5] |
| L31 | Big "O" Truncation Error explains the $O(h^p)$ notation; Maclaurin and Taylor Series covers the series | confirmed | The pages exist and match their subjects |
| L32 | Heading id `{#case-1}` added to Case 1 | confirmed (allowed edit) | Link `[Case 1](#case-1)` matches |
| L33 | Heading id `{#case-2}` added to Case 2 | confirmed (allowed edit) | Link `[Case 2](#case-2)` matches |

---

## Part 3: Checks

**Six points of the overview standard**
1. Problem: present, sentence 1.
2. Core formula: present as display math, in the page's $y_n$, $h$, $t_n$ notation, and equal to what the scripts implement (L3–L5).
3. What it assumes: present, covering Mathews' continuity and Lipschitz assumptions, the needed partials, and positivity and smoothness on this problem (with the caveat in F1).
4. How accurate: present, with a general result and conditions, pointed at Case 1 and Case 2 with computed ratios that I verified (L13–L16).
5. When it fails or misleads: present, with stability (linked to both cases and verified numbers) and derivative cost.
6. Where it fits: present, with links to Euler, Heun, Runge-Kutta, Big O and Maclaurin/Taylor.

The Description comes before `## Animations`. It has no proofs and no theorem or callout boxes.

**Word count:** 400 by my independent count (prose tokens, each inline math = 1 word, display math excluded, link text counted, punctuation-only tokens dropped). This matches the manifest, and sits exactly at the upper limit. Not a finding.

**Links and anchors:**
- `#case-1` and `#case-2` match the ids added to the Case 1 and Case 2 headings.
- `../eulers-method-for-odes/`, `../heuns-method/`, `../runge-kutta-method/`, `../big-o-truncation-error/` and `../maclaurin-and-taylor-series/` all exist as folders with index.qmd under pages/numerical-methods/.

**Scope of the diff:** The diff changes only index.qmd, in three places:
1. The Description is inserted.
2. In the Animations intro, the moved sentence is removed. Its trailing "giving local accuracy" clause is not carried over verbatim, but its content is in the accuracy paragraph (L2).
3. `{#case-1}` and `{#case-2}` are added to the Case 1 and Case 2 headings.

No script, GIF, Behavior paragraph or alt text changed. Nothing outside the allowed edits.

**Consistency with the rest of the page:** I found no contradictions with Case 1 or Case 2.
- The LTE/global orders, the stability limits 2.513 and 2.785, the m-ranges that leave the reference, the m=16 values, and "−41.3 at t=5" all agree with the Behavior paragraphs and with the frames.
- The Case 1 statement "for m=52 to 80 the error in y(5) stays below 3.1e-9" agrees with the m=60 error of −2.93e-9.
- The Case 2 statement that m=12 to 60 have genuinely amplifying steps agrees with my m=60 factors.

**Frames:** Each GIF has 21 frames, one per m. I inspected frames 3 (m=16), 15 (m=60) and 20 (m=120) of both GIFs. The printed y(5), error and shading-onset text match my computed values listed above.

**Animations / scripts:** Not under review, since the diff touches neither. Incidentally, I confirmed symbolically that the y''' in both scripts and the y'''' in taylorderivativebb.jl are the exact total derivatives of the ODE.
