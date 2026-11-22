# Numerical Differentiation — animation review (round 3)

Page: `pages/numerical-methods/numerical-differentiation/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I found no errors, no misleading statements and no fidelity departures that matter.

Observations that are not findings:

- In `numdiffaa.gif`, from frame 4 (h = 0.1) onward the D3 curve and the f′ curve can't be told apart at this scale. Only the title's max-error value changes in frames 4–12. The page's claim ("approaches f′(x) as h shrinks, consistent with second-order truncation error") is still supported, because frames 1–3 show the gap closing and the titles show the h² decay (for example, 3.33e-03 → 3.33e-05 → 3.33e-07 for h = 0.1, 0.01, 0.001). This is a teaching-presentation choice, not an error.
- `numdiffab.jl` lines 26–28 skip a frame through `continue` if the stencil leaves [0, π]. No h in the list triggers this (largest h = 0.6 gives [0.4, 1.6]), so all 12 frames are drawn. It is dead code.
- Mathews' notation for the formula is `D1[x,h]`. The page calls it `D_3(x,h)`, meaning "three-point". This is a notation difference only.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `numdiffaa.jl` | 0 | 7.5 | numdiffaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `numdiffab.jl` | 0 | 7.4 | numdiffab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `numdiffaa.gif` | 12 | byte-identical | numdiffaa |
| `numdiffab.gif` | 12 | byte-identical | numdiffab |

### Page references

- Scripts linked: `numdiffaa.jl`, `numdiffab.jl`
- GIFs embedded: 2
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | Description ¶1 | "In the Mathews examples for this module, the test function is $f(x)=e^{-x}\sin(x)$ on $[0,\pi]$" | Legacy formula images G27 (`f[x] = e^-x Sin[x]`) and G49/G51/G92 (`[0, π]`). Examples 9–17 use the same f (G220…G388). | confirmed |
| 2 | Description ¶1 | "with representative steps $h=0.1,0.01,0.001$" | Legacy G45 `h = 0.1, 0.01, 0.001` and G47 (Example 2). | confirmed |
| 3 | Description formula | $D_3(x,h)=\frac{f(x+h)-f(x-h)}{2h}$ is the three-point central approximation | Legacy G4 is the same formula. `numdiffaa.jl:12` and `numdiffab.jl:34` implement exactly this. | confirmed |
| 4 | Description | "with truncation error $O(h^2)$ when $f$ is sufficiently smooth" | Independent computation: err/h² at x0 = 1 tends to 0.169442 = f‴(1)/6 (table in §3). Max-error ratio is exactly 100 per decade of h. | confirmed |
| 5 | Description | "As $h$ decreases, truncation error improves, but eventually roundoff and cancellation can limit accuracy." | A general true statement. The page doesn't claim the animations show roundoff, and they don't: at h = 0.001 the roundoff is about 1e-13, far below the truncation error of 3.3e-7. | confirmed (general statement, not tied to an animation) |
| 6 | Animations intro | "Each animation below shows finite-difference derivative behavior for $f(x)=e^{-x}\sin(x)$" | Both scripts, line 9: `f(x) = exp(-x) * sin(x)`. | confirmed |
| 7 | Animations intro | "on legacy interval settings from the source module" | Case 1 uses [0, π], as in legacy Examples 2c and 3. Case 2 uses x0 = 1, as in legacy Examples 9–17 (`f'[1.0]`) and the legacy central-difference animations at x = 1. | confirmed |
| 8 | Case 1 heading | "central derivative profile, $D_3(x,h)$ on $[0,\pi]$" | `numdiffaa.jl:12,16,21`: central3 is evaluated on a 700-point grid over (0, π). | confirmed |
| 9 | Case 1 Behavior | "The numerical derivative curve approaches $f'(x)$ as $h$ shrinks" | Script max error falls monotonically from 8.13e-02 (h = 0.5) to 3.33e-07 (h = 0.001). Frames 1–3 show the visible gap closing. | confirmed |
| 10 | Case 1 Behavior | "consistent with second-order truncation error for the central stencil" | Max error equals h²/3 = h²·f‴(0)/6 for h ≤ 0.1, with f‴(0) = 2 (table in §3). Halving or decimating h gives the factor h². | confirmed |
| 11 | Case 1 link / embed | `[Julia source](numdiffaa.jl)`, `![...](numdiffaa.gif)` | `numdiffaa.jl` writes `numdiffaa.gif`. The regenerated GIF and my instrumented copy's GIF are byte-identical to the committed one. | confirmed |
| 12 | Case 1 alt text | "comparing the three-point central derivative approximation against the true derivative over 0 to pi as h decreases" | Frames: black f′(x) and blue D3(x,h) on [0, π]; h runs 0.5 → 0.001. | confirmed |
| 13 | Case 2 heading | "secant to tangent at $x_0=1$, $h \to 0$" | `numdiffab.jl:12` sets `x0 = 1.0`; hs runs 0.6 → 0.001. In the last frame the chord and tangent coincide. | confirmed |
| 14 | Case 2 Behavior | "The slope from the symmetric secant $(f(x_0+h)-f(x_0-h))/(2h)$ converges to the tangent slope $f'(x_0)$ as the stencil contracts." | msec runs −0.049354 → −0.110794 (6 dp) against true −0.110793765. The error falls as h² (table in §3). | confirmed |
| 15 | Case 2 link / embed | `numdiffab.jl`, `numdiffab.gif` | The script writes that GIF, byte-identical to the committed one. | confirmed |
| 16 | Case 2 alt text | "central secant lines through the points at x0 minus h and x0 plus h collapsing to the tangent line at x0 equals 1 for f of x equals e to the minus x times sine x" | `numdiffab.jl:38`: the chord passes through (x0−h, f) and has slope msec. My check that it passes through (x0+h, f(x0+h)) gave residual 0 or 2.8e-17 in every frame. The red line is the true tangent at (1, f(1)). | confirmed |
| 17 | Frame titles, numdiffaa | "h = …, max error ≈ …" (12 values) | All 12 match my independent mpmath computation at 3 significant figures (§3). | confirmed |
| 18 | Frame titles, numdiffab | "secant slope ≈ …, true = −0.110794" (12 values) | All 12 match mpmath at 6 dp. They also match Mathews' printed values: h = 0.1 gives −0.109099, h = 0.05 gives −0.11037, h = 0.02 gives −0.110726, h = 0.01 gives −0.110777 (legacy G336/G339/G342/G345); and h = 0.6 gives −0.049354, h = 0.4 gives −0.083592 (legacy animation frames). | confirmed |
| 19 | Frame legends | numdiffab: "central secant (chord through x0 ± h)", "true tangent", "stencil points". numdiffaa: "f'(x)", "D3(x,h)". | Each label matches the series it is attached to in code and in the frames. | confirmed |
| 20 | Post-case note | "forward- and backward-difference formulas for the first derivative (Examples 9, 10, 12 and 13) ... are not animated here" | Legacy text: Ex 9 is two-point forward, Ex 10 two-point backward, Ex 12 three-point forward, Ex 13 three-point backward. | confirmed |
| 21 | Post-case note | "its formulas for the second derivative (Project II, Examples 5–8, and Examples 15–17) are not animated here" | Legacy text: Project II covers the second-derivative formula (Examples 5–8). Examples 15–17 are second-derivative forward, backward and central. | confirmed |
| 22 | Derivation Notes | $f(x\pm h) = f(x) \pm h f'(x) + \frac{h^2}{2}f''(x) \pm \frac{h^3}{6}f^{(3)}(\xi_\pm)$ | This is the Taylor expansion with Lagrange remainder of order 3, and it is correct. Subtracting the two expansions gives D3 − f′ = h²/12·(f‴(ξ+) + f‴(ξ−)), which is O(h²). That agrees with the measured err/h² → f‴(1)/6. | confirmed |
| 23 | Derivation Notes | "leads to the central three-point first-derivative rule with error proportional to $h^2$" | Same as #4 and #22. | confirmed |
| 24 | Section index | Page linked from the numerical-methods index | `pages/numerical-methods/index.qmd:91` has `[Numerical Differentiation](numerical-differentiation/)`. | confirmed |

