# Accelerated and Modified Newton-Raphson — batch 16 review, round 1 (overview mode)

SUMMARY: 1 Error, 0 Misleading, 0 Minor

Page: `pages/numerical-methods/accelerated-and-modified-newton-raphson/index.qmd`, light-pass batch 16, overview mode. The diff changes no script or GIF, so the animations were not re-reviewed. I consulted the Mathews archive: `/home/jason/Desktop/math-fullerton/baseline/mathews/n2003/NewtonAccelerateMod.html`, its text and formula images gr_12, gr_114 and gr_228. I did not run MATLAB or quarto and changed nothing in the repository. My scratch script is `/tmp/claude-1001/-home-jason--claude-spares-spare-0ogoFf/f6c51b48-3d53-4b4d-8872-653429a6389a/scratchpad/work/review-16/accelerated-and-modified-newton-raphson/reviewer/chk.py`. It uses 50-digit mpmath plus a Float64 rerun of the scripts' formulas.

## 1. Findings

**F1 — Page text — Error.** Location: index.qmd line 44, with its example on line 45.

- **What the page says now:** "Method A fails if $m$ is wrong: in general, a multiplier $\mu \neq m$ gives only linear convergence, $e_{n+1} \approx (1 - \mu/m)\,e_n$, and standard Newton is $\mu = 1$." The next sentence uses $\mu = 2$ at the simple root $x = -2$ ($m = 1$) as its example: "the ratio is $-1$ … after ten steps are still 0.17 from the root."
- **What is true instead:** The local relation $e_{n+1} \approx (1-\mu/m)e_n$ is right. But it gives linear convergence only when $|1-\mu/m| < 1$, that is $0 < \mu < 2m$.
  - For $\mu > 2m$ the iteration is locally repelling and diverges.
  - For $\mu = 2m$ the ratio is $-1$, and convergence is at best sublinear.
  - The page's own example is exactly $\mu = 2m$. So the example contradicts the general claim it is meant to illustrate.
- **The general claim is true only under a hypothesis it leaves out.** By the brief's rule that is an Error.
- **How I know:** in 50-digit arithmetic (chk.py), Method A with multiplier 2 from $x_0 = -2.2$ on $f(x) = x^3-3x+2$ gives:
  - errors $-0.2, 0.15556, -0.19376, 0.15183, -0.18807, \dots$
  - $|e_{10}| = 0.17356$, $|e_{20}| = 0.15534$, $|e_{40}| = 0.13127$
  - the two-step ratio $|e_{n+2}/e_n|$ goes to 1, so this is not linear convergence.
- **Suggested correction:** "in general, a multiplier $\mu \neq m$ is at best linear, $e_{n+1} \approx (1 - \mu/m)\,e_n$, which converges only when $0 < \mu < 2m$; standard Newton is $\mu = 1$." On line 45, add that the ratio $-1$ is the borderline case and the iterates crawl in sublinearly. For example: "…jump from side to side (…) and creep in sublinearly: after ten steps they are still 0.17 from the root." This matches the "at best linear" wording already used on the Improved Newton page (its line 34).

No other findings.

## 2. Claim ledger (the diff's `+` lines)

