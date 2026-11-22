# Adams-Bashforth-Moulton Method — animation review (round 5)

Page: `pages/numerical-methods/adams-bashforth-moulton-method/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page agrees with my own computation and with the frames. Every number in the script matches an independent implementation. Details follow in the ledger and the implementation checks.

Seen but not reported, because each falls outside the review standard:
- The script re-evaluates `f` at four past points every step instead of reusing stored values, which is 5 evaluations per step rather than 2. This affects performance only and not any computed value. The page's phrase "low per-step cost" describes the method in general, not this script.
- My order test (below) gives pre-asymptotic ratios of 42 → 18.4, trending down toward 16. That is expected and is not a defect.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `adamsbashforthmoultonaa.jl` | 0 | 14.5 | adamsbashforthmoultonaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `adamsbashforthmoultonaa.gif` | 21 | byte-identical | adamsbashforthmoultonaa |

### Page references

- Scripts linked: `adamsbashforthmoultonaa.jl`
- GIFs embedded: 1
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Claim (page wording) | Evidence | Verdict |
|---|---|---|---|
| 1 | Intro: "repeats the step-refinement sweep of Mathews' animation for legacy Example 11" | `lnk_12.html` is "Example 11 … Animation 1" and links `Adams1/Adamsaa`. All 22 distinct frames of Adamsaa.gif show the same ODE. | confirmed |
| 2 | "$y' = 1 - t\sqrt[3]{y}$, $y(0)=1$, over $0 \le t \le 5$" | Script lines 12, 66–68. Mathews gr_165: "y' = 1 - t ∛y with y(0) = 1 over 0 ≤ t ≤ 5". | confirmed |
| 3 | "Each frame is a complete ABM4 run with $m$ subintervals ($h=5/m$, the first three steps by RK4)" | `abm4` lines 34–64: RK4 for y1..y3, then AB4/AM PECE. One `abm4` call per frame (line 110). | confirmed |
| 4 | "the 21 values of Mathews' animation, $m = 12, 14, …, 150$" | Mathews' frames read "Using m = 12, 14, 16, 18, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 70, 80, 90, 100, 120, 150" (crop `mathews_anim/mlabels.png`). Script `ms` is identical. The GIF has 21 frames. | confirmed |
| 5 | "labelled with the computed $y(5)$ and its error" | Annotations at lines 129–130. Error = ys[end] − yex5. Frames show the values. | confirmed |
| 6 | "thick gray curve is a high-accuracy reference … fixed-step RK4 at $h=10^{-4}$" | Lines 70–72, 123 (gray70, lw 4). The RK4 reference differs from DOP853 (rtol 1e-13) by at most 9.6e-13 on the grid. At t=5 it gives 0.008119920464867961, against mpmath odefun (30 digits) 0.0081199204648679610. | confirmed |
| 7 | "rises from $y(0)=1$ to about $1.4498$ near $t=0.88$" | Reference max 1.4497667 at t=0.8836 (script), 1.4497667 at t=0.88356 (independent). | confirmed |
| 8 | "decays to $y(5)=0.0081199$" | 0.00811992046 (mpmath). | confirmed |
| 9 | "For $m=12$ through $52$ the computed curve visibly breaks away from the reference in the tail (from $t\approx3.2$ to $4.7$, depending on $m$)" | First grid t with \|e\|>0.02: 3.33, 3.21, 3.44, 3.33, 3.50, 3.96, 3.75, 3.75, 4.17, 4.38, 4.21, 4.69, 4.62. Max \|e\| ≥ 0.114 for each (0.114 at m=52, 0.736 at m=12). Frames show it, e.g. frame 12 (m=48). | confirmed |
| 10 | "each of these runs goes below zero somewhere … at $m=48$ only to $-0.0049$" | min y for m=12..52: −0.419, −0.453, −0.275, −0.243, −0.363, −0.144, −0.176, −0.116, −0.119, −0.053, −0.065, **−0.00488**, −0.033. All negative. | confirmed |
| 11 | "(then $\sqrt[3]{y}$ is the real cube root)" | `cbrt`, line 12. Mathews uses Sign[y]·Abs[y]^(1/3) (gr_166), which is the same function. | confirmed |
| 12 | "For $m=56$ and $60$ the run stays on the reference until about $t=4.8$ and $4.9$ and then rises above it, by up to $0.11$ and $0.096$" | m=56: \|e\|>0.02 first at t=4.821, max +0.1080 at t=4.911. m=60: first at t=4.917, max +0.0956 at t=5. Both stay positive (min 0.0126, 0.0096). | confirmed |
| 13 | "Across $m=12$ to $60$ the end value jumps between $y(5)\approx-0.363$ ($m=20$) and $0.632$ ($m=16$)" | min y(5) = −0.3628404 (m=20), max = 0.6321470 (m=16). These equal Mathews' frame labels −0.3628404 and 0.632147. | confirmed |
| 14 | "at $m=12$, $y(5)=0.0214$, although the run is off by $0.74$ at $t\approx4.17$" | y(5)=0.0214088. Max error +0.7364 at t=4.167. | confirmed |
| 15 | "From $m=60$ on, the error in $y(5)$ falls at every refinement" | 9.555e-2, 2.081e-3, −1.094e-5, −2.940e-7, −4.489e-9, −5.655e-10, −1.356e-10 (m=60..150). Magnitude falls monotonically. | confirmed |
| 16 | "$9.6\times10^{-2}$ at $m=60$" | 9.555e-2 | confirmed |
| 17 | "$2.1\times10^{-3}$ at $m=70$ (26% of $y(5)$, but too small to see in the frame)" | 2.081e-3, which is 25.6% of 0.0081199. In frame 16 it is under one pixel at this scale. | confirmed |
| 18 | "$1.1\times10^{-5}$ at $m=80$, $4.5\times10^{-9}$ at $m=100$ and $1.4\times10^{-10}$ at $m=150$" | 1.094e-5, 4.489e-9, 1.356e-10 (script and independent agree to all printed digits). | confirmed |
| 19 | "$\partial f/\partial y=-t/(3y^{2/3})$ reaches $-41.3$ at $t=5$" | Formula correct (derivative of −t·y^{1/3}). Along the reference it is −41.2554 at t=5, and \|fy\| is monotone increasing on [0.5,5], so t=5 is the maximum. | confirmed |
| 20 | "this ABM4 predictor-corrector is stable on $y'=\lambda y$ with real $\lambda<0$ only while $h\|\lambda\|\le1.285$" | I built the 4×4 one-step matrix of PECE independently from the recurrence. Spectral radius crosses 1 at z = −1.2848163 (brentq). A sweep of [−2,0) finds no unstable z in (−1.2848, 0). The script gives 1.284816263. | confirmed |
| 21 | "for every $m\le160$ ($h>0.0311$) … $h\,\|\partial f/\partial y\|$ exceeds $1.285$ before $t=5$" | h* = 1.28482/41.2554 = 0.031143. m=160 gives h=0.03125 > h*, and m=161 gives h=0.03106 < h*. The bound is exact. | confirmed |
| 22 | "the shaded region, from $t\approx2.83$ at $m=12$ to $t\approx4.89$ at $m=150$" | onset 2.8260 (m=12), 4.8896 (m=150). Shading is [onset, 5], which is valid because \|fy\| is monotone. | confirmed |
| 23 | "For $m=12$ to $60$ the error at the last step before the shaded region is between $5.6\times10^{-5}$ and $2.2\times10^{-3}$" | Range is 5.64e-5 (m=60, t=3.583) to 2.17e-3 (m=20, t=3.000). | confirmed |
| 24 | "and after it the error reaches $0.096$ to $0.74$" | Max \|e\| after onset ranges from 0.0956 (m=60) to 0.736 (m=12). | confirmed |
| 25 | "for $m=100$, $120$ and $150$ it is below $10^{-8}$ there, and the error at $t=5$ is smaller still" | Pre-onset 8.25e-9, 1.12e-9, 1.66e-10. At t=5: 4.49e-9, 5.66e-10, 1.36e-10. Each is smaller. | confirmed |
| 26 | "So $h=0.0311$ is a linear stability bound, not an accuracy threshold." | This follows from 21–25: m=100..150 have h>0.0311 and are accurate to ≤1e-8. | confirmed |
| 27 | "The module's worked solution of Example 11 uses $n=50$, $100$ and $150$ steps" | gr_168/175/182: "Using n = 51 / 101 / 151 points", which is 50/100/150 steps. | confirmed |
| 28 | "the $n=100$ and $150$ runs (frames $m=100$ and $150$ here) end at $y(5)=0.0081199$" | Mathews gives 0.00811992 for both. Independent ABM4 gives 0.00811992 for both. Frames 19 and 21 read 0.0081199. | confirmed |
| 29 | "the $n=50$ run ($h=0.1$) falls to $y_{48}\approx-0.0018$ at $t=4.8$ and ends at $y(5)\approx0.138$, about 17 times the exact value" | Independent: y48 = −0.0018309, y50 = 0.138090, ratio 17.01. Mathews' table (gr_170) shows {4.8, −0.0018309}, {5., 0.13809}. | confirmed |
| 30 | Description: "In the 4-step form, an explicit Adams-Bashforth predictor estimates $y_{n+1}$ from recent history, and an implicit Adams-Moulton corrector immediately refines it" | Script uses AB4 (55,−59,37,−9)/24 and the 4th-order AM corrector (9,19,−5,1)/24, applied once (PECE). I derived both coefficient sets symbolically (`coeffs.py`). | confirmed |
| 31 | Description: "not self-starting, initial points are generated with a one-step method (such as RK4)" | RK4 for y1..y3 (lines 40–49). | confirmed |
| 32 | Case heading: "ABM4 predictor-corrector step-refinement sweep, $y' = 1 - t\sqrt[3]{y}$, $y(0)=1$, $m = 12$ to $150$ subintervals" | Matches the script. | confirmed |
| 33 | Alt text: "gray reference curve that peaks near 1.45 at t ≈ 0.88 and decays to 0.0081 at t = 5" | As in 7–8. | confirmed |
| 34 | Alt text: "For m = 12 to 60 the run visibly breaks away … ending between y(5) = -0.363 and 0.632" | As in 9, 12, 13. | confirmed |
| 35 | Alt text: "a shaded region marks where h·\|∂f/∂y\| exceeds 1.285, which happens in every frame" | Onset exists for all 21 m (latest 4.8896). Shaded in every frame. | confirmed |
| 36 | Alt text: "from m = 70 on the run lies on the reference at this scale, with y(5) = 0.0081199 at m = 100 and 150" | Max \|e\| for m≥70 is 2.08e-3, under a pixel. y(5) as in 28. | confirmed |
| 37 | Wiring: `[Julia source](adamsbashforthmoultonaa.jl)` and the embed `adamsbashforthmoultonaa.gif` | That script writes exactly that GIF (line 135). The regeneration is byte-identical. The section index links the page (index.qmd line 118). | confirmed |

### 3. Implementation checks: `adamsbashforthmoultonaa.jl`

**It is the method it claims to be.** The script runs the 4th-order Adams-Bashforth-Moulton predictor-corrector in PECE mode with the corrector applied once. It uses the AB4 predictor `y + h/24(55f_n − 59f_{n−1} + 37f_{n−2} − 9f_{n−3})`, evaluates f at the prediction, and then applies the AM corrector `y + h/24(9f* + 19f_n − 5f_{n−1} + f_{n−2})`. Each f_n is evaluated at the corrected y_n. Startup is three classical RK4 steps. This matches Mathews' theorem and remark (three starting values by Runge-Kutta). Checks:
- `coeffs.py` integrates the Lagrange bases with sympy and gives AB4·24 = [55, −59, 37, −9] and AM·24 = [9, 19, −5, 1], which match the script.
- `inst/order.jl` runs the script's own `abm4` on y' = −2ty, y(0)=1 over [0,2] (exact solution e^{−t²}). Errors are 6.38e-4, 1.51e-5, 4.71e-7, 1.90e-8, 9.22e-10, 5.02e-11 for n = 10..320. The halving ratios 42 → 32 → 25 → 21 → 18.4 decrease toward 16, which is consistent with 4th order.

**The numbers are right.** I wrote an independent Python ABM4 (`indep.py`) and compared it with the instrumented script (`inst/inst.jl`). y(5) agrees to all 10 printed digits for all 21 m, for example:

| m | script y(5) | independent y(5) | Mathews' frame |
|---|---|---|---|
| 12 | 0.0214087829 | 0.0214087829 | 0.0214088 |
| 16 | 0.6321469806 | 0.6321469806 | 0.632147 |
| 20 | −0.3628404218 | −0.3628404218 | −0.3628404 |
| 48 | 0.0481297112 | 0.0481297112 | 0.0481297 |
| 60 | 0.1036708246 | 0.1036708246 | 0.1036708 |
| 80 | 0.0081089834 | 0.0081089834 | 0.008109 |
| 100 | 0.0081199160 | 0.0081199160 | 0.0081199 |
| 150 | 0.0081199203 | 0.0081199203 | 0.0081199 |

The minimum and maximum of each run agree as well (e.g. m=14 min −0.45300, m=48 min −0.00488). Every value lies inside ylims (−0.5, 1.8), so the axis does not clip anything. The stability limit is 1.284816263 (script) against 1.2848162631 (independent companion-matrix construction plus brentq). Onset times agree to 4 decimals.

**Its reference values are right.** The RK4 reference at h=1e-4 gives y(5) = 0.008119920464867961. mpmath `odefun` at 30 digits gives 0.0081199204648679610. Its ODE residual at t=1..5 is ≤3e-10, which is limited by the numerical differentiation used for the check. The largest difference from a DOP853 rtol=1e-13 solution over the whole grid is 9.6e-13, far below the smallest error the page quotes (1.4e-10). The reference stays positive (min 0.00812), so the cube root is smooth along it and fy is finite.

**The picture shows what was computed.** I viewed the contact sheet and frames 1 (m=12), 12 (m=48), 16 (m=70) and 21 (m=150).
- The magenta polyline with markers is the ABM4 run.
- The gray curve is the reference.
- The red dot is (5, y_m).
- The shading runs from the computed onset to t=5, and its legend label "h·|∂f/∂y| > 1.285" is valid over the whole span because |fy| is monotone.
- The title "ABM4 for y' = 1 - t·y^(1/3) … m = $m subintervals, h = 5/$m" matches f and m.
- The y(5), error, reference y(5) and onset annotations match the computed values listed above.

There is no clamping or NaN masking. The axis limits contain every computed point.

**Legacy fidelity.** The page reproduces Mathews' Example 11 animation: the same ODE, the same real cube root, and the same 21 m values. The y(5) labels match Mathews' to the digits he printed. The gray reference and the stability shading are additions and do not contradict the archive. The page quotes Example 11's worked n=50/100/150 values, and they agree with Mathews' printed tables. Mathews' Examples 1–10 are worked examples with no animation. Their absence falls under the page's planned Worked Example section and is not a dropped animation case.

