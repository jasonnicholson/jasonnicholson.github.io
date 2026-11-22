# Romberg Integration — animation review (round 2)

Page: `pages/numerical-methods/romberg-integration/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every numerical, behavioural, parameter and wiring claim on the page was checked against independent computation and the frames and holds at the precision stated. I considered and rejected the following as findings (recorded so a clean result can be audited):

- The left panel prints `R[k,k] = …` over shaded trapezoids whose area is `R[k,1]` (e.g. frame 3: shaded area 2.372927, label 2.491261). The label explicitly names `R[k,k]`, the table beside it lists both values, and the page never claims the shaded area equals the diagonal value; Mathews' original does the same ("Approximation = 2.491261" at 3 points). Not misleading enough to report.
- "Each frame adds one Romberg row": frame 1 is a lead-in frame (curve only, empty table); frames 2-9 each add exactly one row. Trivial.
- Table header "R[k,k] - I" sits slightly right of its column; faint grid lines in the table panel. Cosmetic, fully readable.
- "Each animation below" with only one animation. Wording only.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `rombergaa.jl` | 0 | 7.9 | rombergaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Claim (page's words) | Location | Evidence | Verdict |
|---|---|---|---|---|
| D1 | $R_{k,1}=T_{2^{k-1}}$ | Description l.13-14 | script l.29-30: `n = m_seq[k]-1` = 1,2,4,…,128 = $2^{k-1}$ subintervals | confirmed |
| D2 | $R_{k,j}=R_{k,j-1}+\frac{R_{k,j-1}-R_{k-1,j-1}}{4^{j-1}-1}$, $j=2..k$ | l.18 | identical to script l.32; equals my independent $(4^{j-1}R_{k,j-1}-R_{k-1,j-1})/(4^{j-1}-1)$ form (tables agree to 12 digits) | confirmed |
| D3 | Trapezoid error expands in even powers of $h$; column $j$ error $O(h^{2j})$ for $f\in C^{2j}$ | l.21 | `poly.py`: script recurrence gives $R_{k,k}$ exact for $x^p$, $p\le 2k-1$, and inexact at $p=2k$ (R22 exact to deg 3, err 0.267 on $x^4$; R33 to deg 5, err 0.0476 on $x^6$; R44 to deg 7, err 0.00417 on $x^8$) — consistent with $O(h^{2k})$ | confirmed |
| D4 | Diagonal converges quickly for smooth integrands, often beats raw trapezoid | l.21 | general statement, consistent with D3 | confirmed |
| A1 | $f(x)=1+e^{-x}\sin(8x^{2/3})$ on $[0,2]$ | intro l.26, heading l.31, alt | script l.9-10; GIF curve shape matches; Mathews Example 6/animation title $y=e^{-x}\sin(8x^{2/3})+1$, $[0,2]$ | confirmed |
| A2 | Sample counts $m=2,3,5,9,17,33,65,129$ | l.27 | script l.14; frames 2-9 show these counts; Mathews Example 6 lists the same $m$ | confirmed |
| A3 | Graph and table updated together; mesh globally refined | l.26 | frames 2-9: panels uniform with $m-1$ subintervals, table row added in same frame | confirmed |
| A4 | Each frame adds one row from a denser partition, then extrapolates across the row | l.33 | script l.31-33; frames 2-9 add one row each (frame 1 is a lead-in) | confirmed |
| A5 | $R_{k,k}$ most accurate in its row from $m=9$ on | l.33 | `instr.jl` row errors: m=9: 1.10e-1, 7.48e-2, 5.29e-2, **4.64e-2**; m=17 … m=129 the last column is the minimum (m=129: 2.7297e-4 vs 2.7298e-4 for col 7) | confirmed |
| A6 | At $m=3$ and $m=5$ the diagonal is least accurate | l.33 | m=3: 0.357 vs **0.475**; m=5: 0.214, 0.405, **0.463** | confirmed |
| A7 | Error not monotone | l.33 | 1.6e-3 → 0.475 → 0.463 → … | confirmed |
| A8 | $\lvert R_{k,k}-I\rvert$ = 1.6e-3, 0.47, 0.46, 0.046, 8.1e-3, 2.8e-3, 8.7e-4, 2.7e-4 | l.33 | mpmath: 1.645e-3, 0.4750, 0.4631, 0.04635, 8.106e-3, 2.764e-3, 8.688e-4, 2.730e-4 | confirmed |
| A9 | $f(0)+f(2)=2.017925$ at $m=2$ | l.33 | mpmath 2.017924816 | confirmed |
| A10 | $m=2$ value close "only by coincidence" | l.33 | one-panel error 1.6e-3 while the 2-panel trapezoid error is 0.357 and the next diagonal 0.475; no systematic reason | confirmed |
| A11 | $f'$ unbounded at 0, $f'(x)\approx\frac{16}{3}x^{-1/3}$ | l.33 | sympy: $\lim_{x\to0} f'(x)/x^{-1/3} = 16/3$ | confirmed |
| A12 | Every column, diagonal included, shrinks like $O(h^{5/3})$, not $O(h^{2j})$ | l.33 | ratios err(65)/err(129) per column: 3.162, 3.202, 3.182, 3.182, 3.183, 3.183, 3.183 vs $2^{5/3}=3.1748$ | confirmed |
| A13 | Halving $h$ divides diagonal error by about 3.18 (64→128 subintervals), tending to $2^{5/3}\approx3.17$ | l.33 | 3.1829; continuing (`more.py`): 3.1793, 3.1771, 3.1760, 3.1754, 3.1751, 3.1750 at 8193 points → 3.1748 | confirmed |
| A14 | Extrapolation helps only by a constant factor, about 4.4 vs trapezoid at 129 points | l.33 | trap/diag error ratio 4.394 at 129; 4.41, 4.42, 4.43, 4.44, 4.44 further; asymptote $\prod_j (4^j-1)/(4^j-2^{5/3}) = 4.4545$ | confirmed |
| A15 | Last frame $R_{8,8}=2.016007$, $2.7\times10^{-4}$ below $I\approx2.016280$ | l.33 | mpmath $R_{8,8}=2.0160067495$, $I=2.0162797196$, diff $-2.730\times10^{-4}$; frame 9 shows the same | confirmed |
| W1 | `[Julia source](rombergaa.jl)` is Case 1 | l.35 | file exists; computes this case | confirmed |
| W2 | Embed `rombergaa.gif` is Case 1 | l.37 | byte-identical to regeneration of `rombergaa.jl` (manifest) | confirmed |
| ALT1 | Trapezoidal panels refine globally while table adds one row per frame | l.37 | frames 2-9 | confirmed |
| ALT2 | Table lists R[k,1], R[k,k] and R[k,k] − I | l.37 | frame 9 table columns; script l.69-71 | confirmed |
| ALT3 | Error still −2.7e-04 at 129 sample points | l.37 | frame 9 row 8 "-2.7e-04"; mpmath −2.730e-4 | confirmed |
| F1 | (Fidelity) same function, interval and $m$ sequence as Mathews Example 6 / Rombergaa animation | archive | Mathews' frames show $y=e^{-x}\sin(8x^{2/3})+1$ on [0,2], points 3…129 with approximations 2.491261, 1.553155, 1.969925, 2.008174, 2.013516, 2.015411, 2.016007 — identical to the page's $R_{k,k}$. Example 6's tol 0.001 stop rule ($\lvert R_{k,k}-R_{k-1,k-1}\rvert$: 1.9e-3 at row 7, 6.0e-4 at row 8) also ends at 129 points. Page adds the $m=2$ row, which Mathews' table also lists. | confirmed, no departure |

### 3. Implementation checks — `rombergaa.jl`

**Method.** Classical Romberg: composite trapezoid on $2^{k-1}$ uniform subintervals (l.21-25, l.29-30), each trapezoid sum recomputed from scratch rather than by the sequential halving formula (equivalent values), followed by Richardson extrapolation with factors $4^{j-1}$ (l.31-33). This is the method in the title and the Description; no hybrid or variant.

**Numbers.** Script (instrumented copy `instr.jl`) vs independent mpmath (`indep.py`):

| k | m | script R[k,1] | mpmath R[k,1] | script R[k,k] | mpmath R[k,k] |
|---|---|---|---|---|---|
| 1 | 2 | 2.017924816216 | 2.017924816 | 2.017924816216 | 2.017924816 |
| 2 | 3 | 2.372926966994 | 2.372926967 | 2.491261017253 | 2.491261017 |
| 3 | 5 | 1.802071488234 | 1.802071488 | 1.553154682740 | 1.553154683 |
| 4 | 9 | 1.906594930315 | 1.906594930 | 1.969924760068 | 1.969924760 |
| 5 | 17 | 1.979055856788 | 1.979055857 | 2.008174202398 | 2.008174202 |
| 6 | 33 | 2.004331112084 | 2.004331112 | 2.013515556346 | 2.013515556 |
| 7 | 65 | 2.012487535614 | 2.012487536 | 2.015410885100 | 2.015410885 |
| 8 | 129 | 2.015080262403 | 2.015080262 | 2.016006749516 | 2.016006750 |

All agree to the 10 digits printed. Property check (`poly.py`, exact rationals, script's recurrence): $R_{k,k}$ integrates $x^p$ on [0,2] exactly for $p\le 2k-1$ and not for $p=2k$, for $k=1..4$ — the expected degree of precision.

**Reference value.** `I_ref = 2.0162797196170963` (l.12). Independent: mpmath tanh-sinh on $[0,2]$ split at 0.5,1,1.5 gives 2.01627971961709632788727…; with the substitution $x=t^3$ gives the identical 50-digit value. The double literal is correct to all 17 digits, far beyond the 1e-4 to 1e-1 errors it is compared with. Comment "(mpmath, 40 digits, after the substitution x = t^3, which makes the integrand smooth)" is accurate.

**Picture.** Frames 1, 2, 3, 5, 9 viewed individually; all 9 on the contact sheet.
- Trapezoids (l.45-55) use $f$ at both endpoints of each subinterval; frame 3 shows heights 1.000 at 0, 1.363 at 1, 1.018 at 2, matching $f$. Frame 2 is a single panel from $f(0)=1$ to $f(2)=1.018$.
- Curve is $f$ from l.9 on 800 points; $f$ ranges about 0.36 to 1.92 on [0,2], inside `ylims=(0,2.1)`, so nothing is clipped. No clamping or NaN masking.
- Annotations: "Sample Points = m" and "R[k,k] = …" use `m_seq[frame]` and `R[frame,frame]` — correct index; values in frames match the table above. Text at (1.12, 1.88/1.74) does not overlap the curve (≈1.3 there).
- Table rows (l.70-74) print `k`, `m_seq[k]`, `R[k,1]`, `R[k,k]`, `R[k,k]-I_ref`; frame 9 values match mpmath to every printed digit; "I = 2.016280" correct.
- 9 frames = 1 lead-in + 8 levels; fps 2.

**Fidelity to archive.** Same example (Mathews Example 6 and his Rombergaa animation), same sample counts, same diagonal values. No dropped case: the archive has one Romberg animation and this page reproduces it. Mathews' Examples 1-5 are static worked examples, not animations, and belong to the planned Worked Example section rather than this animation page.

