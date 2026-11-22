# Fix record: maclaurin-and-taylor-series

Scratch evidence: `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r5fix/maclaurin-and-taylor-series/fix/` (`check.py`, `m03frames/`).

## Findings

### F1 — Error — fixed (decision R5-F)
- Reproduced: `/usr/bin/python3 -I check.py` (sympy):
  - |x|: one-sided limits at 0 are 0 and 0, and |0| = 0. So abs is continuous. Its one-sided derivatives are +1 and −1 (a corner).
  - sign: one-sided limits at 0 are −1 and +1 (a jump).
  - g(x) = sqrt(|x|)·sign(x): one-sided limits at 0 are 0 and 0, and g(0) = 0. So g is continuous.
  - g'(x) → +∞ as x → 0⁺ and as x → 0⁻. The difference quotient g(h)/h → +∞ from both sides, so the derivative at 0 is infinite.
  - Taylor coefficients of g = sqrt(x) about 0.5: the exact ratio is |c_{n−1}/c_n| = 0.5·2n/(2n−3) → 1/2 (sympy limit). Numerically the ratio is 0.5882, 0.5405, 0.5195 and 0.5128 at n = 10, 20, 40 and 60, so the radius is 0.5.
  - The page's sentence calls abs "discontinuous" and blames "the discontinuities of sign and abs", so the finding holds.
- Change: `index.qmd` line 79 (Video Animations, Non-Smooth Case paragraph).
  - Before: "This function contains two discontinuous functions, abs and sign. … poor choice because of the infinite derivative at x=0 of the sqrt function and the discontinuities of sign and abs."
  - After: "This function is built from abs, which is continuous but has a corner at x=0, and sign, which jumps at x=0; the composite itself is continuous. … poor choice because the sqrt gives it an infinite derivative at x=0, so the Taylor series about 0.5 has radius 0.5."
  - The engineering sentence and the conclusion "The Taylor series cannot converge across x=0." are unchanged. Nothing else in Video Animations was touched.
- Check: the reasoning is that the infinite derivative at 0 means g is not analytic at 0, so R ≤ 0.5. Since sqrt is analytic on the disc |z − 0.5| < 0.5, R ≥ 0.5. The computed coefficient ratio limit, 1/2, confirms R = 0.5. Every x < 0 has |x − 0.5| > 0.5, so the series diverges there, which keeps the "cannot converge across x=0" conclusion true.

### F2 — Minor — fixed
- Reproduced:
  - The heading (line 102) is 1/(1−x)².
  - The script (line 26) is `x -> 1 / (1 - x)^2`. Its coefficients are `a[k+1] = k + 1`, and sympy's series of 1/(1−x)² is 1 + 2x + 3x² + 4x³ + …, which matches.
  - Frame 1 of the GIF is titled "Maclaurin M03: f(x) = 1/(1-x)^2, x0 = 0.0". Its curve is at 0.16 at x = −1.5, which is 1/(1−x)² (= 0.16) and not 1/(1−x²) (= −0.8).
  - The M05 alt text, "one over one plus x squared", uses the 1/(1+x²) convention. So the M03 alt text "one over one minus x squared …" reads as 1/(1−x²). The finding holds.
- Change: `index.qmd` line 104 alt text.
  - Before: "Maclaurin animation for one over one minus x squared in the denominator, centered at zero."
  - After: "Maclaurin animation for one over the square of one minus x, centered at zero."
- Check: the new wording names (1−x)² as the squared quantity, matching the heading, script and GIF title. `git diff` shows only this line and the F1 line changed.

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd L79 | "abs, which is continuous but has a corner at x=0" | check.py: lim\|x\| at 0± = 0 = \|0\|; one-sided derivatives 1, −1 | yes |
| index.qmd L79 | "sign, which jumps at x=0" | check.py: lim sign at 0− = −1, 0+ = 1 | yes |
| index.qmd L79 | "the composite itself is continuous" | check.py: g limits at 0± = 0, g(0) = 0 | yes |
| index.qmd L79 | "the sqrt gives it an infinite derivative at x=0" | check.py: g' → ∞ from both sides; g(h)/h → ∞ from both sides | yes |
| index.qmd L79 | "the Taylor series about 0.5 has radius 0.5" | check.py: ratio 0.5·2n/(2n−3) → 1/2; n=60 → 0.5128 | yes |
| index.qmd L79 | "cannot converge across x=0" (unchanged) | x<0 ⇒ \|x−0.5\| > 0.5 = R | yes |
| index.qmd L104 | "one over the square of one minus x, centered at zero" | script L26 `1/(1-x)^2`; sympy series 1+2x+3x²…; GIF frame 1 title and f(−1.5)=0.16 | yes |

## Scripts and GIFs
- No scripts were changed and no GIFs were regenerated. Both fixes are text only.
- Frame 1 of `series_m03.gif` was extracted with giftools (13 frames) and viewed, to confirm the function behind F2.
- `git status --short -- pages/numerical-methods/maclaurin-and-taylor-series` shows ` M .../index.qmd` only.

