# Fix record: madsen-reid-method

Scratch evidence: `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r3fix/madsen-reid-method/fix/` (below: `$W`). Second implementation: the director's compiled C++ in `.../scratchpad/art/build/` (`ref` = published `newton_real`, `fix` = with `fz0 = fz1`), plus `$W/cpp/fixq`, a copy of `fix_hooked.cpp` with `while( n > 2 )` changed to `while( n > 1 )` so that the loop runs on the quadratic of Case 3.

## Findings

### F1 — Misleading — fixed (by decision R3-A)
- **Reproduced:** `$W/run07.jl` runs the scripts' algorithm block on (x−1)²(x+2) from x0 = −0.7, r0 = 3.5.
  - With the committed block (`julia run07.jl alg_old.jl`): `n=21 stages=122222222222222222221`. Stage-2 step factors 0.5457 down to 0.5000. Errors run from 4.1231e-1 at step 2 to 1.7805e-6 at step 20. Final error 3.5095e-11. This matches the old page text and the C++ `ref` binary (`X0=-0.7 ./ref 1 0 -3 2` → total_iters 21, root 0.99999999996490507).
  - With `fz0 = fz1` (`julia run07.jl alg_fixed.jl`): `n=5 stages=12111`, final z = 1.0000000013765751. The C++ `fix` binary (`X0=-0.7 V=1 ./fix 1 0 -3 2`) gives the same iterates bit for bit, with stages 12111.
  - The finding holds as the independent check corrected it.
- **Change:**
  - **Scripts** (`madsreidaa.jl`, `madsreidab.jl`, `madsreidac.jl`):
    - `f0 = f; fz0 = fz` → `f0 = f; fz0 = fz1`, with a two-line comment saying this is the one departure from `newton_real` and why;
    - the stage-test comment now reads "fz0 is P' at the previous iterate";
    - one header line points to that comment.
  - **index.qmd**:
    - l.10: "port the iteration of `newton_real` (…) with one correction (Stage 2, below)".
    - l.14: the old quadratic sentence becomes "so the convergence to a multiple root is quadratic while the iteration stays in Stage 1 (in Case 2, until rounding error takes over)". Added: "Near a double root the two sides of the stage test (below) tend to equality, so whether a run stays in Stage 1 depends on the run. Case 2 stays in Stage 1 throughout." The x0 = −0.7 example is rewritten from the corrected run.
    - l.27: removed "The reference file forms w that way only on the first iteration … The scripts copy this, and with w = f′−f′ the three runs change stage at the same steps." It is replaced by "Here w = f′(z_{k−1}) − f′(z_k), so …" and the one R3-A sentence: the scripts follow `newton_real` except that they store f′(z_{k−1}), as test (2.9) requires [@madsenReid1975] and the reference's own initial value f′(0) implies, where `newton_real` stores f(z_{k−1}).
