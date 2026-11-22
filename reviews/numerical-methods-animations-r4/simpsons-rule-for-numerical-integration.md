# Simpson's Rule for Numerical Integration — animation review (round 4)

Page: `pages/numerical-methods/simpsons-rule-for-numerical-integration/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I found no Error, Misleading or Minor findings.

Observations that are not findings:
- The intro says "Each animation below" although there is only one animation. This is generic wording and nothing in it is false.
- The plot titles do not name $f$, while the legacy frames printed $y=e^{-x}\sin(8x^{2/3})+1$. The page text and the case heading state the function, so a reader is not misled.
- The legacy GIF refines up to 41 sample points ($n=40$), and the page continues to 109 ($n=108$). The function, interval, colours and "Sample Points / Approximation" readout are the same. Every approximation the two GIFs both show agrees to 6 decimals (see §3). Extending the refinement is not a loss of fidelity.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `simpsonsaa.jl` | 0 | 7.9 | simpsonsaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `simpsonsaa.gif` | 24 | byte-identical | simpsonsaa |

### Page references

- Scripts linked: `simpsonsaa.jl`
- GIFs embedded: 1
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|
| D1 | Composite Simpson "fit[s] a quadratic interpolant across each pair of subintervals" | The script fits a quadratic through $(x_{2k},x_{2k+1},x_{2k+2})$ (lines 41–48). The interpolant reproduces the nodes to 2.6e-15. The sum of the exact integrals of the panel quadratics equals `simpson_sum` to 2.7e-15 for every n. | confirmed |
| D2 | $h=(b-a)/n$, n even, $S_n=\frac h3[f_0+f_n+4\sum_{k=1}^{n/2}f_{2k-1}+2\sum_{k=1}^{n/2-1}f_{2k}]$ | Matches `simpson_sum` (lines 26–31): odd indices 1:2:n-1 get weight 4 and even indices 2:2:n-2 get weight 2. All n in `n_seq` are even. My independent formula in mpmath agrees to all printed digits. | confirmed |
| D3 | "the method integrates cubics exactly" | The script's `simpson_sum` gives an error of exactly 0 for $x^0..x^3$ on [0,2] at n=2 and n=4. For $x^4$ the errors are 0.2667 and 0.01667 (ratio 16), and $x^5$ is not exact, so the degree of precision is exactly 3. | confirmed |
| D4 | Composite error is $O(h^4)$ for $f\in C^4[a,b]$ | This is the standard result. The $x^4$ error ratio of 16 on halving h is consistent with it. | confirmed |
| A1 | Interval $[0,2]$, $y=e^{-x}\sin(8x^{2/3})+1$ | Script lines 8–9. | confirmed |
| A2 | "After an opening frame showing only f" | Frame 1 shows only the magenta curve (n=0 branch, lines 33, 39, 70). | confirmed |
| A3 | "each frame redraws the entire interval using a denser even partition" | `n_seq` is strictly increasing and every value is even (2…108). Every frame draws all panels on [0,2]. | confirmed |
| A4 | "Red dots mark the sample points $x_i$" | Line 72 draws $i=0..n$. In frame 2 there are 3 dots and in frame 24 there are 109. | confirmed |
| A5 | "vertical red lines mark the panel boundaries $x_{2k}$" | Lines 58–61 draw $i=0:2:n$. In the 9-point frame the lines are at 0, 0.5, 1, 1.5, 2, and there is no line at the odd nodes. | confirmed |
| A6 | Case heading: Composite Simpson, $f$, $[0,2]$ | Same as A1/D2. | confirmed |
| A7 | "converges toward the true integral $\int_0^2 f\,dx \approx 2.016280$" | mpmath, 40 digits, with the substitution $x=t^3$ removing the singularity: 2.0162797196170963… An independent second quadrature with breakpoints gives the same value. The errors decrease in magnitude monotonically from n=4 onward (sign: S(2) is high, all later values are low). | confirmed |
| A8 | "the last frame (109 sample points) gives 2.015834" | Script S(108)=2.015834215997; mpmath 2.015834216. The frame 24 annotation reads "Sample Points = 109" and "Approximation = 2.015834". | confirmed |
| A9 | "about 0.00045 low" | $S_{108}-I=-4.455\times10^{-4}$. | confirmed |
| A10 | "$x^{2/3}$ term makes $f'$ unbounded at 0 ($f'\approx\frac{16}{3}x^{-1/3}$)" | $f\approx 1+8x^{2/3}+\dots$ near 0, so $f'\approx \frac{16}{3}x^{-1/3}$. | confirmed |
| A11 | Error shrinks like $O(h^{5/3})$, not $O(h^4)$ | Error ratios on halving h: 4.235 (12→24), 3.380 (24→48), 3.221, 3.189, 3.180, 3.177, 3.176, 3.1754, 3.1751 (3072→6144). These approach $2^{5/3}=3.1748$. | confirmed |
| A12 | "halving h divides it by about 3.38 (from 24 to 48 subintervals)" | Error(24)/Error(48) = 3.38032. | confirmed |
| A13 | "tending to $2^{5/3}\approx 3.17$, instead of 16" | $2^{5/3}=3.1748$; see A11. | confirmed |
| A14 | Link `[Julia source](simpsonsaa.jl)` and embed `simpsonsaa.gif` | Both files exist. The manifest shows the GIF is byte-identical to the output of `simpsonsaa.jl`. | confirmed |
| A15 | Alt text: "opening frame showing only f, … sample points as red dots, panel boundaries as vertical red lines, piecewise quadratic panels and the global approximation" | Frames 1, 2, 24 and the contact sheet show these elements. The pink filled quadratic panels have red outlines, and the approximation value is annotated. | confirmed |
| A16 | Frame count (implicit: opening + one frame per n) | 1 + 23 = 24 frames, as in the manifest. | confirmed |

### 3. Implementation checks: `simpsonsaa.jl`

**Is it the method it claims to be?** Yes. It is standard composite Simpson 1/3 with even n and uniform spacing (lines 26–31), not a variant. The drawn panels are the actual quadratic interpolants through each node triple (lines 41–55). The quadrature value comes from the weighted sum, and it equals the exact integral of the drawn quadratics to about 3e-15 for every n.

**Are the numbers right?** Yes. Script values (from `instr.jl`, which runs the script's own `simpson_sum`) against my independent mpmath sum (40 digits):

| n | pts | script | independent | error vs I |
|---|---|---|---|---|
| 2 | 3 | 2.4912610173 | 2.491261017 | +0.475 |
| 4 | 5 | 1.6117863286 | 1.611786329 | −0.404 |
| 6 | 7 | 1.8405602096 | 1.84056021 | −0.176 |
| 10 | 11 | 1.9763885058 | 1.976388506 | −0.0399 |
| 24 | 25 | 2.0103696294 | 2.010369629 | −0.00591 |
| 28 | 29 | 2.0118135929 | 2.011813593 | −0.00447 |
| 40 | 41 | 2.0138900411 | 2.013890041 | −0.00239 |
| 48 | 49 | 2.0145313361 | 2.014531336 | −0.00175 |
| 108 | 109 | 2.0158342160 | 2.015834216 | −0.000446 |

All 23 n values agree. The full list is in the `instr.jl` and `indep.py` output. Property checks on the script's own routine: it is exact for degrees 0–3, not exact for degrees 4–5, and the $x^4$ error drops by a factor of 16 when h is halved. The interpolants reproduce their data to 2.6e-15.

Cross-check against the legacy GIF: the legacy frames read 2.491261 (3 pts), 1.840560 (7), 1.976389 (11), 1.998814 (15), 2.006018 (19), 2.011814 (29) and 2.013890 (41). Each matches the script's value for the same n.

**Are the reference values right?** The page's only reference value is $I\approx2.016280$, against $I=2.01627971961709632789$ (mpmath, two independent quadrature set-ups agreeing to 40 digits). The script draws no reference curve or line.

**Does the picture show what was computed?** Yes.
- Frames 1, 2, 5 and 24 and the contact sheet show the elements described in A2–A5.
- The annotations "Sample Points = n+1" and "Approximation = round(S_n,6)" match the computed values. The displayed 2.0154 for n=72 is `round` dropping a trailing zero from 2.015400, which is correct.
- Display range: ylims are (0, 2.1). Across all n the panel quadratics range from 0.349 to 1.976, and f ranges from 0.357 to 1.920 (`clip.py`), so nothing is clipped.
- The xlims margin (−0.03, 2.03) keeps the end nodes visible.
- There is no NaN masking. The fill runs to y=0, and f is positive everywhere, so the fill is the true area.

Verdict: the implementation, reference value, picture and page text are all consistent. No findings.

