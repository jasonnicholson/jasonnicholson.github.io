# Riemann Sums — animation review

Page: [`pages/numerical-methods/riemann-sums/index.qmd`](../../pages/numerical-methods/riemann-sums/index.qmd) · Scripts: `riemannaa.jl`, `riemannbb.jl`, `riemanncc.jl`, `riemanndd.jl` · GIFs: 4

**Result:** 2 error, 1 misleading, 1 minor.

Errors and misleading findings were each re-checked by an independent subagent given only the allegation (not the reviewer's reasoning). Minor findings were not independently re-checked. Finding IDs (F1, F2, …) are the reviewer's and match the claim ledger below.

## Findings

### F1 — Error — Implementation — "Lower/Upper Riemann Sum" scripts use the endpoint min/max, not the inf/sup on each subinterval

- **Location:** riemanncc.jl:20 and :36 (`min(f(xl), f(xr))`); riemanndd.jl:20 and :36 (`max(f(xl), f(xr))`). GIF titles "Lower Riemann Sum" and "Upper Riemann Sum" (riemanncc.jl:25, riemanndd.jl:25). Case headings at index.qmd:42 and :50. The Description at index.qmd:15 says "bounds from interval minima/maxima", and the scripts contradict that.
- **Now:** Each rectangle's height is the smaller (or larger) of the two endpoint values. f oscillates, with four interior extrema, so many subintervals contain a peak or trough that the endpoints miss. The rectangles labelled "Lower" visibly rise above the curve, and the ones labelled "Upper" fall below it. Examples:
  - riemanncc frame 3 (n=2): both bars sit above the trough at 0.43 and the dip near 1.56.
  - riemanndd frame 4 (n=3): bars sit below the peaks at 0.08 and 0.94.
  - riemanndd n=16 frame: the first bar is at 1.80 under a peak of 1.92.
- **True:** A lower (upper) Riemann/Darboux sum takes inf f (sup f) on each subinterval. Table: GIF annotation compared with the true value and the true integral I = 2.016280. For n = 1, 2 and 3, a "Lower" annotation above I or an "Upper" annotation below I is not a bound at all.

  | n | GIF "Lower" | true lower | GIF "Upper" | true upper |
  |---|---|---|---|---|
  | 1 | 2.000000 | 0.714407 | 2.035850 | 3.839512 |
  | 2 | **2.017925 (> I)** | 1.152792 | 2.727929 | 3.283721 |
  | 3 | 1.832477 | 1.374576 | **1.965664 (< I)** | 2.881461 |
  | 10 | 1.633215 | 1.629124 | 2.242314 | 2.365760 |
  | 16 | 1.734425 | 1.726233 | 2.223686 | 2.240918 |
  | 120 | 1.978952 | 1.978951 | 2.050937 | 2.050951 |

  The largest height gap is 0.92 (upper, n = 3–8) and 0.64 (lower, n = 1–2). The upper-sum area error is still 0.12 at n=10, 0.017 at n=16 and 1.4e-5 at n=120 (`height_gap.py`). Every one of the 24 annotated values in each of the two GIFs differs from the true lower/upper sum at the 6 decimals shown.
- **Evidence:** `julia script_values.jl` reproduces the GIF annotations exactly; for instance it gives lower n=2 = 2.017925 and upper n=3 = 1.965664, and the rectangle areas equal the annotations to 1e-15. `python3 -I independent.py` gives the true lower and upper columns. Its columns "endptmin<=I?" and "endptmax>=I?" are False at n=2 and n=3 respectively.
- **Suggested fix:** Compute the true extrema on each subinterval. Either take the min (or max) of f over the endpoints plus any of the four critical points (0.0803835494, 0.4319819572, 0.9392052472, 1.5644755011) inside the subinterval, or take the min/max over a fine grid inside each subinterval (for example 200 points; refine near x=0, where f′ ~ x^{-1/3}). Use that both for the bar height and for `lower_sum`/`upper_sum`. If endpoint min/max is intended instead, rename the cases ("endpoint-minimum sum" / "endpoint-maximum sum"), drop the bound claims (F2), and change Description line 15.

- **Independent check:** confirmed. Checker: the scripts use min/max(f(xl), f(xr)); at n=1 the true lower/upper sums are 0.714/3.840 vs displayed 2.000/2.036; the gap falls below 1e-3 only for n≥24. Lines 44/52 do say 'endpoint', so the conflict is with line 15 ('interval minima/maxima') and the frame titles ('Lower/Upper Riemann Sum').

### F2 — Error — Page match — Cases 3 and 4 claim the sums are lower/upper bounds; the plotted values are not

- **Location:** index.qmd:44: "Each rectangle uses the **minimum endpoint value** on each subinterval. For nonnegative $f$, this gives a lower bound that rises toward the integral as density increases." index.qmd:52: "Each rectangle uses the **maximum endpoint value** on each subinterval, giving an upper bound."
- **Now:** The page says that the endpoint min gives a lower bound when f ≥ 0, and that the endpoint max gives an upper bound.
- **True:** An endpoint min/max is a bound only when f is monotone on every subinterval. Nonnegativity has nothing to do with it, and f here is not monotone. The GIF itself shows the claim failing:
  - n=2 "Lower" = 2.017925 > I = 2.016280 (riemanncc frame 3).
  - n=3 "Upper" = 1.965664 < I (riemanndd frame 4).

  Even for the true inf/sup sums, the condition "for nonnegative f" is wrong: L(f,P) ≤ ∫f holds for every bounded f.
- **Evidence:** As in F1 (`script_values.jl`, `independent.py`).
- **Suggested fix:** After fixing F1, write: "Each rectangle uses the minimum of f on its subinterval, so the sum is always a lower bound for the integral." Delete "For nonnegative f". If the endpoint version is kept, say instead that it is a bound only where f is monotone on every subinterval, and that it fails here at n=2 (lower) and n=3 (upper).

- **Independent check:** confirmed. Checker: the two violating frames are riemanncc frame_003 (n=2, 2.017925 > I) and riemanndd frame_004 (n=3, 1.965664 < I).

### F3 — Misleading — Page match — "rises toward the integral" / "squeeze": the frame sequence is not monotone

- **Location:** index.qmd:44: "a lower bound that rises toward the integral as density increases". index.qmd:52: "Lower and upper sums squeeze the exact value as $n \to \infty$."
- **Now:** The page implies the lower values increase and the upper values decrease from frame to frame.
- **True:**
  - GIF "Lower" sequence: 2.000000, 2.017925, 1.832477, 1.231216, then rising, with another dip at n=8 (1.624983 → 1.621167). It falls by 0.79 over the first four frames.
  - GIF "Upper" sequence: 2.035850, 2.727929, 1.965664, 2.372927, …, and it rises again at n=8 (2.142981 → 2.192023), n=10 (2.242314) and n=14 (2.245487).
  - The true inf/sup sums are not monotone along this n-sequence either, because the partitions are not nested. True lower drops 1.374576 → 1.192004 from n=3 to n=4. True upper rises 2.418035 → 2.427098 from n=7 to n=8.

  The limit statement itself holds: at n=120 the GIF shows 1.978952 ≤ I ≤ 2.050937, and the gap → 0.
- **Evidence:** `julia script_values.jl` and `python3 -I independent.py`, columns "TRUE lower" and "TRUE upper".
- **Suggested fix:** Either use nested partitions (for example n = 1, 2, 4, …, 128) together with the F1 fix, so that the lower sums are guaranteed non-decreasing and the upper sums non-increasing, or reword to "approaches the integral as n grows (not necessarily monotonically, since successive partitions are not refinements of each other)".

- **Independent check:** confirmed. Checker: mildly Misleading; even true lower/upper sums aren't monotone for this n sequence (partitions are not refinements), so fixing F1 alone won't fix this wording.

### F4 — Minor — Implementation — "Sample Points = n" in the Lower/Upper GIFs counts subintervals, not sample points

- **Location:** riemanncc.jl:43, riemanndd.jl:43 (`"Sample Points = $n"`).
- **Now:** The label shows n.
- **True:** n is the number of subintervals. The current code evaluates f at n+1 endpoints, and a correct lower/upper sum (F1) is not a sample-point rule at all. For Left/Right, n is the number of sample points, so the label is correct in those two GIFs.
- **Evidence:** riemanncc.jl/riemanndd.jl lines 18–20 evaluate f at a+(i-1)dx and a+i·dx for i=1..n, which is n+1 distinct points.
- **Suggested fix:** Label the Lower/Upper GIFs "Subintervals = $n" (optionally all four GIFs, for consistency).

- **Independent check:** not run (minor finding, unverified).

## Inventory (Phase 1)

Every script was copied to scratch and run with the global Julia environment (Plots 1.41.2, SpecialFunctions 2.9.2); each was also run alone to map scripts to GIFs.

| Script | Ran | Time (s) | GIFs produced |
|---|---|---|---|
| `riemannaa.jl` | yes | 3.5 | riemannaa.gif |
| `riemannbb.jl` | yes | 3.7 | riemannbb.gif |
| `riemanncc.jl` | yes | 3.6 | riemanncc.gif |
| `riemanndd.jl` | yes | 3.7 | riemanndd.gif |

Committed GIFs byte-identical to their regenerated output: **4 of 4**. Decoded frames were also compared; all match.

Inventory findings: none (every script runs, every GIF is produced by a script and embedded by the page, every page reference exists, and the section index links the page).

## Claim ledger

| # | index.qmd line | Claim (page's own words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | 12 | "partitioning $[a,b]$ into $n$ subintervals … $\Delta x = (b-a)/n$" | All scripts: dx = (b-a)/n, uniform nodes | confirmed |
| 2 | 12 | "the approximation converges to the true integral" | L₁₂₀ = 2.014795, R₁₂₀ = 2.015094, I = 2.016280. The left-sum error shrinks by about 3.0× per halving, roughly n^{-1.6}, because the leading 1/n term ∝ f(2)−f(0) = 0.018 is tiny and the x^{2/3} cusp dominates (`independent.py` rate table) | confirmed |
| 3 | 14–15 | nodes $x_i = a + i\Delta x$; $L_n=\sum_{i=0}^{n-1} f(x_i)\Delta x$; $R_n=\sum_{i=1}^{n} f(x_i)\Delta x$ | riemannaa.jl:18, riemannbb.jl:18 implement exactly these | confirmed |
| 4 | 15 | "bounds from interval minima/maxima" | Scripts use endpoint min/max, not the interval min/max | wrong (→ F1) |
| 5 | 17 | "increase sampling density over the entire interval between frames. The animations below follow that same pattern." | n_seq = 1…120 over the whole of [0,2]; contact sheets | confirmed |
| 6 | 21–22 | "over $[0, 2]$ for $y = e^{-x}\sin(8x^{2/3})+1$" | All scripts, lines 8–9; curve in frames matches (peak 1.92 at 0.08, trough 0.36 at 0.43) | confirmed |
| 7 | 22 | "the number of sample points increases across the full interval so the approximation refines by density, not by sweeping left-to-right" | Frames: each frame redraws all n rectangles over [0,2] | confirmed |
| 8 | 24 | "Julia source scripts that generated these animations are linked under each case" | manifest: each GIF is byte-identical to its script's output | confirmed |
| 9 | 26 | Case 1 is a Left Riemann Sum of the stated f | riemannaa.jl | confirmed |
| 10 | 28 | "rectangle height … taken at the **left endpoint**" | riemannaa.jl:33 h=f(xl). Frame n=3 heights are 1.000, 0.909, 0.93 = f(0), f(2/3), f(4/3) | confirmed |
| 11 | 28 | "the approximation settles toward the true integral" | Increases monotonically from n=4 (1.797590) to n=120 (2.014795), with I = 2.016280 | confirmed |
| 12 | 30, 32 | link riemannaa.jl / embed riemannaa.gif; alt "each frame increases partition density and updates the left-endpoint area estimate" | manifest wiring; frames (frame 1 is the curve only, n=0) | confirmed |
| 13 | 34, 36 | Case 2: "height is taken at the **right endpoint**" | riemannbb.jl:33 h=f(xr); frames | confirmed |
| 14 | 36 | "Comparing with Case 1 shows how endpoint choice shifts the approximation at finite $n$" | R−L = (f(2)−f(0))Δx = 0.035850/n (n=1: 0.036, n=120: 0.0003). The rectangles differ visibly, but the totals differ little | confirmed (the shift in the total is small for this f, because f(0) ≈ f(2)) |
| 15 | 38, 40 | link riemannbb.jl / embed riemannbb.gif; alt "right-endpoint area estimate" | manifest; frames | confirmed |
| 16 | 42 | Case 3 is a "Lower Riemann Sum" | Script computes the endpoint-min sum, which differs from the lower sum in every frame | wrong (→ F1) |
| 17 | 44 | "Each rectangle uses the **minimum endpoint value** on each subinterval" | riemanncc.jl:36 | confirmed (accurately describes the code, but see F1) |
| 18 | 44 | "For nonnegative $f$, this gives a lower bound" | n=2 value 2.017925 > I = 2.016280 | wrong (→ F2) |
| 19 | 44 | "rises toward the integral as density increases" | Sequence 2.000, 2.018, 1.832, 1.231, … with a dip at n=8 | wrong (→ F3) |
| 20 | 46, 48 | link riemanncc.jl / embed riemanncc.gif; alt "using interval endpoint minima" | manifest; code | confirmed |
| 21 | 50 | Case 4 is an "Upper Riemann Sum" | Script computes the endpoint-max sum | wrong (→ F1) |
| 22 | 52 | "Each rectangle uses the **maximum endpoint value**" | riemanndd.jl:36 | confirmed |
| 23 | 52 | "giving an upper bound" | n=3 value 1.965664 < I | wrong (→ F2) |
| 24 | 52 | "Lower and upper sums squeeze the exact value as $n \to \infty$" | Holds in the limit (n=120: 1.978952 ≤ 2.016280 ≤ 2.050937), but not monotonically over the frames | confirmed for the limit; frame-by-frame reading is misleading (→ F3) |
| 25 | 54, 56 | link riemanndd.jl / embed riemanndd.gif; alt "using interval endpoint maxima" | manifest; code | confirmed |
| 26 | frames | "Approximation = …" values in GIFs aa and bb | Match the independent mpmath L and R sums to all 6 decimals for all 24 n | confirmed |
| 27 | frames | "Approximation = …" in cc/dd titled Lower/Upper | Match the independent endpoint-min/max sums, but not the true lower/upper sums | wrong (→ F1) |
| 28 | frames | "Sample Points = n" | Correct for aa/bb. For cc/dd it counts subintervals | wrong, minor (→ F4) |

## Implementation checks

### riemannaa.jl
- **Method:** Left Riemann sum, h = f(x_{i-1}) on [x_{i-1}, x_i], uniform partition. This is the method named.
- **Numbers:** Script values compared with independent mpmath values:

  | n | script | independent (mpmath) |
  |---|---|---|
  | 1 | 2.000000 | 2.0 |
  | 3 | 1.893096 | 1.8930959 |
  | 10 | 1.935972 | 1.9359721 |
  | 120 | 2.014795 | 2.0147951 |

  All 24 values agree to the 6 displayed decimals. The drawn rectangle area equals the annotation to within 1e-15.
- **Reference values:** None are drawn. The independent I = 2.0162797196 (two quadrature methods agree to 20 digits) was used to confirm convergence. The error ratio per halving of h is 3.07, 3.06, 3.02, 2.96, 2.87 for n = 10→1280, consistent with h^{5/3} from the x^{2/3} cusp plus a small h term. The page states no rate.
- **Picture:** I checked the contact sheet and frames 1 (curve only), 4 (n=3) and 25 (n=120). Bar heights at the left endpoints match f; the curve is the stated f; the title is correct. The y-limits [0, 2.1] contain f's maximum of 1.92. The annotations at y = 1.88/1.74, x ≈ 1.15 sit above the curve in that region (curve at most 1.38), so nothing is obscured.

### riemannbb.jl
- **Method:** Right Riemann sum, h = f(x_i). Correct.
- **Numbers:** Script values compared with independent mpmath values:

  | n | script | independent (mpmath) |
  |---|---|---|
  | 1 | 2.035850 | 2.0358496 |
  | 3 | 1.905046 | 1.9050458 |
  | 10 | 1.939557 | 1.9395571 |
  | 120 | 2.015094 | 2.0150938 |

  All 24 agree to 6 decimals. The drawn area equals the annotation.
- **Reference values:** As for riemannaa.jl. R − L = (f(2) − f(0))Δx was verified at every n.
- **Picture:** I checked the contact sheet and frames 1, 4 and 25. The n=3 bars are f(2/3) = 0.909, f(4/3) = 0.93, f(2) = 1.018, matching the right endpoints. Title correct.

### riemanncc.jl
- **Method:** Not a lower sum. It computes Σ min(f(x_{i-1}), f(x_i))Δx, an endpoint-minimum sum (F1).
- **Numbers:** The script's endpoint-min values match the independent endpoint-min computation at every n; for example n=2 gives 2.017925 from both and n=120 gives 1.978952 against 1.9789517. The true lower sums differ:

  | n | true lower |
  |---|---|
  | 1 | 0.714407 |
  | 2 | 1.152792 |
  | 3 | 1.374576 |
  | 120 | 1.978951 |

  The script's values fail to be a lower bound at n=2.
- **Reference values:** None are drawn. I = 2.0162797196.
- **Picture:** I checked the contact sheet and frames 3 (n=2) and 4 (n=3). The bars are drawn from exactly the quantity the script sums, but that quantity is not the infimum. Bars visibly exceed the curve over the trough at 0.43 and the dip at 1.56 in early frames. The maximum height gap is 0.64 (n=1, 2), still 0.058 at n=16 and 0.005 at n=40.

### riemanndd.jl
- **Method:** Not an upper sum. It computes Σ max(f(x_{i-1}), f(x_i))Δx, an endpoint-maximum sum (F1).
- **Numbers:** The script's values match the independent endpoint-max computation; for example n=3 gives 1.965664 from both and n=120 gives 2.050937 against 2.0509372. The true upper sums differ:

  | n | true upper |
  |---|---|
  | 1 | 3.839512 |
  | 2 | 3.283721 |
  | 3 | 2.881461 |
  | 10 | 2.365760 |
  | 120 | 2.050951 |

  The script's values fail to be an upper bound at n=3.
- **Reference values:** None are drawn. I = 2.0162797196.
- **Picture:** I checked the contact sheet and frames 4 (n=3) and the n=16 frame. Bars are drawn from the endpoint max, and the peaks at 0.08 (1.92) and 0.94 (1.38) poke well above the "upper" bars in early frames. The maximum gap is 0.92 for n = 3–8 and 0.12 at n=16; the area error is 0.12 at n=10.

## Evidence

The reviewer's and checker's computation scripts are copied to [`evidence/riemann-sums/`](evidence/riemann-sums/) (`reviewer/` and `verify/`). They were run from a scratch directory; paths inside them point at that scratch area and will need adjusting to re-run.
