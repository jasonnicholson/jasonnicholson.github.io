# Adaptive Simpson's Rule — animation review (round 9)

Page: `pages/numerical-methods/adaptive-simpsons-rule/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page was confirmed by independent computation or by the frames (ledger below).

Non-findings noted for completeness (not reported as errors):
- "the finest is $[0,1/32]$" / "the finest is $[0,1/2048]$": in each partition there are two panels of that width ($[0,1/32]$ and $[1/32,1/16]$; $[0,1/2048]$ and $[1/2048,1/1024]$). The named panel is a finest one, so the statement is not false.
- "Each animation below shows…" — there is only one animation; wording only.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `adaptivesimpsonsaa.jl` | 0 | 19.4 | adaptivesimpsonsaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `adaptivesimpsonsaa.gif` | 21 | byte-identical | adaptivesimpsonsaa |

### Page references

- Scripts linked: `adaptivesimpsonsaa.jl`
- GIFs embedded: 1
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|
| D1 | $S(a,b)=\frac{b-a}{6}[f(a)+4f(m)+f(b)]$ | script line 15 identical; `prop.jl`: exact for degrees 0–3 on [0,2], error 0.2667 for x^4 (S = 6.6667 vs exact 6.4), i.e. degree of precision 3 | confirmed |
| D2 | refinement compares $S(a,b)$ against $S(a,m)+S(m,b)$ | script line 20 | confirmed |
| D3 | animation uses Mathews' acceptance test $\lvert S(a,m)+S(m,b)-S(a,b)\rvert<\varepsilon_{[a,b]}$ | Mathews `gr_2.gif`: `If[Abs[Sab-Sac-Scb] < tol, Return[Sac+Scb], Return[Adapt[a,c,tol/2]+Adapt[c,b,tol/2]]]`; script line 20 uses strict `<` | confirmed |
| D4 | whole interval starts with ε; each half gets half its tolerance | script line 42 (`t/2`); Mathews routine | confirmed |
| D5 | 15ε variant accepts 9 subintervals, finest $[0,1/32]$ | `indep.py` fac=15: 9 panels `[0,1/32],[1/32,1/16],[1/16,1/8],[1/8,1/4],[1/4,1/2],[1/2,3/4],[3/4,1],[1,3/2],[3/2,2]`, finest width 1/32 | confirmed (tie with [1/32,1/16]) |
| D6 | Mathews' test accepts 20 subintervals, finest $[0,1/2048]$ | `indep.py` fac=1: 20 panels, finest width 1/2048 at [0,1/2048] | confirmed (tie with [1/2048,1/1024]) |
| A1 | $f(x)=1+e^{-x}\sin(8x^{2/3})$ on $[0,2]$, $\varepsilon=10^{-3}$ | script lines 9–12; Mathews `gr_182`, `gr_183`, `Adapt[0,2,0.001]` | confirmed |
| A2 | starts from single panel $[0,2]$; each frame splits the widest failing panel, leftmost first, except $[1/2,1]$ before $[0,1/2]$ | `instr.jl` split order: [0,2],[0,1],[1,2],[1/2,1],[0,1/2],[1,3/2],[0,1/4],[1/4,1/2],[1/2,3/4],[3/4,1],[0,1/8],[1/8,1/4],[0,1/16],…,[0,1/1024] | confirmed |
| A3 | "as in Mathews' trace" | all 20 node sets of script equal Mathews' Example 7 sets (programmatic compare: True, 20/20) | confirmed |
| A4 | new sample points marked in blue | script lines 124–125 plot $(3p+q)/4,(p+3q)/4$ = new nodes; frames (e.g. Split [0,1/2] shows blue at 1/8, 3/8; Split [1,2] at 1.25, 1.75) | confirmed |
| A5 | "Approximation" is the composite Simpson sum of $S(a,b)$ over panels drawn | `simpson_nonuniform` (h/3 with h=(x2−x0)/2) = Σ S(p,q); per-frame values 2.491261, 1.611786, …, 2.016252 equal Mathews' table to all 6 digits for all 20 rows | confirmed |
| C1 | refinement stops when all 20 panels pass | `instr.jl` 20 node sets, last 41 points; `indep.py` 20 panels | confirmed |
| C2 | 41 points drawn are the composite-rule nodes | final frame "Sample Points = 41"; indep 41 nodes | confirmed |
| C3 | test also evaluates quarter-points; 81 distinct points | `indep.py` evals over whole recursion tree = 81 | confirmed |
| C4 | $[1.5,2]$ is never split | indep panel list contains [3/2,2]; split list never includes it | confirmed |
| C5 | 19 of the 41 nodes lie in $[0,1/8]$ | indep count of nodes ≤ 1/8 = 19; also from final node list | confirmed |
| C6 | last seven frames split $[0,1/16],[0,1/32],\dots,[0,1/1024]$ | frames 15–21 in `instr.jl` | confirmed |
| C7 | $f'$ unbounded at 0, $f'(x)\approx\frac{16}{3}x^{-1/3}$ | analytic ($\sin u\approx u$); mpmath $f'(x)x^{1/3}$ = 5.30298, 5.33332, 5.33333 at x=1e-3,1e-6,1e-9 vs 16/3=5.33333 | confirmed |
| C8 | panels split in last five frames at most $1/64$ wide | last five splits [0,1/64]…[0,1/1024] | confirmed |
| C9 | under 5 pixels at this scale | axes box columns 39 and 618 in frame_001 → 289.5 px/unit → 1/64 = 4.52 px | confirmed |
| C10 | blue label names each one | frames 17–21 show "Split [0, 1/64]" … "Split [0, 1/1024]" (frame_021 viewed) | confirmed |
| C11 | final estimate 2.016252 | script 2.01625176; indep 2.01625176116 | confirmed |
| C12 | integral 2.016280 | mpmath quad 2.0162797196171 (split at 0,1/1024,1/8,1,2) and via x=u³ substitution 2.0162797196171 | confirmed |
| C13 | difference −2.8×10⁻⁵ | 2.01625176 − 2.01627972 = −2.796×10⁻⁵ | confirmed |
| C14 | Σ $S(a,m)+S(m,b)$ over same panels (routine's return) = 2.016273 | indep 2.01627260396 | confirmed |
| W1 | link `adaptivesimpsonsaa.jl`, embed `adaptivesimpsonsaa.gif` are this case | files exist; script writes that GIF; manifest byte-identical | confirmed |
| W2 | alt text: one failing panel split per frame, sample points and boundaries drawn, new points blue, ends with 41 points, 19 in [0,1/8], piecewise quadratic and estimate update each frame | frames + C2, C5, A4, A5; piecewise parabola via `poly_coeffs` through the 3 panel nodes | confirmed |

### 3. Implementation checks — `adaptivesimpsonsaa.jl`

**Method.** Mathews' adaptive Simpson (`Adapt[a,b,tol]`): accept if $|S_{ac}+S_{cb}-S_{ab}|<tol$, else halve with $tol/2$ each. No factor 15 and no Richardson correction — the variant the page names. The recursion is replayed breadth-first (widest failing panel first), with one tie-break to match Mathews' trace; since each panel's test depends only on the panel and its tolerance, the final partition equals the recursive routine's (verified: 20 identical panels from the independent recursive implementation).

**Numbers.**

| quantity | script | independent (mpmath, exact rationals) |
|---|---|---|
| final panels | 20 | 20 (same list) |
| final nodes | 41 | 41 |
| distinct evaluations | — | 81 |
| final composite Σ S(a,b) | 2.01625176 | 2.01625176116 |
| Σ (S(a,m)+S(m,b)) | — | 2.01627260396 |
| per-frame approximations (20) | 2.49126102 … 2.01625176 | equal to Mathews' Mathematica table to 6 d.p. in all rows |
| node sets (20) | see `s2.txt` | equal to Mathews' 20 sets (`mathews_sets.txt`) |

Property check: script's `simpson` integrates 1, x, x², x³ on [0,2] exactly and x⁴ with error 0.2667 (degree of precision 3).

**Reference values.** The script draws no reference curve; the page's integral 2.016280 was confirmed by two independent mpmath quadratures (direct with breakpoints, and after $x=u^3$ removing the singular derivative) agreeing to 14 digits.

**Picture.** Frames 1, 2, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21 inspected (contact sheet) and frame 21 at full size. Frame 1: curve only. Frame 2: initial panel, 3 points (no split label, consistent with `splits[1] === nothing`). Each later frame: piecewise interpolating parabola through each panel's 3 nodes filled to 0 (f > 0 on [0,2], min ≈ 0.35, so fill = area), red boundary lines at panel endpoints `xs[1:2:end]`, red nodes, blue new nodes at the half-panel midpoints, blue split label matching `instr.jl`. Axis limits (0–2, 0–2.1) contain the whole curve (max ≈ 1.92). No clamping or masking. Legacy GIF (24 frames) shows the same function, same counts and same approximations (2.491261, 1.909633, 1.935128, 2.003302, …, 2.016251), confirming fidelity of the single case.

**Fidelity.** The archive's only animation for this topic is Example 7 / `AdaptQuadaa.gif`; the page reproduces it (function, interval, tolerance, all 20 node sets, all 20 approximations). Examples 1–6 are non-animated worked examples. No dropped cases.

