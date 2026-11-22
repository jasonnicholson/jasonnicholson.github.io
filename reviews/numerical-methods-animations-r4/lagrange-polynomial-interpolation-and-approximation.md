# Lagrange Polynomial Interpolation and Approximation — animation review (round 4)

Page: `pages/numerical-methods/lagrange-polynomial-interpolation-and-approximation/`. Reported findings: **0 Error, 0 Misleading, 2 Minor**.

## Findings

### F1. Page match, Minor: unexplained identical "degree 1" and "degree 2" frames in Cases 14, 18, 19, 21 and 23

- **Where:** `index.qmd` line 25 says "Each animation raises the polynomial degree through 1, 2, 3, …". The GIF titles read "…, degree $(n_nodes - 1)" (script line 216). Cases 12 and 13 get an explanatory note at lines 75 and 81. Cases 14, 18, 19, 21 and 23 get none.
- **What is there now:** f is odd about the centre of the node interval in these cases. That holds for tan, arctan and arcsin, for J₁, and for Φ(x) − ½. With 3 equally spaced nodes the middle node lies on the line through the two end nodes, so the interpolant in the frame titled "degree 2" is the same straight line as in the frame titled "degree 1". A viewer sees the degree go up and nothing change.
- **Evidence:** `degree.py` compares the interpolant arrays for 2 and 3 nodes and prints max|P(2 nodes) − P(3 nodes)|:

  | Case | max difference |
  |---|---|
  | 14 | 5.6e-17 |
  | 18 | 4.4e-16 |
  | 19 | 8.9e-16 |
  | 21 | 2.6e-18 |
  | 23 | 3.3e-16 |

  For comparison, the same difference is between 0.18 and 160 in every non-symmetric case. The contact sheets show it too: frames 1 and 2 of `lagnewt14`, `18`, `19`, `21` and `23` are the same picture apart from the title.

  The same symmetry lowers the true degree of many other frames, for example every odd-titled frame of the even-function Cases 08, 13, 17, 20 and 22. Those frames still differ from their neighbours, though, and the Description's "degree at most n" covers them.
- **Correction:** Add a one-line note to Cases 14, 18, 19, 21 and 23 like the one in Cases 12 and 13. For example: "f is odd about the centre of the nodes, so the middle node of three lies on the degree-1 line and the frame titled degree 2 shows the same line." Alternatively, add one sentence near line 25 saying that frame titles give the nominal degree n, and that for symmetric f on symmetric nodes the interpolant can have lower degree.

- **Independent check:** not run (Minor finding, unverified)

### F2. Fidelity, Minor: Case 14 nodes depart from the archive's tan x example without a stated reason

- **Where:** `index.qmd` line 85, "Case 14: $f(x)=\tan x$, nodes on $[-3, 3]$". Script lines 45–47.
- **What is there now:** The nodes are on [−3, 3], so they straddle both poles of tan x at ±π/2. The only stated reason is a script comment: 5 equally spaced nodes on [−π, π] would land on the poles. Nothing on the page explains the choice.
- **What the archive has:** The a2001 index gives only the plot window for animation 14, −π ≤ x ≤ π. No GIF for animation 14 is archived. The static example that `LagrangePolyMod_lnk_23.html` links to animation 14 (code image `LagrangePolyMod_gr_444.gif`) uses `aa = -1.45; bb = 1.45` with window [−π, π] × [−10, 10]. In that example the nodes stay on the central branch between the poles, and the point is how the interpolant behaves beyond them. The page's [−3, 3] makes the polynomial pass through nodes on three separate branches, which is a different demonstration.

  For Case 07 the script itself took its nodes from the linked static example ("07 as in his static example linked to animation 7", line 29). I confirmed that example: `LagrangePolyMod_gr_379.gif` has `aa=-1.5, bb=0.95`, which matches the page. Case 14 does not follow that rule, and the comment argues against [−π, π], which the archive's example does not use.
- **Uncertainty:** I could not determine which nodes animation 14 actually used, because its GIF is not in the archive. This finding rests on the linked static example only.
- **Correction:** Either use nodes on [−1.45, 1.45], as in Mathews' linked example, or keep [−3, 3] and add one sentence to the Case 14 text saying the nodes deliberately straddle the poles and why.

