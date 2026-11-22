# Fix record: the-tangent-parabola

Scratch folder (all evidence, re-runnable): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r2fix/the-tangent-parabola/fix/`
(`inst.jl` = instrumented copy of the fixed script's computation; `indep.py` = independent mpmath/numpy/sympy check; `arch/` = archive images converted to PNG; `stackA/B/C.png` = archive formula/code images; `frames/` = frames of the regenerated GIF.)

## Findings

### F1 — Minor (Fidelity) — fixed
- Reproduced: the committed script used `f(x)=cos(x)`, `x0=π/4`, window `[x0-1.5, x0+1.5]`, h = 18 log-spaced values 1.0 → 0.01 (no frame at h = 0.1). The archive module `n2003/TangentParabolaMod.html` has the running example y = sin(x), x₀ = 1 (formula images gr_34/gr_35 and gr_39/gr_40 read "y = sin (x)", "x₀ = 1"); Figure 1 is h = 0.1 (gr_36, caption at HTML line 103), Figure 2 is h = 0.01 (gr_41, line 116), Figure 3 is h → 0; graphs gr_33/38/42 are on x ∈ [0, π] with ticks 1, π/2, π. Table 1 (gr_119) tabulates p(x, x₀, h) for h = 1, 0.3, 0.1, 0.03, 0.01, 0.003, 0.001 at x₀ = 1.
- Change (R2-A: function, centre and interval are parameters of an existing case → follow Mathews):
  - `tangparabaa.jl`: f = sin, f′ = cos, f″ = −sin; x0 = 1.0; plot grid and xlims [0, π] (Mathews' window); ylims (−0.5, 1.3) → (−0.2, 1.15); legend :topright → :bottom (clear of the curves in the new window); h sequence length 18 → 17 log-spaced (= 10^(−k/8), k = 0..16) so h = 0.1 and h = 0.01 are frames; legend label "f(x) = sin(x)"; header comments.
  - `index.qmd`: Animations intro, Case 1 heading and alt text changed to sin(x), x₀ = 1; intro notes it is Mathews' running example and that the frames include the Figure 1 / Figure 2 step sizes. Behavior paragraph unchanged (still exactly true, see ledger).
- Check: `julia inst.jl` (script's own computation) and `python3 -I indep.py` (mpmath with Mathews' formula (4), numpy.polyfit, sympy limit):
  - Script coefficients about x₀: h=1 → 0.841471, 0.454649, −0.386822; h=0.1 → 0.841471, 0.539402, −0.420385; h=0.01 → 0.841471, 0.540293, −0.420732. Identical to mpmath and to Mathews' Table 1 rows at the same h.
  - Exact T₂: 0.841471 + 0.540302(x−1) − 0.420735(x−1)² (mpmath sin 1, cos 1, −sin 1/2).
  - max over [0, π] of |P_h − T₂|: 1.195668e−1 (h=1) … 1.250550e−3 (h=0.1) … 1.251111e−5 (h=0.01), identical in both computations, strictly decreasing over all 17 h.
  - Interpolation residual at the 3 nodes ≤ 1.1e−16 in every frame.
  - sympy: `limit(interpolate(sin at 1−h,1,1+h), h→0) − series(sin x, 1, 3)` = 0.

### F2 — Minor (Fidelity) — fixed (one-sentence note, per R2-A)
- Reproduced: the archive module has Examples 1–5 (`grep 'Example'` on the module and its solution pages `Links/TangentParabolaMod_lnk_{2,3,9,10,11}.html`). Examples 1–2 compute the secant-parabola coefficients at h = 0.1 and h = 0.01 (the parabola case the page animates). Example 3 (lnk_9): f(x) = e^{x/4} cos x, x₀ = 0 (gr_207/208), static graphs of Newton cubics for h = 1/4 and 1/16 (gr_209) compared with T₃. Example 4 (lnk_10): same f, x₀ (gr_225/226), animation of Newton cubics, `P[x, 0, 0.7^i]`, i = 1..12, window x ∈ [−4.7, 3.5], y ∈ [−3, 1.2] (code gr_229, frames gr_230–241). Example 5 (lnk_11): same f, x₀ (gr_254/255), degree 6 (code gr_257/258, frames gr_259–270; frame gr_265 viewed). The Mathematica code builds the nodes as x₀ + k·h, k = 0..n (gr_180 for n = 3, gr_247 for n = 6), i.e. equally spaced points starting at x₀. The page has one case (`tangparabaa.jl`/`.gif`) only, and did not mention these.
- Change: `index.qmd`, new source line directly after the Case 1 embed (the page has no legacy note, so it goes right after the last embed, per the pattern): "The module's Examples 3–5, which extend the construction to Newton polynomials of higher degree through equally spaced points starting at $x_0$ and compare them with the Taylor polynomial of the same degree (the tangent cubic in Examples 3 and 4, a higher-degree tangent polynomial in Example 5), are not animated here." No example added (R2-A).
- Check: sympy in `indep.py`: for g = e^{x/4} cos x, `limit(interpolate(g at kh, k=0..n), h→0) − series(g, 0, n+1)` = 0 for n = 3 and n = 6 (T₃ = 1 + x/4 − 15x²/32 − 47x³/384, matching the review's transcription). So "compare them with the Taylor polynomial of the same degree" is mathematically apt. Mathews' own section headings are "The Tangent Cubic Polynomial" and "Tangent Polynomials of Higher Degree". No numbers other than example numbers in the sentence.

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd intro | "$f(x) = \sin(x)$ centered at $x_0 = 1$" | script lines `f(x)=sin(x)`, `x0=1.0`; frames: vline at x = 1, middle node at (1, 0.841) | yes |
| index.qmd intro | "the running example of Mathews' module" | archive gr_34/35, gr_39/40 ("y = sin (x)", "x₀ = 1"); Table 1 gr_119 "where x₀ = 1" | yes |
| index.qmd intro | "the frames include its Figure 1 and Figure 2 step sizes $h = 0.1$ and $h = 0.01$" | archive: gr_36 "h = 0.1" in Figure 1 caption (HTML l.103–104), gr_41 "h = 0.01" in Figure 2 caption (l.116–117); `inst.jl` → frame 9 h = 0.10000000000000002 (label "0.1"), frame 17 h = 0.010000000000000004 (label "0.01"); frames 009/017 viewed, titles "h = 0.1", "h = 0.01" | yes |
| Case 1 heading | "$f(x) = \sin(x)$, $x_0 = 1$" | as above | yes |
| Behavior (unchanged) | "three well-separated points" / "all three nodes collapse to $x_0$" / approaches T₂ | frame 001: nodes at 0, 1, 2; frame 017: nodes overlap at x₀; max\|P−T₂\| strictly decreasing to 1.25e−5; sympy limit = T₂ | yes |
| alt text | "as h shrinks from 1.0 to 0.01, followed by the tangent parabola alone, for sin(x) at x0=1" | `inst.jl` h labels 1.0 … 0.01 (17 values); frames.md5: 17 distinct frames then 5 identical hold frames showing only T₂ (title "Tangent Parabola (T₂ …)", no nodes) — frame 022 viewed | yes |
| index.qmd, after embed | Examples 3–5 sentence (see F2) | archive lnk_9/10/11 text + gr_207–209, 225–229, 247, 254–258; sympy limits for n = 3, 6 = 0 | yes |
| script title/legend | "f(x) = sin(x)"; h labels `round(h,3)`: 1.0, 0.75, 0.562, 0.422, 0.316, 0.237, 0.178, 0.133, 0.1, 0.075, 0.056, 0.042, 0.032, 0.024, 0.018, 0.013, 0.01 | `indep.py` independent h list rounds to the same 17 labels | yes |

## Scripts and GIFs
- Script changed: `tangparabaa.jl`. GIF regenerated: `tangparabaa.gif` (22 frames: 17 secant frames + 5 hold frames; was 23).
- Frames viewed at full size: 001 (h = 1.0: nodes at 0, 1, 2 on sin; red dashed through all three; node at x = 0 is on the left frame edge but fully drawn), 009 (h = 0.1), 017 (h = 0.01: three nodes overlapping at x₀; secant and T₂ coincide), 022 (hold frame, T₂ only). All curves lie inside ylims (T₂ range on [0, π] is [−0.1196, 1.0149]; P range for every h within [−0.1196, 1.0149]); legend at bottom centre does not cover any curve.
- `git status --short -- pages/numerical-methods/the-tangent-parabola` after regeneration: `M index.qmd`, `M tangparabaa.gif`, `M tangparabaa.jl` (only expected files).

## Legacy archive
Consulted: `n2003/TangentParabolaMod.html`, its Links lnk_2, lnk_3, lnk_9, lnk_10, lnk_11 and Images gr_33–42, gr_119, gr_177–209, gr_225–270 (formula/code images upscaled via Plots' ffmpeg). It shows the parabola example as sin x at x₀ = 1 on [0, π] (Figures 1–3, Table 1), and two animation sequences (Examples 4, 5) for e^{x/4} cos x at x₀ = 0 with degree 3 and 6 forward-node Newton polynomials, h = 0.7^i. The fixed page follows the archive's function, centre, window and Figure step sizes; Table 1's numbers at h = 1, 0.1, 0.01 were recomputed and match. The page does not reproduce Mathews' colours (sin red, parabola blue in his figures); the site's own colour scheme is kept. The Examples 3–5 sequences are not added (R2-A says add a sentence, not the example).

## Notes
- The page has no `## Description` section (pre-existing convention gap noted by the reviewer; no finding names it, so not added).
- Reviewer's cosmetic note (legend lists "Tangent parabola T₂(x)" twice in the hold frames) is not a finding and was left as is.
- The h sequence is not Mathews' Table 1 sequence (1, 0.3, 0.1, …); it keeps the page's log-spaced sweep, adjusted to 17 values so that the two Figure step sizes are exact frames. h = 0.3 is not a frame (0.316 is).

