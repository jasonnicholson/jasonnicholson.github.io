# Fix record: brents-method

Scratch evidence folder (re-runnable): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/work/brents-method/fix/` (below: `$FIX`). Python checks run as `cd $FIX/py && /usr/bin/python3 -I <script>.py`; each output is saved beside it as `<script>.out`. Julia checks run as `cd $FIX && julia <script>.jl`.

- `round1/`: the round-1 evidence, copied. `round1/reviewer/instr_aa.jl` and `instr_bb.jl` were re-run against the old algorithm (output `$FIX/round1_instr.out`).
- `zeroin_instr.jl`: the new `run_brents` (Brent's ZEROIN) with each step's candidate, the acceptance tests and the invariants printed (output `zeroin_instr.out`).
- `brentsaa_steps.jl`, `brentsbb_steps.jl`: the committed scripts' own code up to `steps = run_brents(...)`, with the plotting cut off and step printing added (generated from the repo files; outputs `*_steps.out`).
- `py/check_runs.py`: scipy `brentq` with every evaluation point logged, mpmath roots, f at the endpoints.
- `py/case1_compare.py`, `py/case2_errors.py`: errors of each Brent iterate against the mpmath root; bisection and regula falsi counts for Case 1.
- `py/regula_falsi.py`: regula falsi on Case 2 at 50 digits (counts, sides, endpoint, error ratio, convexity).
- `py/flat_case.py`, `flat_julia.jl`: Brent against bisection on f(x) = x⁹ over [−1, 2].
- `orig_gif/`, `new_gif/`, `regen2/`: frames of the committed GIFs, the new GIFs, and a second regeneration after comment-only edits.

## Findings

### F1 — Error — fixed
- **Reproduced:** `py/check_runs.py`: mpmath `polyroots` gives 0.328538458611415, 1.26465829006442, 2.40680325132417. `py/case1_compare.py`: x* = 0.32853845861141489597, f(0.3268) = −0.0136, f(0.3224) = −0.0482. The page's 0.3268 and the script comment's 0.3224 are not roots. The finding holds.
- **Change:** index.qmd Behavior "0.3268" → "0.3285", and alt text "x≈0.3268" → "x≈0.3285". brentsaa.jl:3 "Root (i) ≈ 0.3224" → "Root ≈ 0.3285".
- **Check:** round(0.328538458…, 4) = 0.3285 (`py/case1_compare.py` prints "4-dec: 0.3285"). The new GIF's last frame (`new_gif/brentsaa/frame_009.png`) shows "b = 0.328538".

### F2 — Error — fixed (by F4: the animation was changed, then the paragraph was rewritten from the new run)
- **Reproduced:** `round1/reviewer/instr_aa.jl` on the old script prints the labels Secant, Bisection, IQI, Secant, Bisection, Bisection, Bisection, Secant, Secant, IQI (10 steps), with final f(b) = −1.538e-12. The old sentence "begins with secant steps and quickly switches to IQI" was false.
- **Change:** Option (a) of F4 replaced the algorithm, and the GIF now shows 8 steps. The Case 1 Behavior paragraph was rewritten from that run: the step sequence; why b stays at 0.4 at step 3; that every step after step 2 is an interpolation step; the errors at steps 5–8; f(b) = 0 at step 8; bisection and regula falsi counts to 10⁻¹⁰. The alt text gained "in 8 steps".
- **Check:** `brentsaa_steps.out` (the script's own code): init, Secant, Bisection, IQI, Secant, IQI, Secant, Secant, IQI; f(b) = 0.0000e+00 at step 8. `py/check_runs.py`: scipy brentq evaluates the same 10 points in the same order. Errors and counts are in the ledger. The frames show the same labels (`new_gif/brentsaa/sheet.png`).

### F3 — Error — fixed
- **Reproduced:** in the old script (brentsaa.jl:51–75), the candidate is IQI when f-values are distinct and secant otherwise, and any rejected candidate becomes `s = mid`, labelled "Bisection". `round1_instr.out` shows `cand=IQI … final=Bisection` at Case 1 steps 2 and 5 and at Case 2 steps 2 and 3. No IQI→secant fallback exists. The new ZEROIN code has the same structure: one candidate (secant if `a == c`, IQI otherwise), and on rejection `d = xm`, a bisection. `zeroin_instr.out` Case 2 step 3 shows `cand=IQI point=3.829 ok(3/4)=false` → Bisection.
- **Change:** index.qmd:
  - "otherwise bisection or secant is used instead." → "otherwise a bisection step is taken instead."
  - "When only two distinct function values are available (or IQI is rejected), the method falls back to the secant step:" → "When only two distinct points are available ($a = c$), the method uses the secant step instead of IQI:"
  - List item 3 "whenever neither of the above produces a sufficiently good step" implied that both interpolations are tried. → "whenever interpolation is not making enough progress".
- **Check:** code structure in brentsaa.jl/brentsbb.jl (`if a == c` → Secant, else IQI; rejection → `d = xm`). `zeroin_instr.out` shows that no step goes IQI→Secant. Case 1 step 2 and Case 2 step 2 are bisections without a candidate, because |f(a)| ≤ |f(b)|; Case 2 step 3 is a rejected IQI.

### F4 — Misleading — fixed (option a: script now runs Brent's ZEROIN)
- **Reproduced:** `round1_instr.out`, from the old script: in Case 1, steps 5–7 reject the candidates 0.328215 (IQI, c3+c5), 0.329259 and 0.328822 (secant, c2+c4) and bisect instead. In Case 2, step 4 rejects the secant candidate 1.118293 (c2+c4). `py/check_runs.py`: scipy brentq evaluates 0.8, 0.4, 0.2276, 0.339288, 0.328215, 0.328544, 0.32853846, 0.328538458611 in Case 1 and 0.539, 1.0196, 1.2598, 1.118293, … in Case 2. So genuine Brent accepts the very candidates the old script rejected. The finding holds.
- **Change:** in brentsaa.jl and brentsbb.jl, `run_brents` was replaced by a transcription of ZEROIN. Both use the same code, with Brent's labelling: b is the best approximation, c the contrapoint, a the previous b. The acceptance test is `2p < 3·xm·q − |tol1·q|` and `p < |e·q/2|`, with tol1 = 2ε|b| + tol/2. A step shorter than tol1 becomes a step of length tol1, labelled "Min step". `BrentStep` now stores (b, c, method). The plot shades between b and c and puts the red dot at b. "Min step" => :gray was added to `method_colors`. Title, window, tol = 1e-10, fps and output paths are unchanged. A header comment states the algorithm.
- **Check:**
  - `brentsaa_steps.out` and `brentsbb_steps.out` (the scripts' own code) match the scipy-logged points to all 15 printed digits on both cases, for every evaluation and in order. Case 1: 10 evaluations. Case 2: 12 evaluations.
  - Labels: Case 1 is S B I S I S S I, 8 steps. Case 2 is S B B S I S S I S + Min step, 10 steps. This is the ZEROIN sequence the round-1 review gave.
  - `zeroin_instr.out` checks the invariants at every step of both cases: f(b)·f(c) ≤ 0; |f(b)| ≤ |f(c)|; a equals the previous b or a = c. All are true.
  - `py/case2_errors.py`: the root lies inside [b, c] at every step.

### F5 — Misleading — fixed
- **Reproduced:** `flat_julia.jl` runs the new script's ZEROIN code on x⁹ over [−1, 2] with tol = 1e-10. It takes 96 evaluations, and in 38 of 93 two-step windows the bracket does not halve. `py/flat_case.py`: scipy brentq(xtol = 1e-10) makes 96 calls, while bisection needs 35 midpoints + 2 endpoints = 37 evaluations to reach width 8.7e-11. So "halves the bracket at every other step … O(2⁻ⁿ)" is false for the method as implemented. The finding holds, as does the checker's version of it.
- **Change:** index.qmd, the Guaranteed bullet now reads: "Brent's method always keeps the root bracketed and converges. Its safeguards take a bisection instead of an interpolation step that would not stay within about three quarters of the way from $b$ to $c$, or that is not smaller than half the step before last. This does not make it at least as fast as bisection: for the very flat $f(x) = x^9$ on $[-1, 2]$ it needs 96 function evaluations to shrink the bracket below $10^{-10}$, where bisection needs 37."
  - The suggested (log₂)² bound was **not** used, because I could not compute it here; the sentence uses only computed numbers.
- **Check:** the ledger. The two safeguard conditions are the code's acceptance test. In `2p < 3·xm·q − |tol1·q|`, xm = (c−b)/2, so the condition is |d| < ¾|c−b| − tol1/2; hence "about". `p < |e·q/2|` is |d| < |e|/2, where e is the step before last.

### F6 — Minor — fixed
- **Reproduced:** `py/regula_falsi.py` (50-digit arithmetic):
  - Every chord point lies left of the root, the chord points increase, and the right endpoint is 1.5 in all 400 iterations. The first chord points are 0.5393, 0.5791, 0.6191, 0.6589, 0.6982, 0.7365, so the claim that the chord "always lands near x = 0.5" is false.
  - Counts to |x−x*| < tol: 100, 133, 165, 197, 229 and 245 for tol = 1e-6, 1e-8, 1e-10, 1e-12, 1e-14 and 1e-15. A double-precision run also gives 165 for 1e-10.
  - The error ratio is 0.936 at k = 2, 0.898 at k = 11, and 0.866418 from k ≈ 100 on. The predicted limit 1 − f′(x*)(1.5−x*)/f(1.5) = 0.866418.
  - The minimum of f″ on [0.5, 1.5] is 1.419 > 0, so f is convex there.
  - "≈ 243 iterations" with no tolerance cannot be checked. The archive shows where it came from (see Legacy archive). The finding holds.
- **Change:** index.qmd, Case 2 Behavior: the regula falsi sentence is replaced by "Regula Falsi, by contrast, needs 165 iterations to get within $10^{-10}$ of the root on this same interval: $f$ is convex here, so every chord lands left of the root, the right endpoint stays at $1.5$, and the error eventually shrinks only by a factor of about 0.87 per iteration."
  - "Brent's safeguards against exactly this pathology" was replaced by the computed fact that the bisection at step 3 moves the right end off 1.5 to 1.2598. The "handful of steps" became the actual 10-step sequence (needed anyway after F4).
- **Check:** the ledger.

### F7 — Minor — fixed (Brent's labelling kept; the animation text changed to [b, c])
- **Reproduced:**
  - Old page lines 24–26 used Brent's labelling (c is the contrapoint, a the previous b) but said the root lies in "either [b,c] or [a,b]".
  - Line 60 and the old scripts used the Wikipedia labelling (a is the contrapoint, c the previous b; old brentsaa.jl:80–91).
  - Under the stated invariant f(b)f(c) ≤ 0, the root lies between b and c. The finding holds.
- **Change:** the new scripts use Brent's labelling, so the page was aligned to it (the finding's alternative). In index.qmd:
  - State Variables: "…and $a$ is the previous value of $b$. The root is guaranteed to lie in either $[b, c]$ or $[a, b]$." → "…and the root always lies between $b$ and $c$. The third point $a$ is the previous value of $b$ (or coincides with $c$) and supplies the extra point for interpolation."
  - Animations intro: "current bracket $[a, b]$" → "current bracket between $b$ and $c$". A sentence explaining the new "Min step" label was added.
  - Line 14: "maintains a bracket $[a, b]$" → "maintains a bracket". In Brent's labelling the bracket is not [a, b].
  - List item 1: "the three most recent points" → "the three points". This is false at Case 1 step 3, where the IQI uses c = 0 although the last three evaluations were 1, 0.8 and 0.4 (`zeroin_instr.out` step 2 state: b = 0.4, c = 0, a = 0.8).
  - List item 2: "a chord through the two most recent points" → "the chord through $(a, f(a))$ and $(b, f(b))$ … (only two distinct points, $a = c$)". This is the code's condition.
- **Check:** `zeroin_instr.out`: f(b)f(c) ≤ 0 and "a == previous b or a == c" hold at every step of both cases. They also hold by construction: after `a, fa = b, fb`, a is the previous b, and both the reset (`c = a`) and the swap (`a, b, c = b, c, b`) leave a == c. The secant formula on the page, s = b − f(b)(b−a)/(f(b)−f(a)), equals ZEROIN's d = p/q when a = c (p = 2·xm·s, q = 1−s with xm = (a−b)/2 gives d = (a−b)f(b)/(f(a)−f(b))). In the frames, the shaded region runs between the red dot b and the other dashed line c.

### Round 2 after check — Minor — fixed
- **Problem (from the independent check):** index.qmd:66 gave the step-8 error in Case 1 as "about 10⁻¹⁶". The true error is 3.98e-19.
- **Cause:** `py/case1_compare.py` used the 15-digit printed value 0.328538458611415, not the script's exact double, and compared it with x* rounded to double. Both roundings are around 1e-16, so the result measured rounding, not the method's error. (The same mistake gave the "8.67e-16" for f(b) in the round-1 ledger.)
- **Recomputed:** `brentsaa_hex.jl` prints the script's exact iterates. Step 8 is 0.3285384586114149 (hex 3fd506c62bcdb6b5). `py/step8_error.py` then gives:
  - |b8 − x*| = 3.98346e-19 against the mpmath root, which is the same at dps 30 and dps 50.
  - b8 is the double nearest x*: `float(x*) == b8` is True, and the neighbouring doubles are off by 5.59e-17 and 5.51e-17.
  - f(b8) = 0.0 in Float64; the exact value is 3.1e-18.
- **Change:** index.qmd Case 1 Behavior: "… $2.7\times10^{-9}$ and about $10^{-16}$; at step 8 $f(b)$ evaluates to exactly 0 in double precision." → "… $2.7\times10^{-9}$ and $4.0\times10^{-19}$: at step 8 $b$ is the double-precision number nearest the root, and $f(b)$ evaluates to exactly 0."
- **Check:** the ledger rows for Case 1 are updated. The errors at steps 5–7 (3.2e-4, 5.5e-6, 2.7e-9) are unaffected by rounding at the 1e-16 level. The same holds for the other quoted errors computed from 15-digit values, such as Case 2 step 9 at 4.6e-12. No script or GIF changed in this round.

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd l.14 | "maintains a bracket that always contains a root" | invariant f(b)f(c) ≤ 0 at every step (`zeroin_instr.out`); bracket contains x* at every step (`py/case2_errors.py`; Case 1 by the invariant) | yes |
| index.qmd list 1 | "through the three points (a,f(a)), (b,f(b)), (c,f(c))" | code: IQI uses fa, fb, fc (`q = fa/fc; r = fb/fc`) | yes |
| index.qmd list 2 | "chord through (a,f(a)) and (b,f(b)) … only two distinct points, a = c" | code: `if a == c` → secant; algebra above gives the page's secant formula | yes |
| index.qmd list 3 | "whenever interpolation is not making enough progress" | code: bisection when \|e\| < tol1, \|f(a)\| ≤ \|f(b)\| (last step did not reduce \|f\|), or the acceptance test fails | yes |
| index.qmd State Variables | "the root always lies between b and c" | `zeroin_instr.out`: fbfc<=0 true at all 20 states (9 + 11) | yes |
| index.qmd State Variables | "a is the previous value of b (or coincides with c)" | `zeroin_instr.out`: "a=prevb\|a=c: true" at all states; code construction | yes |
| index.qmd IQI para | "otherwise a bisection step is taken instead" | code rejection branch `d = xm`; `zeroin_instr.out` Case 2 step 3 | yes |
| index.qmd Secant para | "When only two distinct points are available (a = c), the method uses the secant step instead of IQI" | code `if a == c` | yes |
| index.qmd Convergence | "take a bisection instead of an interpolation step that would not stay within about three quarters of the way from b to c, or that is not smaller than half the step before last" | code test ⇔ \|d\| < ¾\|c−b\| − tol1/2 and \|d\| < \|e\|/2; e = step before last (e = d before d is overwritten) | yes |
| index.qmd Convergence | "96 function evaluations … below 10⁻¹⁰" for x⁹ on [−1,2] | `flat_julia.jl` → evaluations=96, final width 5.0e-11; `py/flat_case.py` scipy brentq(xtol=1e-10) calls=96 | yes |
| index.qmd Convergence | "bisection needs 37" | `py/flat_case.py`: 35 midpoints (width 8.731e-11 < 1e-10) + 2 endpoint evaluations = 37 | yes |
| index.qmd Animations | "current bracket between b and c" | script shades `min(st.b, st.c)`…`max(st.b, st.c)`; frames viewed | yes |
| index.qmd Animations | "\"Min step\" marks a step shorter than the tolerance (≈ 5×10⁻¹¹), which the method replaces by a step of that minimum length" | code `abs(d) > tol1 ? … : copysign(tol1, xm)`; tol1 = 2ε\|b\| + 0.5e-10 = 5.00005e-11 (`py/case2_errors.py`) | yes |
| index.qmd Case 1 | "x* ≈ 0.3285" | mpmath 0.32853845861141489597 | yes |
| index.qmd Case 1 | "takes 8 steps: secant, bisection, IQI, secant, IQI, secant, secant, IQI" | `brentsaa_steps.out` labels; frames 2–9 viewed | yes |
| index.qmd Case 1 | "At step 3 the IQI point 0.2276 has the larger \|f\|, so it becomes the other end of the bracket and b stays at 0.4" | `zeroin_instr.out` IQI point 0.227605801971; step 3 state b = 0.4, c = 0.2276058; `py/case2_errors.py`: f(0.2276) = −0.9124, f(0.4) = 0.4960 | yes |
| index.qmd Case 1 | "After the bisection at step 2 every step is an interpolation step" | labels for steps 3–8: I, S, I, S, S, I | yes |
| index.qmd Case 1 | "at steps 5–8 the error in b falls to 3.2×10⁻⁴, 5.5×10⁻⁶, 2.7×10⁻⁹ and 4.0×10⁻¹⁹" (round 2; was "about 10⁻¹⁶") | `py/case1_compare.py`: 3.237e-4, 5.461e-6, 2.738e-9 (15-digit inputs; the rounding is far below these errors). Step 8: `py/step8_error.py` with the exact double (hex 3fd506c62bcdb6b5) gives 3.98346e-19 at both dps 30 and dps 50 | yes |
| index.qmd Case 1 | "at step 8 b is the double-precision number nearest the root, and f(b) evaluates to exactly 0" (round 2) | `py/step8_error.py`: float(x*) == b8 True; the neighbouring doubles' errors are 5.591e-17 and 5.511e-17, against 3.98e-19 for b8; f(b8) in Float64 = 0.0 (also `brentsaa_steps.out`); exact f(b8) = 3.1e-18 | yes |
| index.qmd Case 1 | "bisection needs 32 iterations and regula falsi 24" (to within 10⁻¹⁰ on [0,1]) | `py/case1_compare.py`: bisection first and stays below at k = 32; regula falsi first at k = 24 (errors monotone). Brent's b is within 1e-10 at step 8 | yes |
| index.qmd Case 1 alt | "x≈0.3285 in 8 steps" | as above | yes |
| index.qmd Case 2 | "takes 10 steps: secant, two bisections, then secant, IQI, secant, secant, IQI, secant and a final minimum step" | `brentsbb_steps.out` labels Secant, Bisection, Bisection, Secant, IQI, Secant, Secant, IQI, Secant, Min step; frames viewed | yes |
| index.qmd Case 2 | "bracket of width 5×10⁻¹¹ with b ≈ 1.1655611852 at one end" | `py/case2_errors.py` step 10: b = 1.165561185202631, c = 1.165561185252632, width 5.0001e-11, contains x* = 1.16556118520721 | yes |
| index.qmd Case 2 | "The bisection at step 3 moves the right end of the bracket off x = 1.5, to 1.2598" | `brentsbb_steps.out`: c = 1.5 at steps 0–2, c = 1.259815943 at step 3 (label Bisection) | yes |
| index.qmd Case 2 | "Regula Falsi … needs 165 iterations to get within 10⁻¹⁰" | `py/regula_falsi.py`: k = 165 (50 digits and double precision) | yes |
| index.qmd Case 2 | "f is convex here" | min f″ on [0.5,1.5] grid = 1.419 > 0 (f″ = 2 sec²x tan x > 0 on (0, π/2)) | yes |
| index.qmd Case 2 | "every chord lands left of the root, the right endpoint stays at 1.5" | `py/regula_falsi.py`: all chord points < x* True; right endpoint always 1.5 True (400 iterations) | yes |
| index.qmd Case 2 | "the error eventually shrinks only by a factor of about 0.87 per iteration" | ratios 0.936 (k=2), 0.898 (k=11), 0.8666 (k=51), 0.866418 (k ≥ 101); theory 0.866418 | yes |
| index.qmd Case 2 alt | "converging in 10 steps" | as above | yes |
| brentsaa.jl:3 | "Root ≈ 0.3285" | as F1 | yes |
| brentsaa/bb.jl header comment | "b = best, c = contrapoint, a = previous b (or a == c); IQI if a != c, secant if a == c; accepted only if less than about 3/4 of the way from b to c and smaller than half the step before last" | as for the page sentences above | yes |
| GIF labels (new values) | "Step k: …", "b = …" | `brentsaa_steps.out`/`brentsbb_steps.out` legend column = `round(b; digits=6)` of the true iterate (e.g. 1.17666032953 → "1.17666"), matching the frames | yes |

Unchanged numbers kept on the page and rechecked: f(0) = −4 and f(1) = 1. f(0.5) = −0.4537, so "≈ −0.454"; f(1.5) = 11.1014, so "≈ 11.1". x* = 1.16556118520721, so "≈ 1.1656". The only sign change of tan x − 2x in (0, π/2) is at 1.1655 (`py/check_runs.py`).

## Scripts and GIFs
- Scripts changed: `brentsaa.jl` and `brentsbb.jl`. Both have the new `run_brents` (ZEROIN), plot the bracket between b and c with the red dot at b, and add the "Min step" colour. brentsaa.jl also has the header root fixed and a comment reworded. Plot styling, window, title, tol, fps and paths are unchanged.
- GIFs regenerated: `brentsaa.gif` has 9 frames (was 11) and `brentsbb.gif` has 11 frames (was 10). The scripts were regenerated again after comment-only edits. The decoded frame md5s are identical to the frames I viewed (`regen2/*/frames.md5` = `new_gif/*/frames.md5`).
- Frames viewed at full size:
  - Case 1: frame 1 (Start, bracket [0,1], b = 1.0); frame 4 (Step 3: IQI, bracket 0.2276–0.4, b = 0.4); frame 9 (Step 8: IQI, b = 0.328538, the red dot on the root).
  - Case 2: frame 4 (Step 3: Bisection, bracket 1.0196–1.2598); frame 6 (Step 5: IQI, b = 1.17666); frame 11 (Step 10: Min step, b = 1.165561).
  - The contact sheets show every label legible in both cases. The title fits, the legend does not cover the curve near the root, and the root is inside the window.
- `git status --short -- pages/numerical-methods/brents-method` after regeneration: `M brentsaa.gif`, `M brentsaa.jl`, `M brentsbb.gif`, `M brentsbb.jl`, `M index.qmd`. These are exactly the expected files.

## Legacy archive
Consulted: `brentmethod/BrentMethodMod.html` and the solutions `BrentMethodMod_lnk_6.html` (Example 4) and `lnk_7.html` (Example 5), with their graph images.
- **Case 1** is Mathews' Example 4, Root (i): the same cubic on [0, 1] (graph `gr_224`). His Brent printout (`gr_229`) lists the iterates 0.8, 0.4, 0.4, 0.3392878121748930, 0.3282147397456249, 0.3285439194491427, 0.3285384613493639, 0.3285384586114148, which is the new script's sequence digit for digit. His final b = 0.3285384586114148, so the archive also supports the F1 root of 0.3285.
- **Case 2** is Mathews' Example 5: tan x − 2x on [0.5, 1.5] (`gr_271`). His Brent printout (`gr_276`) lists 0.5392637731145249, 1.0196318865572620 (twice), 1.1182930272785790, 1.1766603295259700, 1.1637285834543310, 1.1654929603348210, 1.1655612050524230, 1.1655611852026310. These match the new script through the second-to-last step. He used a tighter tolerance (±10⁻¹⁵, `gr_274`), so his final point differs from our tol = 1e-10 minimum step.
- So Mathews ran genuine Brent, and the old script's extra bisections were not in the original.
- **The 243 in F6** comes from Mathews' call `RegulaFalsi[0.5, 1.5, 243]` (`gr_283`), "to achieve an accuracy of ±10⁻¹⁵". His printout stops at p₂₄₃ = 1.16556118520721 (`gr_295`/`gr_296`). It is an iteration cap tied to a 10⁻¹⁵ target, not a computed count. At 50 digits, |x−x*| < 10⁻¹⁵ first holds at k = 245 (`py/regula_falsi.py`). The page now uses the computed 165 for 10⁻¹⁰ and states the tolerance.
- His caveat that "the graph of the function flattens out near the root" was not carried over. f′(x*) = 4x*² − 1 ≈ 4.43, so the graph is not flat there. The page explains the slowness by the fixed endpoint and the error ratio instead.
- Mathews' own text also says the root lies "in either [ ] or [ ]", with the bracket images not readable as text. The page now follows the mathematics: between b and c.

## Notes
- **F4 option (a) chosen** over (b). The labels now show what Brent's method actually picks. The archive shows that Mathews' examples are genuine Brent, and scipy brentq confirms the evaluation points independently.
- **New "Min step" label.** ZEROIN replaces a step shorter than tol1 by a step of length tol1. This happens at Case 2's last step, where the secant step to 1.165561185207 was shorter than tol1 ≈ 5e-11. Labelling that frame "Secant" would misdescribe the move, so it gets its own label and a page sentence explaining it.
- **F5 bound left out.** The suggested worst-case bound ((log₂((b−a)/δ))² evaluations, Brent 1973) was not added, because I could not verify it by computation. Jason could add it with a citation if wanted. The bibliography has no Brent entry.
- **List items 1–2 changed beyond the finding text.** Their "most recent points" wording had to change once the labelling was fixed (F7); the reasons are recorded above.
- **Pre-existing text not touched:** "developed by Richard Brent in 1971" (the 1971 paper; ZEROIN appeared in his 1973 book) and the convergence-order table.
- Nothing outside the page folder was touched.

## Resolution check (independent checker, not shown this record)

Work files (all in this folder): `zeroin.py` (my own transcription of Brent's 1973 ZEROIN, Netlib form, with a step trace), `check1.py` (traces of both page cases plus scipy.brentq and mpmath roots), `check2.py` (bisection and regula falsi counts, the x^9 example), `trace.jl` (dumps the `steps` array of the committed scripts), `run/` (scratch copies of the scripts and regenerated GIFs), `fa/`, `fb/` (extracted frames and contact sheets).

### Original findings

### F1 — resolved
- Evidence: the mpmath root is 0.328538458611414896, and numpy roots are 0.32853846, 1.26465829 and 2.40680325. index.qmd:66 now gives "x* ≈ 0.3285", the alt text at :70 gives "x≈0.3285", and brentsaa.jl:3 gives "Root ≈ 0.3285". grep finds no 0.3268 or 0.3224 left in the folder. The last frame of brentsaa.gif shows b = 0.328538.

### F2 — resolved
- Evidence: the scripts now run ZEROIN (see F4). The Case 1 frames are labelled Start, Secant, Bisection, IQI, Secant, IQI, Secant, Secant, IQI: 9 frames for 8 steps. This matches my independent ZEROIN trace and the page's new sequence "secant, bisection, IQI, secant, IQI, secant, secant, IQI". The new Behavior paragraph has no "begins with secant steps" claim. Its numbers are checked in the ledger.

### F3 — resolved
- Evidence: line 34 now says "otherwise a bisection step is taken instead". Line 38 now says "When only two distinct points are available (a = c), the method uses the secant step instead of IQI", and "(or IQI is rejected)" is gone. Both match the code: brentsaa.jl:62 picks secant only when `a == c`, and a rejected candidate becomes `d = xm`, a bisection (:85–88). Item 2 at line 17 says the same thing.

### F4 — resolved
- Evidence: `run_brents` in both scripts is now a ZEROIN loop.
  - Its state matches ZEROIN: contrapoint c, previous iterate a, and steps d/e with the `c = a; d = e = b − a` reset.
  - The swap is `a, b, c = b, c, b`.
  - The acceptance test is `2p < 3·xm·q − |tol1·q|` and `p < |e·q/2|`, with `tol1 = 2·eps·|b| + tol/2` and the minimum step `copysign(tol1, xm)`.
  - I wrote my own ZEROIN in Python (zeroin.py). It reproduces every (b, c, label) of the Julia `steps` array exactly, to every printed digit, for both cases.
  - scipy.brentq returns the same final iterate and the same call count: 10 calls for Case 1 and 12 for Case 2.
  - The bisections the old variant forced (Case 1 steps 5–7, Case 2 step 4) are gone. Those steps are now IQI, Secant, Secant (Case 1) and Secant (Case 2), as the original table predicted for ZEROIN.

### F5 — resolved
- Evidence: the false claim that the bracket halves every other step and converges as O(2^-n) is gone. The replacement statements are true:
  - The bracket is always kept. This is the ZEROIN invariant fb·fc ≤ 0.
  - Interpolation is rejected beyond about 3/4 of the way from b to c, or when it is not smaller than half the step before last. This is the acceptance test above.
  - The method is not at least as fast as bisection. For x^9 on [−1, 2] with tol 1e-10, my ZEROIN needs 96 evaluations. scipy.brentq also reports 96, and the bracket first drops below 1e-10 at that evaluation. Bisection needs ceil(log2(3/1e-10)) = 35 halvings plus the 2 endpoint evaluations, which is 37. Both counts include the endpoints, so they are comparable.

### F6 — resolved
- Evidence: "≈ 243" and "chord always lands near x = 0.5" are gone. The replacement statements check out:
  - Regula falsi from [0.5, 1.5] first gets within 1e-10 of 1.16556118520721 at iteration 165.
  - The right endpoint is 1.5 in every iteration.
  - The chord points are 0.539, 0.579, 0.619, 0.659, 0.698, …, moving steadily rightward.
  - The error ratio tends to 0.8664, so "about 0.87" is right.
  - "Every chord lands left of the root" holds because f'' = 2 sec²x tan x > 0 on (0.5, 1.5), so f is convex and increasing near the root.

### F7 — resolved
- Evidence: the Description now uses one labelling throughout. Line 24 states f(b)f(c) ≤ 0 and |f(b)| ≤ |f(c)|. Line 26 says "root always lies between b and c; a is the previous value of b (or coincides with c)". Line 60 now says "current bracket between b and c". The scripts use the same labelling: `BrentStep(b, c, …)`, the shaded region is min/max(b, c), and the red dot is `st.b`. The "either [b,c] or [a,b]" claim is gone. The secant formula at line 40 now means the chord to the contrapoint (a = c), and line 38 says so.

### Changed-text ledger

| Location | Text / number | Check | Verdict |
|---|---|---|---|
| qmd:14 | "maintains a bracket that always contains a root" | ZEROIN invariant fb·fc ≤ 0 | OK |
| qmd:16 | IQI through the three points a, b, c | code uses a, b, c when a ≠ c | OK |
| qmd:17 | secant = chord through (a,f(a)), (b,f(b)) when a = c | code :62–66; when a = c this is the chord to the contrapoint | OK |
| qmd:18 | bisection "used whenever interpolation is not making enough progress; … bracket shrinks by at least half" | bisection moves b to the midpoint of [b,c]; the new bracket is half the old one | OK |
| qmd:26 | root between b and c; a = previous b or coincides with c | code :42–49 | OK |
| qmd:34 | rejected → bisection | code :85–88 | OK |
| qmd:38 | secant when only two distinct points (a = c) | code :62 | OK |
| qmd:44 | 3/4 rule, half-step-before-last rule | code :81 | OK |
| qmd:44 | x^9 on [−1,2]: 96 evaluations to bracket < 1e-10, bisection 37 | my ZEROIN gives nf = 96 and the first width < 1e-10 at step 94 (nf 96); scipy gives 96; bisection 35 + 2 = 37 | OK |
| qmd:60 | "bracket between b and c" | script draws min/max(b,c) | OK |
| qmd:60 | "Min step" = a step shorter than the tolerance ≈ 5×10^-11, replaced by a step of that length | tol1 = 2·eps·1.1656 + 5e-11 = 5.00000000005e-11; code :95–99 | OK |
| qmd:66 | x* ≈ 0.3285 | mpmath 0.3285384586 | OK |
| qmd:66 | 8 steps: S, B, I, S, I, S, S, I | independent trace and frames | OK |
| qmd:66 | step 3 IQI point 0.2276 has the larger \|f\|, becomes the other end, b stays 0.4 | trace: c = 0.22760580, b = 0.4; frame 4 shows b = 0.4 with the bracket [0.228, 0.4] | OK |
| qmd:66 | after step 2 every step is interpolation | labels at steps 3–8 are I, S, I, S, S, I | OK |
| qmd:66 | errors at steps 5–7: 3.2e-4, 5.5e-6, 2.7e-9 | 3.237e-4, 5.461e-6, 2.738e-9 (mpmath) | OK |
| qmd:66 | error at step 8 "about 10^-16" | b = 0.3285384586114149 (exact double), \|b − x*\| = 3.98e-19. b is the double nearest x* (half an ulp is 2.8e-17) | **Wrong magnitude** (see N1) |
| qmd:66 | f(b) = 0 exactly at step 8 | fb = 0.0 in both Python and Julia | OK |
| qmd:66 | bisection 32 iterations, regula falsi 24, to within 1e-10 on [0,1] | the actual midpoint error first drops below 1e-10 at n = 32 (the a priori bound would give 33); regula falsi gives 24 | OK |
| qmd:70 | alt: x≈0.3285, "in 8 steps" | 9 frames (Steps 0–8) | OK |
| qmd:74 | 10 steps: S, B, B, S, I, S, S, I, S, Min step | trace and frames | OK |
| qmd:74 | bracket width 5×10^-11, b ≈ 1.1655611852 at one end | final b = 1.16556118520263, c = 1.16556118525263, width 5.000e-11; x* = 1.16556118520721 lies inside | OK |
| qmd:74 | step-3 bisection moves the right end off 1.5 to 1.2598 | c = 1.2598159433 at step 3 | OK |
| qmd:74 | regula falsi 165 iterations, convex, right end stays at 1.5, factor ≈ 0.87 | 165; right ends {1.5}; ratio → 0.8664 | OK |
| qmd:78 | alt "converging in 10 steps" | 11 frames (Steps 0–10) | OK |
| aa.jl:3 | "Root ≈ 0.3285" | mpmath | OK |
| aa/bb.jl:22–26 | comment block describing ZEROIN | matches the code | OK |
| aa/bb.jl:112 | "Min step" colour gray | frame 11 of bb shows "Step 10: Min step" in gray | OK |

### New problems

- **N1 — Minor — index.qmd:66** says that at step 8 "the error in b falls to … about $10^{-16}$". The final iterate is 0.3285384586114149, and its exact distance from x* = 0.328538458611414896 is 3.98×10⁻¹⁹. b is the double nearest the root; half an ulp is 2.8×10⁻¹⁷. So the stated error is about 250× too large. Better wording: "below 10⁻¹⁸, i.e. b is the double closest to the root". Evidence: `check1.py` prints err=3.983e-19 for step 8.

No other new problems. This rests on three things:
- an independent ZEROIN transcription that reproduces both scripts' step arrays exactly, and agrees with scipy;
- mpmath references for every number in the changed text;
- a full-size look at frames 4 and 9 of brentsaa.gif and frame 11 of brentsbb.gif, and at the full contact sheets. In those frames the labels are legible and match the trace. Each legend b value is the step's b. The bracket shading spans [min(b,c), max(b,c)]. The title, axes, curve and asymptote marker are unchanged from before.

### Reproducibility and conventions

- `brentsaa.jl` and `brentsbb.jl` were run from scratch copies, and their output is byte-identical to the committed GIFs:
  - brentsaa.gif sha256 3b0be40c…, which also matches the LFS oid in the diff;
  - brentsbb.gif sha256 08959cd3….
- The frame counts are 9 and 11.
- The page keeps the conventions:
  - Description comes before Animations.
  - Each case has a "Julia source" link and a GIF embed.
  - The alt texts are descriptive.
  - There are no code blocks.
  - The section index still links the page (pages/numerical-methods/index.qmd:24).
- The page fix touched only the five files in pages/numerical-methods/brents-method/. The other modified paths in the working tree belong to other pages' fixes. There is also an untracked review note at reviews/numerical-methods-animations/fixes/brents-method.md. I did not read it, as the brief instructs.

### Re-check

### N1 — resolved
- index.qmd:66 now reads "...the error in $b$ falls to $3.2\times10^{-4}$, $5.5\times10^{-6}$, $2.7\times10^{-9}$ and $4.0\times10^{-19}$: at step 8 $b$ is the double-precision number nearest the root, and $f(b)$ evaluates to exactly 0."
- My own computation (mpmath at 50 digits) gives x* = 0.328538458611414896. The final iterate is b = 0.3285384586114149, and |b − x*| = 3.98e-19, which rounds to 4.0e-19.
- Its neighbouring doubles are 0.32853845861141484 and 0.32853845861141495. Their errors are 5.51e-17 and 5.59e-17, so b is the double nearest the root.
- f(b) evaluates to 0.0 in Python, and in the Julia trace.

### Nothing else changed
- brentsaa.jl and brentsbb.jl are byte-identical (cmp) to the scratch copies I ran in the first check.
- Both GIFs have the same sha256 as before: 3b0be40c… and 08959cd3….
- index.qmd still has 79 lines. I compared every other changed line (14, 16–18, 26, 34, 38, 44, 60, 70, 74, 78) with the text I checked in the first round, and they are identical. Only line 66 differs.
- No file outside the page folder changed for this page.

### New problems
None.

**Final status:** committed
