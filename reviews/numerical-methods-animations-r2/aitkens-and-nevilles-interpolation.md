# Aitken's and Neville's Interpolation — animation review (round 2)

Page: `pages/numerical-methods/aitkens-and-nevilles-interpolation/`. Reported findings: **0 Error, 0 Misleading, 3 Minor**.

## Findings

### F1. Page match, Minor: the last frame's title says "degree 4" but the curve is the cubic the page describes
- **Location:** `nevilleaa.jl` line 50 (`title="Neville's Algorithm for cos(x) — degree $deg  ($(deg+1) node…)"`), shown in frame 5 of `nevilleaa.gif`. It conflicts with index.qmd line 31: "…the fifth node leaves the polynomial unchanged: $P_{0,4}=P_{0,3}$, and the last two frames show the same curve", and with alt text line 35: "…P_{0,4}, which is the same cubic as P_{0,3}".
- **What is there now:** frame 5's title reads "degree 4 (5 nodes)". The page text (correctly) says the curve is a cubic.
- **What is true:** P₀,₄ has exact degree 3. Sympy gives `Poly(P04).degree() = 3` and `simplify(P04 − P03) = 0`. In floating point the script's curves differ by at most 6.7e-16 on the plot grid (`inst.out`: `max |P04-P03| on plot grid = 6.661338147750939e-16`).
- **Why it matters:** the title is the most prominent text in the frame, and taken literally it contradicts the page. "Degree 4" is defensible only as the nominal degree bound. Severity is Minor because the page states the actual situation explicitly.
- **Suggested correction:** label frames by the number of nodes or by degree "≤ $deg", for example `"… — P_{0,$deg}, degree ≤ $deg ($(deg+1) nodes)"`. For deg = 4 the title could also say "(= P_{0,3}, cubic)".

- **Independent check:** not run (Minor finding, unverified)

### F2. Page match, Minor: the j = 2 error the page quotes (1.66 at x = π) falls outside the plotted window
- **Location:** `nevilleaa.jl` line 48 (`ylims=(-1.4, 1.4)`), frame 3. Page line 31: "…rises to 1.66 at $j=2$…".
- **What is there now:** in frame 3 the dashed quadratic leaves the bottom of the axes at about x ≈ 2.5, so the viewer cannot see where it ends up at x = π.
- **What is true:** the maximum error of P₀,₂ on [0, π] is 1.6568542 and it occurs at x = π, where P₀,₂(π) = −2.657. Across the plot range, the minimum of P₀,₂ is −2.882 (at x = π + 0.1). From `inst.out`: `deg=2 maxerr[0,pi]=1.6568542494923797 at x=3.141592653589793 … plot-range y in [-2.882…, 1.0075…]`.
- **Why it matters:** the qualitative point, that the error grows, is still visible. But the specific value the page cites cannot be read off the animation. Severity is Minor.
- **Suggested correction:** widen `ylims` to about (−2.9, 1.4) for all frames, or only for frame 3. Alternatively, add a sentence such as "the quadratic falls to about −2.66 at x = π, off the bottom of the plot".

- **Independent check:** not run (Minor finding, unverified)

### F3. Fidelity, Minor: the only example is not one of Mathews' examples, and no reason is given
- **Location:** index.qmd lines 25 and 29 (the cos x example with nodes 0, π/4, π/2, 3π/4, π). The page cites `[@mathewsSite]` as its source inspiration.
- **What is there now:** a single case, cos x with 5 equally spaced nodes on [0, π], showing whole interpolant curves P₀,ⱼ(x).
- **What the archive has:** `NevilleAlgorithmMod.html`, examples 1–7, uses e^x on {0, 1, 2}, e^x on {1 + i/4}, i = 0..3, evaluated at x̂ = 1.6, and BesselJ[0, x] on {0.5 i}, i = 0..5. The examples compute both the Aitken tableau and the Neville tableau at a single evaluation point, and the page's diagonal-agreement and node-rearrangement themes come from these examples. I read the function and node images in `archive_montage.png`. The archive has no animation for this topic.
- **Why it matters:** this is a small departure. The archive has no animation to reproduce, and the cos x example is mathematically sound. The page does not say that its example is not taken from Mathews.
- **Suggested correction:** add one clause saying that the example is the page's own, or switch to one of Mathews' functions, for example e^x on 1 + i/4.

