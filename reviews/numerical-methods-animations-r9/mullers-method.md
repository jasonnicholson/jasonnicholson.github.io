# Muller's Method — animation review (round 9)

Page: `pages/numerical-methods/mullers-method/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I found nothing false, misleading or minor-but-real on this page. Every numerical claim in the page text matched my independent computation at the precision it is stated to. Every behavioural claim matched the computed sequences, and every frame I inspected draws what the code computes. The evidence follows.

Observations that are not findings:
- Case 1 deliberately departs from Mathews' algorithm. It plots the real part of the complex Muller root, which is the parabola's vertex. Mathews instead drops the square root and keeps the nearest two points. The page states this departure, explains why, and reports Mathews' own iterates correctly (verified below), so it is not a silent fidelity departure.
- In `mullersbb.gif` frame 1, the lower-left corner of the inset covers about 0.02 in x of the f curve near x = 1.04 to 1.06 (f(1.04) = 0.73, and the inset's bottom edge is at y ≈ 0.69). It hides nothing the page discusses.
- The first complex Muller iterate in Case 1 is one of a conjugate pair with equal |denominator|. The page's "+0.3563i" is the one produced by the usual tie-break (|b+D| ≥ |b−D| picks b + i·s, and f(p2) > 0 gives a positive imaginary part). This is fine.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `mullersaa.jl` | 0 | 10.9 | mullersaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `mullersbb.jl` | 0 | 10.5 | mullersbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `mullerscc.jl` | 0 | 11.0 | mullerscc.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `mullersaa.gif` | 8 | byte-identical | mullersaa |
| `mullersbb.gif` | 9 | byte-identical | mullersbb |
| `mullerscc.gif` | 9 | byte-identical | mullerscc |

### Page references

- Scripts linked: `mullersaa.jl`, `mullersbb.jl`, `mullerscc.jl`
- GIFs embedded: 3
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | Intro | "parabola (dashed blue) passes through the current triple (p0,p1,p2)" | `lagrange_parabola` through (q0,q1,q2), `ls=:dash`, `:steelblue`; frames | confirmed |
| 2 | Intro | "next iterate is found where the parabola crosses the x-axis (in Case 1 the parabola never reaches the axis…)" | bb/cc: q3 is the nearest-root formula and P(q3) ≈ 1e-16..1e-22 (instrumented); aa: disc < 0 in all 8 frames | confirmed |
| 3 | Intro | "Each frame advances one iteration: the oldest point is dropped, and the new root estimate becomes p2 (red dot). The gray dots are p0 and p1." | `history[i+1] = (q1,q2,q3)`; gray scatter for q0,q1, red for q2; frames | confirmed |
| 4 | Intro | "Julia source scripts … are linked under each case" | 3 links, one per case | confirmed |
| 5 | Case 1 heading | Convergent, f = x³−3x+2, double root at p = 1 | sympy factor → (x−1)²(x+2); script line 21 | confirmed |
| 6 | Case 1 | "starting from p2 = 2.0" | `p_init = [2.2, 2.1, 2.0]` | confirmed |
| 7 | Case 1 | "None of the parabolas reaches the x-axis: at every step its roots are complex" | disc for frames 1–8: −20.16, −3.909, −0.5667, −0.03021, −1.007e−3, −1.097e−5, −2.157e−8, −6.52e−12 (script, float64); mpmath 60-digit gives the same signs and values | confirmed |
| 8 | Case 1 | "the first would be p3 ≈ 1.2873 + 0.3563i" | mpmath polyroots of the fitted quadratic: 1.287301587 + 0.3563447873i | confirmed |
| 9 | Case 1 | real part of the complex root "is the parabola's vertex (open red circle)" | Algebra: Re[p2 − 2f2/(b+is)] = p2 − 2f2 b/(4 f2 d) = p2 − b/(2d). Numerically, the mpmath root real part equals the vertex x in every step. Open red-circle marker at (q3, h) | confirmed |
| 10 | Case 1 | "Each frame is zoomed to the current points" | xlims built from min/max of (q0,q1,q2,q3); frames | confirmed |
| 11 | Case 1 | vertex "height above the axis falls from 0.80 to 5.4×10⁻¹³ over the eight frames" | script h: 0.79998 … 5.4319e−13 (8 frames); mpmath: 0.79998 … 5.4343e−13; frame titles "8.00e-01" … "5.43e-13"; manifest says 8 frames | confirmed |
| 12 | Case 1 | "iterates 1.2873, 1.1581, 1.0552, 1.0100, 1.0017, … decrease to p = 1" | mpmath: 1.28730159, 1.15808780, 1.05520419, 1.00999920, 1.00168459, 1.00010790, 1.00000301, 1.0000000312; all > 1 and strictly decreasing (also through 10 iterations) | confirmed |
| 13 | Case 1 | "superlinearly (order ≈ 1.32 asymptotically for this real-part variant)" | 3000-digit run of the vertex iteration, 25 steps: local orders settle at 1.3245–1.3249 (plastic number 1.3247) | confirmed |
| 14 | Case 1 | "faster than Newton's method, which converges only linearly at a double root" | Newton from 2.0 on this f: error ratios 0.536, 0.522, …, 0.501 → 1/2 (linear) | confirmed |
| 15 | Case 1 | Mathews "drops the square root, so the step is p3 = p2 − 2f(p2)/b, where b is the parabola's slope at p2" | Archive program (gr_5): `If[b b > 4 a c, disc = Sqrt[...], disc = 0]; Z = -2c/(b+disc)`, with b the linear coefficient in powers of (x − p2) | confirmed |
| 16 | Case 1 | Mathews "keeps the two points nearest the new iterate rather than the two most recent" | Archive program: two conditional swaps, then p2 := p3, which discards the point farthest from p3 (case analysis) | confirmed |
| 17 | Case 1 | Mathews' "iterates 1.1091, 1.4944, 1.0558, 0.9965, … rise to 1.4944, drop below 1, and then approach 1 from both sides" | Archive table (gr_39..50): 1.1091314, 1.4944130, 1.0557604, 0.9964676, 0.9981213, 1.0000166, 0.9999988, 1.0000000057. My float64 transcription of his program (`review/mathews.py`) reproduces all 8 to 10 digits | confirmed |
| 18 | Case 1 alt | "parabolas never reach the x-axis, so each new iterate is the parabola's vertex …; iterates converge to the double root at p = 1; … inset shows the vertex just above the x-axis" | as 7, 9, 12; frames 1–8 inset shows vertex above axis line | confirmed |
| 19 | Case 1 wiring | link `mullersaa.jl`, embed `mullersaa.gif` | script f and p_init match heading; GIF byte-identical to scratch regeneration (`cmp`) | confirmed |
| 20 | Case 2 heading | Convergent, f = sin(x²−2)(x²−2), double root at p = √2 | sympy: f(√2) = 0, f′(√2) = 0, f″(√2) = 16 ≠ 0 → multiplicity exactly 2 | confirmed |
| 21 | Case 2 | "p = √2 ≈ 1.4142", "starting from p2 = 1.0" | `p_init = [0.8, 0.9, 1.0]` | confirmed |
| 22 | Case 2 | "double root where x²−2 = 0 since both factors vanish simultaneously" | both factors have simple zeros at √2 | confirmed |
| 23 | Case 2 | "locates it efficiently despite the flat tangent at the root" | f′(√2) = 0; convergence superlinear, local order → 1.23375 (3000-digit run) | confirmed |
| 24 | Case 2 | "Each frame is zoomed to the current points" | xlims code; frames | confirmed |
| 25 | Case 2 | "inset shows the step from p2 to the parabola's axis crossing (open red circle), which is the next iterate" | inset spans q2 − 0.15s … q3 + 0.8s, filled red at (q2, f(q2)), open red at (q3, 0); frames 1, 5, 9 | confirmed |
| 26 | Case 2 | "step shrinks from 0.25 to 3.6×10⁻⁵ over the nine frames" | script s: 0.254316 … 3.57993e−5 (9 frames); mpmath: 0.25432 … 3.5799e−5; titles "2.54e-01" … "3.58e-05" | confirmed |
| 27 | Case 2 alt | "converging to the double root at p = sqrt(2) starting from p₂ = 1.0; … inset shows the step …" | as 21, 25, 26 | confirmed |
| 28 | Case 2 wiring | `mullersbb.jl` / `mullersbb.gif` | f and starts match; GIF byte-identical to regeneration | confirmed |
| 29 | Case 3 heading | Convergent, f = x⁶−7x⁴+15x²−9, double root at p = √3 | sympy factor → (x−1)(x+1)(x²−3)² | confirmed |
| 30 | Case 3 | "factors as (x²−1)(x²−3)²", "√3 ≈ 1.7321", "Starting from p2 = 1.5" | sympy; `p_init = [1.3, 1.4, 1.5]` | confirmed |
| 31 | Case 3 | "Newton's method would converge linearly here" | Newton from 1.5: error ratios 0.465, 0.485, …, 0.4996 → 1/2 | confirmed |
| 32 | Case 3 | "superlinearly, with order ≈ 1.23 at this double root" | 3000-digit run: local orders 1.23375 (matches real root of 2t³−t²−t−1 = 1.233752) | confirmed |
| 33 | Case 3 | "below the ≈ 1.84 it achieves at a simple root" | real root of t³−t²−t−1 = 1.839287 (Muller's simple-root order) | confirmed |
| 34 | Case 3 | zoom and inset description (same as Case 2) | code identical to bb except inset bbox; frames 1, 5, 9 | confirmed |
| 35 | Case 3 | "step shrinks from 0.13 to 5.5×10⁻⁵ over the nine frames" | script s: 0.127647 … 5.52041e−5 (9 frames); mpmath: 0.12765 … 5.5204e−5; titles "1.28e-01" … "5.52e-05" | confirmed |
| 36 | Case 3 alt | "converging to the double root at p = sqrt(3) starting from p₂ = 1.5 …" | as above | confirmed |
| 37 | Case 3 wiring | `mullerscc.jl` / `mullerscc.gif` | f and starts match; GIF byte-identical to regeneration | confirmed |
| 38 | Fidelity, Ex. 1 | function and starts p0, p1, p2 = 2.2, 2.1, 2.0 | archive gr_7, gr_36..38 and `Muller[2.2, 2.1, 2.0, 10]` | confirmed (algorithm departure disclosed, see ledger 15–17) |
| 39 | Fidelity, Ex. 2 | function and starts 0.8, 0.9, 1.0 | archive gr_75, `Muller[0.8, 0.9, 1.0, 10]`; archive iterates p3..p10 = 1.2543159902744360 … 1.4141744432077470 equal the script's q3 values frame by frame to 16 digits | confirmed |
| 40 | Fidelity, Ex. 3 | function and p2 = 1.5 | archive gr_143 (f), gr_144 (p0 = 1.5) | confirmed for f and 1.5. The Muller starts 1.3, 1.4 **could not be determined**, because the archive solution images for Ex. 3 are missing. Mathews' "near x = 2" is not repeated on the page; the root really is √3, as the script header notes |

### 3. Implementation checks

All three scripts use the same `muller_step`: the divided-difference form P(x) = f2 + b(x−p2) + d(x−p2)², disc = b² − 4 f2 d, and the next iterate p2 − 2f2/E with E the larger-modulus of b ± √disc. This is the standard (most-recent-three) Muller's method. `mullersaa.jl` replaces the complex root by its real part p2 − b/(2d) when disc < 0, and the page names this variant explicitly. `mullersbb.jl` and `mullerscc.jl` raise an error on disc < 0, and they ran without one.

Independent computation (`review/indep.py`). For each step it fits the quadratic by solving the 3×3 Vandermonde system at 60 digits, finds its roots with `mpmath.polyroots`, and picks the one nearest p2, taking the real part for Case 1. So it does not reuse the script's divided-difference formulas. Instrumented script copies are in `review/inst/`, with logs `aa.log`, `bb.log` and `cc.log`.

### mullersaa.jl
- **Method:** real-part (vertex) variant of Muller, as named on the page. disc < 0 in all 8 frames (ledger 7).
- **Numbers (script vs independent):** q3 by frame: 1.2873015873016 / 1.28730158730159; 1.158087802003537 / 1.15808780200354; 1.0552041927906899 / 1.05520419279069; 1.0099991953537275 / 1.00999919535373; 1.0016845914908628 / 1.00168459149086; 1.000107900677376 / 1.00010790067738; 1.0000030057271563 / 1.00000300572712; 1.0000000311735213 / 1.00000003117406. Vertex heights 0.7999841 / 0.79998, … 5.4320e−13 / 5.4343e−13 (the last differs in the 3rd digit only through rounding of f ≈ 1e−11 values in float64; displayed "5.43e-13" either way).
- **Reference values:** the root p = 1 is exact (sympy factor).
- **Picture:** vertex marker plotted at (q3, P(q3)); the leading coefficient `a = (P(q3+1)+P(q3−1))/2 − h` equals the true quadratic coefficient (5.387… for frame 2 is d at that step); the inset window ±1.4√(2h/a) is centred on the vertex, and ylims (−0.8h, 3h) keep the vertex and axis visible in all 8 frames (checked frames 1–8 on the contact sheet, and frames 1 and 8 at full size). The legend "p₂ = %.10g" shows q2 correctly. The script header claims (0.8 → 5e−13, a 9th frame would have h ≈ 1e−17) agree with mpmath (1.0101e−17).

### mullersbb.jl
- **Method:** standard Muller, disc > 0 at all 8 steps (14.39 … 3.13e−9).
- **Numbers:** q3 by frame, script / independent: 1.2543159902744359 / 1.25431599027444; 1.3222993665586782 / 1.32229936655868; 1.3688966241528713 / 1.36889662415287; 1.3970591565574766 / 1.39705915655748; 1.408412963976924 / 1.40841296397692; 1.4126956654374672 / 1.41269566543747; 1.4139236819552305 / 1.41392368195523; 1.4141744432077474 / 1.41417444320775; 1.4142102425258867 / 1.41421024252589. P(q3) ≤ 7e−17 in all frames (axis crossing correct). The sequence also equals Mathews' printed table to 16 digits.
- **Reference:** √2 is a double root (f′ = 0, f″ = 16).
- **Picture:** open circle at (q3, 0), red p2 at (q2, f(q2)), inset limits from s = q3 − q2. Titles match s. Frames 1, 5 and 9 inspected. Header comments ("within 0.1 from frame 5 on": frame 5 q0 error 0.092 vs frame 4 0.160; "from frame 7 on, under 7% of width": 6.3%, 3.8%, 2.0% vs frame 6 8.4%) check out.

### mullerscc.jl
- **Method:** standard Muller, disc > 0 at all steps (45.12 … 1.65e−7).
- **Numbers:** q3 by frame, script / independent: 1.627646913608958 / 1.62764691360896; 1.6742682889831824 / 1.67426828898318; 1.7034875047036455 / 1.70348750470364; 1.7200472229337476 / 1.72004722293374; 1.72750110119843 / 1.72750110119845; 1.7306305638858632 / 1.73063056388569; 1.7317042934610234 / 1.73170429346136; 1.7319877986383865 / 1.73198779863755; 1.732043002751156 / 1.73204300272956 (last digits differ by float64 rounding of f near a double root, ≤ 2e−13). P(q3) ≤ 5e−16. Mathews' nearest-two-points rule gives the identical sequence here (`review/mathews.py`).
- **Reference:** √3 is a double root (sympy factor).
- **Picture:** same construction as bb; inset placed at bbox(0.60, 0.12, 0.36, 0.28) and does not cover the curve in any of the 9 frames (contact sheet). Frames 1 and 9 inspected at full size.

### Regeneration
Scratch copies of all three scripts are byte-identical to the committed scripts. Their GIFs are byte-identical to the committed GIFs (`cmp`, my own check, agreeing with the manifest). Frame counts are 8, 9 and 9, matching "eight frames" and "nine frames" on the page. The page is linked from the section index (`pages/numerical-methods/index.qmd` line 18).

