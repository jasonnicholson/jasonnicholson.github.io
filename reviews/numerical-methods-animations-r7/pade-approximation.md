# Padé Approximation — animation review (round 7)

Page: `pages/numerical-methods/pade-approximation/`. Reported findings: **0 Error, 0 Misleading, 2 Minor**.

## Findings

### F1. Implementation (picture), Minor: 21 frames draw a true pole as a short finite spike

- **Location:** `pade_animations_all.jl` line 452 (fixed 900-point grid) and lines 465-473 (evaluation on that grid only). Example frames: `pade25.gif` frame 2, `pade24.gif` frame 25, `pade26.gif` frame 25.
- **What is there now:** when a pole has a small residue, the grid points on either side of it are not close enough for the curve to reach the top or bottom of the axes. The line joining those two samples appears as a short tick. In Case 25 [0/1] the blue curve spans only y = -1.02 to 1.02 in a window of [-2, 2]. In Case 26 [3/3] it spans -0.45 to 0.29 and looks like a glitch on the curve. In Case 24 [3/3] the upper branch stops at y = 20.6 in a window reaching 45.
- **What is true instead:** each of these approximants has a simple pole at the stated x and is unbounded there. The page's Description presents vertical asymptotes as a defining feature of rational functions, so a bounded-looking blip gives the wrong picture in those frames. The severity is Minor because this affects 21 of 1614 frames, the location of each spike is correct, and most poles (529 of 567) are drawn reaching the axes.
- **How I know:** `/usr/bin/python3 -I $R/indep/poles.py $R` and `$R/indep/more.py $R` find the real roots of each denominator inside the window and read the plotted samples on each side.
  - 444 frames contain 567 real poles in the window.
  - 38 poles have at least one neighbouring sample still inside the y-window.
  - 21 of the 38 are visible (sample jump at least 2% of the y-span). The other 17 are near-cancelling pole-zero pairs (residues as small as 2.5e-15) that no reasonable plot would show.

| Case | [m/n] | Frame | Pole x | Sample left | Sample right |
|---|---|---:|---:|---:|---:|
| 14 | [2/3] | 18 | -0.783 | 11.00 | -2.35 |
| 14 | [1/9] | 57 | 1.692 | -11.22 | 3.79 |
| 22 | [5/2] | 34 | 2.300 | 13.15 | -1.50 |
| 22 | [3/5] | 40 | 2.603 | 8.44 | -9.97 |
| 23 | [1/2] | 8 | 0.985 | -55.00 (clamped) | 25.97 |
| 23 | [7/1] | 44 | 0.644 | -9.04 | 12.75 |
| 24 | [1/3] | 12 | 1.841 | -9.56 | 30.84 |
| 24 | [3/3] | 25 | 1.221 | -19.72 | 20.58 |
| 24 | [5/2] | 34 | 4.463 | -48.67 | 29.98 |
| 25 | [0/1] | 2 | 9.776 | -1.02 | 1.02 |
| 25 | [0/3] | 7 | 9.777 | -0.45 | 0.56 |
| 25 | [2/1] | 9 | 9.630 | 0.22 | 0.08 |
| 25 | [0/5] | 16 | 9.777 | -0.28 | 0.40 |
| 25 | [0/7] | 29 | 9.777 | -0.19 | 0.32 |
| 25 | [2/5] | 31 | 8.982 | 0.66 | 0.23 |
| 26 | [3/1] | 14 | 4.081 | 0.48 | -1.55 |
| 26 | [3/3] | 25 | 3.714 | 0.29 | -0.45 |
| 26 | [3/5] | 40 | 3.222 | 0.55 | -0.12 |
| 27 | [1/1] | 5 | 1.620 | 3.49 | -0.25 |
| 27 | [1/3] | 12 | 1.126 | 6.00 (clamped) | -1.31 |
| 27 | [5/1] | 27 | 0.559 | 1.01 | -6.00 (clamped) |

