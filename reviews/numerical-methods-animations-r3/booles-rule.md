# Boole's Rule — animation review (round 3)

Page: `pages/numerical-methods/booles-rule/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Error 0, Misleading 0, Minor 0.

Every checkable claim on the page agreed with my own computation at the precision it is stated to, and every frame label agreed with the values I computed independently. Notes I considered and judged not to be findings:

- "Each animation below shows…" when there is only one animation. This is a wording slip with no effect on what a reader learns.
- "the highest-order closed Newton-Cotes rule in this set". "This set" is not defined on this page, but the site's Newton-Cotes rules are trapezoidal, Simpson 1/3, Simpson 3/8 and Boole (`newton-cotes-integration/index.qmd`), so the statement is true.
- Rounding to 6 decimals in the label drops trailing zeros ("2.01268", "2.01537"). This is cosmetic.
- The legacy GIF has 3 opening frames, repeats the n=4 frame and skips n=60. The new GIF has 1 opening frame and includes n=60. The legacy title also printed the formula for f. These are layout differences only. The function, interval, rule, node sequence and every shared approximation value match the legacy GIF to 6 decimals, so there is no Fidelity finding.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `boolesaa.jl` | 0 | 10.5 | boolesaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `boolesaa.gif` | 24 | byte-identical | boolesaa |

### Page references

- Scripts linked: `boolesaa.jl`
- GIFs embedded: 1
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Page claim (page's words) | Evidence | Verdict |
|---|---|---|---|
| D1 | "Composite Boole's rule applies a quartic interpolant on each block of four subintervals (five nodes)" | Script fits a degree-4 polynomial through 5 nodes per block (`poly_coeffs`, l.19-22, 55-57). The polynomial's exact integral equals `boole_sum` to ~1e-14 for every n (`instr.jl`, `polyint=` column) | confirmed |
| D2 | $h=(b-a)/n$ with $n$ divisible by 4 | `dx=(b-a)/n`; every n in `n_seq` is a multiple of 4 | confirmed |
| D3 | $B_n=\frac{2h}{45}\sum(7f_{4k}+32f_{4k+1}+12f_{4k+2}+32f_{4k+3}+7f_{4k+4})$ | I integrated the Lagrange basis on nodes 0..4 in sympy: weights $h\cdot[14/45, 64/45, 8/15, 64/45, 14/45] = \frac{2h}{45}[7,32,12,32,7]$. Script l.35 uses the same weights | confirmed |
| D4 | "exact for polynomials up to degree 5" | The script's formula applied to $x^p$ on [0,2], n=8: error 0 (≤4e-16) for p=0..5; 7.4e-4 for p=6; 5.2e-3 for p=7 | confirmed |
| D5 | "global error $O(h^6)$" for smooth f | Smooth test $e^x\cos x$ on [0,2]: error ratios on halving h are 63.0, 63.8, 64.0 → $2^6$ | confirmed |
| D6 | "highest-order closed Newton-Cotes rule in this set" | The site's other closed N-C rules are trapezoidal (O(h²)), Simpson 1/3 and 3/8 (O(h⁴)) | confirmed |
| A1 | $f(x)=1+e^{-x}\sin(8x^{2/3})$ on $[0,2]$ (intro and Case 1 heading) | Script l.8-9: `exp(-x)*sin(8*x^(2/3))+1`, `a,b=0,2` | confirmed |
| A2 | "After an opening frame showing only f" | Frame 1 shows only the magenta curve (loop starts at n=0) | confirmed |
| A3 | "each frame recomputes the approximation over the full interval with a denser partition where n remains a multiple of 4" | n = 4,8,…,64,72,…,120. The sequence is strictly increasing, all multiples of 4, and each frame calls `boole_sum(n)` on [0,2] | confirmed |
| A4 | "Red dots mark the sample points $x_i$" | Script l.81-82 scatters $x_i=a+ih$, i=0..n in red. Frames 2, 24 checked | confirmed |
| A5 | "vertical red lines mark the panel boundaries $x_{4k}$" | Script l.67-70 draws lines at i=0:4:n from 0 to f(x). Frame 2 (n=4) has lines only at 0 and 2. Frame 24 has 31 lines at spacing 4h | confirmed |
| A6 | "Piecewise quartic panels are rebuilt at increasing density" | Pink fills/red outlines are the per-block quartic interpolants. Nodal residuals ≤6e-14. Frames show them rebuilt each frame | confirmed |
| A7 | "the approximation increases from frame to frame toward the true integral" | mpmath values for all 23 n are strictly increasing (1.553155 → 2.015961) | confirmed |
| A8 | "staying below it" | Every $B_n$ < I (mpmath check `all below: True`) | confirmed |
| A9 | true integral "≈ 2.016280" | mpmath with substitution $x=t^3$ (smooth integrand) and an independent 40-panel split agree: I = 2.0162797196170963… | confirmed |
| A10 | "the last frame (121 sample points) gives 2.015961" | n=120: script 2.0159611788706, mpmath 2.01596117887. Frame 24 label "Sample Points = 121 / Approximation = 2.015961" | confirmed |
| A11 | "about $3.2\times10^{-4}$ low" | I − B₁₂₀ = 3.18541e-4 | confirmed |
| A12 | "$f'$ unbounded at $x=0$ ($f'(x)\approx\frac{16}{3}x^{-1/3}$ near 0)" | mpmath f'(1e-6)=533.332 vs 533.333; f'(1e-4)=114.86 vs 114.90 | confirmed |
| A13 | "measured error shrinks like $O(h^{5/3})$ rather than $O(h^6)$" | Error ratios on halving h: 3.10 (16→32), 3.17 (32→64), 3.182 (60→120), 3.180, 3.177, 3.176, 3.1755 (up to 1920). Leading singular term $x^{2/3}$ gives $h^{1+2/3}$ | confirmed |
| A14 | "halving h divides it by about 3.18 (from 60 to 120 subintervals)" | (I−B₆₀)/(I−B₁₂₀) = 3.18196 | confirmed |
| A15 | "tending to $2^{5/3}\approx3.17$, instead of $2^6=64$" | $2^{5/3}$=3.1748. Ratios continue 3.1796, 3.1774, 3.1761, 3.1755 (n=240…1920), approaching it | confirmed |
| W1 | `[Julia source](boolesaa.jl)` points to the script for Case 1 | The file exists and is the only script. It produces `boolesaa.gif` | confirmed |
| W2 | Embed `boolesaa.gif` is Case 1's GIF | The committed GIF is byte-identical to the regenerated output of `boolesaa.jl` | confirmed |
| W3 | Alt text: "Boole's Rule animation over [0,2] with full-interval density refinement: after an opening frame showing only f, each frame shows the sample points as red dots, the panel boundaries as vertical red lines, the piecewise quartic panels and the global approximation" | Frames 1, 2, 9, 24 and the contact sheet match each element. "Global approximation" is the printed value | confirmed |
| C1 | One case, 1 + 23 frames implied ("opening frame" + one per partition) | 24 frames = 1 + length(n_seq)=23 | confirmed |

### 3. Implementation checks: `boolesaa.jl`

**Method.** This is composite Boole's rule (closed 5-point Newton-Cotes) on n/4 blocks (l.26-38). It is not a variant or neighbouring method. I derived the weights independently by integrating the Lagrange basis (sympy), and they equal the script's [7,32,12,32,7]·2h/45. As a property check, the script's formula integrates $x^0..x^5$ exactly and fails on $x^6$ (error 7.44e-4 at n=8). Composite order: ratio 64.0 on a smooth function.

**Numbers.** `instr.jl` runs the script's own `boole_sum`. `indep.py` uses mpmath at 30 digits with independently derived weights. They agree to ≥11 digits for all 23 n:

| n | pts | script | independent (mpmath) | error I−B |
|---|---|---|---|---|
| 4 | 5 | 1.5531546827 | 1.55315468274 | 4.631e-1 |
| 8 | 9 | 1.9634127276 | 1.96341272761 | 5.287e-2 |
| 12 | 13 | 2.0012951727 | 2.00129517274 | 1.498e-2 |
| 16 | 17 | 2.0073277270 | 2.00732772703 | 8.952e-3 |
| 24 | 25 | 2.0116443222 | 2.01164432216 | 4.635e-3 |
| 32 | 33 | 2.0133926437 | 2.01339264373 | 2.887e-3 |
| 48 | 49 | 2.0148087832 | 2.01480878325 | 1.471e-3 |
| 60 | 61 | 2.0152661372 | 2.01526613719 | 1.014e-3 |
| 64 | 65 | 2.0153696865 | 2.01536968654 | 9.100e-4 |
| 96 | 97 | 2.0158173622 | 2.01581736224 | 4.624e-4 |
| 120 | 121 | 2.0159611789 | 2.01596117887 | 3.185e-4 |

(all 23 rows are in `instr.jl` / `indep.py` output and agree)

**Reference value.** The script draws no exact reference. The page's 2.016280 was checked by two mpmath quadratures, one after the substitution $x=t^3$ that removes the singularity: 2.01627971961709632788…

**Picture.** I read frames 1, 2 and 24 at full size, the 12-frame contact sheet, and a crop of the label region of all 24 frames (`committed_labels.png`). Every "Sample Points" and "Approximation" label equals n+1 and round(B_n, 6) from my independent table. The drawn quartics are built from the 5 nodes of each block (nodal residual ≤ 6e-14). The area under them equals the printed approximation (exact polynomial integral vs `boole_sum` agree to 1e-14), so the shaded area is the quantity reported. Divider lines are at $x_{4k}$ from 0 up to f, which is where the interpolants meet f. Display range: the interpolants span 0.124 to 1.931 over all frames and f peaks at 1.920, inside ylims (0, 2.1). Nothing is clipped. xlims (−0.03, 2.03) keep the end dots visible. The title "Boole's Rule / Numerical Quadrature" names the method correctly, and there is no legend.

**Legacy comparison.** Mathews' `Booleaa.gif` uses the same f, interval and rule, with sample points 5, 9, …, 57, 65, 73, …, 121. Its approximations (e.g. 1.553155, 2.001295, 2.012680, 2.015370, 2.015961) match the new GIF to 6 decimals at every shared n. The module page's Examples 1–6 are worked numeric examples, not animations. The page's "Worked Example (Planned)" placeholder is out of scope.

