# Catenary — animation review (round 7)

Page: `pages/numerical-methods/catenary/`. Reported findings: **0 Error, 1 Misleading, 0 Minor**.

## Findings

### F1. Fidelity, Misleading: the page uses a different catenary from Mathews' without saying so, and line 17 cannot hold for the page's formula

**Location:** `index.qmd` line 12 ("the catenary $y = c\cosh(x/c)$"), line 16 ("Case 1 follows Exploration 2 ... which finds the Maclaurin series of the catenary"), line 17 ("solve numerically for the $c$ of the catenary through the origin and two points at equal height on either side of the $y$-axis"). The function itself is at `catenaryaa.jl` lines 13-14.

**What is there now.** The only catenary formula on the page is $y=c\cosh(x/c)$, whose lowest point is $(0,c)$. The page says Case 1 follows Exploration 2, then describes Mathews' Examples as finding "the catenary through the origin".

**What is true instead.** Throughout the module Mathews uses $y=f(x)=c\cosh(x/c)-c$, with lowest point $(0,0)$:
- `CatenaryMod_gr_1.gif` and `_gr_2.gif` (Background): "(0, 0)" and "y = f(x) = c cosh(x/c) - c where c > 0"
- `_gr_24.gif` (end of Exploration 1): the same formula, given explicitly as the one that preserves the shape "for a 'catenary' which passes through the origin"
- `_gr_25.gif`, `_gr_27.gif`, `_gr_28.gif`, `_gr_29.gif` (Exploration 2, the section Case 1 says it follows): $f[x]=-c+c\cosh[x/c]=\sum_{n\ge1}x^{2n}/((2n)!\,c^{2n-1})$, so $f[x]\approx x^2/(2!\,c)$. His parabola is $x^2/(2c)$ with no constant term.
- `_gr_94.gif`, `_gr_95.gif`, `_gr_97.gif` (Example 1): $-c+c\cosh[10/c]=6$

The page's curves are Mathews' curves raised by $c$. That is a legitimate choice, and the page's mathematics is right for its own form. But the page neither states the shift nor gives a reason, and the shift breaks line 17 when read with line 12:

- For $y=c\cosh(x/c)$ with $c>0$, $y(0)=c>0$, so **no member of the page's family passes through the origin**.
- No member passes through Mathews' $(\pm10,6)$ either: the minimum over $c>0$ of $c\cosh(10/c)$ is **15.0888** (at $c=8.3356$), well above 6.
- Mathews' answer $c=9.18894$ gives $y(0)=0$, $y(10)=6$ in his form, but $y(0)=9.18894$, $y(10)=15.18894$ in the page's form.

A reader who tries to reproduce the described example from the page's formula finds it has no solution.

**How I know.** `/usr/bin/python3 review/check2.py`:

```
min over c>0 of c*cosh(10/c) = 15.088796 at c=8.3355656
Mathews c= 9.1889414  shifted form at x=0: -4.544e-31  at x=10: 6.0
page form with same c: y(0)= 9.1889414  y(10)= 15.188941
```

**Suggested correction (text only; the script and GIF can stay).** Add to line 16, after "the Maclaurin series of the catenary":

> Mathews writes the catenary as $y=c\cosh(x/c)-c$, so that its lowest point is at the origin and its series begins with $x^2/(2c)$. The curves here are his raised by $c$, which puts the lowest point at $(0,c)$ and adds the constant term to the parabola.

And in line 17 replace "the $c$ of the catenary through the origin and two points at equal height on either side of the $y$-axis" with "the $c$ for which his shifted catenary $y=c\cosh(x/c)-c$ passes through the origin and the two points $(\pm10,6)$".

---

- **Independent check:** confirmed. The page plots c·cosh(x/c) with lowest point (0,c); Mathews uses c·cosh(x/c) − c with lowest point (0,0). The page does not disclose the shift, and the Maclaurin series differ by the constant c.


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `catenaryaa.jl` | 0 | 7.2 | catenaryaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `catenaryaa.gif` | 25 | byte-identical | catenaryaa |

### Page references

- Scripts linked: `catenaryaa.jl`
- GIFs embedded: 1
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

Claims are in the page's own words. "Line" refers to `index.qmd`.

