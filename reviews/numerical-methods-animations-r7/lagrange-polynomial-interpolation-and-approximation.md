# Lagrange Polynomial Interpolation and Approximation — animation review (round 7)

Page: `pages/numerical-methods/lagrange-polynomial-interpolation-and-approximation/`. Reported findings: **0 Error, 1 Misleading, 2 Minor**.

## Findings

### F3. Implementation, **Misleading**: clamping draws false flat tops on the interpolant between the nodes

- **Added by the review director.** The Newton Interpolation reviewer found this in the script the two pages share. This page's reviewer did not report it. The independent checker tested it on this page separately.
- **Location:** `lagnewt_animations_all.jl:211`, `yinterp = clamp.(yinterp, ylims[1], ylims[2])`. Case 12 frames 5, 6, 7; Case 13 frames 6, 7; Case 20 frames 4, 7; Case 21 frames 5, 6, 7; Case 27 frames 5, 6, 7.
- **What is there now:** where the polynomial overshoots the y-window inside the node interval, its value is replaced by the window limit, so it is drawn as a horizontal segment along the frame. In Case 12, degree 7, the drawn lobes are flat at about ±1.60.
- **What is true instead:** a nonconstant polynomial has no flat stretch. In Case 12, degree 7, the true polynomial reaches ±5.15 on the outer lobes and ±1.671 on the inner lobes.
- **Suggested fix:** break the line where the polynomial leaves the window instead of clamping it, for example by clamping to one y-span beyond the axes as the Padé script does. Apply it to both identical copies of the script, and consider line 194, which clamps `f` the same way.

- **Independent check:** confirmed with correction, by the same independent check as the Newton Interpolation page. Its script is byte-identical, all 29 GIFs have matching frame hashes, and a separate pixel check on this page's committed frames gave the same result. Thirteen frames are affected and 12 are visibly misleading (Case 20 frame 4 overshoots by 0.66 pixel).

### F1. Page match, Minor: the "degree" in the titles and intro is the nominal degree, and for symmetric cases the polynomial drawn has lower degree

- **Location:** `index.qmd` line 25, "Each animation raises the polynomial degree through 1, 2, 3, 4, 5, 7, 9, 11, 13 and 15"; frame titles from `lagnewt_animations_all.jl` line 216 (`degree $(n_nodes - 1)`).
- **What is there:** every frame is titled "degree (nodes − 1)".
- **What is true:** with symmetric nodes, an even or odd $f$ loses the top coefficient whenever its parity disagrees with the nominal degree. Exact degrees, from the leading divided difference at 120 digits on ideal symmetric nodes:

| Cases | Titled degree → actual degree |
|---|---|
| 08, 17, 20, 22 (even $f$) | 1→0, 3→2, 5→4, 7→6, 9→8, 11→10, 13→12, 15→14 |
| 13 ($\cos x$) | 1→0, **3→0**, 5→4, 7→6, 9→8, 11→10, 13→12, 15→14 |
| 14, 18, 19, 21, 23 (odd, or odd about ½) | 2→1, 4→3 |
| 12 ($\sin x$) | 1, 2, 3 → zero polynomial; 4→3 |

  So the frame titled "degree 15" in Cases 08, 13, 17, 20 and 22 shows a degree-14 polynomial. The page explains the degree 1/2 coincidences (Cases 14, 18, 19, 21, 23) and the flat frames of Cases 12 and 13, but says nothing about the horizontal "degree 1" line in Cases 08, 17, 20 and 22, nor about the later frames. The Description's "degree at most $n$" keeps the statement defensible, hence Minor.
- **How I know:** `python3 -I review/check3.py review <page>`, section "true degree of interpolant".
- **Suggested correction:** add to line 25: "The degree in each title is the number of nodes minus one, the most the interpolant can have. When $f$ is even or odd and the nodes are symmetric, the actual degree can be lower: for even $f$ with an even number of nodes it is one less, so the frame titled degree 1 is a horizontal line."

- **Independent check:** not run (Minor finding, unverified)

### F2. Fidelity, Minor: Cases 18 and 20 use wider node intervals than Mathews' worked examples for those animations, with no reason given

