# Derive Numerical Differentiation Formulae — animation review (round 3)

Page: `pages/numerical-methods/derive-numerical-differentiation-formulae/`. Reported findings: **0 Error, 0 Misleading, 2 Minor**.

## Findings

### F1. Fidelity, Minor. The page calls $e^{-x}\sin x$ "the legacy test function", but the legacy module has no test function
- **Location:** `index.qmd` line 18: "Each animation below visualizes one derived stencil formula using the legacy test function $f(x)=e^{-x}\sin(x)$."
- **What is there now:** The sentence attributes the example function to the legacy module.
- **What is true:** The legacy module (`NumericalDiffFormulaeMod.html` plus lnk_1 to lnk_3) is a purely symbolic derivation. Its text never names a numerical function, and its graph-sized images are Mathematica input/output: gr_35 and gr_128 are the solved three-point and five-point systems, gr_191 is the `CentralDiff` subroutine, and gr_219 is the 8-point forward-difference table. None of them evaluates any concrete $f$. The function $e^{-x}\sin x$ was chosen for this page.
- **How I know:** `sed 's/<[^>]*>//g' NumericalDiffFormulaeMod.html | sed '/^[[:space:]]*$/d'` and the same for lnk_1 to lnk_3 (no function named). Every image in those files with HEIGHT ≥ 90 is listed with `grep -o 'gr_[0-9]*.gif"[^>]*HEIGHT=[0-9]*' ... | awk -F'HEIGHT=' '$2>=90'`, and I viewed the representative ones named above. No a2001 animation exists for this topic (`ls a2001/Animations | grep -i diff` returns nothing).
- **Suggested correction:** "Each animation below applies the derived stencils to the test function $f(x)=e^{-x}\sin(x)$ (the legacy module itself derives the formulas symbolically and has no numerical example)."
- Note: the brief excludes history and attribution claims. I report this one because it makes a checkable statement about what the archive contains, and that statement is false.

- **Independent check:** not run (Minor finding, unverified)