Fidelity to the legacy archive:
- **Case 1** matches Mathews Project I (Examples 2c and 3): f on [0, π], D1 compared with f′, maximum error at x = 0. The page animates over h rather than fixing h = 0.01, which is a legitimate extension.
- **Case 2** matches Mathews Examples 11 and 14 (central difference at x = 1.0) and the legacy animation "Central Difference Formula of Order O(h²), Module 2" (`CentralDfaa.gif`). That animation draws the chord through x0 ± h, which is what the page draws. The legacy "Module 1" variant (`CentralD1faa.gif`, and the Example 14 graphs) instead draws the line through (x0, f(x0)) with slope m, plus the interpolating parabola. The page follows Module 2, a valid choice.
- The legacy h sequence (1.0, 0.8, 0.6, 0.4, 0.2, 0.08, …, 0.001) differs from the page's sequence (0.6, 0.4, …, 0.001). This makes no difference to a reader.
- Could not determine: the formula images for Example 11's solution (`gr_264`–`gr_282`) are missing from the archive. Example 11's exact formula is therefore unseen. Both legacy central-difference animations show the same (f(x+h) − f(x−h))/(2h) values, so it is almost certainly the same formula. The page makes no claim specific to Example 11.

### 3. Implementation checks

Commands run:
- Instrumented copies: `review/inst/numdiffaa_inst.jl` and `review/inst/numdiffab_inst.jl`. These add print statements only and write their GIFs into the scratch folder. Both produced GIFs byte-identical to the committed ones (`cmp` reported identical).
- Independent check: `/usr/bin/python3 -I review/indep.py`. It uses sympy for the derivatives, mpmath at 40 digits for D3 and the errors, and scipy plus a dense grid for the continuous maximum.

