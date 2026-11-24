# Rational Approximation — animation review (round 7)

Page: `pages/numerical-methods/rational-approximation/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1. Implementation, Minor: source comment says the minimax approximant has no interpolation nodes

- **Location:** `rationalapproxaa.jl:177`, `if !isempty(xn)  # the minimax approximant has no interpolation nodes`
- **Now:** the comment states as fact that the minimax approximant has no interpolation nodes.
- **True:** the minimax $R$ equals $f$ at exactly five points, one between each pair of adjacent alternation points. They are not prescribed in advance; the exchange determines them. They are the five zeros visible in the lower panel of frame 3. Mathews says the same of this approximant in Solution 1(c) (`lnk_4`): "The nodes are selected in an iterative process".
- **Evidence:** `/usr/bin/python3 review/zeros.py`, using Mathews' printed minimax coefficients (which agree with the script's to about 12 digits):
  - zeros of $f-R$: $x = -0.95211131,\ -0.59238659,\ -8.7858833\times10^{-6},\ 0.59240063,\ 0.95210605$
  - residual at each is below $2\times10^{-32}$, and $f-R$ changes sign across each.
- **Consequence:** none for the picture. Leaving the markers off frame 3 is a fair display choice; only the stated reason is wrong.
- **Suggested correction:** `# minimax has no prescribed nodes: its five crossings of f come out of the exchange`

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `rationalapproxaa.jl` | 0 | 8.2 | rationalapproxaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `rationalapproxaa.gif` | 3 | byte-identical | rationalapproxaa |

### Page references

- Scripts linked: `rationalapproxaa.jl`
- GIFs embedded: 1
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

Verdicts: **C** = confirmed, **W** = wrong, **ND** = could not determine.

### Description

| # | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|
| D1 | $R_{m,n}(x)=P_m(x)/Q_n(x)$, $Q_n(x)\neq0$ | Definition. Mathews writes numerator degree $n$, denominator degree $m$ (gr_12); only the letters differ. Script form at line 14 is this with $m=n=2$, $Q(0)=1$ | C |
| D2 | Mathews compares equally spaced nodes, Chebyshev nodes and MiniMax over a fixed interval | Module text, Examples 1 and 2, parts (a), (b), (c) on $[-1,1]$ | C |
| D3 | MinMax "spreads error more uniformly" | Peak-to-peak of lobes: equal nodes 6.00e-5 to 1.59e-4; minimax all six at 8.6798e-5. Module background also says this | C |
| D4 | MinMax goal is to minimize $\max\lvert(f-R)/f\rvert$ | Mathews `lnk_4`: "minimizing the 'relative error'"; independently, LP in section 3 finds the optimum of exactly this objective at the script's level | C |

### Animations introduction

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| A1 | $f(x)=e^x$ on $[-1,1]$ | Script lines 12, 134; gr_10, gr_12, gr_15 | C |
| A2 | Fixed $[2/2]$ rational form | Script lines 14-22; gr_9 ($R_{2,2}$), gr_12 | C |
| A3 | Order of frames: (1) equal, (2) Chebyshev, (3) minimax | Script lines 150-154; frame titles | C |
| A4 | Minimax "minimizes the maximum relative error" | LP bracket in section 3: infeasible at $0.9999E^*$, feasible at $E^*$ | C |
| A5 | "computed here by the Remez exchange algorithm" | Script lines 57-131: 6-point reference, equioscillation solve, full exchange at error extrema. Variant named in section 3 | C |
| A6 | Source scripts are "linked under each case" | One case, one link; `pandoc` output has `href="rationalapproxaa.jl"` | C |
| A7 | "No archived animation GIF is available for this topic" | 269 surviving module images, 0 multi-frame (`identify`); `a2001/Animations` has no "rational" content outside the separate Padé topic | C |
| A8 | Animation is reconstructed from Example 1 | $e^x$, $R_{2,2}$, $[-1,1]$, parts (a), (b), (c) | C |
| A9 | Example 2: $[4/4]$ for $e^x$ with equal, Chebyshev, MiniMax | gr_113, gr_114; module text 2(a)-(c) | C |
| A10 | Exercise 3: $[4/4]$, $\cos(\pi x/2)$, equal and Chebyshev | gr_216, gr_217; module text 3(a), 3(b) | C |
| A11 | Example 4: $[4/4]$, $\tan x$, equal and Chebyshev | gr_295, gr_296; module text | C |
| A12 | Example 5: $[4/4]$, $\arctan x$, equal and Chebyshev | gr_375, gr_376, gr_415-420; module text | C |
| A13 | These are "not animated here" | One script, one GIF, three frames, all Example 1 | C |

