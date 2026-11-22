# Richardson Extrapolation — animation review (round 5)

Page: `pages/numerical-methods/richardson-extrapolation/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page, every computed value and every reference value checked out against independent computation. Non-findings that I considered and rejected are listed at the end of section 3.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `richexaa.jl` | 0 | 8.0 | richexaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `richexab.jl` | 0 | 7.5 | richexab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `richexaa.gif` | 9 | byte-identical | richexaa |
| `richexab.gif` | 12 | byte-identical | richexab |

### Page references

- Scripts linked: `richexaa.jl`, `richexab.jl`
- GIFs embedded: 2
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | Description | "Richardson extrapolation combines two finite-difference estimates with different step sizes so that the leading truncation term cancels." | `indep3.py`: D3 error on x^3 is h^2, D5 error on x^3 is 0 | confirmed |
| 2 | Description | legacy module presents it "as a refinement of the central three-point derivative for $f(x)=e^{-x}\sin(x)$ over $[0,\pi]$" | Legacy main page / Ex 1–5 use f = e^{-x} sin x on [0, π] | confirmed |
| 3 | Description | $D_3(x,h)=\frac{f(x+h)-f(x-h)}{2h}$ | matches `d3` in both scripts (line 12 / 11) | confirmed |
| 4 | Description | $D_5(x,h)=\frac{4D_3(x,h/2)-D_3(x,h)}{3}$ | matches `d5` in both scripts (line 13 / 12) | confirmed |
| 5 | Description | upgrades truncation "from $O(h^2)$ to $O(h^4)$ for smooth functions" | `indep3.py`: D5 exact for x^0..x^4, error −h^4/4 on x^5; measured slopes 2.000 and 3.99–4.00 (Case 2 table) | confirmed |
| 6 | Animations intro | "Each animation below compares the base central difference with Richardson extrapolation for the legacy test function and interval." | Both scripts use f = e^{-x} sin x; Case 1 on [0, π]; Case 2 at x0 = 1 ∈ [0, π] | confirmed |
| 7 | Animations intro | "Case 2 plots the error of the estimate in the legacy module's Example 8" | Legacy Ex 8: five-point central formula for f'(1.0) of e^{-x} sin x; Case 2 plots \|D5(1,h) − f'(1)\| | confirmed |
| 8 | Animations intro | "$D_5(x,h)$ is that example's five-point formula for $f'$ with spacing $h/2$" | `indep3.py`: D5(x,h) ≡ [f(x−2k)−8f(x−k)+8f(x+k)−f(x+2k)]/(12k), k = h/2 (sympy simplify = 0). Numeric: Mathews Ex 8 h=0.1 → −0.110795226; script d5(1, 0.2) = −0.110795226415 | confirmed |
| 9 | Animations intro | "evaluated here over a different list of step sizes" | Ex 8: H = {0.5,0.2,0.1,0.05,0.02,0.01}; script hs = [0.5,…,0.0015] (12 values) | confirmed |
| 10 | Animations intro | "Examples 9–10 … use five-point central-difference formulas to approximate the second and third derivatives at the same point, are not animated here" | Legacy Ex 9: f''(1.0), Ex 10: f'''(1.0), five-point stencils; neither script does this | confirmed |
| 11 | Animations intro | "neither are the pictures that Examples 8–10 draw: the five stencil points with a line, parabola or cubic through the centre point" | Legacy Ex 8 draws g = f(X)+d1(x−X) (line), Ex 9 quadratic, Ex 10 cubic, plus the 5 stencil points; not in either GIF | confirmed |
| 12 | Animations intro | "Examples 1, 3, 4 and 5 estimate $M_5=\max\|f^{(5)}\|$ on $[0,\pi]$ from a graph of $f^{(5)}$, check the resulting five-point error bound against the actual error, show the bound's $O(h^4)$ scaling, and compare it with the three-point bound" | Legacy images: Ex 1 M5 = max_{0≤x≤π}\|f^(5)\|; Ex 3 plots \|f' − Dfive[x,0.01]\| vs EBfive; Ex 4 EBfive[h/2] = EBfive[h]/16; Ex 5 EBthree vs EBfive | confirmed |
| 13 | Animations intro | "Case 1 annotates the actual maximum errors instead" | `richexaa.jl` l.28–29, 52–56; annotation visible in every frame | confirmed |
| 14 | Case 1 heading | "profile comparison, $D_3(x,h)$ vs. $D_5(x,h)$" | Frames show f', D3, D5 curves over [0, π] | confirmed |
| 15 | Case 1 Behavior | "Both approximations converge as $h$ shrinks" | max\|err D3\|: 8.13e-2 → 3.33e-5; max\|err D5\|: 5.29e-4 → 8.33e-11, monotone (table below) | confirmed |
| 16 | Case 1 Behavior | "the Richardson curve tracks $f'(x)$ much more closely" | D5 max error is 150× (h=0.5) to 4×10^5× (h=0.01) smaller than D3's | confirmed |
| 17 | Case 1 Behavior | "because the dominant $h^2$ error term is canceled" | `indep3.py` | confirmed |
| 18 | Case 1 link | `[Julia source](richexaa.jl)` → profile comparison | script contents match heading | confirmed |
| 19 | Case 1 embed/alt | "Animation comparing D3 and Richardson D5 derivative curves against the true derivative over 0 to pi for decreasing h." | Frames 1, 5, 9 viewed; h decreasing 0.5 → 0.01 | confirmed |
| 20 | Case 2 heading | "pointwise convergence at $x_0=1$ on log-log axes" | `x0 = 1.0`, `xaxis=:log, yaxis=:log` | confirmed |
| 21 | Case 2 Behavior | "error slope for the three-point formula follows approximately $O(h^2)$" | successive slopes 2.007, 2.003, 2.001, 2.000 … 2.000 | confirmed |
| 22 | Case 2 Behavior | "Richardson extrapolation follows approximately $O(h^4)$ before roundoff effects appear" | slopes 3.905, 3.963, 3.986, 3.995, 3.998, 3.999, 4.000, 3.999, 3.987 down to h = 0.006; then 4.823, 1.721. Double-precision errors at h = 0.003 / 0.0015 are 4.26e-14 / 1.29e-14 vs true truncation 7.48e-14 / 4.67e-15 (mpmath, 50 digits), so roundoff is visible in exactly the last two points, as stated; frame 12 shows the flattening | confirmed |
| 23 | Case 2 link | `[Julia source](richexab.jl)` → pointwise case | script contents match heading | confirmed |
| 24 | Case 2 embed/alt | "log-log error curves versus h at x0 equals 1 showing second-order and fourth-order convergence trends" | Frames (sheet + frame 12) | confirmed |
| 25 | Derivation Notes | if $D_3=f'+C_2h^2+C_4h^4+\cdots$ then $\frac{4D_3(x,h/2)-D_3(x,h)}{3}=f'+O(h^4)$ "because the $C_2h^2$ contribution cancels exactly" | D3 has only even powers (central difference); 4·C2(h/2)^2 − C2h^2 = 0; leftover −C4h^4/4, matching sympy on x^5 (C4 = 1 → −h^4/4) | confirmed |

### 3. Implementation checks

### `richexaa.jl` (Case 1)

*Method.* `d3` is the central three-point difference; `d5 = (4 d3(x,h/2) − d3(x,h))/3` is one Richardson step, algebraically identical to the standard five-point central formula with spacing h/2 (sympy, `indep3.py`). This is the variant the page describes; Mathews writes the same formula with spacing h as (4 Dthree(x,h) − Dthree(x,2h))/3, and the page states the h/2 relation explicitly.

*Reference.* `fp(x) = e^{-x}(cos x − sin x)`; sympy confirms it equals d/dx[e^{-x} sin x].

*Numbers.* Script (instrumented copy) vs independent mpmath at 50 digits (`indep.py`, own five-point formula, on the script's 800-point grid and on a 5001-point grid):

| h | script max\|e3\| | indep. | script max\|e5\| | indep. |
|---|---|---|---|---|
| 0.5 | 8.1277e-02 | 8.128e-02 | 5.2853e-04 | 5.285e-04 |
| 0.32 | 3.3786e-02 | 3.379e-02 | 8.7912e-05 | 8.791e-05 |
| 0.2 | 1.3280e-02 | 1.328e-02 | 1.3365e-05 | 1.337e-05 |
| 0.12 | 4.7931e-03 | 4.793e-03 | 1.7295e-06 | 1.729e-06 |
| 0.08 | 2.1320e-03 | 2.132e-03 | 3.4146e-07 | 3.415e-07 |
| 0.05 | 8.3312e-04 | 8.331e-04 | 5.2091e-08 | 5.209e-08 |
| 0.03 | 2.9997e-04 | 3.000e-04 | 6.7504e-09 | 6.750e-09 |
| 0.02 | 1.3333e-04 | 1.333e-04 | 1.3334e-09 | 1.333e-09 |
| 0.01 | 3.3333e-05 | 3.333e-05 | 8.3334e-11 | 8.333e-11 |

The 800-point grid gives the same maxima as the dense grid to 4 digits (maxima occur at or next to x = 0). Frame annotations (8.13e-02 / 5.29e-04, 2.13e-03 / 3.41e-07, 3.33e-05 / 8.33e-11 in frames 1, 5, 9) agree. Halving h from 0.02 to 0.01 cuts the D3 max error by 4.00 and the D5 max error by 16.0, as O(h^2) and O(h^4) require. Cross-check with the archive: my five-point formula reproduces Mathews Ex 2(a) Dfive[x, 0.1] at x = 0, 1, 2, 3 (1.0000134, −0.11079523, −0.17938176, −0.056315528) exactly.

*Picture.* f' black, D3 dashed blue, D5 orange, built from `fp`, `d3`, `d5` at the plotted grid; legend formula matches the code; title h is the D3 step. y-limits (−1, 1.1) contain every curve (D3 max 1.0812 at h = 0.5). No clamping or masking. 9 frames = 9 step sizes. From h ≈ 0.12 on, all three curves overlap at plot resolution, so the frame-to-frame difference is carried by the error annotation. That is a teaching-design observation, not a finding: the annotation reports the right values and nothing drawn is wrong.

### `richexab.jl` (Case 2)

*Method.* Same `d3`/`d5` as Case 1, evaluated at x0 = 1.

*Reference.* f'(1) = −0.11079376530669924 (script) vs −0.11079376530669925782 (mpmath).

*Numbers.* Script (double) vs mpmath 50-digit truncation error (`indep2.py`):

| h | script e3 | indep. e3 | script e5 | indep. e5 |
|---|---|---|---|---|
| 0.5 | 4.257869e-02 | 4.257869e-02 | 5.375918e-05 | 5.375918e-05 |
| 0.32 | 1.738872e-02 | 1.738872e-02 | 9.410393e-06 | 9.410393e-06 |
| 0.2 | 6.783537e-03 | 6.783537e-03 | 1.461109e-06 | 1.461109e-06 |
| 0.12 | 2.440728e-03 | 2.440728e-03 | 1.906987e-07 | 1.906987e-07 |
| 0.08 | 1.084580e-03 | 1.084580e-03 | 3.775150e-08 | 3.775150e-08 |
| 0.05 | 4.236281e-04 | 4.236281e-04 | 5.766570e-09 | 5.766569e-09 |
| 0.03 | 1.525008e-04 | 1.525008e-04 | 7.476736e-10 | 7.476741e-10 |
| 0.02 | 6.777739e-05 | 6.777739e-05 | 1.477083e-10 | 1.477089e-10 |
| 0.01 | 1.694424e-05 | 1.694424e-05 | 9.238929e-12 | 9.232562e-12 |
| 0.006 | 6.099917e-06 | 6.099917e-06 | 1.205230e-12 | 1.196561e-12 |
| 0.003 | 1.524978e-06 | 1.524978e-06 | 4.259093e-14 | 7.478561e-14 |
| 0.0015 | 3.812445e-07 | 3.812445e-07 | 1.292022e-14 | 4.674109e-15 |

The two columns agree to all shown digits until roundoff enters D5 at the last two step sizes. Asymptotic constants: e3 ≈ |f'''(1)|/6 · h^2 = 0.16944 h^2 (script guide c2 = 0.17031); e5 ≈ |f^(5)(1)|/480 · h^4 = 9.23e-4 h^4 (script guide c4 = 8.60e-4). The guide lines are anchored at the h = 0.5 point and sit on the data, as they should. Archive cross-check: Mathews Ex 8 gives −0.110795226 for stencil 0.1 and the script gives d5(1, 0.2) = −0.110795226415.

*Picture.* Log-log axes; blue circles = e3, orange diamonds = e5, dashed = c2 h^2, dotted = c4 h^4, guides drawn over the plotted h range. 12 frames = 12 step sizes, one point added per frame. Frame 12 shows the D5 curve leaving the h^4 guide at the last two points (roundoff), consistent with the page. The axes autoscale each frame, so early frames have fractional-exponent tick labels (e.g. 10^-0.50). That is cosmetic and nothing is mis-shown. Frame 1 shows a single point per series and degenerate guides, which is unremarkable.

### Fidelity to the legacy archive

- Function, interval and point match the archive: e^{-x} sin x on [0, π] (Ex 1–5) and x = 1.0 (Ex 7–10).
- Case 1 contains Mathews Ex 2(b)'s curve: his Dfive[x, 0.01] is the page's D5(x, 0.02), which is frame 8. It adds D3 and other step sizes.
- Case 2 contains Mathews Ex 8's estimate (with the h/2 relation stated) and also Ex 7's Richardson combination (4 Dthree[1,0.01] − Dthree[1,0.02])/3, which is the page's D5(1, 0.02), the h = 0.02 point.
- The page explicitly lists what is not animated: Ex 1, 3, 4, 5, 9, 10 and the Ex 8–10 stencil pictures. It does not mention Ex 2(a) (a table at x = 0..3), Ex 6 (a general proof, which the Derivation Notes cover) or Ex 7 by name, but their content is either a table/proof or already inside Case 2. I do not regard this as a silent drop that matters to a reader, so it is not a finding.
- The archive's Ex 1 page text says "third derivative" while its solution works with f^(5). The page follows the solution (M5). That is correct.

### Considered and rejected as findings

- Case 1 curves become visually indistinguishable from h ≈ 0.12 on; the claim "tracks much more closely" is carried by the numeric annotation. The annotation is correct, so this is a teaching-design matter.
- Case 2 per-frame autoscaling and fractional log tick labels are cosmetic.
- The Animations intro says "for the legacy test function and interval", while Case 2 is pointwise at x0 = 1. The point lies in the interval and the Case 2 heading states it, so the wording is accurate enough.

