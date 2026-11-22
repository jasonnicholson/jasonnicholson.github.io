# Fixed Point Iteration — animation review (round 4)

Page: `pages/numerical-methods/fixed-point-iteration/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I found no Error, Misleading or Minor findings.

Observations that are not findings:
- The repo file names `fixpointdd`/`fixpointee` are the reverse of Mathews' a2001 names. In a2001, `Fixpointdd.gif` is the divergent p0 = 2.03 case (last frame "p9 = 3.75337") and `Fixpointee.gif` is the p0 = 1.95 case (last frame "p16 = 0.01933"). The page also presents Mathews' Example 8 (p0 = 1.95) before Example 7 (p0 = 2.03). A reader never sees the file names, and every heading, link and embed is internally consistent, so neither is a finding.
- In Mathews' Example 9, p0 = 1.97, the animation is titled "Divergence: Spiral" and stops at p10 = 0.17357. The page instead runs 32 iterations and states that the orbit stays bounded and settles onto an attracting 4-cycle. This departure is mathematically correct (see the checks below), so it is not a Fidelity finding.
- Mathews' Examples 1–3, g(x) = 1 + x − x²/3 and 1 + x − x²/4, are Mathematica `FixedPointList` exercises with no animation. The page reproduces all six archive animations (Examples 4–9). It does not drop any animated case.
- In `fixpointdd.jl`, `fixpointee.jl` and `fixpointff.jl`, the branch that draws an off-scale marker never runs. Every drawn iterate lies inside the window: the instrumented copies print `inwindow: true` for all six scripts. The branch is dead code but harmless.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `fixpointaa.jl` | 0 | 6.7 | fixpointaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `fixpointbb.jl` | 0 | 6.6 | fixpointbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `fixpointcc.jl` | 0 | 5.5 | fixpointcc.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `fixpointdd.jl` | 0 | 8.3 | fixpointdd.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `fixpointee.jl` | 0 | 5.9 | fixpointee.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `fixpointff.jl` | 0 | 7.9 | fixpointff.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `fixpointaa.gif` | 13 | byte-identical | fixpointaa |
| `fixpointbb.gif` | 13 | byte-identical | fixpointbb |
| `fixpointcc.gif` | 13 | byte-identical | fixpointcc |
| `fixpointdd.gif` | 17 | byte-identical | fixpointdd |
| `fixpointee.gif` | 10 | byte-identical | fixpointee |
| `fixpointff.gif` | 33 | byte-identical | fixpointff |

### Page references

- Scripts linked: `fixpointaa.jl`, `fixpointbb.jl`, `fixpointcc.jl`, `fixpointdd.jl`, `fixpointee.jl`, `fixpointff.jl`
- GIFs embedded: 6
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | Intro | Cobweb: from x_n on the diagonal, "vertical to the curve to get g(x_n) = x_{n+1}, then horizontal back to the diagonal" | All six scripts build the path as (x_n,x_n)→(x_n,x_{n+1})→(x_{n+1},x_{n+1}). Instrumented check `cobweb ok: true` for all six | confirmed |
| 2 | Intro | C¹ g: \|g'(x*)\|<1 ⇒ convergence for x₀ close enough; \|g'(x*)\|>1 ⇒ nearby iterates (≠x*) move away | Standard local theorem (mean value theorem). Correctly hedged | confirmed |
| 3 | Intro | "Julia source scripts … are linked under each case" | 6 links, one per case | confirmed |
| 4 | Case 1 heading | g(x)=√(2x), x₀=0.1 | `fixpointaa.jl` l.10–11 | confirmed |
| 5 | Case 1 | fixed point x*=2 | √4=2 | confirmed |
| 6 | Case 1 | g'(2)=1/2<1 | mpmath diff: 0.5 | confirmed |
| 7 | Case 1 | converges from below, monotone staircase | x: 0.1, 0.4472, 0.9457, …, 1.99854 (x₁₂), increasing and <2 | confirmed |
| 8 | Case 1 alt | "starting below the fixed point at x₀ = 0.1" | frame 1 shows marker x₀ = 0.1 | confirmed |
| 9 | Case 1 wiring | link `fixpointaa.jl`, embed `fixpointaa.gif` | GIF byte-identical to scratch regeneration (manifest). Frame titles show g(x)=√(2x) | confirmed |
| 10 | Case 2 heading | g=√(2x), x₀=4.0 | `fixpointbb.jl` l.10–11 | confirmed |
| 11 | Case 2 | descends monotonically to 2 | x: 4, 2.8284, 2.3784, …, 2.000338 (x₁₂), decreasing and >2 | confirmed |
| 12 | Case 2 | "confirming convergence from both sides" (with Case 1) | Cases 1 and 2 converge from below and from above | confirmed |
| 13 | Case 2 alt / wiring | x₀=4.0 above fixed point; `fixpointbb.*` | frame 1 shows x_0 = 4.0; byte-identical regeneration | confirmed |
| 14 | Case 3 heading | g=8/(x+2), x₀=4.0, "oscillating convergent" | `fixpointcc.jl` l.11–12; x → 2.000366 (x₁₂) | confirmed |
| 15 | Case 3 | g strictly decreasing, g'(x)=−8/(x+2)², g'(2)=−1/2 | mpmath diff at 2: −0.5. Derivative formula is correct | confirmed |
| 16 | Case 3 | \|g'(2)\|=1/2<1 ⇒ converges; alternates sides each step | errors: +2, −0.667, +0.4, −0.182, +0.095, … sign alternates at every step from x₀ to x₁₂ | confirmed |
| 17 | Case 3 alt / wiring | `fixpointcc.*`, x₀=4.0 | frames show 8/(x+2), x_0 = 4.0; labels x_2 = 2.4, …, x_12 = 2.0004 match computation | confirmed |
| 18 | Case 4 heading | g=x²/4+x/2, x₀=1.95; repelled from 2, converges to 0 | `fixpointdd.jl` l.11–12; x₁₆=0.019332 | confirmed |
| 19 | Case 4 | crosses y=x at 2 and 0; below diagonal for 0<x<2 | g(x)−x = x(x−2)/4 < 0 on (0,2) | confirmed |
| 20 | Case 4 | g'(2)=3/2>1; g'(0)=1/2 | mpmath: 1.5, 0.5 | confirmed |
| 21 | Case 4 | walks left, converges monotonically to 0 | x: 1.95, 1.9256, 1.8898, …, 0.0733, 0.0379, 0.0193, strictly decreasing and >0 | confirmed |
| 22 | Case 4 alt / wiring | "starting at x₀ = 1.95 just below … walks left and converges to … x = 0"; `fixpointdd.*` | frames 1–17 show this. Last label x_16 = 0.0193 | confirmed |
| 23 | Case 5 heading | g=x²/4+x/2, x₀=2.03, divergent | `fixpointee.jl` l.12–13 | confirmed |
| 24 | Case 5 | moves monotonically rightward and diverges | x: 2.03, 2.0452, …, 3.7534, 5.3986, 9.986, 29.92, 238.8, 14373, 5.17e7, increasing and unbounded (g(x)>x for x>2) | confirmed |
| 25 | Case 5 | "showing instability from both sides" (with Case 4) | Case 4 leaves 2 to the left, Case 5 to the right | confirmed |
| 26 | Case 5 | animation stops at x₉ ≈ 3.753, the last iterate in the window | n_iters = 9. x₉ = 3.753371, x₁₀ = 5.3986 > 4. Final frame label x_9 = 3.7534 | confirmed |
| 27 | Case 5 | x₁₂ ≈ 29.92, x₁₄ ≈ 1.437×10⁴ | 29.9210, 14373.03 | confirmed |
| 28 | Case 5 alt / wiring | "reaches x₉ ≈ 3.753 at the right of the window"; `fixpointee.*` | frame 10 shows this | confirmed |
| 29 | Case 6 heading | g=−x²/4−x/2+4, x₀=1.97, "oscillating, does not converge" | `fixpointff.jl` l.12–13; orbit tends to a 4-cycle | confirmed |
| 30 | Case 6 | g'(2)=−3/2, \|g'(2)\|>1 | mpmath: −1.5 (also g(2)=2) | confirmed |
| 31 | Case 6 | moves away from 2, alternating sides at every step | x_n−2 alternates sign for every n from 0 to 40. \|x_n−2\| grows 0.03→0.045→0.068→…→1.83 (x₁₀) | confirmed |
| 32 | Case 6 | settles onto a stable 4-cycle ≈ 4.25, −2.64, 3.58, −0.99 | findroot of g⁴(x)=x: 4.2499617, −2.6405244, 3.5771699, −0.9876211, in that order. Multiplier ∏g' = −0.0305, so the cycle is attracting. The 2-cycle {4, −2} has multiplier −1.25 (repelling) | confirmed |
| 33 | Case 6 alt / wiring | "starting at x₀ = 1.97 … settles onto a 4-cycle"; `fixpointff.*` | final frame (x_32 = −0.9909) shows the 4-cycle box. x₂₉..x₃₂ lie within 0.0033 of the cycle | confirmed |
| 34 | Counts | 6 cases, 6 scripts, 6 GIFs | manifest; frame counts 13/13/13/17/10/33 = n_iters+1 | confirmed |

### 3. Implementation checks

The method is the same in all six scripts: `xs[i+1] = g(xs[i])`. This is plain fixed-point (Picard) iteration, which is the method in the title. The cobweb vertices are exactly (x_n, x_{n+1}) and (x_{n+1}, x_{n+1}); the instrumented copies assert this. Frame k draws 1+2k path points, and the red marker sits at (x_k, x_k) with the label "x_k = round(x_k, 4)". None of the scripts has a reference value apart from the fixed point x*=2, and g(2)=2 holds for all four functions.

How I checked: for each script I copied it to `review/inst/`, cut it at `# --- Animation`, printed `xs`, the cobweb consistency and window containment, and ran `julia fixpoint??.jl`. Independently, `/usr/bin/python3 review/indep.py` iterates each g in 40-digit mpmath.