### F2. Page match, Minor. "Each animation ... visualizes one derived stencil formula" does not describe Cases 2 and 3
- **Location:** `index.qmd` line 18 (same sentence).
- **What is there now:** One formula per animation.
- **What is true:** Case 2 (`diffformab.jl` lines 26-27, 58-59) draws both the five-point and the three-point first-derivative estimates and prints both errors. Case 3 (`diffformac.jl` lines 26-27, 50-51) draws both the three-point and the five-point second-derivative stencils. Only Case 1 shows a single formula. The case headings and Behavior paragraphs describe this correctly, so the impact is small.
- **How I know:** Script lines cited above, and the frames (`committed/diffformab/sheet.png` and `committed/diffformac/sheet.png` show two estimate curves in each legend).
- **Suggested correction:** "Each animation below applies the derived stencil formulas to the test function ..., comparing three-point and five-point stencils in Cases 2 and 3."

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `diffformaa.jl` | 0 | 7.8 | diffformaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `diffformab.jl` | 0 | 7.1 | diffformab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `diffformac.jl` | 0 | 9.5 | diffformac.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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
| 1 | Description ¶1 | central finite-difference formulas are "derived from Taylor expansions and solved in parallel as small linear systems" | Archive gr_35/gr_128: Taylor series set equal to f at stencil points, then solved for f', f'' (and f''', f'''') together | Confirmed (describes the method; not animated) |
| 2 | Description ¶1 | "The legacy module emphasizes deriving first- and second-derivative formulas together" | Archive text: "parallel development of the formulas" for f' and f'' | Confirmed |
| 3 | Description ¶2 | For symmetric stencils odd/even Taylor terms cancel, giving compact formulas with clear error orders | sympy moment check (`indep.py`): 3-pt f' exact through degree 2, 3-pt f'' through degree 3 (O(h²)); 5-pt f' through degree 4, 5-pt f'' through degree 5 (O(h⁴)) | Confirmed |
| 4 | Description ¶2 | Wider stencils can significantly improve accuracy for smooth functions | Case 2: err5 < err3 by a factor of 108 to 3×10⁶; Case 3: err5 < err3 in every frame | Confirmed |
| 5 | Animations intro | Function is $f(x)=e^{-x}\sin(x)$ | All three scripts line 8/9: `f(x) = exp(-x) * sin(x)` | Confirmed |
| 6 | Animations intro | It is "the legacy test function" | Archive has no test function | **Wrong** (F1) |
| 7 | Animations intro | Each animation visualizes "one derived stencil formula" | Cases 2 and 3 show two formulas each | **Wrong in letter** (F2) |
| 8 | Case 1 heading | $f'(x_0)\approx\frac{f(x_0+h)-f(x_0-h)}{2h}$ | `diffformaa.jl` l.11 `d1_3`; sympy weights [-1/2,0,1/2] | Confirmed |
| 9 | Case 1 Behavior | Three-point slope converges to the tangent slope as h decreases | err from 6.14e-2 (h=0.6) to 1.69e-7 (h=0.001), monotone | Confirmed |
| 10 | Case 1 Behavior | "reflecting second-order accuracy" | err/h² = 0.17067, 0.17001, ... 0.16944 (constant) = \|f'''(1)\|/6 = 1.0167/6 = 0.16945 | Confirmed |
| 11 | Case 1 alt | Stencil points and slope line converging to the tangent at x0 = 1 | `x0 = 1.0` (l.13); frames show 3 orange points at x0±h, x0 and the dashed slope line merging into the red tangent | Confirmed |
| 12 | Case 1 wiring | Link `diffformaa.jl`, embed `diffformaa.gif` | Files exist; regenerated GIF byte-identical (manifest); 12 frames = 12 h values | Confirmed |
| 13 | Case 2 heading | $f'(x_0)\approx\frac{f(x_0-2h)-8f(x_0-h)+8f(x_0+h)-f(x_0+2h)}{12h}$ | `diffformab.jl` l.13; sympy weights [1/12,-2/3,0,2/3,-1/12] = [1,-8,0,8,-1]/12 | Confirmed |
| 14 | Case 2 Behavior | Five-point error drops faster than three-point for the same h | err5/h⁴ ≈ 0.0128 to 0.0148 → \|f⁽⁵⁾(1)\|/30 = 0.01478 (4th order); err3/h² ≈ 0.169 (2nd order); err5 < err3 at every h | Confirmed |
| 15 | Case 2 Behavior | Green five-point line "already lies on the red true tangent at h=0.35" | err5(0.35) = 1.92e-4 | Confirmed |
| 16 | Case 2 Behavior | "the two lines differ by about 0.1 pixel at their ends" | End offset = 0.9 × 1.92e-4 = 1.73e-4 y-units; measured plot box 26 to 433 px over 0.65 units ≈ 626 px/unit (upper bound; ticks included) → 0.108 px; from tick labels ≈ 600 px/unit → 0.104 px | Confirmed |
| 17 | Case 2 Behavior | \|err5\| value printed in each frame | Annotation l.65; frames show h, \|err3\|, \|err5\| | Confirmed |
| 18 | Case 2 alt | Dashed three-point line approaches the tangent; five-point line lies on the tangent in every frame; both errors printed | Frames 1-11; three-point line visibly separate at h=0.35 and 0.25, merged by h≈0.12 | Confirmed |
| 19 | Case 2 colours | green = five-point, red = true tangent | l.57 `:crimson` tangent, l.59 `:darkgreen` five-point | Confirmed |
| 20 | Case 2 wiring | `diffformab.jl` / `diffformab.gif` | Byte-identical regen; 11 frames = 11 h values | Confirmed |
| 21 | Case 3 heading | second-derivative formulas on $[2h,\pi-2h]$ | `diffformac.jl` l.23 `xinner = range(2h, pi-2h, 700)` | Confirmed |
| 22 | Case 3 Behavior | compares f''(x) with the three-point and five-point second-derivative stencils | l.10 `fpp = -2e^{-x}cos x` (sympy: equals f''); l.12-13 stencils; sympy weights [1,-2,1] and [-1,16,-30,16,-1]/12 | Confirmed |
| 23 | Case 3 Behavior | both stencils use only points in [0,π] on that window | At x=2h the 5-pt stencil reaches x−2h = 0.000e+00 exactly (instr.jl); at x=π−2h it reaches π | Confirmed |
| 24 | Case 3 Behavior | maximum errors in each frame are taken over this window | l.29-30 use `xinner` | Confirmed |
| 25 | Case 3 Behavior | From h=0.35 to h=0.005 both maximum errors shrink | err3: 1.31e-2, 6.69e-3, 3.47e-3, 1.55e-3, 6.87e-4, 2.69e-4, 9.67e-5, 4.30e-5, 1.07e-5, 2.69e-6; err5: 5.16e-4, 1.86e-4, 6.11e-5, 1.41e-5, 3.06e-6, 5.00e-7, 6.77e-8, 1.37e-8, 8.71e-10, 5.52e-11 (both strictly decreasing) | Confirmed |
| 26 | Case 3 Behavior | five-point stays closer in every frame | err5 < err3 in all 11 frames | Confirmed |
| 27 | Case 3 Behavior | At h=0.002 the five-point max error rises from 5.5e-11 to 5.9e-11 | Script: 5.5163e-11 → 5.8920e-11 (frames print 5.52e-11 and 5.89e-11) | Confirmed |
| 28 | Case 3 Behavior | the rise is "because floating-point rounding now outweighs its truncation error" | Exact-arithmetic (mpmath, 50 digits) truncation-only max error on the same grid: 5.5e-11 at h=0.005 (so the float value there is truncation) and 1.42e-12 at h=0.002. The float max at h=0.002 is 5.89e-11, 40× the truncation, and occurs at x=0.784 rather than at the left end where truncation peaks | Confirmed |
| 29 | Case 3 alt | exact curve on 0 to π, stencil curves on 2h to π−2h | l.21 `xtrue` on [0,π]; l.23 `xinner`; frame 1 shows the stencil curves starting at x=0.7 | Confirmed |
| 30 | Case 3 wiring | `diffformac.jl` / `diffformac.gif` | Byte-identical regen; 11 frames = 11 h values | Confirmed |
| 31 | Derivation Notes | $f(x\pm h)=f\pm hf'+\frac{h^2}{2}f''\pm\frac{h^3}{6}f'''+\cdots$ | Taylor series; matches archive gr_35 | Confirmed |
| 32 | Derivation Notes | $f'=\frac{f(x+h)-f(x-h)}{2h}+O(h^2)$, $f''=\frac{f(x+h)-2f(x)+f(x-h)}{h^2}+O(h^2)$ | sympy degree of exactness 2 and 3 respectively; archive gr_35 shows h²f⁽³⁾/6 and h²f⁽⁴⁾/12 remainders | Confirmed |
| 33 | Derivation Notes | Including x±2h "yields five-point formulas with O(h⁴) truncation behavior" | True for the f' and f'' formulas the page uses (sympy; Case 2 err5/h⁴ constant). The archive also derives five-point f''' and f'''', which are only O(h²) (gr_128 remainders h²f⁽⁵⁾/4 and h²f⁽⁶⁾/6); the page does not mention those | Confirmed for the page's scope |
| 34 | Section index | Page linked from the numerical-methods index | Manifest: yes | Confirmed |

Archive content the page does not cover: forward and backward difference formulas (lnk_3) and the five-point f''' and f'''' formulas. The page explicitly limits itself to central f' and f'' formulas, so I do not report this as a dropped case: the archive has no animated or numerical cases to drop.

---

### 3. Implementation checks

### `diffformaa.jl` (Case 1, three-point f')
- **Method:** `d1_3(x,h) = (f(x+h)-f(x-h))/(2h)` is the standard central difference. Independent sympy moment solve on offsets {−1,0,1} gives weights [−1/2, 0, 1/2], exact through degree 2.
- **Numbers:** Script values (instr.jl) against mpmath at x0=1:

  | h | script approx | annotation (6 dp) | err | err/h² |
  |---|---|---|---|---|
  | 0.6 | −0.0493537427 | −0.049354 | 6.144e-2 | 0.17067 |
  | 0.1 | −0.1090989768 | −0.109099 | 1.695e-3 | 0.16948 |
  | 0.01 | −0.1107768211 | −0.110777 | 1.694e-5 | 0.16944 |
  | 0.001 | −0.1107935959 | −0.110794 | 1.694e-7 | 0.16944 |

  The ratio is constant at \|f'''(1)\|/6 = 0.16945, so the method is second order as claimed. The annotations in all 12 frames match the computed values rounded to 6 digits.
