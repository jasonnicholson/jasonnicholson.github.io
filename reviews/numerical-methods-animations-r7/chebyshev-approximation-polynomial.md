# Chebyshev Approximation Polynomial — animation review (round 7)

Page: `pages/numerical-methods/chebyshev-approximation-polynomial/`. Reported findings: **0 Error, 0 Misleading, 2 Minor**.

## Findings

### F1. Page match, Minor: the blue curve also leaves the frame inside the interval

- **Location:** `index.qmd` line 22: "Green dashed vertical lines mark the ends of the approximation interval; outside them the blue curve is extrapolation and can leave the frame."
- **What is there now:** the sentence presents leaving the frame as something that happens outside the green lines.
- **What is true:** in 7 frames across 6 cases the interpolant also leaves the frame *between* the green lines. The y-window is computed from `f` only (`window_ylims`, script lines 168-175), so the interpolant's own overshoot is cut off at the frame.

| Case | n | Grid points off-frame in interval | Interpolant range in interval | y-window | Excess (share of window height) |
|---|---|---|---|---|---|
| 08 | 3 | 24 / 666 | [-0.1729, 1.0000] | [-0.0951, 1.1189] | 0.0778 (6.4%) |
| 12 | 8 | 78 / 1000 | [-1.5223, 1.5223] | [-1.2946, 1.2938] | 0.2285 (8.8%) |
| 13 | 5 | 4 / 1000 | [-1.3231, 1.0004] | [-1.2941, 1.2931] | 0.0290 (1.1%) |
| 13 | 6 | 90 / 1000 | [-1.5580, 0.9294] | [-1.2941, 1.2931] | 0.2639 (10.2%) |
| 22 | 3 | 62 / 1000 | [-0.1148, 0.3989] | [-0.0530, 0.4559] | 0.0617 (12.1%) |
| 23 | 2 | 54 / 1000 | [-0.1831, 1.1831] | [-0.1469, 1.1469] | 0.0363 (2.8%) |
| 27 | 8 | 2 / 886 | [-0.6023, 0.5982] | [-0.4987, 0.6181] | 0.1036 (9.3%) |

  The clearest case is Case 13, n = 6 (`cheby13.gif` frame 5): the blue curve runs off the bottom of the frame around x = 0, in the middle of the interval.
- **How I know:** `/usr/bin/python3 -I review/extra.py review <page>` (section 6 of its output, saved in `review/extra.out`), using the unclamped interpolant values dumped by `review/instr.jl`; confirmed by eye in the frame.
- **Suggested correction:** the smallest fix is the wording: "Green dashed vertical lines mark the ends of the approximation interval. Outside them the blue curve is extrapolation and can leave the frame; at low $n$ its overshoot can also briefly leave the frame inside the interval (cases 08, 12, 13, 22, 23, 27)." Alternatively, widen `window_ylims` to include each frame's interpolant on the interval, then regenerate those GIFs.

- **Independent check:** not run (Minor finding, unverified)

### F2. Fidelity, Minor: Case 26 uses [0.5, 5], but the legacy animation itself uses [0.05, 5]

- **Location:** script line 53 `with_span("26", "gamma(x)", x -> gamma(x), (-0.2, 5.2), (0.5, 5.0))`; `index.qmd` line 128 "Case 26 caption: f(x)=gamma(x), interval [0.5, 5]."
- **What is there now:** approximation interval [0.5, 5]. This agrees with the legacy *index text* ("unequally spaced nodes in [0.5, 5]").
- **What the archive shows:** the legacy *GIF* for this case (`Chebyshev26/Chebyshevzz.gif`) contradicts its own index text. Its left green line is at x = 0.05, and its 26 red nodes fit Chebyshev nodes on [0.05, 5], not [0.5, 5]. With [0.05, 5] the legacy gamma cases also form a natural widening series: [0.05, 2], [0.05, 4], [0.05, 5]. The index text is most likely a typo for 0.05, though the archive cannot prove which was intended.
- **Why it matters a little:** the pole at x = 0 is what makes the legacy case hard, and starting at 0.5 removes most of that difficulty. Max error of the gamma interpolant:

