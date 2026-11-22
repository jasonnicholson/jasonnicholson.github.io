# Runge-Kutta Method — animation review (round 2)

Page: `pages/numerical-methods/runge-kutta-method/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1. Fidelity, Minor: the legacy step-size sweep has been replaced by a single fine-step trace

- **Location:** `index.qmd` lines 12 and 16–22 (the one case), and `rungekuttaaa.jl` as a whole.
- **What the page has now:** one animation. It traces a single RK4 solution with h = 0.0625 (n = 80) from left to right, four steps per frame. The way accuracy depends on step size appears only in the prose of the Behavior paragraph: the threshold h ≈ 0.0675, and y(5) ≈ 0.289 at h = 0.25.
- **What the legacy animation is:** every frame of the legacy `RungeKuttaaa.gif` (36 frames, titled "Runge-Kutta Method, RK4 / Numerically Approximate the solution to the D.E. y' = 1 − t∛y") is a complete RK4 solution on [0, 5] for a growing number of subintervals m, with the value of y(5) printed on it. The values visible on the contact sheet are m = 12, 14, 18, 20, 28, 32, 40, 44, 52, 70, 100 and 150. The coarse-m frames show the solution oscillating and climbing after t ≈ 3, and the curve settles to y(5) = 0.0081201 by m = 150. The legacy animation therefore teaches convergence as the step is refined, and shows instability at coarse steps. The new GIF shows neither. It looks like a static plot of the correct solution being drawn in.
- **How I know:** `julia .../r2/tools/giftools.jl .../RungeKutta1/RungeKuttaaa.gif review/legacy` gave 36 frames, which I viewed in `legacy/sheet.png` and `legacy/frame_036.png`. I wrote an independent RK4 in Python with the same ODE and n = m. It reproduces every legacy y(5) to all 7 printed digits:
  ```
  m=12 0.5883471   m=14 0.4685529   m=18 0.3316264   m=20 0.2891074
  m=28 0.1108585   m=32 0.1082442   m=40 0.0698482   m=44 0.0604713
  m=52 0.0376958   m=70 0.0081476   m=100 0.0081213  m=150 0.0081201
  ```
  This confirms that the equation and method match Mathews', and that only the format of the animation changed.
- **Why Minor and not higher:** the page is not silently wrong. Its prose does state the coarse-step behaviour correctly, and its h = 0.25 value of 0.289 is the legacy m = 20 frame. But the archive's visible teaching point is missing from the animation, and the page does not say that it departs from the archive.
- **Suggested correction:** add a second case, for example `rungekuttabb.jl`, that animates complete RK4 solutions for m = 12, 14, 18, 20, 28, 32, 40, 44, 52, 70, 100, 150, with y(5) shown in each frame and the reference solution as a faint backdrop. Alternatively, add one sentence saying that the legacy animation swept the number of subintervals and that this page shows a single converged step size instead.

No other findings.

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `rungekuttaaa.jl` | 0 | 5.9 | rungekuttaaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `rungekuttaaa.gif` | 21 | byte-identical | rungekuttaaa |

### Page references

- Scripts linked: `rungekuttaaa.jl`
- GIFs embedded: 1
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

Each claim is quoted in the page's own words, with its verdict and the evidence. "Exact" below means the reference solution I computed independently in two ways that agree to about 1e-16: scipy DOP853 with rtol 1e-13, and mpmath `odefun` (Taylor series, 30 digits). The ODE has no elementary closed form.

| # | Claim (page text) | Verdict | Evidence |
|---|---|---|---|
| 1 | Intro: "IVP $y' = 1 - t\sqrt[3]{y}$, $y(0)=1$ over $[0,5]$" | Confirmed | Script line 9: `f(t,y)=1.0 - t*cbrt(y)`; lines 10–11: `t0,y0=0,1`, `T=5`. |
| 2 | "Each frame adds four RK4 steps (0.25 in $t$)" | Confirmed | `stride=4`, h = 0.0625, so 4h = 0.25. Frames are at `1:4:81`. The frame annotations read t = 0, 0.25, …, 5.0 (instrumented run). Frame 1 shows only the initial point. |
| 3 | "the connecting curve passes through every computed point" | Confirmed | `plot!(ts[1:frame], ys[1:frame])` is a polyline through all computed points up to the current one. |
| 4 | "RK4 computes four slope estimates ($k_1..k_4$) per step and takes a weighted average" | Confirmed | Script lines 27–32 use classical RK4 with weights (1, 2, 2, 1)/6. |
| 5 | "$O(h^5)$ local truncation error and $O(h^4)$ global error" | Confirmed | Global error at t = 5 for n = 80, 160, 320, 640: 6.80e-6, 1.30e-7, 5.97e-9, 3.20e-10. The ratios 52, 22, 18.6 tend towards 16 (the step is still pre-asymptotic at n = 80). The same routine on y' = y over [0, 1] gives ratios 15.3 and 15.7. |
| 6 | "Julia source scripts … are linked under each case" | Confirmed | `[Julia source](rungekuttaaa.jl)` sits under Case 1. (The intro's plural, "Each animation below" and "these animations", is used for a page with a single animation. This is wording only and not a finding.) |
| 7 | Heading: "Case 1 — RK4, $y'=1-t\sqrt[3]{y}$, $y(0)=1$, $n=80$ steps ($h=0.0625$)" | Confirmed | Script line 12: `n = 80`; h = 5/80 = 0.0625. |
| 8 | "$f$ pulls $y$ toward the nullcline $y=1/t^3$ (where $y'=0$)" | Confirmed | $1-ty^{1/3}=0 \iff y=t^{-3}$. Below it y' > 0 and above it y' < 0, so the solution is drawn towards it. The exact y(5) = 0.008120 against 1/125 = 0.008. |
| 9 | "RK4 values stay within $1.3\times10^{-5}$ of the exact solution" | Confirmed | Maximum \|y_RK4 − y_exact\| over all 81 nodes is 1.2891e-5, at t = 3.3125 (`check.py`). |
| 10 | "$y(5)\approx0.0081267$" | Confirmed | Script value 0.0081267250050895 (instrumented copy). My independent Python RK4 gives 0.008126725005089533. |
| 11 | "against the exact $0.0081199$" | Confirmed | DOP853 0.008119920464867977; mpmath 0.008119920464867961. |
| 12 | "RK4's stability limit $2.785$" | Confirmed | Real root of \|1 + z + z²/2 + z³/6 + z⁴/24\| = 1 on the negative axis: z = −2.7852936 (`stab.py`). |
| 13 | "$\partial f/\partial y=-t/(3y^{2/3})$" | Confirmed | d/dy[1 − t·y^{1/3}] = −t/(3y^{2/3}). |
| 14 | "reaches $-41.3$ at $t=5$" | Confirmed | Along the exact solution J(5) = −41.2554. \|J\| increases monotonically on (0, 5], so t = 5 is where it is largest. |
| 15 | "For steps longer than about $h=0.0675$, $h\|\partial f/\partial y\|$ exceeds … 2.785 before $t=5$" | Confirmed | 2.7852936/41.2554 = 0.067513. |
| 16 | "just above $h=0.0675$ this affects only the last steps" | Confirmed | n = 74 (h = 0.0676): onset at t = 4.9987, error at t = 5 is 1.44e-5. n = 70: onset at 4.908, error 2.76e-5. The run is still accurate, with only the last step or steps affected. |
| 17 | "at $h=0.25$ ($n=20$) it starts at $t\approx3.34$" | Confirmed | Solving 0.25·\|J(t)\| = 2.78529 along the exact solution gives t = 3.3416. |
| 18 | "the computed values turn upward after $t=3.25$" | Confirmed | n = 20 values: y(3.0) = 0.0913584, y(3.25) = 0.0499826 (the minimum), y(3.5) = 0.0974962, then 0.1221, 0.1342, 0.1567, 0.2457, 0.1603, 0.2891. They rise overall but zigzag at the end (0.2457 → 0.1603 → 0.2891). "Turn upward" is a fair summary. |
| 19 | "and end at $y(5)\approx0.289$" | Confirmed | 0.2891074. This is also the legacy m = 20 frame value. |
| 20 | Alt text: "step h = 0.0625 … builds from left to right, four RK4 steps per frame" | Confirmed | Frames 1–21 viewed (contact sheet, frames 1 and 21). |
| 21 | Alt text: "rising to about 1.45 near t = 0.9" | Confirmed | Computed maximum 1.44973 at the node t = 0.875. The exact maximum is 1.44977 at t = 0.8836. |
| 22 | Alt text: "falling smoothly toward y ≈ 0.0081 at t = 5" | Confirmed | Final frame shows "t=5.0 y≈0.0081". The curve is monotone after the peak (node values listed in §3). |
| 23 | Wiring: link `rungekuttaaa.jl`, embed `rungekuttaaa.gif` | Confirmed | Manifest: the scratch regeneration of `rungekuttaaa.jl` is byte-identical to the committed `rungekuttaaa.gif`, with 21 frames. The script writes exactly that filename. |
| 24 | GIF title "RK4, h = 0.0625: y' = 1 - t·y^(1/3), y(0) = 1" | Confirmed | Matches `f`, `y0` and `h` in the code. The h in the title is a hard-coded string, but it equals the computed h. |
| 25 | Method description (Description section) | Not applicable | The page has no `## Description` section. The only method statement is claim 4. A missing section is absent content and is not a finding under the standard. |

