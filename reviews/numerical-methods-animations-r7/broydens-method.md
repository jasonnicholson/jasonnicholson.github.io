# Broyden's Method — animation review (round 7)

Page: `pages/numerical-methods/broydens-method/`. Reported findings: **0 Error, 1 Misleading, 2 Minor**.

## Findings

### F1. Page match, Misleading: "each iteration is far cheaper" does not hold for the algorithm the page gives

- **Location:** `index.qmd:60`: "In practice, because each iteration is far cheaper than a full Newton step, Broyden's method often reaches a given accuracy in less total work than Newton's method, especially in high dimensions."
- **What is there now:** The page's algorithm (line 55, step 3) solves $B_k\,\Delta\mathbf{X} = -\mathbf{F}(\mathbf{X}^{(k)})$ at every iteration, and the scripts do the same (`B \ F_curr`, line 60 of each). Line 42 advertises $O(n^2)$ for the *update* only. Line 60 then presents the whole iteration as far cheaper.
- **What is true instead:** A dense solve costs $O(n^3)$, the same order as the linear solve in Newton's method. The algorithm as written saves the $n^2$ derivative evaluations, but its per-iteration arithmetic stays $O(n^3)$. It falls to $O(n^2)$ only if $B_k^{-1}$ or a factorization of $B_k$ is updated, for example by Sherman-Morrison. Mathews makes exactly this point ("Matrix inversion requires ... calculations. Thus we seek a way to avoid this time consuming step") and introduces the improved method for it. The page names that method at line 73 only as something not animated.
- **Evidence:** `/usr/bin/python3 -W ignore checks.py`, section 6, timing the dense solve against the rank-1 update:

  | n | dense solve (s) | rank-1 update (s) | solve / update |
  |---|---|---|---|
  | 500 | 0.0321 | 0.0013 | 24 |
  | 1000 | 0.2480 | 0.0037 | 67 |
  | 2000 | 2.1244 | 0.0114 | 187 |
  | 4000 | 15.7855 | 0.0437 | 362 |

  The solve, which the page's algorithm keeps, dominates the update and the gap grows with $n$. When $\mathbf{F}$ and $J$ are cheap, an iteration of the algorithm as written is not far cheaper than a Newton step.
- **Suggested correction:** Replace the sentence with: "Each iteration avoids the $n^2$ derivative evaluations, so when evaluating the Jacobian dominates the cost, Broyden's method often reaches a given accuracy in less total work than Newton's method. As written, step 3 still solves a linear system, which costs $O(n^3)$ for a dense matrix; the arithmetic per iteration falls to $O(n^2)$ only when $B_k^{-1}$ or a factorization of $B_k$ is updated instead, for example with the Sherman-Morrison formula."

- **Independent check:** confirmed with correction. The sentence is false as an unconditional claim, but true when evaluating the Jacobian costs more than the linear solve. For dense matrices both methods pay the same ⅔n³ factorization, so the only saving is the Jacobian evaluation. On a dense test problem (n = 50 to 3200) the page's Broyden iteration was 8% to 38% cheaper than Newton's, not "far cheaper". "Especially in high dimensions" needs the same condition.

### F2. Page match, Minor: Case B's final residual is quoted to a digit that rounding decides

- **Location:** `index.qmd:85` ("to $3.0\times10^{-14}$ at $\mathbf{X}^{(7)}$") and the alt text at `index.qmd:89` ("to 3.0e-14").
- **What is there now:** A two-figure value. It is a faithful rounding of what the script computes (2.956e-14, shown in the last frame as 2.96e-14), and Mathews' printed residual has the same norm.
- **What is true instead:** The second figure is not a property of the method. The same iteration gives:

  | Computation | $\|\mathbf{F}(\mathbf{X}^{(7)})\|$ |
  |---|---|
  | Script (double precision) | 2.956e-14 |
  | Script's double iterate, $\mathbf{F}$ evaluated exactly in rational arithmetic | 2.972e-14 |
  | Exact-arithmetic Broyden (60 digits) | 3.172e-14 |
  | Double precision, $\mathbf{F}$ written in Horner form | 3.337e-14 |

  These agree on "about $3\times10^{-14}$" and differ in the second figure.
