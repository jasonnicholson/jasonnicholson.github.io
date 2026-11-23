# Numerical Differentiation — animation review (round 6)

Page: `pages/numerical-methods/numerical-differentiation/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I found no Error, Misleading, Minor or Fidelity findings.

The following observations do not meet the bar for a finding. They are recorded so that the owner can see they were considered:

- **Example 14 is drawn the Example 11 way.** Case 2 says it "follows Examples 11 and 14". Mathews' Example 14 solution and the legacy animation `CentralD1faa.gif` also draw the quadratic through the three stencil points, and draw a line with the secant slope through $(x_0,f(x_0))$. The script draws only the chord through $(x_0\pm h, f(x_0\pm h))$, which is how Example 11 and the legacy `CentralDfaa.gif` draw it. Both examples compute the identical quotient, so the numbers and the page claim agree. The parabola is a teaching device whose absence is a design choice, not an error.
- **Plot window and steps differ from the legacy animations.** The legacy animations used the window $[0,2.1]$ and steps $h = 1.0,\dots,0.001$; Example 14 used $h\in\{0.5,0.2,0.1,0.05,0.02,0.01\}$. Case 2 uses the window $[0,\pi]$ and its own step sequence. The page does not claim either setting. Where the steps overlap, the values agree with the legacy frames to all six printed digits: $h=0.6 \to -0.049354$ and $h=0.4 \to -0.083592$.
- **Forward and backward animations are not reproduced.** The archive has animations for the forward and backward differences (`ForwardD1f`, `ForwardD2f`, `BackwardD1f`, `BackwardD2f`). The page explicitly says that Examples 9, 10, 12 and 13 are not animated. That is not silent, so it is not a fidelity finding.
- **Case 1's later frames look the same.** From $h\approx0.05$ on, the Case 1 frames are visually indistinguishable: the curves overlap and only the title's max-error value changes. This is the true behaviour, and the title carries the information. It does not mislead.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `numdiffaa.jl` | 0 | 7.3 | numdiffaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `numdiffab.jl` | 0 | 7.9 | numdiffab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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
| 1 | Description ¶1 | Mathews' test function is $f(x)=e^{-x}\sin(x)$ | Archive gr_27, gr_220 … gr_388: `f[x] = e^-x Sin[x]` | confirmed |
| 2 | Description ¶1 | on $[0,\pi]$ | Archive gr_30, gr_49, gr_51: `[0, π]` | confirmed |
| 3 | Description ¶1 | representative steps $h=0.1,0.01,0.001$ | Archive gr_45, gr_47 | confirmed |
| 4 | Description | $D_3(x,h)=\frac{f(x+h)-f(x-h)}{2h}$ is the three-point central approximation | Archive gr_4; both scripts: `central3`, `msec = (yr - yl)/(2h)` | confirmed |
| 5 | Description | truncation error $O(h^2)$ | `indep.py`: err/h² at $x_0=1$ tends to 0.169442, which equals $f'''(1)/6 = 0.169442$; halving ratios 4.00065 and 4.00003 | confirmed |
| 6 | Description | as $h$ decreases truncation error improves, but eventually roundoff can limit accuracy | float64 at $x_0=1$: err is 1.69e-7 at h=1e-3, 1.67e-11 at h=1e-5, 5.2e-10 at h=1e-8, so the error rises again at small h. A general statement; the animations don't claim to show it. | confirmed |
| 7 | Animations intro | each animation shows derivative behaviour for $f(x)=e^{-x}\sin x$ | Both scripts define `f(x) = exp(-x) * sin(x)`; frame titles and legends agree | confirmed |
| 8 | Animations intro | "on legacy interval settings from the source module" | Case 1 uses $[0,\pi]$, as in Example 2(c). Case 2's window $[0,\pi]$ is the module's Project I interval; the legacy Ex 11/14 plots used $[0,2.1]$. Loosely true; the claim has no numeric consequence. | confirmed (loose) |
| 9 | Animations ¶2 | Case 1 extends Example 2(c), "the plot of $D_3(x,h)$ against $f'(x)$ on $[0,\pi]$, from the single step $h=0.01$ to a sequence of steps" | Archive gr_48 `D1[x, 0.01]`, gr_85–90 (two plots on $[0,\pi]$); script `hs` includes 0.01 among 12 steps | confirmed |
| 10 | Animations ¶2 | Case 2 follows Examples 11 and 14, the central difference at $x_0=1$ | Archive gr_262/263 and gr_325/326: `f'[1.0]`; Ex 14 code gr_327 uses $(f(X+h)-f(X-h))/(2h)$ with X=1.0; script `x0 = 1.0` | confirmed (see the note on the parabola) |
| 11 | Animations ¶2 | Example 1 is "the graph of $f'''$ used to bound the error" | Archive Ex 1 text: find $f^{(3)}$, graph it, find $M_3$ | confirmed |
| 12 | Animations ¶2 | Examples 2(a), 2(b) are tables of approximations | Archive: 2(a) $f'(0)$ for three h "include the details"; 2(b) $f'(0..3)$ table (gr_83/84) | confirmed |
| 13 | Animations ¶2 | Example 3 plots the absolute error against the error bound | Archive Ex 3/3(a)/3(b) text | confirmed |
| 14 | Animations ¶2 | Example 4 studies how the bound shrinks with $h$ | Archive Ex 4 text | confirmed |
| 15 | Animations ¶2 | Examples 9, 10, 12, 13 are the forward and backward first-derivative formulas | Archive: 9 two-point forward, 10 two-point backward, 12 three-point forward, 13 three-point backward | confirmed |
| 16 | Animations ¶2 | Project II, Examples 5–8, and Examples 15–17 are second-derivative formulas | Archive: gr_12 $D2$, Ex 5–8 text; Ex 15–17 `f''[1.0]` | confirmed |
| 17 | Case 1 heading | central derivative profile $D_3(x,h)$ on $[0,\pi]$ | `numdiffaa.jl:12,16,25`; frames show $x\in[0,\pi]$ | confirmed |
| 18 | Case 1 Behavior | the numerical derivative curve approaches $f'(x)$ as $h$ shrinks | Max error decreases monotonically: 8.13e-2, 2.97e-2, 1.33e-2, 3.33e-3, 1.63e-3, 8.33e-4, 3.00e-4, 1.33e-4, 3.33e-5, 8.33e-6, 1.33e-6, 3.33e-7 (script and `indep.py` agree) | confirmed |
| 19 | Case 1 Behavior | consistent with second-order truncation error | Max error ≈ $h^2/3 = M_3h^2/6$ with $M_3=|f'''(0)|=2$; ratios h 0.1→0.05: 3.997, 0.01→0.005: 4.000 | confirmed |
| 20 | Case 1 link/embed | `numdiffaa.jl` / `numdiffaa.gif` | Committed GIF is byte-identical to the regenerated GIF (md5 6e7f3a7b…) | confirmed |
| 21 | Case 1 alt text | central approximation vs true derivative over 0 to π as h decreases | Frames: black $f'$, blue $D_3$, $h$ decreasing 0.5→0.001 | confirmed |
| 22 | Case 1 frames | title "max error ≈ …" for each h | All 12 titles match independent values to 3 s.f. (table in §3) | confirmed |
| 23 | Case 2 heading | secant to tangent at $x_0=1$, $h\to0$ | `x0 = 1.0`; $h$ goes 0.6→0.001 | confirmed |
| 24 | Case 2 Behavior | the slope $(f(x_0+h)-f(x_0-h))/(2h)$ converges to $f'(x_0)$ as the stencil contracts | Error decreases monotonically 0.06144 → 1.69e-7 (table in §3) | confirmed |
| 25 | Case 2 link/embed | `numdiffab.jl` / `numdiffab.gif` | Byte-identical regeneration (md5 83a22727…) | confirmed |
| 26 | Case 2 alt text | central secant lines through the points at $x_0\pm h$ collapsing to the tangent at $x_0=1$ | Instrumented residuals of the secant line at $x_l$ and $x_r$ are 0 and ≤2.8e-17; frames show the dashed chord through the outer orange points converging to the red tangent | confirmed |
| 27 | Case 2 frames | title "secant slope ≈ …, true = −0.110794" | $f'(1) = -0.110793765307$ (40-digit), so −0.110794 is correct; all 12 secant values match (table in §3) | confirmed |
| 28 | Derivation Notes | $f(x\pm h) = f \pm hf' + \tfrac{h^2}{2}f'' \pm \tfrac{h^3}{6}f^{(3)}(\xi_\pm)$ | `taylor.py`: the required $f'''(\xi)$ lies in the range of $f'''$ on $[x,x\pm h]$ for $x\in\{0,1,2\}$, $h\in\{0.5,0.1\}$, both signs (12/12 True) | confirmed |
| 29 | Derivation Notes | this leads to the central rule with error $\propto h^2$ | Subtracting gives error $\tfrac{h^2}{12}(f'''(\xi_+)+f'''(\xi_-))$; numerics in rows 5 and 19 | confirmed |
| 30 | Page wiring | linked from the section index | Manifest: yes | confirmed (from manifest) |

### 3. Implementation checks

### `numdiffaa.jl` (Case 1)

- **The method it claims to be.** Line 12, `central3(x,h) = (f(x+h)-f(x-h))/(2h)`, is the standard central difference, the same as Mathews' `D1[x,h]` (gr_4). The script evaluates it on 700 points of $[0,\pi]$ and uses values of $f$ outside the interval near the ends. Mathews' 2(c) does the same.
- **The numbers are right.** I compared the instrumented script (`aa_instr.jl`) with `indep.py` at 40-digit mpmath, using the same 700-point grid plus a continuous refinement:

| h | script max err (grid) | independent grid max | independent continuous max | $h^2/3$ | title |
|---|---|---|---|---|---|
| 0.5 | 0.0812767083 | 0.081276708 | 0.081277022 (x≈0.025) | 0.08333 | 8.13e-02 |
| 0.3 | 0.0297312685 | 0.029731268 | 0.029731268 | 0.03 | 2.97e-02 |
| 0.2 | 0.0132801083 | 0.013280108 | 0.013280112 | 0.013333 | 1.33e-02 |
| 0.1 | 0.0033299984 | 0.0033299984 | same (x=0) | 0.003333 | 3.33e-03 |
| 0.07 | 0.0016325328 | 0.0016325328 | same | 0.001633 | 1.63e-03 |
| 0.05 | 8.3312498e-4 | 8.3312498e-4 | same | 8.3333e-4 | 8.33e-04 |
| 0.03 | 2.9997300e-4 | 2.999730e-4 | same | 3.0e-4 | 3.00e-04 |
| 0.02 | 1.3332800e-4 | 1.333280e-4 | same | 1.3333e-4 | 1.33e-04 |
| 0.01 | 3.3333000e-5 | 3.3333e-5 | same | 3.3333e-5 | 3.33e-05 |
| 0.005 | 8.3333125e-6 | 8.3333125e-6 | same | 8.3333e-6 | 8.33e-06 |
| 0.002 | 1.3333328e-6 | 1.3333328e-6 | same | 1.3333e-6 | 1.33e-06 |
| 0.001 | 3.3333330e-7 | 3.333333e-7 | same | 3.3333e-7 | 3.33e-07 |

  The grid maximum agrees with the continuous maximum to the 3 significant figures shown. The halving ratios are ≈4, which confirms order 2.
- **Its reference values are right.** sympy gives $f'(x) = \sqrt2 e^{-x}\cos(x+\pi/4) = e^{-x}(\cos x - \sin x)$, the script's `fp`. $f''' = 2\sqrt2 e^{-x}\sin(x+\pi/4)$, so $f'''(0)=2$, which is consistent with max error $\approx h^2/3$ at $x=0$.
- **The picture shows what was computed.** In frames 1, 4, 6, 9 and 12, black is $f'$ and blue is $D_3$, and the titles match the table. The axis limits are $[0,\pi]\times[-1,1.1]$. The largest value drawn is $D_3(0,0.5)=\sin(0.5)(e^{0.5}+e^{-0.5})=1.081$, which is inside the limits, so nothing is clipped. Regenerated output is byte-identical to the committed GIF, both by the manifest and by my own md5 of the instrumented copy's output.

### `numdiffab.jl` (Case 2)

- **The method it claims to be.** Line 34 computes `msec = (yr - yl)/(2h)` with `yl=f(x0-h)` and `yr=f(x0+h)`, which is the central difference at $x_0=1$. The `continue` guard at line 26 never fires, since $x_0\pm0.6 = 0.4, 1.6$ lies inside $[0,\pi]$, so there are 12 frames for 12 steps.
- **The numbers are right.** The instrumented script (`ab_instr.jl`) and `indep.py` (40 digits) agree:

| h | script msec | independent | title (6 dp) | err | err/h² |
|---|---|---|---|---|---|
| 0.6 | −0.0493537427 | −0.04935374268 | −0.049354 | 0.06144 | 0.17067 |
| 0.4 | −0.0835918101 | −0.08359181012 | −0.083592 | 0.027202 | 0.17001 |
| 0.25 | −0.1001894114 | −0.1001894114 | −0.100189 | 0.010604 | 0.16967 |
| 0.15 | −0.1069794600 | −0.10697946 | −0.106979 | 3.8143e-3 | 0.16953 |
| 0.1 | −0.1090989768 | −0.1090989768 | −0.109099 | 1.6948e-3 | 0.16948 |
| 0.07 | −0.1099634110 | −0.109963411 | −0.109963 | 8.3035e-4 | 0.16946 |
| 0.05 | −0.1103701372 | −0.1103701372 | −0.110370 | 4.2363e-4 | 0.16945 |
| 0.03 | −0.1106412645 | −0.1106412645 | −0.110641 | 1.525e-4 | 0.16945 |
| 0.02 | −0.1107259879 | −0.1107259879 | −0.110726 | 6.7777e-5 | 0.16944 |
| 0.01 | −0.1107768211 | −0.1107768211 | −0.110777 | 1.6944e-5 | 0.16944 |
| 0.005 | −0.1107895293 | −0.1107895293 | −0.110790 | 4.2361e-6 | 0.16944 |
| 0.001 | −0.1107935959 | −0.1107935959 | −0.110794 | 1.6944e-7 | 0.16944 |

  err/h² tends to $f'''(1)/6 = 0.169442$, as second-order theory predicts. The legacy frames give the same values for the shared steps: −0.049354 (h=0.6), −0.083592 (h=0.4) and −0.110794 (h=0.001). The legacy Example 14 values at h=0.1, 0.05, 0.02 and 0.01 (−0.109099, −0.11037, −0.110726, −0.110777) also agree.
- **Its reference values are right.** $f'(1) = e^{-1}(\cos1-\sin1) = -0.110793765307$ (sympy/mpmath). The script prints −0.110794, which is correct. Mathews gr_329 gives the same value.
- **The picture shows what was computed.** The secant (line 38) is $y_l + m_{sec}(x-x_l)$. The instrumented residuals at $x_l$ and $x_r$ are 0 and ≤2.8e-17, so it is the chord through both outer stencil points. The tangent (line 39) passes through $(1, f(1))$ with slope $f'(1)$; its ends are at 0.409 and 0.210, matching the red line in frame 1. In frame 1 the secant ends are at 0.276 (x=0.1) and 0.187 (x=1.9), matching the dashed line. The three orange points are at $x_0-h$, $x_0$ and $x_0+h$. $f$ peaks at $f(\pi/4)=0.3224$, inside the limits of −0.1 to 0.55, so nothing is clipped. Frame titles match the table. Regeneration is byte-identical (md5 83a22727…).