No Error-level or Misleading-level findings.

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `nevilleaa.jl` | 0 | 4.7 | nevilleaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Source (page text) | Claim | Evidence | Verdict |
|---|---|---|---|---|
| 1 | Description | "evaluates the unique degree-$(n-1)$ polynomial through data points" | This is the standard (loose) wording for "degree at most n−1". The Animations section uses the precise wording "degree at most j". | Confirmed (loose wording; see F1 for the case where it matters) |
| 2 | Description | $P_{i,i}=y_i$, $P_{i,j}=\frac{(x-x_i)P_{i+1,j}-(x-x_j)P_{i,j-1}}{x_j-x_i}$ | Checked algebraically: at x = xᵢ the formula gives P_{i,j−1}(xᵢ) = yᵢ, and at x = xⱼ it gives P_{i+1,j}(xⱼ) = yⱼ. Every tableau entry at x = 0.5 matches Lagrange on the corresponding node subset (`inst.out` vs `tab.py`, e.g. P₀,₂ = 0.861449440765, P₁,₄ = 0.88322310248, P₂,₄ = 1.63139194878, P₃,₄ = −0.0148887390352). | Confirmed |
| 3 | Description | The final value is $P_{0,n-1}(x)$ | Full-table P[1,5] = 0.883223102480269, Lagrange on all 5 nodes = 0.883223102480269 | Confirmed |
| 4 | Description | Aitken stage k combines the interpolant on x₀…x_{k−1} with the interpolant on x₀…x_{k−2}, xⱼ; entries in a column share leading nodes | Implemented exactly that way in `aitken.py`. For example, entry (k = 2, j = 4) = 0.829508737396, which equals Lagrange on {x₀, x₁, x₄} = 0.829508737396. | Confirmed |
| 5 | Description | Neville combines interpolants on neighbouring runs of consecutive nodes | P_{i,j} uses P_{i+1,j} and P_{i,j−1} (the consecutive runs i+1..j and i..j−1) | Confirmed |
| 6 | Description | "The intermediate entries differ, but both schemes end with the same interpolated value" | The intermediates differ (e.g. Aitken column 1 = 0.8135, 0.6817, 0.6377, 0.6817 vs Neville P_{i,i+1} = 0.8135, 0.9641, 0.9641, −0.0149). Both end at 0.883223102480269. | Confirmed |
| 7 | Description | "The animation below uses Neville's scheme" | The script's `neville_table` is the Neville recursion (lines 18–24) | Confirmed |
| 8 | Animations intro | f(x) = cos(x) | script line 29 | Confirmed |
| 9 | Animations intro | 5 nodes 0, π/4, π/2, 3π/4, π | script line 30 | Confirmed |
| 10 | Animations intro | "Each frame adds one node" | Frames 1–5 show 1, 2, 3, 4, 5 black node markers (script line 57; frames viewed) | Confirmed |
| 11 | Animations intro | Each frame shows $P_{0,j}$, the interpolant of degree ≤ j through the first j+1 nodes, j = 0…4 | `interp_degree` uses `xs[1:deg+1]` and returns P[1,deg+1]. The node residuals are ≤ 1.1e-16 for each j (`inst.out`). There are 5 frames (manifest; `for deg in 0:4`). | Confirmed |
| 12 | Case 1 heading | "$P_{0,0}$ through $P_{0,4}$ for $\cos(x)$" | Same as 9 and 11 | Confirmed |
| 13 | Behavior | Neville builds the degree-n polynomial by combining two of degree n−1 (the formula as in 2) | Same formula as 2. "Degree-n" is meant nominally. | Confirmed |
| 14 | Behavior | "Adding a node does not always reduce the error" | The maximum error goes 2.00 → 0.899 → 1.657 → 0.00807 → 0.00807 | Confirmed |
| 15 | Behavior | max error = 2.00 at j = 0 on [0, π] | Independent: 2.0 (at x = π). Script code: 2.0. | Confirmed |
| 16 | Behavior | 0.90 at j = 1 | Independent: 0.89880475 (at x = 2.75944). Script: 0.8988047473789157. | Confirmed |
| 17 | Behavior | 1.66 at j = 2 | Independent: 1.6568542 (at x = π). Script: 1.6568542494923797. | Confirmed (but not visible in the frame; see F2) |
| 18 | Behavior | 8.1×10⁻³ at j = 3 | Independent: 0.008067672 (at x = 0.282844 and, by symmetry, π − 0.282844). Script: 0.008067671948749022. | Confirmed |
| 19 | Behavior | P₀,₃ passes through (π, −1) | sympy: P₀,₃(π) + 1 simplifies to 0 exactly. Script floating point: residual ≤ 1.1e-16. | Confirmed |
| 20 | Behavior | "because cos is odd about π/2" | cos(π/2 + t) = −sin t is odd in t. The full argument is that the interpolant of odd data on nodes symmetric about π/2 is odd, so it has degree ≤ 3 and must equal P₀,₃. The page compresses this argument, but its conclusion is correct. | Confirmed |
| 21 | Behavior | "$P_{0,4}=P_{0,3}$" | sympy: P04 − P03 = 0, and P04 has degree 3. Script: max diff 6.7e-16. | Confirmed |
| 22 | Behavior | "the last two frames show the same curve" | Frames 4 and 5 show the same dashed curve (visual check, plus the numeric diff in 21). Frame 5 adds the node at π and has a different title. | Confirmed (but the frame 5 title says "degree 4"; see F1) |
| 23 | Source link | `[Julia source](nevilleaa.jl)` is this case's script | The file exists, and per the manifest it produces `nevilleaa.gif` | Confirmed |
| 24 | Embed | `nevilleaa.gif` is the Case 1 animation | Committed GIF is byte-identical to the regenerated output of `nevilleaa.jl` (manifest) | Confirmed |
| 25 | Alt text | Successive interpolants of cos(x) at nodes 0, π/4, π/2, 3π/4, π, from the degree-0 constant to P₀,₄, "the same cubic as P₀,₃" | Frame 1 shows the constant y = 1. Frame 5 shows the cubic (21). | Confirmed |
| 26 | Frames (legend) | Blue solid curve = f(x) = cos(x), red dashed curve = P_{0,j}(x), black markers = nodes used | Script lines 54–57 and the frames | Confirmed. The legend prints the literal text "P_{0,2}(x)" rather than a subscript. This is cosmetic and not a finding. |
| 27 | Frames (title) | "degree $deg ($(deg+1) nodes)" | The node counts are correct. Frame 5's "degree 4" conflicts with the cubic the page describes. | Wrong in frame 5 (F1, Minor) |

