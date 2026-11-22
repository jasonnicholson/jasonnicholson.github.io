# Fix record: newton-cotes-integration

Scratch folder (all evidence, re-runnable):
`/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/work/newton-cotes-integration/fix/`
(below written as `$FIX`). Scripts are in `$FIX/scripts/`, outputs in `$FIX/*.out`.

- `order.py` (`/usr/bin/python3 -I order.py > ../order.out`): independent of the repo. It computes the reference integral and the sympy series of $f'$, solves the moment equations for the weights, finds degree of precision and composite error constants exactly, and evaluates composite sums in mpmath at 40 digits. It also measures doubling ratios, the 24→48 pair, every animation frame's value, in-animation pairs and LS slopes, compares the rules at equal n, and runs a smooth $e^x$ control.
- `extra.py` (`/usr/bin/python3 -I extra.py > ../extra.out`): closed Newton-Cotes weights and degree of precision for m = 1..10, and the error ratios trapezoid/other rule at equal n for n = 12·2^k up to 12288.
- `s38_vs_s13.py` (`/usr/bin/python3 -I s38_vs_s13.py > ../s38_vs_s13.out`): |E₃/₈|/|E₁/₃| at every common n (divisible by 6) from 6 to 6000.
- `script_values.jl` (`julia script_values.jl > ../script_values.out`): an instrumented copy of the four repo scripts. It takes each script's own text up to the animation loop, without Plots. It prints every labelled frame value, the errors on x^k over [0,2], and the $e^x$ ratios.

## Findings

### F1 — Misleading — fixed

- **Reproduced.** The checker's correction applies: lines 43 and 61 are misleading, and line 13 is accurate.
  - `order.py`, sympy, exact: the panel weights are h·(1/2,1/2), h·(1/3,4/3,1/3), h·(3/8,9/8,9/8,3/8) and h·(14/45,64/45,8/15,64/45,14/45).
    - Degrees of precision are **1, 3, 3, 5** and orders p = 2, 4, 4, 6.
    - Composite constants C in |Q−I| = C(b−a)hᵖ|f⁽ᵖ⁾| are 1/12, **1/180, 1/80**, 2/945.
  - `script_values.jl` runs the scripts' own sums for one panel on [0,2] with x^k:
    - trapezoid: exact to k=1, k=2 error 1.33;
    - Simpson 1/3: exact to k=3, k=4 error 0.267;
    - Simpson 3/8: exact to k=3, k=4 error 0.119;
    - Boole: exact to k=5, k=6 error 0.0476.
  - Smooth control ($e^x$ on [0,2], mpmath) gives ratios E(n)/E(2n) → 3.99999, 15.9998, 15.9997, 63.9973. At n=1536, E₃/₈/E₁/₃ = 2.25 (= 180/80).
  - `extra.py`: for m = 1..10, degree of precision is m+1 for even m and m for odd m.
- **Change:** `index.qmd`, text only.
  - Line 43 (Case 3 Behavior):
    - before: "cubics, giving a higher-order piecewise fit to the curve."
    - after: a higher-degree fit than Simpson 1/3, but not a higher-order rule, since both have degree of precision 3. On this integrand its error at the same h is larger, about 1.25 times Simpson's 1/3 error as h shrinks.
  - Line 61 (Derivation Notes): "increases algebraic order by fitting higher-degree interpolants…" is replaced by:
    - interpolant degrees 1–4 against degrees of precision 1, 3, 3, 5, with the even-subinterval rules gaining a degree;
    - for smooth f ($C^2$, $C^4$, $C^4$, $C^6$), orders $O(h^2)$, $O(h^4)$, $O(h^4)$, $O(h^6)$;
    - Simpson 3/8 is not higher order than 1/3 and has the larger constant (1/80 against 1/180);
    - the existing caveat about very high degree is kept.
  - Line 13 is unchanged, per the checker's correction.
- **Check:** every number was recomputed (ledger). `git diff` shows only lines 23, 43 and 61 of `index.qmd` changed.

### F2 — Minor — fixed