- **Suggested correction (not applied or tested):** in `render_case`, for each real root `r` of `q` inside the window, compute the residue `res = p(r)/q'(r)`. If `|res|` is above a small threshold such as 1e-6, add samples at `r ± |res|/(2*yspan)` to that frame's x-grid, where the approximant is about two y-spans off-centre and therefore off-screen, and put a `NaN` at `r`. Both branches then leave the frame and the connecting segment across the pole disappears.

- **Independent check:** not run (Minor finding, unverified)

### F2. Fidelity, Minor: the Mathews convergence-interval display and higher orders are dropped without saying so

- **Location:** `index.qmd` line 86, "Each animation shows one Padé order per frame for a fixed center $x_0$, overlaid on the target function."; `pade_animations_all.jl` case table, `max_total` field (lines 24-50).
- **What is there now:** each GIF steps through every [m/n] with m+n up to 10 (up to 8 in Cases 12, 17 and 22-27). It shows only the target and the approximant.
- **What the archive has:** all 11 surviving legacy GIFs are titled "Pade Approximation / Convergence Intervals". They step along a near-diagonal sequence, and each frame marks the interval where the approximant is within a stated tolerance (±0.001 or ±0.01) with a green bar and green bounds. The last frames reach S9,9 (Cases 1, 2, 3, 5, 6, 8, 17), S9,8 (Cases 11, 18), S8,8 (Case 16) and S5,5 (Case 12). The page's highest diagonal is [5/5], or [4/4] in the 45-frame cases, so for example Mathews' sin(x) reaches total order 18 where the page stops at 10.
- **Why it matters:** the growth of the interval of agreement with order was the stated subject of the originals. A reader cannot get that from the new animations, and the page does not mention the change. The new format is a valid and arguably richer view of the Padé table, so this is Minor.
- **How I know:** `$R/legacy/last.py` (last frames, `$R/legacy/legacy_last.png`), `$R/legacy/fr.py` (`legacy_frames.png`), `$R/legacy/mod.py` (frame counts 12 to 20). The other 16 legacy GIFs are absent from the archive, so for those cases I could not determine the original sequence or tolerance.
- **Suggested correction:** either add one sentence to the Animations introduction, for example: "Unlike Mathews' original animations, which followed the near-diagonal entries and marked a tolerance interval, these step through every entry $[m/n]$ with $m+n\le 10$ ($\le 8$ in Cases 12, 17 and 22-27).", or restore the tolerance-interval overlay and higher diagonal orders.

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `pade_animations_all.jl` | 0 | 113.4 | 27 GIFs (pade01.gif … pade27.gif) | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `pade01.gif` | 66 | byte-identical | pade_animations_all |
| `pade02.gif` | 66 | byte-identical | pade_animations_all |
| `pade03.gif` | 66 | byte-identical | pade_animations_all |
| `pade04.gif` | 66 | byte-identical | pade_animations_all |
| `pade05.gif` | 66 | byte-identical | pade_animations_all |
| `pade06.gif` | 66 | byte-identical | pade_animations_all |
| `pade07.gif` | 66 | byte-identical | pade_animations_all |
| `pade08.gif` | 66 | byte-identical | pade_animations_all |
| `pade09.gif` | 66 | byte-identical | pade_animations_all |
| `pade10.gif` | 66 | byte-identical | pade_animations_all |
| `pade11.gif` | 66 | byte-identical | pade_animations_all |
| `pade12.gif` | 45 | byte-identical | pade_animations_all |
| `pade13.gif` | 66 | byte-identical | pade_animations_all |
| `pade14.gif` | 66 | byte-identical | pade_animations_all |
| `pade15.gif` | 66 | byte-identical | pade_animations_all |
| `pade16.gif` | 66 | byte-identical | pade_animations_all |
| `pade17.gif` | 45 | byte-identical | pade_animations_all |
| `pade18.gif` | 66 | byte-identical | pade_animations_all |
| `pade19.gif` | 66 | byte-identical | pade_animations_all |
| `pade20.gif` | 66 | byte-identical | pade_animations_all |
| `pade21.gif` | 66 | byte-identical | pade_animations_all |
| `pade22.gif` | 45 | byte-identical | pade_animations_all |
| `pade23.gif` | 45 | byte-identical | pade_animations_all |
| `pade24.gif` | 45 | byte-identical | pade_animations_all |
| `pade25.gif` | 45 | byte-identical | pade_animations_all |
| `pade26.gif` | 45 | byte-identical | pade_animations_all |
| `pade27.gif` | 45 | byte-identical | pade_animations_all |

