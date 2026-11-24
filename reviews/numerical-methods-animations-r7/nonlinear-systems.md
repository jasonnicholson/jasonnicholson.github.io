# Nonlinear Systems — animation review (round 7)

Page: `pages/numerical-methods/nonlinear-systems/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


None.


#### Could not determine

- **Mathews' Example 2 starting vectors.** The text reads "find a numerical approximation to the solution near [image]", and those images (`gr_235`, `gr_256`) are missing, as is the graph `gr_234`. So I cannot say whether $(0.5, 0.8)$ and $(2, -1)$ are Mathews' starts. Both starts are valid and converge to the two real solutions, and the page does not claim they are his. No finding is raised.
- **Whether Mathews' Example 2 runs have the same iterates.** This follows from the point above.

---

## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `newtonsysaa.jl` | 0 | 7.8 | newtonsysaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtonsysab.jl` | 0 | 7.3 | newtonsysab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `newtonsysaa.gif` | 9 | byte-identical | newtonsysaa |
| `newtonsysab.gif` | 9 | byte-identical | newtonsysab |

### Page references

- Scripts linked: `newtonsysaa.jl`, `newtonsysab.jl`
- GIFs embedded: 2
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

Verdicts: **C** confirmed, **W** wrong, **?** could not determine. Evidence files are in `$R`.

### Description

| # | Claim (page's words) | Verdict | Evidence |
|---|---|---|---|
| L1 | Solutions of the system are the points of intersection of the two curves | C | Definition; two real solutions found (L19) |
| L2 | Jacobian is the matrix of $\partial f/\partial x$, $\partial f/\partial y$, $\partial g/\partial x$, $\partial g/\partial y$; $J_{ij}=\partial F_i/\partial x_j$ | C | Standard definition; sympy Jacobian of the page's system equals the script's `Jac` (`indep.out`) |
| L3 | Fixed-point form $\mathbf{X}^{(k+1)}=\mathbf{G}(\mathbf{X}^{(k)})$ | C | Mathews' `gr_75`; run in `desc.py` |
| L4 | Row-sum condition at $\mathbf{X}^*$ gives convergence from sufficiently close starts | C | It is $\lVert DG(\mathbf{X}^*)\rVert_\infty<1$. Example 1 at Solution 1: row sums 0.849, 0.160, and iteration converges (`desc.out`) |
| L5 | Row-sum condition is sufficient, not necessary | C | $G=Mx$, $M=[[.5,.9],[0,.5]]$: row sums 1.4, 0.5, $\rho=0.5$, $\lvert x_{80}\rvert=1.2\times10^{-22}$ (`supp.out`) |
| L6 | Converges from close starts whenever $\rho(DG(\mathbf{X}^*))<1$ | C | Same example; Example 1 at Solution 1 has $\rho=0.1603$ and converges |
| L7 | Newton linearization and update $J\Delta\mathbf{X}=-\mathbf{F}$, $\mathbf{X}^{(k+1)}=\mathbf{X}^{(k)}+\Delta\mathbf{X}^{(k)}$ | C | Script line 30 (aa), 31 (ab): `pts[k+1] = pts[k] - Jv \ F(pts[k])` |
| L8 | Four steps of one iteration | C | Same lines; matches Mathews' Steps 1 to 4 |
| L9 | Quadratic near a non-singular solution; correct digits roughly double | C | $e_{k+1}/e_k^2$ settles at 0.535 (Case 1) and 0.960 (Case 2); $\det J=-37.84$ and $32.08$ at the solutions |
| L10 | Quadratic rate is lost if $J$ is singular at the solution | C | $F=(x^2,y)$: $x$ halves each step, linear (`desc.out`) |
| L11 | Same algorithm in any dimension; only the linear system's size changes | C | Algorithm is dimension-free; Mathews' Exercise 5 |
| L12 | Table: fixed-point error shrinks by about $\rho$ per step when $0<\rho<1$ | C | Example 1 at Solution 1: $\rho=0.16026$, measured ratio at step 10 is $0.16026$ |
| L13 | Table: superlinear when $\rho=0$, as for Newton as a fixed-point map, whose $\mathbf{G}$ has zero Jacobian at $\mathbf{X}^*$ | C | Symbolic Newton-map Jacobian evaluates to the zero matrix at both solutions (`desc.out`) |
| L14 | Table: fixed-point cost is function evaluations only; Newton adds Jacobian and linear solve | C | Algorithm structure |
| L15 | Table: row-sum sufficient; Newton requires a good starting guess | C | L5; basin census shows slow and thrown starts (L27 to L30) |
| L16 | Table: starting-point sensitivity High (fixed point), Moderate (Newton) | C (qualitative) | On this system's windows Example 1's $G$ reaches a solution from 73.2% and 54.5% of grid starts, Newton from 100% (`desc.out`, `grid.out`). This is one system, so the row is only consistent with it |

