# Romberg Integration — animation review (round 3)

Page: `pages/numerical-methods/romberg-integration/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** No Error, Misleading, Minor or Fidelity findings.

Things I looked at and decided were not findings:
- The first GIF frame (frame 0 in the loop) shows only the curve and an empty table, so strictly "each frame adds one Romberg row" holds for frames 2–9. This is an intro frame; a reader is not misled.
- The intro says "Each animation below" although there is only one. Wording, not a factual claim about the mathematics.
- The table panel shows faint grid lines despite `axis=false`. Cosmetic; it does not affect readability.
- The legacy GIF shades the area under the curve and marks sample points; the new GIF draws the trapezoid panels. That is a valid (arguably better) depiction of the trapezoid column, not a fidelity departure.
- The Description writes $T_{2^{k-1}}$ without defining the subscript as the number of subintervals. With that reading (the only one consistent with $m=2,3,5,\dots$) it matches the script.



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

Evidence key: **[PY]** = `/usr/bin/python3 -I review/indep.py` (mpmath, 40 digits, own trapezoid + Romberg); **[JL]** = `julia review/rombergaa_instr.jl` (script lines 1–34 verbatim + prints); **[SM]** = `julia review/smoothcheck.jl`; **[FR]** = committed frames.

| # | Claim (page words) | Verdict | Evidence |
|---|---|---|---|
| D1 | "accelerates composite trapezoidal approximations with Richardson extrapolation" | confirmed | script lines 21–34 |
| D2 | $R_{k,1}=T_{2^{k-1}}$ | confirmed | script `n = m_seq[k]-1` = 1,2,4,…,128 = $2^{k-1}$ panels |
| D3 | $R_{k,j}=R_{k,j-1}+\frac{R_{k,j-1}-R_{k-1,j-1}}{4^{j-1}-1}$, $j=2..k$ | confirmed | script line 32 identical; [SM] column j exact for degree 2j−1, not 2j (errors 0 vs 8.3e-2, 1.0e-3, 1.2e-5, 6.4e-8 for j=1..4) |
| D4 | trapezoid error expands in even powers of h; column j has error $O(h^{2j})$ for smooth f | confirmed | [SM] on $e^x$ on [0,2], error ratios per halving: col1 → 4.0, col2 → 15.9, col3 → 63.6, col4 → ~250 (≈ $4^j$) |
| A1 | $f(x)=1+e^{-x}\sin(8x^{2/3})$ on $[0,2]$ | confirmed | script line 9–10; frame title/legacy GIF same function |
| A2 | "graph and table are updated together as the trapezoidal mesh is globally refined" | confirmed | [FR] frames 2–9 |
| A3 | sample counts $m=2,3,5,9,17,33,65,129$ | confirmed | script line 14; frame labels "Sample Points = …" |
| A4 | "Julia source scripts … are linked under each case" | confirmed | `[Julia source](rombergaa.jl)` |
| C1 | Heading: Case 1 — Romberg Table Construction, f, [0,2] | confirmed | script |
| C2 | "Each frame adds one Romberg row from a denser trapezoidal partition and then applies Richardson extrapolation across the row" | confirmed (frames 2–9; frame 1 is an intro frame) | [FR], script lines 28–34, 70–74 |
| C3 | "$R_{k,k}$ … is the most accurate entry in its row from $m=9$ on" | confirmed | [PY]/[JL] argmin column = k for rows 4–8 |
| C4 | "at $m=3$ and $m=5$ it is the least accurate" | confirmed | [PY] row 2 errs 0.357, 0.475; row 3 errs 0.214, 0.404, 0.463 (diagonal largest) |
| C5 | "Its error is not monotone" | confirmed | 1.6e-3 → 0.47 |
| C6 | $\lvert R_{k,k}-I\rvert$ = 1.6e-3, 0.47, 0.46, 0.046, 8.1e-3, 2.8e-3, 8.7e-4, 2.7e-4 | confirmed | [PY] 1.645e-3, 0.4750, 0.4631, 0.04635, 8.106e-3, 2.764e-3, 8.688e-4, 2.730e-4 |
| C7 | "one-panel value at $m=2$, $f(0)+f(2)=2.017925$" | confirmed | [PY] $T_1 = f(0)+f(2) = 2.0179248162$ (h/2·(f0+f2) with h=2) |
| C8 | "close only by coincidence" | confirmed (interpretive; next rows' errors are 300× larger) | C6 |
| C9 | "$f'$ unbounded at 0, $f'(x)\approx\frac{16}{3}x^{-1/3}$" | confirmed | [PY] $f'(x)x^{1/3}$ = 5.33332 at 1e-6, 5.3333333 at 1e-9 (16/3 = 5.3333) |
| C10 | "measured error of every column, the diagonal included, shrinks like $O(h^{5/3})$" | confirmed | [PY] last ratios per halving: col1 3.162, col2 3.202, col3 3.182, col4 3.182, col5 3.182, col6 3.182, col7 3.182 |
| C11 | "halving h divides the diagonal error by about 3.18 (from 64 to 128 subintervals)" | confirmed | [PY]/[JL] 3.18289 |
| C12 | "tending to $2^{5/3}\approx 3.17$" | confirmed | $2^{5/3}=3.1748$; ratios approach it (3.16–3.20). Theory: $x^{2/3}$ singularity gives a $h^{5/3}$ term in the generalized Euler–Maclaurin expansion that extrapolation in $h^2$ does not remove |
| C13 | "extrapolation lowers the error only by a constant factor (about 4.4 against the trapezoid column at 129 sample points)" | confirmed | [PY]/[JL] 4.394 |
| C14 | "last frame's $R_{8,8}=2.016007$ is still $2.7\times10^{-4}$ below $I\approx2.016280$" | confirmed | [PY] $R_{8,8}=2.01600675$, $I=2.0162797196$, diff −2.730e-4; frame 9 shows same |
| L1 | Source link `rombergaa.jl`, embed `rombergaa.gif` are the case | confirmed | committed GIF byte-identical to scratch regeneration (manifest; md5 compared) |
| T1 | Alt: "trapezoidal panels refine globally while the Romberg table adds one row per frame" | confirmed | [FR] |
| T2 | Alt: "listing R[k,1], R[k,k] and the diagonal's error R[k,k] - I" | confirmed | [FR] table header and script line 69–71 |
| T3 | Alt: "still -2.7e-04 at 129 sample points" | confirmed | frame 9 row 8 "-2.7e-04"; [PY] −2.730e-4 |
| G1 | Frame values: R[k,1] column 2.017925, 2.372927, 1.802071, 1.906595, 1.979056, 2.004331, 2.012488, 2.015080 | confirmed | [PY] identical to 6 d.p. |
| G2 | Frame values: R[k,k] column 2.017925, 2.491261, 1.553155, 1.969925, 2.008174, 2.013516, 2.015411, 2.016007 | confirmed | [PY] identical to 6 d.p. |
| G3 | Frame "I = 2.016280" | confirmed | [PY] 2.0162797196 |

### 3. Implementation checks — `rombergaa.jl`

**It is the method it claims.** Standard Romberg: first column is the composite trapezoid rule on $2^{k-1}$ equal panels (computed afresh each level, not by the recursive half-step update; equivalent values), higher columns by Richardson extrapolation with factors $1/(4^{j-1}-1)$. Not a neighbouring method. Property check [SM] with the script's own routine copied verbatim: column j integrates $x^{2j-1}$ exactly and not $x^{2j}$ (j=1..4), and on $e^x$ the per-halving error ratios approach $4^j$.

**The numbers are right.** Script vs independent mpmath (40 digits):

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

Full row errors also agree (e.g. row 8: script 1.199e-3 … 2.730e-4; indep 0.0012 … 0.000273).

**Its reference value is right.** `I_ref = 2.0162797196170963`. Independent: mpmath with substitution $x=t^3$ → 2.016279719617096327887…; direct mpmath on 8 subintervals → same; $2+\int_0^{2^{1/3}} e^{-t^3}\sin(8t^2)3t^2\,dt$ → same. Agreement to all 17 digits printed; far more than the 2-significant-figure error column needs.

**The picture shows what was computed.** Frames 1, 2, 3, 4, 5, 9 inspected individually and all via contact sheet. Each trapezoid is drawn from $(x_l,0),(x_r,0),(x_r,f(x_r)),(x_l,f(x_l))$ with $x_l=a+i\,dx$ on the same $n=m-1$ panels used for `R[k,1]` (lines 43–55). The curve is `f` at 800 points. The "R[k,k]" annotation uses `R[frame,frame]` (correct index). Table lines print `R[k,1]`, `R[k,k]`, `R[k,k]-I_ref` for k ≤ frame — values match [PY]. Axis limits y∈[0,2.1] contain the whole curve (computed range 0.357–1.920); no clamping or masking. 9 frames = 1 intro + 8 levels; fps 2. Regenerated GIF is byte-identical to the committed one.

**Legacy fidelity.** Mathews' `Rombergaa.gif` uses the same function $y=e^{-x}\sin(8x^{2/3})+1$ on [0,2], the same sample counts (3 shown in frame 3, 129 in frame 9), and the same approximations (2.491261 at 3 points, 2.016007 at 129). The page's single case covers the archive's single animation. The n2003 module's worked examples (Examples 1–4) are not animations and their absence from the Animations section is not a dropped case.