### Page references

- Scripts linked: `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`
- GIFs embedded: 27
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

Verdicts: **confirmed**, **wrong**, **could not determine**.

### Description

| # | Page claim | Verdict | Evidence |
|---|---|---|---|
| D1 | Padé is a rational approximation built from a function value and derivative values at a point, like Taylor | confirmed | Script uses only a_0..a_(m+n); contact order checked for all entries |
| D2 | "Often, Padé approximant's can converge when Taylor Series does not" using the same information | confirmed | log(1+x) at x=2: Taylor order 40 = -1.82e10; [20/20] = 1.09861228867 (true 1.098612289) |
| D3 | Rational functions can have vertical and horizontal asymptotes; polynomials have no asymptotes or singularities | confirmed | Poles visible in 444 frames. Polynomials are entire, and non-constant ones have no horizontal or vertical asymptote |
| D4 | R = P_m/Q_n with Q_n(x0) = 1 | confirmed | `q[1] = 1` in `pade_linear`; independently normalised forms agree |
| D5 | Coefficients chosen so R matches f through order m+n; equivalently derivatives 0..m+n agree | confirmed | All 1438 existing entries have contact order > m+n (exact check, 0 exceptions) |
| D6 | When Taylor coefficients vanish, as for even/odd functions or f(x0)=0, some [m/n] have no such R | confirmed | 176 entries have an inconsistent system, in Cases 5, 7, 8, 9, 12, 14-21; all of these functions have vanishing coefficients |
| D7 | Those frames show the lower-order entry that takes their place | confirmed | Reduced form from an independent null-space and polynomial-GCD computation matches the plotted curve and label in all 176 |
| D8 | That entry matches f only to a lower order | confirmed | All 176 have contact order <= m+n |
| D9 | Legend says so, e.g. "Padé [2/1] = [1/0] (degenerate)" | confirmed | Label equals the independent label in 176 of 176; this literal text is visible in `pade12` and `pade17` sheets |
| D10 | Compared with a Taylor polynomial of the same total order, Padé can represent poles and often stays accurate on larger intervals, especially near singularities or branch points | confirmed | Sup error, Taylor order 10 vs Padé: sqrt on [0.05,10.5] 4.94e7 vs 0.0058; 1/sqrt(1-x) on [-1.5,0.95] 5.98 vs 0.060; log on [0.05,4.1] 6.04e3 vs 0.038; atan on [-2,2] 43.2 vs 0.016 |
| D11 | Linear system becomes badly conditioned as order rises | confirmed | sqrt, x0=5, largest cond by total order 2..10: 1.1, 68, 426, 4.9e4, 4.9e5, 2.4e7, 2.9e8, 1.1e10, 1.5e11 |
| D12 | For sqrt(x) about 5, the [4/6] system has condition number about 1.5e11 | confirmed | Script 1.5109e11; independent 80-digit SVD 1.51092e11 |
| D13 | The system is singular for some entries, the degenerate entries | confirmed | Exact rank: 176 singular, 0 of them solvable, 0 nonsingular unsolvable |
| D14 | MATLAB `pade` can be very slow for some entries below total order 20 | confirmed | [1/15], [1/16], [1/17] are total orders 16-18 and took 9 to 171 s here |
| D15 | With 20-digit `vpa`, those entries for e^x about 0 took about 7, 31, 134 s in R2026a | confirmed in magnitude; exact seconds could not be reproduced | R2026a Update 5, same `digits(20)` and `vpa` form: run 1 9.13, 41.64, 171.35 s; run 2 8.78, 38.47, 152.94 s. Other jobs were running on the machine (load 4 to 8). Roughly 14-30% slower with the same growth of about 4x per step; wall-clock times are machine-dependent, so not a finding |
| D16 | `padeapprox` from chebfun also struggles | confirmed | For e^x about 0 on [-5,5], default tolerance: every request from [8/8] to [15/15] returns type (7,7), with error about 1e-5 against the exact approximant. [1/17] returns (0,16), error 0.20. `$R/indep/pa.py` |
| D17 | Chebfun has `padeapprox`, which computes a Padé approximant numerically | confirmed | Function and its header read from the installed Chebfun |
| D18 | External links (Wikipedia, MathWorks, Chebfun, SIAM paper) | confirmed for three; SIAM could not be load-tested | First three return HTTP 200. SIAM returns 403 to automated clients; DOI metadata gives "Robust Padé Approximation via SVD", SIAM Review 55, 101-117 |

