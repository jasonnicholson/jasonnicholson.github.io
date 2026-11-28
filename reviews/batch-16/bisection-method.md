# Bisection Method — batch 16 review, round 1 (overview mode)

SUMMARY: 0 Error, 0 Misleading, 1 Minor

Page: `pages/numerical-methods/bisection-method/index.qmd` (overview page, light-pass batch 16). The diff changes only `index.qmd`: it adds the Description (lines 10–47) and the heading ids `{#case-1}` and `{#case-2}`. No script or GIF changed (checked with `git diff --quiet 147040f` on `*.gif` and `*.jl`), so the animations were not re-reviewed. The committed diff matches `EV/diff.patch` byte for byte. I consulted the Mathews archive: `n2003/BisectionMod.html`, the theorem images `BisectionMod_gr_1..12.gif`, and the MATLAB and Maple code in `bisection/BisectionProg/Links/`. I did not run MATLAB or quarto, and I changed nothing in the repository. My scratch files are in `/tmp/claude-1001/-home-jason--claude-spares-spare-0ogoFf/f6c51b48-3d53-4b4d-8872-653429a6389a/scratchpad/work/review-16/bisection-method/reviewer/` (`check.py`, `m/thm.png`).

## 1. Findings

**F1: Page text, Minor.** Location: Description, line 35: "Mathews' process stops if some $f(c_k) = 0$, since $c_k$ is then a root; the rule above has no such test and moves on past it." Read together with line 25 ("the Intermediate Value Theorem then puts a root in every bracket") and the bound on lines 29–33.
- **What is there now.** The sentence is true. But "moves on past it" understates what happens. Once some $f(c_k)=0$, the displayed rule sets $a_k=c_k$. Every later test is then $f(a)f(c)=0$, which is not negative, so the rule always takes the right half. The brackets drift to $b_{k-1}$ and no longer contain a root. Both the "root in every bracket" claim and the bound $|c_k-x^*|\le(b_0-a_0)/2^k$ then fail for the displayed rule, even though the problem meets both stated hypotheses.
- **How I know.** I ran the displayed rule on $f(x)=x^2-4$ on $[0,4]$, a continuous function with opposite end signs. It gives $c_1=2$, an exact root, then brackets $[2,4]$, $[3,4]$, $[3.5,4]$, …, $[3.96875,4]$ after 7 steps, converging to $4$ where $f(4)=12$. The same happens for $f(x)=x$ on $[-1,1]$, which converges to 1.
- **Why only Minor.** The page does attribute the theorem to Mathews' process and says the rule lacks the stopping test. A careful reader can work out the consequence.
- **Suggested correction.** State the consequence, for example: "…the rule above has no such test, so after an exact hit it walks away to the end of the bracket (on $x^2-4$, $[0,4]$, it hits $c_1=2$ and then converges to 4). The guarantee and the bound hold for the rule above only while no $f(c_k)=0$." Alternatively, add a third case "stop if $f(c_k)=0$" to the display. That would no longer match the scripts, so the wording fix is preferable.

## 2. Claim ledger (text added by the diff)

