# Fix record: 2d-trapezoidal-and-simpson-rules

## Findings
### F1 — Minor — fixed
- Reproduced: `/usr/bin/python3 -I check_f1.py` (scratch folder `r7fix/2d-trapezoidal-and-simpson-rules/fix/`, output in `check_f1.out`).
  - With symbolic nodal values `F_ij` on [0,1]², sympy shows that the exact integral of the piecewise-bilinear interpolant minus the trapezoidal weighted sum $hk\sum\sum w_iw_jF_{ij}$ is identically 0 for n = 2, 4, 6. Likewise, the exact integral of the patchwise-biquadratic interpolant minus $\frac{hk}{9}\sum\sum a_ia_jF_{ij}$ is identically 0 for n = 2, 4, 6. So $I_T$ and $I_S$, the values of the rules, are exactly the weighted sums.
  - The script's `approx` is that same sum (`trapezoid2d` returns `hx*hy*s`, and `simpson2d` returns `(hx*hy/9)*s`). The mpmath sums reproduce the GIF-title values, for example 4.74908773601 (T, n=2) and 5.10626262445 (S, n=2).
  - What the sums approximate is the true integral: I = 5.04756680716754 (mpmath `quad`, 30 digits). I − I_T runs from 0.2985 (n=2) to 0.002868 (n=20). I − I_S runs from −0.0587 (n=2) to −4.676e-6 (n=20). So `≈` belongs between I and the rule values, not in the rule definitions.
- Change: `index.qmd:25` `I_{T} \approx hk\sum...` → `I_{T} = hk\sum...`; `index.qmd:33` `I_{S} \approx \frac{hk}{9}\sum...` → `I_{S} = \frac{hk}{9}\sum...`. The review's optional clause ("with $I\approx I_T$ and $I\approx I_S$") was not added (R7-D, smallest correct change). Line 12 already says the rules are a "numerical approximation of a rectangular double integral", and line 47 writes $I\approx 5.04756680717$.
- Check: `git diff -- index.qmd` shows only those two relation symbols changed. Lines 63 and 76 ("is the trapezoidal value $I_T$", "is the Simpson value $I_S$") and the GIF titles (`I_T = ...`, `I_S = ...`) now agree with the definitions.

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd:25 | `I_{T} = hk\sum_{i=0}^{m}\sum_{j=0}^{n} w_i w_j f(x_i,y_j)` | `check_f1.py`: ∫(bilinear interpolant) − weighted sum = 0 symbolically for n = 2, 4, 6; the sum matches the script's `approx` and the GIF titles at all 8 meshes | yes |
| index.qmd:33 | `I_{S} = \frac{hk}{9}\sum_{i=0}^{m}\sum_{j=0}^{n} a_i a_j f(x_i,y_j)` | `check_f1.py`: ∫(biquadratic interpolant) − weighted sum = 0 symbolically for n = 2, 4, 6; the sum matches the script's `approx` and the GIF titles at all 8 meshes | yes |

No numbers were added or changed.

## Scripts and GIFs
- No scripts were changed and no GIFs were regenerated, because the finding is text-only.
- `git status --short -- pages/numerical-methods/2d-trapezoidal-and-simpson-rules` → ` M .../index.qmd` only.

## Legacy archive
Consulted `n2003/simpsonsrule2dmod.html` and its images. Image `gr_16` defines the rule with an equality, `T2D(f,h,k) = (1/4)hk(...)`. Image `gr_18` gives $\int\int f\,dy\,dx = T2D(f,h,k) + O(h^2) + O(k^2)$. So Mathews also defines the rule value as equal to the weighted sum and approximates the integral, which agrees with the fixed page. There is no legacy animated GIF for this topic, as the review notes.

## Notes
- None. No other text on the page was touched.

## Resolution check (independent checker, not shown this record)

### Original findings
### F1 — resolved
- Evidence: the diff changes only `index.qmd:25` and `index.qmd:33`, replacing `\approx` with `=` in both rule definitions. Now $I_T$ and $I_S$ are defined as exactly their weighted sums, which is true by definition of the rules. An independent NumPy evaluation of these exact formulas reproduces the GIF-title values (2x2 mesh: $I_T$ = 4.749087736005, $I_S$ = 5.106262624448), and the scripts' `approx` is that same sum. The optional "with $I\approx I_T$" clause was not added. That is acceptable: line 47 already states the reference $I\approx 5.04756680717$ (scipy dblquad gives 5.04756680716754).

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd:25 | `I_{T} = hk\sum_{i=0}^{m}\sum_{j=0}^{n} w_i w_j f(x_i,y_j)`, w_0=w_m=1/2, interior 1 | Recomputed in NumPy: 2x2 gives 4.749087736, 20x20 gives 5.044698422. Error ratio when halving the mesh is about 4 (second order), as expected for trapezoidal | correct |
| index.qmd:33 | `I_{S} = \frac{hk}{9}\sum ... a_i a_j f`, weights 1,4,2,...,4,1 | Recomputed: 2x2 gives 5.106262624, 4x4 gives 5.051811627, 8x8 gives 5.047762777. Error ratio about 16 (fourth order) | correct |

### New problems
None. This rests on three things: the diff touches only these two equality signs; the surrounding text (lines 38–41 define h, k, nodes and the $j$-weights with $n$) stays consistent; and the recomputed values match the GIF titles.

### Reproducibility and conventions
- No script or GIF changed (the porcelain status of the page folder lists only index.qmd), so there was nothing to regenerate.
- The conventions still hold: Description comes before Animations, each case has a source link and an embed, the alt text is descriptive, and there are no code blocks.
- Within the page folder only index.qmd changed. The repository working tree has many other pages modified by parallel fixes, and those cannot be attributed to this page's fix.

**Final status:** committed
