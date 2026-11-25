# Review: Inverse Matrix (batch 12, text-only)

Page: `pages/numerical-methods/inverse-matrix.qmd` (342 lines). Module: `n2003/InverseMatrixMod.html` ("The Matrix Inverse"), example folder `n2003/inversematrix/InverseMatrixMod/` (7 link pages). The reviewer consulted the archive.

**Findings: 4 Error, 2 Misleading, 2 Minor.** Every Error and Misleading finding was confirmed by an independent check; the checker rated one sub-claim of F1 (line 324) Misleading rather than Error, and one part of F3 (lines 194–196, 272–274) Misleading, as the reviewer had.

## Findings

### F1. Page text, Error: the least-squares polynomial in Example 2 is wrong

*Independent check: **confirmed** (Error for line 321; the line 324 sentence Misleading). The checker's exact coefficients agree with the reviewer's to 10 digits; the stated polynomial's largest error on [0,1] is 7.8×10⁻⁴, about 46 times the true fit's 1.7×10⁻⁵.*

- **Location:** line 321, `p(x) \approx 1.000 - 0.502\,x^2 + 0.042\,x^4`; line 324, "closely matching the leading terms of the Taylor series".
- **True:** $c = H_5^{-1}y$ exactly:
  - $c_1 = 13865\sin1-6600\cos1-8100 = 0.99998563$
  - $c_2 = 156480+138360\cos1-274800\sin1 = 0.00041471$
  - $c_3 = 1227870\sin1-641340\cos1-686700 = -0.50272940$
  - $c_4 = 1048320+1018080\cos1-1899520\sin1 = 0.00649594$
  - $c_5 = 945630\sin1-516600\cos1-516600 = 0.03615241$

  so $p(x) \approx 0.999986 + 0.000415x - 0.502729x^2 + 0.006496x^3 + 0.036152x^4$, as Mathews prints (gr_217). The page's 0.042 is the Taylor coefficient $1/24$; it drops the $x$ and $x^3$ terms; $c_5$ differs from $1/24$ by 13%.
- **Fix:** replace line 321 with the polynomial above; replace the Taylor sentence with "its coefficients are close to, but not the same as, the Taylor coefficients $1, 0, -1/2, 0, 1/24$, because least squares spreads the error over all of [0,1]".

### F2. Page text, Error: $c_1 = p(0) = \cos 0$ is claimed to hold exactly

*Independent check: **confirmed** (Error).*

- **Location:** lines 315–316 ("$\approx 1.000$ ✓ (which correctly reproduces $\cos(0) = 1$)") and line 326 ("Check that $c_1 = p(0) = \cos(0)$ holds exactly").
- **True:** $c_1 = 0.9999856318$; a continuous least-squares fit does not interpolate $f$ at an endpoint. The closed form and "≈ 1.000" are fine; the ✓ and "exactly" are false.
- **Fix:** "$c_1 \approx 0.999986$, close to but not equal to $\cos 0 = 1$; a least-squares fit need not pass through $f(0)$"; line 326 "Compare $p$ with $\cos x$ at $x=0$ and $x=1$"; table $p(0)=0.99999$ (error 1.4×10⁻⁵), $p(1)=0.54032$ (error 1.7×10⁻⁵).

### F3. Page text, Error: double precision is said to fail for $H_5$, and exact integer $H_5^{-1}$ to be essential

*Independent check: **confirmed** (Error at lines 318 and 337–338; Misleading at 194–196 and 272–274). Double-precision `solve` gives relative coefficient error 2.2×10⁻¹²; `inv(H5)` differs from the exact inverse by 9.5×10⁻¹⁴ relative. What does matter is how precisely $y$ is known: the page's own 5-decimal $y$ values with the exact $H_5^{-1}$ give $c = (0.99665, 0.0612, -0.7581, 0.3836, -0.1449)$.*

