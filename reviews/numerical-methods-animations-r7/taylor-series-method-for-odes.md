# Taylor Series Method for ODE's — animation review (round 7)

Page: `pages/numerical-methods/taylor-series-method-for-odes/`. Reported findings: **0 Error, 3 Misleading, 0 Minor**.

## Findings

### F1. Fidelity, Misleading: the page says Mathews' negative-`y` evaluation is unreproduced, but his program prints the rule and it reproduces all 42 values

- **Location:** `index.qmd` line 18 (Case 1), final sentence: "There Mathews' frames show different values (for example $y(5)=0.1766603$ at $m=12$); how his program evaluated $y^{1/3}$ for negative $y$ has not been reproduced." Line 26 (Case 2) inherits this: "for $m=12$ to $28$ the runs go negative before $t=5$, and there, as in Case 1, his frames show different values".
- **What is there now:** the reader is told the cause of the 2 + 7 mismatches is unknown.
- **What is true:** the archive shows the rule in Example 11 (`TaylorDEMod_gr_228.gif`) and Example 12 (`TaylorDEMod_gr_267.gif`). Mathews builds `D2`, `D3`, `D4` with `Together`, multiplies numerator and denominator by $y^{1/3}$, expands, then substitutes
  $y^{k/3}\to\operatorname{Sign}[y]\,|y|^{k/3}$ for $k=1,2,4,5$ (and $8$ at order 4).
  For even $k$ this is not the real cube-root power: $y^{2/3}=(\sqrt[3]{y})^2$ is positive for $y<0$, but his rule makes it negative. So his $y''$, $y'''$, $y''''$ are not the derivatives of the ODE once $y<0$. The page's real-cube-root run is the mathematically correct one, and his differing values are an artifact of this substitution.
- **How I know:** `/usr/bin/python3 review/mathews_rule.py` implements exactly that program. Output is in `review/mathews_rule.out`.

  | Order | $m$ | Mathews' rule, computed | Printed in his frame | Page's run (real cube root) |
  |---|---|---|---|---|
  | 3 | 12 | 0.1766603 | 0.1766603 | -4.4676549 |
  | 3 | 14 | -3.4636068 | -3.4636068 | -109.0749263 |
  | 4 | 12 | 0.4929678 | 0.4929678 | -0.5365789 |
  | 4 | 14 | 0.2026955 | 0.2026955 | 0.1879762 |
  | 4 | 16 | -554.4454523 | -554.44545 | -7665.8734003 |
  | 4 | 18 | 0.0666066 | 0.0666066 | -16.0687100 |
  | 4 | 20 | 0.0711898 | 0.0711898 | -5.2535013 |
  | 4 | 24 | -39.0862197 | -39.08622 | -1492.8343029 |
  | 4 | 28 | -21.6802983 | -21.680298 | -951.4473378 |

  The rule matches **21 of 21** printed values at each order. At $t=4.17$, $y=-0.03$, the true $y''$ is $-32.74034$ and his substitution gives $+3.94665$ (`review/final_checks.py`).
- **Suggested correction:** replace the final clause of Case 1 with: "There Mathews' frames show different values (for example $y(5)=0.1766603$ at $m=12$) because his program replaces each $y^{k/3}$ by $\operatorname{Sign}(y)|y|^{k/3}$, including even $k$. For $y<0$ that changes the sign of $y^{2/3}$ and $y^{4/3}$, so his higher derivatives are no longer those of the ODE. Applying his rule reproduces all 21 of his printed values; this page keeps the true real-cube-root derivatives." In Case 2, keep "as in Case 1" and say the same rule reproduces all 21 of his order-4 values.

- **Independent check:** confirmed.

### F2. Page match, Misleading: at $m=80$ (Case 1) the shaded "unstable" band contains no step, and "the last steps" is wrong

