# Review: Iterative Refinement (batch 12, text-only)

Page: `pages/numerical-methods/iterative-refinement.qmd` (283 lines). Module: `n2003/IterativeRefinementMod.html` ("Iterative Refinement - Residual Correction"), example folder `n2003/iterativerefinement/IterativeRefinementMod/` (11 link pages). The reviewer consulted the archive (module, all 11 link pages, images for Examples 2–9; Example 4's full output gr_123–159, with gr_129, 134, 138, 140 enlarged). Images for Examples 2 and 3 are missing.

**Findings: 2 Error, 1 Misleading, 2 Minor.** All three were confirmed by an independent check; the checker graded F2 Misleading (borderline Error) and the reviewer Error. F2 stays at Error here because the page states (7) as a general inequality, which the checker showed false in general.

## Findings

### F1. Page text, Error: Example 2 copies several digits of the source output wrongly, so $x^{(1)}$ no longer has the residual the page reports

*Independent check: **confirmed** (Error). Each mis-copied digit traced to the source images (gr_134, gr_143, gr_145); with the page's digits, $H\Delta x - r^{(0)} \approx$ 2–5×10⁻⁸ per component (≈10⁻¹⁴ with the source's).*

- **Location and values** (page vs Mathews' Solution 4, gr_134, gr_138):

  | Line | Quantity | Page | Source |
  |---|---|---|---|
  | 198, 241 | $r^{(0)}_3$ | −35.09523809502379 | −35.0952380952379 |
  | 217 | $\Delta x_3$ | −709.999999877721 | −709.9999999877721 |
  | 219 | $\Delta x_5$ | 550.000000080213 | 550.0000000080213 |
  | 230 | $x^{(1)}_3$ | −10709.9999998777 | −10709.99999998777 |
  | 232 | $x^{(1)}_5$ | −9449.9999999198 | −9449.99999999198 |
  | 247 | $r^{(1)}_2$ | −1.77635683940025×10⁻¹⁴ | −1.77635683940025×10⁻¹⁵ |

- **True:** exact $r^{(0)}_3 = -737/21 = -35.095238095238095$ (the page's value is off by 2.1×10⁻¹⁰); the page's $\Delta x_3$, $\Delta x_5$ are off from the exact −710, 550 by 1.2×10⁻⁷ and 8.0×10⁻⁸ (the source's by ten times less). The page is self-consistent, but its $x^{(1)}$ substituted exactly gives $b - H_5x^{(1)} \approx (-5.1, -4.0, -3.2, -2.7, -2.4)\times10^{-8}$, not the ~10⁻¹⁴ residual the page reports; the source's $x^{(1)}$ gives ~7×10⁻¹³.
- **Fix:** restore the source digits above (or give $r^{(0)}$ exactly), mark the last digits as Mathews' printed Mathematica values, and optionally note the exact $\Delta x = (5, 160, -710, -80, 550)$.

### F2. Page text, Error: inequality (7) is stated as a general bound without its conditions, with mismatched norms

*Independent check: **confirmed** (checker's grade Misleading, borderline Error). Mathews' "Fact" carries the hypothesis "If A, B are input with machine precision". As a general inequality (7) is false: Gaussian elimination with partial pivoting on Wilkinson's growth matrix (n = 60) gave an ∞-norm error of 15.3 against a "bound" of 3.1×10⁻¹⁴. The norm mixing is copied from Mathews (gr_157).*

- **Location:** lines 258–278: "Cond(A) = 943656", "‖x‖₂ = 23017.6", (7) $\|\mathbf{x}-\hat{\mathbf{x}}\|\le \|\mathbf{x}\|\operatorname{Cond}(A)\varepsilon$, and (8).
- **True:** 943656 is $\kappa_\infty(H_5) = \kappa_1$; $\kappa_2 = 476607.25$. Consistent pairs give $\kappa_2\|x\|_2\varepsilon = 2.44\times10^{-6}$ or $\kappa_\infty\|x\|_\infty\varepsilon = 3.75\times10^{-6}$; the page's 4.82×10⁻⁶ mixes them. (7) holds only when $\hat x$ solves a system whose data are perturbed by relative ε (and then with $\|\hat x\|$; Mathews has $\|\hat X\|$, the page changed it to $\|x\|$); for an elimination-computed solution it is a rule-of-thumb estimate. The example's errors (plain LU ≈ 3.4×10⁻⁹, refined ≈ 6×10⁻⁸) happen to sit inside it.
- **Fix:** call (7) a first-order estimate "if $\hat x$ is the exact solution of a system whose data are perturbed by relative amount ε"; use $\|\hat x\|$ or say "approximately"; name the norm and pair it consistently.

### F3. Fidelity / Page text, Misleading: the page omits what makes refinement work, and Mathews' caveat that further iterations do not help

*Independent check: **confirmed** (Misleading), with two corrections: "gains accuracy only with higher-precision residuals" is too strong (refinement in working precision does remove gross errors such as this artificial $x^{(0)}$, and improves backward stability, but cannot push the forward error below about Cond·ε); and line 133 is fine (it refers to Example 1's exact arithmetic). Working-precision run from the same $x^{(0)}$: error 710, 6.0×10⁻⁸, 2.7×10⁻⁸, 1.7×10⁻⁹, 8.9×10⁻⁸, 3.6×10⁻⁸; residual stalls at 4.5×10⁻¹³. Mathews' gr_143/145 show $x^{(2)}$, $r^{(2)}$ (~10⁻¹³, larger than $r^{(1)}$), which the page leaves out.*

- **Location:** lines 12–19, the Algorithm box 63–76, line 133 ("This is the exact solution."), line 254 ("rapid residual reduction after one correction step").
- **True:** Mathews' Remark 1: the "signal feature" is computing residuals in higher precision. His Example 4 caveat: "If iteration is done one more time the values will not get closer to the solution" ($R_3 \approx 4\times10^{-13} > R_2$). In Example 1 the one-step exact result is automatic in exact arithmetic. In Example 2 the refined $x^{(1)}$ is *less* accurate than the plain LU solution (source: 1.7×10⁻⁸ vs 3.5×10⁻⁹; float run 6.0×10⁻⁸ vs 3.4×10⁻⁹): the "improvement" is only relative to the artificial starting vector.
- **Fix:** say the residual is computed in higher precision when refinement is meant to gain accuracy, and that in working precision the residual stagnates after one step; add Mathews' caveat after Example 2; after line 133 note that in exact arithmetic one step always gives the exact solution.

### F4. Fidelity, Minor (unverified): archive examples dropped without comment

- Mathews' Example 1 (the PA = LU solve), Example 3 (5×5, $A$ = [[1,2,4,3,5],[3,5,3,1,2],[1,4,4,2,1],[4,1,2,5,3],[5,2,1,4,1]], $b$ = (5,6,7,8,9)), and Examples 5–9 (Hilbert $H_6$–$H_{10}$, conditioning growing with $n$). The page's Examples 1 and 2 are Mathews' 2 and 4. **Fix:** a sentence noting the n = 6…10 experiments, or one larger $n$.

### F5. Page text, Minor (unverified): $r^{(0)}_2$ is shown as −46 in a vector labelled as what "the source reports"

- **Location:** lines 197, 241. The source prints −46.00000000000025 (exact −46). **Fix:** print the source's value, or give $r^{(0)}$ exactly as (−185/3, −46, −737/21, −583/21, −1427/63).

## Inventory (mechanical checks)

No control characters, no leftover "(Planned)" / "Animation Focus" / legacy stub, no `localhost` link, no code block, no link to a missing target.

## Claim ledger (condensed; 31 entries)

Confirmed: refinement without refactorizing; PA = LU triangular solves; residual and correction equations; update; the algorithm (run as written); Example 1's $A$, $b$ (Mathews Ex 2, det 25), $r^{(0)} = (4,-1,0,-1)$, $\Delta x^{(0)} = (-12,-11,3,8)/25$, $x^{(1)}$, exactness, verification rows, $r^{(1)} = 0$; Example 2's $H_5$, $b$, $x_{\rm true}$, $x^{(0)}$ (gr_133), $r^{(0)}_{1,4,5}$, $\Delta x_{1,2,4}$, $x^{(1)}_{1,2,4}$, $r^{(1)}_{1,3,4,5}$; ε and ‖x‖₂; the product 4.82295×10⁻⁶ (arithmetic); $\log_{10}943656 = 5.97$; markup. Could not determine: $x^{(0)}$ of Example 1 versus Mathews (images missing; valid); the source's last Mathematica digits (not reproducible bit for bit).

Not confirmed: Example 2's $r^{(0)}_3$, $\Delta x_{3,5}$, $x^{(1)}_{3,5}$, $r^{(1)}_2$ (F1); $r^{(0)}_2$ labelling (F5); (7) and Cond's norm (F2); the framing at lines 12–19, 133, 254 (F3).

## Checks

`ex1.py` (exact): every Example 1 quantity as on the page. `alg.py` (float64): from the page's $x^{(0)}$, ‖r‖∞ = 4 → 7.1×10⁻¹⁵ → 3.6×10⁻¹⁵; from an LU-solve start the residual stagnates (7, 4, 10 ×10⁻¹⁵). `ex2.py`: exact $r^{(0)}$ and $\Delta x$ as above; float64 refinement as in F3; a second step gives no gain; κ∞ = κ₁ = 943656, κ₂ = 476607.25, ‖x‖∞ = 17920.
