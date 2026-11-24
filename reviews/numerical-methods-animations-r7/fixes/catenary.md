# Fix record: catenary

Scratch folder (all check scripts): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r7fix/catenary/fix/`

## Findings

### F1 — Misleading (fidelity) — fixed

- **Reproduced:** `/usr/bin/python3 check_math.py`. The minimum over $c>0$ of $c\cosh(10/c)$ is 15.08880 (at $c\approx8.3356$), so the old page form cannot pass through $(\pm10,6)$, and $y(0)=c>0$ means it cannot pass through the origin. Mathews' form $c\cosh(x/c)-c$ has the root $c=9.188941402$ (mpmath, residual about $10^{-40}$). In the old form that $c$ gives $y(0)=9.18894$, $y(10)=15.18894$. Archive images `_gr_2`, `_gr_24`, `_gr_27`, `_gr_28`, `_gr_29`, `_gr_95`, `_gr_97` were viewed and show his form, series and equation.
- **Change (decision R7-B; the review's text-only alternative was not used):**
  - `catenaryaa.jl`: catenary `c*cosh(x/c)` → `c*cosh(x/c) - c`; parabola `x²/(2c) + c` → `x²/(2c)`; marker `(0, c)` → `(0, 0)`; title, legend and header comments follow; `ylims` `(0, 12)` → `(-0.5, 11.5)`.
  - `catenaryaa.gif`: regenerated (25 frames).
  - `index.qmd` line 12: both formulas, "Mathews' form with its lowest point at the origin", and "first two terms" → "first nonzero term".
  - `index.qmd` line 21: lowest point $(0,0)$; $c=1$ curves $y=\cosh x-1$ and $y=x^2/2$.
  - `index.qmd` line 25: alt-text formulas.
  - `index.qmd` line 17: unchanged, because with the page now on Mathews' form its description of Examples 1–2 is true (see ledger).
- **Window choice:** the new limits keep the 12-unit span, so the vertical pixel scale is unchanged. At $c=0.5$ the frame is the old frame moved down by $c$, so the quoted exit points 1.94 and 3.39 still hold. The 0.5 margin below zero keeps the lowest-point marker fully inside the frame.
- **Check:** `check_math.py`, `check_page.py`, `check_pixels.py` (results in the ledger). Over all 25 frames the drawn curves match the formulas to a median error of at most 0.55 px (catenary) and 0.34 px (parabola).

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| qmd 12, script title and legend | $y=c\cosh(x/c)-c$ | Archive `_gr_2`, `_gr_24`, `_gr_95`; `check_math.py` → ODE residual 0 | Yes |
| qmd 12 | "Mathews' form with its lowest point at the origin" | `_gr_2`, `_gr_24`; `check_math.py` → $f(0)=0$; `check_page.py` → minimum of $y$ over all frames is 0.0 | Yes |
| qmd 12, script legend | parabola $y=x^2/(2c)$ | `_gr_29`; sympy series begins $x^2/(2c)$ | Yes |
| qmd 12, script comments | "first nonzero term of its Maclaurin series" | sympy: $x^2/(2c)+x^4/(24c^3)+x^6/(720c^5)+\cdots$, no constant term; `_gr_27`, `_gr_28` | Yes |
| qmd 17 (unchanged, re-checked) | catenary through the origin and two points at equal height on either side of the $y$-axis | `_gr_91` (`pts = {{-a,b},{0,0},{a,b}}`, $a=10$, $b=6$), `_gr_92`; `check_page.py` → $c=9.188941402$, $y(0)\approx-4.5\times10^{-31}$, $y(\pm10)=6.0$ | Yes |
| qmd 21 (number unchanged, re-checked) | gap passes 0.1 at $\lvert x\rvert\approx0.73$ | `check_math.py` → 0.72712337 | Yes |
| qmd 21 (number unchanged, re-checked) | catenary leaves the top at $\lvert x\rvert\approx1.94$ | `check_page.py` → 1.9353834 for top 11.5; `check_pixels.py` → frame 1 crossings −1.933 and 1.926 on the row at $y=11.415$ (predicted ±1.932) | Yes |
| qmd 21 (number unchanged, re-checked) | parabola leaves the top at $\lvert x\rvert\approx3.39$ | `check_page.py` → 3.391165; `check_pixels.py` → frame 1 crossing −3.379 on the same row (predicted 3.379); the right side fell in a dash gap on that row | Yes |
| qmd 21 (unchanged, re-checked) | catenary never below the parabola; difference series | sympy series of the difference; minimum over 25 frames on a 4001-point grid, excluding $\lvert x\rvert\le10^{-3}$, is $+1.0\times10^{-14}$ | Yes |
| qmd 21 | lowest point always at $(0,0)$ | $f(0)=0$; `check_pixels.py` → marker present at $(0,0)$ in frames 1, 13, 25 (80 dark pixels each) | Yes |
| qmd 21 | $c=1$ curves $y=\cosh x-1$ and $y=x^2/2$ scaled by $c$ about the origin | `check_math.py` → both symbolic differences are 0 | Yes |
| qmd 21 (unchanged, re-checked) | large $c$ nearly indistinguishable near $x=0$ | gap at $c=4$: 0.00065 at $\lvert x\rvert=1$, 0.0105 at 2, 0.172 at 4; the vertical pixel scale is unchanged | Yes |
| qmd 12 (unchanged, re-checked) | larger $c$ is flatter | `check_math.py` → sag over $\lvert x\rvert\le4$ strictly decreasing across frames, 744.74 to 2.172 | Yes |
| qmd 25 alt text | $y=c\cosh(x/c)-c$, $y=x^2/(2c)$, $c$ from 0.5 to 4 | As above; 25 frames, first $c=0.5$, last $c=4$ | Yes |
| script `ylims` | $(-0.5, 11.5)$ | `check_page.py`; frames 1, 13, 25 viewed | Yes |

## Scripts and GIFs

- **Script changed:** `catenaryaa.jl`. **GIF regenerated:** `catenaryaa.gif` (25 frames).
- **Frames viewed at full size:** 1 ($c=0.5$), 13 ($c=2.25$), 25 ($c=4.0$), plus the contact sheet of every third frame. Checked: title and legend show the shifted formulas and fit the frame; the marker sits at $(0,0)$ and is not clipped; the legend covers neither curve (`check_archive_legend.py`: the legend spans $x\in[-1.517,1.53]$ above $y=9.595$, and the highest curve value over that span in any frame is 4.84).
- **`git status -- pages/numerical-methods/catenary` after regeneration:** `M catenaryaa.gif`, `M catenaryaa.jl`, `M index.qmd`. No stray files.

## Legacy archive

Consulted (`n2003/CatenaryMod.html`, `catenary/CatenaryMod/Links/`, `Images/`).

- Mathews writes $y=f(x)=c\cosh(x/c)-c$, $c>0$, with lowest point $(0,0)$ (`_gr_2`, `_gr_24`).
- Exploration 2 gives $f[x]=\sum_{n\ge1}x^{2n}/((2n)!\,c^{2n-1})$ and $f[x]\approx x^2/(2!\,c)$ (`_gr_27`, `_gr_28`, `_gr_29`).
- Example 1 uses the points $(-10,6)$, $(0,0)$, $(10,6)$ (`_gr_91`, `_gr_92`) and solves $-c+c\cosh[10/c]=6$ (`_gr_97`). The computed root is $c=9.188941402$.
- The module's image numbers run to 175, with 136 files present. Images 30–46 and 50–71 are absent, including the bodies of Explorations 2 and 3. None of the images this fix relies on is absent.
- The page now follows Mathews' function and parabola. The sweep over $c$ remains the page's own construction: none of the 136 module images has more than one frame (`check_archive_legend.py`), and a filename search of `a2001/Animations/` for "caten" finds nothing.

## Notes

- The page has no `## Description` section, which the page conventions ask for. No finding names it, so it was not added.
- The alt text's word "apex" (for the lowest point) was left as it was; no finding names it.
- `check_pixels.py` reads `frames.raw`, which `raw.jl` extracts from the GIF. The raw file was deleted after the run.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- The fix follows the Round 7 decision (switch script, GIF and text to Mathews' form y = c cosh(x/c) - c with parabola x^2/(2c)), not the text-only alternative.
- Script: `y_cat = c .* cosh.(x ./ c) .- c`, `y_par = x .^ 2 ./ (2c)`, marker at (0,0). sympy: c cosh(x/c) - c = x^2/(2c) + x^4/(24c^3) + x^6/(720c^5) + ..., so x^2/(2c) is the first nonzero Maclaurin term and has no constant term, as in Mathews' Exploration 2.
- Line 17 now holds with line 12: every member of y = c cosh(x/c) - c passes through the origin. Mathews' Example 1, c cosh(10/c) - c = 6, solved with mpmath gives c = 9.18894140222127 (residual 1e-40), which matches his 9.18894. Legacy CatenaryMod.html: "Example 1. Find the catenary that goes through the origin and also passes through the two points ... a = 10 and b = 6". So the "no solution" contradiction is gone.
- GIF: I looked at frames 1, 13 and 25 at full size (c = 0.5, 2.25, 4.0). The title reads "y = c·cosh(x/c) - c" and the legend reads "y = x²/(2c) (parabola)" and "lowest point (0, 0)". The diamond is at the origin and both curves touch it. Spot values: at c = 4, x = 4 the catenary is 4cosh(1) - 4 = 2.17 and the parabola is 2.0, both matching the frame. At c = 2.25, x = 4 they are 4.58 and 3.56, both matching.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd l.12 | catenary $y=c\cosh(x/c)-c$, "Mathews' form with its lowest point at the origin" | y(0)=0, y' = sinh(x/c) is 0 only at 0, y'' > 0; matches the legacy formula (finding F1 sources, lnk_2 text) | true |
| l.12 | parabolic approximation $y=x^2/(2c)$ | sympy series | true |
| l.12 | "the parabola is the first nonzero term of its Maclaurin series" | series has no constant term; the x^2 term is first | true |
| l.21 | gap passes 0.1 at abs(x)≈0.73 (c=0.5) | the gap is unchanged by the shift; root 0.72712 | true |
| l.21 | catenary leaves top at abs(x)≈1.94; parabola at ≈3.39 | new ylim top 11.5: roots 1.93538 and 3.39116 (same as before: the window top moved from 12 to 11.5, exactly the c=0.5 shift) | true |
| l.21 | difference $x^4/(24c^3)+x^6/(720c^5)+\cdots$ positive | sympy series; numeric check on all 25 frames' grids gives catenary ≥ parabola | true |
| l.21 | "The lowest point is always at (0, 0)" | as l.12 | true |
| l.21 | c=1 curves $y=\cosh x-1$, $y=x^2/2$ scaled by c about the origin | c(cosh(u)-1) at x=cu equals c cosh(x/c)-c, and c u^2/2 = x^2/(2c); numeric max error 4e-16 | true |
| l.25 alt text | "Catenary y=c cosh(x/c)-c ... y=x^2/(2c) ... 0.5 to 4; nearly coincide near the apex for large c" | matches the script and the frames | true |
| catenaryaa.jl l.2-3 comments | Mathews' form; "first nonzero Maclaurin term" | as above | true |
| catenaryaa.jl title/labels | "y = c·cosh(x/c) - c", "y = x²/(2c)", "lowest point (0, 0)", ylims (-0.5, 11.5) | frames: the labels are legible, the minimum is visible above the bottom edge, and the legend does not hide the apex | true |

### New problems
None introduced. This rests on:
- every number in the changed text was recomputed (see ledger);
- I looked at the first, middle and last frames at full size;
- I re-ran the script, and its output is byte-identical to the committed GIF.

Pre-existing, not introduced by this fix (Minor, conventions): the page has no `## Description` section before `## Animations`. HEAD has the same headings (Animations, Case 1, Derivation Notes). 12 of 54 numerical-methods pages also lack one.

### Reproducibility and conventions
- Ran a scratch copy of catenaryaa.jl. Its output sha256 is d2570cff5e24bbfdc60cf2ad7deb0f44eaffad5739889d933aef476ac6d0a6fa, the same as the committed working-tree GIF and the LFS oid in the diff. The decoded framemd5 of the two files is identical (25 frames).
- The page keeps one source link and one embed for the single case, the alt text describes the animation, and there are no code blocks. The Description section is missing, but it was missing before the fix too.
- Outside the page folder, the only working-tree change is reviews/numerical-methods-animations/fix-plan/README.md (the decisions file), plus other numerical-methods pages from this round. No other site file changed for this page.

**Final status:** committed