- **Evidence:** `indep.py` (60-digit run) and `checks.py`, sections 2 and 3.
- **Suggested correction:** Write "about $3\times10^{-14}$" at line 85 and "about 3e-14" in the alt text at line 89. The GIF can stay as it is, since it reports what the run computed. Do not simply raise the `resid_title` threshold to cover this value: its order-of-magnitude format would print `1e-14` for 2.96e-14.

- **Independent check:** not run (Minor finding, unverified)

### F3. Implementation, Minor: false comment about term size in `broydenbb.jl`

- **Location:** `broydenbb.jl:81-82`: "Below 1e-14 the residual is at the rounding level of evaluating F (terms of size up to 4, eps ≈ 2.2e-16)".
- **What is there now:** The comment was carried over from `broydenaa.jl`, where it is true (largest term 4).
- **What is true instead:** Along the Case B run the largest term is 6.25. At the root the terms include $|4x| = 6.22$, $x^4 = 5.86$ and $2x^2 = 4.84$. The computed behaviour is unaffected, because the 1e-14 threshold is still well above $6.25\,\varepsilon \approx 1.4\times10^{-15}$.
- **Evidence:** Inline term-size computation: max term 6.0 at $\mathbf{X}^{(0)}$, 6.253 at $\mathbf{X}^{(1)}$, 6.224 at the root.
- **Suggested correction:** In `broydenbb.jl:82`, change "terms of size up to 4" to "terms of size up to about 6".

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `broydenaa.jl` | 0 | 10.9 | broydenaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `broydenbb.jl` | 0 | 10.6 | broydenbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `broydenaa.gif` | 7 | byte-identical | broydenaa |
| `broydenbb.gif` | 8 | byte-identical | broydenbb |

### Page references

- Scripts linked: `broydenaa.jl`, `broydenbb.jl`
- GIFs embedded: 2
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

Line numbers refer to `index.qmd`.

### Description

| # | Line | Claim | Verdict | Evidence |
|---|---|---|---|---|
| 1 | 12 | Newton needs all $n^2$ partials per iteration | Confirmed | Definition of the Jacobian |
| 2 | 12 | Broyden needs no further derivative or finite-difference evaluations after the first iteration | Confirmed | Scripts call `Jac` once (line 43) |
| 3 | 18 | Newton step formula | Confirmed | Standard; my Newton run converges quadratically |
| 4 | 20 | Newton converges quadratically near a simple root | Confirmed | $e_{k+1}/e_k^2$ settles at 1.24 (A) and 0.96 (B) |
| 5 | 20 | Link to Nonlinear Systems | Confirmed | Target file exists |
| 6 | 26 | Central-difference formula for $M_{ij}$ | Confirmed | Matches archive `gr_72` |
| 7 | 28 | $2n^2$ additional function evaluations per iteration | Confirmed | Two evaluations of $F_i$ per $(i,j)$; archive `gr_73` |
| 8 | 34-36 | Secant condition, with $\mathbf{s}_k$ and $\mathbf{y}_k$ as defined | Confirmed | Residual $\|B_{k+1}s-y\|$ 1.1e-16 ($n=2$), 1.2e-15 ($n=5$) |
| 9 | 38 | Secant condition alone does not determine $B_{k+1}$ for $n>1$ | Confirmed | Adding any $Z$ with $Zs=0$ stays feasible |
| 10 | 38-40 | Broyden's update is the Frobenius-closest matrix satisfying the secant condition | Confirmed | 20,000 random feasible alternatives for each of $n=2,5$; none closer |
| 11 | 42 | Correction has rank 1 | Confirmed | `matrix_rank` = 1 |
| 12 | 42 | Update takes $O(n^2)$ operations and no extra function evaluations | Confirmed | Outer product and matrix-vector product; code inspection |
| 13 | 46-48 | Step 0 uses exact $J$ and a Newton step | Confirmed | Script lines 43-44; `Jac` equals the sympy Jacobian |
| 14 | 50-56 | Loop: evaluate, update, solve, step | Confirmed | Script lines 48-65; archive `gr_205`-`gr_210` |
| 15 | 60 | Superlinear, slower than Newton | Confirmed | $e_{k+1}/e_k$ falls toward 0 (not monotonically), reaching 3.0e-35 (A) and 1.2e-21 (B) by the 14th step at 400 digits |
| 16 | 60 | Each iteration is far cheaper than a Newton step | **Wrong as stated for this algorithm (F1)** | Dense solve remains $O(n^3)$ |
| 17 | 60 | Broyden often takes less total work, especially in high dimensions | Could not determine in general | True when derivative cost dominates, which is problem-dependent; addressed in the F1 rewording |
| 18 | 60 | Convergence can fail from a distant start | Confirmed | 110 of 625 grid starts on $[-3,3]^2$ failed, for example $(-3,-3)$ |

