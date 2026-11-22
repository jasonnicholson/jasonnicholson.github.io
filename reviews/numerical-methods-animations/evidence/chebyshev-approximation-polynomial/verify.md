# Verification: chebyshev-approximation-polynomial

## A1 — confirmed
- What I checked: `node_count_sequence` (script lines 158–179) and the frame counts and titles of the committed GIFs.
- Evidence: For max_order=15 (every case except 08) the node counts are [2,3,4,5,6,8,10,12,14,16], so the degrees are 1,2,3,4,5,7,9,11,13,15 (10 frames; `committed/*/nframes` = 10). For case 08 (max_order=31) the sequence is [2..6,8,...,16,20,24,28,32], so the degrees are 1..5,7,9,11,13,15,19,23,27,31 (14 frames, nframes = 14). The legible case-19 titles read "degree 1,2,3,4,5,7,9" (verify/titles_19.png). Committed cheby19/frame_009.png has 14 red nodes, so degree 13, consistent with the sequence.
- Severity: Error is fair. The sentence "increases polynomial degree one step at a time" is literally false for every animation: steps of 2 after degree 5, and steps of 4 after degree 15 in case 08. The practical impact is small.
- Correction to the allegation: none. Scope is all 29 cases, not only case 08.

## A2 — confirmed
- What I checked: How case 19's approximation interval is resolved. It uses `auto_span` (line 42), so `resolved_span` falls back to `finite_support` (lines 64–84), which keeps only the grid points where asin is finite. I also checked the GIF titles.
- Evidence: numpy `linspace(-1.5,1.5,2200)` restricted to |x|<=1 gives endpoints ±0.9993178717598908. `fmt_num` gives "-0.999, 0.999". Every frame title in cheby19 reads "interval [-0.999, 0.999]" (verify/titles_19.png), and the nodes all lie inside (-1,1). [-1.5, 1.5] is only the plot's x-range. asin is not real-valued on most of it, so it cannot be the approximation interval. Elsewhere on the page "interval" means the node interval (e.g. case 04 says [0, 4] while xlims is [0, 10.5]).
- Severity: Error is fair. The stated number is wrong. It is a minor alt-text error.
- Correction to the allegation: none of substance. The interval is ±0.99932, which the title shows as ±0.999.

## A3 — confirmed with correction
- What I checked: Pixel extents of the title row (rows 0–29) in every frame of every GIF (verify/title_extent.txt), plus enlarged crops of the right ends of the titles: verify/titles_19.png, titles_20.png, titles_21.png, edge_zoom.png, c20f10_edge.png, titles_other.png.
- Evidence:
  - Case 19: frames 1–7 show "degree 1,2,3,4,5,7,9". The digit touches the right edge but is legible. Frames 8–10, which are degrees 11, 13 and 15, show only "degree 1". The second digit is clipped off completely (column 757 onward is white after the "1"), so these frames display the wrong degree.
  - Case 20: no legible degree number in any of the 10 frames. Frames 1–7 end at "degree". Frames 8–10 show "degree" followed by a single grey column of pixels at x=759 (gray 57–91), the leftmost edge of the clipped "1". That is not a readable digit.
  - Case 21: all 10 frames end at "degree" with no digit.
  - Other cases whose titles reach the edge (07, 12, 13, 27, 28, 29): the degree is clipped at the edge but still legible ("degree 1", "degree 15").
- Severity: Error is fair for case 19, because three frames assert degree 1 when the degree is 11, 13 or 15. For cases 20 and 21 the defect is missing information rather than a false statement (closer to Misleading or a presentation defect). Together they justify an Error-level fix: shorten or wrap the title, or enlarge the figure.
- Correction to the allegation: Case 20 does not display a wrong degree. In all 10 of its frames, not just some, no legible degree appears; frames 8–10 show only a 1-pixel sliver. Only case 19 (frames 8–10) shows an incorrect degree.