### Video section

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| V1 | Videos are generated by `pade_animation_code.m` | confirmed for parameters | 13 `createVideo` calls correspond one to one with the 13 embeds |
| V2 | Each heading names the right function and centers (exp 0,1; tanh 0,0.5; arctan 0,0.5; 1/x 0.5; 1/(x-1) 0.75; sin 0,0.5; x/(x²+0.01²)^(1/4) 0.5; Runge 0,0.5) | confirmed | All 13 YouTube oEmbed titles match the heading and the script section, in order |
| V3 | The video content itself | could not determine | Videos were not downloaded or watched; only titles were checked |

### Animations

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| A1 | "Each animation shows one Padé order per frame for a fixed center" | confirmed | 66 frames for max order 10, 45 for max order 8, one (m,n) per frame, as in `order_pairs` |
| A2 | "overlaid on the target function" | confirmed | Target plotted in every frame; matches mpmath to at most 3.0e-16 relative at all 900 points |
| A3 | "Julia source for all cases" link, and 27 per-case links | confirmed | All resolve to `pade_animations_all.jl` |

Per-case rows. "Heading" covers f, x0 and interval against the script row and the legacy index. "Wiring" covers the embedded GIF, source link and alt text. "Title" was read at full size from the GIF.

| Case | Page heading | Heading | Wiring | Title | Legacy | Frames | Degenerate |
|---|---|---|---|---|---|---:|---:|
| 01 | sqrt(x), x0=1, [0,10.5] | confirmed | confirmed | confirmed | same | 66 | 0 |
| 02 | sqrt(x), x0=4, [0,10.5] | confirmed | confirmed | confirmed | same | 66 | 0 |
| 03 | sqrt(x), x0=5, [0,10.5] | confirmed | confirmed | confirmed | same | 66 | 0 |
| 04 | 1/sqrt(1-x), x0=0, [-1.5,1.5] | confirmed | confirmed | confirmed | same | 66 | 0 |
| 05 | log(x), x0=1, [-0.5,4.1] | confirmed | confirmed | confirmed | same | 66 | 10 |
| 06 | log(x), x0=2, [-0.5,4.1] | confirmed | confirmed | confirmed | same | 66 | 0 |
| 07 | log(1+x), x0=0, [-1.5,1.5] | confirmed | confirmed | confirmed | same | 66 | 10 |
| 08 | sin(x), x0=0, [-3π,3π] | confirmed | confirmed | confirmed | same | 66 | 20 |
| 09 | cos(x), x0=0, [-3π,3π] | confirmed | confirmed | confirmed | same | 66 | 15 |
| 10 | sin(x), x0=π/4, [-7π/4,9π/4] | confirmed | confirmed | confirmed (0.7854) | same | 66 | 0 |
| 11 | cos(x), x0=π/3, [-5π/3,7π/3] | confirmed | confirmed | confirmed (1.0472) | same | 66 | 0 |
| 12 | tan(x), x0=0, [-π,π] | confirmed | confirmed | confirmed | same | 45 | 14 |
| 13 | e^x, x0=0, [-2,3] | confirmed | confirmed | confirmed | same | 66 | 0 |
| 14 | e^(-x)cos(x), x0=0, [-2,4] | confirmed | confirmed | confirmed | same | 66 | 2 |
| 15 | cosh(x), x0=0, [-4,4] | confirmed | confirmed | confirmed | same | 66 | 15 |
| 16 | arctan(x), x0=0, [-2,2] | confirmed | confirmed | confirmed | same | 66 | 20 |
| 17 | arcsin(x), x0=0, [-1.5,1.5] | confirmed | confirmed | confirmed | same | 45 | 14 |
| 18 | J0(x), x0=0, [-10.2,10.2] | confirmed | confirmed | confirmed | same | 66 | 15 |
| 19 | J1(x), x0=0, [-10.2,10.2] | confirmed | confirmed | confirmed | same | 66 | 20 |
| 20 | normal density, x0=0, [-3,3] | confirmed | confirmed | confirmed | same | 66 | 15 |
| 21 | 1/2 + erf(x/√2)/2, x0=0, [-3,3] | confirmed | confirmed | confirmed | same | 66 | 6 |
| 22 | Γ(x), x0=1, [-0.2,5.2] | confirmed | confirmed | confirmed | same | 45 | 0 |
| 23 | Γ(x), x0=2, [-0.2,5.2] | confirmed | confirmed | confirmed | same | 45 | 0 |
| 24 | Γ(x), x0=3, [-0.2,5.2] | confirmed | confirmed | confirmed | same | 45 | 0 |
| 25 | Y0(x), x0=10, [0,22] | confirmed | confirmed | confirmed | same | 45 | 0 |
| 26 | Y0(x), x0=5, [0,22] | confirmed | confirmed | confirmed | same | 45 | 0 |
| 27 | Y0(x), x0=2, [0,22] | confirmed | confirmed | confirmed | same | 45 | 0 |

