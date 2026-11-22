# Bisection Method — animation review (round 4)

Page: `pages/numerical-methods/bisection-method/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I found no Error, Misleading or Minor finding on this page.

Notes that are not findings, recorded so the clean result can be checked:

- The page has no `## Description` section, although `.github/agents/animation-page.agent.md` (lines 12, 99, 205) requires one. The review standard counts content the page does not yet have as out of scope, so this is not a finding. It does mean there are no Description formulas to check against the scripts.
- In Case 2, the top panel clamps `tan` and the midpoint markers to y in [-15, 15], so from step 4 on the red dot sits on the top or bottom border (for example step 12: drawn at -15, true f(c_12) = -224494.35). The legend labels only the x-value c_k, never f(c_k), and the bottom panel draws every midpoint at its true value. The y-range of the bottom panel is built from |f| at the window ends and at c_k (`bisectionbb.jl` lines 136-139). So the clamped dot is never presented as a real value, and this is an acceptable display device.
- Legend labels use `round(c; digits=6)`, which rounds exact ties to even (c_8 = 1.5703125 is shown as `1.570312`, c_7 = 1.3671875 as `1.367188`). Both are valid 6-decimal roundings of a tie.
- Mathews ran 30 iterations (Example 3) and 15 iterations (Example 4). The page runs 12 iterations (13 frames) for both. This is a frame-count choice and does not change any behaviour the page describes.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `bisectionaa.jl` | 0 | 11.3 | bisectionaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `bisectionbb.jl` | 0 | 10.2 | bisectionbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | Intro l.12-13 | "The shaded region marks the current bracket [a, b]" | `shade_bracket!(p1, a_cur, b_cur, …)`, where a_cur and b_cur are the bracket after the step. Frames show the shading between the blue dashed lines. | confirmed |
| 2 | Intro l.13 | When f is continuous on [a,b] and f(a), f(b) have opposite signs, the IVT guarantees a root | Standard theorem, correctly stated | confirmed |
| 3 | Intro l.14 | "Each frame computes the midpoint c=(a+b)/2, evaluates f(c), and narrows the bracket to the half that still contains the sign change" | Code l.30-40 (aa) and l.33-43 (bb): `c=(a+b)/2`, keep [a,c] if f(a)f(c)<0 and [c,b] otherwise. Frame 0 shows only the initial bracket, which is trivial. | confirmed |
| 4 | Intro l.15 | Top panel shows the full view and the bottom panel zooms on the bracket from before the current step | `a_prev = as[max(frame,1)]`, window [a_prev − 0.1w, b_prev + 0.1w]. Frames show the gray "before" lines at the window edges after padding. | confirmed |
| 5 | Intro l.15 | The bracket becomes narrower than a pixel in the full view "from step 9 on" | I measured the top plot box at columns 115 and 588 (473 px) in frame_001 of both GIFs. Case 1: 3.4/473 = 0.00719 per px. The width after step 8 is 0.01172 (1.63 px) and after step 9 is 0.00586 (0.82 px). Case 2: 2.4/473 = 0.00507 per px. Step 8 gives 0.0078 (1.54 px) and step 9 gives 0.0039 (0.77 px). | confirmed |
| 6 | Intro l.17 | Julia source scripts are linked under each case | The links on lines 24 and 35 point to the existing files | confirmed |
| 7 | Case 1 heading | Convergent, f(x)=x³+4x²−10, [a0,b0]=[−1,2] | `bisectionaa.jl` l.15-16. Matches Mathews Example 3 (gr_647 and gr_648). | confirmed |
| 8 | Case 1 l.21 | f(−1) = −7 < 0, f(2) = 14 > 0 | Python gives −7.0 and 14.0 | confirmed |
| 9 | Case 1 l.22 | True root x* ≈ 1.3652 | mpmath `findroot` gives 1.3652300134. It is the only real root; the other two are the complex pair −2.6826 ± 0.3583i. | confirmed |
| 10 | Case 1 l.22 | Bracket width halves each step; error bound \|c_k − x*\| ≤ (b0−a0)/2^k shrinks monotonically | Widths run 3, 1.5, …, 3/2^12 exactly. For k = 1..12, \|c_k − x*\| is below 3/2^k every time. The largest ratio is k=1: 0.865 against 1.5. | confirmed |
| 11 | Case 1 l.22 | Midpoints are not monotone and fall on both sides of the root | The signs of c_k − x* for k = 1..12 are − − + + − + + − − − + −, and the sequence c_k goes up and down | confirmed |
| 12 | Case 1 alt | Bracket narrows around the root at x≈1.3652 over 12 steps, with a lower zoom panel | n_iters = 12 and the GIF has 13 frames. The final bracket [1.364990234, 1.365722656] contains 1.3652300. The zoom panel is present. | confirmed |
| 13 | Case 1 wiring | Link and embed point at the Case 1 script and GIF | `bisectionaa.jl` and `bisectionaa.gif` show the x³+4x²−10 title. The committed GIF is byte-identical to the regenerated one (manifest). | confirmed |
| 14 | Case 2 heading | Spurious convergence, f(x)=tan(x), [a0,b0]=[0,2] | `bisectionbb.jl` l.18-19. Matches Mathews Example 4 (gr_813 and gr_814). | confirmed |
| 15 | Case 2 l.30 | f(0) = tan(0) = 0, a genuine root at the left end | Float64 `tan(0.0)` = 0.0 | confirmed |
| 16 | Case 2 l.31 | c1 = 1; f(0)f(1)=0 is not negative, so bisection keeps [1,2] | Instrumented run, step 1: a=0, b=2, c=1.0, then a=1.0, b=2.0 | confirmed |
| 17 | Case 2 l.32 | f(1)=tan(1)>0, f(2)=tan(2)<0 | 1.5574077, −2.1850399 | confirmed |
| 18 | Case 2 l.32 | The sign change comes from the asymptote at π/2 ≈ 1.5708, and tan has no zero in [1,2] | The zeros of tan are at kπ: 0, 3.14159, …. π/2 = 1.5707963. | confirmed |
| 19 | Case 2 l.33 | Bisection converges to the asymptote | The final bracket after 12 steps is [1.5703125, 1.57080078125], which contains π/2. c_12 − π/2 = 4.45e−6, and \|f(c_12)\| = 2.24e5 grows instead of shrinking. | confirmed |
| 20 | Case 2 alt | The first step leaves the root at x=0, then the method converges to the asymptote at π/2; lower zoom panel | Frame 2: the gray "before" line is at 0 and the blue bracket is [1,2]. Frame 13: the bracket straddles the orange asymptote line. | confirmed |
| 21 | Case 2 wiring | Link and embed point at the Case 2 script and GIF | `bisectionbb.jl` and `bisectionbb.gif` show the tan(x) title. The committed GIF is byte-identical to the regenerated one. | confirmed |
| 22 | Section index | Page is linked from the Numerical Methods index | `pages/numerical-methods/index.qmd` l.14 | confirmed |