- **Reference:** `fp(x) = e^{-x}(cos x − sin x)`. sympy confirms it is f'. fp(1) = −0.110793765307 (mpmath), matching the frames' "exact = −0.110794".
- **Picture:** The slope line is drawn through (x0, f(x0)) with slope `approx` (l.31), labelled "formula slope", which is a fair depiction. The tangent uses `exact`. The orange points are at x0−h, x0, x0+h (l.21-25, 54). The title shows the right h. All elements stay inside the ylims (−0.1, 0.55): the tangent spans 0.31 ± 0.10. Frame 1 checked in full size; the contact sheet covers all 12 frames.

### `diffformab.jl` (Case 2, five-point f')
- **Method:** `d1_5` coefficients [1, −8, 0, 8, −1]/(12h) match the independent sympy solve [1/12, −2/3, 0, 2/3, −1/12], exact through degree 4 and not degree 5.
- **Numbers:** Script against mpmath (50 digits):

  | h | err3 script / mpmath | err5 script / mpmath |
  |---|---|---|
  | 0.35 | 2.08e-2 / 0.0208 | 1.92e-4 / 1.92e-4 |
  | 0.12 | 2.44e-3 / 2.44e-3 | 3.02e-6 / 3.02e-6 |
  | 0.02 | 6.78e-5 / 6.78e-5 | 2.36e-9 / 2.36e-9 |
  | 0.005 | 4.24e-6 / 4.24e-6 | 9.24e-12 / 9.23e-12 |
  | 0.002 | 6.78e-7 / 6.78e-7 | 2.16e-13 / 2.36e-13 |

  err5/h⁴ approaches \|f⁽⁵⁾(1)\|/30 = 0.01478, so the method is fourth order. At h=0.002 the printed float error (2.16e-13) differs from the truncation error (2.36e-13) because of rounding. It is still the true error of the computed estimate, and the page makes no claim about that value. The script comment's "at most |err5| = 1.92e-4" is correct: the maximum over the frames is at h=0.35.