- **Location:** `index.qmd` line 18: "for steps longer than about $h=0.0609$ ($m\le82$; here $m=12$ to $80$), $h\,|\partial f/\partial y|$ exceeds order-3 Taylor's stability limit $2.513$ before $t=5$ (the shaded region in those frames); on $y'=\lambda y$ ... the method amplifies errors once $h|\lambda|$ exceeds this limit" and "Just above $h=0.0609$ the shading covers only the last steps ($m=80$: from $t\approx4.96$)". Also frame 17 of `taylorderivativeaa.gif` and the alt text "for m = 12 to 80 a shaded region marks where h·|∂f/∂y| exceeds 2.513". The band comes from `onset(h)`, `taylorderivativeaa.jl` lines 62-67, which tests the continuous reference curve rather than the nodes where steps start.
- **What is there now:** a reader takes the band at $m=80$ to mean some steps ran past the limit and amplified error.
- **What is true:** the numbers quoted are right as a statement about the continuous quantity along the reference curve (onset $t=4.958$). But the last step of the $m=80$ run starts at $t=4.9375$, before the band, so **no step starts inside it**. The largest $h|f_y|$ at any step start is $2.482<2.513$. Every step is contracting: the last four have $\partial y_{n+1}/\partial y_n=-0.508,-0.618,-0.741,-0.879$. The band covers part of one step, not "the last steps". The largest $m$ with a step starting past the limit is $78$; the largest with any amplifying step is $77$. In the sweep, $m=70$ has 3 amplifying steps and $m=80$ has 0.
- **How I know:** `review/stab.py` (`stab.out`), brute-force perturbation of the actual run in `review/final_checks.py` (`final_checks.out`), and a count for all 21 values in `review/amp_all.py` (`amp_all.out`).
- **Suggested correction:** either compute the band from step-start nodes (`h*abs(fy(ts[i], ys[i])) > zlim` for `i` in `1:m`), which removes it at $m=80$; or keep it and replace the sentence with: "At $m=80$ the band begins at $t\approx4.96$, inside the final step (which starts at $t=4.9375$), so no step is taken from inside it and every step still contracts errors; steps actually amplify errors for $m\le77$."

- **Independent check:** confirmed.

### F3. Page match, Misleading: at $m=70$ (Case 2) the error rise is attributed to stability, but no step amplifies

- **Location:** `index.qmd` line 26: "The cause is again stability: for steps longer than about $h=0.0675$ ($m\le74$; here $m=12$ to $70$), ... (the shaded region in those frames), and for all of these $m$ the error at $t=5$ is larger than at the last node before the shaded region. Just above $h=0.0675$ the shading covers only the last steps ($m=70$: from $t\approx4.91$)". Also frame 16 of `taylorderivativebb.gif`; band from `onset(h)` in `taylorderivativebb.jl`.
- **What is there now:** the sentence presents the growth at every $m$ from 12 to 70 as the stability mechanism at work.
- **What is true:** the error comparison is numerically right at all these $m$, but at $m=70$ the cause is not amplification. One step does start in the band ($t=4.9286$, $h|f_y|=2.821>2.785$), yet its actual factor is $+0.923$, and the preceding steps have $+0.526,+0.631,+0.762$. No step of the $m=70$ run has $|\partial y_{n+1}/\partial y_n|>1$. The node error rises from $5.50\times10^{-10}$ (at $t=4.857$) to $7.16\times10^{-10}$ (at $t=5$) because new truncation error is added: the earlier error propagated alone would shrink to $3.87\times10^{-10}$. The largest $m$ with any amplifying step is $68$; in the sweep $m=60$ has 3 and $m=70$ has 0. The frozen test $h|f_y|>2.785$ is a good guide but slightly early because it ignores the $t$-dependence.
- **How I know:** `review/stab.py`, `review/final_checks.py`, `review/amp_all.py` (outputs beside them).
- **Suggested correction:** limit the causal claim: "... for $m=12$ to $60$ the run has steps that genuinely amplify error, and the error at $t=5$ is larger than at the last node before the shaded region. At $m=70$ the band contains one step, whose actual error factor is $0.92$, so the small rise from $5.5\times10^{-10}$ to $7.2\times10^{-10}$ is new truncation error rather than amplification." Computing the band from nodes (as in F2) would not remove it at $m=70$, because $h|f_y|$ really does exceed the frozen limit at that step, so the wording needs the change either way.

---

- **Independent check:** confirmed with correction. At m = 70 one step does start inside the band (t = 4.92857, z = −2.8206, linear factor R(z) = +1.0545), so the test-equation criterion is met there, but the actual nonlinear step map is not amplifying (dΦ/dy = 0.9234; maximum over all steps 0.9992). The misattribution is limited to m = 70: for m = 12 to 60, at least two steps have |dΦ/dy| > 1, and the largest m with such a step is 68. The rise at m = 70 comes from same-sign local errors added to a contracting carried error.


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `taylorderivativeaa.jl` | 0 | 12.1 | taylorderivativeaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `taylorderivativebb.jl` | 0 | 10.1 | taylorderivativebb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `taylorderivativeaa.gif` | 21 | byte-identical | taylorderivativeaa |
| `taylorderivativebb.gif` | 21 | byte-identical | taylorderivativebb |

