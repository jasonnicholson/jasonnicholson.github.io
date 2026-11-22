# Fix record: maclaurin-and-taylor-series

Scratch folder (all evidence scripts and frame extractions):
`/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r2fix/maclaurin-and-taylor-series/fix/` (below: `$S`).

## Findings

### F1 — Fidelity, Minor — fixed
- Reproduced: The script row `m10` was `x -> exp(-x^2 / 2)` on `(-2.0, 3.0)`, and the page heading said $e^{-x^2/2}$. The archive index formula images (`a2001/Animations/Interpolation/Series/Images/series_gr_28–30.gif`, upscaled into `$S/legacy/all_stack.png` by `julia $S/upscale.jl $S/legacy`) read "y = f[x] = e^x", "x0 = 0" and "−2 ≤ x ≤ 3". The legacy GIF `Maclaurin10/Maclaurinjj.gif` (12 frames, `$S/legacy/Maclaurinjj/sheet.png`) shows e^x up to about 20 at x = 3, with partial sums S_1…S_10.
- Change (`series_animations_all.jl`):
  - line 33: `raw"e^{-x^2/2}", "exp(-x^2/2)", x -> exp(-x^2 / 2), …, (-1.0, 1.2), 12` → `raw"e^{x}", "exp(x)", x -> exp(x), 0.0, (-2.0, 3.0), (-2.0, 21.0), 12`;
  - lines 280–283: even-power coefficients → `for k in 0:n; a[k + 1] = 1.0 / factorial(k); end`.
  - `index.qmd`: the M10 heading is now `$f(x)=e^{x}$`, and the alt text is "Maclaurin animation for exponential of x centered at zero."
  - The ylims lower bound is −2 rather than the suggested −1. At −1 the "order = k" label overlapped the curve near x = −2 (seen in the first regeneration). At −2 the label sits below the curve: e^{−2} = 0.135, and the label is at y ≈ −0.62.
- Check:
  - `julia $S/dump_coeffs.jl $S/new_lib.jl $S/coeffs_new.tsv`, then `/usr/bin/python3 $S/indep_coeffs.py $S/coeffs_new.tsv`. Against mpmath.taylor(exp, 0, 12) the max relative error is 8.62e-17.
  - Diffing the old and new coefficient dumps shows that only m10 and t08–t12 changed.
  - In the frames (`$S/new/m10/`), the title reads "Maclaurin M10: f(x) = exp(x), x0 = 0.0", there are 13 frames (orders 0–12), and the red dot is at (0, 1). At order 4 the blue curve at x = 3 is about 16.4, which matches mpmath's 16.375. f stays inside the window, since e^3 = 20.0855 < 21.

### F2 — Fidelity, Minor — fixed
- Reproduced: The script had t08/t09/t10 at `c = 2.0, 3.0, 4.0`. In the archive:
  - The index formula images `series_gr_77–84` (`$S/legacy/all_stack.png`) read Γ with "x0 = 1", "x0 = 2" and "x0 = 3" on −0.2 ≤ x ≤ 5.2. The interval image for case 10, `gr_85`, is missing from the archive.
  - The legacy GIF last frames (`$S/legacy/last4.png`) show the red centre at x = 1 (Taylorhh), 2 (Taylorii) and 3 (Taylorjj).
- Change:
  - `series_animations_all.jl` lines 51–53: c = 2.0, 3.0, 4.0 → 1.0, 2.0, 3.0. The ylims are unchanged: (−2, 30), (−2, 30), (−2, 40).
  - `index.qmd`: the headings now read $x_0=1$, $2$, $3$, and the alt texts "centered at one / two / three".
- Check:
  - Against mpmath.taylor(gamma, c, 8), the max relative coefficient error is 5.24e-17 (c=1), 6.35e-17 (c=2) and 9.26e-17 (c=3), via `$S/indep_coeffs.py`.
  - In the frames (`$S/new/t08/sheet.png`, `t08/frame_009.png`, `$S/new/t_last4.png`), the titles read "x0 = 1.0", "2.0" and "3.0", with 9 frames each. The red dot is at Γ(1)=1, Γ(2)=1 and Γ(3)=2 (mpmath).
  - The T08 order-8 polynomial follows Γ on about (0, 2) and leaves the window just past x ≈ 2.5. mpmath gives T₈(2.5) = 16.69 vs Γ(2.5) = 1.329. This is expected for R = 1, and the review predicted it.