| Nodes | On [0.5, 5] (page) | On [0.05, 5] (legacy GIF) |
|---|---|---|
| 6 | 1.828e-01 | 1.107e+01 |
| 16 | 1.125e-04 | 1.610e+00 |
| 26 | 1.611e-07 | 2.168e-01 |

  The page is internally consistent and mathematically correct for the interval it states, so this is a fidelity point only.
- **How I know:** left green line at pixel column 29; x-axis ticks x = 0 at column 23 and x = 5 at column 615, so a = (29-23)/118.4 = 0.051 and b = 5.00 (`review/legacy_measure.py`). Red-dot abscissas against the Chebyshev model with 26 nodes: rms misfit **0.0028** for [0.05, 5] against **0.2753** for [0.5, 5] (`review/legacy26.py`). Error table from `review/extra.py`.
- **Suggested correction:** change the row to `(0.05, 5.0)`, change the caption on line 128 to `interval [0.05, 5]`, and regenerate `cheby26.gif`. If the owner prefers the archive's printed label, keep [0.5, 5]; nothing on the page is then false.

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `chebyshev_animations_all.jl` | 0 | 44.9 | 29 GIFs (cheby01.gif … cheby29.gif) | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `cheby01.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby02.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby03.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby04.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby05.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby06.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby07.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby08.gif` | 14 | byte-identical | chebyshev_animations_all |
| `cheby09.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby10.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby11.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby12.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby13.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby14.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby15.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby16.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby17.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby18.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby19.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby20.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby21.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby22.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby23.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby24.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby25.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby26.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby27.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby28.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby29.gif` | 10 | byte-identical | chebyshev_animations_all |

### Page references

- Scripts linked: `chebyshev_animations_all.jl`
- GIFs embedded: 29
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

### Introduction and Description

| # | Claim (page's words) | Verdict | Evidence |
|---|---|---|---|
| 1 | "uses clustered nodes near interval endpoints" | Confirmed | Formula and plotted nodes in all cases |
| 2 | "to reduce oscillation compared with equally spaced interpolation at the same degree" | Confirmed | Case 08 f, max error equispaced / Chebyshev: n=12 0.236 / 0.048; n=16 0.485 / 0.0138; n=32 14.0 / 9.5e-5. At n=4 and n=8 equispaced is slightly smaller (0.479 / 0.532, 0.135 / 0.165), which does not contradict a claim about high-degree oscillation |
| 3 | "a standard remedy for Runge-type endpoint blow-up" | Confirmed | Same table: equispaced error grows to 14.0 at n=32, Chebyshev falls to 9.5e-5 |
| 4 | $x_k=\frac{a+b}{2}+\frac{b-a}{2}\cos\frac{(2k-1)\pi}{2n}$, $k=1,\dots,n$ | Confirmed | Script line 97 is this formula (then sorted). Script nodes agree with my own to at most 3.4e-15 |
| 5 | They are "the mapped roots" | Confirmed | max \|T_n(mapped script node)\| over all 294 frames = 4.8e-14 |

### Animations introduction

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 6 | "steps through 2, 3, 4, 5, 6, 8, 10, 12, 14 and 16 Chebyshev nodes" | Confirmed | `node_count_sequence` output for all 28 non-08 cases; n in every frame title |
| 7 | "(case 08 continues to 20, 24, 28 and 32)" | Confirmed | Case 08 sequence, 14 frames, titles read |
| 8 | "for a fixed function and approximation interval" | Confirmed | Interval and function are constant across each case; the endpoint-trim fallback in `chebyshev_nodes` never fires (max trim attempt = 0 for all cases and n) |
| 9 | "With $n$ nodes the interpolant has degree at most $n-1$" | Confirmed | The script's values match my degree n-1 Newton interpolant (worst relative difference 5.7e-11) |
| 10 | "for an even function on a symmetric interval and even $n$ it is at most $n-2$" | Confirmed | Top divided difference for even n in the even cases 08, 13, 17, 20, 22: at most 2.1e-43 at 50-digit precision |
| 11 | "Green dashed vertical lines mark the ends of the approximation interval" | Confirmed | `vline!(span)`, seen in frames 1, 5 and last of every case |
| 12 | "outside them the blue curve is extrapolation and can leave the frame" | Confirmed as stated, incomplete | See **F1** |
| 13 | Blue = interpolant, as named in the text and legend | Confirmed | Plot code and legends |
| 14 | "Julia source for all cases" links the script | Confirmed | Link target exists and produces all 29 GIFs (manifest: byte-identical) |

