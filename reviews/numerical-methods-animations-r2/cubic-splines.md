# Cubic Splines — animation review (round 2)

Page: `pages/numerical-methods/cubic-splines/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1: Fidelity, Minor: the archive's worked examples (including the clamped spline) are replaced by a new example, and the page gives no reason

- **Location:** `index.qmd` lines 25 and 29–35 (the Animations intro and Case 1). This is the only case on the page.
- **What is there now:** There is one animation: a natural spline for $\sin x$ on $[0,2\pi]$ with 3, 4, 5, 6, 7 and 9 equally spaced nodes. The page does not mention Mathews' examples.
- **What the archive has:** The Cubic Splines module has no animated GIF. Its worked examples are:
  - Examples 1 and 2 (`_lnk_2`, `_lnk_3`, image `gr_27`/`gr_28`): a natural cubic spline through `{(0,1),(1,0),(2,0),(3,1),(4,2),(5,2),(6,1)}`.
  - Example 3 (`_lnk_4`, `gr_55`/`gr_56`): a clamped spline through the same points, with $S'(0)=-0.2$ and $S'(6)=-2.5$.

  The page's authoring conventions (`.github/agents/animation-page.agent.md`, "Legacy Availability Decision" step 3) say: when there is no animated GIF, reconstruct the animation from the worked examples. The page uses an unrelated function instead. It also drops the clamped-spline example altogether, so the clamped end condition appears only in prose in the Description.
- **How I know:** I read the archive HTML and images listed above. I recomputed both archive splines with SciPy, and they match the archive graphs:
  - natural: minimum −0.150 at x = 1.5, maximum 2.150 at x = 4.5, $M=[0,1.2,1.2,0,-1.2,-1.2,0]$
  - clamped: minimum −0.192 at x ≈ 1.468, maximum 2.098 at x ≈ 4.42

  (These came from the inline `python3 -c` snippet using `CubicSpline(x, y, bc_type=...)`.)
- **Why Minor:** The sin(x) convergence animation is mathematically correct and a reasonable teaching choice. Nothing on the page is false.
- **Suggested correction:** Choose one of two fixes:
  - Add one or two cases built from the archive data: the natural spline through the 7 points, and the clamped spline with $S'(0)=-0.2$, $S'(6)=-2.5$. If you like, the animation can add one panel per frame or compare natural with clamped.
  - Or add one sentence saying the sin(x) convergence example is new to this page and was not taken from Mathews' examples.

No other findings. I checked the clipped closing parenthesis on the right edge of the titles in frames 4–6 and did not count it as a finding. Only the `)` is cut off, and every digit of the error value can be read.

---

- **Independent check:** not run (Minor finding, unverified)


## Reviewer's notes (not findings)


**Summary: 0 Error, 0 Misleading, 1 Minor.**



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `cubicsplineaa.jl` | 0 | 5.1 | cubicsplineaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `cubicsplineaa.gif` | 6 | byte-identical | cubicsplineaa |

### Page references

- Scripts linked: `cubicsplineaa.jl`
- GIFs embedded: 1
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

Each claim is quoted in the page's own words. The evidence is my own computation or the frames.

| # | Location | Claim (page's words) | Verdict | Evidence |
|---|---|---|---|---|
| 1 | Description ¶1 | "piecewise-cubic interpolant built on nodes $x_0<\cdots<x_n$ so that each panel polynomial $S_i(x)$ interpolates endpoint values" | Confirmed | Script residual at the nodes is ≤ 2.2e-16 for every n (`inst.jl`, column `nodeerr`) |
| 2 | Description ¶1 | "enforces continuity of $S$, $S'$, and $S''$ at interior knots" | Confirmed | $S$ and $S''$ are continuous by construction, since the panel formula uses the shared $y_i$ and $M_i$. The largest jump in one-sided $S'$ at interior knots is ≤ 2.2e-16 (`inst.jl`, `maxS'jump`) |
| 3 | Description ¶2 | natural spline: $S''(x_0)=0,\ S''(x_n)=0$ | Confirmed | Script sets `M[1]=M[end]=0`. SciPy `bc_type='natural'` gives identical interior M (n = 4: ±1.184581; n = 9: −0.74415, −1.052387, …) |
| 4 | Description ¶3 | "The unknown second derivatives are found from a tridiagonal linear system, then each cubic panel is reconstructed." | Confirmed | Script lines 19–31 build the standard $h_{j-1}M_{j-1}+2(h_{j-1}+h_j)M_j+h_jM_{j+1}=6(\Delta_j-\Delta_{j-1})$ system. It is stored dense and solved with `\`, and the system is still tridiagonal. Lines 35–45 reconstruct each panel from the M values |
| 5 | Description ¶3 | "with clamped (exact $f'$ at the ends) or not-a-knot end conditions, the maximum error scales like $O(h^4)$" | Confirmed | f = cos on [0, 2π], n = 17→257. Clamped max-error ratios per halving were 16.23, 16.06, 16.01, 16.00; not-a-knot ratios were 14.98, 15.75, 15.94, 15.98 (`indep.py`) |
| 6 | Description ¶3 | "With natural end conditions it is only $O(h^2)$ unless $f''(a)=f''(b)=0$" | Confirmed | f = cos (f''(0) = −1), natural: max-error ratios were 4.06, 4.02, 4.00, 4.00 |
| 7 | Description ¶3 | "that error sits near an end where $f''\neq 0$, and away from the ends the error is still $O(h^4)$" | Confirmed | Location of the natural-spline maximum error for cos: x = 0.150, 6.208, 0.037, 0.019, 0.009, so always at an end. On [1.5, 2π−1.5] the error ratios are 16.36, 16.06, 16.01, 16.00 |
| 8 | Animations intro | "natural cubic spline fitted to equally-spaced data from $f(x)=\sin(x)$ on $[0,2\pi]$" | Confirmed | Script lines 47 and 54: `f(x)=sin(x)`, `range(0.0, 2π, length=nn)` |
| 9 | Animations intro | "with the number of nodes increasing" | Confirmed | `n_node_list = [3,4,5,6,7,9]`. Frame titles show 3, 4, 5, 6, 7, 9 |
| 10 | Animations intro | "The natural spline satisfies $S''(a)=S''(b)=0$" | Confirmed | Same as #3. SciPy $S''$ at the ends is ≤ 6e-16 |
| 11 | Case heading | "Natural cubic spline convergence for $\sin(x)$" | Confirmed | Method and function as in #3 and #8. The error decreases monotonically (see #12) |
| 12 | Behavior | "Adding nodes shrinks the maximum error rapidly." | Confirmed | Max error (fine grid of 200001 points) is 1.000, 0.10877, 0.020017, 0.0089651, 0.0040708, 0.0010661 for n = 3, 4, 5, 6, 7, 9. It falls monotonically, by about 940× overall |
| 13 | Behavior | "For this $f$ the natural end conditions are exact, since $\sin''(0)=\sin''(2\pi)=0$" | Confirmed | $\sin''(x)=-\sin x$ is 0 at 0 and at 2π |
| 14 | Behavior | "so the spline converges at $O(h^4)$, where $h$ is the maximum node spacing" | Confirmed | Script routine, n = 9→17→33→65→129 (h halved each time): error ratios 16.9, 16.2, 16.06, 16.0. SciPy gives the same |
| 15 | Behavior | "for a smooth $f$ with $f''(a)\neq 0$ or $f''(b)\neq 0$ the natural spline's maximum error falls only as $O(h^2)$" | Confirmed | Same as #6 |
| 16 | Behavior | "The 3 to 9 nodes shown are too few for this rate to show cleanly from frame to frame." | Confirmed (a hedge) | Frame-to-frame local orders are 5.47, 5.88, 3.60, 4.33, 4.66. They scatter around 4, so "not cleanly" is fair. Across 5→9 nodes (h halved) the ratio is 18.8 against the ideal 16, which is close but not frame-to-frame |
| 17 | Behavior | "Each frame uses a fully recomputed spline (solving the tridiagonal second-derivative system) for the new set of nodes." | Confirmed | Script lines 53–57: `natural_spline_M` is called inside the `@animate` loop for every `nn` |
| 18 | Source link | `[Julia source](cubicsplineaa.jl)` | Confirmed | The file exists and is the script that produces the embedded GIF. A scratch copy reproduces the committed GIF byte-for-byte (`cmp`: identical) |
| 19 | Embed | `![…](cubicsplineaa.gif)` | Confirmed | 6 distinct frames (frames.md5: 6 distinct hashes), 700×500, fps 2 |
| 20 | Alt text | "Natural cubic spline approximating sin(x) on [0, 2pi] with n=3,4,5,6,7,9 nodes" | Confirmed | Frame titles read 3, 4, 5, 6, 7, 9 nodes. x-axis is [0, 2π] |
| 21 | Alt text | "the spline closely tracks the true curve as nodes increase" | Confirmed | Frame 1: S ≡ 0 (all three data values are 0), visibly off. Frame 2: visible gap (error 0.109). Frames 3–6: the dashed red curve overlays the blue one |
| 22 | Frames (titles) | "max err ≈ 1.0 / 0.109 / 0.02 / 0.00896 / 0.00407 / 0.00107" | Confirmed | Script computes the error on a 600-point grid. Fine-grid values (200001 points, both script and SciPy) are 1.0, 0.10877, 0.020017, 0.0089651, 0.0040708, 0.0010661, which agree to the 3 significant figures shown. "0.02" is `round(0.020017, sigdigits=3)` printed without trailing zeros, so it is correct |
| 23 | Frames (legend) | blue = "f(x) = sin(x)", red dashed = "S(x) — cubic spline", black = "data nodes" | Confirmed | Script lines 67–70. Node markers sit at `range(0,2π,length=nn)` in every frame viewed |
| 24 | Section index | page linked from numerical-methods index | Confirmed | `pages/numerical-methods/index.qmd:62` `- [Cubic Splines](cubic-splines/)` |

I left out the attribution line "Source inspiration: [@mathewsSite]", as the brief requires.

---

### 3. Implementation checks: `cubicsplineaa.jl`

**It is the method it claims to be.** It is a natural cubic spline in the standard second-derivative (M) formulation:
- Rows j = 1..n−1 of the interior system are $h_jM_j + 2(h_j+h_{j+1})M_{j+1} + h_{j+1}M_{j+2} = 6\big[(y_{j+2}-y_{j+1})/h_{j+1} - (y_{j+1}-y_j)/h_j\big]$, with $M_1=M_{n+1}=0$. The coefficient indices in lines 23–27 are correct: the subdiagonal entry of row j is the left-interval width `h[j]`, and the superdiagonal entry is `h[j+1]`.
- Lines 42–44 evaluate the standard M-form panel $\frac{M_i}{6h}(x_{i+1}-x)^3+\frac{M_{i+1}}{6h}(x-x_i)^3+(\frac{y_i}{h}-\frac{M_ih}{6})(x_{i+1}-x)+(\frac{y_{i+1}}{h}-\frac{M_{i+1}h}{6})(x-x_i)$.
- `searchsortedlast` plus `clamp` picks the panel correctly, including at x = 2π.

The system is solved with a dense `A \ b` rather than a Thomas sweep. The system solved is the same tridiagonal one, so this is not a different method.

**The numbers are right.** I instrumented a scratch copy (`review/inst.jl`) and compared it with SciPy `CubicSpline(bc_type='natural')` (`review/indep.py`).

| n | script M (interior, first few) | SciPy M | script max err (600 pts, as titled) | script max err (200001 pts) | SciPy max err (200001 pts) |
|---|---|---|---|---|---|
| 3 | 0 | 0 | 0.99999656 → "1.0" | 1.0 | 1 |
| 4 | −1.184581, 1.184581 | −1.184581, 1.184581 | 0.108771038 → "0.109" | 0.10877104 | 0.108771 |
| 5 | −1.215854, 0, 1.215854 | same | 0.020016823 → "0.02" | 0.020017013 | 0.020017 |
| 6 | −1.081379, −0.668329, … | same | 0.0089649 → "0.00896" | 0.0089651 | 0.00896508 |
| 7 | −0.947665, −0.947665, 0, … | same | 0.0040706 → "0.00407" | 0.0040708 | 0.00407079 |
| 9 | −0.74415, −1.052387, −0.74415, … | same | 0.0010661 → "0.00107" | 0.0010661 | 0.00106609 |

Property checks that do not rely on remembering the formula:
- **Interpolation at nodes:** the residual is ≤ 2.2e-16 for every n.
- **C¹ continuity at interior knots:** the one-sided $S'$ values differ by ≤ 2.2e-16.
- **Natural boundary condition:** M at the ends is exactly 0.
- **Order:** halving h with the script's own routine (n = 9, 17, 33, 65, 129) gives error ratios 16.9, 16.2, 16.06, 16.0, which is $O(h^4)$ as expected because $\sin''$ vanishes at both ends.
- **$S''$ against the true second derivative:** at n = 129 the interior M approach $-\sin x_i$ (peak 1.000201 at 3π/2, against 1).

**Its reference values are right.** The reference is `sin` evaluated directly, so it is exact to machine precision. The 600-point evaluation grid used for the title error underestimates the true maximum by at most about 2e-7 relative to the 200001-point grid. That does not change any of the 3 significant figures shown.

**The picture shows what was computed.** I viewed all 6 frames (contact sheet) and frames 4, 5 and 6 at full size:
- Each frame plots `sin` (blue), the spline S on 600 points (red dashed) and the nodes (black) at the right positions: 3 nodes at 0, π, 2π; 9 nodes at multiples of π/4.
- Frame 1 correctly shows S ≡ 0, because $\sin(0)=\sin(\pi)=\sin(2\pi)=0$ up to 1.2e-16.
- Frame 2 shows the visible gap matching error 0.109, with the largest deviation near the extrema.
- Titles give the correct node count and error for each frame.
- The axes are xlims (0, 2π) and ylims (−1.4, 1.4). No clamping or NaN masking is used, and nothing the page discusses falls outside the window.
- Cosmetic only: the closing `)` of the title is clipped at the right edge in frames 4–6. All digits are readable.
- The committed GIF is byte-identical to a fresh run of a scratch copy (`cmp` reported identical), so the frames reflect the current script.

**Fidelity to the archive:** see F1. The archive's natural-spline and clamped-spline worked examples (7 data points) are not represented. The page's sin(x) example is new and the page does not say so.

