# The Tangent Parabola — animation review (round 7)

Page: `pages/numerical-methods/the-tangent-parabola/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


None.


#### Considered and not reported

These were examined and do not meet the standard for a finding.

- **The secant and tangent curves become visually indistinguishable early.** The sup-norm gap on $[0,\pi]$ falls below one pixel from frame 8 ($h \approx 0.133$, gap 0.00222, about 0.7 px). From there only the nodes visibly move. This is the true $O(h^2)$ convergence, drawn faithfully, and the page makes no claim that contradicts it. The archive itself calls the graphical convergence "quite rapid".
- **Alt text "followed by the tangent parabola alone".** The hold frames also show $\sin x$ and the $x_0$ line. In context "alone" means without the secant parabola, which is accurate, and a reader is not misled.
- **Node marker at the window edge in frame 1.** At $h=1$ the left node is $(0,0)$, on the axis boundary. It remains visible.
- **Only three of the seven Table 1 step sizes are frames** ($h=1, 0.1, 0.01$). The page claims only the Figure 1 and Figure 2 step sizes, and those are present.
- **Archive Examples 3 to 5 are not animated.** The page says so explicitly and describes them correctly, so this is not a silent drop.
- **The page has no `## Description` section.** The authoring conventions ask for one, but missing content is outside this review's standard. As a result there are no Description formulas to check.

## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `tangparabaa.jl` | 0 | 11.7 | tangparabaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `tangparabaa.gif` | 22 | byte-identical | tangparabaa |

### Page references

