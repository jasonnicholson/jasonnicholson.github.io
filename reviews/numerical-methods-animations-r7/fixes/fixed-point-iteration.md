# Fix record: fixed-point-iteration

Scratch evidence: `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r7fix/fixed-point-iteration/fix/` (`check.py`, `orbit.jl`, `aa_frames/`).

## Findings

### F1 — Misleading — fixed
- Reproduced: `/usr/bin/python3 check.py` (sympy + 50-digit mpmath):
  - fixed points of sqrt(2x) = x: `[0, 2]`;
  - g'(x) > 1 on x > 0 exactly for `Interval.open(0, 1/2)`;
  - g'(0.1) = 2.23607, g'(x_1) = g'(0.4472135955) = 1.05737.

  So x_0 and x_1 are outside the contraction region (1/2, ∞). The convergence is real, but "Since g'(2) < 1" does not explain it from this start.
- Change: `index.qmd`, Case 1 Behavior.
  - Before: "intersects y = x at x* = 2. Since g'(2) = 1/2 < 1, iteration converges from below in a monotone staircase."
  - After: the review's suggested correction, with "x < 1/2" tightened to "0 < x < 1/2" (g' is undefined at 0, and g is not real for x < 0). Its text: meets y = x at x = 0 and at x* = 2; on (0, 2) increasing and between y = x and y = 2, so the iterates climb monotonically to x* = 2, even though g'(x) > 1 for 0 < x < 1/2, which includes x_0 = 0.1. Near x* the error is roughly halved at each step, since g'(2) = 1/2.
- Check: `check.py` gave:
  - `g-x>0 on (0,2): Interval.open(0, 2)`;
  - `g<2 on (0,2): Interval.open(0, 2)`;
  - `g increasing (g'>0) on (0,oo): Interval.open(0, oo)`;
  - all 12 drawn iterates strictly increasing and below 2 (`strictly increasing: True  all <2: True`).

  Error ratios e_n/e_{n-1} by step: 0.817, 0.679, 0.593, 0.547, 0.523, 0.512, 0.506, 0.503, 0.5015, 0.5007, 0.5004, 0.5002. They are near 1/2 only once the iterates are near 2 (≤ 0.524 from x_5 ≈ 1.82 on), which is what "Near x*" says. The final frame (`aa_frames/frame_013.png`) shows both intersections, at the origin and at (2, 2), and the climbing staircase. Heading, alt text and GIF title are still consistent with the new text.

### F2 — Minor — fixed
- Reproduced:
  - mpmath, 50 digits: the min over x_0..x_32 is −2.6387871 (n = 30) and the min over 400 iterates is −2.6405704 (n = 34). The first n with x_n < −2.639 is 34.
  - Float64 in Julia (`orbit.jl`): min over 0..32 is −2.6387871250982355, min over 10000 iterates is −2.6405704311320335 at n = 34, and the max is 4.2499792118186654.
  - The 4-cycle roots are −2.6405244, −0.98762106, 3.5771699 and 4.2499617.

  No iterate is below −2.641 or above 4.250.
- Change: `fixpointff.jl` lines 16 and 18 (comment only): `[-2.639, 4.250]` → `[-2.641, 4.250]`; "orbit's min is -2.639" → "-2.641".
- Check: the true minimum −2.64057 rounds to −2.641, and it is > −3.3125, so the legend-placement argument still holds (`min over all > -3.3125: True`). Regenerating `fixpointff.gif` gave a byte-identical file (git shows no change to the GIF).

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| Case 1 Behavior | meets y = x at x = 0 and x* = 2 | `check.py` → `fixed points case1: [0, 2]` | yes |
| Case 1 Behavior | on (0, 2) g is increasing | `check.py` → g' > 0 on `Interval.open(0, oo)` | yes |
| Case 1 Behavior | lies between y = x and y = 2 on (0, 2) | `check.py` → g−x>0 and g<2 each on `Interval.open(0, 2)` | yes |
| Case 1 Behavior | iterates climb monotonically to x* = 2 | `check.py` → x_0..x_12 strictly increasing, all < 2, x_12 = 1.998537775. For all n this follows from the two lines above (bounded increasing sequence; the only fixed point > 0 is 2) | yes |
| Case 1 Behavior | g'(x) > 1 for 0 < x < 1/2 | `check.py` → `solve g'>1 on x>0: Interval.open(0, 1/2)` | yes |
| Case 1 Behavior | which includes x_0 = 0.1 | 0.1 ∈ (0, 1/2); g'(0.1) = 2.23607 | yes |
| Case 1 Behavior | near x* the error is roughly halved per step | `check.py` ratios → 0.5234 at step 5, falling to 0.5002 at step 12 (early ratios 0.82, 0.68 are not near 1/2; the text says "Near x*") | yes |
| Case 1 Behavior | g'(2) = 1/2 | `check.py` → `g'(2)= 1/2` | yes |
| fixpointff.jl l.16 | orbit stays in [−2.641, 4.250] | `orbit.jl` → min −2.64057, max 4.24998 over 10000 Float64 iterates; mpmath, 400 iterates: none < −2.641, none > 4.250 | yes |
| fixpointff.jl l.18 | orbit's min is −2.641 | −2.6405704 → −2.641 (3 d.p.) | yes |