---

### 3. Implementation checks: `nevilleaa.jl`

**It is the method it claims to be.** Lines 12–26 implement Neville's recursion exactly as the page writes it: P[i,i] = yᵢ, and P[i,j] = ((x − xᵢ)P[i+1,j] − (x − xⱼ)P[i,j−1])/(xⱼ − xᵢ), filled by increasing run length. For each degree, `interp_degree` builds a fresh table on the first deg+1 nodes and returns P[1,deg+1]. This is the same value as the top-row entry P₀,deg of the full 5-node table, as `inst.out` confirms: the row-1 entries of the full table at x = 0.5 (1.0, 0.813538, 0.861449, 0.883223, 0.883223) equal the `interp_degree` values for degrees 0–4. It is plain Neville, not a different method. Aitken's scheme is not animated, and the page says so.

**The numbers are right.**
- Tableau at x = 0.5, script vs independent Lagrange evaluation (`tab.py`), with all 15 nonzero entries agreeing to 12 digits:
  - row 0: 1.0, 0.813538, 0.861449, 0.883223, 0.883223 vs 1.0, 0.813538385711, 0.861449440765, 0.88322310248, 0.88322310248
  - row 1: 0.707107, 0.964055, 0.964055, 0.883223 vs 0.707106781187, 0.964055404295, 0.964055404295, 0.88322310248
  - row 2: 6.1e-17, 0.964055, 1.63139 vs 8.5e-32, 0.964055404295, 1.63139194878
  - row 3: −0.707107, −0.0148887 vs −0.707106781187, −0.0148887390352
  - row 4: −1.0 vs −1.0
- Interpolation property: the residuals at the nodes are ≤ 1.1e-16 for every degree.
- Known closed form: interpolating g(x) = 2x³ − x + 1 with the script's routine reproduces g to 2.8e-14 (degree 3) and 2.1e-14 (degree 4) across the plot grid, as it must for a cubic.
- Maximum error on [0, π], script code (200001-point grid) vs independent (sympy exact polynomial plus mpmath refinement): j = 0: 2.0 / 2.0; j = 1: 0.89880475 / 0.89880475; j = 2: 1.65685425 / 1.6568542; j = 3: 0.00806767 / 0.008067672; j = 4: 0.00806767 / 0.008067672.

**Its reference values are right.** The reference curve is `f(x) = cos(x)`, evaluated directly (line 54). There is no other reference quantity.

**The picture shows what was computed.** I viewed frames 1, 3 and 5 and the contact sheet of all 5 frames.
- Frame 1 shows the constant y = 1 with one node.
- Frame 2 shows the line through (0, 1) and (π/4, 0.7071), reaching −0.209 at x = π + 0.1, which matches the computed plot range.
- Frame 3 shows the quadratic through 3 nodes. It leaves the axes near x ≈ 2.5 because `ylims = (−1.4, 1.4)` and its minimum is −2.88 (F2).
- Frames 4 and 5 show the same cubic, which is visually indistinguishable from cos. Frame 5 adds the node at (π, −1).
- The legend entries match the plotted series.
- The title's node count is correct. Its "degree" is the nominal bound (F1).
- The frame count is 5 (j = 0…4) at fps = 1, and the regenerated GIF is byte-identical to the committed one.
- The plot spans [−0.1, π + 0.1]. The page's error claims refer to [0, π], and I verified them on that interval.

**Could not determine:** nothing material. Several archive formula images are small inline graphics I did not view individually. I did view the example functions and nodes (the gr_76/77, 201–204, 336–338, 495–497 images) and the tableau algorithms (gr_1, gr_2).

