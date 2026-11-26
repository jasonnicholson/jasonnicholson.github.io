# Lin-Bairstow Method — batch 15 review (round 1)

Page: `pages/numerical-methods/lin-bairstow-method/` (new page). Mode: full review of both cases; the Description (all new text) checked in overview mode.

**Result: 0 Error, 0 Misleading, 1 Minor.** The Minor finding is reported unverified by the skill's rule; the director confirmed it from Case 1's frame 5 (bottom-left legend: open circle "x₊, step 3").

Archive consulted: `n2003/BairstowMethodMod.html`, its images, Links `lnk_1`–`lnk_5`, and the a2001 Animations index pages.

## Findings

### F1. Minor — Page match: the Animations introduction's marker key does not fit Case 1's bottom-left panel

- **Location:** `index.qmd` lines 71–72: "In the complex-plane panels, red dots are the two roots of the current trial factor $x^2 - r_j x - s_j$ … Open circles mark the roots of $P$."
- **What is there:** Case 1's bottom-left panel is a complex-plane panel but shows one red dot (the current upper root $x_+$), an open circle that is the previous iterate $x_+$ at step $j-1$ (not a root of $P$), and the root $-1+i$ as a black ×. Source: `bairstowaa.jl` lines 145–151; frames 2, 3, 6 (legend "x₊, step 0" open, "x₊, step 1" red).
- **What is true:** the key holds for Case 1's top-right panel and for Case 2. In the zoom panels the open circle means "previous iterate".
- **Why Minor:** Case 1's Behavior paragraph says the panel zooms "in the same way" as the top-left one, and the in-frame legend labels the open circle correctly.
- **Correction:** limit the key to the panels it fits, e.g. "In the full-scale complex-plane panels (Case 1 top right, Case 2), red dots are …; open circles mark the roots of $P$. The zoom panels mark the previous iterate with an open circle."

## Unresolved

None.

## Inventory (director's Phase 1)