### Director note

The checker's new Minor item (the R2-A note sits under the Case 1 heading after its GIF) is the cross-page placement point; the end-of-page placement was the round-2 pattern from the Monte Carlo page. Left as is and listed for Jason in fixes/README.md.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence (archive): I rendered the formula images to `check/arch/stack_34_122.png`. They read: gr_34 "y = sin(x)", gr_35 "x0 = 1", gr_36 "h = 0.1" (Figure 1); gr_39–41 "sin(x), x0 = 1, h = 0.01" (Figure 2); gr_43–45 "h -> 0" (Figure 3); gr_82/83 "x0 = 1", "h = 0.1 and 0.01" (the Numerical Experiment and Examples 1–2); gr_118 "h = 1.0, 0.3, 0.1, 0.03, 0.01, 0.003 and 0.001" and gr_120/121 "sin(x), x0 = 1" (Table 1). Figure 1 (gr_33, `check/arch/r33.png`) is plotted on x in [0, pi] with ticks at 1, pi/2 and pi, and y from 0 to about 1.
- Evidence (script): `f = sin`, `df = cos`, `d2f = -sin` are correct. `x0 = 1.0` and the plot window is `range(0, π)`, which matches Figure 1. The divided-difference Newton parabola through x0-h, x0, x0+h is unchanged, and I checked it against an independent Lagrange form. The h values are `exp.(range(log 1, log 0.01, length=17))` = 10^(-k/8) for k = 0..16. Frame 9 is h = 0.10000000000000002 and frame 17 is h = 0.010000000000000004, so the Figure 1 and Figure 2 step sizes are frames. Their titles read "h = 0.1" and "h = 0.01" (seen at full size).
- Evidence (convergence): the maximum of |P_h − T2| on [0, pi] falls by a factor of 1.778 = (10^(1/8))^2 per frame, from 1.196e-1 at h = 1 to 1.251e-5 at h = 0.01. That is O(h^2), as expected for the symmetric secant parabola. The central coefficients (f(x0+h) − f(x0−h))/2h and (f(x0+h) − 2f(x0) + f(x0−h))/2h^2 tend to cos 1 = 0.540302 and −sin(1)/2 = −0.420735 over Table 1's h list.
- The intro, the Case 1 heading, the alt text and the script header now all say sin(x), x0 = 1. No cos or pi/4 is left in the page folder.

