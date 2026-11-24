# Muller's Method — animation review (round 8)

Page: `pages/numerical-methods/mullers-method/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.**

I found no Error, Misleading or Minor finding. Every numerical and behavioural claim on the page agrees with my independent computation at the precision stated. All three scripts implement the method they claim; Case 1 uses a real-part variant, and the page names and explains it. The frames draw what was computed.

Not counted as findings:
- The page has no `## Description` section, which the authoring conventions in `animation-page.agent.md` require. The review standard treats this as content the page does not yet have. As a result there are no Description formulas to check against the scripts.
- Case 1 departs from Mathews' algorithm. Mathews drops the square root when the discriminant is negative, while the page takes the real part. The page states this departure, gives the reason, and quotes Mathews' iterates correctly (see the ledger). It is therefore not a Fidelity finding.

---



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `mullersaa.jl` | 0 | 11.0 | mullersaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `mullersbb.jl` | 0 | 10.7 | mullersbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `mullerscc.jl` | 0 | 10.1 | mullerscc.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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
| I1 | Intro | "fitting a parabola through three successive approximations"; "parabola (dashed blue) passes through the current triple (p0,p1,p2)" | Lagrange parabola through (q0,q1,q2), `ls=:dash`, `steelblue`, in all scripts; frames show it through the three dots | confirmed |
| I2 | Intro | "next iterate is found where the parabola crosses the x-axis (in Case 1 the parabola never reaches the axis; see that case)" | bb/cc: q3 is the quadratic root nearest p2, and matches the mpmath root to 13 or more digits. aa: disc < 0 in all 8 frames (from −20.16 to −6.5e−12) | confirmed |
| I3 | Intro | "Each frame advances one iteration: the oldest point is dropped, and the new root estimate becomes p2 (red dot). The gray dots are p0 and p1." | `history[i+1] = (q1, q2, q3)`; q2 is a red filled marker, q0 and q1 gray; frames agree | confirmed |
| 1a | Case 1 heading | f(x)=x³−3x+2, double root at p=1 | (x−1)²(x+2) expands to x³−3x+2; script `f` matches | confirmed |
| 1b | Case 1 | "starting from p2 = 2.0" | `p_init=[2.2,2.1,2.0]`; frame 1 legend shows "p₂ = 2" | confirmed |
| 1c | Case 1 | "None of the parabolas reaches the x-axis: at every step its roots are complex" | disc for frames 1–8: −20.16, −3.909, −0.5667, −0.03021, −1.007e−3, −1.097e−5, −2.157e−8, −6.52e−12; mpmath gives the same | confirmed |
| 1d | Case 1 | "the first would be p3 ≈ 1.2873 + 0.3563i" | mpmath: 1.2873016 + 0.35634479i (the conjugate is the other root, with equal modulus) | confirmed |
| 1e | Case 1 | "takes the real part of that complex root instead, which is the parabola's vertex" | Re[p2 − 2c/(b ± i√(−disc))] = p2 − b/(2a), which is the vertex. Script line 42 returns `p2 - b/(2d)` | confirmed |
| 1f | Case 1 | "(open red circle)" | `scatter!([q3],[h]; color=:white, markerstrokecolor=:red)` | confirmed |
| 1g | Case 1 | "Each frame is zoomed to the current points, and the inset shows the vertex" | xlims span min/max of q0..q3; inset centred on q3; frames agree | confirmed |
| 1h | Case 1 | "height above the axis falls from 0.80 to 5.4×10⁻¹³ over the eight frames" | script h: 7.9998e−1 … 5.4319e−13; mpmath on the exact Float64 triple of frame 8: 5.4343e−13; GIF has 8 frames; inset titles read 8.00e−01 … 5.43e−13 | confirmed |
| 1i | Case 1 | "iterates 1.2873, 1.1581, 1.0552, 1.0100, 1.0017, … decrease to p = 1" | script and mpmath: 1.28730159, 1.15808780, 1.05520419, 1.00999920, 1.00168459, 1.00010790, 1.00000301, 1.00000003, a monotone decrease | confirmed |
| 1j | Case 1 | "superlinearly (order ≈ 1.32 asymptotically for this real-part variant)" | mpmath long run, log-ratio order estimates: 1.3256, 1.3244, 1.3246, …, 1.3247 (the plastic number) | confirmed |
| 1k | Case 1 | "faster than Newton's method, which converges only linearly at a double root" | Newton at a double root is linear (ratio 1/2). Mathews' archive: Newton p8 error 5.1e−3, against about 3e−6 for these iterates | confirmed |
| 1l | Case 1 | Mathews "drops the square root, so the step is p3 = p2 − 2f(p2)/b, where b is the parabola's slope at p2" | `gr_5`: `If[bb>4ac, disc=√…, disc=0]`, `Z=-2c/(b+disc)`; b is the linear coefficient in (x − p2), which equals P′(p2) | confirmed |
| 1m | Case 1 | Mathews "keeps the two points nearest the new iterate rather than the two most recent" | Traced the two swap statements in `gr_5`: the kept pair is the nearer of (p0,p1) and the nearer of {farther(p0,p1), p2}, which are the two nearest to p3. `mathews.py` "mathews" and "nearest2" modes give identical iterates | confirmed |
| 1n | Case 1 | Mathews' iterates "1.1091, 1.4944, 1.0558, 0.9965, …, rise to 1.4944, drop below 1, and then approach 1 from both sides" | Archive output: 1.10913140, 1.49441305, 1.05576043, 0.99646762, 0.99812135, 1.00001663, 0.99999880, 1.00000001. `mathews.py` reproduces it exactly | confirmed |
| 1o | Case 1 link/embed/alt | `mullersaa.jl` / `mullersaa.gif`; alt text: "starting from p₂ = 2.0 … each new iterate is the parabola's vertex … converge to the double root at p = 1 … inset shows the vertex just above the x-axis" | file names match the case; content matches the frames | confirmed |
| 2a | Case 2 heading | f(x)=sin(x²−2)(x²−2), double root at p=√2 | sin(u)·u ≈ u² near u=0 and u = x²−2 has a simple zero at √2, so the root is double; script `f` matches | confirmed |
| 2b | Case 2 | "√2 ≈ 1.4142", "starting from p2 = 1.0" | `p_init=[0.8,0.9,1.0]` | confirmed |
| 2c | Case 2 | "both factors vanish simultaneously … despite the flat tangent at the root" | f′(√2)=0 because the root is double | confirmed |
| 2d | Case 2 | "The method converges to the double root" | iterates 1.25432 … 1.4141744, final q3 = 1.41421024 (error 3.3e−6); mpmath long run converges (order 1.2338) | confirmed |
| 2e | Case 2 | "inset shows the step from p2 to the parabola's axis crossing (open red circle), which is the next iterate" | inset spans q2 to q3, red dot at (q2, f(q2)), open circle at (q3, 0) | confirmed |
| 2f | Case 2 | "step shrinks from 0.25 to 3.6×10⁻⁵ over the nine frames" | s: 2.5432e−1 … 3.5799e−5; 9 frames; inset titles read 2.54e−01 and 3.58e−05 | confirmed |
| 2g | Case 2 link/embed/alt | `mullersbb.jl` / `mullersbb.gif`; alt text "starting from p₂ = 1.0" | matches | confirmed |
| 3a | Case 3 heading | f(x)=x⁶−7x⁴+15x²−9, double root at p=√3 | (x²−1)(x²−3)² expands to x⁶−7x⁴+15x²−9 | confirmed |
| 3b | Case 3 | "factors as (x²−1)(x²−3)²", "√3 ≈ 1.7321" | as in 3a | confirmed |
| 3c | Case 3 | "Starting from p2 = 1.5, Muller's method converges to the double root" | `p_init=[1.3,1.4,1.5]`; iterates 1.62765 … 1.7319878, final q3 = 1.73204300 (error 7.5e−6) | confirmed |
| 3d | Case 3 | "Newton's method would converge linearly here" | double root | confirmed |
| 3e | Case 3 | "order ≈ 1.23 at this double root (below the ≈ 1.84 it achieves at a simple root)" | mpmath long run: 1.2338 constant (also 1.2338 for Case 2). 1.839 is the standard simple-root order | confirmed |
| 3f | Case 3 | "step shrinks from 0.13 to 5.5×10⁻⁵ over the nine frames" | s: 1.2765e−1 … 5.5204e−5; 9 frames | confirmed |
| 3g | Case 3 link/embed/alt | `mullerscc.jl` / `mullerscc.gif`; alt text "starting from p₂ = 1.5" | matches | confirmed |
| F1 | Fidelity, Ex 1 | Same f, same p0,p1,p2 = 2.2, 2.1, 2.0 as Mathews | archive `ex1.png` | confirmed. The variant differs from Mathews, and the page discloses it (1l–1n) |
| F2 | Fidelity, Ex 2 | Same f and starting values as Mathews | archive `ex2.png`: Muller[0.8,0.9,1.0]; Mathews' p3…p10 = 1.2543159902744 … 1.4141744432077 equal the script's history to 13 digits | confirmed |
| F3 | Fidelity, Ex 3 | Same f as Mathews; starting values | f and Newton p0 = 1.5 match `gr_143`/`gr_144`. Mathews' Muller starting triple and output images are missing from the archive | f confirmed; starting triple could not be determined (archive images absent) |
| F4 | Fidelity, case count | Three archive examples become three cases | `MullersMethodMod.html` lists Examples 1–3 | confirmed |

