# Secant Method — animation review (round 3)

Page: `pages/numerical-methods/secant-method/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**I found no findings.**

All 6 scripts run the plain two-point secant iteration. My independent high-precision run reproduces every Float64 iterate. Every numerical and behavioural claim on the page and in the alt texts agrees with the computed values at the precision stated. All six cases match the archive's function and starting values. The display devices (clamping, off-chart markers) are never triggered in a way that misrepresents a value.

These observations are not findings. I note them so the owner knows they were seen:

- **No `## Description` section.** The page has none, although `.github/agents/animation-page.agent.md` lines 12 and 205 require one. The brief excludes content the page does not yet have, so I did not report it as a finding. Because there is no Description, the ledger has no Description-formula entries to check. The intro paragraph's statement of the iteration was checked instead.
- **Case 3, frame 7 legend reads `p8 = 0`.** In exact arithmetic $p_8 = -7.59\times10^{-48}$. Float64 cancellation gives exactly 0 (see the `it_cc.jl` output), so the legend is a faithful report of the Float64 computation and the difference is immaterial.
- **Case 2 frames 11 to 28 look the same apart from the legend.** At a window width of 1.0 the iterates are within 0.005 of 0.2, so the "creep" shows only in the 8-decimal legend values (which are correct). It is not misleading, because the legend shows the slow progress.
- **`secantmethodee.jl` line 37** prints a Julia soft-scope warning about `n_valid` (in `regen/secantmethodee/run.err`). `n_valid` is never used afterwards, so the warning has no effect on output.
- **`secantmethoddd.jl` line 33** has an early `break` that would leave `ps` entries uninitialised (`undef`) if it fired before the last iteration. It fires only at `i = 17`, the final loop index (|p17 − p16| = 6.2e-10), so every entry is defined. This is latent fragility only, not a defect in the output.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `secantmethodaa.jl` | 0 | 8.3 | secantmethodaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `secantmethodbb.jl` | 0 | 11.0 | secantmethodbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `secantmethodcc.jl` | 0 | 5.2 | secantmethodcc.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `secantmethoddd.jl` | 0 | 5.6 | secantmethoddd.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `secantmethodee.jl` | 0 | 4.5 | secantmethodee.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `secantmethodff.jl` | 0 | 4.2 | secantmethodff.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `secantmethodaa.gif` | 9 | byte-identical | secantmethodaa |
| `secantmethodbb.gif` | 28 | byte-identical | secantmethodbb |
| `secantmethodcc.gif` | 10 | byte-identical | secantmethodcc |
| `secantmethoddd.gif` | 16 | byte-identical | secantmethoddd |
| `secantmethodee.gif` | 9 | byte-identical | secantmethodee |
| `secantmethodff.gif` | 6 | byte-identical | secantmethodff |

### Page references