### Animations introduction

| # | Line | Claim | Verdict | Evidence |
|---|---|---|---|---|
| 19 | 66 | $f_1$ and $f_2$ as stated | Confirmed | Script lines 16-17; archive `gr_213` and `gr_660` |
| 20 | 64 | Each animation shows convergence | Confirmed | Both runs reach their root |
| 21 | 68 | Blue is $f_1=0$, red is $f_2=0$ | Confirmed | Script lines 98-99; 53/53 solved $f_1$ points on blue pixels, 112/112 $f_2$ points on red |
| 22 | 68 | Exactly two real solutions | Confirmed | Resultant has degree 12 with constant leading coefficients in $x$: 2 real roots, 10 complex |
| 23 | 68 | Solutions near $(0.062, 0.724)$ and $(1.556, -0.576)$ | Confirmed | $(0.0617701263, 0.7244905153)$, $(1.5560974843, -0.5756507696)$ |
| 24 | 68 | Both lie inside the plotted window | Confirmed | Window $[-1.75, 2.25]\times[-1.5, 1.25]$ |
| 25 | 68 | Each frame adds the next iterate, joined by a line | Confirmed | Script lines 90-104; frames |
| 26 | 68 | After the first step, iterates are too close to separate | Confirmed | X0-X1 is 5.3 px (A) and 13.0 px (B); later steps at most 1.3 px, under a roughly 7 px marker |
| 27 | 68 | Right panel plots $\|\mathbf{F}\|$ on a log scale | Confirmed | Script lines 70, 108 |
| 28 | 70 | Source scripts linked under each case | Confirmed | Lines 79, 87 |
| 29 | 72 | Example 5 poses this system | Confirmed | `gr_213` |
| 30 | 72 | Example 5's starting-point, result and graph images are missing | Confirmed | `gr_214`-`gr_241` absent; `gr_213` present |
| 31 | 72 | Starting points come from Example 8's standard Broyden runs | Confirmed | `gr_676`, `gr_682` |
| 32 | 72 | Animations reproduce Example 8's printed iterates | Confirmed | Max coordinate difference 1.1e-16 (A), 4.4e-16 (B), all 15 iterates |
| 33 | 73 | Examples 1 and 3, improved Broyden (Example 8), and 3D/4D exercises are not animated | Confirmed | Module text; page has two cases only |

### Case A

