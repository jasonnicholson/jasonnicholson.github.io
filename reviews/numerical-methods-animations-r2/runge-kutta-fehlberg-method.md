# Runge-Kutta-Fehlberg Method — animation review (round 2)

Page: `pages/numerical-methods/runge-kutta-fehlberg-method/`. Reported findings: **0 Error, 0 Misleading, 2 Minor**.

## Findings

### F1. Page match, Minor: there is no "Modified Euler page"

- **Location:** `index.qmd` lines 30-31: "The second animation uses the same IVP shown on the Adams-Bashforth-Moulton, Euler, and Modified Euler pages".
- **What is there now:** The sentence refers to three pages.
- **What is true:** The IVP $y'=1-t\sqrt[3]{y}$, $y(0)=1$, $[0,5]$ does appear on `adams-bashforth-moulton-method/index.qmd` (line 24, Case 1) and on `eulers-method-for-odes/index.qmd` (line 28, Case 1 Forward Euler, and the Modified Euler (Heun) case whose alt text is at line 66). There is no Modified Euler page. Modified Euler is the second case on the Euler's Method page.
- **How I know:** `ls pages/numerical-methods | grep -i -E 'heun|modif|improv'` lists only `accelerated-and-modified-newton-raphson` and `improved-newton-method`. `grep -rln 'cbrt\|sqrt\[3\]'` finds the IVP on the ABM, Euler, Runge-Kutta and Taylor-series pages.
- **Suggested correction:** "...the same IVP shown on the Adams-Bashforth-Moulton page and in the Euler and Modified Euler cases of the Euler's Method page". It is also on the Runge-Kutta and Taylor-series pages if the owner wants to list them.

- **Independent check:** not run (Minor finding, unverified)

### F2. Fidelity, Minor: Mathews' second RKF example (Examples 6/7) is dropped without comment, and the provenance sentence sits under the wrong case

- **Location:** `index.qmd` lines 30-37 (the Case 2 introduction and the paragraph "Because the recovered archive did not include legacy RKF animated GIF portals for this topic, this animation is reconstructed from the worked-example equations and plot behavior in the module links/images.").
- **What is there now:** Case 2 uses the cross-page IVP $y'=1-t\sqrt[3]{y}$. The provenance paragraph comes straight after the Case 2 introduction, so "this animation" reads as the second animation.
- **What is true:** The Mathews module has two RKF worked IVPs. Example 1 is $y'=1+y^2$, $y(0)=0.5$, $[0,1.1]$ (images gr_27/28/29), and Case 1 reproduces it faithfully. Example 6 is $y'=t^2+y^2$, $y(0)=0.5$, $[0,1.5]$ (gr_103/104/105), run with `RKF45[a,b,α,0.000001]` (gr_108). Example 7 compares Example 6 with its closed-form Riccati/Bessel solution (gr_123). The page never mentions Example 6/7. Case 2 is not taken from any Mathews worked example, so the provenance sentence describes Case 1, not the animation it follows.
- **How I know:** `sed 's/<[^>]*>//g' RungeKuttaFehlbergMod.html` lists Examples 1-8. I viewed the images gr_27-29, gr_103-105, gr_108, gr_109 (the Example 6 RKF45 plot rising to 20 near t=1.5) and gr_123.
- **Suggested correction:** Either add a sentence saying Case 2 replaces Mathews' Example 6 ($y'=t^2+y^2$, $y(0)=0.5$ on $[0,1.5]$) so that this page can be compared with the other ODE pages, or add Example 6 as a further case. The provenance sentence should either move up under the Case 1 introduction or say "the first animation".

- **Independent check:** not run (Minor finding, unverified)


## Reviewer's notes (not findings)



#### Considered and not reported

- **Step-control variant differs from Mathews.** Mathews' subroutine (gr_15) accepts a step when $|z-y|<\varepsilon$, an absolute local error. It clamps $s$ to $[0.1,4]$ and uses $h_0=0.25$, $h_{\min}=0.001$. The scripts follow the Burden-Faires form instead: accept when $|y_5-y_4|/h\le\varepsilon$, with no clamp on $s$, $h_0=0.1$ and $h_{\min}=10^{-6}$. The Description states exactly the rule the scripts use, and it is a valid formulation, so this is not a finding. Mathews' own Example 1 run bottoms out at $h_{\min}=0.001$ near the pole: gr_71 shows the abscissas stepping by 0.001 from t≈1.043, and gr_82 shows an error of about −0.07 at t=1.1. The page's run therefore has far smaller errors than Mathews'. The page does not quote Mathews' numbers, so no reader is misled.
- **"relative error of $3.3\times10^{-5}$" (Case 1).** The true maximum is $3.229\times10^{-5}$, at t=1.1, for RKF45. As an upper bound ("to within") it is true. Rounding a bound up is acceptable, so this is not reported.

