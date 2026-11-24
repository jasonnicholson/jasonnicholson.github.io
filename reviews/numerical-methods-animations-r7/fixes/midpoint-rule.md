# Fix record: midpoint-rule

## Findings
### F1 — Minor — fixed
- Reproduced: `/usr/bin/python3 -I /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r7fix/midpoint-rule/fix/check.py` (output in `check.out` beside it). Reference I = 2.0162797196170963279 (mpmath 40 digits, by substitution x = t^3 on 40 panels, and by tanh-sinh on the original integrand; both agree to 20 digits). All 18 frames with n >= 4 (n = 4, 6, ..., 120) have |M - I| < min(|L - I|, |R - I|). For n = 1 and 2 the left sum is closer (n=1: M-I = 0.711649, L-I = -0.0162797; n=2: M-I = -0.785064, L-I = 0.347685), so "from 4 sample points on" is the right start within the frames. Double-precision scan of every n in [4, 20000]: 3584 exceptions, the contiguous block 1623 to 5206. Boundaries at 40 digits: n=1622 M-I 6.47786e-6, R-I -6.48099e-6 (midpoint closer); n=1623 6.47122e-6 vs -6.46982e-6 (right closer); n=5206 9.29304e-7 vs 9.29290e-7 (right closer); n=5207 9.29007e-7 vs 9.29433e-7 (midpoint closer). These match the review's numbers.
- Change: `index.qmd`, Case 1 Behavior: "From 4 sample points on, the midpoint estimate is closer ..." → "In every frame from 4 sample points on, the midpoint estimate is closer ...". The rest of the sentence is unchanged. Text-only fix under D7 and R7-D, since the animation is right.
- Check: same script. The new quantifier covers exactly the 18 frames n = 4 ... 120, all of which print "mid closest". The flag `all frames n>=4 midpoint closest: True` confirms it.

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd, Case 1 Behavior | "In every frame from 4 sample points on, the midpoint estimate is closer to the integral than the left- or right-endpoint sum with the same number of subintervals." | `check.py` → every frame n in {4,...,120} "mid closest"; n=1, 2 "NOT" (left sum closer) | yes |
| (number) "4" | first frame where the claim holds and from which it holds in every later frame | `check.py` frame table: n=2 NOT, n=4 through n=120 all mid closest | yes |

No other sentence, alt text, title or label was changed.

## Scripts and GIFs
- No script changed and no GIF regenerated. The finding concerned text only.
- `git status --short -- pages/numerical-methods/midpoint-rule` → ` M pages/numerical-methods/midpoint-rule/index.qmd` (only).

## Legacy archive
Consulted. `n2003/midpointrule/` holds only `MidpointRuleMod/Links/*.html` (12 link pages) and `MidpointRuleBib`. The main `MidpointRuleMod.html` named in the brief is not present locally. A search of the link pages' stripped text for "left", "right", "endpoint", "compar" and "more accurate" found nothing, so the archive makes no left/right comparison claim. The legacy animation is `a2001/Animations/Quadrature/Midpoint/Midpointaa.gif`. Per the round-7 review, the page already matches its function, interval and sample counts, and this fix does not touch any of them.

## Notes
- No decision ambiguity. D7 and R7-D settle it as a text fix, and the review's suggested wording was used verbatim.
- The page has no stale "legacy GIF missing" note (R2-A). It already states that it follows Mathews' animation.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: the unqualified "From 4 sample points on, ..." now reads "In every frame from 4 sample points on, ...". This limits the claim to the frames shown. The script's frame sequence is n = 0 (blank), 1, 2, 4, 6, ..., 100, 120. That gives 18 frames with n >= 4. `check/chk.py` (mpmath, 40 digits; I computed from the t^3 substitution and checked it against a direct 40-panel quad, difference 5e-41) gives |M_n - I| < min(|L_n - I|, |R_n - I|) in all 18 of those frames. It fails at n = 1 and n = 2, which agrees with "from 4 on". The exception block in the finding also holds: the claim is true at n = 1622 and 5207 and false at n = 1623 and 5206, with the same error values as the finding's table. So the old unqualified wording was false, and the new wording is true. The GIF and script are unchanged and need no change: the GIF has 21 frames, frame 4 shows "Sample Points = 4, Approximation = 2.011118" and frame 21 shows "120, 2.016771", both matching my M_n.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd Case 1 Behavior | "In every frame from 4 sample points on, the midpoint estimate is closer ... than the left- or right-endpoint sum" | 18/18 frames n>=4 hold; n=1,2 fail | true |
| same line (unchanged text, re-checked) | "Over the first few frames the estimate jumps above and below" | n=1 above, n=2 below, n=4 below, n=6 above | true |
| same | "from 6 sample points on it stays above ... and decreases toward it in every frame" | M_n > I and strictly decreasing for every frame n=6..120 | true |
| same | integral ≈ 2.016280 | I = 2.01627971961709... | true |
| same | last frame 2.016771, about 0.00049 high | M_120 = 2.0167715, error 4.917e-4 | true |
| same | f'(x) ≈ (16/3) x^{-1/3} near 0 | d/dx sin(8x^{2/3}) ~ (16/3)x^{-1/3}·cos(0) (e^{-x}→1) | true |
| same | ratio about 3.11 from 24 to 48 subintervals | e24/e48 = 3.11248 | true |
| same | tending to 2^{5/3} ≈ 3.17 | ratios 3.147, 3.159, 3.165, 3.168, 3.170 (n=48..768); 2^{5/3}=3.1748 | true |

### New problems
None. This rests on three checks: the only change is the one sentence in index.qmd, which I verified above; the rest of the changed line re-checks true; and the GIF and script are untouched.

### Reproducibility and conventions
- No script or GIF in the page folder changed (git status shows only `midpoint-rule/index.qmd` modified), so there was nothing to regenerate. The committed GIF's frames are consistent with the script and the page.
- Conventions are intact: Description comes before Animations; there is a source link `[Julia source](midpointaa.jl)` and an embed with descriptive alt text; there are no code blocks.
- Outside the page folder: the working tree has many other modified pages. These belong to other pages' fixes in this round, and nothing in the midpoint-rule diff touches them.

**Final status:** committed
