# Aitken's and Neville's Interpolation — animation review (round 3)

Page: `pages/numerical-methods/aitkens-and-nevilles-interpolation/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1. Description says the interpolant has degree n-1, but this page's own example has degree n-2 (Page match / method description; Minor)

- **Location:** `index.qmd` line 12: "Neville's interpolation algorithm evaluates the unique degree-$(n-1)$ polynomial through data points $(x_i,y_i)$".
- **What is there now:** It says the interpolant through n points is "the unique degree-(n-1) polynomial".
- **What is true:** The unique interpolant has degree *at most* n-1. The page's own case shows this. With n = 5 nodes, $P_{0,4}$ is a cubic, and the frame-5 title and the Behavior paragraph both say "degree 3". So a reader who checks the Description against the case finds the page contradicting itself. The case introduction on line 25 already uses the correct wording ("the interpolant of degree at most $j$").
- **How I know:** `python3 review/indep.py` (sympy `interpolate` on the exact nodes) gives the 5-node interpolant coefficients `[0.142496, -0.671498, 0.066571, 1.0]`, which is degree 3. It also prints `P4-P3 simplify: 0`.
- **Correction:** Change it to "evaluates the unique polynomial of degree at most $n-1$ through data points $(x_i,y_i)$".

No Error or Misleading findings.

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `nevilleaa.jl` | 0 | 6.1 | nevilleaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `nevilleaa.gif` | 5 | byte-identical | nevilleaa |

### Page references

- Scripts linked: `nevilleaa.jl`
- GIFs embedded: 1
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Claim (page's words) | Location | Evidence | Verdict |
|---|---|---|---|---|
| 1 | Recurrence $P_{i,i}=y_i$, $P_{i,j}=\frac{(x-x_i)P_{i+1,j}-(x-x_j)P_{i,j-1}}{x_j-x_i}$ | Description l.14–19 | Substituting $x=x_i$ gives $P_{i,j-1}(x_i)=y_i$, and $x=x_j$ gives $P_{i+1,j}(x_j)=y_j$. The script's tableau at x=2.0 matches, entry by entry, the Lagrange interpolant on nodes i..j (`tab.py`). | confirmed |
| 2 | "unique degree-$(n-1)$ polynomial" | l.12 | The degree is at most n-1. Here it is 3 for n=5. | wrong (F1, Minor) |
| 3 | Final value is $P_{0,n-1}(x)$ | l.21 | The script returns `P[1, deg+1]`, i.e. $P_{0,\text{deg}}$, and it equals the Lagrange value. | confirmed |
| 4 | Aitken at stage k combines the interpolant on $x_0..x_{k-1}$ with the one on $x_0..x_{k-2},x_j$; every entry in a column shares the leading nodes | l.21 | I implemented exactly this rule in `aitken.py`. It matches Mathews' description ("same row, preceding column" and "top row, preceding column"). | confirmed |
| 5 | Intermediate entries differ, but both schemes end with the same value | l.21 | At x=0.3, 2.0 and 2.8588 the final Aitken and Neville values agree to 2e-15. Intermediates differ: at x=2.0 the Aitken column-2 entry for node 3 vs the Neville entries. | confirmed |
| 6 | "The animation below uses Neville's scheme" | l.21 | The script's `neville_table` (lines 13–27) is Neville's recurrence over consecutive runs. | confirmed |
| 7 | $f(x)=\cos x$ | l.25, heading | Script line 30 `f(x) = cos(x)`. Titles say "cos(x)". | confirmed |
| 8 | 5 nodes $0,\pi/4,\pi/2,3\pi/4,\pi$ | l.25 | Script line 31. Frame 5 shows 5 black markers at those x positions. | confirmed |
| 9 | Each frame adds one node and shows $P_{0,j}$, degree at most j through the first j+1 nodes, j=0..4 | l.25 | `for deg in 0:4` uses `xs[1:deg+1]`. Frames 1–5 show 1–5 nodes with legend `P_{0,j}`. 5 frames (manifest). | confirmed |
| 10 | Heading: $P_{0,0}$ through $P_{0,4}$ for cos x | l.29 | Same as above | confirmed |
| 11 | Neville builds degree n from two of degree n-1 via the stated formula | l.31 | Same formula as claim 1 | confirmed |
| 12 | Max error on $[0,\pi]$ is 2.00 at j=0 | l.31 | 2.0 at x=π (sympy) | confirmed |
| 13 | ... 0.90 at j=1 | l.31 | 0.898805 at x≈2.7596 (sympy). The script grid gives 0.898805. | confirmed |
| 14 | ... rises to 1.66 at j=2, at $x=\pi$, where the quadratic reaches $-2.66$ | l.31 | 1.656854 at x=π. $P_{0,2}(\pi)=-2.656854$ (sympy and script) | confirmed |
| 15 | ... drops to $8.1\times10^{-3}$ at j=3 | l.31 | 0.00806767 at x≈2.8588 (sympy). The script grid gives 0.00806758. | confirmed |
| 16 | "Adding a node does not always reduce the error" | l.31 | 0.90 → 1.66 from j=1 to j=2 | confirmed |
| 17 | $P_{0,3}$ already passes through $(\pi,-1)$ because cos is odd about $\pi/2$ | l.31 | sympy: `P3(pi)+1 = 0` exactly. The reason is sound: the nodes are symmetric about π/2 and the data are odd, so the 5-node interpolant is odd about π/2, has no even terms, and so has degree ≤ 3. | confirmed |
| 18 | $P_{0,4}=P_{0,3}$, so the last two frames show the same curve | l.31 | sympy `P4-P3 = 0`. Script max difference on the plot grid is 6.7e-16. Frames 4 and 5 show the same red curve; only the node count and title differ. | confirmed |
| 19 | Source link `nevilleaa.jl` | l.33 | The file exists and is the only script. It regenerates the committed GIF byte-identically (manifest, and `cmp` confirms). | confirmed |
| 20 | Alt text: interpolants of cos at 0, π/4, π/2, 3π/4, π from the degree-0 constant to $P_{0,4}$, the same cubic as $P_{0,3}$ | l.35 | Frames 1–5 | confirmed |
| 21 | No archived animation GIF exists for this topic; the cos x example is the page's own | l.37 | No Neville/Aitken animation under `a2001/Animations/` (grep -ril neville/aitken finds nothing; Interpolation/ holds only Chebyshev, FourierSeries, Lagrange, Pade, Series). Mathews' examples use $e^x$ (gr_83, gr_205). | confirmed |
| 22 | Example 1 builds a polynomial by recursion; Examples 2–7 fill Aitken/Neville tableaux at one evaluation point; none animated | l.38 | lnk_2 (Example 1, "Use recursion to construct the polynomial"). lnk_3–lnk_8 (Examples 2–7, "compute the entries in Aitken's tableau and Neville's tableau for evaluating ... at ...") | confirmed |
| 23 | Frame titles: "P_{0,j}, degree j (j+1 nodes)"; last frame "P_{0,4} = P_{0,3}, degree 3 (5 nodes)" | frames | Degrees from sympy: 0, 1, 2, 3, 3 | confirmed |

---

### 3. Implementation checks: `nevilleaa.jl`

**Is it the method it claims to be?** Yes. `neville_table` (lines 13–27) fills `P[i,i]=y_i` and then, by increasing run length, `P[i,j] = ((xq-x_i)P[i+1,j] - (xq-x_j)P[i,j-1])/(x_j-x_i)`. This is Neville's recurrence over consecutive node runs, matching the Description's formula. It is not Aitken's arrangement and not a Lagrange or Newton evaluation under another name. Each frame rebuilds the table on the first deg+1 nodes and takes the top-right entry. That is mathematically identical to reading $P_{0,\text{deg}}$ from one 5-node table, a legitimate implementation choice. (The animation draws only the top-row interpolants $P_{0,j}$, not the intermediate $P_{i,j}$ with i>0. The page says so accurately on line 25, so I do not count it as a finding.)

**Are the numbers right?** Yes. Evidence:
- The full 5×5 tableau at x=2.0 from the script's own `neville_table` (`julia review/instr.jl`) matches, entry by entry to all printed digits, an independent table built from `scipy.interpolate.lagrange` on nodes i..j (`python3 review/tab.py`). Examples: P[0,4] = -0.41287896 for both, P[1,4] = -0.41287896, P[2,4] = -0.43774835, P[3,4] = -0.57427358, P[0,2] = -0.56144884.
- Node reproduction: the script's interpolant reproduces y at the nodes used, with max residual 1.1e-16 for every degree.
- Script values set against independent sympy values:

| deg | script max err on grid in [0,π] | sympy max err on [0,π] | script $P(\pi)$ | sympy $P(\pi)$ | script $P(\pi+0.1)$ | sympy $P(\pi+0.1)$ |
|---|---|---|---|---|---|---|
| 0 | 1.99999990 | 2.0 | 1.0 | 1.0 | 1.0 | 1.0 |
| 1 | 0.89880475 | 0.89880474 | -0.17157288 | -0.17157288 | -0.20886520 | -0.20886520 |
| 2 | 1.65585889* | 1.65685425 | -2.65685425 | -2.65685425 | -2.88209164 | -2.88209164 |
| 3 | 0.00806758 | 0.00806767 | -1.0 | -1.0 | -0.98648543 | -0.98648543 |
| 4 | 0.00806758 | 0.00806767 | -1.0 | -1.0 | -0.98648543 | -0.98648543 |

\*The script's 500-point grid does not contain x=π exactly, so its grid maximum falls slightly short. The true value 1.6569 is the page's "1.66".

- An Aitken implementation written independently from the page's description (`aitken.py`) gives the same final value as Neville at x = 0.3, 2.0 and 2.8588 (agreement to 2e-15).

**Are its reference values right?** The reference curve is `cos.(x_plot)`, which is the exact function, so it is correct by construction. The nodes are `cos.(xs)`.

**Does the picture show what was computed?** Yes. I viewed all 5 committed frames (`committed/nevilleaa/frame_001..005.png`):
- Frame 1 shows a red dashed constant y=1 and one node at (0,1).
- Frame 2 shows the line through (0,1) and (π/4, 0.707), reaching ≈ -0.21 at the right edge (computed -0.2089).
- Frame 3 shows the quadratic leaving the blue cos curve after π/2 and reaching ≈ -2.88 at the right edge (computed -2.882), within the ylims (-3, 1.4). So the claimed $P_{0,2}(\pi)=-2.66$ is visible and not clamped.
- Frames 4 and 5 show the red dashed curve on top of cos across the window, with 4 and then 5 nodes. The last node, (π,-1), lies on the curve.

Titles and legend use the right index and degree in every frame. The function in the title, cos(x), is the function in the code. No clamping or NaN masking is used. The x window is [-0.1, π+0.1], so every feature the page discusses (the error maximum at π for j=2, the error locations ≈2.76 and ≈2.86) is inside it. There are 5 frames at fps=1, one per case of j. The titles print the subscripts literally as "P_{0,j}" (GR does not render them as subscripts). This is cosmetic and still readable, so it is not a finding. The committed GIF is byte-identical to a fresh run of a scratch copy (manifest; `cmp` confirmed).

**Legacy fidelity:** Mathews' module has no animation for this topic. Its seven examples are tableau evaluations of $e^x$ (Example 2: $x_i = 1 + i/4$, $\hat{x}=1.6$) and one recursive polynomial construction. The page states openly that its cos x example is its own and that Examples 1–7 are not animated (lines 37–38). This is a disclosed departure, not a silent one, so I report no Fidelity finding.

