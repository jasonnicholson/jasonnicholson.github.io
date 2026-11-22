# Verification: lagrange-polynomial-interpolation-and-approximation

## A1 — confirmed
- What I checked: script line 159 `n_nodes_seq = [2, 3, 4, 5, 6, 8, 10, 12, 14, 16]`, and frame titles in `committed/lagnewt04/sheet.png`.
- Evidence: the frame titles read degree 1, 2, 3, 4, 5, 7, 9, 11, 13, 15 (10 frames, `nframes` = 10). After degree 5 the degree goes up by 2 per frame. Every case uses the same sequence.
- Severity: Error is fair. The sentence "one step at a time" is literally false for half of the frames. It is easy to fix (say "degrees 1–5, then odd degrees to 15").
- Correction to the allegation: none.

## A2 — confirmed
- What I checked: I ran the script's own node, weight and barycentric code (`verify/lib.jl`, copied from the script) for all 29 cases × 10 frames. I compared it with the same interpolant evaluated in 512-bit BigFloat Lagrange form. Both used the identical Float64 nodes and node values, and both results were clamped to the plot's ylims the way the script does. I flagged plotted points that differ by more than 1% of the y-range.
- Evidence: `verify/check.jl`. Exactly 3 frames out of 290 are wrong:
  - case 04, degree 15: 450/1000 plotted points wrong, starting at x≈5.69. Every bad point has the wrong sign. The true interpolant is huge and positive, so it should be pinned to the top of the plot. Instead the Float64 second-form barycentric result has the wrong sign, which draws the vertical bars at x≈5.7 and 9.6–10.4.
  - case 29, degree 13: 44 points wrong (from x≈15.4), all sign flips.
  - case 29, degree 15: 488 points wrong (from x≈10.6), all sign flips.
  
  These match the bars visible in `committed/lagnewt04/frame_010.png` and `committed/lagnewt29/frame_009.png`, `frame_010.png`. The cause: far outside the nodes, the denominator Σ w_j/(x−x_j) = 1/ℓ(x) is tiny but is computed by catastrophic cancellation, so its sign is random. The second barycentric form is not stable for extrapolation.
- Severity: Error is fair for the three frames, which draw a curve that is not the interpolant. The sentence on line 12 ("numerically stable") is true for evaluation on the node interval (Higham's result), so that sentence alone is narrowly defensible. But the page uses barycentric evaluation to draw extrapolation, and it fails there.
- Correction to the allegation: none needed. The scope is exactly the frames named, and no other frame in any case is affected.

## A3 — confirmed
- What I checked: index.qmd (identical to the snapshot).
- Evidence: line 21 says "the listed node intervals", and all 29 alt texts (lines 31–143) say "from the legacy function-and-interval list". The page has no such list: headings are bare "### Case NN" and no function or interval appears in the text. The functions are visible only in the GIF titles. The node intervals appear nowhere a reader can see; they exist only in the script's `node_span` or as automatic spans.
- Severity: Misleading is fair (it could even be argued to be an Error, since it refers to a list that does not exist). Alt text that points to a nonexistent list also gives screen-reader users nothing.
- Correction to the allegation: minor. The function, though not the interval, can be read from each GIF's title.

## A4 — confirmed (with qualification on how much it matters)
- What I checked: `equal_nodes` (script lines 85–102). I also checked the actual node ends for every case, and compared interpolation error with and without the inset in 60-digit mpmath.
- Evidence: `verify/check.jl` (node ranges) and `verify/a4.py`, `verify/a4b.py`.
  - In every case the inset is exactly 3% of the width at each end. The retry branch that widens it never fires. Examples: case 04 √x, nominal [0,2] → nodes [0.06,1.94]; case 08 → [−0.94,0.94]; case 01 [−1.6,0.9] → [−1.525,0.825].
  - √x [0,2], degree 5/9/15, max error on the node interval:
    - with the inset (on [0.06,1.94]): 1.5e‑2 / 3.4e‑3 / 6.3e‑4
    - with true endpoints (on [0,2]): 1.0e‑1 / 6.8e‑2 / 4.8e‑2
    
    The inset moves the derivative singularity at 0 off the nodes. So the animation shows fast convergence and hides √x's characteristic slow convergence. That is a material change.
  - Runge-type case 08, 1/(1+10x²), degree 15: the max error on [−1,1] is 6.05 with the inset against 0.48 with nodes at ±1. With the inset, the interpolant dives off inside [−1,1] at |x|>0.94 (visible in `committed/lagnewt08/frame_010.png`). The Runge end-oscillations still show in both versions, so the qualitative lesson survives here, but the picture on the nominal interval is changed.
- Severity: Misleading is fair. Nodes are equally spaced inside the stated span, but not on it in the sense of having nodes at the endpoints, and the √x case changes what it teaches.
- Correction to the allegation: the nominal intervals are not actually described on the page (see A3). The mismatch is between the page's claim of equally spaced nodes "on the listed node intervals" plus the script's `node_span` values, and the nodes actually used. The ~3% figure is exact: 3.0% at each end, every case.
