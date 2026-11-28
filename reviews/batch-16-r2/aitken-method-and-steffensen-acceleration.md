# Aitken's Method and Steffensen's Acceleration — batch 16 review, round 2 (overview mode)

SUMMARY: 0 Error, 0 Misleading, 3 Minor

Page: `pages/numerical-methods/aitken-method-and-steffensen-acceleration/index.qmd` (light-pass batch 16, overview page, action *check*). The diff changes only `index.qmd`. No script or GIF changed, so the animations are not under review. I did not read anything under `reviews/`. I did not run MATLAB or quarto, and I modified nothing in the repository. My scratch files are in `/tmp/claude-1001/-home-jason--claude-spares-spare-0ogoFf/f6c51b48-3d53-4b4d-8872-653429a6389a/scratchpad/work/review-16r2/aitken-method-and-steffensen-acceleration/reviewer/`: `steff.py`, `steff.jl`, `gen.py` and `wc.py`.

I consulted the Mathews archive (`n2003/AitkenSteffensenMod.html`, read as text).

## 1. Findings

**F1 — Minor, Page text (overview limits): the Description is over the word limit.**
- **Where:** `## Description`, lines 10–70.
- **What is there:** 460 words of prose, as counted in the manifest. The limit is 150–400.
- **Source of the words:** my own count of the diff's `+` prose (`reviewer/wc.py`) gives 193 words. About 30 of those are on line 46, which was already there and only had its notation changed. So the batch added roughly 160 words, and the earlier, already-reviewed text makes up about 300.
- **Suggestion:** under the director's decision, I do not suggest cutting the old text. If any trimming is wanted, the new paragraphs at lines 54–59 are the place. Nothing there misleads.

**F2 — Minor, Page text: "first three Steffensen errors" is ambiguous about which iterates it means.**
- **Where:** line 55, "[Case 2](#case-2) shows this rate: its first three Steffensen errors have exponents $-2$, $-4$ and $-8$, doubling each step; the fourth reaches rounding level."
- **What is true:** line 46 defines $S_0 = x_0$, and the Case 1 Behavior paragraph counts the error of $S_0$ as the first Steffensen error ("errors $1$, $5.7\times10^{-2}$, …"). Read the same way, the first three errors in Case 2 belong to $S_0$, $S_1$ and $S_2$: 0.414, 3.8e-2 and 3.1e-4, with exponents −1, −2 and −4. The claim is only right for $S_1$, $S_2$ and $S_3$.
- **Evidence:** I ran the scripts' algorithm in Julia (`julia reviewer/steff.jl`). In Case 2 the errors of $S_0$ to $S_4$ are 4.142e-01, 3.802e-02, 3.077e-04, 1.677e-08 and 6.661e-16.
- **Suggestion:** "the errors of $S_1$, $S_2$ and $S_3$ have exponents $-2$, $-4$ and $-8$, doubling each step; that of $S_4$ reaches rounding level."

**F3 — Minor, Page text (general result): "converges quadratically" undersells a simple root.**
- **Where:** line 54, "at a root $p$ of multiplicity $m$ … Steffensen's iteration converges quadratically from starting values close enough to $p$."
- **What is true:** for $m \ge 2$ the order is 2. The sentence also covers $m = 1$, though, and there $g'(p) = 0$ and Steffensen on the Newton map converges cubically.
- **Evidence:** I ran `python3 reviewer/gen.py` on $f = (x-1)^m(x+3)$ from 1.3, using 400-digit arithmetic. The orders $\log e_{k+1}/\log e_k$ came out as:

| $m$ | Orders, step by step |
|---|---|
| 1 | 3.42, 3.12, 3.04, 3.01 |
| 2 | 2.53, 2.21, 2.09, 2.05 |
| 3 | 2.53, 2.21, 2.09, 2.05 |

- **Why it is only Minor:** "quadratically" is the order for the multiple roots the page is about. Read as "at least quadratically", the sentence is true.
- **Suggestion:** say "converges at least quadratically", or "at a root $p$ of multiplicity $m \ge 2$".

