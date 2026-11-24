# Graeffe's Method — animation review (round 9)

Page: `pages/numerical-methods/graeffes-method/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** No Error, Misleading or Minor findings.

---



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `graeffesaa.jl` | 0 | 10.4 | graeffesaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `graeffesab.jl` | 0 | 6.8 | graeffesab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `graeffesaa.gif` | 9 | byte-identical | graeffesaa |
| `graeffesab.gif` | 11 | byte-identical | graeffesab |

### Page references

- Scripts linked: `graeffesaa.jl`, `graeffesab.jl`
- GIFs embedded: 2
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Location | Claim (page wording) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | Description, Root Squaring | p₁(x) = (−1)ⁿ p(√x) p(−√x) has roots r_k² | For n=4 this is E(x)² − x·O(x)². Expanding it gives the script's d₀…d₄ exactly. The exact-from-roots p_m equals the script's iterates for every m (assert in `indep.py` passed for m=0..8 Case 1, 0..10 Case 2) | confirmed |
| 2 | Description | m squarings give roots r_k^(2^m) | Same assert | confirmed |
| 3 | Description, Separated Root Theorem | \|r_k\|^(2^m) ≈ \|c_{n−k}/c_{n−k+1}\|, \|r_k\| ≈ (…)^(1/2^m) | Estimates converge to the true magnitudes in Case 1 (errors ~1e−34 at m=8) | confirmed |
| 4 | Description | sign chosen by testing p(±\|r_k\|) | Standard, and matches the archive. The scripts plot magnitudes only, and the Animations intro says so | confirmed (not used by animations; no mismatch) |
| 5 | Convergence | for distinct-magnitude real roots, error decreases quadratically; digits roughly double | Case 1 digits: r₁ 1.9, 3.2, 5.5, 9.8, 18.1, 34.4 (m=3..8); r₄ 3.3, 6.0, 11.1, 21.1, 40.6 | confirmed |
| 6 | Convergence | \|c_{n−k}/c_n\| ≈ (\|r₁\|⋯\|r_k\|)^(2^m) | Case 1 m=8: \|c₀\| = 24^256 ≈ 2.16e353; \|c₇… c₁\| ≈ same; \|c₃\| = 1.34e154 ≈ 4^256 | confirmed |
| 7 | Animations intro | Dashed lines = true magnitudes; coloured traces = estimates vs m | Plot code (`hline!` ls=:dash; `plot!` traces) and frames | confirmed |
| 8 | Animations intro | Scripts use exact integer arithmetic for the squaring step | `big.(...)`, `Vector{BigInt}` in both scripts | confirmed |
| 9 | Animations intro | in double precision the coefficients overflow at m = 8 | Float64 replay: m=7 finite in both cases (max 4.6e176, 2.9e217); m=8 gives inf/nan in both | confirmed |
| 10 | Animations intro | largest coefficient of p₈ ≈ 2.2×10³⁵³ (Case 1) | exact: 2.16e353 | confirmed |
| 11 | Animations intro | … 8.6×10⁴³⁴ (Case 2) | exact: 8.64e434 | confirmed |
| 12 | Case 1 heading | f(x) = (x+1)(x−2)(x+3)(x−4), true \|r_k\| ∈ {1,2,3,4} | Expanded = x⁴−2x³−13x²+14x+24 = script `c0` | confirmed |
| 13 | Case 1 Behavior | all four converge quadratically; from m=3 on digits roughly double each step | digit ratios m3→4: 1.5–1.8; thereafter 1.7–1.9 for all four, tending to 2 | confirmed |
| 14 | Case 1 Behavior | first steps irregular | r₁: 2.0, 5.48, 4.34; r₄: 1.71, 0.84, 0.98 | confirmed |
| 15 | Case 1 Behavior | r₂ estimate 3.017 at m=1, moves away to 2.941 at m=2 | 3.016621, 2.940917 (script and independent) | confirmed |
| 16 | Case 1 Behavior | \|r₁\|/\|r₂\| = 4/3; a few squarings separate them | trivially true; r₁ error 0.0025 by m=4 | confirmed |
| 17 | Case 1 link/embed | `graeffesaa.jl` / `graeffesaa.gif` are Case 1 | Script header and title match the heading; the GIF is byte-identical to the regenerated output | confirmed |
| 18 | Case 1 alt text | roots −3, −1, 2, 4; traces move from poor initial estimates onto dashed lines | Frames 1, 5, 9 viewed: m=0 estimates 2.0, 6.5, 1.08, 1.71; all on lines by m≈4 | confirmed |
| 19 | Case 2 heading | f(x) = (x−1)(x+2)(x−5)², \|r_k\| ∈ {1,2,5,5} | Expanded = x⁴−9x³+13x²+45x−50 = script `c0` | confirmed |
| 20 | Case 2 Behavior | double-root estimates converge linearly; from m=2 on error roughly halves each step | error ratios (r₁, r₂): m2→3 0.47, 0.55; 3→4 0.49, 0.51; … 9→10 0.50, 0.50 | confirmed |
| 21 | Case 2 Behavior | reason: separated-root condition never holds for equal magnitudes | Leading ratio → 2·5^(2^m), so the estimate is 5·2^(1/2^m), error ≈ 5 ln2/2^m (halving). Matches the numbers | confirmed |
| 22 | Case 2 Behavior | simple roots \|r\|=1, 2 converge quadratically | r₃ error 6.5e−4, 1.8e−6, 1.5e−11, 1.7e−21, 4.6e−41 (m=3..7) | confirmed |
| 23 | Case 2 Behavior | a real pair ±r behaves the same way (one squaring gives a double root) | Mathews Ex. 9 (±5, 2, −1): from m=1 its estimates are identical to Case 2 (`pm5.out`), with error ratios 0.47…0.50 | confirmed |
| 24 | Case 2 Behavior | complex pair 3±4i, 2, 1 has magnitudes 5,5,2,1 | \|3±4i\| = 5 | confirmed |
| 25 | Case 2 Behavior | its top two estimates cross back and forth over 5 | sign of r₁ error, m=1..10: −,+,−,+,−,+,+,−,+,+ (r₂ opposite) | confirmed |
| 26 | Case 2 Behavior | error does not halve each step; grows from m=4→5 and m=7→8 | \|err r₁\|: 0.0797→0.165 (m4→5), 0.0171→0.0183 (m7→8); r₂: 0.0784→0.171, 0.0170→0.0183. Other ratios range from −0.76 to +0.35, so the error does not halve. (r₂ error also grows from m=0, where it is exactly 0 because 45/9 = 5, to m=1. That is not stated, and the page does not contradict it) | confirmed |
| 27 | Case 2 link/embed | `graeffesab.jl` / `graeffesab.gif` are Case 2 | Header, title, parameters match; GIF byte-identical to regen | confirmed |
| 28 | Case 2 alt text | two blue traces approach 5 slowly; crimson (2) and orange (1) converge rapidly | Code colours: steelblue ×2, crimson=k3 (\|r\|=2), darkorange=k4 (\|r\|=1); frames 1, 6, 11 viewed | confirmed |
| 29 | Case 2 GIF annotation | "r₁, r₂: linear convergence (double root) / r₃, r₄: quadratic convergence" | Same as rows 20, 22 | confirmed |

---

### 3. Implementation checks

### `graeffesaa.jl` (Case 1)
- **Method:** this is classical Graeffe (Dandelin–Lobachevsky) root squaring. The coefficient recurrence is d₄=c₄², d₃=2c₄c₂−c₃², d₂=c₂²+2c₄c₀−2c₃c₁, d₁=2c₂c₀−c₁², d₀=c₀². It is the expansion of E(t)²−t·O(t)² (n=4, so the sign (−1)ⁿ=+1). The estimates are the separated-root ratios \|c_{k+1}/c_k\|^(1/2^m), largest root first. This is the Graeffe/Graeffe2 form in the archive.
- **Numbers:** for m=0..8 the script's BigInt coefficients equal prod(x − r^(2^m)) built independently from the roots. Estimates, script vs mpmath (60 digits):
  - m=1: 5.477225575, 3.016620626, 1.733107903, 0.8381163549 vs 5.477225575, 3.016620626, 1.733107903, 0.8381163549
  - m=2: 4.337613137, 2.940917081, 1.917379337, 0.9812272568 (identical)
  - m=5: 4.000012556, 2.999990800, 1.999999855, 0.99999999999272 (identical)
  - m=8: 4.0, 3.0, 2.0, 1.0 (independent errors 1.6e−34, −1.2e−34, −6.5e−48, 0)
- **Reference values:** `true_mags` = [4,3,2,1] are the magnitudes of the factored roots, checked by expansion.
- **Picture:** the y-range (0, 7) contains every estimate (max 6.5 at m=0). No clamping or masking. There are 9 frames for m=0..8, and the title shows the right f and m. The legend labels map k=1..4 to \|r\|=4,3,2,1, matching the ratio order. Frames 1–9 were viewed on the contact sheet.

### `graeffesab.jl` (Case 2)
- **Method:** the same recurrence and estimator as Case 1. It is plain Graeffe, without the archive's multiplicity-corrected formula. The page presents it that way, to show linear convergence.
- **Numbers:** for m=0..10 the coefficients match the exact-from-roots construction. Estimates, script vs independent:
  - m=2: 5.966149802, 4.246209542, 2.005317622, 0.9842178983 (identical)
  - m=6: 5.054446430, 4.946140066, 2.0, 1.0 (identical)
  - m=10: 5.003385653, 4.996616638, 2.0, 1.0 (identical)
- **Reference values:** `true_mags` = [5,5,2,1], checked.
- **Picture:** the y-range (0, 9.5) contains every estimate (max 9.0 at m=0). There are 11 frames for m=0..10. Both double-root traces are steelblue, distinguished by circle and diamond markers. The extra dashed line at 5 duplicates the k=1 line, which is harmless. The last-frame annotation sits at (6, 6.3), clear of the traces and the legend. Frames 1–11 were viewed on the contact sheet, and frame 11 at full size.

### Legacy fidelity
- Archive Examples 3 and 4 use f₀ = 24+14x−13x²−2x³+x⁴, which is the page's Case 1. Example 6 uses f₀ = −50+45x+13x²−9x³+x⁴, which is the page's Case 2. In Example 6 the archive also says the repeated root converges linearly and the simple roots quadratically, as the page does.
- Archive Example 9 (unequal real roots of equal magnitude, f₀ = 50+25x−27x²−x³+x⁴ = (x−5)(x+5)(x−2)(x+1)) has no animation. The page covers it in prose ("a real pair ±r behaves the same way"), and that sentence is verified (row 23). The drop is therefore not silent, and I do not report it.
- Archive Examples 5 and 8 (degree 6 and 7, more distinct-root cases) have no animation. They add no new behaviour, so I do not report them.
- Could not determine the polynomial for Example 7 (repeated root): its formula image `GraeffeMethodMod_gr_434.gif` is missing from the archive.

