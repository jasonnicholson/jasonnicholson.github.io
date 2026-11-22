# Newton-Cotes Integration — animation review

Page: [`pages/numerical-methods/newton-cotes-integration/index.qmd`](../../pages/numerical-methods/newton-cotes-integration/index.qmd) · Scripts: `newtoncotesaa.jl`, `newtoncotesbb.jl`, `newtoncotescc.jl`, `newtoncotesdd.jl` · GIFs: 4

**Result:** 0 error, 1 misleading, 1 minor.

Errors and misleading findings were each re-checked by an independent subagent given only the allegation (not the reviewer's reasoning). Minor findings were not independently re-checked. Finding IDs (F1, F2, …) are the reviewer's and match the claim ledger below.

## Findings

### F1 — Misleading — Page match — "Higher degree ⇒ higher algebraic order" is false at the Simpson 1/3 → 3/8 step

- **Location:** index.qmd:13 "trapezoidal (degree 1), Simpson's $1/3$ (degree 2), Simpson's $3/8$ (degree 3), and Boole's rule (degree 4)"; index.qmd:43 "Triplets of subintervals are approximated by cubics, giving a higher-order piecewise fit to the curve."; index.qmd:61 "The closed Newton-Cotes family on equally spaced nodes increases algebraic order by fitting higher-degree interpolants per panel."
- **Now:** The page lists the rules by interpolant degree 1, 2, 3, 4 without saying what "degree" means. It then says that higher-degree interpolants increase the algebraic order, and it calls the 3/8 rule a "higher-order" fit, implying the 3/8 rule is a step up from Simpson 1/3.
- **True:** The degrees of precision are 1, 3, 3, 5, and the composite error orders are O(h²), O(h⁴), O(h⁴), O(h⁶). Simpson 3/8 (cubic interpolant) has the same degree of precision and the same order as Simpson 1/3 (quadratic interpolant), because closed rules with an even number of subintervals gain one extra degree. For smooth f and the same h, the composite 3/8 error constant ((b−a)h⁴f⁽⁴⁾/80) is larger than Simpson 1/3's ((b−a)h⁴f⁽⁴⁾/180). The cubic is a higher-degree *interpolant*, but the 3/8 rule is not a higher-order *quadrature rule*.
- **Evidence:**
  - `reviewer/indep.py` solves the moment equations with sympy for weights on nodes 0..m. It gives weights h·(1/2,1/2), h·(1/3,4/3,1/3), h·(3/8,9/8,9/8,3/8) and h·(14/45,64/45,8/15,64/45,14/45), with degree of precision **1, 3, 3, 5**.
  - `reviewer/precision_check.jl` runs the scripts' own `trapezoid_sum`/`simpson_sum`/`simpson38_sum`/`boole_sum` on x^k over [0,2]:
    - Trapezoid is exact for k ≤ 1 (k=2 error 1.33).
    - Simpson 1/3 is exact for k ≤ 3 (k=4 error 0.267).
    - Simpson 3/8 is exact for k ≤ 3 (k=4 error 0.119).
    - Boole is exact for k ≤ 5 (k=6 error 0.0476).
  - `reviewer/smooth_rate.jl` measures the error ratio per halving of h on the smooth control f = eˣ: 3.99, 15.91, **15.92**, 63.61. Simpson 1/3 and 3/8 have the same order.
- **Suggested fix:** At line 13, write "(interpolant degree 1, 2, 3, 4; degree of precision 1, 3, 3, 5)". At line 61, replace the sentence with something like "Higher-degree interpolants generally raise the degree of precision, but only every other step: the even-subinterval rules (Simpson 1/3, Boole) gain an extra degree, so Simpson 3/8 has the same O(h⁴) order as Simpson 1/3." At line 43, replace "giving a higher-order piecewise fit" with "a higher-degree piecewise fit with the same O(h⁴) order as Simpson's 1/3 rule".

- **Independent check:** confirmed with correction. Checker: both Simpson rules have degree of precision 3 (computed exactly) and measured order 4.00 on a smooth integrand; the 3/8 rule has 2.25× more error at the same h. Correction: line 13 is accurate on its own (it gives interpolant degree only); lines 43 and 61 are the misleading ones.

### F2 — Minor — Page match — The page does not say its integrand is non-smooth at x = 0, which removes the order advantage of the higher-degree rules

- **Location:** index.qmd:23 "Each case uses $f(x)=e^{-x}\sin(8x^{2/3})+1$ on $[0,2]$"; index.qmd:61 "Higher-order rules reduce truncation error for smooth functions…"
- **Now:** The page shows all four rules on f(x)=e^{−x}sin(8x^{2/3})+1. It mentions order only in the general sentence "Higher-order rules reduce truncation error for smooth functions", with no word that this f is not smooth.
- **True:** Because of x^{2/3}, f′(x) ~ (16/3)x^{−1/3} → ∞ at x = 0. All four composite rules therefore converge at the same degraded rate O(h^{5/3}), with an error ratio of about 2^{5/3} ≈ 3.17 per halving of h, instead of 4 / 16 / 16 / 64. The higher-degree rules are still more accurate here, but only by a constant factor. At 121 points the errors are:
  - Trapezoid: 1.34e−3
  - Simpson 3/8: 4.69e−4
  - Boole: 3.19e−4

  The page makes no numerical claim that is contradicted, so this is Minor. But the sentence at line 61, placed right after animations of a non-smooth integrand, invites readers to assume the textbook rates apply to what they just watched.
- **Evidence:** `reviewer/indep.py` computes the reference integral and the error ratio err(n)/err(2n) for each rule at successive halvings.
  - Reference integral (mpmath, 40 digits): I = 2.016279719617096327887274. It is confirmed by the singularity-free substitution x = u³, which gives the same 25 digits.

  | Rule | Ratios err(n)/err(2n) | Asymptotic log₂ |
  |---|---|---|
  | Trapezoid | 3.115, 3.151, 3.162, 3.166 | 1.66 |
  | Simpson 1/3 | 3.709, 3.283, 3.202, 3.184, 3.179 | 1.67 |
  | Simpson 3/8 | 3.550, 3.252, 3.195, 3.182, 3.178 | 1.67 |
  | Boole | 3.101, 3.172, 3.182, 3.179, 3.177, 3.176 | 1.67 |

  The control with smooth eˣ (`reviewer/smooth_rate.jl`) gives the textbook ratios 4/16/16/64. This shows the degradation comes from the integrand, not from the code.
- **Suggested fix:** Add one sentence after line 23 or in the Derivation Notes, for example: "Because $x^{2/3}$ has an unbounded derivative at $x=0$, this integrand is not smooth there; all four rules converge at the same reduced rate $O(h^{5/3})$, so the higher-degree rules win only by a constant factor here, not by the $O(h^2)$/$O(h^4)$/$O(h^6)$ orders they achieve on smooth integrands."

- **Independent check:** not run (minor finding, unverified).

## Inventory (Phase 1)

Every script was copied to scratch and run with the global Julia environment (Plots 1.41.2, SpecialFunctions 2.9.2); each was also run alone to map scripts to GIFs.

| Script | Ran | Time (s) | GIFs produced |
|---|---|---|---|
| `newtoncotesaa.jl` | yes | 3.7 | newtoncotesaa.gif |
| `newtoncotesbb.jl` | yes | 3.4 | newtoncotesbb.gif |
| `newtoncotescc.jl` | yes | 3.5 | newtoncotescc.gif |
| `newtoncotesdd.jl` | yes | 3.7 | newtoncotesdd.gif |

Committed GIFs byte-identical to their regenerated output: **4 of 4**. Decoded frames were also compared; all match.

Inventory findings: none (every script runs, every GIF is produced by a script and embedded by the page, every page reference exists, and the section index links the page).

## Claim ledger

| # | index.qmd line | Claim (page's own words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | 12–13 | "approximate $\int_a^b f(x)\,dx$ by interpolating $f$ on equally spaced nodes and integrating the interpolating polynomial on each panel" | The exact integral of each drawn monomial polynomial, summed over panels, equals the script's rule value to ≤1.4e−14 (nc_bb/cc/dd_vals.jl) | confirmed |
| 2 | 13 | "trapezoidal (degree 1), Simpson's 1/3 (degree 2), Simpson's 3/8 (degree 3), and Boole's rule (degree 4)" | True as interpolant degree. Degree of precision is 1, 3, 3, 5 (indep.py, precision_check.jl) | confirmed as interpolant degree; misleading without that qualifier (→ F1) |
| 3 | 16 | $T_n = h[\tfrac12 f(x_0)+\sum_{i=1}^{n-1}f(x_i)+\tfrac12 f(x_n)]$ | Matches the derived weights h·(1/2,1/2) composited; matches script `trapezoid_sum` | confirmed |
| 4 | 17 | $S_n = \tfrac{h}{3}[f(x_0)+f(x_n)+4\sum f(x_{2k-1})+2\sum f(x_{2k})]$ | Matches derived weights h·(1/3,4/3,1/3) composited; matches script `simpson_sum` (odd 4, interior even 2) | confirmed |
| 5 | 19 | "increasing point density over the full interval between frames" | Each script's n_seq is strictly increasing and every frame partitions all of [0,2]; frames viewed | confirmed |
| 6 | 23 | "Each case uses $f(x)=e^{-x}\sin(8x^{2/3})+1$ on $[0,2]$" | Line 8–9 of all four scripts: `exp(-x) * sin(8 * x^(2 / 3)) + 1`, a,b = 0,2 | confirmed |
| 7 | 23 | "shows a different closed Newton-Cotes construction" | All four rules use both endpoints (closed); m = 1, 2, 3, 4 | confirmed |
| 8 | 23 | "sample density increases frame by frame" | Frame 1 shows the curve only (n=0); n then increases each frame; the "Sample Points" label rises monotonically in the frames | confirmed |
| 9 | 25 | Case 1 is the "Composite Trapezoidal Rule" | newtoncotesaa.jl `trapezoid_sum`; title "Trapezoidal Rule" | confirmed |
| 10 | 27 | "Linear segments connect adjacent sample points, creating trapezoids that refine as nodes get denser." | Lines 38–41 draw the polygon (xl,0),(xr,0),(xr,f(xr)),(xl,f(xl)) and the chord; contact sheet shows refinement | confirmed |
| 11 | 29, 31 | Case 1 links newtoncotesaa.jl and embeds newtoncotesaa.gif | Manifest: newtoncotesaa.gif is produced by newtoncotesaa.jl, byte-identical | confirmed |
| 12 | 31 (alt) | "full-interval point density increases each frame and trapezoid approximation updates" | Approximation label changes every frame and matches the independent values (table below) | confirmed |
| 13 | 33 | Case 2 is "Composite Simpson's Rule (1/3)" | newtoncotesbb.jl `simpson_sum` with weights h/3·(1,4,2,…,4,1); title "Simpson's Rule" | confirmed |
| 14 | 35 | "Pairs of subintervals are approximated by quadratics" | Lines 40–47 fit a degree-2 polynomial through x0, x0+h, x0+2h per pair; node residual ≤2.6e−15 | confirmed |
| 15 | 35 | "producing a visibly smoother top boundary than trapezoids" | Contact sheets at 9 points: the trapezoid boundary has kinks at every node, Simpson only at every second node, with curved arcs between | confirmed |
| 16 | 37, 39 | Case 2 links newtoncotesbb.jl / embeds newtoncotesbb.gif | Manifest | confirmed |
| 17 | 39 (alt) | "density increases each frame and piecewise quadratic area approximation updates" | n = 2,4,…,40; frames viewed | confirmed |
| 18 | 41 | Case 3 is "Composite Simpson's 3/8 Rule" | newtoncotescc.jl `simpson38_sum` = 3h/8·(1,3,3,2,3,3,2,…,1); values match the independent composite | confirmed |
| 19 | 43 | "Triplets of subintervals are approximated by cubics" | Lines 40–48 fit degree 3 through 4 nodes per triple; node residual ≤1.3e−14 | confirmed |
| 20 | 43 | "giving a higher-order piecewise fit to the curve" | A higher-degree interpolant, but the quadrature order is the same as Simpson 1/3 (DOP 3, ratio 15.92 vs 15.91 on eˣ) | wrong as an order claim (→ F1) |
| 21 | 45, 47 | Case 3 links newtoncotescc.jl / embeds newtoncotescc.gif | Manifest | confirmed |
| 22 | 47 (alt) | "increasing node density with piecewise cubic area updates" | n = 3…120, all multiples of 3; frames viewed | confirmed |
| 23 | 49 | Case 4 is "Composite Boole's Rule" | newtoncotesdd.jl `boole_sum` = 2h/45·(7,32,12,32,7) per block; equals derived weights; DOP 5 | confirmed |
| 24 | 51 | "Blocks of four subintervals use quartic interpolation." | Lines 49–58 fit degree 4 through 5 nodes per block; node residual ≤6.6e−14; all n multiples of 4 | confirmed |
| 25 | 51 | "As density rises, the piecewise quartic envelope tracks oscillations closely." | envelope.py: max deviation from f is 1.46 at 5 points, 0.26 at 13, 0.13 at 25 and 0.045 at 121. From 25 points on, the remaining deviation sits within x < 0.02 at the singular point. Contact sheet: visually indistinguishable from f from 25 points on | confirmed |
| 26 | 53, 55 | Case 4 links newtoncotesdd.jl / embeds newtoncotesdd.gif | Manifest | confirmed |
| 27 | 55 (alt) | "increasing point density with piecewise quartic area updates" | n = 4…120; frames viewed | confirmed |
| 28 | 61 | "The closed Newton-Cotes family on equally spaced nodes increases algebraic order by fitting higher-degree interpolants per panel." | DOP 1, 3, 3, 5: going from the quadratic (Simpson 1/3) to the cubic (Simpson 3/8) gives no increase in order | wrong (→ F1) |
| 29 | 61 | "Higher-order rules reduce truncation error for smooth functions" | True for smooth f (eˣ ratios 4/16/16/64). The page's own f is not smooth, and all rules run at h^{5/3} | confirmed as stated; context omission (→ F2) |
| 30 | 61 | "can become less robust for very high degree on wide panels" | General fact (high-order closed NC rules get negative weights); not exercised by any script | confirmed (general statement, not tested here) |
| — | — | Stated error orders / convergence rates | The page states none explicitly; measured rates are reported under F2 | n/a |

Line 57 (legacy note) is out of scope.

## Implementation checks

Common to all four scripts:
- **Reference integral:** I = 2.016279719617096327887274 (mpmath quad on 40 subintervals; the substitution x = u³ gives the same 25 digits). The scripts draw no exact value, so this reference only serves to measure errors.
- **Independent method:** `reviewer/indep.py` derives the weights from moment equations (sympy, no remembered table) and evaluates each composite rule in 40-digit mpmath for every n in the script's sequence.
- **Script values:** `reviewer/nc_<s>_vals.jl` is each script with the animation stripped, printing every frame's value.
- **Display:** All values agree to ≥14 significant digits. The frame label uses `round(x; digits=6)`, which drops a trailing zero (for example "2.01017", "2.01389", "2.01581"). This is cosmetic and not a finding.
- **Display devices:** There is no clamping or NaN masking. ylims (0, 2.1) contain f (min ≈ 0.364, max ≈ 1.92) and all drawn interpolants. The annotation text at y ≈ 1.74–1.88, x ≈ 1.15 does not overlap the curve (f ≈ 1.2 there).

### newtoncotesaa.jl
- **Method:** Composite trapezoidal rule, weights h·(½,1,…,1,½). It matches the derived weights and has DOP 1: exact for 1 and x, error 1.33 for x² (precision_check.jl).
- **Numbers (script vs independent):**

  | n | Pts | Script | mpmath |
  |---|---|---|---|
  | 1 | 2 | 2.017924816215668 | 2.01792481622 |
  | 4 | 5 | 1.8020714882340843 | 1.80207148823 |
  | 24 | 25 | 1.9970856958540892 | 1.99708569585 |
  | 64 | 65 | 2.0124875356136163 | 2.01248753561 |
  | 120 | 121 | 2.0149444646203434 | 2.01494446462 |

  All 24 values agree (full list in the indep.py and nc_aa_vals.jl output).
  - **Rate:** err ratio per halving 3.115 → 3.166 (log₂ 1.66), versus 3.99 on eˣ.
  - **Note:** The n=1 value (2.017925, error 1.6e−3) is fortuitously almost as close to I as n=120 (error 1.3e−3). The page makes no claim about this.
- **Reference values:** None drawn.
- **Picture:** I viewed the contact sheet (frames 1, 3, 6, 9, 12, 15, 18, 21, 24) and frame 25. Each trapezoid uses f at its own two endpoints, the chord runs along the top, "Sample Points = n+1" is correct, and the approximation label matches the computed value.

### newtoncotesbb.jl
- **Method:** Composite Simpson 1/3, h/3·(1,4,2,4,…,4,1). DOP 3: exact through x³, x⁴ error 0.267.
- **Numbers (script vs independent):**

  | n | Pts | Script | mpmath |
  |---|---|---|---|
  | 2 | 3 | 2.4912610172534464 | 2.49126101725 |
  | 4 | 5 | 1.611786328647445 | 1.61178632865 |
  | 20 | 21 | 2.0079417386648446 | 2.00794173866 |
  | 40 | 41 | 2.0138900411352303 | 2.01389004114 |

  All 20 agree.
  - **Rate on this f:** 3.709, 3.283, 3.202, 3.184, 3.179 (log₂ → 1.67), versus 15.91 on eˣ.
- **Reference values:** None drawn.
- **Picture:**
  - **What I viewed:** the contact sheet (all 21 frames shown, 12 sampled) and frame 21.
  - **Interpolant check:** Each arc is the quadratic through f at x0, x0+h, x0+2h, built with a Vandermonde solve. Its node residual is ≤2.6e−15, and it differs from the Lagrange form by ≤3e−15. The integral of the drawn polynomials equals `simpson_sum` to 1.3e−15, so the shaded area is the reported number.
  - **Visible overshoot:** The last frames visibly overshoot the peak near x ≈ 0.08. This is a real property of the interpolant next to the x^{2/3} point (max deviation 0.13 at x = 0.012 with 41 points), not a drawing error.
  - **Animation length:** This animation stops at 41 points while the other three go to 121. This is not a page claim.

### newtoncotescc.jl
- **Method:** Composite Simpson 3/8, 3h/8·(1,3,3,2,3,3,2,…,3,3,1). This equals the derived per-panel weights h·(3/8,9/8,9/8,3/8) with shared panel ends summed (confirmed by matching values against the panel-by-panel mpmath composite). DOP 3: exact through x³, x⁴ error 0.119. Every n in the sequence is a multiple of 3.
- **Numbers (script vs independent):**

  | n | Pts | Script | mpmath |
  |---|---|---|---|
  | 3 | 4 | 1.8842140994188474 | 1.88421409942 |
  | 9 | 10 | 1.9272339711446245 | 1.92723397114 |
  | 48 | 49 | 2.014059184718606 | 2.01405918472 |
  | 120 | 121 | 2.015810410863725 | 2.01581041086 |

  All 24 agree.
  - **Rate:** 3.550, 3.252, 3.195, 3.182, 3.178 (log₂ → 1.67), versus 15.92 on eˣ.
- **Reference values:** None drawn.
- **Picture:** I viewed the contact sheet and frame 25. Each arc is the cubic through 4 nodes (node residual ≤1.3e−14, Lagrange difference ≤1.9e−14), and its integral equals the rule to 4e−15. The 10-point frame shows the cubic dipping below f near x = 0.5 and missing the first peak. This is consistent with the computed max deviation of 1.17 at 7 points and 0.20 at 19 points.

### newtoncotesdd.jl
- **Method:** Composite Boole, 2h/45·(7,32,12,32,7) per block of four. This matches the derived weights h·(14/45,64/45,8/15,64/45,14/45). DOP 5: exact through x⁵ (x⁵ residual 1.8e−15), x⁶ error 0.0476. Every n is a multiple of 4.
- **Numbers (script vs independent):**

  | n | Pts | Script | mpmath |
  |---|---|---|---|
  | 4 | 5 | 1.5531546827403782 | 1.55315468274 |
  | 12 | 13 | 2.0012951727392143 | 2.00129517274 |
  | 64 | 65 | 2.0153696865415838 | 2.01536968654 |
  | 120 | 121 | 2.0159611788705827 | 2.01596117887 |

  All 24 agree.
  - **Rate:** 3.101 → 3.176 (log₂ 1.667), versus 63.61 on eˣ.
- **Reference values:** None drawn.
- **Picture:** I viewed the contact sheet, frame 2 (n=4) at full size and frame 25. In frame 2 the single quartic passes through f at x = 0, 0.5, 1, 1.5, 2 and misses both oscillation peaks, which is correct for 5 nodes. The quartic node residual is ≤6.6e−14, the Lagrange difference ≤8.2e−14, and the integral of the drawn polynomials equals `boole_sum` to 1.4e−14. With ≥25 points the envelope is visually on the curve, consistent with ledger item 25.

### Re-runnable evidence (all in reviewer/)
- `indep.py`: sympy-derived weights and DOP, mpmath reference integral, independent composite values for every frame, halving ratios.
- `nc_aa_vals.jl`, `nc_bb_vals.jl`, `nc_cc_vals.jl`, `nc_dd_vals.jl`: script routines printing every frame's value, plus node-residual, Lagrange and area-consistency checks for the drawn polynomials.
- `precision_check.jl`: the scripts' own routines on xᵏ, k = 0..7.
- `smooth_rate.jl`: the scripts' own routines on eˣ (textbook-rate control).
- `envelope.py`: max deviation between the piecewise interpolant and f.

## Evidence

The reviewer's and checker's computation scripts are copied to [`evidence/newton-cotes-integration/`](evidence/newton-cotes-integration/) (`reviewer/` and `verify/`). They were run from a scratch directory; paths inside them point at that scratch area and will need adjusting to re-run.
