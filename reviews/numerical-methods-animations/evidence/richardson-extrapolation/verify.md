# Verification: richardson-extrapolation
## A1 — confirmed with correction
- What I checked: Recomputed the max errors on the script's own 700-point grid in Julia (copy of the formulas in verify/vals.jl), checked them independently at 40-digit precision with mpmath (verify/check.py), compared with the text shown in the committed frames (committed/richexaa/frame_004/005/009.png and sheet.png), and confirmed that the curves overlap visually.
- Evidence (true max|err D5| -> displayed text from `round(err5; digits=6)`, richexaa.jl line 53):
  - f1 h=0.5: 1.321e-4 -> "0.000132"
  - f2 h=0.32: 4.076e-5 -> "4.1e-5"
  - f3 h=0.2: 8.561e-6 -> "9.0e-6"
  - f4 h=0.12: 1.340e-6 -> "1.0e-6"
  - f5 h=0.08: 2.890e-7 -> "0.0"
  - f6 h=0.05: 4.701e-8 -> "0.0"
  - f7 h=0.03: 6.351e-9 -> "0.0"
  - f8 h=0.02: 1.281e-9 -> "0.0"
  - f9 h=0.01: 8.168e-11 -> "0.0"
  - D3 values are all shown at a reasonable precision (for example 0.000300 -> "0.0003" and 3.333e-5 -> "3.3e-5").
  - The frames match these strings exactly. From h=0.12 (frame 4) onward the D3, D5 and f'(x) curves cannot be told apart at the plot's scale, and even at h=0.2 they are nearly indistinguishable. So in frames 5-9 the annotation, the only quantitative comparison on screen, reports D5's error as "≈ 0.0" in 5 of 9 frames, while the true error is 2.9e-7 down to 8.2e-11. It is nonzero, and its O(h^4) decay is the point of the page.
- Severity: Misleading is fair. The numbers are rounded correctly to 6 decimals, but a reader comes away thinking D5 is exact for h <= 0.08 and cannot see the 4th-order decay.
- Correction to the allegation: "misrounded" is not strictly right. Every value is correctly rounded to 6 decimal places. The problem is that Julia prints very small rounded values in scientific notation with a trailing ".0", so "1.0e-6" (frame 4, true 1.34e-6, 25% low) and "9.0e-6" (frame 3, true 8.56e-6) look like 2-significant-figure values and give the wrong second digit. That is false precision from the display format, not a rounding mistake. The line reference (~line 53) is correct, and "the later frames" means frames 5-9 (h = 0.08, 0.05, 0.03, 0.02, 0.01).