---

## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `rungekuttafehlbergaa.jl` | 0 | 8.6 | rungekuttafehlbergaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `rungekuttafehlbergbb.jl` | 0 | 11.4 | rungekuttafehlbergbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `rungekuttafehlbergaa.gif` | 66 | byte-identical | rungekuttafehlbergaa |
| `rungekuttafehlbergbb.gif` | 81 | byte-identical | rungekuttafehlbergbb |

### Page references

- Scripts linked: `rungekuttafehlbergaa.jl`, `rungekuttafehlbergbb.jl`
- GIFs embedded: 2
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Page text (quoted or close paraphrase) | Evidence | Verdict |
|---|---|---|---|
| D1 | "RKF45 is an adaptive-step one-step solver ... computes embedded 4th- and 5th-order approximations from the same stage evaluations" | sympy rooted-tree order conditions on the scripts' tableau: b4 satisfies all conditions to order 4 and fails at order 5; b5 satisfies all conditions to order 5 and fails at order 6. One set of six stages k1..k6 is shared. | confirmed |
| D2 | "estimates local error from their difference, and then adjusts step size to meet a tolerance" | Scripts lines 34-45 (aa) and 52-63 (bb) | confirmed |
| D3 | "$\lvert y_5-y_4\rvert$ estimates the local error of $y_4$. It shrinks like $h^5$, so $\lvert y_5-y_4\rvert/h$ ... shrinks like $h^4$" | y4 is order 4, so its local error is O(h^5). Fixed-step test: y4 error ratios under halving are 15.2, 15.65, 15.85 (→16) and y5 ratios are 26.1, 28.6, 30.2 (→32). | confirmed |
| D4 | "A step is accepted when $\lvert y_5-y_4\rvert/h \le \varepsilon$" | Code: `err <= tol * h` (aa l.37, bb l.55). The `|| h <= hmin` escape never fires: the smallest h in either run is 2.8e-5, which exceeds hmin = 1e-6. | confirmed |
| D5 | "$h_{new}=sh$, $s=0.84(\varepsilon h/\lvert y_5-y_4\rvert)^{1/4}$" | Code aa l.44-45, bb l.62-63 (h then clamped to [1e-6, 0.25]) | confirmed |
| A1 | Case 1 is "the legacy Example 1 setup from the Mathews module: $y'=1+y^2$, $y(0)=0.5$, on $[0,1.1]$" | Archive gr_27/28/29; script l.8, 52-53. Mathews also used tol 1e-6 for Example 6 (gr_108), and Case 1 uses tol 1e-6. | confirmed |
| A2 | "The dashed black curve is the exact solution $y=\tan(t+\arctan 0.5)$" | d/dt tan(t+c) = 1+tan², and y(0) = tan(atan 0.5) = 0.5 (mpmath). Script l.9, 90 draws it dashed and black. | confirmed |
| A3 | Second animation uses "the same IVP shown on the Adams-Bashforth-Moulton, Euler, and Modified Euler pages" | The IVP is on the ABM page and on the Euler page, which covers both Euler and Modified Euler. No Modified Euler page exists. | wrong (F1, Minor) |
| A4 | Case 2 IVP: $y'=1-t\sqrt[3]{y}$, $y(0)=1$, on $[0,5]$ | Script bb l.8, 69-71 | confirmed |
| A5 | "dashed high-accuracy reference trajectory from fixed-step RK4 at $h=10^{-4}$" | Script l.76, 100. Its maximum deviation from scipy DOP853 (rtol 1e-13) is 9.7e-13. | confirmed |
| A6 | Provenance paragraph ("this animation is reconstructed from the worked-example equations...") | Attribution and history, excluded by the standard. Placement noted in F2. | n/a (see F2) |
| C1-h | Heading: "Adaptive RKF45 vs RKF54, $y'=1+y^2$, $y(0)=0.5$, $t\in[0,1.1]$" | Script l.8, 51-57 | confirmed |
| C1-1 | "Both adaptive traces follow the exact solution to within a relative error of $3.3\times10^{-5}$" | Max relative error: RKF45 3.229e-5, RKF54 2.255e-5 (aa_check.py). As a bound it holds. | confirmed |
| C1-2 | "all the way to $y(1.1)=139.88$" | Exact tan(1.1+atan .5) = 139.8828 | confirmed |
| C1-3 | "just short of the pole of tan at $t=1.1071$" | π/2 − atan 0.5 = 1.107149 | confirmed |
| C1-4 | "the logarithmic y-axis keeps the whole run in view" | ylims (0.4, 200) with yscale log10. Frame 66 shows the endpoint marker at about 140 inside the box. | confirmed |
| C1-5 | "The step shrinks from 0.136 near t=0.1" | Second step is h = 0.13600 starting at t = 0.1. This is the maximum h. | confirmed |
| C1-6 | "to $5\times10^{-5}$ near t=1.1" | The last chosen steps are 5.02e-5 and 4.97e-5. The final 2.8e-5 step is forced by truncation to t_f. | confirmed |
| C1-7 | "187 of the 259 computed points lie in $t\ge1.05$" | 187 of 259 for both RKF45 and RKF54 (script output and independent run) | confirmed |
| C1-8 | "the marker slows as it nears the pole (each frame adds up to four accepted steps)" | stride = 4 (l.68). Frames are 1:4:259 plus 259, giving 66, which matches the GIF's 66 frames. The contact sheet shows the marker reaching t≈0.9 by about frame 7, then creeping from t≈1.01 to 1.1 over the remaining frames. | confirmed |
| C1-9 | "RKF45 and RKF54 share the error estimate and the step rule" | Same function, with only `mode` differing (l.39) | confirmed |
| C1-10 | "their steps agree to within 0.05%" | Script output: maximum relative step difference 0.041%. My independent Python run reaches 0.084% because of last-bit differences near the pole, so the figure holds for the script's own run, which is what the page describes. | confirmed |
| C1-11 | "the curves coincide (blue over magenta)" | RKF54 royalblue lw 2 is drawn over RKF45 magenta lw 5 (l.92-93). The frames show a thin blue line on a wide magenta band. | confirmed |
| C1-12 | "They differ only in whether $y_4$ or $y_5$ is carried forward" | l.39 | confirmed |
| C1-13 | "RKF54 ends closer to the exact value: errors $3.2\times10^{-3}$ against $4.5\times10^{-3}$ at t=1.1" | RKF54: 139.8859967 − 139.8828425 = 3.154e-3. RKF45: 4.517e-3. | confirmed |
| C1-alt | Alt: "Adaptive RKF45 and RKF54 trajectories versus exact solution ... on [0,1.1], with y on a logarithmic axis" | Frames | confirmed |
| C1-w | Link `rungekuttafehlbergaa.jl` and embed `rungekuttafehlbergaa.gif` | The script writes that GIF. The committed GIF is byte-identical to the regenerated one (manifest). | confirmed |
| C2-h | Heading: "Adaptive RKF45 vs RKF54, $y'=1-t\sqrt[3]{y}$, $y(0)=1$, $t\in[0,5]$" | Script bb | confirmed |
| C2-1 | "RKF45 and RKF54 match the dashed reference to within $7\times10^{-7}$ at every accepted point" | Max error against DOP853: RKF45 6.58e-7 at t = 2.010; RKF54 9.4e-8 | confirmed |
| C2-2 | "takes the maximum step h=0.25 over the hump ($0.1\le t\le1.35$)" | Steps of 0.25 starting at t = 0.1, 0.35, 0.6, 0.85, 1.1, ending at 1.35 | confirmed |
| C2-3 | "keeps h between 0.189 and 0.25 until $t\approx2.4$" | Then 0.2435, 0.2176, 0.1989, 0.1891, 0.2001 up to t = 2.399, then 0.1029 | confirmed |
| C2-4 | "past the steepest point ($y'=-0.930$ at t=2.19)" | min y' = −0.93027 at t = 2.1945 | confirmed |
| C2-5 | "cuts the step ... below 0.04 from t=3 on" | The step from 2.956 is 0.0402. Every step from 2.996 on is below 0.04, with a peak of 0.0399 at 3.80. | confirmed |
| C2-6 | "the smallest step it chooses is 0.027, near t=3.27" | min chosen h = 0.0274, from t = 3.244 and 3.272. RKF54's final 0.0006 step is forced truncation, not chosen. | confirmed |
| C2-7 | "corners ... straight segments drawn between accepted points 0.25 apart (up to 0.0091 below the curve, near t=0.48), not integration error" | Largest chord gap over all RKF45 segments is 0.009112, at t = 0.475, with the chord below the curve. Integration error is at most 6.6e-7. | confirmed |
| C2-8 | "$\partial f/\partial y=-t/(3y^{2/3})$ reaches −41.3 at t=5" | Derivative is correct. y(5) = 0.0081199 gives −41.255. Its magnitude is largest on [0,5] at t = 5. | confirmed |
| C2-9 | "for fixed steps longer than about h=0.0732, $h\lvert\partial f/\partial y\rvert$ would exceed ... 3.02 before t=5" | 3.02002/41.2554 = 0.07320 | confirmed |
| C2-10 | "the 4th-order RKF update's stability limit 3.02" | The y4 stability polynomial, from the tableau, is 1+z+z²/2+z³/6+z⁴/24+z⁵/104. Its real-axis limit, where R(x) = −1, is x = −3.02002. The y5 formula's limit is −3.678. | confirmed |
| C2-11 | "every accepted step here keeps $h\lvert\partial f/\partial y\rvert$ below 1.3" | Max 1.270 (RKF45) and 1.274 (RKF54), evaluated at step end | confirmed |
| C2-12 | "These steps are set by the tolerance, not by stability" | Follows from C2-10 and C2-11: the steps sit at no more than 42% of the stability limit. | confirmed |
| C2-alt | Alt: "...versus high-accuracy RK4 reference for y' = 1 - t cbrt(y), y(0)=1 on [0,5]" | Frames, script | confirmed |
| C2-w | Link `rungekuttafehlbergbb.jl` and embed `rungekuttafehlbergbb.gif` | The script writes that GIF. It is byte-identical to the regenerated one and has 81 frames (max(80, 81) points). | confirmed |

