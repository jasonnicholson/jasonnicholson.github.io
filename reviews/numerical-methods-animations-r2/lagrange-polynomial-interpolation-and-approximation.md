# Lagrange Polynomial Interpolation and Approximation — animation review (round 2)

Page: `pages/numerical-methods/lagrange-polynomial-interpolation-and-approximation/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1. Page match, Minor: Case 19 is listed as a case where "f is drawn on a wider interval", and several alt texts say f is drawn on the whole window where f is undefined on part of it

- **Location:** `index.qmd` line 21: "Where $f$ is drawn on a wider interval than $[a, b]$ (Cases 04–06, 08–11, 14, 19 and 24–29), the curve beyond the nodes is extrapolation." Alt texts at line 107 (Case 19: "drawn with f on [−1.5, 1.5]"), and also line 63 / 67 (Cases 09, 10: "drawn with f on [−0.5, 4.1]") and line 71 (Case 11: "drawn with f on [−1.5, 1.5]").
- **What is there now:** these sentences say that f itself is drawn over the full plot window.
- **What is true:** for Case 19, $f(x)=\arcsin x$ is defined only on $[-1,1]$, which is exactly the node interval. `safe_eval` turns the `DomainError` into `NaN`, so the magenta f curve is drawn only on $[-1,1]$. Only the interpolant is drawn on the rest of the window $[-1.5,1.5]$. So f is **not** drawn on an interval wider than $[a,b]$ in Case 19, and the alt text is wrong. In the same way, ln x (Cases 09 and 10) is drawn only on $(0, 4.1]$, not on $[-0.5, 4.1]$, and ln(1+x) (Case 11) only on $(-1, 1.5]$. For 09–11 f really does extend beyond the nodes, so line 21 is right for them; only the alt-text interval is overstated.
- **How I know:** the frames. In `committed/lagnewt19/sheet.png`, every frame shows the magenta curve ending at the nodes at x = ±1 while the blue interpolant continues to the window edges. In `review/grid_last_01.png` and `review/grid_last_11.png` (last frames of 09, 10 and 11), the magenta curve starts at x ≈ 0 and x ≈ −1. In the code, `safe_eval` (script lines 56–63) returns `NaN` for non-finite values or a thrown error, and `ytrue_clip` keeps those NaN values (line 182).
- **Suggested correction:** drop 19 from the list on line 21 and say instead that in Case 19 only the interpolant is drawn beyond $[-1,1]$, because arcsin is undefined there. Change the Case 19 alt text to "drawn with f on [−1, 1] (its whole domain) in a window [−1.5, 1.5]". Optionally, phrase the 09–11 alt texts as "in a window [−0.5, 4.1]" or "[−1.5, 1.5]" instead of "f on …".

No other findings.

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `lagnewt_animations_all.jl` | 0 | 28.7 | 29 GIFs (lagnewt01.gif … lagnewt29.gif) | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Page claim (page's own words) | Evidence | Verdict |
|---|---|---|---|
| D1 | "Lagrange interpolation builds a unique polynomial of degree at most $n$ through $n+1$ data points." | Standard result. The script uses n+1 = 2…16 nodes. | Confirmed |
| D2 | "The animations evaluate it in the first barycentric form, $P_n(x)=\ell(x)\sum w_i y_i/(x-x_i)$ with $\ell(x)=\prod(x-x_j)$ and $w_i=1/\prod_{j\ne i}(x_i-x_j)$." | `barycentric_weights` (lines 101–111) computes exactly that $w$. `barycentric_eval` (lines 113–130) returns `l * s` with `s=Σ w_j y_j/(x-x_j)` and `l=Π(x-x_j)`, and returns $y_j$ exactly at nodes. | Confirmed |
| D3 | "This is the same interpolant" | High-precision Newton divided-difference evaluation (mpmath, 80 digits) on the script's own float nodes and values, at all 1000 plot points of all 290 frames: largest relative difference 6.6e-8 (at a near-zero value of Case 29, degree 15). Everywhere else it is far smaller. | Confirmed |
| D4 | "…it stays accurate far outside the nodes" | Same check: the first form keeps ≤ 6.6e-8 relative error, and the sign is never wrong (0 sign mismatches at any point with \|P\|>1e-8), including at x = 10.5 for nodes on [0,2] (Case 04) and at x = 22 for nodes on [0.5,4] (Case 29). | Confirmed |
| D5 | "…where the second barycentric form (a ratio of two such sums) gives values of the wrong sign in Cases 04 and 29." | `review/dump.jl` evaluates the second form `num/den` on the same grids. Its sign differs from the (verified-correct) first form in Case 04 at n=14 (4 points) and n=16 (1 point), and in Case 29 at n=14 (2 points) and n=16 (151 of 1000 points). No other case has any sign disagreement. | Confirmed |
| D6 | Formula $P_n(x)=\sum y_i L_i(x)$, $L_i=\prod_{j\ne i}(x-x_j)/(x_i-x_j)$ | The standard Lagrange form, algebraically equal to D2. | Confirmed |
| D7 | "The 29 animations below follow the legacy Mathews case ordering." | Legacy `Lagrange.html` case list 1–29 (formula images montaged in `review/legacy_formulas.png`) matches the page's order and functions row by row. | Confirmed |
| D8 | "the nodes are equally spaced from $a$ to $b$, endpoints included" | `equal_nodes` falls back to trimming only if f is non-finite at a node. The instrumented run printed no `TRIM` line for any case or n. Python: largest deviation of any node from $a+(b-a)i/(n-1)$ is 1.4e-16. | Confirmed |
| D9 | "Where f is drawn on a wider interval than [a, b] (Cases 04–06, 08–11, 14, 19 and 24–29), the curve beyond the nodes is extrapolation." | Cases where xlims ≠ node span in the table: exactly 04, 05, 06, 08, 09, 10, 11, 14, 19, 24–29, so the list is complete. But in Case 19 f is not drawn beyond [−1,1] (see F1). | Wrong for Case 19 (F1, Minor); confirmed for the others |
| A1 | "raises the polynomial degree through 1, 2, 3, 4, 5, 7, 9, 11, 13 and 15 (2, 3, 4, 5, 6, 8, 10, 12, 14 and 16 nodes)" | `n_nodes_seq = [2,3,4,5,6,8,10,12,14,16]`. The title prints `n_nodes - 1`. All GIFs have 10 frames (manifest). Titles read in sheets 01, 04, 12, 13, 14, 19, 24, 29 show degrees 1,2,3,4,5,7,9,11,13,15, and the last frames of all other cases read "degree 15". | Confirmed |
| A2 | "for a fixed function and node interval" | Per case, f and span are fixed across frames. | Confirmed |
| A3 | "Where a curve leaves the plot window, it is drawn along the window's top or bottom edge." | `clamp.(yinterp, ylims...)` (line 192) and `ytrue_clip` (line 182). Visible, for example, in Case 04 degree 5+ (top edge) and Case 24 degree 5+ (bottom edge). | Confirmed |
| A4 | Source link `lagnewt_animations_all.jl` | File exists beside index.qmd. It is the only script, and the manifest regenerates all 29 GIFs byte-identically from it. | Confirmed |
| C01 | Case 01: f = 1/(1−x), nodes on [−1.6, 0.9]; alt "drawn with f on the same interval" | Row: f `1/(1-x)`, xlims (−1.6, 0.9), span (−1.6, 0.9). GIF title "f(x) = 1/(1-x)". Legacy: same function, window −1.6..1.5, and the legacy GIF shows nodes on [−1.6, 0.9]. | Confirmed |
| C02 | Case 02: 1/(1+x), [−0.9, 1.6], same interval | Row matches. Title matches. Legacy function matches (window −1.5..1.6). | Confirmed |
| C03 | Case 03: 1/(1−x)², [−1.6, 0.9], same interval | Row matches. Title "1/(1-x)^2". | Confirmed |
| C04 | Case 04: √x, nodes [0, 2], f on [0, 10.5] | Row: xlims (0, 10.5), span (0, 2). Legacy "equally spaced nodes in [0, 2]", window 0..10.5. | Confirmed |
| C05 | Case 05: √x, [0, 8], f on [0, 10.5] | Row matches. Legacy [0, 8]. | Confirmed |
| C06 | Case 06: √x, [0, 10], f on [0, 10.5] | Row matches. Legacy [0, 10]. | Confirmed |
| C07 | Case 07: 1/√(1−x), [−1.6, 0.9], same interval | Row matches. Title "1/sqrt(1-x)". | Confirmed |
| C08 | Case 08: 1/(1+10x²), nodes [−1, 1], f on [−1.5, 1.5] | Row matches. Legacy nodes [−1, 1], window ±1.5. | Confirmed |
| C09 | Case 09: ln x, nodes [0.02, 2], "f on [−0.5, 4.1]" | Row matches (window −0.5..4.1, legacy same). f is drawn only for x > 0. | Nodes and title confirmed; alt-text f interval overstated (F1) |
| C10 | Case 10: ln x, [0.02, 4], "f on [−0.5, 4.1]" | As for C09. | As for C09 (F1) |
| C11 | Case 11: ln(1+x), [−0.98, 1], "f on [−1.5, 1.5]" | Row matches. Legacy [−0.98, 1]. f is drawn only for x > −1. | Nodes and title confirmed; alt-text f interval overstated (F1) |
| C12 | Case 12: sin x, [−3π, 3π], same interval | auto_span. Finite support = full window, so span = (−3π, 3π). | Confirmed |
| C12b | "With 2, 3 and 4 nodes every node is a multiple of π, where sin x = 0, so the frames titled degree 1, 2 and 3 all show the line y = 0." (also in alt) | Nodes {±3π}, {−3π, 0, 3π}, {±π, ±3π}. Interpolant on the grid lies within ±3.7e-16. Frames 1–3 show a flat line at 0. | Confirmed |
| C13 | Case 13: cos x, [−3π, 3π], same interval | Row matches. | Confirmed |
| C13b | "With 2 and 4 nodes every node is an odd multiple of π, where cos x = −1, so the frames titled degree 1 and 3 show the line y = −1." | Nodes {±3π}, {±π, ±3π}. Interpolant in [−1.0000000000000004, −0.99999999999999944]. Frames 1 and 3 are flat at −1. | Confirmed |
| C14 | Case 14: tan x, nodes [−3, 3], f on [−π, π] | Row: xlims (−π, π), span (−3, 3). Title "tan(x)". Legacy window −π..π. The legacy node interval cannot be determined because the legacy GIF `Lagrangenn.gif` is not in the archive. | Confirmed (legacy node span: could not determine) |
| C15 | Case 15: eˣ, [−2, 3], same | Row matches. | Confirmed |
| C16 | Case 16: e^{−x}cos x, [−2, 4], same | Row `cos(x)*exp(-x)` on (−2, 4). | Confirmed |
| C17 | Case 17: cosh x, [−4, 4], same | Row matches. | Confirmed |
| C18 | Case 18: arctan x, [−2.2, 2.2], same | Row matches. | Confirmed |
| C19 | Case 19: arcsin x, nodes [−1, 1], "drawn with f on [−1.5, 1.5]" | Row: xlims (−1.5, 1.5), span (−1, 1). Legacy window ±1.5. f is drawn only on [−1, 1]. | Nodes and title confirmed; alt text wrong (F1) |
| C20 | Case 20: J₀, [−10.2, 10.2], same | Row matches. | Confirmed |
| C21 | Case 21: J₁, [−10.2, 10.2], same | Row matches. | Confirmed |
| C22 | Case 22: e^{−x²/2}/√(2π), [−3, 3], same | Row matches. Title "normal_pdf(x)". | Confirmed |
| C23 | Case 23: ½(1+erf(x/√2)), [−3, 3], same | Row `0.5 + 0.5*erf(x/sqrt(2))`. | Confirmed |
| C24 | Case 24: Γ, nodes [0.05, 2], f on [−0.2, 5.2] | Row matches. Legacy "[0.05, 2]", window −0.2..5.2. | Confirmed |
| C25 | Case 25: Γ, [0.05, 4], f on [−0.2, 5.2] | Row matches. Legacy matches. | Confirmed |
| C26 | Case 26: Γ, [0.5, 5], f on [−0.2, 5.2] | Row matches. Legacy matches. | Confirmed |
| C27 | Case 27: Y₀, [0.5, 20], f on [0, 22] | Row matches. Legacy matches. (Y₀ is undefined at x = 0, a single point; not material.) | Confirmed |
| C28 | Case 28: Y₀, [0.5, 10], f on [0, 22] | Row matches. Legacy matches. | Confirmed |
| C29 | Case 29: Y₀, [0.5, 4], f on [0, 22] | Row matches. Legacy matches. | Confirmed |
| W | Embeds: Case NN → `lagnewtNN.gif` | `out_name = "lagnewt$(case.id).gif"`. The page embeds lagnewt01…29 under the matching headings. All committed GIFs are byte-identical to a fresh run (manifest), and the GIF titles carry the case id. | Confirmed |

---

### 3. Implementation checks (`lagnewt_animations_all.jl`)

**Method.** This is Lagrange polynomial interpolation on equally spaced nodes, evaluated through the first barycentric (modified Lagrange) form with weights $w_j = 1/\prod_{k\ne j}(x_j-x_k)$. That is the interpolant the Description names, and the page states the variant explicitly. Nothing beyond interpolation is involved: no node trimming happened in any case, and no other approximation is used.

**Numbers.**
- Instrumented copy: `review/lib.jl` (script lines 1–212, without the render loop) plus `review/dump.jl`. It wrote every node (x, y) and every plotted interpolant value for all 29 cases × 10 degrees to `review/dump.tsv`. Run: `cd review && julia dump.jl`.
- Independent check: `review/check.py` (run with `/usr/bin/python3 -I check.py <review dir>`).
  - Node x against $a+(b-a)i/(n-1)$ from the page headings: largest deviation 1.44e-16.
  - Node y against mpmath f (80 digits, including besselj/bessely/gamma/erf): largest relative deviation 6.6e-15.
  - Interpolant: Newton divided differences in 80-digit arithmetic on the script's own float data, compared at all 290,000 plotted points. Largest relative error 6.64e-8 (Case 29, n=16, x ≈ 4.845, script 0.0057215253 against exact 0.0057215249). All cases other than 28 and 29 at n ≥ 14 stay below 1e-9. There are 0 sign errors.
- Interpolation property: `barycentric_eval` returns $y_j$ exactly when $|x-x_j|\le10^{-12}$, and the high-precision Newton form also reproduces the data by construction. The node markers in every viewed frame sit on both curves.

**Reference values.** The "true" curve is f evaluated with Julia `Base`/SpecialFunctions. Node values agree with mpmath to 6.6e-15 relative, as above, which covers J₀, J₁, Y₀, Γ and erf. Non-finite values and domain errors become NaN, so f is not drawn where it is undefined (this is the source of F1's wording issue, not a computational error).

**Picture.**
- Viewed the contact sheets for 01, 04, 12, 13, 14, 19, 24 and 29, and the last frames of all other cases (`review/grid_last_01.png`, `grid_last_11.png`, `grid_last_25.png`).
- Titles read "Interpolation Case NN: f(x) = <label>, degree d". The label matches the case's function in every row, and d = number of nodes − 1.
- Red nodes lie on f. The blue interpolant passes through every node.
- y-limits come from the 3rd–97th percentile of f, widened to include every node value of every frame, so no node is ever off-screen.
- Clamping to the window edge is disclosed on the page (A3). It does not hide anything the page discusses: the only behavioural statements (Cases 12 and 13) concern flat lines well inside the window.
- At the poles of tan (Case 14) and Γ (Cases 24–26), the clamped f produces near-vertical lines that read as asymptotes. This is not misleading.
- Second-form remark: the script's own comment (lines 120–122) and the page's D5 are supported by the sign-disagreement counts above.

**Legacy fidelity (not findings).**
- Functions, windows and node intervals agree with the legacy list for all 29 cases. The node interval for Case 14 could not be checked because the legacy GIF is missing. The script comment gives a reason for [−3, 3]: equally spaced nodes on [−π, π] with 5 nodes would hit ±π/2, which is true.
- The legacy animations ran to higher degrees (S₂₅ in case 1, S₁₉ in case 4) and shaded a ±0.05 "convergence region". The page stops at degree 15 and has no tolerance band. These are content omissions, not wrong content, so I did not report them.