### F2 — resolved (by the R2-A "add one sentence" route)
- The page now says (line 24) that the module's Examples 3–5 are not animated. This follows the owner's R2-A decision, which names Tangent Parabola explicitly: add one sentence, do not add the example.
- I checked every claim in that sentence against the archive (`check/arch/r211.png`, `r228.png`, `r257.png`, `r213.png`, `stack_185_255.png`):
  - **"Newton polynomials of higher degree"** — true. Examples 3 and 4 use Newton cubics. Example 5 uses "Newton polynomials of degree 6" (lnk_11 text, and gr_243 "k = 0,…,6").
  - **"through equally spaced points starting at x0"** — true. Mathews' P[x,0,h] has the node factors x, (x−h), (x−2h), … up to (x−5h) in Example 5, so the nodes are 0, h, …, nh with x0 = 0 (forward, not symmetric).
  - **"compare them with the Taylor polynomial of the same degree"** — true:
    - Example 3: "compare them with the Taylor polynomial", and it shows T3.
    - Example 4: "converging to the Taylor polynomial"; its code prints T[x] and S[x], both = 1 + x/4 − 15x²/32 − 47x³/384.
    - Example 5: S[x] is the degree-6 Taylor polynomial.
    - I recomputed both with sympy for e^{x/4} cos x at 0. T3 = 1 + x/4 − 15x²/32 − 47x³/384 and T6 adds 161x⁴/6144 + 1121x⁵/122880 − 11x⁶/65536, both matching the archive.
    - The forward Newton interpolant at h = 0.7^12 agrees with T_n at x = 1.3 to about 5e-3 for n = 3 and 3e-4 for n = 6, so it converges.
  - **"the tangent cubic in Examples 3 and 4"** — true.
  - **"a higher-degree tangent polynomial in Example 5"** — true, under Mathews' own heading "Tangent Polynomials of Higher Degree". It is vaguer than it could be: it could say "degree 6".
  - **"are not animated here"** — true. The page has only the parabola case.
