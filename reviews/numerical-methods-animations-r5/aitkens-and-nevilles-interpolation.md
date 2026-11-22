# Aitken's and Neville's Interpolation — animation review (round 5)

Page: `pages/numerical-methods/aitkens-and-nevilles-interpolation/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1: Fidelity, Minor. The animated example is the page's own and none of Mathews' worked examples is used.

- **Location:** `index.qmd`, Animations intro: "No archived animation GIF is available for this topic in the current snapshot, so the $\cos x$ example animated here is the page's own, not one of the examples in Mathews' module." Also `nevilleaa.jl` lines 30–31 (`f(x) = cos(x)`, `xs = [0, π/4, π/2, 3π/4, π]`).
- **What is there now:** one case using $\cos x$ at 5 equally spaced nodes on $[0,\pi]$. The page states the departure openly and lists the Mathews examples it does not animate.
- **What the archive has:** the module has worked examples that use exactly the successive-interpolant idea this animation shows. Example 3 (`lnk_4`, image `gr_295`) uses $f(x)=e^x$ with nodes $x_i = 1.0 + i/4$ for $i=0..5$ and $\hat x = 1.8$. Its Aitken tableau (`gr_310`) ends at $6.049643$, against the true value $6.049647$. Example 4 (`lnk_5`, `gr_340`) uses $f(x)=J_0(x)$ with nodes $x_i = 0.5i$ for $i=0..5$ and $\hat x=1.8$. Example 5 (`lnk_6`, `gr_391`) uses $e^x$ with the nodes reordered by distance from $\hat x=1.8$: $\{1.75, 2.0, 1.5, 2.25, 1.25, 1.0\}$.
- **Why it is a finding:** the stated reason, that no archived GIF exists, does not explain why a worked example was not used. The page conventions (`.github/agents/animation-page.agent.md`, line 71) say that when no animated GIF exists, the worked examples should be used to infer the function and parameters. The departure is disclosed, so a reader is not misled, which is why this is Minor. The mathematics of the page's own example is correct (see sections 2 and 3).
- **Suggested correction:** if the owner wants fidelity here, as in decision R4-D on the Newton page, animate Example 3: $e^x$ on nodes $1.0, 1.25, \dots, 2.25$, adding one node per frame and marking $\hat x=1.8$. The Example 5 node ordering is optional; it shows Mathews' point about clustering nodes near $\hat x$. Otherwise, reword the reason, for example to "chosen to show the non-monotone error and the $P_{0,4}=P_{0,3}$ symmetry", so that it does not read as forced by the missing GIF.

No other findings.

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `nevilleaa.jl` | 0 | 6.4 | nevilleaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

Evidence key:
- [S]: symbolic or numeric independent computation in `indep.py` (sympy `interpolate`, error on a 200001-point grid over $[0,\pi]$).
- [I]: instrumented copy of the script's own routines, `inst.jl`.
- [A]: independent Neville, Aitken and barycentric cross-check, `aitken.py`.
- [F]: committed frames 1–5, all viewed.

### Description

| # | Claim (page wording) | Verdict | Evidence |
|---|---|---|---|
| D1 | Neville "evaluates the unique polynomial of degree at most $n-1$ through data points $(x_i,y_i)$" (indices $0..n-1$) | Confirmed | Standard result. For $n$ points, [S] gives the unique interpolant. |
| D2 | "without first converting to expanded polynomial coefficients" | Confirmed | The script evaluates the tableau pointwise at each query `xq` (lines 13–27, 46). |
| D3 | $P_{i,i}=y_i$, $P_{i,j}=\frac{(x-x_i)P_{i+1,j}-(x-x_j)P_{i,j-1}}{x_j-x_i}$ | Confirmed | Checked the endpoints: at $x=x_i$ the formula gives $P_{i,j-1}(x_i)=y_i$, and at $x=x_j$ it gives $P_{i+1,j}(x_j)=y_j$. Numerically [A]: this formula, 0-based, gives the same values as scipy barycentric to $10^{-16}$ at $x=1.0, 0.3, 2.9, 3.2$. |
| D4 | "The final interpolated value at a query point $x$ is $P_{0,n-1}(x)$" | Confirmed | [A]: `neville(x)[0,-1]` equals barycentric. |
| D5 | Aitken: "At stage $k$ it combines the interpolant on $x_0..x_{k-1}$ with the interpolant on $x_0..x_{k-2},x_j$, so every entry in a column shares the same leading nodes" | Confirmed | Matches Mathews' Aitken tableau headings $Q_{0,1,2,i}$ etc. (`gr_309`). I implemented exactly this rule in [A]. |
| D6 | "both schemes end with the same interpolated value" | Confirmed | [A]: Aitken and Neville agree to about $2\times10^{-15}$ at 4 test points, e.g. $x=1$: 0.537569521354321 for both. |
| D7 | "The animation below uses Neville's scheme." | Confirmed | `neville_table` implements D3 (lines 19–24). |

### Animations: intro, case, behaviour, alt text, wiring

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| A1 | $f(x)=\cos(x)$ | Confirmed | Script line 30. Frame titles say "cos(x)" [F]. |
| A2 | 5 nodes $0,\pi/4,\pi/2,3\pi/4,\pi$ | Confirmed | Script line 31. Node markers in frame 5 sit at these $x$ [F]. |
| A3 | "Each frame adds one node and shows $P_{0,j}(x)$ … for $j=0,\dots,4$" | Confirmed | The loop `deg in 0:4` gives 5 frames, and `interp_degree` returns `P[1,deg+1]` on the first deg+1 nodes, i.e. $P_{0,j}$. The frames show 1, 2, 3, 4 and 5 nodes [F]. |
| A4 | "the interpolant of degree at most $j$ through the first $j+1$ nodes" | Confirmed | [I]: residual at the nodes used is at most $1.1\times10^{-16}$ for every $j$. [S]: degrees are 0, 1, 2, 3, 3. |
| A5 | Case heading: "Neville's algorithm: $P_{0,0}$ through $P_{0,4}$ for $\cos(x)$" | Confirmed | As A1 and A3. |
| A6 | Behaviour: "builds the interpolating polynomial of degree at most $n$ by combining two polynomials of degree at most $n-1$" and the formula restated | Confirmed | $P_{i,j}$ has degree $\le j-i$ and is built from two entries of degree $\le j-i-1$. The formula is identical to D3. (Here $n$ means the degree, while in the Description it means the number of points. Each statement is true on its own terms, so this is not a finding.) |
| A7 | "Adding a node does not always reduce the error" | Confirmed | The error rises from $j=1$ to $j=2$ (see A9). |
| A8 | Max error on $[0,\pi]$ is 2.00 at $j=0$ | Confirmed | [S] 2.000000 at $x=\pi$. [I] 2.0. |
| A9 | 0.90 at $j=1$ | Confirmed | [S] 0.898805 at $x\approx2.7594$. [I] 0.8988047. |
| A10 | Rises to 1.66 at $j=2$, at $x=\pi$ | Confirmed | [S] 1.65685 at $x=\pi$. [I] 1.6568542 at $x=\pi$. |
| A11 | "the quadratic reaches $-2.66$" at $x=\pi$ | Confirmed | [S] $P_{0,2}(\pi)=-2.656854$. [I] the same. |
| A12 | Drops to $8.1\times10^{-3}$ at $j=3$ | Confirmed | [S] 0.00806767 at $x\approx0.2828$. [I] 0.0080677. |
| A13 | "the cubic $P_{0,3}$ already passes through $(\pi,-1)$" | Confirmed | [S] exact symbolic $P_{0,3}(\pi)=-1$. [I] $-1.0000000000000002$. |
| A14 | "because $\cos$ is odd about $\pi/2$" (reason) | Confirmed | $\cos(\pi/2+t)=-\sin t$ is odd in $t$. The node data are odd about $\pi/2$, so $P_{0,4}$ is odd in $t=x-\pi/2$, has no $t^4$ term, and is a cubic. By uniqueness it is $P_{0,3}$. The reasoning is sound. |
| A15 | "$P_{0,4}=P_{0,3}$" | Confirmed | [S] `simplify(P4-P3) = 0` exactly. [I] $\max\lvert P_{0,4}-P_{0,3}\rvert=6.7\times10^{-16}$ on the plot grid. |
| A16 | "the last two frames show the same curve" | Confirmed | [F] frames 4 and 5 show identical red curves. Frame 5 adds the fifth node marker. |
| A17 | Alt text: "…from the degree-0 constant to the five-node interpolant $P_{0,4}$, which is the same cubic as $P_{0,3}$" | Confirmed | Frame 1 is the constant 1 and frame 5 is the cubic [F]. A15. |
| A18 | Wiring: `[Julia source](nevilleaa.jl)` and embed `nevilleaa.gif` | Confirmed | Both files exist in the page folder. The GIF is produced by this script (byte-identical regeneration, manifest). |
| A19 | "Julia source scripts … are linked under each case" | Confirmed | One case, one link. |
| A20 | "No archived animation GIF is available for this topic in the current snapshot" | Confirmed | No Neville or Aitken material in `a2001/Animations/`. The `Interpolation/` folder there has only Chebyshev, FourierSeries, Lagrange, Pade and Series. The n2003 module has only static images. |
| A21 | Description of Mathews' Examples 1–7 (what each computes or plots, and the degrees 3, 4, 2 for Examples 3–5) | Not assessed | This is legacy-inventory content, which the review standard excludes. Spot checks were consistent with it: Examples 2–7 compute Aitken and Neville tableaux at $\hat x$, and Example 1 builds a quadratic by recursion. |

### Frames (what the diagram shows)

| # | Item | Verdict | Evidence |
|---|---|---|---|
| G1 | Blue line = $f(x)=\cos x$, red dashed = $P_{0,j}$, black dots = "nodes used" | Confirmed | Lines 61–64 and the legend in every frame [F]. |
| G2 | Titles "P_{0,j}, degree j (j+1 nodes)" for frames 1–4, and frame 5 "P_{0,4} = P_{0,3}, degree 3 (5 nodes)" | Confirmed | The degrees match the exact degrees [S]. (The braces print literally, which is cosmetic.) |
| G3 | The feature the page discusses, $P_{0,2}(\pi)=-2.66$, is visible | Confirmed | ylims $(-3.0, 1.4)$. The minimum on the plot window is $P_{0,2}(\pi+0.1)=-2.882$ [S][I], which is inside the window. No clamping or masking is used. |
| G4 | Frame count 5 | Confirmed | Manifest and [F]. |

---

### 3. Implementation checks: `nevilleaa.jl`

**It is the method it claims to be.** Lines 13–27 implement Neville's tableau over consecutive runs: $P_{i,j}$ is built from $P_{i+1,j}$ and $P_{i,j-1}$ with exactly the page's recurrence, evaluated pointwise at each query point. This is Neville, not Aitken, Lagrange or a Vandermonde solve. `interp_degree` (lines 37–43) builds the tableau on the first `deg+1` nodes and returns the top-right entry, $P_{0,\text{deg}}$. That is the same value as the top-row entry $P_{0,j}$ of the full 5-node tableau, because Neville's $P_{0,j}$ depends only on $x_0..x_j$. The full tableau at $x=1$ ([I]) is consistent: row 1 is 1.0, 0.627077, 0.555024, 0.53757, 0.53757.

**The numbers are right.** Script values ([I], `inst.jl`, which runs the script's own `neville_table` and `interp_degree`) beside the independent values ([S], sympy exact interpolation):

| $j$ | max err on $[0,\pi]$ script | independent | $P_{0,j}(\pi)$ script | independent | $P_{0,j}(\pi+0.1)$ script | independent |
|---|---|---|---|---|---|---|
| 0 | 2.0 | 2.000000 | 1.0 | 1.000000 | 1.0 | 1.000000 |
| 1 | 0.8988047 | 0.898805 | −0.1715729 | −0.171573 | −0.2088652 | −0.208865 |
| 2 | 1.6568542 | 1.65685 | −2.6568542 | −2.656854 | −2.8820916 | −2.882092 |
| 3 | 0.0080677 | 0.00806767 | −1.0000000 | −1.000000 | −0.9864854 | −0.986485 |
| 4 | 0.0080677 | 0.00806767 | −1.0 | −1.000000 | −0.9864854 | −0.986485 |

Property checks:
- Interpolation reproduces the data at the nodes: residual at most $1.1\times10^{-16}$ for every $j$.
- $P_{0,4}\equiv P_{0,3}$: symbolically 0, and $6.7\times10^{-16}$ on the grid.
- A second independent route, a Python Neville and Aitken implementation checked against scipy `BarycentricInterpolator` ([A]), agrees to $10^{-15}$.

**Its reference values are right.** The reference curve is `cos` itself (line 30), evaluated directly. It needs no check beyond confirming that it is $\cos$, and it is.

**The picture shows what was computed.** I viewed frames 1–5.
- Frame 1: the horizontal line $y=1$ and one node at $(0,1)$.
- Frame 2: the line through $(0,1)$ and $(\pi/4, 0.707)$, reaching about $-0.21$ at the right edge, which matches $-0.2089$.
- Frame 3: a parabola through 3 nodes, diving to about $-2.9$ at the right edge, which matches $-2.882$, inside ylim $-3$.
- Frames 4 and 5: the cubic lying on $\cos$, with 4 and then 5 nodes.

The legend, titles and node markers use the right indices and quantities. The axis limits do not hide anything the page discusses. No NaN masking or clamping is used. The script's comment at line 53 ("≈ −2.88 at x = π + 0.1") is correct.

Regeneration: the scratch run exited 0 and produced a GIF byte-identical to the committed one (manifest), so the frames reviewed are the output of this code.

