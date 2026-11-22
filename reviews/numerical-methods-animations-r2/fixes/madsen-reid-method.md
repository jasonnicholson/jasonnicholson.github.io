# Fix record: madsen-reid-method

Scratch folder (all evidence, re-runnable): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r2fix/madsen-reid-method/fix/` (below: `$S`).

Reference (decision R2-C): Vestermark's `newton_real`, `Newton_Real.cpp` (Future Team ApS, 2002), fetched with `curl -sSL -A "Mozilla/5.0" -o $S/ref/Newton_Real.cpp https://www.hvks.com/Numerical/Downloads/Newton_Real.cpp` (340 lines). It stays in scratch and is not copied into the repository; the scripts contain an independent Julia port of its iteration loop, with a link to the file.

## How the port was verified

Three implementations were run on the same polynomials and starts and compared iterate by iterate, bit for bit (stage, Re z, Im z, |P|², eps at every iteration):

1. **The reference itself.** `$S/cpp/nr_instr.cpp` / `nr_hex.cpp` are scratch copies of `Newton_Real.cpp` with only these changes: `stdafx.h` removed, `_DBL_RADIX` defined as 2, a trace `printf` at the end of the loop body, and an opt-in override of the start point, `r0` and the `while (n > 2)` bound (so the loop can run from a given start, and on a quadratic). Built with `g++ -std=c++11 -O0 -ffp-contract=off -Dregister=`.
2. **Python transcription** `$S/py/ref_transcription.py`, written line by line from the C++.
3. **Julia port** `$S/jl/port_block.jl`, the block pasted unchanged into all three page scripts.

Command: `$S/cpp/nrhex`, `python3 -I $S/py/harness.py`, `julia $S/jl/harness.jl` over the case files, then `python3 -I $S/py/compare.py out_cpp.txt out_py.txt out_jl.txt`:

| Test set | Polynomials | Iterations compared | Mismatches | Branches exercised |
|---|---|---|---|---|
| `cases.txt` (3 page cases + 200 random, degree 2–7) | 203 | 1349 | 0 | plain, lengthened, halved, rotated, Stage 2 (754 rows), cap (27) |
| `cases2.txt` (saddle points, multiple roots) | 12 | 33 | 0 | saddle (P′ = 0) ×3 |
| `cases3.txt` (multiple roots, searched for rounding branch) | 15 | 184 | 0 | rounding-domain retry (84 rows), increased-full-step (7), cap (10) |

The page scripts' own printed traces (`julia madsreid{aa,ab,ac}.jl`) match the Python trace for step kind, lengthening multiple k and number of halvings at every step.

## Findings

### F1 — Error — fixed
- **Reproduced.** The old scripts' `else` branch halved up to 4 times against |P(z)|² and then rotated dz/16 unchecked. The old `madsreidac.jl` printed z2 = 0.0546875 + 0.40625i. The reference (instrumented C++) from the same start z0 = 1, r0 = 5 gives z2 = (0.359375, 0.8125). The C++ search (lines 269–297) halves while each halving beats the previous trial (`fw >= f` breaks). After the 2nd helpful halving it calls `alterdirection(&dz, 0.5)` and accepts z0 − dz. The brief's independent-check note quotes the 1975 report (¼·e^{iθ}, 36.87°). Under R2-C the reference is `Newton_Real.cpp`, and its rule is 0.5·(0.6 + 0.8i), which is 53.13°, as the reviewer wrote.
- **Change.** All three scripts now run a faithful port of the `newton_real` loop (`newton_real_iterates` in each `.jl`): the Stage-1 lengthening up to (n+1)Δz, halving against the previous trial, rotation after two helpful halvings, the r0 cap with rotation, the saddle-point and rounding-domain branches, Stage 2 with Adams' bound, and the reference's stopping test. `index.qmd`: section 2 rewritten (the Stage 1 bullet); the Case 3 Behavior paragraph, alt text and script header rewritten from the new run.
- **Check.** The 0-mismatch comparisons above. Case 3 new trace (C++ = Python = Julia): z1 = −0.25 (halved 1), z2 = 0.359375 + 0.8125i (rotated), z3 = −0.18577 + 1.63876i (halved 1), z4 plain Stage 1, z5–z8 Stage 2, z8 = −7.9e−31 + 2i. Frames viewed: see below.

### F2 — Error — fixed
- **Reproduced.** The old scripts had no stage logic. Each step labelled "Stage 2 – Newton" was a Stage-1 search ending at k = 1. The page defined Stage 2 as "doubled step does not help".
- **Change.** The port implements the reference's stage test `stage1 = f2/u > u/f/4 || f != ff`. Stage 2 takes plain steps and computes `upperbound` (Adams). Legends now name step types ("plain Newton step", "lengthened step", "halved / rotated step"). (The dashed Stage-2 style was removed after the check; see "Round 2 after check".) Each current-point label names the stage of the step that reached it. `index.qmd` section 2 now describes Stage 1 as the checked search and Stage 2 as unchecked plain Newton, entered only after a plain step when the test passes. The Animations intro and the three Behavior paragraphs give the actual stages.
- **Check.** Stages per run (`$S/py/stage_test.py`):
  - Case 1: S1, S1, S2, S2, S2, S2.
  - Case 2: S1 ×5. Each step follows a lengthened step, so `f != ff`.
  - Case 3: S1 ×4, S2 ×4.

  The rewritten inequality 2|P||w|/|Δz| > |P′|² agrees with `f2/u > u/f/4` at every iteration of the three runs (`same=True`).

  Quirk found in the reference: after the first iteration `fz0 = fz` stores P(z_{k−1}), not P′(z_{k−1}) (line 264), so w = P(z_{k−1}) − P′(z_k). On the first iteration w = P′(0) − P′(z0), because z0 = 0 and fz0 = a[n−1] (lines 230–232). The variant with fz0 = P′(z_{k−1}) (`$S/py/variant_fz0_derivative.py`) gives identical stages and iterates in all three cases. The scripts copy the reference, and the page says so.

