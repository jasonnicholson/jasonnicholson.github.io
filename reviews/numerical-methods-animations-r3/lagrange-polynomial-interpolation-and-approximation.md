# Lagrange Polynomial Interpolation and Approximation — animation review (round 3)

Page: `pages/numerical-methods/lagrange-polynomial-interpolation-and-approximation/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1. Case 14: f = tan x is drawn as one continuous curve through its poles (vertical magenta segments at x ≈ ±π/2)

- **Kind:** Implementation (display) / page match
- **Severity:** Minor
- **Location:** `lagnewt_animations_all.jl` lines 194–201 (`ytrue_clip` is used for f whenever `case.pole` is NaN) and line 47 (Case 14 row has no `pole=`). Page text: "Where a curve leaves the plot window, it is drawn along the window's top or bottom edge, except $f$ in Cases 01–03, which runs off the window and is broken at its pole."
- **What is there now:** For Case 14, f is clamped to the y-limits (±27.79) and plotted as one series. No sample on the 1000-point grid falls on ±π/2. Adjacent samples straddle each pole with tan values of +211.99 / −635.98 (at x = −1.5755, −1.5692) and +635.98 / −211.99 (at x = 1.5692, 1.5755), so the clamped values jump from the top edge to the bottom edge. The line between them draws a full-height vertical magenta segment at each pole. All 10 frames show it (see `committed/lagnewt14/frame_004.png`).
- **What is true instead:** tan x has no values between −27.8 and 27.8 at x = ±π/2. The segment is a plotting artifact, not part of f, and it reads as though the f curve were continuous through the pole. This is neither of the two behaviours the page describes ("drawn along the top or bottom edge" or "broken at its pole"). Cases 01–03 got exactly this treatment for the same reason. Cases 24–26 (Γ at 0) happen to break correctly only because a grid sample lands exactly on x = 0.0 (gamma(0.0) = Inf → NaN; checked: `xs[38] == 0.0`).
- **How I know:** `julia -e '… t=range(-pi,pi,length=1000); find sign changes of tan with |tan|>5'` printed `tan jump between -1.5755134328813678 -1.569223958099406 211.99 -635.98` and `tan jump between 1.569223958099406 1.5755134328813678 635.98 -211.99`. The frames show the vertical lines.
- **Suggested correction:** Break f at its poles in Case 14 as in 01–03. Generalise `pole::Float64` to a list, give the Case 14 row `poles = (-π/2, π/2)`, and insert NaN at each. Alternatively, insert NaN wherever consecutive clamped f values jump from one edge to the other. Then either add Case 14 to the page's exception sentence, or reword it to "except $f$ at its poles (Cases 01–03 and 14), where it is broken".

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `lagnewt_animations_all.jl` | 0 | 34.4 | 29 GIFs (lagnewt01.gif … lagnewt29.gif) | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `lagnewt01.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt02.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt03.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt04.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt05.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt06.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt07.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt08.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt09.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt10.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt11.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt12.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt13.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt14.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt15.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt16.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt17.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt18.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt19.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt20.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt21.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt22.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt23.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt24.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt25.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt26.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt27.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt28.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt29.gif` | 10 | byte-identical | lagnewt_animations_all |

### Page references

- Scripts linked: `lagnewt_animations_all.jl`
- GIFs embedded: 29
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

Verdicts: **C** = confirmed, **W** = wrong, **?** = could not determine.

### Description

| # | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|
| D1 | "builds a unique polynomial of degree at most $n$ through $n+1$ data points" | Standard. The script's interpolant reproduces node values (nodeYerr ≤ 1.5e-15 vs mpmath f). | C |
| D2 | "evaluate it in the first barycentric form, $P_n(x)=\ell(x)\sum w_i y_i/(x-x_i)$, $\ell=\prod(x-x_j)$, $w_i=1/\prod_{j\ne i}(x_i-x_j)$" | Code lines 110–139 compute exactly this: `w[j] /= (xs[j]-xs[k])`, `s += w*y/(x-xj)`, `l *= (x-xj)`, return `l*s`. Node hits are returned directly. | C |
| D3 | "This is the same interpolant" | Compared with direct 60-digit Lagrange-basis evaluation at all 1000 plot points, all 29 cases, all 10 degrees: max clamped difference/y-range = 8.7e-10 (Case 29) and ≤ 1.2e-10 elsewhere. | C |
| D4 | "it stays accurate far outside the nodes" | Max relative error vs the 60-digit reference over the whole window, including extrapolation: ≤ 6.8e-11 in Cases 01–27, 3.2e-8 (Case 28), 6.6e-8 (Case 29). The first form never had the wrong sign (0 points). | C |
| D5 | "the second barycentric form … gives values of the wrong sign in Cases 04 and 29" | `second.jl` (same loop order as the script, BigFloat reference): wrong sign only in Case 04 (deg 13: 4 pts from x = 9.60; deg 15: 1 pt at x = 9.54) and Case 29 (deg 13: 2 pts from x = 19.36; deg 15: 151 pts from x = 11.72). No other case. The numpy version in `check.py` agrees. | C |
| D6 | "Given nodes $(x_i,y_i)$ … $P_n=\sum y_i L_i$, $L_i=\prod_{j\ne i}\frac{x-x_j}{x_i-x_j}$" | Standard formula. It is the reference used in D3. | C |
| D7 | "The 29 animations below follow the legacy Mathews case ordering" | Matches the a2001 Lagrange index: function and window per case 01–29 (`review/legacy_formulas.png`). | C |
| D8 | "the nodes are equally spaced from $a$ to $b$, endpoints included" | All rows, all degrees: max \|x_i − linspace(a,b,n)_i\| ≤ 3.6e-15. The trimming fallback in `equal_nodes` is never triggered. | C |
| D9 | "Where the plot window is wider than $[a,b]$ (Cases 01–11, 14, 19 and 24–29), the interpolant beyond the nodes is extrapolation" | From `dump.txt`, span ≠ xlims for exactly 01–11, 14, 19 and 24–29. In 12, 13, 15–18 and 20–23, span = xlims. | C |
| D10 | "In Case 19, $\arcsin x$ is undefined outside $[-1,1]$, so there only the interpolant is drawn" | `asin` throws for \|x\| > 1 → NaN; only the interpolant appears in \|x\| > 1 (lagnewt19 frames). | C |

### Animations introduction

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| A1 | "raises the polynomial degree through 1, 2, 3, 4, 5, 7, 9, 11, 13 and 15 (2, 3, 4, 5, 6, 8, 10, 12, 14 and 16 nodes)" | `n_nodes_seq = [2,3,4,5,6,8,10,12,14,16]`. Every GIF has 10 frames, titled degree 1…15 in that order (all 29 contact sheets read). | C |
| A2 | "for a fixed function and node interval" | One case per GIF; span fixed across frames. | C |
| A3 | "Where a curve leaves the plot window, it is drawn along the window's top or bottom edge" | The interpolant is clamped (line 211) and f is clamped (line 194) when there is no pole. True for the interpolant everywhere. For f in Case 14, the curve is also joined across the poles by vertical segments. | C, with exception F1 |
| A4 | "except $f$ in Cases 01–03, which runs off the window and is broken at its pole" | `has_pole` branch (lines 196–201): unclamped f with NaN inserted at the pole. Frames 01–03 show f leaving the top edge and no connector across x = ±1. | C |
| A5 | "[Julia source for all cases](lagnewt_animations_all.jl)" | File exists; it is the only script; it produces all 29 GIFs (manifest: byte-identical on regeneration). | C |

### Per-case rows (heading, alt text, script row, GIF title)

All 29 GIF titles read "Interpolation Case NN: f(x) = <label>, degree d", with NN matching the heading and embed. Labels match the heading functions: 16 `cos(x)*exp(-x)` = $e^{-x}\cos x$; 22 `normal_pdf(x)` = $e^{-x^2/2}/\sqrt{2\pi}$; 23 `normal_cdf(x)` = ½(1+erf(x/√2)). Each embed `lagnewtNN.gif` sits under heading NN. For each row, "nodes on [a,b]" was checked against `resolved_span` and the window against `xlims`, both printed in `dump.txt`. The reference f was checked against mpmath on the 1000-point plot grid, with domain/NaN agreement. Max relative difference of f per case is given below. The NaN-pattern mismatch was 0 in every case.

| Case | Page heading / alt text | Script row (f, xlims, span) | f vs mpmath | Verdict |
|---|---|---|---|---|
| 01 | 1/(1−x), nodes [−1.5, 0.9], window [−1.6, 1.5], pole at 1; "beyond the pole f ≤ −2, below the window" | same; pole = 1; ylims = (−1.646, 11.248). For x ∈ (1, 1.5], f ≤ −2 < −1.646, so it is below the window. | 1.6e-16 | C |
| 02 | 1/(1+x), [−0.9, 1.5], window [−1.5, 1.6], pole −1; f ≤ −2 beyond pole | same; ylims (−1.646, 11.248) | 1.6e-16 | C |
| 03 | 1/(1−x)², [−1.5, 0.9], window [−1.6, 1.5], pole at 1 | same | 3.1e-16 | C |
| 04 | √x, [0, 2], f on [0, 10.5] | same | 1.0e-16 | C |
| 05 | √x, [0, 8], [0, 10.5] | same | 1.0e-16 | C |
| 06 | √x, [0, 10], [0, 10.5] | same | 1.0e-16 | C |
| 07 | 1/√(1−x), [−1.5, 0.95], window [−1.6, 1.5], f drawn for x < 1 | same; f → NaN for x > 1 | 1.7e-16 | C |
| 08 | 1/(1+10x²), [−1, 1], f on [−1.5, 1.5] | same | 1.6e-16 | C |
| 09 | ln x, [0.02, 2], window [−0.5, 4.1], f for x > 0 | same | 1.1e-16 | C |
| 10 | ln x, [0.02, 4], window [−0.5, 4.1] | same | 1.1e-16 | C |
| 11 | ln(1+x), [−0.98, 1], window [−1.5, 1.5], f for x > −1 | same | 1.6e-16 | C |
| 12 | sin x, [−3π, 3π], same interval | auto span = (−9.42478, 9.42478) | 7.3e-17 | C |
| 12b | "With 2, 3 and 4 nodes every node is a multiple of π … frames titled degree 1, 2 and 3 all show the line y = 0" | nodes/π = [−3,3], [−3,0,3], [−3,−1,1,3]; max\|P\| over window = 7.3e-16. For 5–16 nodes, max\|P\| ≥ 1.0, so no other frame is flat. | — | C |
| 13 | cos x, [−3π, 3π], same interval | same | 6.4e-17 | C |
| 13b | "With 2 and 4 nodes every node is an odd multiple of π … degree 1 and 3 show the line y = −1" | max\|P+1\| = 2.2e-16 (n = 2), 5.6e-16 (n = 4); all other n ≥ 1.88 | — | C |
| 14 | tan x, [−3, 3], f on [−π, π] | same (window ±π, span ±3) | 1.1e-16 | C (display issue F1) |
| 15 | eˣ, [−2, 3], same interval | auto span (−2, 3) | 1.1e-16 | C |
| 16 | e⁻ˣ cos x, [−2, 4] | auto (−2, 4) | 2.3e-16 | C |
| 17 | cosh x, [−4, 4] | auto (−4, 4) | 1.7e-16 | C |
| 18 | arctan x, [−2.2, 2.2] | auto (−2.2, 2.2) | 1.1e-16 | C |
| 19 | arcsin x, [−1, 1], window [−1.5, 1.5], f on [−1, 1] | same. The grid does not hit ±1 exactly, so the drawn f ends at x = ±0.9985 (visually indistinguishable; nodes at ±1 are on f). | 1.2e-16 | C |
| 20 | J₀(x), [−10.2, 10.2] | auto (−10.2, 10.2) | 1.1e-16 | C |
| 21 | J₁(x), [−10.2, 10.2] | auto | 1.8e-16 | C |
| 22 | normal pdf, [−3, 3] | auto (−3, 3) | 8.4e-17 | C |
| 23 | normal cdf, [−3, 3] | auto (−3, 3) | 1.2e-16 | C |
| 24 | Γ(x), [0.05, 2], f on [−0.2, 5.2] | same | 3.3e-16 | C |
| 25 | Γ(x), [0.05, 4], [−0.2, 5.2] | same | 3.3e-16 | C |
| 26 | Γ(x), [0.5, 5], [−0.2, 5.2] | same | 3.3e-16 | C |
| 27 | Y₀(x), [0.5, 20], f on [0, 22] | same | 1.8e-16 | C |
| 28 | Y₀(x), [0.5, 10], [0, 22] | same | 1.8e-16 | C |
| 29 | Y₀(x), [0.5, 4], [0, 22] | same | 1.8e-16 | C |

Observation, not counted as a finding: frame titles give the nominal degree n (number of nodes − 1). For the symmetric cases the interpolant's actual degree is lower in the first frames, consistent with the Description's "degree at most n":
- Cases 08, 17, 20 and 22: degree 1 is a horizontal line (equal node values, e.g. 08: 0.090909, 0.090909).
- Cases 18, 21 and 23: degree 2 is the same line as degree 1 (odd symmetry about the middle node).

The page explains this only for 12 and 13. That is a teaching choice, not a false statement.

Observation: the full-height vertical blue line in Case 28, degree 9 (x ≈ 18.2) is real. The polynomial crosses zero there between values far outside the window, and the clamped values agree with the 60-digit reference.

---

### 3. Implementation checks (`lagnewt_animations_all.jl`)

**It is the method it claims to be.** The script runs polynomial interpolation through equally spaced nodes, evaluated by the first (modified-Lagrange) barycentric formula (lines 110–139). That is exactly what the Description states. It is a legitimate evaluation scheme for the same Lagrange interpolant, not a different method. `equal_nodes` has a fallback that trims the interval if f is non-finite at a node. I confirmed it never fires: node positions match `linspace(a,b,n)` to ≤ 3.6e-15 in every row and degree.

**The numbers are right.** I dumped every node, node value and unclamped interpolant value from an instrumented copy (`review/dump.jl`, which `include`s the script's own functions). Independently, in Python/mpmath at 60 digits (`review/check.py`):
- f at each node vs mpmath: max abs error ≤ 1.2e-14 (Case 03, f ≈ 100); ≤ 1.5e-15 elsewhere.
- Interpolant vs direct Lagrange-basis evaluation at all 1000 plot points, clamped to the plotted y-limits: max difference ≤ 8.7e-10 of the y-range (Case 29) and ≤ 1.2e-10 in all others.
- Unclamped relative error ≤ 6.6e-8 (Case 29) and ≤ 6.8e-11 for Cases 01–27.
- Zero sign disagreements anywhere, including far extrapolation (to x = 22 from nodes on [0.5, 4]).
- Interpolation property: by construction, `barycentric_eval` returns y_j at nodes, and the plotted nodes are `(xs, ys_nodes)` from the same call.

Per-case summary (max over all 10 degrees), from `check.out`:

| Case | node x err | node y err | clamped diff / y-range | max rel err | 1st-form wrong sign | 2nd-form wrong sign (n: points) |
|---|---|---|---|---|---|---|
| 01 | 3.3e-16 | 4.4e-16 | 1.2e-13 | 3.8e-11 | 0 | — |
| 02 | 2.2e-16 | 4.4e-16 | 1.1e-13 | 2.3e-11 | 0 | — |
| 03 | 3.3e-16 | 1.2e-14 | 8.6e-15 | 2.2e-12 | 0 | — |
| 04 | 2.2e-16 | 1.1e-16 | 1.6e-11 | 6.2e-11 | 0 | 14: 5, 16: 1 |
| 05 | 8.9e-16 | 2.2e-16 | 1.2e-11 | 4.2e-11 | 0 | — |
| 06 | 1.8e-15 | 2.2e-16 | 8.6e-13 | 1.1e-12 | 0 | — |
| 07 | 4.4e-16 | 4.6e-16 | 1.5e-13 | 1.7e-12 | 0 | — |
| 08 | 2.2e-16 | 9.9e-17 | 3.3e-14 | 1.2e-12 | 0 | — |
| 09 | 2.2e-16 | 1.1e-16 | 2.2e-13 | 2.0e-12 | 0 | — |
| 10 | 4.4e-16 | 1.0e-16 | 4.3e-14 | 4.1e-13 | 0 | — |
| 11 | 2.2e-16 | 1.5e-16 | 4.4e-13 | 9.1e-12 | 0 | — |
| 12 | 2.7e-15 | 5.2e-17 | 5.6e-15 | 3.2e-12 | 0 | — |
| 13 | 2.7e-15 | 5.2e-17 | 1.4e-14 | 5.1e-13 | 0 | — |
| 14 | 8.9e-16 | 6.4e-16 | 3.2e-16 | 3.3e-13 | 0 | — |
| 15 | 4.4e-16 | 7.7e-16 | 4.8e-15 | 5.6e-13 | 0 | — |
| 16 | 8.9e-16 | 2.0e-16 | 7.4e-15 | 1.9e-12 | 0 | — |
| 17 | 8.9e-16 | 1.5e-15 | 2.5e-15 | 7.0e-14 | 0 | — |
| 18 | 6.7e-16 | 1.1e-16 | 1.7e-14 | 5.4e-14 | 0 | — |
| 19 | 2.2e-16 | 1.2e-16 | 1.4e-14 | 1.3e-12 | 0 | — |
| 20 | 1.8e-15 | 7.5e-17 | 2.4e-14 | 1.5e-12 | 0 | — |
| 21 | 1.8e-15 | 9.5e-17 | 1.6e-14 | 6.8e-11 | 0 | — |
| 22 | 8.9e-16 | 5.6e-17 | 2.4e-14 | 2.7e-12 | 0 | — |
| 23 | 8.9e-16 | 7.9e-17 | 2.4e-14 | 1.2e-11 | 0 | — |
| 24 | 2.2e-16 | 1.2e-15 | 1.3e-13 | 3.5e-11 | 0 | — |
| 25 | 4.4e-16 | 1.2e-15 | 1.2e-13 | 2.0e-11 | 0 | — |
| 26 | 8.9e-16 | 8.7e-16 | 4.9e-12 | 1.4e-11 | 0 | — |
| 27 | 3.6e-15 | 7.7e-17 | 1.3e-13 | 3.5e-12 | 0 | — |
| 28 | 1.8e-15 | 1.3e-16 | 1.1e-10 | 3.2e-8 | 0 | — |
| 29 | 4.4e-16 | 1.6e-16 | 8.7e-10 | 6.6e-8 | 0 | 14: 2, 16: 110 (numpy order) / 151 (Julia loop order) |

(The "2nd-form" column comes from `check.py`'s numpy evaluation. `second.jl` repeats it in the script's own loop order against a BigFloat reference, with the same two cases flagged.)

**Its reference values are right.** f is the "true" curve. I checked it against mpmath at every plot-grid point for all 29 rows: max relative difference ≤ 3.4e-16, and the finite/NaN pattern is identical everywhere (domain handling for √, log, asin, 1/√(1−x), Γ at 0 and Y₀ at 0 all agree). SpecialFunctions' `besselj`, `bessely`, `gamma` and `erf` all match mpmath to machine precision.

**The picture shows what was computed.**
- I read all 29 contact sheets and full-size frames for Cases 14 and 24.
- Each frame plots f (magenta), the interpolant from the same nodes (blue) and the nodes (red). The nodes lie on f and on the interpolant in every frame.
- Every title has the right case number, function label and degree (n_nodes − 1).
- The y-limits are the 3–97% quantile of f (taken on the node interval for pole cases), widened to include every node of every frame. Every node is therefore visible.
- Clamping of the interpolant is disclosed on the page.
- The x-margin of 2% keeps end nodes whole.
- The committed GIFs are byte-identical to fresh regeneration (manifest), with 10 frames each.
- One display defect: Case 14's f is joined across its poles (F1).
- Case 24–26's Γ breaks correctly at x = 0, but only because the grid `range(-0.2, 5.2, length=1000)` contains 0.0 exactly. This is correct but fragile; no finding.

### Fidelity to the legacy archive

- **Functions and windows:** match the a2001 index for all 29 cases (`review/legacy_formulas.png`).
- **Node intervals stated in the index:** 04 [0,2], 05 [0,8], 06 [0,10], 08 [−1,1], 09 [0.02,2], 10 [0.02,4], 11 [−0.98,1], 24 [0.05,2], 25 [0.05,4], 26 [0.5,5], 27 [0.5,20], 28 [0.5,10], 29 [0.5,4]. All match the page.
- **Case 01:** the legacy animation `Lagrangeaa.gif` shows nodes from −1.5 to 0.9, matching the page.
- **Case 07:** [−1.5, 0.95] matches the n2003 static example image (`LagrangePolyMod_gr_378`).
- **Case 19:** [−1, 1] matches the static example (`gr_476`).
- **Could not determine:** the legacy node intervals for Cases 02, 03, 12–18 and 20–23. Their animations are not in the archive and the index gives no node interval.
  - For Case 14, the static example uses [−1.45, 1.45], but the animation window is [−π, π]. The page's [−3, 3] is a stated, mathematically motivated choice (nodes on [−π, π] would hit ±π/2). I do not report it.
- **Degree sequence and tolerance band:** Mathews' animations (01, 04) step through degrees 2, 3, 5, 6, 8, 10, 13, 16, 19, 22, 25 and show a ±0.05 "Convergence Regions" band. The page uses degrees 1–15 and no band. It does not claim to reproduce either. This is a presentation choice and content the page does not have, so it is not reported as a finding.

