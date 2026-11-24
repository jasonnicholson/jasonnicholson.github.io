# Newton-Raphson Method — animation review (round 7)

Page: `pages/numerical-methods/newton-raphson-method/`. Reported findings: **0 Error, 1 Misleading, 2 Minor**.

## Findings

### F1. Page match, Misleading: "convex side of the root" gives the wrong reason for monotone convergence
- **Location:** `pages/numerical-methods/newton-raphson-method/index.qmd:21`, "Starting at $x_0 = 1.0$ on the convex side of the root, each tangent line lands between the root and the previous iterate".
- **Now:** the sentence attributes the one-sided behaviour to $x_0$ being on "the convex side", which implies the other side of the root is not convex.
- **True:** $f''(x)=3e^x+4\cos x>0$ on the whole interval from the inflection at $x\approx-1.7072$ through the plotted window, so $f$ is convex on **both** sides of $x^*$. What decides the behaviour is the sign of $f$: to the right of the root $f>0$ and $f''>0$, so $f\,f''>0$. Starting left of the root, on the same convex arc, the first tangent overshoots past the root, so it does not land between the root and the previous iterate. (The phrase is defensible only under a geometric reading, the axis point lying on the outer side of the curve, which a student is unlikely to take from it.)
- **Evidence** (mpmath, 40 digits; $x^*=0.25485005902885$):

  | $x_0$ | $f''(x_0)$ | $x_1$ | lands between $x^*$ and $x_0$? |
  |---|---|---|---|
  | 1.0 (page) | 10.316 | 0.4797520 | yes |
  | 0 | 7.0 | 0.3333333 | no, overshoots past $x^*$ |
  | 0.1 | 7.2955 | 0.2788779 | no |
  | 0.2 | 7.5845 | 0.2574265 | no |

  Zero of $f''$ left of the root: $-1.7072431$; minimum of $f''$ sampled on $[-1.697, 1.5]$: $0.0451>0$.
- **Correction:** replace "on the convex side of the root" with "to the right of the root, where $f > 0$ and $f'' > 0$".

- **Independent check:** confirmed.

### F2. Page match, Minor: Case 3 heading names the wrong feature
- **Location:** `index.qmd:35`, "Case 3 — Convergent near inflection point".
- **Now:** the heading suggests the run starts near, or is about being near, an inflection point.
- **True:** the only inflection point of $\arctan$ is $x=0$, which is the root itself. The start $x_0=1.35$ is far from it, at $0.970\,x_c$, right by the convergence threshold. The defining behaviour is sign-alternating convergence from just inside $x_c$, which is what the Behavior paragraph, the script header (`newtoncc.jl:2`, "Convergence with Oscillation") and Mathews' Example 5 title ("Convergence, Oscillation") all say. The body never mentions an inflection point.
- **Evidence:** iterates 1.35, -1.2841, 1.1241, -0.7859, 0.2916, -0.01625, 2.86e-6, -1.56e-17, 2.54e-51; signs alternate at every step and $|x_n|$ strictly decreases.
- **Correction:** "Case 3 — Convergence with oscillation, $f(x) = \arctan(x)$, $x_0 = 1.35$".

- **Independent check:** not run (Minor finding, unverified)

### F3. Page match, Minor: the introduction's summary does not fit half the cases
- **Location:** `index.qmd:14`, "The sequence of tangent lines traces the convergence (or divergence) toward a root."
- **Now:** read literally, every case moves "toward a root", including the divergent ones.
- **True:** only Cases 1-3 approach a root. Case 4 cycles: after the start ($x_0=0$, distance 1.672), every one of 4000 iterates stays at least 1.678 from the only real root. Cases 5 and 6 move away from their root ($x_6=10.0188$ and $|x_6|=8.7103$).
- **Correction:** "The sequence of tangent lines shows whether the iterates converge to a root, fall into a cycle, or diverge."

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `newtonaa.jl` | 0 | 6.7 | newtonaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtonbb.jl` | 0 | 6.6 | newtonbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtoncc.jl` | 0 | 6.8 | newtoncc.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtondd.jl` | 0 | 7.2 | newtondd.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtonee.jl` | 0 | 7.1 | newtonee.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtonff.jl` | 0 | 6.3 | newtonff.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `newtonaa.gif` | 6 | byte-identical | newtonaa |
| `newtonbb.gif` | 13 | byte-identical | newtonbb |
| `newtoncc.gif` | 9 | byte-identical | newtoncc |
| `newtondd.gif` | 11 | byte-identical | newtondd |
| `newtonee.gif` | 7 | byte-identical | newtonee |
| `newtonff.gif` | 7 | byte-identical | newtonff |

### Page references

- Scripts linked: `newtonaa.jl`, `newtonbb.jl`, `newtoncc.jl`, `newtondd.jl`, `newtonee.jl`, `newtonff.jl`
- GIFs embedded: 6
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

The page has no `## Description` section; the method formula is in the Animations introduction and is checked there. History, attribution and the source-inspiration line are out of scope.