- Scripts linked: `secantmethodaa.jl`, `secantmethodbb.jl`, `secantmethodcc.jl`, `secantmethoddd.jl`, `secantmethodee.jl`, `secantmethodff.jl`
- GIFs embedded: 6
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Location | Claim (page wording) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | Intro | Secant line through $(p_{n-1},f(p_{n-1}))$ and $(p_n,f(p_n))$; its x-intercept becomes $p_{n+1}$ | All scripts: `ps[i+1] = ps[i] - f(ps[i])*(ps[i]-ps[i-1])/(f(ps[i])-f(ps[i-1]))`; the frames draw the line through the two blue points, and the red diamond sits at its x-intercept | confirmed |
| 2 | Intro | No derivative is required | No derivative appears in any script | confirmed |
| 3 | Intro | The method can converge quickly, converge slowly near repeated roots, oscillate, or diverge | Cases 1, 2, 3/6 and 5 respectively (see below) | confirmed |
| 4 | Intro | Julia source scripts are linked under each case | 6 links, each to the matching script | confirmed |
| 5 | Case 1 heading | $f=3e^x-4\cos x$, $p_0=1.0$, $p_1=0.9$ | `secantmethodaa.jl` lines 10–12; archive Ex 3 is the same | confirmed |
| 6 | Case 1 | Converges quickly to the root near $x\approx0.2549$ | mpmath root 0.254850059028850; script p9 = 0.25485005902885027 | confirmed |
| 7 | Case 1 | Both starting points are on the same side of the root | 1.0 and 0.9 are both > 0.2549 | confirmed |
| 8 | Case 1 | $p_2\approx0.456$, still 0.20 from the root | p2 = 0.455750754; error 0.2009 | confirmed |
| 9 | Case 1 | Errors 0.066 ($p_3$), 0.0089 ($p_4$), $4.4\times10^{-4}$ ($p_5$), $3.1\times10^{-6}$ ($p_6$) | 0.06588, 0.008910, 4.435e-4, 3.115e-6 | confirmed |
| 10 | Case 1 | Consistent with order ≈ 1.618 at this simple root | Order estimates 1.653, 1.604, 1.623, 1.616, 1.619 | confirmed |
| 11 | Case 1 alt | Secant line through two iterates; x-intercept converges rapidly to the root near 0.2549 | Frames 1–9; legend p10 = 0.25485 | confirmed |
| 12 | Case 2 heading | $f=1-10x+25x^2$, $p_0=1.0$, $p_1=0.9$ | `secantmethodbb.jl` lines 12–14; archive Ex 4 is the same | confirmed |
| 13 | Case 2 | $(1-5x)^2$ with a double root at 0.2 and $f'(0.2)=0$; $f=25(x-0.2)^2$ | Algebra: $25(x^2-0.4x+0.04)=25x^2-10x+1$; $f'(0.2)=-10+50(0.2)=0$ | confirmed |
| 14 | Case 2 | Converges only linearly; the error ratio settles at $(\sqrt5-1)/2\approx0.618$ | mpmath $e_{n+1}/e_n$: 0.605, 0.6188, 0.61799, 0.61804, then 0.61803 to 5 digits | confirmed |
| 15 | Case 2 | Each step removes about 38% of the error and the iterates creep over many iterations | 1 − 0.618 = 0.382; p29 = 0.20000088 after 28 steps | confirmed |
| 16 | Case 2 alt | Iterates slowly approach the double root at 0.2 | Frames 1–28; legend values 0.573… → 0.20000088 | confirmed |
| 17 | Case 3 heading | $f=\arctan x$, $p_0=1.35$, $p_1=1.30$ | `secantmethodcc.jl` lines 12–14; archive Ex 5 is the same | confirmed |
| 18 | Case 3 | Converges to the root $x=0$ | p7 = 4.8e-25, then Float64 0 | confirmed |
| 19 | Case 3 | Iterates jump to the opposite side of the root each step | Signs p1…p8: +, −, +, −, +, −, +, − (exact arithmetic) | confirmed |
| 20 | Case 3 | Flat slope near the start makes the first step overshoot to negative x | Secant slope 0.363; p2 = −1.22138 | confirmed |
| 21 | Case 3 alt | Oscillate across 0 with decreasing amplitude | \|p\|: 1.30, 1.22, 0.018, 0.0067, 4.6e-7, … | confirmed |
| 22 | Case 4 heading | $f=x^3-x+3$, $p_0=2.0$, $p_1=1.0$ | `secantmethoddd.jl` lines 11–13; archive Ex 6 is the same | confirmed |
| 23 | Case 4 | Real root near $x\approx-1.672$ | mpmath −1.67169988165716; discriminant $4-243<0$, so there is one real root | confirmed |
| 24 | Case 4 | Starts from positive values far from the root and wanders, with a large positive excursion, before converging | p0..p6: 2, 1, 0.5, −3, 0.111, −0.265, **3.164**; converges from p12 on; p17 = −1.6716998817 | confirmed |
| 25 | Case 4 | The path is non-monotone | Path shown in #24 | confirmed |
| 26 | Case 4 alt | Wanders through positive and negative values and converges to the root near −1.672 | Frames 1–16; final legend p17 = −1.6717 | confirmed |
| 27 | Case 5 heading | $f=xe^{-x}$, $p_0=1.5$, $p_1=2.0$, non-convergence diverging to infinity | `secantmethodee.jl` lines 11–13; archive Ex 7 is the same; p100000 = 69327 | confirmed |
| 28 | Case 5 | $f$ has a root at 0, but the method diverges | f(0) = 0; iterates increase without bound | confirmed |
| 29 | Case 5 | The secant on the decaying tail has a negative slope and its x-intercept falls to the right | All secant slopes negative; every p_{n+1} > p_n | confirmed |
| 30 | Case 5 | First jump to $p_2\approx4.11$ | 4.11379887 | confirmed |
| 31 | Case 5 | After that, each step moves right by less than 1 | Largest later step 0.9716 (p3→p4) | confirmed |
| 32 | Case 5 | The step tends to $\ln2\approx0.693$ | Step at n = 100, 1000, 10⁴, 10⁵: 0.7025, 0.69414, 0.693247, 0.693157 (ln 2 = 0.693147) | confirmed |
| 33 | Case 5 | The animation stops at $p_{10}\approx10.57$, the first iterate past the right edge | xlims (0, 10.1); p9 = 9.801 is inside; p10 = 10.5746; frame 9 (last) shows "p10 = 10.57 (off chart)" | confirmed |
| 34 | Case 5 | $p_{16}\approx15.11$ | 15.10597 | confirmed |
| 35 | Case 5 alt | x-intercept steps right until p10 ≈ 10.57 leaves the window | Frames 1–9 | confirmed |
| 36 | Case 6 heading | $f=\arctan x$, $p_0=1.60$, $p_1=1.50$ | `secantmethodff.jl` lines 12–14; archive Ex 8 is the same | confirmed |
| 37 | Case 6 | Slightly larger starting values than Case 3; converges to 0 again | 1.60/1.50 vs 1.35/1.30; p7 = −9.2e-17 | confirmed |
| 38 | Case 6 | Larger first overshoot, then quickly closes in | p2 = −1.842 vs Case 3's −1.221; p5 = −5.2e-5 | confirmed |
| 39 | Case 6 | Super-linear, and since $f''(0)=0$ the asymptotic order is 2, not ≈ 1.618 | Theory: $e_{n+1}\approx Ce_ne_{n-1}^2$ gives $p^2=p+2$, so $p=2$. Numeric order estimates (20,000 digits): 2.0588, 1.9715, 2.0145, 1.9928, 2.0036, 1.9982, 2.0009 | confirmed |
| 40 | Case 6 alt | Converges to 0 after an initial overshoot | Frames 1–6 | confirmed |
| 41 | Wiring | Case N link and embed → `secantmethod{aa..ff}` in order, matching the heading parameters | index.qmd lines 20/22, 28/30, 36/38, 44/46, 52/54, 60/62; parameters checked in #5, 12, 17, 22, 27, 36 | confirmed |
| 42 | Frames | GIF titles name the function in the code | aa "3eˣ − 4cos(x)", bb "1 − 10x + 25x²", cc/ff "arctan(x)", dd "x³ − x + 3", ee "x e⁻ˣ (diverges)" | confirmed |
| 43 | Fidelity | The six cases are the archive's six animation examples (Ex 3–8) | Archive formulas: same functions and the same p0, p1 in the same order; archive titles (Fast, Slow, Convergence/Oscillation, Convergence, NON Convergence Diverging to Infinity, Convergence) match the page headings | confirmed |

