# Review: LU Factorization (batch 11, text-only)

Page: `pages/numerical-methods/lu-factorization.qmd` (419 lines). Module: `n2003/LUFactorMod.html` ("PA = LU Factorization with Pivoting"), example folder `n2003/lufactorization/LUFactorMod/` (9 link pages). The reviewer consulted the archive (module text, all 9 link pages, the images it needed).

**Calibration page.** This page was the batch's pilot. The reviewer worked on a scratch copy into which the director had planted two errors (a decimal wrong in its third significant digit and a false behaviour sentence). The reviewer found both. Those two planted findings are removed from this report; the copy differed from the real page only on those two lines (391 and 397, same line count), so every line number below applies to the real page.

**Findings: 0 Error, 1 Misleading, 3 Minor.** The Misleading finding was confirmed by an independent check.

## Findings

### F1. Fidelity, Misleading: the source's pivoting example is silently turned into a no-pivoting one

*Independent check: **confirmed** (Misleading). A fresh checker, given only the allegation, reproduced the page's factors (correct, no-pivot LU exists: leading minors 2, −36, −126), ran partial pivoting (`scipy.linalg.lu`: rows 1 and 2 swap, U = [[4,−10,2],[0,9,0],[0,0,3.5]], y = (−8, 9, 10.5)), and read the source's task "Use PA = LU factorization with pivoting" and its pivoted output images gr_98, gr_99, gr_118, gr_121. None of the page's L, U or y match the source. Kept at Misleading: the final x is right and the literal sentence is defensible.*

- **Location:** Example 3, lines 198–229. Heading "Example 3 - Solving a System with PA = LU", then "From the source module:" and line 213: "Here no row swaps are needed, so $P=I$."
- **Now:** the section sits directly after "Theorem - PA = LU with Pivoting" and is the page's only worked PA = LU solve. It uses P = I, L = [[1,0,0],[2,1,0],[1/2,0,1]], U = [[2,4,1],[0,−18,0],[0,0,7/2]].
- **True:**
  - The narrow claim holds: A has nonzero leading minors, so a no-pivot LU exists. The page's L, U, y and x are all correct.
  - But this is source Example 4, "Use PA = LU factorization with pivoting". Mathews' LUfactor uses partial pivoting and gets a real row swap: P = [[0,1,0],[1,0,0],[0,0,1]], L = [[1,0,0],[0.5,1,0],[0.25,0.5,1]], U = [[4,−10,2],[0,9,0],[0,0,3.5]], Pb = (−8,5,13), y = (−8,9,10.5) (archive images `gr_117`, `gr_121`, `gr_127`, `gr_128`).
  - As written, a reader learns that "PA = LU with pivoting" gives P = I here, and that rows are swapped only when a pivot is exactly zero. Partial pivoting swaps here because |4| > |2|.
  - The page's other permutation (Example 2) is also ad hoc ("one valid reordered matrix"), so the page never shows the pivoting algorithm its source module is named for.
