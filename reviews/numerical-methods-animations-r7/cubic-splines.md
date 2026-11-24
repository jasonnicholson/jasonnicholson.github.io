# Cubic Splines — animation review (round 7)

Page: `pages/numerical-methods/cubic-splines/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** 0 Error, 0 Misleading, 0 Minor, 0 Fidelity.

Four things were examined and deliberately not raised, so that the owner can overrule them:

1. **Title clipped by a few pixels on frames 4 to 6.** The closing `)` of the title reaches the last pixel column (dark title pixels at column 699 of 700) and is partly cut off. Every digit stays legible (`0.00896`, `0.00407`, `0.00107`), so this is cosmetic under the review standard.
2. **Frame 1 (3 nodes) shows $S\equiv 0$.** All three nodes are zeros of $\sin$, so the spline is the zero function and the error is 1. This is the correct spline. The page makes no contrary claim, and explaining it would be a teaching suggestion.
3. **The title's "max err" is sampled on a 600-point grid.** It is not the true supremum, but it agrees with the true maximum at the displayed 3 significant figures in all six frames (table in section 3).
4. **The tridiagonal system is stored dense and solved with Julia's general `\`.** The system is tridiagonal as the page says. The solver choice is a performance matter only.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `cubicsplineaa.jl` | 0 | 6.7 | cubicsplineaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

### Description

| # | Claim (page's words) | Verdict | Evidence |
|---|---|---|---|
| D1 | "piecewise-cubic interpolant built on nodes $x_0<\cdots<x_n$" | Confirmed | Each panel is one cubic; panel fits in `props.out` reproduce node values to at most 3.5e-15 for the page's data |
| D2 | "each panel polynomial $S_i(x)$ interpolates endpoint values" | Confirmed | Same check, both ends of every panel |
| D3 | "enforces continuity of $S$, $S'$, $S''$ at interior knots" | Confirmed | Script's routine: $S'$ jumps at most 2.4e-14, $S''$ jumps at most 9.6e-14 over the six frames |
| D4 | Natural spline: $S''(x_0)=0$, $S''(x_n)=0$ | Confirmed | Script sets `M[1]=M[end]=0`; recovered $|S''|$ at the ends at most 6.5e-14 |
| D5 | "unknown second derivatives are found from a tridiagonal linear system" | Confirmed | Lines 20 to 30 of the script assemble the standard three-term system for interior $M_j$; solution matches an independent first-derivative formulation |
| D6 | "then each cubic panel is reconstructed" | Confirmed | Lines 42 to 44 are the standard second-derivative form; agrees with independent Hermite form and SciPy to at most 8.9e-16 |
| D7 | Clamped: maximum error $O(h^4)$ | Confirmed | $e^x$ on $[0,1]$, N=10 to 320: observed order 3.987 to 3.999; non-uniform mesh 3.90 to 3.98 |
| D8 | Not-a-knot: maximum error $O(h^4)$ | Confirmed | Same problem: 3.926 to 3.995; non-uniform mesh 3.97 to 4.00 |
| D9 | Natural: "only $O(h^2)$ unless $f''(a)=f''(b)=0$" | Confirmed | $e^x$: 1.999 to 2.000. $\cos$ on $[0,2\pi]$: 2.055 to 2.000. One end nonzero ($\sin$ on $[0,\pi/2+1]$): 2.010 to 2.000. $\sin$ on $[0,2\pi]$ (both ends zero): 4.123 to 4.000 |
| D10 | "that error sits near an end where $f''\neq 0$" | Confirmed | $\sin$ on $[0,b]$ with $f''(0)=0$, $f''(b)\ne0$: the maximum is at $x/b=$ 0.981, 0.995, 0.999 for N=20, 80, 320 (the nonzero end) |
| D11 | "away from the ends the error is still $O(h^4)$" | Confirmed | $e^x$ on $[0.25,0.75]$: order 3.982, 3.996, 3.998 for N=80 to 320 (uniform); 3.96 to 4.00 (non-uniform) |

### Animations introduction

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| A1 | "natural cubic spline" | Confirmed | D4, and the uniqueness check in section 3 |
| A2 | "equally-spaced data" | Confirmed | Line 54, `range(0.0, 2π, length=nn)` |
| A3 | $f(x)=\sin(x)$ on $[0,2\pi]$ | Confirmed | Lines 47, 49, 54; plot x-limits; title and legend |
| A4 | "with the number of nodes increasing" | Confirmed | 3, 4, 5, 6, 7, 9, in frame titles and visible markers |
| A5 | "$S''(a)=S''(b)=0$ at the endpoints" | Confirmed | D4 |
| A6 | "Julia source scripts ... linked under each case" | Confirmed | One case, one link, file exists |
| A7 | "Mathews' Cubic Splines module has no animation" | Confirmed | None of the module's 61 images is multi-frame and the module links none. The only spline animation in `a2001/Animations` is `Quadrature/Spline/Splineaa.gif`, which belongs to the separate spline quadrature module (`SplineQuadMod`) |
| A8 | The $\sin(x)$ example "is new to this page" | Confirmed | No example in the module uses $\sin$ |
| A9 | "each frame can report the spline's maximum error" | Confirmed | Every frame title reports it |
| A10 | "the module's examples interpolate a table of data points with no underlying function" | Confirmed | Images `gr_25`, `gr_34`, `gr_53`: $(0,1),(1,0),(2,0),(3,1),(4,2),(5,2),(6,1)$ |
| A11 | Examples 1 and 2 are natural splines, Example 2 via `SplineFit` | Confirmed | `lnk_2`, `lnk_3` text; `gr_36` shows `SplineFit[XY, Cubic]` |
| A12 | Example 3 is a clamped spline | Confirmed | `lnk_4`; `gr_54`: $S'(0)=-0.2$, $S'(6)=-2.5$ |
| A13 | "one shared set of data points" | Confirmed | The three data images are the same list |
| A14 | Examples 1 to 3 "are not animated here" | Confirmed | The page has one case, on $\sin$ |

### Case 1

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| C1 | Heading: natural cubic spline convergence for $\sin(x)$ | Confirmed | A1, A3 |
| C2 | "Adding nodes shrinks the maximum error rapidly" | Confirmed | 1.0, 0.1088, 0.0200, 0.00896, 0.00407, 0.00107; strictly decreasing (`last.out`) |
| C3 | "$\sin''(0)=\sin''(2\pi)=0$" | Confirmed | $\sin''=-\sin$ |
| C4 | "the natural end conditions are exact" for this $f$ | Confirmed | The spline's end condition equals $f''$ at both ends |
| C5 | "the spline converges at $O(h^4)$, where $h$ is the maximum node spacing" | Confirmed | N=10 to 320: 4.123, 4.013, 4.003, 4.001, 4.000; on a non-uniform mesh against $h_{\max}$: 3.96 to 4.00 |
| C6 | With $f''(a)\neq0$ or $f''(b)\neq0$ the error "falls only as $O(h^2)$" | Confirmed | D9, including the one-nonzero-end case |
| C7 | "The 3 to 9 nodes shown are too few for this rate to show cleanly from frame to frame" | Confirmed | Frame-to-frame observed orders: 5.47, 5.88, 3.60, 4.33, 4.66 |
| C8 | "Each frame uses a fully recomputed spline" | Confirmed | `natural_spline_M` is called inside the animation loop, line 56 |
| C9 | "solving the tridiagonal second-derivative system" | Confirmed | D5 |
| C10 | Source link `cubicsplineaa.jl` | Confirmed | File exists and is the script for this case |
| C11 | Embed `cubicsplineaa.gif` | Confirmed | Byte-identical to a scratch regeneration (`cmp`) |
| C12 | Alt text: "n=3,4,5,6,7,9 nodes" on $[0,2\pi]$ | Confirmed | Line 51; six frames, six distinct hashes |
| C13 | Alt text: "the spline closely tracks the true curve as nodes increase" | Confirmed | Frames and C2 |

### 3. Implementation checks: `cubicsplineaa.jl`

**It is the method it claims to be.** It is a natural cubic spline in the second-derivative ($M$) formulation. Interpolation, $C^2$ continuity and $S''=0$ at both ends together characterise the natural spline uniquely, and I tested those properties directly on the script's own routines, recovering each panel's cubic from four interior samples (`props.out`):

| Data | Max interpolation error | Max $S'$ jump | Max $S''$ jump | Max $|S''|$ at ends |
|---|---|---|---|---|
| Six page frames | 3.5e-15 | 2.4e-14 | 9.6e-14 | 6.5e-14 |
| Random meshes and data, n=5, 9, 17 | 4.7e-14 | 4.1e-11 | 2.2e-8 | 5.7e-11 |

The larger random-mesh values are an artefact of recovering derivatives by a numerical fit on short panels (shortest panel 8.0e-3). Recomputed from the analytic derivative of the script's panel formula on the same random cases (`analytic.out`), the $S'$ jump is at most 1.4e-14, or 3.7e-16 relative to $\max|S'|$, and $M$ is exactly 0 at both ends. $S''$ is continuous by construction, because adjacent panels share the same $M_j$ at their common knot. A linear function is reproduced exactly (error 0, $M=0$).

**The numbers are right.** Script values were printed from a scratch copy of its routines and compared with an independent solver (first-derivative unknowns, Hermite evaluation) and with SciPy's `CubicSpline(bc_type='natural')`.

| Nodes | $h$ | Script (600 pts) | Independent (600 pts) | True max (refined) | At $x$ | Title | Independent vs SciPy |
|---|---|---|---|---|---|---|---|
| 3 | 3.14159 | 0.999997 | 0.999997 | 1.000000 | 4.7124 | 1.0 | 1.7e-31 |
| 4 | 2.09440 | 0.108771 | 0.108771 | 0.108771 | 0.9859 | 0.109 | 8.9e-16 |
| 5 | 1.57080 | 0.0200168 | 0.0200168 | 0.020017 | 2.4460 | 0.02 | 6.9e-16 |
| 6 | 1.25664 | 0.00896494 | 0.00896494 | 0.00896508 | 4.3761 | 0.00896 | 4.9e-16 |
| 7 | 1.04720 | 0.00407061 | 0.00407061 | 0.00407079 | 1.5708 | 0.00407 | 3.3e-16 |
| 9 | 0.78540 | 0.00106607 | 0.00106607 | 0.00106609 | 1.1654 | 0.00107 | 3.3e-16 |

**Its reference values are right.** The reference is $\sin(x)$ evaluated in closed form; there is no numerically computed reference.

**The picture shows what was computed.** All six frames were viewed.

- The committed GIF is byte-identical to a scratch regeneration of a byte-identical script.
- Blue is $\sin(x)$, dashed red is $S(x)$, black markers are the nodes, and the node counts in the titles match the markers.
- The spline's extreme values are at most 1.0000 in magnitude (to 4 decimals) on every frame, so the y-limits of $\pm1.4$ clip nothing.
- The x-limits are the full interval $[0, 2\pi]$.
- No clamping or masking is used.
- Six frames, one per entry of `n_node_list`, with six distinct decoded-frame hashes.

### Could not determine

Nothing on this page was left undetermined.

