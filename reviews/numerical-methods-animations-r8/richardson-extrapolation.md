# Richardson Extrapolation — animation review (round 8)

Page: `pages/numerical-methods/richardson-extrapolation/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** There are 0 Error, 0 Misleading and 0 Minor findings.

I checked these and did not count them as findings:
- *Case 2 rescales its axes every frame.* No fixed limits are set. Frame 1 has one point per series, zero-length guide lines and odd tick labels (10^-0.2, 10^0.0), and frames 2–8 have fractional-exponent tick labels such as 10^-0.50. This is cosmetic. Nothing is clamped or hidden, and no claim on the page depends on it.
- *Case 1 curves overlap.* In every frame the D5 curve is visually indistinguishable from f'(x), and from about h = 0.12 onward D3 is too. The convergence of D5 shows only in the max-error annotation. The annotation is correct (see below), so this is not misleading.
- *Case 2 uses different step sizes from Mathews.* Its step list differs from Example 8's H = {0.5, 0.2, 0.1, 0.05, 0.02, 0.01}, and D5(x,h) has spacing h/2. The page states both explicitly (line 31), so this is not a fidelity finding.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `richexaa.jl` | 0 | 8.5 | richexaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `richexab.jl` | 0 | 7.7 | richexab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Page text (location) | Evidence | Verdict |
|---|---|---|---|
| 1 | "the leading truncation term cancels" (l.12) | sympy: 4·C2(h/2)² − C2h² = 0 | confirmed |
| 2 | Legacy module uses central three-point derivative for f(x)=e^{-x}sin x over [0,π] (l.12) | archive Example 2 code: `f[x]=e^-x Sin[x]`, plots on {x,0,π} | confirmed |
| 3 | D3(x,h) = (f(x+h)−f(x−h))/(2h) (l.17) | matches `richexaa.jl:12`, `richexab.jl:12` | confirmed |
| 4 | D5(x,h) = (4D3(x,h/2)−D3(x,h))/3 (l.23) | matches `richexaa.jl:13`, `richexab.jl:13` | confirmed |
| 5 | Upgrades O(h²) to O(h⁴) (l.26) | local log-log slopes at x=1: D3 2.007→2.000, D5 3.905→4.000 for h in [0.5, 0.006] | confirmed |
| 6 | Intro: each animation compares base central difference with Richardson for the legacy function and interval (l.30) | Case 1 is over [0,π]. Case 2 is at x0=1 ∈ [0,π]. Both use f=e^{-x}sin x | confirmed |
| 7 | Case 2 = error of Example 8's estimate. D5(x,h) is Example 8's five-point formula with spacing h/2, over a different step list (l.31) | sympy: D5(x,h) − five(x,h/2) ≡ 0. Example 8 H list read from archive image gr_174. Case 2 hs differ, as the page says | confirmed |
| 8 | Examples 9–10 approximate the second and third derivatives at the same point with five-point central formulas (l.32) | archive gr_193/194/195 (f''[1.0], d2 five-point), gr_214/215/216 (f'''[1.0], d3) | confirmed |
| 9 | Examples 8–10 draw the five stencil points with a line, parabola or cubic through the centre point, and these are not animated (l.32) | archive code: g = f(X)+d1(x−X), then +d2/2(x−X)², then +d3/2(x−X)³, with 5 dots. Graph gr_175 shows this. No script draws them | confirmed |
| 10 | Examples 1, 3, 4, 5: M5 from a graph of f⁽⁵⁾, bound vs actual error, O(h⁴) bound scaling, comparison with three-point bound (l.33) | archive images: f⁽⁵⁾, M5 = max over 0≤x≤π \|f⁽⁵⁾\|, \|f'−D_five[x,0.01]\| ≤ EB_five[0.01], EB_five[h/2] = EB_five[h]/16, EB_three vs EB_five | confirmed |
| 11 | Case 1 annotates the actual maximum errors (l.33) | `richexaa.jl:28-29,52-56`. Frames show those values (see §3) | confirmed |
| 12 | Example 7 combines D3(1,0.02) and D3(1,0.01) into the five-point value at spacing 0.01, which is D5(1,0.02) (l.34) | archive Example 7 statement image. mpmath: D5(1,0.02) = five(1,0.01) = −0.1107937655 | confirmed |
| 13 | Example 7's error is the h=0.02 point of Case 2 (l.34) | 0.02 ∈ `richexab.jl` hs. Error 1.4771e-10 (exact), 1.477083e-10 (script) | confirmed |
| 14 | Example 2(b) plots the five-point formula at spacing 0.01 over [0,π], which is the h=0.02 frame of Case 1 (l.34) | archive: `Plot[D_five[x,0.01],{x,0,π}]`. Case 1 frame 8 has h=0.02 and plots D5(x,0.02)=five(x,0.01) | confirmed |
| 15 | Example 2(a) table at x=0,1,2,3 (l.35) | archive: f'[0],f'[1],f'[2],f'[3] with h=0.1 and 0.01 | confirmed |
| 16 | Example 6: five-point at spacing h = (4D3(x,h)−D3(x,2h))/3 (l.35) | sympy identity holds (≡ 0). Archive image shows the same formula | confirmed |
| 17 | Case 1 heading: profile comparison D3(x,h) vs D5(x,h) | `richexaa.jl` plots both over [0,π] | confirmed |
| 18 | Case 1: both approximations converge as h shrinks (l.39) | max error on [0,π]. D3: 8.13e-2 → 3.33e-5. D5: 5.29e-4 → 8.33e-11. Both decrease monotonically | confirmed |
| 19 | Case 1: the Richardson curve tracks f' much more closely (l.39) | err3/err5 ratio is 154 at h=0.5 and 4.0e5 at h=0.01 | confirmed |
| 20 | Case 1: the dominant h² term is cancelled (l.39) | same as #1 and #5 | confirmed |
| 21 | Case 1 link `richexaa.jl` and embed `richexaa.gif` | the files exist, and the GIF is produced by that script (byte-identical regen) | confirmed |
| 22 | Case 1 alt text: D3 and D5 vs true derivative over 0 to π for decreasing h | frames 1–9 show h = 0.5 → 0.01 with three curves | confirmed |
| 23 | Case 2 heading: pointwise convergence at x0=1 on log-log axes | `richexab.jl:74,95-96` | confirmed |
| 24 | Case 2: three-point error slope ≈ O(h²) (l.47) | local slopes are 2.000–2.007 over all 12 h | confirmed |
| 25 | Case 2: Richardson ≈ O(h⁴) before roundoff appears (l.47) | slopes are 3.905–4.005 down to h=0.006. At h=0.0015 the float error is 1.29e-14 vs truncation 4.67e-15 (mpmath), and the slope from 0.003 to 0.0015 is 1.8. The roundoff departure is visible in the last frame | confirmed |
| 26 | Case 2 link `richexab.jl` and embed `richexab.gif` | the files exist and match (byte-identical regen) | confirmed |
| 27 | Case 2 alt text: log-log error vs h at x0=1 with second- and fourth-order trends | frames show both series plus O(h²) and O(h⁴) guides | confirmed |
| 28 | Derivation note: D3 = f'+C2h²+C4h⁴+⋯ ⇒ (4D3(h/2)−D3(h))/3 = f'+O(h⁴), with C2h² cancelling exactly (l.55-62) | algebra: the C2 term gives 4·C2h²/4 − C2h² = 0, and the C4 term leaves −C4h⁴/4 | confirmed |

### 3. Implementation checks

### `richexaa.jl` (Case 1)
- **Method.** D3 is the central difference and D5 is Richardson's combination of D3 at h and h/2 (lines 12–13). This is the method the page names. It is algebraically identical to the five-point central formula with spacing h/2 (sympy check).
- **Numbers.** Max errors on the script's 800-point grid. Script values come from the instrumented `inst_a.jl`. Independent values come from numpy, and from a 200001-point dense grid that gives the same sups because the max is at x=0:

| h | err3 script | err3 indep | err5 script | err5 indep | annotated in frame |
|---|---|---|---|---|---|
| 0.5 | 8.127686e-02 | 8.13e-02 | 5.285271e-04 | 5.29e-04 | 8.13e-02 / 5.29e-04 |
| 0.32 | 3.378559e-02 | 3.38e-02 | 8.791235e-05 | 8.79e-05 | 3.38e-02 / 8.79e-05 |
| 0.2 | 1.328011e-02 | 1.33e-02 | 1.336504e-05 | 1.34e-05 | 1.33e-02 / 1.34e-05 |
| 0.12 | 4.793083e-03 | 4.79e-03 | 1.729481e-06 | 1.73e-06 | 4.79e-03 / 1.73e-06 |
| 0.08 | 2.131968e-03 | 2.13e-03 | 3.414633e-07 | 3.41e-07 | 2.13e-03 / 3.41e-07 |
| 0.05 | 8.331250e-04 | 8.33e-04 | 5.209108e-08 | 5.21e-08 | 8.33e-04 / 5.21e-08 |
| 0.03 | 2.999730e-04 | 3.00e-04 | 6.750362e-09 | 6.75e-09 | 3.00e-04 / 6.75e-09 |
| 0.02 | 1.333280e-04 | 1.33e-04 | 1.333365e-09 | 1.33e-09 | 1.33e-04 / 1.33e-09 |
| 0.01 | 3.333300e-05 | 3.33e-05 | 8.333401e-11 | 8.33e-11 | 3.33e-05 / 8.33e-11 |

  The h=0.02 D5 error, 1.33e-9, also agrees with Mathews' Example 4 output \|f'−D_five[x,0.01]\| ≤ 1.33336e-9.
- **Reference.** fp(x) = e^{-x}(cos x − sin x). sympy confirms it equals d/dx[e^{-x} sin x], and mpmath `diff` at x=1 gives the same −0.110793765306699.
- **Picture.** I viewed frames 1 and 8 and the full contact sheet (all 9 frames). The title h matches the loop value. The legend formula matches the code. The y-range of the curves (D3 up to 1.081 at h=0.5) stays inside ylims (−1, 1.1), so nothing is clipped. f is evaluated outside [0,π] only for stencil points, which is valid because f is entire.

### `richexab.jl` (Case 2)
- **Method.** It uses the same D3 and D5 as Case 1, evaluated at x0=1.
- **Numbers.** Script values come from `inst_b.jl`. The exact column was computed in mpmath at 50 digits. The float column uses numpy.

| h | e3 script | e3 exact | e5 script | e5 exact | e5 numpy float |
|---|---|---|---|---|---|
| 0.5 | 4.257869e-02 | 4.2579e-02 | 5.375918e-05 | 5.3759e-05 | 5.3759e-05 |
| 0.2 | 6.783537e-03 | 6.7835e-03 | 1.461109e-06 | 1.4611e-06 | 1.4611e-06 |
| 0.05 | 4.236281e-04 | 4.2363e-04 | 5.766570e-09 | 5.7666e-09 | 5.7666e-09 |
| 0.02 | 6.777739e-05 | 6.7777e-05 | 1.477083e-10 | 1.4771e-10 | 1.4771e-10 |
| 0.01 | 1.694424e-05 | 1.6944e-05 | 9.238929e-12 | 9.2326e-12 | 9.2389e-12 |
| 0.006 | 6.099917e-06 | 6.0999e-06 | 1.205230e-12 | 1.1966e-12 | 1.1944e-12 |
| 0.003 | 1.524978e-06 | 1.5250e-06 | 4.259093e-14 | 7.4786e-14 | 4.5672e-14 |
| 0.0015 | 3.812445e-07 | 3.8124e-07 | 1.292022e-14 | 4.6741e-15 | 1.2920e-14 |

  All 12 h agree to the displayed digits until roundoff. For h ≤ 0.003 the float D5 error is set by roundoff and differs between libms, as expected. The leading-term predictions |f⁽⁵⁾(1)|(h/2)⁴/30 = 4.67e-15 and |f'''(1)|h²/6 = 3.81e-7 at h=0.0015 match the exact column. The Example 8 five-point values, recomputed in mpmath (H=0.5: −0.111463434 … H=0.01: −0.110793765), match the archive's printed values.
- **Reference.** f'(1) = −0.110793765306699, the same as Case 1.
- **Picture.** I viewed frame 12 and the contact sheet (all 12 frames). The markers are the computed errors. The guides are c2·h² and c4·h⁴ anchored at h=0.5, with c2 = 0.1703 and c4 = 8.60e-4, so they pass through the first points. In the last frame the D5 points at h = 0.003 and 0.0015 lie above the O(h⁴) guide, which is the roundoff departure the page describes. Legend labels match the plotted quantities. There is no clamping.

The repository was not modified (`git status` is clean for the page folder). All runs used copies in the scratch folder.