### Case rows

For every row: heading, alt text, embedded GIF, table row and all frame titles agree (0 mismatches in a programmatic parse of `index.qmd` against the table; OCR of the title in all 294 frames gave 294 matches after normalising OCR character confusions). Function and plot window agree with the legacy index image for all 29 rows.

"Legacy interval" shows the sources that exist: T = index text, E = module example statement, G = measured from the surviving legacy GIF.

| Case | f | Page interval | Frames | Page vs script vs GIF | Legacy interval | Fidelity verdict |
|---|---|---|---|---|---|---|
| 01 | 1/(1-x) | [-1.6, 0.9] | 10 | Confirmed | No source (GIF missing) | Could not determine. Siblings 03 and 07 start at -1.5 and 02 mirrors to -1.5, so -1.5 is plausible, but nothing states it |
| 02 | 1/(1+x) | [-0.9, 1.5] | 10 | Confirmed | G [-0.90, 1.50] | Confirmed |
| 03 | 1/(1-x)^2 | [-1.5, 0.8] | 10 | Confirmed | G [-1.50, 0.80] | Confirmed |
| 04 | sqrt(x) | [0, 2] | 10 | Confirmed | T, E, G [0, 2] | Confirmed |
| 05 | sqrt(x) | [0, 8] | 10 | Confirmed | T, E [0, 8] | Confirmed |
| 06 | sqrt(x) | [0, 10] | 10 | Confirmed | T, E, G [0, 10] | Confirmed |
| 07 | 1/sqrt(1-x) | [-1.5, 0.95] | 10 | Confirmed | E [-1.5, 0.95] | Confirmed |
| 08 | 1/(1+10x^2) | [-1, 1], to 32 nodes | 14 | Confirmed | T, E [-1, 1] | Confirmed |
| 09 | log(x) | [0.02, 2] | 10 | Confirmed | T, E [0.02, 2] | Confirmed |
| 10 | log(x) | [0.02, 4] | 10 | Confirmed | T, E, G [0.02, 4] | Confirmed |
| 11 | log(1+x) | [-0.98, 1] | 10 | Confirmed | T [-0.98, 1] | Confirmed |
| 12 | sin(x) | [-3pi, 3pi] | 10 | Confirmed | G [-3pi, 3pi]; E [-10, 10] | Confirmed against the animation |
| 13 | cos(x) | [-3pi, 3pi] | 10 | Confirmed | E [-10, 10]; GIF missing | Could not determine. Where both survive (12, 15) the GIF uses the plot window, not E |
| 14 | tan(x) | [-1.45, 1.45] | 10 | Confirmed; poles at ±1.5708 lie outside it | E [-1.45, 1.45] | Confirmed |
| 15 | exp(x) | [-2, 3] | 10 | Confirmed | G [-2, 3]; E [-5, 5] | Confirmed against the animation |
| 16 | cos(x)exp(-x) | [-2, 4] | 10 | Confirmed | No source beyond plot window | Could not determine |
| 17 | cosh(x) | [-4, 4] | 10 | Confirmed | No source beyond plot window | Could not determine |
| 18 | atan(x) | [-2.2, 2.2] | 10 | Confirmed | E [-2, 2]; GIF missing | Could not determine (as case 13) |
| 19 | asin(x) | [-1, 1] | 10 | Confirmed | E [-1, 1] | Confirmed |
| 20 | besselj(0,x) | [-10.2, 10.2] | 10 | Confirmed | E [-10, 10]; GIF missing | Could not determine (as case 13) |
| 21 | besselj(1,x) | [-10.2, 10.2] | 10 | Confirmed | No source beyond plot window | Could not determine |
| 22 | normal_pdf | [-3, 3] | 10 | Confirmed | E [-3, 3] | Confirmed |
| 23 | normal_cdf | [-3, 3] | 10 | Confirmed | E [-3, 3] | Confirmed |
| 24 | gamma(x) | [0.05, 2] | 10 | Confirmed | T, G [0.05, 2] | Confirmed |
| 25 | gamma(x) | [0.05, 4] | 10 | Confirmed | T [0.05, 4] | Confirmed |
| 26 | gamma(x) | [0.5, 5] | 10 | Confirmed | T [0.5, 5]; **G [0.05, 5]** | **Conflict, see F2** |
| 27 | bessely(0,x) | [0.5, 20] | 10 | Confirmed | T, G [0.5, 20] | Confirmed |
| 28 | bessely(0,x) | [0.5, 10] | 10 | Confirmed | T, G [0.5, 10] | Confirmed |
| 29 | bessely(0,x) | [0.5, 4] | 10 | Confirmed | T, G [0.5, 4] | Confirmed |