### F3 — Fidelity, Minor — fixed
- Reproduced: The script had t11 = J₀ about 10 and t12 = J₁ about 5, with `taylor_family` `(:besselj, 0)` and `(:besselj, 1)`. The archive index images `series_gr_86–94` read "Y0[x] = BesselY[0, x]" for cases 11, 12 and 13, with x0 = 10, 5 and 2 on 0 ≤ x ≤ 22. The legacy GIFs `Taylorkk.gif` (`$S/legacy/Taylorkk/sheet.png`) and `Taylorll.gif` (`$S/legacy/last4.png`) are titled Y₀(x), with the centre at 10 and 5.
- Change:
  - `series_animations_all.jl` lines 54–55: `raw"Y_0(x)", "bessely(0,x)", x -> bessely(0, x)` with the centres 10.0 and 5.0 and the ylims (−1.2, 1.2) unchanged, which are the same as T13.
  - line 216: `"t11" => (:bessely, 0), "t12" => (:bessely, 0)`.
  - `index.qmd`: the headings are now `$f(x)=Y_0(x)$`, and the alt texts "Bessel Y zero centered at ten / five".
- Check:
  - Against mpmath.taylor(bessely(0,·), c, 8), the max relative coefficient error is 9.83e-17 (c=10) and 9.23e-17 (c=5).
  - In the frames (`$S/new/t_last4.png`), the titles read "Taylor T11: f(x) = bessely(0,x), x0 = 10.0" and "T12 … x0 = 5.0". The red dots are at Y₀(10) = 0.05567 and Y₀(5) = −0.30852 (mpmath).
  - The samples at x = 0 are NaN, because Y₀(0) = −Inf goes through `safe_eval`, the same as T13.

### F4 — Implementation (picture), Minor — fixed
- Reproduced: `julia $S/f4_repro.jl $S/orig_lib.jl` (the original script without its render loop) finds the adjacent 900-grid samples that jump from beyond one y-limit to beyond the other:
  - m01: 1798.0 / −359.6 at x = 0.99944 / 1.00278;
  - m02: the same values mirrored about x = −1;
  - m09: 572.32 / −190.77 at x = 1.56905 / 1.57604, and mirrored at −π/2;
  - t08, t09, t10: −562.45 / 236.01 at x = −0.00178 / 0.00423.

  No other case triggers it. mpmath gives the same values (`$S/indep_values.py`). The committed `series_m09.gif` frame 12 (`$S/committed/m09/frame_012.png`) shows full-height magenta verticals at ±π/2.
- Change (`series_animations_all.jl`):
  - A new function `break_at_poles(x, y, ylims)` (lines 345–360). It inserts a NaN point between adjacent finite samples when one is above `ylims[2]` and the other below `ylims[1]`.
  - `render_case` builds `xtrue, ytrue_plot` from it (line 365) and plots those for f(x) (line 386).
  - The polynomial arrays and every other element are unchanged.