| # | Line | Claim | Verdict | Computed |
|---|---|---|---|---|
| 34 | 75 | Heading: $\mathbf{X}^{(0)}=(0.1, 0.7)$, root $\approx(0.062, 0.724)$ | Confirmed | Script line 26; root above |
| 35 | 77 | Starts close to the upper intersection | Confirmed | Distance 0.0454 |
| 36 | 77 | First Newton step moves about 0.05 | Confirmed | 0.0464 |
| 37 | 77 | $\|\mathbf{F}\|$ from $2.5\times10^{-1}$ to $7.8\times10^{-3}$ | Confirmed | 2.484e-1, 7.762e-3 |
| 38 | 77 | Later steps use the rank-1 formula with no new derivatives | Confirmed | Script line 59 |
| 39 | 77 | About $10^{-15}$ (machine precision) at $\mathbf{X}^{(6)}$ | Confirmed | 1.355e-15 |
| 40 | 77 | $\mathbf{X}^{(0)}$ to $\mathbf{X}^{(4)}$: shrinks 24 to 43 times per step | Confirmed | 32.01, 24.55, 42.25, 25.67 |
| 41 | 77 | Each of the last two steps: more than 1000 times | Confirmed | 1304, 1.65e5 |
| 42 | 77 | Consistent with superlinear convergence | Confirmed | See entry 15 |
| 43 | 79, 81 | Link and embed are this case | Confirmed | `broydenaa.jl`, `broydenaa.gif`; committed GIF byte-identical to regeneration |
| 44 | 81 | Alt: only the first step large enough to see | Confirmed | Step is 5.3 px; X0 shows as a sliver beside the current-iterate marker |
| 45 | 81 | Alt: falls from 2.5e-1 to about 1e-15 in six steps | Confirmed | 7 frames, $k=0$ to $6$ |

### Case B

| # | Line | Claim | Verdict | Computed |
|---|---|---|---|---|
| 46 | 83 | Heading: $\mathbf{X}^{(0)}=(1.5, -0.5)$, root $\approx(1.556, -0.576)$ | Confirmed | Script line 26; root above |
| 47 | 85 | Starts close to the lower-right intersection | Confirmed | Distance 0.0942 |
| 48 | 85 | Converges to that solution | Confirmed | Final iterate $(1.5560974843, -0.5756507696)$ |
| 49 | 85 | $\|\mathbf{F}\|$ falls at every step | Confirmed | Ratios 6.96, 9.47, 212, 4.95, 55.0, 1198, 5424 |
| 50 | 85 | Starts at $7.3\times10^{-1}$ | Confirmed | 7.315e-1 |
| 51 | 85 | Ends at $3.0\times10^{-14}$ at $\mathbf{X}^{(7)}$ | **Confirmed for the script's run; second figure is rounding-dependent (F2)** | 2.956e-14; other evaluations 2.97e-14 to 3.34e-14 |
| 52 | 85 | About 5 times from $\mathbf{X}^{(3)}$ to $\mathbf{X}^{(4)}$ | Confirmed | 4.953 |
| 53 | 85 | More than 1000 times in each of the last two steps | Confirmed | 1198, 5424 |
| 54 | 85 | A different initial guess finds a different root | Confirmed | Cases A and B |
| 55 | 87, 89 | Link and embed are this case | Confirmed | `broydenbb.jl`, `broydenbb.gif`; committed GIF byte-identical to regeneration |
| 56 | 89 | Alt: only the first step large enough to see | Confirmed | 13.0 px, then at most 1.3 px |
| 57 | 89 | Alt: falls at every step from 7.3e-1 to 3.0e-14 in seven steps | Confirmed, with F2 | 8 frames, $k=0$ to $7$ |

---

### 3. Implementation checks

The two scripts differ only in header text, start point, title string and output filename (`diff`).

### Is it the method it claims to be?

Yes, for both. Each is standard Broyden ("good" Broyden, rank-1 update on $B$), with $B_0$ the exact Jacobian and one Newton step first. `Jac` matches the sympy Jacobian, `[[4x-4, -6y^2], [4x^3, 16y^3+4]]`. The variant is the one the page describes. The stop rule (`norm(F) < 1e-12`, at most 10 Broyden steps) is not stated on the page and does not contradict it.

### Are the numbers right?

Script against the independent 60-digit implementation in `indep.py`, and Mathews' printed values.

**Case A (`broydenaa.jl`)**