1. Problem: the method finds a root of $f(x)=0$ bracketed by $[a_0,b_0]$ with a sign change, by halving (line 12). **Confirmed.**
2. Each step evaluates $f$ at the midpoint and keeps the half where the sign change survives (line 13). **Confirmed** for the scripts' rule (with the exact-zero caveat in F1).
3. Display formula: $c_k=(a_{k-1}+b_{k-1})/2$; $[a_{k-1},c_k]$ if $f(a_{k-1})f(c_k)<0$, otherwise $[c_k,b_{k-1}]$ (lines 15–23). **Confirmed.** It is identical to the loop in `bisectionaa.jl` and `bisectionbb.jl` (`if f(as[i]) * f(c) < 0 … else …`). Mathews' Mathematica and Maple code tests $\mathrm{sign}\,f(b)$ against $\mathrm{sign}\,f(c)$ instead. That is an equivalent variant except at exact zeros, it gives the same $[1,2]$ on Case 2, and it is not a Fidelity issue.
4. Assumes $f$ continuous on $[a_0,b_0]$ and $f(a_0),f(b_0)$ of opposite signs; the IVT then puts a root in every bracket (line 25). **Confirmed**, apart from the exact-zero gap (F1). These match Mathews' hypotheses: $f\in C[a,b]$, $f(a)$ and $f(b)$ of opposite signs, and a root $r\in[a,b]$, which follows from the other two.
5. No derivative is needed, and one new $f$ value per step (line 26). **Confirmed.** This is true of the method if $f(a)$ is stored. The scripts recompute $f(a)$, which is a performance matter and not a finding.
6. It cannot find a root without a sign change, such as the double root of $(x-1)^2$ (line 27). **Confirmed:** $(x-1)^2\ge0$, so no bracket exists.
7. With several roots in the bracket it finds only one (line 27). **Confirmed.**
8. Mathews' theorem: under those two hypotheses the midpoints converge to a root $x^*\in[a_0,b_0]$ with $|c_k-x^*|\le(b_0-a_0)/2^k$, $k\ge1$ (lines 29–33). **Confirmed** against the archive image: $|r-c_n|\le(b-a)/2^{n+1}$ for $n=0,1,\dots$ Mathews' $c_0$ is the page's $c_1$, so the two forms are equivalent.
9. Mathews' process stops if some $f(c_k)=0$ (line 35). **Confirmed** against Mathews' MATLAB `bisect.m` (`if yc==0, a=c; b=c;`, then `b-a<delta` breaks). The Mathematica subroutine on the module page has no such test. The claim is defensible as the textbook process.
10. The rule above has no such test and moves on past it (line 35). **Confirmed** as worded, but understated (F1).
11. The bound halves every step whatever $f$ is, so convergence is linear (line 36). **Confirmed**, as a statement about the bound, which is how the page frames it.
12. One binary digit, about 0.3 decimal digits, per step (line 36). **Confirmed:** $\log_{10}2=0.30103$.
13. A tolerance $\delta$ needs $k\ge\log_2((b_0-a_0)/\delta)$ steps (line 37). **Confirmed:** this is the bound solved for $k$.
14. 22 steps for $\delta=10^{-6}$ on a bracket of width 3 (line 37). **Confirmed:** $\log_2(3\times10^6)=21.517$, so $k=22$. Check: $3/2^{22}=7.15\times10^{-7}\le10^{-6}$, while $3/2^{21}=1.43\times10^{-6}$ is too large.
15. Only the bound is monotone (line 38). **Confirmed** on Case 1 (see 17).
16. Case 1: error at step 12 is $2.40\times10^{-4}$ (line 39). **Confirmed:** $c_{12}=1.364990234375$ and $x^*=1.3652300134140969$ (mpmath findroot), so the error is $2.3978\times10^{-4}$. The GIF's final legend reads `c_12 = 1.36499`, which agrees.
17. Case 1: within the bound $3/2^{12}\approx7.32\times10^{-4}$, but the error grew at steps 3, 6 and 8 (line 39). **Confirmed.**
    - $3/2^{12}=7.324\times10^{-4}$.
    - Errors for steps 1–12: 0.8652, 0.1152, 0.2598↑, 0.07227, 0.02148, 0.02539↑, 0.001957, 0.009761↑, 0.003902, 9.72e-4, 4.93e-4, 2.40e-4.
    - The error increases only at steps 3, 6 and 8, and the bound holds at every step.
