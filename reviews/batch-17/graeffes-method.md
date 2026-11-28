# Graeffe's Method — batch 17 review, round 1 (overview mode)

SUMMARY: 0 Error, 0 Misleading, 2 Minor

Review of `graeffes-method`, light-pass batch 17, overview page (action: check). Page: /home/jason/Desktop/jasonhnicholson.com/pages/numerical-methods/graeffes-method/index.qmd. Evidence: EV=/tmp/claude-1001/-home-jason--claude-spares-spare-0ogoFf/f6c51b48-3d53-4b4d-8872-653429a6389a/scratchpad/work/review-17/graeffes-method. My scratch work is in EV/reviewer/: g.py recomputes the Graeffe iterates in exact sympy arithmetic plus 60-digit mpmath, and wc.py counts words. I did not run MATLAB or quarto, and I changed nothing in the repository. I consulted the Mathews module /home/jason/Desktop/math-fullerton/baseline/mathews/n2003/GraeffeMethodMod.html, reading it as text.

## Part 1: Findings

**F1. Page text, Minor. The Description is longer than the 400-word limit.**
- Location: `## Description`, lines 10–49.
- What is there now: 417 words by the manifest's count and 416 by mine (EV/reviewer/wc.py, with inline math counted as one word and display math and headings left out). The standard allows 150–400 words.
- How it got there: this batch added 92 words. Line 41 has 7, line 46 has 40 and line 48 has 45. The text from before the batch was about 325 words.
- Suggested fix: as you directed, I do not suggest cutting the older text. If you want the page under 400, the new "where it fits" sentence on line 48 can lose about 20 words without losing a link. For example: "Among the site's other root finders, [Newton-Raphson](../newton-raphson-method/) refines one root from a guess, [Lin-Bairstow](../lin-bairstow-method/) finds real quadratic factors (so complex pairs) in real arithmetic, and the [Madsen-Reid method](../madsen-reid-method/) finds roots one at a time with safeguarded Newton steps and deflation."
- Effect on the reader: none. Nothing is misleading.

**F2. Page text, Minor. "Damped Newton steps" does not describe the Madsen-Reid method the site's page presents.**
- Location: line 48, "the [Madsen-Reid method](../madsen-reid-method/) finds the roots one at a time by damped Newton steps and deflation."
- What is wrong: "damped" means shortened steps. The linked page describes more than that:
  - In Stage 1, the step is lengthened to z − kΔz, with k up to n+1. The page says this lengthening is the method's answer to multiple roots: "Lengthened steps at multiple roots", madsen-reid-method/index.qmd line 12 onward.
  - The step is halved and rotated only when |f|² increases.
  - Stage 2 takes plain Newton steps.
  
  So "damped" names only the halving branch and leaves out the feature the linked page leads with.
- What is right: "one at a time … and deflation" is correct. The linked page says each root is deflated out, by degree 1 or 2.
- How I know: I read pages/numerical-methods/madsen-reid-method/index.qmd, lines 8–52.
- Suggested fix: "safeguarded Newton steps" or "checked Newton steps".

## Part 2: Claim ledger

The ledger covers the `+` lines of EV/diff.patch: 6 insertions and 2 modified headings. Nothing was moved.

