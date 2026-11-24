# Fixed Point Iteration — animation review (round 7)

Page: `pages/numerical-methods/fixed-point-iteration/`. Reported findings: **0 Error, 1 Misleading, 1 Minor**.

## Findings

### F1. Page match, **Misleading**: Case 1 attributes convergence from $x_0 = 0.1$ to the slope at $x^*$

**Location:** `index.qmd`, Case 1 Behavior:

> The curve $g(x) = \sqrt{2x}$ intersects $y = x$ at $x^* = 2$. Since $g'(2) = \tfrac{1}{2} < 1$, iteration converges from below in a monotone staircase.

**What is there now.** The word "Since" presents $g'(2) < 1$ as the reason this orbit converges. The page's own introduction states that criterion only for "every starting value close enough to $x^*$".

**What is true.** The conclusion is right, but the stated reason does not establish it for this start:

- $g'(x) = 1/\sqrt{2x} > 1$ for $0 < x < \tfrac12$. The start and the first iterate both lie in that region: $g'(x_0) = g'(0.1) = 2.2361$ and $g'(x_1) = g'(0.4472) = 1.0574$.
- The legacy solution for this example (Mathews Example 4, images `FixedPointMod_gr_262.gif` and `_263.gif`) gives the contraction region as $|g'(x)| < 1$ for $x \in (\tfrac12, \infty)$, which excludes $x_0 = 0.1$.
- The inference fails on this same page. In Cases 4 and 5, $g'(0) = \tfrac12 < 1$ at the fixed point $x = 0$, yet from $x_0 = 2.03$ the orbit diverges ($x_{14} = 14373.03$).
- The sentence names only $x^* = 2$, while the frames show the curves also meeting at the origin. That second fixed point $x = 0$, with unbounded slope, is why the region near it has $g' > 1$. Case 4 does mention its second intersection.

The actual reason: on $(0, 2)$, $g$ is increasing and $x < g(x) < 2$ (because $x^2 < 2x < 4$), so the iterates increase and are bounded by 2. Their limit is a fixed point greater than 0, which can only be 2.

**How I know.** `/usr/bin/python3 review/extra.py` printed `g' case1 at x0, x1: 2.23606... 1.05737...`. `review/props.py` printed `same-page: |g'(0)|=1/2 yet from 2.03 x_14 = 14373.03`.

**Suggested correction:**

> The curve $g(x) = \sqrt{2x}$ meets $y = x$ at $x = 0$ and at $x^* = 2$. On $(0, 2)$ it is increasing and lies between $y = x$ and $y = 2$, so the iterates climb monotonically to $x^* = 2$, even though $g'(x) > 1$ for $x < \tfrac12$, which includes $x_0 = 0.1$. Near $x^*$ the error is roughly halved at each step, since $g'(2) = \tfrac12$.

The "halved" claim is supported: the error ratios at the end of the run are 0.5007, 0.5004, 0.5002.

- **Independent check:** confirmed. |g'(x)| < 1 only for x > 1/2, and the first two iterates (0.1 and 0.4472) lie below that, with g' = 2.236 and 1.057. The orbit does converge, but g'(2) < 1 does not explain it from this start.

### F2. Implementation (code comment), **Minor**: Case 6 orbit bound is wrong in the third decimal

**Location:** `fixpointff.jl`, lines 16 and 18:

> window holds the whole true orbit (it stays in [-2.639, 4.250]) ... and the orbit's min is -2.639.

**What is there now.** The comment gives $-2.639$ as the minimum of "the whole true orbit".

**What is true.** $-2.6388$ is the minimum only of the 33 iterates drawn ($x_{30} = -2.638787$). The next visit to that branch is below the bound: $x_{34} = -2.64057$, and the 4-cycle point is $-2.640524$. The true orbit's minimum is $-2.64057$.

**Consequence.** None for the picture. The window $[-4.5, 4.5]$ holds the whole orbit, and the legend-placement argument needs only that the minimum exceeds $-3.3125$.

**How I know.** `/usr/bin/python3 review/extra.py` printed `first n with x_n < -2.639: 34 -2.64057` and `min over 0..32 -2.638787 min over 0..300 -2.64057`.