Legacy features that the page does not have (the tolerance band and "convergence region" bar, and higher final degrees such as S25 in the gamma cases) are not reported as findings: the page makes no claim about them, and the review standard excludes content the page does not yet have.

---

### 3. Implementation checks: `chebyshev_animations_all.jl`

**It is the method it claims to be.** Polynomial interpolation at the n roots of T_n mapped to [a, b], evaluated by the barycentric formula (second form inside the node range, first form outside, which is the stable choice for extrapolation). This is the method the page describes. The endpoint-trim fallback in `chebyshev_nodes` could silently change the interval, but it never fires in any case (max attempt = 0).

**The numbers are right.** `review/instr.jl` (a scratch copy with the render loop replaced) dumped every node, node value and unclamped interpolant. `review/verify.py` recomputed them with its own nodes, its own f in mpmath at 50 digits, and its own Newton divided-difference interpolant at 143 points per frame.

| Check (worst over all cases and frames) | Result |
|---|---|
| Script nodes vs own nodes | 3.4e-15 absolute |
| Script f(node) vs mpmath | 2.7e-15 relative |
| Script interpolant vs own interpolant | 5.7e-11 relative (case 29, far extrapolation); at most 3.5e-12 in every other case |
| Interpolant reproduces its data at the nodes | 3.9e-14 |
| Nodes are roots of T_n | 4.8e-14 |
| Even function, even n: top coefficient vanishes | at most 2.1e-43 |

Per-case values are in `review/verify.out`.

**Its reference values are right.** The magenta curve agrees with mpmath at every third plot point for all 29 functions: worst relative difference 3.3e-16, and 0 disagreements about where f is undefined. The normal pdf and cdf also agree with `scipy.stats.norm` (0 and 2.2e-16).

**The picture shows what was computed.**

- Frames 1, 5 and last of all 29 cases were viewed, and all 294 titles were read by OCR. Nodes lie on f, the curve passes through them, green lines are at the stated interval, and legends are correct.
- Poles: cases 01, 02 and 14 break correctly at the pole. Case 03's double pole shows two branches running off the top.
- Clamping to a band one window-height beyond the limits is invisible and affects only off-frame points.
- The y-window hides part of the interpolant's overshoot in 7 frames; see **F1**.

**Robustness note (not a finding; no visible effect).** The gamma pole at x = 0 in cases 24-26 is not in the `poles` list, although the field's comment (line 19) describes poles inside the plotting window. The curve breaks correctly only because the 1000-point grid lands exactly on 0.0, where `safe_eval` returns NaN (grid values -0.005405, 0.0, 0.005405; confirmed in `review/pole_crops.png`). A different grid length would draw a false vertical line joining the branches. Adding `poles=[0.0]` to those three rows would remove the dependence.

**Could not determine.** The approximation intervals intended by Mathews for cases 01, 13, 16, 17, 18, 20 and 21, because their legacy GIFs are missing and the archive either gives no interval or gives an example statement that the surviving GIFs show was not always what the animation used.

