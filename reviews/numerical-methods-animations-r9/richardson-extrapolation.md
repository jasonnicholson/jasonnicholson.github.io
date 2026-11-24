# Richardson Extrapolation — animation review (round 9)

Page: `pages/numerical-methods/richardson-extrapolation/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page, and every number drawn in the frames, agrees with my independent computation. The archive's ten examples are all accounted for on the page: each is either animated or explicitly listed as not animated.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `richexaa.jl` | 0 | 8.6 | richexaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `richexab.jl` | 0 | 7.5 | richexab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | Desc. l.12 | Richardson combines two finite-difference estimates with different step sizes so the leading truncation term cancels | sympy: (4D3(h/2)−D3(h))/3 has the h² term cancelled (see 12) | confirmed |
| 2 | Desc. l.12 | Legacy module uses f(x)=e^{-x}sin(x) over [0,π] | archive gr_34, gr_60/62, gr_96 | confirmed |
| 3 | Desc. l.17 | D3(x,h)=(f(x+h)−f(x−h))/(2h) | matches the script's `d3` and archive gr_4 | confirmed |
| 4 | Desc. l.23 | D5(x,h)=(4D3(x,h/2)−D3(x,h))/3 | matches the script's `d5` in both scripts | confirmed |
| 5 | Desc. l.26 | upgrades the error from O(h²) to O(h⁴) for smooth f | Case 2 local slopes: D3 is 2.000 and D5 rises 3.905→4.000 (table below) | confirmed |
| 6 | Anim. intro l.30 | each animation compares the base central difference with Richardson for the legacy function and interval | Case 1 is on [0,π]; Case 2 is at x0=1, a point inside that interval and the archive's Example 7/8 point | confirmed |
| 7 | l.31 | Case 2 plots the error of the estimate in Example 8; D5(x,h) is that example's five-point f′ formula with spacing h/2 | sympy: (4D3(h/2)−D3(h))/3 − [f(x−h)−8f(x−h/2)+8f(x+h/2)−f(x+h)]/(6h) = 0. Archive Example 8 (gr_174): X=1.0, five-point central formula | confirmed |
| 8 | l.31 | evaluated over a different list of step sizes | Example 8 uses spacings H={0.5,0.2,0.1,0.05,0.02,0.01}; Case 2 uses spacings h/2 = 0.25…0.00075 | confirmed |
| 9 | l.32 | Examples 9–10 use five-point central formulas for the 2nd and 3rd derivatives at the same point | archive gr_194 is f''(1.0) and gr_215 is f'''(1.0); the stencil formulas are in gr_198 and gr_219 | confirmed |
| 10 | l.32 | Examples 8–10 draw the five stencil points with a line, parabola or cubic through the centre point | archive graphs gr_175 (line), gr_196 (parabola), gr_217 (cubic), each with 5 dots | confirmed |
| 11 | l.33 | Examples 1, 3, 4, 5 estimate M5=max\|f^(5)\| on [0,π] from a graph of f^(5), check the five-point bound against the actual error, show O(h⁴) scaling, and compare with the three-point bound | gr_35–37 (M5 over 0≤x≤π; the graph gr_39 is missing); Ex 3 gr_95–98; Ex 4 gr_113–115 (h halved, bound divided by 16); Ex 5 gr_139–140 | confirmed (Example 1's graph itself could not be viewed because the image is missing) |
| 12 | l.33 | Case 1 annotates the actual maximum errors instead | annotation reads max\|error D3\| and max\|error D5\|, and the values match (table below) | confirmed |
| 13 | l.34 | Example 7 combines D3(1,0.02) and D3(1,0.01) into the five-point value at spacing 0.01, which is D5(1,0.02) | archive gr_154–157. mpmath: extrapolated value −0.110793765454 equals five-point Dfive(1,0.01) = −0.110793765454 | confirmed |
| 14 | l.34 | its error is the h=0.02 point of Case 2 | Case 2 at h=0.02: \|D5−f′\| = 1.477e-10, the same as Example 7's extrapolated value against f′(1) = −0.1107937653 | confirmed |
| 15 | l.34 | Example 2(b)'s plot of the five-point formula at spacing 0.01 over [0,π] is the h=0.02 frame of Case 1 | archive gr_89–93 plot Dfive[x,0.01] on {x,0,π}; Case 1 has an h=0.02 frame (frame 8), and D5(x,0.02) uses spacing 0.01 | confirmed |
| 16 | l.35 | Example 2(a) is a table at x=0,1,2,3; Example 6 proves five-point(h) = (4D3(x,h)−D3(x,2h))/3 | archive gr_63–65 and gr_148 | confirmed |
| 17 | Case 1 heading | profile comparison, D3(x,h) vs D5(x,h) | richexaa.jl plots f′, D3 and D5 on 800 points over [0,π] for each h | confirmed |
| 18 | Case 1 Behavior | both approximations converge as h shrinks | max errors fall monotonically: D3 8.13e-2→3.33e-5, D5 5.29e-4→8.33e-11 | confirmed |
| 19 | Case 1 Behavior | the Richardson curve tracks f′ much more closely because the h² term cancels | D5 error is 150–400,000 times smaller than D3's. Frames 1–2 show the dashed D3 curve visibly off f′ while D5 lies on it | confirmed |
| 20 | Case 1 alt | compares D3 and Richardson D5 against the true derivative over 0 to π for decreasing h | frames: h=0.5…0.01, x∈[0,π] | confirmed |
| 21 | Case 1 link/embed | `richexaa.jl` / `richexaa.gif` | the script writes richexaa.gif; the regeneration is byte-identical | confirmed |
| 22 | Case 2 heading | pointwise convergence at x0=1 on log-log axes | `x0 = 1.0`, with `xaxis=:log, yaxis=:log` | confirmed |
| 23 | Case 2 Behavior | three-point error follows about O(h²) | local slopes 2.007, 2.003, then 2.000 | confirmed |
| 24 | Case 2 Behavior | Richardson follows about O(h⁴) before roundoff effects appear | exact-arithmetic slopes 3.905→4.000. In float64 the error departs from the exact value only at h=0.003 (4.26e-14 vs exact 7.48e-14) and h=0.0015 (1.29e-14 vs 4.67e-15). This is visible as the kink in frames 11–12 | confirmed |
| 25 | Case 2 alt | log-log error curves vs h at x0=1 showing 2nd- and 4th-order trends | frame 12 | confirmed |
| 26 | Case 2 link/embed | `richexab.jl` / `richexab.gif` | the script writes richexab.gif; the regeneration is byte-identical | confirmed |
| 27 | Derivation | if D3=f′+C2h²+C4h⁴+…, then (4D3(h/2)−D3(h))/3 = f′+O(h⁴) because C2h² cancels | 4·C2h²/4 − C2h² = 0. The remaining C4 term is −(1/4)C4h⁴ | confirmed |

### 3. Implementation checks

### `richexaa.jl` (Case 1)

- **Method.** `d3` is the central three-point difference. `d5 = (4d3(x,h/2) − d3(x,h))/3` is one step of Richardson extrapolation. sympy confirms it is identical to Mathews' five-point central formula with spacing h/2.
- **Exact derivative.** `fp(x)=e^{-x}(cos x − sin x)` agrees with sympy's d/dx of e^{-x}sin x; the difference simplifies to 0.
- **Numbers.** In the table below, "mpmath" is my independent computation: 40-digit evaluation of the five-point stencil at spacing h/2 on the same 800-point grid over [0,π]. "Script (instr.jl)" is the instrumented copy. "Frame label" is what the annotation in the committed frame reads.

| h | D3 max err: mpmath | D3: script (instr.jl) | D3: frame label | D5 max err: mpmath | D5: script | D5: frame label |
|---|---|---|---|---|---|---|
| 0.5 | 8.1277e-02 | 8.1277e-02 | 8.13e-02 | 5.2853e-04 | 5.2853e-04 | 5.29e-04 |
| 0.32 | 3.3786e-02 | 3.3786e-02 | 3.38e-02 | 8.7912e-05 | 8.7912e-05 | 8.79e-05 |
| 0.2 | 1.3280e-02 | 1.3280e-02 | 1.33e-02 | 1.3365e-05 | 1.3365e-05 | 1.34e-05 |
| 0.12 | 4.7931e-03 | 4.7931e-03 | 4.79e-03 | 1.7295e-06 | 1.7295e-06 | 1.73e-06 |
| 0.08 | 2.1320e-03 | 2.1320e-03 | 2.13e-03 | 3.4146e-07 | 3.4146e-07 | 3.41e-07 |
| 0.05 | 8.3312e-04 | 8.3312e-04 | 8.33e-04 | 5.2091e-08 | 5.2091e-08 | 5.21e-08 |
| 0.03 | 2.9997e-04 | 2.9997e-04 | 3.00e-04 | 6.7504e-09 | 6.7504e-09 | 6.75e-09 |
| 0.02 | 1.3333e-04 | 1.3333e-04 | 1.33e-04 | 1.3334e-09 | 1.3334e-09 | 1.33e-09 |
| 0.01 | 3.3333e-05 | 3.3333e-05 | 3.33e-05 | 8.3334e-11 | 8.3334e-11 | 8.33e-11 |

Both maxima fall at or near x=0, where the stencil reaches outside [0,π]. f is defined there, and this matches Mathews' Example 2(b), which also evaluates Dfive over the whole of [0,π].

- **Reference.** The exact f′ is verified symbolically.
- **Picture.** I viewed the contact sheet (all 9 frames). The title's h matches each frame's h. The black curve is f′, the dashed blue curve is D3 and the orange curve is D5, and the legend text matches the formulas. The fixed ylims (−1, 1.1) contain the whole range of f′ on [0,π], which runs from about −0.21 to 1. No clamping or masking is used. From h=0.12 onward the three curves cannot be told apart by eye, and only the annotation shows the difference. That is accurate, and the page does not claim otherwise.

### `richexab.jl` (Case 2)

- **Method.** The same `d3`/`d5` as Case 1, evaluated at x0=1.
- **Numbers.** In the table below, "mpmath" is the exact-arithmetic error from my independent computation; I list the D3 error only once, because the script's value agrees with it to 7 significant figures at every h. "D5 (script)" is the float64 value printed by `instr.jl`. The local slopes are log(e_k/e_{k−1})/log(h_k/h_{k−1}), computed in mpmath.

| h | D3 err (mpmath) | D5 err (mpmath) | D5 err (script, float64) | slope D3 | slope D5 |
|---|---|---|---|---|---|
| 0.5 | 4.257869e-02 | 5.375918e-05 | 5.375918e-05 | – | – |
| 0.32 | 1.738872e-02 | 9.410393e-06 | 9.410393e-06 | 2.007 | 3.905 |
| 0.2 | 6.783537e-03 | 1.461109e-06 | 1.461109e-06 | 2.003 | 3.963 |
| 0.12 | 2.440728e-03 | 1.906987e-07 | 1.906987e-07 | 2.001 | 3.986 |
| 0.08 | 1.084580e-03 | 3.775150e-08 | 3.775150e-08 | 2.000 | 3.995 |
| 0.05 | 4.236281e-04 | 5.766569e-09 | 5.766570e-09 | 2.000 | 3.998 |
| 0.03 | 1.525008e-04 | 7.476741e-10 | 7.476736e-10 | 2.000 | 3.999 |
| 0.02 | 6.777739e-05 | 1.477089e-10 | 1.477083e-10 | 2.000 | 4.000 |
| 0.01 | 1.694424e-05 | 9.232562e-12 | 9.238929e-12 | 2.000 | 4.000 |
| 0.006 | 6.099917e-06 | 1.196561e-12 | 1.205230e-12 | 2.000 | 4.000 |
| 0.003 | 1.524978e-06 | 7.478561e-14 | 4.259093e-14 | 2.000 | 4.000 |
| 0.0015 | 3.812445e-07 | 4.674109e-15 | 1.292022e-14 | 2.000 | 4.000 |

Leading constants are consistent with the theory. D3 error / h² → f'''(1)/6 = 0.169442, and 1.694424e-05/1e-4 = 0.16944. D5 error / h⁴ → |f⁽⁵⁾(1)|/(30·16) = 9.2328e-4, and 9.2326e-12/1e-8 matches.

- **Reference.** f′(1) = −0.1107937653 (mpmath). This agrees with Mathews' printed f′[1.] = −0.110793765 (gr_176).
- **Guides.** `c2` and `c4` anchor the O(h²) and O(h⁴) guides at the first data point, which is a legitimate display choice. The guides overlie the data as they should.
- **Picture.** I viewed the contact sheet of all 12 frames and frame 12 at full size. The frames add one h at a time, and the axes rescale on each frame. The legend labels |D3(1,h)−f′(1)| and |D5(1,h)−f′(1)| match the computed quantities. The roundoff departure at the last two points is visible in frames 11–12. In early frames the log-axis tick labels have fractional exponents (for example 10^−0.50). This is cosmetic and does not mislead.

### Legacy fidelity

Each archive example maps to something on the page:
- Ex 1, 3, 4, 5 are listed as not animated.
- Ex 2(a) is listed as not animated, and Ex 2(b) corresponds to the h=0.02 frame of Case 1.
- Ex 6 is listed as not animated.
- Ex 7 corresponds to the h=0.02 point of Case 2.
- Ex 8 is Case 2, run with different step sizes, which the page discloses.
- Ex 9 and 10 are listed as not animated.

The function, the point x0=1 and the interval all match the archive. I found no undisclosed departure.