### Page references

- Scripts linked: `taylorderivativeaa.jl`, `taylorderivativebb.jl`
- GIFs embedded: 2
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

Evidence codes: **I** = `review/indep.out` (script values against an independent jet-recursion implementation and a 60-digit reference); **E** = `review/extra.out`; **S** = `review/stab.out`, `final_checks.out`, `amp_all.out`; **M** = `review/mathews_rule.out` and the legacy label crops `legacy_aa_labels.png`, `legacy_bb_labels.png`; **F** = committed frames (`review/labels_aa.png`, `labels_bb.png`, contact sheets, full frames 2, 8, 16, 17).

### Introduction

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 1 | IVP $y'=1-t\sqrt[3]{y}$, $y(0)=1$ on $[0,5]$ | confirmed | scripts lines 11-27; Mathews `gr_232` |
| 2 | Each frame is a complete run with $m$ subintervals, $h=5/m$ | confirmed | code; F |
| 3 | 21 values of Mathews' animations, the listed $m$ | confirmed | M: both legacy GIFs show exactly these 21 |
| 4 | Drawn over a fine-step reference | confirmed | 50000 steps; max difference from high precision $9.5\times10^{-14}$ (aa), $6.5\times10^{-14}$ (bb) |
| 5 | Labelled with computed $y(5)$ and its error | confirmed | all 42 frames read, F |
| 6 | Points below $-0.3$ marked by triangles on the bottom edge | confirmed | code lines 87-90 (aa); F |
| 7 | The run's true minimum is printed | confirmed | frames agree with I (e.g. -8.597, -109.1, -7751, -951.4) |
| 8 | $\sqrt[3]{y}$ is the real cube root; negative runs stay real | confirmed | `cbrt`; I |
| 9 | Truncated Taylor series using analytic derivatives | confirmed | sympy: script's $y'',y''',y''''$ minus true total derivatives $=0$ |
| 10 | Local accuracy $O(h^{p+1})$ | confirmed | one-step error slopes 4.00 (p=3), 4.98 and 4.88 (p=4) |

### Case 1

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 11 | Order 3, three derivative terms | confirmed | code |
| 12 | Local $O(h^4)$, global $O(h^3)$ | confirmed | observed global rates 3.26, 3.17, 3.09 |
| 13 | Same order as third-order RK | confirmed | by definition with #12 |
| 14 | Requires explicit derivatives of the RHS | confirmed | code |
| 15 | Reference peak about 1.4498 near $t=0.88$ | confirmed | 1.449767 at $t=0.88356$ |
| 16 | Reference $y(5)=0.0081199$ | confirmed | 0.00811992046487 (60-digit; DOP853 agrees) |
| 17 | $m=12$ through $36$ visibly leave the reference in the tail | confirmed | max node error $\ge0.029$; F |
| 18 | $y(5)\approx-4.47$ at $m=12$ | confirmed | -4.4676549 |
| 19 | $y(5)\approx-109$ at $m=14$ | confirmed | -109.0749263 |
| 20 | $m=20$: 0.0068 at $t=4$, 1.22 at $t=4.25$, ends 0.0895 | confirmed | 0.00680, 1.21616, 0.0895215 |
| 21 | From $m=40$ each run decreases steadily after its peak | confirmed | zero rises after peak for all $m\ge40$ |
| 22 | From $m=40$ within $3\times10^{-4}$ at every node | confirmed | largest $2.504\times10^{-4}$ ($m=40$) |
| 23 | $m=100$: largest node error $1.3\times10^{-5}$ | confirmed | $1.327\times10^{-5}$ |
| 24 | $m=100$: error in $y(5)$ is $-1.2\times10^{-9}$ | confirmed | $-1.186\times10^{-9}$ |
| 25 | $\partial f/\partial y=-t/(3y^{2/3})$ reaches $-41.3$ at $t=5$ | confirmed | -41.2554 |
| 26 | Threshold $h\approx0.0609$, $m\le82$ | confirmed for the continuous quantity | $h^*=0.060907$, $m^*=82.09$ |
| 27 | Order-3 limit 2.513 | confirmed | real root of $R(z)=-1$: -2.51275 |
| 28 | Shaded for $m=12$ to $80$ | confirmed | F, I |
| 29 | Method amplifies errors on $y'=\lambda y$ past the limit | confirmed | $|R(z)|>1$ beyond the root |
| 30 | For $m=12$ to $48$ the error at $t=5$ exceeds that at the last node before the band | confirmed | I, all 12 cases |
| 31 | "shading covers only the last steps ($m=80$: from $t\approx4.96$)" | **onset confirmed; "last steps" wrong** | onset 4.958; no step starts in the band. **F2** |
| 32 | For $m=52$ to $80$ the error in $y(5)$ is below $3.1\times10^{-9}$ | confirmed | largest $3.091\times10^{-9}$ ($m=56$) |
| 33 | At $m=12$ shading starts $t\approx3.07$ | confirmed | 3.0664 |
| 34 | $m=90$ to $150$ stay below the limit up to $t=5$ | confirmed | no onset |
| 35 | Mathews reproduced to every digit for 19 of 21 | confirmed | E, M |
| 36 | Exceptions $m=12,14$ go negative before $t=5$ | confirmed | first negative at 4.167 and 4.643; $m=24,28$ go negative only at $t=5$, so their last step is unaffected |
| 37 | Mathews shows 0.1766603 at $m=12$ | confirmed | M |
| 38 | "how his program evaluated $y^{1/3}$ ... has not been reproduced" | **misleading** | the archive prints it; reproduces 21/21. **F1** |
| 39 | Alt text: parameters, peak, off-scale at $m=12,14$, spike at $m=20$, band $m=12$-$80$, on reference from $m=40$, final value | confirmed | I, F; the band caveat is F2 |
| 40 | Link and embed are the order-3 case | confirmed | `taylorderivativeaa.jl`, `.gif` |

### Case 2

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 41 | Order 4, four analytic derivative terms | confirmed | code; sympy |
| 42 | Local $O(h^5)$, global $O(h^4)$ | confirmed | observed global rates 4.35, 4.18, 4.13; one-step slopes 4.98, 4.88 |
| 43 | Same order as RK4 | confirmed | with #42 |
| 44 | $m=12$ through $32$ leave the reference and go negative | confirmed | all 8 have negative nodes; F |
| 45 | Exact solution stays positive | confirmed | at $y=0$, $y'=1>0$; grid minimum 0.00812 |
| 46 | $y(5)\approx-7666$ at $m=16$ | confirmed | -7665.8734 |
| 47 | $m=20$: negative at 4.25, about -10.4 at 4.5, ends -5.25 | confirmed | -0.0465, -10.434, -5.2535 |
| 48 | $y(5)\approx-0.081$ at $m=32$ | confirmed | -0.080651 |
| 49 | From $m=36$ within $2.7\times10^{-3}$ at every node | confirmed | largest $2.651\times10^{-3}$ ($m=36$) |
| 50 | $m=36,40$ turn up once, by about 0.0015 and 0.0005 | confirmed | 0.001477, 0.000547; one rise each |
| 51 | These rises are too small to see | confirmed | below one pixel to about one pixel on this axis; F |
| 52 | From $m=40$ error in $y(5)$ falls at every refinement | confirmed | $1.36\times10^{-3}$ down to $4.76\times10^{-12}$, strictly |
| 53 | $4.8\times10^{-12}$ at $m=150$ | confirmed | $4.762\times10^{-12}$ against the 60-digit value |
| 54 | $m=100$: largest node error $8.0\times10^{-7}$ | confirmed | $8.021\times10^{-7}$ |
| 55 | More than 16 times smaller than order 3 | confirmed | ratio 16.5 |
| 56 | Threshold $h\approx0.0675$, $m\le74$ | confirmed for the continuous quantity | $h^*=0.067513$, $m^*=74.06$ |
| 57 | Order-4 limit 2.785 | confirmed | real root of $R(z)=1$: -2.78529 |
| 58 | Shaded for $m=12$ to $70$ | confirmed | F, I |
| 59 | For all these $m$ the error at $t=5$ exceeds that at the last node before the band | confirmed numerically | I, all 16 cases |
| 60 | "The cause is again stability", applied to all of $m=12$ to $70$ | **misleading at $m=70$** | no step amplifies. **F3** |
| 61 | $m=70$: band from $t\approx4.91$ | confirmed | 4.9083 |
| 62 | At $m=12$ band starts $t\approx3.10$ | confirmed | 3.1033 |
| 63 | $m=80$ to $150$ stay below the limit | confirmed | no onset |
| 64 | Mathews reproduced to every digit for $m=32$ to $150$ | confirmed | E, M: 14 of 14 |
| 65 | $m=12$ to $28$ go negative before $t=5$ | confirmed | first negative between 3.75 and 4.82 |
| 66 | Mathews shows 0.0711898 at $m=20$ | confirmed | M |
| 67 | Alt text: off-scale for $m=12$-$28$, low of -7751 at $m=16$, band $m=12$-$70$, on reference from $m=36$, final value | confirmed | I, F; the band caveat is F3 |
| 68 | Link and embed are the order-4 case | confirmed | `taylorderivativebb.jl`, `.gif` |

### Counts, wiring, fidelity

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 69 | 21 frames per GIF | confirmed | manifest; extraction |
| 70 | Committed GIFs are what the scripts produce | confirmed | manifest: byte-identical |
| 71 | Two Mathews animations, order 3 and order 4, both kept | confirmed | legacy titles "Order n=3", "Order n=4" |

The page has no `## Description` section, so there is no separate method description to check beyond the formula in its introduction. Content the page does not yet have is not a finding.

---

### 3. Implementation checks

### `taylorderivativeaa.jl` (order 3)

- **It is the method claimed.** Each step is $y+hy'+\frac{h^2}{2}y''+\frac{h^3}{6}y'''$ with total derivatives along the ODE. Sympy confirms the script's $y''$ and $y'''$ equal the true total derivatives identically.
- **The numbers are right.** I recomputed all 21 runs with a different algorithm: Taylor coefficients of $u=y^{1/3}$ and $y$ by power-series recursion, with no derivative formula taken from the script. The largest relative difference at any node in any run is $1.2\times10^{-13}$ (mostly below $10^{-14}$). Observed order at $t=5$ for $m=200,400,800$: 3.26, 3.17, 3.09. One-step error slope: 4.00, 4.00.
- **The reference is right.** Script $y(5)=0.008119920464867961$; a 60-digit order-30 Taylor integration gives $0.00811992046486796100\ldots$; DOP853 gives $0.008119920464867971$. Largest difference along the sampled reference curve is $9.5\times10^{-14}$, far below every error the page or frames quote. Stability limit $2.5127453266$ matches the real root of $R(z)=-1$.
- **The picture shows what was computed.** Titles, $m$, $y(5)$, error and onset were read for all 21 frames and agree with the computed values. Triangles sit at the true off-scale nodes and the true minimum is printed. No computed value exceeds the top of the window (largest 1.4497). The only display issue is the band at $m=80$ (F2).