| # | Where | Claim (page's words) | Verdict | Evidence |
|---|---|---|---|---|
| 1 | Intro l.12 | At each $x_n$ a tangent to $f$ is drawn | Confirmed | Each segment runs $(x_n,f(x_n))\to(x_{n+1},0)$; slope vs $f'(x_n)$ rel. mismatch ≤ 2.8e-11 in all scripts |
| 2 | Intro l.13 | x-intercept gives $x_{n+1}=x_n-f(x_n)/f'(x_n)$ | Confirmed | All scripts implement it; iterates match independent run |
| 3 | Intro l.14 | Tangent lines trace "convergence (or divergence) toward a root" | **Wrong (F3)** | Cases 4-6 do not move toward a root |
| 4 | Intro l.16 | Julia source linked under each case | Confirmed | Lines 23, 31, 40, 49, 58, 67 |
| 5 | C1 heading | $f=3e^x-4\cos x$, $x_0=1.0$ | Confirmed | `newtonaa.jl:10,14`; Mathews Ex. 3 |
| 6 | C1 heading | Quadratic convergence | Confirmed | $e_{n+1}/e_n^2\to0.79333=f''/(2f')$ at root (0.793327) |
| 7 | C1 | Single positive root | Confirmed | $f'=3e^x+4\sin x>0$ for $x\ge0$, $f(0)=-1$; one sign change on (0,50) |
| 8 | C1 | $x^*\approx0.2549$ | Confirmed | 0.25485005902885 |
| 9 | C1 | Infinitely many negative roots | Confirmed | $-4\cos x$ oscillates while $3e^x\to0$; -1.3812, -4.7191, -7.8537, -10.9956 |
| 10 | C1 | Negative roots outside the plotted window | Confirmed | `xlims=(0,1.5)` |
| 11 | C1 | $x_0$ "on the convex side of the root" | **Misleading (F1)** | $f$ convex on both sides |
| 12 | C1 | Each tangent lands between root and previous iterate | Confirmed | $x_n>x_{n+1}>x^*$ for all computed $n$ |
| 13 | C1 | Iterates decrease monotonically to $x^*$ | Confirmed | Same check |
| 14 | C1 | 1, 0.4798, 0.2857, 0.2556, 0.254850 | Confirmed | 1, 0.479752, 0.285738, 0.255577, 0.2548505 |
| 15 | C1 | Correct digits roughly double each step | Confirmed | $-\log_{10}|e_n|$: 0.13, 0.65, 1.51, 3.14, 6.38, 12.9, 25.8 |
| 16 | C1 alt | Rapid, monotone from 1.0 to $x\approx0.2549$ | Confirmed | As above; final legend 0.25485 |
| 17 | C2 heading | $f=(1-5x)^2$, $x_0=1.0$ | Confirmed | `newtonbb.jl:11,15`; Mathews Ex. 4 ($1-10x+25x^2$) |
| 18 | C2 | Double root at $x^*=0.2$ | Confirmed | $f=25(x-0.2)^2$ |
| 19 | C2 | $f'(x^*)=0$ | Confirmed | $f'(0.2)=50(0.2)-10=0$ |
| 20 | C2 | Linear; each step roughly halves the error | Confirmed | Exactly halves: $x_{n+1}-0.2=(x_n-0.2)/2$; 1, .6, .4, .3, .25, ... |
| 21 | C2 alt | Slow linear convergence to 0.2 | Confirmed | $x_{12}=0.2001953$ |
| 22 | C3 heading | $f=\arctan x$, $x_0=1.35$ | Confirmed | `newtoncc.jl:11,15`; Mathews Ex. 5 |
| 23 | C3 heading | "Convergent near inflection point" | **Misleading wording (F2)** | Root is the inflection; $x_0$ is far from it |
| 24 | C3 | Only root $x^*=0$ | Confirmed | arctan strictly increasing |
| 25 | C3 | Converges only when $|x_0|<x_c$ | Confirmed | $h(x)=2x-(1+x^2)\arctan x$ has one positive zero; $|N(x)|<|x|$ iff $|x|<x_c$. Numeric: 1.39174 converges, 1.3918 diverges |
| 26 | C3 | $x_c\approx1.3917$ | Confirmed | 1.39174520027073 |
| 27 | C3 | 1.35 just inside the radius | Confirmed | $x_0/x_c=0.970$ |
| 28 | C3 | Converges after several oscillating steps | Confirmed | Signs alternate for all 8 steps; $|x_n|$ decreases |
| 29 | C3 alt | Convergent, just inside the critical radius | Confirmed | As above |
| 30 | C4 heading | $f=x^3-x+3$, $x_0=0$ | Confirmed | `newtondd.jl:12,16`; Mathews Ex. 6 |
| 31 | C4 heading | Cycling, non-convergence | Confirmed | Period-4 orbit below |
| 32 | C4 | One real root | Confirmed | Discriminant $-239<0$ |
| 33 | C4 | $x^*\approx-1.6717$ | Confirmed | -1.67169988 |
| 34 | C4 | Curve crosses axis at left of window | Confirmed | `xlims=(-2,3.5)`; visible in every frame |
| 35 | C4 | Attracting 4-cycle ≈ 0.0074 → 3.0005 → 1.9619 → 1.1475 | Confirmed | 0.007446077, 3.000498254, 1.961896666, 1.147501572; multiplier 0.2325 < 1 |
| 36 | C4 | Iterates are drawn into it | Confirmed | Float64 after 400 steps sits on the cycle to 6 places |
| 37 | C4 | Never approach the root | Confirmed | Minimum distance to root over iterates 1 to 4000: 1.678 (the start $x_0=0$ is 1.672 away) |
| 38 | C4 alt | Settles into the 4-cycle, never reaches the root | Confirmed | As above. The GIF's 10 steps reach 0.0073 and 1.1474 on the last pass, consistent with "≈" while still converging to the cycle |
| 39 | C5 heading | $f=xe^{-x}$, $x_0=2$; divergence to infinity | Confirmed | `newtonee.jl:11,15`; Mathews Ex. 7 |
| 40 | C5 | Only root $x^*=0$ | Confirmed | $e^{-x}>0$ |
| 41 | C5 | Maximum of $f$ at $x=1$; $x_0=2$ beyond it | Confirmed | $f'=(1-x)e^{-x}$ |
| 42 | C5 | There $f>0$, $f'<0$ | Confirmed | For $x>1$ |
| 43 | C5 | $x_{n+1}=x_n^2/(x_n-1)>x_n$ | Confirmed | Algebra; residual 0 at sample points; $x^2>x^2-x$ for $x>1$ |
| 44 | C5 | 2, 4, 5.33, 6.56, ..., 10.02 after six steps | Confirmed | 2, 4, 5.3333, 6.5641, ..., 10.018819 |
| 45 | C5 | $f(x_n)\to0$; small residual does not mean a root is near | Confirmed | $f(x_6)=4.46\times10^{-4}$ at distance 10.02 from the root |
| 46 | C5 alt | Each tangent meets axis further right; iterates move toward $+\infty$ | Confirmed | Strictly increasing; unbounded because $x_{n+1}-x_n=x_n/(x_n-1)>1$ |
| 47 | C6 heading | $f=\arctan x$, $x_0=1.4$; divergent | Confirmed | `newtonff.jl:11,15`; Mathews Ex. 8 |
| 48 | C6 | Just outside $x_c\approx1.3917$ | Confirmed | $x_0/x_c=1.0059$ |
| 49 | C6 | Do not converge; escape toward larger $|x|$ | Confirmed | 1.4, -1.4136, 1.4501, -1.5506, 1.8471, -2.8936, 8.7103, then -103.25, 16540.6 |
| 50 | C6 alt | Divergent, just outside the critical radius | Confirmed | As above |
| 51 | Wiring | Each case links and embeds its own script and GIF | Confirmed | Lines 23/25 aa, 31/33 bb, 40/42 cc, 49/51 dd, 58/60 ee, 67/69 ff; parameters match headings |
| 52 | Counts | Six cases | Confirmed | Six scripts, GIFs and headings; frames 6, 13, 9, 11, 7, 7 = `n_iters+1` |

### 3. Implementation checks

Common to all six scripts:

- **Method:** plain Newton-Raphson, $x_{n+1}=x_n-f(x_n)/f'(x_n)$, with no safeguards or damping. Page and script describe the same variant.
- **Derivatives:** each hand-coded `fp` agrees with a central difference to ≤ 1.1e-9 relative at every iterate, and with sympy's derivative through the independent iteration.
- **Reproduction:** instrumented scratch copies (`review/inst/inst_*.jl`, dump code appended only) produced GIFs byte-identical to the committed ones, so the dumped values are the values behind the committed frames.
- **Geometry:** each drawn tangent's slope matches $f'(x_n)$ (max relative mismatch by script: aa 2.8e-11, bb 5.7e-14, cc 1.2e-16, dd 1.4e-16, ee 3.0e-16, ff 1.2e-16). Verticals run from $(x_{n+1},0)$ to $(x_{n+1},f(x_{n+1}))$. The marker and legend index match the frame.
- **Titles:** the function in each title is the function in the code.
- **Frames viewed:** the contact sheet covering every frame of aa, cc, dd, ee, ff (all ≤ 12 frames) and 7 of bb's 13 (0, 2, 4, 6, 8, 10, 12), plus legend crops of `newtoncc/frame_008.png` ($x_7$) and `newtonff/frame_007.png` ($x_6$).

Script-specific display notes (none is a finding):

- `newtoncc.jl`: legends for $x_6,x_7,x_8$ read `0.0`, `-0.0`, `0.0`. These are 5-decimal roundings of 2.86e-6, -1.56e-17 and 2.5e-51; cosmetic.
- `newtondd.jl`: the clamp at lines 48, 51 and 58 never activates (max $f(x_n)=27.01<30$), so no value is drawn falsely.
- `newtonee.jl`: the off-window `→ ∞` label branch is never reached, because all iterates are within `xlims=(0,11)`.
- `newtonff.jl`: $x_6=8.71$ is off-window. Its tangent is correctly clipped at the edge and the legend states the true value with "(out of range)", so the display does not misrepresent it.

Reference values (independent, mpmath): Case 1 root 0.25485005902885; Case 2 root 0.2; Case 3/6 root 0 and $x_c=1.39174520027073$; Case 4 root -1.67169988165716 and cycle 0.007446077373, 3.000498254, 1.961896666, 1.147501572 (multiplier 0.23250483); Case 5 root 0. None of the scripts draws a separate "exact" curve; each draws $f$ itself.

Commands: `python3 review/indep.py`; `python3 review/compare.py review`; `julia review/inst/inst_<case>.jl`; `python3 review/tables.py review`.

### Iterates: script vs independent

**newtonaa.jl** (script Float64 vs independent 60-digit mpmath with sympy derivative)

| n | script x_n | independent x_n | abs diff |
|---|---|---|---|
| 0 | 1 | 1.0 | 0.0 |
| 1 | 0.479752015606 | 0.479752015606 | 3.7e-17 |
| 2 | 0.285738359131 | 0.285738359131 | 1.7e-18 |
| 3 | 0.255576900472 | 0.255576900472 | 1.1e-16 |
| 4 | 0.254850477734 | 0.254850477734 | 4.8e-17 |
| 5 | 0.254850059029 | 0.254850059029 | 6.7e-18 |

**newtonbb.jl** (script Float64 vs independent 60-digit mpmath with sympy derivative)

| n | script x_n | independent x_n | abs diff |
|---|---|---|---|
| 0 | 1 | 1.0 | 0.0 |
| 1 | 0.6 | 0.6 | 0.0 |
| 2 | 0.4 | 0.4 | 3.0e-17 |
| 3 | 0.3 | 0.3 | 3.9e-62 |
| 4 | 0.25 | 0.25 | 0.0 |
| 5 | 0.225 | 0.225 | 0.0 |
| 6 | 0.2125 | 0.2125 | 0.0 |
| 7 | 0.20625 | 0.20625 | 0.0 |
| 8 | 0.203125 | 0.203125 | 0.0 |
| 9 | 0.2015625 | 0.2015625 | 0.0 |
| 10 | 0.20078125 | 0.20078125 | 0.0 |
| 11 | 0.200390625 | 0.200390625 | 0.0 |
| 12 | 0.2001953125 | 0.2001953125 | 0.0 |

**newtoncc.jl** (script Float64 vs independent 60-digit mpmath with sympy derivative)

| n | script x_n | independent x_n | abs diff |
|---|---|---|---|
| 0 | 1.35 | 1.35 | 0.0 |
| 1 | -1.28409114963 | -1.28409114963 | 2.8e-16 |
| 2 | 1.12412310647 | 1.12412310647 | 2.0e-16 |
| 3 | -0.785871881003 | -0.785871881003 | 4.4e-16 |
| 4 | 0.291553977394 | 0.291553977394 | 5.1e-16 |
| 5 | -0.0162510014433 | -0.0162510014433 | 5.3e-17 |
| 6 | 2.86105489419e-06 | 2.86105489419e-6 | 3.8e-19 |
| 7 | -1.56129348003e-17 | -1.56130342577e-17 | 9.9e-23 |
| 8 | 0 | 2.537293336e-51 | 2.5e-51 |

**newtondd.jl** (script Float64 vs independent 60-digit mpmath with sympy derivative)

| n | script x_n | independent x_n | abs diff |
|---|---|---|---|
| 0 | 0 | 0.0 | 0.0 |
| 1 | 3 | 3.0 | 0.0 |
| 2 | 1.96153846154 | 1.96153846154 | 3.8e-17 |
| 3 | 1.1471759614 | 1.1471759614 | 4.3e-17 |
| 4 | 0.00657937148071 | 0.00657937148071 | 6.0e-17 |
| 5 | 3.00038907407 | 3.00038907407 | 1.3e-16 |
| 6 | 1.96181817567 | 1.96181817567 | 2.3e-17 |
| 7 | 1.14743022848 | 1.14743022848 | 1.6e-16 |
| 8 | 0.00725624755242 | 0.00725624755242 | 5.4e-16 |
| 9 | 3.00047318877 | 3.00047318877 | 1.5e-16 |
| 10 | 1.96187864636 | 1.96187864636 | 6.9e-17 |

**newtonee.jl** (script Float64 vs independent 60-digit mpmath with sympy derivative)

| n | script x_n | independent x_n | abs diff |
|---|---|---|---|
| 0 | 2 | 2.0 | 0.0 |
| 1 | 4 | 4.0 | 0.0 |
| 2 | 5.33333333333 | 5.33333333333 | 3.3e-16 |
| 3 | 6.5641025641 | 6.5641025641 | 1.0e-16 |
| 4 | 7.74382606641 | 7.74382606641 | 4.3e-16 |
| 5 | 8.89210984332 | 8.89210984332 | 5.6e-17 |
| 6 | 10.0188186728 | 10.0188186728 | 3.2e-16 |

**newtonff.jl** (script Float64 vs independent 60-digit mpmath with sympy derivative)

| n | script x_n | independent x_n | abs diff |
|---|---|---|---|
| 0 | 1.4 | 1.4 | 0.0 |
| 1 | -1.4136186488 | -1.4136186488 | 1.4e-16 |
| 2 | 1.45012931463 | 1.45012931463 | 7.8e-16 |
| 3 | -1.55062597564 | -1.55062597564 | 2.3e-15 |
| 4 | 1.84705408415 | 1.84705408415 | 7.3e-15 |
| 5 | -2.89356239314 | -2.89356239314 | 2.9e-14 |
| 6 | 8.71032584698 | 8.71032584698 | 2.1e-13 |

### Legacy archive

Consulted. Examples 3-8 of `Newton'sMethodMod.html` are Animations 1-6. Their formula images (`gr_374/375`, `394/395`, `433/434`, `454/455`, `484/485`, `514/515`) give exactly the page's functions and starting values:

| Case | Mathews | Function | $p_0$ |
|---|---|---|---|
| 1 | Ex. 3 Fast Convergence | $3e^x-4\cos x$ | 1.0 |
| 2 | Ex. 4 Slow Convergence | $1-10x+25x^2$ | 1.0 |
| 3 | Ex. 5 Convergence, Oscillation | $\arctan x$ | 1.35 |
| 4 | Ex. 6 NON Convergence, Cycling | $x^3-x+3$ | 0.0 |
| 5 | Ex. 7 NON Convergence, Diverging to Infinity | $xe^{-x}$ | 2.0 |
| 6 | Ex. 8 NON Convergence, Divergent Oscillation | $\arctan x$ | 1.4 |

The surviving legacy GIFs (`Newtonaa`, `dd`, `ee`, `ff`) show the same iterates as the page (for example $p_6=10.0188$ for Case 5 and $p_6=8.71033$ for Case 6). `Newtonbb.gif` and `Newtoncc.gif` are referenced but absent from the archive; those two cases were checked from their formula images. No Fidelity finding. Examples 1 and 2 are static worked examples with no legacy animation, so their absence from the Animations section is not a dropped case; I did not review their content. Iteration counts and plot windows differ modestly from the legacy (for example 12 steps rather than 25 in Case 2), with no effect on what a reader would conclude.

### Could not determine

Nothing on this page was left undetermined.

