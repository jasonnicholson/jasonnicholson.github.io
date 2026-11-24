# Aitken's and Neville's Interpolation — animation review (round 8)

Page: `pages/numerical-methods/aitkens-and-nevilles-interpolation/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


None (0 Error, 0 Misleading, 0 Minor).

Observations not raised as findings:
- Plot titles/legends print `P_{0,3}` with literal braces (GR does not render the subscript). Cosmetic; the text is still unambiguous.
- Case 2 calls $P_{0,j}(1.8)$ "the top-row entry of Neville's tableau" and also "the diagonal of Mathews' Neville tableau". Both are right in their own layout (top row in the page's $P_{i,j}$ indexing with $i$ the row; diagonal in Mathews' printed table, which lists $P_{0,1,\dots,j}$ on the diagonal), and the Description states the correspondence explicitly.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `nevilleaa.jl` | 0 | 6.1 | nevilleaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `nevillebb.jl` | 0 | 8.8 | nevillebb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| D1 | Description | Neville evaluates the unique polynomial of degree at most $n-1$ through the data | Script reproduces data at nodes (node residual ≤ 8.9e-16) and agrees with Lagrange form to ≤ 1e-15 | confirmed |
| D2 | Description | $P_{i,i}=y_i$, $P_{i,j}=\frac{(x-x_i)P_{i+1,j}-(x-x_j)P_{i,j-1}}{x_j-x_i}$ | Algebra: at $x=x_i$ gives $P_{i,j-1}(x_i)=y_i$, at $x=x_j$ gives $P_{i+1,j}(x_j)=y_j$, interior nodes shared; same as script lines 22–23 of both scripts | confirmed |
| D3 | Description | Final value is $P_{0,n-1}(x)$ | Script returns `P[1, deg+1]` (1-based) | confirmed |
| D4 | Description | Aitken at stage $k$ combines interpolant on $x_0..x_{k-1}$ with that on $x_0..x_{k-2},x_j$; entries in a column share leading nodes; Neville uses consecutive runs | Matches Mathews' text ("same row, preceding column" and "top row, preceding column") and the standard Aitken scheme | confirmed |
| D5 | Description | Both schemes yield the same sequence $P_{0,0},\dots,P_{0,n-1}$ (diagonal of Mathews' two tableaux) and the same final value | Uniqueness of interpolant on $x_0..x_k$; archive Ex 3 "entries on the diagonal are the same" | confirmed |
| D6 | Description | The animations use Neville's scheme | Both scripts run the Neville recursion | confirmed |
| A1 | Animations intro | Each frame adds one node and shows $P_{0,j}$, degree ≤ $j$ through first $j+1$ nodes | `interp_degree` uses `xs[1:deg+1]`; frames show nodes accumulating | confirmed |
| A2 | Intro | Case 1: $\cos x$ at 5 nodes $0,\pi/4,\pi/2,3\pi/4,\pi$, $j=0..4$ | `nevilleaa.jl` l.30–31, `for deg in 0:4`; 5 frames | confirmed |
| A3 | Intro | Case 2: $e^x$ at 6 nodes $x_i=1+i/4$, $j=0..5$ | `nevillebb.jl` l.30–31, `0:5`; 6 frames | confirmed |
| A4 | Intro para | Case 2 animates Mathews' Example 3: $e^x$, $x_i=1+i/4$, $i=0..5$, $\hat x=1.8$ | Archive image gr_295: `f[x_]=e^x; x_i=1.0+i/4; x̂=1.8; i=0..5` | confirmed |
| A5 | Intro para | Case 1 is the page's own example (shows error can increase; $P_{0,4}=P_{0,3}$) | No cos example in archive; behaviour confirmed in C1-3..C1-6 | confirmed |
| A6 | Intro para | Example 3 plots successive interpolants up to degree 3, Ex 4 to 4, Ex 5 to 2 (legacy inventory) | gr_306 (P_{0,1,2,3}), gr_351 (P_{0,1,2,3,4}), gr_405 (P_{0,1,2}) | confirmed (inventory; not otherwise audited) |
| C1-1 | Case 1 heading | $P_{0,0}$ through $P_{0,4}$ for $\cos x$ | script / frames | confirmed |
| C1-2 | Case 1 Behavior | Degree ≤ n built from two of degree ≤ n−1 via the formula | same formula as D2 | confirmed |
| C1-3 | Case 1 Behavior | Max error on $[0,\pi]$: 2.00 ($j=0$) → 0.90 ($j=1$) | indep: 2.0, 0.898805; script grid: 2, 0.898805 | confirmed |
| C1-4 | Case 1 Behavior | Rises to 1.66 at $j=2$, at $x=\pi$, where quadratic reaches −2.66 | indep: 1.65685 at x=3.14159, $P_{0,2}(\pi)=-2.6568542$ | confirmed |
| C1-5 | Case 1 Behavior | Drops to $8.1\times10^{-3}$ at $j=3$ | indep 8.06767e-3; script 8.06758e-3 | confirmed |
| C1-6 | Case 1 Behavior | $P_{0,3}$ already passes through $(\pi,-1)$; $P_{0,4}=P_{0,3}$; last two frames same curve | $P_{0,3}(\pi)=-1.00000000$; 4th divided difference $f_0-4f_1+6f_2-4f_3+f_4=4.6\times10^{-41}$ (40-digit); script $\max|P_{0,4}-P_{0,3}|=6.7\times10^{-16}$; frames 4 and 5 show identical red curve (frame 5 adds node at π) | confirmed |
| C1-7 | Case 1 Behavior | "because cos is odd about π/2" (with symmetric nodes) | $\cos(\pi/2+t)=-\cos(\pi/2-t)$; symmetric nodes + antisymmetric data ⇒ $P_{0,4}$ odd about π/2 ⇒ no quartic term | confirmed (reasoning is compressed but correct) |
| C1-8 | Case 1 link/embed | `nevilleaa.jl` / `nevilleaa.gif` | file contents | confirmed |
| C1-9 | Case 1 alt text | Constant to five-node interpolant $P_{0,4}$, same cubic as $P_{0,3}$ | frames; C1-6 | confirmed |
| C2-1 | Case 2 heading | Mathews' Ex 3, $P_{0,0}..P_{0,5}$, $e^x$ at $\hat x=1.8$ | script, archive | confirmed |
| C2-2 | Case 2 Behavior | Nodes $1,1.25,\dots,2.25$; each frame marks $P_{0,j}(1.8)$ | script l.31, l.65; frames show green diamond on x̂ line | confirmed |
| C2-3 | Case 2 Behavior | Values 2.718282, 5.188877, 5.960761, 6.048454, 6.049700, 6.049643 | indep: 2.718281828, 5.188877441, 5.960760585, 6.048454357, 6.04969972, 6.049643126; script identical | confirmed |
| C2-4 | Case 2 Behavior | Match diagonal of Mathews' Neville tableau | archive gr_298: 2.71828, 5.18888, 5.96076, 6.04845, 6.0497, 6.04964 | confirmed |
| C2-5 | Case 2 Behavior | $e^{1.8}=6.049647$ | 6.049647464 | confirmed |
| C2-6 | Case 2 Behavior | Error falls in size each step: 3.33, 0.861, 0.0889, 1.19e-3, −5.23e-5, 4.34e-6 (negative only at $j=4$) | indep: 3.33137, 0.86077, 0.0888869, 0.00119311, −5.22557e-5, 4.3387e-6; archive gr_303 same | confirmed |
| C2-7 | Case 2 Behavior | Max error on $[1,2.25]$ falls each step, 6.77 ($j=0$) to $3.2\times10^{-5}$ ($j=5$) | indep: 6.769, 2.909, 0.7163, 0.09347, 0.005024, 3.182e-5 (monotone) | confirmed |
| C2-8 | Case 2 Behavior | From $j=4$ indistinguishable at plot scale; at $j=3$ they part only toward the right edge | Window [0.95,2.30], y-range 8.5 over ≈420 px (≈0.02/px). $j=4$: max window error 0.0078 (≈0.4 px). $j=3$: error exceeds 0.02 only for $x>2.015$, 0.12 at 2.30 (≈6 px); frame 4 shows separation only at the right | confirmed |
| C2-9 | Case 2 Behavior | Legend carries the values at $\hat x$ | frames show $f(1.8)$, $P_{0,j}(1.8)$ and difference in legend | confirmed |
| C2-10 | Case 2 link/embed | `nevillebb.jl` / `nevillebb.gif` | file contents | confirmed |
| C2-11 | Case 2 alt text | Nodes 1..2.25, marker at 1.8 approaching 6.049647, ends at 6.049643 | frames, C2-3 | confirmed |

### 3. Implementation checks

### `nevilleaa.jl` (Case 1)
- **Method:** Neville's tableau, `P[i,j] = ((xq-xs[i])P[i+1,j] - (xq-xs[j])P[i,j-1])/(xs[j]-xs[i])`, filled by increasing length; returns the top-right entry. This is Neville's algorithm, evaluated pointwise on 500 grid points. Not a different method.
- **Numbers:** instrumented copy vs independent mpmath Lagrange form:

  | j | script max err [0,π] (grid) | indep max err | script $P(\pi)$ | indep $P(\pi)$ |
  |---|---|---|---|---|
  | 0 | 2 | 2.0 | 1.00000000 | 1.0 |
  | 1 | 0.898805 | 0.898805 | −0.17157288 | −0.17157288 |
  | 2 | 1.65586 | 1.65685 | −2.65685425 | −2.6568542 |
  | 3 | 0.00806758 | 0.00806767 | −1.00000000 | −1.0 |
  | 4 | 0.00806758 | 0.00806767 | −1.00000000 | −1.0 |

  (j=2 grid value slightly below the true max because the script grid does not land exactly on π; immaterial.) Node reproduction residual ≤ 1.1e-16 for every degree.
- **Reference:** `cos` from Base; nothing approximated.
- **Picture:** frames 1–5 show `cos` (blue), $P_{0,j}$ (red dashed) and the $j+1$ nodes. ylims (−3, 1.4) contain the full window range (min −2.882 at x=π+0.1 for j=2, indep −2.88209), so nothing is clipped. Titles give correct index/degree; frame 5 title "P_{0,4} = P_{0,3}, degree 3 (5 nodes)" is correct.

### `nevillebb.jl` (Case 2)
- **Method:** same Neville routine; evaluated on the plot grid and at $\hat x=1.8$.
- **Numbers:** script vs independent (C2-3, C2-6 above) agree to all printed digits; node residual ≤ 8.9e-16. Also matches Mathews' printed tableau diagonal and error list (archive gr_298, gr_303).
- **Reference:** `exp`; $e^{1.8}=6.049647464$ (mpmath).
- **Picture:** ylims (2, 10.5) contain all curves (window min 2.5639, max 9.9741 across j). Green diamond at $(1.8, P_{0,j}(1.8))$, legend values formatted `%.6f` / `%.3g` match the computed values. Titles' index and degree correct for all six frames.

### Fidelity
Case 2 reproduces Mathews' Example 3 exactly (function, nodes, $\hat x$, tableau diagonal, errors) and extends his degree-3 plot to degree 5, as the page says. Case 1 is a non-archive example and the page says so; Example 4 ($J_0$, nodes $0,0.5,\dots,2.5$, $\hat x=1.8$) and the others are listed as not animated. No undisclosed departure found.

