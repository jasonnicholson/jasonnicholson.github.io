# Verification: adaptive-simpsons-rule

## A1 — confirmed
- What I checked: I wrote my own recursive adaptive Simpson for f(x)=1+e^{-x}sin(8x^{2/3}) on [0,2] with eps=1e-3 and ran it several ways: tolerance kept at eps at every level or halved at each split (the usual Lyness/textbook convention), with and without the Richardson (+(S2-S)/15) correction, and acceptance thresholds 15*eps, 10*eps and 1*eps. I compared each final node set with the script's last node set (41 points, lines 13–34) and against a high-precision reference integral. I also scanned the threshold factor k in |S2-S| < k*eps to find which values reproduce the animation's partition.
- Evidence: verify/asr.py, verify/scan.py. Reference integral (mpmath) = 2.0162797196.
  - Page criterion 15*eps, eps halved at each split (standard): 19 nodes {0,1/64,1/32,3/64,1/16,3/32,1/8,3/16,1/4,3/8,1/2,5/8,3/4,7/8,1,5/4,3/2,7/4,2}, smallest panel 1/32, S = 2.0160635 (err -2.2e-4).
  - Page criterion 15*eps, eps not split: 11 nodes, smallest panel 1/4, S = 2.0130 (err -3.3e-3).
  - With 10*eps (Mathews-style) and halving: 21 nodes.
  - The animation's 41-node set, which goes down to h = 2^-12 near x=0, is reproduced exactly only by |S2-S| < k*eps with halving and k in about [0.914, 1.051], i.e. |S2-S| < eps. That is 15 times stricter than the stated test. No k gives it without halving.
  - The animation shows a final value of 2.016252 (the script computes it from rounded hard-coded nodes such as 0.0117188). Exact nodes give 2.0162726. The stated criterion gives 2.0160635.
- Severity: Misleading is fair. The page states the criterion and "tol = 0.001", and the GIF labels every frame "tol = 0.001". But the refinement shown, with roughly twice as many nodes and three more levels near 0, comes from |S2-S| < eps. A reader who implements the stated test will not get this picture. It could arguably be called an Error, since the stated test and tolerance demonstrably do not produce the partition shown, but "Misleading" is defensible because the page calls the test only "a common criterion".
- Correction to the allegation: none. The stricter test is specifically |S(a,m)+S(m,b)-S(a,b)| < eps (factor 15 dropped) with the tolerance halved at each split.

## A2 — confirmed with correction
- What I checked: I read the script's plotting code (lines 59–90) and looked at frames 003, 005, 010, 014 and 020 and the contact sheet. I measured pixel colours along a row inside the pink fill to see whether panel boundaries leave any trace.
- Evidence:
  - The script draws only the filled parabolas (plot! with fillrange, lines 79–80) and the f curve. It draws no node markers, vlines or scatter.
  - Pixel scan (verify, inline python on frame_005 and frame_020, row 420): the fill is uniform RGB(255,207,214). Panel boundaries leave only 1-px anti-aliasing seams of RGB about (255,213-215,219-221), a contrast of about 3%. They are essentially invisible at normal viewing.
  - In frame_020 the seams that exist fall at 0.0035, 0.0069, 0.014, 0.031, 0.062 and so on. At this scale (about 290 px per unit) all refinements after roughly frame 14 lie within x < 0.008, which is under 2.3 px. From about the 17-point frame onward, the red parabolas sit on the magenta curve, so successive frames look identical apart from the text counters.
  - Partial counterpoint: in the early frames (5 to about 13 points) the panel structure can be seen indirectly through kinks in the red piecewise curve (for example at x=0.5 and 1.0 in frame_005). The earlier refinement of [0,1] versus [1,2] can be made out there, and a slight coarse-panel mismatch on [1.5,2] stays visible through the end.
- Severity: Misleading is fair. The alt text and the "showing how new points are introduced nonuniformly" claim promise visible concentration. In the frames, the main concentration (repeated bisection toward x=0, where x^{2/3} has an unbounded derivative) cannot be seen.
- Correction to the allegation: "no visible indication of node locations" is slightly too strong. The early frames do show nonuniform panels indirectly through the kinks in the piecewise parabola, and faint 1-px seams exist. The substance holds: there are no markers or boundary lines, and the later concentration near 0 is not visible.
