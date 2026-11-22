# False Position or Regula Falsi Method — animation review

Page: [`pages/numerical-methods/false-position-or-regula-falsi-method/index.qmd`](../../pages/numerical-methods/false-position-or-regula-falsi-method/index.qmd) · Scripts: `regulafalsiaa.jl`, `regulafalsibb.jl` · GIFs: 2

**Result:** 3 error, 0 misleading, 2 minor.

Errors and misleading findings were each re-checked by an independent subagent given only the allegation (not the reviewer's reasoning). Minor findings were not independently re-checked. Finding IDs (F1, F2, …) are the reviewer's and match the claim ledger below.

## Findings

### F1 — Error — Page match — Case A root is quoted as 1.3688; the true root is 1.36523

- **Location:** index.qmd:19, "The method converges to the real root $x^* \approx 1.3688$". Also in the script comment `regulafalsiaa.jl:6`, "True root ≈ 1.3688".
- **Now:** x* ≈ 1.3688.
- **True:** the real root of x³ + 4x² − 10 is x* = 1.365230013414. The quoted value is wrong in the third decimal. The GIF contradicts the page: its last frame's legend reads `c_12 = 1.365229`.
- **Evidence:** `python3 -I reviewer/indep.py` printed `A root 1.3652300134141`. Check: f(1.3688) = 1.3688³ + 4(1.3688)² − 10 ≈ 0.0590, which is not near zero. The script's c₁₂ = 1.36522935002777 (`aa_values.txt`), and the frame_013 legend shows `c_12 = 1.365229`.
- **Suggested fix:** change it to $x^* \approx 1.3652$ (or 1.36523) on line 19 and in the comment on `regulafalsiaa.jl:6`.

- **Independent check:** confirmed.

### F2 — Error — Page match — Case A says the left endpoint a = −1 stays fixed, but a moves and b = 2 is the fixed endpoint

- **Location:** index.qmd:19, "The left endpoint $a = -1$ stays fixed throughout because $f(-1) < 0$ and all successive false-position points $c$ also satisfy $f(c) < 0$, so the algorithm keeps replacing $a$ with $c$ while $b = 2$ holds."
- **Now:** the sentence opens by saying a = −1 stays fixed, then says a is replaced by c each step while b = 2 holds. These contradict each other.
- **True:** b = 2 is the fixed endpoint. a takes the values −1, 0, 0.8333, 1.2088, 1.3241, 1.3548, …, 1.365227. The rest of the sentence is correct: every f(c) < 0, so a ← c and b = 2 holds. The alt text on line 23 is also correct ("with the right endpoint fixed and successive false-position points converging from the left"). In the frames, the shaded bracket's left edge moves right while the blue dot stays at (2, 14).
- **Evidence:** `aa_values.txt` gives `b_next=2.0` and `a_next=c` at all 12 iterations, with f(c) running from −10.0 to −1.095e−5. `indep.py` independently gives the same a-sequence and b = 2 throughout. Frames 002 and 013 were checked.
- **Suggested fix:** "The right endpoint $b = 2$ stays fixed throughout: $f(-1) < 0$ and every false-position point $c$ also satisfies $f(c) < 0$ (f is convex on the bracket), so the algorithm keeps replacing $a$ with $c$ while $b = 2$ holds."

- **Independent check:** confirmed. Checker: every f(c_k)<0, so a moves every step (−1 → 0 → 0.833 → …) while b=2 is fixed; the same sentence also says 'b = 2 holds', so line 19 contradicts itself.

### F3 — Error — Page match — Case B gets the one-sided behaviour backwards: a = 0 does not stay fixed, the points approach from the left, and the bracket shrinks from the left

- **Location:** index.qmd:27, "The left endpoint $a = 0$ remains fixed at $f(0) = -1$ throughout, while successive false-position points advance from the right. … the bracket shrinks only on the right side". The alt text at index.qmd:31 says the same: "with the left endpoint fixed at 0 while the right endpoint steps in". The source comments `regulafalsibb.jl:3-4` repeat it: "left endpoint stays fixed at 0. The successive c points converge from the right."
- **Now:** a = 0 fixed, c approaches from the right, the right side shrinks.
- **True:** f(x) = x − cos x is convex on [0, 1] (f'' = cos x > 0), with f(0) = −1 and f(1) = 0.4597. Every c lies left of the root with f(c) < 0, so a is replaced every step and **b = 1 stays fixed**. The iterates 0.685073, 0.736299, 0.738945, 0.739078, … increase toward x* = 0.7390851332 from the left. The bracket shrinks only on the left side. The frames show the same thing: the blue dot stays at (1, 0.4597) and the shading's left edge moves right.
- **Evidence:** `bb_values.txt` gives `b_next=1.0` at all 10 iterations, every f(c) < 0 (−0.0893 down to −1.85e−13), and c increasing. `indep.py` gives the same sequence and a root of 0.739085133215161. The bb contact sheet and the frames were checked.
- **Suggested fix:** line 27: "The right endpoint $b = 1$ remains fixed (with $f(1) \approx 0.4597$) throughout, while successive false-position points advance from the left. … the bracket shrinks only on the left side, yet the secant intercept homes in on the root accurately." Line 31 alt text: "…with the right endpoint fixed at 1 while the left endpoint steps in." Correct `regulafalsibb.jl:3-4` to match.

- **Independent check:** confirmed.

### F4 — Minor — Implementation — A script comment says regula falsi is "slower than bisection"; on this problem it is faster

- **Location:** `regulafalsiaa.jl:5`, "Note: one endpoint tends to stay fixed as the other converges (slower than bisection)."
- **Now:** says the method is slower than bisection.
- **True:** for Case A the error falls by a factor of 0.2513 per step, compared with bisection's 0.5. After 12 iterations the regula falsi error is 6.6e−7, while bisection's midpoint error bound after the same 12 halvings of [−1, 2] is 3.7e−4. One-sided convergence is linear, but here it is not slower than bisection. The page itself does not make this claim. Line 13 even says "often giving faster convergence", so the comment contradicts the page.
- **Evidence:** `indep_out.txt` gives error ratios 0.2542, 0.2520, 0.2515, …, 0.25127; `A asymptotic ratio 0.251271`; `err 6.634e-7` at i = 12; `bisection half-width after n: 0.0003662`.
- **Suggested fix:** change the comment to "(convergence is only linear; for some functions it can be slower than bisection)", or delete the parenthetical.

- **Independent check:** not run (minor finding, unverified).

### F5 — Minor — Page match — Each frame's secant joins the previous bracket's endpoints, but the frame marks and shades the updated bracket

- **Location:** `regulafalsiaa.jl:84-89` and `regulafalsibb.jl:83-87` draw the secant through `as[frame], bs[frame]`, the bracket before step `frame`. Lines 46-47/45-46 and 69-75/68-74 shade and mark `as[frame+1], bs[frame+1]`, the bracket after the step. The page text at index.qmd:13 reads "At each step, a secant line is drawn through the two bracket endpoints $(a, f(a))$ and $(b, f(b))$".
- **Now:** in frame k, the dashed secant passes through (a_{k−1}, f(a_{k−1})). That point is no longer marked, lies outside the shaded bracket, and is labelled by nothing. The marker labelled "bracket [a, b]" sits at the new a = c_k, under the red dot. For example, Case A frame 002 shades [0, 2], but its secant runs from (−1, −7) to (2, 14).
- **True:** the computation and geometry are correct. The secant does join the endpoints of the bracket that produced c_k, and its x-intercept is c_k. However, the chord never visibly joins the two blue markers labelled "bracket [a, b]" in the same frame, which is what line 13 leads a reader to expect.
- **Evidence:** code reading of the lines above. In frame_002 of regulafalsiaa, the secant crosses the curve at x = −1, the shading starts at x = 0 and blue markers appear only at x = 0 (hidden under the red point) and x = 2.
- **Suggested fix:** in frame k, also draw the old endpoint `(as[frame], f(as[frame]))` as a hollow marker. Alternatively, change the page to say "the secant through the previous bracket endpoints; the shaded region is the updated bracket".

- **Independent check:** not run (minor finding, unverified).

## Inventory (Phase 1)

Every script was copied to scratch and run with the global Julia environment (Plots 1.41.2, SpecialFunctions 2.9.2); each was also run alone to map scripts to GIFs.

| Script | Ran | Time (s) | GIFs produced |
|---|---|---|---|
| `regulafalsiaa.jl` | yes | 3.6 | regulafalsiaa.gif |
| `regulafalsibb.jl` | yes | 3.5 | regulafalsibb.gif |

Committed GIFs byte-identical to their regenerated output: **2 of 2**. Decoded frames were also compared; all match.

Inventory findings: none (every script runs, every GIF is produced by a script and embedded by the page, every page reference exists, and the section index links the page).

## Claim ledger

| # | index.qmd line | Claim (page's own words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | 13 | "a secant line is drawn through the two bracket endpoints (a, f(a)) and (b, f(b)); its x-intercept c becomes the new estimate" | The algorithm (aa:30, bb:29) is exactly this. The drawn secant uses the pre-step bracket while the frame shows the post-step bracket | confirmed for the method; drawing caveat → F5 |
| 2 | 13 | "Regula Falsi weights the new point toward whichever endpoint has a smaller \|f\| value" | c = (a\|f(b)\| + b\|f(a)\|)/(\|f(a)\|+\|f(b)\|) is a weighted mean that lies closer to the endpoint with smaller \|f\|. Case B step 1: \|f(1)\| = 0.46 < \|f(0)\| = 1 and c = 0.685, closer to 1 | confirmed |
| 3 | 13 | "often giving faster convergence" (than bisection) | Case A: error 6.6e−7 against the bisection bound 3.7e−4 after 12 steps. Case B: 1.1e−13 against 4.9e−4 after 10 | confirmed |
| 4 | 13 | "one endpoint can remain fixed for many iterations" | b fixed for all 12 (A) and all 10 (B) iterations | confirmed |
| 5 | 15 | Julia scripts are linked under each case | lines 21 and 29 | confirmed |
| 6 | 17 | Case A heading: "Convergent, f(x) = x³ + 4x² − 10, [a, b] = [−1, 2]" | `regulafalsiaa.jl:13-14` matches; the iterates converge | confirmed |
| 7 | 19 | "converges to the real root x* ≈ 1.3688" | true root 1.365230013 (mpmath); GIF shows c_12 = 1.365229 | wrong (→ F1) |
| 8 | 19 | "The left endpoint a = −1 stays fixed throughout" | a: −1 → 0 → 0.833 → … ; b = 2 fixed | wrong (→ F2) |
| 9 | 19 | "f(−1) < 0" | f(−1) = −7 | confirmed |
| 10 | 19 | "all successive false-position points c also satisfy f(c) < 0" | f(c_k) from −10 to −1.1e−5, all negative | confirmed |
| 11 | 19 | "the algorithm keeps replacing a with c while b = 2 holds" | `aa_values.txt` | confirmed |
| 12 | 19 | "This 'one-sided' stagnation is characteristic of Regula Falsi" | the fixed endpoint is seen in both cases; this is a general statement | confirmed |
| 13 | 21 | Link `regulafalsiaa.jl` is Case A | the script's f and bracket match the heading | confirmed |
| 14 | 23 | Alt text: "f(x)=x³+4x²−10 on [−1,2]" | matches the script and the frame titles | confirmed |
| 15 | 23 | Alt text: "walks toward the root near x=1.37" | 1.36523 rounds to 1.37 | confirmed |
| 16 | 23 | Alt text: "with the right endpoint fixed and successive false-position points converging from the left" | b = 2 fixed; c increasing toward the root | confirmed |
| 17 | 23 | Embed `regulafalsiaa.gif` is Case A | the manifest shows it is produced by regulafalsiaa.jl, byte-identical | confirmed |
| 18 | 25 | Case B heading: "Convergent (one-sided), f(x) = x − cos(x), [a, b] = [0, 1]" | `regulafalsibb.jl:12-13` matches; convergence is one-sided | confirmed |
| 19 | 27 | "converges to the 'Dottie number' x* ≈ 0.7391, the unique fixed point of cosine" | root 0.7390851332; x − cos x is strictly increasing (f' = 1 + sin x ≥ 0, zero only at isolated points), so the root is unique | confirmed |
| 20 | 27 | "The left endpoint a = 0 remains fixed at f(0) = −1 throughout" | f(0) = −1 is true, but a moves (0 → 0.685 → 0.736 …) and b = 1 is fixed | wrong (→ F3) |
| 21 | 27 | "successive false-position points advance from the right" | c increases from 0.685 toward 0.73909, so the points approach from the left | wrong (→ F3) |
| 22 | 27 | "the bracket shrinks only on the right side" | only the left side moves | wrong (→ F3) |
| 23 | 27 | "yet the secant intercept homes in on the root accurately" | c_10 error 1.1e−13 | confirmed |
| 24 | 29 | Link `regulafalsibb.jl` is Case B | matches | confirmed |
| 25 | 31 | Alt text: "f(x)=x−cos(x) on [0,1] … converges to the Dottie number x*≈0.739" | confirmed | confirmed |
| 26 | 31 | Alt text: "with the left endpoint fixed at 0 while the right endpoint steps in" | the right endpoint is fixed at 1; the left endpoint steps in | wrong (→ F3) |
| 27 | 31 | Embed `regulafalsibb.gif` is Case B | the manifest shows it is produced by regulafalsibb.jl, byte-identical | confirmed |

(The page has no Description section, so the formula on line 13 is the only method description.)

## Implementation checks

### regulafalsiaa.jl
- **Method:** plain regula falsi (false position). It computes `c = (a f(b) − b f(a))/(f(b) − f(a))` and keeps the subinterval with the sign change (`f(a) f(c) < 0` → b = c, else a = c). It does not use the Illinois or Pegasus modification and does not discard bracketing as the secant method does. It runs a fixed 12 iterations with no stopping test, which is fine for an animation. No f(c) = 0 occurs, so the `else` branch's handling of an exact zero is never exercised.
- **Numbers:**

  | k | script c_k (Float64) | independent c_k (mpmath) | f(c_k) | error |
  |---|---|---|---|---|
  | 1 | 0.0 | 0.0 | −10 | 1.365 |
  | 2 | 0.8333333333333334 | 0.833333333333 | −6.6435 | 0.532 |
  | 3 | 1.2087912087912087 | 1.20879120879 | −2.389 | 0.156 |
  | 4 | 1.32412611057995 | 1.32412611058 | −0.6652 | 0.0411 |
  | 6 | 1.362596802578731 | 1.36259680258 | −0.04343 | 2.63e−3 |
  | 8 | 1.365063606246616 | 1.36506360625 | −2.75e−3 | 1.66e−4 |
  | 10 | 1.365219506354675 | 1.36521950635 | −1.74e−4 | 1.05e−5 |
  | 12 | 1.36522935002777 | 1.36522935003 | −1.10e−5 | 6.6e−7 |

  The script and the independent run agree at every iteration to the digits printed. Brackets: a_k = c_{k−1} and b = 2 throughout in both. The error ratio settles at 0.25127, matching the theoretical one-sided rate 1 − f'(r)(2 − r)/f(2) = 0.251271. This is linear convergence, faster than bisection (F4).
- **Reference values:** the script draws no reference root. The only reference is the comment "True root ≈ 1.3688" (line 6), which is wrong; the true root is 1.3652300134 (F1). The GIF shows only computed c values, which are correct.
- **Picture:** I looked at the contact sheet and at frame_002 (k = 1) and frame_013 (k = 12) at full size. Title and curve label `x³ + 4x² − 10` match f in the code. The legend `c_k = round(c_k, 6)` uses the right index and value: frame_002 shows `c_1 = 0.0`, frame_013 shows `c_12 = 1.365229`, and the sheet shows c_2, c_4, c_6, c_8, c_10 matching the table. The secant in frame_002 passes through (−1, −7) and (2, 14) with x-intercept 0 = c₁. The vertical dotted line runs from (c, 0) to (c, f(c)). Gray diamonds mark earlier c's. The shaded bracket is the updated [a_k, 2]. No clamping is used. The root and all iterates are inside xlims = (−1.5, 2.5), and the curve exceeds ylims only near x > 2.1, which does not matter. Secant and bracket timing: F5. The frame count is 13 (1 initial + 12 iterations), matching the manifest.

### regulafalsibb.jl
- **Method:** the same plain regula falsi as above, with 10 iterations.
- **Numbers:**

  | k | script c_k | independent c_k | f(c_k) | error |
  |---|---|---|---|---|
  | 1 | 0.6850733573260451 | 0.685073357326 | −0.0893 | 0.0540 |
  | 2 | 0.736298997613654 | 0.736298997614 | −4.66e−3 | 2.79e−3 |
  | 3 | 0.7389453559657132 | 0.738945355966 | −2.34e−4 | 1.40e−4 |
  | 4 | 0.7390781308800257 | 0.73907813088 | −1.17e−5 | 7.0e−6 |
  | 5 | 0.7390847824489231 | 0.739084782449 | −5.87e−7 | 3.5e−7 |
  | 10 | 0.73908513321505 | 0.739085133215 | −1.85e−13 | 1.1e−13 |

  The values agree. b = 1 is fixed and a_k = c_{k−1} throughout. The error ratio is constant at 0.050093, matching the theoretical rate 1 − f'(r)(1 − r)/f(1) = 0.0500926. Convergence is linear but fast.
- **Reference values:** the comment root 0.7391 is correct (0.7390851332). The comments on lines 3-4 have the fixed endpoint and the direction of approach reversed (F3).
- **Picture:** I looked at the contact sheet (all 11 frames). The title and label match f. The legend values c_1 = 0.685073, c_2 = 0.736299, c_3 = 0.738945, c_4 = 0.739078, and c_5…c_10 = 0.739085 match the table. The blue marker stays at (1, 0.46) in every frame and the shading's left edge moves right, which visibly contradicts the page text (F3). In frame 1 the secant runs from (0, −1) to (1, 0.46) and crosses zero at 0.685. Frames 6–11 look the same because the changes are below the plot and legend resolution. That is not misleading, because the page claims nothing about those frames. Secant and bracket timing: F5.

## Evidence

The reviewer's and checker's computation scripts are copied to [`evidence/false-position-or-regula-falsi-method/`](evidence/false-position-or-regula-falsi-method/) (`reviewer/` and `verify/`). They were run from a scratch directory; paths inside them point at that scratch area and will need adjusting to re-run.