### `numdiffaa.jl` (Case 1)

- **The method it claims to be.** Yes. `central3(x,h) = (f(x+h) - f(x-h)) / (2h)` is the three-point central difference. It is evaluated directly; there is no hidden smoothing.
- **Reference values.** The script's `fp(x) = exp(-x)*(cos x − sin x)`. Sympy gives f′ = √2·e^{−x}·cos(x + π/4), and the difference simplifies to 0, so the reference is exact. f‴ = 2√2·e^{−x}·sin(x + π/4), with f‴(0) = 2.
- **The numbers.**

| h | Script max err (700-pt grid) | Location | mpmath, 700-pt grid | mpmath, continuous max | h²·f‴(0)/6 = h²/3 | Title |
|---|---|---|---|---|---|---|
| 0.5 | 0.0812767 | x = 0.027 | 8.127671e-02 | 8.127702e-02 | 8.33e-02 | 8.13e-02 |
| 0.3 | 0.0297313 | x = 0.009 | 2.973127e-02 | 2.973127e-02 | 3.00e-02 | 2.97e-02 |
| 0.2 | 0.0132801 | x = 0.0045 | 1.328011e-02 | 1.328011e-02 | 1.333e-02 | 1.33e-02 |
| 0.1 | 3.3300e-03 | x = 0 | 3.329998e-03 | 3.330002e-03 | 3.333e-03 | 3.33e-03 |
| 0.07 | 1.6325e-03 | 0 | 1.632533e-03 | same | 1.633e-03 | 1.63e-03 |
| 0.05 | 8.3312e-04 | 0 | 8.331250e-04 | same | 8.333e-04 | 8.33e-04 |
| 0.03 | 2.9997e-04 | 0 | 2.999730e-04 | same | 3.000e-04 | 3.00e-04 |
| 0.02 | 1.3333e-04 | 0 | 1.333280e-04 | same | 1.333e-04 | 1.33e-04 |
| 0.01 | 3.3333e-05 | 0 | 3.333300e-05 | same | 3.333e-05 | 3.33e-05 |
| 0.005 | 8.3333e-06 | 0 | 8.333312e-06 | same | 8.333e-06 | 8.33e-06 |
| 0.002 | 1.3333e-06 | 0 | 1.333333e-06 | same | 1.333e-06 | 1.33e-06 |
| 0.001 | 3.3333e-07 | 0 | 3.333333e-07 | same | 3.333e-07 | 3.33e-07 |

