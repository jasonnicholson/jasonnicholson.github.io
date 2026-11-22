# Aitken's Method & Steffensen's Acceleration — animation review (round 2)

Page: `pages/numerical-methods/aitken-method-and-steffensen-acceleration/`. Reported findings: **0 Error, 0 Misleading, 4 Minor**.

## Findings

### F1. Page match (Description). Minor. Aitken's theorem is stated without the hypothesis it needs
- **Location:** `index.qmd` line 30: "**Theorem (Aitken Acceleration).** If $\{x_k\} \to p$ linearly with $x_k \neq p$ for all $k$, then $\lim (\hat{x}_k - p)/(x_k - p) = 0$". Also line 24: "Given *any* linearly convergent sequence … Aitken's process constructs an accelerated sequence … that converges *faster*".
- **What is there:** the only hypothesis is "converges linearly".
- **What is true:** the theorem needs the *signed* error ratio to have a limit: $\lim (x_{k+1}-p)/(x_k-p) = A$ with $|A|<1$. Mathews' statement of the theorem in the archive includes this explicitly ("If there exists a real number A with |A|<1 such that …"). Burden and Faires instead add the condition $(x_k-p)(x_{k+1}-p)>0$. Under the common definition of linear convergence through $|e_{k+1}|/|e_k|\to\lambda$, the statement as written is false.
- **Evidence:** I built a sequence with $|e_{k+1}/e_k| = 1/2$ exactly (linear, rate 1/2) and signs repeating `+,+,-`, then applied Aitken in 50-digit mpmath. For k = 50..55, $\hat e_k/e_k$ = `-0.28571, 0.0, 2.0, -0.28571, 0.0, 2.0`. The ratio does not tend to 0. The page's own Newton sequences do satisfy the stronger hypothesis (signed ratio → 0.5, computed below), so the animations are not affected.
- **Fix:** state the hypothesis as Mathews does: "If $x_k \to p$, $x_k\neq p$, and $\lim_{k\to\infty}(x_{k+1}-p)/(x_k-p) = A$ with $|A|<1$, then …". Make line 24 consistent with it.

- **Independent check:** not run (Minor finding, unverified)

### F2. Page match (animation intro and Case 3). Minor. After about 10 frames the top "tangent-line" panel is frozen and the Newton marker is hidden
- **Location:** `index.qmd` line 58: "the top panel traces Newton–Raphson's tangent-line geometry (one step per frame) … you can directly compare where Newton is geometrically with how fast each method is converging". Line 80 (Case 3): "Newton's linear crawl is visible in both the tangent-line panel and the gently sloping error curve".
- **What is there:** the Newton steps shrink below one pixel at the panel's scale after a few frames. The blue "Newton x_k" circle (ms=6) is drawn first and is then covered by the red Steffensen diamonds (ms=7, drawn later), which sit on the root. From roughly the middle of each GIF onward, the top panel changes only in the legend text.
- **Evidence:** I computed a pixel diff of the top plot area between consecutive committed frames, with the legend masked out (inline Python on `committed/<gif>/frame_###.png`). The count is the number of changed pixels for each transition from frame k-1 to frame k:
  - aitkenab: `1542, 1142, 750, 1726, 205, 108, 60, 35, 23, 20, 14, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0`. Static from frame 13 to frame 22.
  - aitkencd: `1033, 748, 247, 77, 1285*, 12, 14, 8, 3, 0, …`. Static from frame 10. The starred value is the legend growing when the "stopped" text appears.
  - aitkenef: `716, 649, 258, 69, 65, 51, 7, 3, 0, …`. Static from frame 9.
  - In `aitkenef/frame_006.png`, Newton is at x_5 = 1.729099 and its marker cannot be seen under the diamonds at S_1..S_5. In `aitkenab/frame_023.png`, the legend reads "Newton x_22 = 1.0" (true value 1.0000003115, which `round(·; digits=6)` prints as `1.0`) and the marker is hidden under S_2/S_3.