### F3 — Minor — not reproduced (not a defect under R2-C)
- **Reproduced the behaviour, not the defect.** r0 is set from the pre-cap length. The reference does the same: C++ lines 257–260 compute `r` before `alterdirection(&dz, r0/r)` and then set `r0 = r * 5.0`. R2-C classes this as matching the reference. The port keeps it.
- **Change.** Wording only. Line 16 now reads "reset after each Newton step to five times that step's length before the cap", which makes the existing behaviour explicit.
- **Check.** The cap never acts: `cap=0` at every step of all three runs (`limited` False in the Python trace; C++ agrees bit for bit).

## Ledger of changed text

Evidence commands (all from `$S`):
- **[T]**: `python3 -I py/ref_transcription.py`
- **[N]**: `python3 -I py/page_numbers.py $S/py`
- **[S]**: `python3 -I py/stage_test.py $S/py`
- **[M]**: the mpmath block run inline (recorded in `py/page_numbers.py` output and the session). It gives x* = 1.8793852415718167681, the errors and ratios, the |P|² sequences, and the stop-condition check.
- **[C]**: the C++ trace `cpp/nr 3 1 0 -3 -1 3.0 15.0 2` etc.

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| Description ¶1 | "follows Madsen's method as implemented by Vestermark … `newton_real` (Newton_Real.cpp, Future Team ApS, 2002)" + link | File header lines 5–6, 25, 202–204 of the downloaded file | yes |
| §1 | Lengthening runs in Stage 1 when z − Δz does not increase \|f\|² | C++ `div2 = f > f0`; the `else` branch lengthens | yes |
| §1 | "up to z − (n+1)Δz" | C++ `for(i=1..n)`, `wz -= dz` starting from wz = z0 − dz, so the last trial is z0 − (n+1)dz | yes |
| §1 | "stops at the first trial that does not lower \|f\|², and keeps the trial before it" | C++ `if (fw >= f) break;`. Case 1 step 1 stops at 3Δx (8.73 ≥ 3.17) although 4Δx would give 2.24 [N] | yes |
| §1 | "near a root of multiplicity m that point is z − mΔz … quadratically until rounding error takes over (Case 2)" | General: \|f(z−kΔz)\| ∝ \|1−k/m\|^m near the root. Case 2 takes k = 2 at steps 2–5. e_{k+1}/e_k² = 0.238, 0.160, 0.167, then 9114 at step 5 [M] | yes |
| §1 r0 | "reset after each Newton step to five times that step's length before the cap" | C++ lines 257–260 | yes |
| §1 cap | "cut to length r0 and rotated by 53.13°" | `alterdirection(&dz, r0/r)`. \|0.6+0.8i\| = 1, angle 53.1301° [M] | yes |
| §1 cap | "their scripts stop with an error if one occurs" | Guard `all(s -> imag(s.z) == 0.0 && imag(s.zN) == 0.0, steps) \|\| error(...)` in aa/ab | yes |
| §1 cap | "No Newton step … longer than r0, so the cap never acts" | `cap=0` in all 19 iterations of the three runs [T], Julia trace | yes |
| §2 heading | "Safety — the two stages" | — | yes |
| §2 lead | Newton step, cap, one of two stages | C++ lines 250–261, 269 | yes |
| §2 Stage 1 | Halving kept only while it beats the previous trial | `fw >= f` break, with f updated to each accepted trial | yes |
| §2 Stage 1 | Two helpful halvings lead to a rotation by 53.13° and one more halving (×0.5(0.6+0.8i)), accepted | `if(div2 && i==2){ alterdirection(&dz,0.5); z = z0 - dz; f = feval(...); break; }` | yes |
| §2 Stage 1 | "can only be shown in Case 3" | Cases 1–2 contain no rotation [T]. The guard covers it | yes |
| §2 Stage 2 | "no trial points … ends the run once \|f(z)\| is no larger than Adams' bound" | `else eps = upperbound(...)` (squared bound). Loop condition `f > eps` | yes |
| §2 Stage 2 | Used only after a plain step and when 2\|f(z_k)\|\|w\| ≤ \|f′(z_k)\|²\|z_{k−1}−z_k\| | Algebra: f2/u ≤ u/(4f) ⇔ 4·f·f2 ≤ u² ⇔ 2\|P\|\|w\|/\|Δ\| ≤ \|P′\|². Numerical agreement at every iteration [S] `same=True`. `f != ff` ⇔ the search moved the point | yes |
| §2 Stage 2 | "estimates Kantorovich's condition 2\|f\|\|f″\| ≤ \|f′\|²" | Scalar Kantorovich: (1/\|f′\|)·\|f/f′\|·L ≤ ½ ⇔ 2\|f\|L ≤ \|f′\|², with L estimated by \|w/Δz\| | yes |
| §2 Stage 2 | Reference forms w from f′ only on the 1st iteration (origin as previous point), then w = f(z_{k−1}) − f′(z_k); same stages with f′ | Lines 230–232, 253, 264. Variant run → identical stages and iterates in all three cases | yes |
| §2 branches | Saddle: previous step rotated 53.13° and lengthened 5×. Rounding: step < 2^{−26}\|z\| with no decrease is retried from its start, rotated and halved. "Neither is reached" | Lines 246–247, 304–311 (`DBL_MANT_DIG/2` = 26). `saddle=0 rounding=0` in all three traces | yes |
| §2 last ¶ | "each halving is compared with the previous trial …, the rotated step is accepted without a check, and Stage-2 steps are not checked at all" | Code as above | yes |
| §2 last ¶ | "In all three animations \|f\|² does decrease at every step" (unchanged sentence, new runs) | Computed f per step [T]: Case 1: 289 → 3.17 → 0.637 → 2.38e−3 → 5.2e−8 → 2.6e−17 → 3.2e−30. Case 2: 2916 → 0.746 → 5.1e−4 → 1.7e−11 → 2.5e−26 → 0. Case 3: 25 → 16.50 → 12.37 → 2.19 → 0.0405 → 6.1e−6 → 1.5e−13 → 7.9e−29 → 1.0e−59 | yes |
| Animations intro | Colour = step type; the label names the stage (the dashed-segment sentence was removed after the check) | Script code `stepcolor`, label strings. Frames viewed (v3) | yes |
| Animations intro | "Cases 1 and 2 start from their own x0 with r0 = 5\|x0\| rather than the reference's start-point rule; Case 3 starts where the reference does" | Reference starts [T]: Case 1 −1/6 (r0 0.833), Case 2 1/3 (1.667), Case 3 1 (r0 5.0). Scripts: r0 = 5·abs(x0) | yes |
| Case 1 | \|P\|² = 17.3, 3.17, 8.73 at Δx, 2Δx, 3Δx | [N] 17.3075, 3.17079, 8.73249 | yes |
| Case 1 | x1 ≈ 1.5833 (lengthened, green), passes the root | x1 = 1.583333333333333 [C], error 0.296 | yes |
| Case 1 | Later steps plain. Step 2 Stage 1, steps 3–6 Stage 2. No step halved | [T]/[S] kinds: lengthened, plain, stage2 ×4 | yes |
| Case 1 | x* ≈ 1.8794; errors 9.8e−2, 6.4e−3, 3.0e−5, 6.7e−10 (steps 2–5) | [N] 0.0978293, 0.00639689, 3.01542e−5, 6.74867e−10. x* = 1.8793852415718167681 | yes |
| Case 1 | x6 equals x* to double precision; \|P\| below Adams' bound stops the run | float(x*) == 1.8793852415718169 == x6: True. Final \|P\| 1.78e−15 < bound 4.95e−14 (the only failing loop condition) | yes |
| Case 1 alt | "doubled first step … plain Newton steps, Stage 2 from step 3 on, converging quadratically … x≈1.8794" | As above | yes |
| Case 2 | "lengthened step every time … all in Stage 1 … a lengthened step never leads to Stage 2" | [S] stage1 ×5. A lengthened step is taken only when fw < f, so f ≠ ff and the next step is Stage 1 | yes |
| Case 2 | 3Δx to x1 = 0.4, then 2Δx four times | [T] k = 3, 2, 2, 2, 2. x1 = 0.3999999999999999 | yes |
| Case 2 | Errors 8.6e−2, 1.2e−3, 2.3e−7 of x2–x4 fall quadratically | [M] 0.08571, 0.001174, 2.296e−7. Ratios 0.160, 0.167 | yes |
| Case 2 | x5 ≈ 0.99999999952, error 4.8e−10; computed \|P(x5)\|² exactly 0, true ≈ 4.8e−37; the run stops | [C] 0.99999999951934093, f = 0. [M] true 4.804e−37, error 4.807e−10. Stop: f > eps False | yes |
| Case 2 | "No step is halved" | [T] | yes |
| Case 2 | Steps shrink from 0.69 to 2.3e−7 | [M] \|x2−x1\| = 0.6857, \|x5−x4\| = 2.301e−7 | yes |
| Case 2 | Zoomed frames: tangent reaches the axis halfway, then the second Δx | Newton point 1.0000001145815212 = midpoint of x4, x5. Frames 3–6 viewed | yes |
| Case 2 alt | "five lengthened steps (3Δx, then 2Δx four times) … quadratically until rounding ends the run at x₅" | As above | yes |
| Case 3 | "The reference solves a quadratic in closed form, so this case runs its iteration loop on z²+4 directly, from the reference's own start z0 = 1 with r0 = 5" | C++ `while(n > 2)` then `quadratic(n,a,res)`. [T] reference start (1+0j), 5.0 | yes |
| Case 3 | Full step to −1.5 increases \|P\|² (39.1 vs 25). One halving gives −0.25. The 2nd halving, to 0.375, does not help | [M] 39.0625, 25. [N] 16.5039 vs 17.1448 | yes |
| Case 3 | At z1 the full step to 7.875 increases \|P\|². Two halvings help (3.8125, then 1.78125). Rotation gives z2 = 0.359375 + 0.8125i | [M] 4358.06 > 16.50; 343.55 < 4358; 51.45 < 343.55. z2 by hand = (0.359375+0.8125j). [C] same | yes |
| Case 3 | Orange = halved steps 1, 3 and rotated step 2. Step 4 plain, Stage 1. Steps 5–8 Stage 2 (blue) | [T]/[S] kinds and stages. Frames 2–9 viewed | yes |
| Case 3 | "converging quadratically to +2i" | [M] e_{k+1}/e_k² = 0.247, 0.250, 0.244 (steps 5–7) ≈ \|f″/(2f′)\| = 1/4 | yes |
| Case 3 | Stops at z8 with \|P\| ≈ 3.2e−30, below Adams' bound | [C] f = 9.957e−60 → \|P\| = 3.16e−30. Bound 6.22e−15. Only `f > eps` fails | yes |
| Case 3 | "No lengthened step occurs" | [T] | yes |
| Case 3 alt | "from z₀=1 a halved step, then a step rotated off the real axis after two helpful halvings, a further halved step, and plain Newton steps converging to … +2i" | As above | yes |
| Scripts: headers | aa/ab "(as implemented by Vestermark)"; ac header describes the two-halving rotation and the closed-form note | As above | yes |
| GIF legends | "plain Newton step x − Δx", "lengthened step x − kΔx", "halved / rotated step" (the "dashed: Stage 2" entry was removed after the check) | Matches `stepcolor` | yes |
| GIF labels | Case 1 "x6 = 1.87939 (Stage 2)". Case 2 `sigdigits=11` ("x5 = 0.99999999952 (Stage 1)"; at 9 digits it would have shown "1.0"). Case 3 values to 3 decimals, values under 5e−4 in %.1e, exact 0 as "0" | Frames 7 (aa), 6 (ab), 1/3/6/9 (ac) viewed at full size | yes |