### `taylorderivativebb.jl` (order 4)

- **It is the method claimed.** Each step adds $\frac{h^4}{24}y''''$. The script's closed form for $y''''$ matches the symbolic total derivative identically.
- **The numbers are right.** Same independent recursion for all 21 runs. Largest relative node difference is $4.8\times10^{-10}$, at $m=28$, where the run reaches about $-951$ and rounding is amplified; for stable runs it is below $10^{-13}$. Observed order at $t=5$: 4.35, 4.18, 4.13. One-step slope: 4.98, 4.88.
- **The reference is right.** Same $y(5)$ as above to all printed digits; largest difference along the sampled curve is $6.5\times10^{-14}$. The smallest error the page quotes, $4.8\times10^{-12}$, is about 70 times larger. Stability limit $2.7852935634$ matches the real root of $R(z)=1$.
- **The picture shows what was computed.** All 21 frames' labels were read and agree with the computed values. Triangles and printed minima are correct. No computed value exceeds the top of the window (largest 1.4498). The only display issue is the band at $m=70$ (F3).

### Could not determine

Nothing on the page was left undetermined. One limit on the evidence: I did not run Mathematica, so F1 rests on a Python implementation of the program shown in his images. Its agreement with all 42 printed values is the evidence that the implementation is faithful.

