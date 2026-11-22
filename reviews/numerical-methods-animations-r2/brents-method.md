# Brent's Method — animation review (round 2)

Page: `pages/numerical-methods/brents-method/`. Reported findings: **0 Error, 0 Misleading, 2 Minor**.

## Findings

### F1: The prose description of the IQI step describes a forward parabola, not inverse interpolation
- **Kind:** Page match (method description)
- **Severity:** Minor
- **Location:** `index.qmd` line 16: "**Inverse quadratic interpolation** — fits a quadratic through the three points $(a, f(a))$, $(b, f(b))$, $(c, f(c))$ and uses the $x$-intercept of that quadratic."
- **What is there now:** The sentence most naturally reads as fitting a parabola $y = q(x)$ through the three points and taking its zero. That is a Muller-type step, not IQI.
- **What is true instead:** IQI fits $x$ as a quadratic function of $y$, $x = P(y)$, through the three points and takes $s = P(0)$. The formula on line 32 and the code (lines 69–72 of both scripts) both do this correctly. For the page's own step 3 of Case 1, the two readings give different points:
  - the inverse quadratic (page formula and script): $s = 0.2276058019714996$
  - the forward parabola $y = q(x)$ through the same points, root in the bracket: $0.33387$

  The page's step-3 narrative (the "IQI point $0.2276$" has the larger $|f|$ and becomes the far bracket end) depends on the inverse version.
- **How I know:** `/usr/bin/python3 -I iqi.py` evaluates the line-32 formula at $(a,b,c) = (0.8, 0.4, 0)$ and gets `0.2276058019714996`. `np.polyfit` on the same three points followed by `np.roots` gives `[1.0697, 0.33387]`.
- **Suggested correction:** "fits $x$ as a quadratic function of $y$ through the three points $(a, f(a))$, $(b, f(b))$, $(c, f(c))$ (a sideways parabola) and evaluates it at $y = 0$."

- **Independent check:** not run (Minor finding, unverified)

### F2: Mathews' Example 4 finds all three roots of the cubic, but the page keeps only the first one and does not say so
- **Kind:** Fidelity
- **Severity:** Minor
- **Location:** `index.qmd` line 64 (Case 1 heading) and `brentsaa.jl` lines 12–13. Also the plot window `xlims = (-0.15, 3.1)` on line 17 of `brentsaa.jl`.
- **What is there now:** Case 1 uses $f(x) = 4x^3 - 16x^2 + 17x - 4$ on $[0,1]$ only. The GIF's x-window runs to 3.1, so the other two roots at $x \approx 1.2647$ and $x \approx 2.4068$ are visible but never discussed.
- **What the archive has:** Example 4 ("find the three roots of the cubic") runs `BrentMethod` on $[0,1]$, $[1,2]$ and $[2,3]$ (image gr_223), and compares each run with regula falsi and bisection. Example 5 ($\tan x = 2x$ on $[0.5,1.5]$) is reproduced faithfully: the archive's iterates $p_0$–$p_9$ (gr_276) match the script's to all printed digits. The archive uses tolerance $10^{-15}$ where the page uses $10^{-10}$. That departure is harmless because the page computes its own counts.
- **How I know:** I read the archive text and images listed above. With scipy's `brentq` (`xtol=1e-10`) the other two roots take 8 evaluations ($[1,2]$, root 1.264658290063954) and 11 evaluations ($[2,3]$, root 2.40680325132415).
- **Suggested correction:** Either add one sentence to Case 1 saying that only the root in $[0,1]$ is animated and that the other two roots near 1.2647 and 2.4068 are bracketed by $[1,2]$ and $[2,3]$, or narrow `xlims` so the unexplained roots are not in the picture. Adding the other two brackets as cases would also restore the archive.

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `brentsaa.jl` | 0 | 6.3 | brentsaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `brentsbb.jl` | 0 | 6.6 | brentsbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `brentsaa.gif` | 9 | byte-identical | brentsaa |
| `brentsbb.gif` | 11 | byte-identical | brentsbb |

### Page references

- Scripts linked: `brentsaa.jl`, `brentsbb.jl`
- GIFs embedded: 2
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

