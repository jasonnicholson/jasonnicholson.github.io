# Damped Newton with Acceleration (Madsen-Reid Method) — animation review (round 7)

Page: `pages/numerical-methods/madsen-reid-method/`. Reported findings: **0 Error, 1 Misleading, 0 Minor**.

## Findings

### F1. Page match, Misleading: in Case 2's zoomed frames the "second Δx" cannot be seen, because earlier steps paint the whole axis green

- **Location:** `madsreidab.jl:223` (the axis segment is redrawn for every past step), and `index.qmd:57`: "each zoomed frame shows the tangent reaching the axis halfway along the step, then the second $\Delta x$ along the axis."
- **What is there now:** every frame redraws the thick (`lw=3`) axis segment of all earlier steps. Step 1's segment runs from 2.8 to 0.4 and step 2's from 0.743 to 1.086, and these cover the zoom windows. The thick green bar therefore does not stop at the current step's ends.
- **What is true instead:** the current step's axis part is only $[x_{k+1},\ x_k - \Delta x]$. In frames `frame_004` to `frame_006` (x3, x4, x5) the bar runs from edge to edge of the plot, past the red marker on the left and past the step's start on the right. In `frame_003` (x2) it runs from $x=0.4$ to the right edge, past $x_2 = 1.0857$. A viewer cannot tell the second $\Delta x$ from the leftovers of older steps, and the bar reads as a step extending beyond the current iterate.
- **Evidence:** pixel scan of the densest green row in each committed frame (`review/stress.py`), image width 640:

  | Frame | Iterate | Green from column | to column | Note |
  |---|---|---|---|---|
  | `frame_003` | x2 | 129 | 627 | starts at $x=0.4$, runs to the right spine |
  | `frame_004` | x3 | 73 | 627 | full plot width |
  | `frame_005` | x4 | 95 | 628 | full plot width |
  | `frame_006` | x5 | 109 | 628 | full plot width |

  The window is built with a 15% margin on each side of the step, so the step should fill only $1/1.3 \approx 77\%$ of the plot width, and only its second half should be on the axis as a thick bar.
- **Suggested correction:** in `madsreidab.jl:223`, draw older axis segments only in the unzoomed frames:

  ```julia
  (frame < 2 || k == frame) && xt[k] != xn1 && plot!([xt[k], xn1], [0.0, 0.0]; color=col, lw=3, label="")
  ```

  I ran this on a scratch copy (`review/fixtest/madsreidab.jl`, frames in `review/fixtest/frames/`). In the x3 frame the bar then runs only from the Newton point (1.0434) to $x_3$, which is what the sentence describes. No page text needs changing once the script and GIF are updated.

---

- **Independent check:** confirmed with correction. In frame_003 the green bar covers 88.46% of the window; in frames 004 to 006 it spans the full width. The second Δx's endpoints are still marked by the tangent's foot and the red point, so a reader can infer its span, but the thick green bar does not show it. Unzoomed frames are unaffected.


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `madsreidaa.jl` | 0 | 9.4 | madsreidaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `madsreidab.jl` | 0 | 10.6 | madsreidab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `madsreidac.jl` | 0 | 10.1 | madsreidac.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `madsreidaa.gif` | 7 | byte-identical | madsreidaa |
| `madsreidab.gif` | 6 | byte-identical | madsreidab |
| `madsreidac.gif` | 9 | byte-identical | madsreidac |

### Page references

- Scripts linked: `madsreidaa.jl`, `madsreidab.jl`, `madsreidac.jl`
- GIFs embedded: 3
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

Verdicts: **C** confirmed, **W** wrong, **M** misleading, **?** could not determine.

### Description