- **Why it matters (slightly):** in Case 3 the linear crawl is visible in the tangent panel for only about 4 frames. Most of what the page attributes to that panel is shown only by the error plot.
- **Fix:** either soften the text, for example: "the top panel shows the first few Newton tangent steps; the bottom panel shows the long linear tail". Or make the panel show it: add a zoomed inset or rescale the top x-window around p as k grows, draw the Newton marker after the Steffensen diamonds, and print the Newton label with more significant digits (e.g. `@sprintf("%.10f")`).

- **Independent check:** not run (Minor finding, unverified)

### F3. Implementation (display). Minor. Plot titles of Cases 2 and 3 are cut off at the right edge, which hides the root p
- **Location:** `aitkencd.jl` line 87 and `aitkenef.jl` line 87 (top-panel `title=`).
- **What is there:** the titles "… f(x) = (x²−2)sin(x²−2)  (p = √2)" and "… f(x) = x⁶−7x⁴+15x²−9  (p = √3)" are too wide for the 680 px figure. They render as "…(p =" (Case 2) and "…(p = (" (Case 3) in every frame (see `committed/aitkencd/frame_023.png` and `committed/aitkenef/frame_001.png`). The y-labels of the bottom panel are also partly clipped on the left in all three GIFs, though they are still mostly legible.
- **Fix:** shorten the titles (e.g. drop "Newton (blue) vs Steffensen (red): ", since the legend already says this), set `titlefontsize=10`, or add `left_margin`/`right_margin`.

- **Independent check:** not run (Minor finding, unverified)

### F4. Fidelity. Minor. The archive's Aitken Δ² examples (Mathews Examples 1, 3, 5) are dropped, although the script headers say they were merged in
- **Location:** `aitkenab.jl` line 2 "Examples 1 & 2 merged (subplot)", `aitkencd.jl` line 2 "Examples 3 & 4 merged", `aitkenef.jl` line 2 "Examples 5 & 6 merged". Also the page's Animations section, which has three cases.
- **What the archive has:** six examples in three pairs on the same three functions. Examples 1, 3 and 5 apply *Aitken's Δ² process to the already-computed Newton sequence* $\{p_n\}$ to form $\{q_n\}$ and compare errors. Examples 2, 4 and 6 are *Steffensen's* method. The archive text in `AitkenSteffensenMod_lnk_2.html` reads: "Let us apply Aitken's acceleration process to a sequence of iterations generated by Newton's method … The sequence {q_n} is converging to p faster than the sequence {p_n}".
- **What the page has:** each case plots only Newton and Steffensen. The Aitken-accelerated sequence $\hat x_k$ of the Description (line 27) never appears in any animation, even though "Aitken's Method" leads the page title. The page does not say that these examples were dropped.
- **Fix:** add a third series $\hat x_k$ (Aitken applied to `xN`, available for k ≤ n_total−2) to the bottom panel. Alternatively, change the script headers to say that only the Steffensen example of each pair is animated, and add a sentence to the page saying so.

- **Independent check:** not run (Minor finding, unverified)


## Reviewer's notes (not findings)



