# Accelerated & Modified Newton-Raphson — animation review (round 7)

Page: `pages/numerical-methods/accelerated-and-modified-newton-raphson/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Errors: 0. Misleading: 0. Minor: 0. Fidelity: 0.

Five things were examined closely and judged not to be findings. They are recorded so the owner can overrule that judgement.

1. **Case 3, "that overshoot and the later steps are too small to see."** The $x_1$ marker centre is 2.60 px from the root's pixel, and the marker hops 2.60 px between the $x_1$ and $x_2$ frames. A viewer stepping through frames can just detect the hop (`zoom.png`, left pair). The marker (red radius about 4.5 px) still covers the root in both, the side and size of the overshoot cannot be read from the plot, and the page gives the value. The sentence's practical meaning holds.
2. **Case 1, "the remaining halvings show only in the legend value."** After $x_5$ the marker still moves 1.50 px ($x_5 \to x_6$), 0.84 px ($x_6 \to x_7$), then under 0.6 px per frame. These are sub-marker shifts with the root covered throughout. Same judgement as item 1.
3. **Round-off in the plotted late iterates.** Case 3's script gives $x_3 = 1.0000000000083733$; the exact iterate is $0.99999999999454$, on the other side of the root. Case 2's script gives $x_3 = 1.0000000000036071$ against the exact $1.0000000000062084$. This is the expected limit of evaluating the expanded cubic near a double root (the archive's own printed floating-point run shows the same value, $1.000000000003609$, for Example 2, while its table has $1.00000000000621$). The page states these only "to six decimals", which is true for both.
4. **Frozen last frames.** In Cases 2 and 3, $f(x_3)$ evaluates to exactly 0.0 in Float64, so $x_4$ (and $x_5$ in Case 2) equal $x_3$ and those frames add nothing. The page does not claim otherwise, and the legend's 1.0 is right to the displayed six decimals.
5. **Legend index glyphs.** The label `x₍5₎` renders with small parentheses around the index. It is readable and correct.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `accnewtonaa.jl` | 0 | 7.5 | accnewtonaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `accnewtonbb.jl` | 0 | 6.1 | accnewtonbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `accnewtoncc.jl` | 0 | 5.8 | accnewtoncc.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

Verdicts: **C** confirmed, **W** wrong, **ND** could not determine. No entry is W or ND.

### Description (lines 12–22)

| # | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|
| D1 | Newton "converges quadratically at simple roots" | Cubic at simple root $-2$ from $-2.4$: errors 0.4, 0.0762, 0.0036, 8.59e-6, 4.92e-11; $e_{n+1}/e_n^2 \to 0.666667$ (`general.py`) | C |
| D2 | "degrades to linear convergence at multiple roots, because $f'(x^*)=0$" | Error ratios: $m=2$ 0.5000, $m=3$ 0.674 and falling toward 2/3, $m=6$ 0.832 toward 5/6; $f'(1)=0$ | C |
| D3 | "Two methods restore quadratic convergence" | A and B have $e_{n+1}/e_n^2$ converging to a finite constant at $m=2,3,6$ (D5, D8) | C |
| D4 | Method A formula $x_{n+1}=x_n-m\,f/f'$ | Same as archive theorem (gr_114) and `accnewtonbb.jl:29` | C |
| D5 | A "recovers the quadratic rate" | Constants: cubic $m=2$ 1/6; quintic $m=2$ 1.5; quintic $m=3$ 0.666667; septic $m=6$ 0.166667 | C |
| D6 | A "requires knowing $m$ in advance" | The formula contains $m$ | C |
| D7 | If $f$ has multiplicity $m$, $h=f/f'$ has a simple root | Symbolic $h'(\text{root}) = 1/2, 1/3, 1/6$ for $m = 2,3,6$ (nonzero) | C |
| D8 | Newton on $h$ equals $x - ff'/(f'^2-ff'')$; quadratic without $m$ | `sympy` difference simplifies to 0 for the cubic; matches archive gr_229new; constants at $m=2,3,6$: 1/6, 1.5, 2/3, and $m=6$ errors 0.2, 0.0103, 1.81e-5, 5.45e-11, 4.95e-22 | C |
| D9 | Both need smoothness and "$x_0$ close enough" | From $x_0=-1.5$ and $-3$, A does not reach 1 (after 40 steps it sits at $-1.86$ and $-2.17$), and B goes to the other root $-2$ (`far_start.py`) | C |

### Animations introduction (lines 26–31)

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| I1 | Three animations, one method each, "same double root" | Three scripts, same $f$, root $x=1$; `sympy` factor $(x-1)^2(x+2)$ | C |
| I2 | Line from curve at $x_n$ to axis intercept traces $x_{n+1}$ | All plotted sloped series run $(x_n,\text{curve}(x_n)) \to (x_{n+1},0)$; no mismatch in 12, 3, 3 segments (`series_check.jl`) | C |
| I3 | Cases 1 and 3: tangent to plotted curve | Drawn slope vs $f'(x_n)$: relative difference at most 1.54e-12 over 12 steps. Vs $h'(x_n)$: 4.95e-15, 3.73e-12, 2.42e-6 (last is round-off at $x_2 \approx 1$) | C |
| I4 | Case 2: half the tangent slope | Drawn 0.66, 0.018236915, 1.8310044e-5 equal $f'(x_n)/2$ to at most 9.05e-12 relative | C |
| I5 | Cases 1, 2 plot $f$; Case 3 plots $h$ | `aa:40`, `bb:42`, `cc:56`; frames | C |
| I6 | $h$ has a simple root where $f$ has a double root | $h'(1)=1/2$ | C |
| I7 | Source scripts generated the animations | Committed GIFs byte-identical to scratch regeneration (`cmp`) and scripts identical to the regen copies (`diff`) | C |
| I8 | Cases reproduce Examples 1(b), 2, 4, all at the double root of the same cubic | Archive gr_31/gr_119/gr_234: $x^3-3x+2$; $p=1$; $p_0=1.2$. Iterates agree: 1(b) 1.10303, 1.05236, 1.0264; Ex 2 1.00606, 1.00001, 1.; Ex 4 0.994152, 0.999994, 1. | C |
| I9 | Example 1(a): standard Newton at the simple root of that cubic | gr_32 $p=-2$, gr_33 $p_0=-2.4$ | C |
| I10 | Examples 3, 5: accelerated, modified at a double and a triple root of a fifth-degree polynomial | gr_160, gr_276; factors as $(x-2)^3(x-1)^2$; lnk_5 and lnk_7 treat $p=1$ and $p=2$ | C |
| I11 | Example 6: standard, accelerated, modified at a root of higher multiplicity | gr_334 factors as $-(x-2)(x-1)^6$; lnk_8–10 are the three methods; $m=6$ in gr_391. (The archive's prose says "double root" there; the page is right) | C |
| I12 | Those examples "are not animated here" | Only three scripts and GIFs; disclosed, so not a silent drop | C |

### Case 1 (lines 33–39)

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| 1a | Heading: standard Newton, $f=x^3-3x+2$, $x_0=1.2$ | `aa:11,15,27` | C |
| 1b | Linear convergence | $e_n/e_{n-1}$: 0.51515, 0.50817, 0.50425, … 0.5000087 | C |
| 1c | $f=(x-1)^2(x+2)$, double root at 1 | `sympy` | C |
| 1d | $f'(x^*)=0$; error constant $(m-1)/m=1/2$ | $f'(1)=0$; series $e_{n+1}=e/2+e^2/12-\dots$ | C |
| 1e | Near the root $f\approx3(x-1)^2$ | $x+2\to3$ in the exact factor | C |
| 1f | Tangent meets axis between $x_n$ and $x^*$, about halfway | Exact: $(x_{n+1}-1)/(x_n-1)=(2x_n+1)/(3x_n+3)$, in $(1/2,2/3)$ for $x_n>1$ | C |
| 1g | "Each step covers just under half the remaining distance" | That ratio exceeds 1/2 for $x_n>1$, so the fraction covered is below 1/2: 0.4848, 0.4918, 0.4957, …, 0.49999 | C |
| 1h | Iterates 1.2, 1.10303, 1.052356, 1.026401 | Exact 1.1030303, 1.0523564, 1.0264008; script the same to 13 or more digits | C |
| 1i | After 12 steps $x_{12}=1.000052$ | Exact 1.00005201565; script 1.00005201565008 | C |
| 1j | About $5.2\times10^{-5}$ from the root | 5.20156e-5 | C |
| 1k | Only the first few steps can be told apart | Marker moves 67.5, 28.4, 13.7, 6.6, 3.5, 1.5, 0.8 px | C |
| 1l | From $x_5$ on the iterate is less than 0.007 from the root | $e_5=0.00664342$; $e_4=0.0133$ does not qualify | C |
| 1m | From $x_5$ on its marker covers the root | Distance to root's pixel: $x_4$ 6.83 px (not covered), $x_5$ 3.30 px, then smaller; red radius about 4.5 px | C |
| 1n | Remaining halvings show only in the legend | Sub-marker shifts only; see section 1, item 2 | C |
| 1o | Link and embed are this case | `accnewtonaa.jl`, `accnewtonaa.gif`, title and legend match | C |
| 1p | Alt text: 12 iterations from 1.2, $x_5$ marker statement | 13 frames (0 to 12); as 1l, 1m | C |

### Case 2 (lines 41–47)

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| 2a | Heading: accelerated, $m=2$, same $f$, $x_0=1.2$ | `bb:12,16,18,29` | C |
| 2b | Formula with $m=2$ | `bb:29`; `sympy` $g_A=(x^2+x+4)/(3(x+1))$, equal to archive gr_133 | C |
| 2c | Orange line from $(x_n,f(x_n))$, not the tangent | `bb:49` `:darkorange`; frame 2 | C |
| 2d | Slope is $f'(x_n)/2$ | I4; at $x_0$ 0.66 against tangent slope 1.32 | C |
| 2e | Meets the axis twice as far from $x_n$ as the Newton tangent | $(1.2-x^A_1)/(1.2-x^N_1)=2.000000000000002$ | C |
| 2f | $\lvert e_{n+1}\rvert\approx C\lvert e_n\rvert^2$ | $e_{n+1}/e_n^2$: 0.1515, 0.16616, 0.166666, 0.1666667; series $e^2/6$ | C |
| 2g | $x_1=1.006061$ | Exact $166/165=1.0060606$ | C |
| 2h | $x_2=1.000006$ | 1.00000610333 | C |
| 2i | $x_3$ equals 1 to six decimals | Exact $1+6.2\times10^{-12}$; script $1+3.6\times10^{-12}$ | C |
| 2j | Requires knowing $m$ | `m = 2` is an input | C |
| 2k | Link and embed are this case; alt text | `accnewtonbb.*`; title `m=2`; 6 frames | C |

### Case 3 (lines 49–57)

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| 3a | Heading: modified, Method B, same $f$, $x_0=1.2$ | `cc:14,31,22-28` | C |
| 3b | $h$ has a simple root at the double root; Newton on $h$ is quadratic | $h'(1)=1/2$; $e_{n+1}/e_n^2$: $-0.1462, -0.16732, -0.166667$ | C |
| 3c | Iteration formula implements Newton on $h$ | Symbolic difference 0; also 1.2 maps to 0.9941520467836 via $h/h'$ directly | C |
| 3d | Plots $h=(x-1)(x+2)/(3(x+1))$ | `sympy` cancel of $f/f'$ equals this; `cc:19,56` | C |
| 3e | Tangent lines dashed | `cc:64`, `ls=:dash`, frames | C |
| 3f | $h$ nearly straight between root and $x_0$; first tangent almost on the curve | Max $\lvert h-\text{tangent}\rvert$ on $[x_1,x_0]$ is 0.00293, about 1.5 px | C |
| 3g | One step to $x_1=0.994152$, just left of the root | Exact $170/171=0.99415205$ | C |
| 3h | Overshoot and later steps too small to see | 2.6 px hop, marker still covers root; see section 1, item 1 | C |
| 3i | $x_2=0.999994$ | 0.99999427797 | C |
| 3j | $x_3$ equals 1 to six decimals | Exact $1-5.46\times10^{-12}$; script $1+8.4\times10^{-12}$ | C |
| 3k | Does not require knowing $m$ | No $m$ in `cc` | C |
| 3l | Link and embed are this case; alt text | `accnewtoncc.*`; title names Method B and $h$; 5 frames | C |

### 3. Implementation checks

Independent values come from `indep.py` (exact rational first step, then 60-digit `mpmath` on the `sympy`-simplified iteration maps). Script values come from `inst_*.jl`, which are scratch copies with the `gif` call replaced by printing `xs`. The archive's printed values are a third source.

### `accnewtonaa.jl` (standard Newton)

- **Method:** `x - f/f'`, with $f$ and $f'$ coded by hand; $f' = 3x^2-3$ agrees with `sympy`.
- **Numbers:**