Fidelity check against the archive: Mathews' "Various Scenarios and Animations" section has exactly two examples. Example 3 is the convergent cubic x³+4x²−10 on [−1,2] (Bisection[a,b,30]). Example 4 is "Not a root located", Tan[x] on [0,2] (Bisection[a,b,15]), with the note "The bisection method located a pole". The page reproduces both with the same functions and intervals, and its Case 2 behaviour matches Mathews' note. Examples 1 and 2 (lnk_2 and lnk_3) are static worked examples with no animation: Example 1 uses the cubic on [1,2] for 10 iterations and Example 2 is Bisection[0,1,30]. Omitting them drops no animated case. I found no fidelity departure.

### 3. Implementation checks

### `bisectionaa.jl`

- **Is the method it claims:** The code is plain bisection. It uses c = (a+b)/2 and the sign test f(a)f(c) < 0 to keep [a,c], keeping [c,b] otherwise. It runs a fixed 12 iterations with no tolerance stop. This is the textbook variant without an exact-zero check, which matters only if f(c) = 0 or f(a) = 0, and that never happens here.
- **Numbers are right:** The instrumented Julia copy and the independent Python bisection (`indep.py`, written from the definition) agree on every value to full precision.

  | k | c_k (script = independent) | f(c_k) | bracket after |
  |---|---|---|---|
  | 1 | 0.5 | −8.875 | [0.5, 2] |
  | 2 | 1.25 | −1.796875 | [1.25, 2] |
  | 3 | 1.625 | 4.853515625 | [1.25, 1.625] |
  | 4 | 1.4375 | 1.236083984 | [1.25, 1.4375] |
  | 5 | 1.34375 | −0.350982666 | [1.34375, 1.4375] |
  | 6 | 1.390625 | 0.424594879 | [1.34375, 1.390625] |
  | 7 | 1.3671875 | 0.032355785 | [1.34375, 1.3671875] |
  | 8 | 1.35546875 | −0.160421193 | [1.35546875, 1.3671875] |
  | 9 | 1.361328125 | −0.064310245 | [1.361328125, 1.3671875] |
  | 10 | 1.3642578125 | −0.016046691 | [1.3642578125, 1.3671875] |
  | 11 | 1.36572265625 | 0.008137173 | [1.3642578125, 1.36572265625] |
  | 12 | 1.364990234375 | −0.003959102 | [1.364990234375, 1.36572265625] |

  Property check: the bracket width is exactly 3/2^k, and |c_k − x*| ≤ 3/2^k for every k.