| # | Line | Claim | Verdict | Evidence |
|---|---|---|---|---|
| 1 | 12 | Shows the catenary $y=c\cosh(x/c)$ | Confirmed | Script line 13; agrees with an mpmath evaluation to relative 1.0e-15 over all frames; frame titles and legend |
| 2 | 12 | Alongside parabola $y=x^2/(2c)+c$ | Confirmed | Script line 14; agrees to relative 2.1e-16 |
| 3 | 12 | $c$ increases from 0.5 to 4 | Confirmed | Dumped values: 25, uniform step 0.145833, first 0.5, last 4.0 |
| 4 | 12 | $c$ is the ratio of horizontal tension to weight per unit length | Confirmed | Force balance $T_0y''=w\sqrt{1+y'^2}$ gives $c=T_0/w$; sympy confirms $y''^2=(1+y'^2)/c^2$ for $y=c\cosh(x/c)$ |
| 5 | 12 | Larger $c$ means a tauter, flatter cable | Confirmed | Sag over $\lvert x\rvert\le4$, $c(\cosh(4/c)-1)$, is strictly decreasing across all 25 values (744.74 at $c=0.5$, 2.17 at $c=4$) |
| 6 | 12 | The catenary is the curve of a flexible cable hanging under gravity | Confirmed | Same ODE as #4 |
| 7 | 12 | The parabola is the first two terms of its Maclaurin series | Confirmed | sympy: $c+x^2/(2c)+x^4/(24c^3)+\dots$ |
| 8 | 14 | Source scripts are linked under each case | Confirmed | One case, one link, line 23 |
| 9 | 16 | Case 1 follows Exploration 2 ("Approximated by a parabola") | Confirmed for the topic, **see F1** for the function | In the archive the "Exploration 2" link follows the "Approximated by a parabola" section. Its function is $c\cosh(x/c)-c$ |
| 10 | 16 | That Exploration finds the Maclaurin series of the catenary | Confirmed | `lnk_3` text; `_gr_27`, `_gr_28`. Images 30-46, the body of the Exploration, are missing from the archive, so I could not determine whether it also held a plot |
| 11 | 17 | Exploration 1: catenaries with different $c$ are scaled copies of one shape | Confirmed | `lnk_2` text; `_gr_3`, `_gr_13`, `_gr_19` |
| 12 | 17 | Exploration 3 is arc length | Confirmed | `lnk_4` |
| 13 | 17 | There is a catenary-fit section | Confirmed | `CatenaryMod.html` "Catenary Fit" |
| 14 | 17 | Those and Examples 1-2 are not animated here | Confirmed | One script, one GIF, showing only the sweep; no case is silently dropped |
| 15 | 17 | Examples solve numerically for $c$ of "the catenary through the origin" and two equal-height points | **Wrong as read with line 12 (F1)**; accurate for Mathews' form | Newton/FindRoot in `_gr_94`, $c=9.18894$ (mine: 9.1889414). No such $c$ exists in the page's form |
| 16 | 17 | Examples compute its arc length with Simpson's rule | Confirmed | `_gr_110` to `_gr_114`: 24.1882 (mine, closed form $2c\sinh(10/c)$: 24.188203) |
| 17 | 17 | Examples compare the catenary with the parabola through the same three points | Confirmed | `lnk_6`: $3x^2/50$ through $(0,0),(\pm10,6)$; length 24.0869 (mine: 24.086942); maximum difference 0.142418 at $x=7.1053$ (mine: 0.142418 at 7.105296) |
| 18 | 19 | Case heading: catenary vs parabola as $c$ varies | Confirmed | Script and frames |
| 19 | 21 | For large $c$ the curves are nearly indistinguishable near $x=0$ | Confirmed | At $c=4$ the gap is 0.00065 at $\lvert x\rvert=1$ and 0.0105 at $\lvert x\rvert=2$, under one pixel (1 px = 0.028 in $y$). It is 0.172 (about 6 px) at the window edge, as the page's "near $x=0$" allows. Frame 25 |
| 20 | 21 | For small $c$ the catenary climbs more steeply than the parabola | Confirmed | Slope $\sinh(x/c)>x/c$ for $x>0$; frame 1 |
| 21 | 21 | The two separate well inside the window (small $c$) | Confirmed | $c=0.5$: gap 0.381 at $\lvert x\rvert=1$, 9.15 at $\lvert x\rvert=2$ |
| 22 | 21 | At $c=0.5$ the gap passes 0.1 at $\lvert x\rvert\approx0.73$ | Confirmed | mpmath root 0.72712337 |
| 23 | 21 | The catenary leaves the top of the plot at $\lvert x\rvert\approx1.94$ | Confirmed | Exact $0.5\,\mathrm{arccosh}(24)=1.9353834$; ylim 12 in script; frame 1 pixel crossing at $\pm1.937$ on the row at $y=11.915$ (predicted 1.932) |
| 24 | 21 | The parabola leaves at $\lvert x\rvert\approx3.39$ | Confirmed | Exact $\sqrt{11.5}=3.391165$; frame 1 pixel crossing at $-3.384$ on the same row (predicted 3.379) |
| 25 | 21 | The catenary never lies below the parabola | Confirmed | Minimum of cat-par over all frames and samples is +2.7e-12; a dense 4001-point grid per frame is non-negative |
| 26 | 21 | Their difference is $x^4/(24c^3)+x^6/(720c^5)+\cdots$, positive for $x\ne0$ | Confirmed | sympy series; all coefficients positive |
| 27 | 21 | The lowest point is always at $(0,c)$ | Confirmed | $y'(0)=0$, $y(0)=c$, convex; diamond marker at $(0,c)$ in frames 1, 13, 25 |
| 28 | 21 | Curves for $c$ are the $c=1$ curves $y=\cosh x$, $y=x^2/2+1$ scaled by $c$ about the origin | Confirmed | sympy: both differences simplify to 0 |
| 29 | 21 | Flattening comes from viewing ever larger copies through a fixed window | Confirmed | Follows from #28; `xlims` and `ylims` are constant in the script |
| 30 | 23 | Source link `catenaryaa.jl` | Confirmed | File exists; identical to the script that produced the GIF |
| 31 | 25 | GIF embed `catenaryaa.gif` | Confirmed | Byte-identical to the regenerated GIF and to the instrumented run |
| 32 | 25 | Alt text: compared as $c$ sweeps from 0.5 to 4 | Confirmed | #1 to #3 |
| 33 | 25 | Alt text: nearly coincide near the apex for large $c$ | Confirmed | #19 |