- **Reference:** Same `fp` as Case 1, verified.
- **Picture:** Five stencil points at x0 + {−2,−1,0,1,2}h. Three lines go through (x0, f(x0)) with slopes approx3, approx5 and exact. The tangent is drawn wider (lw 5) underneath the green line. The 0.1-pixel claim is verified in ledger #16. The annotation reports h, \|err3\| and \|err5\| matching the computed values in all 11 frames.

### `diffformac.jl` (Case 3, three- and five-point f'')
- **Method:** `d2_3` [1,−2,1]/h² and `d2_5` [−1,16,−30,16,−1]/(12h²) match the independent sympy weights [1,−2,1] and [−1/12, 4/3, −5/2, 4/3, −1/12]. They are exact through degree 3 and degree 5 respectively, which gives O(h²) and O(h⁴).
- **Numbers:** The script's max errors over the 700-point `xinner` grid (instr.jl) against the mpmath exact-arithmetic max on the same grid:

  | h | err3 script / exact | err5 script / exact (truncation only) |
  |---|---|---|
  | 0.35 | 1.31e-2 / 0.0131 | 5.16e-4 / 5.16e-4 |
  | 0.05 | 2.69e-4 / 2.69e-4 | 5.00e-7 / 5.0e-7 |
  | 0.01 | 1.07e-5 / 1.07e-5 | 8.71e-10 / 8.71e-10 |
  | 0.005 | 2.69e-6 / 2.69e-6 | 5.52e-11 / 5.5e-11 |
  | 0.002 | 4.30e-7 / 4.3e-7 | 5.89e-11 / 1.42e-12 |

  The h=0.005 five-point value equals the leading truncation term h⁴\|f⁽⁶⁾(0)\|/90 = 6.25e-10·8/90 = 5.56e-11, with the maximum at the left end of the window (x = 0.01). At h=0.002 the float result is dominated by rounding, so the page's explanation holds.
- **Reference:** `fpp(x) = −2e^{-x}cos x`. sympy confirms it is f''.
- **Picture:** The exact curve is on [0,π] and the stencil curves on [2h, π−2h]. The title reports h, and the annotations match the computed values in all 11 frames. In frame 1 the legend box (upper right) overlaps the flat part of the curves near x ≈ 2.4 to 3.0, around the right end of the stencil curves at π−2h = 2.44. Nothing the page discusses depends on that region, and the errors are read from the printed values, so I do not count it as a finding. From about h=0.18 onward the three curves are visually indistinguishable (max err3 ≈ 3.5e-3 is under 1 px on a 2.3-unit axis). The page relies on the printed maxima, not on the picture, so this is consistent with the text.

### Reproducibility
Per the manifest, each scratch copy run alone reproduces its committed GIF byte for byte (exit 0 for all three). The frame counts (12, 11, 11) equal the lengths of the `hs` vectors.