### Animations introduction

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| L17 | System $f_1=1-4x+2x^2-2y^3$, $f_2=-4+x^4+4y+4y^4$ | C | Scripts lines 12 to 13 (aa) and 13 to 14 (ab); Mathews `gr_221` |
| L18 | Blue is $f_1=0$, red is $f_2=0$ | C | Drawn pixels lie on the right curve: median distance 0.002 to 0.003 data units (under one pixel); control test of blue against $f_2$ gives 0.36 to 0.41 (`frames.out`). Reverse check: every true curve sample lies within 1.6 px of a pixel of its colour (`supp.out`) |
| L19 | "Their two intersections are the solutions" | C | Degree-12 resultant in $y$ has exactly 2 real roots (Sturm count), giving $(0.06177012633860737, 0.7244905153472166)$ and $(1.556097484322053, -0.5756507696188434)$ (`indep.out`) |
| L20 | Each frame adds one Newton step | C | 9 frames with 9 distinct hashes; frame $k$ shows $x^{(k)}$, $k=0..8$. From about step 4 the movement is below a pixel, so later frames change only in the legend index |
| L21 | Jacobian evaluated at the current point, system solved, iterate moved | C | Scripts lines 29 to 30 (aa), 30 to 31 (ab) |
| L22 | Quadratic convergence is local; the error squares only once close | C | L24, L33; thrown starts in L29 |
| L23 | Julia source scripts are linked under each case | C | Links resolve; manifest: regenerated GIFs byte-identical |
| L27 | $301\times301$ grid covering each plot window | C | Census uses the script's `xlims`, `ylims` with endpoints |
| L28 | More than 90% get within $10^{-10}$ of a solution in at most 10 iterations | C | **91.319%** (Case 1 window), **93.209%** (Case 2 window). numpy (`grid.out`) and Julia with the script's `\` solve (`gridjl.out`) agree |
| L29 | Starts near the $\det J=0$ curve can be thrown far outside the window | C | All starts within 0.01 of the curve (825 and 645) reach peak $\lvert\mathbf{X}\rvert\ge 24$, median 113 and 83.5, while no point of either window is farther than 3.13 from the origin (`excursion.out`) |
| L30 | They need dozens of iterations to come back | C | Starts within 0.01: median 23 and 22 iterations, all over 10, up to 174 and 183 (`dist.out`). Of starts over 10 iterations, 82.5% and 79.5% lie within 0.1 of the curve, against 9.0% and 6.9% of all starts |
| L31 | Over 200 iterations for the slowest start in each window | C | **246** from $(-13/120, -829/1200)$, **203** from $(-1/5, -27/40)$. Same counts in numpy, Julia, and 120-digit arithmetic on the exact rational grid points (`trace.out`). The slowest starts lie 0.061 and 0.044 from the curve; peak $\lvert\mathbf{X}\rvert=1.9\times10^{29}$ and $9.1\times10^{23}$ |
| L32 | Every grid start converges (implied by "come back") | C | 90601 of 90601 in both windows, none singular |
| L44 | Example 1 is fixed-point iteration on this same system | C | `gr_75`; sympy: $x-g_1=-f_1/4$, $y-g_2=f_2/12$ |
| L45 | Example 3 checks that the fixed-point form and the system are equivalent | C | `gr_274`, `gr_275`, text of `lnk_4` |
| L46 | Example 4 is Newton on this system as a fixed-point iteration; Exercise 5 is Newton for three equations in three unknowns | C | `gr_288`, `lnk_5` text; `gr_357` to `gr_360`, `lnk_6` text. No archive example is silently dropped: Examples 1, 3, 4 and Exercise 5 are listed, Example 2 is animated |

