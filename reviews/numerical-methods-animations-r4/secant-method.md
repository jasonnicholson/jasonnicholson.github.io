# Secant Method — animation review (round 4)

Page: `pages/numerical-methods/secant-method/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page agrees with my independent computation, and every script implements the plain two-point secant method on the stated problem and draws what it computes.

Things I looked at and judged not to be findings:
- **Case 3 GIF, frames 8–10.** No secant line or new diamond is drawn. In double precision p8 = 0.0 exactly (p7 = 4.8e-25 and f(p7) = p7 in floating point, so the update cancels to 0). From there |f(pb)-f(pa)| ≤ 4.8e-25 < 1e-14, so the script's guard skips the step and stores p9 = p10 = p8 instead of a secant update. The method has reached f = 0 exactly, the legend makes no false claim, and the frames only hold the converged state. Cosmetic.
- **Case 5 GIF has 9 frames, while the legacy listing has n = 16.** The page says why it stops at p10 (the first iterate past the window, which is the same 0–10.1 window as Mathews'), and it quotes p16. The legacy animation also stops showing iterates at p9 ≈ 9.80. Not a fidelity departure.
- **Case 4 y-range is −25..32; legacy PlotRange is −5..32.** The change is documented in the script comment (it shows f(p3) = −21 and f(p9) ≈ −21.9). It is a valid readability choice.
- **The page has no `## Description` section** (the authoring conventions require one). This is content the page lacks, so it is outside the review standard. The method statement in the Animations introduction was checked instead (ledger L1–L3).

---



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `secantmethodaa.jl` | 0 | 6.6 | secantmethodaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `secantmethodbb.jl` | 0 | 7.9 | secantmethodbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `secantmethodcc.jl` | 0 | 7.7 | secantmethodcc.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `secantmethoddd.jl` | 0 | 5.4 | secantmethoddd.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `secantmethodee.jl` | 0 | 4.7 | secantmethodee.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `secantmethodff.jl` | 0 | 4.3 | secantmethodff.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `secantmethodaa.gif` | 9 | byte-identical | secantmethodaa |
| `secantmethodbb.gif` | 28 | byte-identical | secantmethodbb |
| `secantmethodcc.gif` | 10 | byte-identical | secantmethodcc |
| `secantmethoddd.gif` | 16 | byte-identical | secantmethoddd |
| `secantmethodee.gif` | 9 | byte-identical | secantmethodee |
| `secantmethodff.gif` | 6 | byte-identical | secantmethodff |

### Page references

- Scripts linked: `secantmethodaa.jl`, `secantmethodbb.jl`, `secantmethodcc.jl`, `secantmethoddd.jl`, `secantmethodee.jl`, `secantmethodff.jl`
- GIFs embedded: 6
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

Values in the "Evidence" column come from `indep.py` (mpmath) unless marked "script", which means the instrumented double-precision dump `inst/out_*.txt`. The two agree to every digit displayed.

### Introduction
| # | Claim (page wording) | Evidence | Verdict |
|---|---|---|---|
| L1 | "a secant line is drawn through the two most recent iterates (p_{n-1}, f(p_{n-1})) and (p_n, f(p_n)); its x-intercept becomes p_{n+1}" | All scripts: `ps[i+1] = ps[i] - f(ps[i])*(ps[i]-ps[i-1])/(f(ps[i])-f(ps[i-1]))`. Each frame draws the line through ps[frame], ps[frame+1] and marks ps[frame+2] as the intercept. In the frames, every red diamond sits where the blue line crosses y = 0. | confirmed |
| L2 | "no derivative is required — the slope is approximated from two function evaluations" | No derivative appears in any script | confirmed |
| L3 | "can converge quickly, converge slowly near repeated roots, oscillate while converging, or diverge entirely" | Cases 1, 2, 3/6 and 5 show each behaviour (see below) | confirmed |
| L4 | "Julia source scripts … are linked under each case" | Six links, one under each case | confirmed |