Reverse check, frames against page: title, legend and marker are consistent with the page in every frame. Titles show $c$ rounded to two decimals (0.5, 0.65, ..., 4.0); $c=3.125$ displays as 3.12 by half-even rounding, which is within rounding and is not a finding.

Observations that are not findings:
- The page has no `## Description` section, although the authoring template asks for one. The review standard excludes content a page does not yet have, so there are no Description claims to check.
- "Nearly taut" is a qualitative statement about large $c$. The largest $c$ shown (4) still has a sag of 2.17 over a width of 8, and the frame shows that plainly, so a viewer is not misled.

---

### 3. Implementation checks: `catenaryaa.jl`

**It is the method it claims to be.** The script evaluates the closed-form catenary and the truncated Maclaurin series over a grid of $c$. No iterative method is involved. The parabola is exactly the two-term truncation: $y-p$ and its derivatives vanish at 0 through order 3, and the fourth derivative is $1/c^3$ (sympy).

**The numbers are right.** Instrumented scratch copy `review/instr/inst.jl` dumped every value (25 frames, 500 points each), and its GIF is byte-identical to the committed GIF.

| Quantity | Script | Independent (mpmath, 40 digits) |
|---|---|---|
| Frames | 25 | 25 |
| $c$ grid | 0.5 to 4.0, step 0.14583333 | $0.5+3.5k/24$; maximum difference 4.4e-16 |
| Catenary values | all frames | maximum relative error 1.02e-15 (every 7th sample) |
| Parabola values | all frames | maximum relative error 2.08e-16 (every 7th sample) |
| cat - par | minimum +2.7e-12 | positive by series |

**Its reference values are right.** The script's catenary is an exact solution of the hanging-cable ODE: sympy gives residual 0 for $y''^2-(1+y'^2)/c^2$, with $y(0)=c$, $y'(0)=0$. No numerically computed reference is used.

**The picture shows what was computed.** I extracted the blue and red curves from all 25 committed frames and compared them to the formulas through the detected plot box (px 52-688 by 31-453, about 120-170 sample columns per curve per frame, legend area excluded):

- Catenary: median error 0.18-0.57 px, worst 95th percentile 1.75 px (frame 1, steepest curve)
- Parabola: median error 0.11-0.34 px, worst 95th percentile 1.11 px

Top-edge crossings in frame 1 match the predicted values (ledger #23 and #24). I viewed frames 1, 13 and 25 directly. The legend does not cover either curve in the viewed frames, since it sits at $y>10$ and $\lvert x\rvert<1.4$, where both curves are far lower or outside it. Clipping at $y=12$ for $c=0.5$ is reported by the page rather than hidden. Axis limits are fixed, as the page states.

**Archive limits.** Images 30-46 and 50-71 are missing from the archive, so the bodies of Explorations 2 and 3 could be read only from their text and the section headers. This does not affect F1, because the function is fixed by images 2, 24, 25, 27, 28 and 94. The archive has no animated GIF for this topic (0 of 136 images), so the $c$ sweep is the author's construction rather than a reproduction, and the page does not claim otherwise.

