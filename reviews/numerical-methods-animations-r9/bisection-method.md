# Bisection Method — animation review (round 9)

Page: `pages/numerical-methods/bisection-method/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I found no Error, Misleading or Minor findings.

Observations I considered and decided are not findings, with the reasons:

- *Top-panel clamping in case 2.* In `bisectionbb.jl` (lines 105–113), `clamp_y` clamps the plotted midpoints to ±15 in the full view. Examples are c_4 (tan = −18.43, frame 5) and c_8 (tan = 2066.9, frame 9). Those dots sit exactly on the axis-box edge. The legend label gives only the x-value (`c_k = …`), which is correct. The bottom zoom panel draws every midpoint at its true value: −18.4 and +2.07e3 are visible on its y-axis. No y-value is labelled at its clamped level, so a viewer is not told something false.
- *Case 2 zoom y-range.* The zoom panel's y-range is set from |f| at the padded window ends and at the midpoint, as the comment at lines 124–127 says. It does not use f at the bracket ends. So in frames 1–2 the value f(2) = −2.185 lies below the zoom panel, and in frame 4 f(1.5) = 14.1 lies above it. The top panel shows these values, so the sign change the page discusses is still visible. This is a display choice that does not change any conclusion.
- *No `## Description` section.* The authoring conventions ask for one. The review standard says content the page does not yet have is not a finding, so I record this here only. Because there is no Description, no Description formulas could be checked.
- *Fewer iterations than the archive.* The animation runs 12 iterations, while Mathews' notebooks use 30 and 15, and his animations use 20 and 19. The page does not state Mathews' counts, and 12 is enough to show both behaviours. Not a fidelity finding.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `bisectionaa.jl` | 0 | 21.5 | bisectionaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `bisectionbb.jl` | 0 | 18.1 | bisectionbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `bisectionaa.gif` | 13 | byte-identical | bisectionaa |
| `bisectionbb.gif` | 13 | byte-identical | bisectionbb |

### Page references