| $n$ | Script | Independent | Archive |
|---|---|---|---|
| 1 | 1.1030303030303028 | 1.1030303030303030 | 1.1030303030303 |
| 2 | 1.052356417197916 | 1.052356417197916 | 1.0523564171979 |
| 3 | 1.0264008140553686 | 1.0264008140553682 | 1.0264008140554 |
| 6 | 1.0033253746264617 | 1.0033253746264589 | 1.0033253746265 |
| 12 | 1.0000520156500807 | 1.0000520156497739 | 1.0000520156498 |

- **Rate:** $e_n/e_{n-1}$ runs 0.51515 to 0.50000867, which is linear at $(m-1)/m$.
- **Reference values:** the root $x=1$ is exact (factorisation).
- **Picture:** the 12 sloped segments and 12 risers have the right endpoints and tangent slopes; the legend is built from `xs` in the code (`aa:55`), and the legends read in frames 0, 2, 4, 5, 6, 8, 10 and 12 match it. Limits $[0.7,1.8]\times[-0.05,1]$ include every plotted point; no clamping or masking.

### `accnewtonbb.jl` (accelerated, $m=2$)

- **Method:** `x - m*f/f'` with `m = 2`, the correct multiplicity.
- **Numbers:**

| $n$ | Script | Independent | Archive |
|---|---|---|---|
| 1 | 1.0060606060606054 | 1.0060606060606061 | 1.00606060606061 |
| 2 | 1.0000061033293672 | 1.0000061033293662 | 1.0000061033 |
| 3 | 1.0000000000036071 | 1.0000000000062084 | 1.000000000003609 (printed run), 1.00000000000621 (table) |

