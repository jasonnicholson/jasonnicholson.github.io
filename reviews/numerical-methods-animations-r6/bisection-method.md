# Bisection Method — animation review (round 6)

Page: `pages/numerical-methods/bisection-method/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I found no Error, Misleading or Minor finding.

Notes that are not findings under the review standard:

- The page has no `## Description` section, although `.github/agents/animation-page.agent.md` (lines 12, 99, 205) requires one. This is missing content, which the standard says not to report as a finding. As a result there are no Description formulas to check against the scripts.
- The intro says "Each frame computes the midpoint". Frame 1 of each GIF is the initial bracket and has no midpoint. The 13 frames are the initial frame plus 12 steps, and the alt text for Case 1 says "over 12 steps", which is correct. A reader is not misled.
- Case 2, top panel. From step 4 on, the midpoint dots and their dotted drop lines sit at the clamped values y = ±15 (`clamp_y`, `bisectionbb.jl` lines 105 and 110). This is a readability device. The clamped curve leaves the window at the same place. The legend reports only c_k, not f(c_k). The bottom panel draws f(c_k) at its true value: +1.21e2, −2.24e5 and so on, all checked in the frames. A viewer's conclusion does not change.
- The legend rounds c with `round(c; digits=6)`. This gives `c_8 = 1.570312` for the exact tie 1.5703125, and `c_12 = 1.36499` (trailing zero dropped). Both are valid roundings of the true values.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `bisectionaa.jl` | 0 | 11.5 | bisectionaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `bisectionbb.jl` | 0 | 9.7 | bisectionbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

Each claim is quoted from `index.qmd` unless marked as a script header.

| # | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|
| 1 | "The shaded region marks the current bracket $[a, b]$" | Both scripts call `shade_bracket!(p1, a_cur, b_cur, ylims)` with `a_cur = as[frame+1]`, the bracket after the step. In the frames, the shading lies between the blue dashed lines (e.g. aa frame 2: [0.5, 2]; bb frame 13: [1.5703125, 1.57080078]) | confirmed |
| 2 | "when $f$ is continuous on $[a, b]$ and $f(a)$, $f(b)$ have opposite signs, the IVT guarantees that it contains a root" | Standard theorem, stated correctly | confirmed |
| 3 | "Each frame computes the midpoint $c=\tfrac{a+b}{2}$, evaluates $f(c)$, and narrows the bracket to the half that still contains the sign change" | Code: `c=(a+b)/2`. If `f(a)f(c)<0` keep [a,c], else keep [c,b]. That is bisection. Frame 1 is the initial bracket with no step (see the note above) | confirmed (frame 1 is the initial state) |
| 4 | "The top panel shows the full view; the bottom panel zooms in on the bracket from before the current step" | Code: `zx = (a_prev − 0.1w, b_prev + 0.1w)` with `a_prev = as[frame]`, the bracket before the step. Frames show gray "[a,b] before step k" lines at the window's 10% insets | confirmed |
| 5 | "…narrower than a pixel in the full view (from step 9 on)" | Pixel measurement of the top-panel blue bracket lines (`px.py`). Case 1: x=−1 at col 143, x=2 at col 560, so 139 px/unit. Width after step 8 = 0.0117, which is 1.63 px (cols 470 and 472). After step 9 = 0.00586, which is 0.81 px (cols 471–472, merged). Case 2: 196.5 px/unit. After step 8: 1.54 px (cols 464–465). After step 9: 0.77 px (single col 464) | confirmed |
| 6 | "13 frames / 12 steps" (implied; alt text "over 12 steps") | `n_iters = 12`, `@animate for frame in 0:n_iters` gives 13 frames. The manifest counts 13 frames per GIF | confirmed |
| 7 | Case 1 heading: $f(x)=x^3+4x^2-10$, $[a_0,b_0]=[-1,2]$ | `bisectionaa.jl` lines 15–16. GIF title "f(x) = x³ + 4x² − 10", frame 1 "Initial bracket [-1.0, 2.0]" | confirmed |
| 8 | "Convergent" | Brackets nest down to [1.364990234375, 1.36572265625] containing x* (indep.py) | confirmed |
| 9 | "$f(-1) = -7 < 0$ and $f(2) = 14 > 0$" | indep.py: f(−1) = −7, f(2) = 14 | confirmed |
| 10 | "The true root is $x^* \approx 1.3652$" | numpy roots: 1.36523001 (the only real root; the other two are −2.6826 ± 0.3583i). mpmath findroot: 1.3652300134140968 | confirmed |
| 11 | "The bracket width halves each step" | Instrumented widths 3, 1.5, 0.75, …, 0.00146484375, then 0.000732 after step 12 | confirmed |
| 12 | "the error bound $\lvert c_k - x^*\rvert \le (b_0-a_0)/2^k$ shrinks monotonically" | indep.py checks \|c_k − x*\| ≤ 3/2^k for k=1..12: all true (e.g. k=12: 2.40e−4 ≤ 7.32e−4). The bound 3/2^k decreases strictly | confirmed |
| 13 | "the midpoints themselves are not monotone and fall on both sides of the root" | Signs of c_k − x*: L, L, R, R, L, R, R, L, L, L, R, L. The sequence 0.5, 1.25, 1.625, 1.4375, … is not monotone | confirmed |
| 14 | Case 1 alt: "bracket narrows around the root at x≈1.3652 over 12 steps, with a lower panel zoomed on each halving" | Frames 2–13 show 12 steps. In the last frame the bracket [1.36499, 1.36572] contains the zero crossing of the curve in the zoom panel | confirmed |
| 15 | Case 1 link `bisectionaa.jl` and embed `bisectionaa.gif` | The script writes `bisectionaa.gif`. The manifest shows the regenerated GIF is byte-identical to the committed one | confirmed |
| 16 | Case 2 heading: $f(x)=\tan(x)$, $[a_0,b_0]=[0,2]$ | `bisectionbb.jl` lines 18–19. GIF title "f(x) = tan(x) [cautionary case]", frame 1 "Initial bracket [0.0, 2.0]" | confirmed |
| 17 | "$f(0)=\tan(0)=0$, so the starting bracket has a genuine root at its left end" | tan 0 = 0 | confirmed |
| 18 | "The first midpoint is $c_1 = 1$; since $f(0)\,f(1) = 0$ is not negative, bisection keeps $[1, 2]$ and walks away from that root" | Instrumented: k=1 c=1, new=[1, 2]. Code takes the `else` branch when the product is 0. Frame 2 shows bracket [1,2] with the gray "before" line at 0 | confirmed |
| 19 | "On $[1, 2]$, $f(1) = \tan(1) > 0$ and $f(2) = \tan(2) < 0$" | tan 1 = 1.5574, tan 2 = −2.1850 (mpmath) | confirmed |
| 20 | "the vertical asymptote at $x = \tfrac{\pi}{2} \approx 1.5708$" | π/2 = 1.5707963 | confirmed |
| 21 | "$\tan$ has no zero in $[1, 2]$" | Zeros of tan are kπ, and none of them lie in [1, 2] (0 < 1, π > 2) | confirmed |
| 22 | "Bisection converges to the asymptote" | Every bracket from step 1 to step 12 contains π/2. c_12 = 1.57080078125 and c_12 − π/2 = +4.45e−6. The final bracket [1.5703125, 1.57080078125] has width 4.9e−4 and contains π/2. \|f(c_k)\| grows to 2.24e5 | confirmed |
| 23 | "illustrating that the IVT guarantee requires $f$ to be continuous on $[a, b]$" | f(1)f(2) < 0 on [1, 2], but tan is discontinuous at π/2 ∈ [1, 2] | confirmed |
| 24 | Case 2 alt: "the first step leaves the root at x=0, then the method converges to the asymptote at π/2, not a root, … with a lower panel zoomed on each halving" | Frames 2 and 13, and the instrumented iterates | confirmed |
| 25 | Case 2 link `bisectionbb.jl` and embed `bisectionbb.gif` | The script writes `bisectionbb.gif`. The regenerated GIF is byte-identical | confirmed |
| 26 | Script header (aa): "(Mathews, Bisection Method module, Example 3)", "True root ≈ 1.3652" | Archive Example 3 "Convergence": x³+4x²−10 = 0 on [a,b] = [−1, 2] (`gr_647`, `gr_648`, `gr_649`) | confirmed |
| 27 | Script header (bb): "(Mathews, … Example 4)", sign change "due to the asymptote at π/2 ≈ 1.5708" | Archive Example 4 "Not a root located": Tan[x] = 0 on [0, 2] (`gr_813`, `gr_814`, `gr_815`). Mathews: "The bisection method located a pole" | confirmed |
| 28 | GIF legend and title values (c_k labels, "Zoom: step k halves [a, b] of width w") | Legends and titles in frames 2, 4, 10 and 13 (aa) and 2, 6 and 13 (bb) match the instrumented c_k and w_prev, e.g. "c_9 = 1.361328" and "width 0.01171875"; "c_12 = 1.570801" and "width 0.0009765625" | confirmed |