- Scripts linked: `bisectionaa.jl`, `bisectionbb.jl`
- GIFs embedded: 2
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|
| 1 | "The shaded region marks the current bracket $[a, b]$" | Code: `shade_bracket!(p1, a_cur, b_cur, …)` with `a_cur = as[frame+1]`, the bracket after the step. Frames 4, 10 and 13 show the shading between the blue dashed lines. | confirmed |
| 2 | "when $f$ is continuous on $[a,b]$ and $f(a)$, $f(b)$ have opposite signs, the IVT guarantees that it contains a root" | Standard theorem; the statement is correct. | confirmed |
| 3 | "Each frame computes the midpoint $c=\tfrac{a+b}{2}$, evaluates $f(c)$, and narrows the bracket to the half that still contains the sign change" | Code lines 30–40 (aa) and 33–43 (bb). Frames 1–12 each show one step; frame 0 shows the initial bracket. Every kept half has f(a)f(b) < 0 in both runs (see the tables in section 3). | confirmed |
| 4 | "The top panel shows the full view; the bottom panel zooms in on the bracket from before the current step" | Code: `a_prev = as[max(frame,1)]` and `zx` is that bracket padded by 10%. Zoom titles read "step k halves [a, b] of width w_prev", with w_prev = 3/2^(k−1) (aa) and 2/2^(k−1) (bb), and the gray lines mark the bracket before the step. | confirmed |
| 5 | "…after the bracket becomes narrower than a pixel in the full view (from step 9 on)" | I measured the top-panel plot area at x = 116…588 px, about 472 px for 3.4 units, or 138.8 px per unit. The width after step 8 is 0.01172, which is 1.63 px; after step 9 it is 0.00586, which is 0.81 px. | confirmed (case 1; the sentence refers to that panel geometry) |
| 6 | "Julia source scripts that generated these animations are linked under each case" | Manifest: both scratch regenerations are byte-identical to the committed GIFs. | confirmed |
| 7 | Case 1 heading: "Convergent, $f(x)=x^3+4x^2-10$, $[a_0,b_0]=[-1,2]$" | Script lines 15–16 match. The method converges to the only real root. | confirmed |
| 8 | "$f(-1) = -7 < 0$ and $f(2) = 14 > 0$" | mpmath gives −7.0 and 14.0. | confirmed |
| 9 | "The true root is $x^*\approx 1.3652$" | mpmath `findroot` gives 1.3652300134; `polyroots` gives one real root, and the other two roots are complex at −2.6826 ± 0.3583i. | confirmed |
| 10 | "The bracket width halves each step" | The widths 3, 1.5, …, 0.000732 halve exactly. | confirmed |
| 11 | "error bound $\lvert c_k-x^*\rvert \le (b_0-a_0)/2^k$ shrinks monotonically" | Checked for k = 1…12: every \|c_k − x*\| is at or below 3/2^k. For example k = 12 gives 2.398e−4 ≤ 7.32e−4, and k = 7 gives 1.957e−3 ≤ 2.34e−2. | confirmed |
| 12 | "the midpoints themselves are not monotone and fall on both sides of the root" | The sides of c_k − x* for k = 1…12 are − − + + − + + − − − + −. | confirmed |
| 13 | Case 1 alt text: "bracket narrows around the root at x≈1.3652 over 12 steps, with a lower panel zoomed on each halving" | `n_iters = 12`, giving 13 frames. The final bracket [1.364990, 1.365723] contains 1.365230. The lower panel is present in every frame. | confirmed |
| 14 | Case 1 wiring: `[Julia source](bisectionaa.jl)` and the `bisectionaa.gif` embed | The script is the cubic on [−1, 2], and its GIF title reads "f(x) = x³ + 4x² − 10". | confirmed |
| 15 | Case 2 heading: "Spurious convergence (cautionary), $f(x)=\tan(x)$, $[a_0,b_0]=[0,2]$" | Script lines 18–19 match. It converges to the pole, not to a root. | confirmed |
| 16 | "$f(0)=\tan(0)=0$, so the starting bracket has a genuine root at its left end" | tan(0.0) = 0.0 exactly. | confirmed |
| 17 | "The first midpoint is $c_1 = 1$" | Julia prints `c=1.0`; frame 2 legend reads "c_1 = 1.0". | confirmed |
| 18 | "moves $b$ only when $f(a)f(c)<0$; since $f(0)f(1)=0$ is not negative, it keeps $[1,2]$" | Code line 36. The instrumented copy prints `f(a0)*f(c1) = 0.0`, and the bracket after step 1 is [1.0, 2.0]. | confirmed |
| 19 | "(A variant testing $f(a)f(c)\le 0$ would keep $[0,1]$ and converge to the root at 0.)" | `variant.py` with ≤ gives a final bracket of [0, 0.000488] after 12 steps. | confirmed |
| 20 | "On $[1,2]$, $f(1)=\tan(1)>0$ and $f(2)=\tan(2)<0$" | tan 1 = 1.5574 and tan 2 = −2.1850. | confirmed |
| 21 | "caused by the vertical asymptote at $x=\tfrac{\pi}{2}\approx 1.5708$, not a root: $\tan$ has no zero in $[1,2]$" | π/2 = 1.5707963. The zeros of tan are kπ, and neither 0 nor π lies in [1, 2]. | confirmed |
| 22 | "Bisection converges to the asymptote" | Final bracket [1.5703125, 1.5708008] contains π/2. c_12 − π/2 = 4.45e−6, and \|tan c_k\| grows to 2.24e5. | confirmed |
| 23 | "illustrating that the IVT guarantee requires $f$ to be continuous on $[a,b]$" | tan is discontinuous at π/2 ∈ [1, 2]. | confirmed |
| 24 | Case 2 alt text: "the first step leaves the root at x=0, then the method converges to the asymptote at π/2, not a root … with a lower panel zoomed on each halving" | Frame 2 shows bracket [1, 2]; frame 13 shows bracket [1.57031, 1.57080] around the orange π/2 line. | confirmed |
| 25 | Case 2 wiring: `[Julia source](bisectionbb.jl)` and the `bisectionbb.gif` embed | The script is tan on [0, 2], and its GIF title reads "f(x) = tan(x) [cautionary case]". | confirmed |
| F1 | Fidelity: case 1 is Mathews Example 3, $x^3+4x^2-10=0$ on [−1, 2] | Images gr_647, gr_648 and gr_649 match. The legacy `Bisectionaa.gif` ends at p20 = 1.36523. | confirmed |
| F2 | Fidelity: case 2 is Mathews Example 4, tan x = 0 on [0, 2], "Not a root located … located a pole" | Images gr_813, gr_814 and gr_815 and the lnk_5 note match. Mathews' own rule (`If[Sign[f[b]]==Sign[f[c]], b=c, a=c]`, image gr_11) also gives [1, 2] after step 1, and his table row 1 reads a = 1, c = 1.5, b = 2. The legacy `Bisectionbb.gif` ends at p19 = 1.57080. | confirmed |
| F3 | Fidelity: no archive animation case dropped | The legacy `BisectionMethod.html` lists 2 animations, and both are present. | confirmed |

