# Review: Triangular Systems and Back Substitution (batch 11, text-only)

Page: `pages/numerical-methods/triangular-systems-and-back-substitution.qmd` (303 lines). Module: `n2003/backsubstitutionmod.html` ("Forward Substitution and Back Substitution"), example folder `n2003/backsubstitution/BackSubstitutionMod/` (5 link pages). The reviewer consulted the archive (module, all 5 link pages, images gr_19, gr_20, gr_103/104/106, gr_142–178). The Example 1(a)/(b) solution images (gr_21–86) are missing.

**Findings: 3 Error, 0 Misleading, 2 Minor.** All three Error findings were confirmed by an independent check.

## Findings

### F1. Page text, Error: Example 1(b) has the wrong value of $x_1$, in both exact and decimal form

*Independent check: **confirmed** (Error). Exact solve gives (1027/252, −11/9, −1/21, 6/7); 1181/252 leaves a row-1 residual of 22/9. With the correct $x_1$ (3.917 → 4.075), the callout's "dramatically alter" rests on $x_2$, $x_3$ and $x_4$, not $x_1$.*

- **Location:** line 129, `x_1 = \frac{1181}{252}.`; line 134, `$\mathbf{x} \approx (4.687,\; -1.222,\; -0.048,\; 0.857)$`.
- **True:** $x_1 = (20 + x_2 - 2x_3 - 3x_4)/4 = (20 - 11/9 + 2/21 - 18/7)/4 = 1027/252 \approx 4.0754$. The page's $x_2, x_3, x_4$ (−11/9, −1/21, 6/7) are correct. 1181/252 = 4.68651 does not satisfy row 1.
- **How the reviewer knows:** exact back substitution and sympy `LUsolve` both give `[1027/252, -11/9, -1/21, 6/7]`, residual 0.
- **Fix:** line 129 `x_1 = \frac{1027}{252}`; line 134 `(4.075,\; -1.222,\; -0.048,\; 0.857)`. The callout's "can dramatically alter the solution" still holds ($x_3$: −1 → −0.048; $x_2$: −0.333 → −1.222).

### F2. Page text, Error: Example 1(a), Step 4, has a sign slip, so its first equality is false

*Independent check: **confirmed** (Error, low impact: the final answer is right). The first expression evaluates to 35/3, the next line to 47/3.*

- **Location:** line 91, `x_1 = \frac{20 - (-1)\!\left(-\tfrac{1}{3}\right) + 2(-1) + (-3)(2)}{4}`, then line 92 `= \frac{20 - \tfrac{1}{3} + 2 - 6}{4}`.
- **True:** `+ 2(-1)` is −2, so the first numerator is 35/3, while line 92 (correctly) uses +2 and gets 47/3. The term should be $-a_{13}x_3 = -2(-1) = +2$. The final $x_1 = 47/12$ is correct.
- **Fix:** change `+ 2(-1)` to `- 2(-1)` (and, for consistency, `+ (-3)(2)` to `- 3(2)`).

### F3. Page text, Error: the stated reason the Newton system is lower-triangular is false

*Independent check: **confirmed** (Error: the stated reason is false, the conclusion right). For nodes 1, 2, 4, 5 every $(x_k - x_j)$ with $j > k$ is nonzero (−1, −3, −4, −2, −3, −1).*

- **Location:** lines 248–249, "Because $(t - x_j) = 0$ whenever $j \geq k$, each equation only involves $c_1, \ldots, c_k$."
- **True:** at $t = x_k$, $(x_k - x_j)$ vanishes only for $j = k$ (in Example 3, $x_2 - x_3 = -2$). The conclusion is right for a different reason: the coefficient of $c_l$ is $\prod_{j=1}^{l-1}(t - x_j)$, which for $l > k$ contains the factor $(t - x_k)$.
- **Fix:** "Because for $l > k$ the term multiplying $c_l$ contains the factor $(t - x_k)$, which vanishes at $t = x_k$, each equation only involves $c_1, \ldots, c_k$."

### F4. Fidelity, Minor (unverified): Example 1(a)/(b) silently uses a different matrix from Mathews

- **Location:** lines 72 and 114, row 2 `0 & 3 & -2 & -4`.
- **Mathews:** gr_19 and gr_20 both show row 2 as (0, −2, 7, −4); everything else matches. Mathews' 1(a) has the integer solution (3, −4, −1, 2); his 1(b) has (67/14, 34/21, −1/21, 6/7) ≈ (4.786, 1.619, −0.048, 0.857), in which $x_2$ changes sign, a better illustration of the callout's point.
- **Fix (optional):** restore row 2 = (0, −2, 7, −4) in both examples and recompute everything; otherwise only F1 and F2 need fixing.

### F5. Page text, Minor (unverified): the Newton application never says the nodes must be distinct

- **Location:** lines 239–253.
- **True:** the diagonal entries are $\prod_{j<k}(x_k - x_j)$, nonzero exactly when the nodes are distinct, which the page's own forward-substitution theorem requires. Example 3's diagonal (1, 1, 6, 12) is fine.
- **Fix:** add "with distinct $x_1, \ldots, x_{n+1}$" at line 240.

## Inventory (mechanical checks)

No control characters, no leftover "(Planned)" / "Animation Focus" / legacy stub, no `localhost` link, no code block, no link to a missing target.

## Claim ledger (condensed; 51 entries in the reviewer's ledger)

Confirmed (both sides recomputed exactly where applicable): the upper- and lower-triangular definitions and forms (1)–(2); both uniqueness theorems with $a_{ii}\ne0$ (det = ∏aᵢᵢ); the back- and forward-substitution formulas, run as written; Example 1(a) $x_4 = 2$, $x_3 = -1$, $x_2 = -1/3$, the line-92 expression and $x_1 = 47/12$, the solution and all four verification rows; Example 1(b) $x_4 = 6/7$, $x_3 = -1/21$, $x_2 = -11/9$; Example 2's system (matches Mathews), $x = (5/3, 23/3, -43/3, 305/6)$ with every intermediate step, decimals and the ≈ verification (5.0001, 6.0000, 4.0000, 2.0001); the Newton form, the system $\sum_l c_l\prod_{j<l}(x_k - x_j) = y_k$ (matches Mathews' gr_143), Example 3's points, matrix, $c = (4, -2, 1/2, 1/12)$ (matches Mathews), $P(t)$ and $P(1), P(2), P(4), P(5) = 4, 2, 1, 3$; markup.

Not confirmed: line 91 first expression (F2); line 129 and line 134's $x_1$ (F1); line 248's reason (F3); Example 1's row 2 versus Mathews (F4); distinct-node hypothesis absent (F5).

## Checks

All sympy exact. Back substitution (single formula, empty sum = 0) and forward substitution run as written on every example, cross-checked with `LUsolve` and exact residuals. Ex 1(a) (47/12, −1/3, −1, 2); Ex 1(b) (1027/252, −11/9, −1/21, 6/7) against the page's 1181/252; Ex 2 (5/3, 23/3, −43/3, 305/6); Ex 3 matrix [[1,0,0,0],[1,1,0,0],[1,3,6,0],[1,4,12,12]], $c = (4, -2, 1/2, 1/12)$, expanded $P = t^3/12 - t^2/12 - 7t/3 + 19/3$. Mathews' own Ex 1 (for F4): (3, −4, −1, 2) and (67/14, 34/21, −1/21, 6/7).