#### Departures from the archive that are correct (not findings)
- Archive Example 6 says "the multiple root near x = 2" of $x^6-7x^4+15x^2-9$. The double root is $\sqrt3\approx1.732$ (the factored form is $(x^2-1)(x^2-3)^2$, and $f''(\sqrt3)=48\neq0$), and the archive's own image `gr_193` gives p = √3. The page uses √3, which is right.
- Archive Example 2 gives the starting value as `gr_60` = "p₀ = 1", which is the root itself (f'(1)=0, so Newton is undefined there). The page uses x₀ = 2.0, a sensible fix. I could not see the starting values for archive Examples 1, 3 and 5 because those formula images are missing from the archive. Examples 4 and 6 (p₀ = 1 and p₀ = 1.5) match Cases 2 and 3.

---

## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `aitkenab.jl` | 0 | 8.8 | aitkenab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `aitkencd.jl` | 0 | 8.9 | aitkencd.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `aitkenef.jl` | 0 | 8.9 | aitkenef.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `aitkenab.gif` | 23 | byte-identical | aitkenab |
| `aitkencd.gif` | 23 | byte-identical | aitkencd |
| `aitkenef.gif` | 23 | byte-identical | aitkenef |

### Page references

- Scripts linked: `aitkenab.jl`, `aitkencd.jl`, `aitkenef.jl`
- GIFs embedded: 3
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|
| D1 | Newton converges quadratically at simple roots | standard; not animated | confirmed |
| D2 | At an order-m root, $\lim |x_{k+1}-p|/|x_k-p| = (m-1)/m$ | mpmath: e22/e21 = 0.5 for all three m=2 cases | confirmed |
| D3 | m=2: ratio 1/2, each step halves the error | as D2 | confirmed |
| D4 | About 50 iterations to go from error 1 to 1e-16 ($2^{-53}\approx1.1\times10^{-16}$) | 2^-53 = 1.11e-16; log2(1e16) = 53.2 | confirmed |
| D5 | Case 1 and Case 3 expanded polynomials: f evaluates to exactly 0 after 28 and 25 Newton steps | `review/newton_long.jl`: "case1: f(x_28) == 0", "case3: f(x_25) == 0" | confirmed |
| D6 | … at errors 1.5e-9 and 2.6e-10 | 1.5211e-9 and 2.5538e-10 | confirmed |
| D7 | Δ, Δ² definitions and the Aitken formula $\hat x_k = x_k - (\Delta x_k)^2/\Delta^2x_k$ | algebra checked | confirmed |
| D8 | Theorem: linear convergence with x_k≠p ⇒ $(\hat x_k-p)/(x_k-p)\to0$ | counterexample above | wrong as stated (F1) |
| D9 | Aitken accelerates "any linearly convergent sequence" | same issue | wrong as stated (F1) |
| D10 | Steffensen = Aitken applied directly to the Newton iteration; steps 1–3 (q1, q2, p1 formula, restart) | matches code lines 41–47 (ab) / 45–59 (cd, ef) exactly | confirmed |
| D11 | Superlinear convergence even at double roots; roughly quadratic | mpmath $e_{k+1}/e_k^2$ → 0.08333, 0.1768, 0.5774 (bounded and constant, so order 2) | confirmed |
| D12 | Each outer iteration uses two Newton steps; the result is more accurate than either step | code; e.g. Case 1: S1 error 0.0575 vs q1 0.556, q2 0.298 | confirmed |
| D13 | Table: Newton simple quadratic; Newton double linear 1/2; Steffensen double ≈2, two Newton evals per step | D2, D11 | confirmed |
| A1 | Two synchronized panels per case; top = Newton tangent-line geometry, one step per frame | code; frames | confirmed (but see F2 on visibility) |
| A2 | Bottom = $\log_{10}|x_k-p|$ vs iteration for Newton and Steffensen | code lines 101–110; frames | confirmed |
| A3 | Shared frame clock lets you compare where Newton is geometrically with convergence speed | top panel static after frames 9–13; Newton marker occluded | partly true, overstated (F2) |
| A4 | Julia scripts linked under each case | links aitkenab/cd/ef.jl present and correct | confirmed |
| C1.1 | Case 1: f = x³−3x+2, double root p = 1, x₀ = 2.0 | script lines 12–16; f(1)=f'(1)=0, f''=6 | confirmed |
| C1.2 | f = (x−1)²(x+2) | expanded by hand | confirmed |
| C1.3 | Newton converges linearly; ratio 1/2 | float64 and mpmath errors halve; e22/e21=0.5 | confirmed |
| C1.4 | Steffensen errors 1, 5.7e-2, 2.8e-4, 6.6e-9 in 3 steps | script: 1.0, 0.057471, 2.8049e-4, 6.5560e-9; mpmath: 1, 0.05747, 2.805e-4, 6.557e-9 | confirmed |
| C1.5 | Plain Newton 3.1e-7 after 22 steps | script 3.1148e-7; mpmath 3.115e-7 | confirmed |
| C1.6 | At S₃ the expanded polynomial evaluates to exactly 0, so the Δ² denominator is 0 and the sequence stops | instrumented: f(S3)=0.0, q1=q2=S3, denom=0.0; n_done=3, stop "Δ² denominator = 0"; final-frame legend shows this | confirmed |
| C1.7 | Link aitkenab.jl / embed aitkenab.gif is this case | title in frames "f(x) = x³−3x+2 (p = 1)"; GIF byte-identical to scratch regen | confirmed |
| C1.8 | Alt text: Newton steps from x₀=2 toward p=1; Steffensen stops after 3 steps at 6.6e-9 | frames 1, 4, 23 | confirmed |
| C2.1 | Case 2: f = (x²−2)sin(x²−2), double root √2, x₀ = 1.0 | script; f''(√2)=16 (mpmath) | confirmed |
| C2.2 | Newton converges linearly | e22/e21 = 0.5 | confirmed |
| C2.3 | Steffensen is Aitken on two Newton steps, restarted from each accelerated value | code | confirmed |
| C2.4 | Error 6.7e-16 after 4 steps (8 Newton steps) | script 6.6613e-16 (3 ulp of √2; exact-arithmetic value 4.97e-17) | confirmed |
| C2.5 | Plain Newton 4.7e-8 after 22 | script 4.7272e-8; mpmath 4.727e-8 | confirmed |
| C2.6 | Stops at S₄ because |f'(S₄)| < 1e-14 cutoff | instrumented: df(S4) = −8.79e-15; stop_reason "|f'(S_4)| < 1e-14" | confirmed |
| C2.7 | Link/embed aitkencd is this case; alt text (reaches 6.7e-16 after 4 steps) | frames 3, 23 | confirmed |
| C3.1 | Case 3: f = x⁶−7x⁴+15x²−9, double root √3, x₀ = 1.5 | script; f''(√3)=48 | confirmed |
| C3.2 | f = (x²−1)(x²−3)²; √3 ≈ 1.732 | expanded by hand | confirmed |
| C3.3 | Newton's linear crawl visible in the tangent-line panel | visible for about 4 frames only; panel static from frame 9 | overstated (F2) |
| C3.4 | … and in the gently sloping error curve | frames: straight line, slope log10(0.5) | confirmed |
| C3.5 | Steffensen error 2.8e-8 in 3 steps | script 2.7592e-8; mpmath 2.760e-8 | confirmed |
| C3.6 | Near the root f values are of order 1e-14, comparable to evaluation rounding | f(S3) computed 2.13e-14; true value ≈ 24·e² ≈ 1.8e-14; terms of size ~27 have ulp 3.6e-15 | confirmed |
| C3.7 | Steps 4–6 give errors 5.4e-8, 2.1e-8, 1.5e-8 | script 5.442e-8, 2.148e-8, 1.458e-8 | confirmed |
| C3.8 | About where plain Newton is after 22 steps (2.4e-8) | script (float64, as plotted) 2.402e-8. Exact-arithmetic Newton gives 2.237e-8, so the plotted Newton value is itself slightly affected by rounding; the page quotes the plotted value | confirmed |
| C3.9 | In exact arithmetic step 4 would reach 4.4e-16 | mpmath 4.398e-16 | confirmed |
| C3.10 | Link/embed aitkenef is this case; alt text "levels off at a few times 1e-8 after 3 steps" | frames 1, 6, 23 | confirmed |
| C3.11 | (script comment) no guard fires for this case | n_done=6, stop_reason empty; a 7th step would hit denom=0 but n_steff=6 | confirmed |

---

### 3. Implementation checks

All three scripts share one structure: 22 Newton steps, a Steffensen loop (with guards), a cobweb of tangent segments, and a log-error plot. Each script's scratch regen is byte-identical to the committed GIF (I checked md5 myself as well as reading the manifest), so the frames reflect these scripts.

**Method.** The Newton update is $x - f/f'$. The Steffensen update takes q1 and q2 as two Newton steps from S, then $S - (q1-S)^2/(q2-2q1+S)$. That is Aitken's Δ² applied to the Newton map, i.e. Steffensen's fixed-point acceleration with g = Newton map. This is the variant Mathews' archive calls "Steffensen's acceleration" and the one the page's Description sets out (steps 1–3). It is not the derivative-free Steffensen root finder ($x - f^2/(f(x+f)-f)$), and the page does not claim that it is. The derivatives are correct: by hand, (ab) 3x²−3; (cd) 2x(sin u + u cos u) with u = x²−2; (ef) 6x⁵−28x³+30x. The independent computation also uses mpmath's numerical `diff` rather than these formulas, and the iterates agree.

**Numbers.** I instrumented copies (`review/<script>_num.jl`, the script up to the animation block plus prints) and compared them with an independent 120-digit computation (`review/indep.py`: own Newton/Steffensen, derivative via `mp.diff`, roots 1, √2, √3).

| Case | Quantity | Script (Float64) | Independent (mpmath) |
|---|---|---|---|
| 1 | Newton e1, e2, e3, e22 | 0.55556, 0.29791, 0.15539, 3.1148e-7 | 0.5556, 0.2979, 0.1554, 3.115e-7 |
| 1 | Steffensen e1..e3 | 0.057471, 2.8049e-4, 6.5560e-9 | 0.05747, 2.805e-4, 6.557e-9 (e4 = 3.58e-18 in exact arithmetic; Float64 stops) |
| 2 | Newton e1, e2, e3, e22 | 0.10972, 0.051689, 0.025263, 4.7272e-8 | 0.1097, 0.05169, 0.02526, 4.727e-8 |
| 2 | Steffensen e1..e4 | 0.038023, 3.0775e-4, 1.6772e-8, 6.66e-16 | 0.03802, 3.077e-4, 1.677e-8, 4.97e-17 (Float64 floor) |
| 3 | Newton e1, e2, e3, e22 | 0.053479, 0.024879, 0.012062, 2.4023e-8 | 0.05348, 0.02488, 0.01206, 2.237e-8 |
| 3 | Steffensen e1..e6 | 0.019424, 2.1863e-4, 2.7592e-8, 5.44e-8, 2.15e-8, 1.46e-8 | 0.01942, 2.186e-4, 2.760e-8, 4.40e-16, 1.1e-31, 7.2e-63 |

The two columns agree to all printed digits until each Float64 sequence reaches its rounding floor. The floors are explained correctly on the page. The convergence rate is confirmed as a property rather than from memory: Newton's signed error ratio → 0.5 in all three cases, and Steffensen's $e_{k+1}/e_k^2$ settles at a constant (0.0833, 0.1768, 0.5774), which is quadratic order.

**Reference values.** root = 1.0, sqrt(2.0), sqrt(3.0), each the correctly rounded double of the exact root. mpmath confirms f(p)=f'(p)=0 and f''(p) = 6, 16, 48 (≠0), so each is a genuine double root. The clamp at 1e-16 is never engaged, since the smallest plotted error is 6.66e-16. The Newton guards in cd/ef (|f'| < 1e-14) never fire: |f'(x_22)| is about 1e-6 or more.

**Picture.** Each tangent segment goes from (x_i, f(x_i)) to (x_{i+1}, 0), which is the tangent line, because x_{i+1} is its zero. The vertical segments rise from (x_i, 0) to the curve. Frame k shows x_k: in frame_004 of ab, the label "x_3 = 1.15539" matches N3 = 1.1553902. The Steffensen count nS = min(frame, n_done) and the label and annotation index S_nS are correct. The stop reason appears in the legend after the stop. The function in each title matches the code. Axis windows contain all relevant iterates; the curve is clipped outside them, which is harmless. There are 23 frames per GIF (k = 0..22). Display issues are in F2 (frozen, occluded top panel) and F3 (clipped titles).

**Could not determine:** archive starting values for Examples 1, 3 and 5, and any archive solution graphs for Examples 2, 4 and 6; those images are absent from the archive copy.