- **Check:**
  - **Cases 1–3:** the new traces are identical to the traces of the HEAD scripts. Both were run in `$W/old/` and diffed against `$W/trace_*.txt`, giving "aa/ab/ac traces identical". The C++ `fix`/`fixq` gives the same stage strings and final iterates: Case 1 `112222`, 1.8793852415718169; Case 2 `11111`, 0.99999999951934093; Case 3 `11112222`, −7.8886090522101181e-31+2i.
  - **GIFs:** all three regenerated GIFs are byte-identical to HEAD.
  - **x0 = −0.7:** checked independently in mpmath (`/usr/bin/python3 -I $W/check07.py`); the numbers are in the ledger.

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| l.10 | "with one correction (Stage 2, below)" | Script diff: only the `fz0` line changed in the algorithm | yes |
| l.14 | "convergence to a multiple root is quadratic while the iteration stays in Stage 1" | `check07.py`: e/e² for the k = 2 Stage-1 steps of the x0 = −0.7 run = 0.138, 0.165, 0.167. Case 2 (traces unchanged; round-3 ledger C2.6): e/e² = 0.16, 0.17 | yes |
| l.14 | "(in Case 2, until rounding error takes over)" | Case 2 e5/e4² = 4.807e-10/(2.296e-7)² ≈ 9.1e3, not quadratic; computed \|P(x5)\|² = 0 (trace) | yes |
| l.14 | "two sides of the stage test tend to equality" near a double root | sympy: lim 2PP″/P′² at x→1 = 1. The divided-difference version with z_{k−1}=1+e, z_k=1+te also has limit 1 as e→0. Left/right in runs: −0.7 run 1.238, 1.199, 1.012; Case 2 (√ of the C++ squared ratio) 0.64, 3.59, 0.70, 1.043, 1.0027 | yes |
| l.14 | "Case 2 stays in Stage 1 throughout" | trace stages `11111` (Julia and C++ `fix`) | yes |
| l.14 | plain Newton step "past the root to x1 ≈ 1.7556" | Julia trace step 1 kind=plain, k=1, z=1.7555555555555553; mpmath Newton point 1.75555…; \|P\|² at k=1..4 = 4.60, 4102, … so k = 1; −0.7 < 1 < 1.7556 | yes |
| l.14 | "one Stage-2 step to x2 ≈ 1.4123" | trace step 2 stage2, z=1.4123058542413378; mpmath Newton from x1 = 1.41230585424133796; test left/right = 0.348 ≤ 1 | yes |
| l.14 | "error falls from 0.76 to 0.41" | errors 7.5556e-1, 4.1231e-1 | yes |
| l.14 | "stage test then fails (its left side is 1.24 times its right side)" | `check07.py` iter 3: left/right = 1.23839. C++ `fix` prints squared ratio 1.53361 (√ = 1.2384) | yes |
| l.14 | "three lengthened Stage-1 steps with k = 2" | trace steps 3–5: stage1 lengthened k=2. mpmath \|P\|² at k=1..4 is minimal at k=2 for each step | yes |
| l.14 | errors 2.3e-2, 9.1e-5, 1.4e-9 | 2.3490e-2, 9.0897e-5, 1.3766e-9 (Julia trace = C++ `fix`) | yes |
| l.14 | "computed \|f\|² is exactly 0 and the run stops after 5 steps" | trace step 5 \|P\|²=0.0000e+00; Python float Horner (reference scheme) at 1.0000000013765751 → 0.0; n=5; true value 3.23e-35 | yes |
| l.27 | "Here w = f′(z_{k−1}) − f′(z_k)" | scripts now `fwz = fz0 - fz1` with `fz0 = fz1` from the previous step | yes |
| l.27 | "newton_real stores f(z_{k−1})" | `fix_hooked.cpp` vs `ref_hooked.cpp` diff: the only difference is l.266 `fz0 = fz;` → `fz0 = fz1;` | yes |
| l.27 | "reference's own initial value f′(0)" | `fz0 = complex<double>(a[n-1])` with z0 = 0; a[n−1] is the x coefficient = P′(0) (sympy: −3 = −3 for Case 2) | yes |
| scripts | comments: "fz0 is P' at the previous iterate"; departure note | code | yes |

## Scripts and GIFs
- **Scripts changed:** `madsreidaa.jl`, `madsreidab.jl` and `madsreidac.jl` (one code line and comments each).
- **GIFs:** all three were regenerated in place and are byte-identical to HEAD (`git diff --quiet HEAD -- *.gif`). The iterate traces are identical to the HEAD scripts' traces.
- **Frames:** the `madsreidab.gif` contact sheet was viewed (6 frames). It is unchanged: all green, "(Stage 1)" labels, and x5 = 0.99999999952.
- **git status** of the page folder: `M index.qmd`, `M madsreidaa.jl`, `M madsreidab.jl`, `M madsreidac.jl`.