### 3. Implementation checks

All six committed GIFs are byte-identical to fresh scratch runs (manifest). Each script was cut before plotting and run to print its Float64 iterates (`it_*.jl`). Those were compared with `indep.py`, which runs the same recurrence in 50-digit mpmath and was written from the definition, not from the scripts.

### `secantmethodaa.jl` (Case 1)
- **Method.** Plain secant recurrence (lines 24–31). The guard `|Δf| < 1e-14` freezes the iterate once the method has converged. It is the secant method.
- **Numbers.** Script and mpmath agree to all printed digits.

  | Iterate | Script | mpmath |
  |---|---|---|
  | p2 | 0.45575075416314531 | 0.455750754163146 |
  | p3 | 0.32073053275992147 | 0.320730532759922 |
  | p4 | 0.26376025263505531 | 0.263760252635055 |
  | p5 | 0.25529351342420903 | 0.255293513424209 |
  | p6 | 0.25485317414524578 | 0.254853174145246 |
  | p7 | 0.25485006012443362 | 0.254850060124434 |

  The order estimate tends to 1.618.
- **Reference.** No reference value is drawn. The root 0.25485005902885 comes from `findroot`, and f(root) = 0 in Float64.
- **Picture.** Frames 1, 2, 3, 5 and 9 inspected. The secant passes through the two blue points, and the red diamond is at the line's x-intercept (p2 = 0.45575 in frame 1, p3 = 0.32073 in frame 2). Legend indices are right: frame k shows p_{k−1}, p_k → p_{k+1}. p0 = (1, 5.994) sits just inside ylim 6.