### Case 1 heading, Behavior, alt text, wiring

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| B1 | Heading: $[2/2]$, $e^x$, $[-1,1]$, equal nodes, Chebyshev nodes, MinMax | Script; frame titles | C |
| B2 | Both interpolants "exact at their nodes" | Max node residual: script 4.4e-16 both; mpmath 1.6e-61 and 3.1e-61 | C |
| B3 | Equal-node max relative error "about $1.59\times10^{-4}$" | Independent 1.593661e-4; script 1.593650e-4 (1201-point grid) | C |
| B4 | Equal-node error "largest near $x\approx\pm0.82$" | Extrema at $\pm0.82442661$ (1.59341e-4 and 1.59366e-4) | C |
| B5 | Chebyshev max relative error $8.94\times10^{-5}$ | Independent and script 8.941921e-5, attained at $x=-1$ | C |
| B6 | Minimax has "the smallest possible maximum relative error for this form" | Six alternations with full degree (alternation theorem) **and** the LP bracket, which does not use that theorem | C |
| B7 | Minimax value $8.68\times10^{-5}$ | Independent $E^*=8.6797863986\times10^{-5}$; script 8.679786399e-5 | C |
| B8 | "about 3% below the Chebyshev value" | $(8.94192-8.67979)/8.94192 = 2.93\%$ | C |
| B9 | Error reaches this level "with alternating sign at six points" | Signed values: $-,+,-,+,-,+$, each $8.679786399\times10^{-5}$; spread 6.6e-46 at 60 digits | C |
| B10 | Points $x=-1,\pm0.812,\pm0.312,1$ | Independent $-1,\mp0.812304291,\mp0.312414594,1$ | C |
| B11 | Relative-error curve in the last frame is equal-ripple | Frame 3 lobes equal; drawn curve within 0.5 px of independent values at the 99th percentile | C |
| B12 | Alt: three frames | Manifest and frame extraction: 3 | C |
| B13 | Alt: 1.59e-4, 8.94e-5, 8.68e-5 | As B3, B5, B7; frame legends read 0.0001594, 8.94e-5, 8.68e-5 | C |
| B14 | Alt: "each with function and relative-error panels" | All three frames | C |
| B15 | Link and embed point at this case's script and GIF | `pandoc` output; GIF regenerated byte-identical from the script (md5 `4052de20...` for both) | C |
| B16 | Page linked from the section index | `pages/numerical-methods/index.qmd:66` | C |

No entry is **W**. No page claim is **ND**.

One narrower item could not be determined and affects no page claim: Mathews' own numerical results for Example 1(b) cannot be compared, because images 49-86 are missing from the archive. His Chebyshev node formula was read from Example 5(b) instead (see section 3).

### 3. Implementation checks: `rationalapproxaa.jl`

### It is the method it claims to be

- **Interpolants:** linearized collocation $P(x_i)-y_iQ(x_i)=0$ with $Q(0)=1$, 5 equations for 5 unknowns, the same system Mathews solves (gr_22).
- **Equal nodes:** $-1,-0.5,0,0.5,1$, identical to Mathews (gr_16).
- **Chebyshev nodes:** first-kind (zeros of $T_5$), $\cos((2k-1)\pi/10)$. Mathews' formula (gr_419) is $\cos\frac{(2(m+n)+1-2i)\pi}{2(m+n)+2}$, which gives the same set for $m+n=4$.
- **Minimax:** true Remez, **multi-point (second-algorithm) exchange** on the relative-error weight. Each iteration solves the nonlinear equioscillation system $P(x_i)=f(x_i)(1-s_iE)Q(x_i)$ at six reference points by Newton, then replaces all six with the error extrema. It starts from the $T_5$ extrema. The Jacobian at line 71 was derived by hand and is correct.
- **Convergence:** ripple spread 3.45e-8, 7.48e-14, 7.06e-16 over 3 iterations, the expected quadratic behaviour.

### The numbers are right

Independent: `review/indep.py` (mpmath, 60 digits, shares no code with the script). Script values: instrumented copy `review/inst/inst.jl`. Mathews: archive images gr_22, gr_89.