- Scripts linked: `tangparabaa.jl`
- GIFs embedded: 1
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | Intro | "secant parabola (degree-2 Newton polynomial through $x_0-h$, $x_0$, $x_0+h$)" | Lines 22-31 are the Newton divided-difference form on those nodes. Agrees with an independent 50-digit Lagrange evaluation to at most 5.0e-13 on all 500 points in all 17 frames | Confirmed |
| 2 | Intro | "tangent parabola (degree-2 Taylor polynomial at $x_0$)" | Plotted curve vs `sympy.series(sin x, x, 1, 3)`: max difference 2.2e-16 in all 22 frames | Confirmed |
| 3 | Intro | "converging to the tangent parabola ... as $h \to 0$" | Sup gap 0.119567 at $h=1$, 0.001251 at $h=0.1$, 0.000013 at $h=0.01$. Gap$/h^2 \to 0.1251$; predicted $\cos(1)/6+\sin(1)/24 = 0.125112$ | Confirmed |
| 4 | Intro, heading | "$f(x) = \sin(x)$" | Line 11; frame legend; plotted series vs `numpy.sin`: 1.1e-16 | Confirmed |
| 5 | Intro, heading | "centered at $x_0 = 1$" | Line 15; middle node and vertical line at 1 in every frame | Confirmed |
| 6 | Intro | "the running example of Mathews' module" | Archive Figures 1 to 3, Examples 1 and 2 and Table 1 all use $y=\sin x$, $x_0=1$ (`m1.png`, `m2.png`, `m9.png`) | Confirmed |
| 7 | Intro | "the frames include its Figure 1 and Figure 2 step sizes $h = 0.1$ and $h = 0.01$" | Archive gr36 $h=0.1$, gr41 $h=0.01$. Frame 9 has $h=0.10000000000000002$, frame 17 has $h=0.010000000000000004$; titles read 0.1 and 0.01 | Confirmed |
| 8 | Intro | "Julia source scripts ... are linked under each case" | One case, one link, target exists | Confirmed |
| 9 | Intro | Examples 3 to 5 "extend the construction to Newton polynomials of higher degree" | Archive: cubic in Examples 3 and 4, degree 6 in Example 5 (gr193, gr194, gr245, gr246) | Confirmed |
| 10 | Intro | "through equally spaced points starting at $x_0$" | Archive gr194 and gr246: nodes $x_0+kh$, $k=0,\dots,n$ | Confirmed |
| 11 | Intro | "compare them with the Taylor polynomial of the same degree" | Archive gr211, gr229, gr257, gr258 plot $f$, $T$, $P$. Independently, forward Newton coefficients approach $T_3$ and $T_6$ of $e^{x/4}\cos x$ (max coefficient difference 1.6e-4 for $n=3$ and 5.1e-6 for $n=6$ at $h=0.001$) | Confirmed |
| 12 | Intro | "the tangent cubic in Examples 3 and 4" | Archive gr211, gr228: $T = 1 + x/4 - 15x^2/32 - 47x^3/384$; `mpmath.taylor` gives 1, 0.25, -0.46875, -0.12239583 | Confirmed |
| 13 | Intro | "a higher-degree tangent polynomial in Example 5" | Archive gr257: degree 6. `mpmath.taylor` gives the $x^4$ to $x^6$ coefficients 0.026204427, 0.0091227214, -0.00016784668, equal to 161/6144, 1121/122880, -11/65536 | Confirmed |
| 14 | Intro | Examples 3 to 5 "are not animated here" | One script, one GIF, both for $\sin x$ | Confirmed |
| 15 | Heading | "Case 1 — Secant parabola $\to$ tangent parabola as $h \to 0$" | Frames 1 to 17 decrease $h$ from 1 to 0.01; frames 18 to 22 show $T_2$ | Confirmed |
| 16 | Behavior | "For large $h$ the secant parabola is determined by three well-separated points" | Frame 1 nodes at $x = 0, 1, 2$ | Confirmed |
| 17 | Behavior | "As $h \to 0$ all three nodes collapse to $x_0$" | Plotted nodes equal $1-h, 1, 1+h$ to 1.1e-16; markers overlap at $x_0$ by frame 17 | Confirmed |
| 18 | Behavior | "the secant parabola approaches the Taylor polynomial $T_2(x) = f(x_0) + f'(x_0)(x-x_0) + \tfrac{1}{2}f''(x_0)(x-x_0)^2$" | Formula matches line 19 and sympy: $0.8414709848 + 0.5403023059(x-1) - 0.4207354924(x-1)^2$. Script coefficients approach these limits (see section 3) | Confirmed |
| 19 | Behavior | "the Taylor polynomial is the limiting position of the Newton interpolating parabola" | Closed forms $a_1=\cos(1)\sin(h)/h \to \cos 1$, $a_2=-\sin(1)(1-\cos h)/h^2 \to -\sin(1)/2$; numerics as in entry 3 | Confirmed |
| 20 | Link | `[Julia source](tangparabaa.jl)` is this case | File exists and generates this GIF | Confirmed |
| 21 | Embed | `tangparabaa.gif` is this case | Instrumented copy reproduces it byte for byte (md5 `8770517046b4223b4b86b4e84efd63f6`) | Confirmed |
| 22 | Alt text | "Secant parabola (red dashed) through three nodes" | Line 46 `:tomato`, line 60 `:dash`, three-point scatter; frames 1, 9, 17 | Confirmed |
| 23 | Alt text | "tangent parabola (green dotted, Taylor degree-2)" | Line 61 `:darkgreen`, `:dot`; frames | Confirmed |
| 24 | Alt text | "as h shrinks from 1.0 to 0.01" | $h$ runs from 1.0 to 0.010000000000000004 over 17 frames | Confirmed |
| 25 | Alt text | "followed by the tangent parabola alone" | Frames 18 to 22: secant and nodes absent; series are $\sin x$, $T_2$, $x_0$ line | Confirmed (read as "without the secant") |
| 26 | Alt text | "for sin(x) at x0=1" | Lines 11, 15 | Confirmed |

Not checked, per the standard: history and attribution, the "Derivation Notes (Planned)" placeholder.

**Could not determine:** how Quarto renders the page. I did not build the site, so the KaTeX and the final image placement were not seen. Link and image targets were checked on disk only.