- **Reproduced:** `order.py`.
  - $I = 2.01627971961709632788727442192$. The substitution $x=t^3$ and direct tanh-sinh on 80 panels differ by $-4.6\times10^{-41}$.
  - sympy: $f'$ = `16/(3*x**(1/3)) + O(1)` at 0.
  - Doubling n = 12·2^k gives ratio E(n/2)/E(n) and p at n=12288:

    | Rule | Ratio at n=24 → 12288 | p at 12288 |
    |---|---|---|
    | Trapezoid | 3.076 → 3.17309 (rising) | 1.6659 |
    | Simpson 1/3 | 4.235 → 3.17494 (falling) | 1.6667 |
    | Simpson 3/8 | 5.030 → 3.17497 | 1.6667 |
    | Boole | 3.233 → 3.1749 | 1.6667 |

    For comparison, $2^{5/3} = 3.1748$.
  - At 121 points the errors are: trapezoid −1.34e−3, 3/8 −4.69e−4, Boole −3.19e−4. These match the round-1 values.
  - The smooth control gives 4/16/16/64, so the code is not the cause.
  - The finding holds.
- **Change:** `index.qmd` line 23, the Animations intro paragraph shared by all four cases. Three sentences were appended:
  - the D1 cause sentence, verbatim;
  - the D1 measured-rate sentence, giving each rule's own 24→48 ratio (3.14, 3.38, 3.55, 3.15), the limit $2^{5/3}\approx3.17$, and the textbook factors 4, 16, 16, 64;
  - one sentence saying the higher-degree rules gain only a constant factor over the trapezoidal rule here, not extra powers of h.

  The textbook orders now appear only in Derivation Notes, labelled "For smooth f" with the $C^k$ hypotheses (see F1).
- **Check:** see the ledger.

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd:23 | "The $x^{2/3}$ term makes $f'$ unbounded at $x=0$ ($f'(x)\approx\tfrac{16}{3}x^{-1/3}$ near $0$), so the textbook error order, which assumes smooth $f$, does not hold for this integrand." (D1 verbatim) | `order.py` → `f' series at 0: 16/(3*x**(1/3)) + O(1)`; measured p → 1.6659–1.6667 ≠ 2,4,4,6 | yes |
| index.qmd:23 | "measured error of all four rules shrinks like $O(h^{5/3})$" | `order.py` doubling: p at n=12288 = 1.6659, 1.6667, 1.6667, 1.6667 | yes |
| index.qmd:23 | "rather than $O(h^2)$, $O(h^4)$, $O(h^4)$ and $O(h^6)$" | `order.py` exact: p = 2, 4, 4, 6 (dop 1,3,3,5); smooth control ratios → 4, 16, 16, 64 | yes |
| index.qmd:23 | "halving $h$ (from 24 to 48 subintervals) divides it by about 3.14, 3.38, 3.55 and 3.15" (trap, S1/3, S3/8, Boole) | `order.py` "pair 24 -> 48": 3.1415, 3.3803, 3.5499, 3.1513. n=24 and 48 are frames of aa, cc and dd. Simpson 1/3's animation stops at n=40, so for it the pair is a property of the rule, not two frames. Its in-animation 20→40 ratio is 3.489. | yes |
| index.qmd:23 | "tending to $2^{5/3}\approx3.17$ for each" | `order.py`: ratios at 12288 are 3.17309, 3.17494, 3.17497, 3.1749. $2^{5/3}$ = 3.1748. | yes |
| index.qmd:23 | "instead of 4, 16, 16 and 64" | $2^p$ with p = 2,4,4,6; control `order.py` → 3.99999, 15.9998, 15.9997, 63.9973 | yes |
| index.qmd:23 | "at equal $h$ the higher-degree rules gain only a constant factor over the trapezoidal rule here, not extra powers of $h$" | `extra.py`: E_trap/E_rule at n=48…12288 is 3.49→3.63 (S1/3), 2.75→2.89 (S3/8) and 4.15→4.24 (Boole). The increments shrink (e.g. Boole +0.0044, +0.0032, +0.0024), so each ratio settles to a constant. All ratios are > 1 for n = 12·2^k, 12…12288 (`order.py` equal-n table, n = 12…3840). | yes |
| index.qmd:43 | "Triplets of subintervals are approximated by cubics." | script `newtoncotescc.jl` fits `poly_coeffs` on 4 nodes per panel (i in 0:3:n−3); frame_003 viewed | yes |
| index.qmd:43 | "a higher-degree piecewise fit than Simpson's 1/3 rule, but not a higher-order rule: both have degree of precision 3" | `order.py`: dop 3 and 3; `script_values.jl`: both of the scripts' sums are exact to k=3 and fail at k=4 | yes |
| index.qmd:43 | "On this integrand its error at the same $h$ is larger, about 1.25 times Simpson's 1/3 error as $h$ shrinks" | `s38_vs_s13.py`: for every n divisible by 6 from 6 to 6000, ratio > 1 (min 1.2542 at 6000, max 1.5841 at 12), and the ratio is 1.2542 from n≈5988. `extra.py` at 12288 gives 1.2541. | yes |
| index.qmd:61 | "fit interpolants of degree 1, 2, 3 and 4 per panel" | 2,3,4,5 nodes per panel in the four scripts; `extra.py` m=1..4 | yes |
| index.qmd:61 | "degrees of precision are 1, 3, 3 and 5" | `order.py` exact; `script_values.jl` exactness on x^k; archive corollary (8)–(11) states 1, 3, 3, 5 | yes |
| index.qmd:61 | "the rules with an even number of subintervals per panel (Simpson's 1/3, Boole) are exact for one degree more than their interpolant" | `extra.py`: m=2 dop 3, m=4 dop 5 (and m=6,8,10 likewise; odd m have dop m) | yes |
| index.qmd:61 | "For smooth $f$ ($C^2$, $C^4$, $C^4$ and $C^6$ on $[a,b]$ respectively)" | Archive images `NewtonCotesMod_gr_36/38/41/43.gif` read f ∈ C²[a,b], C⁴[a,b], C⁴[a,b], C⁶[a,b] | yes |
| index.qmd:61 | "composite errors are therefore $O(h^2)$, $O(h^4)$, $O(h^4)$ and $O(h^6)$" | `order.py` exact constants with p = 2,4,4,6; smooth control ratios 4/16/16/64 | yes |
| index.qmd:61 | "Simpson's 3/8 rule is thus not higher order than Simpson's 1/3 rule" | both p = 4 (`order.py`); control 15.9998 vs 15.9997 | yes |
| index.qmd:61 | "$\lvert E\rvert=\tfrac{1}{80}(b-a)h^4\lvert f^{(4)}(\xi)\rvert$ against $\tfrac{1}{180}(b-a)h^4\lvert f^{(4)}(\xi)\rvert$" | `order.py`: C = 1/80 and 1/180. Archive single-panel terms are $-\tfrac{3}{80}f^{(4)}h^5$ per 3h panel (gr_42) and $-\tfrac{1}{90}f^{(4)}h^5$ per 2h panel (gr_39), giving the same composite constants. Control at n=1536 on $e^x$: E₃/₈/E₁/₃ = 2.25. | yes |
| index.qmd:61 | "Rules of very high degree on wide panels can become less robust." (old claim, reworded) | `extra.py`: closed rules get negative weights at m=8 (min −3632/2835, Σ\|w\|/m = 1.45) and m=10 (Σ\|w\|/m = 3.06) | yes |