- Scripts: `bairstowaa.jl` → `bairstowaa.gif` (9 frames); `bairstowbb.jl` → `bairstowbb.gif` (18 frames). Both ran in scratch; both GIFs byte-identical to the committed files.
- No control characters, leftover placeholder sections, localhost links or code blocks; every page link and case anchor resolves; every `.jl`/`.gif` is referenced; the section index links the page (after Horner's Method).
- Description prose: 374 words (director); reviewer 378. Within 150–400.

## Claim ledger (reviewer)

### Description: formulas and method

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| D1 | Roots two at a time via $x^2-rx-s$, real arithmetic, finds complex pairs | Confirmed | Case 1 |
| D2 | $P=(x^2-rx-s)Q+b_1(x-r)+b_0$, $Q=b_nx^{n-2}+\dots+b_2$ | Confirmed | Mathews (2),(5),(3); sympy on 3 polynomials |
| D3 | $b$ recursion, $k=n-2..0$ | Confirmed | Mathews (8); sympy equals true remainder |
| D4 | $c$ recursion, $k=n-2..1$ | Confirmed | Mathews (12) |
| D5 | Factor iff $b_0=b_1=0$ | Confirmed | |
| D6 | Newton's method on $(b_0,b_1)$ | Confirmed | Mathews says the same |
| D7 | Partial derivatives equal $c_1$, $c_2$, $c_2$, $c_3$ | Confirmed | sympy differentiation of the true remainder |
| D8 | 2×2 system, Cramer's rule in Mathews' module | Confirmed | gr_129–135, gr_147 |
| D9 | Needs $n\ge3$, a start, $c_1c_3-c_2^2\ne0$ | Confirmed | |
| D10 | Real starts keep iterates real; a real quadratic factor exists | Confirmed | |
| D11 | Mathews' start $r_0=-a_1/a_2$, $s_0=-a_0/a_2$ | Confirmed | gr_137–142 |
| D12 | General: Newton quadratic from close starts if Jacobian nonsingular | Confirmed (standard) | |
| D13 | Nonsingular exactly when $x^2-rx-s$ and $Q$ share no root | Confirmed | Proof: Jacobian is $(\alpha,\beta)\mapsto(\alpha x+\beta)Q \bmod D$, singular iff $\gcd(Q,D)\ne1$ |
| D14 | $(x^2+1)^2$ from $(0.1,-1.2)$: error ratio → 1/2 | Confirmed | 80 digits: 0.4798, 0.4892, …, 0.49999 (double precision stalls near 6.6e-9; page names no arithmetic) |
| D15 | Example 4 converges to $x^2+2x+2$; $Q=x^2-x+3$; roots | Confirmed | sympy factor; gr_148–150 |
| D16 | From step 2 on the exponent roughly doubles | Confirmed | ratios 2.10, 2.10, 2.05 |
| D17 | Table, every cell | Confirmed | 80-digit recomputation |
| D18–D20 | Quintic deflation factors, roots, linear factor | Confirmed | 60-digit polyroots |
| D21 | From (−1, −2): $\lvert s_{26}\rvert\approx7\times10^8$, wanders > 90 steps | Confirmed | 7.11e8 at j = 26 at every precision; settles at 133 (double), 95 (≥ 29 digits) |
| D22 | Limit factor depends on the arithmetic (double vs ≥ 30 digits) | Confirmed | 39 precisions from 29 to 500 digits all give $x^2+8.011701x+14.931211$ |
| D23 | Cross-links | Confirmed | All targets exist and match |
| D24 | Six points present | Confirmed | |
| D25 | 150–400 words | Confirmed | |
| D26 | Worked-example table ≤ 6 rows, page's own problem | Confirmed | 5 rows |
| D27 | Nothing the standard leaves out | Confirmed | |
| D28 | `#case-1`, `#case-2` resolve | Confirmed | |

### Animations introduction

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| A1 | No Mathews animation; both new | Confirmed | No animation link in module; a2001 root-finding index lists only Bisection, Regula Falsi, Fixed Point, Newton, Secant; nothing named *bairstow* outside n2003 |
| A2 | Most frames one step; Case 2 also a frame per deflation | Confirmed | 9 and 18 frames |
| A3 | Marker key for complex-plane panels | Confirmed except Case 1 bottom-left (F1) | |
| A4 | Case 1 zooms; Case 2 repeats on quotients | Confirmed | |
| A5 | Examples 1–3 are one division each; step 0 of Case 2 | Confirmed | lnk_2–4 |

### Case 1

| # | Claim | Verdict |
|---|---|---|
| C1.1–C1.2 | Heading; converges to (−2, −2), roots $-1\pm i$, iterates real | Confirmed |
| C1.3 | Window ±0.13 → ±1.7e-17 | Confirmed (0.13, 1.709e-17) |
| C1.4 | Roots start $-1.05\pm0.893i$; within 0.021 at step 1 | Confirmed (0.0205763) |
| C1.5 | Upper-root distances 0.118 … 1.04e-35 | Confirmed |
| C1.6 | 0.141 → 0.0511; exponents −3.8, −8.0, −16.8, −34.5 | Confirmed ($e_{k+1}/e_k^2$ bounded) |
| C1.7 | Agrees with Mathews' printed iterates to ≥ 14 decimals | Confirmed (≤ 5.1e-16) |
| C1.8 | 256-bit; double gives $r_4=s_4=-2$ exactly | Confirmed |
| C1.9 | Gray circles $\tfrac12\pm\tfrac{\sqrt{11}}2i$ | Confirmed |
| C1.10–C1.11 | Wiring; alt text | Confirmed |

### Case 2

| # | Claim | Verdict |
|---|---|---|
| C2.1–C2.2 | Quintic; stage 1 from (−2, 3); remainder $3(x+2)+8$ | Confirmed (quotient $x^3+4x^2-5x+2$; gr_37) |
| C2.3 | Trial roots 1, −3 → −0.289346, −2.949618, stay real | Confirmed |
| C2.4 | Stops at 6 and 5 steps under $\lvert\Delta r\rvert+\lvert\Delta s\rvert<10^{-12}$ | Confirmed |
| C2.5 | $b_0$ from 8 to about $10^{-14}$ | Confirmed (−1.5099e-14) |
| C2.6 | Cubic and stage-2 start | Confirmed |
| C2.7–C2.8 | Stage 2 roots complex → real → complex; $r^2+4s$ = −0.99, 3.94, −2.10 | Confirmed |
| C2.9 | Linear root −5.062082 | Confirmed |
| C2.10 | From step 2 roots sit on their circles at this scale | Confirmed |
| C2.11–C2.12 | Companion-matrix agreement 3.6e-15; 60-digit comparisons | Confirmed (3.5527e-15; ≤ 2.12e-16) |
| C2.13–C2.14 | Wiring; alt text | Confirmed |

## Implementation checks

- **`bairstowaa.jl`:** Mathews' Lin-Bairstow step for step (b and c recursions as his (8) and (12); Cramer identical to his d₁, d₂). Independent check: Newton on the true remainder with a sympy Jacobian (not the c recursion) in 60–80-digit mpmath; iterates, errors and upper-root distances agree with the script at every step (e.g. j = 3: −1.999999996545, −1.999999991124; error 9.525e-9). Mathews' printed iterates agree to 15 decimals. Frames 1, 2, 3, 6 viewed: coordinates, titles, zoom half-widths and annotations match; no clamping.
- **`bairstowbb.jl`:** same step function; stopping rule as stated; deflation and Mathews' start on the cubic use the correct indices. An independent float64 implementation reproduces every quantity exactly (stage-1 (r, s) = (−3.238964139312645, −0.8534596542049295); stage-2 (2.301046424403453, −1.8517305478167687); linear root −5.062082285090808); 60-digit roots agree. Frames 1, 3, 8, 10, 11, 18 viewed; all roots inside the window; nothing clamped.
- **Fidelity:** both cases declared new (confirmed); Examples 1–4 accounted for. No Fidelity findings.