| # | Claim (page's words) | Verdict | Evidence |
|---|---|---|---|
| D1 | "robust, globally convergent" algorithm | ? | No proof available to me. Stress test of 20,000 random polynomials (degree 3 to 12, reference start rule): 0 non-converged, at most 26 steps. This is consistent with the claim but does not establish it |
| D2 | Finds all roots of a real polynomial; scripts port `newton_real` with one correction | C | Line-by-line read of `Newton_Real.cpp:204-339` against the script routine. The only iteration difference is the `fz0` line. Scripts run the first-root loop only and say so (`madsreidaa.jl:24-25`) |
| D3 | At multiplicity $m$: $f/f'\approx(x-x^*)/m$, error factor $(m-1)/m$ | C | Plain Newton on Case 2: error ratios settle to 0.500 for $m=2$ |
| D4 | If $z-\Delta z$ does not increase $\lvert f\rvert^2$, tries up to $z-(n+1)\Delta z$, stops at first non-lowering trial, keeps the one before | C | `Newton_Real.cpp:272-288`; `madsreidaa.jl:119-140` |
| D5 | Near a root of multiplicity $m$ that point is $z-m\Delta z$ | C | Single step from $1+\delta$ on $(x-1)^m(x+2)$, $\delta=0.1, 0.01$: $k=2,3,4$ for $m=2,3,4$ |
| D6 | Quadratic at a multiple root while in Stage 1 (Case 2, until rounding) | C | $e_{k+1}/e_k^2$ = 0.238, 0.160, 0.167, then 9114 at the rounding-limited step 5 |
| D7 | Stage 2 steps are plain Newton, linear at a multiple root | C | Code; D3 |
| D8 | Near a double root the two sides of the stage test tend to equality | C | Analytically both tend to $4c^2e^2$ for $P\approx ce^2$. Measured left/right in the variant run: 1.238, 1.199, 1.012 |
| D9 | $x_0=-0.7$: plain step to $x_1\approx1.7556$, Stage-2 step to $x_2\approx1.4123$ | C | 1.7555555…, 1.4123058… |
| D10 | Error falls from 0.76 to 0.41 | C | 0.756, 0.412 |
| D11 | Stage test then fails, left side 1.24 times right | C | 1.2384 |
| D12 | Three Stage-1 steps with $k=2$; errors $2.3\times10^{-2}$, $9.1\times10^{-5}$, $1.4\times10^{-9}$ | C | 0.02349, $9.09\times10^{-5}$, $1.377\times10^{-9}$ |
| D13 | Computed $\lvert f\rvert^2$ exactly 0; stops after 5 steps | C | Trace: `f = 0.0`, 5 steps |
| D14 | $r_0\leftarrow5\lvert\Delta z\rvert$, using the length before the cap | C | `Newton_Real.cpp:257-260` |
| D15 | A longer step is cut to $r_0$ and rotated $53.13°$ | C | `alterdirection(dz, r0/r)`; $\arctan(0.8/0.6)=53.13°$ |
| D16 | Cases 1 and 2 scripts stop with an error on a rotation | C | `madsreidaa.jl:180-181`, same in `madsreidab.jl` |
| D17 | No step in the three animations exceeds $r_0$ | C | `cap = 0` for all 19 steps |
| D18 | Stage 1 halving and acceptance rules | C | `Newton_Real.cpp:274-295` |
| D19 | Two helpful halvings: rotate and halve, factor $0.5(0.6+0.8i)$, accepted | C | Code; Case 3 step 2 reproduced by hand |
| D20 | Stage 2 conditions, test $2\lvert f\rvert\lvert w\rvert\le\lvert f'\rvert^2\lvert z_{k-1}-z_k\rvert$, stop at Adams' bound | C | Algebraically equivalent to `f2/u > u/f/4` negated; `f != ff` is the "search left it unchanged" condition; `f > eps` with `eps = e²` |
| D21 | Storing $f'(z_{k-1})$ is what Madsen and Reid's test (2.9) requires | ? | The report is not available to me. Mathematically only $f'$ gives the $f''$ estimate the page describes, and the reference's initial value `a[n-1]` is $f'(0)$ (confirmed). Note: the unmodified line gives the same stage sequence and final root in all three animated cases |
| D22 | `newton_real` stores $f(z_{k-1})$ | C | `Newton_Real.cpp:264` |
| D23 | Saddle branch: rotate previous step, lengthen 5 times | C | `Newton_Real.cpp:246-247` |
| D24 | Rounding branch: step shorter than $2^{-26}\lvert z\rvert$, no decrease, retried rotated and halved | C | `Newton_Real.cpp:304-311` (`-53/2` is $-26$ in integer division) |
| D25 | Neither branch is reached in the animations | C | `saddle = 0`, `rounding = 0` for all steps |
| D26 | Decrease is not guaranteed, for the three reasons given | C | Code. 1,785 of the 20,000 stress runs had a step that increased $\lvert f\rvert^2$ |
| D27 | In all three animations $\lvert f\rvert^2$ decreases at every step | C | Strictly monotone in all three |
| D28 | Uses only $f$ and $f'$ | C | Code |
| D29 | More reliable than unguarded Newton | C | Same stress set and start: plain Newton failed on 2,954, this method on 0 |
| D30 | Deflation by degree 1 or 2, closed form for the last factor | C | `Newton_Real.cpp:223, 317-333` |
| D31 | Generalization note: which parts need only real $f, f'$; rotation needs complex evaluation | C | Code structure |

### Animations

