# Fixed Point Iteration — animation review (round 3)

Page: `pages/numerical-methods/fixed-point-iteration/`. Reported findings: **0 Error, 0 Misleading, 2 Minor**.

## Findings

### F1 — Page match, Minor: the convergence criterion in the introduction is stated as if it were global

- **Location:** `index.qmd`, Animations introduction: "Convergence occurs when $|g'(x^*)| < 1$."
- **What is there now:** an unconditional statement.
- **What is true instead:** $|g'(x^*)| < 1$ (with $g'$ continuous) guarantees convergence only for $x_0$ close enough to $x^*$. It is a local, sufficient condition. The page's own Case 5 is a counterexample to the global reading. $x = 0$ is a fixed point of $g(x) = x^2/4 + x/2$ with $g'(0) = 1/2 < 1$, but from $x_0 = 2.03$ the iteration does not converge: $x_{10} = 5.3986$, $x_{12} = 29.921$, $x_{14} = 14373.03$. The sentence also says nothing about $|g'(x^*)| > 1$, which three of the six cases illustrate.
- **How I know:** `python3 -I checks.py` printed `ee x9,x10,x12,x14 ['3.753371', '5.3986339', '29.921011', '14373.031']`. In `indep.py`, the numerical derivative gives `g'(0) = 1/2`. Analytically, $g(x) - x = x(x-2)/4 > 0$ for $x > 2$, so the orbit from 2.03 increases without bound.
- **Why only Minor:** Cases 4 and 5 show the local nature immediately below, and each case's Behavior paragraph applies the criterion at the right fixed point.
- **Suggested correction:** "If $|g'(x^*)| < 1$, the iteration converges to $x^*$ for every starting value close enough to $x^*$. If $|g'(x^*)| > 1$, iterates near $x^*$ (other than $x^*$ itself) move away from it."

- **Independent check:** not run (Minor finding, unverified)

### F2 — Fidelity, Minor: Cases 2 and 3 change Mathews' starting value with no reason given

- **Location:** `index.qmd`, Case 2 heading "$x_0 = 3.8$" (`fixpointbb.jl` line 11, `x0 = 3.8`), and Case 3 heading "$x_0 = 1.0$" (`fixpointcc.jl` line 12, `x0 = 1.0`).
- **What is there now:** $x_0 = 3.8$ for $g(x) = \sqrt{2x}$, and $x_0 = 1.0$ for $g(x) = 8/(x+2)$.
- **What the archive has:** in both Example 5 (Monotone Decreasing, $\sqrt{2x}$) and Example 6 (Spiral, $8/(x+2)$), Mathews uses $p_0 = 4.0$. The formula images `FixedPointMod_gr_272.gif` and `_313.gif` (see `review/eqs.png`) show this, and so does the solution cell `p0 = 4.0` in `FixedPointMod_gr_273.gif`. The legacy animation `Fixpointcc.gif` ends at "p9 = 1.99707", which equals $x_9$ from $x_0 = 4$: my `checks.py` gives `1.9971`. From $x_0 = 1.0$ the value is $x_9 = 2.0023$.
- **Consequence:** small. The behaviour each case demonstrates is the same with either starting value: monotone descent for Case 2, and alternating convergence for Case 3. $x_0 = 4.0$ also stays inside the page's [0, 4] window. For Case 3, though, the reader is not shown Mathews' example, which starts above $x^*$ rather than below it, and is not told it was changed.
- **Suggested correction:** either use $x_0 = 4.0$ in both scripts (the window already contains the whole orbit: from 4.0 the iterates are 2.828, 2.378, … and 1.333, 2.4, 1.818, …), or add a sentence to each Behavior paragraph saying the starting value differs from Mathews' $p_0 = 4.0$ and why.

- **Independent check:** not run (Minor finding, unverified)


## Reviewer's notes (not findings)


**2 findings: 0 Error, 0 Misleading, 2 Minor.**


#### Checked and not reported

