# Bisection Method — animation review (round 7)

Page: `pages/numerical-methods/bisection-method/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1. Case 2's walk away from the root depends on an unstated tie rule

- **Kind:** Page match (method description)
- **Severity:** Minor
- **Location:** `index.qmd` line 31: "since $f(0)\,f(1) = 0$ is not negative, bisection keeps $[1, 2]$ and walks away from that root." The rule is at `bisectionbb.jl` line 36: `if f(as[i]) * f(c) < 0`.
- **What is there now:** The sentence attributes the step to "bisection" in general. The page never says that the update test is one of several valid forms, and the intro only says the bracket narrows "to the half that still contains the sign change".
- **What is true instead:** The sentence is correct for this script's strict test. The outcome is a property of that test. With the equally valid form `f(a)f(c) <= 0 → b = c`, the same problem keeps $[0, 1]$ and converges to the genuine root at 0. Mathews' own rule (`Sign[f[b]] == Sign[f[c]] → b = c`, archive images `BisectionMod_gr_11.gif`, `_640`, `_645`) gives the same sequence as the script, so the script is faithful to the source.
- **How I know:** `/usr/bin/python3 -I review/variants.py <evidence dir>`, exact rational midpoints, 12 steps on $\tan x$, $[0,2]$:

| Update rule | First three midpoints | Final bracket |
|---|---|---|
| Script: `f(a)f(c) < 0 → b = c` | 1, 1.5, 1.75 | [1.5703125, 1.57080078125] (contains π/2) |
| Mathews: `sign f(b) == sign f(c) → b = c` | 1, 1.5, 1.75 | [1.5703125, 1.57080078125] |
| Variant: `f(a)f(c) <= 0 → b = c` | 1, 0.5, 0.25 | [0, 0.00048828125] (contains the root 0) |

On Case 1 all three rules give identical midpoints, because no $f(a)$ or $f(c)$ is zero there.

- **Suggested correction:** Replace the sentence with: "The first midpoint is $c_1 = 1$. This implementation moves $b$ only when $f(a)\,f(c) < 0$; since $f(0)\,f(1) = 0$ is not negative, it keeps $[1, 2]$ and walks away from that root. (A variant testing $f(a)\,f(c) \le 0$ would keep $[0, 1]$ and converge to the root at 0.)"

- **Independent check:** not run (Minor finding, unverified)


## Reviewer's notes (not findings)



#### Considered and not reported as findings

- **Clamped midpoints in Case 2's top panel.** For steps 4 to 12 the dot is drawn at $y = \pm 15$, while the true $\tan(c_k)$ runs from −18.43 to −224,494 (table in section 3). This is an acceptable display device: the legend reports only $c_k$, which is correct, the sign is preserved, and the zoom panel directly below draws every midpoint at its true value (checked for all 12 steps).
- **Clamped curve along the border.** `clamp_y` draws the curve as a 10-pixel run along the top edge ($x \in [1.5042, 1.5508]$) and the bottom edge ($x \in [1.5908, 1.6374]$). It merges with the plot frame and does not change what a viewer concludes.
- **Bracket endpoints off the zoom window in Case 2.** In frames 0, 1, 3, 6, 9 and 10, one pre-step endpoint value lies outside the zoom panel's y-range (for example $\tan 2 = -2.185$ in frame 0, window ±1.51). The curve visibly leaves the panel toward that value, and the midpoint is always in view.
- **"Each frame computes the midpoint."** Frame 0 shows only the initial bracket; the other 12 frames each do one step. The alt text's "12 steps" is right, and no reader is misled.
- **No Description section.** The page has none, so there are no Description formulas to check. Missing content is out of scope.
- **Archive Examples 1 and 2.** These are worked text examples with no animation (`lnk_2` and `lnk_3` contain no animation link). Only Examples 3 and 4 have animations, and both are on the page.

## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `bisectionaa.jl` | 0 | 11.6 | bisectionaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `bisectionbb.jl` | 0 | 11.3 | bisectionbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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
| 1 | Intro | "bracket-halving diagram" | Script loop; every frame | Confirmed |
| 2 | Intro | "The shaded region marks the current bracket $[a, b]$" | Shading uses `a_cur`, `b_cur`; dump matches independent brackets in all 13 frames | Confirmed |
| 3 | Intro | Continuous $f$ with opposite signs at $a$, $b$: IVT guarantees a root | Standard theorem, stated with its hypotheses | Confirmed |
| 4 | Intro | "Each frame computes the midpoint $c = \tfrac{a+b}{2}$, evaluates $f(c)$" | True of the 12 step frames; frame 0 is the initial bracket | Confirmed (see note above) |
| 5 | Intro | Narrows "to the half that still contains the sign change" | Kept endpoints have strictly opposite signs at all 12 steps, both cases | Confirmed |
| 6 | Intro | Top panel is the full view | Fixed limits in all frames | Confirmed |
| 7 | Intro | Bottom panel "zooms in on the bracket from before the current step" | Zoom x-limits equal the pre-step bracket ±10% in all frames | Confirmed |
| 8 | Intro | Narrower than a pixel in the full view "from step 9 on" | Plot width 473 px. Case 1: 1.63 px after step 8, 0.82 after step 9. Case 2: 1.54, then 0.77 | Confirmed |
| 9 | Intro | Source scripts linked under each case | Lines 24 and 35 | Confirmed |
| 10 | Case 1 heading | Convergent, $x^3 + 4x^2 - 10$, $[-1, 2]$ | Script lines 15-16; title; computed sequence | Confirmed |
| 11 | Case 1 | $f(-1) = -7 < 0$, $f(2) = 14 > 0$ | Exact arithmetic | Confirmed |
| 12 | Case 1 | IVT guarantees a root in $[-1, 2]$ | Polynomial, sign change | Confirmed |
| 13 | Case 1 | $x^* \approx 1.3652$ | 1.36523001341410 (sympy, mpmath); only real root | Confirmed |
| 14 | Case 1 | "bracket width halves each step" | Widths 1.5, 0.75, ..., 0.000732421875 | Confirmed |
| 15 | Case 1 | $\lvert c_k - x^*\rvert \le (b_0 - a_0)/2^k$, shrinking monotonically | Holds for k = 1..12 (section 3) | Confirmed |
| 16 | Case 1 | Midpoints "not monotone and fall on both sides of the root" | Sides L L R R L R R L L L R L | Confirmed |
| 17 | Case 1 alt | Bracket narrows around the root at $x \approx 1.3652$ over 12 steps | Final bracket [1.364990234375, 1.36572265625] contains $x^*$ | Confirmed |
| 18 | Case 1 alt | Lower panel zoomed on each halving | Frames; dump | Confirmed |
| 19 | Case 1 | Link and embed | `bisectionaa.jl`, `bisectionaa.gif`; regenerated GIF byte-identical | Confirmed |
| 20 | Case 2 heading | Spurious convergence, $\tan x$, $[0, 2]$ | Script lines 18-19; title | Confirmed |
| 21 | Case 2 | $f(0) = 0$, a genuine root at the left end | Direct | Confirmed |
| 22 | Case 2 | $c_1 = 1$ | Dump, independent | Confirmed |
| 23 | Case 2 | "$f(0)f(1) = 0$ is not negative, bisection keeps $[1, 2]$" | True for the script and Mathews' rule; depends on the tie rule | Confirmed; see F1 |
| 24 | Case 2 | $f(1) > 0$, $f(2) < 0$ | 1.5574077, −2.1850399 | Confirmed |
| 25 | Case 2 | Sign change caused by asymptote at $\pi/2 \approx 1.5708$ | π/2 = 1.570796327; π/2 lies in every kept bracket | Confirmed |
| 26 | Case 2 | "$\tan$ has no zero in $[1, 2]$" | Zeros at $k\pi$; none in range | Confirmed |
| 27 | Case 2 | "Bisection converges to the asymptote" | $\lvert c_{12} - \pi/2\rvert = 4.45 \times 10^{-6}$; $\lvert\tan c_k\rvert$ grows to 224,494 | Confirmed |
| 28 | Case 2 | Illustrates that the IVT guarantee requires continuity | $[1, 2]$ has opposite signs, a discontinuity and no root | Confirmed |
| 29 | Case 2 alt | First step leaves the root at 0, then converges to the asymptote | Dump; frames | Confirmed |
| 30 | Case 2 | Link and embed | `bisectionbb.jl`, `bisectionbb.gif`; regenerated GIF byte-identical | Confirmed |
| 31 | Page | Two cases | Two scripts, two GIFs | Confirmed |

### 3. Implementation checks

Method for both scripts: scratch copies were instrumented to dump every plotted series, title and axis limit per frame (`review/inst/dump_aa.txt`, `dump_bb.txt`). The instrumented copies still produce GIFs byte-identical to the committed ones. `review/indep.py` recomputes each case in exact rational arithmetic (tan with 60-digit mpmath), and `review/verify.py` compares all 13 frames. **Mismatches: 0 for both scripts**, covering brackets in both panels, zoom windows, zoom titles (step and width), legend $c_k$ labels, and plotted midpoint heights.

### `bisectionaa.jl`

- **Method:** True bisection, with a fixed 12 steps and the update `f(a)f(c) < 0 → b = c, else a = c`.
- **Numbers:** Script and independent values agree exactly.
- **Reference:** $x^* = 1.36523001341410$, residual 0 at 20 digits.
- **Picture:** Frames 1 to 13 viewed. The function, bracket, midpoint and drop line are built from the right quantities.
- **Archive:** Example 3, same $f$ and interval. The legacy GIF's $I_{10} = \{1.36426, 1.36719\}$, $p_{10} = 1.36572$ matches the script's bracket before step 11 and $c_{11}$ (legacy indexing starts at 0).

| k | c_k (script = independent) | f(c_k) | Side | \|c_k − x*\| | Bound 3/2^k |
|---|---|---|---|---|---|
| 1 | 0.5 | −8.875 | L | 0.86523 | 1.5 |
| 2 | 1.25 | −1.796875 | L | 0.11523 | 0.75 |
| 3 | 1.625 | 4.853516 | R | 0.25977 | 0.375 |
| 4 | 1.4375 | 1.236084 | R | 0.07227 | 0.1875 |
| 5 | 1.34375 | −0.350983 | L | 0.02148 | 0.09375 |
| 6 | 1.390625 | 0.424595 | R | 0.025395 | 0.046875 |
| 7 | 1.3671875 | 0.032356 | R | 0.00195749 | 0.0234375 |
| 8 | 1.35546875 | −0.160421 | L | 0.00976126 | 0.01171875 |
| 9 | 1.361328125 | −0.06431 | L | 0.00390189 | 0.005859375 |
| 10 | 1.3642578125 | −0.016047 | L | 0.000972201 | 0.0029296875 |
| 11 | 1.36572265625 | 0.008137 | R | 0.000492643 | 0.00146484375 |
| 12 | 1.364990234375 | −0.003959 | L | 0.000239779 | 0.000732421875 |

### `bisectionbb.jl`

- **Method:** The same bisection with the same strict test (see F1).
- **Numbers:** Script and independent values agree exactly.
- **Reference:** The asymptote is drawn at π/2. Mathews' Example 4 table (rows k = 0..7, `table_ex4.png`) matches the script's $c_1$ to $c_8$ and their tan values to the digits printed.
- **Picture:** Frames 1 to 13 viewed. The top panel clamps as described in section 1. The zoom panel plots true values, and its axis range contains the midpoint in every frame.
- **Archive:** Example 4, same $f$ and interval. The legacy GIF's $I_{10} = \{1.57031, 1.57227\}$, $p_{10} = 1.57129$ matches the bracket before step 11 and $c_{11}$.

| k | c_k (script = independent) | tan(c_k) | Drawn in top panel | \|c_k − π/2\| |
|---|---|---|---|---|
| 1 | 1 | 1.5574077 | true | 0.5708 |
| 2 | 1.5 | 14.10142 | true | 0.070796 |
| 3 | 1.75 | −5.5203799 | true | 0.1792 |
| 4 | 1.625 | −18.430863 | −15 | 0.054204 |
| 5 | 1.5625 | 120.53251 | +15 | 0.0082963 |
| 6 | 1.59375 | −43.55836 | −15 | 0.022954 |
| 7 | 1.578125 | −136.4479 | −15 | 0.0073287 |
| 8 | 1.5703125 | 2066.8552 | +15 | 0.00048383 |
| 9 | 1.57421875 | −292.18949 | −15 | 0.0034224 |
| 10 | 1.572265625 | −680.59654 | −15 | 0.0014693 |
| 11 | 1.5712890625 | −2029.4854 | −15 | 0.00049274 |
| 12 | 1.57080078125 | −224494.35 | −15 | 0.0000044545 |

### Legacy archive

Consulted: `BisectionMod.html`, `lnk_2` to `lnk_5`, the formula and graph images for Examples 3 and 4, the three subroutine images, and both legacy animated GIFs. No fidelity finding. The page uses 12 steps where the legacy animations run to about 20; the page makes no claim that depends on the extra steps.

### Could not determine

Nothing on the page was left undetermined.

