# Bisection Method — animation review (round 5)

Page: `pages/numerical-methods/bisection-method/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page and in the frames agreed with my own computation (ledger below). I checked the following items and did not count them as findings:

- *No `## Description` section.* The authoring conventions (`.github/agents/animation-page.agent.md`, lines 12 and 205) require one. 42 of the 54 numerical-methods pages have it and this page does not. That is content the page does not have yet, so under the review standard it is not a finding. The method description that is on the page (Animations intro, lines 12–15) is correct.
- *Clamped values in the Case 2 top panel* (`bisectionbb.jl` lines 59, 93–94, 105, 110–113). Midpoints with |tan c| > 15 are drawn at y = ±15 on the panel border, and the curve runs along the border for a short distance near the asymptote. The legend gives only the x-value (`c_k = …`), and the zoom panel underneath plots f(c) at its true value with symmetric limits (I checked step 4 at −18.4, step 8 at +2.07e3 and step 12 at −2.24e5 against the y-ticks). Nothing labels a clamped value as if it were real, so this display device does not mislead.
- *12 steps where Mathews ran 20 and 18.* The legacy animations run 20 steps (cubic, ending at p₂₀ = 1.36523) and 18 steps (tan, ending at p₁₈ = 1.57080). The page runs 12 steps for both. The page never claims a step count it does not show. The 12th bracket contains both the true root and π/2. This is a choice of animation length, not a fidelity departure that matters to a reader.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `bisectionaa.jl` | 0 | 12.6 | bisectionaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `bisectionbb.jl` | 0 | 10.2 | bisectionbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `bisectionaa.gif` | 13 | byte-identical | bisectionaa |
| `bisectionbb.gif` | 13 | byte-identical | bisectionbb |

### Page references