- Check:
  - `julia $S/f4_check_new.jl $S/new_lib.jl` inserts breaks only in m01 (x = 1.0011), m02 (−1.0011), m09 (±1.5725) and t08–t10 (0.0012). With the breaks, no drawn f(x) segment in any of the 31 cases spans more than 90% of the window height.
  - The new frames `$S/new/m01/frame_013.png`, `m02/frame_013.png`, `m09/frame_012.png` and `t08/frame_009.png` show no vertical magenta line at the poles; each branch runs off the window edge.
  - The cases without a pole regenerate byte-identically (see below).

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd M10 heading | `$f(x)=e^{x}$`, $x_0=0$, $x\in[-2,3]$ | Script row m10: `x -> exp(x)`, c 0.0, xlims (−2, 3). Archive gr_28–30: e^x, x0 = 0, −2 ≤ x ≤ 3 | yes |
| index.qmd M10 alt | "Maclaurin animation for exponential of x centered at zero." | Same row. Frame title "f(x) = exp(x), x0 = 0.0" | yes |
| GIF title M10 | "Maclaurin M10: f(x) = exp(x), x0 = 0.0" | Read in `$S/new/m10/frame_001.png` and `frame_013.png` | yes |
| script m10 coefficients | a_k = 1/k!, k = 0..12 | `indep_coeffs.py` → max rel err 8.62e-17 | yes |
| script m10 ylims | (−2.0, 21.0) | e^3 = 20.0855 < 21 and e^{−2} = 0.1353 > −2 (`indep_values.py`). The full f is visible in the frames | yes |
| index.qmd T08 heading/alt | $x_0=1$, "centered at one" | Script c = 1.0, title "x0 = 1.0", red dot at (1, Γ(1)=1) | yes |
| index.qmd T09 heading/alt | $x_0=2$, "centered at two" | Script c = 2.0, title "x0 = 2.0", red dot at (2, 1) | yes |
| index.qmd T10 heading/alt | $x_0=3$, "centered at three" | Script c = 3.0, title "x0 = 3.0", red dot at (3, 2) | yes |
| script t08–t10 coefficients | taylor_coeffs_exact(:gamma, c, 8) | `indep_coeffs.py` → 5.24e-17, 6.35e-17, 9.26e-17 | yes |
| index.qmd T11 heading/alt | `$f(x)=Y_0(x)$`, $x_0=10$, "Bessel Y zero centered at ten" | Script row t11 `bessely(0, x)`, c 10.0. Title "bessely(0,x), x0 = 10.0". Archive gr_86–88 | yes |
| index.qmd T12 heading/alt | `$f(x)=Y_0(x)$`, $x_0=5$, "Bessel Y zero centered at five" | Script row t12 `bessely(0, x)`, c 5.0. Title "x0 = 5.0". Archive gr_89–91 | yes |
| script t11/t12 coefficients | taylor_coeffs_exact(:bessely, c, 8; nu=0) | `indep_coeffs.py` → 9.83e-17, 9.23e-17 | yes |
| GIF titles T08–T12 | "gamma(x), x0 = 1.0/2.0/3.0"; "bessely(0,x), x0 = 10.0/5.0" | Read in `$S/new/t08/frame_009.png` and `$S/new/t_last4.png` | yes |
| script comment above `break_at_poles` | "…jump from beyond one y-limit to beyond the other (a pole lies between them)…" | `f4_check_new.jl` → fires only at the poles 1, −1, ±π/2 and 0 | yes |

No Description, Animations-intro or Video text was changed. The Description's list of entire functions ("$\exp(x)$, $\sin(x)$, $e^{-x^2/2}$, $J_0(x)$ and the normal CDF") stays true. $e^{-x^2/2}$ is still illustrated, up to a constant, by M17, and $J_0$ by M15.

## Scripts and GIFs
- Script changed: `series_animations_all.jl`. It was run with `julia series_animations_all.jl` from its own folder (31 GIFs).
- GIFs regenerated with changes:
  - series_m01, m02 and m09: pole breaks only;
  - series_m10: new function;
  - series_t08, t09 and t10: new centres and the pole break;
  - series_t11 and t12: new function.
- The other 22 GIFs are byte-identical to the committed ones (md5 lists `$S/committed_md5.txt` vs `$S/new_md5_2.txt`; git shows them unmodified).
- Frames viewed (`$S/new/…`):
  - M10: the sheet, then frames 1, 5 and 13 at full size. Checked the title, red dot, label clearance and the order-4 value at x = 3.
  - M01 frame 13, M02 frame 13 and M09 frame 12: no pole verticals.
  - T08: the sheet and frame 9, showing the centre at 1 and the polynomial departing past 2.
  - T09, T10, T11 and T12: frame 9 of each (`t_last4.png`). Checked the titles, centres, red dots and that the ylims keep f visible. Γ(5.2) = 32.58 is clipped at 30 in T08 and T09, the same as before the change.
- `git status --short -- pages/numerical-methods/maclaurin-and-taylor-series` after regeneration: M index.qmd, series_animations_all.jl, series_m01.gif, series_m02.gif, series_m09.gif, series_m10.gif, series_t08.gif, series_t09.gif, series_t10.gif, series_t11.gif, series_t12.gif.

## Legacy archive
- Consulted. The n2003 `taylorpoly/` folder is present. The animation index used was `a2001/Animations/Interpolation/Series/Series.html` with its formula images, plus the legacy GIFs Maclaurinjj, Taylorhh, Taylorii, Taylorjj, Taylorkk and Taylorll.
- It shows:
  - M10 = e^x about 0 on [−2, 3];
  - T08–T10 = Γ about 1, 2 and 3 on [−0.2, 5.2];
  - T11–T13 = Y₀ about 10, 5 and 2 on [0, 22].
- The page now follows these.
- Remaining differences, none of them findings and all left unchanged:
  - The legacy Taylor GIFs run to S₃₀/S₃₁, while the page stops at order 8.
  - The legacy M10 runs to S₁₀, while the page goes to order 12.
  - The legacy GIFs draw a ±0.01 tolerance bar and the convergence-interval lines, which the page does not draw.
  - The legacy interval image for Taylor case 10 (`series_gr_85.gif`) is missing from the archive. The interval [−0.2, 5.2] for T10 is taken from the GIF frame axes, which match T08 and T09.

