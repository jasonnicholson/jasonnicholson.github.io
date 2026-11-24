# Bisection Method — animation review (round 8)

Page: `pages/numerical-methods/bisection-method/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page, in the script headers and in the frames agrees with independent computation.

Observation (not a finding, per the brief's "content the page does not yet have"): the page has no `## Description` section, although `.github/agents/animation-page.agent.md` (lines 12, 99, 205) says every page must have one. Consequently there were no Description formulas to check against the scripts.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `bisectionaa.jl` | 0 | 13.1 | bisectionaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `bisectionbb.jl` | 0 | 11.1 | bisectionbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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
| 1 | Intro | "The shaded region marks the current bracket [a, b]" | `shade_bracket!(p1, a_cur, b_cur, …)` with a_cur/b_cur = as/bs[frame+1]; frames show shading between the blue dashed lines | confirmed |
| 2 | Intro | IVT guarantees a root when f continuous and f(a), f(b) opposite signs | standard theorem, stated with its hypotheses | confirmed |
| 3 | Intro | "Each frame computes the midpoint c=(a+b)/2, evaluates f(c), and narrows the bracket to the half that still contains the sign change" | script lines 30-40 (both): c=(a+b)/2, keep [a,c] if f(a)f(c)<0 else [c,b]; frames 1..12 each add one c. (Frame 0 shows only the initial bracket, trivially.) | confirmed |
| 4 | Intro | Top panel full view; bottom panel zooms on the bracket from before the current step | lines 105-108 / 128-131: window = [as[frame], bs[frame]] ±10%; zoom titles e.g. "step 2 halves [a, b] of width 1.5" (bracket before step 2 is [0.5, 2]) | confirmed |
| 5 | Intro | bracket narrower than a pixel in the full view "from step 9 on" | Measured plot box in frame_001: columns 115-588 = 473 px. Case 1: 3.4/473 = 0.00719/px; width after step 8 = 0.01172 (1.63 px), after step 9 = 0.00586 (0.81 px). Case 2: 2.4/473 = 0.00507/px; after step 8 = 0.00781 (1.54 px), after step 9 = 0.00391 (0.77 px) | confirmed (both cases) |
| 6 | Intro | Julia scripts linked under each case | links `bisectionaa.jl`, `bisectionbb.jl` | confirmed |
| 7 | Case 1 heading | "Convergent", f(x)=x³+4x²−10, [a0,b0]=[−1,2] | script line 15-16; bracket shrinks to [1.364990234375, 1.36572265625] ∋ x* | confirmed |
| 8 | Case 1 | f(−1)=−7<0, f(2)=14>0 | Julia: `-7.0 14.0`; mpmath same | confirmed |
| 9 | Case 1 | x* ≈ 1.3652 | mpmath findroot/polyroots: 1.365230013414097 (only real root) | confirmed |
| 10 | Case 1 | bracket width halves each step; \|c_k−x*\| ≤ (b0−a0)/2^k shrinks monotonically | widths 1.5, 0.75, …, 0.000732; bound 3/2^k holds for k=1..12 (indep.py prints True for all) | confirmed |
| 11 | Case 1 | midpoints not monotone, fall on both sides of the root | c_k−x* signs: −,−,+,+,−,+,+,−,−,−,+,− | confirmed |
| 12 | Case 1 alt | "bracket narrows around the root at x≈1.3652 over 12 steps, with a lower panel zoomed on each halving" | n_iters=12, 13 frames; final c_12=1.364990, bracket contains 1.36523 | confirmed |
| 13 | Case 1 wiring | link/embed = bisectionaa.jl/.gif, which uses the heading's f and interval | script lines 15-16, 155 | confirmed |
| 14 | Case 2 heading | "Spurious convergence (cautionary)", f=tan x, [0,2] | script lines 18-19 | confirmed |
| 15 | Case 2 | f(0)=tan 0=0, a genuine root at the left end | Julia tan(0.0)=0.0 | confirmed |
| 16 | Case 2 | c1=1; implementation moves b only when f(a)f(c)<0; f(0)f(1)=0 so it keeps [1,2] | line 36; instrumented: step 1 after = [1.0, 2.0]; frame_002 shows bracket [1,2], root at 0 outside | confirmed |
| 17 | Case 2 | a ≤ 0 variant would keep [0,1] and converge to 0 | with ≤, f(0)f(c)=0 at every step so b←c, c_k = 2^{1−k} → 0 | confirmed |
| 18 | Case 2 | tan1>0, tan2<0 | 1.5574, −2.1850 | confirmed |
| 19 | Case 2 | sign change caused by asymptote at π/2≈1.5708; tan has no zero in [1,2] | zeros of tan are kπ; π/2=1.5707963 | confirmed |
| 20 | Case 2 | "Bisection converges to the asymptote" | final bracket [1.5703125, 1.57080078125] ∋ π/2; \|f(c_k)\| grows to 2.24e5 (Julia and mpmath agree at all 12 steps) | confirmed |
| 21 | Case 2 alt | first step leaves root at 0, then converges to asymptote at π/2, lower panel zoomed on each halving | frames 2-13 | confirmed |
| 22 | Case 2 wiring | link/embed = bisectionbb.jl/.gif with heading's parameters | lines 18-19, 183 | confirmed |
| 23 | Frames | titles name the function in the code; legend `c_k = …` with correct index and value | e.g. aa frame 13 "c_12 = 1.36499" (=round(1.364990234375,6)); bb frame 13 "c_12 = 1.570801"; all 12 match instrumented cs | confirmed |