The script agrees with the independent computation to all printed digits. The 700-point grid does not under-report the true maximum at 3 significant figures. The order-2 property holds: the error equals h²·f‴(0)/6 to leading order, and the maximum sits at x = 0 for h ≤ 0.1, as Mathews' Example 3(b) says.
- **The picture.** Frame 1 (h = 0.5) shows D3(0) ≈ 1.081 inside ylims (−1, 1.1), so nothing is clipped. The black curve is f′ and the blue curve is D3, with legend entries to match. The title's h and max error are taken from the same loop iteration. The axis window covers the whole interval the page names. No clamping or masking is used. f is evaluated at x ± h outside [0, π], which is legitimate because f is entire; the comment on line 23 says so.

### `numdiffab.jl` (Case 2)

- **The method it claims to be.** Yes. `msec = (f(x0+h) − f(x0−h))/(2h)` at x0 = 1.
- **Reference values.** f′(1) = −0.110793765306699 (mpmath), and the script's `mtan` is −0.11079376530669924. f(1) = 0.309559875653112 agrees with the script's y0.
- **The numbers.**

| h | Script msec | mpmath D3 | Title (6 dp) | err = D3 − f′(1) | err/h² |
|---|---|---|---|---|---|
| 0.6 | −0.04935374267500 | −0.049353742675 | −0.049354 | 6.144e-02 | 0.170667 |
| 0.4 | −0.08359181012485 | −0.0835918101248 | −0.083592 | 2.720e-02 | 0.170012 |
| 0.25 | −0.10018941138993 | −0.10018941139 | −0.100189 | 1.060e-02 | 0.169670 |
| 0.15 | −0.10697945995888 | −0.106979459959 | −0.106979 | 3.814e-03 | 0.169525 |
| 0.1 | −0.10909897684773 | −0.109098976848 | −0.109099 | 1.695e-03 | 0.169479 |
| 0.07 | −0.10996341095255 | −0.109963410953 | −0.109963 | 8.304e-04 | 0.169460 |
| 0.05 | −0.11037013724894 | −0.110370137249 | −0.110370 | 4.236e-04 | 0.169451 |
| 0.03 | −0.11064126452006 | −0.11064126452 | −0.110641 | 1.525e-04 | 0.169445 |
| 0.02 | −0.11072598791772 | −0.110725987918 | −0.110726 | 6.778e-05 | 0.169443 |
| 0.01 | −0.11077682107024 | −0.11077682107 | −0.110777 | 1.694e-05 | 0.169442 |
| 0.005 | −0.11078952925451 | −0.110789529255 | −0.110790 | 4.236e-06 | 0.169442 |
| 0.001 | −0.11079359586472 | −0.110793595865 | −0.110794 | 1.694e-07 | 0.169442 |

err/h² tends to f‴(1)/6 = 0.169442, which confirms the method is second order. Every title value is correctly rounded. They also agree with the values Mathews printed (Example 14 and the legacy animation frames).
- **The picture.** The dashed chord, `yl + msec·(x − xl)`, passes through both stencil endpoints: the residual at xr is 0 or 2.8e-17 in every frame. The red line is `f(x0) + f′(x0)(x − x0)`, the true tangent. The three orange markers sit at x0 − h, x0 and x0 + h on the curve. In frame 1 the chord crosses the curve at x = 0.4 and x = 1.6, and the tangent touches it at (1, 0.310), as the code predicts. The line segments span [0.1, 1.9] and stay inside ylims (−0.1, 0.55). The legend at the upper right covers no data. In the last frame (h = 0.001) the chord and the tangent coincide, as claimed. The guard at lines 26–28 never triggers, so all 12 frames are drawn.