## Scripts and GIFs
- **Scripts changed:** `madsreidaa.jl`, `madsreidab.jl`, `madsreidac.jl`. Each holds the same port block, built from `$S/parts/*_head.jl` + `$S/jl/port_block.jl` + `$S/parts/*_tail.jl`. The old 4-halving rule and the stage-free loop are gone. The cases' polynomials, x0 and windows are unchanged. The initial r0 for Cases 1–2 is now 5|x0| (was 2.5|x0|); this has no effect because the cap never acts.
- **Case 2:** an x-tick formatter with enough decimals for the zoomed frames (frame 6 spans 2.3e−7, and the default ticks were overlapping "1.00000000×10⁰" labels).
- **Case 3:** the label formatter fixes the old cosmetic "−0.0 + 2.0i".
- **GIFs regenerated:**
  - `madsreidaa.gif`: 7 frames.
  - `madsreidab.gif`: 6 frames (was 5).
  - `madsreidac.gif`: 9 frames (was 8).
  - A second run of all three scripts reproduced the GIFs byte for byte (md5 check).
- **Frames viewed** (`$S/frames/v1_*`, `v2_ab`, `v2_ac`):
  - Case 1: frames 2, 4 and 7 at full size. Green tangent to 2.2917 then along the axis to 1.5833. Blue plain steps follow. The labels show the stage.
  - Case 2: the contact sheet, and frame 6 at full size. Each zoomed frame shows the tangent to the midpoint and then the axis run. The legend shows x5 = 0.99999999952. Tick labels are legible.
  - Case 3: the contact sheet, and frames 1, 3, 6 and 9 at full size. Orange segments: 1 → −0.25, then the rotation to 0.359+0.812i, then the halved step to −0.186+1.639i. Blue from there. Labels read z0 = 1.000 + 0i … z8 = −7.9e−31 + 2.000i (Stage 2).
  - The Stage-2 steps were too short to show their dashes in the full windows. The dashed style was removed after the check, and the stages are shown by the point labels only.