### 3. Implementation checks: `tangparabaa.jl`

**It is the method it claims to be.** Lines 22-31 build the degree-2 Newton interpolant by divided differences on $x_0-h, x_0, x_0+h$. This is algebraically Mathews' formula (4), the centered form $f(x_0) + \frac{f(x_0+h)-f(x_0-h)}{2h}(x-x_0) + \frac{f(x_0-h)-2f(x_0)+f(x_0+h)}{2h^2}(x-x_0)^2$ (archive gr96). Line 19 is the degree-2 Taylor polynomial.

**The numbers are right.** Coefficients of the script's routine, recovered by fitting its output in powers of $(x-1)$, against the closed forms and the archive's Table 1. The constant term is 0.841471 at every $h$.

| $h$ | Archive $a_1$, $a_2$ | Closed form $a_1$, $a_2$ | Script $a_1$, $a_2$ |
|---|---|---|---|
| 1.0 | 0.454649, -0.386822 | 0.45464871, -0.38682227 | 0.45464871, -0.38682227 |
| 0.3 | 0.532234, -0.417589 | 0.53223416, -0.41758943 | 0.53223416, -0.41758943 |
| 0.1 | 0.539402, -0.420385 | 0.53940225, -0.42038500 | 0.53940225, -0.42038500 |
| 0.03 | 0.540221, -0.420704 | 0.54022126, -0.42070394 | 0.54022126, -0.42070394 |
| 0.01 | 0.540293, -0.420732 | 0.54029330, -0.42073199 | 0.54029330, -0.42073199 |
| 0.003 | 0.540301, -0.420735 | 0.54030150, -0.42073518 | 0.54030150, -0.42073518 |
| 0.001 | 0.540302, -0.420735 | 0.54030222, -0.42073546 | 0.54030222, -0.42073546 |

Limits: $f(1)=0.84147098$, $f'(1)=0.54030231$, $f''(1)/2=-0.42073549$.

Further checks:

- **Against an independent method:** every plotted secant curve matches a 50-digit Lagrange evaluation; worst difference 5.0e-13 (frame 16, rounding in the divided differences).
- **Interpolation property:** a quadratic fitted to the plotted curve reproduces the plotted node values to at most 1.2e-15.
- **Order of convergence:** gap$/h^2$ runs 0.1196, 0.1220, 0.1233, 0.1241, 0.1245, 0.1248, 0.1249, 0.1250, then 0.1251 through frame 17, matching the predicted 0.125112 at $x=0$.

**Its reference values are right.** $T_2$ matches the sympy series to 2.2e-16, and the plotted $\sin x$ matches `numpy.sin` to 1.1e-16.

**The picture shows what was computed.**

- The instrumented copy, which adds only data dumping, produces a GIF byte-identical to the committed one, so the dumped series are exactly what is drawn.
- Frames 1, 9, 17 and 22 and the contact sheet were viewed. Curves, nodes and legends agree with the dumped data.
- All 17 secant-frame titles and legend entries equal `round(h, digits=3)` for that frame's $h$: 1.0, 0.75, 0.562, 0.422, 0.316, 0.237, 0.178, 0.133, 0.1, 0.075, 0.056, 0.042, 0.032, 0.024, 0.018, 0.013, 0.01.
- Frame count is 22: 17 secant frames and 5 hold frames.
- No clamping or masking is used. All plotted curves lie in $y \in [-0.1196, 1.0149]$, inside the window $(-0.2, 1.15)$, and nodes lie in $x \in [0, 2]$, inside $(0, \pi)$.
- The window $[0,\pi]$ matches the archive's figures. The lower $y$ limit is extended so that $T_2(0) = -0.1196$ is visible.
- The legend at the bottom does not cover any curve or node.

**Archive completeness.** Images gr105 to gr110, gr113 and gr123 are missing from the archive. This affects the display of Example 2's solution and a Table 1 detail. The values they would show are covered by the Table 1 image (gr119) and the independent computation above.