"Same" means the function, center and interval equal the legacy index formula images (`$R/legacy/legacy_index_0.png`, `legacy_index_1.png`). The order range and overlay differ; see F2. Legacy module Examples 1 and 2 ([2/2] of e^x, [4/4] of cos x) appear as frames of Cases 13 and 9.

---

### 3. Implementation checks: `pade_animations_all.jl`

The manifest reports all 27 regenerated GIFs byte-identical to the committed ones, so values dumped from a scratch copy of the script are the values in the GIFs. Instrumented copies: `$R/inst/dump.jl`, `$R/inst/ytrue.jl`.

**It is the method it claims to be.** The script runs the standard linearised Padé construction (Baker form): q0 = 1, a Toeplitz system for q1..qn, then p from the convolution of q and a. When the system is singular it shows the reduced (Frobenius) form from the Padé block and labels it. The page describes this same variant.

**The numbers are right.** Independent computation in `$R/indep/check.py`, sharing no code or formulas with the script:

- Taylor coefficients by a 720-point Cauchy integral at 220 digits, directly from each function.
- Each table entry from the null space of the full homogeneous system, reduced by polynomial GCD, with existence decided by exact rank of the Toeplitz system.

Script against independent result:

| Case | f | Max relative coefficient error | Entries | Exists | Degenerate (script / independent) | Label mismatches | Largest visible curve difference (fraction of y-span) |
|---|---|---:|---:|---:|---|---:|---:|
| 01 | sqrt, x0=1 | 1.1e-217 | 66 | 66 | 0 / 0 | 0 | 3.8e-14 |
| 02 | sqrt, x0=4 | 1.1e-217 | 66 | 66 | 0 / 0 | 0 | 1.7e-14 |
| 03 | sqrt, x0=5 | 8.3e-17 | 66 | 66 | 0 / 0 | 0 | 4.3e-14 |
| 04 | 1/sqrt(1-x) | 2.3e-218 | 66 | 66 | 0 / 0 | 0 | 1.6e-10 |
| 05 | log, x0=1 | 5.6e-17 | 66 | 56 | 10 / 10 | 0 | 8.1e-12 |
| 06 | log, x0=2 | 5.6e-17 | 66 | 66 | 0 / 0 | 0 | 1.3e-11 |
| 07 | log(1+x) | 5.6e-17 | 66 | 56 | 10 / 10 | 0 | 8.1e-12 |
| 08 | sin, 0 | 6.7e-17 | 66 | 46 | 20 / 20 | 0 | 1.3e-15 |
| 09 | cos, 0 | 8.6e-17 | 66 | 51 | 15 / 15 | 0 | 4.8e-15 |
| 10 | sin, π/4 | 1.4e-15 | 66 | 66 | 0 / 0 | 0 | 2.6e-14 |
| 11 | cos, π/3 | 3.0e-15 | 66 | 66 | 0 / 0 | 0 | 1.6e-14 |
| 12 | tan | 5.6e-17 | 45 | 31 | 14 / 14 | 0 | 8.0e-16 |
| 13 | exp | 8.6e-17 | 66 | 66 | 0 / 0 | 0 | 6.9e-14 |
| 14 | e^-x cos x | 6.7e-17 | 66 | 64 | 2 / 2 | 0 | 2.5e-14 |
| 15 | cosh | 8.6e-17 | 66 | 51 | 15 / 15 | 0 | 2.0e-15 |
| 16 | atan | 5.6e-17 | 66 | 46 | 20 / 20 | 0 | 3.9e-16 |
| 17 | asin | 5.6e-17 | 45 | 31 | 14 / 14 | 0 | 4.7e-15 |
| 18 | J0 | 5.6e-17 | 66 | 51 | 15 / 15 | 0 | 1.8e-15 |
| 19 | J1 | 5.6e-17 | 66 | 46 | 20 / 20 | 0 | 7.4e-16 |
| 20 | normal pdf | 1.3e-16 | 66 | 51 | 15 / 15 | 0 | 6.7e-16 |
| 21 | normal cdf | 1.3e-16 | 66 | 60 | 6 / 6 | 0 | 1.1e-13 |
| 22 | Γ, x0=1 | 5.2e-17 | 45 | 45 | 0 / 0 | 0 | 3.3e-11 |
| 23 | Γ, x0=2 | 6.3e-17 | 45 | 45 | 0 / 0 | 0 | 3.5e-14 |
| 24 | Γ, x0=3 | 9.3e-17 | 45 | 45 | 0 / 0 | 0 | 6.5e-13 |
| 25 | Y0, x0=10 | 9.8e-17 | 45 | 45 | 0 / 0 | 0 | 5.8e-14 |
| 26 | Y0, x0=5 | 9.2e-17 | 45 | 45 | 0 / 0 | 0 | 1.2e-14 |
| 27 | Y0, x0=2 | 5.8e-17 | 45 | 45 | 0 / 0 | 0 | 1.5e-14 |