The case headings, alt texts and GIF titles are unchanged, and none of them makes an order or rate claim. The Case 3 alt text says "piecewise cubic area updates", which matches the script.

## Scripts and GIFs

- **No script was changed and no GIF was regenerated.** The animations are correct.
  - The four quadrature routines are correct composite rules: the exact weights match, and the smooth control reaches the textbook orders.
  - All 92 labelled frame values from `script_values.jl` match the 40-digit mpmath sums rounded to 6 digits (scripted comparison, `True`, 92/92).
- **Frames.** Frames of all four committed GIFs were extracted to `$FIX/orig_aa`, `orig_bb`, `orig_cc` and `orig_dd` (25, 21, 25 and 25 frames).
  - Viewed the contact sheet for cc and frame_003 of cc at full size ("Sample Points = 7, Approximation = 1.79047", which matches n=6, 1.790470).
  - The last cc frame reads 2.01581, which matches 2.015810.
  - The panels are built from f at the nodes.
  - The new text cites no frame value.
- `git status --short -- pages/numerical-methods/newton-cotes-integration` → ` M pages/numerical-methods/newton-cotes-integration/index.qmd` (only).

## Legacy archive

Consulted.

- **The module.** `n2003/NewtonCotesMod.html` states the corollary: degree of precision 1, 3, 3, 5 with hypotheses f ∈ C², C⁴, C⁴, C⁶ (images gr_36/38/41/43). Its error terms are $-\tfrac{1}{90}f^{(4)}h^5$ (Simpson, gr_39) and $-\tfrac{3}{80}f^{(4)}h^5$ (3/8, gr_42). It agrees with the fixed text.
- **The animations.** The module links to `a2001/Animations/Quadrature/{Trapezoidal,Simpson,Simpson38,Boole}`.
  - Frames were extracted to `$FIX/legacy/{Simpson,Simpson38,Boole}`.
  - They use the same $y=e^{-x}\sin(8x^{2/3})+1$ on [0,2].
  - Their labels agree with ours to 6 digits:
    - Simpson: 2.491261, 1.840560, 1.976389, 1.998814, 2.006018, 2.009329, 2.011175, 2.012331, 2.013112, 2.013669.
    - 3/8: 1.884214, 1.927234, 1.994094, 2.008397, 2.012595, 2.014059, 2.014767, 2.015170, 2.015425, and 2.015810 at 121 points. Legacy 106 points (2.015692) is not one of our frames.
    - Boole: 1.553155, 2.001295, 2.010045, 2.012680, 2.013905, 2.014809, 2.015370, 2.015653, 2.015817, 2.015922.
