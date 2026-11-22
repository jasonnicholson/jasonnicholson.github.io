# Improved Newton Method — animation review

Page: [`pages/numerical-methods/improved-newton-method/index.qmd`](../../pages/numerical-methods/improved-newton-method/index.qmd) · Scripts: `newtonimpaa.jl`, `newtonimpbb.jl`, `newtonimpcc.jl`, `newtonimpdd.jl`, `newtonimpee.jl` · GIFs: 5

**Result:** 2 error, 0 misleading, 4 minor.

Errors and misleading findings were each re-checked by an independent subagent given only the allegation (not the reviewer's reasoning). Minor findings were not independently re-checked. Finding IDs (F1, F2, …) are the reviewer's and match the claim ledger below.

## Findings

### F1 — Error — Implementation — Method A (m=3) frames show floating-point noise as iterates: x₃ and x₄ are wrong, and x₄ jumps away from the root

- **Location:** newtonimpdd.jl:11 (`f(x) = x^4 - x^3 - 3x^2 + 5x - 2` evaluated in expanded form), :17 (`n_iters = 5`), :29 (iteration), :55 (label). The result is visible in committed frames 4–6 of newtonimpdd.gif.
- **Now:** The legend labels read x₀=1.3, x₁=1.008824, x₂=1.000009, **x₃=1.000001, x₄=1.000719**, x₅=1.0. At step 4 the iterate moves about 1000 times farther from the root than at step 3.
- **True:** Method A in exact arithmetic gives x₃ = 1 + 8.25e-12 and x₄ = 1 + 7.56e-24, both "1.0" to 6 decimals. The ratio e/e² is 0.111111 (= 1/9) at every step. The script's values diverge from this once |x−1| ≲ 1e-5. Near a triple root the expanded quartic is pure cancellation: at the script's x₃ = 1.000000641886474, Float64 gives f(x₃) = −8.88e-16, but the true f(x₃) is 7.93e-19, with the wrong sign and 1000 times too large. This noise is divided by f'(x₃) ≈ 3.7e-12 and produces the jump to 1.000719. The page calls this case "quadratic convergence" (heading at line 48, lines 50–52, alt text at line 56), but the last two labelled values in the animation contradict that.
- **Evidence:** `reviewer/instr_dd.jl` (script iteration, printed) gives x = 1.0088235294117645, 1.0000086167285056, 1.000000641886474, 1.0007193769128275, 1.000000057738013. `reviewer/indep.py` (mpmath, 400 digits) gives err = 8.82353e-3, 8.61673e-6, 8.24975e-12, 7.56203e-24, 6.35382e-48, with e/e² = 0.0980, 0.1107, 0.111111, 0.111111. `reviewer/fix_check.jl` gives Float64 expanded f(x₃) = −8.881784197001252e-16 against an exact value of 7.934069861507476e-19.
- **Suggested fix:** Evaluate f in factored form, `f(x) = (x-1)^3*(x+2)` (and `fp(x) = (x-1)^2*(4x+5)`, which is identical to the current derivative), and set `n_iters = 3`. With factored f, Float64 gives 1.008824, 1.000009, 1.0. With more steps it reaches exactly 1.0 and then gives 0/0 = NaN at step 5, so either stop at 3 or stop once `f(x) == 0`. Another option is to iterate in BigFloat and only plot in Float64.

- **Independent check:** confirmed with correction. Checker: Float64 gives x3=1.000000642, x4=1.000719 vs 256-bit 1+8e-12, 1+8e-24. Correction: the jump is visible only in the legend text ('x₍4₎ = 1.000719', frame 5); the marker moves less than a pixel. f is defined on line 12, not 11.

### F2 — Error — Page match — "Methods A, B, and C do not fix this case" is false for Method B

- **Location:** index.qmd:64, "Note that Methods A, B, and C **do not fix this case** — they are designed to restore quadratic convergence at multiple roots, not to handle divergence caused by a flat-tailed function." The same idea recurs at line 66: "even the improved methods have limits".
- **Now:** The page says none of the three improved methods converges for arctan from x₀ = 1.4.
- **True:** The page never defines Method B. The standard Method B for multiple roots, and the one that goes with "Method A, accelerated" in this setting, is the modified Newton–Raphson method. It is Newton applied to u = f/f': $x_{n+1}=x_n-\dfrac{f f'}{(f')^2-f f''}$. From x₀ = 1.4 on arctan it converges to the root at 0: 0.6316, 0.1712, 6.25e-3, 3.25e-7, 4.58e-20, 1.28e-58. For large |x| the iteration behaves like x/2, so it does not escape. Method A with m = 1 is plain Newton, and m ≥ 2 overshoots further, so the claim is correct for A. For C it is plausible, but see F5.
- **Evidence:** `reviewer/indep.py`, section "arctan, Method B (Newton on u=f/fp), x0=1.4". It prints 0.63157320523693154984, 0.17116554462542049836, 0.0062468912799141324491, 3.2500489845917074701e-7, …
- **Suggested fix:** Change the sentence to say that Methods A and C do not fix this case. Also say that Method B (Newton on f/f') does converge here, because f/f' = (1+x²)·arctan x has no flat tail. Alternatively, remove the mention of B and C. If the author meant a different Method B, define it on the page (see F5).

- **Independent check:** confirmed. Depends on interpretation: the page never defines Method B. The checker notes this site's sibling page (accelerated-and-modified-newton-raphson) and the Mathews source define B as Newton applied to f/f′; under that reading B converges quadratically on arctan from x0=1.4, so the claim is false for B (true for A and C).

### F3 — Minor — Implementation — Method A (m=2) frame for x₄ shows 0.999999, a roundoff artefact

- **Location:** newtonimpbb.jl:12 (expanded `x^3 - 3x + 2`), :17 (`n_iters = 5`). Committed frame 5 of newtonimpbb.gif has the label "x₍4₎ = 0.999999".
- **Now:** The labels read 1.3, 1.013043, 1.000028, 1.0, **0.999999**, 1.0, so the iterate seems to cross below the root and back.
- **True:** In exact arithmetic x₄ = 1 + 2.92e-21, which rounds to 1.000000. The script's x₄ = 0.9999994335946778 comes from cancellation in f near the double root: f(x₃) evaluates to 2.22e-16, against a true value of about 5.1e-20. The error is in the 6th decimal, but the frame contradicts the clean quadratic convergence the page describes.
- **Evidence:** `reviewer/instr_bb.jl` gives x₃ = 1.0000000001306446, f = 2.220446049250313e-16, and x₄ = 0.9999994335946778. `reviewer/indep.py` gives err(x₃) = 1.32272e-10, err(x₄) = 2.91597e-21, and e/e² → 0.166667.
- **Suggested fix:** Same as F1. Use `f(x) = (x-1)^2*(x+2)` and `n_iters = 3`, or stop when f(x) == 0. `reviewer/fix_check.jl` shows the factored form gives 1.013043, 1.000028, 1.0.

- **Independent check:** not run (minor finding, unverified).

### F4 — Minor — Page match — Intro describes every case as a "tangent-line diagram … on functions with multiple roots"

- **Location:** index.qmd:12, "Each animation below shows the **tangent-line diagram** for Newton-type iterations on functions with multiple roots."
- **Now:** The intro presents all five animations as tangent-line diagrams on multiple-root functions.
- **True:** In Cases 2 and 4 the orange segment runs from (xₙ, f(xₙ)) to (xₙ₊₁, 0). Its slope is f'(xₙ)/m, so it is not the tangent. The code comments at newtonimpbb.jl:49–50 and newtonimpdd.jl:48 call it an "effective tangent". Case 5 (arctan) has a simple root. Line 13 describes the drawn segment correctly, which is why this is Minor.
- **Evidence:** Code at bb.jl:51 and dd.jl:49. For dd frame 2, the segment from (1.3, 0.0891) to (1.00882, 0) has slope 0.3060 = f'(1.3)/3 = 0.918/3, while the tangent slope is 0.918.
- **Suggested fix:** Change "tangent-line diagram" to something like "the tangent line (for Method A, the line of slope f'(xₙ)/m)", and "functions with multiple roots" to "mostly functions with multiple roots". Alternatively, say in Cases 2 and 4 that the orange line has slope f'(xₙ)/m.

- **Independent check:** not run (minor finding, unverified).

### F5 — Minor — Page match — Methods B and C are cited but never defined, and Method C's stated test uses the unknown root p

- **Location:** index.qmd:64–65, "Methods A, B, and C …" and "Method C searches for $m = 1, 2, 3, \ldots$ such that $|x_{n,m} - p| < |x_{n,m-1} - p|$".
- **Now:** Method B appears only by name. Method C's selection rule compares distances to p, the root being sought, so a reader cannot run the test.
- **True:** The page has no Description section defining the methods. The agent brief requires one, and it is absent. Under the rule as written, with p = 0, the numbers given are right: x_{1,1} = −1.413619, x_{1,2} = −4.227237, x_{1,3} = −7.040856. Whether the rule is the intended Method C could not be determined, because the method is not defined anywhere available to me.
- **Evidence:** `reviewer/indep.py`, last three lines.
- **Suggested fix:** Add a short Description that defines Methods A, B and C. Write C's test in computable quantities, for example $|f(x_{n,m})| < |f(x_{n,m-1})|$ or the step-difference form the source used.

- **Independent check:** not run (minor finding, unverified).

### F6 — Minor — Implementation — Titles cut off in the triple-root animations

- **Location:** newtonimpcc.jl:21 and newtonimpdd.jl:23 (title string), with `size=(640,600)` at :34 and :36.
- **Now:** Every frame of newtonimpcc.gif and newtonimpdd.gif shows "… (triple root at x=" cut off at the right edge, as seen in cc frame 13 and dd frame 5.
- **True:** The title text in the code ends "(triple root at x=1)". The root location, which is the point of the title, is not visible.
- **Evidence:** Committed frames `committed/newtonimpcc/frame_013.png` and `committed/newtonimpdd/frame_005.png`.
- **Suggested fix:** Shorten the title (e.g. "Standard Newton, f = (x−1)³(x+2)") or add `titlefontsize=10`.

- **Independent check:** not run (minor finding, unverified).

## Inventory (Phase 1)

Every script was copied to scratch and run with the global Julia environment (Plots 1.41.2, SpecialFunctions 2.9.2); each was also run alone to map scripts to GIFs.

| Script | Ran | Time (s) | GIFs produced |
|---|---|---|---|
| `newtonimpaa.jl` | yes | 3.3 | newtonimpaa.gif |
| `newtonimpbb.jl` | yes | 3.0 | newtonimpbb.gif |
| `newtonimpcc.jl` | yes | 3.3 | newtonimpcc.gif |
| `newtonimpdd.jl` | yes | 2.9 | newtonimpdd.gif |
| `newtonimpee.jl` | yes | 2.9 | newtonimpee.gif |

Committed GIFs byte-identical to their regenerated output: **5 of 5**. Decoded frames were also compared; all match.

Inventory findings: none (every script runs, every GIF is produced by a script and embedded by the page, every page reference exists, and the section index links the page).

## Claim ledger

| # | index.qmd line | Claim (page's own words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | 12 | "Each animation below shows the **tangent-line diagram** … on functions with multiple roots" | Cases 2/4 lines have slope f'/m; Case 5 root is simple | wrong (→ F4) |
| 2 | 13 | "the line connecting $(x_n, f(x_n))$ to the next iterate's x-intercept traces the convergence path" | aa:47, bb:51, cc:46, dd:49, ee:47 draw exactly this, plus a vertical drop | confirmed |
| 3 | 14 | "Standard Newton-Raphson degrades to linear convergence at multiple roots" | mpmath e/e_prev → 0.500013 (m=2), 0.666801 (m=3) | confirmed |
| 4 | 14 | "Method A (accelerated) restores quadratic convergence by multiplying the Newton step by the root's multiplicity $m$" | bb/dd:29; mpmath e/e² → 1/6, 1/9; order 2.02, 2.01 | confirmed (exact arithmetic; displayed Float64 tail is off, F1/F3) |
| 5 | 16 | "Julia source scripts … are linked under each case" | lines 24, 34, 44, 54, 68 | confirmed |
| 6 | 18 | Case 1: Standard Newton, double root, $f(x)=x^3-3x+2$, $x_0=1.3$ | aa:11, 15, 27 | confirmed |
| 7 | 20 | "$(x-1)^2(x+2)$ has a double root at $x^*=1$" | sympy factor/roots: {1:2, −2:1} | confirmed |
| 8 | 21 | "$f'(x^*) = 0$ at a multiple root" | f'(1) = 3−3 = 0 | confirmed |
| 9 | 22 | "Each step only halves the error rather than squaring it" | error ratios 0.522, 0.512, 0.506, 0.503, … 0.50005 | confirmed |
| 10 | 22 | "creeps slowly toward $x = 1$ over many steps" | x₁₀ = 1.000321 after 10 steps (script = mpmath to 1e-13) | confirmed |
| 11 | 24, 26 | link/embed newtonimpaa.jl/.gif is Case 1 | manifest: aa.jl produces aa.gif, byte-identical; title and params match | confirmed |
| 12 | 26 | alt: "slow linear convergence from x₀=1.3 toward the double root at x=1" | as rows 9–10 | confirmed |
| 13 | 28 | Case 2: Method A, $m=2$, quadratic, same f, $x_0=1.3$ | bb:12, 16, 18, 29 | confirmed |
| 14 | 30 | "$x_{n+1} = x_n - m \cdot f(x_n)/f'(x_n)$ with $m = 2$" | bb:29 identical | confirmed |
| 15 | 31 | "enlarged step compensates for the vanishing derivative … restoring quadratic convergence" | e/e² → 0.166667 at 400 digits | confirmed (frame x₄ label is a roundoff artefact, F3) |
| 16 | 32 | "same function, same starting point, completely different speed" | x₂ = 1.000028 (A) vs 1.080154 (Newton) | confirmed |
| 17 | 34, 36 | link/embed newtonimpbb.jl/.gif is Case 2 | manifest; title "Method A (m=2)" | confirmed |
| 18 | 36 | alt: "quadratic convergence from x₀=1.3 to the double root at x=1 in just a few steps" | x₁ = 1.013043, x₂ = 1.000028, x₃ = 1.0 | confirmed |
| 19 | 38 | Case 3: Standard Newton, triple root, $f=x^4-x^3-3x^2+5x-2$, $x_0=1.3$ | cc:11, 15, 27 | confirmed |
| 20 | 40 | "$(x-1)^3(x+2)$ has a triple root at $x^*=1$" | sympy: {1:3, −2:1} | confirmed |
| 21 | 41 | "asymptotic error constant for standard Newton at an order-$m$ root is $(m-1)/m$" | ratios → 0.50001 (m=2), 0.66680 (m=3), still decreasing toward 2/3 | confirmed |
| 22 | 42 | "For a triple root this is $2/3$ … reduces the error by $1/3$ — even slower than the double-root case" | ratios 0.676 … 0.6668 vs 0.5 | confirmed |
| 23 | 44, 46 | link/embed newtonimpcc is Case 3; alt "very slow linear convergence from x₀=1.3" | manifest; x₁₂ = 1.002423 after 12 steps | confirmed |
| 24 | 48 | Case 4: Method A, $m=3$, quadratic, same f as Case 3, $x_0=1.3$ | dd:12, 16, 18, 29 | confirmed for the method; the animated sequence is not quadratic after x₂ (→ F1) |
| 25 | 50 | "Method A with $m = 3$ … restores quadratic convergence at the triple root" | e/e² → 0.111111 (mpmath) | confirmed (exact); the frames contradict it (F1) |
| 26 | 51 | "reaches $x \approx 1$ in just a couple of steps" | x₂ = 1.000009 | confirmed |
| 27 | 52 | "knowing $m$ unlocks quadratic convergence regardless of root order" | checked m = 2, 3: C = 1/6, 1/9 | confirmed |
| 28 | 54, 56 | link/embed newtonimpdd is Case 4; alt "quadratic convergence from x₀=1.3 to the triple root" | manifest; frames show x₄ = 1.000719 | wiring confirmed; alt contradicted by frame 5 (→ F1) |
| 29 | 60 | Case 5: Standard Newton diverges, $f=\arctan x$, $x_0=1.4$ | ee:11, 15, 27 | confirmed |
| 30 | 62 | "simple root at $x^* = 0$" | atan(0) = 0, f'(0) = 1 | confirmed |
| 31 | 63 | "converges only when $\|x_0\| < x_c \approx 1.3917$" | x_c = 1.39174520027073 (root of 2x = (1+x²)atan x); scan: 1.39174 converges, 1.39175 diverges | confirmed |
| 32 | 63 | "$x_0 = 1.4$ — just outside that radius" | 1.4 > 1.39175 | confirmed |
| 33 | 63 | "each tangent line overshoots further than the previous iterate, and the iterates escape toward $\pm\infty$" | \|xₙ\| = 1.4, 1.4136, 1.4501, 1.5506, 1.8471, 2.8936, 8.7103 with alternating signs (script = mpmath) | confirmed |
| 34 | 64 | "Methods A, B, and C **do not fix this case**" | A: m=1 is Newton, m≥2 worse (confirmed); B (modified Newton) converges 0.632 → 0.171 → 6e-3 → 3e-7 | wrong (→ F2) |
| 35 | 64 | "they are designed to restore quadratic convergence at multiple roots" | true of A and B by construction | confirmed |
| 36 | 65 | "Method C searches for m … such that $\|x_{n,m}-p\| < \|x_{n,m-1}-p\|$" | not defined elsewhere; uses unknown p | could not determine (no definition of Method C available) (→ F5) |
| 37 | 65 | "the $m=1$ step already overshoots to $x_1 \approx -1.41$" | −1.413619 | confirmed |
| 38 | 65 | "larger $m$ moves further away" | m=2: −4.227237, m=3: −7.040856 | confirmed |
| 39 | 65 | "the search never succeeds" | under the rule as written: \|x_{1,1}\| = 1.4136 > 1.4 and m=2 is worse | confirmed for the stated rule; could not determine for the source's actual Method C |
| 40 | 66 | "even the improved methods have limits: they address multiplicity, not general global-convergence failures" | true of A; B happens to converge here | partly wrong (→ F2) |
| 41 | 68, 70 | link/embed newtonimpee is Case 5; alt "divergent oscillation from x₀=1.4, just outside the critical convergence radius" | manifest; signs alternate and \|x\| grows | confirmed |

## Implementation checks

Common to all: f and f' were checked against sympy (`diff`). For newtonimpdd.jl, f' = 4x³−3x²−6x+5 = (x−1)²(4x+5). The manifest shows each committed GIF is byte-identical to its script's output. The instrumented copies `reviewer/instr_XX.jl` are the scripts minus plotting, plus a full-precision print. The independent computation is `reviewer/indep.py` (sympy + mpmath at 400 digits, no script code reused).

### newtonimpaa.jl
- Method: plain Newton-Raphson, `xs[i] - f/fp` (line 27). This is the baseline the page names "Standard Newton".
- Numbers: script / mpmath. x₁ 1.1565217391304348 / 1.1565217391304348; x₅ 1.0102496959724938 / 1.0102496959724945; x₁₀ 1.0003213616712867 / 1.0003213616712000. They agree to about 1e-13. Error ratios 0.5217 → 0.50005 give a linear rate of 1/2.
- Reference values: the root x = 1 (double) is confirmed by sympy factorisation.
- Picture: I looked at contact sheet frames 1–11 and full frame 11. Blue segments run from (xₙ, f(xₙ)) to (xₙ₊₁, 0) and are true tangents, because the slope f/(xₙ−xₙ₊₁) equals f'. The vertical drops are correct. Every label matches the printed value rounded to 6 digits. Title, function and axes are fine.

### newtonimpbb.jl
- Method: Method A, `xs[i] - m*f/fp` with m = 2 (line 29). This matches the page formula (line 30).
- Numbers: script / mpmath. x₁ 1.0130434782608695 / 1.0130434782608696; x₂ 1.0000281716593045 / 1.0000281716593107; x₃ 1.0000000001306446 / 1+1.3227e-10; **x₄ 0.9999994335946778 / 1+2.92e-21**; x₅ 0.9999999999391621 / 1+1.4e-42. The steps up to x₂ are correct. x₄ is a roundoff artefact (F3). In exact arithmetic e/e² = 0.1449, 0.1656, 0.166664, 0.166667, which matches the derived constant 1/6, so the order is 2.
- Reference values: the root is 1.
- Picture: I looked at frame 5 at full size and the sheet. The orange segment has slope f'/2 and is not a tangent (F4, Minor). The labels match the computed values, but the computed x₄ is wrong at the 6th decimal (F3).

### newtonimpcc.jl
- Method: plain Newton (line 27).
- Numbers: script / mpmath. x₁ 1.2029411764705882 / 1.2029411764705882; x₆ 1.0274800683263425 / 1.0274800683263394; x₁₂ 1.0024225476442639 / 1.0024225476413147. The 3e-12 difference at x₁₂ comes from cancellation in f and is far below the 6-digit label. Error ratios 0.6765 → 0.6668 give a linear rate approaching 2/3.
- Reference values: the triple root at 1 is confirmed by sympy.
- Picture: I looked at the sheet and full frame 13. The tangents are correct and the labels match. The title is cut off at the right edge (F6).

### newtonimpdd.jl
- Method: Method A, m = 3 (line 29). This matches the page.
- Numbers: script / mpmath. x₁ 1.0088235294117645 / 1.0088235294117647; x₂ 1.0000086167285056 / 1.0000086167279412; **x₃ 1.000000641886474 / 1+8.25e-12; x₄ 1.0007193769128275 / 1+7.56e-24**; x₅ 1.000000057738013 / 1+6.4e-48. The values are wrong from x₃ onward because of cancellation in the expanded quartic (F1). In exact arithmetic e/e² = 0.0980, 0.1107, 0.111111, which matches the derived 1/9, so the order is 2.
- Reference values: the root is 1.
- Picture: I looked at the full sheet and full frame 5. Labels x₃ = 1.000001 and x₄ = 1.000719 are shown (F1). The orange segment slope is f'/3 (F4). The title is cut off (F6).

### newtonimpee.jl
- Method: plain Newton on arctan (line 27). f' = 1/(1+x²) is correct.
- Numbers: script / mpmath. −1.4136186488037423 / −1.4136186488037424; 1.4501293146283372 / 1.450129314628338; −1.5506259756377534 / −1.5506259756377557; 1.84705408415019 / 1.8470540841501973; −2.8935623931424104 / −2.8935623931424393; 8.710325846983183 / 8.710325846983391. They agree to about 1e-13 relative, and the sequence diverges with alternating signs.
- Reference values: the root is 0. The critical radius x_c = 1.3917452002707349 is the root of N(x) = −x, i.e. 2x = (1+x²)·arctan x. A scan confirms convergence at 1.39174 and divergence at 1.39175.
- Picture: I looked at full frame 7. There is no clamping. Segments whose endpoint falls outside [−4, 5] are omitted (only x₅ → x₆), and the legend gives the true value "x₍6₎ = 8.71 (out of range)". This is honest and not misleading. The tangents from x₀ to x₅ are drawn correctly, and the title matches f and x₀.

## Evidence

The reviewer's and checker's computation scripts are copied to [`evidence/improved-newton-method/`](evidence/improved-newton-method/) (`reviewer/` and `verify/`). They were run from a scratch directory; paths inside them point at that scratch area and will need adjusting to re-run.
