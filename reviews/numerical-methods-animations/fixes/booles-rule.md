# Fix record: booles-rule

Scratch folder (all evidence, re-runnable):
`/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/work/booles-rule/fix/`
(written below as `$FIX`). Scripts are in `$FIX/scripts/`, outputs in `$FIX/*.out`.

## Findings

### F1 — Error — fixed

- **Reproduced:** `/usr/bin/python3 -I $FIX/scripts/order.py` (output `$FIX/order.out`). This is independent of the repo script: mpmath at 40 digits, composite Boole sums at exact nodes $k\cdot 2/n$, with weights $\tfrac{2h}{45}(7,32,12,32,7)$.
  - **Reference integral.** $I = 2.01627971961709632788727442192$. Two methods agree to $-4.6\times10^{-41}$: substitution $x=t^3$ followed by tanh-sinh, and direct tanh-sinh on 80 panels.
  - **Cause.** sympy gives `series(diff(f), x, 0, 0)` = `16/(3*x**(1/3)) + O(1)` (`$FIX/scripts/checks.py`, output `$FIX/checks.out`).
  - **Doubling $n$.** Ratios $E(n/2)/E(n)$ and orders $p=\log_2(\text{ratio})$:

    | n | E(n) | ratio | p |
    |---|---|---|---|
    | 8 | $-5.287\times10^{-2}$ | — | — |
    | 16 | $-8.952\times10^{-3}$ | 5.906 | 2.562 |
    | 32 | $-2.887\times10^{-3}$ | 3.101 | 1.633 |
    | 64 | $-9.100\times10^{-4}$ | 3.1725 | 1.666 |
    | 128 | $-2.860\times10^{-4}$ | 3.1819 | 1.670 |
    | 256 | $-8.996\times10^{-5}$ | 3.1794 | 1.669 |
    | 1024 | $-8.915\times10^{-6}$ | 3.1760 | 1.667 |
    | 4096 | $-8.842\times10^{-7}$ | 3.1751 | 1.6668 |
    | 16384 | $-8.772\times10^{-8}$ | 3.17488 | 1.6667 |

    For comparison, $2^{5/3}=3.1748$.
  - **In-animation pairs.** 24→48 gives 3.151 ($p=1.656$), 48→96 gives 3.181 ($p=1.670$), and 60→120 gives 3.182 ($p=1.670$). Every pair from 16→32 to 60→120 lies between 3.10 and 3.19.
  - **Least-squares slope.** The slope of $\log|E|$ against $\log h$ over the animation's frames $n=8..120$ is 1.753. It sits above 5/3 because the pre-asymptotic $n=8$ point is included; the 8→16 ratio is 5.9.
  - **Control.** The same routine on $e^x$ over $[0,2]$ gives ratios 58.3, 62.5, 63.6, 63.90, 63.98, 63.994, so $p\to6$. The routine attains the textbook order on a smooth integrand.
  - **Conclusion.** The finding holds. The rule is implemented correctly, but the "sixth-order" and "converges rapidly" claims are false for this integrand: the error falls like $h^{5/3}$, and the last frame is still $3.2\times10^{-4}$ low.
- **Change:** text only, in `index.qmd`. The animation is correct, so per D1 and D7 the script and GIF are unchanged.
  - **Line 17 (Description).** Before: "has global error $O(h^6)$ on smooth functions". After: "and, for smooth $f$ (six times continuously differentiable on $[a,b]$), has global error $O(h^6)$". This applies D1(b) with the $C^6$ hypothesis of Mathews' corollary.
  - **Line 28 (Behavior).** Before: "…and the approximation converges rapidly with sixth-order global accuracy." After, three sentences:
    - the monotone approach from below, with the reference value and the last frame's value;
    - the D1 cause sentence, verbatim;
    - the measured $O(h^{5/3})$ rate.

    The full text is in the ledger.
  - **Alt text.** Unchanged. It makes no rate or accuracy claim ("each frame updates piecewise quartic panels and the global approximation"), and that matches the frames.
