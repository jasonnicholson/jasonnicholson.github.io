# Damped Newton with Acceleration (Madsen-Reid Method) — animation review (round 3)

Page: `pages/numerical-methods/madsen-reid-method/`. Reported findings: **0 Error, 1 Misleading, 0 Minor**.

## Findings

### F1. Page match: Misleading. The slow Stage-2 example at x0 = -0.7 is caused by the reference's substitute w, and the page says that substitution makes no difference

**Location:** `index.qmd` line 14: "Only Stage 1 searches, though: Stage 2 takes plain Newton steps, which are linear at a multiple root. Started at $x_0 = -0.7$ instead of 4, Case 2's polynomial gets 19 Stage-2 steps (steps 2 to 20) whose error shrinks by a factor of 0.55 to 0.50 per step … before the stage test fails …". Also line 27: "The scripts copy this, and with $w = f'(z_{k-1}) - f'(z_k)$ the three runs change stage at the same steps."

**What is there now:** The page presents the 19 linear Stage-2 steps as a property of the method: Stage 2 is plain Newton, so it is linear at a double root. Line 27 tells the reader that the reference's substitute `w = f(z_{k-1}) - f'(z_k)`, which mixes P with P', gives the same stage sequence as the intended Kantorovich estimate `w = f'(z_{k-1}) - f'(z_k)`. The reader is left thinking the quirk does not matter for anything the page shows.

**What is true:** Each number in the x0 = -0.7 sentence is right for the reference code (see the ledger). But the 19-step Stage-2 run is a product of the reference's substitute w. With the intended w, which line 27 itself describes as estimating f'', the same start takes Stage 2 only once (step 2). The stage test then fails clearly, and three lengthened steps reach the root at step 5. The line-27 statement is true only for the three animated runs. The page's own fourth run is the one where the choice of w changes everything.

| run, x0 = -0.7, r0 = 3.5 | stages by step | steps | final error |
|---|---|---|---|
| reference w = P(z_{k-1}) - P'(z_k) (scripts; compiled C++) | 1, 2×19, 1 | 21 | 3.5e-11 |
| intended w = P'(z_{k-1}) - P'(z_k) | 1, 2, 1, 1, 1 | 5 | 1.4e-9 |

The reference run's stage test (ratio `4|P|²|w|²/(|P'|⁴|Δz|²)`; Stage 1 when > 1) creeps up toward 1 from below: 0.012, 0.10, 0.42, 0.68, … 0.99998, 0.999994. It exceeds 1 only at step 21, at **1.000023**. So the "stage test fails" exit is a rounding-level event, not a margin. With the intended w the ratio is 1.53 at step 3, a clear failure.

A first-order expansion at x = 1 + e (with e_{k-1} ≈ 2e_k for Newton at a double root) explains why. For the reference w the ratio is ≈ 1 - (13/3)e < 1, so it stays in Stage 2 indefinitely. For the intended w it is ≈ 1 + (5/3)e > 1, so it leaves Stage 2.

**How I know:**
- The compiled reference was run under gdb (`cpp/c2b.gdb`, start overridden to z = -0.7, r0 = 3.5; output in `cpp/c2b.out`). It gave 21 iterations, stage1 = 1,0×19,1, and a final z of 0.99999999996490507.
- `julia variant.jl alg.jl` vs `julia variant.jl alg_variant.jl`. `alg_variant.jl` is the scripts' algorithm block with line `f0 = f; fz0 = fz` changed to `fz0 = fz1`. The output was:
  - x0=-0.7, reference w: `n=21 stages=122222222222222222221`
  - x0=-0.7, intended w: `n=5 stages=12111 kinds=plain,stage2,lengthened,lengthened,lengthened`, final z = 1.000000001376575
  - Cases 1–3: identical stage strings under both versions (`112222`, `11111`, `11112222`), confirming line 27's narrower claim.
- The test ratios come from `julia v3.jl alg_dbg.jl` and `julia v3.jl alg_variant_dbg.jl`.

**Suggested correction:** In line 14, say that the long linear Stage-2 run comes from the reference's stage test with its substitute w. Something like: "…19 Stage-2 steps … This happens because the reference's w = f(z_{k-1}) − f'(z_k) keeps the stage test passing (just barely) near a double root. With w = f'(z_{k-1}) − f'(z_k) the same start takes Stage 2 once and reaches the root in 5 steps." In line 27, qualify "the three runs change stage at the same steps" by adding "(the x₀ = −0.7 run in §1 does not: 5 steps instead of 21)". Alternatively, drop the x0 = -0.7 example as a demonstration of the method's behaviour.

---

- **Independent check:** confirmed. The checker derived the stage test independently: it is the Kantorovich condition 2|f||f"| <= |f'|^2 with f" replaced by w/(z_{k-1}-z_k), which requires w = P'(z_{k-1}) - P'(z_k). The reference stores P(z_k) instead, which is dimensionally inconsistent. Under the correct w, from x0 = -0.7, Stage 2 lasts one step and lengthened Stage-1 steps converge quadratically, 0.412 -> 2.3e-2 -> 9.1e-5 -> 1.4e-9, ending in 5 steps, not 21. The three animated cases are unaffected. Details: checker verify.md.


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `madsreidaa.jl` | 0 | 9.1 | madsreidaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `madsreidab.jl` | 0 | 10.0 | madsreidab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `madsreidac.jl` | 0 | 9.7 | madsreidac.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `madsreidaa.gif` | 7 | byte-identical | madsreidaa |
| `madsreidab.gif` | 6 | byte-identical | madsreidab |
| `madsreidac.gif` | 9 | byte-identical | madsreidac |

### Page references

- Scripts linked: `madsreidaa.jl`, `madsreidab.jl`, `madsreidac.jl`
- GIFs embedded: 3
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

Verdicts are C = confirmed, W = wrong, ND = could not determine.

### Description (formulas and algorithm)

| # | Claim (page wording) | Verdict | Evidence |
|---|---|---|---|
| D1 | Scripts port the iteration of `newton_real` (Newton_Real.cpp) | C | Line-by-line comparison; compiled C++ under gdb gives bit-identical iterates for all three cases (§3) |
| D2 | "robust, globally convergent" (l.10) | ND | General property claim, not checkable from these runs. Line 31 itself says decrease is not guaranteed. |
| D3 | Newton at multiplicity m: f/f' ≈ (x−x*)/m, error factor (m−1)/m | C | Standard; Case 2 plain-Newton errors from x0=4 ratio → 0.500 (`checks.py`) |
| D4 | Stage 1 lengthening tries z−2Δz … up to z−(n+1)Δz, stops at first non-decrease, keeps previous | C | Code l.119–129 (`for i in 1:n`, `wz -= dz`, `fw >= f && break`); C++ l.272–288 |
| D5 | Near multiplicity-m root the kept point is z − mΔz, quadratic until rounding (Case 2) | C | Case 2: k=2 at steps 2–5, error ratios e/e² = 0.16, 0.17 |
| D6 | Stage 2 at x0=−0.7: 19 Stage-2 steps (2–20), factor 0.55→0.50, error 0.41→1.8e-6, then one lengthened step to 3.5e-11 | C (numbers) / see F1 | C++ gdb: errors 0.4123 … 1.7805e-6, ratios 0.5457 … 0.499999, step 21 k=2 to 3.509e-11 |
| D7 | r0 reset to 5×(uncapped) step length; longer step cut to r0 and rotated 53.13° | C | Code l.100–105; C++ l.257–260; atan2(0.8,0.6)=53.13° |
| D8 | Cases 1 and 2 scripts stop with an error on rotation | C | `madsreidaa.jl`/`ab.jl` l.177–178 |
| D9 | No Newton step in the three animations exceeds r0 | C | Traces: `cap=0` everywhere; gdb r vs r0 values |
| D10 | Δz = f/f' | C | Code l.92–93 = fz·conj(fz1)/|fz1|² |
| D11 | Stage 1 halving: each halving kept only while it lowers |f|² below previous trial | C | Code l.120–128 |
| D12 | Two helpful halvings → rotate and halve (×0.5(0.6+0.8i)), accepted | C | Code l.130–135; Case 3 step 2 reproduces z2 = 0.359375+0.8125i |
| D13 | Stage 2: no trial points, ends when |f| ≤ Adams' bound | C | Code l.142–144 and loop condition `f > eps` (both squared) |
| D14 | Stage 2 only after an unchanged (plain) step and test 2|f||w| ≤ |f'|²|z_{k−1}−z_k| | C | `stage1 = f2/u > u/f/4 || f != ff` is algebraically the negation |
| D15 | Test estimates Kantorovich 2|f||f''| ≤ |f'|² | C | Standard form h = |f||f''|/|f'|² ≤ 1/2 |
| D16 | Reference uses w = f'(0)−f'(z) on first iteration, w = f(z_{k−1})−f'(z_k) afterwards | C | C++ l.232 (`fz0 = a[n-1]` = P'(0), z0=0), l.264 (`fz0 = fz`) |
| D17 | With w = f'−f' the three runs change stage at the same steps | C (but see F1) | `variant.jl`: identical stage strings for Cases 1–3 |
| D18 | Saddle branch (f'=0: rotate ×5) and rounding branch exist, neither reached | C | C++ l.246–247, 304–311; traces `saddle=0 rounding=0` |
| D19 | |f|² decrease not guaranteed (halving vs previous trial; rotated unchecked; Stage 2 unchecked) | C | Code structure |
| D20 | In all three animations |f|² decreases every step | C | Case 1: 289→3.17→0.637→2.4e-3→5.2e-8→2.6e-17→3.2e-30; Case 2: 2916→0.746→5.1e-4→1.7e-11→2.5e-26→0; Case 3: 25→16.5→12.37→2.19→0.0405→6.1e-6→1.5e-13→7.9e-29→1.0e-59 |
| D21 | Uses only f and f' plus extra f at trial points | C | Code |
| D22 | "far more reliable than unguarded Newton on difficult polynomials" | ND | Not tested; general claim |
| D23 | Deflation by 1 or 2, remaining linear/quadratic solved analytically | C | C++ l.317–333 (not run by scripts, as the scripts state) |
| D24 | Generalization note (applicable to nonlinear systems, alternative to trust-region) | ND | Opinion, not checkable |

### Animations intro

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| A1 | Blue = plain Newton z−Δz; green = lengthened k≥2 drawn as tangent to Newton point then along axis; orange = halved/rotated | C | `stepcolor`, drawing code l.199–207; frames |
| A2 | Point label names the stage of the step that reached it | C | Label code; e.g. Case 1 frame 4 "x3 … (Stage 2)" matches trace |
| A3 | Cases 1 and 2 use own x0 with r0 = 5|x0|; Case 3 starts where the reference does | C | Scripts l.14–15; gdb without override for z²+4 prints `START z=1+0i r0=5` |
| A4 | Case 3 star markers show the exact roots | C | Stars at ±2i (frames) |
| A5 | Julia sources linked under each case | C | Links present; each script's frame title matches its case |

### Case 1: P(x) = x³ − 3x − 1, x0 = 3.0

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| C1.1 | Function and x0 = 3.0 | C | Script l.10–14; frame title |
| C1.2 | Three simple real roots | C | numpy: 1.8794, −1.5321, −0.3473 |
| C1.3 | |P|² = 17.3, 3.17, 8.73 at Δx, 2Δx, 3Δx | C | mpmath: 17.3075, 3.17079, 8.73249 |
| C1.4 | x1 = x0 − 2Δx ≈ 1.5833, green, passes the root | C | 1.583333…; root 1.8794 lies between x0 and x1; frame 2 green |
| C1.5 | Every later step plain; step 2 Stage 1, steps 3–6 Stage 2; no halving | C | Trace stages 1,1,2,2,2,2; kinds lengthened, plain, stage2×4 |
| C1.6 | x* ≈ 1.8794 | C | 2cos(π/9) = 1.87938524157… |
| C1.7 | Errors 9.8e-2, 6.4e-3, 3.0e-5, 6.7e-10 over steps 2–5; quadratic | C | 9.783e-2, 6.397e-3, 3.015e-5, 6.749e-10; e/e² → 0.742 = P''/(2P') |
| C1.8 | x6 equals x* to double precision | C | x6 = 1.8793852415718169 = nearest double to 2cos(π/9) |
| C1.9 | |P| below Adams' bound at x6, run stops | C | |P|² = 3.16e-30 < eps = 2.45e-27 |
| C1.10 | Alt text (doubled first step, Stage 2 from step 3, quadratic) | C | As above |

### Case 2: P(x) = (x−1)²(x+2), x0 = 4.0

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| C2.1 | Function (= x³−3x+2) and x0 = 4 | C | Expansion; script l.10–14 |
| C2.2 | Double root at 1 with P'(1) = 0 | C | Factored form |
| C2.3 | Standard Newton from 4: error roughly halves, 3.4e-4 after 14 steps | C | `checks.py`: 3.354e-4 at step 14; ratios 0.58→0.50 |
| C2.4 | Lengthened every step, all green, all Stage 1; 3Δx to x1 = 0.4 past the root, then 2Δx four times | C | Trace k=3,2,2,2,2, stage1 all; frames all green |
| C2.5 | Run starts in Stage 1; a lengthened step never leads to Stage 2 | C | ff initialised to 2a_n² ≠ f; after lengthening f < ff so `f != ff` |
| C2.6 | Errors of x2–x4: 8.6e-2, 1.2e-3, 2.3e-7, quadratic | C | 8.571e-2, 1.174e-3, 2.296e-7; e/e² = 0.16, 0.17 |
| C2.7 | x5 ≈ 0.99999999952, error 4.8e-10 | C | 0.9999999995193409; 4.807e-10 |
| C2.8 | Computed |P(x5)|² exactly 0, true ≈ 4.8e-37; run stops | C | feval (Python port) → 0.0; mpmath 4.804e-37 |
| C2.9 | No step halved | C | halvings=0 |
| C2.10 | From x2 on the window zooms; steps shrink from 0.69 to 2.3e-7 | C | Code `frame ≥ 2`; step lengths 0.6857 … 2.301e-7; frames 3–6 |
| C2.11 | Each zoomed frame shows the tangent reaching the axis halfway, then the second Δx along the axis | C | Frames 3–6: Newton point at the midpoint (e.g. 0.743 between 0.4 and 1.086) |
| C2.12 | Alt text | C | As above |

### Case 3: P(z) = z² + 4, z0 = 1 + 0i

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| C3.1 | Roots ±2i, no real roots | C | Trivial |
| C3.2 | Runs the loop on the quadratic from reference start z0 = 1, r0 = 5 | C | startpoint = 2, z = u/2 = 1, r0 = 2.5u = 5 (gdb START line) |
| C3.3 | Full step to −1.5 increases |P|² (39.1 vs 25) | C | 39.0625 vs 25 |
| C3.4 | One halving to z1 = −0.25; second halving to 0.375 does not help | C | 16.504 < 39.06; 17.145 > 16.504 |
| C3.5 | At z1 full step to 7.875 increases |P|², two halvings help (3.8125, 1.78125) | C | 4358 > 16.5; 343.6 < 4358; 51.45 < 343.6 |
| C3.6 | Rotate and halve: z2 = 0.359375 + 0.8125i | C | mpmath and trace |
| C3.7 | Orange = halved steps 1, 3 and rotated step 2 | C | Trace kinds; frames 2–4 orange |
| C3.8 | Step 4 plain in Stage 1; steps 5–8 Stage 2 blue; quadratic to +2i | C | Stages 1,1,1,1,2,2,2,2; error ratios e/e² = 0.247, 0.250, 0.244 (→ 1/4 = |P''/(2P')|) |
| C3.9 | Stops at z8 with |P| ≈ 3.2e-30 below Adams' bound | C | |P(z8)| = 3.155e-30; bound √eps = 6.2e-15 |
| C3.10 | No lengthened step; path a polyline | C | Trace; frames |
| C3.11 | Alt text | C | As above |

### Wiring and counts

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| W1 | Each case links/embeds its own script/GIF | C | aa ↔ simple root, ab ↔ double root, ac ↔ complex (frame titles) |
| W2 | Committed GIFs are what the scripts produce | C | Manifest: byte-identical regeneration; frames 7/6/9 = steps + 1 |

---

### 3. Implementation checks

All three scripts contain the same algorithm block (`newton_real_iterates`, `feval`, `upperbound`, `alterdirection`). The block in `madsreidaa.jl` and `madsreidab.jl` is byte-identical, and `madsreidac.jl` differs only in a comment line.

**Method.** This is Vestermark's `newton_real` iteration loop, i.e. Madsen's Newton method for real-coefficient polynomials. It includes:
- Stage 1 search (lengthening/halving/rotation);
- Stage 2 with Adams' bound;
- the r0 cap;
- the saddle-point and rounding branches;
- the reference's own w substitution.

Only the first root's loop is run; deflation is not. The page names this variant explicitly. I compared it line by line with `Newton_Real.cpp` lines 229–312. The ported constants are correct:
- `2^-106` = `_DBL_RADIX^(-2·DBL_MANT_DIG)`;
- `2^-52` = `^(-DBL_MANT_DIG+1)`;
- `2^-26` = `^(-DBL_MANT_DIG/2)` with C integer division.

**Numbers: strongest check.** I compiled the unmodified reference: `cpp/driver.cpp` `#include`s it from its original location, with an empty `stdafx.h`, `-D_DBL_RADIX=2`, `-std=c++14`. I ran it under gdb with breakpoints at lines 242, 245, 304 and 314. For Cases 1 and 2 the gdb script overrides z, dz, f, r and r0 at line 242 to the case's start. For Case 3 it jumps past `while (n > 2)` so that the loop runs on the quadratic. Commands are in `cpp/c1.gdb`, `c2.gdb`, `c3.gdb`, `c2b.gdb`; outputs are in `cpp/c*.out`. The C++ iterates, |P|², stage flags and eps agree with the scripts' printed traces to every printed digit (17 significant):

| Case | Script final iterate | C++ final iterate | Stages script / C++ |
|---|---|---|---|
| 1 | 1.8793852415718169 | 1.8793852415718169 | 112222 / 1,1,0,0,0,0 (stage1 flag) |
| 2 | 0.9999999995193409 | 0.99999999951934093 | 11111 / all 1 |
| 3 | −7.888609052210118e-31 + 2.0i | −7.8886090522101181e-31 + 2i | 11112222 / 1,1,1,1,0,0,0,0 |

Intermediate iterates match as well, e.g. Case 3 z3 = −0.18577342058459634 + 1.638759472626044i in both.

**Numbers: method-independent checks** (`checks.py`, mpmath at 50 digits):
- **Case 1:** the root is 2cos(π/9). Errors fall quadratically with e_{k+1}/e_k² → 0.7422, which equals P''(x*)/(2P'(x*)) = 0.74223.
- **Case 2:** errors with k = 2 give e/e² ≈ 0.16–0.17, which is quadratic, as expected for the multiplicity-corrected step. The final residual is 4.8e-37 (true) against 0 (computed).
- **Case 3:** e/e² → 0.25 = |P''/(2P')| at 2i.
- **Hand computation:** the first-step trial values were recomputed by hand: 17.31/3.17/8.73 for Case 1, and 39.06/16.50/17.14/4358/343.6/51.45 for Case 3.

**Reference values.**
- **Case 1:** root 1.8794 = 2cos(π/9), confirmed by numpy and mpmath.
- **Case 2:** roots 1 (double) and −2, by factorisation.
- **Case 3:** roots ±2i, drawn as stars at (0, ±2).

None of these is computed numerically by the scripts.

**Picture.**
- **Case 1** (frames 1, 2, 4, 7 viewed):
  - The tangent runs from (3, 17) to (2.2917, 0), slope 24 = P'(3).
  - The axis segment runs to 1.5833 and then a vertical rises to P(x1).
  - Steps 3–6 are sub-pixel at this scale, and frames 5–7 differ only in the label. The page does not claim otherwise.
  - Labels round correctly, e.g. x4 = 1.87942 for 1.8794154.
- **Case 2** (all 6 frames viewed):
  - Frame 2 shows the tangent from (4, 54) to the Newton point 2.8, then the axis to 0.4 (= 4 − 3·1.2).
  - Frames 3–6 zoom to each step with the Newton point at the midpoint.
  - Tick labels get enough decimals to be told apart (8 at the last step).
  - The rounding noise of x³−3x+2 near 1 (~4e-16) is about 0.3% of the last frame's y-range (1.6e-13), so the curve is drawn faithfully.
  - The 11-significant-digit labels match the trace.
- **Case 3** (all 9 frames viewed):
  - The polyline runs through z0 … z8 with colours by step kind: orange 1–3, blue 4–8.
  - Every iterate lies inside the fixed window [−2.5, 2.5] × [−2.8, 2.8]; no clamping changes what is shown.
  - Labels match the trace, e.g. "z2 = 0.359 + 0.812i", "z8 = −7.9e-31 + 2.000i (Stage 2)".
- **All cases:** no NaN masking or clamping of iterates. The Case 1/2 off-axis guard was never triggered.

**Could not determine:** D2, D22, D24 (general claims not testable by these runs).

