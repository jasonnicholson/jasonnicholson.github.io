# Review: Horner's Method (batch 13, text-only)

Page: `pages/numerical-methods/horners-method.qmd` (100 lines). Module: `n2003/HornerMod.html` ("Horner's Method"), example folder `n2003/horner/HornerMod/` (10 link pages). The reviewer consulted the archive (`HornerMod.html`, links 1–4 as text, images gr_36, gr_37, gr_92, gr_93, gr_94, gr_128, gr_172, gr_179, HornerMod2_gr_45).

**Findings: 2 Error, 0 Misleading, 2 Minor.** Both Error findings were confirmed by an independent check.

## Findings

### F1. Page text, Error: the derivative is wrongly identified as $b_1$

*Independent check: **confirmed** (Error). A fresh checker, given only the allegation, showed symbolically that $d_0 - p'(c) = 0$ while $d_0 - b_1 = a_2c + 2a_3c^2 \ne 0$ for a general cubic; on the page's example $d_0 = 27$, $b_1 = 1$.*

- **Location:** line 60: "Then $p'(c) = d_0 = b_1$. (The equality $d_0 = b_1$ follows from differentiating the factorization above.)"
- **Now:** the derivative is said to equal $b_1$, the last coefficient of the quotient, by differentiating $p(x) = (x-c)q(x) + b_0$.
- **True:** differentiating gives $p'(x) = q(x) + (x-c)q'(x)$, so $p'(c) = q(c) = d_0$. In general $d_0 \ne b_1$. The recurrence on line 58 and $p'(c) = d_0$ are correct; only "$= b_1$" and the bracketed justification are false. The slip looks like a mix-up with Mathews' notation: his second-pass sequence (gr_92) is $c_n = b_n$, $c_k = b_k + z\,c_{k+1}$, with output $c_1 = P'(z)$; the page re-indexed it to $d_k = c_{k+1}$ but kept a subscript 1.
- **How the reviewer knows:** sympy, $n = 5$, general $a_k, c$: `d0 == p'(c)` is True, and `d0 - b1 = a2*c + 2*a3*c**2 + 3*a4*c**3 + 4*a5*c**4`. On the page's own example $d_0 = 27 = p'(2)$ but $b_1 = 1$.
- **Fix:** "Then $p'(c) = d_0 = q(c)$. Differentiating $p(x) = (x-c)q(x) + b_0$ gives $p'(x) = q(x) + (x-c)q'(x)$, so $p'(c) = q(c)$."

### F2. Page text, Error: the worked example's derivative sentence is garbled and implies $p'(2) = 1$

*Independent check: **confirmed** (Error). The checker computed $p'(x) = 8x^3 - 9x^2 + 2x - 5$, $p'(2) = 27$, and the second tableau $d = (2, 5, 13, 27)$; "$1\cdot2\cdot2\cdot2+\ldots$" matches no valid formula, and the page never states $p'(2)$.*

- **Location:** line 93: "Applying Horner's method again to $q(x)$ at $c = 2$ gives $p'(2) = b_1 = 1 \cdot 2 \cdot 2 \cdot 2 + \ldots$ — or more directly, since $b_1 = 1$ is already computed, a second tableau on the $b_k$ values would yield $p'(2)$."
- **Now:** sets $p'(2) = b_1$ (which would be 1), then gives a meaningless expression, and never states $p'(2)$.
- **True:** $p'(x) = 8x^3 - 9x^2 + 2x - 5$, $p'(2) = 27$. Horner on $q(x) = 2x^3 + x^2 + 3x + 1$ at $c = 2$: $d_3 = 2$, $d_2 = 5$, $d_1 = 13$, $d_0 = 27$.
- **Fix:** replace line 93 with the second step table ($d_3 = 2$, $d_2 = 5$, $d_1 = 13$, $d_0 = 27$), the conclusion $p'(2) = d_0 = 27$, and the check $p'(2) = 64 - 36 + 4 - 5 = 27$.

### F3. Page text, Minor (unverified): line 48 leaves $b_n$ out of the quotient's coefficients