- The page has no `## Description` section, which the authoring conventions require. The review standard counts that as content the page does not yet have, so it is not a finding. Because no Description exists, there are no method formulas to check beyond the introduction's description of the cobweb construction.
- The page's `fixpointdd` and `fixpointee` are Mathews' `Fixpointee` (Example 8, $p_0 = 1.95$) and `Fixpointdd` (Example 7, $p_0 = 2.03$) in swapped order. The script headers cite the right example numbers, and a reader is not affected.
- Mathews titles Example 9 "Divergence: Spiral" and his animation stops at $p_{10}$ in a [0, 4] window. The page widens the window to [−4.5, 4.5], runs 32 iterations and reports the attracting 4-cycle. This departure makes the page mathematically correct (see Case 6 checks), so it is not a finding.
- Mathews' Examples 1–3 ($g = 1 + x - x^2/3$ and $1 + x - x^2/4$) are Mathematica exercises with no legacy animation. All six legacy animations are represented on the page.
- Cosmetic issues that do not mislead: `fixpointaa`'s title omits $x_0$ while the other titles include it; `fixpointaa`'s frame-0 legend reads "x₀" while later frames read "x_1" and so on (GR renders the underscore literally); and Case 3 calls a spiral a "staircase".

---

## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `fixpointaa.jl` | 0 | 8.7 | fixpointaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `fixpointbb.jl` | 0 | 7.0 | fixpointbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `fixpointcc.jl` | 0 | 7.5 | fixpointcc.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `fixpointdd.jl` | 0 | 6.5 | fixpointdd.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `fixpointee.jl` | 0 | 6.4 | fixpointee.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `fixpointff.jl` | 0 | 8.3 | fixpointff.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

Verdicts: C = confirmed, W = wrong, ? = could not determine.

### Introduction

| # | Claim (page wording) | Evidence | Verdict |
|---|---|---|---|
| I1 | "Each animation below shows the cobweb (staircase) diagram" | All six scripts build the same cobweb path; frames confirm | C |
| I2 | "plots two curves — the identity line $y=x$ and … $y=g(x)$" | Green `y = x` and magenta `y = g(x)` in every script and frame | C |
| I3 | "from the current iterate $x_n$ on the diagonal, vertical to the curve to get $g(x_n)=x_{n+1}$, then horizontal back to the diagonal" | Path vertices are `(x_n,x_n)→(x_n,x_{n+1})→(x_{n+1},x_{n+1})`; instrumented check "cobweb vertices consistent: true" for all six | C |
| I4 | "Convergence occurs when $\lvert g'(x^*)\rvert < 1$" | True only locally; Case 5 orbit from 2.03 diverges although $g'(0)=1/2$ | C as a local criterion; unconditional wording is F1 |
| I5 | "Julia source scripts … are linked under each case" | Six links, each to the script with that case's parameters | C |

### Case 1: $g(x)=\sqrt{2x}$, $x_0=0.1$ (`fixpointaa`)

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| 1a | Heading: $g(x)=\sqrt{2x}$, $x_0=0.1$ | Script lines 10–11 | C |
| 1b | "Convergent staircase" | Orbit 0.1 → 1.99854 by $x_{12}$; error ratio 0.5002 | C |
| 1c | "intersects $y=x$ at $x^*=2$" | $\sqrt{4}=2$ | C |
| 1d | "$g'(2)=\tfrac12<1$" | mpmath derivative 0.5 | C |
| 1e | "converges from below in a monotone staircase" | Strictly increasing, all iterates < 2 (`checks.py`: `aa increasing True`) | C |
| 1f | Alt: "convergent … starting below the fixed point at x₀ = 0.1" | Frames 1 and 13 | C |
| 1g | Link and embed point at `fixpointaa.jl` / `fixpointaa.gif` | qmd; manifest byte-identical regen | C |