- **Where the archive and the page differ.** The archive's animations make no order claim for this integrand. Its general orders hold only under the $C^k$ hypotheses, which this integrand fails at x=0. The page now says so, and the integrand is kept per D1.

## Notes

- **D1 placement.** This page has four Behavior paragraphs and no order claim in any of them, and one intro paragraph (line 23) covers all four cases. The D1 cause and measured-rate sentences went into that intro paragraph once, rather than being repeated four times.
  - The measured sentence lists each rule's own 24→48 ratio.
  - For Simpson 1/3, n=48 is not a frame (its animation stops at 40), so the 24→48 ratio is a property of the rule on this integrand. Its in-animation 20→40 ratio is 3.489.
- **Labelled textbook orders.** The page's Description has no order statement. The labelled textbook orders went into Derivation Notes line 61, where F1 located the claim, rather than being added to the Description.
- **Not touched: legacy note (line 57).** The page's legacy note says the archive is incomplete, "notably Simpson's 3/8 GIF". That is false for this archive copy: `a2001/Animations/Quadrature/Simpson38/Simpsonaa.gif` exists and is a 3/8 animation of the same integrand, with values that match ours. This is a legacy-inventory stub that no finding names, so it was not changed. Jason may want to correct or remove it.
- **Not touched: label formatting.** The scripts label values with `round(approx; digits=6)`, which drops trailing zeros (for example "2.01581" for 2.015810 and "1.79047" for 1.790470). The values are correct, so this is cosmetic, no finding names it, and it was not changed.
- **Outside this page.** Nothing outside the page folder and this record was touched.

## Resolution check (independent checker, not shown this record)