| # | Claim (page's words) | Verdict | Evidence |
|---|---|---|---|
| L1 | The methods find a root of multiplicity $m \ge 2$, where standard Newton-Raphson slows down | confirmed | Mathews' Background; Case 1 frames and computed ratios |
| L2 | Root of order $m$: $f = f' = \dots = f^{(m-1)} = 0$ and $f^{(m)} \ne 0$ at $x^*$, with $f^{(m)}$ continuous near $x^*$ (attributed to Mathews) | confirmed | Mathews gr_12 image and text ("f(x) and its derivatives are defined and continuous on an interval about x = p") |
| L3 | In general, standard Newton-Raphson is quadratic at simple roots and linear at multiple roots, $e_{n+1} \approx \tfrac{m-1}{m}e_n$, because $f'(x^*) = 0$ | confirmed | Mathews' Convergence Rate theorem (gr_25); Case 1 ratios tend to 0.5 |
| L4 | Method A formula $x_{n+1} = x_n - m f/f'$ | confirmed | Matches accnewtonbb.jl line 30 and Mathews gr_114 |
| L5 | Method A recovers the quadratic rate and needs $m$ in advance | confirmed | $e_n/e_{n-1}^2 = 0.1515, 0.16616, 0.166666$ |
| L6 | $h = f/f'$ has a simple root at a root of $f$ of multiplicity $m$ | confirmed | $h \approx (x-x^*)/m$; for this cubic $h = u/2 - u^2/12 + \dots$ with $u = x-1$, so $h'(1) = 1/2 \ne 0$ |
| L7 | Newton on $h$ gives $x_{n+1} = x_n - f f'/(f'^2 - f f'')$ | confirmed | $h' = (f'^2 - f f'')/f'^2$, so $h/h' = f f'/(f'^2 - f f'')$; matches accnewtoncc.jl and Mathews gr_228 |
| L8 | Method B is quadratic without knowing $m$ | confirmed | $e_n/e_{n-1}^2 = -0.1462, -0.16732, -0.166667$ |
| L9 | Method B costs a second derivative per step and works at simple roots too, since $h$ has a simple root where $f$ does | confirmed | At a simple root $h'(x^*) = 1 - f f''/f'^2 = 1$ |
| L10 | Both need $f$ smooth enough and $x_0$ close enough; under those hypotheses both are quadratic in general, $\lvert e_{n+1}\rvert \approx C\lvert e_n\rvert^2$ | confirmed | Mathews' theorems; for these cases $C = \pm 1/6 \ne 0$ |
| L11 | All three cases start at $x_0 = 1.2$ at the double root $x^* = 1$ of $(x-1)^2(x+2)$ | confirmed | x0 = 1.2 in all three scripts; $x^3 - 3x + 2 = (x-1)^2(x+2)$ |
| L12 | Case 1: $e_n/e_{n-1}$ is 0.515, 0.508, 0.504, … and tends to 1/2 | confirmed | 0.515152, 0.508165, 0.504252, …, 0.500009 at n = 12 |
| L13 | Method A: $e_n/e_{n-1}^2$ tends to 1/6 | confirmed | 0.151515, 0.166163, 0.166666, 0.166667; analytically $f'''/(m(m+1)f'') = 6/(6 \cdot 6) = 1/6$ |
| L14 | Method B: $e_n/e_{n-1}^2$ tends to −1/6 | confirmed | −0.146199, −0.167318, −0.166667; analytically $h''/(2h') = (-1/12)/(1/2) = -1/6$ |
| L15 | "so Method B's first step lands left of the root" | confirmed | $x_1 = 0.9941520$ (frame_002 legend reads 0.994152) |
| L16 | Table header "in 50-digit arithmetic" | confirmed | Recomputed at mp.dps = 50 |
| L17 | Table row n = 0: 2.00e-1 in all three columns | confirmed | e0 = 0.2 |
| L18 | Row n = 1: 1.03e-1, 6.06e-3, −5.85e-3 | confirmed | 0.1030303, 0.0060606, −0.0058480 |
| L19 | Row n = 2: 5.24e-2, 6.10e-6, −5.72e-6 | confirmed | 0.0523564, 6.1033e-6, −5.7220e-6 |
| L20 | Row n = 3: 2.64e-2, 6.21e-12, −5.46e-12 | confirmed | 0.0264008, 6.208e-12, −5.457e-12 |
| L21 | Method A fails if $m$ is wrong | confirmed | Below-quadratic rate for any $\mu \ne m$ |
| L22 | A multiplier $\mu \ne m$ gives only linear convergence, $e_{n+1} \approx (1-\mu/m)e_n$; standard Newton is $\mu = 1$ | **wrong as a general claim (F1)** | The relation holds, but linear convergence needs $0 < \mu < 2m$; $\mu = 1$ is right |
| L23 | With $\mu = 2$ at the simple root $-2$ the ratio is $-1$ | confirmed | $1 - 2/1 = -1$; the computed ratio goes to −1 |
| L24 | From $x_0 = -2.2$ the iterates jump side to side: $-1.844444$, $-2.193762$, … | confirmed | −1.8444444, −2.1937622, −1.8481711, … |
| L25 | After ten steps they are still 0.17 from the root | confirmed | $x_{10} = -2.1735577$, so $\lvert e\rvert = 0.1736$ |
| L26 | Near the double root $f(x_n) \approx 3e_n^2$ is small and computed with a large relative error | confirmed | $f = e^2(e+3)$; at $x_2$ the true $f \approx 1.1\text{e-}10$, while rounding in the expanded cubic is ~1e-16 absolute |
| L27 | In double precision the third iterates miss the table: $e_3 = 3.6\text{e-}12$ (A) and $8.4\text{e-}12$ (B) | confirmed | Float64 gives 3.6089e-12 and 8.3855e-12 (B has the opposite sign to the exact −5.46e-12; the page gives no sign, which is consistent) |
| L28 | There $f$ evaluates to exactly 0, so later steps change nothing | confirmed | Float64 $f(x_3) = 0.0$; $x_4, x_5, x_6$ equal $x_3$ for both methods |
| L29 | Both modify Newton-Raphson; link `../newton-raphson-method/` | confirmed | Page exists |
| L30 | The Improved Newton Method adds an adaptive method that needs no $m$; link `../improved-newton-method/` | confirmed | That page's line 25: "Method C (adaptive Newton) does not need $m$" |
| L31 | Aitken's and Steffensen's acceleration speeds up the linear Newton sequence; link `../aitken-method-and-steffensen-acceleration/` | confirmed | That page applies Δ² and Steffensen to Newton iterates at double roots |
| L32 | Halley's Method uses $f''$ to converge cubically at simple roots; link `../halleys-method/` | confirmed | Standard result; Halley page lines 12 and 28 |
| L33 | Heading ids `{#case-1}`, `{#case-2}`, `{#case-3}` added, and the links `#case-1/2/3` target them | confirmed | Ids are on lines 60, 68 and 76; each case's script and GIF match its heading parameters |
| L34 | Unchanged sentences re-wrapped onto separate lines (Method A/B paragraphs) | confirmed | Same words, so no change in meaning |

## 3. Checks (overview mode)

**The six points of the standard**
1. Problem: line 12. Present.
2. Core formula: both iterations as display math, in the scripts' notation. Present.
3. Assumptions: order-of-root definition, smoothness, $x_0$ close, $m$ known for A, $f''$ needed for B. Present.
4. Accuracy: the general linear and quadratic results are labelled "in general", and the rates are checked on the cases (L12–L14). Present.
5. Failure modes: wrong $m$ (see F1 for its wording) and rounding near the double root, both computed. Present.
6. Where it fits: line 49. Present.
- Optional worked example: a 4-row error table on the page's own problem, which agrees with the GIF legends.
- No proofs, no callout or theorem boxes, no MATLAB or Mathematica.

**Word count:** my count is 401 tokens, and 399 once the two "…" tokens are dropped. That agrees with the manifest's 399, at the top of the 150–400 limit and within it.

**Links and anchors:** all four relative page links resolve to existing `index.qmd` files. `#case-1`, `#case-2` and `#case-3` match the explicit heading ids.

**Diff scope:** only index.qmd changes. Outside the Description the only edits are the three heading ids, which the standard allows. No sentence was moved out of the Animations introduction. No script or GIF changed.

**Consistency with the rest of the page:**
- Case 1's text ($(m-1)/m = 1/2$; 1.2, 1.10303, 1.052356, 1.026401; $x_{12} = 1.000052$), Case 2's ($x_1 = 1.006061$, $x_2 = 1.000006$) and Case 3's ($x_1 = 0.994152$, $x_2 = 0.999994$) all agree with the new Description and the table. So do my computed values.
- Frames checked: accnewtonaa sheet, accnewtonbb frame_006 and accnewtoncc frames 002 and 005. Their legends show 1.052356, …, 1.000052; 1.0; 0.994152; and 1.0, consistent with the text.

**Fidelity:** the formulas match Mathews (gr_114 and gr_228), and the definition of root order matches gr_12. No fidelity finding.


## Independent check of F1 (a separate checker given only the allegation)

**F1: confirmed. Error is the right severity.**

Evidence comes from `/usr/bin/python3 -I f1.py` (sympy and mpmath at 50 digits) in /tmp/claude-1001/-home-jason--claude-spares-spare-0ogoFf/f6c51b48-3d53-4b4d-8872-653429a6389a/scratchpad/work/review-16/accelerated-and-modified-newton-raphson/checker/.

1. **The general claim is false outside 0 < μ < 2m.** The linearization e_{n+1} ≈ (1 − μ/m) e_n is right: the iteration map has g'(x*) = 1 − μ/m. But that only gives linear convergence when |1 − μ/m| < 1. At μ = 2m the ratio is −1, which is not linear convergence. For μ > 2m or μ ≤ 0 the iteration diverges from x* locally. Checked on the double root x = 1 (m = 2), starting from x0 = 1.01:
   - μ = 1: e30 = 9.3e-12, linear with ratio 1/2.
   - μ = 3: e30 = 9.3e-12, linear with ratio −1/2.
   - μ = 4 (= 2m): e30 = 0.01. The error swings between ±0.00997 and ±0.0100 and never shrinks at a linear rate.
   - μ = 5: e1..e3 = −0.015, 0.023, −0.034, and e30 = −2.28. It diverges.

   So "a multiplier μ ≠ m gives only linear convergence" is false as stated.

2. **The example is exactly the boundary case where the claim fails.** At x = −2 with μ = 2:
   - g(−2+e) + 2 = −e − (4/3)e² − (4/3)e³.
   - Two steps give g(g(−2+e)) + 2 = e − (8/9)e³ + ….
   - The ratio −1 gives no linear contraction. The cubic term makes the convergence sublinear, with |e| shrinking like n^(−1/2).
   - Iterating from −2.2 gives e10 = −0.173558, e50 = −0.1227, e100 = −0.0961 and e200 = −0.0719. That matches 1/e² growing by about 16/9 every two steps (predicted 203 at n = 200, observed 193).

   The example does show that Method A "fails" with the wrong m. But it sits right after "gives only linear convergence, e_{n+1} ≈ (1 − μ/m) e_n", so a reader takes ratio −1 as an instance of linear convergence. It is actually the case where that conclusion breaks down. So the example does not illustrate the claim it follows.

3. **The example's numbers are correct:**
   - x1 = −1.844444 and x2 = −2.193762 match.
   - After ten steps the iterate is 0.1736 from the root, which matches "0.17".
   - The iterates do alternate sides.

   Only the framing is wrong.

**Why Error and not Misleading:** the sentence makes a stated general result ("in general, a multiplier μ ≠ m gives only linear convergence") that is mathematically false for μ ≥ 2m and μ ≤ 0. It is not just a defensible statement with a bad emphasis.

**Possible fix:** limit the claim to 0 < μ < 2m. Then say that at μ = 2m the ratio is −1 and convergence is sublinear at best, and that it diverges beyond that. Present the x = −2 example as that boundary case.