### 3. Implementation checks

### `bisectionaa.jl` (x³ + 4x² − 10 on [−1, 2], 12 steps)

- **Method.** This is plain bisection: c = (a+b)/2, and the bracket becomes [a, c] if f(a)f(c) < 0 and [c, b] otherwise. There is no safeguard or hybrid step. It is the method named on the page.
- **Numbers.** I instrumented a copy (`review/inst_aa.jl`) and compared it with an independent 40-digit mpmath run (`review/indep.py`). All 12 midpoints agree exactly, because they are dyadic rationals:

  | k | script c_k | independent c_k | script f(c_k) | independent f(c_k) |
  |---|---|---|---|---|
  | 1 | 0.5 | 0.5 | −8.875 | −8.875 |
  | 3 | 1.625 | 1.625 | 4.853515625 | 4.85352 |
  | 7 | 1.3671875 | 1.3671875 | 0.0323558 | 0.0323558 |
  | 9 | 1.361328125 | 1.361328125 | −0.0643102 | −0.0643102 |
  | 12 | 1.364990234375 | 1.364990234 | −0.0039591 | −0.0039591 |

  Final bracket: script [1.364990234375, 1.36572265625]; independent run identical.
- **Reference values.** The quoted root 1.3652 compares with 1.36523001341 from mpmath `findroot`, which has residual 0. The root is unique and real.
- **Picture.** I checked frames 1, 4, 10 and 13. The red dot is at (c_k, f(c_k)), with a dotted drop line to the diamond on the axis. Gray dots mark earlier midpoints. The blue dashed lines and shading show the bracket after the step, and the gray dashed lines in the zoom show the bracket before it. Zoom titles show the correct pre-step widths (3, 1.5, …, 0.00146484375). Legend indices match `cs[frame]`. I printed the zoom tick values (`review/ticks_aa.jl`); for example, frame 12 ticks at 1.3644, 1.3647, … match their labels. No clamping is used. The zoom y-range includes f at a_prev, c and b_prev.

### `bisectionbb.jl` (tan x on [0, 2], 12 steps)

- **Method.** The same plain bisection rule. It uses the strict test f(a)f(c) < 0, and the page names that variant explicitly. Mathews' Sign[f[b]] rule gives the same sequence here; I checked this with `review/variant.py`.
- **Numbers.** I compared the instrumented copy (`review/inst_bb.jl`) with the independent mpmath run:

  | k | script c_k | independent c_k | script tan(c_k) | independent tan(c_k) |
  |---|---|---|---|---|
  | 1 | 1.0 | 1.0 | 1.5574077 | 1.55741 |
  | 2 | 1.5 | 1.5 | 14.10142 | 14.1014 |
  | 5 | 1.5625 | 1.5625 | 120.5325 | 120.533 |
  | 8 | 1.5703125 | 1.5703125 | 2066.855 | 2066.86 |
  | 12 | 1.57080078125 | 1.570800781 | −224494.3 | −224494.0 |

  Final bracket: script [1.5703125, 1.57080078125]; independent run identical. It contains π/2 = 1.5707963268.
- **Reference values.** The asymptote line is drawn at `π/2` exactly. I confirmed tan(0) = 0 exactly in floating point, and f(a0)·f(c1) = 0.0.
- **Picture.** I checked frames 1, 2, 5, 9 and 13. The asymptote is shown as an orange dashed line in both panels. The curve is split at π/2 ± 0.02 in the full view and at ±0.002·w in the zoom, so no false vertical connector is drawn. Top-panel dots are clamped to ±15; the zoom shows true values (see the observation in section 1). Frame 13 shows c_12 at −2.24e5, just right of the asymptote (4.45e−6 ≈ 1.8 px at that zoom), and the bracket [1.57031, 1.57080] straddles π/2. The labels "c_k = …" use the correct indices and round to 6 digits, for example 1.5703125 → 1.570312, which is valid round-half-even. Zoom y ticks match their values (`review/ticks_bb.jl`).

### Legacy archive

Both cases reproduce Mathews' Examples 3 and 4 (the function, the interval, and the "not a root located / pole" behaviour), and the legacy animation endpoints agree: 1.36523 and 1.57080. The archive's animation list has two entries, and the page has both.

