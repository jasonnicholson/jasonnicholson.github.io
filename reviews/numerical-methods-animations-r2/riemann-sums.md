# Riemann Sums — animation review (round 2)

Page: `pages/numerical-methods/riemann-sums/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page was confirmed against independent computation and the frames, and all four scripts compute what they claim.

Observations that I judged *not* to be findings (recorded so the owner can see they were considered):

- `riemannaa.jl:41` and `riemannbb.jl:41` format the on-frame value with `round(approx; digits=6)`, which drops trailing zeros, so some frames show fewer than six decimals: `Approximation = 2.0` (Left, n=1), `1.79759` (Left, n=4), `1.8522` (Left, n=6), `1.95574` (Left, n=12), `2.03585` (Right, n=1), `2.01341` (Right, n=72). Each displayed value is correct to the digits shown (e.g. L_6 = 1.852200399), so nothing is misleading; it is only inconsistent with Cases 3/4, which use `@sprintf("%.6f", ...)`. Optional tidy-up: use `@sprintf("%.6f", approx)` in aa/bb too.
- The n2003 module's Examples 10-13 (the Left/Right/Lower/Upper "Various Scenarios and Animations" examples) state `f(x) = 1 + e^{-x} sin(9x/2)` on [0,2] (formula images gr_176, gr_227), while the a2001 animated GIFs those examples link to use `y = e^{-x} sin(8x^{2/3}) + 1` on [0,2]. The page uses the animation's function, which is the right source for an animations page (and is what the legacy animations actually show). Not a fidelity departure.
- The legacy animations use n = 1, 2, 4, 6, 8, ..., 100, 120 (per the lnk_15-18 tables); the page uses 1-8, 10, 12, ..., 120. Same "density over the whole interval" pattern, same endpoint n = 120; not a meaningful departure.
- Legacy lower/upper approximations differ from the page's in the 6th-7th significant digit in places (legacy Lower n=1 0.714411, Upper n=4 2.843070, Upper n=6 2.508595, Upper n=8 2.427094, Lower n=32 1.872235). The page's values agree with my independent computation (0.714407, 2.843078, 2.508600, 2.427098, 1.870891); the legacy used approximate numerical minimisation. The page departs from the archive in order to be right: correct.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `riemannaa.jl` | 0 | 7.1 | riemannaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `riemannbb.jl` | 0 | 6.5 | riemannbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `riemanncc.jl` | 0 | 7.4 | riemanncc.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `riemanndd.jl` | 0 | 7.5 | riemanndd.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `riemannaa.gif` | 25 | byte-identical | riemannaa |
| `riemannbb.gif` | 25 | byte-identical | riemannbb |
| `riemanncc.gif` | 25 | byte-identical | riemanncc |
| `riemanndd.gif` | 25 | byte-identical | riemanndd |

### Page references

- Scripts linked: `riemannaa.jl`, `riemannbb.jl`, `riemanncc.jl`, `riemanndd.jl`
- GIFs embedded: 4
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

Independent reference values come from `indep.py` (mpmath, 30 digits; exact Riemann sums, exact min/max via the four interior critical points) and `brute.py` (numpy/scipy dense sampling + bounded optimisation; does not use any derivative formula).

| # | Page text (location) | Check | Verdict |
|---|---|---|---|
| 1 | Description: "partitioning [a,b] into n subintervals ... Δx = (b−a)/n" | All scripts use `dx = (b-a)/n` with equal subintervals | confirmed |
| 2 | Description: "As n increases ... the approximation converges to the true integral" | f continuous on [0,2]; all four sums at n=120 within 0.035 of I and trending to it (table §3) | confirmed |
| 3 | Description: nodes x_i = a + iΔx; L_n = Σ_{i=0}^{n-1} f(x_i)Δx | `riemannaa.jl:18` exactly this | confirmed |
| 4 | Description: R_n = Σ_{i=1}^{n} f(x_i)Δx | `riemannbb.jl:18` exactly this | confirmed |
| 5 | Description: "bounds from interval minima/maxima" | `riemanncc.jl:41`, `riemanndd.jl:41` take exact min/max over endpoints + interior critical points | confirmed |
| 6 | Description: "legacy Mathews animations increase sampling density over the entire interval between frames. The animations below follow that same pattern." | Legacy frames (e.g. Left: n=1,4,8,12,16,24,32,50,70,100) and committed frames both repartition the whole interval each frame | confirmed |
| 7 | Animations intro: "Riemann sum diagram over [0, 2]" | `a, b = 0.0, 2.0`, xlims (0,2) in all four | confirmed |
| 8 | Intro and every heading: y = e^{-x} sin(8x^{2/3}) + 1 | `f(x) = exp(-x) * sin(8 * x^(2 / 3)) + 1` in all four scripts; frame curves match (peak 1.920 at x≈0.080, min 0.357 at x≈0.432, max 1.385 at x≈0.939, min 0.796 at x≈1.564) | confirmed |
| 9 | Intro: "n increases across the full interval ... refines by density, not by sweeping left-to-right" | Frames: each frame redraws all n rectangles across [0,2]; n_seq strictly increasing | confirmed |
| 10 | Intro: "Julia source scripts ... are linked under each case" | 4 links present, each to the case's script | confirmed |
| 11 | Case 1 heading "Left Riemann Sum" / link `riemannaa.jl` / embed `riemannaa.gif` | Script computes left sum, frame titles "Left Riemann Sum"; committed GIF byte-identical to regenerated output (manifest) | confirmed |
| 12 | Case 1: "rectangle height ... taken at the left endpoint" | `riemannaa.jl:31-33` h = f(xl); frame 2 (n=1) height 1.0 = f(0) | confirmed |
| 13 | Case 1: "approximation settles toward the true integral" | L_n: 2.0, 2.364, 1.893, 1.798, then increasing monotonically to 2.014795 at n=120; I = 2.016280 | confirmed |
| 14 | Case 1 alt text: "each frame increases partition density and updates the left-endpoint area estimate" | Frames 2-25 show increasing n with updated value (frame 1 is the bare curve) | confirmed |
| 15 | Case 2 heading "Right Riemann Sum" / `riemannbb.jl` / `riemannbb.gif` | as #11 | confirmed |
| 16 | Case 2: "height is taken at the right endpoint" | `riemannbb.jl:31-33` h = f(xr); n=3 frame heights f(2/3), f(4/3), f(2) | confirmed |
| 17 | Case 2: "Comparing with Case 1 shows how endpoint choice shifts the approximation at finite n" | R_n − L_n = Δx (f(2) − f(0)) = 0.03585/n: e.g. n=1 2.035850 vs 2.0; n=120 2.015094 vs 2.014795 | confirmed |
| 18 | Case 2 alt text | as #14 | confirmed |
| 19 | Case 3 heading "Lower Riemann Sum" / `riemanncc.jl` / `riemanncc.gif` | as #11 | confirmed |
| 20 | Case 3: "Each rectangle uses the minimum of f on its subinterval" | `fmin` over endpoints + interior critical points; brute-force min agrees (n=1,3,4,7,8,120 to 9 decimals); frame 5 (n=4) heights 0.357, f(0.5), f(1.5), 0.796 visible | confirmed |
| 21 | Case 3: "every frame's sum is a lower bound for the integral" | All 24 lower sums < I (max 1.978951 at n=120) | confirmed |
| 22 | Case 3: "I ≈ 2.016280" | mpmath (x=t³ substitution) I = 2.0162797196170963; split-interval quad agrees to 29 digits | confirmed |
| 23 | Case 3: "approach I as n grows, but not monotonically" | Sequence 0.714, 1.153, 1.375, **1.192**, 1.376, 1.448, ... 1.978951: one drop (n=3→4), otherwise increasing | confirmed |
| 24 | Case 3: "lower sum falls from 1.374576 at n=3" | 1.3745762078 | confirmed |
| 25 | Case 3: "to 1.192004 at n=4" | 1.1920041540 | confirmed |
| 26 | Case 3: "because the n=4 partition is not a refinement of the n=3 one" | {0,2/3,4/3,2} ⊄ {0,1/2,1,3/2,2}; refinement would force L(n=4) ≥ L(n=3) | confirmed |
| 27 | Case 3 alt text: "each frame increases the number of subintervals and uses the minimum of f on each subinterval" | as #20, frames | confirmed |
| 28 | Case 4 heading "Upper Riemann Sum" / `riemanndd.jl` / `riemanndd.gif` | as #11 | confirmed |
| 29 | Case 4: "Each rectangle uses the maximum of f on its subinterval" | `fmax`; brute-force agrees; frame 9 (n=8) first rectangle height 1.920 (interior max at 0.0804) | confirmed |
| 30 | Case 4: "every frame's sum is an upper bound for the integral" | All 24 upper sums > I (min 2.050951 at n=120) | confirmed |
| 31 | Case 4: "Lower and upper sums squeeze the exact value as n → ∞" | Gap U−L: 3.125 (n=1) → 0.0720 (n=120), shrinking ~1/n | confirmed |
| 32 | Case 4: "at n=120, 1.978951 ≤ I ≤ 2.050951" | L=1.9789510237, U=2.0509510464, I=2.0162797 | confirmed |
| 33 | Case 4: "not monotonically along this sequence of n" | Upper: 3.840, 3.284, 2.881, 2.843, 2.678, 2.509, 2.418, **2.427**, 2.366, ... decreasing except n=7→8 | confirmed |
| 34 | Case 4: "upper sum rises from 2.418035 at n=7" | 2.4180348322 | confirmed |
| 35 | Case 4: "to 2.427098 at n=8" | 2.4270980115 | confirmed |
| 36 | Case 4 alt text: "uses the maximum of f on each subinterval" | as #29 | confirmed |
| 37 | Frame annotations (all GIFs): "Sample Points = n" (aa, bb) / "Subintervals = n" (cc, dd) and "Approximation = value" | Annotation uses the same n and sum as drawn; values equal instrumented script output, which equals independent values (§3) | confirmed |

### 3. Implementation checks

Common to all four scripts: f(x) = e^{-x} sin(8x^{2/3}) + 1 on [0,2]; n_seq = [1,2,3,4,5,6,7,8,10,12,14,16,20,24,28,32,40,48,56,64,72,88,104,120]; 25 frames (blank curve, then one per n); xlims (0,2), ylims (0,2.1). f ranges over [0.357, 1.920] on [0,2], so nothing is clipped and no masking is used. Per the manifest, all four committed GIFs are byte-identical to fresh scratch regenerations, so the frames are the scripts' output.

### riemannaa.jl (Left)
- **Method:** left-endpoint Riemann sum, Δx (f(x_0)+...+f(x_{n-1})); rectangles drawn on [x_i, x_{i+1}] at height f(x_i). Correct method.
- **Numbers:** instrumented copy `inst_aa.jl` vs `indep.py` (mpmath):

| n | script | independent |
|---|---|---|
| 1 | 2.0 | 2.0 |
| 3 | 1.8930959069910491 | 1.893095907 |
| 4 | 1.7975902841801672 | 1.797590284 |
| 8 | 1.9043543282875939 | 1.904354328 |
| 16 | 1.9779355557746807 | 1.977935556 |
| 48 | 2.009796492388508 | 2.009796492 |
| 120 | 2.0147950911518797 | 2.014795091 |

All 24 agree to all printed digits (full table in `indep.py` output). Legacy Mathews values that are visible agree too (n=4 1.797590, n=8 1.904354, n=16 1.977936, n=24 1.996339).
- **Reference values:** the script draws none.
- **Picture:** frames 1, 2 (n=1, height f(0)=1), sheet frames n=3,6,10,16,28,48,72,120 viewed: rectangles at left endpoints, labels match n and sum.

### riemannbb.jl (Right)
- **Method:** right-endpoint Riemann sum; rectangles on [x_{i-1}, x_i] at height f(x_i). Correct.
- **Numbers:** `inst_bb.jl` vs independent: n=1 2.035849632431337 / 2.035849632; n=4 1.8065526922880015 / 1.806552692; n=8 1.908835532341511 / 1.908835532; n=120 2.0150938380888075 / 2.015093838. All 24 agree.
- **Reference values:** none drawn.
- **Picture:** sheet frames viewed; e.g. n=3 heights 0.91, 0.93, 1.02 = f(2/3), f(4/3), f(2); labels correct.

### riemanncc.jl (Lower)
- **Method:** lower (Darboux) sum with exact subinterval minima: min over the endpoints and the interior critical points of f. Critical points found by sign changes of the analytic f′ on a 20000-point grid on [1e-4, 2] plus 60 bisection steps. The f′ formula `exp(-x)*((16/3)x^(-1/3)cos(8x^(2/3)) − sin(8x^(2/3)))` is the correct derivative; the four critical points it finds (0.08038354937224365, 0.43198195723294985, 0.9392052471495191, 1.5644755011307958) agree with mpmath roots to 12 digits, and mpmath's numeric `diff(f, c)` at each is ~1e-37. On (0, 1e-4) f′ > 0 (cos term dominates, x^{-1/3} → ∞), so no critical point is missed there. Correct.
- **Numbers:** `inst_cc.jl` vs `indep.py` vs `brute.py` (derivative-free):

| n | script | mpmath | brute-force |
|---|---|---|---|
| 1 | 0.714407371854672 | 0.7144073719 | 0.714407372 |
| 3 | 1.3745762078373442 | 1.374576208 | 1.374576208 |
| 4 | 1.1920041539710546 | 1.192004154 | 1.192004154 |
| 7 | 1.5417683885275877 | 1.541768389 | 1.541768389 |
| 8 | 1.6015612631830378 | 1.601561263 | 1.601561263 |
| 120 | 1.9789510236705385 | 1.978951024 | 1.978951024 |

All 24 agree with mpmath.
- **Reference values:** I is not drawn, only quoted on the page (verified, ledger #22).
- **Picture:** frame 5 (n=4) viewed in full: heights 0.357 (interior min), f(0.5)≈0.43, f(1.5)≈0.81, 0.796 (interior min at 1.564); every rectangle lies under the curve; label "Subintervals = 4 / Approximation = 1.192004". Sheet frames n=3..120 viewed, consistent.

### riemanndd.jl (Upper)
- **Method:** upper (Darboux) sum with exact subinterval maxima, same critical-point machinery. Correct.
- **Numbers:** `inst_dd.jl` vs mpmath vs brute-force: n=1 3.8395118983809415 / 3.839511898 / 3.839511898; n=3 2.8814604949365776 / 2.881460495 / 2.881460495; n=4 2.843077650645517 / 2.843077651 / 2.843077651; n=7 2.4180348322293406 / 2.418034832 / 2.418034832; n=8 2.427098011520269 / 2.427098012 / 2.427098012; n=120 2.0509510464124627 / 2.050951046 / 2.050951046. All 24 agree with mpmath.
- **Reference values:** none drawn.
- **Picture:** frame 9 (n=8) viewed in full: first rectangle at 1.920 (interior max at 0.0804, above both endpoint values), fourth at 1.385 (interior max at 0.939), every rectangle lies above the curve; label "Subintervals = 8 / Approximation = 2.427098". Sheet frames n=3..120 viewed, consistent. Tallest rectangle 1.920 < ylim 2.1, so nothing is clipped.

### Commands run
- `python3 -I review/indep.py`: I = 2.01627971961709632788727442192; critical points and all 24×4 sums (table above).
- `python3 -I review/brute.py`: derivative-free lower/upper sums for n = 1, 3, 4, 7, 8, 120.
- `julia review/inst_{aa,bb,cc,dd}.jl`: script copies truncated before `@animate`, printing each sum at full precision and as displayed.
- `julia tools/giftools.jl` on the four legacy a2001 GIFs, output in `review/legacy_*`.