- **Check:** every number and behaviour word in the new text was recomputed (see the ledger). `git diff` shows only lines 17 and 28 of `index.qmd` changed.

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd:17 | "for smooth $f$ (six times continuously differentiable on $[a,b]$), has global error $O(h^6)$" | The archive corollary image `boolerule/BooleRuleMod/Images/BooleRuleMod_gr_41.gif` reads "f(x) ∈ C⁶[a,b]". The control run in `order.py` on $e^x$ gives ratios → 63.994 and $p$ → 5.9999. | yes |
| index.qmd:17 | "exact for polynomials up to degree 5" (unchanged words in an edited sentence) | `checks.py`: on one panel with nodes 0..4, rule − exact = 0 for degrees 0–5 and 128/21 for degree 6. | yes |
| index.qmd:17 | "highest-order closed Newton-Cotes rule in this set" (unchanged clause) | The section's closed Newton-Cotes pages are trapezoid, Simpson 1/3, Simpson 3/8 and Boole (`pages/numerical-methods/index.qmd`:99–103; newton-cotes-integration Cases 1–4). For smooth $f$ the trapezoid is $O(h^2)$, both Simpson rules are $O(h^4)$ and Boole is $O(h^6)$; Boole's 6 is measured above. | yes (clause not changed) |
| index.qmd:28 | "the approximation increases from frame to frame … staying below it" | `checks.py`: across the 23 approximation frames ($n=4..120$), "strictly increasing: True" and "all below I: True". The first GIF frame ($n=0$) shows only the curve. | yes |
| index.qmd:28 | $\int_0^2 f\,dx \approx 2.016280$ | `order.py` → I = 2.01627971961709632788727442192, which rounds to 2.016280. | yes |
| index.qmd:28 | "last frame (121 sample points) gives 2.015961" | mpmath $B_{120}$ = 2.015961179. Julia `boole_sum(120)` rounded to 6 digits (`$FIX/scripts/jlvals.jl`) → 2.015961. The full-size frame `$FIX/orig/frames/frame_024.png` shows "Sample Points = 121 / Approximation = 2.015961". | yes |
| index.qmd:28 | "about $3.2\times10^{-4}$ low" | `checks.py`: I − B(120) = 0.0003185. | yes |
| index.qmd:28 | Cause sentence: $f'(x)\approx\tfrac{16}{3}x^{-1/3}$ near 0, unbounded | sympy `series(diff(f),x,0,0)` → `16/(3*x**(1/3)) + O(1)`. | yes |
| index.qmd:28 | "shrinks like $O(h^{5/3})$ rather than $O(h^6)$" | Doubling sequence $p$ = 1.633, 1.666, 1.670, 1.669, …, 1.6668, 1.6667 (n = 32 … 16384). | yes |
| index.qmd:28 | "divides it by about 3.18 (from 60 to 120 subintervals)" | `order.py` in-animation pairs: 60→120 ratio = 3.182. | yes |
| index.qmd:28 | "tending to $2^{5/3}\approx 3.17$" | `order.py`: 2^(5/3) = 3.1748. Doubling ratios 3.1819 (n=128) → 3.17488 (n=16384). | yes |
| index.qmd:28 | "instead of $2^6=64$" | Arithmetic. The control run reaches 63.994. | yes |

## Scripts and GIFs

- **Scripts and GIFs.** No script changed and no GIF was regenerated. The animation was judged correct:
  - `jlvals.jl`, which runs the repo's `boole_sum` unmodified, reproduces the mpmath values to 6 decimals for all 23 frames.
- **Frames viewed.** The committed `boolesaa.gif` was extracted to `$FIX/orig/frames/` (24 frames; contact sheet `sheet.png`, last frame at full size).
  - The quartic panels are visible at 9 and 17 points.
  - The labels increase from 1.553155 (5 points; 1.963413 at 9 points) to 2.015961 (121 points).
  - The last frame shows 121 points and 2.015961, as the text cites.
- **git status of the page folder** (`git status --short -- pages/numerical-methods/booles-rule`): ` M pages/numerical-methods/booles-rule/index.qmd` only. The GIF is unchanged (`git diff --quiet` passes; it is LFS-tracked).

## Legacy archive

The archive was consulted.

- **`n2003/BooleRuleMod.html`.** The composite Boole theorem and the remainder corollary are there. The corollary's hypothesis (image `gr_41`) is $f\in C^6[a,b]$, which the new Description wording uses.
- **Original animation: `a2001/Animations/Quadrature/Boole/Booleaa.gif`** (24 frames, extracted to `$FIX/archive/`).
  - It uses the same integrand, $y=e^{-x}\sin(8x^{2/3})+1$ on $[0,2]$.
  - Its frames show the same sample-point counts and values as the site's GIF, for example 5 → 1.553155, 13 → 2.001295, 121 → 2.015961.
  - The site's animation is therefore faithful to Mathews' example.
- **Differences from the archive.**
  - Mathews' frames also draw the sample nodes as red dots and vertical lines at the panel boundaries; the site's GIF does not. This is not a finding and was left alone.
  - The archive page makes no claim about the convergence rate of this example. Its general remark that the error falls by about $1/2^6$ per halving holds only under the $C^6$ hypothesis, which this integrand fails. The page now says so.

## Notes

