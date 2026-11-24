# Derive Numerical Differentiation Formulae — animation review (round 8)

Page: `pages/numerical-methods/derive-numerical-differentiation-formulae/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page agrees with values I computed independently, and all three scripts implement the stencils they name, with correct reference derivatives. Per the manifest, the committed GIFs are byte-identical to fresh scratch runs, so the frames show the current code.

Observations that do not rise to findings (cosmetic, or not content the page claims):
- Case 3: from about h = 0.18 on, the three curves cannot be told apart at this scale (the 3-point max error of 3.5e-3 is about 0.6 px). The page states the comparison in terms of the printed maximum errors, so it is not misleading.
- Case 3: in the early frames the legend box sits over the top-right part of the curves. It hides nothing the page discusses.
- Case 1: the "formula slope" line goes through (x0, f(x0)) with the secant slope. It is not the chord through x0 ± h. The legend says "formula slope", which is accurate. In later frames the red tangent is drawn on top of it, which fits "converging to the tangent".
- Case 1 annotation: `round(...; digits=6)` drops trailing zeros (for example "-0.11037" at h = 0.05). The values are still correct.
- No case heading states x0 = 1 (only the Case 1 alt text does). The page never states a wrong value, so this is not a finding.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `diffformaa.jl` | 0 | 8.2 | diffformaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `diffformab.jl` | 0 | 7.9 | diffformab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `diffformac.jl` | 0 | 8.2 | diffformac.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `diffformaa.gif` | 12 | byte-identical | diffformaa |
| `diffformab.gif` | 11 | byte-identical | diffformab |
| `diffformac.gif` | 11 | byte-identical | diffformac |

### Page references

- Scripts linked: `diffformaa.jl`, `diffformab.jl`, `diffformac.jl`
- GIFs embedded: 3
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | Description | formulas "derived from Taylor expansions and solved in parallel as small linear systems" | Describes the legacy method (archive gr_35, gr_128, gr_191). I re-derived all stencils this way in sympy (indep.py §1). | confirmed |
| 2 | Description | the legacy module derives first- and second-derivative formulas together | Archive text and gr_35/gr_128 solve for f' and f'' (and f''', f'''') at the same time | confirmed |
| 3 | Description | symmetric stencils give cancellation and "clear error orders" | sympy: 3-pt f', f'' are O(h^2); 5-pt f', f'' are O(h^4) | confirmed |
| 4 | Animations intro | test function f(x)=e^{-x} sin x | all three scripts: `f(x) = exp(-x) * sin(x)` | confirmed |
| 5 | Animations intro | Case 1 is three-point f'; Cases 2/3 compare three- and five-point for f' and f'' | diffformab plots d1_3 and d1_5; diffformac plots d2_3 and d2_5 | confirmed |
| 6 | Animations intro | legacy module "derives the formulas symbolically and has no numerical example" | Archive main page and lnk_1..3 contain only symbolic derivations and Mathematica subroutines; the graph-sized images are formula output | confirmed |
| 7 | Case 1 heading | f'(x0) ≈ (f(x0+h)−f(x0−h))/(2h) | diffformaa.jl:11 matches; sympy weights {−1/2, 0, 1/2} | confirmed |
| 8 | Case 1 Behavior | three-point slope converges to the tangent slope as h decreases | err: 6.14e-2 (h=0.6) … 1.69e-7 (h=0.001), decreasing every frame; script and mpmath agree to all printed digits | confirmed |
| 9 | Case 1 Behavior | "reflecting second-order accuracy" | err(0.01)/err(0.005) = 1.694e-5/4.236e-6 = 4.00; err(0.1)/err(0.05) = 4.00; sympy leading term h^2 f'''/6 | confirmed |
| 10 | Case 1 alt | stencil points and slope line converge to the tangent at x0 = 1 | x0 = 1.0 (diffformaa.jl:13); frames 1–12 show it | confirmed |
| 11 | Case 1 link/embed | diffformaa.jl / diffformaa.gif | wiring matches; GIF byte-identical to regen | confirmed |
| 12 | Case 2 heading | f'(x0) ≈ [f(x0−2h)−8f(x0−h)+8f(x0+h)−f(x0+2h)]/(12h) | diffformab.jl:13 matches; sympy weights {1/12, −2/3, 0, 2/3, −1/12}; exact for polynomials of degree ≤ 4, not 5 | confirmed |
| 13 | Case 2 Behavior | five-point error drops faster than three-point for the same h | err5 < err3 in all 11 frames; err5 ratio h 0.01→0.005 = 1.477e-10/9.239e-12 = 16.0 (order 4) | confirmed |
| 14 | Case 2 Behavior | green five-point line already lies on the red tangent at h = 0.35 | |err5| = 1.92e-4 (script and mpmath); frame 1 shows the green line on the red one | confirmed |
| 15 | Case 2 Behavior | "the two lines differ by about 0.1 pixel at their ends" | slope difference × 0.9 = 1.73e-4 y-units; plot area about 389 px for 0.65 units, so 0.10 px | confirmed |
| 16 | Case 2 Behavior | five-point error read from the |err5| printed in each frame | annotation at diffformab.jl:65; frames show err5 values matching the computed ones (1.92e-4 … 2.16e-13) | confirmed |
| 17 | Case 2 alt | dashed three-point line approaching the tangent, five-point line on the tangent in every frame, both errors printed | frames 1–11 (sheet) | confirmed |
| 18 | Case 2 link/embed | diffformab.jl / diffformab.gif | matches; byte-identical regen | confirmed |
| 19 | Case 3 heading/Behavior | second-derivative formulas on [2h, π−2h]; "both stencils use only points in [0,π]" | diffformac.jl:23 `xinner = range(2h, pi-2h, 700)`; the widest stencil reaches x ± 2h, which stays in [0, π] | confirmed |
| 20 | Case 3 Behavior | the max errors in each frame are taken over this window | diffformac.jl:29–30 use xinner (700-point grid) | confirmed |
| 21 | Case 3 Behavior | from h = 0.35 to h = 0.005 both max errors shrink | err3: 1.31e-2→2.69e-6; err5: 5.16e-4→5.52e-11, monotone (instr.jl and mpmath) | confirmed |
| 22 | Case 3 Behavior | the five-point stencil stays closer in every frame | err5 < err3 in all 11 frames | confirmed |
| 23 | Case 3 Behavior | at h = 0.002 the five-point max error rises from 5.5e-11 to 5.9e-11 | float64: 5.516e-11 → 5.892e-11 (Julia and numpy) | confirmed |
| 24 | Case 3 Behavior | the rise is because rounding outweighs truncation | 50-digit truncation-only error: 5.50e-11 at h = 0.005 (so float there is truncation) and 1.42e-12 at h = 0.002, which is 40 times below the observed 5.89e-11 | confirmed |
| 25 | Case 3 alt | exact curve on 0 to π, stencil curves on 2h to π−2h | xtrue on [0, π] (line 21), xinner on [2h, π−2h]; frame 1 shows the stencil curves starting at 0.7 | confirmed |
| 26 | Case 3 link/embed | diffformac.jl / diffformac.gif | matches; byte-identical regen | confirmed |
| 27 | Derivation Notes | Taylor expansion of f(x ± h) | standard; signs and factorials correct | confirmed |
| 28 | Derivation Notes | f' central formula + O(h^2), f'' central formula + O(h^2) | sympy: leading error terms h^2/6 f''' and h^2/12 f'''' | confirmed |
| 29 | Derivation Notes | five-point f', f'' are O(h^4); five-point f''', f'''' are only O(h^2) | sympy leading-term orders 4, 4, 2, 2; agrees with archive gr_128 (h^2 f^(5) and h^2 f^(6) remainders) | confirmed |

### 3. Implementation checks

### diffformaa.jl (Case 1)
- **Method:** `d1_3(x,h) = (f(x+h)-f(x-h))/(2h)` is the central three-point first-derivative formula. sympy solving the Taylor system on {−1, 0, 1} gives weights (−1/2, 0, 1/2) with error h^2 f'''/6. Exact for degree ≤ 2, not 3.
- **Numbers:** script (instr.jl) against 50-digit mpmath, approx at x0 = 1:
  h=0.6 −0.049353742675 / −0.04935374268; 0.25 −0.100189411390 / −0.1001894114; 0.05 −0.110370137249 / −0.1103701372; 0.001 −0.110793595865 / −0.1107935959. All 12 agree.
- **Reference:** `fp(x) = e^{-x}(cos x − sin x)` checked symbolically (sympy); fp(1) = −0.110793765306699 in both.
- **Picture:** orange points at x0−h, x0, x0+h on f; the dashed line goes through (x0, f(x0)) with slope `approx`; the red tangent has slope `fp(x0)`; the annotation prints both rounded to 6 digits and matches the computed values. Axis limits contain every element (line ends at y 0.21–0.41; f on [0, π] is within [0, 0.3224]). 12 frames, one per h.

### diffformab.jl (Case 2)
- **Method:** `d1_5` coefficients match the sympy solve (1/12, −2/3, 0, 2/3, −1/12), leading error −h^4 f^(5)/30. Exact for polynomials of degree ≤ 4, not 5. `d1_3` as in Case 1.
- **Numbers:** err3 / err5 from the script against mpmath: 0.35: 2.08e-2/1.92e-4 against 2.08e-2/1.92e-4; 0.05: 4.24e-4/9.21e-8 against same; 0.005: 4.24e-6/9.24e-12 against 4.24e-6/9.23e-12; 0.002: 6.78e-7/2.16e-13 against 6.78e-7/2.36e-13 (rounding at about 10% level in float64; the page makes no claim about this frame).
- **Reference:** same fp as Case 1, verified.
- **Picture:** five stencil points at x0 + {−2, −1, 0, 1, 2}h; three lines through (x0, f(x0)) with slopes approx3, approx5 and exact; the annotation matches the computed errors. The code comment "differ by at most |err5| = 1.92e-4" is correct (largest at h = 0.35). 11 frames.

### diffformac.jl (Case 3)
- **Method:** `d2_3` weights (1, −2, 1)/h^2 and `d2_5` weights (−1, 16, −30, 16, −1)/(12h^2) both match the sympy solve (−1/12, 4/3, −5/2, …). Degree of exactness 3 and 5, not 4 and 6. Leading errors h^2 f''''/12 and −h^4 f^(6)/90.
- **Numbers:** max errors over the script's 700-point grid, script (float64) against mpmath (truncation only): 0.35: 1.31e-2/5.16e-4 against 1.31e-2/5.16e-4; 0.08: 6.87e-4/3.06e-6 against same; 0.01: 1.07e-5/8.71e-10 against same; 0.005: 2.69e-6/5.52e-11 against 2.69e-6/5.50e-11; 0.002: 4.30e-7/5.89e-11 against 4.30e-7/1.42e-12. The last pair is rounding error, as the page says.
- **Reference:** `fpp(x) = −2e^{-x} cos x` checked symbolically; range on [0, π] is [−2.000, 0.134], inside ylims (−2.1, 0.2).
- **Picture:** the exact curve on [0, π] and the stencil curves on [2h, π−2h]; the annotation matches the computed maxima. Only frame 1 (and faintly frame 2) shows a visible gap. In later frames the comparison is carried by the printed numbers, which is how the page phrases it. 11 frames.

### Fidelity to the legacy archive
The archive (Mathews 2003/2004) is purely symbolic: Taylor systems solved in Mathematica for 3- and 5-point central formulas, plus forward/backward and higher-order subroutines, with no test function, h values or plots of numerical behaviour. The page says it chose its own test function, and its formulas and error orders (including the O(h^2) for five-point f''' and f'''') agree with the archive's results (gr_35, gr_128). The forward/backward formulas are not animated, but that is content the page does not yet have, not a contradiction. No fidelity findings.