---

### 3. Implementation checks: `rungekuttaaa.jl`

**It is the method it claims to be.** Lines 25–33 are the classical fourth-order Runge–Kutta method: k1 at (t, y), k2 and k3 at the midpoint using k1/2 and k2/2, k4 at t + h using k3, and weights (1, 2, 2, 1)/6. It uses a fixed step, with no adaptivity and no hidden variant. Its order is confirmed by behaviour rather than from memory: error ratios on step halving tend towards 16 on this problem (52, 22, 18.6 for n = 80→160→320→640) and are 15.3 and 15.7 on y' = y. The 12 legacy Mathews RK4 values of y(5) are reproduced to 7 digits by the same formula (F1), which independently confirms it is Mathews' RK4 on Mathews' ODE.

**The numbers are right.** I made an instrumented copy (`review/instr.jl`, the script's compute block with plotting removed) and set its output beside an independent Python RK4 (`review/check.py`):

| t | script y | independent RK4 | exact |
|---|---|---|---|
| 0.25 | 1.2172625228 | 1.2172625 | 1.2172625 |
| 1.00 | 1.4421683531 | 1.4421684 | 1.4421684 |
| 2.00 | 0.8595887550 | 0.8595888 | 0.8595887 |
| 3.00 | 0.0898360833 | 0.0898361 | 0.0898317 |
| 3.25 | 0.0384728053 | 0.0384728 | 0.0384600 |
| 4.00 | 0.0162376507 | 0.0162377 | 0.0162357 |
| 5.00 | 0.0081267250050895 | 0.008126725005089533 | 0.0081199205 |

The script and the independent RK4 agree to machine precision. The script prints 21 frames, h = 0.0625, and a maximum of 1.44973 at t = 0.875.

**Its reference values are right.** The script draws no reference curve. The page quotes the exact y(5) = 0.0081199. I checked it with two independent integrators: DOP853 at rtol 1e-13 gives 0.008119920464867977, and mpmath `odefun` at 30 digits gives 0.008119920464867961. They also agree at t = 1…5 to about 1e-13. y stays positive on [0, 5], so `cbrt` and y^{2/3} are smooth along the solution and the order and stability statements apply.

**The picture shows what was computed.** I viewed the contact sheet and frames 1 and 21. Each frame draws the polyline `ts[1:frame], ys[1:frame]` with a red marker at `(ts[frame], ys[frame])`. The annotation "t=… y≈…" reports the same index `frame`, and I checked its values against the instrumented output (for example t = 3.5 y≈0.0254, and t = 5.0 y≈0.0081). The axes, xlims (−0.1, 5.1) and ylims (−0.05, 1.8), contain the whole solution: the peak at 1.45 and the end point at (5, 0.0081) are both inside. There is no clamping or NaN masking. The annotation at y = 1.7 stays clear of the curve. There are 21 frames at 3 fps. The plot is accurate, and the only gap is the fidelity point in F1: it shows nothing about how the result depends on step size.

