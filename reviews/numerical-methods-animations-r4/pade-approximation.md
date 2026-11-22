# Padé Approximation — animation review (round 4)

Page: `pages/numerical-methods/pade-approximation/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1 — Implementation (display), Minor: in Case 01, off-scale values are clamped onto the y = 0 border, so a diverging approximant is drawn as if it were 0

- **Location:** `pade_animations_all.jl` line 475, `ypad = clamp.(ypad, case.ylims[1], case.ylims[2])`, together with the Case 01 ylims `(0.0, 3.5)` (line 24).
- **What is there now:** every value outside the y-window is replaced by the window edge and drawn. In most cases the edge is an arbitrary number (±1.5, −10, …) and a curve running along the frame clearly reads as "off the chart". In Case 01 the lower edge is y = 0, which is also the x-axis and a meaningful value for √x. In 9 frames, the approximant leaves through the bottom and then runs along y = 0 for at least 10 % of the window: [2/0], [4/0], [5/1], [6/0], [7/1], [8/0], [8/2], [9/1] and [10/0]. It looks as though the approximant falls to 0 and stays there.
- **What is true:** these approximants go far below zero. The Taylor polynomial [4/0] about 1 is −5.0 at x = 5 and −270.1 at x = 10.5. Frame 15 of `pade01.gif` shows it drawn at 0 from x ≈ 3.97 to 10.5.
- **How I know:** `display.py` lists all frames with a clamped run of at least 90 grid points. Case 01 is the only case where such runs sit on y = 0. The values come from evaluating the script's own p and q (`dump.txt`) at x = 5 and x = 10.5. Case 01 [0/3] also lies on the border, but its true values there are −0.07 to −0.004, so drawing it at 0 is visually fair.
- **Suggested correction:** do not clamp; set out-of-window values to `NaN` (or leave them and let `ylims` clip them), so the curve leaves the frame instead of running along it. If clamping is kept for drawing poles, at least give Case 01 a lower limit below 0, such as `(-0.5, 3.5)`.

No other findings. All 1614 computed approximants, all 176 "degenerate" legends, all 27 case rows, the reference curves and the numerical claims on the page check out (details below).

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `pade_animations_all.jl` | 0 | 109.4 | 27 GIFs (pade01.gif … pade27.gif) | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

Claims are quoted from `index.qmd` as written. "Animations section" covers the introduction, the 27 headings, the alt texts, the links and the embeds. The Description's method statements are included. History, attribution and the Outside Links are left out.

### Description (method statements)

| # | Claim (page wording) | Verdict | Evidence |
|---|---|---|---|
| D1 | "Padé approximant is a rational function approximation expanded from a function value and the derivative function values similar to Taylor Series." | confirmed | The script builds each R from the Taylor coefficients a_k = f^(k)(x0)/k! (`series_coeffs_analytic`). The coefficients agree with mpmath to ≤ 3e-15 relative in every case (`coeffs.py`). |
| D2 | "Often, Padé approximant's can converge when Taylor Series does not even though both use the same information at a point." | confirmed (as an "often") | Case 01 (√x about 1, Taylor radius 1): Taylor [10/0] has max error 4.9e7 on [0, 10.5] and is within 1e-3 on 15 % of the window. Padé [5/5] has max error 0.09 and is within 1e-3 on 68 % (`taylor_vs_pade.py`). The same holds for cases 05, 16 and 22. |
| D3 | "Rational functions can have singularities/vertical-asymptotes and horizontal asymptotes. Polynomials do not…" | confirmed | Mathematical fact. Poles are visible in the frames, e.g. Case 01 [0/3], Case 12 [4/4]. |
| D4 | R_{m,n}=P_m/Q_n, Q_n(x0)=1 | confirmed | `pade_linear` fixes q0 = 1 (line 361) and evaluates in z = x − x0 (line 466). |
| D5 | "chooses coefficients so the Taylor expansion of R_{m,n} about x0 matches the target function through order m+n. Equivalently, f^(k)(x0)=R^(k)(x0) for k=0..m+n." | confirmed | The script solves the standard linearised Toeplitz system (rows k = m+1..m+n) and then forms p from q·a. My exact solution agrees for all 1438 non-degenerate frames, with the largest clamped curve difference 1.6e-10 of the y-range (`compare.out`). |
| D6 | "When Taylor coefficients vanish, as for even or odd functions or when f(x0)=0, some entries [m/n] have no such R_{m,n}." | confirmed | The exact check finds entries with no Q(0)=1 solution in cases 05, 07 (f(x0)=0), 08, 09, 12, 15–20 (odd/even) and 14, 21 (other vanishing coefficients). Cases 01–04, 06, 10, 11, 13 and 22–27 have none. Counts per case: 10, 10, 20, 15, 14, 2, 15, 20, 14, 15, 20, 15, 6 (176 in all). These are the same entries the script flags. |
| D7 | "Those frames show the lower-order entry that takes their place in the Padé table, which matches f only to a lower order, and the legend says so, for example 'Padé [2/1] = [1/0] (degenerate)'." | confirmed | For all 176 degenerate entries, the script's legend `[l/μ]` equals the degrees of the exact reduced Frobenius solution. The plotted curve equals it (max difference 5.6e-16 of the y-range), and its first non-matching order is ≤ m+n in every one (`compare.out`, contact-order check). The quoted example appears verbatim in frame 9 of cases 08, 12, 14, 16, 17, 19 and 21. |
| D8 | "Compared with a Taylor polynomial of the same total order, Padé approximants can represent poles and often stay accurate on larger intervals…" | confirmed (as an "often") | `taylor_vs_pade.py` compares the share of the window within 1e-3 for the diagonal Padé against Taylor [N/0]. Padé covers clearly more in 18 of 27 cases (01–07, 12–14, 16, 17, 20–24, 27). The two are within 0.02 of each other in 6 (08, 10, 11, 19, 25, 26). Taylor covers more in 3: Case 15 cosh (0.74 against 0.53), and Cases 09 and 18, where the diagonal [5/5] is itself degenerate (= [4/4]). That fits "often". |
| D9 | "the linear system for the denominator coefficients can become badly conditioned as the order rises (for √x about x0=5, the [4/6] system has condition number about 1.5×10^11)" | confirmed | cond₂(B) = 1.51092e11 from the script's own Float64 B (`dump.txt`), from numpy, and from mpmath on exact coefficients (`cond.py`). It is also the largest regular-system condition number in the whole table. |
| D10 | "…and because that system is singular for some entries [m/n], the degenerate entries described above." | confirmed | In this table every singular B is inconsistent: sympy found no singular-but-solvable entry. So "singular" and "degenerate" coincide here, as the page says. |
| D11 | "with the 20-digit `vpa` setting of the video script" | confirmed | `pade_animation_code.m`: `digits(20); func = vpa(func(vpa(1.0)*x));` then `pade(func, x, expansionPoint, 'order', order)`. |
| D12 | "the [1/15], [1/16] and [1/17] entries for e^x about 0 took about 7, 31 and 134 seconds in MATLAB R2026a" | confirmed | I ran `padetime.m` with MATLAB R2026a Update 5 on this machine, using the same setup as the video script (`syms x real; digits(20); f = vpa(exp(vpa(1.0)*x)); pade(f,x,0,'order',[1 n])`). The times were [1/14] 1.7 s, [1/15] 7.4 s, [1/16] 32.9 s and [1/17] 141.3 s, against the page's "about 7, 31, 134". Wall-clock times depend on the machine, but these agree to within about 6 %. |
| D13 | "`padeapprox` from chebfun also struggles." | could not determine | Chebfun is not run in this review. The only support is the comment in `pade_animation_code.m` ("numerical issues at total order … of 16 or so"). |

### Animations section

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| A1 | "Each animation shows one Padé order per frame for a fixed center x0, overlaid on the target function." | confirmed | One [m/n] per frame, ordered by m+n = 0..N and then by m (`order_pairs`). The centre is fixed per GIF and the magenta f(x) is drawn in every frame. Frame counts are 66 (N = 10) or 45 (N = 8), matching the manifest. |
| A2 | "[Julia source for all cases](pade_animations_all.jl)" and the per-case "[Julia source]" links (27) | confirmed | The file exists and produces all 27 GIFs (manifest: byte-identical). |
| C01 | Case 01: f=√x, x0=1, x∈[0,10.5]; alt "sqrt(x) centered at x0=1 over x in [0,10.5]"; embed pade01.gif | confirmed | Script line 24. GIF title "Padé Case 01: f(x) = sqrt(x), x0 = 1.0"; x-axis 0–10.5. Matches Mathews #1. |
| C02 | Case 02: √x, x0=4, [0,10.5]; pade02.gif | confirmed | Line 25; GIF title and axis agree; Mathews #2. |
| C03 | Case 03: √x, x0=5, [0,10.5]; pade03.gif | confirmed | Line 26; GIF agrees; Mathews #3. |
| C04 | Case 04: 1/√(1−x), x0=0, [−1.5,1.5]; alt "one over square root of one minus x centered at zero"; pade04.gif | confirmed | Line 27; title "1/sqrt(1-x), x0 = 0.0"; Mathews #4. |
| C05 | Case 05: log x, x0=1, [−0.5,4.1]; pade05.gif | confirmed | Line 28; GIF agrees; Mathews #5. |
| C06 | Case 06: log x, x0=2, [−0.5,4.1]; pade06.gif | confirmed | Line 29; Mathews #6. |
| C07 | Case 07: log(1+x), x0=0, [−1.5,1.5]; pade07.gif | confirmed | Line 30; Mathews #7. |
| C08 | Case 08: sin x, x0=0, [−3π,3π]; pade08.gif | confirmed | Line 31; Mathews #8. |
| C09 | Case 09: cos x, x0=0, [−3π,3π]; pade09.gif | confirmed | Line 32; Mathews #9. |
| C10 | Case 10: sin x, x0=π/4, [−7π/4,9π/4]; alt "sin(x) centered at pi over 4"; pade10.gif | confirmed | Line 33; title shows x0 = 0.7854 (π/4 to 4 d.p.); x-axis −5.50…7.07; Mathews #10. |
| C11 | Case 11: cos x, x0=π/3, [−5π/3,7π/3]; pade11.gif | confirmed | Line 34; title x0 = 1.0472; Mathews #11. |
| C12 | Case 12: tan x, x0=0, [−π,π]; pade12.gif | confirmed | Line 35 (N = 8); Mathews #12. The tan Taylor table (1, 1/3, 2/15, 17/315, 62/2835) matches mpmath. |
| C13 | Case 13: e^x, x0=0, [−2,3]; pade13.gif | confirmed | Line 36; Mathews #13. |
| C14 | Case 14: e^{−x}cos x, x0=0, [−2,4]; pade14.gif | confirmed | Line 37; Mathews #14 ("Cos[x] e^-x"). |
| C15 | Case 15: cosh x, x0=0, [−4,4]; pade15.gif | confirmed | Line 38; Mathews #15. |
| C16 | Case 16: arctan x, x0=0, [−2,2]; pade16.gif | confirmed | Line 39 (title "atan(x)"); Mathews #16. |
| C17 | Case 17: arcsin x, x0=0, [−1.5,1.5]; pade17.gif | confirmed | Line 40 (title "asin(x)", N = 8); Mathews #17. |
| C18 | Case 18: J0, x0=0, [−10.2,10.2]; pade18.gif | confirmed | Line 41; Mathews #18. |
| C19 | Case 19: J1, x0=0, [−10.2,10.2]; pade19.gif | confirmed | Line 42; Mathews #19. |
| C20 | Case 20: (1/√(2π))e^{−x²/2}, x0=0, [−3,3]; alt "normal density"; pade20.gif | confirmed | Line 43 (title "normal_pdf(x)"); Mathews #20. |
| C21 | Case 21: ½+½erf(x/√2), x0=0, [−3,3]; alt "normal CDF"; pade21.gif | confirmed | Line 44 (title "normal_cdf(x)"); Mathews #21. |
| C22 | Case 22: Γ(x), x0=1, [−0.2,5.2]; pade22.gif | confirmed | Line 45 (N = 8); Mathews #22. |
| C23 | Case 23: Γ(x), x0=2, [−0.2,5.2]; pade23.gif | confirmed | Line 46; Mathews #23. |
| C24 | Case 24: Γ(x), x0=3, [−0.2,5.2]; pade24.gif | confirmed | Line 47 (ylims to 45); Mathews #24. |
| C25 | Case 25: Y0, x0=10, [0,22]; pade25.gif | confirmed | Line 48; Mathews #25. |
| C26 | Case 26: Y0, x0=5, [0,22]; pade26.gif | confirmed | Line 49; Mathews #26. |
| C27 | Case 27: Y0, x0=2, [0,22]; pade27.gif | confirmed | Line 50; Mathews #27. |
| W | Wiring: each case's embed is that case's GIF | confirmed | I checked the contact sheet of every GIF. The title in each reads "Padé Case NN: f(x) = …, x0 = …" with the same NN, function and centre as the heading that embeds it. |

The video section (YouTube embeds and their headings) is outside the scope set by the brief. I only noted that `pade_animation_code.m` contains cases matching each video heading (exp about 0 and 1, tanh about 0 and 0.5, atan about 0 and 0.5, 1/x about 0.5, 1/(x−1) about 0.75, sin about 0 and 0.5, x/(x²+0.01²)^{1/4} about 0.5, and Runge about 0 and 0.5).

**Fidelity to Mathews.** All 27 rows reproduce Mathews' function, centre and interval exactly, and no archive case is dropped. Mathews' own animations (e.g. `Pade01/Padeaa.gif`, 20 frames) step through the diagonal S_{n,n} for n = 1..9 and add a ±0.001 tolerance band. The page instead steps through the whole Padé table up to total order 10 (or 8). This is a presentation choice that the page does not misstate, so it is not a finding.

---

### 3. Implementation checks — `pade_animations_all.jl`

**It is the method it claims to be.** The script runs the classical linearised Padé construction: q0 = 1, the n×n Toeplitz system Σ_j q_j a_{k−j} = −a_k for k = m+1..m+n, then p_i = Σ_{j≤min(i,n)} q_j a_{i−j}. That is the definition on the page (D4, D5). Where the Toeplitz system is singular (cond > 1e14), it computes the reduced Frobenius form. This is the unique p/q with z^d(qf − p) = O(z^{m+n+1}), found by searching [l/μ] in increasing l+μ for a regular entry satisfying that condition, and the legend then reads "[m/n] = [l/μ] (degenerate)". That is the standard block-structure (Baker / Frobenius) treatment of a non-normal Padé table. The "consistent singular" branch (line 434–435) is never taken in this table. In the one place it could matter it would return a pinv/backslash solution rather than the reduced one. Every singular B here made `B\rhs` throw, and none was consistent, so this has no effect.

The script's comment claims "regular systems have cond(B) ≤ 1.6e11 and exactly singular ones ≥ 4.7e16". This is confirmed from `dump.txt`: the largest regular cond is 1.511e11 (case 03 [4/6]) and the smallest singular cond is 4.73e16 (case 20 [1/5]). My exact computation classifies every entry the same way as the 1e14 threshold does.

**The numbers are right.**
- *Taylor coefficients*: compared with mpmath `taylor` at 60 digits (numerical differentiation, independent of the script's formulas), the largest relative error per case is ≤ 1.3e-16 everywhere except cases 10 and 11. Those two use `sin(c + kπ/2)` in Float64 and reach 1.4e-15 and 3.0e-15. Exact zeros (odd/even functions) are exactly zero in the script.
- *Approximants*: for every frame in every case (1614 frames), the script's p/q from `dump.txt` was compared with my independent table on the script's 900-point grid. Mine is exact sympy for cases 01–21 and 50-digit mpmath for 22–27. Both curves were clamped to the case ylims and points within 3 grid steps of a pole were skipped. The largest difference per case, as a fraction of the y-range, is 4e-14, 2e-14, 4e-14, 1.6e-10, 8e-12, 1.3e-11, 8e-12, 2e-15, 5e-15, 3e-14, 2e-14, 8e-16, 7e-14, 6e-15, 2e-15, 3e-16, 3e-15, 2e-15, 8e-16, 6e-16, 4e-15, 2.5e-11, 3e-14, 1.3e-13, 5e-15, 1.4e-15 and 4.5e-15 for cases 01–27. No frame differs visibly.
- *Degenerate entries*: all 176 legends agree with the degrees of the exact reduced form (e.g. sin [2/5] = [1/4], cos [5/5] = [4/4], erf-CDF [4/3] = [3/2]). For every one of them, the reduced form's first non-matching Taylor order is ≤ m+n, so the entries really have no Q(0)=1 approximant and really "match f only to a lower order".
- *Gamma and Y0 (22–27)*: the smallest relative singular value of any Toeplitz system is 4.7e-6 (case 25), so none is near-singular, and the script, correctly, flags none.
- *Property check*: the contact-order computation above is the derivative-matching property applied to the degenerate entries. For the regular entries, agreement with the exact solution of the defining system is the check.

**Its reference values are right.** The magenta "y = f(x)" curve, `safe_eval(case.f, x)` on the 900-point grid, agrees with mpmath to ≤ 3.8e-13 relative in every case. The NaN masks fall exactly where f is not real: x<0 for log, x>1 for 1/√(1−x), x<−1 for log(1+x), |x|>1 for arcsin, and x=0 for Y0 (`ftrue.py`: 0 mismatches). The red marker is (x0, f(x0)).

**The picture shows what was computed.**
- Titles carry the right case number, function label and x0 (rounded to 4 d.p.), and the legend carries the right [m/n] in all frames I inspected (contact sheets of all 27 GIFs, plus frames read at full size).
- The axis windows equal the heading intervals.
- Poles: the denominator mask (|Q| < 1e-8) plus clamping draws each pole as a vertical stroke across the window. `display.py` found 30 frames with a real pole inside the window that the grid never resolves beyond the y-limits. Most are near-cancelling pole–zero pairs, with the numerator at the pole between 2.8e-14 and about 0.02, and these really are nearly invisible. The rest, e.g. Case 25 [0/1], [0/3], [0/5], [0/7] (numerator 0.0557) and Case 24 [1/3], are genuine poles with a small residue: the pole of [0/1] at x = 9.776 has residue ≈ 0.0125, and the frame shows a sharp ±1 spike at the pole (frame 2 of `pade25.gif`). That still reads as a pole, so it is not a finding.
- Clamping: see F1. Elsewhere, curves that run along the ±border at a non-meaningful level (e.g. cos [2/2] heading to −5) read as off-scale, and I do not count them as findings.

**Not checked / limits.** I did not open every one of the 1614 frames at full size. Labels and curves were checked numerically for all of them, and visually through the 27 contact sheets plus selected full-size frames.