## Legacy archive
- **Consulted:** grep for "madsen" in `/home/jason/Desktop/math-fullerton/baseline/mathews/` finds only bibliography entries on other topics: Nels Madsen on pivoting, and Hald & Madsen and Madsen–Nielsen–Pinar on optimisation and linear programming.
- **Result:** the archive has no Madsen-Reid topic, so nothing was compared.

## Notes
- **Not done, as R3-A says:** no factor-2 margin and no Stage-2 |f|-decrease check were added.
- **Description claims left alone:** "robust, globally convergent" (l.10) and the reliability and generalisation claims (l.35, l.39) were marked could-not-determine by the reviewer but are not findings, so they were left as they are.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- The fix did not just reword the page. Per decision R3-A, the scripts now store P' at the previous iterate (`f0 = f; fz0 = fz1`) instead of P (`fz0 = fz`). This is the only algorithmic change in all three scripts. In the reference's port, `fz0 = fz` was the source of the dimensionally inconsistent w. Line 14 now describes the corrected run, and the false line-27 sentence ("The scripts copy this … change stage at the same steps") is gone.
- The stage test in the code, `stage1 = f2/u > u/f/4 || f != ff`, is algebraically 2|P(z_k)||P'(z_{k-1})−P'(z_k)| > |P'(z_k)|²|z_{k-1}−z_k|, or "previous step not plain". This is test (2.9) as quoted in the brief, and it matches the page's formula on line 27.
- Corrected run from x0 = −0.7 (scratch copy of madsreidab.jl with x0 changed, ratio printed): 5 steps, stages 1,2,1,1,1, kinds plain, stage2, lengthened k=2 three times. The final z is 1.000000001376575 and |P|² = 0. The compiled C++ `fix` binary (`X0=-0.7 V=1 ./fix 1 0 -3 2`) gives the same thing digit for digit: iters 5, stages 12111, z = 1.0000000013765751, and the same squared ratios 45.44, 0.1211, 1.5336, 1.4378, 1.0236. The unmodified `ref` binary still gives 21 iterations. So the old 19-step Stage-2 text really was an artifact of the substitute w.
- An independent mpmath (40-digit) recomputation of the same iteration gives the same picture. z1 = 1.75556 (k=2 would give |P|² = 4102 > 14.1, so the step is plain). z2 = 1.412306. The unsquared test ratio is 0.348 at z1 (passes, so Stage 2) and 1.2384 at z2 (fails). The errors after the three k=2 steps are 2.349e-2, 9.090e-5 and 1.377e-9. Successive e_{k+1}/e_k² = 0.138, 0.165, 0.167 → 1/6, the theoretical constant h'(1)/(2h(1)) for the m-corrected Newton step on (x−1)²(x+2). So the convergence is quadratic, as the restored sentence says.
- Cases 1–3: I ran the old (HEAD, `fz0 = fz`) and new algorithms on all three cases, and the printed iterate traces are byte-identical. The C++ `ref` and `fix` binaries agree on the stage strings for Cases 1 and 2 (112222, 11111). So no GIF needed regenerating, and none was.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| l.10 | "port the iteration of `newton_real` … with one correction (Stage 2, below)" | The diff of all three scripts shows exactly one algorithmic line changed (`fz0 = fz1`), plus comments | OK |
| l.14 | "convergence to a multiple root is quadratic while the iteration stays in Stage 1 (in Case 2, until rounding error takes over)" | −0.7 run: e_{k+1}/e_k² → 1/6. Case 2 errors 8.6e-2 → 1.2e-3 → 2.3e-7 (0.0857²/6 = 1.22e-3). M&R p. 4 "quadratic convergence to a multiple zero" | OK |
| l.14 | "Near a double root the two sides of the stage test tend to equality" | Exact quantity 2\|P\|\|P''\|/\|P'\|² = 2·3e²·6/(6e)² → 1. Computed squared ratios: −0.7 run 1.53 → 1.44 → 1.02; Case 2 1.087 → 1.005 | OK |
| l.14 | "whether a run stays in Stage 1 depends on the run. Case 2 stays in Stage 1 throughout" | Case 2 stages 11111 (Julia and C++ fix) | OK |
| l.14 | "plain Newton step past the root to x1 ≈ 1.7556" | 1.7555555…; k=1 chosen (2Δx gives \|P\|² 4102); passes x*=1 | OK |
| l.14 | "one Stage-2 step to x2 ≈ 1.4123" | 1.4123058542 (stage2 in trace) | OK |
| l.14 | "error falls from 0.76 to 0.41" | 0.75556, 0.41231 | OK |
| l.14 | "its left side is 1.24 times its right side" | sqrt(1.53361) = 1.2384 (Julia, C++); mpmath 1.23839 | OK |
| l.14 | "three lengthened Stage-1 steps with k = 2" | Steps 3–5: stage1, lengthened, k=2 | OK |
| l.14 | errors 2.3e-2, 9.1e-5, 1.4e-9 | 2.349e-2, 9.090e-5, 1.3766e-9 (float) / 1.3770e-9 (mpmath) | OK |
| l.14 | "computed \|f\|² is exactly 0 and the run stops after 5 steps" | Trace step 5: \|P\|² = 0; the loop exits on f > eps; 5 iterations | OK |
| l.27 | "Here w = f'(z_{k-1}) − f'(z_k), so w/(z_{k-1}−z_k) estimates f''…Kantorovich" | Divided difference of f'; matches the (2.9) quote and the code | OK |
| l.27 | "scripts follow `newton_real` except in one line … store the derivative f'(z_{k-1}) … where `newton_real` stores f(z_{k-1})" | ref.cpp line 264 `f0 = f; fz0 = fz;`; scripts `fz0 = fz1` = P'(z) at the step's start, which is the next test's z_{k-1}. "after each step" is loosely worded (the store happens at the start of the next step) but is correct in effect | OK |
| l.27 | "the reference's own initial value f'(0) implies" | Initial `fz0 = complex(a[n])` = coefficient of z¹ = P'(0) (ref.cpp l.232 `a[n-1]`, 0-indexed) | OK |
| l.27 | citation `[@madsenReid1975]` | Present in references.bib l.56 | OK |
| scripts | comments "fz0 is P' at the previous iterate", "One line departs from the reference" | Match the code | OK |