## Notes
- F5 (the Video section calls abs "discontinuous") is outside the review scope, and the brief does not list it. It was not touched.
- The "order = k" label overlaps curves in some other cases. The reviewer noted this as cosmetic and not a finding, and it was not changed. Only M10's new ylims were chosen to avoid it.
- The page has no Behavior paragraphs or radius statements for T08–T12, so no radius numbers were added. The headings, alt text and GIF titles are the only case text.

## Resolution check (independent checker, not shown this record)

Scratch: `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r2fix/maclaurin-and-taylor-series/check/`
(`run/` = full regeneration from a scratch copy of the script; `coef/` = coefficient dump (`dump.jl`, `coeffs.txt`) and mpmath check (`check.py`); `old/` = HEAD GIFs via `git show | git lfs smudge`; `frames/new_*`, `frames/old_*` = extracted frames; `legacy/` = frames of the Mathews GIFs.)

### Original findings

### F1 — resolved
- Script: M10 is now `x -> exp(x)`, c = 0, x in (-2, 3), ylims (-2, 21), order 12, coefficients `a[k+1] = 1/factorial(k)`.
- Coefficients against `mpmath.taylor(exp, 0, 12)` at 60 digits: max relative error 8.6e-17 (correct rounding).
- Frames 1, 7 and 13 at full size: title "Maclaurin M10: f(x) = exp(x), x0 = 0.0". The red dot is at (0, 1). Order 0 is the line y = 1. By order 12 the curve coincides with e^x on [-2, 3]: the Lagrange remainder bound at x = 3 is 3^13 e^3 / 13! ≈ 5e-3, and e^3 ≈ 20.09 lies inside the ylim of 21.
- The legacy `Maclaurin10/Maclaurinjj.gif` last frame reads "y = f[x] = e^x" on [-2, 3], so the case now matches it.
- Heading `$f(x)=e^{x}$, $x_0=0$, $x\in[-2,3]$` and the alt text "exponential of x centered at zero" are correct.
- The Description's list of entire functions ($\exp(x)$, $\sin$, $e^{-x^2/2}$, $J_0$, normal CDF) is still true. M17 still shows $e^{-x^2/2}$ up to a constant factor.

### F2 — resolved
- Script: t08, t09 and t10 now have c = 1.0, 2.0 and 3.0, with family :gamma.
- Coefficients against `mpmath.taylor(gamma, c, 8)`: max relative error 5.2e-17, 6.4e-17 and 9.3e-17. For example, the c = 1 coefficients are 1, -0.5772157 (= -γ), 0.989056, …
- Last frames:
  - The red dots are at (1, 1), (2, 1) and (3, 2), matching Γ(1) = Γ(2) = 1 and Γ(3) = 2.
  - T08 order 8 agrees with Γ on about (0.2, 1.8) and diverges beyond |x - 1| = 1, consistent with R = 1 (pole at 0).
  - T09 order 8 agrees on about (0.5, 4), consistent with R = 2.
  - T10 order 8 agrees on about (0.4, 5.2), consistent with R = 3.
  - The ylims still frame each case. T10's ylim of 40 holds Γ(5.2) = 32.6. T09 clips Γ just before 5.2, which is the same as the old ylim at the same interval.
- The legacy last frames of `Taylorhh`, `Taylorii` and `Taylorjj` show the centre dot at 1, 2 and 3. The page now matches them.
- The headings ($x_0=1,2,3$) and the alt texts ("centered at one/two/three") are correct. No page sentence states a Gamma radius, so there is nothing else to update.

### F3 — resolved
- Script: t11 and t12 are now `x -> bessely(0, x)` with `taylor_family` `(:bessely, 0)` and c = 10.0 and 5.0, on (0, 22). Title label "bessely(0,x)".
- Coefficients against `mpmath.taylor(lambda x: bessely(0,x), c, 8)`: max relative error 9.8e-17 for c = 10 and 9.2e-17 for c = 5.
- Red dots: Y0(10) = 0.0556712 and Y0(5) = -0.3085176, matching the dots.
- Last frames:
  - T11 order 8 tracks Y0 on about (7, 13).
  - T12 order 8 tracks Y0 on about (0.3, 8.5).
  - Both diverge further out.
  - All of this is consistent with R = c, the distance to the logarithmic singularity at 0.