---

### 3. Implementation checks

### `mullersaa.jl` (Case 1)
- **Method.** Standard Muller divided-difference coefficients: d = (δ1 − δ0)/(h1 + h0) is the quadratic coefficient, b = δ1 + h1·d is the slope at p2, and c = f2. With disc ≥ 0 it uses the larger-modulus denominator. With disc < 0 it returns p2 − b/(2d), the real part of the complex Muller root (derived algebraically above). This branch is taken in every frame. The variant is named in the code comments and on the page.
- **Numbers.**
  - Script iterates (Float64): 1.2873015873016, 1.158087802003537, 1.0552041927906899, 1.0099991953537275, 1.0016845914908628, 1.000107900677376, 1.0000030057271563, 1.00000003117352.
  - mpmath iterates (3000 digits): 1.28730158730159, 1.15808780200354, 1.05520419279069, 1.00999919535373, 1.00168459149086, 1.00010790067738, 1.00000300572712.
  - The two agree to about 13 digits.
  - Vertex heights agree to 5 significant figures: script 0.79998, 0.18139, 0.031872, 2.1573e−3, 7.8117e−5, 8.9418e−7, 1.7903e−9; mpmath gives the same values.
  - Frame-8 height: 5.4319e−13 in the script and 5.4343e−13 in exact arithmetic on the same triple, a 0.04% difference from rounding in f.
  - The header says the next height would be about 1e−17; mpmath gives 1.0101e−17.
