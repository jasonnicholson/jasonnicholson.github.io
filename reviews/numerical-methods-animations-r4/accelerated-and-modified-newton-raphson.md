# Accelerated & Modified Newton-Raphson — animation review (round 4)

Page: `pages/numerical-methods/accelerated-and-modified-newton-raphson/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page agrees with my own computation and with the frames. All three scripts implement the methods they name, and the drawn geometry matches the computed iterates.

These observations are not findings and need no change:

- In Float64, Case 2's $x_3 = 1 + 3.6\times10^{-12}$ and Case 3's $x_3 = 1 + 8.4\times10^{-12}$. Exact arithmetic gives $1 + 6.2\times10^{-12}$ and $1 - 5.5\times10^{-12}$. The difference comes from cancellation error in $f$ near the double root, where $f(x_3)$ evaluates to exactly 0 and the iteration stalls after that. The page claims only "equal to 1 to six decimals", which is true either way.
- The legend labels use subscript parentheses (`x₍1₎`). This is cosmetic and readable.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `accnewtonaa.jl` | 0 | 6.7 | accnewtonaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `accnewtonbb.jl` | 0 | 6.2 | accnewtonbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `accnewtoncc.jl` | 0 | 6.0 | accnewtoncc.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `accnewtonaa.gif` | 13 | byte-identical | accnewtonaa |
| `accnewtonbb.gif` | 6 | byte-identical | accnewtonbb |
| `accnewtoncc.gif` | 5 | byte-identical | accnewtoncc |

### Page references

- Scripts linked: `accnewtonaa.jl`, `accnewtonbb.jl`, `accnewtoncc.jl`
- GIFs embedded: 3
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Location | Claim (page wording) | Evidence | Verdict |
|---|---|---|---|---|
| D1 | Description | Standard N-R is quadratic at simple roots, linear at multiple roots because $f'(x^*)=0$ | Case 1 ratios $e_{n+1}/e_n \to 0.50000867$ (indep.py); sympy limit = 1/2 | confirmed |
| D2 | Description | Method A: $x_{n+1}=x_n-m f/f'$ recovers quadratic rate; needs $m$ | sympy: $\lim e_{n+1}/e_n^2 = 1/6$ for m=2; mp iterates $e/e^2 \to 0.16666667$ | confirmed |
| D3 | Description | If $f$ has root of multiplicity $m$, $h=f/f'$ has a simple root | $h=(x-1)(x+2)/(3(x+1))$, $h'(1)=1/2\neq0$ (sympy) | confirmed |
| D4 | Description | Newton on $h$ gives $x - ff'/(f'^2-ff'')$ | sympy: Newton-on-$h$ minus formula simplifies to 0 | confirmed |
| D5 | Description | Method B converges quadratically without knowing $m$ | mp: $e/e^2 \to -0.16666667$; sympy limit $-1/6$ | confirmed |
| I1 | Animations intro | Three methods applied to the same double root | All three scripts use $f=x^3-3x+2$, $x_0=1.2$, root 1 | confirmed |
| I2 | Intro | Line from curve at $x_n$ to axis intercept gives $x_{n+1}$ | Each script draws `[xn, xn1], [curve(xn), 0]` | confirmed |
| I3 | Intro | Cases 1 and 3: that line is the tangent to the plotted curve; Case 2: half the tangent slope | slopes.py: drawn slope / expected slope minus 1 is about 1e-15 (std, $f'$), about 1e-14 (acc, $f'/2$), about 1e-15 to 2e-6 (mod, $h'$; the last is the near-root roundoff step) | confirmed |
| I4 | Intro | Cases 1, 2 plot $f$; Case 3 plots $h=f/f'$ | aa/bb line 40/42 plot `f`; cc line 56 plots `h_plot`; frames show it | confirmed |
| I5 | Intro | Cases reproduce Mathews Examples 1(b), 2, 4, all at the double root of the same cubic | Archive lnk_3/4/6: $f=x^3-3x+2$, $p=1$, $p_0=1.2$, standard / accelerated m=2 / modified | confirmed |
| I6 | Intro | Ex 1(a) is standard N-R at the simple root of the cubic | Archive: $p=-2$, $p_0=-2.4$ | confirmed |
| I7 | Intro | Ex 3 (accelerated) and Ex 5 (modified) at a double and a triple root of a fifth-degree polynomial | Archive: $x^5-8x^4+25x^3-38x^2+28x-8 = (x-1)^2(x-2)^3$ (sympy) | confirmed |
| I8 | Intro | Ex 6: standard, accelerated, modified at a root of higher multiplicity | Archive: $f=-(x-2)(x-1)^6$, parts (a)(b)(c) | confirmed |
| C1.1 | Case 1 heading | Standard N-R, linear, $f=x^3-3x+2$, $x_0=1.2$ | aa.jl lines 11, 15, 27 | confirmed |
| C1.2 | Case 1 | $f=(x-1)^2(x+2)$, double root at 1 | sympy factor | confirmed |
| C1.3 | Case 1 | Asymptotic error constant $(m-1)/m=1/2$, each step halves the error | Ratios 0.515, 0.508, …, 0.500009 | confirmed |
| C1.4 | Case 1 | Near root $f\approx3(x-1)^2$; tangent meets the axis between $x_n$ and $x^*$, about halfway | $f''(1)/2 = 3$; $f$ convex for $x>0$, so every intercept stays right of 1; ratios about 0.5 | confirmed |
| C1.5 | Case 1 | Each step covers just under half the remaining distance | $e_{n+1}/e_n > 0.5$ for all n, so the fraction covered is $1 - \text{ratio} < 0.5$ | confirmed |
| C1.6 | Case 1 | Iterates 1.2, 1.10303, 1.052356, 1.026401 | Script: 1.2, 1.1030303, 1.0523564, 1.0264008; mp identical | confirmed |
| C1.7 | Case 1 | After 12 steps $x_{12}=1.000052$, about $5.2\times10^{-5}$ from the root | Script 1.0000520157, mp 1.0000520156 | confirmed |
| C1.8 | Case 1 | From $x_5$ on, the iterate is under 0.007 from the root and its marker covers the root | $e_5=0.006643$; frame_006 shows the marker over x=1 | confirmed |
| C1.9 | Case 1 alt | 12 iterations, from $x_5$ on the marker covers the root, progress only in the legend | 13 frames ($x_0$…$x_{12}$); frame_013 legend "x₍12₎ = 1.000052" | confirmed |
| C2.1 | Case 2 heading | Method A, m=2, quadratic, same $f$, $x_0$ | bb.jl lines 12, 16, 18, 29 | confirmed |
| C2.2 | Case 2 | Orange line from $(x_n,f(x_n))$ has slope $f'(x_n)/2$ and meets the axis twice as far as the Newton tangent | slopes.py ratios about 1; bb.jl line 49 `:darkorange`; frame_002 | confirmed |
| C2.3 | Case 2 | $\lvert e_{n+1}\rvert \approx C\lvert e_n\rvert^2$ | $C\to1/6$ | confirmed |
| C2.4 | Case 2 | $x_1=1.006061$, $x_2=1.000006$, $x_3$ equals 1 to six decimals | Script 1.0060606061, 1.0000061033, 1.0000000000036; mp 1.00606060606, 1.00000610333, 1+6.2e-12; archive 1.00606, 1.00001, 1. | confirmed |
| C2.5 | Case 2 alt | Steps twice the Newton step; quadratic convergence to 1; $x_3=1$ to six decimals | As above | confirmed |
| C3.1 | Case 3 heading | Method B, quadratic, same $f$, $x_0$ | cc.jl lines 14–16, 22–28, 31 | confirmed |
| C3.2 | Case 3 | Iteration formula = Newton on $h$ using $f,f',f''$ | sympy identity (D4); cc.jl line 27 | confirmed |
| C3.3 | Case 3 | Plots $h=(x-1)(x+2)/(3(x+1))$ | sympy: $f/f' - $ that expression is 0; the pole at $x=-1$ lies outside xlims (0.5, 2) | confirmed |
| C3.4 | Case 3 | Tangent lines dashed | cc.jl line 64 `ls=:dash`, black; frames show dashed segments | confirmed |
| C3.5 | Case 3 | $h$ nearly straight; first tangent lies almost on the curve; $x_1=0.994152$, just left of the root | Max gap between tangent and $h$ on $[x_1,x_0]$ is 0.0029 (y-range 1.0); $x_1$ script 0.99415205, mp 0.994152047, archive 0.994152 | confirmed |
| C3.6 | Case 3 | Overshoot and later steps too small to see at this scale | $\lvert e_1\rvert=0.0058$ on an x-range of 1.5, about 2 px; frames 2–5 look identical except the legend | confirmed |
| C3.7 | Case 3 | $x_2=0.999994$; $x_3$ equals 1 to six decimals | Script 0.99999428, mp 0.99999428, archive 0.999994; $x_3$: script 1+8.4e-12, mp 1−5.5e-12 | confirmed |
| C3.8 | Case 3 alt | Dashed tangent from $x_0$ lies almost on the curve, one step to 0.994152, quadratic, no $m$ needed | As above | confirmed |
| W1 | Wiring | Case 1 links/embeds `accnewtonaa.jl`/`.gif`; Case 2 `bb`; Case 3 `cc` | Script titles and parameters match each heading; the manifest says the GIFs are produced by these scripts | confirmed |

No claim was left undetermined.

### 3. Implementation checks

Commands (all run from the scratch folder):
- Iterates: `julia review/<s>_iter.jl` (the script's pre-animation section plus a print loop)
- Independent: `/usr/bin/python3 review/indep.py` (mpmath at 50 digits plus sympy)
- Geometry: `/usr/bin/python3 -I review/slopes.py`

### `accnewtonaa.jl`: standard Newton-Raphson
- **Method:** `xs[i+1] = xs[i] - f/fp` with $f'=3x^2-3$ correct. This is plain Newton-Raphson, as labelled.
- **Numbers:** script vs mp: $x_1$ 1.1030303030303028 / 1.1030303030303; $x_6$ 1.0033253746 / 1.00332537462646; $x_{12}$ 1.0000520156500807 / 1.00005201564977. The rounding difference at 1e-13 does not matter. Error ratios approach 0.5, the linear rate expected at a double root. All agree with the archive (1.10303, 1.05236, 1.0264, 1.01326, 1.00664, 1.00333).
- **Reference:** the root $x^*=1$ (double) is confirmed by sympy factorisation $(x-1)^2(x+2)$.
- **Picture:** the tangent segment from $(x_n,f(x_n))$ to $(x_{n+1},0)$ has slope equal to $f'(x_n)$ to 1e-15, and the vertical drop to the curve and the marker at $(x_n,f(x_n))$ are correct. The legend index matches the frame. The axis window (0.7–1.8) contains all iterates. 13 frames.

### `accnewtonbb.jl`: accelerated Newton, m=2
- **Method:** `xs[i] - m*f/fp` with m=2. This is Method A as described.
- **Numbers:** script vs mp: $x_1$ 1.0060606060606054 / 1.00606060606061; $x_2$ 1.0000061033293672 / 1.00000610332937; $x_3$ 1+3.6e-12 / 1+6.2e-12 (float cancellation, see the note under Findings). $e/e^2 \to 1/6$, matching the sympy limit. The archive gives 1.00606, 1.00001, 1., and its long-precision values $p_1, p_2$ agree to all digits shown.
- **Reference:** $x^*=1$.
- **Picture:** the orange segment's slope equals $f'(x_n)/2$ (relative error 1e-14), so it is correctly drawn as not the tangent. $x_3$ to $x_5$ stall because $f(x_3)=0.0$ exactly in Float64; the legend shows 1.0, consistent with the page. 6 frames.

### `accnewtoncc.jl`: modified Newton (Newton on $h=f/f'$)
- **Method:** `x - f*fp/(fp^2 - f*fpp)` with $f''=6x$. By sympy this is identical to Newton applied to $h$, so it is Method B (Mathews' "modified Newton-Raphson", archive gr_244: $g = x - h/h'$).
- **Numbers:** script vs mp: $x_1$ 0.9941520467836247 / 0.994152046783626; $x_2$ 0.9999942779650373 / 0.999994277965015; $x_3$ 1+8.4e-12 / 1−5.5e-12 (float noise; Mathews' own float run gives 0.99999999999454). $e/e^2 \to -1/6$, which is quadratic.
- **Reference:** $h$ in its simplified form `h_plot` equals $f/f'$ (sympy difference 0), with the removable singularity at 1 and the pole at −1 outside the window.
- **Picture:** the dashed segment from $(x_n,h(x_n))$ to $(x_{n+1},0)$ has slope equal to $h'(x_n)$ ($h'$ verified symbolically) for n=0,1. At n=2 the relative difference is 2.4e-6, because the step is at roundoff scale, and the segment is invisible. The marker sits at $(x_n, h(x_n))$. The tangent at $x_0$ stays within 0.003 of the curve, so "lies almost on the curve" is accurate. 5 frames.

