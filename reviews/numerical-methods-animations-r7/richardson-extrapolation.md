# Richardson Extrapolation — animation review (round 7)

Page: `pages/numerical-methods/richardson-extrapolation/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1. Fidelity, Minor: Example 7 (and 2(a), 6) missing from the page's otherwise explicit list of what is not animated

- **Location:** `index.qmd` lines 31–33, the three sentences that account for the module's examples.
- **What is there now:** The page accounts for Example 8 (Case 2), Examples 9–10 (not animated), the pictures of Examples 8–10 (not animated) and Examples 1, 3, 4, 5 (not animated). The text reads as a complete inventory, but Examples **2(a), 6 and 7** do not appear. Example 2(b) is named only in a code comment (`richexaa.jl` line 21).
- **What is true instead:** Example 7 is the module's one direct numerical demonstration of Richardson extrapolation, the page's subject: compute $D_{three}[1.0,0.02]$ and $D_{three}[1.0,0.01]$, apply $\frac{4D_{three}[1.0,0.01]-D_{three}[1.0,0.02]}{3}$, compute $D_{five}[1.0,0.01]$ directly and compare with $f'[1.0]$ (statement images 153–158). Example 6 is the general identity $D_{five}(x,h)=\frac{4D_{three}(x,h)-D_{three}(x,2h)}{3}$ (image 148). Example 2(a) is the table of $D_{five}$ at $x=0,1,2,3$ for $h=0.1,0.01$ (images 57–58, 65).
- **How I know:** Read the module text and images (`legacy/mod.png`, `legacy/lnk3.png`), and `grep` of the page finds no mention of Examples 2, 6 or 7. `indep.py` computes Example 7:

  | Quantity | Independent (60 digits) | Script (`richexab.jl`, page $h=0.02$) |
  |---|---|---|
  | $D_3(1,0.02)$ | -0.11072598792 | -0.11072598791771887 |
  | $D_3(1,0.01)$ | -0.11077682107 | -0.11077682107023534 |
  | extrapolated | -0.1107937654544 | -0.1107937654544075 |
  | $D_{five}(1,0.01)$ directly | -0.1107937654544 | (same quantity) |
  | $f'(1)$ | -0.1107937653067 | -0.11079376530669924 |

  So Example 7's result does exist in Case 2, but only as one unlabelled marker (page $h=0.02$), and a reader cannot tell.
- **Suggested correction:** Add to the end of line 33: "Example 7, the module's worked extrapolation, combines $D_3(1,0.02)$ and $D_3(1,0.01)$ into the five-point value at spacing $0.01$; it is the $h=0.02$ point of Case 2 and is not shown separately. Example 2(a)'s table at $x=0,1,2,3$ and Example 6's proof of the identity are not animated either."

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `richexaa.jl` | 0 | 8.7 | richexaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `richexab.jl` | 0 | 7.3 | richexab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `richexaa.gif` | 9 | byte-identical | richexaa |
| `richexab.gif` | 12 | byte-identical | richexab |

### Page references

- Scripts linked: `richexaa.jl`, `richexab.jl`
- GIFs embedded: 2
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

Verdicts: **confirmed**, **wrong**, **could not determine**. Line numbers refer to `index.qmd`.

### Description

| # | Line | Claim | Verdict | Evidence |
|---|---|---|---|---|
| 1 | 12 | Richardson "combines two finite-difference estimates with different step sizes so that the leading truncation term cancels" | confirmed | sympy series of D5 has zero $h^2$ coefficient |
| 2 | 12 | Legacy module presents it as a refinement of the central three-point derivative | confirmed | Module theorem, images 19–26 |
| 3 | 12 | Legacy test function $f(x)=e^{-x}\sin x$ on $[0,\pi]$ | confirmed | Images 34, 37, 60, 62 |
| 4 | 17 | $D_3(x,h)=\frac{f(x+h)-f(x-h)}{2h}$ | confirmed | Same as module image 4 and script line 12; exact for $x^0..x^2$, not $x^3$ |
| 5 | 23 | $D_5(x,h)=\frac{4D_3(x,h/2)-D_3(x,h)}{3}$ | confirmed | Same as script line 13; exact for $x^0..x^4$, not $x^5$ (`degree.jl`, exact rationals) |
| 6 | 26 | Upgrades truncation from $O(h^2)$ to $O(h^4)$ for smooth functions | confirmed | Series: D3 error $\frac{f'''}{6}h^2$; D5 error $-\frac{f^{(5)}}{480}h^4$; measured slopes 2.000 and 4.000 |

### Animations introduction

| # | Line | Claim | Verdict | Evidence |
|---|---|---|---|---|
| 7 | 30 | Each animation compares base central difference with Richardson | confirmed | Both scripts plot D3 and D5 |
| 8 | 30 | ...for the legacy test function and interval | confirmed | Same $f$ in both. Interval applies to Case 1; Case 2 is the point $x_0=1$ inside it, as its heading says |
| 9 | 31 | Case 2 plots the error of the estimate in Example 8 | confirmed | Example 8 is $f'(1.0)$ by the five-point formula (images 172–174) |
| 10 | 31 | $D_5(x,h)$ is that example's five-point formula with spacing $h/2$ | confirmed | sympy: page $D_5(x,h)$ minus legacy $D_{five}(x,h/2)$ simplifies to 0; all 6 printed legacy values reproduced (table in section 3) |
| 11 | 31 | "evaluated here over a different list of step sizes" | confirmed | Legacy $H$ = {0.5, 0.2, 0.1, 0.05, 0.02, 0.01}; script spacings $h/2$ = {0.25, 0.16, 0.1, 0.06, 0.04, 0.025, 0.015, 0.01, 0.005, 0.003, 0.0015, 0.00075} |
| 12 | 32 | Examples 9–10 use five-point central formulas for the second and third derivatives at the same point | confirmed | Images 193–195, 214–216, $X=1.0$; I reproduce -0.397532221 and 1.01666305 at $H=0.01$ |
| 13 | 32 | Examples 9–10 are not animated here | confirmed | No script computes them |
| 14 | 32 | Examples 8–10 draw five stencil points with a line, parabola or cubic through the centre point | confirmed | Images 174–190, 195–211, 216–232. Archive note: Example 10's cubic uses `d3/2` where a Taylor term needs `d3/6` (image 216); it still passes through the centre point, and the page does not reproduce it |
| 15 | 32 | Those pictures are not animated here | confirmed | Neither GIF draws a stencil |
| 16 | 33 | Examples 1, 3, 4, 5 are truncation-error-bound examples | confirmed | Module text and images 34–38, 95–99, 113–116, 139–140 |
| 17 | 33 | They estimate $M_5=\max\lvert f^{(5)}\rvert$ on $[0,\pi]$ from a graph of $f^{(5)}$ | confirmed | Images 35–38. The module's prose says "third derivative", a legacy slip; its formulas are $f^{(5)}$. $M_5=4$ at $x=0$ |
| 18 | 33 | They check the five-point bound against the actual error | confirmed | Example 3, images 95–99. The page states no outcome. For the record, with $M_5=4$ the bound is 1.3333333e-9 and the actual error at $x=0$ is 1.3333651e-9, so it fails narrowly; the module's own aside says so and widens the interval. Not a finding, because the page does not claim the bound holds |
| 19 | 33 | They show the bound's $O(h^4)$ scaling | confirmed | Example 4, images 113–123; $EB_{five}(h)=2h^4/15$ |
| 20 | 33 | They compare it with the three-point bound | confirmed | Example 5, images 139–140 |
| 21 | 33 | Case 1 annotates the actual maximum errors | confirmed | Script lines 28–29, 52–56; all 18 values match (section 3) |
| 22 | 31–33 | (implied) this accounts for the module's examples | **incomplete** | Examples 2(a), 6, 7 are absent. See F1 |

### Case 1

| # | Line | Claim | Verdict | Evidence |
|---|---|---|---|---|
| 23 | 35 | Profile comparison of $D_3$ and $D_5$ | confirmed | Frames 1, 5, 9 |
| 24 | 37 | Both approximations converge as $h$ shrinks | confirmed | Max errors fall monotonically: D3 8.13e-2 to 3.33e-5; D5 5.29e-4 to 8.33e-11 |
| 25 | 37 | Richardson tracks $f'$ much more closely | confirmed | D5 max error is 154 to 400,000 times smaller across the frames. From $h\le0.12$ all three curves are within about a pixel, so the annotation carries the comparison in those frames; it is correct |
| 26 | 37 | Because the dominant $h^2$ term is cancelled | confirmed | Series, ledger 1 |
| 27 | 39 | Source link is `richexaa.jl` | confirmed | File exists and is this case |
| 28 | 41 | Embed `richexaa.gif`; alt: D3 and D5 against true derivative over 0 to pi for decreasing $h$ | confirmed | Frames; `hs` strictly decreasing; byte-identical to regeneration |

### Case 2

| # | Line | Claim | Verdict | Evidence |
|---|---|---|---|---|
| 29 | 43 | Pointwise at $x_0=1$ | confirmed | Script line 14, frame titles |
| 30 | 43 | Log-log axes | confirmed | `xaxis=:log, yaxis=:log`; decade ticks in frames |
| 31 | 45 | Three-point slope approximately $O(h^2)$ | confirmed | Local slopes 2.007 falling to 2.000 |
| 32 | 45 | Richardson approximately $O(h^4)$ | confirmed | Local slopes 3.905 rising to 4.000 through $h=0.01$; 3.987 at $h=0.006$ |
| 33 | 45 | ...before roundoff effects appear | confirmed | Last two points depart: $h=0.003$ error 4.26e-14 against truncation 7.48e-14; $h=0.0015$ error 1.29e-14 against 4.67e-15. Visible in frames 11–12 |
| 34 | 47 | Source link is `richexab.jl` | confirmed | File exists and is this case |
| 35 | 49 | Embed `richexab.gif`; alt: log-log error curves at $x_0=1$, second- and fourth-order trends | confirmed | Frames 1, 6, 11, 12 |

### Derivation Notes

| # | Line | Claim | Verdict | Evidence |
|---|---|---|---|---|
| 36 | 53 | $D_3=f'+C_2h^2+C_4h^4+\cdots$ | confirmed | sympy series: even powers only; $C_2=f'''/6$, $C_4=f^{(5)}/120$ |
| 37 | 56–57 | The combination equals $f'+O(h^4)$ | confirmed | Series remainder $-C_4h^4/4=-f^{(5)}h^4/480$ |
| 38 | 60 | The $C_2h^2$ contribution cancels exactly | confirmed | $4C_2(h/2)^2-C_2h^2=0$; sympy $h^2$ coefficient is 0 |

**Could not determine:** nothing on the page. The missing archive images prevent reading the worked solutions of Examples 1, 3, 5, 6 and 7, but every page claim about them is supported by the surviving statements.

---

### 3. Implementation checks

### `richexaa.jl`

**It is the method it claims to be.** One level of Richardson extrapolation on the central difference. `d5` is algebraically the five-point rule at spacing $h/2$ (sympy difference = 0). Applied through the script's own lines with exact rationals (`degree.jl`, $x=3/7$, $h=2/5$): D3 exact for degree 0–2, error 0.16 at $x^3$; D5 exact for degree 0–4, error -0.0064 at $x^5$.

**The numbers are right.** Script values (printed from inside its loop) against an independent 40-digit continuous maximisation over $[0,\pi]$, and the annotation read from the frames:

| $h$ | Script max D3 | Independent | Script max D5 | Independent | Frame annotation |
|---|---|---|---|---|---|
| 0.5 | 8.12769e-2 | 8.12770e-2 | 5.28527e-4 | 5.28527e-4 | 8.13e-02, 5.29e-04 |
| 0.32 | 3.37856e-2 | 3.37857e-2 | 8.79123e-5 | 8.79123e-5 | 3.38e-02, 8.79e-05 |
| 0.2 | 1.32801e-2 | 1.32801e-2 | 1.33650e-5 | 1.33650e-5 | 1.33e-02, 1.34e-05 |
| 0.12 | 4.79308e-3 | 4.79309e-3 | 1.72948e-6 | 1.72948e-6 | 4.79e-03, 1.73e-06 |
| 0.08 | 2.13197e-3 | 2.13197e-3 | 3.41463e-7 | 3.41463e-7 | 2.13e-03, 3.41e-07 |
| 0.05 | 8.33125e-4 | 8.33125e-4 | 5.20911e-8 | 5.20911e-8 | 8.33e-04, 5.21e-08 |
| 0.03 | 2.99973e-4 | 2.99973e-4 | 6.75036e-9 | 6.75036e-9 | 3.00e-04, 6.75e-09 |
| 0.02 | 1.33328e-4 | 1.33328e-4 | 1.33337e-9 | 1.33337e-9 | 1.33e-04, 1.33e-09 |
| 0.01 | 3.33330e-5 | 3.33330e-5 | 8.33340e-11 | 8.33338e-11 | 3.33e-05, 8.33e-11 |

All 18 annotated values equal the independent values rounded to three figures. The 800-point grid does not change any displayed digit, even though the continuous D3 maximum lies slightly inside the interval rather than at $x=0$ ($x\approx0.025$ at $h=0.5$, moving toward 0 as $h$ shrinks).

**Its reference values are right.** `fp` matches a 60-digit numerical derivative of $f$ at 23 points on $[0,22/7]$ to 8e-62.

**The picture shows what was computed.** Frames 1, 5 and 9 viewed; contact sheet of all 9 read. Title $h$, legend and annotation match the loop variable. Plotted range is -0.208 to 1.0812, inside `ylims=(-1.0, 1.1)`, so nothing is clipped. The GIF is byte-identical to a fresh run (`cmp`).

### `richexab.jl`

**It is the method it claims to be.** Same `d3` and `d5` lines, same exactness result.

**The numbers are right.** Script double-precision errors at $x_0=1$ against 60-digit truncation errors:

| $h$ | Script D3 err | True D3 err | Script D5 err | True D5 err | Slope D3 | Slope D5 (true) | Slope D5 (script) |
|---|---|---|---|---|---|---|---|
| 0.5 | 4.25787e-2 | 4.25787e-2 | 5.37592e-5 | 5.37592e-5 | | | |
| 0.32 | 1.73887e-2 | 1.73887e-2 | 9.41039e-6 | 9.41039e-6 | 2.007 | 3.905 | 3.905 |
| 0.2 | 6.78354e-3 | 6.78354e-3 | 1.46111e-6 | 1.46111e-6 | 2.003 | 3.963 | 3.963 |
| 0.12 | 2.44073e-3 | 2.44073e-3 | 1.90699e-7 | 1.90699e-7 | 2.001 | 3.986 | 3.986 |
| 0.08 | 1.08458e-3 | 1.08458e-3 | 3.77515e-8 | 3.77515e-8 | 2.000 | 3.995 | 3.995 |
| 0.05 | 4.23628e-4 | 4.23628e-4 | 5.76657e-9 | 5.76657e-9 | 2.000 | 3.998 | 3.998 |
| 0.03 | 1.52501e-4 | 1.52501e-4 | 7.47674e-10 | 7.47674e-10 | 2.000 | 3.999 | 3.999 |
| 0.02 | 6.77774e-5 | 6.77774e-5 | 1.47708e-10 | 1.47709e-10 | 2.000 | 4.000 | 4.000 |
| 0.01 | 1.69442e-5 | 1.69442e-5 | 9.23893e-12 | 9.23256e-12 | 2.000 | 4.000 | 3.999 |
| 0.006 | 6.09992e-6 | 6.09992e-6 | 1.20523e-12 | 1.19656e-12 | 2.000 | 4.000 | 3.987 |
| 0.003 | 1.52498e-6 | 1.52498e-6 | 4.25909e-14 | 7.47856e-14 | 2.000 | 4.000 | 4.823 |
| 0.0015 | 3.81245e-7 | 3.81245e-7 | 1.29202e-14 | 4.67411e-15 | 2.000 | 4.000 | 1.721 |

The departure in the last two rows is genuine double-precision roundoff, which the page describes. Asymptotic constants agree: $f'''(1)/6=0.169442$ and $\lvert f^{(5)}(1)\rvert/480=0.00092328$.

Legacy Example 8 values reproduced through the page's formula, $D_5(1,2H)$:

| $H$ | Legacy printed | Page $D_5(1,2H)$ |
|---|---|---|
| 0.5 | -0.111463434 | -0.1114634336 |
| 0.2 | -0.110816367 | -0.1108163675 |
| 0.1 | -0.110795226 | -0.1107952264 |
| 0.05 | -0.110793857 | -0.1107938574 |
| 0.02 | -0.110793768 | -0.1107937677 |
| 0.01 | -0.110793765 | -0.1107937655 |

**Its reference values are right.** Same `fp`; $f'(1)=-0.110793765307$ independently, and the module prints -0.110793765.

**The picture shows what was computed.** Frames 1, 6, 11 and 12 viewed; contact sheet read. Each frame $k$ plots the first $k$ points. Guides are anchored exactly at the first data point ($c_2=0.170315$, $c_4=0.000860147$), so they illustrate slope rather than the asymptotic constant; the offset from the true constants (0.5% and 6.8%) is invisible on these axes. Frame 1 has a single point per series, so its guides have zero length; this is harmless. Frames 11–12 show the roundoff departure the page mentions. The GIF is byte-identical to a fresh run (`cmp`).

### Legacy animations

The module links two legacy GIFs (`a2001/Animations/Derivative/CentralD2.1f` and `CentralD2.2f`). Both show the three-point $O(h^2)$ central difference at $x=1$ for the same function, one with the interpolating parabola and one with the secant. They contain no Richardson step, are shared with the Numerical Differentiation module, and the sibling page `numerical-differentiation` (Case 2) covers the central secant, so their absence here is not a finding.