- **Rate:** $e_n/e_{n-1}^2$ is 0.15152, 0.16616, 0.166666, tending to the series constant $1/6$.
- **Reference values:** root exact.
- **Picture:** 3 non-degenerate chords with slope $f'(x_n)/2$ (I4); steps 3 and 4 are degenerate because $f(x_3)=0.0$ in Float64. Legends match.

### `accnewtoncc.jl` (modified, Method B)

- **Method:** `x - f f' / (f'^2 - f f'')`, which is Newton on $h$ (symbolic difference 0). The plotted `h_plot` is the cancelled form of $f/f'$, equal to it for $x \ne \pm1$, with the correct removable value 0 at $x=1$; the pole at $-1$ is outside the window.
- **Numbers:**

| $n$ | Script | Independent | Archive |
|---|---|---|---|
| 1 | 0.9941520467836247 | 0.9941520467836257 | 0.994152046783626 |
| 2 | 0.9999942779650373 | 0.9999942779650155 | 0.999994277965015 |
| 3 | 1.0000000000083733 | 0.9999999999945430 | 0.999999999994543 |

  The $x_3$ difference is round-off, about $10^{-11}$, and invisible at the six decimals shown (section 1, item 3).
- **Rate:** $e_n/e_{n-1}^2$ is $-0.14620, -0.16732, -0.166667$, with the series constant $-1/6$.
- **Reference values:** root exact; $h(1.2)=0.0969697$, $h'(1.2)=0.4710744$, and $1.2-h/h'=0.9941520$.
- **Picture:** the 3 non-degenerate dashed segments run from $(x_n,h(x_n))$ to $(x_{n+1},0)$ with tangent slope (I3). The window $[0.5,2]\times[-0.4,0.6]$ contains the curve's range $[-0.278,0.444]$. Legends match.

### Could not determine

No claim on this page was left undetermined. The only undetermined item is outside the page: the content of the two legacy GIFs missing from the archive (`Newtonbb.gif`, `Newtoncc.gif`). Perceptual wording ("too small to see", "can be told apart") was tested by pixel measurement rather than by viewing alone.