Evidence key: **J** = instrumented script output (`julia brentsaa_instr.jl`, `julia brentsbb_instr.jl`); **S** = independent scipy `brentq(xtol=1e-10)` evaluation trace (`indep.py`); **M** = mpmath 40-digit root; **C** = `counts.py`; **F** = frames; **X** = `x9.jl`.

### Description (method claims)
| # | Claim (page words) | Verdict | Evidence |
|---|---|---|---|
| D1 | Requires only that $f$ be continuous with $f(a), f(b)$ of opposite sign; no derivatives | confirmed | The code uses only $f$ values |
| D2 | "fits a quadratic through the three points … uses the x-intercept of that quadratic" | **wrong / ambiguous (F1)** | The forward-parabola reading gives 0.3339; IQI gives 0.2276 |
| D3 | Secant used "when inverse quadratic interpolation cannot be used (only two distinct points, $a = c$)" | confirmed | `brentsaa.jl` line 62 |
| D4 | Bisection is used as a safeguard; the bracket shrinks by at least half | confirmed | A bisection step sets `d = xm`, so the bracket exactly halves |
| D5 | $f(b)f(c) \le 0$, $\lvert f(b)\rvert \le \lvert f(c)\rvert$; $a$ = previous $b$ or coincides with $c$ | confirmed | Lines 42–49 and 94 |
| D6 | IQI Lagrange formula (line 32) | confirmed | The formula reproduces the script's 0.2276058019714996 at step 3 (`iqi.py`) |
| D7 | Accepted only if inside the bracket and making adequate progress, else bisection | confirmed (stated loosely; the precise test is given in D9) | Line 81 |
| D8 | Secant formula $s = b - f(b)(b-a)/(f(b)-f(a))$ | confirmed | Case 1 step 1: $1 - 1\cdot 1/(1-(-4)) = 0.8$; J gives 0.80000000000000004 |
| D9 | Bisection replaces an interpolation step that does not stay within about 3/4 of the way from $b$ to $c$, or that is not smaller than half the step before last | confirmed | Line 81: `2p < 3*xm*q - abs(tol1*q) && p < abs(e*q/2)`; `e` holds the step before last |
| D10 | $x^9$ on $[-1,2]$: Brent needs 96 evaluations to shrink the bracket below $10^{-10}$; bisection needs 37 | confirmed | X: 94 steps + 2 = 96 evaluations, final width 5.0e-11. S: `function_calls = 96`. C: bisection reaches width < 1e-10 after 35 halvings, + 2 endpoint evaluations = 37 |
| D11 | Order ≈ 1.839, the positive root of $t^3 = t^2 + t + 1$ | confirmed | `np.roots` gives 1.83928676 |
| D12 | Cannot fail to converge with a valid bracket and continuous $f$ | confirmed (standard property; consistent with every run) | |
| D13 | Table: bisection order 1, regula falsi linear, secant ≈1.618, IQI ≈1.839, Brent up to ≈1.839 | confirmed | Standard values |

### Animations introduction
| # | Claim | Verdict | Evidence |
|---|---|---|---|
| A1 | Shaded region = current bracket between $b$ and $c$ | confirmed | Lines 118, 134–137; F |
| A2 | Red dot = $b$, the endpoint with the smallest $\lvert f\rvert$ | confirmed | Lines 47–49, 140–143; F |
| A3 | The step annotation names the sub-method (Bisection, Secant, IQI) | confirmed | Lines 120, 145–146; F |
| A4 | "Min step" = a step shorter than the tolerance (≈5e-11), replaced by a step of that length | confirmed | Lines 95–99. `tol1 = 2eps|b| + 5e-11`. Case 2 step 10 leaves width 5.000e-11 (J) |
| A5 | Julia sources linked under each case | confirmed | Lines 68, 76 |

