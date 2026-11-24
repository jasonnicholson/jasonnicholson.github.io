# Fixed Point Iteration — animation review (round 8)

Page: `pages/numerical-methods/fixed-point-iteration/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**No findings.** Error: 0, Misleading: 0, Minor: 0.

Things I looked at and judged not to be findings:
- Legend labels are plain text `x_1`, `x_2`, … where Plots does not render a subscript. `fixpointaa.jl` uses `x₀` for frame 0 and `x_n` after that, and its title leaves out x₀, unlike the other five. These are cosmetic only.
- The page has no `## Description` section, although the authoring conventions ask for one. The brief says missing content is not a finding. As a result there are no Description formulas to check.
- The off-scale marker branch in `fixpointdd/ee/ff.jl` never runs, because every iterate lies inside its window (shown below). That is dead code, not an error.
- The Case 6 window is [−4.5, 4.5], where Mathews used [0, 4]. The wider window is needed to show the true orbit, which reaches −2.64, so it is a justified departure.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `fixpointaa.jl` | 0 | 6.1 | fixpointaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `fixpointbb.jl` | 0 | 7.4 | fixpointbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `fixpointcc.jl` | 0 | 6.8 | fixpointcc.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `fixpointdd.jl` | 0 | 7.9 | fixpointdd.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `fixpointee.jl` | 0 | 6.4 | fixpointee.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `fixpointff.jl` | 0 | 8.8 | fixpointff.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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
| 1 | Intro | cobweb: from x_n on the diagonal, vertical to the curve to get g(x_n)=x_{n+1}, then horizontal back to diagonal | code builds (x_n,x_n)→(x_n,x_{n+1})→(x_{n+1},x_{n+1}); instrumented check `cobweb ok: true` for all 6 | confirmed |
| 2 | Intro | |g'(x*)|<1 ⇒ converges for starts close enough; |g'(x*)|>1 ⇒ nearby iterates move away | standard local theorem; consistent with all six computed orbits | confirmed |
| 3 | Intro | "Julia source scripts … are linked under each case" | 6 links, each to the matching script | confirmed |
| 4 | Case 1 heading | g=√(2x), x₀=0.1, convergent staircase | fixpointaa.jl L10–11; iterates rise to 1.99854 | confirmed |
| 5 | Case 1 | meets y=x at 0 and x*=2 | √(2x)=x ⇔ x(x−2)=0 | confirmed |
| 6 | Case 1 | on (0,2) increasing, between y=x and y=2, monotone climb | √(2x)>x ⇔ x<2; √(2x)<2 ⇔ x<2; iterates 0.1, 0.447, 0.946, …, 1.99854 strictly increasing | confirmed |
| 7 | Case 1 | g'(x)>1 for 0<x<½, which includes x₀=0.1 | g'=1/√(2x)>1 ⇔ x<½ | confirmed |
| 8 | Case 1 | error roughly halved near x*, g'(2)=½ | error ratios 0.817, 0.679, …, 0.5004, 0.5002 | confirmed |
| 9 | Case 1 alt | starting below the fixed point at x₀=0.1 | frame 1 | confirmed |
| 10 | Case 2 heading/alt | g=√(2x), x₀=4.0 | fixpointbb.jl L10–11; title in frames | confirmed |
| 11 | Case 2 | descends monotonically to x*=2 | 4, 2.828, 2.378, …, 2.000338 strictly decreasing | confirmed |
| 12 | Case 3 heading | g=8/(x+2), x₀=4.0, oscillating convergent | fixpointcc.jl L11–12; iterates → 2.000366 | confirmed |
| 13 | Case 3 | strictly decreasing, g'=−8/(x+2)², g'(2)=−½ | differentiation; −8/16 | confirmed |
| 14 | Case 3 | converges, alternates sides of x* each step | 4, 1.333, 2.4, 1.818, 2.095, 1.953, … (signs of x−2 alternate) | confirmed |
| 15 | Case 4 heading | g=x²/4+x/2, x₀=1.95; repelled from 2, converges to 0 | fixpointdd.jl L11–12; 1.95 → 0.01933 at x₁₆ | confirmed |
| 16 | Case 4 | crosses y=x at 2 and 0; below the diagonal on (0,2) | x²/4+x/2−x = x(x−2)/4 <0 on (0,2) | confirmed |
| 17 | Case 4 | g'(2)=3/2, g'(0)=½, monotone convergence to 0 | g'=x/2+½; sequence strictly decreasing to 0.01933 | confirmed |
| 18 | Case 4 alt | staircase walks left and converges to x=0 | frames 1–17 | confirmed |
| 19 | Case 5 heading | same g, x₀=2.03, divergent | fixpointee.jl L12–13 | confirmed |
| 20 | Case 5 | moves monotonically rightward and diverges | 2.03, 2.0452, …, 3.7534, 5.3986, 9.9856, 29.92, 238.8, 14373 | confirmed |
| 21 | Case 5 | stops at x₉≈3.753, last iterate inside window | x₉=3.753371, x₁₀=5.3986>4; 10 frames (0..9) | confirmed |
| 22 | Case 5 | x₁₂≈29.92, x₁₄≈1.437×10⁴ | 29.921011, 14373.031 | confirmed |
| 23 | Case 5 alt | reaches x₉≈3.753 at the right of the window | final frame label `x_9 = 3.7534` | confirmed |
| 24 | Case 6 heading | g=−x²/4−x/2+4, x₀=1.97, oscillating, does not converge | fixpointff.jl L12–13 | confirmed |
| 25 | Case 6 | steeply decreasing at 2, g'(2)=−3/2 | g'=−x/2−½ | confirmed |
| 26 | Case 6 | moves away from 2, alternating sides at every step | sign of x_n−2 for n=0..32: `-+-+-+…` strictly alternating; the gap grows from 0.03 to >1 by x₈ | confirmed |
| 27 | Case 6 | settles onto stable 4-cycle (≈4.25, −2.64, 3.58, −0.99) | g⁴ fixed points 4.249962, −2.640524, 3.577170, −0.987621; cycle multiplier ∏g' = −0.0305 (stable); orbit is within 0.0033 of the cycle by x₂₉…x₃₂ | confirmed |
| 28 | Case 6 alt | staircase moves away from 2, alternating, settles onto a 4-cycle | frames 1, 13, 33 | confirmed |
| 29 | Wiring | each case links/embeds fixpoint{aa..ff}.jl/.gif in order | index.qmd L25–73; manifest: each committed GIF byte-identical to a fresh run of its script | confirmed |
| 30 | Diagram | green y=x, magenta y=g(x), blue path, red current iterate | legend entries in every frame | confirmed |

