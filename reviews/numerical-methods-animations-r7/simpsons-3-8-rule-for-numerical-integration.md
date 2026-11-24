# Simpson's 3/8 Rule for Numerical Integration — animation review (round 7)

Page: `pages/numerical-methods/simpsons-3-8-rule-for-numerical-integration/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Findings by severity: Error 0, Misleading 0, Minor 0.

Three observations were considered and deliberately not raised, so the owner can overrule them:

- **"Each frame recomputes the approximation"** (Animations intro). Frame 1 shows only $f$ and computes nothing. The image alt text says so ("after an opening frame showing only f"), and a viewer cannot be misled by a frame with no approximation on it.
- **Different intermediate $n$ from the legacy GIF.** The page discloses this in its legacy note. The start (4 points), the error increase at 7 points and the end (121 points, 2.015810) are the same in both, so nothing a reader would conclude changes. Details are in ledger entry 27.
- **Trailing zeros in GIF labels.** `round(approx; digits=6)` prints `1.79047`, `2.01517`, `2.01572` and `2.01581` with five decimals. All are correct values. This is cosmetic.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `simpson38aa.jl` | 0 | 9.0 | simpson38aa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `simpson38aa.gif` | 24 | byte-identical | simpson38aa |

### Page references

- Scripts linked: `simpson38aa.jl`
- GIFs embedded: 1
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|
| 1 | "applies cubic interpolation on blocks of three subintervals" | Script lines 40-51 fit a cubic through 4 nodes per block; the fit reproduces its nodes (assert under 1e-9, all 23 $n$) | confirmed |
| 2 | $h=(b-a)/n$, $n$ divisible by 3 | Script line 26; every entry of `n_seq` is a multiple of 3 | confirmed |
| 3 | Composite formula with weights 1, 3, 2 and factor $3h/8$ | Weights equal the sum of Lagrange-derived panel weights [3/8, 9/8, 9/8, 3/8], exact rational comparison at $n$ = 3, 6, 9, 30, 120 | confirmed |
| 4 | For $C^4$ $f$, $S_n^{3/8}-I=O(h^4)$ | Script routine on $e^x$: error ratio on halving 15.69, 15.92, 15.98, 15.995, 15.999 | confirmed |
| 5 | "higher-order refinement of trapezoidal geometry" | $(9T_h-T_{3h})/8-S=0$ to working precision (at most 2.3e-41) at $n$ = 6, 60, 120, so the rule is a Richardson extrapolation of the trapezoid rule | confirmed |
| 6 | Diagram "over $[0,2]$" for $y=e^{-x}\sin(8x^{2/3})+1$ | Script lines 8-9 | confirmed |
| 7 | "Each frame recomputes the approximation across the full interval with a denser partition" | $n$ strictly increases over frames 2-24 and each sum spans $[0,2]$. Frame 1 is the opening frame (see Findings note) | confirmed, with the noted exception of the opening frame |
| 8 | "$n$ remains a multiple of 3" | `n_seq` | confirmed |
| 9 | "Red dots mark the sample points $x_i$" | Script lines 72-73 draw $x_i$, $i=0..n$. Seen in frames 2, 24 and the 12-frame contact sheet. Dots were not pixel-counted in every frame | confirmed |
| 10 | "vertical red lines mark the panel boundaries $x_{3k}$" | Pixel scan of frames 2-24: divider count $n/3+1$ and positions within 2 px of $x_{3k}$ in **23 of 23** frames | confirmed |
| 11 | "linked under each case" | One case, one link, target exists | confirmed |
| 12 | Case 1 heading: function and interval | Script lines 8-9 | confirmed |
| 13 | "Piecewise cubic panels over triplets of subintervals are rebuilt at increasing density" | Script lines 40-55, inside the frame loop | confirmed |
| 14 | "Every approximation shown lies below the true integral" | All 23 values below $I$ (table in Section 3) | confirmed |
| 15 | $\int_0^2 f\,dx\approx 2.016280$ | 2.016279719617096, by quadrature after $x=t^3$ removes the singularity; direct quadrature agrees to all 14 digits shown | confirmed |
| 16 | "The error grows from 4 to 7 sample points" | $\lvert e\rvert$: 0.132066 to 0.225809 | confirmed |
| 17 | "then shrinks at every later frame" | $\lvert e\rvert$ strictly decreases from $n=6$ through $n=120$ | confirmed |
| 18 | "the last frame (121 sample points) gives 2.01581" | 2.015810411; frame 24 shows `2.01581` | confirmed |
| 19 | "about 0.00047 low" | $S-I=-0.000469309$ | confirmed |
| 20 | "$f'$ unbounded at $x=0$", $f'(x)\approx\tfrac{16}{3}x^{-1/3}$ | Ratio of $f'$ to this expression: 0.994308, 0.999997, 1.0 at $x$ = 1e-3, 1e-6, 1e-9 | confirmed |
| 21 | Textbook order "does not hold for this integrand" | Observed ratio is about 3.2, not 16 | confirmed |
| 22 | "shrinks like $O(h^{5/3})$" | Observed order 1.689, 1.673, 1.669, ... 1.6667. $(S-I)/h^{5/3}$ converges to the generalized Euler-Maclaurin constant $C=-0.428304$ (measured -0.431563, -0.428602, -0.428341, -0.428309 at $n$ = 120, 960, 7680, 61440) | confirmed |
| 23 | "divides it by about 3.22 (from 60 to 120 subintervals)" | 3.223844. Both $n$ are frames in the GIF | confirmed |
| 24 | "tending to $2^{5/3}\approx 3.17$, instead of 16" | Ratios 3.2238, 3.1890, 3.1801, 3.1771, 3.1759, 3.1753, 3.1751, 3.1749, 3.17487; $2^{5/3}=3.174802$ | confirmed |
| 25 | Alt text: opening frame shows only $f$; later frames show dots, boundaries, cubics and the approximation | Frames 1, 2, 24 and contact sheet | confirmed |
| 26 | Wiring: `simpson38aa.jl` and `simpson38aa.gif` are this case | Both exist beside the page. The committed GIF equals the regenerated one (md5 `222c4c9a391fca9e698dd8aa82e170cb`). Checked in source; the Quarto page was not rendered | confirmed |
| 27 | Legacy note: reconstructs `Simpsonaa.gif`, same integrand and interval, same 121-point value 2.015810, different intermediate $n$ | Legacy Example 11 gives $f=1+e^{-x}\sin(8x^{2/3})$ on $[0,2]$; legacy frame 24 shows 121 points, `2.015810`. Sample-point sets differ: 17 shared; legacy only 79, 85, 106; page only 22, 28, 34, 82, 100, 109. All 20 legacy labels were recomputed and match | confirmed |

### 3. Implementation checks: `simpson38aa.jl`

### It is the method it claims to be

The script runs the composite Simpson 3/8 rule. Interior points with $i\not\equiv 0 \pmod 3$ get weight 3, interior multiples of 3 get weight 2, and the factor is $3h/8$. The page describes this same variant. There is no adaptive or hybrid component.

Degree of precision, using the script's own routine: errors for $x^0$ through $x^3$ are at most 8.9e-16 at $n$ = 3, 6, 12. Errors for $x^4$ are 0.11852, 0.0074074, 0.00046296, which fall by 16 at each halving. The rule is exact through degree 3 and not beyond it.

### The numbers are right

Independent values below come from a rule built from symbolically integrated Lagrange basis polynomials, at 40-digit precision. Script values come from the instrumented copy. Displayed labels were read from all 24 frames and all 23 match.

| $n$ | Points | Script | Independent | $S-I$ |
|---|---|---|---|---|
| 3 | 4 | 1.8842140994 | 1.884214099 | -0.132066 |
| 6 | 7 | 1.7904704813 | 1.790470481 | -0.225809 |
| 9 | 10 | 1.9272339711 | 1.927233971 | -0.0890457 |
| 12 | 13 | 1.9766291962 | 1.976629196 | -0.0396505 |
| 15 | 16 | 1.9940944248 | 1.994094425 | -0.0221853 |
| 18 | 19 | 2.0018338081 | 2.001833808 | -0.0144459 |
| 21 | 22 | 2.0059341930 | 2.005934193 | -0.0103455 |
| 24 | 25 | 2.0083970415 | 2.008397042 | -0.00788268 |
| 27 | 28 | 2.0100124028 | 2.010012403 | -0.00626732 |
| 30 | 31 | 2.0111411216 | 2.011141122 | -0.0051386 |
| 33 | 34 | 2.0119677266 | 2.011967727 | -0.00431199 |
| 36 | 37 | 2.0125952389 | 2.012595239 | -0.00368448 |
| 42 | 43 | 2.0134768107 | 2.013476811 | -0.00280291 |
| 48 | 49 | 2.0140591847 | 2.014059185 | -0.00222053 |
| 54 | 55 | 2.0144675377 | 2.014467538 | -0.00181218 |
| 60 | 61 | 2.0147667416 | 2.014766742 | -0.00151298 |
| 66 | 67 | 2.0149935292 | 2.014993529 | -0.00128619 |
| 72 | 73 | 2.0151701321 | 2.015170132 | -0.00110959 |
| 81 | 82 | 2.0153705880 | 2.015370588 | -0.000909132 |
| 90 | 91 | 2.0155186139 | 2.015518614 | -0.000761106 |
| 99 | 100 | 2.0156314275 | 2.015631428 | -0.000648292 |
| 108 | 109 | 2.0157196261 | 2.015719626 | -0.000560094 |
| 120 | 121 | 2.0158104109 | 2.015810411 | -0.000469309 |

The script's routine was also run on $x^{2/3}$, whose integral is known in closed form. Error ratios are 3.17479, 3.17480, 3.17480, 3.17480, matching $2^{5/3}=3.174802$.

### Its reference values are right

The script draws no reference value. The page's reference, $I\approx 2.016280$, was computed independently as 2.016279719617096 (see ledger entry 15).

### The picture shows what was computed

- **Cubics.** The exact integral of the drawn cubics equals the displayed sum to about 1e-15 at all 23 $n$ (for example, at $n=120$: 2.0158104108637227 against 2.015810410863725). The shaded area is therefore the reported approximation.
- **Dividers.** Count and position match $x_{3k}$ in 23 of 23 frames by pixel scan.
- **Axis limits.** No clipping. Across all frames the cubics range from 0.2011 to 1.9395 and $f$ from 0.3572 to 1.9198, inside `ylims = (0, 2.1)`. The fill to $y=0$ is true area because the cubics stay positive.
- **Labels.** "Sample Points" is $n+1$ and "Approximation" is $S_n$ for that frame's $n$.
- **Reproducibility.** The scratch copy regenerates the committed GIF byte for byte.

### Legacy archive

The archive has one animation for this topic (`Simpson.html` links only `Simpsonaa.html`), tied to Example 11. The page reproduces its function and interval. Examples 1-10 are static worked examples, which correspond to the page's placeholder sections, so they were not compared.

### Could not determine

Nothing in the ledger. Limits of what was checked: the Quarto page was not rendered, so wiring was checked in source; red dots were confirmed from code and visual inspection rather than a per-frame pixel count.

