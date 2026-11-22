# Gauss-Legendre Quadrature — animation review (round 4)

Page: `pages/numerical-methods/gauss-legendre-quadrature/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1 — Page match — Minor — smooth-contrast error "4×10⁻¹⁷" is not attainable in double precision

- **Location:** `index.qmd` line 35, last sentence: "For contrast, the smooth integrand $1+e^{-x}\sin 8x$ on $[0,2]$ already has error $4\times10^{-17}$ at $n=16$."
- **What is there:** a specific error value of 4e-17.
- **What is true:** at n=16 the rule is at round-off level, but the round-off error is about 1e-15 to 4e-16, not 4e-17. The exact integral is $I = 2 + \frac{8 - e^{-2}(\sin 16 + 8\cos 16)}{65} = 2.139627760200246\ldots$. The Float64 grid spacing near 2.14 is 4.44e-16, and the closest double to I is still 1.57e-16 away from I. So no Float64 result can have an error of 4e-17 against the true value. Against a Float64 reference, the difference is 0 or a multiple of 4.44e-16.
- **Evidence:**
  - `julia smooth.jl` (uses the script's own Golub-Welsch routine): n=12 err 3.312e-10, n=14 err 1.861e-13, **n=16 err 8.882e-16** against the Float64 exact value and 1.045e-15 against the BigFloat exact value.
  - `/usr/bin/python3 indep.py` (numpy `leggauss`): n=16 err −4.441e-16. scipy `fixed_quad` n=16 gives −7.3e-16.
  - `julia -e '... Float64(big(Float64(Ib))-Ib)'` gives fl(I)−I = 1.566e-16, with eps(2.0) = 4.44e-16.
- **Correction:** change the sentence to "…already has error at round-off level (about $10^{-15}$) at $n=16$". Or quote a pre-round-off value, for example "error $1.9\times10^{-13}$ at $n=14$ and at round-off level by $n=16$".

No other findings. Two cosmetic points did not reach the threshold and are not findings: the "Y = exp(-x)…" label slightly overlaps the "2.0" y-tick label, and in frame 2 the reference value is labelled "True / Numerical Quadrature". Both are readable and not misleading.

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `gausslegendreaa.jl` | 0 | 12.4 | gausslegendreaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `gausslegendreaa.gif` | 24 | byte-identical | gausslegendreaa |

### Page references

- Scripts linked: `gausslegendreaa.jl`
- GIFs embedded: 1
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Claim (page wording) | Where | Verdict | Evidence |
|---|---|---|---|---|
| 1 | $n$-point rule $\int_{-1}^1 g \approx \sum w_i g(t_i)$ with $t_i$ roots of $P_n$ and $w_i$ associated weights | Description l.15–18 | Confirmed | `nodes.jl`: max\|P_n(t_i)\| = 1.3e-16 (n=2), 3.4e-14 (n=10), 4.7e-13 (n=64). Weights equal $2/((1-t^2)P_n'(t)^2)$ to ≤5e-15. |
| 2 | Shifted formula with $x=\frac{a+b}2+\frac{b-a}2 t$ and factor $\frac{b-a}2$ | l.20–23 | Confirmed | Script l.38–39 implements exactly this. |
| 3 | "exact for polynomials up to degree $2n-1$" | l.24 | Confirmed | `inst.jl` moment test on [-1,1]: degrees 0..2n−1 have error ≤3e-15; degree 2n has error 0.18 (n=2), 0.046 (n=3), 2.9e-3 (n=5), 2.9e-6 (n=10). |
| 4 | $f(x)=1+e^{-x}\sin(8x^{2/3})$ on $[0,2]$ | l.29, heading, l.42 | Confirmed | Script l.11–12. Frame label "Y = exp(-x) sin(8*x^(2/3)) + 1". |
| 5 | Opens with three frames of the integrand alone | l.29 | Confirmed | `frame_states` starts with :intro1..3. Frames 1–3 show the curve only. Frames 1 and 3 have identical hashes (f6ca0ec6…). |
| 6 | The second frame also shows the reference value $I\approx2.016280$ | l.29 | Confirmed | Frame 2 shows "I = 2.016280". |
| 7 | $I\approx 2.016280$ | l.29, l.35, alt | Confirmed | mpmath (substitution x=u³, 30 digits): I = 2.0162797196171. The script's trapezoid reference is 2.016279706128 (error −1.35e-8, ample for 6 decimals). |
| 8 | n sequence 2,3,4,5,6,8,10,…,20,24,28,…,48,56,64 | l.29 | Confirmed | Script l.15–16. Frames 4–24 show "Sample Points" with these values. |
| 9 | Frame count implied (3 intro + 21 rules) | l.29 | Confirmed | GIF has 24 frames. |
| 10 | Each frame recomputes nodes and weights across the full interval (not composite) | l.29 | Confirmed | `gauss_legendre_sum(n)` maps a single n-point rule onto [0,2]. |
| 11 | Each shaded bar has width $w_i$ and height $f(x_i)$, area $w_i f(x_i)$ | l.35, alt | Confirmed | `weighted_rectangles`: widths = scaled weights, heights = f(x_i). The scale factor (b−a)/2 is 1 here, so scaled weight = $w_i$. |
| 12 | Red dot at the node $x_i$ (on the bar top) | l.35, alt | Confirmed | `scatter!(x_i, f(x_i))`, also seen in frames 4, 24. A vertical red line at x_i is also drawn (not mentioned; harmless). |
| 13 | Bars laid end to end across $[0,2]$ | l.35 | Confirmed | `inst.jl`: sum of weights = 2.000000000000000 (±1e-15) and last bound = 2 for every n. |
| 14 | Each node lies inside its own bar | l.35 | Confirmed | `inst.jl`: `inside=true` for all 21 n. |
| 15 | Nodes become denser as $n$ grows | l.35 | Confirmed | min x_i falls from 0.423 (n=2) to 6.95e-4 (n=64). Frames show this. |
| 16 | "from $n=6$ on it decreases in every frame" | l.35 | Confirmed | Approximations: 2.019465 (6), 2.017912, 2.017086, 2.016729, 2.016553, 2.016457, 2.016400, 2.016365, 2.016327, 2.016308, 2.016298, 2.016292, 2.016289, 2.016286, 2.016285, 2.016283, 2.016282 (64). Strictly decreasing. (n=5 is 2.014623, below I, so the restriction to n≥6 is needed and correctly stated.) |
| 17 | Last frame ($n=64$) gives 2.016282 | l.35, alt | Confirmed | Script 2.016281583861, numpy 2.016281583861. Frame 24 shows "Approximation = 2.016282". |
| 18 | "still about $1.9\times10^{-6}$ high" | l.35 | Confirmed | Error = +1.8642e-6. |
| 19 | $f'$ unbounded at 0, $f'(x)\approx\frac{16}{3}x^{-1/3}$ near 0 | l.35 | Confirmed | mpmath f'(1e-9) = 5333.33332 vs (16/3)(1e-9)^{-1/3} = 5333.33333. |
| 20 | Error shrinks only algebraically, like $O(n^{-10/3})$ | l.35 | Confirmed | Log-log slope 3.305 (48→64) and 3.299 (32→64), against 10/3 = 3.333. This matches theory for an $x^{2/3}$ endpoint singularity, where the error is $O(n^{-2-2\alpha})$ with α=2/3. |
| 21 | Doubling $n$ divides the error by about 9.8 (32→64) | l.35 | Confirmed | 1.8347e-5 / 1.8642e-6 = 9.84. |
| 22 | …tending to $2^{10/3}\approx10.08$ | l.35 | Confirmed | 2^{10/3} = 10.079. The ratios 9.22 (8→16), 9.65 (16→32) and 9.84 (32→64) increase toward it. |
| 23 | Textbook error order (assumes smooth f) does not hold | l.35 | Confirmed | Follows from #19–20: the error is algebraic, not geometric. |
| 24 | Smooth integrand $1+e^{-x}\sin 8x$ has error $4\times10^{-17}$ at $n=16$ | l.35 | **Wrong** (F1) | Actual error is 4e-16 to 1e-15 (round-off). 4e-17 is unattainable in Float64. |
| 25 | Alt text: n increases from 2 to 64, estimate settles toward 2.016280, reaching 2.016282 at 64 nodes | l.39 | Confirmed | See #7, #8, #17. |
| 26 | Source link `gausslegendreaa.jl` and embed `gausslegendreaa.gif` are this case | l.37, l.39 | Confirmed | The script writes `gausslegendreaa.gif`. The committed GIF is byte-identical to the regeneration (manifest). |
| 27 | Compares $I_n=\sum w_i f(x_i)$ against a high-resolution numerical reference | l.41–42 | Confirmed | Trapezoid with 120001 points. Accurate to 1.35e-8, far below the smallest displayed error (1.9e-6). |
| 28 | "follows the archived module equation" (same function as the archive) | l.41 | Confirmed | Archive Example 6 (gr_278) uses `f[x_]=1+e^-x Sin[8x^(2/3)]`, a=0, b=2. |

---

### 3. Implementation checks — `gausslegendreaa.jl`

**Is it the method it claims to be?** Yes. It is plain (non-composite) n-point Gauss-Legendre quadrature. Nodes and weights come from the Golub-Welsch eigenvalue method on the Legendre Jacobi matrix, with off-diagonal $k/\sqrt{4k^2-1}$ and weights $2v_{1,i}^2$ (μ₀ = 2). The rule is shifted affinely to [0,2]. This is a standard construction of the rule the page describes, not a different variant.

**Are the numbers right?** Yes.
- Nodes: the computed t_i are roots of P_n. The residual |P_n(t_i)| is at most 4.7e-13 at n=64 (BigFloat Bonnet recurrence). Weights match the closed form $2/((1-t_i^2)P_n'(t_i)^2)$ to 5e-15.
- Degree of precision: exactly 2n−1. Moments of degree 0..2n−1 are exact to ~1e-15, and degree 2n fails (n=2,3,5,10 tested).
- Approximations: script values beside independent numpy `leggauss` (computed on 1+t):

| n | script | numpy | error vs I |
|---|---|---|---|
| 2 | 1.154627908484 | 1.154627908484 | −8.6165e-1 |
| 3 | 2.332149179135 | 2.332149179135 | +3.1587e-1 |
| 5 | 2.014622535920 | 2.014622535920 | −1.6572e-3 |
| 6 | 2.019465088565 | 2.019465088565 | +3.1854e-3 |
| 16 | 2.016456684783 | 2.016456684783 | +1.7697e-4 |
| 32 | 2.016298066545 | 2.016298066545 | +1.8347e-5 |
| 48 | 2.016284543986 | 2.016284543986 | +4.8244e-6 |
| 64 | 2.016281583861 | 2.016281583861 | +1.8642e-6 |

  All 21 values agree to 12 decimals. The full list is in the `inst.jl` / `indep.py` output. The legacy Mathews GIF independently shows the same 6-decimal values where its n overlap (n=2: 1.154628, 6: 2.019465, 10: 2.017086, 14: 2.016553, 18: 2.016400).

**Reference value:** the script uses a trapezoid rule with 120001 points, giving 2.016279706128. The independent mpmath value (x=u³ substitution, which removes the singularity; cross-checked by direct mp.quad with subdivisions) is 2.016279719617. The difference is 1.35e-8, so the displayed "I = 2.016280" is correct. It is also adequate because the smallest error shown (1.9e-6 at n=64) is about 140 times larger.

**Does the picture show what was computed?** Yes. I checked frames 1–4, the contact sheet (frames at n=3,5,8,12,16,20,28,36,44,56) and frame 24 against the code:
- Bars run from cumulative-weight bounds (`a + [0; cumsum(w)]`) with height f(x_i).
- Red dots sit at (x_i, f(x_i)) on the bar tops.
- The magenta curve is f.
- "Sample Points = n" and "Approximation = …" match the computed values.
- Axis window [0,2]×[0,2.1] contains the whole graph (max f ≈ 1.92 near x ≈ 0.09, min ≈ 0.36).
- Nothing is clamped or masked.
- Very thin bars near x=0 at large n are a true feature of the rule (weights cluster at the endpoints), not a display artefact.

**Fidelity to the archive:** consistent. The archive animation uses the same f on [0,2], the same bar geometry (n=2 bars [0,1] and [1,2]) and n = 2,4,…,40. The page uses a different n sequence (2…6, then even n to 20, then steps of 4 and 8 up to 64) and adds a reference-value frame. These extend the archive rather than depart from it, so there is no Fidelity finding.