No Fidelity findings:
- The module's formulas are images. Its text describes Steffensen as two Newton steps from $p_0$ followed by Aitken's formula, then restarting from the result. The page's renaming to $S_k$, $q_1$, $q_2$ matches the GIF labels ($S_k$) and the scripts, and the method is unchanged.
- The module states no convergence order for Steffensen, so the new general result does not depart from it.

## 2. Claim ledger (text added or changed by the batch)

1. Line 46: "Starting from $S_0 = x_0$". The scripts set `xS[1] = x0`, and the GIF labels use `S_k`. **Confirmed.**
2. Line 48: $q_1 = S_k - f(S_k)/f'(S_k)$ and $q_2 = q_1 - f(q_1)/f'(q_1)$. These are lines 42–43 of `aitkenab.jl`, and the same in `aitkencd.jl` and `aitkenef.jl`. **Confirmed.**
3. Line 49: $S_{k+1} = S_k - (q_1-S_k)^2/(q_2-2q_1+S_k)$. These are lines 44 and 48 of `aitkenab.jl`, the same in the other two scripts. **Confirmed.**
4. Line 50: "Set $k \leftarrow k+1$ and repeat." This matches the loop in the scripts. **Confirmed.**
5. Line 54: the Newton map $g(x) = x - f(x)/f'(x)$ has $g'(p) = (m-1)/m$ at a root of multiplicity $m$. Using sympy with the limit at $p$, I got $g'(p) = 0, 1/2, 2/3, 3/4$ for $m = 1$ to 4. **Confirmed.**
6. Line 54: $(m-1)/m \neq 1$. This holds for every $m \ge 1$. **Confirmed.**
7. Line 54: if $g$ is smooth enough near $p$, Steffensen converges quadratically from close enough starts. This is the standard Steffensen theorem (needs $g'(p) \ne 1$ and $g \in C^2$ or $C^3$), which "smooth enough" covers. The order is 2 for $m \ge 2$ (see F3). For $m = 1$ it is 3. **Confirmed, with the precision caveat in F3.**
8. Line 55: Case 2 shows this rate. I checked $e_{k+1}/e_k^2$ in Case 2: 0.213 and 0.177 in double precision. In exact arithmetic the next ratio is 4.97e-17/(1.68e-8)² ≈ 0.176, so the ratio settles. The bottom panel's points at about −1.4, −3.5, −7.8 and −15.2 match the GIF frame. **Confirmed.**
9. Line 55: "first three Steffensen errors have exponents −2, −4 and −8". The errors of $S_1$ to $S_3$ are 3.802e-2, 3.077e-4 and 1.677e-8, with exponents −2, −4 and −8. **Confirmed for $S_1$–$S_3$; the wording is ambiguous (F2).**
10. Line 55: "doubling each step". The exponents go −2, −4, −8. **Confirmed.**
11. Line 55: "the fourth reaches rounding level". The error of $S_4$ is 6.661e-16, while exact arithmetic would give 4.97e-17. Case 2 stops because $f'(S_4) = -8.79\times10^{-15}$. **Confirmed.**
12. Line 57: "Rounding limits both methods near a double root, where $f$ is tiny and is computed with a large relative error." For Steffensen, Cases 1 and 3 below show it. For Newton, line 20 (not part of this diff) says $f$ evaluates to 0 after 28 and 25 Newton steps. **Confirmed** as a general statement supported by the page.
13. Line 58: in Case 1 the expanded cubic rounds to exactly 0 at the third Steffensen iterate. In Julia, $f(S_3) = 0.0$ at $S_3 = 0.99999999344396751$, and Python gives the same. **Confirmed.**
14. Line 58: both Newton steps from it return the same point. I found `q1 == S_3` and `q2 == q1` both true. **Confirmed.**
15. Line 58: the $\Delta^2$ denominator is 0. The computed value is `denom = 0.0`, and the GIF legend reads "stopped: Δ² denominator = 0". **Confirmed.**
16. Line 59: in Case 3 the error stalls after three steps at a few times $10^{-8}$. In Julia the errors of $S_3$ to $S_6$ are 2.759e-8, 5.442e-8, 2.148e-8 and 1.458e-8. The last GIF frame shows the curve flattening near −7.5. Exact arithmetic would give 4.4e-16 at $S_4$. **Confirmed.** This also agrees with the Case 3 Behavior paragraph.
17. Line 69: "Steffensen's method is Aitken's process applied to a fixed-point iteration, here the Newton-Raphson map". This matches the algorithm and the module's wording. **Confirmed.**
18. Line 69: Accelerated and Modified Newton-Raphson restores quadratic convergence at multiple roots. That page's lines 16–34 say so for Methods A and B. **Confirmed.**
19. Line 69: the Improved Newton Method restores quadratic convergence at multiple roots in other ways. That page's Description says Methods A and B are at least quadratic, and Method C reproduces A. **Confirmed.**
20. Line 69: the Power Method applies Aitken's process to its eigenvalue estimates. That page's lines 119–126 and 220 apply it to the estimates $c_k$. **Confirmed.**
21. Headings at lines 80, 88 and 96 got `{#case-1}`, `{#case-2}` and `{#case-3}`. These are explicit ids, the convention used on other pages (`graeffes-method`, `nonlinear-systems`). **Confirmed.**
22. Contradiction check against the rest of the page:
    - Line 52 says "roughly quadratic".
    - The table says "Superlinear (≈2)".
    - The Case 1, 2 and 3 Behavior paragraphs give values that match items 9–16.

    **No contradiction found.**

## 3. Checks

- **Six points of the standard:** all present.
  1. *The problem:* lines 12–20.
  2. *The core formula:* Aitken as display math (line 27), and Steffensen in steps (lines 48–49, in the page's $S_k$ notation).
  3. *What it assumes:* Aitken's theorem hypotheses (line 30). For Steffensen, $g'(p)\ne1$, $g$ smooth and a close start (line 54).
  4. *How accurate it is:* line 54, with Case 2 as the illustration (line 55).
  5. *When it fails or misleads:* rounding at double roots, with links to Cases 1 and 3 (lines 57–59).
  6. *Where it fits:* line 69.

  There are no proofs or new callout boxes. The theorem at line 30 is old text.
- **Word count:** 460, over the 400 limit (F1). The batch's `+` prose is about 193 words, of which about 160 are new.
- **Links and anchors:**
  - `#case-1`, `#case-2` and `#case-3` resolve to the explicit heading ids.
  - `../fixed-point-iteration/`, `../newton-raphson-method/`, `../accelerated-and-modified-newton-raphson/`, `../improved-newton-method/` and `../power-method/` each exist with an `index.qmd`.
  - The link format matches other pages, for example `halleys-method` line 45.
- **Scope of the diff:**
  - Inside the Description: lines 46–50 (notation change only, same algorithm), and new lines 54–59 and 69.
  - Outside the Description: only the three heading ids, which the standard allows.
  - There are no moved sentences, and no script or GIF changes.
- **Independent computation:**
  - **Julia (`reviewer/steff.jl`):** it reproduces the scripts' Steffensen loop with their guards. All the page's Case 1–3 numbers match:

| Case | Steffensen errors | Newton error after 22 steps |
|---|---|---|
| 1 | 6.556e-9 at $S_3$ | 3.115e-7 |
| 2 | 6.661e-16 at $S_4$ | 4.727e-8 |
| 3 | 2.76e-8, 5.44e-8, 2.15e-8, 1.46e-8 | 2.402e-8 |

  - **Python float64:** it matches Julia for Cases 1 and 2. For Case 3 it gives different post-stall values (5.3e-8, 3.5e-9, 2.2e-8), because `x**6` rounds differently from Julia's `x^6`. That shows the stall level is rounding noise, which supports "a few times $10^{-8}$" as a description rather than precise digits.
  - **mpmath:** confirms the exact-arithmetic values. For Case 3, step 4 gives 4.4e-16, matching line 98. For Case 2 from the exact $\sqrt2$ the error is 5.69e-16, matching line 90.
- **Frames viewed:** the last frame (`frame_023.png`) of each of `aitkenab`, `aitkencd` and `aitkenef`. The legends, stop reasons, the $S_k$ labels and the shape of the bottom panel all agree with the new text.
