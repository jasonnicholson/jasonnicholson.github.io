# Fix record: mullers-method

Scratch evidence: `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r4fix/mullers-method/fix/` (call it `$S`). Scripts there: `aa_chk.jl` (instrumented copy of the original `mullersaa.jl`), `vertex_exact.py` (independent Python transcription of the vertex rule, plus exact-rational and mpmath vertex heights), `mathews_check.py` (independent transcription of Mathews' subroutine), `stack.py` (stacks archive output images). Frames: `$S/new2/`.

## Findings

### F1 — Minor — fixed (R4-A, with one deviation and one frame cut; see Notes)
- **Reproduced.** I ran `julia aa_chk.jl` in `$S`, an instrumented copy of the committed script. It gives the vertex heights h = 0.800, 0.181, 3.19e-2, 2.16e-3, 7.81e-5, 8.94e-7, 1.79e-9, 5.43e-13, 2.08e-16 for frames 1–9, and disc < 0 in all 9 frames. Under the committed fixed window (15 units tall, about 410 px), the vertex is under 1 px above the axis from frame 3 on. The review's table is confirmed.
  - **Independent check.** `/usr/bin/python3 -I vertex_exact.py` computes h with exact rational arithmetic through the same Float64 nodes and values, and with mpmath using exact f. Results: 7.9998e-1, 1.8139e-1, 3.1872e-2, 2.1573e-3, 7.8117e-5, 8.9418e-7, 1.7903e-9, 5.4319e-13 (exact f gives 5.4343e-13). With `x*x*x` (Julia's literal `x^3`), the iterates match Julia bit for bit.
  - **Two further facts from the same runs.**
    - **The decision's literal window would not work.** h / max|f(q)| = 0.13, 3.7e-2, 8.0e-3, 8.0e-3, 9.9e-4, 9.6e-5, 6.0e-6, 6.4e-8 by frame. A y-range scaled to max|f(q)| therefore cannot show the gap after frame 2. The cause is that the vertex height is about (e₀e₁)²/12, while f(q₀) is about 3e₀².
    - **Frame 9 is rounding-dominated.** Through the Float64 f values its parabola has h = 2.08e-16, but with exact f at the same nodes h = 1.01e-17. Python's `x**3` (a different rounding of f) even makes it negative (−2.4e-16). Its vertex step gives p₁₁ − 1 = 7.9e-11 (Float64) and 5.5e-11 (exact f). For frame 8, the Float64 and exact-f heights agree to 0.05% (5.4319e-13 vs 5.4343e-13).
- **Change:** `mullersaa.jl`.
  - `n_iters` 8 → 7, giving 8 frames, so the rounding-dominated 9th frame is not drawn.
  - The fixed `xlims`/`ylims` are removed. Each frame now sets x in [min(q ∪ {vertex}) − δ, max(q ∪ {vertex}) + δ] with δ = 0.08·width, and y = (−0.08Y, 1.12Y) with Y = max|f(q)|, as R4-A says. The vertex is included because in frame 1 it lies outside the triple's x-range (1.287 vs [2.0, 2.2]).
  - An inset is added at top left. It magnifies the vertex: x = vertex ± 1.4√(2h/a) and y = (−0.8h, 3h). It shows the axis line, f, the dashed parabola and the vertex marker, and its title reads "near vertex: height %.2e".
  - The legend moves topleft → bottomright, which is empty below the convex curves. The p₂ label changes from `round(q2; digits=5)` to `@sprintf("%.10g")`, so the last frame no longer shows "1.0" on an axis 2e-3 wide.
  - The parabola clamp is removed; the axis limits clip it.
  - The header comment explains the zoom and the 7-step stop. `using Printf` is added from the standard library.
  - `index.qmd` Case 1 gets one sentence on the zoom and inset, and the alt text gets a matching clause.
- **Check.** I regenerated the GIF and extracted its frames with `giftools.jl` into `$S/new2`: 8 frames. I viewed the contact sheet and frames 1, 4 and 8 at full size.
  - In every frame the inset shows the parabola's minimum (the open red circle) clearly above the black axis line. The vertex sits at about 47% of the inset height and the axis at about 21%.
  - The inset titles read 8.00e-01, 1.81e-01, 3.19e-02, 2.16e-03, 7.81e-05, 8.94e-07, 1.79e-09, 5.43e-13, matching the exact-rational values above to 3 significant figures.
  - In every inset f touches the axis at x = 1, as a double root should.
  - In the main panel all three points are in view in every frame, and the legend does not overlap the curves.
  - From frame 5 on, the vertex marker in the main panel coincides with the red p₂ dot. The inset is what shows it there.

### F2 — Minor — fixed (R4-B)
- **Reproduced.** I read Mathews' subroutine myself: archive `MullersMethodMod_gr_5.gif`, extracted to `$S/archive/gr5.png`.
  - It uses `If[b b > 4 a c, disc = Sqrt[b b - 4 a c], disc = 0]; If[b < 0, disc = -disc]; Z = -2c/(b + disc); p3 = p2 + Z`, where c = f(p₂) and b is the linear coefficient of c + b(x−p₂) + a(x−p₂)², that is P′(p₂).
  - So in the complex case the step is p₃ = p₂ − 2f(p₂)/b.
  - Its two swap statements drop whichever of p₀, p₁, p₂ is farthest from p₃. I traced both branches.
  - His printed Example 1 column is in archive gr_40–gr_49, stacked into `$S/archive/ex1_muller.png`: 1.1091314031180390, 1.4944130474051970, 1.0557604296857690, 0.9964676201032940, 0.9981213458431420, 1.0000166310225440, 0.9999987979593480, 1.0000000056524160.
  - `/usr/bin/python3 -I mathews_check.py` is my own transcription. In Float64 it gives 1.1091314031180384, 1.4944130474051827, 1.0557604296857677, 0.9964676201032902, 0.9981213458431428, 1.0000166310225753, 0.9999987979688656, 1.0000000056368235, and mpmath (60 digits) agrees to the digits quoted on the page.
  - `p2 - 2c/b` equals p₃ at every disc = 0 step, e.g. b = 8.98 at step 1, giving 2 − 8/8.98 = 1.10913.
  - One step of his run (p₇) takes the real-root branch. The rest take disc = 0.
  - With the page's drop-oldest rule instead of his farthest-point rule, the first four iterates are identical. Later ones differ slightly (0.99725, 1.0000089, 0.9999980, 1.000000005) but have the same sign pattern.
- **Change:** `index.qmd` Case 1 Behavior gets one sentence: "Mathews' own program [@mathewsSite] handles the complex case differently: it drops the square root, so the step is $p_3 = p_2 - 2f(p_2)/b$, where $b$ is the parabola's slope at $p_2$, and its iterates $1.1091, 1.4944, 1.0558, 0.9965, \ldots$ rise to 1.4944, drop below 1, and then approach 1 from both sides." The page's own rule and animation are kept, as R4-B says.
- **Check.** See the ledger. The errors p − 1 for p₃..p₁₀ are +0.109, +0.494, +0.0558, −0.00353, −0.00188, +1.66e-5, −1.20e-6, +5.65e-9. The run rises at p₄, is first below 1 at p₆, and from p₆ on has both signs with |error| strictly decreasing.

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd Case 1 | "Each frame is zoomed to the current points" | script: xlims from min/max of (q0,q1,q2,q3) ± 8%; frames 1–8 viewed, all 3 points + vertex in window | yes |
| index.qmd Case 1 | "the inset magnifies the vertex" | inset subplot 2, x = v ± 1.4√(2h/a), y = (−0.8h, 3h); frames viewed | yes |
| index.qmd Case 1 | "height above the axis falls from 0.80" | vertex_exact.py frame 1: h = 7.9998e-01; GIF title 8.00e-01 | yes |
| index.qmd Case 1 | "to 5.4 × 10⁻¹³" | vertex_exact.py frame 8: 5.4319e-13 (exact f: 5.4343e-13); GIF title 5.43e-13 | yes |
| index.qmd Case 1 | "over the eight frames" (and "falls": h decreases every frame) | giftools → "8 frames"; h sequence strictly decreasing (0.800 … 5.43e-13) | yes |
| index.qmd Case 1 (unchanged, re-checked against the 8-frame GIF) | "None of the parabolas reaches the x-axis … at every step its roots are complex"; "iterates … decrease to p = 1" | aa_chk.jl: disc < 0 frames 1–8; exact-f h > 0 frames 1–8 (vertex_exact.py); p₃..p₁₀ strictly decreasing (review C1-i; same floats) | yes |
| index.qmd Case 1 | "Mathews' own program … drops the square root" | gr_5.gif: `If[b b > 4 a c, disc = Sqrt[…], disc = 0]` | yes |
| index.qmd Case 1 | "$p_3 = p_2 - 2f(p_2)/b$" | gr_5.gif: Z = −2c/(b+disc), c = Y2 = f(p2), disc = 0; mathews_check.py: p2 − 2c/b = p3 at every disc = 0 step | yes |
| index.qmd Case 1 | "$b$ is the parabola's slope at $p_2$" | from Mathews' a, b formulas: b is the linear coefficient of c + b(x−p₂) + a(x−p₂)², so P′(p₂); step 1: b = 8.98 = δ₁ + h₁d = 9.61 − 0.63 | yes |
| index.qmd Case 1 | "1.1091, 1.4944, 1.0558, 0.9965" | Mathews' printed column (ex1_muller.png); mathews_check.py Float64 1.1091314…, 1.4944130…, 1.0557604…, 0.9964676… | yes |
| index.qmd Case 1 | "rise to 1.4944, drop below 1, and then approach 1 from both sides" | errors p₃..p₁₀: +0.109, +0.494, +0.0558, −3.5e-3, −1.9e-3, +1.7e-5, −1.2e-6, +5.7e-9 (printed and recomputed) | yes |
| index.qmd Case 1 alt text | "each frame is zoomed to the current points, and an inset magnifies the vertex just above the x-axis" | as above; inset vertex at y = h > 0 above axis line in all 8 frames | yes |
| mullersaa.gif inset title | "near vertex: height %.2e" values 8.00e-01 … 5.43e-13 | vertex_exact.py exact-rational h per frame, agree to 3 s.f. | yes |
| mullersaa.gif legend | "p₂ = %.10g": 2, 1.287301587, 1.158087802, 1.055204193, 1.009999195, 1.001684591, 1.000107901, 1.000003006 | `julia -e 'include("aa_chk.jl"); …'` history reprs (2.0, 1.2873015873016, …, 1.0000030057271563) | yes |
| mullersaa.jl header | "vertex height shrinks from 0.8 to about 5e-13"; "The run stops after 7 steps (8 frames): an 8th step, in a 9th frame, would have a vertex height (about 1e-17) below the rounding error of f" (corrected after checker: earlier wording said "8th frame"; frame 8 exists with h = 5.4e-13) | frame-9 parabola: exact-f h = 1.01e-17, Float64-f h = 2.08e-16 (Julia rounding) or −2.4e-16 (`x**3` rounding); Float64 f(q2) = 3.109e-15 vs exact 2.915e-15 (error 1.9e-16) | yes |

## Scripts and GIFs
- Script changed: `mullersaa.jl`. Regenerated `mullersaa.gif` (8 frames, previously 9). `mullersbb.jl` and `mullerscc.jl` and their GIFs are untouched.
- Frames viewed: the contact sheet (all 8), and frames 1, 4 and 8 at full size. Checks:
  - the vertex marker is above the axis in the inset;
  - the inset titles match the computed h;
  - the p₂ labels match the iterates;
  - the three points are in the main window;
  - there is no legend or inset overlap with the curves. In frame 1, before the inset was moved down, the inset title touched the top frame. Moving the bbox from 0.05 to 0.10 fixed it.
- `git status --short -- pages/numerical-methods/mullers-method` gives: `M index.qmd`, `M mullersaa.gif`, `M mullersaa.jl`.

## Legacy archive
- **Consulted.** `n2003/MullersMethodMod.html` was read as text. `mullersmethod/MullersMethodMod/Images/` holds the subroutine (gr_5) and the Example 1 Muller output (gr_34–gr_52).
- **Example 1** is Muller[2.2, 2.1, 2.0, 10] on f = 2 − 3x + x³. This is the same function and triple as Case 1.
- **Mathews' complex-case rule** is disc = 0, i.e. p₃ = p₂ − 2f(p₂)/b. He also keeps the two points nearest p₃. His iterates oscillate around 1.
- **The page keeps its own vertex (real-part) rule** per R4-B. The new sentence tells the reader about the difference. I did not mention the point-retention difference on the page, because R4-B asks for one sentence on the complex case. Neither the quoted iterates nor the quoted pattern depend on it: the first four iterates are identical under both retention rules, and the sign pattern is the same.

## Notes
- **R4-A was followed for the main panel but not on its own.** The literal window it describes (x around the triple, y scaled to max|f(q)|) cannot meet R4-A's stated goal. The vertex sits at h/max|f(q)| = 0.8% of the height in frame 3 and 6e-8 in frame 8, since h ≈ (e₀e₁)²/12 while f(q₀) ≈ 3e₀². I kept that main panel and added the zoomed inset the review offered as its alternative, which is the smallest addition that makes the gap visible in every frame. Jason may prefer another presentation, for example a log-scale y-axis or a main window centred on p₂ and the vertex.
- **The frame cut (9 → 8 frames) was not asked for.** Zooming exposes frame 9 as a rounding artifact: its h is below the rounding error of f, and its sign depends on how x³ is rounded. The review itself suggested cutting frames to the ones where the geometry is visible. The page text states no frame count apart from the new "eight frames", and the iterates it quotes (p₃..p₇) are unaffected.
- **Pre-existing convention gap, not touched:** the page has no `## Description` section.
- **Outside this page:** the repo has unrelated modifications from other fixers (brents-method, halleys-method, pade-approximation, runge-kutta-method, gauss-legendre-quadrature). I did not touch them.

### Director note

The checker found an off-by-one in a script comment (frame count); sent back to the fixer, who corrected the comment only. The director confirmed the comment diff and that the GIF reproduces byte for byte.

## Resolution check (independent checker, not shown this record)

Scripts used: `check/chk.py` (page rule in double and 60-digit mpmath, vertex heights, discriminants, Mathews' subroutine transcribed literally from `MullersMethodMod_gr_5.gif`), `check/order.py` (400-digit order estimate). Frames are in `check/frames/`. The regenerated GIF is in `check/run/`.

### Original findings

### F1: resolved
- Evidence: each frame is now zoomed per R4-A, with x in [min(q, q3) − δ, max(q, q3) + δ], δ = 8% of the span, and y in [−0.08Y, 1.12Y], where Y = max|f(q)|. A top-left inset is zoomed to the vertex, with x in q3 ± 1.4·sqrt(2h/a) and y in [−0.8h, 3h]. I viewed frames 1, 4 and 8 at full size plus the contact sheet of all 8.
  - In every frame the inset clearly shows the dashed parabola strictly above the axis, the open red vertex marker at its minimum, and f (magenta) touching the axis at x = 1.
  - Frames 1–3: the minimum of f sits visibly left of the vertex. Frame 8: it sits almost under the vertex, offset 3.1e-8 against a half-width of 8.4e-7.
- Independent check (mpmath, 60 digits): the discriminant is negative and the vertex height h > 0 in all 8 frames: 0.79998, 0.18139, 0.031872, 0.0021573, 7.812e-5, 8.942e-7, 1.790e-9 and 5.434e-13. The inset titles read 8.00e-01, 1.81e-01, 3.19e-02, 2.16e-03, 7.81e-05, 8.94e-07, 1.79e-09 and 5.43e-13, all correct.
- In the main panel the vertex still merges with the axis from about frame 4 on, and it is under the red p₂ dot in frames 7–8. That is expected at this scale, and the inset carries the claim.
- Cutting from 9 frames to 8 is justified. In exact arithmetic the 9th frame's vertex height is 1.0e-17. In double precision the evaluation error of x³ − 3x + 2 near x = 1 is about 2–4e-16, which is larger. My double-precision run of the same rule gives disc = +2.9e-15 and h = −2.4e-16 on that step, so the sign is noise. A 9th frame would have contradicted "no real root", and the inset's ylims (−0.8h, 3h) would have inverted.

### F2: resolved
- Evidence: I transcribed Mathews' subroutine literally (disc = 0 when b² ≤ 4ac, Z = −2c/(b + disc), nearest-point swaps).
  - From (2.2, 2.1, 2.0) it gives 1.1091314031180384, 1.4944130474051827, 1.0557604296857677, 0.9964676201032902, 0.99812134584314, 1.00001663102, 0.99999879797, 1.0000000056. This matches his printed column to about 1e-10 or better. The later digits differ only by roundoff near the double root.
  - The four quoted iterates all come from the disc = 0 branch (the 5th uses the real square root).
  - The four quoted values are identical if the oldest point is dropped instead of keeping the nearest ones. So attributing the difference to the complex-case rule is accurate for what the sentence quotes.
  - In Mathews' parametrization, P(x) = a(x − p₂)² + b(x − p₂) + c with c = f(p₂), so b = P′(p₂) ("slope at p₂"). Setting disc = 0 gives p₃ = p₂ − 2f(p₂)/b. Check: 2 − 8/b = 1.10913 gives b = 8.979, close to f′(2) = 9.
  - "Rise to 1.4944, drop below 1 (0.9965, 0.9981), then approach 1 from both sides (1.0000166, 0.9999988, 1.0000000057)" is correct.
  - The page keeps its own rule and does not animate Mathews' rule, as R4-B requires.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd Case 1 | "Each frame is zoomed to the current points" | Script: per-frame xlims and ylims from the triple and q3; frames viewed | True |
| index.qmd Case 1 | "the inset magnifies the vertex" | Frames 1–8 inset viewed | True |
| index.qmd Case 1 | "height above the axis falls from 0.80 to 5.4 × 10⁻¹³" | mpmath h₁ = 0.79998, h₈ = 5.434e-13; double gives 0.79998 and 5.4341e-13 | True |
| index.qmd Case 1 | "over the eight frames" | giftools: 8 frames | True |
| index.qmd Case 1 | "it drops the square root, so the step is p₃ = p₂ − 2f(p₂)/b" | Mathews' code: disc = 0 gives Z = −2c/(b + 0) | True |
| index.qmd Case 1 | "b is the parabola's slope at p₂" | b is the linear coefficient of P in powers of (x − p₂), so P′(p₂) = b | True |
| index.qmd Case 1 | "1.1091, 1.4944, 1.0558, 0.9965" | Literal transcription: 1.10913, 1.49441, 1.05576, 0.99647 | True |
| index.qmd Case 1 | "rise to 1.4944, drop below 1, and then approach 1 from both sides" | The sequence above | True |
| index.qmd alt text | "each frame is zoomed to the current points, and an inset magnifies the vertex just above the x-axis" | Frames | True |
| mullersaa.jl header | "vertex height shrinks from 0.8 to about 5e-13" | As above | True |
| mullersaa.jl header | "The run stops after 7 steps: in an 8th frame the vertex height (about 1e-17) would be below the rounding error" | 1e-17 is the vertex height of a **9th** frame (the triple after 8 steps). Frame 8 already exists (h = 5.4e-13). | Off by one (comment only), see below |
| GIF legend | p₂ = 2, 1.287301587, 1.158087802, 1.055204193, 1.009999195, 1.001684591, 1.000107901, 1.000003006 | mpmath iterates 1.2873015873, 1.1580878020, 1.0552041928, 1.0099991954, 1.0016845915, 1.0001079007, 1.0000030057, each to 10 significant digits | True values |
| GIF inset titles | 8.00e-01 … 5.43e-13 (8 values) | mpmath, listed under F1 | True |
| GIF legend | "parabola (no real root)" in all frames | disc < 0 in all 8 frames, in both double and exact arithmetic | True |
| Unchanged context | "order ≈ 1.32 asymptotically" | 400-digit run: 1.3251, 1.3260, 1.3233, 1.3256 | Still true |

### New problems
- **Minor.** `mullersaa.jl` header comment, lines 11–12: "in an 8th frame the vertex height (about 1e-17) …". The GIF already has 8 frames, and the 8th has height 5.4e-13. The 1e-17 vertex belongs to a 9th frame, after the 8th step. The text should say "a 9th frame" or "an 8th step". The page text and GIF are unaffected, but the script is linked from the page.

Nothing else is new. That rests on these checks:
- all 8 frames viewed, with no overlap of the inset or legend with data;
- every label value verified;
- the inset geometry verified: the parabola is above f to the left of the triple because P − f = −(x − q0)(x − q1)(x − q2) > 0 there.

### Reproducibility and conventions
- Scratch run of `mullersaa.jl` gives sha256 2a7cd90a…970d, byte-identical to the committed GIF (640×500, 8 frames).
- The fix diff touches only `index.qmd`, `mullersaa.jl` and `mullersaa.gif` in the page folder. Other modified paths in the worktree belong to other pages.
- The page still has a source link and an embed for each of its 3 cases, descriptive alt text and no code blocks.
- The page has no `## Description` section before `## Animations`. This was already so at HEAD (count 0), so the fix did not introduce it.

**Final status:** committed