| k | Script x | Script y | 60-digit x | 60-digit y | Script ‖F‖ |
|---|---|---|---|---|---|
| 0 | 0.1 | 0.7 | 0.1 | 0.7 | 2.484e-1 |
| 1 | 0.061038616443267 | 0.725258837008245 | 0.061038616443267 | 0.725258837008245 | 7.762e-3 |
| 2 | 0.061779159834426 | 0.724459783671636 | 0.061779159834426 | 0.724459783671636 | 3.162e-4 |
| 3 | 0.061770589062488 | 0.724491157041490 | 0.061770589062488 | 0.724491157041490 | 7.483e-6 |
| 4 | 0.061770109194288 | 0.724490490187661 | 0.061770109194288 | 0.724490490187661 | 2.915e-7 |
| 5 | 0.061770126325456 | 0.724490515327927 | 0.061770126325456 | 0.724490515327927 | 2.235e-10 |
| 6 | 0.061770126338607 | 0.724490515347217 | 0.061770126338607 | 0.724490515347217 | 1.355e-15 |

**Case B (`broydenbb.jl`)**

| k | Script x | Script y | 60-digit x | 60-digit y | Script ‖F‖ |
|---|---|---|---|---|---|
| 0 | 1.5 | -0.5 | 1.5 | -0.5 | 7.315e-1 |
| 1 | 1.563144329896907 | -0.582474226804124 | 1.563144329896907 | -0.582474226804124 | 1.051e-1 |
| 2 | 1.555352036863449 | -0.575188105942452 | 1.555352036863449 | -0.575188105942452 | 1.109e-2 |
| 3 | 1.556095422856546 | -0.575627127115621 | 1.556095422856546 | -0.575627127115621 | 5.231e-5 |
| 4 | 1.556096954909285 | -0.575652970586295 | 1.556096954909285 | -0.575652970586295 | 1.056e-5 |
| 5 | 1.556097494140761 | -0.575650731326978 | 1.556097494140761 | -0.575650731326978 | 1.921e-7 |
| 6 | 1.556097484313824 | -0.575650769650469 | 1.556097484313824 | -0.575650769650470 | 1.603e-10 |
| 7 | 1.556097484322055 | -0.575650769618837 | 1.556097484322055 | -0.575650769618837 | 2.956e-14 |

Against Mathews' printed Broyden iterates (read from `gr_676` and `gr_682`, compared in `archcmp.py`): maximum coordinate difference 1.1e-16 for A and 4.4e-16 for B. His printed final residuals, $(-7.77\times10^{-16}, 1.11\times10^{-15})$ and $(-8.49\times10^{-15}, 2.83\times10^{-14})$, have norms equal to the script's 1.355e-15 and 2.956e-14.

### Are its reference values right?

The scripts draw no separate exact solution; the reference is the root quoted in the title and page. From the resultant in $y$ (sympy, degree 12) with $x$ recovered from $f_1$:

- $(0.06177012633860737, 0.7244905153472166)$, residual below 1e-30
- $(1.556097484322053, -0.5756507696188434)$, residual below 1e-30

The other 10 resultant roots are non-real, so these are the only real solutions. The leading coefficients of $f_1$ and $f_2$ in $x$ are the constants 2 and 1, so the resultant loses no solution at infinity.

### Does the picture show what was computed?

Yes. I viewed both contact sheets and full frames 2 (Case A) and 8 (Case B).

- **Curves:** solved points on $f_1=0$ fall on blue pixels 53 of 53 times, and on $f_2=0$ on red pixels 112 of 112 times, after calibrating the axes to the plot box. The curve shapes match Mathews' graph `gr_669`.
- **Titles:** every frame's $\mathbf{X}_k$ and $\|\mathbf{F}(\mathbf{X}_k)\|$ agrees with the computed value at index $k$.
- **Machine-precision label:** applied only to Case A's final frame (1.355e-15, shown as `1e-15`). Case B's final value is above the 1e-14 cutoff and is printed numerically.
- **Display devices:** no clamping or masking. All residuals lie within the plot's $10^{-16}$ to $10^{1}$ range, and all iterates lie inside the window.
- **Frame counts:** 7 and 8, equal to the iterate counts. Committed GIFs are byte-identical to the scratch regenerations (`cmp`).

### Fidelity to the archive

The system, both starting points, and both runs match Mathews' Example 8 standard Broyden runs. The page discloses that Example 5's images are missing and names the examples and exercises it does not animate. No fidelity finding.