| # | Claim (page's words) | Verdict | Evidence |
|---|---|---|---|
| A1 | Blue plain, green lengthened (tangent to Newton point, then axis), orange halved/rotated | C | `stepcolor`; frames. See F1 for the axis part in Case 2 |
| A2 | Label names the stage of the step that reached the point | C | `stage2[frame]`; frames agree with trace |
| A3 | Cases 1, 2 use own $x_0$ with $r_0=5\lvert x_0\rvert$ | C | 15 and 20 |
| A4 | Case 3 starts where the reference does | C | `startpoint` gives $u=2$, so $z_0=1$, $r_0=5$ |
| A5 | Star markers show exact roots in Case 3 | C | Plotted at $\pm2i$; sympy roots $\pm2i$ |
| 1.1 | $P=x^3-3x-1$, $x_0=3.0$; link and GIF wired | C | Script, title, frames |
| 1.2 | Three simple real roots | C | $-1.5321, -0.3473, 1.8794$; discriminant 81 |
| 1.3 | $\lvert P\rvert^2$ = 17.3, 3.17, 8.73 for $\Delta x, 2\Delta x, 3\Delta x$ | C | 17.308, 3.171, 8.732 |
| 1.4 | $x_1\approx1.5833$, green, passes the root | C | 1.58333 < 1.87939 |
| 1.5 | Step 2 plain in Stage 1, steps 3 to 6 Stage 2, none halved | C | Trace |
| 1.6 | $x^*\approx1.8794$ | C | $2\cos(\pi/9)=1.87938524157\ldots$ |
| 1.7 | Errors $9.8\times10^{-2}$, $6.4\times10^{-3}$, $3.0\times10^{-5}$, $6.7\times10^{-10}$ | C | 0.09783, 0.006397, $3.015\times10^{-5}$, $6.749\times10^{-10}$ |
| 1.8 | Quadratic | C | $e_{k+1}/e_k^2\to0.7422$, the theoretical $\lvert f''/2f'\rvert$ |
| 1.9 | $x_6$ equals $x^*$ to double precision | C | $x_6$ is the nearest double to $x^*$ (error $8.8\times10^{-17}$) |
| 1.10 | $\lvert P\rvert$ below Adams' bound, run stops | C | $3.16\times10^{-30}\le2.45\times10^{-27}$ (squared values) |
| 2.1 | $P=(x-1)^2(x+2)$, $x_0=4.0$; wired | C | sympy expansion $x^3-3x+2$ |
| 2.2 | Double root at 1 with $P'=0$ | C | sympy |
| 2.3 | Plain Newton error roughly halves; $3.4\times10^{-4}$ after 14 steps | C | Ratios 0.58 to 0.50; $3.354\times10^{-4}$ |
| 2.4 | Every step lengthened, all Stage 1; a lengthened step never leads to Stage 2 | C | Trace; a lengthened step makes `f != ff` |
| 2.5 | $3\Delta x$ to $x_1=0.4$, then $2\Delta x$ four times | C | $k$ = 3, 2, 2, 2, 2 |
| 2.6 | Errors $8.6\times10^{-2}$, $1.2\times10^{-3}$, $2.3\times10^{-7}$ | C | 0.08571, 0.001174, $2.296\times10^{-7}$ |
| 2.7 | $x_5\approx0.99999999952$, error $4.8\times10^{-10}$ | C | $4.807\times10^{-10}$ |
| 2.8 | Computed $\lvert P\rvert^2$ exactly 0, true about $4.8\times10^{-37}$ | C | 0.0; $4.804\times10^{-37}$ |
| 2.9 | No step halved | C | Trace |
| 2.10 | Window zooms from $x_2$; steps shrink from 0.69 to $2.3\times10^{-7}$ | C | 0.686, $2.30\times10^{-7}$; frames |
| 2.11 | Tangent reaches the axis halfway along the step | C | Frames; Newton point is the midpoint when $k=2$ |
| 2.12 | "then the second $\Delta x$ along the axis" | **M** | **F1** |
| 3.1 | $P=z^2+4$, $z_0=1+0i$; roots $\pm2i$; wired | C | Script, frames, sympy |
| 3.2 | Reference solves a quadratic in closed form | C | `while( n > 2 )`, then `quadratic` |
| 3.3 | Full step to $-1.5$; $\lvert P\rvert^2$ 39.1 against 25 | C | 39.0625, 25 |
| 3.4 | One halving to $-0.25$; second, to 0.375, does not help | C | 16.504, then 17.145 |
| 3.5 | Full step to 7.875 increases; halvings to 3.8125, 1.78125 help | C | 4358.1, 343.6, 51.4 |
| 3.6 | $z_2=0.359375+0.8125i$ | C | Reproduced by direct formula |
| 3.7 | Orange: halved 1 and 3, rotated 2 | C | Trace; frames |
| 3.8 | Step 4 plain in Stage 1; steps 5 to 8 Stage 2, blue | C | Trace; frames |
| 3.9 | Quadratic to $+2i$ | C | $e_{k+1}/e_k^2\approx0.25=1/(2\lvert z^*\rvert)$ |
| 3.10 | Stops at $z_8$, $\lvert P\rvert\approx3.2\times10^{-30}$, below Adams' bound | C | $3.155\times10^{-30}$; bound $6.2\times10^{-15}$; $z_7$ at $8.9\times10^{-15}$ was still above it |
| 3.11 | No lengthened step; path is a polyline | C | Trace; frames |
| W1 | All three alt texts | C | Each statement checked above |
| W2 | Frame counts (7, 6, 9) equal steps + 1 | C | Manifest; 6, 5, 8 steps |
| W3 | Source links and embeds point to the right case | C | Manifest; script parameters and titles |

