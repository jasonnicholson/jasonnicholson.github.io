# Verification: least-squares-polynomials

## A1 — confirmed

- What I checked: (1) Whether the final coefficients in each script really are the degree-m least-squares fits. (2) Whether each intermediate frame, which plots `partial_eval(x, coeffs, k)` (the degree-m coefficients truncated after x^k), matches the true degree-k least-squares fit, and how their RMS values compare. (3) The committed frames, to check what readers see.
- Evidence: `verify/check_a1.py` (numpy `lstsq` on the Vandermonde matrix, degrees 0 to 5).
  - The final coefficients in all four scripts match the true least-squares fits (to within 5e-9), so every final frame is correct.
  - The intermediate truncations are not least-squares fits. Their coefficients differ from the true degree-k fits by up to 0.86. Their RMS is always higher than the true degree-k least-squares RMS:
    - m=2: k=0 gives 1.993 vs 1.799, and k=1 gives 0.897 vs 0.540.
    - m=4: k=2 gives 0.2209 vs 0.0525, and k=3 gives 0.1672 vs 0.0277.
    - m=5: k=3 gives 0.2027 vs 0.0277, and k=4 gives 0.1051 vs 0.00734.
  - In the quintic case the RMS gets worse when a term is added. Truncating after x^2 gives RMS 0.17774, and adding the x^3 term raises it to 0.20267. The committed frames `committed/leastsqpolyad/frame_003.png` and `frame_004.png` show exactly these values ("RMS(partial) = 0.17774" and "= 0.20267"). Their titles read "Least Squares Polynomial Fit: Degree 5 (terms through x^2)" and "(terms through x^3)". Truncating a least-squares fit is not a least-squares fit, because the monomial basis is not orthogonal on these points.
- Severity: Misleading is fair. The page text (line 36) and the legend do say "partial polynomial built from terms up to degree k", so the description is narrowly accurate. But the phrase "term-by-term construction of the least-squares polynomial fit" and the frame titles suggest that each frame shows a least-squares fit, or that least squares builds the fit up term by term. Neither is true. The non-monotone RMS (0.178 to 0.203) also sits awkwardly beside the page's line 32, which says RMS decreases as the degree increases. That statement is true only for genuine least-squares fits.
- Correction to the allegation: none needed. The locations are correct: page line 36, `partial_eval` on script line 16, and the title on script line 29, in all four scripts. "Can even fit worse as terms are added" is borne out by the m=5 case, k=2 to k=3.
