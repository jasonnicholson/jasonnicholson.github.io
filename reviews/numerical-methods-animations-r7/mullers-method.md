# Muller's Method — animation review (round 7)

Page: `pages/numerical-methods/mullers-method/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1. Page match, Minor: the description of Mathews' program omits his point-selection rule, which changes his iterates from $p_7$ on

- **Location:** `index.qmd` line 18: "Mathews' own program [@mathewsSite] handles the complex case differently: it drops the square root, so the step is $p_3 = p_2 - 2f(p_2)/b$, where $b$ is the parabola's slope at $p_2$, and its iterates $1.1091, 1.4944, 1.0558, 0.9965, \ldots$ rise to 1.4944, drop below 1, and then approach 1 from both sides."
- **What is there now:** dropping the square root is presented as the difference between the page's Case 1 and Mathews' program. The page's introduction (line 12) says the oldest point is dropped at each step.
- **What is true:** Mathews' program differs in a second way. It does not drop the oldest point; it discards whichever of the three points is farthest from the new iterate:
  `If[Abs[p3-p1] < Abs[p3-p0], swap p0,p1]; If[Abs[p3-p2] < Abs[p3-p1], swap p1,p2]; p2 = p3` (archive image `MullersMethodMod_gr_5.gif`).
  A reader who applies the page's rules (drop the square root, drop the oldest point) reproduces the four quoted iterates and then leaves Mathews' sequence at $p_7$.
- **How I know:** `/usr/bin/python3 review/mathews_lit.py`:

  | | Archive table | Mathews' program, transcribed | Square root dropped, oldest point dropped |
  |---|---|---|---|
  | $p_3$ | 1.1091314031 | 1.1091314031 | 1.1091314031 |
  | $p_4$ | 1.4944130474 | 1.4944130474 | 1.4944130474 |
  | $p_5$ | 1.0557604297 | 1.0557604297 | 1.0557604297 |
  | $p_6$ | 0.9964676201 | 0.9964676201 | 0.9964676201 |
  | $p_7$ | **0.9981213458** | **0.9981213458** | **0.9972479592** |
  | $p_8$ | 1.0000166310 | 1.0000166310 | 1.0000089091 |
  | $p_9$ | 0.9999987980 | 0.9999987980 | 0.9999980057 |
  | $p_{10}$ | 1.0000000057 | 1.0000000056 | 1.0000000050 |

  The transcription matches the archive's Example 1 table to $1.6\times10^{-11}$ and its Example 2 table to $4.4\times10^{-16}$.
- **Why only Minor:** every value the page quotes is correct, and the qualitative description (rises to 1.4944, drops below 1, approaches 1 from both sides) holds under either rule. Cases 2 and 3 are unaffected: their iterates increase monotonically, so the oldest point is always the farthest, and the two rules give identical sequences (difference exactly 0.0 in Float64).
- **Suggested correction:** add one clause, for example: "...where $b$ is the parabola's slope at $p_2$. His program also keeps the two points nearest the new iterate rather than the two most recent, and its iterates $1.1091, 1.4944, 1.0558, 0.9965, \ldots$ rise to 1.4944, ..."

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `mullersaa.jl` | 0 | 11.0 | mullersaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `mullersbb.jl` | 0 | 10.9 | mullersbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `mullerscc.jl` | 0 | 10.7 | mullerscc.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `mullersaa.gif` | 8 | byte-identical | mullersaa |
| `mullersbb.gif` | 9 | byte-identical | mullersbb |
| `mullerscc.gif` | 9 | byte-identical | mullerscc |

### Page references

- Scripts linked: `mullersaa.jl`, `mullersbb.jl`, `mullerscc.jl`
- GIFs embedded: 3
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

### Introduction (line 12)

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| L1 | Each animation fits a parabola through three successive approximations | Confirmed | Scripts' `lagrange_parabola`; matches an exact Vandermonde parabola to $\le 1.8\times10^{-10}$ of $\max\lvert f\rvert$ at 4 sample points per frame (`cmp.py`) |
| L2 | Parabola is dashed blue and passes through the current $(p_0,p_1,p_2)$ | Confirmed | Plot code; frames |
| L3 | Next iterate is where the parabola crosses the x-axis (Cases 2, 3) | Confirmed | $P(q_3)$ is $\le 4.5\times10^{-16}$ in every frame; the nearer real root in exact arithmetic |
| L4 | In Case 1 the parabola never reaches the axis | Confirmed | Discriminant < 0 in all 8 frames (script and exact), and in all 25 exact steps run |
| L5 | Each frame advances one iteration; the oldest point is dropped | Confirmed | `history[i+1] = (q1, q2, q3)` |
| L6 | New estimate becomes $p_2$ (red dot) | Confirmed | Each frame's open circle equals the next frame's red dot; legends read back below |
| L7 | Gray dots are $p_0$ and $p_1$ | Confirmed | Plot code; frames |
| L8 | Source scripts are linked under each case | Confirmed | Lines 20, 28, 36 |

### Case 1 (lines 16–22)

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| L9 | $f(x)=x^3-3x+2$, in heading, script and GIF title | Confirmed | Script line 21; frames; archive |
| L10 | $f=(x-1)^2(x+2)$, double root at 1 | Confirmed | Expansion; archive `Solve` output |
| L11 | Starts from $p_2=2.0$ | Confirmed | Script line 22 (2.2, 2.1, 2.0), same as archive |
| L12 | None of the parabolas reaches the axis; roots complex at every step | Confirmed | See L4 |
| L13 | First complex iterate $\approx 1.2873+0.3563i$ | Confirmed | $1.2873016 \pm 0.35634479i$, a conjugate pair; residual $P(z)$ is 0 at working precision |
| L14 | Animation takes the real part, which is the vertex (open red circle) | Confirmed | Script line 42; $\mathrm{Re}(p_2 - 2c/(b \pm i\sqrt{-\Delta})) = p_2 - b/(2d)$ since $\lvert E\rvert^2 = 4cd$ |
| L15 | Each frame is zoomed to the current points | Confirmed | Script lines 78–82; frames |
| L16 | Vertex height falls from 0.80 to $5.4\times10^{-13}$ over eight frames | Confirmed | Exact 0.79998 to $5.4343\times10^{-13}$; script $5.4319\times10^{-13}$; inset titles 8.00e-01 to 5.43e-13; 8 frames |
| L17 | Iterates 1.2873, 1.1581, 1.0552, 1.0100, 1.0017 | Confirmed | Exact 1.28730159, 1.15808780, 1.05520419, 1.00999920, 1.00168459 |
| L18 | Iterates decrease to $p=1$ | Confirmed | Monotone over all 25 exact steps |
| L19 | Superlinear, order $\approx 1.32$ for this variant | Confirmed | Measured 1.3245–1.3249 at high precision; the error recurrence $e_{n+1}\approx e_{n-1}e_{n-2}/6$ gives $r^3=r+1$, $r=1.32472$ |
| L20 | Faster than Newton, which is linear at a double root | Confirmed | After 8 steps: Muller error $3.1\times10^{-8}$, Newton $5.1\times10^{-3}$; Newton's late error ratio 0.50000 |
| L21 | Mathews' step when complex: $p_3=p_2-2f(p_2)/b$, $b$ the slope at $p_2$ | Confirmed, incomplete | Archive `gr_5`: `disc = 0`, `Z = -2c/(b+disc)`. See **F1** for the omitted point-selection rule |
| L22 | Mathews' iterates 1.1091, 1.4944, 1.0558, 0.9965 | Confirmed | Archive table and literal transcription |
| L23 | They rise to 1.4944, drop below 1, approach 1 from both sides | Confirmed | 0.9965, 0.9981, 1.0000166, 0.9999988, 1.0000000057 |
| L24 | Alt text (parabolas miss axis, vertex is next iterate, zoom, inset) | Confirmed | Frames; L4, L14 |
| L25 | Link and embed are the Case 1 script and GIF | Confirmed | `mullersaa.jl`, `mullersaa.gif`; GIF byte-identical to scratch regeneration (`cmp`) |

### Case 2 (lines 24–30)

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| L26 | $f(x)=\sin(x^2-2)(x^2-2)$, double root at $\sqrt2\approx1.4142$, both factors vanish | Confirmed | Script line 16; near the root $f \approx 8e^2$; archive |
| L27 | Converges from $p_2=1.0$ | Confirmed | Triple 0.8, 0.9, 1.0 as in archive; script iterates match the archive table through $p_{10}$ at the digits shown there; last frame's next iterate 1.41421024 |
| L28 | "Locates it efficiently despite the flat tangent" | Confirmed | $f'(\sqrt2)=0$; after 8 steps Muller error $3.9\times10^{-5}$, Newton $7.7\times10^{-4}$; order measured 1.23375 |
| L29 | Inset shows step from $p_2$ to axis crossing (open red circle), the next iterate | Confirmed | Plot code; frames |
| L30 | Step shrinks from 0.25 to $3.6\times10^{-5}$ over nine frames | Confirmed | Exact 0.25432 to $3.5799\times10^{-5}$; inset titles 2.54e-01 to 3.58e-05; 9 frames |
| L31 | Alt text; link and embed | Confirmed | Frames; `mullersbb.jl`, `mullersbb.gif` byte-identical to regeneration |

### Case 3 (lines 32–38)

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| L32 | $f=x^6-7x^4+15x^2-9=(x^2-1)(x^2-3)^2$, double root at $\sqrt3\approx1.7321$ | Confirmed | Factorisation residual $6\times10^{-3001}$ at a test point; function matches archive `gr_143` |
| L33 | Starts from $p_2=1.5$ | Confirmed for $p_2$; **could not determine** $p_0,p_1$ against the archive | Archive `gr_144` gives 1.5. Images `gr_145` onward do not exist, so Mathews' Example 3 triple and table are unavailable. The script's 1.3, 1.4 follow the pattern of his Examples 1 and 2 |
| L34 | Converges to the double root | Confirmed | Last frame's next iterate 1.73204300; monotone from below over 34 exact steps |
| L35 | Newton would converge linearly here | Confirmed | Late error ratio 0.50000 |
| L36 | Muller is superlinear, order $\approx 1.23$ at this double root | Confirmed | Measured 1.23375; root of $2r^3-r^2-r-1=0$ is 1.23375 |
| L37 | $\approx 1.84$ at a simple root | Confirmed | Measured 1.8390–1.8403 on $x^3-3x$ at $\sqrt3$; tribonacci constant 1.83929 |
| L38 | Inset shows the step; it shrinks from 0.13 to $5.5\times10^{-5}$ over nine frames | Confirmed | Exact 0.12765 to $5.5204\times10^{-5}$; inset titles 1.28e-01 to 5.52e-05; 9 frames |
| L39 | Alt text; link and embed | Confirmed | Frames; `mullerscc.jl`, `mullerscc.gif` byte-identical to regeneration |

### Other

| # | Item | Verdict | Evidence |
|---|---|---|---|
| L40 | Description section formulas | Not applicable | The page has no Description section; content the page lacks is not a finding under the brief |
| L41 | Every archive example has a case | Confirmed | Archive has Examples 1–3; page has Cases 1–3 with the same functions |
| L42 | Case 1's departure from Mathews' iteration | Disclosed, no finding | The page states its variant, the reason and Mathews' alternative |

---

### 3. Implementation checks

### All three scripts

- **The method:** Muller's method in the standard form $P(x)=f_2+b(x-p_2)+d(x-p_2)^2$, with $p_3=p_2-2f_2/E$ and $E$ the larger-magnitude of $b\pm\sqrt{b^2-4f_2d}$. Each step drops the oldest point. `mullersaa.jl` adds a named variant for a negative discriminant (real part, the vertex), and all of its steps take that branch. `mullersbb.jl` and `mullerscc.jl` raise an error on a negative discriminant, and none occurs.
- **Script against exact arithmetic** (`cmp.py`, 120 digits, each script's stored triple in each frame):

  | Script | Frames | Max iterate difference | Max parabola difference, relative to $\max\lvert f\rvert$ |
  |---|---|---|---|
  | `mullersaa.jl` | 8 | $3.4\times10^{-14}$ | $1.3\times10^{-10}$ |
  | `mullersbb.jl` | 9 | $2.5\times10^{-16}$ | $3.6\times10^{-14}$ |
  | `mullerscc.jl` | 9 | $8.4\times10^{-13}$ | $1.8\times10^{-10}$ |

- **Regeneration:** each committed GIF is byte-identical to a scratch run of the unchanged script (`cmp`).

### `mullersaa.jl`

- **Numbers** (frame: script $p_2$ / exact $p_2$ / vertex height, script / exact):

  | Frame | Script $p_2$ | Exact $p_2$ | $h$ script | $h$ exact |
  |---|---|---|---|---|
  | 1 | 2 | 2 | 0.7999841 | 0.79998 |
  | 2 | 1.287301587 | 1.28730159 | 0.1813936 | 0.18139 |
  | 3 | 1.158087802 | 1.15808780 | 0.03187154 | 0.031872 |
  | 4 | 1.055204193 | 1.05520419 | 2.157309e-3 | 2.1573e-3 |
  | 5 | 1.009999195 | 1.00999920 | 7.811686e-5 | 7.8117e-5 |
  | 6 | 1.001684591 | 1.00168459 | 8.941839e-7 | 8.9418e-7 |
  | 7 | 1.000107901 | 1.00010790 | 1.790330e-9 | 1.7903e-9 |
  | 8 | 1.000003006 | 1.00000301 | 5.431920e-13 | 5.4343e-13 |

- **Reference values:** root 1 is exact.
- **Header comment:** a 9th frame's vertex height is $1.01\times10^{-17}$ exactly, while Float64 computes it as $2.08\times10^{-16}$. This supports the comment that it is below the rounding error of $f$.
- **Picture:** frames 1, 8 and the contact sheet viewed. The open circle is the vertex, on the parabola, above the axis. The inset's $f$ touches the axis at $x=1$. In frame 8 the main panel's circle sits under the red dot, and the inset shows it. No marker or curve is under the inset in any frame (`inset.out`). Legend values and inset titles match the computed values.

### `mullersbb.jl`

- **Numbers:** $p_3,\ldots,p_{10}$ = 1.25431599, 1.32229937, 1.36889662, 1.39705916, 1.40841296, 1.41269567, 1.41392368, 1.41417444, identical in script, exact computation and archive table. Next iterate in frame 9: 1.41421024. Discriminant positive in all 9 frames.
- **Reference value:** $\sqrt2$.
- **Header comments:** "within 0.1 of it from frame 5 on" holds (largest distance 0.0919 in frame 5, 0.1599 in frame 4). "From frame 7 on, under 7% of the main panel's width" holds (0.0843 in frame 6, 0.0628 in frame 7).
- **Picture:** frame 1 at full size and the contact sheet (all 9 frames) viewed. Legends and inset titles match. In frame 1 the inset's corner covers about 3% of the width of $f$ and the parabola; no marker or axis crossing is hidden, so this is not a finding.

### `mullerscc.jl`

- **Numbers:** $p_3,\ldots,p_{10}$ = 1.62764691, 1.67426829, 1.70348750, 1.72004722, 1.72750110, 1.73063056, 1.73170429, 1.73198780 (script and exact agree). Next iterate in frame 9: 1.73204300. Discriminant positive in all 9 frames. The archive's table for this example is missing, so a run of Mathews' program from the same triple was the comparison: it agrees with the script to the 8 digits printed.
- **Reference value:** $\sqrt3$. The archive's "near $x=2$" is loose; the double root is $\sqrt3$, as the script's header notes.
- **Picture:** frame 9 and the contact sheet viewed. The header's "placed clear of f, the parabola and the points in every frame" holds (`inset.out`: 0.0% hidden in all 9 frames).

### Could not determine

- Mathews' Example 3 starting triple and iteration table: the archive images are missing (L33). His $p_2=1.5$ and the function are confirmed.

