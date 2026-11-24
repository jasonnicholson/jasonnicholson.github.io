# Derive Numerical Differentiation Formulae — animation review (round 9)

Page: `pages/numerical-methods/derive-numerical-differentiation-formulae/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**Error: 0. Misleading: 0. Minor: 0.**

I found nothing to report. Below are the things I checked and decided were not findings:
- **Case 3 legend.** The legend (topright) covers the curves for about x in [2.45, 3.04], y near 0.1. All three curves coincide there and the max-error values are printed, so a viewer would not conclude anything wrong. This is cosmetic.
- **Case 1 slope line.** The dashed "formula slope" line goes through (x0, f(x0)) with the central-difference slope. It does not go through the outer stencil points. The legend label is accurate, and the page never calls it a secant, so this is a valid display choice.
- **Forward and backward formulas.** The archive's appendix also generates forward and backward difference formulas. The page says it covers central formulas. This counts as content the page does not have yet, not a fidelity departure. The archive has no numerical example, and the page says so.
- **Missing five-point f'' formula.** The page never writes out the five-point f'' formula that Case 3 uses. That is also content the page does not have; the script's formula itself is correct (see below).



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `diffformaa.jl` | 0 | 16.0 | diffformaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `diffformab.jl` | 0 | 7.9 | diffformab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `diffformac.jl` | 0 | 10.2 | diffformac.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Location | Claim (page's words) | Verdict | Evidence |
|---|---|---|---|---|
| 1 | Description L12 | central finite-difference formulas "are derived from Taylor expansions and solved in parallel as small linear systems" | confirmed | Archive gr_35/gr_128/gr_191 show exactly this. sympy solving the k=1 and k=2 systems gives the 3- and 5-point formulas (indep.out). |
| 2 | L12 | legacy module derives first- and second-derivative formulas together | confirmed | Archive text: "parallel development of the numerical differentiation formulas". |
| 3 | L14 | symmetric stencils cancel odd/even Taylor terms, giving formulas with clear error orders; wider stencils improve accuracy for smooth f | confirmed | The series error terms contain only even powers of h (indep.out). The 5-point errors are far below the 3-point ones at every h. |
| 4 | L18 | test function f(x)=e^{-x} sin x in every case | confirmed | Line 8/9/9 of the three scripts. |
| 5 | L18 | Case 1 three-point f'; Cases 2 and 3 compare 3- and 5-point for f' and f'' | confirmed | Scripts and frames. |
| 6 | L18 | legacy module is symbolic only, with no numerical example | confirmed | All archive HTML text and graph-sized images are derivations or code. None has a numeric example or plot. |
| 7 | Case 1 heading | f'(x0) ≈ (f(x0+h)-f(x0-h))/(2h) | confirmed | diffformaa.jl L11; sympy d1 (k=1). |
| 8 | Case 1 Behavior | three-point slope converges to the tangent slope as h decreases | confirmed | Errors fall monotonically: 6.144e-2 to 1.694e-7 over the 12 h values (instr.out = mpmath). |
| 9 | Case 1 Behavior | reflects second-order accuracy | confirmed | Ratios: h 0.6 to 0.4 gives 2.259 (theory 2.25); 0.01 to 0.005 gives 4.000; 0.005 to 0.001 gives 25.0. Series error a^3 h^2/6. |
| 10 | Case 1 alt | stencil points and slope line converging to the tangent at x0 = 1 | confirmed | x0 = 1.0 (L13); frames 1-12. |
| 11 | Case 2 heading | f'(x0) ≈ [f(x0-2h)-8f(x0-h)+8f(x0+h)-f(x0+2h)]/(12h) | confirmed | diffformab.jl L13; sympy d1 (k=2) = -(8fm1-fm2-8fp1+fp2)/(12h). |
| 12 | Case 2 Behavior | the five-point stencil cancels lower-order truncation terms, so its error drops faster than the three-point estimate for the same h | confirmed | Series error -a^5 h^4/30, i.e. O(h^4). err5/err3 = 9.2e-3 at h=0.35 and 3.2e-7 at h=0.002. Ratio for h 0.02 to 0.01 is 16.0. |
| 13 | Case 2 Behavior | the green five-point line already lies on the red true tangent at h=0.35 | confirmed | frame_001. |
| 14 | Case 2 Behavior | the two lines differ by about 0.1 pixel at their ends | confirmed | Slope difference 1.9193e-4 times half-width 0.9 = 1.727e-4 y-units. Gridlines in frame_001 are 60 px per 0.1 (rows 116/176/236/296/356), so the gap is 0.104 px. |
| 15 | Case 2 Behavior | the five-point error size is read from the \|err5\| printed in each frame | confirmed | Every frame prints \|err5\|. The values match instr.out (1.92e-04 ... 2.16e-13). |
| 16 | Case 2 alt | dashed three-point line approaches the tangent; five-point line lies on the tangent in every frame; both errors printed | confirmed | Contact sheet; claim 14 gives at most 0.104 px. |
| 17 | Case 3 heading/Behavior | stencil curves on [2h, π-2h], where both stencils use only points in [0, π] | confirmed | diffformac.jl L23. At x = 2h the leftmost node is 0; at π-2h the rightmost node is π. |
| 18 | Case 3 Behavior | max errors in each frame are taken over this window | confirmed | L29-30 use xinner. |
| 19 | Case 3 Behavior | from h=0.35 to h=0.005 both max errors shrink | confirmed | 3-pt: 1.306e-2 to 2.687e-6, monotone. 5-pt: 5.158e-4 to 5.516e-11, monotone (instr.out, numpy). |
| 20 | Case 3 Behavior | five-point stays closer in every frame | confirmed | max5 < max3 in all 11 frames, including h=0.002 (5.89e-11 vs 4.30e-7). |
| 21 | Case 3 Behavior | at h=0.002 the five-point max error rises from 5.5e-11 to 5.9e-11 | confirmed | 5.5163e-11 to 5.8920e-11 (Julia); numpy gives 5.516e-11 and 5.892e-11. |
| 22 | Case 3 Behavior | the rise is because floating-point rounding outweighs truncation | confirmed | Exact-arithmetic (mpmath) truncation max at h=0.002 is 1.417e-12, against 5.89e-11 in float64. At h=0.005 truncation is 5.500e-11 and float64 gives 5.516e-11, so that step is still truncation-dominated. |
| 23 | Case 3 alt | exact curve on [0, π], stencil curves on [2h, π-2h] | confirmed | L21/L23; frame_001 stencil curves start at 0.7. |
| 24 | Wiring | Case 1/2/3 link and embed aa/ab/ac | confirmed | index.qmd L24/26, L32/34, L40/42. The manifest says the page is linked from the section index. |
| 25 | Derivation Notes | Taylor expansion of f(x±h) | confirmed | Standard; signs correct. |
| 26 | Derivation Notes | f' central = O(h^2), f'' 3-point = O(h^2) | confirmed | Series errors a^3 h^2/6 and a^4 h^2/12. |
| 27 | Derivation Notes | five-point f', f'' are O(h^4); five-point f''', f^(4) are only O(h^2) | confirmed | sympy: -a^5 h^4/30, -a^6 h^4/90, a^5 h^2/4, a^6 h^2/6. The archive text says the same. |

### 3. Implementation checks

### diffformaa.jl (Case 1)
- **Method.** The script implements the central three-point first derivative (L11). It matches the sympy derivation.
- **Numbers.** All 12 annotated approximations match an independent mpmath computation to the 6 printed digits. Examples: h=0.6 gives -0.0493537 (script) and -0.04935374268 (mpmath); h=0.001 gives -0.1107936 and -0.1107935959. The error ratios show second order (claim 9).
- **Reference.** fp(x) = e^{-x}(cos x - sin x). sympy confirms that d/dx f - fp = 0. fp(1) = -0.1107937653 agrees with mpmath.diff.
- **Picture.** Stencil points are at x0-h, x0, x0+h on f. The dashed line has the formula slope through (x0, f(x0)), and the red tangent uses the exact slope. Title and annotation show the frame's h and values. ylims (-0.1, 0.55) hold all elements, and there is no clamping. There are 12 frames (h from 0.6 to 0.001).

### diffformab.jl (Case 2)
- **Method.** The script implements the five-point first derivative (L13), with the three-point formula for comparison. It matches the sympy k=2 solution.
- **Numbers.** \|err3\| and \|err5\| in all 11 frames match instr.out and the numpy float64 values to the 3 printed digits. The exact-arithmetic err5 agrees down to h=0.005 (9.233e-12). At h=0.002 the float64 err5 of 2.16e-13 differs from the exact-arithmetic 2.36e-13 because rounding is starting to show. The frame prints the actually computed error, which is correct, and the page makes no claim about it.
- **Reference.** This is the same fp as Case 1, already verified.
- **Picture.** All five stencil points lie on f. The tangent is drawn wider underneath, and the green line is drawn on top. The pixel separation is about 0.10 px (claim 14). The comment at L56 says "differ by at most \|err5\| = 1.92e-4"; that is the slope difference at h=0.35, which is the largest. There is no clamping, and all stencil points are inside the window. There are 11 frames.

### diffformac.jl (Case 3)
- **Method.** The script implements the three-point f'' (L12) and the five-point f'' (-1, 16, -30, 16, -1)/(12h^2) (L13). Both match the sympy k=1 and k=2 solutions.
- **Numbers.** max3 and max5 in all 11 frames match instr.out and an independent numpy recomputation on the same 700-point grid, to the 3 printed digits. The mpmath exact-arithmetic maxima confirm the truncation part (claim 22).
- **Reference.** fpp(x) = -2e^{-x} cos x. sympy confirms that f'' - fpp = 0.
- **Picture.** The exact curve is on [0, π] and the stencil curves are on [2h, π-2h]. The window is correct for both stencils. ylims (-2.1, 0.2) contain the whole range: f'' is -2 at x=0 and peaks at 0.134 at x = 3π/4. The legend covers part of the curves near the peak (x ≈ 2.45 to 3.04). The curves coincide there, so this is not misleading. There are 11 frames.

### Legacy fidelity
The archive module consists of symbolic Mathematica derivations: the 3-point and 5-point central systems, the 7-point extension, and forward and backward difference subroutines. It has no numerical example or graph. The page's choice of test function is declared (L18). Its formulas and order statements agree with the archive's (including the O(h^2) surprise for f''' and f^(4)). No case was dropped, because the archive has no numerical cases.