---

### 3. Implementation checks

### `rungekuttafehlbergaa.jl` (Case 1)

1. **It is the method it claims to be.** It is RKF45 (Fehlberg 4(5)) with a Burden-Faires style controller: accept when err/h ≤ tol, and s = 0.84(tol·h/err)^{1/4}. Two variants run, carrying y4 (RKF45) or y5 (RKF54, local extrapolation), as in Mathews' two subroutines. I checked the tableau without relying on memory (`review/order_check.py`, sympy). Row sums equal c. b4 satisfies all 1+1+2+4 rooted-tree conditions to order 4 and fails at order 5. b5 satisfies all conditions to order 5 (9 trees) and fails at order 6. b5 − b4 equals Mathews' error coefficients (1/360, −128/4275, −2197/75240, 1/50, 2/55), shown in archive image gr_15.
2. **The numbers are right.** I wrote an independent Python RKF from the verified tableau and the stated rule (`review/indep.py`). It gives the same 259 accepted points for both modes and 4 rejections. Accepted t values agree to 5e-8, and the final y agrees to 3e-11 (RKF45: 139.88735928039 from the script against 139.88735928042 from mine). Intermediate y values differ by up to 9e-4, all next to the pole where y ≈ 100+ and the slope is enormous, so these are rounding-level differences. Empirical order (`review/order_emp.jl`, BigFloat, fixed steps on [0,0.8]): y4 error ratios under halving are 15.2, 15.65, 15.85, and y5 ratios are 26.1, 28.6, 30.2, approaching 16 and 32.
3. **Its reference values are right.** $y=\tan(t+\arctan 0.5)$ satisfies $y'=\sec^2=1+y^2$ and y(0) = 0.5. It is evaluated on [0, 1.1], inside the pole at 1.107149.
4. **The picture shows what was computed.** I viewed frames 1 and 66 and the contact sheet. The legend reads Exact, RKF45 and RKF54. The title states the right ODE, initial value and tol. Markers sit at the current accepted point. No clamping is used. The log axis (0.4 to 200) contains the full range 0.5 to 139.9. There are 66 frames with a stride of 4.

