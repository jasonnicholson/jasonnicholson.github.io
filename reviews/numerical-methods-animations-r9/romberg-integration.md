# Romberg Integration — animation review (round 9)

Page: `pages/numerical-methods/romberg-integration/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page, every value drawn in the GIF, and the script's reference integral agree with independent computation at the precision stated. (Considered and rejected as non-findings: "Each animation below" for a single animation is wording only; "every column ... shrinks like O(h^{5/3})" cannot be measured for column 8, which has one entry, but the diagonal ratio stated alongside covers it; the plot panel does not name f in its title, but the case heading does.)



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `rombergaa.jl` | 0 | 9.8 | rombergaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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
| D1 | $R_{k,1}=T_{2^{k-1}}$ | script: `n = m_seq[k]-1`, `m_seq = 2^{k-1}+1` → n = 1,2,4,...,128 | confirmed |
| D2 | $R_{k,j}=R_{k,j-1}+(R_{k,j-1}-R_{k-1,j-1})/(4^{j-1}-1)$, j=2..k | script line 32 identical | confirmed |
| D3 | trapezoid error expands in even powers; column j has error $O(h^{2j})$ for $f\in C^{2j}$ | Euler–Maclaurin; property check: at k=8 column j is exact (≤2e-16 rel.) for x^d, d ≤ 2j-1, and not for d = 2j (col1 fails at d=2, col2 at d=4, col3 at d=6, col4 at d=8) | confirmed |
| A1 | $f(x)=1+e^{-x}\sin(8x^{2/3})$ on $[0,2]$ | script line 9–10 | confirmed |
| A2 | sample counts m = 2,3,5,9,17,33,65,129 | script line 14; frame annotations "Sample Points = 2 ... 129" | confirmed |
| A3 | "graph and table are updated together as the trapezoidal mesh is globally refined" | frames 2–9: panels uniform, table row added in same frame | confirmed |
| A4 | link `rombergaa.jl`, embed `rombergaa.gif` are this case | manifest: rombergaa.jl regenerates rombergaa.gif byte-identically | confirmed |
| C1 | Case heading: f and [0,2] | as A1 | confirmed |
| B1 | opening frame shows f alone with empty table | frame_001: magenta curve only, table header + "I = 2.016280" only | confirmed |
| B2 | each frame adds one row from a denser partition, Richardson across the row | frames 2–9 add rows k=1..8; 9 frames total | confirmed |
| B3 | $R_{k,k}$ most accurate in its row from m=9 on | |R_{k,j}-I| rows: m=9 [0.110, 0.0748, 0.0529, 0.0464]; m=17 [...,0.00811]; m=33,65,129 diagonal minimal (strictly decreasing along row) | confirmed |
| B4 | at m=3 and m=5 diagonal least accurate | m=3 [0.357, 0.475]; m=5 [0.214, 0.404, 0.463] | confirmed |
| B5 | |R_kk − I| = 1.6e-3, 0.47, 0.46, 0.046, 8.1e-3, 2.8e-3, 8.7e-4, 2.7e-4 | computed: 1.645e-3, 0.47498, 0.46313, 0.046355, 8.1055e-3, 2.7642e-3, 8.6883e-4, 2.7297e-4 | confirmed (all) |
| B6 | error not monotone | sequence above rises 1.6e-3 → 0.475 | confirmed |
| B7 | $f(0)+f(2)=2.017925$ is the one-panel value | T_1 = (2/2)(f(0)+f(2)) = 2.0179248162 | confirmed |
| B8 | $f'$ unbounded at 0, $f'\approx\frac{16}{3}x^{-1/3}$ | mpmath: f'(x)/(16/3 x^{-1/3}) = 0.9999972 at 1e-6, 0.999999997 at 1e-9 | confirmed |
| B9 | every column's error shrinks like $O(h^{5/3})$ | last halving ratios: col1 3.162, col2 3.202, col3 3.182, col4 3.182, col5 3.182, col6 3.182, col7 3.182; extended to 2^13 panels col1 → 3.1728, diag → 3.1749; 2^{5/3}=3.1748 | confirmed |
| B10 | diagonal error ratio ≈3.18 from 64 to 128 subintervals, tending to 3.17 | 3.1829; extended sequence 3.1815, 3.1829, 3.1793, 3.1771, 3.1760, 3.1754, 3.1751, 3.1749 | confirmed |
| B11 | extrapolation only a constant factor, ≈4.4 vs trapezoid at 129 points | |T−I|/|R88−I| = 4.394; extended 4.39, 4.41, 4.42, 4.43, 4.44, 4.44 (bounded) | confirmed |
| B12 | last frame $R_{8,8}=2.016007$, 2.7e-4 below $I\approx2.016280$ | R88 = 2.0160067495; I = 2.0162797196; diff −2.7297e-4; frame_009 shows these | confirmed |
| Alt | alt text: opening frame f alone, one row per frame, columns R[k,1], R[k,k], R[k,k]−I, still −2.7e-04 at 129 points | frames 1 and 9; table header matches | confirmed |

### 3. Implementation checks — `rombergaa.jl`

**Method.** Standard Romberg: composite trapezoid with n = 2^{k-1} panels in column 1 (computed fresh each level rather than by the sequential/halving update — same values), Richardson recurrence with 4^{j-1}−1. This is the method named on the page and in the Description.

**Numbers.** Instrumented copy (`inst.jl`) vs independent mpmath (`indep.py`, 40 digits):

| k | m | script R[k,1] | mpmath R[k,1] | script R[k,k] | mpmath R[k,k] |
|---|---|---|---|---|---|
| 1 | 2 | 2.017924816215668 | 2.017924816 | 2.017924816215668 | 2.017924816 |
| 2 | 3 | 2.372926966994002 | 2.372926967 | 2.491261017253446 | 2.491261017 |
| 3 | 5 | 1.802071488234084 | 1.802071488 | 1.553154682740378 | 1.553154683 |
| 4 | 9 | 1.906594930314552 | 1.906594930 | 1.969924760068105 | 1.969924760 |
| 5 | 17 | 1.979055856788160 | 1.979055857 | 2.008174202397756 | 2.008174202 |
| 6 | 33 | 2.004331112084414 | 2.004331112 | 2.013515556345729 | 2.013515556 |
| 7 | 65 | 2.012487535613616 | 2.012487536 | 2.015410885099917 | 2.015410885 |
| 8 | 129 | 2.015080262402557 | 2.015080262 | 2.016006749516376 | 2.016006750 |

Property check (script's own `trapezoid_sum` and recurrence with f = x^d on [0,2]): column j exact through degree 2j−1 and not degree 2j, for j = 1..5 — the correct degrees of precision of Romberg columns.

**Reference value.** `I_ref = 2.0162797196170963`. Independent: mpmath quad after x = t^3 → 2.016279719617096327887…; direct mpmath quad on 8 subintervals → same 40 digits. Correct to double precision.

**Picture.** Trapezoids built from f at the panel endpoints (lines 46–54), panel count n = m−1 matches "Sample Points = m". Plot annotation "R[k,k]" shows R[frame,frame] = diagonal for the current level. Table columns R[k,1], R[k,k], R[k,k]−I printed from the same array; values in frames 2–9 match the table above to 6 decimals; error column matches B5. Axis limits y ∈ [0, 2.1] contain f (min ≈0.36, max ≈1.92); no clamping or masking. 9 frames = opening + 8 levels. Annotations do not overlap the curve in any frame (contact sheet reviewed).

**Legacy fidelity.** Mathews a2001 `Rombergaa.gif`: same f = e^{-x} sin(8x^{2/3}) + 1, same interval [0,2], sample points 3,5,...,129, approximations 2.491261, 1.553155, 1.969925, 2.008174, 2.013516, 2.015411, 2.016007 — identical to the script's diagonal. The page adds an m=2 row and a table panel (a superset), and draws true trapezoids where the legacy shades under the curve. The n2003 module's Examples 1–5 are worked examples, not animations; the page's worked example section is planned content, not a dropped animation case. No fidelity finding.