### 3. Implementation checks

All six scripts run plain fixed-point iteration x_{n+1}=g(x_n) with the named g and x₀, and none of them clamps anything. There is no reference value beyond x*, and x* was checked by hand for each g. Each committed GIF is byte-identical to a fresh run of its script (manifest).

Independent computation used mpmath at 40 digits (`review/indep.py`). The script values come from the instrumented copies (`julia review/inst_<s>.jl`). They agree to every printed digit, and the archive values agree as well:

| Script | Script value | Independent value | Mathews archive |
|---|---|---|---|
| aa | x₁₀=1.994157511, x₁₂=1.998537775 | 1.9941575, 1.9985378 | p₁₀=1.994157510729 |
| bb | x₁₀=2.001354261, x₁₂=2.000338479 | 2.0013543, 2.0003385 | p₁₀=2.001354261386 |
| cc | x₁₂=2.000366233 | 2.0003662 | (no values; Example 6 images are missing from the archive) |
| dd | x₁₀=0.6199205414, x₁₆=0.01933215993 | 0.61992054, 0.01933216 | p₁₀=0.619920541350 |
| ee | x₉=3.753370983 | 3.753371; x₁₀=5.3986339, x₁₅≈5.165×10⁷ | p₁₀=5.398633924, p₁₅=5.1653×10⁷ |
| ff | x₁₀=0.1735717694, x₂₀=−1.453072059, x₃₂=−0.9908811884 | 0.17357177, −1.4530721, −0.99088119 | p₁₀=0.173571769, p₂₀=−1.453072059 |

- **Method:** each script runs fixed-point iteration as named. The cobweb vertices were checked programmatically against the iterates (`cobweb ok: true` for all six).
- **Numbers:** they match the table above.
- **Reference values:** x*=2 in every case, and x=0 for Case 4. Both were verified algebraically, and the derivative values quoted in the comments are correct. The ff comment "within 0.004 of the 4-cycle" is confirmed (largest distance 0.00326), and so is "orbit stays in [−2.641, 4.250]" (minimum −2.64057, maximum 4.24998).
- **Picture:** I viewed the contact sheets of all six GIFs and the last frame of ff (frame 033).
  - The curves are the coded g on the stated windows.
  - The path ends at the red marker on the diagonal at x_n.
  - The legend values equal the computed iterates to 4 decimals.
  - Frame counts are 13, 13, 13, 17, 10 and 33, which is n_iters+1 in each case.
  - No iterate leaves its window: the dd minimum is 0.0193, the ee maximum is 3.7534, and the ff range is [−2.641, 4.250] inside ±4.5. So no clamped marker is ever drawn.
  - The ff legend at bottom right covers no part of the orbit or the curve.

**Fidelity.** Cases 1–6 correspond to Mathews Examples 4–9 (Animations 1–6), with the same g and p₀: √(2x) with 0.1 and with 4.0; 8/(x+2) with 4.0; x²/4+x/2 with 2.03 and with 1.95; −x²/4−x/2+4 with 1.97. The page orders Examples 7 and 8 differently (as Cases 5 and 4), which does no harm. Mathews calls Example 9 "Divergence: Spiral". The page says more precisely that the orbit leaves x* and settles onto a stable 4-cycle, which is mathematically correct. Mathews Examples 1–3 are Mathematica exercises with no animation, so leaving them out drops no archive animation.