- **Location:** line 318 ("exact integer arithmetic with $H_5^{-1}$ … is essential"); lines 337–338 ("Solving the normal equations numerically (even in double precision) leads to significant errors because $\kappa(H_5) \approx 5 \times 10^5$"); related lines 194–196 and 272–274.
- **True:** $\kappa_2(H_5) = 4.77\times10^5$ costs about 6 of 16 digits; coefficient errors are ~10⁻¹²; the exact inverse applied to floating $y$ has the same cancellation. Ill-conditioning bites for larger $n$ ($\kappa(H_{12}) \sim 10^{16}$) or for rounded data (Mathews' Example 3, see F8).
- **Fix:** remove "even in double precision … significant errors" and "is essential"; say what is true above; soften 194–196 and 272–274.

### F4. Page text, Error: the exact inverse is said to give "exact rational coefficients" and to avoid instability completely

*Independent check: **confirmed** (Error). $c_4 \approx 0.0065$ comes from terms of size ~1.6×10⁶, losing 8–9 digits; exact $H_n^{-1}$ removes the inversion error, not the sensitivity to errors in $y$.*

- **Location:** lines 339–340.
- **True:** each $c_i$ is an integer combination of $1, \sin 1, \cos 1$, not rational; evaluated in floating point the cancellation remains.
- **Fix:** "The exact $H_n^{-1}$ gives the coefficients in exact closed form (integer combinations of $1$, $\sin 1$, $\cos 1$), so they can be evaluated to any precision."

### F5. Page text, Misleading: the inverse is said to pay off over LU for many right-hand sides

*Independent check: **confirmed** (Misleading).*

- **Location:** lines 16–18.
- **True:** a stored LU (≈ ⅔n³ once) answers each right-hand side in ≈ 2n² flops, the same as $A^{-1}b$, while forming $A^{-1}$ costs ≈ 2n³ and is usually less accurate.
- **Fix:** "Once $A^{-1}$ is known each solve costs $O(n^2)$, but a stored LU factorization gives the same $O(n^2)$ per solve at a third of the setup cost and with better accuracy. The inverse is mainly useful in theory, or when its entries themselves are wanted (as with the Hilbert matrix below)."

### F6. Page text, Misleading: Example 1 does not follow the stated algorithm

*Independent check: **confirmed** (Misleading). The stated algorithm would swap rows 2 and 3 at step 2 (pivot 3) and divide each pivot row (step-1 row 1 = (1, 2, 1, 0 | 1/4, 0, 0, 0)); same final $[I \mid A^{-1}]$.*

- **Location:** algorithm lines 43–47 (partial pivoting, normalize, eliminate); Example 1 lines 81 ("pivot = 4", row left as `4 8 4 0`) and 95 ("pivot = 2").
- **True:** the example's matrices are correct for Gauss–Jordan without pivoting and with normalization deferred to the end; a reader running the stated algorithm gets different intermediate matrices.
- **Fix:** one sentence before Step 1: "For hand computation we take the pivots in order without row interchanges and postpone dividing by the pivots to the end; the algorithm above would swap $R_2$ and $R_3$ at step 2 but reaches the same $A^{-1}$."

### F7. Page text, Minor (unverified): "the first three Hilbert matrices" shows $H_2$ to $H_4$

- **Location:** line 175. **Fix:** "The Hilbert matrices of orders 2, 3 and 4 are:".

### F8. Fidelity, Minor (unverified): Mathews' Example 3 (chopped Hilbert matrix) dropped

- **Archive:** $H_5$ with entries rounded to 6 decimals (gr_125) has an inverse off by up to 28259 (reproduced: 28258.85), the module's only concrete demonstration of ill-conditioning. **Fix:** add it (or a sentence with the 28259 figure) as the evidence for the warning; the natural fix for F3.

## Inventory (mechanical checks)

No control characters, no leftover "(Planned)" / "Animation Focus" / legacy stub, no `localhost` link, no code block, no link to a missing target.

## Claim ledger (condensed; 55 entries)

Confirmed: the inverse's definition; $O(n^2)$ per solve; the Gauss–Jordan inverse theorem and algorithm (run as written); Example 1's $A$ (gr_14), every intermediate matrix (for the no-pivot, deferred-normalization variant), $A^{-1}$, det −48, the four verification rows; Hilbert definition and $H_2$–$H_4$; $\kappa(H_5) \approx 4.77\times10^5$ (2-norm 476607.25); formulas (7) and (8) for n = 1…10; $H_5^{-1}$ entries and the two worked entries; the least-squares setup, normal equations and Gram matrix = $H_n$; Example 2's problem (= Mathews Example 4), $y_1..y_5$ closed forms and values, $c_1$'s expression and value; $p(1) = 0.540$ (true of the correct $p$); markup.

Not confirmed: lines 16–18 (F5); Example 1's pivots versus the algorithm (F6); line 175 (F7); lines 194–196, 272–274, 318, 337–340 (F3, F4); lines 315–316, 321, 324, 326 (F1, F2).

## Checks

`ex1.py`: the page's steps replayed exactly; the stated algorithm (swap at $j=2$) reaches the same $A^{-1}$. `hilb.py`: formulas (7), (8) exact for n ≤ 10; float `inv(H5)` error 4.2×10⁻¹³. `ex2.py`: $y$, $c$ as above (match Mathews' printed vector); max error 1.70×10⁻⁵ (true), 7.8×10⁻⁴ (page), 1.36×10⁻³ (Taylor); double-precision solve errors ≤ 1.9×10⁻¹²; chopped $H_5$ inverse difference 28258.85.
