# Numerical Differentiation — animation review (round 4)

Page: `pages/numerical-methods/numerical-differentiation/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1. Fidelity, Minor: the list of material that is not animated is incomplete

- **Location:** `index.qmd` line 26: "The module's forward- and backward-difference formulas for the first derivative (Examples 9, 10, 12 and 13) and its formulas for the second derivative (Project II, Examples 5–8, and Examples 15–17) are not animated here."
- **What is there now:** The sentence lists the archive content that has no animation. Because it is an explicit list, a reader takes everything else to be covered.
- **What is true instead:** Most of Project I is not animated either, and the sentence does not mention it:
  - Example 1: graph of $f'''$ and the bound $M_3$.
  - Example 3: plot of the absolute error $|f'(x) - D_1(x,0.01)|$ on $[0,\pi]$ against the bound $EB_1(0.01)$, and the observation that the maximum error occurs at $x=0$.
  - Example 4: the table showing $O(h^2)$ behaviour of $EB_1(h)$.
  - Examples 2(a) and 2(b): numeric tables.

  Case 1 covers Example 2(c), and Case 2 covers Examples 11 and 14 (both are the same formula at $x_0=1$). Case 1's title reports the maximum error, which partly stands in for Examples 3 and 4. However, no frame shows the error curve or the truncation-error bound.
- **How I know:** I read `NumericalDiffMod.html` as text, `Links/NumericalDiffMod_lnk_12.html` (Example 8; the link numbering is offset from the example numbers) through `_lnk_19.html`, and the formula images listed above.
- **Suggested correction:** Add to line 26: "Project I's error-analysis items (Example 1, the graph of $f'''$; Example 3, the absolute-error plot against the bound $h^2 M_3/6$; Example 4, the $O(h^2)$ table) are not animated. Case 1 reports only the maximum error in its title." Alternatively, animate Example 3.

No other findings. Every number in the frames agrees with an independent 40-digit computation to the printed precision, and every behaviour claim agrees with the computed sequences.

---

- **Independent check:** not run (Minor finding, unverified)


## Reviewer's notes (not findings)


**Count: Error 0, Misleading 0, Minor 1.**



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `numdiffaa.jl` | 0 | 7.5 | numdiffaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `numdiffab.jl` | 0 | 7.6 | numdiffab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | Description, l.12 | "In the Mathews examples for this module, the test function is $f(x)=e^{-x}\sin(x)$" | archive gr_27, gr_262; both scripts line 9 | confirmed |
| 2 | Description, l.12 | "on $[0,\pi]$" | archive gr_49 / gr_95; aa `xlims=(0.0, pi)` | confirmed |
| 3 | Description, l.12 | "representative steps $h=0.1,0.01,0.001$" | archive gr_45, gr_47 (Example 2) | confirmed |
| 4 | Description, l.14–18 | "three-point central approximation … $D_3(x,h)=\frac{f(x+h)-f(x-h)}{2h}$" | aa line 12 `central3` and ab line 34 are this formula exactly. Mathews calls it the three-point rule (from the Lagrange parabola; the middle weight is 0) | confirmed |
| 5 | Description, l.20 | "truncation error $O(h^2)$ when $f$ is sufficiently smooth" | indep: Case 1 maxerr/$h^2$ goes 0.3251 → 0.33333 (limit $f'''(0)/6 = 1/3$); Case 2 err/$h^2$ goes 0.17067 → 0.169442 ($= f'''(1)/6$) | confirmed |
| 6 | Description, l.20 | "As $h$ decreases, truncation error improves, but eventually roundoff and cancellation can limit accuracy." | A true general statement. In this animation roundoff is never reached: at $h=0.001$ the error is $3.3333\times10^{-7}$, which equals $h^2/3$ to 5 digits. The page does not claim the animation shows roundoff | confirmed |
| 7 | Animations intro, l.24 | "Each animation below shows finite-difference derivative behavior for $f(x)=e^{-x}\sin(x)$" | both scripts line 9; frame titles and legends | confirmed |
| 8 | Animations intro, l.24 | "on legacy interval settings from the source module" | Case 1 uses $[0,\pi]$, as in Example 2(c). Case 2 uses $x_0=1$, as in Examples 11 and 14; its plot window $[0,\pi]$ differs from Mathews' $[0,2.1]$, which is immaterial | confirmed |
| 9 | l.26 | forward/backward first-derivative formulas are "Examples 9, 10, 12 and 13" | lnk_13, 14, 16, 17 | confirmed |
| 10 | l.26 | second-derivative formulas are "Project II, Examples 5–8, and Examples 15–17" | main page text; lnk_12 (Example 8); lnk_19 (Example 15) | confirmed |
| 11 | l.26 (implicit) | the list names everything that is not animated | Project I Examples 1, 3, 4 and 2(a)/(b) are also not animated | wrong (F1, Minor) |
| 12 | Case 1 heading | "central derivative profile, $D_3(x,h)$ on $[0,\pi]$" | aa lines 12, 16, 21; frames | confirmed |
| 13 | Case 1 Behavior | "The numerical derivative curve approaches $f'(x)$ as $h$ shrinks" | maxerr falls monotonically 8.13e-02 → 3.33e-07 over 12 frames (aa.out, indep agree). Frames 1–3 show a visible gap that has closed by frame 4 | confirmed |
| 14 | Case 1 Behavior | "consistent with second-order truncation error for the central stencil" | maxerr/$h^2$ = 0.3251, 0.3303, 0.3320, 0.3330, …, 0.333333. Each tenfold cut in $h$ shrinks the error by 100× (titles: 3.33e-03 → 3.33e-05 → 3.33e-07) | confirmed |
| 15 | Case 1 link | `[Julia source](numdiffaa.jl)` | file exists and produces numdiffaa.gif | confirmed |
| 16 | Case 1 embed | `numdiffaa.gif` | byte-identical to the regenerated output (manifest); frames show the $D_3$ profile | confirmed |
| 17 | Case 1 alt | "comparing the three-point central derivative approximation against the true derivative over 0 to pi as h decreases" | frames: black $f'(x)$ and blue $D_3(x,h)$ on $[0,\pi]$, $h$ from 0.5 down to 0.001 | confirmed |
| 18 | Case 2 heading | "secant to tangent at $x_0=1$, $h\to 0$" | ab `x0 = 1.0`; hs 0.6 → 0.001 | confirmed |
| 19 | Case 2 Behavior | "The slope from the symmetric secant $(f(x_0+h)-f(x_0-h))/(2h)$" | ab line 34 `msec = (yr - yl) / (2h)`, with yl = f(x0-h) and yr = f(x0+h) | confirmed |
| 20 | Case 2 Behavior | "converges to the tangent slope $f'(x_0)$ as the stencil contracts" | msec: -0.049354, -0.083592, -0.100189, -0.106979, -0.109099, -0.109963, -0.110370, -0.110641, -0.110726, -0.110777, -0.110790, -0.110794. This is monotone toward $f'(1)=-0.1107937653$, and err/$h^2 \to 0.169442$ | confirmed |
| 21 | Case 2 link | `[Julia source](numdiffab.jl)` | exists and produces numdiffab.gif | confirmed |
| 22 | Case 2 embed | `numdiffab.gif` | byte-identical to the regenerated output; shows the $x_0=1$ secant and tangent | confirmed |
| 23 | Case 2 alt | "central secant lines through the points at x0 minus h and x0 plus h" | instrumented: the secant evaluated at $x_0+h$ equals $f(x_0+h)$ exactly in every frame, and the line is anchored at $(x_0-h, f(x_0-h))$; orange markers lie on the dashed line in the frames | confirmed |
| 24 | Case 2 alt | "collapsing to the tangent line at x0 equals 1" | line ranges converge: secant (0.18700, 0.27584) at $h=0.6$ becomes (0.209845, 0.409274) at $h=0.001$, against tangent (0.209845, 0.409274) | confirmed |
| 25 | Case 2 alt | "for f of x equals e to the minus x times sine x" | ab line 9; legend | confirmed |
| 26 | Frame titles, Case 1 | "max error ≈ 8.13e-02, 2.97e-02, 1.33e-02, 3.33e-03, 1.63e-03, 8.33e-04, 3.00e-04, 1.33e-04, 3.33e-05, 8.33e-06, 1.33e-06, 3.33e-07" | indep (40 digits, 700-point and 4001-point grids): 0.0812767, 0.0297313, 0.0132801, 0.00333, 0.00163253, 0.000833125, 0.000299973, 0.000133328, 3.3333e-5, 8.33331e-6, 1.33333e-6, 3.33333e-7 | confirmed |
| 27 | Frame titles, Case 2 | "true = -0.110794" | indep `mp.diff`: −0.110793765306699; Mathews gr_329: −0.110794 | confirmed |
| 28 | Frame titles, Case 2 | the "secant slope ≈" values | all 12 match indep to 6 decimals (see §3) | confirmed |
| 29 | Frame legend, Case 2 | "central secant (chord through x0 ± h)" (dashed blue), "true tangent" (red), "stencil points" (orange: $x_0-h$, $x_0$, $x_0+h$) | ab lines 60–62; instrumented values | confirmed |
| 30 | Derivation Notes | $f(x\pm h) = f(x) \pm h f'(x) + \frac{h^2}{2}f''(x) \pm \frac{h^3}{6}f^{(3)}(\xi_\pm)$ | Taylor's theorem with Lagrange remainder. Subtracting gives $D_3 - f' = \tfrac{h^2}{12}(f'''(\xi_+)+f'''(\xi_-)) = \tfrac{h^2}{6}f'''(\xi)$ | confirmed |
| 31 | Derivation Notes | "leads to the central three-point first-derivative rule with error proportional to $h^2$" | as #5 and #30 | confirmed |

---

### 3. Implementation checks

### `numdiffaa.jl` (Case 1)

- **It is the method it claims to be.** Line 12 `central3(x,h) = (f(x+h) - f(x-h))/(2h)` is the central difference, called "three-point" in Mathews' convention (from the Lagrange parabola; the middle weight is 0). It is evaluated on 700 points of $[0,\pi]$. Near $x=0$ it uses $f$ at negative arguments. The comment on line 23 says so, and it is legitimate because $f$ is entire.
- **The numbers are right.** The instrumented copy (`aa.out`) and the independent computation (`indep.py`, 40-digit mpmath, $f'$ from `mp.diff`) agree:

  | h | script maxerr | indep maxerr | indep err/h² |
  |---|---|---|---|
  | 0.5 | 0.0812767083 | 0.0812767 | 0.325107 |
  | 0.3 | 0.0297312685 | 0.0297313 | 0.330347 |
  | 0.2 | 0.0132801083 | 0.0132801 | 0.332003 |
  | 0.1 | 0.0033299984 | 0.00333 | 0.333 |
  | 0.07 | 0.0016325328 | 0.00163253 | 0.33317 |
  | 0.05 | 8.331250e-4 | 8.33125e-4 | 0.33325 |
  | 0.03 | 2.999730e-4 | 2.99973e-4 | 0.333303 |
  | 0.02 | 1.333280e-4 | 1.33328e-4 | 0.33332 |
  | 0.01 | 3.33330e-5 | 3.3333e-5 | 0.33333 |
  | 0.005 | 8.33331e-6 | 8.33331e-6 | 0.333332 |
  | 0.002 | 1.333333e-6 | 1.33333e-6 | 0.333333 |
  | 0.001 | 3.333333e-7 | 3.33333e-7 | 0.333333 |

  - **Order property:** err/$h^2$ tends to $f'''(0)/6 = 2/6 = 1/3$, the predicted leading constant. This confirms second order without relying on a remembered formula.
  - **Grid resolution:** A 4001-point grid gives the same maximum to 6 digits, so the 700-point sampling is adequate. For $h \le 0.05$ the maximum is at $x=0$. For larger $h$ it sits just right of 0 ($x \approx 0.025$ at $h=0.5$).
- **Its reference values are right.** The closed form `fp(x) = exp(-x)*(cos(x) - sin(x))` agrees with sympy's $\sqrt2 e^{-x}\cos(x+\pi/4)$, which is the same function, and with `mp.diff` at $x=1$ to 15 digits.
- **The picture shows what was computed.**
  - I read all 12 frames on the contact sheet. Each title's $h$ and maxerr match the table above.
  - Black is $f'$ and blue is $D_3$.
  - The $D_3$ range is [-0.1915, 1.0812] at $h=0.5$, and $f'$ spans [-0.2079, 1]. Both fit inside ylims (-1, 1.1), so nothing is clipped.
  - From frame 4 ($h=0.1$) on, the curves are visually indistinguishable, and only the title shows further convergence. That matches the claim, which says nothing about visibility, so it is not a finding.

### `numdiffab.jl` (Case 2)

- **It is the method it claims to be.** Line 34 computes `msec = (f(x0+h) - f(x0-h))/(2h)` at $x_0 = 1$, the central difference of Mathews Examples 11 and 14. The chord on line 38 is `yl + msec*(x - xl)`: the line through $(x_0-h, f(x_0-h))$ with the chord slope. The instrumented run confirms that it also passes through $(x_0+h, f(x_0+h))$ in every frame (secant at $x_r$ minus $y_r$ is 0 or $3\times10^{-17}$).

  Mathews' Example 14 graph instead draws the line of slope $m$ through $(x_0, f(x_0))$, plus the interpolating parabola. Both are valid ways to show the same quotient, and the page's wording ("chord through x0 ± h") matches what this script draws.
- **The numbers are right.**

  | h | script msec | indep $D_3(1,h)$ (6 dp) | indep error | err/h² |
  |---|---|---|---|---|
  | 0.6 | -0.0493537427 | -0.049354 | 6.1440e-2 | 0.170667 |
  | 0.4 | -0.0835918101 | -0.083592 | 2.7202e-2 | 0.170012 |
  | 0.25 | -0.1001894114 | -0.100189 | 1.0604e-2 | 0.169670 |
  | 0.15 | -0.1069794600 | -0.106979 | 3.8143e-3 | 0.169525 |
  | 0.1 | -0.1090989768 | -0.109099 | 1.6948e-3 | 0.169479 |
  | 0.07 | -0.1099634110 | -0.109963 | 8.3035e-4 | 0.169460 |
  | 0.05 | -0.1103701372 | -0.110370 | 4.2363e-4 | 0.169451 |
  | 0.03 | -0.1106412645 | -0.110641 | 1.5250e-4 | 0.169445 |
  | 0.02 | -0.1107259879 | -0.110726 | 6.7777e-5 | 0.169443 |
  | 0.01 | -0.1107768211 | -0.110777 | 1.6944e-5 | 0.169442 |
  | 0.005 | -0.1107895293 | -0.110790 | 4.2361e-6 | 0.169442 |
  | 0.001 | -0.1107935959 | -0.110794 | 1.6944e-7 | 0.169442 |

  - The leading constant $f'''(1)/6 = 0.169442$ (sympy $f''' = 2\sqrt2 e^{-x}\sin(x+\pi/4)$) is reached, which confirms second order.
  - All 12 titles match column 3 to 6 decimals.
- **Its reference values are right.** `mtan = fp(1)` = −0.11079376530669924. Independent `mp.diff` gives −0.110793765306699, and Mathews (gr_329) gives −0.110794. The tangent line is $f(1) + m_{tan}(x-1)$ with $f(1) = 0.3095598757$.
- **The picture shows what was computed.**
  - In all 12 frames the three orange markers sit at $x_0-h$, $x_0$ and $x_0+h$ on the curve. The dashed chord passes through the outer two, and the red tangent touches at $x_0$.
  - Line extents: $x_0 \pm 0.9$ = [0.1, 1.9], with y-range [0.187, 0.409]. The curve maximum is $f(\pi/4) = 0.3224$. Everything fits inside ylims (-0.1, 0.55).
  - The `continue` guard on line 26 never fires: the largest stencil is [0.4, 1.6], inside $[0,\pi]$. So no frame is dropped, and the frame count is 12 as committed.
  - Legend and title labels are correct.

### Not determined

- I could not see Mathews' own Example 11 graph or the legacy animated GIFs (`a2001/.../CentralD1faa.gif`, `CentralDfaa.gif`) because those files are absent from the archive. So I could not check whether Case 2 reproduces the legacy animation's exact geometry. The parameters ($f$, $x_0 = 1$, the central formula) are confirmed from gr_262, gr_263 and gr_327.