- **How the reviewer knows:** exact partial-pivoting LU (`pplu` in the reviewer's `check.py`) gives the P, L, U above; P·A = L·U is True, y = (−8, 9, 21/2) and x = (−1, 1, 3), all matching the archive images.
- **Fix:** either rework Example 3 with the partial-pivoting factors above (P swaps rows 1 and 2, Pb = (−8,5,13)ᵀ, y = (−8,9,21/2)ᵀ, x = (−1,1,3)ᵀ), or retitle it as a no-pivot LU solve and say that partial pivoting would swap rows 1 and 2.

### F2. Page text, Minor (unverified): the quoted condition number belongs to the perturbed matrix

- **Location:** lines 417–418: "The source reports a condition number near $2.87518\times 10^7$, indicating severe ill-conditioning."
- **Now:** the number is given with no matrix named, in a warning about how sensitive the *original* system is.
- **True:** the source gives κ(A) = 4.39152×10⁷ for the original matrix (`gr_241`, `gr_267`) and 2.87518×10⁷ for the perturbed Ã (`gr_263`). numpy, ∞-norm (the 1-norm agrees, the matrix being symmetric): κ(A) = 43,915,200 and κ(Ã) = 28,751,832. In the 2-norm: κ(A) = 3.19×10⁷, κ(Ã) = 2.08×10⁷. The conclusion (severe ill-conditioning) is unchanged.
- **Fix:** "The original matrix has condition number $\kappa_\infty(A)\approx4.39\times10^7$ (the perturbed one, $\approx2.88\times10^7$)".

### F3. Fidelity, Minor (unverified): two archive cases dropped without mention

- **Location:** the page as a whole. Examples 1–3 say "From the source module"; Examples 4–5 cite source Examples 6–8.
- **Now:** source Example 2 (factor the 4×4 matrix [[4,2,−1,3],[3,−4,2,5],[−2,6,−5,−2],[5,1,6,−3]]) and source Example 5 (solve the 4×4 system with that matrix and b = (16.9, −14, 25, 9.4)) are left out without comment.
- **True:** both are well posed. The leading minors are 4, −22, 44, 99, so a no-pivot LU exists. The Example 5 solution is (9/2, 8/5, −19/5, −27/10). Leaving them out loses the only 4×4 cases.
- **Fix:** add them, or note that they were omitted.

### F4. Page text, Minor (unverified): coefficient indexing changes between (6) and the examples

- **Location:** line 270, `p_m(x)=c_0+c_1x+\cdots+c_mx^m`, and (6) with j = 0..m, versus line 291, `p_2(x)=c_1+c_2x+c_3x^2`, and line 328, `p_3(x)=c_1+\dots+c_4x^3`.
- **Now:** under (6), c₁ is the coefficient of x. In the examples, c₁ is the constant term.
- **True:** the matrices and solutions are correct; only the labels shift by one. A reader who maps an example's c₁ back to (6) mislabels every coefficient.
- **Fix:** index (6) from 1 (p(x) = Σ_{j=1}^{m+1} c_j x^{j−1}), or re-index the examples from c₀.

## Inventory (mechanical checks)

No control characters, no leftover "(Planned)" / "Animation Focus" / legacy stub, no `localhost` link, no code block, no link to a missing target. The only link is the back link `./`.

## Claim ledger (whole page)

| # | Line | Claim | Verdict |
|---|---|---|---|
| 1 | 12–13 | LU turns solving into forward and back substitution | confirmed |
| 2 | 18–24 | Definition: A = LU, L lower and U upper triangular | confirmed |
| 3 | 26–29 | Doolittle means L has unit diagonal | confirmed |
| 4 | 33–38 | Eq. (1): Ly = b, Ux = y | confirmed |
| 5 | 41–46 | Theorem: elimination without row exchanges (all pivots nonzero) gives a Doolittle factorization | confirmed (hypotheses sufficient) |
| 6 | 50–55 | Eq. (2): u_kj = a_kj − Σ_{s<k} ℓ_ks u_sj, j = k..n | confirmed (run as written) |
| 7 | 57–60 | Eq. (3): ℓ_ik = (a_ik − Σ ℓ_is u_sk)/u_kk, i > k | confirmed (run as written) |
| 8 | 62 | ℓ_kk = 1; breakdown when u_kk = 0 | confirmed |
| 9 | 66–75 | Example 1 matrix is from the source | confirmed (`gr_8`) |
| 10 | 77–80 | u₁₁ = 4, ℓ₂₁ = −3/4, ℓ₃₁ = 1/2 | confirmed |
| 11 | 86–88 | u₂₂ = 5/2, u₂₃ = 25/4 | confirmed |
| 12 | 94 | ℓ₃₂ = 6/5 | confirmed |
| 13 | 96 | u₃₃ = −4 | confirmed |
| 14 | 101–115 | L and U as shown | confirmed (also equal the source, `gr_17`, `gr_18`) |
| 15 | 121–123 | Verification rows | confirmed (both sides) |
| 16 | 125 | LU = A | confirmed |
| 17 | 129–138 | Example 2 matrix is from the source | confirmed (`gr_39`) |
| 18 | 140 | det(A) = 175 ≠ 0 | confirmed |
| 19 | 140–144 | No-pivot Doolittle breaks: u₂₂ = 8 − 4·2 = 0 | confirmed |
| 20 | 146 | Nonsingularity alone does not guarantee LU without pivoting | confirmed (leading 2×2 minor = 0) |
| 21 | 148–158 | B = PA (rows 2, 3, 1) is a valid reordering | confirmed (also the partial-pivoting result; the source used a different, also valid, swap) |
| 22 | 162–176 | L and U of B | confirmed |
| 23 | 178 | LU = B = PA | confirmed |
| 24 | 180–188 | Theorem: every nonsingular A has P with PA = LU | confirmed |
| 25 | 190–195 | Eq. (5): Ly = Pb, Ux = y | confirmed |
| 26 | 200–211 | Example 3 system is from the source | confirmed (`gr_94`) |
| 27 | 213 | "no row swaps are needed, so P = I" | confirmed narrowly; Fidelity departure (F1) |
| 28 | 215–229 | L and U for P = I | confirmed |
| 29 | 233–238 | y = (5, −18, 21/2) | confirmed |
| 30 | 243–248 | x₃ = 3, x₂ = 1, x₁ = −1 | confirmed |
| 31 | 253–255 | x = (−1, 1, 3)ᵀ | confirmed |
| 32 | 259–263 | Verification rows 5, −8, 13 | confirmed (both sides) |
| 33 | 267–279 | Normal equations (6) | confirmed; indexing inconsistent with the examples (F4) |
| 34 | 281 | The system is solved efficiently by LU | confirmed |
| 35 | 285–288 | Data (2,8), (3,27), (4,64), (5,125) from the source | confirmed (`gr_194`) |
| 36 | 291–302 | 3×3 normal matrix and right side | confirmed |
| 37 | 306–316 | c = (357/10, −347/10, 21/2) and p₂ | confirmed (`gr_200`, `gr_203`) |
| 38 | 320–324 | Verification rows 224, 978, 4424 | confirmed (both sides) |
| 39 | 328–340 | 4×4 normal equations | confirmed (`gr_242`) |
| 40 | 344–350 | c = (0,0,0,1), p₃ = x³ | confirmed |
| 41 | 352 | p₃ matches the data exactly | confirmed |
| 42 | 356–361 | a₄₄: 20514 → 20515; 1/20514 = 0.0000487 = 0.00487% | confirmed (4.8747e−5) |
| 43 | 366–376 | Perturbed matrix Ã | confirmed |
| 44 | 381–387 | c̃ = (51/4, −347/28, 15/4, 9/14) | confirmed |
| 45 | 389–394 | Decimals 12.75, −12.3929, 3.75, 0.642857 | confirmed (on the real page; the copy's planted decimal was caught) |
| 46 | 397–400 | q(x) = 51/4 − (347/28)x + (15/4)x² + (9/14)x³ | confirmed |
| 47 | 405–410 | Perturbed verification rows 224, 978, 4424, 20514 | confirmed (both sides, exact) |
| 48 | 415 | 0.00487% perturbation in one entry | confirmed |
| 49 | 416–417 | c₄: 1 → 9/14, relative change ≈ 35.7% | confirmed (5/14 = 0.35714) |
| 50 | 417–418 | Source reports a condition number near 2.87518×10⁷ | confirmed as quoted (κ∞ of Ã); misattributed by context (F2) |
| 51 | 418 | Severe ill-conditioning | confirmed (κ ≈ 10⁷ in the 1, 2 and ∞ norms) |
| 52 | whole page | Markup: `\tag` inside `$$`, `\\[2pt]` in pmatrix, `\%` in math, `$\checkmark$` in tables | confirmed; no broken markup |

## Checks (reviewer's numbers beside the page's)

- **Algorithm (2)–(3), run as written** (exact): Example 1 gives L = [[1,0,0],[−3/4,1,0],[1/2,6/5,1]], U = [[4,2,3],[0,5/2,25/4],[0,0,−4]], LU = A, as on the page. Example 2's matrix breaks at k = 2 with u₂₂ = 0, as on the page. The page's B gives L = [[1,0,0],[−1/2,1,0],[1/4,0,1]], U = [[4,8,−1],[0,7,9/2],[0,0,25/4]], as on the page. Example 3's matrix gives the page's L and U.
- **Example 2:** det = 175; leading minors 1, 0, 175; PA = B for the cyclic permutation.
- **Example 3:** y = (5, −18, 21/2), x = (−1, 1, 3), A·x = (5, −8, 13), as on the page; sympy's direct solve agrees. Partial pivoting swaps rows 1 and 2 (see F1).
- **Example 4:** the normal equations built from the data match the page; the solve gives (357/10, −347/10, 21/2); solving VᵀVc = Vᵀy with the Vandermonde matrix agrees.
- **Example 5:** unperturbed c = (0,0,0,1); perturbed c̃ = (12.75, −12.392857, 3.75, 0.642857); Ã·c̃ = (224, 978, 4424, 20514) exactly; relative change of c₄ = 0.35714; det A = 144, det Ã = 224; condition numbers as in F2.
- **Theorem hypotheses:** the no-pivoting theorem (nonzero pivots) and the PA = LU theorem (nonsingular A) are both correctly stated.
- **Could not determine:** nothing on the page depends on MATLAB output. Source Example 4's P image is missing from the archive, so the reviewer took P from the `PB =` output (`gr_121`).