### Case 1: `secantmethodaa`
| # | Claim | Evidence | Verdict |
|---|---|---|---|
| 1a | f(x) = 3e^x − 4cos(x), p0 = 1.0, p1 = 0.9 | script lines 10–12; title "3eˣ − 4cos(x)" | confirmed |
| 1b | "Fast Convergence" | error 3.1e-6 at p6, 1.1e-9 at p7, 2.7e-15 at p8 | confirmed |
| 1c | root "near x ≈ 0.2549" (also in alt text) | mpmath findroot: 0.254850059028853 | confirmed |
| 1d | "Both starting points are on the same side of the root" | 1.0 and 0.9 are both > 0.2549 | confirmed |
| 1e | "p2 ≈ 0.456, still 0.20 from the root" | p2 = 0.455750754, e = 0.200901 | confirmed |
| 1f | errors "0.066 at p3, 0.0089 at p4, 4.4×10⁻⁴ at p5, 3.1×10⁻⁶ at p6" | 0.0658805, 0.00891019, 4.43454e-4, 3.11512e-6 | confirmed |
| 1g | "consistent with the secant method's order ≈ 1.618 at this simple root" | f'(r) = 4.88 ≠ 0 and f''(r) ≠ 0. Empirical q_n = 1.794, 1.500, 1.653, 1.604, 1.623, 1.616, 1.619, 1.618 (`order.py`) | confirmed |
| 1h | alt: "x-intercept converges rapidly to the root" | frames 1–9 legend p2 … p10 = 0.45575, 0.32073, 0.26376, 0.25529, 0.25485 … | confirmed |
| 1i | wiring: link `secantmethodaa.jl`, embed `secantmethodaa.gif` | the script writes that GIF; the manifest shows it byte-identical | confirmed |

### Case 2: `secantmethodbb`
| # | Claim | Evidence | Verdict |
|---|---|---|---|
| 2a | f(x) = 1 − 10x + 25x², p0 = 1.0, p1 = 0.9 | script lines 12–14 | confirmed |
| 2b | "(1−5x)² has a double root at x = 0.2 where f'(0.2) = 0" | algebraic identity; f'(x) = −10 + 50x = 0 at 0.2 | confirmed |
| 2c | "here f(x) = 25(x−0.2)²" | 25(x² − 0.4x + 0.04) = 25x² − 10x + 1 | confirmed |
| 2d | "converges, but only linearly" | e_n/e_{n−1} → 0.618034 (constant), see 2e | confirmed |
| 2e | "ratio of successive errors settles at (√5−1)/2 ≈ 0.618" | ratios p5…p33: 0.62295, 0.61616, 0.61875, 0.61776, 0.61814, … 0.618034 from p15 on | confirmed |
| 2f | "each step removes only about 38% of the remaining error" | 1 − 0.618 = 0.382 | confirmed |
| 2g | "Slow Convergence" / "creep toward the root over many iterations" | after 28 frames p29 = 0.200000883 (e = 8.8e-7). Frame 28 legend "p29 = 0.20000088" (script: 0.20000088348568937) | confirmed |
| 2h | alt: "iterates slowly approach the double root at x=0.2, demonstrating linear convergence" | as above | confirmed |
| 2i | wiring | `secantmethodbb.jl` → `secantmethodbb.gif`, 28 frames | confirmed |

### Case 3: `secantmethodcc`
| # | Claim | Evidence | Verdict |
|---|---|---|---|
| 3a | f(x) = arctan(x), p0 = 1.35, p1 = 1.30 | script lines 12–14 | confirmed |
| 3b | "converges to the root at x = 0" | p5 = 4.57e-7, p6 = −6.89e-12, p7 = 4.80e-25 | confirmed |
| 3c | "iterates oscillate — jumping to the opposite side of the root each step before settling" | signs from p1: +, −, +, −, +, −, +, − … (p2 = −1.2214, p3 = 0.01804, p4 = −0.006723, p5 = +4.6e-7, p6 = −6.9e-12, p7 = +4.8e-25) | confirmed |
| 3d | "flat slope … causes the secant line to overshoot to negative x on the first step" | secant slope through p0, p1 = 0.363; p2 = −1.22138 | confirmed |
| 3e | alt: "oscillate across x=0 with decreasing amplitude" | \|p1\| … = 1.30, 1.22, 0.018, 0.0067, 4.6e-7, … strictly decreasing | confirmed |
| 3f | wiring | `secantmethodcc.jl` → `secantmethodcc.gif`, 10 frames | confirmed |

### Case 4: `secantmethoddd`
| # | Claim | Evidence | Verdict |
|---|---|---|---|
| 4a | f(x) = x³ − x + 3, p0 = 2.0, p1 = 1.0 | script lines 11–13 | confirmed |
| 4b | "a real root near x ≈ −1.672" (alt: "near x=-1.672") | findroot: −1.67169988165716. The discriminant 4 − 243 < 0 means it is the only real root | confirmed |
| 4c | "Starting from positive values far from the root" | p0 − r = 3.67, p1 − r = 2.67 | confirmed |
| 4d | "the secant iterates wander — including a large positive excursion — before eventually converging" | 2, 1, 0.5, −3.0, 0.111, −0.265, **3.164**, −0.659, −1.118, −3.034, −1.329, −1.471, −1.735, −1.6625, −1.6713, −1.67170, −1.6716999, −1.67169988 | confirmed |
| 4e | heading "Convergence (Oscillating Path…)" / "non-monotone" path | the path above is non-monotone and swings between sides of x = 0 | confirmed |
| 4f | alt: "wander through positive and negative values before converging" | as above; frame 16 legend "p17 = -1.6717" | confirmed |
| 4g | wiring | `secantmethoddd.jl` → `secantmethoddd.gif`, 16 frames | confirmed |

