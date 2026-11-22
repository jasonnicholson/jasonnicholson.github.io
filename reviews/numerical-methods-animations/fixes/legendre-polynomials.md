# Fix record: legendre-polynomials

Scratch folder with all evidence scripts and frame extractions:
`/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/work/legendre-polynomials/fix/`
- `instr_old.jl`: lines 1–44 of the committed `legendrepolybb.jl` (the coefficient code, unchanged) plus a loop that prints the coefficients and per-frame max errors; no plotting.
- `instr_new.jl`: lines 1–49 of the fixed script plus the same print loop and a check of the Gauss–Legendre rule.
- `indep.py` (mpmath, 30 digits: `quad` with `mp.legendre`, and the closed form (2n+1)(−1)^{n/2} j_n(π/2) via `besselj`) and `sym_odd.py` (sympy exact integrals). Run with `/usr/bin/python3 -I`.
- `framediff.py` (pixel diff of consecutive frames), `new/legendrepolybb/` (frames, sheet and framemd5 of the regenerated GIF), `archive/` (archive images converted to PNG).

## Findings

### F1 — Error — fixed
- Reproduced: `julia instr_old.jl` prints the committed script's coefficients: c_6 = −1.337276518e-3 and c_8 = 8.214295821e-6. The frame titles read 0.637, 0.637, 0.0505, 0.0505, 0.00131, 0.00131, 3.17e-5, 3.17e-5, 2.35e-5. `python3 -I indep.py` gives c_6 = −0.00133045638584257 and c_8 = 1.71321795415561e-5; the quad and closed-form values agree to all 15 printed digits. The true max errors on the script's 500-point grid are 0.63662, 0.63662, 0.0504655, 0.0504655, 0.00131346, 0.00131346, 1.70005e-5, 1.70005e-5 and 1.31692e-7. All of them occur at x = −1. The same values hold on a 4001-point grid for S_6 and S_8. `sym_odd.py` gives the integrals exactly: c_8 = (17/2)·(−242161920/π⁷ − 10080/π³ + 4/π + 3326400/π⁵ + 2075673600/π⁹) = 1.71321795415561e-5. So the finding holds. c_8 is about half its true value, and the titles of frames 7–8 (3.17e-5) and frame 9 (2.35e-5) are wrong.
- Change (legendrepolybb.jl):
  - Added `using LinearAlgebra`, which is in the standard library.
  - New `gauss_legendre(m)` computes the nodes and weights by the Golub–Welsch method: eigen of the Jacobi matrix with off-diagonal k/√(4k²−1).
  - `legendre_coeff` now uses a 20-point Gauss–Legendre rule. It replaces the 1000-point trapezoid rule, which the comment had called "Gauss-Legendre quadrature with many points".
  - The comment now reads "(20-point Gauss-Legendre quadrature)", which is the rule actually used.
  - The closed form via `sphericalbesselj` was not used, because it would add a SpecialFunctions dependency to the script.
- Check: `julia instr_new.jl`.
  - Rule check: the weights sum to 1.9999999999999998. max|P_20(x_i)| = 1.4e-13, so the nodes are the zeros of P_20. ∫x³⁸ has error 5.3e-16, as expected since the rule is exact to degree 39.
  - New coefficients: c_0 = 0.6366197723675801, c_2 = −0.6870852701460279, c_4 = 0.05177895367626449, c_6 = −0.001330456385852889, c_8 = 1.713217954923792e-5. Each agrees with mpmath to better than 1e-15 absolute. The odd coefficients are at most 6.8e-15 in size, against exact 0.
  - Per-frame errors: 0.63662, 0.63662, 0.0504655, 0.0504655, 0.00131346, 0.00131346, 1.70005e-5, 1.70005e-5, 1.31692e-7. These are the mpmath values to 6 digits.
  - Titles: 0.637, 0.637, 0.0505, 0.0505, 0.00131, 0.00131, 1.7e-5, 1.7e-5, 1.32e-7. I read them in the regenerated frames 7 and 9 at full size and in the contact sheet.

