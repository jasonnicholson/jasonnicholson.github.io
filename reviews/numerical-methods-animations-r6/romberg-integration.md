# Romberg Integration — animation review (round 6)

Page: `pages/numerical-methods/romberg-integration/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page and every number in the frames agrees with my independent computation; the implementation is standard Romberg integration and reproduces the legacy example exactly.

(Observations considered and deliberately not raised as findings: the introduction says "Each animation below" although there is one animation; the first GIF frame shows only the curve and an empty table, so "each frame adds one Romberg row" holds for frames 2-9; the table panel shows only columns 1 and k, not the intermediate extrapolation columns. None of these changes what a reader concludes.)



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `rombergaa.jl` | 0 | 8.6 | rombergaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Page claim (page's words) | Evidence | Verdict |
|---|---|---|---|
| D1 | "Romberg integration accelerates composite trapezoidal approximations with Richardson extrapolation" | Script lines 21-34: composite trapezoid column + Richardson recurrence | confirmed |
| D2 | $R_{k,1}=T_{2^{k-1}}$ | Script `n = m_seq[k]-1` = 1,2,4,...,128 = $2^{k-1}$ subintervals | confirmed |
| D3 | $R_{k,j}=R_{k,j-1}+\frac{R_{k,j-1}-R_{k-1,j-1}}{4^{j-1}-1}$, $j=2,\dots,k$ | Script line 32 identical. Exactness test (`instr.jl`): column j integrates $x^p$ exactly for $p\le 2j-1$ and not $p=2j$ (col1 exact p≤1, err 5.2e-3 at p=2; col2 exact p≤3, 6.5e-5 at p=4; col3 exact p≤5, 1.2e-5 at p=6; col4 exact p≤7, 1.6e-5 at p=8; col5 exact p≤9) | confirmed |
| D4 | For smooth f ($C^{2j}$), $T_n-I=c_1h^2+c_2h^4+\cdots$, column j has error $O(h^{2j})$ | `smooth.py`, $\int_0^2 e^x$: halving-h error ratios col1→4.00, col2→16.0, col3→63.98, col4→255.6 | confirmed |
| A1 | Function $f(x)=1+e^{-x}\sin(8x^{2/3})$ on $[0,2]$ (intro and Case 1 heading) | Script lines 9-10 | confirmed |
| A2 | Sample counts $m=2,3,5,9,17,33,65,129$, globally refined mesh | Script line 14; frames show panels with 1,2,4,...,128 subintervals | confirmed |
| A3 | "The graph and table are updated together" | Frames 2-9: left panel and table both advance one level per frame | confirmed |
| A4 | "Each frame adds one Romberg row from a denser trapezoidal partition and then applies Richardson extrapolation across the row" | Frames 2-9 each add one row; frame 1 is the bare curve with empty table (9 frames total). Recurrence applied across row (line 31-33) | confirmed (frame 1 is an intro frame) |
| A5 | Diagonal $R_{k,k}$ is the most accurate entry in its row from $m=9$ on | `indep2.py`: diag has smallest error in rows 4-15 (row 8: col7 2.73006e-4, diag 2.72970e-4) | confirmed |
| A6 | At $m=3$ and $m=5$ the diagonal is the least accurate entry | Row 2 errs 0.357, 0.475; row 3 errs 0.214, 0.404, 0.463 | confirmed |
| A7 | Error not monotone | 1.645e-3 → 0.475 → 0.463 → ... | confirmed |
| A8 | $\lvert R_{k,k}-I\rvert$ = 1.6e-3, 0.47, 0.46, 0.046, 8.1e-3, 2.8e-3, 8.7e-4, 2.7e-4 | Independent (mpmath): 1.6451e-3, 0.474981, 0.463125, 0.046355, 8.1055e-3, 2.7642e-3, 8.6884e-4, 2.7297e-4 | confirmed (all at stated precision) |
| A9 | One-panel value $f(0)+f(2)=2.017925$ | 2.0179248162 (= $\tfrac{2}{2}(f(0)+f(2))$) | confirmed |
| A10 | $f'(x)\approx\tfrac{16}{3}x^{-1/3}$ near 0, unbounded | mpmath: $f'(10^{-6})\,x^{1/3}=5.33332$ vs 16/3=5.33333 | confirmed |
| A11 | Every column, diagonal included, shrinks like $O(h^{5/3})$, not $O(h^{2j})$ | Halving ratios at the last available level: col1 3.16, col2 3.20, col3 3.18, col4 3.18, diag 3.18; extended to 16385 points, col1→3.173, diag→3.1749 | confirmed |
| A12 | Diagonal error divided by about 3.18 from 64 to 128 subintervals, tending to $2^{5/3}\approx3.17$ | Ratio 3.18289; extended rows 3.17929, 3.17709, ..., 3.17487; $2^{5/3}=3.17480$ | confirmed |
| A13 | Extrapolation gains only a constant factor, about 4.4 against the trapezoid column at 129 points | $\lvert R_{8,1}-I\rvert/\lvert R_{8,8}-I\rvert$ = 1.19946e-3/2.72970e-4 = 4.394 | confirmed |
| A14 | Last frame $R_{8,8}=2.016007$, still $2.7\times10^{-4}$ below $I\approx2.016280$ | $R_{8,8}$=2.0160067495, I=2.0162797196, diff −2.7297e-4 | confirmed |
| A15 | Alt text: trapezoid panels refine globally; table adds a row per frame listing R[k,1], R[k,k], R[k,k]−I; −2.7e-04 at 129 sample points | Frame 9: header "k m R[k,1] R[k,k] R[k,k] - I", last row "8 129 2.015080 2.016007 -2.7e-04" | confirmed |
| A16 | Wiring: `[Julia source](rombergaa.jl)`, embed `rombergaa.gif` | Both files exist in the page folder; GIF is byte-identical to the scratch run of that script | confirmed |
| F1 | Frame values shown in table (R[k,1], R[k,k], error) | All 8 rows in frame 9 match `instr.jl` and the independent mpmath table to 6 decimals (e.g. row 3: 1.802071, 1.553155, −4.6e-01) | confirmed |

### 3. Implementation checks — `rombergaa.jl`

**Is the method it claims to be.** Yes. Column 1 is the composite trapezoidal rule on $2^{k-1}$ equal subintervals (lines 21-25, 29-30), and higher columns use the standard Romberg/Richardson recurrence with divisor $4^{j-1}-1$ (line 32). This is the textbook Romberg table, run for a fixed 8 rows (no tolerance stop; the legacy example also shows exactly these 8 rows).

**Numbers are right.** Script output (instrumented copy `instr.jl`) beside independent mpmath computation (`indep.py`, 40 digits):

| k | m | script R[k,1] | indep R[k,1] | script R[k,k] | indep R[k,k] |
|---|---|---|---|---|---|
| 1 | 2 | 2.0179248162 | 2.017924816 | 2.0179248162 | 2.017924816 |
| 2 | 3 | 2.3729269670 | 2.372926967 | 2.4912610173 | 2.491261017 |
| 3 | 5 | 1.8020714882 | 1.802071488 | 1.5531546827 | 1.553154683 |
| 4 | 9 | 1.9065949303 | 1.90659493 | 1.9699247601 | 1.96992476 |
| 5 | 17 | 1.9790558568 | 1.979055857 | 2.0081742024 | 2.008174202 |
| 6 | 33 | 2.0043311121 | 2.004331112 | 2.0135155563 | 2.013515556 |
| 7 | 65 | 2.0124875356 | 2.012487536 | 2.0154108851 | 2.015410885 |
| 8 | 129 | 2.0150802624 | 2.015080262 | 2.0160067495 | 2.01600675 |

Property checks of the same recurrence: polynomial degree of precision 2j−1 for column j (table D3 above), and $4^j$ error reduction per halving for a smooth integrand (D4). The legacy Mathews animation shows the same approximations (2.491261, 1.553155, 1.969925, 2.008174, 2.013516, 2.015411, 2.016007).

**Reference value is right.** `I_ref = 2.0162797196170963`; mpmath via $x=t^3$ substitution and via direct subdivided quadrature both give 2.016279719617096327887…; difference −2.8e-17. Ample for 1-2 significant-figure error reporting.

**Picture shows what was computed.** Frames 1, 2, 3, 5, 9 inspected at full size and all frames on the contact sheet. Each trapezoid is built from `f(xl)`, `f(xr)` at the mesh nodes (lines 45-54); frame 3 shows the two-panel trapezoid with vertices at (0,1), (1,f(1)≈1.36), (2,1.018), on the curve. The magenta curve is the same `f`. Annotation "Sample Points = m" and "R[k,k] = …" use `m_seq[frame]` and `R[frame,frame]` (correct index). Axis limits [0,2]×[0,2.1] contain the whole curve (max ≈1.92 near x≈0.08). No clamping or masking. Table panel rows match the computed table. Frame count 9 = 1 intro + 8 levels.

**Legacy fidelity.** Mathews Example 6 / Animation 1 uses the same $f(x)=e^{-x}\sin(8x^{2/3})+1$ on [0,2] with m = 2,…,129 sample points; the page reproduces this case and its values. The archive's Examples 1-5 are worked examples (not animations) and correspond to the page's "Worked Example (Planned)" section, which is out of scope. No fidelity departure.