- **git status of the page folder:** `M index.qmd`, `M madsreidaa.{jl,gif}`, `M madsreidab.{jl,gif}`, `M madsreidac.{jl,gif}`. No other files.

## Legacy archive
Consulted. `grep -ril "madsen\|alterdirection"` over the archive finds only unrelated bibliography entries (Nels Madsen on pivoting; Hald & Madsen on l1 optimisation; Madsen, Nielsen & Pinar on LP). There is no Madsen-Reid topic and no legacy GIF. The page follows the reference implementation named in R2-C.

## Notes
- **R2-C vs the brief's F1 check note.** The independent check quoted the 1975 report (¼·e^{iθ}, θ = 36.87°). R2-C makes `Newton_Real.cpp` the reference, and its rule is 0.5·(0.6+0.8i) at 53.13° after two helpful halvings, so that is what the scripts and page use. The page cites [@madsenReid1975] for the method and links the implementation inline. Adding a Vestermark bib entry would mean editing `references.bib`, which is outside this page folder, so I did not.
- **Reference quirk** (`fz0 = fz` stores P, not P′, after the first iteration): ported as is and stated on the page. In these runs it changes nothing.
- **Case 3 on a quadratic.** The reference never iterates on a quadratic. This is now stated on the page rather than changing the case.
- **The reference's start-point rule** would start Cases 1 and 2 elsewhere (−1/6 and 1/3). The cases keep their own x0, and the page says so.
- **Not touched** (not findings): Description claim D1 ("globally convergent", ND in the review), the generalisation note, the deflation paragraph, and section 3.

## Round 2 after check

The independent check confirmed F1 and F2 resolved (it compiled the reference and matched the scripts bit for bit) and F3 not a defect. It raised two new items.