### F2 — Misleading — fixed
- Reproduced: `sym_odd.py` gives ∫ cos(πx/2) P_n dx = 0 exactly for n = 1, 3, 5 and 7. `instr_old.jl` shows the frame pairs (1,2), (3,4), (5,6) and (7,8) with the same error (0.636619, 0.0504686, 0.00130559, 3.16903e-5), while the titles counted "2 terms", "4 terms" and so on. Following the checker's correction, the curves and errors are identical, and the frames differ only in their title and legend.
- Change (decision D7: text changed to describe the animation, not the frame sequence):
  - index.qmd Case 2 Behavior: "Each added term refines the fit." → "…: the odd-order coefficients are zero, so $S_1, S_3, S_5, S_7$ equal $S_0, S_2, S_4, S_6$ and every second frame shows the same curve and max error as the frame before it. Each even-order term reduces the max error, from 0.637 for $S_0$ to $1.32\times 10^{-7}$ for $S_8$."
  - Alt text: "…building up frame by frame, showing convergence to the true function" → "Legendre series partial sums S_0 through S_8 for cos(pi x/2), one per frame; the odd-order terms are zero, so every second frame repeats the previous curve, and the max error falls from 0.637 to 1.32e-7".
  - legendrepolybb.jl title: "— $(n+1) term(s)" → "— S_$n(x)". The title no longer counts zero terms as added terms, and it matches the legend and the alt text.
  - legendrepolybb.jl header line 3: added a note that the odd-n coefficients are zero, so S_1, S_3, S_5, S_7 equal S_0, S_2, S_4, S_6.
- Check: `python3 -I framediff.py new/legendrepolybb`. In the regenerated GIF, the frame pairs 1→2, 3→4, 5→6 and 7→8 differ in only 209, 161, 196 and 210 pixels, all in rows 2–76 (title and legend). By contrast, 2→3 differs in 8831 pixels and 8→9 in 5933. The max errors of the even-order frames (0.637, 0.0505, 0.00131, 1.70e-5, 1.32e-7) strictly decrease (`instr_new.jl`).

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd Case 2 | odd-order coefficients are zero | `sym_odd.py` → integrals for n = 1, 3, 5, 7 are exactly 0 | yes |
| index.qmd Case 2 | S_1, S_3, S_5, S_7 equal S_0, S_2, S_4, S_6 | follows from c_odd = 0 (above); `instr_new.jl` errors of the pairs agree to 6 digits | yes |
| index.qmd Case 2 | every second frame shows the same curve and max error as the frame before it | `framediff.py` → the pairs differ only in rows 2–76 (title and legend); titles 0.637/0.637, 0.0505/0.0505, 0.00131/0.00131, 1.7e-5/1.7e-5 | yes |
| index.qmd Case 2 | each even-order term reduces the max error | `instr_new.jl` → 0.63662 > 0.0504655 > 0.00131346 > 1.70005e-5 > 1.31692e-7 | yes |
| index.qmd Case 2 | 0.637 for S_0 | `indep.py` → 0.63662 (= 2/π, at x = ±1) | yes |
| index.qmd Case 2 | 1.32×10⁻⁷ for S_8 | `indep.py` → 1.31692e-7 on the 500-point grid and on the 4001-point grid | yes |
| index.qmd alt text | S_0 through S_8, one per frame | script n_max = 8; new GIF has 9 frames (giftools) | yes |
| index.qmd alt text | odd-order terms are zero; every second frame repeats the previous curve | as above | yes |
| index.qmd alt text | max error falls from 0.637 to 1.32e-7 | as above | yes |
| legendrepolybb.jl header | odd-n coefficients are zero, so S_1… equal S_0… | as above | yes |
| legendrepolybb.jl comment | "20-point Gauss-Legendre quadrature", "Golub-Welsch eigenvalue method" | code uses `gauss_legendre(20)`; `instr_new.jl` → Σw = 2.0, max\|P_20(x_i)\| = 1.4e-13, ∫x³⁸ error 5.3e-16 | yes |
| legendrepolybb.jl title (each frame) | "S_n(x)" with max err 0.637, 0.637, 0.0505, 0.0505, 0.00131, 0.00131, 1.7e-5, 1.7e-5, 1.32e-7 | `instr_new.jl` → title strings as listed; mpmath true errors 0.63662 … 1.31692e-7 (`indep.py`); read in new frames 2, 7, 9 and the sheet | yes |