- **Location:** `index.qmd` line 103 (`nodes on $[-2.2, 2.2]$`) and line 115 (`nodes on $[-10.2, 10.2]$`), with their alt text; `lagnewt_animations_all.jl` lines 51 and 53 (`auto_span`, so nodes fill the plot window).
- **What is there:** nodes span the whole plot window.
- **What the archive has:** `LagrangePolyMod.nb` Solution 13, linked to Animation 18, sets `aa = -2.0; bb = 2.0` (notebook lines 4357 onward; the module page states the interval as $[-2, 2]$). Solution 15, linked to Animation 20, sets `aa = -10; bb = 10` while plotting on `a = -10.2; b = 10.2` (notebook lines 4527–4546), which is the animation's window. So in Case 20 the window and node interval are visibly distinct in Mathews' own code. The script already follows these worked examples for Cases 07, 14 and 19, where the window is also wider than the nodes.
- **Limits of this evidence:** the animated GIFs for 18 and 20 are not in the archive, so their nodes cannot be read directly. Case 20 is strong evidence (same window). Case 18 is weaker, because the example's plot window ($[-2, 2]$) differs from the animation's ($[-2.2, 2.2]$). Case 21 ($J_1$) has no worked example; its interval **could not be determined**, though $[-10, 10]$ would parallel Case 20.
- **Suggested correction:** use `with_span` with $(-10, 10)$ for Case 20 and $(-2, 2)$ for Case 18, then update the two headings, the alt text and the "window wider than $[a,b]$" list on line 21 (add 18 and 20). The degree 1/2 notes for Case 18 remain true. If the wider intervals are kept deliberately, say so in the script comment.

- **Independent check:** not run (Minor finding, unverified)


## Reviewer's notes (not findings)



#### Archive differences noted but not counted

- Mathews' animations overlay "convergence regions" (a ±0.05 tolerance band) and run to higher degree (S₂₅ in animation 1, S₂₀ in animation 4). The page draws neither and stops at degree 15. This is content the page does not have, so under the review standard it is not a finding; the owner may want to decide on it.
- Cases 12, 13 and 15 use the plot window as node interval. The module page's example intervals ($[-10, 10]$, $[-10, 10]$, $[-5, 5]$) might suggest a departure, but the notebook builds the nodes from `a`, `b` = $\pm3\pi$, $\pm3\pi$ and $[-2, 3]$. **The page is correct.**

---

## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `lagnewt_animations_all.jl` | 0 | 36.6 | 29 GIFs (lagnewt01.gif … lagnewt29.gif) | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

### Description

| # | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|
| D1 | "a unique polynomial of degree at most $n$ through $n+1$ data points" | Standard; degree n−1 reproduced, degree n not (`prop.jl`) | confirmed |
| D2 | "evaluate it in the first barycentric form", $P_n=\ell\sum w_iy_i/(x-x_i)$ | Script lines 129–138 | confirmed |
| D3 | $\ell(x)=\prod_{j=0}^n(x-x_j)$, $w_i=1/\prod_{j\ne i}(x_i-x_j)$ | Script lines 110–120, 136 | confirmed |
| D4 | "This is the same interpolant" | Matches 90-digit Newton divided differences in all 290 frames | confirmed |
| D5 | "stays accurate far outside the nodes" | Worst relative error over all frames and grid points 1.7e-7 (Case 29); worst plotted error 2.2e-9 of window height | confirmed |
| D6 | second form "(a ratio of two such sums)" | Standard identity | confirmed |
| D7 | second form "gives values of the wrong sign in Cases 04 and 29" | Julia loop over all 29 cases: wrong signs in exactly 04 (deg 13: 4 points, deg 15: 1) and 29 (deg 13: 2, deg 15: 151). E.g. Case 04, x=9.596: P=9.37e11, second form −1.58e13 | confirmed |
| D8 | $P_n=\sum y_iL_i$, $L_i=\prod_{j\ne i}(x-x_j)/(x_i-x_j)$ | Evaluated directly at 90 digits, Case 08 degree 15: 0.42299950493 at x=0.3709, −405.66039524 at x=1.2297; script agrees | confirmed |
| D9 | "The 29 animations below follow the legacy Mathews case ordering" | All 29 functions and windows match the legacy index, row by row | confirmed |
| D10 | "Each case heading gives the function and the node interval" | Parsed all 29 headings against the case table | confirmed |
| D11 | "nodes are equally spaced from $a$ to $b$, endpoints included" | Endpoints exact and spacing uniform in all 290 frames; the trim branch never fires | confirmed |
| D12 | Window wider than $[a,b]$ in "Cases 01–11, 14, 19 and 24–29" | Computed set is exactly this list | confirmed |
| D13 | "In Case 19, $\arcsin x$ is undefined outside $[-1, 1]$, so there only the interpolant is drawn" | f is NaN outside; finite samples end at ±0.9985 | confirmed |

