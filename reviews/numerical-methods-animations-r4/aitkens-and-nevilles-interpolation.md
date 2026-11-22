# Aitken's and Neville's Interpolation — animation review (round 4)

Page: `pages/numerical-methods/aitkens-and-nevilles-interpolation/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1. Fidelity, Minor: the page says the archive's examples are only tableaux, but Examples 3–5 also plot successive Neville interpolants

- **Location:** `index.qmd` line 29: "No archived animation GIF is available for this topic in the current snapshot, so the $\cos x$ example animated here is the page's own, not one of the examples in Mathews' module. The module's Examples 1–7, which build an interpolating polynomial by recursion (Example 1) and fill in Aitken's and Neville's tableaux at a single evaluation point (Examples 2–7), ... are not animated here."
- **What is there now:** The page describes Examples 2–7 only as tableau fill-ins at one point. It explains the switch to its own $\cos x$ example by saying there is no archived GIF.
- **What is true instead:** Examples 3, 4 and 5 in the archive (`NevilleAlgorithmMod_lnk_4/5/6.html`) each include a static plot of $f$ together with the successive Neville polynomials $P_0, P_{0,1}, P_{0,1,2}, P_{0,1,2,3}$ and the nodes. That is the same picture the animation builds frame by frame:
  - Example 3: $f(x)=e^x$, nodes $x_i = 1 + i/4$ ($i=0..5$), $\hat x = 1.8$. The Mathematica cell is `gr_306.gif` (`Plot[{f[x], P0[x], P01[x], P012[x], P0123[x]}, {x,1,2.25}]`) and the plot is `gr_307.gif`.
  - Example 4: $f(x)=J_0(x)$, nodes $x_i = 0.5i$, $\hat x=1.8$ (`gr_340.gif`). The plot is `gr_352.gif`.
  - Example 5: $f(x)=e^x$ with nodes rearranged by distance from 1.8 (`gr_391.gif`). The plot is `gr_406.gif`.
  
  So the archive does contain a successive-interpolant example the page could have animated, and the page's account of the archive understates what is there. The page does say plainly that its $\cos x$ example is its own, so a reader is not misled about the mathematics. The inaccuracy is only in how the page describes the source.
- **How I know:** I read the HTML of each example as text (`sed 's/<[^>]*>//g' ...`) and listed the graph-sized images (`HEIGHT>=100`). I looked at `gr_295`, `gr_306`, `gr_307`, `gr_340`, `gr_352`, `gr_391` and `gr_406` directly.
- **Suggested correction:** Do one of the following:
  - Correct the sentence, for example: "Examples 3–5 plot the successive Neville polynomials $P_0,\dots,P_{0,1,2,3}$ of $e^x$ (nodes $1, 1.25, \dots$) and $J_0(x)$ (nodes $0, 0.5, \dots$); the animation here uses $\cos x$ instead, because ..."
  - Or add a case that animates Mathews' Example 3, $e^x$ at $x_i = 1+i/4$ on $[1, 2.25]$.

No other findings.

Observed but not counted as a finding: the title and legend show literal `P_{0,2}` text because GR does not render the braces as subscripts. It is readable and unambiguous.

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `nevilleaa.jl` | 0 | 5.0 | nevilleaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Page text (own words) | Evidence | Verdict |
|---|---|---|---|
| D1 | Neville "evaluates the unique polynomial of degree at most $n-1$ through data points $(x_i,y_i)$" | With $n$ points indexed $0..n-1$ this is standard. Script node residual is ≤1.1e-16 for every degree (instr.jl). | confirmed |
| D2 | $P_{i,i}=y_i$, $P_{i,j}=\frac{(x-x_i)P_{i+1,j}-(x-x_j)P_{i,j-1}}{x_j-x_i}$ | Checked algebraically: at $x=x_i$ it gives $P_{i,j-1}(x_i)=y_i$ and at $x=x_j$ it gives $P_{i+1,j}(x_j)=y_j$. It is the same as script lines 22–23. | confirmed |
| D3 | "The final interpolated value at a query point $x$ is $P_{0,n-1}(x)$" | Script returns `P[1, deg+1]`. At x=1 the 5-node table's top-right is 0.537569521354321, sympy gives 0.5375695213543209. | confirmed |
| D4 | Aitken "combines the interpolant on $x_0..x_{k-1}$ with the interpolant on $x_0..x_{k-2},x_j$, so every entry in a column shares the same leading nodes", while Neville uses neighbouring runs | Matches Mathews' "top row, preceding column" rule for Aitken and "preceding row" rule for Neville. I implemented Aitken exactly as described (aitken.py). | confirmed |
| D5 | "The intermediate entries differ, but both schemes end with the same interpolated value" | aitken.py at x = 1, 2, π+0.1: Aitken 0.53756952135432, −0.41287895668986, −0.98648542530062. Neville gives the same values, and so does a degree-4 polyfit. | confirmed |
| D6 | "The animation below uses Neville's scheme" | Script recursion uses $P_{i+1,j}$ and $P_{i,j-1}$ (neighbouring runs), which is Neville, not Aitken. | confirmed |
| A1 | $f(x)=\cos(x)$ | script line 30 | confirmed |
| A2 | 5 nodes $0, \pi/4, \pi/2, 3\pi/4, \pi$ | script line 31 | confirmed |
| A3 | "Each frame adds one node and shows $P_{0,j}(x)$ ... through the first $j+1$ nodes, for $j=0,\dots,4$" | `for deg in 0:4` uses `xs[1:deg+1]`. The GIF has 5 frames showing 1–5 black node markers. | confirmed |
| A4 | "Julia source scripts ... are linked under each case" | `[Julia source](nevilleaa.jl)` is under Case 1 and the file exists. | confirmed |
| A5 | No archived animation GIF for this topic | No Neville/Aitken file in `a2001/Animations` (find returned none). The module HTML has no animation. | confirmed |
| A6 | "The $\cos x$ example ... is the page's own, not one of the examples in Mathews' module" | Mathews uses $e^x$ and $J_0$ (see F1). | confirmed |
| A7 | Module Example 1 "build[s] an interpolating polynomial by recursion" | lnk_2 text: "Use recursion to construct the polynomial". | confirmed |
| A8 | Examples 2–7 "fill in Aitken's and Neville's tableaux at a single evaluation point" | True, but Examples 3–5 also plot successive interpolants (F1). | wrong (incomplete), F1 |
| C1 | Heading: "Neville's algorithm: $P_{0,0}$ through $P_{0,4}$ for $\cos(x)$" | Frame titles P_{0,0} … P_{0,4} | confirmed |
| C2 | "builds the interpolating polynomial of degree at most $n$ by combining two polynomials of degree at most $n-1$" with the stated formula | Same as D2 | confirmed |
| C3 | "Adding a node does not always reduce the error" | max error goes 0.899 → 1.657 from j=1 to j=2 | confirmed |
| C4 | max error 2.00 at j=0 | indep.py 2.0 (at x=π). Script grid gives 1.99999990. | confirmed |
| C5 | max error 0.90 at j=1 | indep.py 0.898805 (at x≈2.7594). Script grid gives 0.898805. | confirmed |
| C6 | max error 1.66 at j=2, "at $x=\pi$" | indep.py 1.656854 at x=π (=4√2−4) | confirmed |
| C7 | quadratic "reaches −2.66" at π | indep.py P_{0,2}(π) = −2.656854. Script gives −2.6568542494923797. | confirmed |
| C8 | max error $8.1\times10^{-3}$ at j=3 | indep.py 0.0080677 (x≈2.8587). Script grid gives 0.0080676. | confirmed |
| C9 | "cubic $P_{0,3}$ already passes through $(\pi,-1)$" | sympy gives P_{0,3}(π) = −1 exactly. Script gives −1.0000000000000002. | confirmed |
| C10 | "because cos is odd about π/2" | cos(π−t) = −cos t (residual 1.2e-16). The data are therefore odd about π/2, so the 5-node interpolant is odd about π/2, has degree ≤ 3, and equals the 4-node cubic by uniqueness. | confirmed |
| C11 | "$P_{0,4}=P_{0,3}$, and the last two frames show the same curve" | sympy gives P04−P03 = 0. Script grid max difference is 6.7e-16. Frames 4 and 5 show identical red curves and differ only in the 5th node marker and the title. | confirmed |
| C12 | Alt text: "Neville algorithm building successive polynomial interpolants of cos(x) at nodes 0, π/4, π/2, 3π/4, π, from the degree-0 constant to the five-node interpolant P_{0,4}, which is the same cubic as P_{0,3}" | frames 1–5 | confirmed |
| W1 | Embed `nevilleaa.gif` is the Case 1 animation, and its link is `nevilleaa.jl` | The GIF is produced by that script and is byte-identical on regeneration (manifest). | confirmed |
| W2 | Page listed in section index | `pages/numerical-methods/index.qmd:67` | confirmed |

Frame-level claims (from the script header and titles):

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| G1 | Frame titles "degree j (j+1 nodes)" for j=0..3, and "P_{0,4} = P_{0,3}, degree 3 (5 nodes)" for frame 5 | The degree of each interpolant is 0, 1, 2, 3, 3 by sympy. | confirmed |
| G2 | Script comment: the quadratic's minimum is ≈ −2.88 at x = π+0.1, so ylims (−3, 1.4) show P_{0,2}(π) | P_{0,2}(π+0.1) = −2.882 and the window range is [−2.882, 1.0076]. Frame 3 shows the whole curve inside the axes. | confirmed |
| G3 | Legend: blue = cos, red dashed = P_{0,j}, black = nodes used | frames 1–5 | confirmed |

---

### 3. Implementation checks: `nevilleaa.jl`

**Method identity.** `neville_table` (lines 13–27) fills the tableau by increasing run length, combining `P[i+1,j]` and `P[i,j-1]` with the weights $(x-x_i)$ and $-(x-x_j)$ over $(x_j-x_i)$. This is Neville's algorithm, using consecutive runs of nodes, as the page says. It is not Aitken's. For each degree the script builds a fresh table on the first deg+1 nodes and returns the top-right entry. That equals the top row $P_{0,j}$ of the full 5-node table: at x=1 the full table's row 1 is 1, 0.627077, 0.555024, 0.537570, 0.537570, which matches the per-degree values. It is evaluated pointwise on 500 points in [−0.1, π+0.1].

**Numbers.** I instrumented a copy (`review/instr.jl`) and compared it with an independent sympy Lagrange interpolation (`review/indep.py`):

| deg | script P(π) | sympy P(π) | script P(1.0) | sympy P(1.0) | max err on [0,π] (sympy, refined) |
|---|---|---|---|---|---|
| 0 | 1.0 | 1.0 | 1.0 | 1.0 | 2.000000 |
| 1 | −0.17157287525381 | −0.17157287525381 | 0.6270767714219434 | 0.6270767714219434 | 0.898805 |
| 2 | −2.65685424949238 | −2.65685424949238 | 0.5550244478486578 | 0.5550244478486578 | 1.656854 |
| 3 | −1.0000000000000002 | −1 (exact) | 0.537569521354321 | 0.5375695213543209 | 0.0080677 |
| 4 | −1.0 | −1 (exact) | 0.537569521354321 | 0.5375695213543209 | 0.0080677 |

The interpolant reproduces the data at the nodes (max residual 1.1e-16 at every degree). sympy confirms $P_{0,4}-P_{0,3}\equiv 0$.

**Reference values.** The reference curve is `cos.(x_plot)`, which is the exact function. Nothing is computed numerically as a reference.

**Picture.** I viewed all 5 committed frames:
- Each frame draws cos in blue, $P_{0,j}$ in red dashed, and the first j+1 nodes as black markers.
- Frame 1 shows the constant 1.
- Frame 2 shows the chord through (0,1) and (π/4, 0.707), reaching about −0.21 at the right edge.
- Frame 3 shows the quadratic diving to about −2.88 at x=π+0.1, inside ylims −3.
- Frames 4 and 5 show the red dashes overlaid on cos. Frame 5 adds the node at (π, −1), which lies on the curve.

Titles and legend indices match the computed degree. There is no clamping or masking. The x-window extends 0.1 past each end of [0,π]. The page's error figures are stated on [0,π], and I computed them on [0,π].