18. Case 2 breaks both hypotheses (line 41). **Confirmed.** $\tan$ is discontinuous at $\pi/2\in[0,2]$, and $f(0)f(2)=\tan0\cdot\tan2=0$ (computed as −0.0), which is not negative.
19. The root is exactly at $a_0=0$, so $f(a_0)f(b_0)=0$, and the rule takes $[1,2]$ (line 42). **Confirmed:** $c_1=1$ and $f(0)f(1)=0$ is not $<0$, so the bracket becomes $[1,2]$. GIF frame 2 shows the bracket $[1,2]$ with `c_1 = 1.0`.
20. On $[1,2]$, $\tan$ changes sign across the asymptote at $\pi/2$, not at a root, and the brackets close in on the asymptote (line 43). **Confirmed.** $\tan1=1.557$ and $\tan2=-2.185$. The bracket after step 12 is $[1.5703125, 1.57080078125]$, which contains $\pi/2=1.5707963$.
21. $c_{12}\approx1.570801$ (line 43). **Confirmed:** 1.57080078125. Frame 13's legend reads `c_12 = 1.570801`.
22. $|f(c_{12})|\approx2.2\times10^5$ (line 43). **Confirmed:** $\tan(c_{12})=-224494.3$. Frame 13's zoom panel shows the red dot at about $-2.2\times10^5$.
23. Checking that $|f(c_k)|$ is small exposes this false root (line 44). **Confirmed:** $|f(c_k)|$ grows from $10^1$ to $10^5$ over steps 2–12.
24. False Position keeps the bracket but cuts at the secant line's $x$-intercept (line 46). **Confirmed** as the standard definition.
25. Brent's Method uses bisection as a safeguard behind interpolation steps (line 46). **Confirmed** as the standard description.
26. Newton-Raphson and the Secant Method converge faster near a simple root but can lose it without a bracket (line 46). **Confirmed** as general results (orders 2 and about 1.618 for a simple root).
27. Heading ids `{#case-1}` and `{#case-2}` are added to the Case 1 and Case 2 headings (lines 57, 66), with links `[Case 1](#case-1)` and `[Case 2](#case-2)` (lines 39, 41). **Confirmed:** the ids exist and the links match them.
28. The functions and intervals named for the cases ($x^3+4x^2-10$ on $[-1,2]$; $\tan x$ on $[0,2]$) (lines 39, 41). **Confirmed** against the scripts' `f`, `a0` and `b0` and against the case headings.

## 3. Checks

- **Six points of the overview standard.** All six are present:
  1. Problem: line 12.
  2. Core formula as display math, in the animations' notation ($a$, $b$, $c$, $[a_0,b_0]$): lines 15–23.
  3. Assumptions: line 25.
  4. Accuracy as a general result with hypotheses, pointing to Case 1: lines 29–39.
  5. Failure modes: line 27 (no sign change, several roots), plus Case 2 linked and computed (lines 41–44).
  6. Where it fits: line 46.

  There are no proofs, theorem or definition callouts, or MATLAB or Mathematica procedures, and no worked-example table.
- **Word count.** The manifest gives 376. My own rough count, with inline math as one word and display math removed, gives 388. Either way it is within 150–400.
- **Consistency with the rest of the page.**
  - No contradiction with the Animations introduction (line 51, the IVT guarantee).
  - No contradiction with Case 1's Behavior (bound monotone, midpoints on both sides; $x^*\approx1.3652$ agrees with my 1.36523).
  - No contradiction with Case 2's Behavior (the `<0` test keeps $[1,2]$; convergence to the asymptote). The Description's "breaks both" adds the zero-product hypothesis to Case 2's continuity point without contradicting it.
- **Frames inspected.** bisectionaa frame 13; bisectionbb frames 2 and 13. Their legends and values agree with the ledger numbers above.
- **Links.** These targets exist as page folders under `pages/numerical-methods/`, each with an index `.qmd`: `../false-position-or-regula-falsi-method/`, `../brents-method/`, `../newton-raphson-method/`, `../secant-method/`. The anchors `#case-1` and `#case-2` match the explicit ids. The manifest's mechanical check also reports no link or anchor problems.
- **Scope of the diff.** Outside the Description the only changes are the two heading ids, which are allowed as cross-references. No sentence was moved out of the Animations introduction. No other section, script or GIF changed.
- **Fidelity.** No Fidelity finding. The page's indexing of the bound ($c_k$ for $k\ge1$, $2^k$) is a valid re-indexing of Mathews' ($c_n$ for $n\ge0$, $2^{n+1}$). Using the $f(a)f(c)<0$ test instead of Mathews' $\mathrm{sign}\,f(b)$ test is a valid variant that matches the scripts. Mathews' Examples 3 and 4 are the page's Cases 1 and 2.
- **Could not determine.** Nothing.