### `rungekuttafehlbergbb.jl` (Case 2)

1. **It is the method it claims to be.** The `rkf_integrate` routine is identical to the one in aa, with the same verification.
2. **The numbers are right.** My independent Python RKF gives 80 points (RKF45) and 81 points (RKF54), as the script does, with 3 rejections each. The y values agree to 1.6e-10 and 1.0e-10. The accepted-step list is reproduced in the C2 rows of the ledger. Both runs end exactly at t = 5.
3. **Its reference values are right.** The RK4 reference with h = 1e-4 (50001 points) differs from scipy DOP853 (rtol 1e-13, atol 1e-15) by at most 9.7e-13, far below the 7e-7 comparison it supports. y stays positive on [0,5] (minimum 0.00812 at t = 5), so `cbrt` has no sign issue.
4. **The picture shows what was computed.** I viewed frames 1 and 81 and the contact sheet. The legend reads "Reference (RK4 h=1e-4)", RKF45 and RKF54, and the title is correct. With xlims (−0.1, 5.1) and ylims (−0.1, 1.55), the hump peak (1.4498 at t = 0.884) and the endpoint (5, 0.0081) are both in view. The visible corners on the hump are 0.25-wide chords, at most 0.0091 below the curve, as the page says. There are 81 frames, one accepted step per frame.

### Commands run (all in the review/ scratch folder)
- `julia aa_dump.jl`, `julia bb_dump.jl`: these include lines 8-57 of aa and 8-76 of bb verbatim, with the plotting removed, and dump the t and y arrays.
- `python3 order_check.py`: symbolic order conditions and stability polynomials.
- `python3 stab.py`: real stability limits, −3.02002 (y4) and −3.67771 (y5).
- `python3 -I indep.py aa|bb`: independent RKF, DOP853 reference, step lists, h|f_y|, chord gaps.
- `python3 -I aa_check.py`: mpmath exact solution, Case 1 errors and step statistics.
- `julia order_emp.jl`: fixed-step convergence ratios.