| Script | Script x_final (Float64) | Independent (mpmath) | Frames (script / GIF) | Notes |
|---|---|---|---|---|
| aa | x₁₂ = 1.9985377748870492 | 1.99853777489 | 13 / 13 | monotone up. Labels in frames (0.9457, 1.6585, 1.9085, 1.9767, 1.9942, 1.9985) match |
| bb | x₁₂ = 2.0003384794106043 | 2.00033847941 | 13 / 13 | monotone down. Error ratio ≈ 0.5 = g'(2) (e.g. 0.000677/0.001354) |
| cc | x₁₂ = 2.000366233290606 | 2.00036623329 | 13 / 13 | error ratio ≈ −0.5 = g'(2) |
| dd | x₁₆ = 0.019332159933648924 | 0.0193321599336 | 17 / 17 | error ratio near 0 tends to 0.5 = g'(0) (0.0379→0.0193) |
| ee | x₉ = 3.7533709825454316 | 3.75337098255 | 10 / 10 | matches Mathews' a2001 frame "p9 = 3.75337" |
| ff | x₃₂ = −0.9908811883812021 | −0.990881188381 | 33 / 33 | Float64 and 40-digit orbits agree to about 1e-11 at n=32 |

All intermediate iterates agree to the printed precision (see `indep.py` output against `inst` output). The picture shows what was computed. I viewed the contact sheets of all six GIFs and full final frames for aa and ff. Each title and legend names the g in the code. The diagonal and the g curve are correct: the curve crosses the diagonal at 2, and in dd/ee also at 0. Path vertices fall on the curve and the diagonal, and marker labels carry the correct index and value. Display devices are harmless:
- aa uses a 0–4 window. bb and cc use 0–4.2, so x₀ = 4 is not on the edge. dd and ee use 0–4. ff uses −4.5 to 4.5 and holds the whole orbit, whose range is −2.639 to 4.249.
- ee stops at the last in-window iterate, and the page says so explicitly with the true later values.
- Nothing is clamped or masked in any drawn frame.
- In ff the legend sits bottom-right, below everything drawn: the curve's minimum on the window is g(4.5) = −3.3125 and the orbit's minimum is −2.639.

Script comments checked:
- ee: "x_10 = 5.3986 would leave it" (5.39863) ✓.
- dd: "x_16 = 0.0193" ✓.
- ff: "within 0.004 of the 4-cycle by x_29…x_32" (max deviation 0.0033) ✓.
- The Mathews example numbers in the headers (5, 6, 7, 8, 9) match the archive's formula images: Ex4 √(2x), 0.1; Ex5 √(2x), 4.0; Ex6 8/(x+2), 4.0; Ex7 x²/4+x/2, 2.03; Ex8 the same g, 1.95; Ex9 −x²/4−x/2+4, 1.97 ✓.

Regeneration: according to the manifest, all six committed GIFs are byte-identical to scratch runs of the committed scripts, so the frames I reviewed are the scripts' output.