### 3. Implementation checks

### bisectionaa.jl
- *Method:* plain bisection, fixed 12 iterations, test f(a)f(c)<0 → [a,c] else [c,b]. Standard variant (the else-branch also absorbs f(c)=0, which never occurs here).
- *Numbers:* instrumented copy (`review/bisectionaa_inst.jl`) vs independent mpmath bisection (`review/indep.py`): all 12 (a,b,c,f(c)) rows identical, e.g. k=1 c=0.5 f=−8.875; k=7 c=1.3671875 f=0.0323558; k=12 c=1.364990234375 f=−0.0039591.
- *Reference:* x*=1.36523001341409685 (mpmath, 30 digits); header "≈ 1.3652" correct.
- *Picture:* frames 1, 2, 3, 5, 7, 9, 11, 13 inspected. Midpoint dot at (c_k, f(c_k)) with dotted drop to diamond at (c_k, 0); gray earlier midpoints on the curve; zoom window = previous bracket, y-range covers the curve and f(c); no clamping in this case. Legacy fidelity: Mathews Example 3 is x³+4x²−10=0 on [−1,2] (archive images gr_647/648/649) — matches; Mathews ran 30 steps, page 12, which does not affect the lesson.

### bisectionbb.jl
- *Method:* same bisection loop as Case 1.
- *Numbers:* instrumented vs mpmath: identical for all 12 steps (k=1 c=1.0 f=1.5574; k=5 c=1.5625 f=120.53; k=8 c=1.5703125 f=2066.86; k=12 c=1.57080078125 f=−224494.35).
- *Reference:* asymptote drawn at π/2 (line 48) — correct.
- *Picture:* frames 1, 2, 3, 5, 7, 9, 11, 13 inspected. Top panel clamps f to ±15 (`clamp_y`), so from step 4 on the current red dot sits on the panel border; the legend reports c_k only (not f(c_k)) and the bottom zoom panel draws f(c_k) unclamped (e.g. −2.24e5 at step 12), so the clamp does not misstate any value — not a finding. Curve split around π/2 (gap 0.02 top, 0.002·w zoom) avoids a false connecting line; frame 13 zoom shows the asymptote between the left branch and c_12 (c_12 − π/2 = 4.5e−6 ≈ 1.8 px). Legacy fidelity: Mathews Example 4 is tan x = 0 on [0,2] ("Not a root located … located a pole"; images gr_813/814/815) — matches; Mathews used 15 steps, page 12.