- **Location:** line 48: "The intermediate values $b_{n-1}, b_{n-2}, \ldots, b_1$ are the coefficients of the *quotient polynomial* $q(x)$ of degree $n-1$".
- **True:** $q$ has the $n$ coefficients $b_n, \ldots, b_1$ (line 50 itself writes $q(x) = b_n x^{n-1} + \cdots + b_1$, and the example's $q$ has leading coefficient $b_4 = 2$).
- **Fix:** "The values $b_n, b_{n-1}, \ldots, b_1$ are the coefficients of the quotient polynomial…"

### F4. Fidelity, Minor (unverified): Mathews' example polynomial replaced, and his derivative and Newton–Horner examples dropped without comment

- **Location:** "Worked Example" (lines 77–93), and the page as a whole.
- **Now:** one example, $p(x) = 2x^4 - 3x^3 + x^2 - 5x + 7$ at $c = 2$.
- **Archive:** Examples 1–3 use $P(x) = x^5 - 6x^4 + 8x^3 + 8x^2 + 4x - 40$ ($P(3)$, the tableau, $P'(3)$); Example 4 does one Newton step with Horner values; Example 5 runs Newton–Horner to a root; Example 6 compares Horner with ordinary evaluation on $\prod_{k=1}^{10}(x-k)$ (expanded coefficients in gr_179 confirmed); Example 7 covers higher derivatives; Example 8 deflation and all real roots; plus a "Horner's Method for Higher Derivatives" lemma and a "Polynomial Deflation" section.
- **Why it matters:** with Example 3 dropped, the derivative recurrence is never worked through, which is how F1 and F2 went unnoticed.
- **Reference values:** $P(3) = 17$ with $b = [1, -3, -1, 5, 19, 17]$; second pass $[1, 0, -1, 2, 25]$, so $P'(3) = 25$ (direct differentiation agrees).
- **Fix:** work Mathews' Examples 1–3 ($P(3) = 17$, $P'(3) = 25$), or at least complete the derivative example (F2), and say that the deflation and Newton–Horner examples are not covered.

## Inventory (mechanical checks)

No control characters, no leftover "(Planned)" / "Animation Focus" / legacy stub, no `localhost` link, no code block, no link to a missing target.

## Claim ledger (whole page)

| # | Line | Claim | Verdict |
|---|---|---|---|
| 1 | 12 | Also called synthetic division / nested multiplication | confirmed |
| 2 | 12 | $n$ multiplications and $n$ additions for degree $n$ | confirmed |
| 3 | 18 | General form of $p$ | confirmed |
| 4 | 20 | Naive: $a_k x^k$ costs $k$ multiplications | confirmed |
| 5 | 22 | $\sum_{k=1}^n k = n(n+1)/2$ | confirmed |
| 6 | 24 | Degree 10 gives 55 multiplications | confirmed |
| 7 | 30–32 | Nested form of the degree-5 polynomial | confirmed (symbolic) |
| 8 | 34 | Exactly $n$ multiplications and $n$ additions; $O(n^2) \to O(n)$ | confirmed relative to the per-term naive scheme of lines 20–22 |
| 9 | 44 | $b_n = a_n$, $b_k = b_{k+1}c + a_k$ | confirmed (run as written) |
| 10 | 46 | $p(c) = b_0$ | confirmed (symbolic) |
| 11 | 48 | "$b_{n-1}, \ldots, b_1$ are the coefficients of $q$" | wrong: $b_n$ missing (F3) |
| 12 | 48 | $q$ has degree $n-1$; $b_0$ is the remainder | confirmed |
| 13 | 50 | $p(x) = (x-c)q(x) + b_0$ | confirmed (symbolic) |
| 14 | 52 | Equivalent to synthetic division by $(x-c)$ | confirmed (`sp.div`) |
| 15 | 56 | Horner on $q$ gives $p'(c)$ | confirmed |
| 16 | 58 | $d_{n-1} = b_n$, $d_k = d_{k+1}c + b_{k+1}$ | confirmed |
| 17 | 60 | $p'(c) = d_0$ | confirmed |
| 18 | 60 | $d_0 = b_1$, "follows from differentiating the factorization" | wrong (F1) |
| 19 | 62–64 | Newton–Horner: Horner gives $p(x_k)$, $p'(x_k)$; $x_{k+1} = x_k - p(x_k)/p'(x_k)$ | confirmed |
| 20 | 68–75 | Tableau layout; each bottom entry is the sum of the two above | confirmed (first column trivial) |
| 21 | 79–81 | Problem: $p(2)$ for $2x^4 - 3x^3 + x^2 - 5x + 7$ | confirmed as stated (differs from Mathews; F4) |
| 22 | 85–89 | $b_4..b_0 = 2, 1, 3, 1, 9$ | confirmed |
| 23 | 91 | $p(2) = 9$; $q(x) = 2x^3 + x^2 + 3x + 1$ | confirmed (direct substitution; `sp.div`) |
| 24 | 93 | "$p'(2) = b_1 = 1\cdot2\cdot2\cdot2 + \ldots$" | wrong (F2) |
| 25 | 93 | A second tableau on the $b_k$ would yield $p'(2)$ | confirmed (27), but the value is never stated |
| 26 | 99–100 | Direct evaluation $n(n+1)/2$ multiplications; Horner $n$ | confirmed |
| 27 | — | Markup | confirmed; nothing broken (the tableau's first row renders as a markdown header row, cosmetic) |

## Checks

- Line 44's recurrence run as written on the example: $b = (2, 1, 3, 1, 9)$, $p(2) = 9$ by direct substitution; sympy `div` gives quotient $2x^3 + x^2 + 3x + 1$, remainder 9.
- Symbolic degree-5 check: $b_0 = p(c)$ and $p = (x-c)q + b_0$ both True.
- Line 58's recurrence run as written: $d = (2, 5, 13, 27)$; true $p'(2) = 27$; the page's $b_1 = 1$.
- $\sum_{k=1}^{10} k = 55$.
- Newton step from $x_0 = 2$ (formula check only): $x_1 = 2 - 9/27 = 5/3$.
- Not determined: Mathews' Mathematica outputs for Examples 5–8 (the page makes no claims about them).