### `secantmethodbb.jl` (Case 2)
- **Method.** Plain secant recurrence.
- **Numbers.** p2 = 0.57333333 (mpmath 0.573333333), p7 = 0.235 (0.235), p29 = 0.20000088348568937 (mpmath 0.20000088348853). The 3e-12 difference at p29 comes from Float64 cancellation in f near the double root; it does not show at the 8 decimals the legend prints. The error ratio tends to 0.618034 in mpmath, which confirms linear convergence with ratio 1/φ.
- **Reference.** The double root 0.2 is exact by algebra.
- **Picture.** Frames 1, 4, 10, 20 and 28 inspected. The secant and diamond are correct. All iterates lie within xlims [0, 1] and f within [0, 16], so clamping never changes a point. The last legend reads p29 = 0.20000088.

### `secantmethodcc.jl` (Case 3)
- **Method.** Plain secant recurrence.
- **Numbers.**

  | Iterate | Script | mpmath |
  |---|---|---|
  | p2 | −1.2213792056860207 | −1.22137920568601 |
  | p3 | 0.018036298196725919 | 0.018036298196728 |
  | p4 | −0.0067232949785550 | −0.00672329497855570 |
  | p5 | 4.5722058130988e-7 | 4.57220581309815e-7 |
  | p6 | −6.88864933911e-12 | −6.88864933909555e-12 |
  | p7 | 4.798e-25 | 4.800e-25 |

  p8 is 0 in Float64 against −7.59e-48 exactly, a cancellation artefact. The order estimate tends to 2.000 (`order.py`).
- **Reference.** The root 0 is exact.
- **Picture.** Frames 1–10 inspected on the sheet. In frame 1 the secant through (1.35, 0.933) and (1.30, 0.915) meets the axis at −1.221. In frames 8–10, Δf < 1e-14, so no secant is drawn and the legend shows only the blue points. That is correct behaviour after convergence. No iterate is outside xlims, so clamping is never triggered.