## Legacy archive
- Consulted `/home/jason/Desktop/math-fullerton/baseline/mathews/n2003/taylorpoly/`.
- The main `TaylorPolyMod.html` is not present. The folder holds `TaylorPolyMod/Links/*.html` (37 HTML files in all), `TaylorPolyBib` and `TaylorPolyProof.pdf`.
- A grep for abs/sign/(1−x)² found nothing. Neither finding is a fidelity finding, and the archive has no bearing on them.

## Notes
- F1 is in the owner-written Video Animations section and was fixed only under R5-F. Only the false clauses were rewritten.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: line 79 no longer says abs is discontinuous. Both false clauses are gone: "contains two discontinuous functions, abs and sign" and "the discontinuities of sign and abs". The new text reads: "This function is built from abs, which is continuous but has a corner at x=0, and sign, which jumps at x=0; the composite itself is continuous. ... This function is a poor choice because the sqrt gives it an infinite derivative at x=0, so the Taylor series about 0.5 has radius 0.5. The Taylor series cannot converge across x=0."
- I checked each claim with mpmath at 50 digits (`check/chk.py`):
  - |±h| = h → 0 for h = 1e-4, 1e-8 and 1e-16. abs is continuous.
  - sign(±h) = ±1. sign jumps.
  - f(±h) = ±√h → 0, and f(0) = 0. The composite is continuous.
  - The forward difference of f near 0+ grows like h^(-1/2): 41, 4142, then 4.1e7. The derivative is infinite at 0.
  - Radius: for the Taylor coefficients of √x about 0.5, the ratio |c_{n-1}/c_n| is 0.5405, 0.5195 and 0.5096 at n = 20, 40 and 80. It tends to 0.5, so R = 0.5. Partial sums converge at x = 0.05 and x = 0.9 (inside the disk). They diverge at x = −0.1 and x = 1.1 (outside). So "cannot converge across x=0" holds.
  - The causal "so" is valid. If R were greater than 0.5, the sum would be analytic at 0 and equal to f on (0, 1), so its derivative would be finite at 0. That contradicts the infinite derivative.
- The MATLAB source (`taylor_series_animation_code.m` lines 83–85) uses `sqrt(abs(x)).*sign(x)` about 0.5, which matches the heading.
- Scope: only line 79 of the Video Animations section changed. The heading, the video embeds and the other paragraphs are untouched, and the paragraph keeps its conclusion.

### F2 — resolved
- Evidence: the line 104 alt text is now "Maclaurin animation for one over the square of one minus x, centered at zero." That unambiguously means 1/(1−x)².
- It matches the heading (line 102, `\dfrac{1}{(1-x)^2}`) and the script (line 26, `x -> 1 / (1 - x)^2`).
- It matches the GIF. Frame 7 at full size has the title "Maclaurin M03: f(x) = 1/(1-x)^2, x0 = 0.0". The magenta curve is positive on both sides of the pole at x = 1, and its value at x = −1.5 is about 0.16 = 1/2.5².
- It no longer clashes with M05's "one over one plus x squared" (1/(1+x²)).

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd:79 | "abs, which is continuous but has a corner at x=0" | \|±h\| → 0. Left and right derivatives are −1 and +1. | True |
| index.qmd:79 | "sign, which jumps at x=0" | sign(±h) = ±1 | True |
| index.qmd:79 | "the composite itself is continuous" | f(±h) = ±√h → 0 = f(0) | True |
| index.qmd:79 | "the sqrt gives it an infinite derivative at x=0" | Difference quotient ~ h^(-1/2): 41, 4142, 4.1e7 | True |
| index.qmd:79 | "Taylor series about 0.5 has radius 0.5" | Coefficient ratio → 0.5 (0.5096 at n = 80). Partial sums converge inside the disk and diverge outside it. | True |
| index.qmd:79 | "cannot converge across x=0" (kept) | Partial sums at x = −0.1 are −0.83, −9.3, −4053 | True |
| index.qmd:104 | "one over the square of one minus x, centered at zero" | Heading, script and GIF title are all 1/(1−x)², x0 = 0 | True |

### New problems
None. This rests on three checks:
- `git diff --stat HEAD` on the page folder shows only `index.qmd`, with 2 lines changed. No GIFs or scripts changed, and there are no untracked files.
- Every claim in the changed text was verified numerically above.
- No other sentence on the page was touched.

### Reproducibility and conventions
- Reproducibility: no script or GIF in the page folder changed, so there is nothing to regenerate.
- Conventions still hold:
  - Description (line 10) comes before Animations (line 83).
  - The source link is present (line 89, the single script for all 31 cases).
  - Each case has an embed with descriptive alt text.
  - There are no code fences in index.qmd (grep for ``` finds nothing).
- Files outside the page folder: the working tree has modified files on other pages (Broyden, Laurent, Muller, Nonlinear Systems, RKF, Secant). Those belong to the other round-5 fixers. The diff for this page touches only this page's `index.qmd`.

**Final status:** committed
