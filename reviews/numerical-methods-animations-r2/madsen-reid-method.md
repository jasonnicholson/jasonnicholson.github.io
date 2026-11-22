# Damped Newton with Acceleration (Madsen-Reid Method) — animation review (round 2)

Page: `pages/numerical-methods/madsen-reid-method/`. Reported findings: **2 Error, 0 Misleading, 1 Minor**.

## Findings

### Finding 1. Implementation and page match, **Error**: the damped / `alterdirection` rule is not Madsen's

**Location**
- `madsreidac.jl` lines 62–77: the `else` branch, which halves up to 4 times and rotates only if every halving fails.
- The same logic in `madsreidaa.jl` lines 68–84 and `madsreidab.jl` lines 67–82. It is not reached in Cases 1–2.
- `index.qmd` line 28: "**Stage 1 (Damped):** If the full Newton step *increases* $|f(z)|^2$, the step is repeatedly halved (up to 4 times) until a reducing step is found. If halving fails, `alterdirection` rotates the step by $53.13°$ … breaking symmetry and escaping saddle points or cycles."
- `index.qmd` line 64 (Case 3): "neither the real Newton step nor any of its 4 halvings reduces $|P|^2$: the real-axis iterates stagnate. The `alterdirection` mechanism rotates the step into the complex plane, to $z_2 = 0.0546875 + 0.40625i$".

**What is there now.** When the Newton step increases |P|, the script halves the step until |P(z−dz/2^h)|² < |P(z)|², for up to 4 halvings. If none succeeds, it rotates the last halved step (dz/16) by 0.6+0.8i and accepts the result unchecked.

**What Madsen's algorithm does** (Vestermark §6.4, `try_shorten_steps`; the brief quotes are below):
- It halves "as long as that reduces |P|". Each halving is compared with the previous trial point, starting from the increased value |P(z0−dz)|, not with |P(z0)|.
- It allows at most n halvings, where n is the degree.
- "If two halvings both helped, the iterate is probably near a saddle point, and the step is rotated by 53° and halved once more" (`wdz = changedirection(wdz, 0.5)` at `i == 2`).

The rotation is therefore triggered by two *successful* halvings, not by the failure of all halvings, and it carries an extra factor of 0.5.

