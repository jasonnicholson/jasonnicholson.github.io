# Lagrange Polynomial Interpolation and Approximation — animation review (round 8)

Page: `pages/numerical-methods/lagrange-polynomial-interpolation-and-approximation/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** No Error, Misleading or Minor findings.

Things I looked at and decided were not findings:

- **Archive "Convergence Regions" overlay not reproduced.** Mathews' animations (01 and 04 are on disk) are titled "Convergence Regions": a yellow bar marks where |P − f| < 0.05, and the degree goes much higher (S2…S25+ for Case 01, S2…S19 for Case 04). The page shows the interpolant and f only, for degrees 1–15. The page makes no claim to reproduce the overlay, the function, window and node interval of every case match the archive, and the review standard excludes content the page does not yet have. So this is not a finding. It is recorded here so the owner knows about it.
- **The breaks in f at the Γ pole (Cases 24–26) depend on the sampling grid.** The cases table gives no `poles` for 24–26. The break at x = 0 happens only because `range(-0.2, 5.2, length=1000)` contains exactly `0.0`, and `gamma(0.0) = Inf`, which `safe_eval` turns into NaN. I checked that it does: the dump shows x = 0.0 → f = NaN, and there is no connecting segment in the frames. The page's claim is therefore true as rendered. It would stop being true if the window or the sample count changed. This is fragile, but it is not wrong.
- **In Case 19, f is drawn only to x = ±0.9985.** That is the last grid point inside [−1, 1]. The f curve ends about 0.055 below the node marker at (±1, ±π/2), which is about 6 px and barely visible. It is not misleading.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `lagnewt_animations_all.jl` | 0 | 36.2 | 29 GIFs (lagnewt01.gif … lagnewt29.gif) | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Page text (quoted / paraphrased closely) | Evidence | Verdict |
|---|---|---|---|
| D1 | "a unique polynomial of degree at most $n$ through $n+1$ data points" | standard theorem | confirmed |
| D2 | First barycentric form $P_n(x)=\ell(x)\sum w_i y_i/(x-x_i)$, $\ell=\prod(x-x_j)$, $w_i=1/\prod_{j\ne i}(x_i-x_j)$; "The animations evaluate it in the first barycentric form" | script lines 112–141 implement exactly this | confirmed |
| D3 | "it stays accurate far outside the nodes" | script interpolant vs 60-digit mpmath Lagrange interpolant of the same float data, all 29×10 frames × 1000 points: max error / y-window ≤ 2.0e-9 (Case 29) wherever the exact value is within 0.5 window-heights of the window; the first form has **zero** sign errors anywhere in any window (`second.py`) | confirmed |
| D4 | "the second barycentric form … gives values of the wrong sign in Cases 04 and 29" | float64 second form vs exact, all cases: sign errors **only** in 04 (deg 13: x∈[9.6,10.4], e.g. exact 3.11e12 vs −7.76e11; deg 15: x∈[9.39,10.1]) and 29 (deg 13: x∈[19.4,20.0]; deg 15: 189 points in x∈[11.3,21.8], wrong sign or inf) | confirmed |
| D5 | Lagrange basis formula $P_n=\sum y_iL_i$, $L_i=\prod_{j\ne i}(x-x_j)/(x_i-x_j)$ | standard; used as my independent reference | confirmed |
| D6 | "The 29 animations below follow the legacy Mathews case ordering" | archive `Lagrange.html` functions 1–29 match the case table row for row (montage `archive_formulas_*.png`) | confirmed |
| D7 | "nodes are equally spaced from $a$ to $b$, endpoints included" | instrumented dump: `equal_nodes` never trims (trimmed=false for all 290 node sets); nodes equal `np.linspace(a,b,n)` to 1e-14 | confirmed |
| D8 | "plot window is wider than [a, b] (Cases 01–11, 14, 18–20 and 24–29)" | xlims vs span from dump: exactly those cases have xlims ⊋ span; 12, 13, 15–17, 21–23 have xlims = span | confirmed |
| D9 | "In Case 19, arcsin x is undefined outside [−1, 1], so there only the interpolant is drawn" | `asin` throws DomainError → NaN; frames show only blue beyond ±1 | confirmed |
| A1 | Degrees 1, 2, 3, 4, 5, 7, 9, 11, 13, 15 (2…16 nodes) | `n_nodes_seq`; 10 frames per GIF (manifest); titles in sheets | confirmed |
| A2 | "The degree in each title is the number of nodes minus one … its actual degree can be lower" | title string `degree $(n_nodes - 1)` | confirmed |
| A3 | Even cases (08, 13, 17, 20, 22): degree-1 frame is a horizontal line; degree-15 frame has degree 14 | mpmath Vandermonde solve: n=2 slope 0 for all five; n=16 c15 ≈ 0 (≤6e-37) and c14 ≠ 0 (−371, −3.65e-12, 1.4e-11, −7.2e-13, −1.27e-7); these are the only even-f symmetric-node cases | confirmed |
| A4 | "A curve that goes off-scale leaves the plot window" | `offscale` clamps to one y-span beyond the limits, so curves exit the frame; seen in the frames | confirmed |
| A5 | "$f$ is broken at each of its poles (Cases 01–03, 14 and 24–26)" | 01–03, 14: NaN inserted at the listed poles; 24–26: grid contains x=0.0, gamma(0.0)=Inf→NaN; no spanning segment in frames | confirmed (24–26 by grid coincidence, see §1) |
| A6 | Source link `lagnewt_animations_all.jl` | file exists; produces all 29 GIFs byte-identically (manifest) | confirmed |
| C01 | heading $1/(1-x)$, [−1.5, 0.9]; alt: window [−1.6, 1.5], includes pole at 1, "beyond the pole f ≤ −2, below the window" | row 01; ylims (−1.646, 11.25); f(1.5) = −2, so f ≤ −2 on (1, 1.5], which is below −1.646; GIF title matches; archive anim 01 nodes [−1.5, 0.9] | confirmed |
| C02 | $1/(1+x)$, [−0.9, 1.5]; window [−1.5, 1.6], pole −1, f ≤ −2 below window | row 02; same ylims (−1.646, …) | confirmed |
| C03 | $1/(1-x)^2$, [−1.5, 0.9]; window [−1.6, 1.5] incl. pole at 1 | row 03; frames show both branches | confirmed |
| C04 | $\sqrt x$, [0, 2]; f on [0, 10.5] | row 04; archive text "[0, 2]" | confirmed |
| C05 | $\sqrt x$, [0, 8]; f on [0, 10.5] | row 05 | confirmed |
| C06 | $\sqrt x$, [0, 10]; f on [0, 10.5] | row 06 | confirmed |
| C07 | $1/\sqrt{1-x}$, [−1.5, 0.95]; window [−1.6, 1.5], f for x<1 | row 07; archive Ex 6 [−1.5, 0.95] | confirmed |
| C08 | $1/(1+10x^2)$, [−1, 1]; f on [−1.5, 1.5] | row 08; archive text [−1, 1] | confirmed |
| C09 | $\ln x$, [0.02, 2]; window [−0.5, 4.1], f for x>0 | row 09 | confirmed |
| C10 | $\ln x$, [0.02, 4]; same window | row 10 | confirmed |
| C11 | $\ln(1+x)$, [−0.98, 1]; window [−1.5, 1.5], f for x>−1 | row 11 | confirmed |
| C12 | $\sin x$, [−3π, 3π]; degrees 1, 2, 3 show y=0 (nodes multiples of π) | auto span = ±9.42477796 = ±3π; nodes {±3π}, {±3π, 0}, {±3π, ±π}; frames show the flat line | confirmed |
| C13 | $\cos x$, [−3π, 3π]; degrees 1 and 3 show y=−1 (odd multiples of π) | nodes {±3π}, {±3π, ±π}; frames | confirmed |
| C14 | $\tan x$, [−1.45, 1.45]; f on [−π, π] broken at ±π/2; degrees 1 and 2 same line | row 14; n=3 coefficients (0, 5.68, 0) = n=2 line; frames; archive Ex 11 | confirmed |
| C15 | $e^x$, [−2, 3] | auto span = window | confirmed |
| C16 | $e^{-x}\cos x$, [−2, 4] | auto span | confirmed |
| C17 | $\cosh x$, [−4, 4] | auto span | confirmed |
| C18 | $\arctan x$, [−2, 2]; f on [−2.2, 2.2]; degrees 1 and 2 same line | row 18; n=3 c2=0; archive Ex 13 | confirmed |
| C19 | $\arcsin x$, [−1, 1]; window [−1.5, 1.5], f on [−1, 1]; degrees 1 and 2 same line | row 19; n=3 c2=0; archive Ex 14 | confirmed |
| C20 | $J_0$, [−10, 10]; f on [−10.2, 10.2] | row 20; archive Ex 15 | confirmed |
| C21 | $J_1$, [−10.2, 10.2]; degrees 1 and 2 same line | auto span (−10.2, 10.2); n=3 c2=0 | confirmed |
| C22 | $e^{-x^2/2}/\sqrt{2\pi}$, [−3, 3] | auto span; node values match mpmath to 6e-17 | confirmed |
| C23 | $\tfrac12(1+\mathrm{erf}(x/\sqrt2))$, [−3, 3]; middle node (0, ½) on end-node line | n=3 c2 ≈ 0, c0 = 0.5 | confirmed |
| C24 | $\Gamma$, [0.05, 2]; f on [−0.2, 5.2] | row 24; archive text | confirmed |
| C25 | $\Gamma$, [0.05, 4] | row 25 | confirmed |
| C26 | $\Gamma$, [0.5, 5] | row 26 | confirmed |
| C27 | $Y_0$, [0.5, 20]; f on [0, 22] | row 27; archive text | confirmed |
| C28 | $Y_0$, [0.5, 10] | row 28 | confirmed |
| C29 | $Y_0$, [0.5, 4] | row 29 | confirmed |
| W  | Each `lagnewtNN.gif` embed is case NN | GIF titles "Interpolation Case NN: f(x) = …" match the headings in all 29 contact sheets | confirmed |

### 3. Implementation checks (`lagnewt_animations_all.jl`)

**It is the method it claims to be.** The script runs polynomial interpolation through equally spaced nodes. It evaluates in the first barycentric form (modified Lagrange formula) with correct weights $w_j = 1/\prod_{k\ne j}(x_j-x_k)$, and returns $y_j$ exactly at a node. This is the Lagrange interpolant, and the page names the variant (first form) correctly.

**The numbers are right.** `review/dump.jl` is an instrumented copy with plotting removed. It wrote every node set and all 1000 interpolant samples for each of the 290 frames. `review/check.py` then:
- rebuilt the nodes with `np.linspace(a, b, n)` and matched them to 1e-14 for all 290 sets;
- compared node values with 60-digit mpmath values of each f (worst relative error 3e-16);
- compared the script's interpolant with an independent mpmath evaluation of the classical Lagrange formula on the same float data, wherever the curve is on screen. The worst error as a fraction of the y-window, by case: 01 1.2e-13, 04 3.7e-11, 05 3.0e-11, 26 4.9e-12, 28 1.6e-10, 29 2.0e-9, all others ≤ 2e-12.

The property checks also pass. The interpolant reproduces the data at the nodes because the node shortcut is exact. The parity of the coefficients, from `review/parity.py`, matches the symmetry of f in all 11 symmetric cases.

**Its reference values are right.** The magenta f curve was compared with mpmath at every finite sample in all 29 cases, with a worst relative error of 4.1e-16. Γ, J₀, J₁, Y₀, erf and the normal density are all the functions the headings name.

**The picture shows what was computed.** I looked at the contact sheets of all 29 GIFs, at full size for 01–05, 07, 09, 12–14, 19, 24 and 29. Nodes are drawn at (x_i, f(x_i)). The y-limits contain every node value of every frame, from the dump. Off-scale clamping goes to one y-span beyond the limits, so no curve runs along an edge. The near-vertical blue line at x ≈ 18.17 in Case 28, degree 9, is a real zero crossing of a steep polynomial (−0.90 → +1.52 between adjacent samples), not an artefact. f is broken at the poles as A5 describes. The y-limits of Cases 01 and 02 (−1.646, 11.25) put the branch beyond the pole below the window, as the alt text says. The committed GIFs are byte-identical to a fresh scratch run (manifest).

Not determined: the node intervals Mathews used in the animations for Cases 02, 03, 12, 13, 15–17 and 21. His animation text gives none, and the GIFs are missing from the archive. The page's choices are consistent with the archive windows and static examples, so I report nothing there.

