# Romberg Integration — animation review (round 7)

Page: `pages/numerical-methods/romberg-integration/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1. Page match, Minor: "Each frame adds one Romberg row" is not true of the opening frame

- **Location:** `index.qmd` line 33, "Each frame adds one Romberg row from a denser trapezoidal partition"; line 37 (alt text and visible caption), "the Romberg table adds one row per frame".
- **What is there now:** the claim covers every frame.
- **What is true:** the GIF has 9 frames and 8 rows. The first frame (`frame = 0`, `rombergaa.jl` line 36) shows only $f$, with no panels and an empty table. Rows are added by frames 2 to 9.
- **How I know:** `rombergaa.jl` line 36 loops `for frame in 0:n_levels` with `n_levels = 8`; the row loop at line 70 is `for k in 1:frame`, which is empty at `frame = 0`. The instrumented run (`inst/inst.out`) prints no row annotations for frame 0, and `committed/rombergaa/sheet.png` shows the empty table in the first frame.
- **Suggested correction:** line 33, "After an opening frame showing $f$ alone, each frame adds one Romberg row ...". Line 37, "the Romberg table adds one row per frame after the opening frame".

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `rombergaa.jl` | 0 | 9.2 | rombergaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `rombergaa.gif` | 9 | byte-identical | rombergaa |

### Page references

- Scripts linked: `rombergaa.jl`
- GIFs embedded: 1
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

### Description

| # | Claim (page's words) | Verdict | Evidence |
|---|---|---|---|
| D1 | $R_{k,1}=T_{2^{k-1}}$ | confirmed | Script uses `n = m_seq[k] - 1` = 1, 2, 4, ..., 128 (lines 14, 29-30) |
| D2 | $R_{k,j}=R_{k,j-1}+\frac{R_{k,j-1}-R_{k-1,j-1}}{4^{j-1}-1}$, $j=2,\dots,k$ | confirmed | Script line 31-32 is the same formula; independent table agrees to 1.21e-15 |
| D3 | For smooth $f$, the trapezoidal error expands in even powers of $h$ | confirmed | On $e^x$, $[0,1]$: column 1 halving ratios 3.95, 3.99, 4.00 |
| D4 | Each extrapolation removes the leading term, so column $j$ has error $O(h^{2j})$ | confirmed | $e^x$: column 2 ratios 15.65, 15.91, 15.98 (16); column 3 62.46, 63.61, 63.90 (64); column 4 249.69, 252.12 (256), the next ratio being roundoff. Column $j$ integrates $x^{2j-1}$ exactly and not $x^{2j}$, for $j=1,\dots,5$ |
| D5 | Requirement $f\in C^{2j}[a,b]$ for column $j$ | confirmed | Euler-Maclaurin with $j-1$ correction terms and an $O(h^{2j})$ remainder needs exactly this. Reasoned, with D4 as the numerical support |
| D6 | Diagonal entries converge quickly for smooth integrands, often outperforming raw trapezoidal refinement for the same evaluations | confirmed | $e^x$, 17 points: $|R_{5,5}-I|=3.3\times10^{-14}$ against $|T_{16}-I|=5.6\times10^{-4}$ |

### Animations introduction

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| A1 | $f(x)=1+e^{-x}\sin(8x^{2/3})$ | confirmed | Script line 9; legacy image 277 is the same function |
| A2 | Interval $[0,2]$ | confirmed | Script line 10; legacy image 278 |
| A3 | Sample counts $m=2,3,5,9,17,33,65,129$ | confirmed | Script line 14; legacy Example 6 table lists the same counts |
| A4 | Graph and table update together as the mesh is globally refined | confirmed | Panel counts 1, 2, 4, ..., 128 from the plotted series; table row added in the same frame |
| A5 | "Each animation below" / source "linked under each case" | confirmed | There is one case with one link; the plural wording is not a false claim |

### Case 1

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| C1 | Heading: Romberg table construction, this $f$, $[0,2]$ | confirmed | Script lines 9-10, 27-34 |
| C2 | "Each frame adds one Romberg row" | **wrong for frame 1** | See F1 |
| C3 | Each row comes from a denser trapezoidal partition and Richardson extrapolation across the row | confirmed | Script lines 28-34 |
| C4 | $R_{k,k}$ is the most accurate entry in its row from $m=9$ on | confirmed | 50-digit table: the smallest error is in column $k$ for rows 4-8. Row 8 errors run from 1.199e-3 (col 1) to 2.7297e-4 (col 8) |
| C5 | At $m=3$ and $m=5$ the diagonal is the least accurate | confirmed | Row 2 errors 0.357, 0.475. Row 3 errors 0.214, 0.404, 0.463 |
| C6 | The error is not monotone | confirmed | 0.0016 rises to 0.475 |
| C7 | Errors $1.6\times10^{-3}, 0.47, 0.46, 0.046, 8.1\times10^{-3}, 2.8\times10^{-3}, 8.7\times10^{-4}, 2.7\times10^{-4}$ | confirmed | Computed 0.0016451, 0.47498, 0.46313, 0.046355, 0.0081055, 0.0027642, 0.00086883, 0.00027297 |
| C8 | One-panel value $f(0)+f(2)=2.017925$ | confirmed | 2.0179248162 |
| C9 | That value is close only by coincidence | confirmed | Error 1.6e-3, while the two-panel error is 0.357. The asymptotic term $8\zeta(-2/3)h^{5/3}$ at $h=2$ would predict about -3.94 |
| C10 | $f'$ is unbounded at 0, $f'(x)\approx\frac{16}{3}x^{-1/3}$ | confirmed | $f'(x)/(\frac{16}{3}x^{-1/3})$ = 0.994308, 0.999997, 1.000000 at $x=10^{-3},10^{-6},10^{-9}$ |
| C11 | The textbook order does not hold for this integrand | confirmed | Column ratios below |
| C12 | Every column, diagonal included, shrinks like $O(h^{5/3})$ | confirmed | Extended to 4097 points: columns 1-8 all have ratios 3.172-3.175 at the last refinement. $T_n-I$ at $n=128$ is -0.0011995 against $8\zeta(-2/3)h^{5/3}=-0.0012125$ |
| C13 | Halving $h$ divides the diagonal error by about 3.18 (64 to 128 subintervals) | confirmed | 3.1829 |
| C14 | The ratio tends to $2^{5/3}\approx3.17$ | confirmed | Later ratios 3.1793, 3.1771, 3.1760, 3.1754, 3.1751; $2^{5/3}=3.17480$ |
| C15 | Extrapolation lowers the error only by a constant factor, about 4.4 at 129 points | confirmed | 4.394 at 129 points, 4.441 at 4097. The limit from $\prod_j(4^j-2^{5/3})/(4^j-1)$ is 4.4545 |
| C16 | $R_{8,8}=2.016007$ | confirmed | 2.016006749516 |
| C17 | It is $2.7\times10^{-4}$ below $I$ | confirmed | -2.7297e-4 |
| C18 | $I\approx2.016280$ | confirmed | 2.01627971961709633 |
| C19 | Source link goes to `rombergaa.jl` | confirmed | Line 35; file exists |
| C20 | Embed is `rombergaa.gif`, produced by this script | confirmed | Line 37; md5 `c671ccfb...` identical for committed and regenerated GIF |
| C21 | Alt text: trapezoidal panels refine globally | confirmed | Frames 2-9 |
| C22 | Alt text: table lists R[k,1], R[k,k], and R[k,k] - I | confirmed | Frame annotations in `inst/inst.out` |
| C23 | Alt text: "adds one row per frame" | **wrong for frame 1** | See F1 |
| C24 | Alt text: error still -2.7e-04 at 129 points | confirmed | Last table row reads `8 129 2.015080 2.016007 -2.7e-04` |

### Legacy fidelity

| # | Archive claim | Verdict | Evidence |
|---|---|---|---|
| L1 | Example 6 and the Romberg animation use this $f$ on $[0,2]$ | matches | Images 277, 278; legacy GIF title |
| L2 | Sample points 2 through 129 | matches | `RombergMod_lnk_7.html` |
| L3 | $R_{i,i}$ = 2.017925, 2.491261, 1.553155, 1.969925, 2.008174, 2.013516, 2.015411, 2.016007 | matches | Legacy table images 293-301 and legacy GIF frames; identical to the script's values at 6 decimals |
| L4 | Legacy `tol = 0.001` | consistent | $|R_{8,8}-R_{7,7}|=5.96\times10^{-4}$ is the first difference below 0.001 ($|R_{7,7}-R_{6,6}|=1.895\times10^{-3}$), which is why the table ends at $m=129$. The page does not state a tolerance and makes no contrary claim |
| L5 | Examples 1-5 | not a finding | Static worked examples with no animation. The page's Worked Example section is a planned placeholder. I did not check their integrals |

Display difference, not a finding: the legacy GIF shades under the curve. The page draws the true trapezoid chords, which is the correct picture of $T_n$.

---

### 3. Implementation checks: `rombergaa.jl`

**It is the method it claims to be.** Yes. Standard Romberg integration: composite trapezoid on $2^{k-1}$ panels in column 1, Richardson extrapolation with denominators $4^{j-1}-1$. Each trapezoid value is computed directly rather than by the reuse recurrence, which gives the same value. Column $j$ integrates polynomials exactly through degree $2j-1$ and not degree $2j$ (`inst/prop.jl`, the script's own table code):

| Column | Error on $x^{2j-1}$ | Error on $x^{2j}$ |
|---|---|---|
| 1 | 0 | 4.17e-2 |
| 2 | 0 | 5.21e-4 |
| 3 | 0 | 5.81e-6 |
| 4 | 0 | 3.18e-8 |
| 5 | 0 | 7.06e-11 |

**The numbers are right.** The instrumented copy's 36 table entries agree with an independent 50-digit mpmath table to at most 1.21e-15 (`compare.py`).

| k | m | n | script R[k,1] | independent R[k,1] | script R[k,k] | independent R[k,k] | independent R[k,k]-I |
|---|---|---|---|---|---|---|---|
| 1 | 2 | 1 | 2.017924816216 | 2.017924816216 | 2.017924816216 | 2.017924816216 | 0.0016451 |
| 2 | 3 | 2 | 2.372926966994 | 2.372926966994 | 2.491261017253 | 2.491261017253 | 0.474981 |
| 3 | 5 | 4 | 1.802071488234 | 1.802071488234 | 1.553154682740 | 1.553154682740 | -0.463125 |
| 4 | 9 | 8 | 1.906594930315 | 1.906594930315 | 1.969924760068 | 1.969924760068 | -0.046355 |
| 5 | 17 | 16 | 1.979055856788 | 1.979055856788 | 2.008174202398 | 2.008174202398 | -0.00810552 |
| 6 | 33 | 32 | 2.004331112084 | 2.004331112084 | 2.013515556346 | 2.013515556346 | -0.00276416 |
| 7 | 65 | 64 | 2.012487535614 | 2.012487535614 | 2.015410885100 | 2.015410885100 | -0.000868835 |
| 8 | 129 | 128 | 2.015080262403 | 2.015080262403 | 2.016006749516 | 2.016006749516 | -0.00027297 |

**The reference value is right.** Script `I_ref = 2.0162797196170963`. Two independent 50-digit quadratures, one after $x=t^3$ and one directly on $f$ with breakpoints graded toward 0, both give 2.0162797196170963278872744219151... The script value differs by 2.8e-17.

**The picture shows what was computed.**

- Each frame's polygon areas, read back from the plotted series by the shoelace formula, equal $R_{k,1}$ to at most 8.9e-16 (panels 1, 2, 4, ..., 128).
- Plotted panel tops equal $f$ at the nodes (maximum difference 0.0).
- The title, curve, labels and table rows match the computed values in every frame (annotations dumped to `inst/inst.out`; frames 2, 5, 9 viewed at full size, all 9 on the contact sheet).
- $f$ ranges over 0.35720 to 1.91976 on $[0,2]$, inside `ylims = (0, 2.1)`, so nothing is clipped. The script uses no clamping or NaN masking.
- The in-plot label gives $R_{k,k}$ while the shaded area equals $R_{k,1}$. The label names its quantity correctly and the table beside it lists both, so I did not count this as a finding.
- The committed GIF is byte-identical to the regenerated output.

**Could not determine:** nothing within scope. The legacy Examples 1-5 were not checked because they are not cases on this page.

