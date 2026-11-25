# Review round 2: Faddeev-Leverrier Method (batch 10, text-only)

Page: `pages/numerical-methods/faddeev-leverrier-method.qmd` (467 lines after the round-1 fix). Module: `n2003/FaddeevLeverrierMod.html`. The reviewer consulted the archive (module, formula images gr_9, 15, 21, 23, 35–37, 39, Examples 1–3 images gr_40–62; gr_63–73 are missing) and did not read earlier rounds' reports. The claim ledger covers the whole page.

**Findings: 0 Error, 1 Misleading, 0 Minor.** The Misleading finding was confirmed by an independent check.

## Findings

### F1. Page text, Misleading: the n = 20 explanation blames root sensitivity alone, but the experiment behind it mixes in the double-precision root finder

*Independent check: **confirmed** (Misleading). Over 20 seeds (`scipy.stats.ortho_group`): medians (a) double recursion + double roots 0.16, (b) rounded 120-digit coefficients + double roots 0.10, (c) 120-digit + high-precision roots 1.1×10⁻¹⁴, (d) rounded + high-precision roots 0.012, (e) double recursion + high-precision roots 0.066; (e) > (d) in 16 of 20 seeds. What the experiment does support: in an all-double pipeline correctly rounded coefficients are no better than the recursion's ($b \approx a$). The page's own numbers are within the spread; only the attribution is wrong. The checker's suggested wording: "Rounding the 120-digit coefficients to double precision and finding the roots with a standard double-precision root finder still gives eigenvalue errors of 0.14, no better than with the recursion's own coefficients. Even the exact roots of the rounded coefficients are off by about $10^{-2}$, while the exact roots of the 120-digit coefficients are correct to about $2\times10^{-14}$. The roots are so sensitive (problem 2) that every small error is magnified: rounding the coefficients to double precision, the root finder's own rounding, and the recursion's coefficient errors of about $10^{-8}$ (problem 1) each move the eigenvalues by $10^{-2}$ to $10^{-1}$. Computing the coefficients more accurately does not help unless the roots are also found in higher precision."*

- **Location:** lines 447–450: "Rounding the 120-digit coefficients to double precision and finding the roots still gives eigenvalue errors of $0.14$, while finding the roots of the 120-digit coefficients in high precision gives the eigenvalues to about $2\times 10^{-14}$. So at $n = 20$ the loss comes mainly from problem 2, the sensitivity of the roots, rather than from the recursion itself."
- **True:** the 0.14 arises only when the rounded coefficients' roots are found by a double-precision root finder (`numpy.roots`), which adds its own error of about 0.02–0.2 at n = 20. The exact roots of the correctly rounded coefficients are off by only about 4×10⁻⁴–3×10⁻²; the exact roots of the double-precision recursion's coefficients are off by about 0.009–0.29, typically ten times more than rounding alone. So the recursion's own coefficient errors (relative about 10⁻⁸ at n = 20) are not secondary.
- **How the reviewer knows:** `wilk.py`, `wilk2.py`: 10 random orthogonal $Q$, recursion in double and in 120-digit mpmath, roots by `np.roots` or `mp.polyroots` (extra precision 800), bottleneck matching:

  | seed | double recursion + np.roots | rounded 120-digit coeffs + np.roots | 120-digit coeffs, high-precision roots | rounded coeffs, high-precision roots | double recursion, high-precision roots |
  |---|---|---|---|---|---|
  | 0 | 0.305 | 0.201 | 1.2e-14 | 0.0169 | 0.293 |
  | 1 | 0.200 | 0.116 | 1.2e-14 | 0.0061 | 0.087 |
  | 2 | 0.268 | 0.049 | 1.4e-14 | 0.0051 | 0.123 |
  | 3 | 0.127 | 0.114 | 7.1e-15 | 0.00036 | 0.076 |
  | 4 | 0.089 | 0.157 | 8.9e-15 | 0.017 | 0.031 |
  | 5 | 0.025 | 0.183 | 1.0e-14 | 0.032 | 0.009 |
  | 6 | 0.254 | 0.040 | 1.1e-14 | 0.0039 | 0.261 |
  | 7 | 0.109 | 0.133 | 1.4e-14 | 0.0046 | 0.016 |
  | 8 | 0.058 | 0.024 | 1.4e-14 | 0.0084 | 0.027 |
  | 9 | 0.175 | 0.044 | 9.8e-15 | 0.0041 | 0.042 |

  The exact Wilkinson polynomial behaves the same way (rounded + `np.roots` 0.093; rounded, exact roots 6.2×10⁻⁴, all real).
- **Fix:** replace the last two sentences, e.g. "Rounding the 120-digit coefficients to double precision and solving with a double-precision root finder still gives eigenvalue errors of about 0.1; the exact roots of those rounded coefficients are off by only about $10^{-3}$–$10^{-2}$, and the exact roots of the double-precision recursion's coefficients by about $10^{-2}$–$10^{-1}$. So at $n = 20$ both problems matter: the coefficient errors of the recursion, and the sensitivity of the roots, which also amplifies the root finder's own rounding."

## Inventory (mechanical checks, rerun after the fix)

No control characters, no leftover "(Planned)" / "Animation Focus" / legacy stub, no `localhost` link, no code block, no link to a missing target.

## Claim ledger (condensed; 122 entries)

Confirmed, apart from F1: the introduction; trace, (1), Mathews' two conventions (gr_9, gr_36); the recursion (2)–(3) and (4) (matching gr_21–39; run on the three examples and 30 random integer matrices, 10 singular); all four theorem items and the proof, every step; Newton's identities; the sign convention remarks; Examples 1–3 in full (every $B_k$, $p_k$, inverse, factorization, eigenvalue, determinant and verification row; agreement with Mathews' gr_42, 44, 48, 53, 54, 56, 59, 61); the integer, singular-matrix, modular, cost and practical remarks; the floating-point table (every entry within the reviewer's spread over seeds; exact values depend on the unspecified random $Q$), the matching definition and the "all real up to n = 20" note; the n = 20 Wilkinson facts ($p_1 \approx 210$, $|p_{18}| \approx 1.4\times10^{19}$), and the 0.14 and 2×10⁻¹⁴ figures themselves; markup.

Not confirmed: the inference at lines 449–450 (F1).

## Checks

`ex.py`, `ex2.py` (sympy exact), `fp.py`, `fp2.py` (the floating-point table over seeds), `wilk.py`, `wilk2.py` (the decomposition in F1).