**Suggested correction:** in both places, write `-2.641` (`[-2.641, 4.250]`), or say "the 33 drawn iterates stay in [-2.639, 4.250]".

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `fixpointaa.jl` | 0 | 7.3 | fixpointaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `fixpointbb.jl` | 0 | 5.7 | fixpointbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `fixpointcc.jl` | 0 | 8.7 | fixpointcc.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `fixpointdd.jl` | 0 | 6.3 | fixpointdd.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `fixpointee.jl` | 0 | 6.1 | fixpointee.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `fixpointff.jl` | 0 | 8.7 | fixpointff.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

Verdicts come from my own computation (scripts above) and the extracted frames.

### Introduction

| # | Claim (page's words) | Verdict | Evidence |
|---|---|---|---|
| 1 | Each animation shows the cobweb (staircase) diagram | Confirmed | All six sheets |
| 2 | Plots the identity line $y=x$ and $y=g(x)$ | Confirmed | Code and frames; title and legend function equal the code's `g` in all six |
| 3 | From $x_n$ on the diagonal, vertical to the curve to get $g(x_n)=x_{n+1}$, then horizontal back | Confirmed | `compare.py` checked every vertex: $(x_n,x_{n+1})$ then $(x_{n+1},x_{n+1})$ |
| 4 | $\lvert g'(x^*)\rvert<1$, $g\in C^1$: converges for every start close enough | Confirmed | Standard local contraction (mean value theorem); correctly stated as local |
| 5 | $\lvert g'(x^*)\rvert>1$: iterates near $x^*$ (other than $x^*$) move away | Confirmed | Mean value theorem; matches Cases 4, 5, 6 |
| 6 | Source scripts are linked under each case | Confirmed | Six links, each to the matching script |

### Case 1

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 7 | $g(x)=\sqrt{2x}$, $x_0=0.1$ | Confirmed | `fixpointaa.jl` lines 10–11; title; legend `x₀ = 0.1` |
| 8 | Intersects $y=x$ at $x^*=2$ | Confirmed, incomplete | Fixed points are $\{0, 2\}$; see F1 |
| 9 | $g'(2)=\tfrac12<1$ | Confirmed | sympy |
| 10 | "Since" $g'(2)<1$, iteration converges | **Wrong reasoning, true conclusion (F1)** | $g'(0.1)=2.236$ |
| 11 | Converges from below, monotone staircase | Confirmed | $0.1, 0.4472, \dots, x_{12}=1.998538$; strictly increasing |
| 12 | Alt text: starting below the fixed point at $x_0=0.1$ | Confirmed | Frame 1 |

### Case 2

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 13 | Same function, $x_0=4.0$, above the fixed point | Confirmed | `fixpointbb.jl` lines 10–11 |
| 14 | Descends monotonically to $x^*=2$ | Confirmed | $4, 2.8284, \dots, x_{12}=2.000338$; strictly decreasing |
| 15 | Convergence from both sides | Confirmed | Cases 1 and 2 |
| 16 | Alt text | Confirmed | Frame 1 |

### Case 3

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 17 | $g(x)=8/(x+2)$, $x_0=4.0$ | Confirmed | `fixpointcc.jl` lines 11–12; legacy `gr_312`, `gr_313` |
| 18 | Strictly decreasing | Confirmed on $x>-2$ | $g'<0$; this branch holds the window and every iterate. $g$ is not monotone across its pole at $x=-2$, which is not displayed |
| 19 | $g'(x)=-8/(x+2)^2$, $g'(2)=-\tfrac12$ | Confirmed | sympy |
| 20 | $\lvert g'(2)\rvert=\tfrac12<1$, iteration converges | Confirmed | $g$ maps $[4/3, 4]$ into itself with $\lvert g'\rvert\le 0.72$, so $x_0=4$ is in a contraction interval; $x_{12}=2.000366$ |
| 21 | Alternates sides of $x^*$ on each step | Confirmed | Sign of $x_n-2$ alternates for all 12 steps |
| 22 | Alt text | Confirmed | Frames |

### Case 4

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 23 | $g(x)=x^2/4+x/2$, $x_0=1.95$ | Confirmed | `fixpointdd.jl` lines 11–12 |
| 24 | Crosses $y=x$ at $x^*=2$ and $x=0$ | Confirmed | sympy: $\{0, 2\}$ |
| 25 | Below the diagonal for $0<x<2$ | Confirmed | $g(x)-x=x(x-2)/4<0$ |
| 26 | $g'(2)=\tfrac32>1$ | Confirmed | sympy |
| 27 | Walks away from 2 to the left, converges monotonically to 0 | Confirmed | $1.95, 1.9256, \dots, x_{16}=0.019332$; strictly decreasing |
| 28 | $g'(0)=\tfrac12$ | Confirmed | sympy |
| 29 | Alt text | Confirmed | Frames 1 and 17 |

