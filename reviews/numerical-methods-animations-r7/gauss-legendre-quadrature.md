# Gauss-Legendre Quadrature — animation review (round 7)

Page: `pages/numerical-methods/gauss-legendre-quadrature/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1. Node stems in the bar colour make each bar look like two bars

- **Kind:** Page match (what the diagram shows). Also a departure from the archive drawing.
- **Severity:** Minor
- **Location:** `gausslegendreaa.jl` lines 89-91; visible in GIF frames 4-24. The page text affected is in `index.qmd` line 35: "Each shaded bar has width $w_i$ and height $f(x_i)$, marked by a red dot at the node $x_i$ ... and each node lies inside its own bar."
- **What is there now:** After drawing the bars, the script draws a red vertical line from $(x_i,0)$ to $(x_i,f(x_i))$ for every node. The lines have the same hue as the bar outlines (`lw=0.6` against `lw=0.8`) and run the full height of the bar. The page never mentions them.
- **What is true instead:** The line is not a bar edge, but it reads as one. For $n$ nodes a frame shows $2n-1$ interior vertical lines, of which only $n-1$ are bar boundaries. A viewer checking the page's statement sees $2n$ apparent cells, with each node on the boundary between two of them rather than inside one bar. The apparent widths are not the weights.
- **How I know:**
  - Pixel scan of the committed frames at 90% of image height (`checks2.py`). Frame 4 ($n=2$) has interior red lines at px 159, 327, 495, of which only 327 is a bar edge. Frame 5 ($n=3$) has lines at px 102, 198, 327, 456, 552, of which only 198 and 456 are bar edges.
  - For $n=3$ (`checks3.py`): true bar widths $w=(0.5556, 0.8889, 0.5556)$; apparent cell widths $(0.2254, 0.3302, 0.4444, 0.4444, 0.3302, 0.2254)$.
  - The archive GIF draws the bars and dots with no such lines (legacy frames 4, 5 and 24).
  - The bar top runs unbroken across each stem and the stem ends at the dot, so a careful viewer can work it out. That is why this is Minor rather than Misleading.
- **Suggested correction:** Delete lines 89-91 of `gausslegendreaa.jl` and regenerate the GIF. This matches the archive and changes no number. If the stems are wanted, draw them in a clearly different style (for example dotted and darker) and say on the page that they mark the nodes.

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `gausslegendreaa.jl` | 0 | 11.9 | gausslegendreaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `gausslegendreaa.gif` | 24 | byte-identical | gausslegendreaa |

### Page references

- Scripts linked: `gausslegendreaa.jl`
- GIFs embedded: 1
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

Claims are in the page's own words where possible. "Conf." = confirmed.

### Description

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| D1 | Rule form $\int_{-1}^1 g\approx\sum w_i g(t_i)$ | Script lines 36-41 | Conf. |
| D2 | $t_i$ are roots of $P_n$ | $\max\lvert P_n(t_i)\rvert\le 4.6\times10^{-13}$ for $n$ = 2, 5, 10, 20, 64, by three-term recurrence applied to the script's nodes | Conf. |
| D3 | $w_i$ are the associated weights | Script nodes and weights agree with `scipy.special.roots_legendre` to $\le 2.3\times10^{-15}$ for $n$ = 2, 3, 5, 10, 20, 64 | Conf. |
| D4 | Map $x=\frac{a+b}{2}+\frac{b-a}{2}t$ and factor $\frac{b-a}{2}$ | Script lines 38-39 | Conf. |
| D5 | "optimally chosen interior nodes" | All nodes lie strictly inside $(0,2)$; degree of exactness is $2n-1$ (D6) | Conf. |
| D6 | "exact for polynomials up to degree $2n-1$" | 60-digit arithmetic on $[0,2]$: relative error $\le 7\times10^{-61}$ for all $k\le 2n-1$; nonzero at $k=2n$ ($0.0278$, $1.57\times10^{-5}$, $2.93\times10^{-11}$, $2.77\times10^{-18}$, $5.26\times10^{-23}$ for $n$ = 2, 5, 10, 16, 20) | Conf. |

### Animations introduction

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| A1 | $f(x)=1+e^{-x}\sin(8x^{2/3})$ on $[0,2]$ | Script lines 11-12; frame label; archive `gr_276`, `gr_278` | Conf. |
| A2 | "opens with three frames of the integrand alone" | Frames 1-3 show only the curve and titles; frames 1 and 3 are identical by hash | Conf. |
| A3 | "the second also showing the reference value $I\approx2.016280$" | Frame 2 reads "I = 2.016280" | Conf. |
| A4 | $I\approx2.016280$ | $I=2.01627971961709633$ (40-digit quadrature after $x=u^3$, which removes the singularity); direct quadrature agrees to the 14 digits printed | Conf. |
| A5 | $n=2,3,4,5,6,8,10,\dots,20,24,28,\dots,48,56,64$ | `n_seq`, lines 15-16; all 21 labels read from frames 4-24 | Conf. |
| A6 | "Each later frame uses more nodes" | `n_seq` strictly increasing | Conf. |
| A7 | "recomputes nodes and weights across the full interval" | `gauss_legendre_sum(n)` per frame; rule is global on $[0,2]$ | Conf. |
| A8 | Source scripts "linked under each case" | One case, one link, file exists | Conf. |

### Case 1 heading and Behavior paragraph

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| B1 | Heading: increasing-order rule, stated $f$, $[0,2]$ | Script matches | Conf. |
| B2 | "Each shaded bar has width $w_i$ and height $f(x_i)$" | `weighted_rectangles`; on $[0,2]$ the scaled weight equals $w_i$. True of the geometry, but see F1 for how it reads | Conf. (see F1) |
| B3 | "marked by a red dot at the node $x_i$" | Lines 104-107 draw $(x_i,f(x_i))$; frames 4, 9, 24 | Conf. |
| B4 | "its area is the term $w_i f(x_i)$" | Polygon has base $w_i$, height $f(x_i)$; $n=3$ bar areas sum to 2.3321491791 = script value | Conf. |
| B5 | "laid end to end across $[0,2]$" | Last cumulative bound = 2.00000000000000 and all widths positive for all 21 $n$ | Conf. |
| B6 | "each node lies inside its own bar" | `bounds[i] < x[i] < bounds[i+1]` true for all nodes, all 21 $n$ | Conf. (visual: F1) |
| B7 | "the nodes become denser" | Minimum weight falls from 1.0 ($n=2$) to $1.78\times10^{-3}$ ($n=64$); frames | Conf. |
| B8 | "settles toward $I\approx2.016280$" | Error falls to $+1.864\times10^{-6}$ at $n=64$ | Conf. |
| B9 | "from $n=6$ on it decreases in every frame" | All 16 steps from $n=6$ to $n=64$ negative; $n=5\to6$ rises by $+4.84\times10^{-3}$, so 6 is the correct start | Conf. |
| B10 | "last frame ($n=64$) gives 2.016282" | $I_{64}=2.016281584$; frame 24 label | Conf. |
| B11 | "still about $1.9\times10^{-6}$ high" | $I_{64}-I=+1.864\times10^{-6}$ | Conf. |
| B12 | "$f'$ unbounded at $x=0$ ($f'(x)\approx\frac{16}{3}x^{-1/3}$ near 0)" | $x^{1/3}f'(x)=5.302979, 5.333318, 5.333333, 5.333333$ at $x=10^{-3},10^{-6},10^{-9},10^{-12}$; $16/3=5.333333$ | Conf. |
| B13 | "the textbook error order, which assumes smooth $f$, does not hold" | Measured rate is algebraic (B14), not the factorial decay seen for the smooth comparator (B17-B18) | Conf. |
| B14 | "shrinks only algebraically, like $O(n^{-10/3})$" | Log-log slopes over 32, 64, 128, 256, 512: $-3.299, -3.315, -3.324, -3.329$, approaching $-10/3=-3.3333$ | Conf. |
| B15 | "doubling $n$ divides it by about 9.8 (from 32 to 64 nodes)" | $E_{32}/E_{64}=9.8415$ | Conf. |
| B16 | "tending to $2^{10/3}\approx10.08$" | Ratios for $n\to2n$ from 8: 9.22, 9.65, 9.84, 9.95, 10.02, 10.05, 10.06; $2^{10/3}=10.0794$ | Conf. |
| B17 | Smooth $1+e^{-x}\sin 8x$: "error about $1.8\times10^{-13}$ at $n=14$" | 60-digit: $1.846\times10^{-13}$; double precision: $1.839\times10^{-13}$; closed-form reference | Conf. |
| B18 | "reaches double-precision round-off level (about $10^{-15}$ or less) by $n=16$" | True error $n=15$: $-3.12\times10^{-15}$; $n=16$: $4.17\times10^{-17}$; computed in double at $n=16$: $-8.9\times10^{-16}$ | Conf. |

### Embed, alt text, closing sentence

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| C1 | Link `gausslegendreaa.jl` is this case | File is the script for this case | Conf. |
| C2 | Embed `gausslegendreaa.gif` is this case | Byte-identical to a scratch regeneration (`cmp`) | Conf. |
| C3 | Alt: bars of width $w_i$, height $f(x_i)$, red dot at each node | As B2, B3 | Conf. |
| C4 | Alt: "increases from 2 to 64" | `n_seq` | Conf. |
| C5 | Alt: "settles toward 2.016280, reaching 2.016282 at 64 nodes" | As B8, B10 | Conf. |
| C6 | "follows the archived module equation" | Archive `gr_276`, `gr_278`: `f[x_]=1+e^-x Sin[8 x^(2/3)]`, $a=0$, $b=2$ | Conf. |
| C7 | "compares $I_n=\sum w_i f(x_i)$" (no $\frac{b-a}{2}$ factor) | On $[0,2]$, $\frac{b-a}{2}=1$, so the form is correct here | Conf. |
| C8 | "against a high-resolution numerical reference" | 120001-point trapezoid = 2.016279706128, error $-1.35\times10^{-8}$, which rounds to the displayed 2.016280 | Conf. |
| C9 | Page linked from section index | `pages/numerical-methods/index.qmd:106` | Conf. |

**Ledger total:** 41 entries, 41 confirmed, 0 wrong, 0 could not determine. F1 concerns an element the page does not describe, so it appears as a qualification on B2 and B6 rather than as a wrong claim.

---

### 3. Implementation checks: `gausslegendreaa.jl`

**It is the method it claims to be.** Yes. It computes nodes and weights by the Golub-Welsch eigenvalue method on the Legendre Jacobi matrix ($\beta_k=k/\sqrt{4k^2-1}$, $w_i=2v_{1,i}^2$), maps them to $[0,2]$, and evaluates the global $n$-point Gauss-Legendre sum. It is a single rule on the whole interval, not a composite one. The page does not name a node algorithm, so there is no variant mismatch.

**The numbers are right.** Script values (instrumented copy, `instr.jl`) against independent values (`indep.py` with SciPy nodes; 60-digit Newton-on-$P_n$ for the marked rows):

| $n$ | Script $I_n$ | Independent $I_n$ | Error vs. $I$ | Frame label |
|---|---|---|---|---|
| 2 | 1.1546279085 | 1.154627908 (60-digit) | $-8.6165\times10^{-1}$ | 1.154628 |
| 3 | 2.3321491791 | 2.332149179 (60-digit) | $+3.1587\times10^{-1}$ | 2.332149 |
| 4 | 2.1066635395 | 2.106663539 (60-digit) | $+9.0384\times10^{-2}$ | 2.106664 |
| 5 | 2.0146225359 | 2.014622536 (60-digit) | $-1.6572\times10^{-3}$ | 2.014623 |
| 6 | 2.0194650886 | 2.019465089 (60-digit) | $+3.1854\times10^{-3}$ | 2.019465 |
| 8 | 2.0179117938 | 2.0179117938 | $+1.6321\times10^{-3}$ | 2.017912 |
| 10 | 2.0170861969 | 2.0170861969 | $+8.0648\times10^{-4}$ | 2.017086 |
| 12 | 2.0167288608 | 2.0167288608 | $+4.4914\times10^{-4}$ | 2.016729 |
| 14 | 2.0165526381 | 2.0165526381 | $+2.7292\times10^{-4}$ | 2.016553 |
| 16 | 2.0164566848 | 2.0164566848 | $+1.7697\times10^{-4}$ | 2.016457 |
| 18 | 2.0164003524 | 2.0164003524 | $+1.2063\times10^{-4}$ | 2.016400 |
| 20 | 2.0163652790 | 2.0163652790 | $+8.5559\times10^{-5}$ | 2.016365 |
| 24 | 2.0163268644 | 2.0163268644 | $+4.7145\times10^{-5}$ | 2.016327 |
| 28 | 2.0163081652 | 2.0163081652 | $+2.8446\times10^{-5}$ | 2.016308 |
| 32 | 2.0162980665 | 2.0162980665 | $+1.8347\times10^{-5}$ | 2.016298 |
| 36 | 2.0162921736 | 2.0162921736 | $+1.2454\times10^{-5}$ | 2.016292 |
| 40 | 2.0162885221 | 2.01628852214 (40-digit) | $+8.8025\times10^{-6}$ | 2.016289 |
| 44 | 2.0162861485 | 2.0162861485 | $+6.4289\times10^{-6}$ | 2.016286 |
| 48 | 2.0162845440 | 2.0162845440 | $+4.8244\times10^{-6}$ | 2.016285 |
| 56 | 2.0162826189 | 2.0162826189 | $+2.8993\times10^{-6}$ | 2.016283 |
| 64 | 2.0162815839 | 2.016281584 (60-digit) | $+1.8642\times10^{-6}$ | 2.016282 |

Property checks on the script's own routine: degree of exactness (D6), $P_n(t_i)\approx0$ (D2), $\sum w_i=2$ to 14 decimals for all 21 $n$, and all weights positive.

**Its reference value is right.** The script's 120001-point trapezoid gives 2.016279706128. The independent value is 2.016279719617 (substitution $x=u^3$, which makes the integrand smooth, then 40-digit quadrature). The difference of $-1.35\times10^{-8}$ does not affect the displayed 2.016280, and it does not change the page's error figures at the precision stated: against the script's reference, $E_{64}$ would be $1.878\times10^{-6}$ (still $1.9\times10^{-6}$) and $E_{32}/E_{64}$ about 9.78 (still "about 9.8").

**The picture shows what was computed.**
- Bars: base $[\text{bound}_i,\text{bound}_{i+1}]$, height $f(x_i)$; dots at $(x_i,f(x_i))$. Confirmed in code and frames 4, 9 and 24.
- All 21 "Sample Points" and "Approximation" labels were read from the frames (contact sheet, frames 4, 9, 24, and `labels.png`) and match the table.
- Curve and label match the code's $f$.
- Axis limits do not hide anything: $f$ on $[0,2]$ ranges from 0.357204 (at $x=0.43198$) to 1.919756 (at $x=0.08038$), inside $y\in[0,2.1]$. No clamping or masking.
- The committed GIF is byte-identical to a scratch regeneration.
- The node stems are the subject of F1.
- Not reported as findings because they stay legible: the "Y" of the function label sits on the left axis line, and in frame 2 the curve passes through the "I" of "I = 2.016280".

### Archive comparison

- The page's example is the archive's only animated example (Example 6): same $f$, same interval, same bar construction (cumulative-weight cells with a sample dot).
- The archive's static $Q_2$ to $Q_5$ (1.15462790..., 2.33215, 2.10666..., 2.01462) agree with the script.
- The archive GIF labels I read ($n$ = 2, 6, 10, ..., 38, and 40) agree with the computed values, except that at $n=40$ the archive shows 2.016288 where the true value 2.01628852 rounds to 2.016289. The page's 2.016289 is correct.
- Not findings: the page uses a different $n$ sequence (2, 3, 4, 5, 6, 8, ..., 64 instead of even $n$ to 40) and adds a reference-value frame. Neither changes what the example teaches, and the extended sequence supports the page's convergence statements.
- Examples 1 to 5 of the module ($\int_{-1}^1\cos x\,dx$, $\int_{-1}^1 e^{-x^2/2}dx$, comparisons with Newton-Cotes rules, and normal-probability integrals) are static worked examples, not animations. The page's single case matches the archive's single animation, so I do not treat them as a dropped case.