- **Reference values.** The root p = 1 comes from the exact factorisation.
- **Picture.** The parabola is drawn through the three points (Lagrange form). The vertex marker is at (q3, P(q3)). The inset is centred on the vertex, with width 1.4·√(2h/a) and y range (−0.8h, 3h), so the gap above the axis is visible in every frame. In frame 1 the inset also shows f touching the axis at x = 1. Titles, legend (p₂ to 10 significant figures) and inset titles match the computed values. There is no clamping or masking.

### `mullersbb.jl` (Case 2)
- **Method.** Standard real Muller. The step errors on a negative discriminant, which never happens (disc from 14.39 down to 4.69e−7). Taking the larger-modulus denominator selects the quadratic root nearest p2.
- **Numbers.**
  - Script iterates: 1.2543159902744359, 1.3222993665586782, 1.3688966241528713, 1.3970591565574766, 1.408412963976924, 1.4126956654374672, 1.4139236819552305, 1.4141744432077474, and last q3 = 1.41421024252589.
  - mpmath gives the same to 13 or more digits.
  - Mathews' archive printout gives the same to all 13 printed digits.
  - The convergence order in a high-precision long run is 1.2338.
- **Reference values.** √2 is exact.
- **Picture.** The open circle is at (q3, 0), and q3 is a verified root of the drawn parabola. The inset spans [q2 − 0.15s, q3 + 0.8s], with title "step to next p₂: %.2e" = q3 − q2. In frames 5–9 the parabola has two real crossings (negative vertex height), and the marker correctly sits on the one nearest p2. Header comments checked:
  - "within 0.1 of √2 from frame 5": frame 5 has q0 = 1.3223, error 0.092, and frame 4 has q0 = 1.2543, error 0.16. Correct.
  - "under 7% of panel width from frame 7": frame 7 is 6.3% and frame 6 is 8.4%. Correct.

### `mullerscc.jl` (Case 3)
- **Method.** Identical code to `mullersbb.jl` except for f, the starting values, the title and the inset position. Standard real Muller, with disc positive throughout (45.1 down to 1.19e−5).
- **Numbers.**
  - Script iterates: 1.627646913608958, 1.6742682889831824, 1.7034875047036455, 1.7200472229337476, 1.72750110119843, 1.7306305638858632, 1.7317042934610234, 1.7319877986383865, and last q3 = 1.73204300275116.
  - mpmath: 1.62764691360896, 1.67426828898318, 1.70348750470364, 1.72004722293374, 1.72750110119845, 1.73063056388569, 1.73170429346136, 1.73198779863755.
  - The two agree to about 12 digits, and the remaining difference is Float64 rounding near the double root.
  - Mathews' program (transcribed) gives the same sequence.
  - Order 1.2338.
- **Reference values.** √3 is exact from the factorisation.
- **Picture.** Same construction as Case 2, and the frames agree. The step values in the inset titles are 1.28e−01 … 5.52e−05.