### Case 2: $g(x)=\sqrt{2x}$, $x_0=3.8$ (`fixpointbb`)

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| 2a | Heading parameters | Script lines 10–11 | C (differs from Mathews' 4.0: F2) |
| 2b | "starting above the fixed point" | 3.8 > 2 | C |
| 2c | "descends monotonically to $x^*=2$" | Strictly decreasing to 2.000313 by $x_{12}$; error ratio 0.49996 | C |
| 2d | "confirming convergence from both sides" | Case 1 converges from below and Case 2 from above | C |
| 2e | Alt text | Frames match | C |
| 2f | Wiring | `fixpointbb.jl` / `.gif` | C |

### Case 3: $g(x)=8/(x+2)$, $x_0=1.0$ (`fixpointcc`)

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| 3a | Heading parameters | Script lines 11–12 | C (differs from Mathews' 4.0: F2) |
| 3b | "strictly decreasing" | $g'<0$ for $x>-2$ (the whole window) | C |
| 3c | "$g'(x)=-8/(x+2)^2$, $g'(2)=-\tfrac12$" | mpmath −0.5 | C |
| 3d | "$\lvert g'(2)\rvert=\tfrac12<1$, iteration converges" | $x_{12}=1.999707$; error ratio −0.49993 | C |
| 3e | "alternates sides of $x^*$ on each step" | `cc alternates True` | C |
| 3f | Alt: "oscillating convergent" | Frames show a shrinking spiral | C |
| 3g | Wiring | `fixpointcc.jl` / `.gif` | C |

### Case 4: $g(x)=x^2/4+x/2$, $x_0=1.95$ (`fixpointdd`)

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| 4a | Heading parameters | Script lines 11–12 | C |
| 4b | "crosses $y=x$ at $x^*=2$ (and again at $x=0$)" | $x^2/4-x/2=0 \Rightarrow x\in\{0,2\}$ | C |
| 4c | "lies below the diagonal for $0<x<2$" | $g(x)-x=x(x-2)/4<0$ there | C |
| 4d | "$g'(2)=\tfrac32>1$" | mpmath 1.5 | C |
| 4e | "walks away from $x^*=2$ toward the left" | 1.95 → 1.9256 → 1.8898 … | C |
| 4f | "converges monotonically to … $x=0$" | Strictly decreasing to $x_{16}=0.019332$; $x_{16}/x_{15}=0.509$; the analytic argument holds (decreasing and bounded below by 0, so the limit is the fixed point 0) | C |
| 4g | "$g'(0)=\tfrac12$" | $g'(x)=x/2+1/2$ | C |
| 4h | Heading: "Repelled from $x^*=2$, converges to $x=0$" | As in 4e and 4f | C |
| 4i | Alt: "walks left and converges to the fixed point x = 0" | Last frame shows $x_{16}=0.0193$ at the origin | C |
| 4j | Wiring | `fixpointdd.jl` / `.gif` | C |

### Case 5: $g(x)=x^2/4+x/2$, $x_0=2.03$ (`fixpointee`)

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| 5a | Heading parameters, "Divergent" | Script lines 12–13; orbit unbounded | C |
| 5b | "moves monotonically rightward and diverges" | `ee increasing True`; $x_{16}=6.67\times10^{14}$ | C |
| 5c | "showing instability from both sides" | Case 4 leaves 2 from below and Case 5 from above | C |
| 5d | "The animation stops at $x_9\approx3.753$" | Script `n_iters = 9`; 10 frames; last legend "x_9 = 3.7534"; mpmath 3.753371 | C |
| 5e | "the last iterate inside the window" | $x_{10}=5.3986>4$ | C |
| 5f | "$x_{12}\approx29.92$" | 29.921011 | C |
| 5g | "$x_{14}\approx1.437\times10^4$" | 14373.03 | C |
| 5h | Alt: "reaches x₉ ≈ 3.753 at the right of the window" | Frame 10 | C |
| 5i | Wiring | `fixpointee.jl` / `.gif` | C |

### Case 6: $g(x)=-x^2/4-x/2+4$, $x_0=1.97$ (`fixpointff`)

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| 6a | Heading parameters | Script lines 12–13 | C |
| 6b | "Oscillating, does not converge" | The sequence has no limit; it approaches a 4-cycle | C |
| 6c | "steeply decreasing at $x^*=2$" | $g'(2)=-1.5$ | C |
| 6d | "$g'(2)=-\tfrac32$, $\lvert g'(2)\rvert=\tfrac32>1$" | mpmath −1.5 | C |
| 6e | "moves away from $x^*=2$" | $\lvert x_n-2\rvert$: 0.03, 0.045, 0.068, 0.100, 0.153, … | C |
| 6f | "alternating sides at every step" | `ff alternates around 2: True` for all 32 steps. Analytically, $g(x)>2 \iff -4<x<2$, and the orbit stays in [−2.64, 4.25] | C |
| 6g | "settles onto a stable 4-cycle" | Real roots of $g^4-x$ include the cycle {4.249962, −2.640524, 3.577170, −0.987621}; multiplier $\prod g'=-0.0305$ (attracting) | C |
| 6h | "(≈ 4.25, −2.64, 3.58, −0.99)" | 4.24996, −2.64052, 3.57717, −0.98762, in this orbit order | C |
| 6i | Alt: "settles onto a 4-cycle" | $x_{29..32}$ are within 0.00066, 0.0017, 0.0014 and 0.0033 of the cycle | C |
| 6j | Wiring | `fixpointff.jl` / `.gif` | C |

### What the diagrams show (every case)

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| D1 | The red marker is the current iterate $x_n$ on the diagonal, with its value in the legend | Legend values in the sampled frames equal my rounded values (for example aa x_12 = 1.9985, cc x_12 = 1.9997, dd x_16 = 0.0193, ee x_9 = 3.7534, ff x_32 = −0.9909) | C |
| D2 | Each frame adds one vertical and one horizontal segment | `n_pts = 1 + 2*frame` | C |
| D3 | No off-scale or clamped markers are shown misleadingly | Every iterate in every case lies inside its window (instrumented check "all in window: true"), so the off-scale branch never runs | C |

---

### 3. Implementation checks (per script)

All six scripts implement plain fixed-point iteration $x_{n+1}=g(x_n)$ in Float64 and draw the standard cobweb. No variant, relaxation or safeguard is involved. None of the cases has a separate "true" reference value. The reference quantities are the fixed points and the derivatives quoted in comments and on the page, and I checked those analytically and with mpmath.

### `fixpointaa.jl`: $\sqrt{2x}$, $x_0=0.1$, 12 iterations, 13 frames

- **Method:** correct; lines 18–22 iterate `xs[i+1] = g(xs[i])`.
- **Numbers:** the script gives 0.1, 0.44721, 0.94574, 1.37531, 1.65850, 1.82126, 1.90854, 1.95374, 1.97673, 1.98833, 1.99416, 1.99708, 1.99854. mpmath gives the same to every printed digit; for example $x_{12}$ is 1.9985377748870 (script) and 1.9985378 (mpmath).
- **Reference values:** $x^*=2$ and $g'(2)=1/2$ are confirmed.
- **Picture:** the cobweb vertices lie on $g$ and on $y=x$ (checked). Frames 1, 3, 5, 7, 9, 11 and 13 show a rising staircase to (2, 2), and the legend values match.

### `fixpointbb.jl`: $\sqrt{2x}$, $x_0=3.8$, 12 iterations, 13 frames

- **Method:** correct.
- **Numbers:** the script gives 3.8, 2.75681, 2.34811, 2.16708, 2.08186, 2.04052, 2.02016, 2.01005, 2.00502, 2.00251, 2.00125, 2.00063, 2.00031, identical to mpmath at display precision. The error ratio is 0.49996, which equals $g'(2)$.
- **Reference values:** as for Case 1.
- **Picture:** a descending staircase, correct; the legend values match.

### `fixpointcc.jl`: $8/(x+2)$, $x_0=1.0$, 12 iterations, 13 frames

- **Method:** correct.
- **Numbers:** the script gives 1.0, 2.66667, 1.71429, 2.15385, 1.92593, 2.03774, 1.98131, 2.00939, 1.99532, 2.00234, 1.99883, 2.00059, 1.99971, identical to mpmath (exact values 8/3, 12/7, 28/13, … agree). The error ratio is −0.49993.
- **Reference values:** $g(2)=2$ and $g'(2)=-1/2$ are confirmed, and so is the header's "8/16 = 0.5".
- **Picture:** a shrinking rectangular spiral around (2, 2); the legend values match.

### `fixpointdd.jl`: $x^2/4+x/2$, $x_0=1.95$, 16 iterations, 17 frames

- **Method:** correct.
- **Numbers:** the script gives 1.95, 1.925625, 1.88982, 1.83777, 1.76323, 1.65886, 1.51738, 1.33430, 1.11224, 0.86539, 0.61992, 0.40604, 0.24423, 0.13703, 0.07321, 0.03794, 0.019332, identical to mpmath. The header comment "x_16 = 0.0193" is confirmed.
- **Reference values:** fixed points 0 and 2, $g'(2)=3/2$ and $g'(0)=1/2$ are confirmed.
- **Picture:** the staircase descends between the curve and the diagonal to the origin. All iterates lie in [0, 4], so the clamping branch is unused. Frames 1, 5, 9, 13 and 17 checked.

### `fixpointee.jl`: $x^2/4+x/2$, $x_0=2.03$, 9 iterations, 10 frames

- **Method:** correct.
- **Numbers:** the script gives 2.03, 2.045225, 2.06835, 2.10369, 2.15822, 2.24360, 2.38023, 2.60649, 3.00169, 3.75337. mpmath agrees and continues with $x_{10}=5.39863$, $x_{12}=29.9210$, $x_{14}=14373.03$, $x_{16}=6.67\times10^{14}$. The header's "x_10 = 5.3986" is confirmed.
- **Reference values:** as for Case 4.
- **Picture:** a rising staircase, with the last vertical segment reaching (3.0017, 3.7534) and then the marker at (3.7534, 3.7534). Nothing is clipped or clamped. All ten frames are on the contact sheet and match.

### `fixpointff.jl`: $-x^2/4-x/2+4$, $x_0=1.97$, 32 iterations, 33 frames, window [−4.5, 4.5]²

- **Method:** correct.
- **Numbers:** all 33 script iterates equal mpmath at display precision. Examples: $x_{10}=0.173572$, $x_{12}=-1.766430$, $x_{29}=4.249300$, $x_{30}=-2.638787$, $x_{31}=3.578594$, $x_{32}=-0.990881$ (script), against 0.17357177, −1.7664298, 4.2492998, −2.6387871, 3.5785942, −0.99088119 (mpmath).
- **Reference values:**
  - $g(2)=2$ and $g'(2)=-3/2$ are confirmed.
  - Factorisation: $g(g(x))-x=-(x-4)(x-2)(x+2)(x+8)/64$, so there is a 2-cycle {4, −2} with multiplier −1.25, which is repelling.
  - The real roots of $g^4-x$ give the 4-cycle {4.249962, −2.640524, 3.577170, −0.987621} with multiplier −0.0305, which is attracting.
  - Header line 14, "within 0.004 of the 4-cycle", is confirmed: the largest distance is 0.00326.
  - Header lines 16–19: $g(4.5)=-53/16=-3.3125$ is the minimum of $g$ on the window, and the orbit range is [−2.6388, 4.2500]. Both are confirmed.
- **Picture:**
  - The cobweb vertices are consistent, and the orbit lies entirely inside the window, so nothing is clamped.
  - In the last frame (`frame_033.png`), the legend "x_32 = -0.9909" sits at bottom right without covering the orbit.
  - The outer loop of the cobweb is the 4-cycle. The inner transient spiral around (2, 2) stays visible. This is correct, though busy.