### Animations introduction

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| A1 | Degrees "1, 2, 3, 4, 5, 7, 9, 11, 13 and 15" | Script line 167; true degree can be lower, see F1 | confirmed as nominal (F1) |
| A2 | "(2, 3, 4, 5, 6, 8, 10, 12, 14 and 16 nodes)" | Script line 167; node counts in dump | confirmed |
| A3 | "for a fixed function and node interval" | Case table; nodes identical across frames apart from count | confirmed |
| A4 | A curve leaving the window "is drawn along the window's top or bottom edge" | Script lines 194, 211; frames. Includes interior overshoot, e.g. Case 12 degree 7 reaches ±5.15 in a ±1.6 window; also Cases 13, 20, 21, 27 | confirmed (disclosed clamp) |
| A5 | "except $f$ in Cases 01–03 and 14, which runs off the window and is broken at each of its poles" | Script lines 196–201; frames | confirmed |
| A6 | "[Julia source for all cases]" | Link resolves to the one script | confirmed |
| A7 | 29 cases, 10 frames each | 29 embeds; 10 frames in all 29 GIFs | confirmed |

### Every case: heading, wiring, alt text, title

For every row below I checked by script that the heading interval equals the table's node span, the embed is `lagnewtNN.gif`, the alt-text nodes equal the heading, and the alt-text window equals the table's `xlims`. I compared the function with the code and the legacy index, and read the title in frames 1, 5 and 10. Committed GIFs are byte-identical to a fresh run (manifest).

| Case | Function | Nodes | Window | Legacy check of nodes | Verdict |
|---|---|---|---|---|---|
| 01 | $1/(1-x)$ | [−1.5, 0.9] | [−1.6, 1.5] | surviving GIF | confirmed |
| 02 | $1/(1+x)$ | [−0.9, 1.5] | [−1.5, 1.6] | window only; nodes could not be determined | confirmed vs code |
| 03 | $1/(1-x)^2$ | [−1.5, 0.9] | [−1.6, 1.5] | window only; nodes could not be determined | confirmed vs code |
| 04 | $\sqrt x$ | [0, 2] | [0, 10.5] | index, GIF, notebook | confirmed |
| 05 | $\sqrt x$ | [0, 8] | [0, 10.5] | index, notebook | confirmed |
| 06 | $\sqrt x$ | [0, 10] | [0, 10.5] | index, notebook | confirmed |
| 07 | $1/\sqrt{1-x}$ | [−1.5, 0.95] | [−1.6, 1.5] | notebook | confirmed |
| 08 | $1/(1+10x^2)$ | [−1, 1] | [−1.5, 1.5] | index, notebook | confirmed |
| 09 | $\ln x$ | [0.02, 2] | [−0.5, 4.1] | index, notebook (legacy GIF is a corrupt HTML file) | confirmed |
| 10 | $\ln x$ | [0.02, 4] | [−0.5, 4.1] | index, notebook | confirmed |
| 11 | $\ln(1+x)$ | [−0.98, 1] | [−1.5, 1.5] | index | confirmed |
| 12 | $\sin x$ | [−3π, 3π] | same | notebook | confirmed |
| 13 | $\cos x$ | [−3π, 3π] | same | notebook | confirmed |
| 14 | $\tan x$ | [−1.45, 1.45] | [−π, π] | notebook | confirmed |
| 15 | $e^x$ | [−2, 3] | same | notebook | confirmed |
| 16 | $e^{-x}\cos x$ | [−2, 4] | same | window only; nodes could not be determined | confirmed vs code |
| 17 | $\cosh x$ | [−4, 4] | same | window only; nodes could not be determined | confirmed vs code |
| 18 | $\arctan x$ | [−2.2, 2.2] | same | notebook example uses [−2, 2] | **F2** |
| 19 | $\arcsin x$ | [−1, 1] | [−1.5, 1.5] | notebook | confirmed |
| 20 | $J_0$ | [−10.2, 10.2] | same | notebook uses [−10, 10] | **F2** |
| 21 | $J_1$ | [−10.2, 10.2] | same | window only; nodes could not be determined | confirmed vs code |
| 22 | normal pdf | [−3, 3] | same | notebook | confirmed |
| 23 | normal cdf | [−3, 3] | same | notebook | confirmed |
| 24 | $\Gamma$ | [0.05, 2] | [−0.2, 5.2] | index | confirmed |
| 25 | $\Gamma$ | [0.05, 4] | [−0.2, 5.2] | index | confirmed |
| 26 | $\Gamma$ | [0.5, 5] | [−0.2, 5.2] | index | confirmed |
| 27 | $Y_0$ | [0.5, 20] | [0, 22] | index | confirmed |
| 28 | $Y_0$ | [0.5, 10] | [0, 22] | index | confirmed |
| 29 | $Y_0$ | [0.5, 4] | [0, 22] | index | confirmed |