### N1 — Misleading — fixed
- **Reproduced.** The §1 heading "Quadratic convergence — even at multiple roots" is not true of `newton_real` in general. On Case 2's polynomial x³ − 3x + 2 started at x0 = −0.7 (r0 = 3.5):
  - Step 1 is a plain Stage-1 step.
  - Steps 2 to 20 are Stage-2 plain Newton steps. Their error falls 0.412, 0.218, … 1.78e−6, with ratios 0.546 → 0.5000.
  - At step 21 the stage test fails: 2|P||w|/|Δz| = 1.141e−10 > |P′|² = 1.141e−10 by rounding, with f == ff. The step goes back to Stage 1 and a lengthened 2Δx step reaches x = 0.9999999999649051, error 3.5e−11.
  - Evidence: `python3 -I py/ref_transcription.py` iterate with (−0.7, 3.5), `$S/py/stage_test_n1.py`, and the C++ reference `cpp/nr 3 1 0 -3 2 -0.7 3.5 2` (TRACE k=20 z = 1.0000017804885653, Stage 2; k=21 z = 0.99999999996490507, Stage 1). All three agree.
- **Change.** In `index.qmd`, heading "### 1. Quadratic convergence — even at multiple roots" → "### 1. Lengthened steps at multiple roots". I added after "(Case 2)": "Only Stage 1 searches, though: Stage 2 takes plain Newton steps, which are linear at a multiple root. Started at $x_0 = -0.7$ instead of 4, Case 2's polynomial gets 19 Stage-2 steps (steps 2 to 20) whose error shrinks by a factor of 0.55 to 0.50 per step, from 0.41 to $1.8 \times 10^{-6}$, before the stage test fails and one lengthened step brings the error to $3.5 \times 10^{-11}$."
- **Ledger:**

| Location | New text / number | Check | Confirmed |
|---|---|---|---|
| §1 heading | "Lengthened steps at multiple roots" | Describes the mechanism only; no convergence claim | yes |
| §1 | "Only Stage 1 searches … Stage 2 takes plain Newton steps, which are linear at a multiple root" | Code: the Stage-2 branch has no search. Run above: ratio → 0.5000 = (m−1)/m | yes |
| §1 | 19 Stage-2 steps (steps 2–20) | Trace above: steps 2..20 Stage 2 | yes |
| §1 | "shrinks by a factor of 0.55 to 0.50 per step, from 0.41 to 1.8e−6" | Errors 4.123e−1 … 1.780e−6; ratios 0.5457 (step 3/2) decreasing to 0.5000 (step 20/19) | yes |
| §1 | "before the stage test fails and one lengthened step brings the error to 3.5e−11" | it21: test True with f==ff, so Stage 1; kind lengthened k=2; error 3.509e−11 | yes |

### N2 — Minor — fixed
- **Reproduced.** In the v1/v2 frames, the dashed Stage-2 segments in `madsreidaa.gif` and `madsreidac.gif` are a few pixels long and show no dashes (frames 4 and 7 of aa, 6 and 9 of ac).
- **Change, the smallest one.** I removed the dashed line style and the "dashed: Stage 2 (unchecked)" legend entry from all three scripts. In `index.qmd` I dropped the sentence "Solid segments are Stage-1 steps and dashed segments Stage-2 steps"; the remaining sentence says the point label names the stage. Nothing on the page mentions dashes now (`grep dash index.qmd` → none).
- **Check.** All three GIFs regenerated (7, 6 and 9 frames, as before). Frames `$S/frames/v3_*` viewed: aa frame 4 ("x3 = 1.88578 (Stage 2)"), ab frame 6 ("x5 = 0.99999999952 (Stage 1)"), ac frame 9 ("z8 = −7.9e−31 + 2.000i (Stage 2)"). The legends list only P/roots, the current point, z0, and the step types. The printed iterate traces are unchanged (same values as before).

## Resolution check (independent checker, not shown this record)

Reference (owner decision R2-C): Vestermark's `newton_real`, Newton_Real.cpp, fetched to
`check/ref/Newton_Real.cpp` (scratch only, 340 lines, v01.01 HVE/021018).

I checked the reference three ways, independently of the fixer's code:
1. `check/nr.py` is my own line-by-line Python transcription of the iteration loop. It keeps complex values as (re, im) pairs and logs every trial point.
2. `check/cpp/nr_instr.cpp` is the actual reference C++, compiled with g++ in scratch. The only changes are a stub `stdafx.h`, `_DBL_RADIX 2`, a hook to set the start point and r0, a printf at the end of each iteration, and `while(n > MINN)` so the loop also runs for n = 2.
3. The fixer's three Julia scripts, run from scratch copies (`check/run/`).

All three give the same iterates, |P|², eps and stage, **bit for bit**, at every step of all three cases (`check/nr_out.txt`, `check/run/out_*.txt`, the C++ output in the log below).

### Original findings

### F1 — resolved
- **Script.** The halving rule is now the reference's. `for i in 1:n`: halve `dz` and compare `fw` with the previous trial `f` (`fw >= f && break`). At `div2 && i == 2`, set `dz = alterdirection(dz, 0.5)` and accept `z0 - dz` unchecked. This matches C++ lines 272–296 exactly. `alterdirection` is ×(0.6+0.8i)·m (53.13°), as in C++ lines 164–171. The old "up to 4 halvings vs |P(z0)|², then rotate dz/16" rule is gone from all three scripts.
- **Case 3 iterates.** These come from the reference, starting at its own start: startpoint([1,0,4]) = 2, so z0 = 1 and r0 = 5.
  - Step 1: N = −1.5 (|P|² 39.06 > 25). H1 = −0.25 (16.50) is accepted; H2 = 0.375 (17.14) does not help. z1 = −0.25.
  - Step 2: N = 7.875 (4358). H1 = 3.8125 (343.6) and H2 = 1.78125 (51.45) both help, so the step is rotated: z2 = 0.359375+0.8125i (12.37).
  - Step 3: halved once, z3 = −0.18577+1.63876i.
  - Step 4: plain Stage-1 step, z4 = 0.04371+2.02433i. The 2Δ trial fails.
  - Steps 5–8: Stage 2. z8 = −7.9e−31+2i, |P|² = 9.96e−60 ≤ eps = 3.87e−29.