- The legacy `Taylorkk` and `Taylorll` frames read "Y0(x)" with centres 10 and 5. They now match.
- Headings `$f(x)=Y_0(x)$, $x_0=10$` / `$x_0=5$, $x\in[0,22]$` and alt texts "Bessel Y zero centered at ten/five" are correct.

### F4 — resolved
- `break_at_poles` inserts a NaN point between adjacent samples that jump from beyond one y-limit to beyond the other.
- I ran it on all 31 cases (dump.jl). It inserts breaks only at:
  - M01 x = 1.0011
  - M02 x = -1.0011
  - M09 x = ±1.5725
  - T08, T09 and T10 x = 0.0012

  Those are exactly the poles at 1, -1, ±π/2 and 0. It inserts nothing for any other case.
- Old and new M09 frame 12 at full size: the two full-height magenta verticals at ±π/2 are gone. M01 and M02 frames show no vertical at x = ±1, and the T08–T10 frames show none at x = 0.
- A pixel diff of new against old frames (threshold 60/255) changes only the columns at the pole (M01 cols 582–584, M02 159–161, M09 212–214 and 529–531, plus 3 edge pixels). The remaining differences are sub-threshold palette noise. The rest of each picture is unchanged.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd M10 heading | $f(x)=e^{x}$, $x_0=0$, $x\in[-2,3]$ | script line, legacy Maclaurinjj, frame title/axes | correct |
| index.qmd M10 alt | "exponential of x centered at zero" | matches f, c | correct |
| index.qmd T08 heading/alt | Γ, $x_0=1$, [-0.2,5.2]; "centered at one" | script c=1.0, dot at (1,1), legacy Taylorhh | correct |
| index.qmd T09 heading/alt | Γ, $x_0=2$; "centered at two" | c=2.0, dot (2,1), legacy Taylorii | correct |
| index.qmd T10 heading/alt | Γ, $x_0=3$; "centered at three" | c=3.0, dot (3,2), legacy Taylorjj | correct |
| index.qmd T11 heading/alt | $Y_0$, $x_0=10$, [0,22]; "Bessel Y zero centered at ten" | c=10.0, dot Y0(10)=0.05567, legacy Taylorkk | correct |
| index.qmd T12 heading/alt | $Y_0$, $x_0=5$, [0,22]; "Bessel Y zero centered at five" | c=5.0, dot Y0(5)=-0.30852, legacy Taylorll | correct |
| script m10 | exp(x), ylims (-2,21), a_k = 1/k! | mpmath taylor, rel err 8.6e-17; e^3=20.09 < 21 | correct |
| script t08–t10 | c = 1, 2, 3 | mpmath taylor of Γ, rel err ≤ 9.3e-17 | correct |
| script t11–t12 | bessely(0,·), (:bessely,0), c = 10, 5 | mpmath taylor of Y0, rel err ≤ 9.8e-17 | correct |
| script break_at_poles + comment | "Break the f(x) line … a pole lies between them" | breaks found only at the 5 pole locations across 31 cases | correct |
| Description (unchanged, re-checked) | entire-function list incl. $\exp(x)$, $e^{-x^2/2}$, $J_0$; radius statements for arctan, 1/(1+x²), tanh, log | none concerns the changed cases' new functions in a way that is now false; exp(x) is M10 now, $e^{-x^2/2}$ still M17 | still true |
| Animations intro (unchanged) | blue/gray/magenta/red-dot description; clipping to top/bottom edge | verified in new frames | still true |

### New problems
None. This rests on:
- the mpmath coefficient checks for all 9 changed cases (m01, m02 and m09 also checked: m09 against the sympy tan series exactly);
- full-size first, middle and last frames of M10, T08 and T10, and last frames of M01, M02, M09, T09, T11 and T12, plus contact sheets;
- break_at_poles firing only at true poles;
- all 22 unchanged GIFs being byte-identical to HEAD.

### Reproducibility and conventions
- I ran a scratch copy of `series_animations_all.jl` with plain `julia`; it regenerated all 31 GIFs. All 31 are byte-identical to the working-tree GIFs, including the 9 changed ones.
- The 22 GIFs not listed in the diff are byte-identical to HEAD (sha256 of `git show HEAD:… | git lfs smudge`).
- Conventions:
  - Description (line 10) comes before Animations (line 83).
  - There is one source link to the Julia script, which generates all cases.
  - There are 31 image embeds, one per GIF, each with descriptive alt text.
  - The page has no code blocks.
- The fix diff touches only the page folder: index.qmd, the script and 9 GIFs.
- Other modified paths in the repository belong to other pages' fixes and are not part of this diff.

**Final status:** committed