No other findings. Everything below was checked and passed.

---

- **Independent check:** not run (Minor finding, unverified)


## Reviewer's notes (not findings)


**Count: 0 Error, 0 Misleading, 2 Minor.**



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `lagnewt_animations_all.jl` | 0 | 33.4 | 29 GIFs (lagnewt01.gif … lagnewt29.gif) | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Claim (page wording) | Evidence | Verdict |
|---|---|---|---|
| D1 | "builds a unique polynomial of degree at most $n$ through $n+1$ data points" | Standard result; the n-node interpolants were checked against an independent Lagrange-form evaluation (I1) | confirmed |
| D2 | Animations evaluate "the first barycentric form, $P_n(x)=\ell(x)\sum w_i y_i/(x-x_i)$, $\ell=\prod(x-x_j)$, $w_i=1/\prod_{j\ne i}(x_i-x_j)$" | Script lines 110–119 compute the weights and lines 132–138 compute `l*s` exactly so; nodes are snapped within 1e-12 (lines 123–127) | confirmed |
| D3 | "This is the same interpolant" | 290 case/degree pairs agree with a 60-digit Lagrange-form evaluation, with max normalised error 4.4e-9 (Case 29, 16 nodes) | confirmed |
| D4 | "it stays accurate far outside the nodes" | Same check over the full plot window, including extrapolation out to 22 for nodes on [0.5, 4] | confirmed |
| D5 | "the second barycentric form … gives values of the wrong sign in Cases 04 and 29" | `check.py` evaluates the second form in float64 on the script's nodes. Wrong sign at 213 and 94 grid points in Case 04 at degrees 13 and 15, and at 55 and 375 points in Case 29 at degrees 13 and 15. All are visible within the window. No wrong-sign points occur in any other case. | confirmed |
| D6 | Lagrange formula $P_n=\sum y_iL_i$, $L_i=\prod_{j\ne i}(x-x_j)/(x_i-x_j)$ | Standard; it is the reference used in `check.py` | confirmed |
| D7 | "The 29 animations below follow the legacy Mathews case ordering" | Archive formula images 1–29 (`mathews_formulas.png`) give the same functions in the same order | confirmed |
| D8 | "nodes are equally spaced from $a$ to $b$, endpoints included" | `dump.tsv`: for all 290 node sets, the first node equals a, the last equals b, and the node-trimming fallback (script lines 94–106) never triggers. My independent linspace matches to 8.9e-16. | confirmed |
| D9 | "Where the plot window is wider than [a, b] (Cases 01–11, 14, 19 and 24–29)" | `dump.tsv` CASE rows: those cases have span strictly inside xlims, and Cases 12, 13, 15–18 and 20–23 have span = xlims | confirmed |
| D10 | "In Case 19, arcsin x is undefined outside [-1, 1], so there only the interpolant is drawn" | `safe_eval` turns DomainError into NaN; frames show f only on [−1, 1] | confirmed |
| A1 | "raises the polynomial degree through 1, 2, 3, 4, 5, 7, 9, 11, 13 and 15 (2 … 16 nodes)" | `n_nodes_seq` (line 167); 10 frames per GIF (manifest); titles read degree 1…15 | confirmed (nominal degree; see F1) |
| A2 | "Where a curve leaves the plot window, it is drawn along the window's top or bottom edge" | Lines 194 and 211 clamp f and the interpolant; visible in the frames (e.g. Case 04, 09, 24) | confirmed |
| A3 | "except $f$ in Cases 01–03 and 14, which runs off the window and is broken at each of its poles" | `poles` is set only for 01, 02, 03 and 14; lines 196–201 add a NaN at each pole and leave f unclamped; frames show the breaks | confirmed |
| A4 | Single source link `lagnewt_animations_all.jl` | File exists and produces all 29 GIFs byte-identically (manifest) | confirmed |
| C01 | Heading: f = 1/(1−x), nodes [−1.5, 0.9]; alt: window [−1.6, 1.5], pole x = 1, "beyond the pole f ≤ −2, below the window" | Script row 32. f(1.5) = −2 and f is decreasing beyond the pole; window y-min = −1.646 (dump), so −2 is below it. Title "f(x) = 1/(1-x)". Archive animation 1 GIF: nodes from −1.5 to 0.9, window −1.6…1.5. | confirmed |
| C02 | 1/(1+x), nodes [−0.9, 1.5]; window [−1.5, 1.6]; pole −1; f ≤ −2 beyond the pole, below the window | Row 33; f(−1.5) = −2, y-min −1.646; archive window −1.5…1.6 | confirmed |
| C03 | 1/(1−x)², nodes [−1.5, 0.9]; window [−1.6, 1.5] including pole x = 1 | Row 34; frames show f broken at 1 | confirmed |
| C04 | √x, nodes [0, 2], f on [0, 10.5] | Row 35; archive "[0, 2]", window 0…10.5 | confirmed |
| C05 | √x, nodes [0, 8], f on [0, 10.5] | Row 36; archive "[0, 8]" | confirmed |
| C06 | √x, nodes [0, 10], f on [0, 10.5] | Row 37; archive "[0, 10]" | confirmed |
| C07 | 1/√(1−x), nodes [−1.5, 0.95]; window [−1.6, 1.5]; f drawn for x < 1 | Row 38; archive static example aa = −1.5, bb = 0.95; f(x ≥ 1) is NaN | confirmed |
| C08 | 1/(1+10x²), nodes [−1, 1], f on [−1.5, 1.5] | Row 39; archive "[−1, 1]" | confirmed |
| C09 | ln x, nodes [0.02, 2]; window [−0.5, 4.1]; f for x > 0 | Row 40; archive "[0.02, 2]" | confirmed |
| C10 | ln x, nodes [0.02, 4]; window [−0.5, 4.1] | Row 41; archive "[0.02, 4]" | confirmed |
| C11 | ln(1+x), nodes [−0.98, 1]; window [−1.5, 1.5]; f for x > −1 | Row 42; archive "[−0.98, 1]" | confirmed |
| C12a | sin x, nodes [−3π, 3π], f on the same interval | Row 43 (auto span = xlims = ±3π exactly) | confirmed |
| C12b | "With 2, 3 and 4 nodes every node is a multiple of π … frames titled degree 1, 2 and 3 all show the line y = 0" | Nodes/π = {±3}, {−3, 0, 3}, {±3, ±1}; interpolant max abs 3.7e-16 | confirmed |
| C13a | cos x, nodes [−3π, 3π] | Row 44 | confirmed |
| C13b | "With 2 and 4 nodes every node is an odd multiple of π … degree 1 and 3 show the line y = −1" | Interpolant in [−1.0000000000000004, −0.9999999999999994] | confirmed |
| C14 | tan x, nodes [−3, 3]; f on [−π, π], broken at ±π/2 | Row 47; frames show it | confirmed as a description; departure from the archive in F2 |
| C15 | eˣ, nodes [−2, 3] | Row 48; archive static example a = −2, b = 3 | confirmed |
| C16 | e^{−x} cos x, nodes [−2, 4] | Row 49; title "cos(x)*exp(-x)" | confirmed |
| C17 | cosh x, nodes [−4, 4] | Row 50 | confirmed |
| C18 | arctan x, nodes [−2.2, 2.2] | Row 51; archive window −2.2…2.2 (the linked static example uses [−2, 2]; the archive does not say which nodes the animation used) | confirmed against the script; archive nodes could not be determined |
| C19 | arcsin x, nodes [−1, 1], window [−1.5, 1.5], f on [−1, 1] | Row 52; archive static example aa = −1, bb = 1 | confirmed |
| C20 | J₀, nodes [−10.2, 10.2] | Row 53 (auto); archive window ±10.2 (the static example uses nodes ±10; the animation's nodes are not stated) | confirmed against the script; archive nodes could not be determined |
| C21 | J₁, nodes [−10.2, 10.2] | Row 54 | confirmed |
| C22 | e^{−x²/2}/√(2π), nodes [−3, 3] | Row 55; archive static example aa = −3, bb = 3 | confirmed |
| C23 | ½(1+erf(x/√2)), nodes [−3, 3] | Row 56; archive static example ±3 | confirmed |
| C24 | Γ(x), nodes [0.05, 2], f on [−0.2, 5.2] | Row 57; archive "[0.05, 2]", window −0.2…5.2 | confirmed |
| C25 | Γ(x), nodes [0.05, 4] | Row 58; archive "[0.05, 4]" | confirmed |
| C26 | Γ(x), nodes [0.5, 5] | Row 59; archive "[0.5, 5]" | confirmed |
| C27 | Y₀, nodes [0.5, 20], f on [0, 22] | Row 60; archive "[0.5, 20]", window 0…22 | confirmed |
| C28 | Y₀, nodes [0.5, 10] | Row 61; archive "[0.5, 10]" | confirmed |
| C29 | Y₀, nodes [0.5, 4] | Row 62; archive "[0.5, 4]" | confirmed |
| W | Each heading's embed `lagnewtNN.gif` is that case | All 29 contact sheets read "Interpolation Case NN: f(x) = <same function>" | confirmed |
| Alt-all | Each alt text says "degree rising from 1 to 15" | Titles go 1, 2, 3, 4, 5, 7, 9, 11, 13, 15 | confirmed |

---

### 3. Implementation checks: `lagnewt_animations_all.jl`

**It is the method claimed.** The script builds the polynomial interpolant through equally spaced nodes and evaluates it in the first barycentric form. This is the Lagrange interpolant written differently, and the Description says so (D2). It is not a least-squares fit, a spline or Chebyshev-node interpolation.

**The numbers are right.**
- **Nodes:** My mpmath linspace on each case's [a, b] agrees with the script's nodes to at most 8.9e-16 (Case 12, from the π rounding). The script's node values, from Base, SpecialFunctions `gamma`, `besselj`, `bessely` and `erf`, agree with mpmath to a relative 8.5e-16 at most.
- **Interpolant:** For all 29 cases × 10 degrees = 290 interpolants, I evaluated the explicit Lagrange form at 60 digits through the script's float data. I used all 1000 plot points, including extrapolation. Max |P_script − P_ref| / max(1, |P_ref|) = 4.4e-9 (Case 29, degree 15, where |P| reaches about 1e8 at x = 22). Typical values are 1e-16 to 1e-11.
- **Interpolation property:** `barycentric_eval` returns y_j exactly when |x − x_j| ≤ 1e-12. Away from the nodes, the agreement above shows the curve passes through them.
- **Node trimming:** The fallback that moves nodes inside the interval never fires (D8).

**Reference values are right.** The "true" curve is f evaluated directly. The library values match mpmath to about 1e-16 at the nodes. Singular and undefined points become NaN through `safe_eval`. Γ at the exact grid point x = 0 returns Inf, which becomes NaN, so the Γ curve is broken at its pole rather than joined by a vertical segment.

**The picture shows what was computed.** I viewed all 29 contact sheets, which show all 10 frames per GIF.
- Titles: each shows the right function label and degree (n_nodes − 1).
- Nodes: red dots sit on f, and all are inside the y-window by construction (lines 184–193).
- y-limits: these come from robust quantiles of f, on the node interval for the pole cases and on the window otherwise, extended by the node values.
- Pole cases 01–03 and 14: f is broken at each pole and left unclamped, as the page says.
- Clamping: elsewhere both curves are clamped to the window edge, as the page says.
- Case 28, degree 9: the vertical blue segment at x ≈ 18.2 is a real sign change of P₉. `root28.py` gives P₉(18) = −17.0, P₉(18.2) = +2.63, root at 18.1765. The vertical look comes from clamping a polynomial of size about 50 into a window of about ±0.7. It is not a plotting artefact.
- Display devices: none of them hides a feature the page talks about.

**Archive notes (not findings).** Mathews' animation 1 runs to higher degrees (S₂₅) and overlays a "Convergence Regions" ±0.05 tolerance band. The page's animations have neither. That is content the page does not have, not an error.

