# Boole's Rule — animation review (round 7)

Page: `pages/numerical-methods/booles-rule/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1. "in this set" has no referent on this page

- **Kind:** Page match
- **Severity:** Minor
- **Location:** `index.qmd` line 17: "making it the highest-order closed Newton-Cotes rule in this set."
- **What is there now:** The page names no set of rules, so a reader arriving here cannot tell what "this set" is. The natural fallback reading is that Boole's rule is the highest-order closed Newton-Cotes rule, which is false.
- **What is true:** Among the four closed rules on the site's Newton-Cotes page (trapezoidal, Simpson's 1/3, Simpson's 3/8, Boole), Boole's rule does have the highest degree of precision. Closed rules with more subintervals go higher.
- **How I know:** `/usr/bin/python3 -I review/more.py review committed/boolesaa` solves the moment equations exactly for each closed rule and finds its degree of precision:

  | Subintervals per panel | 1 | 2 | 3 | 4 (Boole) | 5 | 6 | 7 | 8 |
  |---|---|---|---|---|---|---|---|---|
  | Degree of precision | 1 | 3 | 3 | **5** | 5 | 7 | 7 | 9 |

  The four-rule set is stated at `newton-cotes-integration/index.qmd` line 13.
- **Suggested correction:** "making it the highest-order of the four closed Newton-Cotes rules on this site (trapezoidal, Simpson's 1/3, Simpson's 3/8 and Boole). Closed rules with more nodes reach higher degree."

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `boolesaa.jl` | 0 | 7.8 | boolesaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `boolesaa.gif` | 24 | byte-identical | boolesaa |

### Page references

- Scripts linked: `boolesaa.jl`
- GIFs embedded: 1
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

Line numbers refer to `index.qmd`.

### Description

| # | Line | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | 13 | "applies a quartic interpolant on each block of four subintervals (five nodes)" | Script fits a degree-4 polynomial through 5 nodes per block (`boolesaa.jl` 48-60). The interpolant's exact area equals the Boole sum to at most 1.4e-14 at all 23 n | Confirmed |
| 2 | 13 | $h=(b-a)/n$, $n$ divisible by 4 | Script line 27; all 23 n are multiples of 4 | Confirmed |
| 3 | 14-16 | Formula with $2h/45$ and weights 7, 32, 12, 32, 7, summed over $k=0..n/4-1$ | Weights derived from moment equations: 14/45, 64/45, 8/15, 64/45, 14/45, equal to $\tfrac{2}{45}(7,32,12,32,7)$. Index ranges match script line 29 | Confirmed |
| 4 | 17 | "exact for polynomials up to degree 5" | Exact rational error is 0 for degrees 0 to 5, and 128/21 for degree 6 (on [0,4], h=1) | Confirmed |
| 5 | 17 | Smooth $f$ ($C^6$): global error $O(h^6)$ | $e^x$ on [0,2]: observed orders 5.865, 5.965, 5.991, 5.998 | Confirmed |
| 6 | 17 | "highest-order closed Newton-Cotes rule in this set" | True for the site's four rules; "this set" is undefined on the page | Wrong as worded (**F1**, Minor) |

### Animations introduction

| # | Line | Claim | Evidence | Verdict |
|---|---|---|---|---|
| 7 | 21-22 | $f(x)=1+e^{-x}\sin(8x^{2/3})$ on $[0,2]$ | Script lines 8-9 | Confirmed |
| 8 | 22 | "an opening frame showing only $f$" | `n=0` is the first loop value; frame 1 shows only the curve | Confirmed |
| 9 | 22 | Each frame recomputes over the full interval with a denser partition, $n$ a multiple of 4 | 23 n values, strictly increasing, all multiples of 4, from 4 to 120. Every block loop spans $[a,b]$ | Confirmed |
| 10 | 22 | "Red dots mark the sample points $x_i$" | Script lines 81-82; frames 2 and 24 inspected | Confirmed |
| 11 | 22 | "vertical red lines mark the panel boundaries $x_{4k}$" | Script lines 67-70. Pixel count along a row above the axis gives $n/4+1$ lines in all 23 frames (2 at n=4, 17 at n=64, 31 at n=120) | Confirmed |
| 12 | 21, 24 | "Each animation", "under each case" | The page has one animation and one case. The plural is template wording and states nothing false | Confirmed |

### Case 1

| # | Line | Claim | Evidence | Verdict |
|---|---|---|---|---|
| 13 | 26 | Heading: Composite Boole's Rule, this $f$, $[0,2]$ | Script | Confirmed |
| 14 | 28 | "the approximation increases from frame to frame" | Strictly increasing over all 23 frames (smallest step 3.889e-5) | Confirmed |
| 15 | 28 | True integral $\approx 2.016280$ | 2.0162797196170963 by substitution $x=t^3$ (removes the singularity). Direct adaptive quadrature agrees to all 14 digits printed | Confirmed |
| 16 | 28 | "staying below it" | $I-B_n>0$ at all 23 n | Confirmed |
| 17 | 28 | Last frame: 121 sample points | n=120; frame 24 reads "Sample Points = 121" | Confirmed |
| 18 | 28 | Last frame gives 2.015961 | 2.015961179 independent; 2.0159611789 script; frame 24 shows 2.015961 | Confirmed |
| 19 | 28 | "about $3.2\times10^{-4}$ low" | $I-B_{120}=3.1854\times10^{-4}$ | Confirmed |
| 20 | 28 | $f'$ unbounded at 0, $f'(x)\approx\tfrac{16}{3}x^{-1/3}$ | Symbolic limit $x^{1/3}f'(x)\to 16/3$ | Confirmed |
| 21 | 28 | Textbook order does not hold for this integrand | Observed order about 1.67, not 6 | Confirmed |
| 22 | 28 | Error shrinks like $O(h^{5/3})$ | Observed order from n to 2n: 1.6699 (60), 1.6689 (120), 1.6678 (240), 1.6667 (7680) | Confirmed |
| 23 | 28 | Halving $h$ from 60 to 120 divides the error by about 3.18 | 3.18196 | Confirmed |
| 24 | 28 | "tending to $2^{5/3}\approx 3.17$" | Ratios 3.1820, 3.1796, 3.1774, 3.1761, ... 3.17484 at n=15360; $2^{5/3}=3.17480$ | Confirmed |
| 25 | 28 | "instead of $2^6=64$" | Arithmetic | Confirmed |

### Wiring and alt text

| # | Line | Claim | Evidence | Verdict |
|---|---|---|---|---|
| 26 | 30 | Link to `boolesaa.jl` is this case | One script, and its parameters are the heading's | Confirmed |
| 27 | 32 | Embed `boolesaa.gif` is that script's output | Committed GIF is byte-identical to a fresh scratch run (`cmp`) | Confirmed |
| 28 | 32 | Alt text: over [0,2], opening frame of $f$, red dots, vertical red lines, piecewise quartic panels, global approximation | Matches the script and frames 1, 2 and 24 | Confirmed |

---

### 3. Implementation checks: `boolesaa.jl`

**It is the method it claims to be.** Lines 26-38 are composite Boole's rule with disjoint blocks of four subintervals. The weights were not taken from memory: solving the moment equations on nodes 0 to 4 gives them exactly, and the rule is exact through degree 5 and not degree 6. On $e^x$ the composite rule converges at order 6.

**The numbers are right.** Script against the independent 40-digit computation at all 23 n: the largest difference is 4.8e-11, which is the rounding of the 10-digit print. Selected values:

| n | Points | Script | Independent | Error $I-B_n$ |
|---|---|---|---|---|
| 4 | 5 | 1.5531546827 | 1.553154683 | 4.6313e-1 |
| 8 | 9 | 1.9634127276 | 1.963412728 | 5.2867e-2 |
| 16 | 17 | 2.0073277270 | 2.007327727 | 8.952e-3 |
| 32 | 33 | 2.0133926437 | 2.013392644 | 2.8871e-3 |
| 60 | 61 | 2.0152661372 | 2.015266137 | 1.0136e-3 |
| 64 | 65 | 2.0153696865 | 2.015369687 | 9.1003e-4 |
| 120 | 121 | 2.0159611789 | 2.015961179 | 3.1854e-4 |

**Reference value.** The script draws no reference. The page's 2.016280 is confirmed by two independent quadratures (claim 15).

**The picture shows what was computed.**

- Each drawn quartic interpolates its nodes (largest residual 6.6e-14) and agrees with an independent Lagrange evaluation (largest difference 7.3e-14), so the Vandermonde solve causes no visible error at these block widths.
- The shaded area equals the annotated approximation: exact integration of the plotted polynomials matches `boole_sum` to at most 1.4e-14.
- Nothing is clipped. Interpolant values range from 0.1239 to 1.9305 across all frames and $f$ from 0.357 to 1.920, inside `ylims = (0, 2.1)`. The fill to $y=0$ is therefore the true area.
- Annotated values in the frames inspected (the 11 non-opening contact-sheet frames plus frames 2 and 24) match the computed values. Because the GIF is byte-identical to the regenerated output, the remaining frames carry the same computed annotations.
- Two annotations print fewer digits (2.01268 at n=28, 2.01537 at n=64) because `round` drops a trailing zero. Both values are correct. This is cosmetic and not a finding.

### Legacy archive (consulted)

- **Source:** Example 11 of `BooleRuleMod` (`BooleRuleMod_lnk_12.html`), Animation 1 (`a2001/Animations/Quadrature/Boole/Booleaa.gif`, 24 frames).
- **Function and interval:** the archive uses $f[x]=1+e^{-x}\sin[8x^{2/3}]$ on $[0,2]$, the same as the page.
- **Values:** all 20 of Mathews' tabulated approximations (n = 4 to 40 by 4, then 48 to 120 by 8) appear in the script's sequence and agree to all printed digits. The script adds n = 44, 52 and 60.
- **Pacing:** the legacy GIF holds three opening frames and repeats its first approximation frame; the page has one opening frame. This has no effect on what a reader learns.
- **Other examples:** Examples 1 to 5 use $\int_0^2(2+\cos 2\sqrt{x})\,dx$ and Examples 6 to 10 use $\int_0^3(3e^{-x}\sin x^2+1)\,dx$. They are worked examples; only Example 11's page (`lnk_12`) mentions an animation. The page's Worked Example section is a planned placeholder, which the brief excludes.
- **Fidelity findings:** none.