| Quantity | Script | Independent | Mathews |
|---|---|---|---|
| Equal $a_1$ | 0.49983148044945 | 0.499831480449 | 0.499831 |
| Equal $a_2$ | 0.08161203841263 | 0.0816120384126 | 0.081612 |
| Equal $b_1$ | -0.49983148044945 | -0.499831480449 | -0.499831 |
| Equal $b_2$ | 0.08161203841263 | 0.0816120384126 | 0.081612 |
| Chebyshev $a_1$ | 0.49978937588751 | 0.499789375888 | image missing |
| Chebyshev $a_2$ | 0.08160322161195 | 0.0816032216119 | image missing |
| Minimax $a_0$ | 0.9999999962330653 | 0.999999996233 | 0.999999996233065 |
| Minimax $a_1$ | 0.49978562382661 | 0.499785623827 | 0.4997856238266049 |
| Minimax $a_2$ | 0.08159269632523836 | 0.0815926963252 | 0.08159269632523609 |
| Minimax $b_1$ | -0.499785625709263 | -0.499785625709 | -0.4997856257092684 |
| Minimax $b_2$ | 0.08159269663258942 | 0.0815926966326 | 0.08159269663259221 |
| Max abs error, equal | 3.6736517e-4 | not computed | 0.000367365 |
| Max abs error, minimax | 2.3594106e-4 | not computed | 0.000235941 |
| Max rel error, equal | 1.593650e-4 (1201 pts), 1.593661e-4 (400001 pts) | 1.593661e-4 | not given |
| Max rel error, Chebyshev | 8.941921e-5 | 8.941921e-5 | image missing |
| Max rel error, minimax | 8.679786e-5 | 8.679786e-5 | not given |

The script's alternation points differ from the independent ones by at most 3.6e-7 (for example 0.31241432 against 0.31241459). That is the golden-section search on a flat maximum; the six error magnitudes at the script's points still agree to 7e-16 absolute (about 8e-12 relative), so nothing displayed is affected.

**Global optimality check that does not use the alternation theorem** (`review/lp.py`). For a trial level $E$, the set of coefficients with $f(1-E)Q\le P\le f(1+E)Q$ on an 801-point grid is a linear feasibility problem, and its constraints force $Q\ge0$. A negative best margin $t$ proves no $[2/2]$ form reaches level $E$.

| $E/E^*$ | 0.9 | 0.99 | 0.999 | 0.9999 | 1.0 | 1.0001 | 1.001 | 1.01 |
|---|---|---|---|---|---|---|---|---|
| Best margin $t$ | -8.04e-6 | -7.99e-7 | -7.98e-8 | -7.94e-9 | +4.8e-11 | +8.04e-9 | +7.99e-8 | +7.99e-7 |

Feasibility switches at $E^*$, so $8.68\times10^{-5}$ is the true minimax level.

### Its reference values are right

The only reference is `f(x) = exp(x)`, evaluated directly. There are no hard-coded "true" values. The guard at lines 18-20 never fires: $\min\lvert Q\rvert$ on $[-1,1]$ is 0.5818 for all three approximants, and the minimax denominator's roots are complex ($3.063\pm1.696i$).

### The picture shows what was computed

- **Regeneration:** the instrumented copy reproduces the committed GIF byte for byte (md5 `4052de20c8b7deda80ca11a78a719169`).
- **Error curves** (`review/pix2.py`), drawn purple curve against independently computed $\lvert e\rvert$ over 651 pixel columns:

| Frame | Median deviation | 99th percentile | Max |
|---|---|---|---|
| 1 | 0.25 px | 0.57 px | 2.00 px |
| 2 | 0.26 px | 0.57 px | 2.00 px |
| 3 | 0.25 px | 0.50 px | 1.99 px |

- **Node markers** (`review/nodes.py`), read from the pixels:
  - Frame 1: $x\approx-0.995,-0.501,-0.001,0.499,0.994$ (edge markers are clipped by the axis box, which pulls their centroids inward).
  - Frame 2: $x\approx-0.950,-0.588,-0.001,0.587,0.950$.
  - Frame 3: none, as coded.
  - Marker heights agree with $e^x$ to within about 0.02.
- **Titles and legends:** each reports its own method and its own maximum (0.0001594, 8.94e-5, 8.68e-5).
- **Display devices:** the axis limits $y\in[0.2,3]$ and error $\in[0,2\times10^{-4}]$ contain everything; nothing is clamped or masked. The lower panel plots $\lvert e\rvert$ and is labelled `|f-R|/|f|`, so the sign alternation in the page text is not itself visible, but the page does not claim it is.

### Legacy fidelity

- The page uses Mathews' Example 1 function, degrees, interval, node sets and minimax objective, and its minimax approximant agrees with his to about 12 digits.
- The undrawn cases are named on the page (A9-A13).
- Mathews plots over $[-2,2]$ and adds Taylor and Padé comparisons with absolute-error bounds. The page shows $[-1,1]$ and relative error only. That is a scope choice and is stated plainly, so it is not a Fidelity finding.
- **Archive gap:** images 49-86 (all of Solution 1(b)) and the solution images for 2(b), 3(b) and 4(b) are absent, so Mathews' own Chebyshev results for Example 1 could not be read.