Totals: 1614 entries, 1438 existing, 176 degenerate. The worst plotted difference anywhere is 1.6e-10 of the y-span, far below one pixel (about 2e-3).

Further checks (`$R/indep/extra.py`, `check2.py`):

- Contact order: 0 existing entries fail to match through m+n; 0 degenerate entries match through m+n.
- Exact singularity: 176 singular systems, exactly the 176 degenerate entries. The script's "singular but consistent" branch (line 435) is never reached on this table.
- The comment at lines 375-376 is correct: largest regular cond(B) = 1.511e11, smallest singular = 4.733e16, so the 1e14 threshold separates them cleanly.

**Its reference values are right.** The magenta target was compared with mpmath at all 900 grid points of each case (`$R/indep/ytrue.py`). The maximum relative error is 3.0e-16, and there are 0 mismatches in where the curve is undefined (for example x > 1 for 1/sqrt(1-x), |x| > 1 for asin, x <= 0 for log, x = 0 for Y0).

**The picture shows what was computed.** I viewed the contact sheets of all 27 GIFs and full-size frames where a question arose.

- Titles and legends report the correct function, center and [m/n].
- The red marker is at (x0, f(x0)).
- Clamping to one y-span beyond the axes (line 478) only affects off-screen values.
- Vertical segments at sign-changing poles, in both the approximant and the target (tan, Γ), are line-plot joins located at the true poles. They read as asymptotes and are not a separate finding.
- The one display problem is F1.

**Could not determine:** the content of the YouTube videos (V3), the exact wall-clock figures in D15 on an idle machine, and the original order sequence and tolerance of the 16 legacy GIFs missing from the archive.