- The sentence does not mention that Examples 4 and 5 are the module's own animation sequences. R2-A does not require that.

### Changed-text ledger

| Location | Text / number | Check | Verdict |
|---|---|---|---|
| Intro | f(x) = sin(x), x0 = 1 | Script lines 11–15; archive gr_34/35 | correct |
| Intro | "the running example of Mathews' module" | Figures 1–3, Examples 1–2 (gr_82/83) and Table 1 (gr_120/121) all use sin x at x0 = 1 | correct |
| Intro | "frames include its Figure 1 and Figure 2 step sizes h = 0.1 and h = 0.01" | gr_36 = 0.1, gr_41 = 0.01; these are frames 9 and 17, titled "h = 0.1" and "h = 0.01" | correct |
| Case 1 heading | sin(x), x0 = 1 | as above | correct |
| Alt text | "red dashed" secant, "green dotted" tangent, "three nodes" | `:tomato` dash, `:darkgreen` dot, 3 scatter points; seen in frames | correct |
| Alt text | "h shrinks from 1.0 to 0.01" | 17 values, from 1.0 to 0.01 | correct |
| Alt text | "followed by the tangent parabola alone" | 5 frames of h = 0 with no secant and no nodes (frames 18–22) | correct |
| Alt text | "for sin(x) at x0=1" | as above | correct |
| Note (line 24) | Examples 3–5 claims | see F2 | correct |
| GIF titles | "h = 1.0", "0.75", "0.562", …, "0.1", …, "0.013", "0.01" | `round(h, digits=3)` of 10^(-k/8): 1.0, 0.75, 0.562, 0.422, 0.316, 0.237, 0.178, 0.133, 0.1, 0.075, 0.056, 0.042, 0.032, 0.024, 0.018, 0.013, 0.01 | correct |
| GIF legend | "f(x) = sin(x)" | script line 61 | correct |
| Script comments | "17 values = 10^(-k/8), k = 0..16"; "Mathews' plot window [0, π]"; "Figures 1–3 and Table 1" | computed; gr_33; gr_120/121 | correct |
| Axes | ylims (−0.2, 1.15) | Over all frames: curve minimum −0.1196 (T2(0) = −0.1196), maximum 1.0149 (T2 peak) | no clipping |

