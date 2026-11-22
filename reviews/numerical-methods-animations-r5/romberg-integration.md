# Romberg Integration — animation review (round 5)

Page: `pages/numerical-methods/romberg-integration/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page was confirmed against independent computation and the frames (ledger below). Observations below the finding threshold, recorded so the owner can see they were considered:

- Intro says "Each animation below shows ..." although the page has one animation. Wording only; nothing a reader would conclude wrongly.
- "Each frame adds one Romberg row": the first of the 9 frames is a curve-only title frame that adds no row (rows are added in frames 2-9). Trivial.
- The table panel shows faint background grid lines despite `axis=false`. Cosmetic, does not impair reading.
- The table shows only columns R[k,1] and R[k,k]; the script comment says so, and the page/alt text describe exactly those columns. Not a mismatch.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `rombergaa.jl` | 0 | 8.9 | rombergaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|
| D1 | "Romberg integration accelerates composite trapezoidal approximations with Richardson extrapolation" | Script: `trapezoid_sum` then Richardson recurrence (lines 21-34) | confirmed |
| D2 | $R_{k,1}=T_{2^{k-1}}$ | Script `n = m_seq[k]-1` = 1,2,4,...,128 = $2^{k-1}$ subintervals | confirmed |
| D3 | $R_{k,j}=R_{k,j-1}+(R_{k,j-1}-R_{k-1,j-1})/(4^{j-1}-1)$, $j=2..k$ | Script line 32 identical | confirmed |
| D4 | For $f\in C^{2j}$, trapezoid error expands in even powers of h; column j has error $O(h^{2j})$ | Standard Euler-Maclaurin; property test on the script's own recurrence: column j exact for $x^d$, $d\le 2j-1$, not for $d=2j$ (col1: deg 1; col2: deg 3; col3: deg 5; col4: deg 7; x^8 col4 err 4.17e-3) | confirmed |
| D5 | Triangular table; diagonal converges quickly for smooth integrands | General statement, consistent with D4 | confirmed |
| A1 | Function $f(x)=1+e^{-x}\sin(8x^{2/3})$ on $[0,2]$ | Script line 9-10; curve in frames matches legacy plot of same function | confirmed |
| A2 | Sample counts $m=2,3,5,9,17,33,65,129$ | `m_seq` line 14; frame labels "Sample Points = 2 ... 129" | confirmed |
| A3 | Graph and table updated together; mesh refined globally | Frames 2-9: panels uniform width (b-a)/(m-1), table row added same frame | confirmed |
| A4 | "Each animation below" (plural) | One animation | confirmed in substance (wording only; see note) |
| A5 | Case heading: Romberg table construction, same f, [0,2] | Script and frames | confirmed |
| B1 | Each frame adds one Romberg row from a denser partition then applies Richardson across the row | Script loop; frames 2-9 add rows 1-8 (frame 1 is a title frame) | confirmed (note: frame 1 adds none) |
| B2 | $R_{k,k}$ is the most accurate entry in its row from m=9 on | Full-row errors (mpmath, `ext.py`): best column = k for k=4..8 (and k=9..13 in extension). Row 7: 8.6883e-4 (diag) < 8.6930e-4 (col 6); row 8: 2.72970e-4 < 2.73006e-4 | confirmed |
| B3 | At m=3 and m=5 the diagonal is the least accurate | Row 2 errs 0.357, 0.475; row 3 errs 0.214, 0.404, 0.463 | confirmed |
| B4 | Error not monotone; $|R_{k,k}-I|$ = 1.6e-3, 0.47, 0.46, 0.046, 8.1e-3, 2.8e-3, 8.7e-4, 2.7e-4 | mpmath: 1.6451e-3, 0.474981, 0.463125, 0.046355, 8.1055e-3, 2.7642e-3, 8.6884e-4, 2.7297e-4 | confirmed |
| B5 | One-panel value $f(0)+f(2)=2.017925$, close only by coincidence | mpmath 2.0179248162 (T_1 = (2/2)(f(0)+f(2))); next level error jumps to 0.475 | confirmed |
| B6 | $x^{2/3}$ makes $f'$ unbounded at 0, $f'(x)\approx\frac{16}{3}x^{-1/3}$ | $f'=-e^{-x}\sin(8x^{2/3})+e^{-x}\cos(8x^{2/3})\cdot\frac{16}{3}x^{-1/3}\to\frac{16}{3}x^{-1/3}$ | confirmed |
| B7 | Textbook error order does not hold | Ratios below | confirmed |
| B8 | Every column, diagonal included, shrinks like $O(h^{5/3})$ not $O(h^{2j})$ | Error ratios at last step (64→128): col1 3.162, col2 3.202, col3 3.182, col4 3.182, col5 3.182, col6 3.182, col7 3.182; all ≈ $2^{5/3}$=3.1748, none near $4^j$ | confirmed |
| B9 | Halving h divides diagonal error by about 3.18 (64→128 subintervals), tending to $2^{5/3}\approx3.17$ | Diagonal ratio 3.18289; extended table: 3.17929, 3.17709, 3.17595, 3.17538, 3.17509 (to 4096 subintervals) → 3.1748 | confirmed |
| B10 | Extrapolation lowers error only by a constant factor, about 4.4 vs trapezoid at 129 points | (T−I)/(R_kk−I) = 4.394 at m=129; extension 4.412, 4.424, 4.432, 4.437, 4.441 (settles to a constant) | confirmed |
| B11 | Last frame $R_{8,8}=2.016007$, still $2.7\times10^{-4}$ below $I\approx2.016280$ | Script 2.016006749516; mpmath 2.01600675; I = 2.0162797196...; diff −2.7297e-4; frame 9 shows R[k,k] = 2.016007, −2.7e-04, I = 2.016280 | confirmed |
| W1 | `[Julia source](rombergaa.jl)` | File exists, is this case's script | confirmed |
| W2 | Embed `rombergaa.gif` | Committed GIF = regenerated output of `rombergaa.jl` (byte-identical) | confirmed |
| ALT | "trapezoidal panels refine globally while the Romberg table adds one row per frame, listing R[k,1], R[k,k] and the diagonal's error R[k,k] - I, which is still -2.7e-04 at 129 sample points" | Frame 9 table header and last row | confirmed |

Table values in frames (all 8 rows, R[k,1], R[k,k], error) were compared to `indep.py`: every 6-decimal value and every error to 2 significant figures agrees (e.g. row 4: 1.906595 / 1.969925 / −4.6e-02; row 6: 2.004331 / 2.013516 / −2.8e-03).

### 3. Implementation checks — `rombergaa.jl`

**Is the method it claims.** Standard Romberg: first column composite trapezoid on $2^{k-1}$ subintervals (each level recomputed from scratch rather than by the sequential/halving update — numerically equivalent), higher columns by Richardson with factor $4^{j-1}-1$. Property check with the script's recurrence (`inst.jl`): column j integrates $x^d$ on [0,2] exactly for $d\le 2j-1$ (errors 0 / 3.6e-15) and fails at $d=2j$ (col1 x^2 2.08e-2, col2 x^4 1.04e-3, col3 x^6 7.44e-4, col4 x^8 4.17e-3). This is the expected degree of precision 1,3,5,7 (trapezoid, Simpson, Boole, ...).

**Numbers right.** Instrumented copy (`julia inst.jl`) printed the full table; independent mpmath (40 digits, `indep.py`) gives the same:

| k | m | script R[k,1] | mpmath R[k,1] | script R[k,k] | mpmath R[k,k] |
|---|---|---|---|---|---|
| 1 | 2 | 2.017924816216 | 2.017924816 | 2.017924816216 | 2.017924816 |
| 2 | 3 | 2.372926966994 | 2.372926967 | 2.491261017253 | 2.491261017 |
| 3 | 5 | 1.802071488234 | 1.802071488 | 1.553154682740 | 1.553154683 |
| 4 | 9 | 1.906594930315 | 1.90659493 | 1.969924760068 | 1.96992476 |
| 5 | 17 | 1.979055856788 | 1.979055857 | 2.008174202398 | 2.008174202 |
| 6 | 33 | 2.004331112084 | 2.004331112 | 2.013515556346 | 2.013515556 |
| 7 | 65 | 2.012487535614 | 2.012487536 | 2.015410885100 | 2.015410885 |
| 8 | 129 | 2.015080262403 | 2.015080262 | 2.016006749516 | 2.01600675 |

The diagonal values also coincide with Mathews' legacy animation (2.491261, 1.553155, 1.969925, 2.008174, 2.013516, 2.015411, 2.016007).

**Reference value.** Script `I_ref = 2.0162797196170963`. Independent: mpmath `quad` after substitution $x=t^3$ gives 2.016279719617096327887...; direct tanh-sinh on 40 subintervals of [0,2] gives the identical 40-digit value. Agrees to full double precision.

**Picture shows what was computed.** Frames 1 (title, curve only), 2, 3, 5, 9 and the contact sheet inspected. Each trapezoid is the polygon (xl,0),(xr,0),(xr,f(xr)),(xl,f(xl)) on the uniform mesh with m−1 panels — correct trapezoid geometry; m=2 frame shows one panel joining f(0)=1 and f(2)≈1.018. Magenta curve is the same f as the script. Annotations "Sample Points = m" and "R[k,k] = …" use the current frame's index. Table rows k, m, R[k,1], R[k,k], R[k,k]−I match the computed values. Axis limits x∈[0,2], y∈[0,2.1] contain the whole curve (max ≈1.92, min ≈0.36); no clamping or masking. 9 frames = 1 title + 8 levels.

### Legacy fidelity

Mathews' only Romberg animation (`a2001/Animations/Quadrature/Rombeg/Rombergaa.gif`, 9 frames) uses $y=e^{-x}\sin(8x^{2/3})+1$ on [0,2] with sample points 3,5,...,129 and the same approximations as this page. The page reproduces it (adding an m=2 level, and drawing trapezoids instead of shading under the curve, which is a more faithful depiction of the first column). The RombergMod examples 1-5 are worked Mathematica examples, not animations; the page's Worked Example section is a placeholder, which is out of scope. No fidelity finding.