- **Page.** The page text (Stage-1 bullet, Case 3 Behavior, alt text) now describes exactly this. The false "real-axis iterates stagnate / rotation as last resort" story is gone.
- **GIF.** The GIF shows the orange polyline 1 → −0.25 → 0.359+0.8125i → −0.186+1.639i, then blue segments to 2i. The labels read z3 = −0.186 + 1.639i (Stage 1) and z8 = −7.9e−31 + 2.000i (Stage 2).
- The round-1 checker's primary-source variant (36.87°, ¼ factor) is superseded by R2-C. The fix follows the reference.

### F2 — resolved
- **Page.** Lines 22–31 now define the stages by the reference's test `stage1 = f2/u > u/f/4 || f != ff` (C++ line 256). Stage 2 runs only if the previous step was plain (f == ff) and 4·f·f2 ≤ u². That is the page's 2|f||w| ≤ |f'|²|z_{k−1}−z_k| (algebra checked). Stage 1 is every checked step. Stage 2 is plain Newton with no trial points, ending by Adams' bound (`upperbound`, matching C++ lines 140–162; eps = 2^-52 scale).
- **Reference quirk.** The page states that the reference forms w = P'(z_{k−1}) − P'(z_k) only on the first iteration (fz0 = a[n−1] = P'(0), z0 = 0) and afterwards w = P(z_{k−1}) − P'(z_k) (C++ line 264 sets fz0 = fz). Both statements are true of the file. I re-ran with the "intended" w = P'(z_{k−1}) − P'(z_k). The stages are identical: aa [1,1,2,2,2,2], ab [1,1,1,1,1], ac [1,1,1,1,2,2,2,2]. So the page's claim that the runs change stage at the same steps holds.
- **Scripts.** The scripts now carry the actual stage. The legends say "plain Newton step x − Δx / lengthened step x − kΔx / halved / rotated step / dashed: Stage 2 (unchecked)". Each point label names the stage of the step that reached it, and the labels are correct in every frame I read: aa x2 Stage 1, x3–x6 Stage 2; ab all Stage 1; ac z1–z4 Stage 1, z5–z8 Stage 2.
- The heading issue that F2 mentioned in passing is not addressed. With Stage 2 now implemented it has become a real problem; see N1.

### F3 — resolved (not a defect relative to the reference)
- **Reference.** C++ lines 257–260 take `r = |dz|` before the cap, then `if (r > r0) alterdirection(dz, r0/r)` and `r0 = r*5.0`. So r0 = 5·(the pre-cap length), and the original finding's "post-limit" rule is not what the reference does. The scripts do the same.
- **Page.** The page now says "five times that step's length before the cap" and that the cap rotates by 53.13°. Both are true of the reference.
- The cap never acts in any of the three runs (cap=0 at every step in all three traces), as the page says.

### Changed-text ledger

| Location | Text / number | Check | Verdict |
|---|---|---|---|
| Intro | follows `newton_real` (Newton_Real.cpp, Future Team ApS, 2002), link to hvks.com | File header: "Copyright (c) 2002 Future Team Aps", newton_real; URL fetched OK | true |
| §1 | lengthening runs in Stage 1 when z−Δz does not increase \|f\|² | `div2 = f > f0` (C++ l.272) | true |
| §1 | tries up to z−(n+1)Δz, stops at first non-lowering trial, keeps the one before | `wz -= dz` for i = 1..n, so z0−(i+1)dz; `fw >= f` break. Case 2 step 1 evaluates 2.8, 1.6, 0.4 and −0.8 (= 4Δx) | true |
| §1 | near a multiplicity-m root the kept point is z−mΔz, quadratic until rounding (Case 2) | Case 2: k = 2 at steps 2–5; e3/e2² ≈ 0.16, e4/e3² ≈ 0.17; x5 limited by rounding | true for Case 2 (but see N1 for the general heading) |
| §1 | r0 reset after each Newton step to 5× its pre-cap length | C++ l.257–260 | true |
| §1 | longer step cut to r0 and rotated 53.13°; Cases 1–2 scripts error if a rotation occurs | alterdirection(dz, r0/r), \|0.6+0.8i\| = 1; script `all(imag==0) \|\| error(...)` | true |
| §1 | no step longer than r0, cap never acts | cap=0 every step, all cases | true |
| §2 | each iteration: Δz = f/f', capped, one of two stages | C++ l.250–261 (except the saddle branch, stated below) | true |
| §2 Stage 1 bullet | halving kept only while it lowers \|f\|² below the previous trial; two helpful halvings, then rotate and halve once more, ×0.5(0.6+0.8i), accepted | C++ l.274–295 | true |
| §2 Stage 1 bullet | rotation only shown in Case 3 | aa/ab never rotate (traces) | true |
| §2 Stage 2 bullet | no trial points; ends when \|f\| ≤ Adams' bound | C++ l.298–302, loop condition `f > eps` (both squared) | true |
| §2 Stage 2 bullet | used only if previous step plain and 2\|f\|\|w\| ≤ \|f'\|²\|z_{k−1}−z_k\| | equivalent to `!(f2/u > u/f/4) && f == ff` | true |
| §2 Stage 2 bullet | w/(z_{k−1}−z_k) estimates f''; Kantorovich 2\|f\|\|f''\| ≤ \|f'\|² | standard h = \|f\|\|f''\|/\|f'\|² ≤ ½ | true |
| §2 Stage 2 bullet | reference forms w that way only on the 1st iteration (origin as previous point), afterwards w = f(z_{k−1}) − f'(z_k); scripts copy; intended w gives the same stage changes | C++ l.230–232, 253, 264; my variant run | true |
| §2 | saddle branch: f' = 0, previous step rotated 53.13° and ×5 | `alterdirection(&dz, 5.0)` | true ("lengthened 5 times" = ×5) |
| §2 | rounding branch: step shorter than 2^-26\|z\| not lowering \|f\|², retried from start rotated and halved | C++ l.304–311; −DBL_MANT_DIG/2 = −26 (integer division) | true |
| §2 | neither branch reached | saddle=0, rounding=0 everywhere | true |
| §2 | not a guarantee: halvings vs previous trial, rotation unchecked, Stage 2 unchecked; \|f\|² decreases at every step in all three runs | code; aa 289→3.17→0.637→…; ab 2916→0.746→…→0; ac 25→16.5→12.37→2.19→0.0405→… | true |
| Animations | colour/dash/label legend; Cases 1–2 start at own x0 with r0 = 5\|x0\|; Case 3 at reference start | scripts r0 = 15 and 20; startpoint([1,0,4]) = 2, so z = 1 and r0 = 5 | true (dashes hardly visible, see N2) |
| Case 1 | \|P\|² = 17.3, 3.17, 8.73 for Δx, 2Δx, 3Δx | 17.3075, 3.17079, 8.73249 | true |
| Case 1 | x1 ≈ 1.5833 green; step 2 plain Stage 1; steps 3–6 Stage 2; no halving | trace | true |
| Case 1 | errors 9.8e−2, 6.4e−3, 3.0e−5, 6.7e−10 (steps 2–5) | 0.0978, 6.40e−3, 3.02e−5, 6.75e−10 vs mpmath root | true |
| Case 1 | x6 = x* to double precision; \|P\| below Adams' bound, stop | x6 − x* = 8.8e−17 < ½ ulp (1.1e−16); \|P\|² 3.16e−30 ≤ eps 2.45e−27 | true |
| Case 1 alt | doubled first step, plain steps, Stage 2 from step 3 | trace/frames | true |
| Case 2 | all green, all Stage 1, lengthened step never leads to Stage 2 | f ≠ ff after any lengthening, so stage1 is forced | true |
| Case 2 | 3Δx to 0.4, then 2Δx four times | k = 3, 2, 2, 2, 2 | true |
| Case 2 | errors 8.6e−2, 1.2e−3, 2.3e−7 of x2–x4 | 0.08571, 1.174e−3, 2.296e−7 | true |
| Case 2 | x5 ≈ 0.99999999952, error 4.8e−10, computed \|P\|² = 0, true ≈ 4.8e−37, run stops | 0.99999999951934; 4.807e−10; f = 0; mpmath 4.80e−37; 0 ≤ eps | true |
| Case 2 | steps shrink 0.69 to 2.3e−7 | step 2 = 0.6857, step 5 = 2.30e−7 | true |
| Case 2 | Newton error 3.4e−4 after 14 steps (unchanged) | 3.35e−4 | true |
| Case 2 alt | five lengthened steps (3Δx, then 2Δx ×4), rounding ends at x5 | trace/frames | true |
| Case 3 | all numbers listed under F1; \|P(z8)\| ≈ 3.2e−30 below bound; no lengthened step | \|P\| = 3.155e−30; bound² 3.87e−29; step 4's 2Δ trial fails (4.74 > 0.0405) | true |
| Case 3 | reference solves quadratics in closed form; loop run directly | C++ `while(n > 2)` … `quadratic()` | true (disclosed) |
| Case 3 alt | halved, rotated after two helpful halvings, halved, plain steps to +2i | trace/frames | true |
| Legends | four entries listed under F2 | frames | correct |

### New problems

**N1 — Misleading. §1 heading "Quadratic convergence — even at multiple roots" and its closing sentence.** Not changed by the fix, but now untrue of the implementation the page says it follows.
- The page now states that it describes `newton_real`. In that implementation, Stage 2 (plain, unchecked Newton) can be entered next to a multiple root, and there it converges only linearly.
- On Case 2's own polynomial x³−3x+2, started at x0 = −0.7 with r0 = 3.5, the actual reference C++ (`check/cpp/nr2`) and my transcription agree. Step 1 is a plain Stage-1 step. Steps 2–20 are Stage-2 Newton steps whose error halves each time (0.41, 0.22, 0.11, …, 1.8e−6). Only step 21 returns to Stage 1 and takes a 2Δx step.
- Similar runs occur for (x−1)²(x+3)(x−4) (11 of 120 starts) and (x−1)³(x+2).
- F2 had flagged that this heading rested on a check Stage 2 lacks. The fix implemented Stage 2 but kept the unqualified claim.
- Suggested fix: one sentence saying that the lengthened step is what gives fast convergence at a multiple root, and that if the stage test admits Stage 2 there, its plain Newton steps converge only linearly (Case 2 itself stays in Stage 1).

**N2 — Minor. Dashed Stage-2 segments are not visibly dashed.**
- In madsreidaa.gif (steps 3–6) and madsreidac.gif (steps 5–8), the Stage-2 segments are only a few to about 18 px long. Zoomed crops (`check/crop_aa4.png`) show no dash pattern, so the legend entry "dashed: Stage 2 (unchecked)" and the page sentence "dashed segments Stage-2 steps" promise a cue the viewer cannot see.
- The point label "(Stage 2)" does carry the information, so nothing is wrong, only invisible.

No other new problems. That rests on: the three-way bit-identical iterate check; reading the first, middle and last frames of all three GIFs at full size plus their contact sheets (labels legible and correct; Case 2 zoom tick labels distinguishable down to 5e−8 spacing; tangent, Newton point and axis segments built from xt = x−Δx and x_{k+1}); and the full ledger above. The frame-to-frame plot-box jitter in Case 3, from varying legend width, was already in the pre-fix GIF.

### Reproducibility and conventions
- **Reproducibility.** All three scripts were run from scratch copies with plain `julia`. madsreidaa.gif, madsreidab.gif and madsreidac.gif are **byte-identical** to the committed working-tree GIFs (`cmp`). Frame counts are 7, 6 and 9, matching 6, 5 and 8 steps plus frame 0.
- **Conventions.** Description comes before Animations. Each case has a `[Julia source]` link and a GIF embed with descriptive alt text. There are no code blocks. Script headers follow the template.
- **Files changed.** The diff touches only the 7 files in the page folder. No copy of Newton_Real.cpp is in the repository (no *.cpp or newton_real file found). The scripts contain a Julia port of the reference's loop and helper routines, which R2-C asks for, with attribution and URL.

### Re-check

The fixer addressed N1 and N2. I checked against the updated working tree; the updated `fix.diff` still touches only the 7 files in the page folder.

### N1 — resolved
- **Heading.** The §1 heading is now "Lengthened steps at multiple roots".
- **New sentences.** "Only Stage 1 searches, though: Stage 2 takes plain Newton steps, which are linear at a multiple root. Started at x0 = −0.7 instead of 4, Case 2's polynomial gets 19 Stage-2 steps (steps 2 to 20) whose error shrinks by a factor of 0.55 to 0.50 per step, from 0.41 to 1.8e−6, before the stage test fails and one lengthened step brings the error to 3.5e−11."
- **Check.** I recomputed every number with my own port (`nr.py`, x0 = −0.7, r0 = 3.5). The real reference C++ run (`cpp/nr2`, earlier in this file) gives identical iterates.

| Claim | My port | Verdict |
|---|---|---|
| 19 Stage-2 steps, steps 2 to 20 | steps 2–20 are Stage 2; 21 steps in all | true |
| error ratio per step 0.55 to 0.50 | 0.5457, 0.5285, 0.5164, …, settling at 0.5000 from step 13 | true |
| error from 0.41 to 1.8e−6 | 4.1231e−1 (step 2), 1.7805e−6 (step 20) | true |
| the stage test fails, back to Stage 1 | step 21: previous step plain (f == ff), so the Kantorovich test itself failed | true |
| one lengthened step brings the error to 3.5e−11 | step 21 is len2 (2Δx), error −3.5095e−11, \|P\|² = 0, run stops | true |

- **Remaining mentions of quadratic convergence.** Every other "quadratic" on the page is now correct:
  - §1's "converges quadratically until rounding error takes over (Case 2)" is now qualified by the Stage-2 sentence, and it is true of Case 2's run.
  - Case 1 and Case 3 are simple roots.
  - The Case 2 Behavior text and alt text describe that specific run, which stays in Stage 1. This is verified above.
  - Line 37 "quadratic factor" refers to deflation.
- No sentence still claims quadratic convergence at multiple roots in general.

### N2 — resolved
- **Page.** grep finds no "dash" anywhere in index.qmd. The Animations paragraph now says only that "The label of the current point names the stage of the step that reached it."
- **Scripts.** No dashed step style and no "dashed: Stage 2" legend entry remain. The only `ls=:dash` left is the pre-existing thin gray real-axis `hline!` in madsreidac.jl line 215, which is unrelated to stages.
- **Frames.** I read these at full size:
  - aa frame 4 (x3 = 1.88578, Stage 2);
  - ab frame 6 (x5 = 0.99999999952, Stage 1, zoomed ticks legible);
  - ac frame 9 (z8 = −7.9e−31 + 2.000i, Stage 2);
  - the full ac contact sheet.

  The legends now have three entries for aa and ab, and two plus the root and start markers for ac. Stage labels are correct on every frame. The geometry is unchanged from the first check.

### Reproducibility
- I re-ran all three scripts from fresh scratch copies (`check/run2/`). madsreidaa.gif, madsreidab.gif and madsreidac.gif are byte-identical to the committed files (`cmp`). The iterate traces match the first check's output exactly, with frame counts 7, 6 and 9.

### F1–F3
- Unchanged by this revision; they remain resolved. The iterates are identical to the reference.

### New problems
- None. This rests on the recomputation above, the full-size frames, the grep for "dash" and "quadratic", and the byte-identical regeneration.

**Final status:** committed
