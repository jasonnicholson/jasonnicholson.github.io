# Romberg Integration — animation review (round 4)

Page: `pages/numerical-methods/romberg-integration/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page, every number in the frames, and the reference integral agree with independent computation at the precision stated. No Error, Misleading, Minor or Fidelity findings.

One observation that I judged below the threshold of a finding: the Behavior paragraph and alt text say "Each frame adds one Romberg row" / "adds one row per frame", but the GIF has 9 frames and the first (frame_001) shows only the curve and an empty table; rows are added in frames 2-9. A reader will not be misled by this.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `rombergaa.jl` | 0 | 9.0 | rombergaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Page text (quoted) | Evidence | Verdict |
|---|---|---|---|
| D1 | "$R_{k,1}=T_{2^{k-1}}$" | script: `n = m_seq[k]-1` = 1,2,4,...,128 = $2^{k-1}$ panels, `R[k,1] = trapezoid_sum(n)` (lines 29-30) | confirmed |
| D2 | "$R_{k,j}=R_{k,j-1}+\frac{R_{k,j-1}-R_{k-1,j-1}}{4^{j-1}-1}$, $j=2,\dots,k$" | script line 32 is this formula verbatim; independently, Lagrange extrapolation of $(h_i^2,T_i)$ to $h^2=0$ (formula-free) gives the same diagonal to 12 digits for all 8 rows (`indep.py`) | confirmed |
| D3 | "column $j$ has error $O(h^{2j})$" for $f\in C^{2j}$ | property test of the script's own recurrence (`poly.jl`): $R_{3,3}$ exact for $x^5$ (err 0), not $x^6$ (4.76e-2); $R_{4,4}$ exact for $x^7$, not $x^8$ (4.17e-3); $R_{5,5}$ exact for $x^9$, not $x^{10}$ (1.48e-4), i.e. degree of precision $2k-1$, consistent with $O(h^{2k})$ | confirmed |
| D4 | trapezoid error "expands in even powers of $h$, $T_n-I=c_1h^2+c_2h^4+\cdots$" for smooth $f$ | standard Euler-Maclaurin; consistent with D3 | confirmed |
| A1 | $f(x)=1+e^{-x}\sin(8x^{2/3})$ on $[0,2]$ | script line 9-10; frames' curve | confirmed |
| A2 | sample counts $m=2,3,5,9,17,33,65,129$ | `m_seq` line 14; frame annotations "Sample Points = 2 ... 129" | confirmed |
| A3 | "graph and table are updated together as the trapezoidal mesh is globally refined" | frames 2-9: trapezoids with $m-1$ equal panels, table grows by one row per frame | confirmed |
| A4 | Case heading "Romberg Table Construction, $f(x)=1+e^{-x}\sin(8x^{2/3})$, $[0,2]$" | script | confirmed |
| B1 | "Each frame adds one Romberg row from a denser trapezoidal partition and then applies Richardson extrapolation across the row" | frames 2-9 each add one row; frame 1 is a curve-only frame (see note above) | confirmed (with note) |
| B2 | "$R_{k,k}$ ... is the most accurate entry in its row from $m=9$ on" | `rows.py` argmin column of $|R_{k,j}-I|$ = $k$ for rows $m=9,17,33,65,129$ (e.g. m=129: col7 2.73006e-4 vs col8 2.72970e-4) | confirmed |
| B3 | "at $m=3$ and $m=5$ it is the least accurate" | m=3: 0.357 (col1) vs 0.475 (diag); m=5: 0.214, 0.404, 0.463 (diag) — argmax = diag | confirmed |
| B4 | errors "$1.6\times10^{-3}$, $0.47$, $0.46$, $0.046$, $8.1\times10^{-3}$, $2.8\times10^{-3}$, $8.7\times10^{-4}$, $2.7\times10^{-4}$" | independent: 1.645e-3, 0.47498, 0.46313, 0.046355, 8.1055e-3, 2.7642e-3, 8.6883e-4, 2.7297e-4 | confirmed |
| B5 | "Its error is not monotone" | 1.6e-3 → 0.47 increases | confirmed |
| B6 | "$f(0)+f(2)=2.017925$", one-panel value | $T_1=\tfrac{2}{2}(f(0)+f(2))$; mpmath 2.017924816 | confirmed |
| B7 | "$f'$ unbounded at $x=0$ ($f'(x)\approx\tfrac{16}{3}x^{-1/3}$ near 0)" | mpmath: $f'(10^{-6})\cdot 10^{-2}=5.33332$ ≈ 16/3 | confirmed |
| B8 | "measured error of every column, the diagonal included, shrinks like $O(h^{5/3})$" | last error ratios per column (65→129 points): col1 3.162, col2 3.202, col3 3.182, col4 3.182, col5 3.182, col6 3.182, col7 3.182; extended run to 4097 points: trapezoid ratio 3.1723, diagonal 3.1751, both → $2^{5/3}=3.1748$ | confirmed |
| B9 | "halving $h$ divides the diagonal error by about 3.18 (from 64 to 128 subintervals), tending to $2^{5/3}\approx 3.17$" | diag ratio 8.6883e-4/2.7297e-4 = 3.183; extended sequence 3.1829, 3.1793, 3.1771, 3.1760, 3.1754, 3.1751; $2^{5/3}=3.1748$ | confirmed |
| B10 | "extrapolation lowers the error only by a constant factor (about 4.4 against the trapezoid column at 129 sample points)" | 1.19946e-3 / 2.72970e-4 = 4.394 | confirmed |
| B11 | "last frame's $R_{8,8}=2.016007$ is still $2.7\times10^{-4}$ below $I\approx 2.016280$" | $R_{8,8}$=2.0160067495; $I$=2.0162797196; diff −2.7297e-4; frame_009 shows 2.016007, −2.7e-04, I = 2.016280 | confirmed |
| W1 | `[Julia source](rombergaa.jl)` | file exists, is the script producing the GIF | confirmed |
| W2 | `![...](rombergaa.gif)` | committed GIF = regenerated output of `rombergaa.jl` (byte-identical, manifest) | confirmed |
| W3 | Alt text: "trapezoidal panels refine globally while the Romberg table adds one row per frame, listing R[k,1], R[k,k] and the diagonal's error R[k,k] - I, which is still -2.7e-04 at 129 sample points" | frame_009 table columns k, m, R[k,1], R[k,k], R[k,k]-I; last row −2.7e-04 (frame 1 adds no row, see note) | confirmed |
| F1 | Frame table values (all 8 rows of R[k,1], R[k,k], R[k,k]−I) | frame_009 vs `rows.py`: 2.017925/2.017925/+1.6e-3; 2.372927/2.491261/+4.7e-1; 1.802071/1.553155/−4.6e-1; 1.906595/1.969925/−4.6e-2; 1.979056/2.008174/−8.1e-3; 2.004331/2.013516/−2.8e-3; 2.012488/2.015411/−8.7e-4; 2.015080/2.016007/−2.7e-4 — all match | confirmed |

### 3. Implementation checks — `rombergaa.jl`

**Method is what it claims.** Composite trapezoid with $n=2^{k-1}$ equal panels (lines 21-25, 29-30) followed by the standard Romberg/Richardson recurrence with divisor $4^{j-1}-1$ (line 32). This is classic Romberg integration (non-recursive trapezoid evaluation, which is mathematically identical to the recursive midpoint-refinement form). Polynomial-exactness test of the script's own routine (`poly.jl`) shows degree of precision $2k-1$ for $R_{k,k}$ exactly as Romberg should.

**Numbers are right.** Instrumented copy (`instr.jl`) beside independent mpmath (50 digits, `indep.py`):

| k | m | script R[k,1] | script R[k,k] | mpmath R[k,k] | R[k,k]−I |
|---|---|---|---|---|---|
| 1 | 2 | 2.017924816215668 | 2.017924816215668 | 2.01792481622 | +1.645097e-03 |
| 2 | 3 | 2.372926966994002 | 2.491261017253446 | 2.49126101725 | +4.749813e-01 |
| 3 | 5 | 1.802071488234084 | 1.553154682740378 | 1.55315468274 | −4.631250e-01 |
| 4 | 9 | 1.906594930314552 | 1.969924760068105 | 1.96992476007 | −4.635496e-02 |
| 5 | 17 | 1.979055856788160 | 2.008174202397756 | 2.00817420240 | −8.105517e-03 |
| 6 | 33 | 2.004331112084414 | 2.013515556345729 | 2.01351555635 | −2.764163e-03 |
| 7 | 65 | 2.012487535613616 | 2.015410885099917 | 2.01541088510 | −8.688345e-04 |
| 8 | 129 | 2.015080262402557 | 2.016006749516376 | 2.01600674952 | −2.729701e-04 |

Independent diagonal also obtained by formula-free polynomial extrapolation in $h^2$ to 0 (Lagrange through the $k$ trapezoid values): identical to 12 digits.

**Reference value is right.** Script `I_ref = 2.0162797196170963`. mpmath, both via the substitution $x=t^3$ and via direct tanh-sinh with breakpoints: 2.01627971961709632788727442192. Agrees to all 17 digits stored.

**Picture shows what was computed.** Frames 1, 4, 5, 9 and the contact sheet inspected. Each trapezoid is the polygon $(x_l,0),(x_r,0),(x_r,f(x_r)),(x_l,f(x_l))$ with heights at the correct nodes (lines 45-54); in frame 4 (m=5) the vertices sit on the curve at x=0,0.5,1,1.5,2. The annotation `R[k,k] = round(R[frame,frame],6)` uses the correct index; the table rows use `R[k,1]`, `R[k,k]`, `R[k,k]-I_ref` with matching headers. No clamping or masking; axis limits $[0,2]\times[0,2.1]$ contain the whole curve (f range 0.357 to 1.920 on a 200001-point grid). Frame count 9 = 1 curve-only frame + 8 levels.

**Legacy fidelity.** Mathews' animation `Rombergaa.gif` (9 frames) uses the same function $e^{-x}\sin(8x^{2/3})+1$, interval [0,2], sample points 2…129, and reports "Approximation = 1.553155" at 5 points and "2.016007" at 129 points, matching this page's $R_{k,k}$. The legacy GIF shades area under the curve with sample stems; the page draws the actual trapezoids, which is a faithful (arguably more accurate) depiction. The module `RombergMod.html` has five worked examples that were never animations in the archive; the page's Animations section covers the single archive animation, so no case is dropped.