### `secantmethoddd.jl` (Case 4)
- **Method.** Plain secant recurrence with a convergence `break`. The break fires only at the last loop index, i = 17 (see the observations above).
- **Numbers.** The script matches mpmath at every iterate: p3 = −3 exactly, p6 = 3.1639049160972 (mpmath 3.16390491609723), p9 = −3.0342275767851 (−3.03422757678514), p12 = −1.7346585404889 (−1.73465854048893), p17 = −1.67169988165716 (−1.67169988165716).
- **Reference.** Root −1.67169988165716 from mpmath `findroot`. The header comment "≈ −1.6717" is correct, and so is the ylims comment "f(p3) = −21, f(p9) ≈ −21.9" (−21.900).
- **Picture.** Frames 1, 3, 5, 7, 9, 11, 13 and 16 inspected. Frame 1 shows the secant through (2, 9) and (1, 3), which has slope 6 and meets the axis at 0.5. In frame 5, f(p6) = 31.5 lies inside ylim 32. All iterates lie inside xlims [−3.2, 3.5], so the clamped diamond is never used. The legend values are correct to 4 decimals.

### `secantmethodee.jl` (Case 5)
- **Method.** Plain secant recurrence. Its divergence guards (|p| > 1e6, NaN or Inf) are never triggered within 10 iterates.
- **Numbers.**

  | Iterate | Script | mpmath |
  |---|---|---|
  | p2 | 4.113798873326397 | 4.1137988733264 |
  | p3 | 4.8125063367527 | 4.8125063367527 |
  | p9 | 9.8009866463166 | 9.80098664631658 |
  | p10 | 10.574639777228 | 10.5746397772281 |

  Step lengths: 0.6987, 0.9716, 0.8108, 0.8332, 0.7992, …, 0.7667 at n = 10. At n = 10⁵ the step is 0.693157, which tends to ln 2. A fixed-point argument gives the same limit: $s=s/(e^s-1)\Rightarrow e^s=2$.
- **Reference.** The root 0 is exact.
- **Picture.** Frames 1, 2, 5, 8 and 9 inspected. The secants slope downward with intercepts to the right. In frame 9 the hollow red diamond sits at the right edge, and the legend and annotation both say "p10 = 10.57 (off chart)". The off-chart value is labelled with its true value, not the clamped one. The root at 0 is at the window's left edge. That is acceptable, because the case is about the iterates leaving to the right.

### `secantmethodff.jl` (Case 6)
- **Method.** Plain secant recurrence.
- **Numbers.**

  | Iterate | Script | mpmath |
  |---|---|---|
  | p2 | −1.8424619601336 | −1.84246196013363 |
  | p3 | −0.0974833864747 | −0.0974833864747366 |
  | p4 | 0.0761932295147 | 0.0761932295146752 |
  | p5 | −5.23681503041e-5 | −5.2368150304106e-5 |
  | p6 | 1.011134093196e-7 | 1.01113409319577e-7 |
  | p7 | −9.2253442e-17 | −9.22534493586e-17 |

  The last row differs only in Float64 roundoff. The order estimate tends to 2.0009 (`order.py`), which confirms the page's order-2 claim. The header comment "p2 ≈ −1.842, from p3 on the iterates alternate sides" is confirmed: the signs from p2 on are −, −, +, −, +, −.
- **Reference.** The root 0 is exact.
- **Picture.** All 6 frames inspected. The secants and diamonds are correct, and the legend values (−1.84246, −0.09748, 0.07619, −5.24e-05, 1.01e-07, −9.23e-17) match the computed iterates.

### Legacy archive
`SecantMethodMod.html` Examples 3–8 are the "Various Scenarios and Animations" examples. From the formula images:

| Example | Function | p0 | p1 |
|---|---|---|---|
| 3 | `3 Exp[x] − 4 Cos[x]` | 1.0 | 0.9 |
| 4 | `1 − 10x + 25x²` | 1.0 | 0.9 |
| 5 | `ArcTan[x]` | 1.35 | 1.30 |
| 6 | `x³ − x + 3` | 2.0 | 1.0 |
| 7 | `x e^(−x)` | 1.5 | 2.0 |
| 8 | `ArcTan[x]` | 1.60 | 1.50 |

These match page Cases 1–6 exactly, in order and with matching behaviour labels. Examples 1–2 are worked cubic-root exercises, not animation scenarios, so no animation case was dropped.