**How I know.** `madsen_ref.py` applies Madsen's Stage-1 rules to Case 3, starting from the script's own z0 = 1 and r0 = 5:
```
1 (-0.25+0j)                     halved x1
2 (0.359375+0.8125j)             halved x2 then rotated
3 (-0.18577342+1.63875947j)      halved x1
4 (0.04370916+2.02433028j)       newton
...
7 (1.9e-15+1.999999999999999j)   newton   |P| = 8.9e-15
```
The script and `indep.py` (the page's rule) both give z2 = 0.0546875+0.40625i and z3 = −0.28445+2.72241i. The two rules agree on z1 and diverge at z2.

At z1 = −0.25 the two rules behave differently:
- Madsen: the 1st halving (3.8125, |P| = 18.5 < 66.0) and the 2nd (1.78125, |P| = 7.17 < 18.5) both help, so the step rotates: z2 = −0.25 − (−2.03125)(0.6+0.8i)(0.5) = 0.359375+0.8125i.
- Script: it compares every halving with |P(−0.25)|² = 16.504. The 4th halving gives 16.536, so all fail, and the script rotates dz/16.

The page's story is that real-axis halvings stagnate and the rotation is a last resort after failure. That is the script's own invention. In Madsen's method the rotation is a saddle-point heuristic set off by the opposite pattern.

**Suggested correction**, either of:
- (a) Implement Madsen's rule: halve while |P| keeps decreasing relative to the previous trial, at most n times; after the 2nd successful halving, set dz ← 0.5·(0.6+0.8i)·dz and accept z0 − dz. Regenerate Case 3 and rewrite its Behavior paragraph from the new iterates (z2 = 0.359375+0.8125i; the 2nd step is the rotation, the 1st and 3rd are halved steps, the last four are Newton steps; |P(z7)| ≈ 8.9e-15).
- (b) Keep the current rule, but say on the page (line 28 and Case 3) that it is a simplified damping rule that differs from Madsen-Reid's, and drop "escaping saddle points" as the stated rationale.

- **Independent check:** confirmed with correction, from the primary source (Madsen & Reid 1975, AERE R.7986, eq. 2.6; secondary check against Vestermark 2023): the scripts' rule (up to 4 halvings, then dz/16 rotated and accepted unchecked) is not Madsen's. Madsen–Reid compare each trial with the previous one, make at most 2 halvings, then try the rotated step ¼·e^{iθ}·dz_k with θ = arctan(3/4) ≈ 36.87° (not 53°, and no extra 0.5 factor); a failed search is followed on the next iteration by the checked rotation −½·e^{iθ}·dz_{k−1} of eq. (2.3c). The reviewer's own description of Madsen's rule (53°, ×0.5) is therefore itself inexact; use the primary-source version when fixing.

### Finding 2. Page match (method description) and implementation, **Error**: "Stage 1" and "Stage 2" are defined wrongly

**Location**
- `index.qmd` lines 26–27: "**Stage 2 (Newton):** If the full Newton step … reduces $|f(z)|^2$ and the doubled step $z - 2\Delta z$ does not reduce it further, $z - \Delta z$ is accepted as-is. This is the fast, quadratic phase near a simple root." and "**Stage 1 (Multi-step):** If $z - 2\Delta z$ reduces $|f|^2$ further …".
- Line 42: "Blue segments indicate full Newton steps (Stage 2)".
- The legend entry "Stage 2 – Newton" in all three scripts (`madsreidaa.jl` line 127 and the matching lines in ab/ac).
- The scripts contain no stage logic at all; `mr_iterates` and `mr_complex_iterates` run the same checked step every iteration.

**What is true.** In Madsen's algorithm the stage is a state of the iteration, chosen by Ostrowski's convergence test. Vestermark §6.3, `newton_converging`, tests |P′(z0)−P′(z)|/|z0−z| ≤ |P′(z)|/(4|P(z)|) with a factor-2 safety margin since his v01.40, and requires that "the previous step was a plain step". Stage 1 covers *every* checked step: shortened, rotated, lengthened, or plain-but-checked. Stage 2 takes plain Newton steps *without* the |P| checks or the m·dz trials (Vestermark §6.6: "In stage 2 the step of the method is taken without shortening or lengthening").

So "the doubled step did not help" is not the definition of Stage 2. For example, Case 1 step 2 directly follows a lengthened step (2Δx), so under Madsen's rule it cannot be a Stage-2 step, yet it is drawn and labelled "Stage 2 – Newton".

**Impact on the numbers.** In these three runs every step the script labels `:newton` had its m·dz trial fail. A Stage-2 plain step would therefore land on the same iterate, and the iterates are unaffected. What is wrong is the stated definition of the method's two stages and the stage labels in the legend.

Vestermark §6.9 adds a related point. Under Madsen's original test a double root could pass into Stage 2 "by rounding" and then converge only linearly. The scripts avoid this only because they have no Stage 2. The page's heading "Quadratic convergence — even at multiple roots" is true of the scripts but rests on a check that Madsen's Stage 2 does not perform.

**Suggested correction.** Rewrite lines 24–28 to say that the stage is chosen by Ostrowski's test (Newton convergence guaranteed, using a divided-difference estimate of P″ and requiring the previous step to be a plain step). Say that Stage 1 contains the checked, halved, rotated and lengthened steps, and that Stage 2 is unchecked Newton. Then either:
- add the stage test to the scripts and label steps by the actual stage, or
- keep the scripts and relabel the colours by step type ("plain Newton step", "lengthened step kΔx", "shortened / rotated step") without calling them Stage 1 or 2, and state that the scripts run Stage-1-style checked steps throughout.

- **Independent check:** confirmed (primary source: Stage 1 is every iteration that runs the search; Stage 2 is plain Newton entered only through the Kantorovich test, eq. 2.9; the scripts have no such test, so the steps labelled 'Stage 2' are Stage 1 searches that ended at p = 1)

### Finding 3. Page match and implementation, **Minor**: the r0 update uses the pre-limit step length

**Location**
- `index.qmd` line 16: "$r_0$ … is reset after every iteration to five times the latest Newton step length".
- `madsreidaa.jl` line 51 (`r0 = r * 5.0`, where `r = abs(dz)` is taken before limiting, line 47). Same in `madsreidab.jl` and in `madsreidac.jl` lines 42–46.

**What is true.** In Madsen's code (Vestermark §6.2) r0 is reset to 5× the length of the step after limiting: `dz=changedirection(dz,r0/r); r=dz.abs(); … r0=5*r`. The script and page use the length before limiting.

**Impact.** No effect on these animations. The limit never acts: I checked |Δz| ≤ r0 at every step in all three cases (`indep.py`, "limited" column all False), which confirms the page's own statement on line 20.

**Suggested correction.** Recompute `r = abs(dz)` after limiting, or say "five times the length of the step after limiting".

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `madsreidaa.jl` | 0 | 5.5 | madsreidaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `madsreidab.jl` | 0 | 6.4 | madsreidab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `madsreidac.jl` | 0 | 6.5 | madsreidac.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `madsreidaa.gif` | 7 | byte-identical | madsreidaa |
| `madsreidab.gif` | 5 | byte-identical | madsreidab |
| `madsreidac.gif` | 8 | byte-identical | madsreidac |

### Page references

- Scripts linked: `madsreidaa.jl`, `madsreidab.jl`, `madsreidac.jl`
- GIFs embedded: 3
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

Abbreviations: C = confirmed, W = wrong, ND = could not determine.

### Description

| # | Claim (page wording) | Verdict | Evidence |
|---|---|---|---|
| D1 | "a robust, globally convergent Newton-based algorithm for finding all roots of a real-coefficient polynomial" | ND | I know of no global-convergence proof. Vestermark says only that it converges from its start point on all his test sets. The page itself (line 30) says descent "is not a guarantee". Historical and characterising, so not pursued. |
| D2 | Newton at an m-fold root: f/f′ ≈ (x−x*)/m; the error shrinks by (m−1)/m per step | C | Case 2 plain-Newton error ratios → 0.500 (`indep.py`: 0.579, 0.557, …, 0.5, 0.5). |
| D3 | Tries z−2Δz, …, z−nΔz and keeps the last point at which \|f\|² is still decreasing | C | Matches the scripts' lines 58–66 and Vestermark §6.4. |
| D4 | Near an m-fold root that point is z−mΔz, which converges quadratically (Case 2) | C | Case 2 picks k=2 at the double root three times; e/e² ≈ 0.24, 0.16, 0.17. |
| D5 | r0 limits the Newton step and is reset to 5\|Δz\| | C for the scripts / W in detail vs Madsen | Finding 3. |
| D6 | Real scripts cut the step keeping its direction; the complex script also rotates it 53.13° | C | Scripts aa/ab lines 48–50 and ac lines 43–45. 0.6+0.8i has angle 53.1301° and modulus 1 (`indep.py`). |
| D7 | "No Newton step in the three animations is longer than r0, so the limit never acts" | C | `indep.py` "limited" flags are all False. Instrumented r0 trace for Case 3: Newton \|Δz\| = 2.5, 8.125, 4.68, … all below r0 = 5, 12.5, 40.6, …. |
| D8 | Stage 2 (Newton) defined as "Newton step reduces and the doubled step does not" | W | Finding 2. |
| D9 | Stage 1 (Multi-step) when z−2Δz reduces further | C in part | This is part of Madsen's Stage 1, but Stage 1 is not defined by it (Finding 2). |
| D10 | Stage 1 (Damped): halved up to 4 times until a reducing step is found; if halving fails, `alterdirection` rotates | W | Finding 1. |
| D11 | Rotation by 53.13° = multiplication by 0.6+0.8i | C | `indep.py`. Madsen's version also halves (Finding 1). |
| D12 | "an `alterdirection` step is accepted without checking \|f\|²" | C | Script ac line 74–76. Madsen's rotated step is also accepted unchecked (`try_shorten_steps`). |
| D13 | "In all three animations below \|f\|² does decrease at every step" | C | Case 1 \|P\|²: 289, 3.17, 0.637, 2.4e-3, 5.2e-8, 2.6e-17, 7.9e-31. Case 2: 2916, 0.746, 5.1e-4, 1.7e-11, 2.5e-26. Case 3: 25, 16.50, 14.73, 13.49, 0.203, 1.3e-4, 7.1e-11, 2.0e-23. |
| D14 | Uses only f and f′ (plus extra f evaluations at trial points) | C | Scripts use `f`, `fp` only. Madsen's stage test uses a divided difference of P′, so P″ is not needed. |
| D15 | Deflation after each root (degree −1 or −2), last linear/quadratic solved analytically | C (as a description; not implemented in the scripts, which find one root) | Consistent with Vestermark §6 outline and §6.8. |
| D16 | Note on generalization to general f(x)=0 and systems | ND | Not a checkable numerical claim. Not pursued. |

### Animations section, introduction

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| A1 | Blue = full Newton steps (Stage 2) | C for the colour / W for "Stage 2" | Colour mapping matches the code (`:steelblue` for `:newton`). Stage label: Finding 2. |
| A2 | Green = multi-step z−kΔz, k≥2, drawn as the tangent down to the Newton point and then along the axis | C | Code lines 112–115. Frames: Case 1 frame 1, tangent (3,17)→(2.2917,0), then axis to 1.5833. Case 2 frame 1, tangent to 2.8, then axis to 0.4. |
| A3 | Orange = damped or direction-altered steps (Stage 1) | C | Code and Case 3 frames 1–3. |
| A4 | In Case 3, star markers show the exact roots | C | Stars at 0±2i; the roots of z²+4 are ±2i. |
| A5 | Source scripts linked under each case | C | The three links resolve to the three scripts. |

### Case 1

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 1a | P(x)=x³−3x−1, x0=3.0 | C | Script lines 10, 14. Title in the frames matches. |
| 1b | Three simple real roots exist | C | 2cos(π/9), 2cos(7π/9), 2cos(13π/9) = 1.879, −1.532, −0.347. |
| 1c | The doubled step reduces \|P\|² more than the Newton step, so x1 = x0−2Δx ≈ 1.5833 (green) | C | \|P\|² at k=1,2,3: 17.31, 3.17, 8.73, so k=2. x1 = 1.5833333. |
| 1d | x1 passes the root | C | x1 − x* = −0.296. |
| 1e | Every later step is a full Newton step (blue), no damping | C | labels = [multi, newton ×5]. |
| 1f | x* ≈ 1.8794 | C | 1.87938524157181677 (mpmath). |
| 1g | Errors 9.8e-2, 6.4e-3, 3.0e-5, 6.7e-10 over steps 2–5 | C | 0.09783, 0.006397, 3.0154e-5, 6.7487e-10. |
| 1h | Convergence is quadratic | C | e_{k+1}/e_k² = 0.668, 0.737, 0.742 → f″/(2f′) = 0.742. |
| 1i | x6 equals x* to double precision | C | x6 = 1.8793852415718169 = float(x*). |
| 1j | Alt text: doubled first step to x1≈1.5833, then Newton steps converging to x≈1.8794 | C | Frames 1–6, legend "x1 = 1.58333", …, "x6 = 1.87939". |
| 1k | Wiring: link `madsreidaa.jl`, embed `madsreidaa.gif` | C | Manifest. Parameters match the heading. |

### Case 2

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 2a | P(x)=(x−1)²(x+2), x0=4.0 | C | x³−3x+2 = (x−1)²(x+2). Script line 14. |
| 2b | Double root x*=1 with P′(1)=0 | C | P′(1)=3−3=0. |
| 2c | Plain Newton from x0=4: error roughly halves each step and is still 3.4e-4 after 14 steps | C | Error after 14 steps = 3.35e-4. Ratios 0.58 → 0.50. |
| 2d | Multi-step at every step (all green) | C | labels = [multi ×4]. |
| 2e | 3Δx to x1 = 0.4, past the root | C | Δx=1.2, x1 = 0.4000000000000004, below 1. |
| 2f | Then 2Δx three times | C | `indep.py`: k=2, 2, 2. xt is the midpoint each time. |
| 2g | Errors 8.6e-2, 1.2e-3, 2.3e-7, falling quadratically | C | 0.085714, 0.0011742, 2.2964e-7. e/e² = 0.24, 0.16, 0.17. |
| 2h | Stops after 4 steps at x4 ≈ 1.00000023, \|P(x4)\| ≈ 1.6e-13 | C | x4 = 1.0000002296, \|P\| = 1.58e-13 < 1e-10 stop. |
| 2i | No step is damped | C | labels. |
| 2j | From x2 on the window zooms in on each new step | C | Code `frame ≥ 2`. Frames 3–5 zoomed (contact sheet). |
| 2k | Steps shrink from 0.69 to 0.0012 | C | \|x2−x1\| = 0.6857, \|x4−x3\| = 0.001174. |
| 2l | Each zoomed frame shows the tangent reaching the axis halfway along the step, then the second Δx along the axis | C | Frames 3–5: tangent ends at xt (0.743, 1.0434, 1.000587), the midpoint of each step. |
| 2m | Alt text: four multi-step moves (3Δx, then 2Δx ×3) converging quadratically from 4.0 to 1 | C | As above. |
| 2n | Wiring | C | Manifest. |

### Case 3

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 3a | P(z)=z²+4, z0 = 1+0i | C | Script lines 12, 87. |
| 3b | Roots ±2i, no real roots | C | |
| 3c | A halved Newton step reaches z1 = −0.25 | C | Δz=2.5, full step to −1.5 gives \|P\|² 39.06 > 25; the 1st halving gives −0.25, \|P\|² 16.50. |
| 3d | At z1 neither the real Newton step nor any of its 4 halvings reduces \|P\|² | C for the script | Trials 7.875, 3.8125, 1.78125, 0.765625, 0.2578125 give \|P\|² 4358, 343.6, 51.4, 21.03, 16.536, all ≥ 16.504. Under Madsen's rule the halvings *do* succeed relative to each other (Finding 1). |
| 3e | "the real-axis iterates stagnate", and `alterdirection` lets them escape | W as a description of Madsen-Reid / C for the script | Finding 1. |
| 3f | z2 = 0.0546875+0.40625i | C for the script | Exact in `indep.py` and the instrumented run. Madsen's rule gives 0.359375+0.8125i. |
| 3g | Orange: 1st and 3rd are halved Newton steps, 2nd is the rotation | C | `indep.py`: "damped, 1 halving", "alter after 4 halvings", "damped, 1 halving". |
| 3h | Last four segments are full Newton steps (blue); no multi-step | C | labels = [damped ×3, newton ×4]. |
| 3i | Converges to z* = +2i | C | z7 = 1.0e-12+2.0000000000004i, \|P\|² = 2.0e-23. |
| 3j | Alt text: escape via `alterdirection` and convergence to +2i | C for the script | Frames 3–8. |
| 3k | Wiring | C | Manifest. |
| 3l | Legend "Stage 2 – Newton" / "Stage 1 – Damped / alterdirection" | W in stage naming | Finding 2. |

---

### 3. Implementation checks

### `madsreidaa.jl`: Case 1, x³−3x−1, x0 = 3

- **Is it the method it claims to be?** It is Madsen's Stage-1 checked step applied at every iteration: Newton step, |P|² test, m·Δx lengthening up to n=3, halving branch. It has no Ostrowski stage test and therefore no Stage 2 (Finding 2), and its halving/rotation rule is not Madsen's (Finding 1; not reached here). In this run every step it takes is what Madsen's Stage 1 would also take. For the later steps, Madsen's Stage 2 would take the same plain step.
- **Are the numbers right?** Script and `indep.py` agree to the last bit:

  | k | script | indep.py | label |
  |---|---|---|---|
  | 1 | 1.5833333333333333 | 1.5833333333333333 | multi k=2 |
  | 2 | 1.977214541730671 | 1.9772145417306708 | newton |
  | 3 | 1.8857821360790887 | same | newton |
  | 4 | 1.87941539579132 | same | newton |
  | 5 | 1.8793852422466839 | 1.879385242246684 | newton |
  | 6 | 1.8793852415718169 | same | newton |

- **Reference values.** The header comment's x* ≈ 1.8794 is confirmed: mpmath gives 1.879385241571816768 = 2cos(π/9).
- **Does the picture show what was computed?** I viewed all 7 frames on the contact sheet.
  - The green tangent goes from (3,17) to (2.2917,0), runs along the axis to 1.5833, then drops vertically to P(x1) = −1.78.
  - Blue tangents run from (x_k, P(x_k)) to (x_{k+1}, 0).
  - The legend shows x_k to 5 decimals, matching the computed values.
  - Axis limits (−0.5..3.5, −5..22) contain every element. No clamping.

### `madsreidab.jl`: Case 2, (x−1)²(x+2), x0 = 4

- **Is it the method it claims to be?** Same as aa. All steps are lengthened steps, which Madsen also keeps in Stage 1, so the iterates match what Madsen's Stage 1 gives.
- **Are the numbers right?**

  | k | script | indep.py | k used |
  |---|---|---|---|
  | 1 | 0.40000000000000036 | same | 3 |
  | 2 | 1.0857142857142854 | same | 2 |
  | 3 | 1.0011741682974562 | same | 2 |
  | 4 | 1.0000002296437034 | same | 2 |

  Newton points: 2.8, 0.742857, 1.043444, 1.000587. Each is the midpoint of its 2Δx step.
- **Reference values.** The root is 1, exact by factorisation. For comparison, plain Newton's errors after 1 to 15 steps are 1.8 … 3.35e-4 (step 14) … 1.68e-4 (mpmath).
- **Does the picture show what was computed?**
  - Frames 1–2 use the full window. Frame 1 shows the tangent to 2.8, then the thick green run along the axis to 0.4.
  - Frames 3–5 zoom on [start, Newton point, end] ±15%, and each shows the tangent to the midpoint and the axis run.
  - The legend reports x_k to 9 significant digits and matches.
  - Zooming is disclosed on the page and does not misrepresent anything.

### `madsreidac.jl`: Case 3, z²+4, z0 = 1

- **Is it the method it claims to be?** The Newton step, the r0 limit with rotation, and the m·Δz trials (n=2) follow Madsen. The damping/rotation rule does not (Finding 1), and that changes z2 onward. There is no stage test (Finding 2). The P′=0 branch (`alterdirection(r0*0.1)`) differs from Madsen's, which rotates the previous step ×5 from the previous iterate, but it is never reached because z never hits 0.
- **Are the numbers right?** For the rule as implemented, the script and `indep.py` agree exactly:

  | k | script | indep.py (page rule) | Madsen rule (`madsen_ref.py`) |
  |---|---|---|---|
  | 1 | −0.25 | −0.25 | −0.25 |
  | 2 | 0.0546875+0.40625i | same | 0.359375+0.8125i |
  | 3 | −0.28444751+2.72241362i | same | −0.18577342+1.63875947i |
  | 4 | −0.06629461+2.08791569i | same | 0.04370916+2.02433028i |
  | 5 | −0.00276332+2.00088619i | same | 0.00053212+1.99968582i |
  | 6 | −1.226e-6+1.99999829i | same | −8.4e-8+1.99999995i |
  | 7 | 1.05e-12+2.00000000000036i | same | 1.9e-15+2.0i |

- **Reference values.** The roots ±2i are exact.
- **Does the picture show what was computed?** I viewed all 8 frames (contact sheet) and frame 4 at full size.
  - Segments join consecutive iterates: orange for steps 1–3, blue for steps 4–7.
  - The current-point legend matches the iterates at 3 decimals. Frame 7's legend shows "−0.0 + 2.0i", which is cosmetic.
  - Axis limits (−2.5..2.5, −2.8..3.22) contain the whole path, including z3 at Im 2.72. No clamping takes effect.