### 3. Implementation checks

### `bisectionaa.jl` (Case 1)

- **Is it the method it claims to be?** Yes. It is classical bisection with fixed iteration count. The sign test uses f(a)·f(c) < 0, so it keeps [a, c] or else [c, b]. Mathews' subroutine (`gr_646`) tests `Sign[f[b]] == Sign[f[c]]`. The two rules choose the same half whenever f(a), f(b) and f(c) are nonzero. They differ only when f(c) or f(a) is 0, and no such case arises here.
- **Are the numbers right?** I instrumented a copy (`review/instr_aa.jl`, the script's own parameter and loop code with printing added). I computed bisection independently in exact rationals, using Mathews' sign rule (`review/indep.py`). All 12 midpoints and brackets agree exactly:

  | k | script c_k | independent c_k | f(c_k) (script) | new bracket |
  |---|---|---|---|---|
  | 1 | 0.5 | 0.5 | −8.875 | [0.5, 2] |
  | 2 | 1.25 | 1.25 | −1.796875 | [1.25, 2] |
  | 3 | 1.625 | 1.625 | 4.8535 | [1.25, 1.625] |
  | 4 | 1.4375 | 1.4375 | 1.2361 | [1.25, 1.4375] |
  | 5 | 1.34375 | 1.34375 | −0.35098 | [1.34375, 1.4375] |
  | 6 | 1.390625 | 1.390625 | 0.42459 | [1.34375, 1.390625] |
  | 7 | 1.3671875 | 1.3671875 | 0.032356 | [1.34375, 1.3671875] |
  | 8 | 1.35546875 | 1.35546875 | −0.16042 | [1.35546875, 1.3671875] |
  | 9 | 1.361328125 | 1.361328125 | −0.064310 | [1.361328125, 1.3671875] |
  | 10 | 1.3642578125 | 1.3642578125 | −0.016047 | [1.3642578125, 1.3671875] |
  | 11 | 1.36572265625 | 1.36572265625 | 0.0081372 | [1.3642578125, 1.36572265625] |
  | 12 | 1.364990234375 | 1.364990234375 | −0.0039591 | [1.364990234375, 1.36572265625] |

  The sequence also matches Mathews' legacy animation, allowing for its index offset. Mathews labels p_1 = 1.25, p_4 = 1.39063 (the script's c_6 = 1.390625) and p_11 = 1.36499. Property check: |c_k − x*| ≤ 3/2^k holds for all k.
- **Is the reference value right?** The page states x* ≈ 1.3652. Independently, x* = 1.36523001341 (numpy.roots and mpmath.findroot agree). It is the only real root.
- **Does the picture show what was computed?** I viewed frames 1, 2, 4, 10 and 13 and the contact sheet. The red dot sits at (c_k, f(c_k)) on the curve, with a diamond at (c_k, 0). The shading and blue lines show the post-step bracket. The zoom window is the pre-step bracket padded by 10%, with gray dashed lines at the pre-step endpoints. The curve's zero crossing lies inside the shaded bracket in every zoom frame I checked. The titles name the code's function. The top-panel axis limits [−1.2, 2.2] × [−12, 16] contain every midpoint value (|f(c_k)| ≤ 8.875). There is no clamping. The committed GIF is byte-identical to the regenerated one (manifest).

### `bisectionbb.jl` (Case 2)