### Case notes and extra alt-text claims

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| N1 | Cases 01, 02: window "includes the pole"; "beyond the pole f ≤ −2, below the window" | max f beyond the pole = −2.0; window bottom −1.646 | confirmed |
| N2 | Case 03: window includes the pole at x=1 | Script `poles=[1.0]`; frames | confirmed |
| N3 | Cases 07, 09, 10, 11: f drawn only where defined | NaN outside the domain; frames | confirmed |
| N4 | Case 12: with 2, 3, 4 nodes every node is a multiple of π; the frames show y=0 | Nodes/π = ±3; −3,0,3; −3,−1,1,3. max\|P\| = 3.7e-16 | confirmed |
| N5 | Case 13: with 2 and 4 nodes every node is an odd multiple of π; the frames show y=−1 | max\|P+1\| = 2.2e-16 and 5.6e-16 | confirmed |
| N6 | Case 14: degree 1 and 2 frames show the same line; nodes lie between the poles at ±π/2 | max difference 7.1e-15; 1.45 < π/2 | confirmed |
| N7 | Case 18: same line at degrees 1 and 2 | max difference 4.4e-16 | confirmed |
| N8 | Case 19: same line at degrees 1 and 2; f on its whole domain | max difference 8.9e-16 | confirmed |
| N9 | Case 21: same line at degrees 1 and 2 | max difference 2.6e-18 | confirmed |
| N10 | Case 23: $f-\tfrac12$ odd; $(0,\tfrac12)$ on the line; same line | max difference 3.3e-16 | confirmed |

---

### 3. Implementation checks: `lagnewt_animations_all.jl`

**It is the method it claims to be.** The code is Lagrange interpolation in the first barycentric form with weights $1/\prod_{k\ne j}(x_j-x_k)$. An exact-hit branch returns $y_j$ within 1e-12 of a node. No hidden variant or safeguard changes the result: the node-trimming retry in `equal_nodes` exists but never fires in any of the 290 frames.

**The numbers are right.** Independent reference: Newton divided differences at 90 digits, with $f$ evaluated by mpmath at the script's nodes, compared at all 1000 grid points of all 290 frames (`check1.py`, output in `inst/check1.out`).

| Quantity | Script vs independent |
|---|---|
| Node ordinates $f(x_i)$ | max relative difference 2.7e-16 |
| Interpolant, relative, all frames | worst 1.7e-7 (Case 29), 4.1e-8 (Case 28), all others ≤ 1.0e-10 |
| Interpolant as plotted (clamped), fraction of window height | worst 2.2e-9 (Case 29) |

Property checks on the script's own routine (`prop.jl`), for each n from 2 to 16 nodes:
- reproduces a polynomial of degree n−1 (relative error 3.7e-16 at n=2, rising to 2.7e-11 at n=16, on a grid extending past the nodes);
- does not reproduce degree n (relative error 1.0 to 9.4), so the degree of exactness is exactly n−1;
- passes through the data when evaluated 1e-9 from each node, away from the exact-hit branch (error ≤ 1.2e-9).

**Its reference values are right.** The "true" curve $f$ agrees with mpmath at every 7th grid point of every case to at most 2.9e-16 relative (covers $J_0$, $J_1$, $Y_0$, $\Gamma$, erf). The table's functions match the legacy index.

**The picture shows what was computed.** I viewed frames 1, 5 and 10 of all 29 GIFs at readable size, and the other frames are covered numerically by the dump.
- Titles carry the right case number, function and nominal degree (see F1).
- Nodes sit on $f$; the interpolant passes through them; colours match the legend.
- Y-limits include every node of every frame.
- Clamping: the interpolant and (outside Cases 01–03 and 14) $f$ are clamped to the window, as the page says. Clamping also flattens interior overshoot in some frames: Case 12 degree 7 (true ±5.15, window ±1.6), Case 13 degrees 7 and 9, Case 20 degrees 4 and 9, Case 21 degrees 5, 7 and 9, Case 27 degrees 5, 7 and 9. The page discloses this, so it is not a finding.
- Poles: in Cases 01–03 and 14, $f$ is NaN at each pole, so no line crosses it. In Cases 24–26, $\Gamma$ is clamped rather than broken, but the grid contains x = 0.0 exactly, where $f$ is NaN, so no false vertical line is drawn across its pole. This depends on the grid hitting 0 exactly and would need rechecking if the window or sample count changed.
- Largest jump between adjacent plotted samples of $f$ outside the pole cases is 0.112 of window height (Cases 24–26, on the steep side of the $\Gamma$ pole), so no spurious connecting segment appears.