### Case 5

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 30 | Same function, $x_0=2.03$, above the fixed point | Confirmed | `fixpointee.jl` lines 12–13 |
| 31 | Moves monotonically rightward and diverges | Confirmed | Strictly increasing through $x_{14}=14373.03$; $g(x)>x$ for all $x>2$ |
| 32 | Instability from both sides | Confirmed | Cases 4 and 5 |
| 33 | Stops at $x_9\approx3.753$ | Confirmed | $x_9=3.753371$; last frame legend `x_9 = 3.7534` |
| 34 | $x_9$ is the last iterate inside the window | Confirmed | $x_{10}=5.398634>4$ |
| 35 | $x_{12}\approx29.92$ | Confirmed | $29.92101$ |
| 36 | $x_{14}\approx1.437\times10^4$ | Confirmed | $14373.03$ |
| 37 | Alt text | Confirmed | Frame 10 |

### Case 6

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 38 | $g(x)=-x^2/4-x/2+4$, $x_0=1.97$ | Confirmed | `fixpointff.jl` lines 12–13 |
| 39 | Steeply decreasing at $x^*=2$; $g'(2)=-\tfrac32$; $\lvert g'(2)\rvert>1$ | Confirmed | sympy |
| 40 | Does not converge to $x^*$; moves away | Confirmed | $\lvert x_n-2\rvert$ grows from 0.03 to over 4 |
| 41 | Alternates sides at every step | Confirmed | All 32 steps, and all four cycle points alternate about 2 |
| 42 | Settles onto a stable 4-cycle | Confirmed | Period-4 residual 0; multiplier $-0.0305$; $x_{29..32}$ within 0.0033 |
| 43 | Cycle ≈ 4.25, −2.64, 3.58, −0.99 | Confirmed | $4.249962, -2.640524, 3.577170, -0.987621$, in orbit order |
| 44 | Alt text | Confirmed | Frames 1 and 33 |

### Wiring and counts

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 45 | Each case links its own script and embeds its own GIF | Confirmed | Cases 1–6 map to aa, bb, cc, dd, ee, ff; each GIF's title carries the heading's function |
| 46 | Six cases, six scripts, six GIFs | Confirmed | Manifest and directory listing |
| 47 | GIFs are the output of the scripts | Confirmed | Manifest: all six regenerate byte-identically |

The page has no `## Description` section, so there are no Description formulas to check. The review standard excludes content a page does not yet have.

---

### 3. Implementation checks

### Common to all six scripts

- **Method.** Plain fixed point iteration: `xs[i+1] = g(xs[i])`, with no relaxation, safeguard or stopping rule.
- **Reference values.** No script computes a reference curve or root. The fixed points named in comments and on the page were solved exactly with sympy.
- **Picture.** The cobweb is correctly built from the true iterates (every vertex checked). The marker is at $(x_k, x_k)$, and the legend reports $x_k$ with the matching index. Frame count is `n_iters + 1`.
- **Display devices.** The off-scale marker branch in `dd`, `ee` and `ff` never runs, because every drawn iterate is inside its window (`props.py`). Nothing is clamped in any GIF.

### Script against independent values

`compare.py` used separate 50-digit iteration from the decimal start values.

| Script | $g$, $x_0$ | Iterations | Max relative difference | Script final | Independent final | Cobweb vertices | Frames |
|---|---|---|---|---|---|---|---|
| `aa` | $\sqrt{2x}$, 0.1 | 12 | 5.6e-17 | 1.9985377749 | 1.998538 | Correct | 13 |
| `bb` | $\sqrt{2x}$, 4.0 | 12 | 9.5e-17 | 2.0003384794 | 2.000338 | Correct | 13 |
| `cc` | $8/(x+2)$, 4.0 | 12 | 1.5e-16 | 2.0003662333 | 2.000366 | Correct | 13 |
| `dd` | $x^2/4+x/2$, 1.95 | 16 | 4.7e-16 | 0.0193321599 | 0.01933216 | Correct | 17 |
| `ee` | $x^2/4+x/2$, 2.03 | 9 | 7.0e-15 | 3.7533709825 | 3.753371 | Correct | 10 |
| `ff` | $-x^2/4-x/2+4$, 1.97 | 32 | 1.4e-15 | -0.9908811884 | -0.9908812 | Correct | 33 |