- Scripts linked: `bisectionaa.jl`, `bisectionbb.jl`
- GIFs embedded: 2
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | Intro l.12 | Each animation shows the bracket-halving diagram for bisection | Both scripts run bisection (l.30–40 / l.33–43); frames show the bracket halving | confirmed |
| 2 | Intro l.13 | The shaded region marks the current bracket [a, b] | `shade_bracket!(p1, a_cur, b_cur, …)`; in the frames the shading lies between the blue dashed lines at [a_k, b_k] | confirmed |
| 3 | Intro l.13 | IVT: continuous f with opposite-sign endpoint values ⇒ root in [a, b] | Standard theorem, stated correctly | confirmed |
| 4 | Intro l.14 | Each frame computes c = (a+b)/2, evaluates f(c), and keeps the half that still contains the sign change | Code `c=(as[i]+bs[i])/2`; keeps `[a,c]` if `f(a)f(c)<0`, otherwise `[c,b]`. Frame 0 shows only the initial bracket, which is implicit in the wording | confirmed |
| 5 | Intro l.15 | Top panel full view; bottom panel zooms on the bracket from before the current step | `a_prev = as[max(frame,1)]`, window = [a_prev, b_prev] ± 10% of width; frames 2, 8 and 13 show the gray "before" lines at the window edges | confirmed |
| 6 | Intro l.15 | The bracket becomes narrower than a pixel in the full view from step 9 on | Measured from frame_001: aa has 139 px per unit (x=−1 at px 143, x=2 at px 560), bb has 196.5 px per unit (x=0 at 155, x=2 at 548). Bracket after step 8: aa 0.01172 = 1.63 px, bb 0.0078125 = 1.53 px. After step 9: aa 0.00586 = 0.81 px, bb 0.00391 = 0.77 px | confirmed |
| 7 | Intro l.17 | Julia sources are linked under each case | `[Julia source](bisectionaa.jl)` and `(bisectionbb.jl)`; both files exist | confirmed |
| 8 | Case 1 heading | Convergent case, f(x) = x³+4x²−10, [a₀,b₀] = [−1,2] | `bisectionaa.jl` l.15–16 | confirmed |
| 9 | Case 1 l.21 | f(−1) = −7 < 0, f(2) = 14 > 0 | indep.py: f1(−1) = −7, f1(2) = 14 | confirmed |
| 10 | Case 1 l.22 | True root x* ≈ 1.3652 | sympy nroots: 1.365230013414097 (the other two roots are complex) | confirmed |
| 11 | Case 1 l.22 | Bracket width halves each step | Widths 1.5, 0.75, …, 0.000732421875 = 3/2^k | confirmed |
| 12 | Case 1 l.22 | \|c_k − x*\| ≤ (b₀−a₀)/2^k and the bound shrinks monotonically (c_1 = midpoint of [a₀,b₀]) | indep.py: errors 0.865, 0.115, 0.260, 0.0723, 0.0215, 0.0254, 0.00196, 0.00976, 0.00390, 0.000972, 0.000493, 0.000240 are each ≤ 3/2^k (1.5 … 0.000732) | confirmed |
| 13 | Case 1 l.22 | Midpoints are not monotone and fall on both sides of the root | c = 0.5, 1.25, 1.625, 1.4375, 1.34375, … Relative to x*: below, below, above, above, below, above, above, below, below, below, above, below | confirmed |
| 14 | Case 1 link/embed | Link `bisectionaa.jl`, embed `bisectionaa.gif` belong to Case 1 | Script writes `bisectionaa.gif`; committed GIF is byte-identical to the regeneration (md5 961067b3…); title in the frames is "f(x) = x³ + 4x² − 10" | confirmed |
| 15 | Case 1 alt | Bracket narrows around the root at x≈1.3652 over 12 steps, with a lower panel zoomed on each halving | n_iters = 12, 13 frames; final bracket [1.364990234375, 1.36572265625] contains 1.365230 | confirmed |
| 16 | Case 2 heading | Spurious convergence (cautionary), f(x) = tan x, [a₀,b₀] = [0,2] | `bisectionbb.jl` l.18–19 | confirmed |
| 17 | Case 2 l.30 | f(0) = tan 0 = 0, a genuine root at the left end | tan(0.0) = 0.0 exactly | confirmed |
| 18 | Case 2 l.31 | c₁ = 1; f(0)f(1) = 0 is not negative, so bisection keeps [1,2] and walks away from that root | Instrumented step 1: c=1, next bracket [1, 2]; the test is strict `< 0` | confirmed |
| 19 | Case 2 l.32 | f(1) = tan 1 > 0, f(2) = tan 2 < 0 | mpmath: tan 1 = 1.5574077, tan 2 = −2.1850399 | confirmed |
| 20 | Case 2 l.32 | The sign change comes from the asymptote at π/2 ≈ 1.5708; tan has no zero in [1,2] | Zeros of tan are kπ (0 and 3.14159 lie outside); π/2 = 1.5707963 | confirmed |
| 21 | Case 2 l.33 | Bisection converges to the asymptote | indep.py: every bracket k=1..12 contains π/2; final bracket [1.5703125, 1.57080078125] has width 4.88e-4; c₁₂ = 1.570801, \|c₁₂ − π/2\| = 4.5e-6; \|f(c_k)\| grows to 2.24e5 | confirmed |
| 22 | Case 2 l.33 | The IVT guarantee requires f continuous on [a,b] | Correct | confirmed |
| 23 | Case 2 link/embed | Link `bisectionbb.jl`, embed `bisectionbb.gif` belong to Case 2 | Script writes `bisectionbb.gif`; byte-identical to the regeneration (md5 313f6679…); frame title "f(x) = tan(x) [cautionary case]" | confirmed |
| 24 | Case 2 alt | First step leaves the root at x=0, then converges to the asymptote at π/2, with a zoomed lower panel | Same evidence as 18 and 21; frames 2 and 13 | confirmed |
| 25 | Frames (both) | Legend `c_k = …` values | aa: 0.5, 1.25, 1.625, 1.4375, 1.34375, 1.390625, 1.367188, 1.355469, 1.361328, 1.364258, 1.365723, 1.36499. bb: 1.0, 1.5, 1.75, 1.625, 1.5625, 1.59375, 1.578125, 1.570312, 1.574219, 1.572266, 1.571289, 1.570801. All match indep.py rounded to 6 digits | confirmed |
| 26 | Frames (both) | Zoom titles "step k halves [a,b] of width w" | w = width of the bracket before step k: aa 3.0, 1.5, …, 0.00146484375; bb 2.0, 1.0, …, 0.0009765625. Correct for every k | confirmed |
| 27 | Frames bb | Orange dashed line = "asymptote x = π/2" | `vline!(p1,[π/2])`; at x≈1.5708 in the zoom frames for steps 8, 10 and 12 | confirmed |
| 28 | Page wiring | Page is linked from the section index | `pages/numerical-methods/index.qmd` l.14 | confirmed |
| 29 | Fidelity | Case 1 = Mathews Example 3 (x³+4x²−10, [−1,2]); Case 2 = Mathews Example 4 (Tan[x]=0, [0,2]) | Formula images gr_647/648/813/814; Mathews' Example 4 note says the method "located a pole of tan(x)"; legacy frames show I₁ = [0.5,2] (cubic) and I₁ = [1,2] (tan), the same as the scripts. These are the only two animated examples in the archive | confirmed |