### Case 1: $f(x)=4x^3-16x^2+17x-4$, $[0,1]$
| # | Claim | Verdict | Evidence |
|---|---|---|---|
| C1.1 | The heading's function and interval match the script | confirmed | `brentsaa.jl` lines 10–13; the GIF title matches |
| C1.2 | $f(0) = -4$, $f(1) = 1$ | confirmed | Direct evaluation |
| C1.3 | $x^* \approx 0.3285$ | confirmed | M: 0.3285384586114148960 |
| C1.4 | 8 steps: secant, bisection, IQI, secant, IQI, secant, secant, IQI | confirmed | J labels. S evaluation points identical to J at every step |
| C1.5 | Step 3: the IQI point 0.2276 has larger $\lvert f\rvert$, becomes the other end, and $b$ stays at 0.4 | confirmed | $f(0.2276) = -0.912$ vs $f(0.4) = 0.496$. J step 3: b=0.4, c=0.2276058. F frame 4 shows b = 0.4 |
| C1.6 | After step 2, every step is an interpolation step | confirmed | J |
| C1.7 | Error in $b$ at steps 5–8: 3.2e-4, 5.5e-6, 2.7e-9, 4.0e-19 | confirmed | J b values against M: 3.237e-4, 5.46e-6, 2.738e-9, 3.98e-19 |
| C1.8 | At step 8, $b$ is the double nearest the root and $f(b)$ evaluates to exactly 0 | confirmed | `iqi.py` neighbour check: errors 5.5e-17 / **3.98e-19** / 5.6e-17. $f(b) = 0.0$ in Julia (J) and Python |
| C1.9 | Bisection needs 32 iterations to get within 1e-10 | confirmed (actual-error criterion; the a-priori bound would give 34) | C |
| C1.10 | Regula falsi needs 24 | confirmed | C: first iterate with error < 1e-10 is k = 24 |
| C1.11 | Alt text: "narrows from [0,1] to the root at x≈0.3285 in 8 steps, with step labels showing bisection, secant, and IQI" | confirmed | F: 9 frames = Start + 8 steps |
| C1.12 | Link `brentsaa.jl` and embed `brentsaa.gif` are this case | confirmed | Manifest: the GIF regenerates byte-identical from this script |

### Case 2: $f(x)=\tan x-2x$, $[0.5,1.5]$
| # | Claim | Verdict | Evidence |
|---|---|---|---|
| C2.1 | The heading's function and interval match the script | confirmed | `brentsbb.jl` lines 10–13; the GIF title matches |
| C2.2 | $x^* \approx 1.1656$ (non-trivial root of $\tan x = 2x$) | confirmed | M: 1.1655611852072113068 |
| C2.3 | $f(0.5) \approx -0.454$, $f(1.5) \approx 11.1$ | confirmed | −0.4537, 11.1014 |
| C2.4 | 10 steps: secant, two bisections, secant, IQI, secant, secant, IQI, secant, final minimum step | confirmed | J. S evaluation points identical. Archive gr_276 p0–p9 identical |
| C2.5 | Final bracket of width 5e-11 contains the root, with $b \approx 1.1655611852$ at one end | confirmed | J: b=1.1655611852026313, c=1.1655611852526317, width 5.000e-11. The root 1.16556118520721 lies between them |
| C2.6 | The bisection at step 3 moves the right end off 1.5, to 1.2598 | confirmed | J step 3: c = 1.2598159432786313, where $f = +0.59$ |
| C2.7 | Regula falsi needs 165 iterations to get within 1e-10 | confirmed | C: k = 165 |
| C2.8 | $f$ is convex, every chord lands left of the root, the right endpoint stays at 1.5 | confirmed | $f'' = 2\sec^2 x\tan x > 0$. C: all 165 iterates < root and the right end stays {1.5} |
| C2.9 | The error eventually shrinks by a factor of about 0.87 per iteration | confirmed | C: ratios 0.86642 |
| C2.10 | Alt text: "converging in 10 steps despite the function blowing up near the π/2 asymptote" | confirmed (10 steps; the asymptote lies outside the bracket, but large $f(1.5)$ is real) | F: 11 frames |
| C2.11 | Link `brentsbb.jl` and embed `brentsbb.gif` are this case | confirmed | Manifest: byte-identical regeneration |

---

### 3. Implementation checks

Both scripts share an identical `run_brents` (`diff` shows only parameters, plotting limits and asymptote masking differ).

**Is it the method it claims to be?** Yes. It is Brent's ZEROIN (1973) line by line:
- the sign test resets `c = a, d = e = b - a`;
- the swap makes `b` the endpoint with the smaller `|f|`;
- `tol1 = 2 eps |b| + tol/2` and `xm = (c - b)/2`;
- it stops when `|xm| ≤ tol1` or `fb == 0`;
- secant is used if `a == c`, otherwise IQI in the `p/q` form;
- the sign normalisation and the two acceptance tests (3/4 rule and half the step before last) match;
- a step shorter than `tol1` is replaced by `copysign(tol1, xm)`.