### New problems

1. **Minor — placement of the Examples 3–5 note.**
   - Location: `index.qmd` line 24.
   - Problem: the note sits under `### Case 1 — …`, after the Case 1 GIF, with no heading or separator. In the rendered page, and in Quarto's section structure, it is part of the Case 1 subsection rather than a page-level remark. Because it opens with "extend the construction", it reads naturally as a coda to Case 1. Nothing in it is false.
   - Context: the same "after the last case's GIF" placement is used on many other fixed pages (Hermite, Rational, Catenary, Monte Carlo π, Cubic Splines, and others), so it is a site-wide pattern rather than an error on this page.
   - Fix: to make it unambiguously page-level, move it into the Animations intro paragraph, before the Case 1 heading.

None others. That rests on:
- full-size views of frames 1, 9, 17 and 22, plus the contact sheet of all 22 frames;
- the computed curve ranges (no clipping);
- the legend box (bottom centre, x ≈ 1.0–2.1, y ≈ −0.2–0.05), which never meets a curve or node, because every curve is above 0.75 for x in [1, 2.1];
- the ledger above.

Observations that are not defects:
- **Secant against curve.** The parabola stays clearly distinct from sin(x) away from x0. The gap reaches about 0.12 at x = 0 and x = pi.
- **Secant against tangent.** The secant and tangent parabolas become visually coincident from about h ≤ 0.18, when |P − T2| < 4e-3, which is about 1 px. So frames 7–17 differ only in where the nodes are. This is the convergence being shown, and Mathews' Figure 1 at h = 0.1 looks the same.
- **Pre-existing, not introduced by this fix:**
  - The h = 0 frames list "Tangent parabola T₂(x)" twice in the legend, for the dashed and the dotted copy. The script logic for this is unchanged from HEAD.
  - The page has no `## Description` section; see the conventions section.

### Reproducibility and conventions

- **Reproducibility:** I ran a scratch copy with `julia run/tangparabaa.jl`. The output has sha256 e9303ade…0f4642, byte-identical to the committed GIF and to the LFS oid in the diff. The GIF has 22 frames at 700×500.
- **Scope:** the fix diff touches only `pages/numerical-methods/the-tangent-parabola/` (index.qmd, tangparabaa.jl, tangparabaa.gif). The other modified files in the working tree belong to other pages' fixes and are not in this page's diff.
- **Conventions:**
  - There is one source link and one embed for the single case.
  - The alt text is descriptive.
  - There are no code blocks.
  - The GIF output uses `@__DIR__`.
  - The page has no `## Description` section before `## Animations`, which the conventions require. This is pre-existing (HEAD lacks it too and the diff does not touch it), so it is not a regression from this fix.

**Final status:** committed