- **Reference values:** The script uses no numerical reference; its header gives "True root ≈ 1.3652". mpmath at 40 digits gives 1.365230013414097, the unique real root, so the header is correct to 4 decimals.
- **Picture shows what was computed:** I viewed frames 1, 4 and 13 and the contact sheet (frames 1, 3, 5, …, 13). The red dot is at (c_k, f(c_k)) on the curve, with a diamond at (c_k, 0) and a dotted drop line between them. The gray dots are the earlier midpoints. The blue dashed lines and the shading show the bracket after the step. The legend `c_k = …` matches the table, for example c_3 = 1.625 and c_12 = 1.36499. In the zoom panel, the gray lines are the bracket before the step and the blue lines the bracket after. The title width is the width before the step (step 3: 0.75; step 12: 0.00146484375 = 3/2^11, as the code intends and the title wording states). The zoom y-range includes 0, f at the window ends and f(c_k). Nothing is clamped. The committed GIF is byte-identical to the regenerated one.

### `bisectionbb.jl`

- **Is the method it claims:** The loop is the same plain bisection, 12 iterations. The f(a)·f(c) = 0 case at step 1 sends the bracket to [1,2], which is exactly what the page and the header describe.
- **Numbers are right:** The instrumented Julia copy and independent Python agree exactly.

  | k | c_k | tan(c_k) | bracket after |
  |---|---|---|---|
  | 1 | 1.0 | 1.5574077 | [1, 2] |
  | 2 | 1.5 | 14.1014199 | [1.5, 2] |
  | 3 | 1.75 | −5.5203799 | [1.5, 1.75] |
  | 4 | 1.625 | −18.4308628 | [1.5, 1.625] |
  | 5 | 1.5625 | 120.5325057 | [1.5625, 1.625] |
  | 6 | 1.59375 | −43.5583604 | [1.5625, 1.59375] |
  | 7 | 1.578125 | −136.4479038 | [1.5625, 1.578125] |
  | 8 | 1.5703125 | 2066.8551897 | [1.5703125, 1.578125] |
  | 9 | 1.57421875 | −292.1894914 | [1.5703125, 1.57421875] |
  | 10 | 1.572265625 | −680.5965439 | [1.5703125, 1.572265625] |
  | 11 | 1.5712890625 | −2029.4853990 | [1.5703125, 1.5712890625] |
  | 12 | 1.57080078125 | −224494.3493166 | [1.5703125, 1.57080078125] |

  The bracket closes on π/2 = 1.5707963268. |f(c_k)| grows without bound, which confirms that the limit is a pole and not a root.
- **Reference values:** The asymptote is drawn at `π/2`, which is correct. The page's 1.5708 is correct to 4 decimals.
- **Picture shows what was computed:** I viewed frames 2 and 13 and the contact sheet. The curve is split at π/2: a ±0.02 gap in the top panel and a ±0.002·w gap in the zoom panel. Both are smaller than the distance from any drawn midpoint to the asymptote, which is at least 4.45e−6, larger than the zoom gap of 1.95e−6 at step 12. So every midpoint lies on a drawn branch. The orange line is at π/2. The top panel clamps as noted above, which is acceptable. The zoom panel shows true values, including f(c_12) ≈ −2.24e5 at the bottom of frame 13 and f(c_8) ≈ +2.07e3 at step 8. In frame 2, the root at x = 0 is visible in the zoom, the gray "before" line is at 0, and the bracket after the step is [1,2], which matches the page's narrative. The legend labels match the table. The committed GIF is byte-identical to the regenerated one.

