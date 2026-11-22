# Legendre Polynomials — animation review (round 2)

Page: `pages/numerical-methods/legendre-polynomials/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1. Fidelity, Minor: Case 2 uses cos(pi x/2) instead of either of Mathews' Legendre-series functions, with no reason given

- **Location:** `index.qmd` line 24 heading "### Case 2 — Legendre series for $f(x) = \cos(\pi x/2)$"; `legendrepolybb.jl` line 43 `f(x) = cos(π * x / 2)`.
- **What is there now:** The Legendre-series animation approximates f(x) = cos(pi x/2) on [-1, 1].
- **What the archive has:** Mathews' only Legendre-series example on [-1,1] is Example 8, "Compare the discrete interpolation polynomial and Legendre series approximation on the interval [-1, 1]", with 8(a) f(x) = e^x and 8(b) f(x) = e^x cos(pi x/2) (images `LegendrePolyMod_gr_323.gif` = "[-1, 1]", `gr_324.gif` = "f[x] = e^x", `gr_325.gif` = "f[x] = e^x Cos[pi/2 x]", referenced from `_lnk_16.html` and `_lnk_17.html`). cos(pi x/2) alone appears in none of the module's examples (I rendered the function images of Examples 1, 2, 3, 4, 8 and 9: e^x, e^x cos(pi x/2), ArcTan[x] on [0,1] / [0,3]).
- **Why it matters to a reader:** Dropping the e^x factor makes f even, so every odd Legendre coefficient is zero and four of the nine frames (S_1, S_3, S_5, S_7) repeat the previous curve. The page states this honestly, so nothing it says is false, but the reader loses Mathews' case in which every term contributes, and the departure is not explained.
- **Evidence:** archive images above (rendered to `review/legacy/big323.png`, `big324.png`, `big325.png`, `examples.png`). Script's computed coefficients (instrumented `bb_instr.jl`): c_1, c_3, c_5, c_7 = -5.0e-17, -3.1e-16, -1.7e-15, 6.8e-15 (exactly 0 analytically by sympy).
- **Suggested correction:** Either switch Case 2 to Mathews' 8(b) f(x) = e^x cos(pi x/2) (or 8(a) e^x), regenerate, and recompute the quoted max errors; or keep cos(pi x/2) and add one sentence saying it was chosen (rather than Mathews' e^x cos(pi x/2)) to show the even-function / zero odd-coefficient effect.

No other findings.

Observations checked and judged **not** findings:
- In `legendrepolyaa.gif` the top-right legend sits over the region where all curves rise to (1, 1). I cropped and enlarged frame 6 (`review/aa_f6_crop.png`): the common point (1,1) and the final approach of all six curves remain visible to the right of the legend, so the P_n(1)=1 property is still readable.
- The GIF title "Legendre Polynomials P₀ … P_5" mixes a Unicode subscript with an underscore. Cosmetic only.
- Odd coefficients come out at about 1e-15, not exactly 0, so S_1 and S_0 differ at round-off level. This is invisible and the page's "equal" is correct mathematically.

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `legendrepolyaa.jl` | 0 | 5.1 | legendrepolyaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `legendrepolybb.jl` | 0 | 6.5 | legendrepolybb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `legendrepolyaa.gif` | 6 | byte-identical | legendrepolyaa |
| `legendrepolybb.gif` | 9 | byte-identical | legendrepolybb |

### Page references

- Scripts linked: `legendrepolyaa.jl`, `legendrepolybb.jl`
- GIFs embedded: 2
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Page text (own words) | Check | Verdict |
|---|---|---|---|
| L1 | "Each animation below illustrates Legendre polynomials $P_n(x)$ on $[-1,1]$." | Both scripts use `x = range(-1.0, 1.0, length=500)`, xlims (-1,1); frames show [-1,1] | confirmed |
| L2 | "The first animation reveals $P_0$ through $P_5$ one per frame" | aa: `for n in 0:5`, cumulative plot k=0..n; 6 frames in committed GIF; frame titles P_0 … P_5; contact sheet shows one new curve per frame | confirmed |
| L3 | "the second shows the Legendre series partial sums converging to $f(x)=\cos(\pi x/2)$" | bb: S_0..S_8 of cos(pi x/2); max error falls 0.637 → 1.32e-7 | confirmed |
| L4 | "Julia source scripts ... are linked under each case." | Case 1 links `legendrepolyaa.jl`, Case 2 links `legendrepolybb.jl` | confirmed |
| L5 | Case 1 heading "Successive polynomials $P_0, P_1, \ldots, P_5$" | n_max = 5, 6 frames | confirmed |
| L6 | "Each $P_n$ is orthogonal to all lower-degree Legendre polynomials on $[-1,1]$." | sympy Gram matrix of Rodrigues P_0..P_5 = diag(2, 2/3, 2/5, 2/7, 2/9, 2/11), all off-diagonals 0 | confirmed |
| L7 | "$P_n(1)=1$" | Script recurrence at x=1 gives 1.0 for n=0..5; sympy confirms; frames show all curves through (1,1) | confirmed |
| L8 | "$P_n(-1)=(-1)^n$" | Script gives 1, -1, 1, -1, 1, -1; sympy confirms | confirmed |
| L9 | "$P_n$ has exactly $n$ zeros in $(-1,1)$" | sympy real roots: n=1 {0}; n=2 ±0.57735; n=3 0, ±0.77460; n=4 ±0.33998, ±0.86114; n=5 0, ±0.53847, ±0.90618. Script grid sign changes = n for n=0..5 | confirmed |
| L10 | "They are computed by the recurrence $(n+1)P_{n+1} = (2n+1)xP_n - nP_{n-1}$." | Script line 20 `P = ((2k-1) x P_{k-1} - (k-1) P_{k-2}) / k` is the same with k=n+1; sympy verifies the identity for n=1..4 against Rodrigues; script values at 5 test points match scipy `eval_legendre` to ≤1e-16 | confirmed |
| L11 | Alt text 1: "P_0 through P_5 added one per frame on the interval [-1, 1], showing their oscillatory character" | Frames match | confirmed |
| L12 | Case 2 heading "Legendre series for $f(x)=\cos(\pi x/2)$" | bb line 43; GIF title and legend show cos(πx/2) | confirmed |
| L13 | "$S_N(x)=\sum_{n=0}^{N} c_n P_n(x)$" | bb lines 53-56 sum k=0..n of coeffs[k+1]·P_k | confirmed |
| L14 | "$c_n = \tfrac{2n+1}{2}\int_{-1}^{1} f(x)P_n(x)\,dx$" | Correct normalisation (‖P_n‖² = 2/(2n+1), L6); bb line 40 implements it with 20-pt Gauss-Legendre; script c_n agree with exact sympy values to ≤8e-15 (table in §3) | confirmed |
| L15 | "converges to $f$ as $N\to\infty$" | f is entire; computed sup errors decrease geometrically to 1.3e-7 at N=8 | confirmed |
| L16 | "Only even-$n$ terms contribute (since $f$ is even): the odd-order coefficients are zero" | sympy c_1=c_3=c_5=c_7=0 exactly; script values ≤7e-15 | confirmed |
| L17 | "$S_1, S_3, S_5, S_7$ equal $S_0, S_2, S_4, S_6$ and every second frame shows the same curve and max error as the frame before it" | Script errors: 0.63662/0.63662, 0.050465/0.050465, 0.0013135/0.0013135, 1.70005e-5/1.70005e-5; frame titles show identical 3-s.f. values; contact sheet curves identical | confirmed |
| L18 | "Each even-order term reduces the max error" | 0.637 → 0.0505 → 0.00131 → 1.70e-5 → 1.32e-7 (strictly decreasing) | confirmed |
| L19 | "from 0.637 for $S_0$" | Exact sup error at N=0 is 2/π = 0.636620 (at x=±1); script 0.6366197723675799 | confirmed |
| L20 | "to $1.32\times10^{-7}$ for $S_8$" | Independent: 1.31692e-7 on a 20001-point grid and on the script's 500-point grid; script 1.3169151774938115e-7 | confirmed |
| L21 | Alt text 2: "partial sums S_0 through S_8 for cos(pi x/2), one per frame; the odd-order terms are zero, so every second frame repeats the previous curve, and the max error falls from 0.637 to 1.32e-7" | 9 frames S_0..S_8; rest as L17-L20 | confirmed |
| L22 | Wiring: Case 1 embed `legendrepolyaa.gif`, Case 2 embed `legendrepolybb.gif` | Each GIF is produced by the linked script (manifest: regenerated byte-identical); content matches heading | confirmed |
| L23 | Frame titles in bb: "max err = 0.637, 0.637, 0.0505, 0.0505, 0.00131, 0.00131, 1.7e-5, 1.7e-5, 1.32e-7" | Match independent values rounded to 3 s.f. | confirmed |

The page has no separate Description section; the method statements are in the Case 1 "Properties" and Case 2 "Behavior" paragraphs and are covered above (L6-L10, L13-L14).

---

### 3. Implementation checks

### `legendrepolyaa.jl`

- **Method claimed vs run:** Three-term (Bonnet) recurrence starting from P_0=1, P_1=x. That is what the code runs (lines 10-25). Correct.
- **Numbers:** Instrumented copy `review/aa_instr.jl` printed P_n at x = (-0.9, -0.3, 0, 0.25, 0.7). Compared with scipy `eval_legendre` (`review/indep.py`):

  | n | script | scipy |
  |---|---|---|
  | 2 | 0.715, -0.365, -0.5, -0.40625, 0.235 | 0.715, -0.365, -0.5, -0.40625, 0.235 |
  | 3 | -0.4725, 0.3825, 0, -0.3359375, -0.1925 | same |
  | 4 | 0.2079375, 0.0729375, 0.375, 0.15771484375, -0.4120625 | same |
  | 5 | 0.04114125, -0.34538625, 0, 0.3397216796875, -0.36519875 | same |

  Differences are at the 1e-16 level. Endpoint values, zero counts and orthogonality: see L6-L9.
- **Reference values:** none drawn.
- **Picture:** Six frames, frame n draws P_0..P_n in fixed colours with matching legend labels; title index matches n. ylims (-1.3, 1.3) contain every curve (min of P_2 is -0.5, of P_4 -0.4286, of P_3/P_5 -1 at x=-1). The shapes in the frames match the values: P_2 minimum -0.5 at 0; P_4 = 0.375 at 0; P_3 and P_5 extrema at about ±0.45 and ±0.77 / ±0.29. No clamping or masking.

### `legendrepolybb.jl`

- **Method claimed vs run:** Legendre series (L2 orthogonal projection onto P_0..P_N) with c_n = (2n+1)/2 ∫ f P_n, the integral done by 20-point Gauss-Legendre from Golub-Welsch (Jacobi matrix off-diagonal k/√(4k²-1), weights 2·v₁²). Correct.
- **Quadrature check (property-based):** the 20-point rule gives sum w = 2.0000000000000; ∫x^38 = 0.05128205128205075 vs exact 2/39 = 0.05128205128205128 (exact to round-off; degree 38 ≤ 39); ∫x^40 = 0.04878048780205485 vs 2/41 = 0.04878048780487805 (error 2.8e-12). So it is exact through degree 39 = 2m-1 and fails beyond, as a 20-point Gauss rule should.
- **Numbers:** coefficients, script vs exact (sympy closed form, evaluated at 30 digits):

  | n | script | exact |
  |---|---|---|
  | 0 | 0.63661977236758 | 2/π = 0.636619772367581 |
  | 1 | -5.0e-17 | 0 |
  | 2 | -0.6870852701460279 | 10/π − 120/π³ = -0.687085270146032 |
  | 3 | -3.1e-16 | 0 |
  | 4 | 0.05177895367626449 | 0.0517789536762638 |
  | 5 | -1.7e-15 | 0 |
  | 6 | -0.0013304563858528892 | -0.00133045638584257 |
  | 7 | 6.8e-15 | 0 |
  | 8 | 1.7132179549237916e-5 | 1.71321795415561e-5 |

  Max errors, script (500-pt grid) vs independent (exact c_n, scipy P_n, 20001-pt grid): N=0 0.636620 / 0.63662; N=2 0.0504655 / 0.0504655; N=4 0.00131346 / 0.00131346; N=6 1.70005e-5 / 1.70005e-5; N=8 1.31692e-7 / 1.31692e-7. Odd N equal the preceding even N in both. The maximum is at x = ±1 in every case, and those points are on the script's grid, so the 500-point grid does not under-report the sup error.
- **Reference values:** f(x) = cos(πx/2) evaluated directly. Correct.
- **Picture:** Nine frames; blue solid f, red dashed S_n; title index and legend index equal the frame's n; the max error in the title is the computed value at 3 s.f. (all match, L23). In S_0 and S_1 the dashed line is flat at 0.637 (= c_0); in S_2 and S_3 the visible gap at x=±1 is about 0.05, consistent with the computed error; from S_4 on the curves coincide visually, as expected for errors ≤1.3e-3. ylims (-1.3, 1.3) contain everything; no clamping.
- **Header comment** (lines 2-3) matches the behaviour.

### Commands run
- `julia review/aa_instr.jl`, `julia review/bb_instr.jl` (instrumented copies, writing only into `review/`).
- `/usr/bin/python3 -I review/indep.py` (Rodrigues-formula polynomials, recurrence identity, Gram matrix, roots, exact c_n by symbolic integration, sup errors on dense and 500-point grids).
- Archive: text extraction of `LegendrePolyMod.html`, `_lnk_16.html`, `_lnk_17.html`; formula images rendered with ffmpeg into `review/legacy/`.

