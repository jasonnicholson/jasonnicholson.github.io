# Richardson Extrapolation — animation review (round 4)

Page: `pages/numerical-methods/richardson-extrapolation/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1 — Fidelity, Minor — legacy Examples 1, 3, 4 (error-bound graphs) dropped without mention

- **Location:** `index.qmd` lines 30–32 (Animations intro). The intro explicitly accounts for Example 8 (Case 2) and for what is *not* animated from Examples 8–10 ("Examples 9–10 … are not animated here, and neither are the pictures that Examples 8–10 draw"), which reads as a complete accounting of the legacy module.
- **What is there now:** No mention of the legacy module's other graph-bearing examples:
  - Example 1: graph of $f^{(5)}(x)$ on $[0,\pi]$ to estimate $M_5$ for the truncation-error bound;
  - Example 3: plot of $|f'(x)-D_\text{five}(x,0.01)|$ over $[0,\pi]$ against the bound $EB_\text{five}(0.01)=M_5h^4/30$, including Mathews' aside that the bound must use the enlarged interval $[-2h,\pi+2h]$ because the stencil at $x=0$ leaves $[0,\pi]$;
  - Example 4: the $O(h^4)$ table/graphs of $EB_\text{five}(h)$ and $|f'(x)-D_\text{five}(x,h)|$ for $h=0.02,0.01$ (lnk_5 shows the plot with $2.13\times10^{-8}$ and $1.33\times10^{-8}$ bounds).
  Case 1 and Case 2 cover the *actual error* parts of Examples 2(b)/3/4 (max error annotation; log-log slopes) but never the error **bound** $M_5h^4/30$ that Examples 1, 3, 4 are built around. (Examples 5–7 are numeric/symbolic; Example 7's extrapolated value $D_5(1,0.02)$ in page notation is one of Case 2's plotted points, so it is implicitly covered.)
- **How I know:** read `RichardsonExtrapMod.html` and `RichardsonExtrapMod_lnk_2/4/5.html` as text and viewed the stacked images `review/legacy/main_1.png`, `main_2.png`, `lnk3_*.png`, `lnk5.png`.
- **Suggested correction:** add one sentence to the intro, e.g. "The legacy module's truncation-error-bound examples (Examples 1, 3, 4: $M_5=\max|f^{(5)}|$ and $EB_\text{five}(h)=M_5h^4/30$) are not animated; Case 1 shows the actual maximum error instead." Alternatively, overlay the bound in Case 1.

No other findings.

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `richexaa.jl` | 0 | 7.9 | richexaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `richexab.jl` | 0 | 6.7 | richexab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `richexaa.gif` | 9 | byte-identical | richexaa |
| `richexab.gif` | 12 | byte-identical | richexab |

### Page references

- Scripts linked: `richexaa.jl`, `richexab.jl`
- GIFs embedded: 2
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Where | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | Description l.12 | "combines two finite-difference estimates with different step sizes so that the leading truncation term cancels" | D5 = (4D3(h/2) − D3(h))/3; e3/h² → 0.169442 = f‴(1)/6, cancelled in D5 (see #6) | confirmed |
| 2 | Description l.12 | Legacy presents it for $f(x)=e^{-x}\sin x$ over $[0,\pi]$ | Legacy main page / lnk_3: `f[x]=e^-x Sin[x]`, interval `[0, π]` | confirmed |
| 3 | Description l.12; both scripts l.9 | function is $e^{-x}\sin x$ | `f(x) = exp(-x) * sin(x)` in both scripts | confirmed |
| 4 | Description l.17 | $D_3(x,h)=\frac{f(x+h)-f(x-h)}{2h}$ | `d3` line 12 / 11 identical | confirmed |
| 5 | Description l.23 | $D_5(x,h)=\frac{4D_3(x,h/2)-D_3(x,h)}{3}$ | `d5` line 13 / 12 identical | confirmed |
| 6 | Description l.26 | upgrades truncation behaviour from $O(h^2)$ to $O(h^4)$ | observed local slopes (float64, script values): p3 = 2.0066 → 2.0000; p5 = 3.905 → 3.9999 for h ≥ 0.006; mpmath e5/h⁴ → 9.23281e-4 = |f⁽⁵⁾(1)|/480 | confirmed |
| 7 | Animations l.30 | each animation compares base central difference with Richardson for legacy test function and interval | Case 1 over [0, π]; Case 2 at x0 = 1 ∈ [0, π], same f | confirmed |
| 8 | l.31 | Case 2 plots the error of the estimate in legacy Example 8 | Example 8 (lnk_9): five-point f′(1.0) for e^{-x} sin x; Case 2 plots |D5(1,h) − f′(1)| | confirmed |
| 9 | l.31 | $D_5(x,h)$ is that example's five-point formula with spacing $h/2$ | algebra: (4D3(h/2) − D3(h))/3 = [f(x−h) − 8f(x−h/2) + 8f(x+h/2) − f(x+h)]/(12·h/2); numerically max diff 4.5e-50 at 66 (x,h) pairs (`indep.py`) | confirmed |
| 10 | l.31 | evaluated over a different list of step sizes | legacy H = {0.5, 0.2, 0.1, 0.05, 0.02, 0.01} (spacing); script hs = [0.5 … 0.0015] (12 values, spacing h/2) | confirmed |
| 11 | l.32 | Examples 9–10 use five-point central-difference formulas for the 2nd and 3rd derivatives at the same point | lnk_10: f″[1.0] with (−f(X−2H)+16f(X−H)−30f(X)+16f(X+H)−f(X+2H))/(12H²); lnk_11: f‴[1.0] with (−f(X−2H)+2f(X−H)−2f(X+H)+f(X+2H))/(2H³) | confirmed |
| 12 | l.32 | Examples 8–10 draw the five stencil points with a line, parabola or cubic through the centre point | lnk_9 g = f(X)+d1(x−X) (line); lnk_10 adds d2/2 (x−X)² (parabola); lnk_11 cubic; dots at X, X±H, X±2H | confirmed |
| 13 | l.32 | those are not animated here | no such script/GIF on the page | confirmed |
| 14 | Case 1 heading | profile comparison $D_3(x,h)$ vs $D_5(x,h)$ | frames show f′, D3, D5 curves on [0, π] | confirmed |
| 15 | Case 1 Behavior | "Both approximations converge as h shrinks" | max errors (50-digit): D3 8.128e-2, 3.379e-2, 1.328e-2, 4.793e-3, 2.132e-3, 8.331e-4, 3.000e-4, 1.333e-4, 3.333e-5; D5 5.285e-4, 8.791e-5, 1.337e-5, 1.729e-6, 3.415e-7, 5.209e-8, 6.750e-9, 1.333e-9, 8.333e-11 — strictly decreasing | confirmed |
| 16 | Case 1 Behavior | Richardson curve tracks $f'$ much more closely | ratio max-err D3/D5 from 154 (h = 0.5) to 4.0e5 (h = 0.01); visibly separated D3 curve in frames 1–2, D5 on top of f′ | confirmed |
| 17 | Case 1 Behavior | because the dominant $h^2$ term is cancelled | see #6 | confirmed |
| 18 | Case 1 link/embed | `richexaa.jl` / `richexaa.gif` are Case 1 | script header and output name; committed GIF byte-identical to regen (`cmp`) | confirmed |
| 19 | Case 1 alt text | D3 and Richardson D5 vs true derivative over 0 to π for decreasing h | 9 frames, h = 0.5 → 0.01, xlims (0, π) | confirmed |
| 20 | Case 2 heading | pointwise convergence at $x_0=1$ on log-log axes | `x0 = 1.0`, `xaxis=:log, yaxis=:log`; title "Pointwise Richardson Convergence at x0 = 1" | confirmed |
| 21 | Case 2 Behavior | three-point error slope follows approximately $O(h^2)$ | p3 between 2.0000001 and 2.0066 at every step | confirmed |
| 22 | Case 2 Behavior | Richardson follows approximately $O(h^4)$ before roundoff appears | p5 = 3.905, 3.963, 3.986, 3.995, 3.998, 3.9991, 3.9997, 3.9989, 3.987 down to h = 0.006; then 4.82 (h = 0.003) and 1.72 (h = 0.0015). Float64 e5 vs 50-digit truncation error: h = 0.006: 1.205e-12 vs 1.197e-12; h = 0.003: 4.26e-14 vs 7.48e-14; h = 0.0015: 1.29e-14 vs 4.67e-15 — roundoff, visible as the kink at the last two points of frames 11–12 | confirmed |
| 23 | Case 2 link/embed | `richexab.jl` / `richexab.gif` are Case 2 | script header, output name; byte-identical regen | confirmed |
| 24 | Case 2 alt text | log-log error curves vs h at x0 = 1 showing 2nd and 4th order trends | frames 1–12, legend `|D3(1,h)-f'(1)|`, `|D5(1,h)-f'(1)|`, O(h^2)/O(h^4) guides | confirmed |
| 25 | Derivation Notes l.52 | $D_3=f'+C_2h^2+C_4h^4+\cdots$ | central difference is even in h; mpmath e3/h² → f‴(1)/6 = 0.169442 | confirmed |
| 26 | Derivation Notes l.54–59 | $(4D_3(h/2)-D_3(h))/3=f'+O(h^4)$ because the $C_2h^2$ contribution cancels exactly | 4·C2(h/2)² − C2h² = 0; remainder −C4h⁴/4 = −f⁽⁵⁾h⁴/480; mpmath e5/h⁴ → 9.23281e-4 = |f⁽⁵⁾(1)/480| = 9.2328138e-4 | confirmed |
| 27 | GIF frames vs page | Case 1 title "Richardson Extrapolation on [0, pi] \| h = …", legend "D5(x,h) = (4D3(x,h/2)-D3(x,h))/3" | consistent with page formula and h list | confirmed |
| 28 | Section index | page linked from index | manifest: yes | confirmed (from manifest) |

---

### 3. Implementation checks

### `richexaa.jl` (Case 1)

- **Method:** `d3` is the central three-point difference; `d5` is the Richardson combination (4D3(h/2) − D3(h))/3, identical (to 4.5e-50) to the five-point formula with spacing h/2. It is the named method.
- **Numbers:** instrumented copy (`inst/richexaa_inst.jl`) printed the per-frame grid maxima; independent mpmath maxima over [0, π] (4001-point grid + local refinement, `indep.py`):

| h | script err3 (label) | 50-digit max err3 | script err5 (label) | 50-digit max err5 |
|---|---|---|---|---|
| 0.5 | 0.0812769 (8.13e-02) | 0.08128 (x≈0.025) | 5.28527e-4 (5.29e-04) | 5.285e-4 (x=0) |
| 0.32 | 0.0337856 (3.38e-02) | 0.03379 | 8.79123e-5 (8.79e-05) | 8.791e-5 |
| 0.2 | 0.0132801 (1.33e-02) | 0.01328 | 1.33650e-5 (1.34e-05) | 1.337e-5 |
| 0.12 | 4.79308e-3 (4.79e-03) | 4.793e-3 | 1.72948e-6 (1.73e-06) | 1.729e-6 |
| 0.08 | 2.13197e-3 (2.13e-03) | 2.132e-3 | 3.41463e-7 (3.41e-07) | 3.415e-7 |
| 0.05 | 8.33125e-4 (8.33e-04) | 8.331e-4 | 5.20911e-8 (5.21e-08) | 5.209e-8 |
| 0.03 | 2.99973e-4 (3.00e-04) | 3.000e-4 | 6.75036e-9 (6.75e-09) | 6.750e-9 |
| 0.02 | 1.33328e-4 (1.33e-04) | 1.333e-4 | 1.33337e-9 (1.33e-09) | 1.333e-9 |
| 0.01 | 3.33330e-5 (3.33e-05) | 3.333e-5 | 8.33340e-11 (8.33e-11) | 8.333e-11 |

  Every label agrees to its 3 printed digits. Closed-form cross-check at x = 0 (where both maxima sit for small h): f‴(0)/6·h² = h²/3 → 3.333e-5 at h = 0.01; |f⁽⁵⁾(0)|/480·h⁴ = 4h⁴/480 → 8.333e-11. ✓
- **Reference:** `fp(x) = exp(-x)*(cos x − sin x)`; sympy `diff(exp(-x)*sin(x))` minus this simplifies to 0. ✓
- **Picture:** frames 1, 2, 5, 9 viewed. Curves are f′ (black), D3 (blue dashed), D5 (orange); title h matches the frame's h; annotation matches computed maxima. Evaluating D3/D5 at x near 0 uses f at negative x — stated in the script comment and consistent with Mathews' own Example 2(b)/3 (who noted the bound must then use [−2h, π+2h]). After frame 3 the three curves are visually indistinguishable; the annotation carries the comparison, which is acceptable. Regenerated GIF is byte-identical to the committed one.

### `richexab.jl` (Case 2)

- **Method:** same `d3`/`d5`; errors at x0 = 1. ✓
- **Numbers:** instrumented copy vs 50-digit (`case2.py`, using the same float64 h values):

| h | script e3 | 50-digit e3 | script e5 | 50-digit e5 |
|---|---|---|---|---|
| 0.5 | 0.0425786932 | 0.042578693 | 5.37592e-5 | 5.3759178e-5 |
| 0.32 | 0.0173887187 | 0.017388719 | 9.41039e-6 | 9.4103927e-6 |
| 0.2 | 6.78354e-3 | 6.7835372e-3 | 1.461109e-6 | 1.4611088e-6 |
| 0.12 | 2.44073e-3 | 2.4407281e-3 | 1.906987e-7 | 1.9069865e-7 |
| 0.08 | 1.08458e-3 | 1.0845798e-3 | 3.77515e-8 | 3.7751504e-8 |
| 0.05 | 4.23628e-4 | 4.2362806e-4 | 5.76657e-9 | 5.7665688e-9 |
| 0.03 | 1.525008e-4 | 1.5250079e-4 | 7.47674e-10 | 7.476741e-10 |
| 0.02 | 6.77774e-5 | 6.7777389e-5 | 1.477083e-10 | 1.4770888e-10 |
| 0.01 | 1.694424e-5 | 1.6944236e-5 | 9.2389e-12 | 9.2325616e-12 |
| 0.006 | 6.09992e-6 | 6.0999166e-6 | 1.2052e-12 | 1.1965609e-12 |
| 0.003 | 1.524978e-6 | 1.5249783e-6 | 4.26e-14 | 7.4785608e-14 |
| 0.0015 | 3.812445e-7 | 3.8124451e-7 | 1.29e-14 | 4.6741091e-15 |

  D3 errors agree throughout; D5 errors agree until float64 roundoff (~1e-14 relative to |f′(1)| ≈ 0.11) takes over at the last two h, exactly what the page says. f′(1): script −0.11079376530669924, 50-digit −0.11079376530669926 (Mathews: −0.110793765). ✓
- **Reference:** f′ as above. ✓ Guide constants c2 = 0.170315, c4 = 8.6015e-4 anchored at h = 0.5 (asymptotic values 0.169442 and 9.2328e-4); the guides are anchored lines of slope 2 and 4, as labelled.
- **Picture:** frames 1, 2, 6, 11, 12 viewed. Points added one per frame (12 frames = 12 h values); axes autoscale each frame. The O(h²) guide lies on top of the D3 data (difference < 0.6 % over the whole range) so it is barely visible, and the O(h⁴) guide likewise except where roundoff pulls the last two D5 points away — not misleading, since coincidence with the data is what the guide is meant to show. Legend entries and title match the code. Regenerated GIF byte-identical to committed.

### Not checked / could not determine
- Nothing material. The "section index links the page" item relies on the manifest rather than my own inspection.

