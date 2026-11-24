# Romberg Integration — animation review (round 8)

Page: `pages/numerical-methods/romberg-integration/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** (0 Error, 0 Misleading, 0 Minor.)

Observed but not reported as findings (cosmetic, not misleading): the "Romberg Table" panel shows faint grid lines although `axis=false`; the table columns are not perfectly aligned because a proportional font is used (row 8, `m=129`, shifts right). The intro says "Each animation below" although there is one animation.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `rombergaa.jl` | 0 | 8.4 | rombergaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Claim (page wording) | Evidence | Verdict |
|---|---|---|---|
| D1 | "Romberg integration accelerates composite trapezoidal approximations with Richardson extrapolation" | script lines 27-34 | confirmed |
| D2 | $R_{k,1}=T_{2^{k-1}}$ | script uses `n = m_seq[k]-1` = 1,2,4,...,128 = 2^{k-1} subintervals | confirmed |
| D3 | $R_{k,j}=R_{k,j-1}+(R_{k,j-1}-R_{k-1,j-1})/(4^{j-1}-1)$, j=2..k | script line 32 identical; polynomial test (below) confirms the formula's degree of precision | confirmed |
| D4 | trapezoid error expands in even powers of h; column j has error O(h^{2j}) for f in C^{2j} | standard Euler-Maclaurin; the script's routine on x^2,x^4,x^6,x^8 over [0,2]: R22 exact for x^2, error 0.267 for x^4; R33 exact through x^4, error 0.0476 for x^6; R44 exact through x^6 (3.6e-15), error 4.2e-3 for x^8 -> degree of precision 2k-1 for R_kk | confirmed |
| A1 | f(x)=1+e^{-x}sin(8x^{2/3}) on [0,2] | script line 9-10; legacy frame title "y = e^{-x} sin(8x^{2/3}) + 1" | confirmed |
| A2 | sample counts m=2,3,5,9,17,33,65,129 | script line 14; frames | confirmed |
| A3 | graph and table updated together; mesh globally refined | frames 2-9 | confirmed |
| A4 | Case heading: Romberg Table Construction, same f, [0,2] | script | confirmed |
| B1 | Opening frame shows f alone with an empty table | frame_001: curve only; table has header and "I = 2.016280" line, no rows | confirmed |
| B2 | each frame adds one Romberg row from a denser partition and applies Richardson across the row | 9 frames = 1 + 8 rows; script fills full row; table displays R[k,1], R[k,k] only (alt text says so) | confirmed |
| B3 | R_kk most accurate in its row from m=9 on | full-precision argmin of row errors: rows 4-8 best column = k | confirmed |
| B4 | at m=3 and m=5, R_kk least accurate | rows 2,3 worst column = k (row 2: 0.36 vs 0.47; row 3: 0.21, 0.40, 0.46) | confirmed |
| B5 | |R_kk-I| = 1.6e-3, 0.47, 0.46, 0.046, 8.1e-3, 2.8e-3, 8.7e-4, 2.7e-4 | mpmath: 1.645e-3, 0.475, 0.463, 0.0464, 8.11e-3, 2.76e-3, 8.69e-4, 2.73e-4 | confirmed |
| B6 | error not monotone | 1.6e-3 -> 0.475 | confirmed |
| B7 | one-panel value f(0)+f(2)=2.017925, close only by coincidence | mpmath 2.0179248162; next trapezoid error 0.36 | confirmed |
| B8 | f'(x) ~ (16/3)x^{-1/3} near 0, unbounded | d/dx sin(8x^{2/3}) = (16/3)x^{-1/3}cos(...), e^{-x}->1 | confirmed |
| B9 | every column's error shrinks like O(h^{5/3}) | last-step ratios per column: 3.162, 3.202, 3.182, 3.182, 3.182, 3.182, 3.182; extended col-1 ratios -> 3.1736 at 2^15 | confirmed |
| B10 | diagonal error ratio about 3.18 from 64 to 128 subintervals, tending to 2^{5/3}=3.17 | 3.183; extended (16 levels, double): 3.1829, 3.1793, 3.1771, ..., 3.1749, 3.1748; 2^{5/3}=3.17480 | confirmed |
| B11 | extrapolation gains about 4.4 vs trapezoid column at 129 points | |R81-I|/|R88-I| = 4.394 | confirmed |
| B12 | last frame R_88=2.016007, 2.7e-4 below I~2.016280 | mpmath R88 = 2.01600675, I = 2.0162797196, diff -2.73e-4; frame_009 shows same | confirmed |
| W1 | `[Julia source](rombergaa.jl)` link and embed `rombergaa.gif` | both exist; manifest: regen byte-identical | confirmed |
| W2 | alt text: lists R[k,1], R[k,k], R[k,k]-I; still -2.7e-04 at 129 points; opening frame f alone | frame_009 last row "-2.7e-04"; header columns match | confirmed |
| L1 | Fidelity to Mathews animation (function, interval, m sequence, final 2.016007) | legacy Rombergaa.gif: same f, [0,2], 9 frames, 129 sample points, "Approximation = 2.016007"; lnk_7 lists m = 2,...,129 | confirmed |

### 3. Implementation checks: `rombergaa.jl`

- **Method:** standard Romberg: composite trapezoid with 2^{k-1} panels in column 1, Richardson with factors 4^{j-1}-1. Not a variant. Trapezoid sums are recomputed from scratch at each level rather than reusing previous points (equivalent values).
- **Numbers:** instrumented copy prints the full table; independent mpmath (40 digits) table agrees to all 10 printed digits on every entry checked, e.g. row 8: script 2.0150802624 / 2.0160067495, mpmath 2.015080262 / 2.01600675; row 3: 1.8020714882 / 1.5531546827 vs 1.802071488 / 1.553154683. Degree-of-precision test above confirms the extrapolation coefficients independently of memory.
- **Reference value:** I_ref = 2.0162797196170963. Independent: mpmath quad after x=t^3 substitution = 2.016279719617096327887...; tanh-sinh on 19 subintervals of the original integrand agrees to 4.6e-41. Confirmed.
- **Picture:** trapezoid shapes use f at the panel endpoints (lines 45-54); panel counts 1,2,4,...,128 visible in frames 2-9; annotation "Sample Points" = m and "R[k,k]" = diagonal entry of the current row; table rows match independent values to 6 decimals; ylims (0,2.1) contain f's max (~1.92); no clamping or masking. Frame count 9 = opening + 8 rows.

