# Numerical Differentiation — animation review (round 7)

Page: `pages/numerical-methods/numerical-differentiation/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1. Fidelity, Minor: Case 2 claims to follow Example 14 but omits the construction that distinguishes it

- **Location:** `index.qmd` line 26, "and Case 2 follows Examples 11 and 14, the central difference at $x_0=1$"; drawing in `numdiffab.jl` lines 37-39 and 60-62.
- **What is there now:** Case 2 draws the chord through $(x_0-h, f(x_0-h))$ and $(x_0+h, f(x_0+h))$, the true tangent, and three markers. This is the geometry of Mathews' Example 11 and its Animation 6 (`a2001/Animations/Derivative/CentralD2.2f/CentralDfaa.gif`).
- **What is true instead:** Example 14 and its Animation 5 (`CentralD2.1f/CentralD1faa.gif`) use a different construction. Its code (image `NumericalDiffMod_gr_327.gif`) builds:
  - the parabola `q[x_] = Fit[{{X-H, f[X-H]}, {X, f[X]}, {X+H, f[X+H]}}, {1, x, x^2}, x]`, and
  - the line `g[x_] = f[X] + m (x - X)`, through the **centre** point with the central-difference slope.

  Neither is drawn on this page. That construction is what makes the formula a *three-point* rule. The module's Background derives it by differentiating the Lagrange polynomial through three points. Without it, the middle "stencil point" marker in Case 2 has no visible role, since the formula gives it weight zero and the chord does not pass through it.
- **How I know:** I viewed `gr_327` and four frames from each legacy GIF (`review/CentralDfaa_sheet.png`, `review/CentralD1faa_sheet.png`), then compared with frames 1, 6 and 12 of `numdiffab.gif`. The numerical results are unaffected: in `review/check.py`, the derivative at $x_0$ of the parabola through the three stencil points equals the script's secant slope to within $7.6\times10^{-14}$ for all 12 values of $h$.
- **Suggested correction (either one):**
  1. Reword line 26: "Case 2 follows Example 11 and its animation, the chord through $x_0\pm h$. Example 14 reaches the same slope as the derivative at $x_0$ of the parabola through the three stencil points; that parabola is not drawn here."
  2. Or add the parabola, and optionally the parallel line through $(x_0, f(x_0))$, to `numdiffab.jl`, so the page really does follow both examples.

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `numdiffaa.jl` | 0 | 8.4 | numdiffaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `numdiffab.jl` | 0 | 7.3 | numdiffab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `numdiffaa.gif` | 12 | byte-identical | numdiffaa |
| `numdiffab.gif` | 12 | byte-identical | numdiffab |

### Page references

- Scripts linked: `numdiffaa.jl`, `numdiffab.jl`
- GIFs embedded: 2
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

Verdicts: **confirmed**, **wrong**, **could not determine**. Line numbers refer to `index.qmd`.

### Description and derivation

| # | Line | Claim | Verdict | Evidence |
|---|---|---|---|---|
| 1 | 12 | Numerical differentiation replaces analytic derivatives with finite-difference quotients of nearby values | confirmed | Definition; both scripts do this |
| 2 | 12 | Mathews' test function is $f(x)=e^{-x}\sin x$ | confirmed | `gr` formula images in links 2, 8, 13, 14, 15, 16, 17, 18, 19, 20, 21 |
| 3 | 12 | On $[0,\pi]$ | confirmed | Example 1 bound $\max_{0\le x\le\pi}$; Example 2(c) `gr_49`, `gr_85` |
| 4 | 12 | Representative steps $h=0.1,0.01,0.001$ | confirmed | Example 2(a) and 2(b) statements; `gr_52` |
| 5 | 16-18 | $D_3(x,h)=\frac{f(x+h)-f(x-h)}{2h}$ is the three-point central rule | confirmed | Module theorem; `gr_87`; the code matches (Mathews writes it `D1`, same formula) |
| 6 | 20 | Truncation error $O(h^2)$ for smooth $f$ | confirmed | Observed order 1.969 to 2.000 (Case 1), 2.009 to 2.000 (Case 2) |
| 7 | 20 | Truncation error improves as $h$ decreases | confirmed | Error falls monotonically over all 12 steps in both cases |
| 8 | 20 | Roundoff and cancellation eventually limit accuracy | confirmed | At $x=1$ in double precision: $1.67\times10^{-11}$ at $h=10^{-5}$, $5.22\times10^{-10}$ at $10^{-8}$, $6.49\times10^{-6}$ at $10^{-12}$ |
| 9 | 49 | Taylor form $f(x\pm h)=f\pm hf'+\frac{h^2}{2}f''\pm\frac{h^3}{6}f^{(3)}(\xi_\pm)$ | confirmed | Standard Lagrange remainder |
| 10 | 52 | This leads to the central rule with error proportional to $h^2$ | confirmed | Error$/h^2$ tends to $f'''(x)/6$: 0.33333 at $x=0$, 0.16944 at $x=1$; sympy series gives $0.169442h^2$ |

### Animations introduction

| # | Line | Claim | Verdict | Evidence |
|---|---|---|---|---|
| 11 | 24 | Each animation shows $f(x)=e^{-x}\sin x$ | confirmed | Line 9 of both scripts; Case 2 legend |
| 12 | 24 | "legacy interval settings from the source module" | confirmed, with a note | Case 1 uses Example 2(c)'s $[0,\pi]$. Case 2 also uses $[0,\pi]$, the Project I interval, while Examples 11/14 plot $[0,2.1]$. No effect on any conclusion, so not raised |
| 13 | 26 | Case 1 extends Example 2(c), $D_3$ against $f'$ on $[0,\pi]$, from single step $h=0.01$ to a sequence | confirmed | `gr_48` to `gr_51`, `gr_85` to `gr_89`; `hs` in script includes 0.01 |
| 14 | 26 | Case 2 follows Example 11, central difference at $x_0=1$ | confirmed | `gr_262`, `gr_263`; Animation 6 values match (claim 34) |
| 15 | 26 | Case 2 follows Example 14 | **wrong in part** | Same formula and point, but Example 14's parabola and centre line are not drawn. See F1 |
| 16 | 26 | Other examples not animated: Example 1, graph of $f'''$ for the bound | confirmed | Link 2 |
| 17 | 26 | Examples 2(a), 2(b), tables of approximations | confirmed, with a note | 2(b) is called a "table"; 2(a) is a printed list of worked approximations at $x=1$. Too small to raise |
| 18 | 26 | Example 3, absolute error against the error bound | confirmed | Link 6 statement (its graphs are missing from the archive) |
| 19 | 26 | Example 4, how the bound shrinks with $h$ | confirmed | Link 7 text, table of `EB1[h]` |
| 20 | 26 | Examples 9, 10, 12, 13 are forward/backward first-derivative formulas | confirmed | Module statements; links 13, 14, 16, 17 |
| 21 | 26 | Project II, Examples 5-8 and Examples 15-17 are second-derivative work | confirmed | Module statements; links 8 to 12, 19 to 21 |

### Case 1

| # | Line | Claim | Verdict | Evidence |
|---|---|---|---|---|
| 22 | 28 | Heading: central derivative profile, $D_3(x,h)$ on $[0,\pi]$ | confirmed | Script lines 12, 16, 21; frames |
| 23 | 30 | Numerical curve approaches $f'(x)$ as $h$ shrinks | confirmed | Maximum error falls from $8.13\times10^{-2}$ to $3.33\times10^{-7}$ |
| 24 | 30 | Consistent with second-order truncation error | confirmed | Error$/h^2$ from 0.32511 to 0.33333, limit $|f'''(0)|/6=1/3$ |
| 25 | 32 | Source link is this case's script | confirmed | `numdiffaa.jl` |
| 26 | 34 | Alt text: three-point central approximation against true derivative over 0 to $\pi$ as $h$ decreases | confirmed | Frames 1 to 12 |
| 27 | 34 | Embed is this case's GIF | confirmed | Instrumented copy reproduces `numdiffaa.gif` byte for byte |

### Case 2

| # | Line | Claim | Verdict | Evidence |
|---|---|---|---|---|
| 28 | 36 | Heading: secant to tangent at $x_0=1$, $h\to0$ | confirmed | `x0 = 1.0`; $h$ from 0.6 to 0.001 |
| 29 | 38 | Slope is $(f(x_0+h)-f(x_0-h))/(2h)$ | confirmed | Script line 34; matches 50-digit evaluation to $1.6\times10^{-14}$ or better |
| 30 | 38 | Slope converges to $f'(x_0)$ as stencil contracts | confirmed | Error falls monotonically from $6.144\times10^{-2}$ to $1.694\times10^{-7}$ |
| 31 | 40 | Source link is this case's script | confirmed | `numdiffab.jl` |
| 32 | 42 | Alt text: central secants through $x_0\pm h$ collapsing to the tangent at $x_0=1$ for $f$ | confirmed | Chord residual at $x_0+h$ at most $2.8\times10^{-17}$; frames 1, 6, 12 |
| 33 | 42 | Embed is this case's GIF | confirmed | Instrumented copy reproduces `numdiffab.gif` byte for byte |
| 34 | frames | Title values agree with legacy Animation 6 where the steps coincide | confirmed | $h=0.6$: −0.049354; $h=0.07$: −0.109963; $h=0.001$: −0.110794 in both |

---

### 3. Implementation checks

Commands, from the `review/` folder:
- `julia inst/aa.jl`, `julia inst/ab.jl`: scratch copies with a print added to each frame. Both produced GIFs **byte-identical** to the committed ones (`cmp`), so the printed values are the values behind the frames.
- `/usr/bin/python3 check.py`: independent evaluation with mpmath at 50 digits, sympy and numpy.

### `numdiffaa.jl` (Case 1)

**Method.** The code runs the symmetric central difference, line 12. This is the method named.

**Numbers.** I derived the closed form
$$D_3(x,h)=e^{-x}\left[\frac{\cosh h\,\sin h}{h}\cos x-\frac{\sinh h\,\cos h}{h}\sin x\right],$$
which agrees with direct 50-digit evaluation to $3\times10^{-51}$, and maximised the error over the continuous interval.

| $h$ | Script max error (700-pt grid) | Independent continuous max | Frame title | Error$/h^2$ | Observed order |
|---|---|---|---|---|---|
| 0.5 | 8.12767083e-02 | 8.12770222e-02 | 8.13e-02 | 0.32511 | |
| 0.3 | 2.97312685e-02 | 2.97312685e-02 | 2.97e-02 | 0.33035 | 1.969 |
| 0.2 | 1.32801083e-02 | 1.32801116e-02 | 1.33e-02 | 0.33200 | 1.988 |
| 0.1 | 3.32999841e-03 | 3.33000175e-03 | 3.33e-03 | 0.33300 | 1.996 |
| 0.07 | 1.63253281e-03 | 1.63253321e-03 | 1.63e-03 | 0.33317 | 1.999 |
| 0.05 | 8.33124975e-04 | 8.33125027e-04 | 8.33e-04 | 0.33325 | 1.999 |
| 0.03 | 2.99972999e-04 | 2.99973001e-04 | 3.00e-04 | 0.33330 | 2.000 |
| 0.02 | 1.33328000e-04 | 1.33328000e-04 | 1.33e-04 | 0.33332 | 2.000 |
| 0.01 | 3.33330000e-05 | 3.33330000e-05 | 3.33e-05 | 0.33333 | 2.000 |
| 0.005 | 8.33331250e-06 | 8.33331250e-06 | 8.33e-06 | 0.33333 | 2.000 |
| 0.002 | 1.33333280e-06 | 1.33333280e-06 | 1.33e-06 | 0.33333 | 2.000 |
| 0.001 | 3.33333300e-07 | 3.33333300e-07 | 3.33e-07 | 0.33333 | 2.000 |

The 700-point grid never changes a displayed digit.

**Reference.** sympy confirms $f'(x)=e^{-x}(\cos x-\sin x)$ exactly (residual 0).

**Picture.** The curves are the plotted `fp` and `central3` values. The $y$-limits $(-1, 1.1)$ clip nothing: the computed range of $D_3$ across all frames is $-0.2079$ to $1.0812$. Titles match the values above in all 12 frames. No NaN masking or clamping is used.

### `numdiffab.jl` (Case 2)

**Method.** The slope is $(f(x_0+h)-f(x_0-h))/(2h)$, line 34. The drawn line is the chord through the two outer points.

**Numbers.** True $f'(1)=-0.110793765306699$ (mpmath); the script has $-0.11079376530669924$.

| $h$ | Script slope | 50-digit slope | Frame title | Error | Error$/h^2$ |
|---|---|---|---|---|---|
| 0.6 | −0.049353743 | −0.049353743 | −0.049354 | +6.144002e-02 | 0.17067 |
| 0.4 | −0.083591810 | −0.083591810 | −0.083592 | +2.720196e-02 | 0.17001 |
| 0.25 | −0.100189411 | −0.100189411 | −0.100189 | +1.060435e-02 | 0.16967 |
| 0.15 | −0.106979460 | −0.106979460 | −0.106979 | +3.814305e-03 | 0.16952 |
| 0.1 | −0.109098977 | −0.109098977 | −0.109099 | +1.694788e-03 | 0.16948 |
| 0.07 | −0.109963411 | −0.109963411 | −0.109963 | +8.303544e-04 | 0.16946 |
| 0.05 | −0.110370137 | −0.110370137 | −0.110370 | +4.236281e-04 | 0.16945 |
| 0.03 | −0.110641265 | −0.110641265 | −0.110641 | +1.525008e-04 | 0.16945 |
| 0.02 | −0.110725988 | −0.110725988 | −0.110726 | +6.777739e-05 | 0.16944 |
| 0.01 | −0.110776821 | −0.110776821 | −0.110777 | +1.694424e-05 | 0.16944 |
| 0.005 | −0.110789529 | −0.110789529 | −0.110790 | +4.236052e-06 | 0.16944 |
| 0.001 | −0.110793596 | −0.110793596 | −0.110794 | +1.694420e-07 | 0.16944 |

The limit is $f'''(1)/6=0.169442$. Observed order between successive steps runs from 2.009 to 2.000. Mathews' worked Example 14 values at $h=0.5,0.2,0.1,0.05,0.02,0.01$ are all reproduced by the same formula.

**Reference.** The tangent uses the exact $f'(1)$ and passes through $(1, f(1))$, with $f(1)=0.309559875653112$ in both computations.

**Picture.** The chord passes through both outer stencil points (residual at most $2.8\times10^{-17}$). The tangent touches the curve at $x_0$. The range guard at line 26 never triggers, so all 12 steps appear as 12 frames. In the last frame the three markers overlap because $h=0.001$ is below pixel resolution, which is expected. The chord and tangent are plotted only over $x_0\pm0.9$, which contains every stencil.

### Could not determine

- The worked solution graphics for Example 11 are missing from the archive (19 of the 21 images in link 15). Its statement (`gr_262`, `gr_263`) and its Animation 6 are present and were used instead.
- Likewise missing: 19 of 27 images in link 6 (Example 3), 13 of 17 in link 7 (Example 4), 2 of 4 in link 4 (Example 2(b)). The page only names what those examples are about, and their statement text is enough for that. Their graphs could not be compared, and the page draws on none of them.

---

### 4. Archive use

- Read as text: `NumericalDiffMod.html` and `NumericalDiffMod_lnk_1` to `_21`.
- Viewed: the statement formula images for Examples 1 to 17 where present, the code images for Examples 2(a), 2(c) and 14, the graphs for Example 2(c), and four frames each of legacy Animations 5 and 6 (`CentralD1faa.gif`, `CentralDfaa.gif`), plus the title region of every distinct frame of Animation 6.
- The page's list of examples it does not animate is accurate and discloses the forward, backward and second-derivative material, so those omissions are not findings.

