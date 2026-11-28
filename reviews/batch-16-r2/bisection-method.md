# Bisection Method — batch 16 review, round 2 (overview mode)

SUMMARY: 0 Error, 0 Misleading, 2 Minor

Overview review of the `bisection-method` page, light-pass batch 16 (round 2). Page: /home/jason/Desktop/jasonhnicholson.com/pages/numerical-methods/bisection-method/index.qmd. The diff touches only index.qmd: it adds the Description (lines 10–48) and adds the `{#case-1}` and `{#case-2}` ids to the case headings. It changes no script or GIF, so the animations were not re-reviewed. I consulted the Mathews archive: BisectionMod.html and its images (theorem gr_1–gr_10, the Mathematica subroutines gr_11 and gr_640–646, Examples 3 and 4), plus bisection/BisectionProg/Links/BisectionProg_lnk_1.html (the MATLAB `bisect`). Scratch work: /tmp/claude-1001/-home-jason--claude-spares-spare-0ogoFf/f6c51b48-3d53-4b4d-8872-653429a6389a/scratchpad/work/review-16r2/bisection-method/reviewer/ (check.py, mathews_1_12.png, mathews_rest.png). I ran no MATLAB, no quarto and no git commands that change state.

## Part 1: Findings

**F1 — Page text, Minor.** index.qmd line 35: "the rule above has no such test, so after an exact hit it always takes the right half, leaving the root (on $x^2 - 4$, $[0, 4]$: $c_1 = 2$, then $c_k \to 4$)."
- **What is wrong.** As a general statement, "always takes the right half" says too much. The rule is forced right only on the step of the hit and on the step after it, because then $f(a)\,f(c) = 0$. After that $f(a_k) \ne 0$ again and the ordinary sign test resumes, so the method can take left halves and converge to a different root.
- **Evidence (check.py, float64, the page's rule).** With $f = (x-2)(x-3.2)(x-3.7)$ on $[0, 4]$, $f(0) = -23.68$ and $f(4) = 0.48$. The midpoints are $c_1 = 2$ (exact hit), $c_2 = 3$, $c_3 = 3.5$, $c_4 = 3.25$, $c_5 = 3.125$. Step 4 takes the left half, and the bracket after 12 steps is $[3.19922, 3.20020]$, which converges to 3.2. The page's own example is correct: on $x^2 - 4$ the midpoints run 2, 3, 3.5, 3.75, … → 4.
- **Why it matters.** "Leaving the root" is true. The risk is that a reader concludes the method always marches to $b_0$ after an exact hit.
- **Suggested fix.** "…so an exact hit $f(c_k) = 0$ makes it take the right half $[c_k, b_{k-1}]$ and, since then $f(a_k) = 0$, the right half again, leaving the root (on $x^2 - 4$, $[0, 4]$: $c_1 = 2$, then $c_k \to 4$)."

**F2 — Page text, Minor.** index.qmd line 38: "Reaching a tolerance $\delta$ takes $k \ge \log_2\bigl((b_0 - a_0)/\delta\bigr)$ steps, so 22 for $\delta = 10^{-6}$ on a bracket of width 3."
- **What is wrong.** This is the step count at which the bound guarantees the tolerance. It is sufficient, not necessary, but "takes" reads as necessary.
- **Evidence (check.py, mpmath, 40 digits).** On Case 1's own problem, $f = x^3 + 4x^2 - 10$ on $[-1, 2]$, the error first falls below $10^{-6}$ at step 18 ($5.47 \times 10^{-7}$). It is back above at steps 19–20 ($5.2 \times 10^{-6}$ and $2.3 \times 10^{-6}$) and stays below from step 21 ($8.8 \times 10^{-7}$). The arithmetic itself is right: $\log_2(3 \times 10^6) = 21.52$, so 22.
- **Suggested fix.** "Guaranteeing a tolerance $\delta$ takes $k \ge \ldots$ steps…"

There are no other findings. I found no contradiction between the new Description and the Animations sections, and nothing in the Description departs from Mathews (see L5, L6 and L13 below).

## Part 2: Claim ledger

Every entry is from the `+` lines of the diff. No sentences were moved.

| # | Claim (page's words) | Verdict | Evidence |
|---|---|---|---|
| L1 | The method finds a root of $f(x) = 0$ bracketed on $[a_0, b_0]$ with a sign change, and halves the interval | confirmed | Definition; matches both scripts |
| L2 | Display formula: $c_k = (a_{k-1}+b_{k-1})/2$; keep $[a_{k-1}, c_k]$ if $f(a_{k-1})f(c_k) < 0$, else $[c_k, b_{k-1}]$ | confirmed | Same as the loop in bisectionaa.jl and bisectionbb.jl (`if f(as[i])*f(c) < 0` → `b = c`, else `a = c`). Notation matches the headings ($[a_0, b_0]$) and the legends (`c_k`). |
| L3 | "keeps the half on which the sign change survives" | confirmed, with a caveat | True whenever $f(c_k) \ne 0$. The exception $f(c_k) = 0$ is stated at lines 35–36. |
| L4 | Assumes $f$ is continuous on $[a_0, b_0]$ and $f(a_0)$, $f(b_0)$ have opposite signs; the IVT puts a root in every bracket | confirmed, with a caveat | Standard. For this rule it fails after an exact hit: on $x^2-4$ the bracket after step 2 is $[3, 4]$, with no root. Line 36 qualifies this. |
| L5 | Needs no derivative; only one new $f$ value per step | confirmed | Method property (Mathews' second Mathematica subroutine, gr_645, caches Yb and Yc) |
| L6 | Cannot find a root without a sign change, e.g. the double root of $(x-1)^2$; with several roots in the bracket it finds only one | confirmed | $(x-1)^2 \ge 0$, so it never changes sign. The midpoint sequence converges to a single limit. |
| L7 | Mathews' bisection theorem, under those two hypotheses: midpoints converge to a root $x^*$ in $[a_0, b_0]$ with $\lvert c_k - x^*\rvert \le (b_0-a_0)/2^k$, $k = 1, 2, \ldots$ | confirmed | Mathews (gr_1–gr_10): $f \in C[a,b]$, $r \in [a,b]$ with $f(r) = 0$, $f(a)$ and $f(b)$ of opposite sign, $\lvert r - c_n\rvert \le (b-a)/2^{n+1}$ for $n = 0, 1, \ldots$, and $c_n \to r$. The page's $k = n+1$ is an index shift (first midpoint is $c_1$). The bound holds because $c_k$ is the centre of a bracket of width $(b_0-a_0)/2^{k-1}$. |
| L8 | Mathews' process stops if some $f(c_k) = 0$ | confirmed, but only for one of Mathews' programs | Mathews' MATLAB `bisect` (BisectionProg_lnk_1) has `if yc==0, a=c; b=c;` and then breaks on `b-a < delta`. The module's Mathematica subroutines have no such test: on $f(c) = 0$, `Sign[0] ≠ Sign[f[b]]` sets $a = c$, the same as the page's rule. Not raised as a finding, because the claim is true of Mathews' program. |
| L9 | The rule has no such test; after an exact hit it always takes the right half, leaving the root | partly wrong | See F1. "Leaving the root" is true. "Always" fails in general (counterexample $(x-2)(x-3.2)(x-3.7)$ on $[0, 4]$). |
| L10 | Example: $x^2 - 4$ on $[0, 4]$: $c_1 = 2$, then $c_k \to 4$ | confirmed | Midpoints 2, 3, 3.5, 3.75, …, 3.99609; bracket after 10 steps is $[3.99609, 4]$ |
| L11 | For this rule the guarantee and the bound hold only while no $f(c_k) = 0$ | confirmed | On $x^2-4$: $c_3 = 3.5$ has error 1.5, above the bound $4/8 = 0.5$ |
| L12 | The bound halves every step whatever $f$ is, so convergence is linear: one binary digit, about 0.3 decimal digits, per step | confirmed | $\log_{10} 2 = 0.30103$. "Linear" is tied to the bound (R-linear), which is the standard textbook sense. |
| L13 | Reaching tolerance $\delta$ takes $k \ge \log_2((b_0-a_0)/\delta)$ steps; 22 for $\delta = 10^{-6}$, width 3 | arithmetic confirmed, wording Minor | $\log_2(3 \times 10^6) = 21.517$, so 22. "Takes" overstates; see F2. Mathews' MATLAB uses the same count (`max1 = 1+round((log(b-a)-log(delta))/log(2))`). |
| L14 | Only the bound is monotone | confirmed | The errors grow at several steps (L17) |
| L15 | Case 1: $f(x) = x^3 + 4x^2 - 10$ on $[-1, 2]$ | confirmed | bisectionaa.jl `f`, `a0, b0 = -1.0, 2.0`. This is Mathews' Example 3 (gr_646 caption). |
| L16 | Case 1: error at step 12 is $2.40 \times 10^{-4}$, within the bound $3/2^{12} \approx 7.32 \times 10^{-4}$ | confirmed | $x^* = 1.3652300134140968$ (mpmath findroot), $c_{12} = 1.364990234375$, error $2.398 \times 10^{-4}$, $3/4096 = 7.324 \times 10^{-4}$. Frame 13 legend reads `c_12 = 1.36499`. |
| L17 | Case 1: the error grew at steps 3, 6 and 8 | confirmed | Errors for k = 1–12: 0.865, 0.115, 0.260↑, 0.0723, 0.0215, 0.0254↑, 0.00196, 0.00976↑, 0.00390, 9.7e-4, 4.9e-4, 2.4e-4. Within 12 steps the increases are exactly at 3, 6 and 8. |
| L18 | Link `[Case 1](#case-1)` and `[Case 2](#case-2)` | confirmed | The headings carry explicit `{#case-1}` and `{#case-2}` |
| L19 | The guarantee needs both hypotheses; Case 2, $f = \tan x$ on $[0, 2]$, breaks both | confirmed | $\tan$ is discontinuous at $\pi/2 \in [0, 2]$, and $f(0)f(2) = 0$, not negative. bisectionbb.jl uses `tan`, `[0.0, 2.0]`. This is Mathews' Example 4. |
| L20 | The root lies exactly at $a_0 = 0$, so $f(a_0)f(b_0) = 0$; the rule takes the right half $[1, 2]$ and leaves that root | confirmed | $c_1 = 1$, $f(0)f(1) = 0$, not $< 0$, so the bracket becomes $[1, 2]$. Mathews' rule (compare with $f(b)$) also gives $[1, 2]$. |
| L21 | On $[1, 2]$, $\tan x$ changes sign across the asymptote at $\pi/2$, not at a root | confirmed | $\tan 1 = 1.557$, $\tan 2 = -2.185$; the zeros of $\tan$ are $0$ and $\pi$, so none lies in $[1, 2]$ |
| L22 | The brackets close in on the asymptote: $c_{12} \approx 1.570801$, $\lvert f(c_{12})\rvert \approx 2.2 \times 10^5$ | confirmed | $c_{12} = 1.57080078125$, $\tan(c_{12}) = -224494.3$. The bracket after 12 steps is $[1.5703125, 1.57080078]$, which contains $\pi/2 = 1.5707963$. Frame 13 legend reads `c_12 = 1.570801`, and the zoom panel shows $f \approx -2.2\text{e}5$. |
| L23 | A narrow bracket alone does not prove a root; checking that $\lvert f(c_k)\rvert$ is small exposes this false one | confirmed | $\lvert f(c_k)\rvert$ grows: 1.56, 14.1, 5.5, 18.4, 120, 43.6, 136, 2067, 292, 681, 2029, 2.2e5 |
| L24 | False Position keeps the same bracket but cuts at the secant line's $x$-intercept | confirmed | Standard; the linked page exists |
| L25 | Brent's Method uses bisection as the safeguard behind faster interpolation steps | confirmed | Standard; the linked page exists |
| L26 | Newton-Raphson and Secant converge faster near a simple root but, without a bracket, can lose it | confirmed | Orders 2 and about 1.618 at a simple root. Neither keeps a bracket. |
| L27 | Heading-id additions: `{#case-1}`, `{#case-2}` | confirmed allowed | These are the only changes outside the Description |

## Part 3: Checks

**The six points of the overview standard.** All six are present, in order.
1. Problem: line 12.
2. Core formula: display math at lines 15–23, in the scripts' notation.
3. Assumptions: line 25.
4. Accuracy: lines 29–40. It is stated as a general result with its hypotheses, and its consequences are checked against Case 1's own iterates.
5. Failure modes: line 27 (no sign change, several roots), line 35 (exact hit) and Case 2 (lines 42–45), linked to the case.
6. Where it fits: line 47.

There are no proofs, callout boxes or theorem boxes. The optional worked example is not used. The Case 1 numbers are inline and agree with the GIF.

**Word count.** My own count of lines 12–47 is 400 (360 prose words plus 40 inline math expressions; display math and punctuation-only tokens excluded). Counting stray punctuation tokens it is 417. This matches the manifest's 400 and sits exactly at the 400-word ceiling, so it is within the limit.

**Links and anchors.**
- `#case-1` and `#case-2` match the explicit heading ids at lines 58 and 67.
- `../false-position-or-regula-falsi-method/`, `../brents-method/`, `../newton-raphson-method/` and `../secant-method/` each exist as a folder with index.qmd. The trailing-slash form follows the site convention (for example, `](../newton-raphson-method/)` is used 17 times elsewhere).

**Scope of the diff.** There are 41 insertions and 2 deletions. The two deletions are the case headings re-added with ids, and their text is unchanged. No Behavior paragraph, alt text, embed, script or GIF changed, and no sentence moved out of the Animations introduction. `git status` shows no uncommitted changes to the page.

**Consistency with the rest of the page.**
- The Animations introduction (IVT under continuity and a sign change) agrees with the Description.
- Case 1's Behavior ("error bound shrinks monotonically; the midpoints themselves are not monotone") agrees with L14 and L17.
- Case 2's Behavior ($f(0)f(1) = 0$ so it keeps $[1, 2]$; converges to the asymptote; continuity is required) agrees with L19–L22.

**Frames inspected.** bisectionaa frame_013 shows `c_12 = 1.36499` and the bracket around 1.3652. bisectionbb frame_013 shows `c_12 = 1.570801` on the asymptote, with the zoom-panel midpoint at about −2.2e5. Both agree with my computation.

**Scripts.** They were not under review because the diff does not touch them. I read both and confirmed the update rule the Description states (L2). I did not run them; I reproduced their iteration independently in check.py, in float64 and in mpmath.