| # | Claim (page's words) | Verdict | Evidence |
|---|---|---|---|
| L1 | Line 41: "[Case 1](#case-1) shows this from $m = 3$ on." "This" is line 40's claim that the error decreases quadratically and the accurate digits roughly double per iteration. | Confirmed | g.py, Case 1. Correct digits (−log10 of the error) for \|r\| = 4, 3, 2, 1: m=3 gives 1.30, 1.67, 2.02, 3.29; m=4 gives 2.60, 2.80, 3.72, 6.02; m=5 gives 4.90, 5.04, 6.84, 11.14; m=6 gives 9.20, 9.33, 12.77, 21.07; m=7 gives 17.5, 17.6, 24.4, 40.6. From m=3 the digits roughly double at every step. Before m=3 they do not: \|r\|=3 goes from 1.78 digits at m=1 to 1.23 at m=2, matching the Case 1 Behavior paragraph (3.017 then 2.941). |
| L2 | Line 46: "[Case 2](#case-2) shows one of these, a double root" | Confirmed | Case 2 is f = (x−1)(x+2)(x−5)², which has a double root at 5. The "Special cases" sentence on line 45 lists double roots. |
| L3 | Line 46: "as with Newton-Raphson at a multiple root, its two estimates converge only linearly" | Confirmed | Newton at a root of multiplicity m converges linearly with error ratio (m−1)/m; the site's Newton-Raphson page, Case 2, shows this. Mathews' module says the same: "As in the case of Newton's method, the iteration will proceed linearly for the repeated root and quadratically for the simple roots." |
| L4 | Line 46: "their error roughly halving at each step from $m = 2$ on" | Confirmed | g.py, Case 2. The error ratios e_{m+1}/e_m of the two \|r\|=5 estimates are 0.469 and 0.550 (m=2→3), 0.489 and 0.512, 0.495 and 0.505, 0.497 and 0.503, 0.499 and 0.501, 0.499 and 0.501. Between m=1 and m=2 they are 0.40 and 0.75, so "from m = 2 on" is the right starting point. Theory agrees: the estimates are 5·2^{±1/2^m}, so the error is about 5 ln2 / 2^m. |
| L5 | Line 46: "while the two simple roots still converge quadratically" | Confirmed | g.py, Case 2. Errors for \|r\|=2: 5.5e-2, 5.3e-3, 6.5e-4, 1.8e-6, 1.5e-11, 1.7e-21, 4.6e-41. For \|r\|=1: 1.3e-1, 1.6e-2, 4.9e-4, 9.5e-7, 7.3e-12, 8.5e-22, 2.3e-41. The digits double. |
| L6 | Line 48: "[Newton-Raphson](../newton-raphson-method/) refines one root from a starting guess" | Confirmed | Matches the description on newton-raphson-method/index.qmd. |
| L7 | Line 48: "[Lin-Bairstow](../lin-bairstow-method/) finds real quadratic factors, and so complex-conjugate pairs, in real arithmetic" | Confirmed | lin-bairstow-method/index.qmd, lines 12–13: it finds a quadratic factor x² − rx − s and "uses only real arithmetic, yet finds complex-conjugate pairs". |
| L8 | Line 48: "the [Madsen-Reid method](../madsen-reid-method/) finds the roots one at a time" | Confirmed | Madsen-Reid page: deflation after each root is found. |
| L9 | Line 48: "…by damped Newton steps and deflation" | Wrong in part (F2) | "Deflation" is right. "Damped" leaves out the lengthened Stage-1 steps and the plain Stage-2 steps. |
| L10 | Heading id `{#case-1}` on the Case 1 heading, the target of line 41's link | Confirmed | The id is present on line 56, and the link `#case-1` matches it. |
| L11 | Heading id `{#case-2}` on the Case 2 heading, the target of line 46's link | Confirmed | The id is present on line 64, and the link `#case-2` matches it. Apart from the ids, the heading text is unchanged (diff lines 52–53 and 60–61). |

## Part 3: Checks

**Scope of the diff.**
- `git diff` on the page folder is identical to EV/diff.patch. The only file touched is index.qmd, and the two .jl scripts and two GIFs are unchanged, so the animations are not under review.
- Outside the Description, the only changes are the two heading ids, which the rules allow. No sentence was moved and the Animations prose is unchanged.

**Consistency with the rest of the page.**
- Line 41 agrees with the Case 1 Behavior paragraph: quadratic from m=3, irregular first steps.
- Line 46 agrees with the Case 2 Behavior paragraph (linear and halving from m=2, simple roots quadratic) and with the annotation on the GIF's last frame.
- The values I computed match the frames:
  - graeffesaa frame_009 at m=8: the traces start at 2.0, 6.5, 1.08, 1.71 at m=0, and r₂ is at 3.017 at m=1 and 2.941 at m=2, as computed.
  - graeffesab frame_011 at m=10: the r₁ and r₂ traces close in on 5 from above and below as 5.4528/4.5856 (m=3), 5.2214/4.7880 (m=4) and so on, ending at 5.00339/4.99662 at m=10.
- No contradictions with any other section.

**General results.**
- Line 40's "quadratic" (text from before the batch) is attached to Case 1 by the new line 41, so I checked it on Case 1.
- What holds: the digits double (order 2 in the sense that log e_{m+1}/log e_m → 2).
- A side observation, not a finding: e_{m+1}/e_m² is not bounded. For \|r\|=4 it runs 1.0, 2.0, 4.0, 8.0, 16.0 from m=4 to m=8, because e_m ≈ \|r_k\| q^{2^m}/2^m with q = \|r_{k+1}/r_k\|. Checking that model at m=6: 4·0.75⁶⁴/64 = 6.27e-10, against a computed error of 6.31e-10. The page states the result as digits doubling, which is accurate, so I am not raising this as a finding.
- The new text adds no other general result, so no hypothesis is missing.

**The six points of the standard.** All six are present.
1. The problem: line 12.
2. The core formula: display math on lines 18, 22, 30 and 34, in the scripts' notation (c_j is the coefficient of x^j, and the estimate is \|c_{n−k}/c_{n−k+1}\|^{1/2^m}). The scripts' mag_estimates function computes exactly this.
3. What it assumes: lines 28, 36 and 40 (separated magnitudes, real roots).
4. How accurate it is: lines 40–41, pointing to Case 1.
5. When it fails or misleads: lines 43 (overflow) and 45–46 (special cases, pointing to Case 2).
6. Where it fits: line 48.

There are no proofs or callout boxes. The Description's existing `###` subheadings come from before the batch.

**Word count.** 417 by the manifest, 416 by mine, over the 400 limit (F1).

**Links.**
- `#case-1` and `#case-2` resolve to the new explicit ids.
- `../newton-raphson-method/`, `../lin-bairstow-method/` and `../madsen-reid-method/` all exist, each with an index.qmd.

**Fidelity to Mathews.** The module says repeated roots converge linearly and simple roots quadratically, "as in the case of Newton's method". The new line 46 says the same, so there is no fidelity finding.

**Could not determine.** Nothing.