Scope of the fix: only `index.qmd` changed (fix.diff; `git diff --quiet HEAD` on the page's `.jl` and `.gif` files is clean). Three text edits: Animations intro (line 23), Case 3 Behavior (line 43), Derivation Notes (line 61).

Independent tools (scratch): `check.py` (sympy moment equations for weights / degree of precision / composite error constants; mpmath 40-digit reference integral computed two ways; my own composite rules from the exact weights; errors at n = 12·2^k up to 6144), `smooth2.py` (e^x control).

### Original findings

### F1 — resolved
- Evidence: The false sentence at old line 61 ("increases algebraic order by fitting higher-degree interpolants") is gone; the replacement states interpolant degrees 1,2,3,4 vs degrees of precision 1,3,3,5, explains the even-subinterval extra degree, gives O(h^2), O(h^4), O(h^4), O(h^6), and says 3/8 is not higher order than 1/3 with larger constant 1/80 vs 1/180. Line 43 no longer says "higher-order"; it now says higher-degree fit but not higher-order, both degree of precision 3.
- My computation: sympy moment equations give weights (1/2,1/2), (1/3,4/3,1/3), (3/8,9/8,9/8,3/8), (14/45,64/45,8/15,64/45,14/45), degree of precision 1, 3, 3, 5; composite error constants (exact − approx)/((b−a)h^p f^(p)) = −1/12, −1/180, −1/80, −2/945. Smooth control e^x on [0,2]: halving ratios → 4.00, 16.00, 16.00, 63.99; 3/8-to-1/3 error ratio → 2.25 (= 180/80).
- Line 13 ("trapezoidal (degree 1) ... Boole (degree 4)") is unchanged; it is accurate as interpolant degree and is now disambiguated by the Derivation Notes, consistent with the independent check's correction.

### F2 — resolved
- Evidence: New text after line 23 states f' is unbounded at 0, the smooth-f orders do not apply, and all four rules converge like O(h^{5/3}) with ratios tending to 2^{5/3}, so higher-degree rules gain only a constant factor. All numbers verified (ledger below). Reference I = 2.016279719617096327887274421915… identical by adaptive quadrature and by the x = u^3 substitution.
- Asymptotic errors (n = 6144): trap −1.908e−6, S13 −5.261e−7, S38 −6.598e−7, Boole −4.498e−7; ratios to trap 0.276, 0.346, 0.236 — constant factors, consistent with the closed forms S13 = (4T_h − T_2h)/3 ⇒ factor (4−2^β)/3, S38 = (9T_h − T_3h)/8 ⇒ (9−3^β)/8, Boole ⇒ (4−2^β)(16−2^β)/45, β = 5/3.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd:23 | f' unbounded at x=0, f'(x) ≈ (16/3)x^{-1/3} near 0 | d/dx e^{-x}sin(8x^{2/3}) = e^{-x}[cos(8x^{2/3})(16/3)x^{-1/3} − sin(·)] → (16/3)x^{-1/3} | correct |
| index.qmd:23 | textbook order assumes smooth f, does not hold here | measured ratios ≈3.17 for all four, not 4/16/16/64 | correct |
| index.qmd:23 | all four rules O(h^{5/3}) | ratios at n=3072→6144: trap 3.1726, S13 3.1751, S38 3.1751, Boole 3.1750; theory: endpoint x^{2/3} singularity ⇒ h^{1+2/3} | correct |
| index.qmd:23 | "rather than O(h^2), O(h^4), O(h^4), O(h^6)" | smooth control ratios 4, 16, 16, 64 | correct |
| index.qmd:23 | 24→48 ratios 3.14, 3.38, 3.55, 3.15 | computed 3.1415, 3.3803, 3.5499, 3.1513 | correct |
| index.qmd:23 | tending to 2^{5/3} ≈ 3.17 | 2^{5/3} = 3.1748; measured limits above | correct |
| index.qmd:23 | "instead of 4, 16, 16 and 64" | e^x control: 4.00, 16.00, 16.00, 63.99 | correct |
| index.qmd:23 | at equal h higher-degree rules gain only a constant factor over trapezoid | error ratios to trap stabilise at 0.276 / 0.346 / 0.236 | correct |
| index.qmd:43 | cubics on triplets; higher-degree fit but not higher order; both degree of precision 3 | sympy: DOP 3 and 3 | correct |
| index.qmd:43 | error ≈ 1.25 × Simpson 1/3 error as h shrinks (this integrand) | S38/S13 ratio: 1.584 (n=12), 1.334 (24), 1.270 (48), 1.258 (96) … 1.2542 (6144); closed form [(9−3^{5/3})/8]/[(4−2^{5/3})/3] = 1.2541 | correct ("as h shrinks" covers the larger ratios at the coarse frames) |
| index.qmd:61 | interpolant degrees 1,2,3,4; DOP 1,3,3,5 | sympy | correct |
| index.qmd:61 | even-subinterval rules (S13, Boole) exact for one degree more than interpolant | DOP 3 vs deg 2, 5 vs deg 4; trap/3-8 (odd) no gain | correct |
| index.qmd:61 | smooth f: C^2, C^4, C^4, C^6; composite errors O(h^2), O(h^4), O(h^4), O(h^6) | standard error-term derivative requirements; e^x ratios confirm orders | correct |
| index.qmd:61 | 3/8 not higher order than 1/3 | same DOP, same measured order | correct |
| index.qmd:61 | \|E\| = (1/80)(b−a)h^4\|f^{(4)}(ξ)\| vs (1/180)(b−a)h^4\|f^{(4)}(ξ)\| | sympy composite constants −1/80, −1/180; e^x error ratio → 2.2500 | correct |
| index.qmd:61 | very high degree on wide panels less robust | kept from old text; true (closed NC weights go negative at 8 and ≥10 points) | correct |

### New problems
None. Rests on: every changed sentence and number above checked by independent exact/high-precision computation; no script or GIF changed (git diff clean for `*.jl`, `*.gif` in the page folder), so no picture could have regressed; frames of newtoncotescc.gif (25 frames, contact sheet and last frame at full size) still show the 3/8 construction, labels legible, final "Sample Points = 121, Approximation = 2.01581" consistent with I − 4.69e−4.

### Reproducibility and conventions
- No script changed, so no GIF needed regeneration; committed GIFs equal HEAD, and Phase 1 already established byte-identical regeneration (4/4).
- Conventions intact: Description precedes Animations; each of the four cases keeps its `[Julia source]` link and GIF embed with descriptive alt text; no code blocks added.
- Outside the page folder: fix.diff touches only this page. The working tree also has `pages/numerical-methods/index.qmd` modified (link changes for Milne-Simpson / Predictor-Corrector / Shooting pages, unrelated to this page) and an untracked `reviews/numerical-methods-animations/fixes/newton-cotes-integration.md` (workflow report). Neither changes this page's content; the section index still links `newton-cotes-integration/`.

**Final status:** committed
