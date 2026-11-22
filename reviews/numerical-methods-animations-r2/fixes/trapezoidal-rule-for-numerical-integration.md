# Fix record: trapezoidal-rule-for-numerical-integration

Scratch folder (evidence, re-runnable): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r2fix/trapezoidal-rule-for-numerical-integration/fix/`
- `indep.py`: independent mpmath computation (30 digits), run with `/usr/bin/python3 -I indep.py`
- `instr.jl`: the script's own `f` and `trapezoid_sum` (lines 1–22 of `trapezoidalaa.jl`, without Plots), run with `julia instr.jl`
- `frames/`: frames of the committed `trapezoidalaa.gif`; `legacy/`: frames of Mathews' `Trapezoidalaa.gif`

## Findings

### F1 — Minor — fixed
- Reproduced: `/usr/bin/python3 -I indep.py` gives I = 2.0162797196171 (substitution x = t³, which removes the x^{2/3} singularity) and, for the animation's n sequence, T_n − I = +0.0016451 (n=1), +0.356647 (n=2), −0.117209 (n=3), −0.214208 (n=4), −0.194387 (n=5), −0.161092 (n=6), …, −0.00133525 (n=120). The error magnitude grows from n=1 to n=2 and again from n=3 to n=4, and shrinks at every later frame. Checked over every integer n from 5 to 120 as well (not just the frames): |e_n| < |e_{n−1}| for all of them (the list of exceptions is empty). `julia instr.jl` with the script's own `trapezoid_sum`: n=1 → 2.017924816215668 (label 2.017925), n=2 → 2.372926966994002, n=4 → 1.8020714882340843, n=120 → 2.0149444646203434. Frame 2 of the committed GIF (`frames/frame_002.png`, viewed) shows "Sample Points = 2 / Approximation = 2.017925", and frame 3 shows "Sample Points = 3 / Approximation = 2.372927". The finding holds: the page explained neither the near-exact first value nor the jump that follows it.
- Change: `index.qmd` line 29 (Case 1 Behavior). Three sentences inserted after "…about 0.0013 low.":
  "The approach is not steady at first. The single trapezoid in the first partition frame (2 sample points, 2.017925) is close to the integral only by coincidence: the areas where the curve lies above and below the chord from $f(0)$ to $f(2)$ almost cancel. With 2 subintervals the error jumps to about $+0.36$, and from 4 subintervals (5 sample points) on its size shrinks at every frame."
  Nothing else on the page changed. The heading, alt text and GIF title make no claim about early frames, so they still agree with the new text.
- Check: the "almost cancel" claim is computed in `indep.py`. The chord from (0, f(0)=1) to (2, f(2)=1.01792) crosses f at x = 0.245757, 0.698132 and 1.27046. The area of f above the chord is 0.28027166 and the area below is 0.28191676, so the net is −0.0016450966 = I − T_1. The other numbers in the inserted text are checked in the ledger below.

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd l.29 | "The approach is not steady at first." | `indep.py`: \|e\| goes 0.00165 → 0.357 (n=1→2) and 0.117 → 0.214 (n=3→4), so it is not monotone over the early frames | yes |
| index.qmd l.29 | "first partition frame (2 sample points, 2.017925)" | frame_001 is the curve only (n=0) and frame_002 is the first with trapezoids; frame_002 label "Sample Points = 2 / Approximation = 2.017925"; `instr.jl` n=1 → 2.017924816 | yes |
| index.qmd l.29 | "single trapezoid" | n=1 is one subinterval; frame_002 shows one trapezoid | yes |
| index.qmd l.29 | "close to the integral only by coincidence: the areas where the curve lies above and below the chord from f(0) to f(2) almost cancel" | `indep.py`: area above the chord 0.28027166, area below 0.28191676, net ∫(f − chord) = −0.0016451 = I − T_1; each area is about 170× the net | yes |
| index.qmd l.29 | "With 2 subintervals the error jumps to about +0.36" | `indep.py`: T_2 − I = +0.356647 (T_2 = 2.372926967); frame_003 label 2.372927 | yes |
| index.qmd l.29 | "from 4 subintervals (5 sample points) on its size shrinks at every frame" | `indep.py`: \|e\| strictly decreasing over the frames n = 4,5,6,7,8,10,…,96,120 (all marked "shrinks"), and also over every integer n = 4…120 (exception list empty); n=4 is labelled "Sample Points = 5" (script prints n+1) | yes |

## Scripts and GIFs
- Scripts changed: none. GIFs regenerated: none (the finding is text-only, and the animation is correct).
- Frames viewed: the committed `trapezoidalaa.gif` was extracted with `giftools.jl` (24 frames). I viewed frame_002 and frame_003 at full size and checked that their labels match the values above.
- `git status --short -- pages/numerical-methods/trapezoidal-rule-for-numerical-integration` → ` M .../index.qmd` only.

## Legacy archive
Consulted. `n2003/TrapezoidalRuleMod.html` links one animation, `a2001/Animations/Quadrature/Trapezoidal/Trapezoidalaa.gif` (24 frames, extracted to `legacy/`; contact sheet viewed). It has the same function and interval as the page. Its 2-sample-point frame also shows "Approximation = 2.017925", followed by 1.802071 at 5 points, so Mathews' animation has the same coincidental first value without comment. The page's new sentences describe that behaviour and do not change the example. Its schedule differs slightly (51, 71 and 101 points, for example), and it draws node dots and an in-frame formula. Round 2 found no fidelity finding for these, so they are not changed.

## Notes
- No decision ambiguity. D1 wording (measured order 5/3 and the cause, f′ unbounded at 0) was already on the page from round 1 and is unchanged.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- The fix adds four sentences to the Case 1 Behavior paragraph in `index.qmd`. The original claims stay. The new sentences say that the approach is not steady at first, explain the near-coincidental single-trapezoid value, give the jump at 2 subintervals, and say that the error shrinks monotonically from 4 subintervals on. A reader comparing the first and last values is no longer left without an explanation.
- Independent check: `check/indep.py`, mpmath at 30 digits. The integral was computed two ways, by split quad and by the substitution x=t^3, and both give I = 2.016279719617096. T_n was evaluated at every frame's n in mpmath.
- Script's own sums: `check/instr.jl`, which copies `trapezoid_sum` verbatim, gives the same values to all digits shown.
- Full error sequence, T_n − I, by n:

  | n | error | n | error | n | error | n | error |
  |---|---|---|---|---|---|---|---|
  | 1 | +0.001645 | 6 | −0.161092 | 16 | −0.037224 | 40 | −0.008263 |
  | 2 | +0.356647 | 7 | −0.132297 | 18 | −0.030740 | 48 | −0.006110 |
  | 3 | −0.117209 | 8 | −0.109685 | 20 | −0.025882 | 56 | −0.004732 |
  | 4 | −0.214208 | 10 | −0.078515 | 24 | −0.019194 | 72 | −0.003119 |
  | 5 | −0.194387 | 12 | −0.059046 | 28 | −0.014893 | 96 | −0.001935 |
  | | | 14 | −0.046174 | 32 | −0.011949 | 120 | −0.001335 |

  |error| grows from n=1 to 2, shrinks from 2 to 3, grows from 3 to 4, and then shrinks at every one of the 19 frames from n=4 to n=120. That matches the new wording exactly.
- The script and GIF did not change, and they did not need to: the finding was about the text only. The frames I viewed match the new text:
  - frame_002 shows "Sample Points = 2 / Approximation = 2.017925", a single near-flat chord from (0,1) to (2,1.0179);
  - frame_003 shows 3 points and 2.372927;
  - frame_005 shows 5 points and 1.802071;
  - frame_024 shows 121 points and 2.014944.

### Changed-text ledger

| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd Case 1 Behavior | "The approach is not steady at first." | The error sequence above is non-monotone for n=1..4. | True |
| same | "first partition frame (2 sample points, 2.017925)" | Frame 1 is the empty axes (n=0) and frame 2 is n=1, labelled 2 sample points and 2.017925. T_1 = 2.0179248 in both mpmath and the script. | True |
| same | "close to the integral only by coincidence: the areas where the curve lies above and below the chord from f(0) to f(2) almost cancel" | The chord runs from f(0)=1 to f(2)=1.0179248 and crosses the curve at x≈0.2455, 0.698 and 1.270. Area of the curve above the chord: 0.280272. Area below: 0.281917. The net is −0.001645, so T_1 − I = +0.001645, which is consistent. Two lobes of about 0.28 cancel to 0.6%. | True |
| same | "With 2 subintervals the error jumps to about +0.36" | T_2 − I = +0.356647. | True |
| same | "from 4 subintervals (5 sample points) on its size shrinks at every frame" | I checked \|e\| frame by frame for n = 4, 5, 6, 7, 8, 10, …, 96, 120 (19 frames): it strictly decreases each time, from 0.2142 down to 0.001335. In the GIF, frame_005 is labelled "Sample Points = 5", which matches n=4. | True |
| same (unchanged context, re-verified) | I ≈ 2.016280; last frame 2.014944, about 0.0013 low; ratio 3.14 from 24 to 48 subintervals; tends to 2^{5/3} ≈ 3.17 | I = 2.0162797. T_120 = 2.0149445, so the error is −0.001335. e24/e48 = 3.1415. Further halving ratios are 3.158, 3.165, 3.168, 3.170, 3.171 and 3.173, tending to 3.1748. | True |

### New problems

None. This rests on four checks:
- every number and behaviour word in the added sentences was recomputed both in mpmath and with the script's own `trapezoid_sum`;
- the monotonicity claim was checked against every frame's error;
- the frames were viewed at full size;
- the diff touches only one paragraph of `index.qmd`.

### Reproducibility and conventions

- **Script and GIF.** No script or GIF changed in this fix. As a sanity check, I ran `trapezoidalaa.jl` from a scratch copy (`check/run/`), and its output is byte-identical to the committed `trapezoidalaa.gif` (`cmp` reports IDENTICAL).
- **Page conventions.** The page keeps all of them:
  - Description comes before Animations;
  - the case has a `[Julia source](trapezoidalaa.jl)` link and an embed;
  - the alt text is descriptive;
  - there are no code blocks.
- **Files outside the page folder.** `git diff HEAD --stat` on the page folder lists only `index.qmd`, with one line changed. Other pages in the working tree are also modified, and there are untracked files under `reviews/numerical-methods-animations-r2/fixes/`. These come from other pages' fixes running in parallel in the same tree. Nothing in this page's diff refers to them, so they are not attributable to this fix.

**Final status:** committed