## Scripts and GIFs
- Scripts changed: `fixpointff.jl` (comment only).
- GIFs regenerated: `fixpointff.gif`, byte-identical to the committed file.
- Frames viewed: `fixpointaa.gif` (unchanged; text-only fix) final frame 13, which shows both intersections (0 and 2) and the monotone climb to x_12 = 1.9985.
- `git status --short -- pages/numerical-methods/fixed-point-iteration` after regeneration: ` M fixpointff.jl`, ` M index.qmd`.

## Legacy archive
Consulted: `n2003/FixedPointMod.html` and `fixedpoint/FixedPointMod/Links/FixedPointMod_lnk_5.html` (Solution 4). Solution 4 reads "Since [|g'(x)| < 1] for all [x ∈ (1/2, ∞)], the iteration will converge to the fixed point …" (images `FixedPointMod_gr_262.gif` and `_263.gif`, viewed). That region excludes x_0 = 0.1, as the review said. The page now gives the monotone-bounded argument that covers this start, and records Mathews' contraction region implicitly through the 0 < x < 1/2 sentence.

## Notes
- The page has no `## Description` section. That is a pre-existing convention gap that no finding names, so it was not added.
- `fixpointaa.jl` header line 3 ("Convergent case: |g'(x*)| = 1/2 < 1 at fixed point x* = 2") states a true fact without claiming it is the reason for convergence from 0.1. It was left unchanged.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: The "Since g'(2) = 1/2 < 1 ... converges" sentence is gone. The new Case 1 text gives a causal argument that holds. Proof: for 0 < x < 2, x < sqrt(2x) iff x^2 < 2x iff x < 2, and sqrt(2x) < 2 iff x < 2. So g maps (0,2) into (x,2). From x0 = 0.1 the iterates are therefore strictly increasing and bounded by 2. Their limit L lies in (0.1, 2] and, because g is continuous, satisfies g(L) = L, so L = 2. ("Increasing" is true, since g' > 0, but the argument does not need it.)
- Computed with mpmath at 50 digits: the iterates are strictly increasing and below 2 for 40 steps. g'(x0) = 2.2361 and g'(x1) = 1.0574, both > 1. g'(x) = 1/sqrt(2x) > 1 iff x < 1/2. The fixed points of sqrt(2x) = x are 0 and 2.
- The "roughly halved" claim holds. The error ratios (2 - x_{n+1})/(2 - x_n) are 0.817, 0.679, 0.593, 0.547, 0.523, 0.512, 0.506, 0.503, 0.501, 0.5007, 0.5004, 0.5002. They tend to g'(2) = 1/2, and the "Near x*" qualifier covers the early ratios being larger.
- The unchanged GIF fixpointaa.gif (13 frames, last frame checked at full size) agrees with the text: the curve meets y = x at the origin and at (2,2), and the staircase climbs monotonically to x_12 = 1.9985.

### F2 — resolved
- Evidence: Both comments now give -2.641. Iterating at 50 digits for 5000 steps: the minimum over x_0..x_32 is -2.638787, the minimum over the whole orbit is -2.6405704 (at n = 34), and the maximum is 4.24998. The orbit tends to the 4-cycle (4.24996, -2.64052, 3.57717, -0.98762).
  - [-2.641, 4.250] contains the whole orbit, and -2.6406 rounds to -2.641.
  - The legend argument still holds, because -2.641 > -3.3125.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd Case 1 | meets y = x at x = 0 and x* = 2 | sqrt(2x) = x gives x in {0, 2} | true |
| index.qmd Case 1 | on (0,2) increasing | g' = 1/sqrt(2x) > 0 | true |
| index.qmd Case 1 | lies between y = x and y = 2 on (0,2) | x^2 < 2x < 4 for 0 < x < 2 | true |
| index.qmd Case 1 | "so the iterates climb monotonically to x* = 2" | bounded monotone sequence; its limit is a fixed point in (0.1, 2], so it is 2; also computed | true (proved) |
| index.qmd Case 1 | g'(x) > 1 for 0 < x < 1/2 | 1/sqrt(2x) > 1 iff x < 1/2 | true |
| index.qmd Case 1 | includes x0 = 0.1 | g'(0.1) = 2.236 | true |
| index.qmd Case 1 | error roughly halved near x*, g'(2) = 1/2 | g'(2) = 1/2; ratios tend to 0.5002 | true |
| fixpointff.jl l.16 | orbit stays in [-2.641, 4.250] | min -2.64057, max 4.24998 | true |
| fixpointff.jl l.18 | orbit's min is -2.641 | -2.64057 rounds to -2.641 | true |

### New problems
None. This rests on:
- the ledger above, where every changed sentence and number was proved or computed;
- the GIFs, which are unchanged from HEAD (git diff --quiet) and agree with the new text.

### Reproducibility and conventions
- fixpointff.jl was run from a scratch copy, and its GIF is byte-identical (cmp) to the committed fixpointff.gif.
- fixpointaa.jl was not changed, and its GIF is unchanged from HEAD.
- Conventions are intact:
  - the page has a Description before the Animations;
  - each case has a source link and an embed;
  - the alt text is descriptive;
  - there are no code blocks.
- The page diff touches only the two files in the page folder. The working tree has many other modified pages and untracked review files, which belong to other pages' work and are not part of this page's fix.

**Final status:** committed