### Case 5: `secantmethodee`
| # | Claim | Evidence | Verdict |
|---|---|---|---|
| 5a | f(x) = x e^{−x}, p0 = 1.5, p1 = 2.0 | script lines 11–13 | confirmed |
| 5b | "has a root at x = 0" | f(0) = 0 | confirmed |
| 5c | "NON Convergence (Diverging to Infinity)" | p_n increases without bound: p100 = 74.96, p1000 = 701.0, p5000 = 3475.2 | confirmed |
| 5d | "decreases toward zero for large x, so the secant line … has a shallow negative slope whose x-intercept falls to the right" | f' < 0 for x > 1. Secant slopes: −0.128 (p0, p1), then negative and shrinking in magnitude. Each p_{n+1} > p_n | confirmed |
| 5e | "after the first jump to p2 ≈ 4.11" | p2 = 4.113798873 | confirmed |
| 5f | "each step moves right by less than 1" | the steps after p2 are 0.6987, 0.9716, 0.8108, 0.8332, 0.7992, …, and the largest is 0.97156 (5000-iteration run) | confirmed |
| 5g | "(the step tends to ln 2 ≈ 0.693)" | step at n = 10: 0.7737, n = 100: 0.70263, n = 1000: 0.69414, n = 5000: 0.69335. ln 2 = 0.69315. The fixed point of s = s/((1 − s/p)e^s − 1) as p → ∞ is e^s = 2 | confirmed |
| 5h | "The animation stops at p10 ≈ 10.57, the first iterate past the right edge of the window" | p9 = 9.80099 < 10.1 < p10 = 10.57464. Frame 9 (last) shows "p10 = 10.57 (off chart)" with a hollow marker at the edge, labelled as such | confirmed |
| 5i | "p16 ≈ 15.11" | p16 = 15.105971719963 | confirmed |
| 5j | alt: "x-intercept steps progressively further right until p10≈10.57 leaves the window, illustrating slow divergence" | frames 1–9: p2 … p9 = 4.114, 4.813, 5.784, 6.595, 7.428, 8.227, 9.02, 9.801, then p10 off chart | confirmed |
| 5k | wiring | `secantmethodee.jl` → `secantmethodee.gif`, 9 frames | confirmed |