### Rate and stability

- **`aa`, `bb`:** error ratio tends to $g'(2)=\tfrac12$ (`aa` last three: 0.5007, 0.5004, 0.5002; `bb`: 0.4998, 0.4999, 0.5000).
- **`cc`:** ratio tends to $-\tfrac12$ (last three: $-0.5004, -0.4998, -0.5001$).
- **`ff`:** the period-4 factor of $g^4(x)-x$ has exactly four real roots, $\{-2.640524, -0.987621, 3.577170, 4.249962\}$, so this is the only real 4-cycle. Its multiplier is $-0.0305$, so it attracts. The real 2-cycle $\{-2, 4\}$ has multiplier $-1.25$ and repels. The fixed points $2$ and $-8$ have $g'=-\tfrac32$ and $\tfrac72$ and repel.

### Script comments checked

- `dd` line 13 ($x_{16}=0.0193$): confirmed.
- `ee` lines 5 and 14 ($x_9=3.7534$, $x_{10}=5.3986$): confirmed.
- `ff` line 14 ($x_{29..32}$ within 0.004 of the cycle): confirmed, largest distance 0.00326, while $x_{28}$ is 0.0653 away.
- `ff` lines 17–18 (minimum of $g$ on the window is $g(4.5)=-3.3125$): confirmed, exactly $-53/16$.
- `ff` lines 16 and 18 (orbit minimum $-2.639$): **wrong, see F2.**
- Mathews example numbers in the headers of `bb` through `ff`: match the archive.

### Frames viewed

Contact sheets of all six committed GIFs (first, evenly spaced middle, and last frames, except `ff`, whose sheet ends at $x_{30}$), plus full-size `fixpointff/frame_033.png` and `fixpointdd/frame_017.png`. In the `ff` final frame the legend sits below the whole cobweb and does not hide any iterate.

### Fidelity to the legacy archive

| Page case | Legacy example | Legacy GIF | $g$, $p_0$ | Match |
|---|---|---|---|---|
| 1 | Example 4, Convergence: Monotone Increasing | `Fixpointaa` | $\sqrt{2x}$, 0.1 | Yes |
| 2 | Example 5, Convergence: Monotone Decreasing | `Fixpointbb` | $\sqrt{2x}$, 4.0 | Yes |
| 3 | Example 6, Convergence: Spiral | `Fixpointcc` | $8/(x+2)$, 4.0 | Yes |
| 4 | Example 8, Convergence: Monotone Decreasing | `Fixpointee` | $x^2/4+x/2$, 1.95 | Yes |
| 5 | Example 7, Divergence: Monotone Increasing | `Fixpointdd` | $x^2/4+x/2$, 2.03 | Yes |
| 6 | Example 9, Divergence: Spiral | `Fixpointff` | $-x^2/4-x/2+4$, 1.97 | Yes, with a justified change |

Legacy frame values agree with the independent orbits wherever compared (for example `aa` $p_1$ to $p_8$, and `dd`/`ee` values to five decimals).

Departures reviewed, none a finding:

- **Case 6 wording.** Mathews labels this "Divergence: Spiral" and draws it in $[0, 4.05]$. The orbit is actually bounded and leaves that window at $x_{12}=-1.766$. The page's wider window and "does not converge, settles onto a 4-cycle" are mathematically right.
- **Cases 4 and 5 order.** The page's `fixpointdd` is legacy `Fixpointee` and vice versa. The page does not cite legacy animation numbers, so a reader is not affected.
- **Iteration counts** differ from the legacy runs (for example 12 against 20). Each still shows the stated behaviour.
- **Examples 1 to 3** ($g(x)=1+x-x^2/3$) are static worked examples with no legacy animation. All six legacy animations are represented.
- **Legacy image `FixedPointMod_gr_314.gif`** (the Example 6 code cell) is missing from the archive. The function and start value were confirmed from `gr_312`, `gr_313` and the legacy GIF.

### Could not determine

Nothing on the page was left undetermined.

