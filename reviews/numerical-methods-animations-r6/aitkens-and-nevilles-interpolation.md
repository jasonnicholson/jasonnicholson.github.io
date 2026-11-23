# Aitken's and Neville's Interpolation — animation review (round 6)

Page: `pages/numerical-methods/aitkens-and-nevilles-interpolation/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page, in the script headers and comments, and in the frames agrees with independent computation at the precision stated.

Observations that are not findings (recorded so the clean result can be trusted, not as requested changes):
- The Case 1 Behavior paragraph uses $n$ for the degree ("degree at most $n$ by combining two polynomials of degree at most $n-1$"), while the Description uses $n$ for the number of points (degree at most $n-1$, final value $P_{0,n-1}$). Each statement is true in its own sentence; it is a notational shift, not an error.
- The page is titled "Aitken's and Neville's Interpolation" but animates only Neville's scheme. The page says so explicitly ("The animations below use Neville's scheme"), so this is content not yet present, not a mismatch.
- The plot windows extend slightly past the node range (Case 1: [-0.1, π+0.1]; Case 2: [0.95, 2.30]), so the curves are extrapolated at the edges. The y-limits contain every curve in full (Case 1 min −2.882 > −3.0; Case 2 range 2.564…9.974 within [2.0, 10.5]); nothing is clipped, so no display device alters what is seen.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `nevilleaa.jl` | 0 | 5.1 | nevilleaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `nevillebb.jl` | 0 | 7.5 | nevillebb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `nevilleaa.gif` | 5 | byte-identical | nevilleaa |
| `nevillebb.gif` | 6 | byte-identical | nevillebb |

### Page references

- Scripts linked: `nevilleaa.jl`, `nevillebb.jl`
- GIFs embedded: 2
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

### Description
| # | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|
| D1 | Neville evaluates "the unique polynomial of degree at most $n-1$ through data points" without expanded coefficients | Standard; script never forms coefficients | confirmed |
| D2 | $P_{i,i}(x)=y_i$, $P_{i,j}(x)=\frac{(x-x_i)P_{i+1,j}-(x-x_j)P_{i,j-1}}{x_j-x_i}$ | Algebra: at $x=x_i$ gives $P_{i,j-1}(x_i)=y_i$; at $x=x_j$ gives $P_{i+1,j}(x_j)=y_j$; interior nodes shared by both. Same formula as script lines 22–23 of both scripts | confirmed |
| D3 | "The final interpolated value at a query point $x$ is $P_{0,n-1}(x)$" | Script returns `P[1, deg+1]` (1-based) = $P_{0,\text{deg}}$ | confirmed |
| D4 | Aitken: "At stage $k$ it combines the interpolant on $x_0,\dots,x_{k-1}$ with the interpolant on $x_0,\dots,x_{k-2},x_j$, so every entry in a column shares the same leading nodes" | Matches Mathews' rule ("same row, preceding column" and "top row, preceding column"); my Aitken tableau implementation (indep2.py) using exactly this rule gives diagonal 2.718282, 5.188877, 5.960761, 6.048454, 6.0497, 6.049643 for Example 3 | confirmed |
| D5 | "The intermediate entries differ, but both schemes end with the same interpolated value" | Uniqueness of the interpolant; numerically identical diagonals (D4 vs C2-3) | confirmed |
| D6 | "The animations below use Neville's scheme" | Both scripts implement the Neville recurrence | confirmed |

### Animations introduction
| # | Claim | Evidence | Verdict |
|---|---|---|---|
| I1 | "Each frame adds one node and shows $P_{0,j}(x)$, the interpolant of degree at most $j$ through the first $j+1$ nodes" | Scripts loop `deg in 0:4` / `0:5`, use `xs[1:deg+1]`; frames show 1,2,…,5 / 1,…,6 black nodes | confirmed |
| I2 | Case 1: $\cos x$ at 5 nodes $0,\pi/4,\pi/2,3\pi/4,\pi$, $j=0..4$ | `nevilleaa.jl` lines 30–31, 45; 5 frames | confirmed |
| I3 | Case 2: $e^x$ at 6 nodes $x_i=1+i/4$, $j=0..5$ | `nevillebb.jl` lines 30–31, 45; 6 frames | confirmed |
| I4 | "Julia source scripts ... are linked under each case" | Links present: `nevilleaa.jl` under Case 1, `nevillebb.jl` under Case 2 | confirmed |
| I5 | Case 2 "animates the module's Example 3: $e^x$ at the nodes $x_i=1+i/4$, $i=0..5$, evaluated at $\hat x=1.8$" | Archive gr_295: `f[x_]=e^x; x_i_=1.0+i/4; x̂=1.8; Table[x_i,{i,0,5}]` | confirmed |
| I6 | Archive inventory (Examples 1–7, which plot what, degrees 3, 4, 2) | Legacy-inventory text, out of scope; spot-checked anyway: Ex 3 plot code gr_306 plots up to $P_{0,1,2,3}$ (deg 3); Ex 4 gr_351 up to $P_{0,1,2,3,4}$ (deg 4); Ex 5 gr_405 up to $P_{0,1,2}$ (deg 2); Ex 1 gr_108 plots f, $P_{0,1}$, $P_{1,2}$, $P_{0,1,2}$; Ex 6/7 (lnk_7/8) contain tableaux only | confirmed (spot check) |

### Case 1
| # | Claim | Evidence | Verdict |
|---|---|---|---|
| C1-1 | Heading: "$P_{0,0}$ through $P_{0,4}$ for $\cos(x)$" | 5 frames, titles P_{0,0}…P_{0,4} | confirmed |
| C1-2 | Behavior: builds degree-≤n interpolant from two of degree ≤ n−1 via the stated formula | Same formula as D2 | confirmed |
| C1-3 | max $|P_{0,0}-\cos|$ on $[0,\pi]$ = 2.00 | indep.py: 2.0 at $x=\pi$ | confirmed |
| C1-4 | 0.90 at $j=1$ | indep.py (refined): 0.898805 at $x\approx2.760$; script grid 0.898805 | confirmed |
| C1-5 | rises to 1.66 at $j=2$, at $x=\pi$ | indep.py: 1.656854 at $x=\pi$ | confirmed |
| C1-6 | "the quadratic reaches $-2.66$" at $\pi$ | sympy $P_{0,2}(\pi)=-2.656854$; script −2.6568542 | confirmed |
| C1-7 | drops to $8.1\times10^{-3}$ at $j=3$ | indep.py refined: 8.067672e-3 at $x\approx0.283$; script grid 8.06758e-3 | confirmed |
| C1-8 | "the cubic $P_{0,3}$ already passes through $(\pi,-1)$" | sympy exact $P_{0,3}(\pi)=-1$; script −1.0000000000000002 | confirmed |
| C1-9 | "because cos is odd about $\pi/2$" | $\cos(\pi/2+t)=-\sin t$ is odd in $t$; with nodes symmetric about $\pi/2$ the 5-node interpolant is odd about $\pi/2$, so has no $(x-\pi/2)^4$ term, hence degree ≤3, hence equals $P_{0,3}$ by uniqueness. Valid reason | confirmed |
| C1-10 | "$P_{0,4}=P_{0,3}$, and the last two frames show the same curve" | sympy `simplify(P04-P03)=0`; script values at x=1.0 identical (0.537569521354321); frames 4 and 5 identical curves | confirmed |
| C1-11 | Link `nevilleaa.jl`, embed `nevilleaa.gif` are this case | Script header and content are cos, 5 nodes; GIF produced by it (byte-identical regen) | confirmed |
| C1-12 | Alt text: cos(x) at nodes 0, π/4, π/2, 3π/4, π, degree-0 constant to $P_{0,4}$, "the same cubic as $P_{0,3}$" | Frames 1–5 | confirmed |

### Case 2
| # | Claim | Evidence | Verdict |
|---|---|---|---|
| C2-1 | Heading: "Mathews' Example 3: $P_{0,0}$ through $P_{0,5}$ for $e^x$ at $\hat x=1.8$" | Archive gr_295; 6 frames P_{0,0}…P_{0,5}; vline and marker at 1.8 | confirmed |
| C2-2 | Nodes $1, 1.25, \dots, 2.25$ | script line 31 | confirmed |
| C2-3 | "each frame marks $P_{0,j}(1.8)$, the top-row entry of Neville's tableau" | Green diamond at `(x_hat, p_hat)`, `p_hat = P[1,deg+1]` = row-0 entry | confirmed |
| C2-4 | Values 2.718282, 5.188877, 5.960761, 6.048454, 6.049700, 6.049643 | sympy Lagrange at 1.8: 2.718281828, 5.188877441, 5.960760585, 6.048454357, 6.049699720, 6.049643126; script identical to 10 d.p. | confirmed |
| C2-5 | "match the diagonal of Mathews' Neville tableau" | Archive gr_298 diagonal: 2.71828, 5.18888, 5.96076, 6.04845, 6.0497, 6.04964; Neville approx 6.049643 | confirmed |
| C2-6 | "$e^{1.8}=6.049647$" | mpmath 6.04964746441 | confirmed |
| C2-7 | Errors $e^{1.8}-P_{0,j}(1.8)$: 3.33, 0.861, 0.0889, $1.19\times10^{-3}$, $-5.23\times10^{-5}$, $4.34\times10^{-6}$ | mpmath: 3.33137, 0.86077, 0.0888869, 1.19311e-3, −5.22557e-5, 4.3387e-6 | confirmed |
| C2-8 | "falls in size at each step ... (negative only at $j=4$)" | Magnitudes strictly decreasing; only j=4 negative | confirmed |
| C2-9 | Largest error on $[1,2.25]$ falls at each step, "from 6.77 at $j=0$ to $3.2\times10^{-5}$ at $j=5$" | indep.py (5001-pt grid incl. endpoints): 6.769, 2.909, 0.7163, 0.09347, 5.024e-3, 3.182e-5 — strictly decreasing | confirmed |
| C2-10 | "From $j=4$ on, $P_{0,j}$ and $e^x$ are indistinguishable at the plot's scale" | Max error over the whole plotted window [0.95, 2.30]: j=4 7.8e-3, j=5 7.1e-5 (script grid); y-span 8.5 over ≈400 px ⇒ ≈0.37 px and ≪1 px. Frames 5–6 show coincident curves | confirmed |
| C2-11 | "(at $j=3$ they part only toward the right edge)" | j=3 error 0.093 at 2.25, 0.121 at 2.30, small on left; frame 4 shows the dashed curve separating only beyond ≈2.1 | confirmed |
| C2-12 | "the legend carries the values at $\hat x$" | Legend: "P_{0,j}(1.8) = …, f(1.8) − P_{0,j}(1.8) = …" and "f(1.8) = 6.049647"; values match C2-4/C2-7 in all 6 frames | confirmed |
| C2-13 | Link `nevillebb.jl`, embed `nevillebb.gif` are this case | Script content is e^x Example 3; GIF byte-identical regen | confirmed |
| C2-14 | Alt text: nodes 1…2.25, degree-0 to degree-5, marker at 1.8 approaching 6.049647 and ending at 6.049643 | Frames 1–6; C2-4, C2-6 | confirmed |

### Script headers/comments (claims)
| # | Claim | Evidence | Verdict |
|---|---|---|---|
| S1 | `nevilleaa.jl` l.4: "$P_{0,4}=P_{0,3}$ ... frame 5 is titled degree 3" | C1-10; frame 5 title "P_{0,4} = P_{0,3}, degree 3 (5 nodes)" | confirmed |
| S2 | `nevilleaa.jl` l.53: quadratic minimum "≈ −2.88 at x = π + 0.1" | min over window −2.88209 (both sympy and script), at right edge | confirmed |
| S3 | `nevillebb.jl` l.2–3: Example 3, $e^x$, $x_i=1+i/4$, $\hat x=1.8$, $j=0..5$ | script body | confirmed |
| S4 | Frame titles "degree $j$ ($j+1$ nodes)" for Case 2 | sympy degrees of $P_{0,j}$ for $e^x$ are exactly $j$ (nonzero leading divided differences) | confirmed |

### Fidelity to the legacy archive
| # | Item | Verdict |
|---|---|---|
| F1 | Case 2 reproduces Example 3's function, nodes, evaluation point and tableau diagonal, and extends its static plot (deg ≤3) to deg 5 — disclosed on the page | confirmed, no fidelity issue |
| F2 | Case 1 is not a Mathews example; the page says so and gives the reason | disclosed, not a finding |
| F3 | Examples 1, 2, 4–7 not animated; disclosed | disclosed, not a finding |

### 3. Implementation checks

### `nevilleaa.jl` (Case 1)
- **Method:** `neville_table` fills the tableau by increasing run length `len`, combining `P[i+1,j]` and `P[i,j-1]` with weights $(x-x_i)$, $-(x-x_j)$ over $(x_j-x_i)$ — Neville's recurrence on consecutive runs, exactly as in the Description. Not Aitken, not Lagrange disguised. Evaluated pointwise at 500 grid points.
- **Numbers:** instrumented copy (`inst_nevilleaa.jl`) vs. independent sympy Lagrange (`indep.py`) and scipy barycentric (`indep2.py`):

  | j | script $P_{0,j}(1.0)$ | barycentric $P_{0,j}(1.0)$ | script $P_{0,j}(\pi)$ | sympy $P_{0,j}(\pi)$ | max err [0,π] script grid | sympy refined |
  |---|---|---|---|---|---|---|
  | 0 | 1.0 | 1.0 | 1.0 | 1 | 1.9999999 | 2.0 |
  | 1 | 0.6270767714219434 | 0.6270767714219434 | −0.171572875 | −0.1715728753 | 0.8988047 | 0.8988047 |
  | 2 | 0.5550244478486578 | 0.5550244478486578 | −2.656854249 | −2.656854249 | 1.65586 (grid misses π) | 1.656854 |
  | 3 | 0.537569521354321 | 0.5375695213543211 | −1.0000000 | −1 (exact) | 8.06758e-3 | 8.067672e-3 |
  | 4 | 0.537569521354321 | 0.537569521354321 | −1.0 | −1 | 8.06758e-3 | 8.067672e-3 |

  Interpolant reproduces data at used nodes to ≤1.1e-16 for every j.
- **Reference:** $\cos$ evaluated directly; nothing numerical to verify.
- **Picture:** frames 1–5 viewed (sheet and frames). Blue = cos, red dashed = $P_{0,j}$ from the computed `P_vals`, black dots = `xs[1:deg+1]`. Titles and legend indices match the loop variable. ylims (−3, 1.4) contain the full curve in every frame (window min −2.882, max 1.037); no clamping/NaN masking used. Frame count 5 = page's $j=0..4$.

### `nevillebb.jl` (Case 2)
- **Method:** identical Neville routine; marker value `p_hat = interp_degree(1.8, …)` is the row-0 entry $P_{0,j}(1.8)$.
- **Numbers:** instrumented copy (`inst_nevillebb.jl`) vs. sympy/mpmath (`indep.py`) and scipy barycentric (`indep2.py`):

  | j | script $P_{0,j}(1.8)$ | sympy $P_{0,j}(1.8)$ | script err | mpmath err | script $P_{0,j}(1.3)$ | barycentric $P_{0,j}(1.3)$ | max err [1,2.25] (independent, incl. 2.25) |
  |---|---|---|---|---|---|---|---|
  | 0 | 2.7182818285 | 2.718281828 | 3.33137 | 3.33137 | 2.7182818285 | 2.718281828459 | 6.769 |
  | 1 | 5.1888774413 | 5.188877441 | 0.86077 | 0.86077 | 3.6447551833 | 3.6447551833 | 2.909 |
  | 2 | 5.9607605845 | 5.960760585 | 0.0888869 | 0.0888869 | 3.6710693813 | 3.6710693813 | 0.7163 |
  | 3 | 6.0484543571 | 6.048454357 | 0.00119311 | 0.00119311 | 3.6690763410 | 3.6690763410 | 0.09347 |
  | 4 | 6.0496997201 | 6.049699720 | −5.22557e-5 | −5.22557e-5 | 3.6693310744 | 3.6693310744 | 5.024e-3 |
  | 5 | 6.0496431257 | 6.049643126 | 4.3387e-6 | 4.3387e-6 | 3.6692905580 | 3.6692905580 | 3.182e-5 |

  An independent Aitken-tableau implementation gives the same diagonal (2.718282, 5.188877, 5.960761, 6.048454, 6.0497, 6.049643), and Mathews' archived tableau (gr_298) shows the same values to 6 significant figures.
- **Reference:** $e^{1.8}=6.04964746441$ (mpmath, 40 digits); legend "f(1.8) = 6.049647" correct.
- **Picture:** frames 1–6 viewed (sheet; frame 4 at full size). Red dashed curve from computed `P_vals`; black nodes = `xs[1:deg+1]`; gray dotted line at 1.8; green diamond at $(1.8, P_{0,j}(1.8))$ lies on the dashed curve in every frame; legend numbers match the table above (3.33, 0.861, 0.0889, 0.00119, −5.23e-05, 4.34e-06). ylims (2.0, 10.5) contain all curves (min 2.564, max 9.974); xticks at the node positions. Frame count 6 = page's $j=0..5$.