### Case 6: `secantmethodff`
| # | Claim | Evidence | Verdict |
|---|---|---|---|
| 6a | f(x) = arctan(x), p0 = 1.60, p1 = 1.50 | script lines 12–14 | confirmed |
| 6b | "With slightly larger starting values than Case 3" | 1.60/1.50 vs 1.35/1.30 | confirmed |
| 6c | "converges to x = 0" | p5 = −5.24e-5, p6 = 1.01e-7, p7 = −9.2e-17, p8 = 3.1e-31 | confirmed |
| 6d | "a larger first overshoot" | p2 = −1.84246 vs Case 3 p2 = −1.22138 | confirmed |
| 6e | "subsequent steps quickly close in on the root" | p3 = −0.0975, p4 = 0.0762, p5 = −5.2e-5 | confirmed |
| 6f | "super-linear … because f''(0) = 0 for arctan its asymptotic order here is 2 rather than … 1.618" | f''(0) = 0 and f'''(0) = −2 ≠ 0. Then e_{n+1} ≈ −(1/3)e_n e_{n−1}(e_n + e_{n−1}) ~ e_n e_{n−1}², so p² = p + 2 and p = 2. Empirical q_n = 1.600, 2.250, 1.889, 2.059, 1.972, 2.015 → 2 (`order.py`) | confirmed |
| 6g | alt: "converge to x=0 after initial overshoot, showing super-linear convergence" | as above; frame 6 legend "p7 = -9.23e-17" | confirmed |
| 6h | wiring | `secantmethodff.jl` → `secantmethodff.gif`, 6 frames | confirmed |

### Script header comments (claims in the scripts)
| # | Claim | Evidence | Verdict |
|---|---|---|---|
| H1 | dd: "Real root near x ≈ -1.6717" | −1.67170 | confirmed |
| H2 | dd: "f(p3) = -21 and f(p9) ≈ -21.9" | −21.0, −21.9005 | confirmed |
| H3 | ee: "frame 9 shows p10 ≈ 10.57, the first iterate past the window" | confirmed (5h) | confirmed |
| H4 | ff: "overshoots to p2 ≈ -1.842, then from p3 on the iterates alternate sides" | p2 = −1.84246; signs from p3: −, +, −, +, −, … | confirmed |
| H5 | n = 9, 28, 10, 16, 9, 6 in the headers | `n_iters` and frame counts 9, 28, 10, 16, 9, 6 (manifest) | confirmed |

### Fidelity to the legacy archive
| # | Item | Evidence | Verdict |
|---|---|---|---|
| F1 | Mathews Examples 3–8 (Fast, Slow, Convergence/Oscillation, Convergence, NON Convergence/Diverging to Infinity, Convergence) map to Cases 1–6 | `legacy_formulas.png`: 3Exp[x]−4Cos[x], 1.0, 0.9; 1−10x+25x², 1.0, 0.9; ArcTan, 1.35, 1.30; x³−x+3, 2.0, 1.0; x e^{−x}, 1.5, 2.0; ArcTan, 1.60, 1.50. All six match the page and scripts, in the same order and with the same behaviour labels | confirmed |
| F2 | Legacy n and windows | aa n = 9, x∈[0,1], y∈[−1,6]; bb n = 28, [0,1]×[0,16]; dd n = 16, x∈[−3.2,3.5]; ee n = 16, [0,10.1]×[0,0.4]; ff n = 6, [−3,2]×[−1.25,1.15]. All match the scripts except ee n (explained on the page, and the legacy GIF also shows nothing past p9) and the dd y-floor (documented) | confirmed |
| F3 | Legacy iterate values | legacy Secantcc frames show p2 = −1.22138, p3 = 0.01804, p4 = −0.00672, p5 = 4.57221×10⁻⁷. Legacy Secantee frames show p2 = 4.11380 … p9 = 9.80099. Both are identical to the script values | confirmed |
| F4 | Mathews Examples 1–2 (cubic, three roots; 2(a) fast/2(b) slow) | These are worked examples, not in the "Scenarios and Animations" set. Examples 3–4 of the animation set cover fast and slow convergence | not a departure |

---

### 3. Implementation checks (per script)

The same four checks apply to every script:
- **Method.** The iteration is the textbook two-point secant update with no bracketing or safeguard, other than a 1e-14 denominator guard that only freezes the iterate once f-values are equal to working precision. This is not regula falsi: no sign test is made and the two most recent points are always used. The ee script also has an |p| > 1e6 divergence cap, which never fires within its 9 steps.
- **Numbers.** Script values (double) were compared with my mpmath values. The tables give both.
- **Reference values.** The only references are the quoted roots: 0.2549, 0.2 (exact), 0 (exact), −1.672, 0 (exact), 0 (exact). Each was checked by findroot or algebra.
- **Picture.** Each frame draws the line through (ps[frame], f) and (ps[frame+1], f), clipped to the box by `clip_line`. Its slope is (fb−fa)/(pb−pa), and the diamond is placed at ps[frame+2] with label index frame+1, which equals the p-index of ps[frame+2] because ps[k] = p_{k−1}. The blue/dark-blue markers are labelled p_{frame−1} and p_frame, which is correct. In every frame I viewed, the diamond lies on the line's x-axis crossing.

### `secantmethodaa.jl` (Case 1)
| n | script p_n | mpmath p_n |
|---|---|---|
| 2 | 0.4557507541631453 | 0.455750754163146 |
| 3 | 0.32073053275992147 | 0.320730532759922 |
| 4 | 0.2637602526350553 | 0.263760252635055 |
| 5 | 0.25529351342420903 | 0.255293513424209 |
| 6 | 0.2548531741452458 | 0.254853174145246 |
| 7 | 0.2548500601244336 | 0.254850060124434 |
| 8 | 0.254850059028853 | 0.254850059028853 |
| 9, 10 | 0.2548500590288503 | 0.25485005902885 |

Root: findroot 0.254850059028850. Frames 1, 2, 9 viewed full size and all nine on the contact sheet. Frame 1's line through (1.0, 5.994) and (0.9, 4.892) meets y = 0 at 0.456. In frame 9, |Δf| = 1.33e-14 just passes the 1e-14 guard, the line is drawn, and p10 = p9.

### `secantmethodbb.jl` (Case 2)
| n | script | mpmath |
|---|---|---|
| 2 | 0.5733333333333335 | 0.573333333333333 |
| 7 | 0.23500000000000001 | 0.235 |
| 15 | 0.200744779890941 | 0.200744779890943 |
| 20 | 0.20006715675103587 | 0.200067156751052 |
| 25 | 0.2000060555206828 | 0.200006055520472 |
| 29 | 0.20000088348568937 | 0.20000088348853 |

Rounding from evaluating f in expanded form (f is about 1e-11 near the double root) moves p29 by 3e-12. That is below the 8 decimals in the legend. A closed-form check: for f = c(x−a)², the secant error satisfies e_{n+1} = e_n e_{n−1}/(e_n+e_{n−1}), so the ratio → 1/φ = 0.618034. Both computations show this. The y-clamp at 16 is exact for p0 (f = 16). Frames 1, 28 and the contact sheet were viewed.

### `secantmethodcc.jl` (Case 3)
| n | script | mpmath |
|---|---|---|
| 2 | −1.2213792056860207 | −1.22137920568601 |
| 3 | 0.01803629819672592 | 0.0180362981967281 |
| 4 | −0.006723294978554995 | −0.0067232949785557 |
| 5 | 4.5722058130987647e-7 | 4.57220581309817e-7 |
| 6 | −6.8886493391088996e-12 | −6.88864933909559e-12 |
| 7 | 4.798293787661118e-25 | 4.80018331316748e-25 |
| 8 | 0.0 | −7.59e-48 |

p7 differs in the 3rd digit. That is the expected double-precision effect at |p| ~ 1e-25: the denominator f(p6) − f(p5) loses digits. It is invisible at the legend precision ("4.80e-25"). In double, p8 = 0 exactly because atan(p7) == p7, and the guard holds p9, p10 at 0. Frames 8–10 therefore show no secant step (see Findings). The legacy frames agree with p2–p5. All 10 frames were viewed on the contact sheet.

### `secantmethoddd.jl` (Case 4)
| n | script | mpmath |
|---|---|---|
| 3 | −3.0 | −3.0 |
| 6 | 3.1639049160972332 | 3.16390491609723 |
| 9 | −3.034227576785138 | −3.03422757678514 |
| 12 | −1.7346585404889323 | −1.73465854048893 |
| 15 | −1.6717022768625058 | −1.67170227686251 |
| 17 | −1.67169988165716 | −1.67169988165716 |

The early-exit `break` (when |Δp| < 1e-8 and i > 4) fires only at i = 17, the last loop pass. No `ps` entry is left undefined, which I confirmed because all 18 entries are printed. No iterate falls outside x∈[−3.2,3.5] and no f-value outside y∈[−25,32] (the largest is f(p6) = 31.51), so the clamps never change a drawn point. The contact sheet (8 of 16 frames) was viewed. In frame 5, p6 = 3.1639 is at the right edge with its dashed line reaching f = 31.5, and in frame 9 p10 = −1.3294.

### `secantmethodee.jl` (Case 5)
| n | script | mpmath |
|---|---|---|
| 2 | 4.113798873326397 | 4.1137988733264 |
| 5 | 6.594867561790274 | 6.59486756179027 |
| 9 | 9.800986646316584 | 9.80098664631658 |
| 10 | 10.574639777228054 | 10.5746397772281 |
| 16 | — (not computed) | 15.105971719963 |

The off-window handling is honest. In frame 9, p10 is outside [0,10.1], so the script draws a hollow red marker at x = 10.1, labelled "p10 = 10.57 (off chart, marker at edge)", plus a text note. This is not a clamped value passed off as real. A soft-scope warning about `n_valid` when run as a script is harmless because the variable is unused in plotting. All 9 frames were viewed (contact sheet, plus frame 9 at full size).

### `secantmethodff.jl` (Case 6)
| n | script | mpmath |
|---|---|---|
| 2 | −1.8424619601336367 | −1.84246196013363 |
| 3 | −0.09748338647473931 | −0.0974833864747366 |
| 4 | 0.07619322951467797 | 0.0761932295146751 |
| 5 | −5.236815030411346e-5 | −5.23681503041059e-5 |
| 6 | 1.0111340931960545e-7 | 1.01113409319577e-7 |
| 7 | −9.225344201478945e-17 | −9.22534493586272e-17 |

The order-2 claim was checked by the empirical q_n at 3000 digits (→ 2.015) and by the error-recursion argument in 6f. All 6 frames were viewed; the legend values match the table.

