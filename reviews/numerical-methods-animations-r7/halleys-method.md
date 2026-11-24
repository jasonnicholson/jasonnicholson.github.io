# Halley's Method — animation review (round 7)

Page: `pages/numerical-methods/halleys-method/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1. Timing claim holds for only one of the two displayed Halley formulas

- **Kind:** Page match
- **Severity:** Minor
- **Location:** `index.qmd` line 40: "Computing $\sqrt{2}$ from $x_0 = 2$ to 20,000 digits at fixed working precision with the formulas above, for example, Halley needs 10 iterations against Newton's 15 but takes about as long or slightly longer."
- **What is there now:** "the formulas above" covers both Halley forms the page displays (line 18, one division; line 22, three divisions as written). Newton's formula is not displayed on the page at all, so those two are the only formulas the phrase can literally point at.
- **What is true:** The iteration counts (10 and 15) are right for both forms. The timing is right only for the line 18 form. The line 22 form, evaluated as written, takes about 1.8 to 1.9 times as long as Newton.
- **Evidence:** `julia review/timing2.jl` (MPFR, 66,503 bits, 200 shuffled repetitions, run twice) and `python3 -I review/timing.py` (mpmath, Python-integer backend, 20,020 digits):

| Method | Iterations | Julia run 1 (ms, ratio) | Julia run 2 (ms, ratio) | mpmath (ms, ratio) |
|---|---|---|---|---|
| Newton | 15 | 6.173 (1.000) | 5.956 (1.000) | 64.86 (1.000) |
| Halley, line 18 form | 10 | 6.239 (1.011) | 5.967 (1.002) | 66.03 (1.018) |
| Halley, line 22 form | 10 | 11.764 (1.906) | 11.093 (1.863) | 115.36 (1.779) |

  Absolute times are specific to this machine; the ratios are what matters.
- **Suggested correction:** Replace "with the formulas above" with "with the first formula above", and optionally add: "(the second form, evaluated as written, does two more divisions per step and takes nearly twice as long)".

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `halleysaa.jl` | 0 | 7.8 | halleysaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `halleysab.jl` | 0 | 7.1 | halleysab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `halleysba.jl` | 0 | 7.2 | halleysba.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `halleysaa.gif` | 7 | byte-identical | halleysaa |
| `halleysab.gif` | 5 | byte-identical | halleysab |
| `halleysba.gif` | 6 | byte-identical | halleysba |

### Page references

- Scripts linked: `halleysaa.jl`, `halleysab.jl`, `halleysba.jl`
- GIFs embedded: 3
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

Verdicts: **C** confirmed, **W** wrong, **?** could not determine. History and attribution are excluded as the brief directs.

### Description

| # | Line | Claim | Verdict | Evidence |
|---|---|---|---|---|
| 1 | 12 | Newton takes the $x$-intercept of the tangent | C | `halleysaa.jl` line 49; residual at root ≤ 2.2e-16 in every frame |
| 2 | 12 | Hyperbola $y=\frac{a+b(x-x_n)}{1+c(x-x_n)}$ matches $f,f',f''$ at $x_n$ | C | sympy: all three differences simplify to 0 |
| 3 | 12 | Its $x$-intercept is $x_{n+1}$ | C | sympy: root minus Halley step = 0 |
| 4 | 12 | The Taylor parabola's root gives a different iteration | C | From $x_0=2$ on $x^2-2$: parabola root 1.4142136, Halley 1.4285714 |
| 5 | 12, 28 | Cubic convergence at simple roots; digits roughly triple | C | $e_{n+1}/e_n^3 \to 0.125$ (Case 1), $0.3333$ (Case 2) |
| 6 | 12 | Newton roughly doubles digits | C | Case 1a digits 1.07, 2.61, 5.67, 11.8, 24.05, 48.54 |
| 7 | 18 | Iteration formula | C | Matches sympy derivation from the hyperbola |
| 8 | 22 | Rewritten form equals line 18 | C | sympy difference = 0 |
| 9 | 24 | Correction factor near 1 close to a simple root | C | $f\to0$ with $f'\ne0$, so $ff''/(2f'^2)\to0$ |
| 10 | 30, 34 | Error law and constant $C$ | C | Series of $g$: $e^3$ coefficient $=(B^2-AC)/A^2$, the negative of the page's inner expression; numeric limits equal page $C$ for both examples (1/8, 1/3) |
| 11 | 36 | Multiple root: linear convergence | C | Ratios 0.3333, 0.5, 0.6 for $m=2,3,4$, equal to $(m-1)/(m+1)$; Newton 0.5 at $m=2$ |
| 12 | 40 | Three evaluations against two | C | Formula inspection |
| 13 | 40 | $\log2/\log3\approx0.63$ | C | 0.63093 |
| 14 | 40 | $3^{1/3}\approx1.442$, $2^{1/2}\approx1.414$ | C | 1.44225, 1.41421 |
| 15 | 40 | 20,000 digits: Halley 10 iterations, Newton 15 | C | Julia BigFloat and mpmath, stopping at $|e|<10^{-20000}$ |
| 16 | 40 | Halley "takes about as long or slightly longer" "with the formulas above" | **W in part** | True for line 18 form (1.00 to 1.02); line 22 form 1.78 to 1.91. See F1 |

### Animations introduction

| # | Line | Claim | Verdict | Evidence |
|---|---|---|---|---|
| 17 | 44 | Case 1a shows the tangent construction alone, blue dashed | C | `halleysaa.jl` line 52; frames 1 and 2 |
| 18 | 44 | Cases 1b, 2 mark the current iterate on the curve | C | Red circle at $(x_n,f(x_n))$; frames viewed |
| 19 | 44 | Tangent is blue dotted and shows the Newton jump | C | Lines 64 (ab), 65 (ba); Newton marker equals tangent root |
| 20 | 44 | Orange dashed hyperbola crosses the axis at $x_{n+1}$ | C | $|H(x_{n+1})|\le 4\times10^{-16}$ in every frame of both scripts |
| 21 | 46 | Source linked under each case | C | Lines 55, 63, 71 |
| 22 | 48 | Cases follow Mathews Examples 1(a), 1(b), 2(b) | C | Archive gr_61, gr_63, gr_175, gr_177, gr_67, gr_128, gr_243, gr_251 |
| 23 | 49 | Example 2(a) is Newton on the same function and start, and is not animated | C | Archive lnk_4, gr_181, gr_189; no Newton-only Case 2 script |
| 24 | 49 | Case 2's blue diamond is the Newton step from the current Halley iterate | C | `halleysba.jl` line 79 |

### Case 1a

| # | Line | Claim | Verdict | Evidence |
|---|---|---|---|---|
| 25 | 51 | $f=x^2-2$, $x_0=2$, Newton | C | Lines 10, 13, 28 |
| 26 | 53 | Quadratic convergence to $\sqrt2\approx1.41421$ | C | $e_{n+1}/e_n^2\to0.35355=1/(2\sqrt2)$ |
| 27 | 53 | $x_1=1.5$, $x_2\approx1.4167$, $x_3\approx1.4142$ | C | 1.5, 1.41666667, 1.41421569 |
| 28 | 57 | Alt text: each frame advances one tangent step | C | 7 frames, $x_0$ to $x_6$ |

### Case 1b

| # | Line | Claim | Verdict | Evidence |
|---|---|---|---|---|
| 29 | 59 | $f=x^2-2$, $x_0=2$, Halley | C | Lines 10 to 14, 32 |
| 30 | 61 | Orange is Halley, blue is Newton | C | Lines 82, 86; frames 1, 2 |
| 31 | 61 | $x_1\approx1.42857$ against Newton's 1.5 | C | 10/7 = 1.4285714 |
| 32 | 61 | About 1.8, 6.4, 20 digits after steps 1 to 3 | C | 1.843, 6.438, 20.22 (200-digit arithmetic) |
| 33 | 61 | $|g'''(x^*)|/3!$ governs rather than $|g''(x^*)|/2!$ | C | $g=x(x^2+6)/(3x^2+2)$: $g'(\sqrt2)=g''(\sqrt2)=0$, $g'''/6=1/8$; Newton's $g''/2=\sqrt2/4$ |
| 34 | 65 | Alt text: hyperbola, tangent, both next iterates marked | C | All frames except the last, which has no next iterate |

### Case 2

| # | Line | Claim | Verdict | Evidence |
|---|---|---|---|---|
| 35 | 67 | $f=x^3-3x+2$, $x_0=-2.2$, Halley | C | Lines 11, 15, 33 |
| 36 | 69 | $f=(x+2)(x-1)^2$; simple root $-2$, double root $1$ | C | sympy factor |
| 37 | 69 | Halley converges cubically | C | $e_{n+1}/e_n^3$: 0.2577, 0.3324, 0.3333; page $C=1/3$ |
| 38 | 69 | $x_1\approx-2.002$ Halley, $-2.022$ Newton | C | $-2.002061856$, $-2.022222222$ |
| 39 | 69 | Newton errors $2.2\times10^{-2}$, $3.2\times10^{-4}$, $6.9\times10^{-8}$, $3.2\times10^{-15}$ | C | 2.22e-2, 3.22e-4, 6.91e-8, 3.19e-15 |
| 40 | 69 | Halley errors $2.1\times10^{-3}$, $2.9\times10^{-9}$, $8.2\times10^{-27}$ | C | 2.06e-3, 2.91e-9, 8.24629e-27 |
| 41 | 69 | Double precision: Newton first exactly $-2$ at $x_5$, Halley at $x_3$ | C | Julia sequences in `review/extra.jl`; Python agrees |
| 42 | 69 | Neither first step overshoots; both left of the root | C | Both $<-2$ |
| 43 | 69 | Halley lands within 0.0021 | C | 0.002062 |
| 44 | 69 | First-step markers about 0.02 apart and overlapping | C | Gap 0.02016; frame 1 |
| 45 | 69 | Legend gives their values | C | Frame 1: $-2.02222$ and $-2.002062$ |
| 46 | 73 | Alt text: hyperbola, tangent, next iterates, cubic convergence to $-2$ | C | Frames 1 to 5 carry the markers; the last has none |

### Wiring

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 47 | Case 1a link and embed are `halleysaa` | C | Lines 55, 57; script parameters match heading |
| 48 | Case 1b link and embed are `halleysab` | C | Lines 63, 65 |
| 49 | Case 2 link and embed are `halleysba` | C | Lines 71, 73 |
| 50 | Committed GIFs are what the scripts produce | C | `cmp` against the regenerated GIFs: identical for all three |

### Legacy archive (fidelity)

- Functions and starting values match: Example 1 $x^2-2$, $p_0=2$; Example 2 $x^3-3x+2$, $p_0=-11/5=-2.2$.
- The one archive case without an animation, Example 2(a), is disclosed at line 49, so it is not a silent drop.
- The archive's Example 2(b) table code (gr_268) computes its error as $\sqrt2-p_k$, a copy-paste slip since the root is $-2$. The page correctly uses $-2$. No finding.

---

### 3. Implementation checks

### `halleysaa.jl` (Newton, Case 1a)

- **Method:** Plain Newton-Raphson (line 28), as the case heading says.
- **Numbers:** Script against independent 200-digit iteration:

| n | Script | Independent |
|---|---|---|
| 1 | 1.5 | 1.5 |
| 2 | 1.4166666666666667 | 1.4166666666667 |
| 3 | 1.4142156862745099 | 1.4142156862745 |
| 4 | 1.4142135623746899 | 1.4142135623747 |
| 5 | 1.4142135623730951 | 1.4142135623731 |
| 6 | 1.414213562373095 | 1.4142135623731 |

  $x_5$ and $x_6$ are adjacent doubles, which is rounding at the limit and invisible at the displayed precision.
- **Reference:** $\sqrt2$ is not drawn separately; the zero crossing of $x^2-2$ is exact.
- **Picture:** Tangent has slope $f'(x_n)$ through $(x_n,f(x_n))$, and its zero equals the labelled next iterate. Labels carry the correct indices in all 7 frames.

### `halleysab.jl` (Halley, Case 1b)

- **Method:** Halley's rational iteration (line 32), the page's line 18 form, not the irrational variant.
- **Numbers:**

| n | Script | Independent | Error |
|---|---|---|---|
| 1 | 1.4285714285714286 | 1.4285714285714 | 1.436e-2 |
| 2 | 1.4142139267767408 | 1.4142139267767 | 3.644e-7 |
| 3 | 1.414213562373095 | 1.4142135623731 | 6.049e-21 |
| 4 | 1.4142135623730951 | 1.4142135623731 | 2.766e-62 |

  (Errors are from the 200-digit run; the double-precision script cannot resolve those beyond $n=2$.)
- **Hyperbola:** $b_1=-f''/(2f')$, $a_1=f'+fb_1$. Instrumented finite differences give $H-f=0$, $H'-f'\sim10^{-9}$, $H''-f''\le1.2\times10^{-7}$ in all frames. The stored next iterate equals the hyperbola's root.
- **Display devices:** The NaN mask beyond the pole is inactive. Poles lie at 6.0, 4.29, 4.24, 4.24, 4.24, outside the window (1.0, 2.6).

### `halleysba.jl` (Halley, Case 2)

- **Method:** Halley's rational iteration (line 33).
- **Numbers:**

| n | Script | Independent | Error |
|---|---|---|---|
| 1 | -2.002061855670103 | -2.002061856 | 2.06e-3 |
| 2 | -2.0000000029138016 | agrees | 2.91e-9 |
| 3 | -2.0 | agrees | 8.25e-27 |
| 4, 5 | -2.0 | agrees | at double-precision limit |

  Newton marker from $x_1$: script $-2.0000028283$, the correct Newton step from that iterate.
- **Reference:** Root $-2$ confirmed by factorisation.
- **Hyperbola:** Same checks as Case 1b pass. $|H(x_{n+1})|\le4\times10^{-16}$. Poles at $-3.95$ to $-3.50$ are outside the window $(-3, 2.5)$, so the NaN mask is inactive.
- **Display device, not counted as a finding:** Line 65 clamps the tangent to the y-limits, so its off-scale parts run as a faint dotted line along the top and bottom plot borders (visible at bottom left from $x=-3$ to about $-2.5$ in frame 1). It lies on the frame, changes no value and no conclusion. Removing the `clamp.` would leave the line clipped by the axes and remove the artefact.

### Could not determine

- Timing ratios in F1 and ledger entry 16 are measured on this machine with MPFR and mpmath only. Other big-number libraries could shift them, though the line 22 form's two extra full-precision divisions are a structural cost.

