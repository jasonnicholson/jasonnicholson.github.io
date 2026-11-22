# Chebyshev Approximation Polynomial — animation review (round 5)

Page: `pages/numerical-methods/chebyshev-approximation-polynomial/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** No Error, Misleading or Minor finding.

I looked hard at the following and decided they are not findings:

- **The Mathews "convergence region" overlay is not reproduced.** Every archive GIF draws a tolerance (±0.05 or ±0.001), a yellow bar showing where |f − P| < tol, and green lines marking the approximation interval. The page draws f, the interpolant and the nodes, and gives the interval in the title. This is content the page does not have, not something it gets wrong. The review standard puts that outside the findings. The owner may still want it as a teaching enhancement.
- **Node-trimming fallback in `chebyshev_nodes` (lines 89–105).** If any node gave a non-finite f, the interval would be shrunk silently while the title kept showing the untrimmed interval. This is a latent hazard only. The instrumented run shows `attempts = 0` for every n in all 29 cases, so the fallback never fires and every title interval is the true node interval.
- **Description sentence "reduce oscillation compared with equally spaced interpolation at the same degree".** This is true in the sense intended (large n, Runge-type behaviour). For case 08 at very small n, equally spaced nodes happen to give a smaller max error (n = 6: Chebyshev 0.302, equispaced 0.203). From n = 10 onward Chebyshev wins decisively: n = 16 gives 0.0138 vs 0.485, and n = 32 gives 9.5e-5 vs 14.0. The claim is about oscillation and the standard asymptotic behaviour, so it stands.

---



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `chebyshev_animations_all.jl` | 0 | 41.6 | 29 GIFs (cheby01.gif … cheby29.gif) | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `cheby01.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby02.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby03.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby04.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby05.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby06.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby07.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby08.gif` | 14 | byte-identical | chebyshev_animations_all |
| `cheby09.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby10.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby11.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby12.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby13.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby14.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby15.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby16.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby17.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby18.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby19.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby20.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby21.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby22.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby23.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby24.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby25.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby26.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby27.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby28.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby29.gif` | 10 | byte-identical | chebyshev_animations_all |

### Page references

- Scripts linked: `chebyshev_animations_all.jl`
- GIFs embedded: 29
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

Source: `index.qmd`. The page has no per-case "Behavior" paragraphs. Its checkable claims are the Description, the Animations introduction, the 29 headings with alt-text captions, and the source link and embeds.

| # | Claim (page wording) | Evidence | Verdict |
|---|---|---|---|
| D1 | "Chebyshev-node interpolation uses clustered nodes near interval endpoints to reduce oscillation compared with equally spaced interpolation at the same degree." | `props.py`, case 08: Chebyshev vs equispaced max error at n = 10/16/20/32 is 0.0889/0.0138/0.00396/9.5e-5 vs 0.173/0.485/1.07/14.0. The frames show the nodes clustering at the endpoints. | confirmed (see note in §1 about n = 6) |
| D2 | "…a standard remedy for Runge-type endpoint blow-up." | Case 08 (Runge-type 1/(1+10x²)): the Chebyshev error falls geometrically at exactly the theoretical rate ρ = 1/√10 + √(1/10+1) = 1.3650, ρ⁴ = 3.472. The script's error ratios per +4 nodes are 3.471, 3.471, 3.473. | confirmed |
| D3 | Node formula x_k = (a+b)/2 + (b−a)/2 · cos((2k−1)π/(2n)), k = 1..n | Script line 97 is the same formula. These are the mapped roots of T_n, and they match Mathews' node set (n = N+1). | confirmed |
| A1 | "Each animation steps through 2, 3, 4, 5, 6, 8, 10, 12, 14 and 16 Chebyshev nodes" | `instr.out`: seq = [2,3,4,5,6,8,10,12,14,16] for every case except 08. Manifest: 10 frames each. | confirmed |
| A2 | "(case 08 continues to 20, 24, 28 and 32)" | `instr.out` case 08 seq = [2,…,16,20,24,28,32]. The GIF has 14 frames, and the last frame title reads "n = 32 nodes, degree ≤ 31" (viewed at full size). | confirmed |
| A3 | "for a fixed function and approximation interval" | Span and f are fixed per case (`resolved_span`). The title interval is identical in every frame (contact sheets). | confirmed |
| A4 | "With n nodes the interpolant has degree at most n−1" | n points give a unique interpolant of degree ≤ n−1. The mpmath Chebyshev series has n coefficients, c_0..c_{n−1}. | confirmed |
| A5 | "for an even function on a symmetric interval and even n it is at most n−2" | `indep.py` parity check on the even cases 08, 13, 17, 20, 22 with n = 2, 4, 6, 16: c_{n−1} ≈ 1e-60 (zero), and c_{n−2} ≠ 0. Visible in the frames too: case 17 and case 20 at n = 2 are horizontal lines. | confirmed |
| L1 | Link "Julia source for all cases" → `chebyshev_animations_all.jl` | The file exists. It is the only script, and it produces all 29 GIFs byte-identically (manifest). | confirmed |
| C01 | Case 01: f(x)=1/(1-x), [-1.6, 0.9] | Table row 28: `1/(1-x)`, span (-1.6, 0.9). GIF title "f(x) = 1/(1-x) / interval [-1.6, 0.9]". The embed is `cheby01.gif`. | confirmed |
| C02 | Case 02: 1/(1+x), [-0.9, 1.5] | Row 29. The title matches. The Mathews GIF shows green interval lines at −0.9 and 1.5. | confirmed |
| C03 | Case 03: 1/(1-x)^2, [-1.5, 0.8] | Row 30. The title matches. The Mathews GIF shows green lines at −1.5 and 0.8. | confirmed |
| C04 | Case 04: sqrt(x), [0, 2] | Row 31. The title is "[0, 2]". Mathews: "nodes in [0, 2]". | confirmed |
| C05 | Case 05: sqrt(x), [0, 8] | Row 32. The title matches. Mathews: [0, 8]. | confirmed |
| C06 | Case 06: sqrt(x), [0, 10] | Row 33. The title matches. Mathews: [0, 10]. | confirmed |
| C07 | Case 07: 1/sqrt(1-x), [-1.5, 0.95] | Row 34. The title matches. | confirmed (Mathews interval: could not determine, archive GIF missing) |
| C08 | Case 08: 1/(1+10x^2), [-1, 1], up to 32 nodes | Row 35, max_order = 31 → 32 nodes. The title matches. Mathews: [-1, 1]. | confirmed |
| C09 | Case 09: log(x), [0.02, 2] | Row 36. The title matches. Mathews: [0.02, 2]. | confirmed |
| C10 | Case 10: log(x), [0.02, 4] | Row 37. The title matches. Mathews: [0.02, 4]. | confirmed |
| C11 | Case 11: log(1+x), [-0.98, 1] | Row 38. The title matches. Mathews: [-0.98, 1]. | confirmed |
| C12 | Case 12: sin(x), [-3pi, 3pi] | Row 39 auto_span → finite support of the window (−3π, 3π). The title shows "[-9.425, 9.425]" (= ±3π to 3 d.p.). The Mathews GIF shows the interval as the full window. | confirmed |
| C13 | Case 13: cos(x), [-3pi, 3pi] | Row 40. The title is "[-9.425, 9.425]". | confirmed |
| C14 | Case 14: tan(x), [-1.45, 1.45] "inside singularities" | Row 41. The title matches. The poles ±π/2 = ±1.5708 lie outside the span, so the span is inside them. | confirmed (Mathews interval: could not determine) |
| C15 | Case 15: exp(x), [-2, 3] | Row 42 auto → (-2, 3). The title matches. The Mathews GIF shows the full window. | confirmed |
| C16 | Case 16: cos(x)*exp(-x), [-2, 4] | Row 43. The title matches. | confirmed |
| C17 | Case 17: cosh(x), [-4, 4] | Row 44. The title matches. | confirmed |
| C18 | Case 18: atan(x), [-2.2, 2.2] | Row 45. The title matches. | confirmed |
| C19 | Case 19: asin(x), [-1, 1] | Row 46. The title matches. | confirmed (Mathews interval: could not determine) |
| C20 | Case 20: besselj(0,x), [-10.2, 10.2] | Row 47. The title matches. | confirmed |
| C21 | Case 21: besselj(1,x), [-10.2, 10.2] | Row 48. The title matches. | confirmed |
| C22 | Case 22: normal_pdf(x), [-3, 3] | Row 49: exp(−x²/2)/√(2π), the same as the Mathews formula. The title matches. | confirmed |
| C23 | Case 23: normal_cdf(x), [-3, 3] | Row 50: ½+½erf(x/√2), the same as Mathews. The title matches. | confirmed |
| C24 | Case 24: gamma(x), [0.05, 2] | Row 51. The title matches. Mathews: [0.05, 2]. | confirmed |
| C25 | Case 25: gamma(x), [0.05, 4] | Row 52. The title matches. Mathews: [0.05, 4]. | confirmed |
| C26 | Case 26: gamma(x), [0.5, 5] | Row 53. The title matches. Mathews: [0.5, 5]. | confirmed |
| C27 | Case 27: bessely(0,x), [0.5, 20] | Row 54. The title matches. Mathews: [0.5, 20]. | confirmed |
| C28 | Case 28: bessely(0,x), [0.5, 10] | Row 55. The title matches. Mathews: [0.5, 10]. | confirmed |
| C29 | Case 29: bessely(0,x), [0.5, 4] | Row 56. The title matches. Mathews: [0.5, 4]. | confirmed |
| W | Embeds: each "### Case NN" embeds `chebyNN.gif` | Read in `index.qmd`. Each GIF's title shows "Chebyshev Case NN" with the same NN (all 29 contact sheets). | confirmed |

**Fidelity against Mathews.** All 29 archive cases are present, in the same order. The functions match the archive formula images exactly. The plotting windows match the archive windows for all 29 rows, the archive's x-ranges being (-1.6,1.5), (-1.5,1.6), …, (0,22). Every node interval stated in the archive's index, plus those visible in the archive GIFs for 02, 03, 12 and 15, matches. Mathews gives no interval in text and has no GIF for cases 01, 07, 13, 14, 16–23, so for those I could not check the node interval against the archive. For 13 and 16–23 the page uses the full window, which is what the archive GIFs for 12 and 15 do. For 01, 07, 14 and 19 the author picked explicit sub-intervals. They are mathematically reasonable (f is finite at every node, and the span avoids the singularity) but cannot be traced to the archive. As a side note, case 01's left end −1.6 does not mirror case 02's right end 1.5. Mirrored, it would be [−1.5, 0.9]. Without the archive GIF this is speculation, so it is not reported as a finding.

---

### 3. Implementation checks: `chebyshev_animations_all.jl`

**Is it the method it claims to be?** Yes. The script builds n Chebyshev nodes on [a,b] (line 97, the roots of T_n mapped to [a,b]). It interpolates f there with the barycentric Lagrange formula: weights at lines 108–118, the second (true) barycentric form inside the node hull at lines 135–142, and the first form ℓ(x)·Σ w_j y_j/(x−x_j) for extrapolation at lines 130–133. Mathews' "Chebyshev approximation polynomial" (ChebyshevPolyMod: Lagrange–Chebyshev theorem and the coefficient algorithm c_j = (2/(N+1)) Σ f(x_k) T_j(x_k)) is mathematically the same polynomial, namely the interpolant at the N+1 Chebyshev nodes. I confirmed the two agree numerically (below). The variant used is barycentric Lagrange evaluation rather than Mathews' Chebyshev-coefficient sum. The page names neither form, so there is no mismatch.

**Are the numbers right?**
- *Independent reconstruction.* `indep.py` rebuilds every (case, n) polynomial in 60-digit mpmath using Mathews' Chebyshev-series form and evaluates it at 28 grid points per frame (every 37th plotting-grid point, inside and outside the span, 4,147 points in all). Maximum relative difference from the script, per case, is 2.2e-16 (case 22) to 5.5e-11 (case 29). Case 29 is the worst because it is extrapolated far beyond [0.5, 4], to x = 22, where the polynomial is ~1e14. Every case is ≤ 1.4e-12 except case 29. The large absolute differences in cases 04 and 29 occur only where the extrapolated polynomial is huge, and those values are clamped off-screen anyway.
- *Interpolation property.* The mpmath polynomials reproduce f at the nodes to ≤ 8e-59. Since the script matches them to ~1e-12 relative, the script's interpolant passes through its nodes. The script's own `node_resid = 0` in `instr.out` is trivially zero, because `barycentric_eval` returns y_j at a node. I did not rely on it.
- *Convergence-rate property.* Where f has a single nearest singularity, Chebyshev interpolation error should shrink by the Bernstein-ellipse factor ρ per added node. Here ρ = t + √(t²−1), and t is the singularity's position in [−1,1] coordinates (for case 08 the singularity is complex, so ρ = a + √(a²+1)). Script error ratios against theory:
  - case 01: 2.213 and 2.214 per +2 nodes, theory ρ² = 2.214
  - case 02: 2.249 and 2.250, theory 2.250
  - case 14: 2.250 and 2.250, theory 2.250
  - case 08: 3.471, 3.471 and 3.473 per +4 nodes, theory ρ⁴ = 3.472

  Agreement to 3–4 digits confirms both nodes and evaluation.
- *Parity property.* Even f on a symmetric interval with even n gives c_{n−1} = 0 to 1e-60 (cases 08, 13, 17, 20, 22).
- *Node interval as stated.* The trimming fallback never fires (`attempts` all 0), so the nodes lie on exactly the interval printed in the title.

**Are the reference values right?** The "reference" is f itself, drawn on a 1000-point grid from Julia's Base and SpecialFunctions: `sqrt`, `log`, `tan`, `gamma`, `besselj`, `bessely`, `erf`. In `indep.py` each case's f is coded independently in mpmath, using the formula from the Mathews formula image, and the node values agree, as the ~1e-12 polynomial agreement implies. The functions in the table match the page captions and the Mathews formulas for all 29 rows. normal_pdf is exp(−x²/2)/√(2π) and normal_cdf is ½+½erf(x/√2), as in the archive.

**Does the picture show what was computed?** I viewed all 29 contact sheets, plus case 08's final frame and a zoom of case 26 frame 1 at full size.
- Every title states the case id, the function label (equal to the coded f) and the interval (equal to the node span). It also gives n, which equals the number of red markers, and "degree ≤ n−1".
- Red markers lie on the magenta f curve, and the blue interpolant passes through every one of them in every frame inspected.
- `nodes_in_ylims = true` for every (case, n), so no node is ever off-screen.
- *Display devices:*
  - The y-window comes from f (quantiles widened to include f on the span).
  - The interpolant is clamped to a band one window-height beyond the limits. It therefore runs off the frame rather than along the edge, and no clamped value is labelled or presented as real.
  - f is broken with NaN at the poles in cases 01, 02 and 14, and no false join across a pole is drawn.
  - Case 03 (double pole at x = 1, not in `poles`) has both branches → +∞, so any join lies above the window and is invisible.
  - Gamma cases 24–26 show no vertical join at x = 0 (checked on the zoom).
  - Outside f's domain (log, sqrt, asin, 1/sqrt(1−x), Y0 at 0) f is NaN and simply not drawn.
  - The extrapolated blow-up outside the span (e.g. cases 04, 09, 28, 29) is real polynomial behaviour, correctly computed (verified above), and the title states the interval.

  None of these devices changes what a viewer would conclude.
- *Frame counts:* 10 per case and 14 for case 08 (manifest, `instr.out`), matching the page.

**Regeneration:** a scratch copy reproduces all 29 committed GIFs byte-identically (manifest), so the frames reviewed are the output of the script reviewed.