---

### 3. Implementation checks

All three scripts contain the identical solver routine (`madsreidaa.jl:27-165`, same text in `madsreidab.jl` and at `madsreidac.jl:23-161`; confirmed by `diff`).

### `madsreidaa.jl` (Case 1)

- **Method:** Madsen's two-stage modified Newton as in `newton_real`, with the disclosed `fz0` change.
- **Numbers:** script and independent port are bit-identical.

  | Step | Script $x$ | Port $x$ | True error (mpmath) |
  |---|---|---|---|
  | 1 | 1.583333333333333 | same | 0.2961 |
  | 2 | 1.9772145417306708 | same | 0.09783 |
  | 3 | 1.885782136079089 | same | 0.006397 |
  | 4 | 1.8794153957913198 | same | $3.015\times10^{-5}$ |
  | 5 | 1.879385242246684 | same | $6.749\times10^{-10}$ |
  | 6 | 1.8793852415718169 | same | $8.77\times10^{-17}$ |

- **Reference:** $x^*=2\cos(\pi/9)$, residual $-6\times10^{-61}$ at 60 digits.
- **Picture:** tangents, axis segments and landing verticals use the right points. Title and function match. Steps 4 to 6 are sub-pixel at this scale; the legend label carries their values, and the page does not claim they are visible.

### `madsreidab.jl` (Case 2)

- **Method:** as above.
- **Numbers:** bit-identical.

  | Step | Script $x$ | $k$ | True error | Exact $\lvert P\rvert^2$ | Computed $\lvert P\rvert^2$ |
  |---|---|---|---|---|---|
  | 1 | 0.3999999999999999 | 3 | 0.6 | 0.7465 | 0.746496 |
  | 2 | 1.0857142857142854 | 2 | 0.08571 | $5.140\times10^{-4}$ | $5.140\times10^{-4}$ |
  | 3 | 1.0011741682974553 | 2 | 0.001174 | $1.712\times10^{-11}$ | $1.712\times10^{-11}$ |
  | 4 | 1.0000002296437014 | 2 | $2.296\times10^{-7}$ | $2.503\times10^{-26}$ | $2.513\times10^{-26}$ |
  | 5 | 0.9999999995193409 | 2 | $4.807\times10^{-10}$ | $4.804\times10^{-37}$ | 0 |

- **Reference:** roots $1$ (double) and $-2$, by sympy.
- **Picture:** correct geometry and labels. Axis band defect is **F1**.

### `madsreidac.jl` (Case 3)

- **Method:** as above, run on the quadratic directly, as the page discloses. Rotation occurs at step 2.
- **Numbers:** bit-identical.

  | Step | Kind | Script $z$ | $\lvert z-2i\rvert$ | $\lvert P\rvert$ |
  |---|---|---|---|---|
  | 1 | halved | $-0.25$ | 2.02 | 4.062 |
  | 2 | rotated | $0.359375+0.8125i$ | 1.24 | 3.518 |
  | 3 | halved | $-0.18577+1.63876i$ | 0.406 | 1.48 |
  | 4 | plain, Stage 1 | $0.04371+2.02433i$ | 0.050 | 0.2013 |
  | 5 | Stage 2 | $0.000532+1.999686i$ | $6.18\times10^{-4}$ | 0.002472 |
  | 6 | Stage 2 | $-8.36\times10^{-8}+2.0000000i$ | $9.55\times10^{-8}$ | $3.82\times10^{-7}$ |
  | 7 | Stage 2 | $1.93\times10^{-15}+2.0i$ | $2.23\times10^{-15}$ | $8.90\times10^{-15}$ |
  | 8 | Stage 2 | $-7.89\times10^{-31}+2.0i$ | $7.89\times10^{-31}$ | $3.155\times10^{-30}$ |

- **Reference:** stars at $\pm2i$, by sympy.
- **Picture:** polyline through the iterates with the right colours and labels; both roots inside the window.

### Could not determine

- **D1:** "globally convergent" as a theorem. The stress test supports it empirically only.
- **D21:** that the storing of $f'$ is what test (2.9) of the Madsen-Reid report requires. The source was not available.