### 3. Implementation checks

Both committed GIFs are byte-identical to fresh scratch runs (my md5 check matches the manifest), and the scratch scripts are identical to the repository scripts. So the frames reviewed are exactly what the current code produces.

### `bisectionaa.jl` (Case 1)

- **Method.** Plain bisection with a fixed count of 12 steps: midpoint, test `f(a)f(c) < 0`, keep the left or right half. No hybrid and no early stop. This is the method the page names.
- **Numbers.** The instrumented copy `review/inst_aa.jl` (the script's own parameter and bisection code plus printing) gave the same sequence as my independent exact-rational bisection in `review/indep.py` (Python `Fraction`, exact sign of the polynomial). Script and independent values of c_k agree exactly (all are dyadic): 0.5, 1.25, 1.625, 1.4375, 1.34375, 1.390625, 1.3671875, 1.35546875, 1.361328125, 1.3642578125, 1.36572265625, 1.364990234375. The brackets agree as well. f(c_k) changes sign in step with the bracket choice, for example f(c₇) = +0.0324 → keep [1.34375, 1.3671875] and f(c₈) = −0.160 → keep [1.35546875, 1.3671875].
- **Reference values.** The header comment and the page give root ≈ 1.3652. sympy nroots gives 1.36523001341. Every bracket contains it. The final midpoint is 2.4e-4 from it, within the bound 7.3e-4.
- **Picture.** Frames 1, 2, 8 and 13 viewed in full, the rest on the contact sheet. The red dot is at (c_k, f(c_k)) on the curve, the diamond at (c_k, 0), the dotted drop line joins them, and the gray dots are earlier midpoints. The blue dashed lines and shading are at [a_k, b_k] after the step. In the zoom panel the gray lines are at the pre-step bracket and the y-limits enclose f over the window and 0. The step-12 zoom places a_prev = 1.36426, c = 1.36499 and b = 1.36572, consistent with the tick labels (pixel scale 268 290 px/unit; tick 1.3650 at about px 354, c₁₂ at about px 351). Titles, the function string and the legend agree with the code. No clamping in this script.

### `bisectionbb.jl` (Case 2)

- **Method.** Identical bisection loop, 12 steps. Its sign test is strict (`< 0`), so f(a)f(c) = 0 sends the method to [c, b]. This is the behaviour the page describes for step 1 and is the convention of Mathews' program (his I₁ = [1, 2]).
- **Numbers.** Instrumented copy `review/inst_bb.jl` against `indep.py` (mpmath tan at 40 digits, exact rational midpoints). c_k agree exactly: 1, 1.5, 1.75, 1.625, 1.5625, 1.59375, 1.578125, 1.5703125, 1.57421875, 1.572265625, 1.5712890625, 1.57080078125. tan(c_k) agree to all printed digits: script 1.557408, 14.10142, −5.520380, −18.43086, 120.5325, −43.55836, −136.4479, 2066.855, −292.1895, −680.5965, −2029.485, −224494.3. mpmath gives 1.5574077, 14.10142, −5.5203799, −18.430863, 120.53251, −43.55836, −136.4479, 2066.8552, −292.18949, −680.59654, −2029.4854, −224494.35.
- **Reference values.** The asymptote is drawn at `π/2` computed by Julia (1.5707963…). Every bracket contains it, checked in indep.py. No exact root is claimed, and none exists in [1,2].
- **Picture.** Frames 1, 2 and the contact sheet (steps 2, 4, 6, 8, 10, 12) viewed. The curve is split at π/2 ± 0.02 in the top panel and ± 0.002·w in the zoom, so no false vertical connector is drawn. The top panel clamps the curve and the midpoint markers to ±15. As noted under Findings, the markers sit on the border, the legend reports only x, and the zoom panel shows the true f(c). The zoom y-range is symmetric, ±1.1·max(|f| at the window ends and at c), so the midpoint is always inside the panel at its true value. I confirmed this in the frames: step 4 at −1.84e1, step 8 at +2.07e3, step 10 at −6.8e2, step 12 at −2.24e5. Titles and legend entries ("asymptote x = π/2", "[a, b] before/after step k") agree with the code.

