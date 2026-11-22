# Verification: newton-interpolation-polynomial

## A1 — confirmed
- What I checked: Copied lines 1–152 of lagnewt_animations_all.jl (definitions only, no rendering) to verify/defs.jl. In verify/check_a1.jl, for every case (01–29) and every frame (n = 2..16 nodes), I evaluated the script's Float64 `barycentric_eval` on the same 1000-point xplot. I compared it with the exact interpolant through the same Float64 nodes and values, computed with Newton divided differences in 512-bit BigFloat. Both were clamped to the frame's ylims the same way the script does (line 190). I flagged plotted points that differ by more than 1% of the y-range. I also viewed committed frames lagnewt04/frame_010.png and lagnewt29/frame_009.png and frame_010.png.
- Evidence (`julia check_a1.jl`): across all 29 cases × 10 frames, only three frames differ:
  - case 04, degree 15: 450/1000 points wrong, starting at x≈5.69
  - case 29, degree 13: 44/1000 points wrong, starting at x≈15.44
  - case 29, degree 15: 488/1000 points wrong, starting at x≈10.59

  At every wrong point the true interpolant is large and positive (|p| ≥ 5.9e7, so the clamp should pin it to the top of the plot), but the Float64 value has the wrong sign. The clamp then sends it to the bottom, which draws the dense vertical bars seen in the frames. Example, case 04 degree 15 at x=8: float −1.81e9 vs true +6.67e11. Case 29 degree 15 at x=22: float −6.9e7 vs true +3.07e13. Case 29 degree 13 at x=20: float +1.85e9 vs true +9.05e10, and it goes negative elsewhere past 15.4.

  The cause is cancellation in the second-form barycentric denominator `den = Σ w_j/(x−x_j)` (lines 125–129). Its exact value is 1/∏(x−x_j), which falls to about 1e-21 (case 29, x=22) and about 3e-16 (case 04, x=10.4). The Float64 rounding noise is about 1e-16 to 1e-12, so `den` comes out with the wrong sign and magnitude. The frames match this: case 04 frame 10 shows bars near x≈5.7, 9.6, 9.9 and 10.4; case 29 frames 9 and 10 show bars over x≈15.4–22 and x≈10.6–21.
- Severity: Error is fair. The plotted curve is computed wrongly; it should be a flat line clamped at the top edge. The bars falsely suggest the interpolant comes back down through the plotting window. The impact is limited to off-scale extrapolation regions in 3 of 290 frames.
- Correction to the allegation: none. The line numbers (116–131, 189), the GIFs and the frames named (lagnewt04 last frame, lagnewt29 last two frames) are all accurate, and no other frame in any case is affected.

## A2 — confirmed
- What I checked: script line 159, `n_nodes_seq = [2, 3, 4, 5, 6, 8, 10, 12, 14, 16]`, together with the title "degree $(n_nodes - 1)". I also read the frame titles on committed/lagnewt01/sheet.png. All 29 GIFs have 10 frames.
- Evidence: the degrees shown are 1, 2, 3, 4, 5, 7, 9, 11, 13, 15. After degree 5 the sequence steps by 2 and skips 6, 8, 10, 12 and 14. The sheet titles confirm this.
- Severity: Error is fair, since the sentence is literally false. The impact is minor: a reader is only misled about which degrees are shown, not about the mathematics.
- Correction to the allegation: none.