### New problems
None. This rests on four checks:
- Each new number agrees across three implementations (the corrected Julia script, the C++ `fix` binary, and an mpmath recomputation).
- The Case 1–3 traces are unchanged under the corrected line.
- The unchanged Case 1–3 text still matches those traces: Case 1 stages 112222 with x1 = 1.5833; Case 2 11111 with x5 = 0.99999999952; Case 3 halved/rotated/halved/plain, then Stage 2 for steps 5–8, with \|P(z8)\| = 3.2e-30.
- The final frames of all three GIFs show labels consistent with the page.

### Reproducibility and conventions
- I ran all three scripts from scratch copies (`check/run/`). The madsreidaa.gif, madsreidab.gif and madsreidac.gif they produced are byte-identical (`cmp`) to the committed files. No GIF is modified in the working tree, which is correct because the algorithm change does not alter any animated run.
- I viewed the last frames at full size (aa frame 7: x6 = 1.87939 Stage 2; ab frame 6: x5 = 0.99999999952 Stage 1; ac frame 9: z8 Stage 2). They are legible and consistent with the text.
- Conventions: Description comes before Animations; each case has a source link and an embed; alt text is descriptive; there are no code blocks (0 fences).
- The fix diff touches only files in the page folder. references.bib and .github are unchanged. The other modified files in the working tree belong to other pages' parallel fixes, not this one.
- The fix follows R3-A: one-line change, no factor-2 margin, no |f|-decrease check, a one-sentence explanation with citation, the quadratic statement scoped to Stage 1, and the −0.7 example recomputed (5 steps).

**Final status:** committed