- **Is it the method it claims to be?** Yes. It has the same loop as Case 1. When f(a)·f(c) = 0 at step 1, it takes the `else` branch and keeps [1, 2], as the page says. Mathews' rule gives the same choice: Sign[tan 2] ≠ Sign[tan 1], so a = c. Mathews' legacy animation also shows I_1 = {1, 2}.
- **Are the numbers right?** Instrumented copy `review/instr_bb.jl` against the independent mpmath run (`indep.py`, 40 digits):

  | k | script c_k | independent c_k | tan(c_k) script / indep | new bracket | c_k − π/2 |
  |---|---|---|---|---|---|
  | 1 | 1.0 | 1 | 1.557408 / 1.557408 | [1, 2] | −5.71e−1 |
  | 2 | 1.5 | 1.5 | 14.10142 / 14.10142 | [1.5, 2] | −7.08e−2 |
  | 3 | 1.75 | 1.75 | −5.520380 / −5.520380 | [1.5, 1.75] | +1.79e−1 |
  | 4 | 1.625 | 1.625 | −18.43086 / −18.43086 | [1.5, 1.625] | +5.42e−2 |
  | 5 | 1.5625 | 1.5625 | 120.5325 / 120.5325 | [1.5625, 1.625] | −8.30e−3 |
  | 6 | 1.59375 | 1.59375 | −43.55836 / −43.55836 | [1.5625, 1.59375] | +2.30e−2 |
  | 7 | 1.578125 | 1.578125 | −136.4479 / −136.4479 | [1.5625, 1.578125] | +7.33e−3 |
  | 8 | 1.5703125 | 1.5703125 | 2066.855 / 2066.855 | [1.5703125, 1.578125] | −4.84e−4 |
  | 9 | 1.57421875 | 1.57421875 | −292.1895 / −292.1895 | [1.5703125, 1.57421875] | +3.42e−3 |
  | 10 | 1.572265625 | 1.572265625 | −680.5965 / −680.5965 | [1.5703125, 1.572265625] | +1.47e−3 |
  | 11 | 1.5712890625 | 1.5712890625 | −2029.485 / −2029.485 | [1.5703125, 1.5712890625] | +4.93e−4 |
  | 12 | 1.57080078125 | 1.57080078125 | −224494.3 / −224494.3 | [1.5703125, 1.57080078125] | +4.45e−6 |

  Every bracket contains π/2, and none contains a zero of tan. This agrees with Mathews' legacy frames, e.g. I_4 = {1.5, 1.625} and I_12 = {1.57031, 1.57080}.
- **Are the reference values right?** π/2 = 1.5707963. The asymptote line in the code is drawn at `π/2`. The zeros of tan are kπ, so 0 is a genuine root and no zero lies in [1, 2].
- **Does the picture show what was computed?** I viewed frames 1, 2, 6 and 13 and the contact sheet. The orange dashed asymptote is at π/2. The curve is split at π/2 ± 0.02 in the top panel and ± 0.002·w in the zoom, so no false vertical connector is drawn. In the zoom panel the y-range is ±1.1·max|f| at the window ends and the midpoint, so the midpoint is drawn at its true value. Examples: frame 6 shows +1.21e2 and frame 13 shows −2.24e5. In frame 13 the c_12 point at 1.570801 lies just right of the asymptote, on the negative branch, consistent with tan(c_12) = −2.24e5. The top-panel clamping to ±15 is discussed in the Section 1 notes and is not a finding. The root at x = 0 is visible in frames 1–2 (x-limits start at −0.2). The committed GIF is byte-identical to the regenerated one.

### Fidelity to the legacy archive

The page's two cases are Mathews' Example 3 (Convergence, x³+4x²−10 on [−1, 2]) and Example 4 (Not a root located, Tan[x] on [0, 2]). These are the only two bisection animations in the archive (`a2001/.../BisectionMethod.html` lists "Bisection Method 1, 2"). The functions, intervals and described behaviour match. Mathews ran 30 and 15 iterations in the notebook and about 20 and 18 frames in the animations, where the page uses 12 steps. This does not change what the reader learns, so it is not a fidelity finding. Examples 1 and 2 (the cubic in Example 1 with Bisection[0,1,30]) are text-only exercises with no animation in the archive, and the page does not include them.