- **Cosmetic label formatting.** The GIF's label uses `round(approx; digits=6)`, which drops trailing zeros: the 65-point frame shows "2.01537" for 2.015370 (mpmath 2.015369687). The value is correct, just shown with one digit fewer. This is not a round-1 finding, so it was not changed.
- **Pre-existing text.** The Animations intro ("Each frame recomputes … where $n$ remains a multiple of 4") and the alt text were checked against the frames and left unchanged.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: The false sentence ("converges rapidly with sixth-order global accuracy") is gone from index.qmd. Every claim in the new Behavior paragraph was checked independently (`check/indep.py`, mpmath at 40 digits):
  - Reference integral, computed two ways (substitution x = t^3 over [0, 2^{1/3}], and direct split quadrature over 60 pieces): both give I = 2.016279719617096327887274…, so "≈ 2.016280" is correct.
  - Composite Boole on the script's n sequence (4…120): every value increases on the previous one and every value is below I. The last frame (n = 120, 121 points) gives 2.015961179, and B − I = −3.185e-4. So "increases … staying below it", "2.015961" and "about 3.2×10⁻⁴ low" are all correct.
  - Near 0, f(x) = 1 + e^{-x} sin(8x^{2/3}) ≈ 1 + 8x^{2/3}, so f'(x) ≈ (16/3)x^{-1/3}. The page's formula is correct.
  - Error ratios on halving h: 60→120 gives 3.18196 (the page says "about 3.18"). Further halvings give 3.1796, 3.1774, 3.1761, 3.1755, 3.1751, 3.1750, 3.1749, tending to 2^{5/3} = 3.1748 (the page says "≈ 3.17"). log2 of the ratio goes from 1.6699 to 1.6667. So "O(h^{5/3}) rather than O(h^6)" is correct.
  - The Description now gives the condition for the O(h^6) bound (f ∈ C^6[a,b]), which is right.
- The script and GIF were not changed, and they did not need to be. The finding was a page/text mismatch, and the rule is implemented correctly.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd:17 (Description) | "exact for polynomials up to degree 5" | Boole on [0,1] with n=4, error for x^d: d=0..5 about 1e-41, d=6 3.7e-4 | correct |
| index.qmd:17 | "for smooth f (six times continuously differentiable on [a,b]), has global error O(h^6)" | Standard condition; error term involves f^{(6)}. Measured order 6 on a smooth control in the original review | correct |
| index.qmd:28 (Behavior) | "approximation increases from frame to frame" | Monotone increasing for all 23 n values. The first frame (n=0) shows no approximation, which is harmless | correct |
| index.qmd:28 | "toward the true integral ≈ 2.016280, staying below it" | I = 2.0162797196…; all B_n < I | correct |
| index.qmd:28 | "last frame (121 sample points) gives 2.015961" | B_120 = 2.015961179; the last GIF frame shows "Sample Points = 121, Approximation = 2.015961" | correct |
| index.qmd:28 | "about 3.2×10⁻⁴ low" | B_120 − I = −3.185e-4 | correct |
| index.qmd:28 | "f'(x) ≈ (16/3)x^{-1/3} near 0" | d/dx[8x^{2/3}] = (16/3)x^{-1/3}; e^{-x} → 1 | correct |
| index.qmd:28 | "textbook error order, which assumes smooth f, does not hold" | Measured order 1.667, not 6 | correct |
| index.qmd:28 | "O(h^{5/3}) rather than O(h^6)" | log2 ratios 1.6699 → 1.6667 | correct |
| index.qmd:28 | "halving h divides it by about 3.18 (from 60 to 120 subintervals)" | e60/e120 = 3.18196 | correct |
| index.qmd:28 | "tending to 2^{5/3} ≈ 3.17" | Ratios 3.1820 → 3.1749; 2^{5/3} = 3.17480 | correct |
| index.qmd:28 | "instead of 2^6 = 64" | arithmetic | correct |

### New problems
None. This rests on:
- every number and claim in the two changed lines being checked against a 40-digit reference;
- the full-size first, middle and last frames (frames 2, 12 and 24), plus the contact sheet, agreeing with the text. Their values are 1.553155, 2.014579 and 2.015961, which match B_4, B_44 and B_120.

Text the fix did not touch, such as "highest-order closed Newton-Cotes rule in this set" and the alt text, is unchanged and outside this finding.

### Reproducibility and conventions
- Only index.qmd changed in the page folder. boolesaa.jl and boolesaa.gif are identical to HEAD (`git diff --quiet HEAD` on both).
- boolesaa.jl was run from the scratch copy at `check/run/`. Its output is byte-identical to the committed boolesaa.gif (`cmp`). The GIF has 24 frames.
- Conventions are kept: Description comes before Animations, the case has a source link and an embed, the alt text is descriptive, and the page has no code blocks.
- Outside the page folder, the working tree has changes to many other numerical-methods pages and untracked `reviews/numerical-methods-animations/fixes/*.md`. These include `fixes/booles-rule.md`, which is the fixer's own note and not site content. These look like parallel fixes to other pages. Nothing outside the booles-rule folder belongs to this page's site content.

**Final status:** committed
