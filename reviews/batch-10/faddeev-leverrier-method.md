# Review: Faddeev-Leverrier Method (batch 10, text-only)

Page: `pages/numerical-methods/faddeev-leverrier-method.qmd` (460 lines; text written in this batch). Module: `n2003/FaddeevLeverrierMod.html` ("Faddeev-Leverrier Method for Eigenvalues"), example folder `n2003/faddeev/FaddeevLeverrierMod/` (4 link pages). The reviewer consulted the archive (module, the 4 link pages, images gr_8, 9, 36, 37, 39, 40, 42, 44, 47, 48, 53, 54, 56, 59, 62). Because the page text was written in this batch, the claim ledger covers the whole page.

**Calibration page.** This page was the batch's pilot. The reviewer worked on a scratch copy into which the director had planted two errors (Example 2's $p_2$ given as −318; a false sentence calling Example 1's matrix symmetric). The reviewer found both. They are removed from this report. The planted sentence added two lines after line 154 of the copy, so line numbers from 155 on are given below for the real page (copy line − 2).

**Findings: 0 Error, 0 Misleading, 2 Minor** (unverified, as the review skill allows for Minor findings).

## Findings

### F1. Page text, Minor: the $n = 25$ and $n = 30$ eigenvalue errors in the floating-point table ignore the imaginary parts

- **Location:** lines 434–435, "| 25 | 2.5×10⁻⁶ | 1.4 (complex roots appear) |" and "| 30 | 8.7×10⁻⁴ | 3.2 (complex roots appear) |".
- **True:** the reviewer reproduced the experiment (`np.random.default_rng(0)`, 120-digit reference) and every other entry of the table to the digit (relative coefficient errors 4.6e-16, 2.6e-14, 5.0e-11, 6.1e-09, 2.5e-06, 8.7e-04; eigenvalue errors for n = 5–20: 1.9e-13, 3.2e-09, 1.0e-05, 1.5e-01). The values 1.4 and 3.2 are reproduced only by sorting the real parts of the roots and comparing them with the eigenvalues, discarding the imaginary parts. At n = 25, 20 of the 25 roots are complex with |Im| up to 3.2; at n = 30, 26 roots with |Im| up to 7.0. The true distance from the computed roots to the eigenvalues is 3.3 at n = 25 (optimal matching; nearest-root 3.2) and 7.0 at n = 30. The conclusion (the eigenvalues are useless) is unchanged.
- **Fix:** "3.3 (complex roots appear)" and "7.0 (complex roots appear)", or relabel those cells as the error in the real parts and give the imaginary parts (up to 3.2 and 7.0).

### F2. Fidelity, Minor: the page says Mathews uses a different sign convention, but he uses the page's own $p_k$

- **Location:** lines 45–46, "Mathews writes the polynomial as $P(\lambda) = \lambda^n + c_1\lambda^{n-1} + \cdots + c_n$, so $c_k = -p_k$. The minus signs in (1) make the recursion below free of signs."
- **True:** Mathews' eq (3) (gr_9) uses $c_k$, but his eq (6) (gr_36) writes $P(\lambda) = \lambda^n - p_1\lambda^{n-1} - \cdots - p_n$, exactly the page's (1), and his recursion (gr_39) and worked solutions use these $p_k$.
- **Fix:** "Mathews first writes the polynomial as $\lambda^n + c_1\lambda^{n-1} + \cdots + c_n$, then, like this page, as (1) with $c_k = -p_k$; the minus signs make the recursion free of signs."

## Inventory (mechanical checks)

No control characters, no leftover "(Planned)" / "Animation Focus" / legacy stub, no `localhost` link, no code block, no link to a missing target.

## Claim ledger (condensed; 105 entries in the reviewer's ledger)

Confirmed: the introduction (roots of the characteristic polynomial, $n!$ terms, what the recursion gives, exact but poor in floating point); trace definition; (1); the recursion (2)–(3) (same as Mathews' gr_39; run on the three examples and on random integer 5×5 matrices) and the inverse formula (4); all four theorem items ($B_n = p_nI$, $\det A = (-1)^{n+1}p_n$, the inverse); the proof via the adjugate and Jacobi's formula, every step re-derived; $C_{n-1} = (-1)^{n-1}\operatorname{adj}A$, also for singular $A$; Newton's identities and Example 1's $s_k$ and $p_k$; the sign-convention remark on det(A − λI); Example 1 in full ($B_k$, $p = (6,-11,6)$, $A^{-1}$, eigenvalues 1, 2, 3, det 6, every verification row, agreement with Mathews' gr_42/44/48); Example 2 in full ($p = (30, -319, 1410, -2138)$, every $B_k$, $2138A^{-1}$ and its reduced form, irreducibility over ℚ, the shift 15/2, the closed-form roots and their decimals, Gershgorin interval, det, every verification row); Example 3 in full ($p = (10, -36, 56, -35, 6)$, every $B_k$, the inverse and its min/max formula, the factorization and eigenvalues $2 \pm \sqrt3$, 1, 2, 3 $= 2 + 2\cos(k\pi/6)$, every verification row; Mathews' Example 3 outputs are missing, as the page says); the integer-matrix, singular-matrix ($A - I$), division-by-$k$, cost and floating-point remarks; the n = 20 side claims (0.14, ~2×10⁻¹⁴, $p_1 \approx 210$, $|p_{18}| \approx 1.4\times10^{19}$); practical recommendations; markup; fidelity (all three of Mathews' examples present).

Not confirmed: lines 45–46 (F2); lines 434–435's two numbers (F1).

## Checks

The recursion (2)–(4) run literally in sympy exact arithmetic reproduces every $B_k$, $p_k$ and inverse on the page for all three examples (table in the reviewer's report); the closed-form roots of Example 2 make $P$ vanish exactly; random 5×5 integer matrices confirm the theorem, $C_{n-1} = \operatorname{adj}(-A)$, integrality and Newton's identities. Floating-point table reproduced with seed 0 (`fp.py`, `fp2.py`; mpmath 120 digits, numpy `roots`, `eigvalsh`); other seeds give the same orders of magnitude.