The variant is ZEROIN. The "Secant" step, taken when `a == c`, is the chord through the two bracket ends. The page's "(regula falsi)" gloss is therefore accurate.

**Are the numbers right?** I checked against an independent implementation, scipy's `brentq`, whose C code follows the same Dekker–Brent logic with a different, divided-difference IQI formula. Its tolerance is `xtol/2 + 2eps|x|`, identical to `tol1` here. I recorded every point it evaluated:

| step | script b (Case 1) | scipy eval | script b/c (Case 2) | scipy eval |
|---|---|---|---|---|
| 1 | 0.80000000000000004 | 0.8 | 0.53926377311452489 | 0.5392637731145249 |
| 2 | 0.40000000000000002 | 0.4 | 1.0196318865572624 | 1.0196318865572624 |
| 3 | c=0.22760580197149965 | 0.22760580197149965 | c=1.2598159432786313 | 1.2598159432786313 |
| 4 | 0.33928781217489301 | 0.339287812174893 | 1.1182930272785787 | 1.1182930272785787 |
| 5 | 0.32821473974562487 | 0.3282147397456249 | 1.1766603295259697 | 1.1766603295259697 |
| 6 | 0.32854391944914269 | 0.3285439194491427 | 1.1637285834543314 | 1.1637285834543314 |
| 7 | 0.32853846134936388 | 0.3285384613493639 | 1.1654929603348207 | 1.1654929603348207 |
| 8 | 0.3285384586114149 | 0.3285384586114149 | 1.1655612050524227 | 1.1655612050524227 |
| 9 | — | — | 1.1655611852026313 | 1.1655611852026313 |
| 10 | — | — | c=1.1655611852526317 | 1.1655611852526317 |

- Totals: scipy made 10 and 12 function calls, which is 8 and 10 steps plus 2 endpoint evaluations, exactly as the script.
- Property checks: the final $b$ has residual 0.0 (Case 1) and −2.03e-11 (Case 2). The errors fall superlinearly: 3.2e-4 → 5.5e-6 → 2.7e-9 → 4e-19.
- Mathews' own Brent output (archive gr_229, gr_276) agrees to all printed digits through step 7 (Case 1) and step 9 (Case 2). Beyond that it differs only in the last ulp or by its tighter $10^{-15}$ tolerance.
- The routine on $x^9$, $[-1,2]$ (`x9.jl`) makes 96 evaluations. scipy also makes 96.

**Reference values.** The scripts draw no "true" root; the only reference is the comment "Root ≈ 0.3285" / "≈ 1.1656". Both are confirmed by mpmath at 40 digits (0.32853845861141489597, 1.16556118520721130683).

**Does the picture show what was computed?** Yes. I viewed the contact sheets of both GIFs and frames 1, 4 and 9 of `brentsaa` and frame 11 of `brentsbb` at full size.
- The bracket shading and dashed lines are at `min/max(b, c)`.
- The red dot sits at `(b, f(b))` and its legend shows `b` to 6 decimals.
- Step labels and colours follow the `method` recorded for the step that produced the new point.
- Display devices:
  - Case 1 clamps the backdrop to `ylims ± 1`, so the curve simply exits the frame.
  - The `b_best` clamp to `xlims` never binds, since b ∈ [0, 1].
  - Case 2 masks `|x − π/2| < 0.04`, which lies outside the bracket, and clamps the dot's y to `ylims`, which never binds because $\lvert f(b)\rvert \le 0.48$.

  None of these changes what a viewer would conclude.
- From step 6 onward (Case 1) and step 8 onward (Case 2), the bracket is narrower than a pixel. Those frames differ only in the label and legend, and steps 7 and 8 of Case 1 both show "b = 0.328538". This limits how much the GIF shows of the late convergence the text describes, but nothing drawn is wrong, so I did not report it as a finding.
- The GIF titles name the function in the code.
- The frame counts (9 and 11) match the step counts plus the start frame.

**Regeneration.** Per the manifest, scratch runs reproduce both committed GIFs byte-identically. My instrumented copies use the unchanged algorithm code.