## Scripts and GIFs
- Script changed: `legendrepolybb.jl`, regenerated with `julia legendrepolybb.jl` from the page folder. The GIF still has 9 frames. `legendrepolyaa.jl` was not touched and not regenerated.
- Frames viewed at full size: 2, 7 and 9, plus the contact sheet of all 9. The titles fit inside the frame and read S_1 … 0.637, S_6 … 1.7e-5 and S_8 … 1.32e-7. The legend labels match each frame's S_n, and the S_2 to S_8 curves approach f as expected.
- `git status --short -- pages/numerical-methods/legendre-polynomials` after regeneration: `M index.qmd`, `M legendrepolybb.gif`, `M legendrepolybb.jl`. No other file changed.

## Legacy archive
- Consulted: `legendrepoly/LegendrePolyMod.html` and the links in `LegendrePolyMod/Links/`. Mathews' Legendre-series example is Example 8 (`LegendrePolyMod_lnk_16.html` / `_lnk_17.html`). The formula images `gr_324` and `gr_325` show that it uses f(x) = eˣ (8a) and f(x) = eˣ cos(πx/2) (8b). Code image `gr_326` shows that it uses degree n = 4, exact coefficients c_k = (2k+1)/2 ∫ f P_k (Mathematica `Integrate`), and a comparison with the equally spaced interpolating polynomial.
- Difference: the site's Case 2 uses cos(πx/2) and N = 0…8, not Mathews' functions. Neither finding concerns the choice of function, so I kept it. The fix's exact (Gauss–Legendre) coefficients agree with Mathews' use of exact integration.

## Notes
- F2 had two valid fixes: change the text, or animate even N only. I followed D7 and changed the text, since the animation itself is correct once F1 is fixed. I also replaced the term count in the GIF title with "S_n(x)". This is the smallest change that stops the title from announcing an added term on frames where nothing changes.
- The title prints "1.7e-5" for 1.70005e-5, because `round(…, sigdigits=3)` drops the trailing zero. I left this unchanged because the value is correct.
- Pre-existing convention gap, not a finding: the page has no `## Description` section before `## Animations`. I did not add one.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- The trapezoid rule is gone. `legendre_coeff` now uses 20-point Gauss–Legendre nodes and weights from Golub–Welsch (`legendrepolybb.jl:29-41`). I checked the nodes and weights against numpy `leggauss(20)`: they agree to 5.6e-16 and 1.4e-15. The off-diagonal k/sqrt(4k²−1) and the weights 2·v₁² are the correct Jacobi-matrix data for Legendre.
- Script coefficients come from the instrumented copy `check/instr.jl`. My reference is `check/indep.py`: mpmath `quad` with `legendre` at 30 digits.
  - c_0 = 0.63661977236758 (ref 0.636619772367581)
  - c_2 = −0.6870852701460279 (ref −0.687085270146032)
  - c_4 = 0.05177895367626449 (ref 0.0517789536762638)
  - c_6 = −0.0013304563858528892 (ref −0.00133045638584257)
  - c_8 = 1.7132179549237916e-5 (ref 1.71321795415561e-5)
  - Odd c_n are at most 7e-15 (exactly 0 in theory).
  - Every coefficient agrees to about 1e-14 absolute.
- Per-frame max errors from the script, with the reference error of S_N on the same 500-point grid:
  - S_0, S_1: 0.6366197723675799; ref 0.63662
  - S_2, S_3: 0.0504654977784; ref 0.0504655
  - S_4, S_5: 0.00131345589782; ref 0.00131346
  - S_6, S_7: 1.70004880e-5; ref 1.70005e-5
  - S_8: 1.31691518e-7; ref 1.31692e-7
- On a 200 001-point grid the maxima are the same, so the 500-point grid catches the true sup (it sits at x = ±1).
- Frame titles in the committed GIF, read at full size: 0.637, 0.637, 0.0505, 0.0505, 0.00131, 0.00131, 1.7e-5, 1.7e-5, 1.32e-7. All are correct at 3 significant figures. Julia drops the trailing zero of 1.70e-5, which is acceptable.
- The line-27 comment now says "20-point Gauss-Legendre quadrature", which matches the code.

### F2 — resolved
- The false sentence "Each added term refines the fit" is gone. index.qmd:26 now says:
  - the odd coefficients are zero;
  - S_1, S_3, S_5, S_7 equal S_0, S_2, S_4, S_6;
  - every second frame repeats the previous curve and max error;
  - each even-order term reduces the max error, from 0.637 to 1.32e-7.

  All of these are true. The coefficients are listed under F1, and the error sequence 0.637 > 0.0505 > 0.00131 > 1.70e-5 > 1.32e-7 decreases strictly.