### Case 1

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| L24 | Start $(0.5, 0.8)$, wired to `newtonsysaa.jl` and `.gif` | C | Script line 19; GIF title; link and embed on the page |
| L33 | "just above the red curve and well above the blue curve at $x=0.5$" | C | At $x=0.5$ red is at $y=0.7182$ and $-1.2182$, blue at $-0.6300$ |
| L34 | Converges to $(0.0618, 0.7245)$ | C | $(0.0617701, 0.7244905)$ |
| L35 | "the intersection in the upper-left portion of the plot" | C | Frames; 12% across and 72% up the window |
| L36 | Distances $0.44\to0.24\to0.024\to3\times10^{-4}\to5\times10^{-8}\to1\times10^{-15}$ | C | 0.4447, 0.2367, 0.02374, 2.923e-4, 4.569e-8, 1.116e-15 (80-digit Newton, `indep.out`) |
| L37 | Each error roughly the square of the previous one | C | $e_{k+1}/e_k^2$ = 1.20, 0.42, 0.52, 0.53, 0.53 |
| L38 | Alt text: from $(0.5, 0.8)$ to about $(0.062, 0.724)$ | C | Correct rounding of $(0.06177, 0.72449)$ |

### Case 2

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| L25 | Start $(2, -1)$, wired to `newtonsysab.jl` and `.gif` | C | Script line 20; GIF title; link and embed on the page |
| L26 | "in the lower-right region near Solution 2" | C | Frames; 0.614 from the solution |
| L39 | Converges to $(1.5561, -0.5757)$, the lower-right intersection | C | $(1.5560975, -0.5756508)$. Mathews' `lnk_2` gives $1.5560974843220556$, $-0.5756507696188449$, agreeing to 14 digits |
| L40 | Blue crosses red close to red's rightmost point $(1.5579, -0.6300)$ | C | Rightmost point has $\partial f_2/\partial y=0$: $y=-4^{-1/3}=-0.62996$, $x=1.55785$. It is 0.054 from the solution |
| L41 | Distances $0.61\to0.21\to0.034\to1.1\times10^{-3}\to1.1\times10^{-6}\to1.1\times10^{-12}$ | C | 0.6141, 0.2142, 0.03367, 1.051e-3, 1.058e-6, 1.076e-12 |
| L42 | Each error roughly the square of the previous one | C | $e_{k+1}/e_k^2$ = 0.57, 0.73, 0.93, 0.96, 0.96 |
| L43 | Alt text: from $(2, -1)$ to about $(1.556, -0.576)$ | C | Correct rounding |

### Fidelity

| # | Claim or question | Verdict | Evidence |
|---|---|---|---|
| L47 | Case starts match Mathews' Example 2 | ? | `gr_235`, `gr_256` missing from the archive |
| L48 | Case iterates match Mathews' Example 2 tables | ? | `gr_236` to `gr_273` missing from the archive |
| L49 | Same system as Mathews' Example 2 | C | `gr_221` |

---

### 3. Implementation checks

### `newtonsysaa.jl`

- **Method.** Plain, undamped Newton with an exact analytic Jacobian and a direct solve. This is the method the page describes; there is no line search or safeguard.
- **Numbers.** Instrumented copy `$R/inst_aa/inst.jl` against the independent 80-digit mpmath Newton in `indep.py`:

| k | script $x$ | script $y$ | independent $x$ | independent $y$ | error |
|---|---|---|---|---|---|
| 0 | 0.5 | 0.8 | 0.5 | 0.8 | 0.4447 |
| 1 | -0.17312820513 | 0.75371260684 | -0.1731282051 | 0.7537126068 | 0.2367 |
| 2 | 0.03807159006 | 0.72585857776 | 0.03807159006 | 0.7258585778 | 0.02374 |
| 3 | 0.06147780801 | 0.72449357174 | 0.06147780801 | 0.7244935717 | 2.923e-4 |
| 4 | 0.06177008065 | 0.72449051556 | 0.06177008065 | 0.7244905156 | 4.569e-8 |
| 5 | 0.06177012634 | 0.72449051535 | 0.06177012634 | 0.7244905153 | 1.116e-15 |

- **Reference values.** The script draws no separate reference root. Its final iterate is $(0.06177012633860736, 0.7244905153472166)$, within one unit in the last place of the 80-digit solution; residual $\lVert F\rVert=0$ in double precision.
- **Picture.** Curves match in both directions (L18). In all 9 frames the red marker is within 0.6 px of the computed $x^{(k)}$ (`frames.out`). Legend values and indices match the computed iterates at 4 decimals. Title matches the parameters. No clamping or masking; the whole path stays inside the window.

### `newtonsysab.jl`

- **Method.** Same as above.
- **Numbers.** Instrumented copy `$R/inst_ab/inst.jl` against `indep.py`:

| k | script $x$ | script $y$ | independent $x$ | independent $y$ | error |
|---|---|---|---|---|---|
| 0 | 2 | -1 | 2 | -1 | 0.6141 |
| 1 | 1.75 | -0.66666666667 | 1.75 | -0.6666666667 | 0.2142 |
| 2 | 1.58969107716 | -0.57791698264 | 1.589691077 | -0.5779169826 | 0.03367 |
| 3 | 1.55714446095 | -0.57555359683 | 1.557144461 | -0.5755535968 | 1.051e-3 |
| 4 | 1.55609854067 | -0.57565070461 | 1.556098541 | -0.5756507046 | 1.058e-6 |
| 5 | 1.55609748432 | -0.57565076962 | 1.556097484 | -0.5756507696 | 1.076e-12 |

- **Reference values.** No separate reference root is drawn. Final iterate $(1.556097484322053, -0.5756507696188433)$; $\lVert F\rVert=5.3\times10^{-16}$.
- **Picture.** Same checks as Case 1, all passing; red marker within 0.5 px of $x^{(k)}$ in all 9 frames. The legend sits over a short stretch of the blue curve at the top right, away from the iteration, so it does not affect what a viewer concludes.

### Commands

```
/usr/bin/python3 $R/indep.py        # symbolic Jacobian, resultant, real solutions, 80-digit Newton
/usr/bin/python3 $R/grid.py         # 301x301 census (numpy)
julia $R/gridjl.jl                  # same census with the script's solve
/usr/bin/python3 $R/trace.py        # slowest starts in 120-digit arithmetic on exact grid points
/usr/bin/python3 $R/dist.py         # iterations against distance to det J = 0
/usr/bin/python3 $R/excursion.py    # peak |X| for starts near det J = 0
/usr/bin/python3 $R/frames.py <evidence dir>  # curves and markers measured from committed frames
/usr/bin/python3 $R/supp.py <evidence dir>    # reverse curve check, row-sum counterexample
/usr/bin/python3 $R/desc.py         # fixed-point form, rho, row sums, Newton map, singular-root rate
/usr/bin/python3 $R/arch.py $R      # archive text with image positions, formula image sheets
julia $R/inst_aa/inst.jl; julia $R/inst_ab/inst.jl   # instrumented script copies
```

