# Cubic Splines — animation review (round 3)

Page: `pages/numerical-methods/cubic-splines/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1: Fidelity, Minor: the Mathews data-point example is replaced by sin(x), and no reason is given

- **Location:** `index.qmd` lines 25 and 37–38: "The animation below shows a natural cubic spline fitted to equally-spaced data from $f(x) = \sin(x)$ on $[0, 2\pi]$ …" and "the $\sin(x)$ example above is new to this page rather than taken from that module. The module's Examples 1–3 … are not animated here."
- **What is there now:** The only case animates natural splines of sin(x) with 3 to 9 nodes. Mathews' module has no animation. Its worked examples all use one data set, (0,1),(1,0),(2,0),(3,1),(4,2),(5,2),(6,1). The natural spline uses S''(0)=S''(6)=0 (Examples 1 and 2) and the clamped spline uses S'(0)=−0.2, S'(6)=−2.5 (Example 3). The page does not animate either one, and it does not show the natural/clamped contrast that the module builds up.
- **Evidence:** The data image is identical in all three examples: `md5sum` of gr_25, gr_34 and gr_53 = `20be64a49ca1b3b3082ebc619ecf5641`. I viewed gr_26 ("S''(0) = 0 and S''(6) = 0") and gr_54 ("S'(0) = -0.2 and S'(6) = -2.5"). The graphs gr_28 (natural) and gr_56 (clamped) show different end behaviour. The site conventions (`.github/agents/animation-page.agent.md` lines 13 and 71) say that when no legacy GIF exists, the parameters should be reconstructed from the worked examples.
- **Why only Minor:** The page states the substitution and the omission openly (lines 37–38), so a reader is not deceived. What is missing is a reason, and any case built on the archive's own example.
- **Suggested correction:** Either give a one-line reason for choosing sin(x) (it is a smooth function with a known closed form, so the error can be measured), or add a case from the shared Mathews data: natural versus clamped (S'(0)=−0.2, S'(6)=−2.5) on the same axes.

No other findings.

**Observations that are not findings:**
- In frames 4–6 the right-hand end of the title is clipped (the closing parenthesis is partly cut off, for example "max err ≈ 0.00107)"). All digits of the error value can still be read, so nothing is misleading.
- With 3 nodes, every data value is sin(0)=sin(π)=sin(2π)=0, so frame 1's spline is identically zero and its max error is 1.0. This is computed correctly and is consistent with the page, which makes no claim about frame 1 beyond the node list.

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `cubicsplineaa.jl` | 0 | 5.5 | cubicsplineaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Claim (page wording) | Where | Verdict | Evidence |
|---|---|---|---|---|
| 1 | "a piecewise-cubic interpolant … each panel polynomial $S_i(x)$ interpolates endpoint values" | Description l.12 | confirmed | The script's spline reproduces the data at the nodes to ≤2.2e-16 (`instr.jl`, `noderes`) |
| 2 | "enforces continuity of $S$, $S'$, $S''$ at interior knots" | l.12–13 | confirmed | `deriv.jl`: the one-sided FD jumps in S′ and S″ at the knots are O(step) (~1e-5 with step 1e-5), i.e. no real jumps. The Julia S equals SciPy's C² natural spline to ≤1.3e-15 |
| 3 | Natural BC $S''(x_0)=S''(x_n)=0$ | l.15–19 | confirmed | Script `M[1]=M[end]=0` (l.29–30). FD S″ at the ends is ~1e-6 |
| 4 | "The unknown second derivatives are found from a tridiagonal linear system, then each cubic panel is reconstructed" | l.21 | confirmed | Script l.20–30 builds the tridiagonal system `h_j, 2(h_j+h_{j+1}), h_{j+1}` with RHS 6·(divided-difference jump); l.42–44 is the standard M-form panel formula. M agrees with SciPy (for example n=9: ±0.744150, ±1.052387) |
| 5 | Clamped or not-a-knot: max error $O(h^4)$ | l.21 | confirmed | `indep.py`, exp on [0,1]: clamped orders 3.98, 3.99, 4.00, 4.00, 4.00; not-a-knot 3.91, 3.95, 3.98, 3.99, 3.99 |
| 6 | Natural: "only $O(h^2)$ unless $f''(a)=f''(b)=0$" | l.21 | confirmed | cos on [0,2π]: orders 2.09, 2.02, 2.01, 2.00, 2.00. exp on [0,1]: 2.00 throughout |
| 7 | "that error sits near an end where $f''\neq0$, and away from the ends the error is still $O(h^4)$" | l.21 | confirmed | On the middle half of the interval: cos orders 4.81, 4.03, 4.01, 4.00, 4.00; exp orders tend to 3.99, 4.00 |
| 8 | "natural cubic spline fitted to equally-spaced data from $f(x)=\sin(x)$ on $[0,2\pi]$" | Animations intro l.25 | confirmed | Script l.47, l.54: `range(0, 2π, length=nn)`, `f(x)=sin(x)` |
| 9 | "with the number of nodes increasing" | l.25 | confirmed | `n_node_list = [3,4,5,6,7,9]`. Frame titles read 3,4,5,6,7,9 |
| 10 | "The natural spline satisfies $S''(a)=S''(b)=0$" | l.25 | confirmed | as #3 |
| 11 | "Julia source scripts … are linked under each case" | l.27 | confirmed | l.33 links `cubicsplineaa.jl`, which exists and is the producing script |
| 12 | Case heading "Natural cubic spline convergence for $\sin(x)$" | l.29 | confirmed | The script is a natural spline of sin, and the frames show the error decreasing |
| 13 | "Adding nodes shrinks the maximum error rapidly" | Behavior l.31 | confirmed | Max error (fine grid, 4e5 points, SciPy): 1.000, 0.108771, 0.020017, 0.008965, 0.004071, 0.001066, which is monotone, ≈1000× over the animation |
| 14 | "natural end conditions are exact, since $\sin''(0)=\sin''(2\pi)=0$" | l.31 | confirmed | −sin(0) = −sin(2π) = 0 |
| 15 | "so the spline converges at $O(h^4)$, where $h$ is the maximum node spacing" | l.31 | confirmed | sin natural, n=9→257: orders 4.66, 4.08, 4.02, 4.01, 4.00, 4.00 |
| 16 | "for a smooth $f$ with $f''(a)\neq0$ or $f''(b)\neq0$ the natural spline's maximum error falls only as $O(h^2)$" | l.31 | confirmed | as #6 |
| 17 | "The 3 to 9 nodes shown are too few for this rate to show cleanly from frame to frame" | l.31 | confirmed | Observed orders between successive frames: 5.47, 5.88, 3.60, 4.33, 4.66, which scatter around 4 and are not clean. (Frames n=5→9, where h is halved, give a ratio of 18.8 ≈ 2^4.23. The page's claim concerns frame-to-frame, so it stands.) |
| 18 | "Each frame uses a fully recomputed spline (solving the tridiagonal second-derivative system) for the new set of nodes" | l.31 | confirmed | Script l.54–57, inside the `@animate` loop |
| 19 | Link `[Julia source](cubicsplineaa.jl)` | l.33 | confirmed | The file exists, and its regeneration reproduces the GIF byte for byte |
| 20 | Embed `cubicsplineaa.gif` | l.35 | confirmed | The file exists, has 6 frames, and matches the script output |
| 21 | Alt text: "…sin(x) on [0, 2pi] with n=3,4,5,6,7,9 nodes" | l.35 | confirmed | Frame titles 3,4,5,6,7,9 |
| 22 | Alt text: "the spline closely tracks the true curve as nodes increase" | l.35 | confirmed | Frames 3–6 visually coincide. The max error falls to 1.07e-3, against a y-range of 2.8 |
| 23 | Frame titles "max err ≈ 1.0 / 0.109 / 0.02 / 0.00896 / 0.00407 / 0.00107" | GIF | confirmed | The script's 600-point error rounded to 3 s.f. The SciPy fine-grid values above agree with all of them at that precision (0.020017 is shown as 0.02 because `round(…, sigdigits=3)` drops trailing zeros) |
| 24 | Legend: blue = f(x)=sin(x), red dashed = S(x), black dots = data nodes | GIF | confirmed | Script l.67–70, frames 1, 4, 6 viewed |
| 25 | "Mathews' Cubic Splines module has no animation" and the description of Examples 1–3 (natural, natural via SplineFit, clamped, one shared data set) | l.37–38 | confirmed (legacy-inventory section, checked for the fidelity finding only) | The module HTML links only lnk_1–4, the .nb, and Prog/Proof/Bib pages. `a2001/Animations/Interpolation` has no spline folder. The "Natural Cubic Spline" animation in Animations7.html belongs to the Spline Quadrature module. The point images are identical (md5 above), and gr_26/gr_54 show the BCs |

### 3. Implementation checks: `cubicsplineaa.jl`

**It is the method it claims to be.** It is a natural cubic spline in the second-derivative (M) formulation. The interior M are found from the standard tridiagonal system, M₀ = Mₙ = 0, and each panel is evaluated with the standard M-form cubic. No other variant or simplification is involved. The page's Description names the same formulation.

**The numbers are right.** I instrumented a scratch copy (`review/instr.jl`) and checked it independently with SciPy `CubicSpline(bc_type='natural')` (`review/indep.py`, run with `/usr/bin/python3 -I`).

| nodes | script M (interior) | SciPy M (interior) | script err (600 pts) | script err (2e5 pts) | SciPy err (4e5 pts) | title |
|---|---|---|---|---|---|---|
| 3 | ≈0 (−7.4e-17) | 0 | 0.9999966 | 1.0 | 1.000000 | 1.0 |
| 4 | −1.184581, 1.184581 | −1.184581, 1.184581 | 0.1087710 | 0.1087710 | 0.108771 | 0.109 |
| 5 | −1.215854, 0, 1.215854 | same | 0.0200168 | 0.0200170 | 0.020017 | 0.02 |
| 6 | −1.081379, −0.668329, 0.668329, 1.081379 | same | 0.0089649 | 0.0089651 | 0.00896508 | 0.00896 |
| 7 | −0.947665, −0.947665, 0, 0.947665, 0.947665 | same | 0.0040706 | 0.0040708 | 0.00407079 | 0.00407 |
| 9 | −0.744150, −1.052387, −0.744150, 0, 0.744150, 1.052387, 0.744150 | same | 0.0010661 | 0.0010661 | 0.00106609 | 0.00107 |

- I compared the script's spline routine (`review/funcs.jl`, lines 10–45 of the script) evaluated on 20001 points with SciPy's. The maximum difference was 1.29e-15, 9.2e-16, 8.9e-16, 8.9e-16 and 9.2e-16 for n=4, 5, 6, 7, 9.
- The node residual is ≤2.2e-16.
- S′ and S″ are continuous at the knots, and S″ is ≈0 at both ends (`review/deriv.jl`).
- The 600-point sampling of the max error matches the fine-grid value to the 3 s.f. shown in every frame.

**Its reference values are right.** The reference curve is `sin` itself, evaluated in closed form, so there is no numerical reference to verify.

**The picture shows what was computed.** I viewed the contact sheet and frames 1, 4 and 6.
- The blue curve is sin, the red dashed curve is the computed S, and the black dots are (xs, sin xs).
- Titles report the node count and the computed max error with the right value.
- `ylims=(-1.4, 1.4)` contains everything, since |S| ≤ ~1.0 in all frames. There is no clamping or masking.
- There are 6 frames at 2 fps, which matches `n_node_list`.
- The visible gap between S and sin in frame 2 (n=4, error 0.109) and the near-coincidence from n=5 on agree with the computed errors.
- The only display issue is the slight title clipping noted above, which is not misleading.