- The misleading frame titles ("2 terms", "4 terms", …) are replaced by "S_N(x)", so a repeated frame no longer claims an extra term.
- In the committed frames, each pair (1,2), (3,4), (5,6), (7,8) differs in only 54–63 pixels. Those pixels sit in the box at rows 67–76, columns 582–588, which is the "S_n" digit in the legend. The titles differ only in the subscript digit. The curves are pixel-identical, which matches the text.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd:26 | "odd-order coefficients are zero" | mpmath: c_1, c_3, c_5, c_7, c_9 = 0 (f is even, P_odd is odd) | true |
| index.qmd:26 | "S_1, S_3, S_5, S_7 equal S_0, S_2, S_4, S_6" | follows from zero odd coefficients; frames pixel-identical apart from the label | true |
| index.qmd:26 | "every second frame shows the same curve and max error as the frame before it" | frame pixel diff; titles 0.637/0.637, 0.0505/0.0505, 0.00131/0.00131, 1.7e-5/1.7e-5 | true |
| index.qmd:26 | "Each even-order term reduces the max error" | 0.63662 → 0.0504655 → 0.00131346 → 1.70005e-5 → 1.31692e-7 | true |
| index.qmd:26 | "0.637 for S_0" | max\|f − c_0\| = c_0 = 2/π = 0.63662 (at x = ±1) | true |
| index.qmd:26 | "1.32×10⁻⁷ for S_8" | 30-digit reference 1.31692e-7, on both the script grid and a dense grid | true |
| index.qmd:30 alt | "S_0 through S_8 … one per frame" | 9 frames, titles S_0 to S_8 | true |
| index.qmd:30 alt | "odd-order terms are zero, so every second frame repeats the previous curve" | as above | true |
| index.qmd:30 alt | "max error falls from 0.637 to 1.32e-7" | as above | true |
| bb.jl:3 comment | odd-n coefficients zero; S_1, S_3, S_5, S_7 equal S_0, S_2, S_4, S_6 | as above | true |
| bb.jl:28 comment | "Gauss-Legendre nodes and weights … (Golub-Welsch eigenvalue method)" | code builds the symmetric tridiagonal Jacobi matrix and its eigen-decomposition; agrees with leggauss | true |
| bb.jl:35 comment | "20-point Gauss-Legendre quadrature" | npts = 20 default, used at line 49 | true |
| bb.jl:63 title | "S_$n(x)  (max err = …)" | N matches the partial sum plotted (sum over k = 0..n); err values as above | true |

### New problems
None. This rests on the following checks:
- I read all 9 new frames on the contact sheet and frames 1, 5, 8 and 9 at full size.
  - Titles and legends are legible.
  - The title and the legend use the same S_n label.
  - Axes, limits and curves are unchanged from the pre-fix GIF; I compared old frame 1 visually. The scattered old-vs-new pixel differences (about 3,300 per frame across the whole image) fit palette-quantization noise from the changed title text, and there is no layout change.
- Every changed number and sentence checks out (see the ledger).

The "S_0(x)" in the title is a literal underscore, not a subscript. It is consistent with the legend label, which was already in that style before the fix, so it is not a problem.

### Reproducibility and conventions
- **Reproducibility:** I ran `legendrepolybb.jl` from a scratch copy (`check/run/`). Its output sha256 e6f176b7…0af is byte-identical to the committed GIF and matches the LFS pointer oid in the diff. `legendrepolyaa.*` is unchanged.
- **Conventions:**
  - Each case still has a source link and a GIF embed.
  - The alt text is descriptive and there are no code blocks.
  - `using LinearAlgebra` is a stdlib, so no new dependency is needed.
  - One pre-existing deviation remains, which the fix neither introduced nor touched: the page has no `## Description` section before `## Animations`. This is visible in HEAD as well, and `.github/agents/animation-page.agent.md` lines 12 and 205 require one.
- **Files outside the page folder:** the only outside file for this page is the untracked fixer note `reviews/numerical-methods-animations/fixes/legendre-polynomials.md`, a workflow record rather than site content. All other outside modifications on the branch belong to other pages' fixes.

**Final status:** committed
