# Secant Method — animation review (round 7)

Page: `pages/numerical-methods/secant-method/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


None.


#### Checked and deliberately not reported

These are recorded so a clean result can be audited. None meets the standard for a finding.

- **No `## Description` section.** The page begins at `## Animations`. The authoring conventions ask for a Description, but content the page does not yet have is out of scope. The method statement in the Animations introduction was checked instead (L1-L3).
- **Mathews Examples 1 and 2 are not on the page.** They are static Mathematica worked examples on cubics. Mathews' animation index for this topic lists exactly six animations, and all six are present as Cases 1 to 6, in order.
- **Case 3 runs past the legacy animation.** Mathews' GIF ends at $p_5$ and the page ends at $p_8$. The page explains the double-precision result at $p_8$ and the values are right.
- **Case 4 uses a wider y-window than Mathews**, $[-25, 32]$ against $[-5, 32]$. This is an improvement: $f(p_3) = -21$ and $f(p_9) = -21.9$ are visible rather than off the plot.
- **Case 5 uses 9 frames where Mathews sets $n = 16$.** Mathews' animation also shows nothing past $p_9$ inside this window. The page says where it stops and quotes $p_{16}$ correctly.
- **Case 6 oscillates too, without saying so.** From $p_3$ on the iterates alternate sides of the root, as in Case 3. The page makes no contrary claim, and the script header states it.
- **Case 6 has no single asymptotic error constant.** $e_{n+1}/e_n^2$ alternates between 0.0090233 and 36.941, with product $1/3$. This follows from $e_{n+1} \approx \tfrac13 e_n e_{n-1}^2$. The order is still 2, so the page's claim stands.
#### Could not determine

- **The `n` and plot range of Mathews' Example 5 (Case 3).** Its parameter image `SecantMethodMod_gr_368.gif` and 15 other images on that link page are missing from the archive. The function ($\arctan x = 0$) and starting values ($p_0 = 1.35$, $p_1 = 1.30$) are confirmed from the surviving inline images `gr_365` to `gr_367`, and the iterates from the legacy animation frames. No page claim depends on the missing values.

## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `secantmethodaa.jl` | 0 | 6.9 | secantmethodaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `secantmethodbb.jl` | 0 | 9.5 | secantmethodbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `secantmethodcc.jl` | 0 | 5.7 | secantmethodcc.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `secantmethoddd.jl` | 0 | 7.9 | secantmethoddd.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `secantmethodee.jl` | 0 | 4.9 | secantmethodee.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `secantmethodff.jl` | 0 | 4.4 | secantmethodff.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `secantmethodaa.gif` | 9 | byte-identical | secantmethodaa |
| `secantmethodbb.gif` | 28 | byte-identical | secantmethodbb |
| `secantmethodcc.gif` | 7 | byte-identical | secantmethodcc |
| `secantmethoddd.gif` | 16 | byte-identical | secantmethoddd |
| `secantmethodee.gif` | 9 | byte-identical | secantmethodee |
| `secantmethodff.gif` | 6 | byte-identical | secantmethodff |

### Page references

- Scripts linked: `secantmethodaa.jl`, `secantmethodbb.jl`, `secantmethodcc.jl`, `secantmethoddd.jl`, `secantmethodee.jl`, `secantmethodff.jl`
- GIFs embedded: 6
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

Verdicts: **confirmed**, **wrong**, **could not determine**.

### Introduction

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| L1 | Secant line through $(p_{n-1}, f(p_{n-1}))$ and $(p_n, f(p_n))$ | Code and frames, all 75 frames by `geom_*.jl` | confirmed |
| L2 | Its x-intercept becomes $p_{n+1}$ | Line zero against next iterate, all frames (section 3) | confirmed |
| L3 | No derivative required; slope from two function evaluations | No derivative in any script | confirmed |
| L4 | The method can converge quickly, slowly near repeated roots, oscillate, or diverge | Cases 1, 2, 3, 5 | confirmed |
| L5 | Julia source linked under each case | Six links, each to an existing script | confirmed |

### Case 1: $f(x) = 3e^x - 4\cos x$, $p_0 = 1.0$, $p_1 = 0.9$

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| C1.1 | Function and starting values | Script lines 10-12; Mathews `gr_305` | confirmed |
| C1.2 | Root near 0.2549 | 0.25485005902885 | confirmed |
| C1.3 | Both starts on the same side of the root | 1.0 and 0.9, both above the root | confirmed |
| C1.4 | $p_2 \approx 0.456$, still 0.20 from the root | 0.45575, error 0.2009 | confirmed |
| C1.5 | Error 0.066 at $p_3$ | 0.06588 | confirmed |
| C1.6 | Error 0.0089 at $p_4$ | 0.00891 | confirmed |
| C1.7 | Error $4.4 \times 10^{-4}$ at $p_5$ | $4.435 \times 10^{-4}$ | confirmed |
| C1.8 | Error $3.1 \times 10^{-6}$ at $p_6$ | $3.115 \times 10^{-6}$ | confirmed |
| C1.9 | Consistent with order $\approx 1.618$, simple root | Local orders 1.79, 1.50, 1.65, 1.60, 1.62, 1.62, then 1.618; $f''(r) = 7.74 \ne 0$ | confirmed |
| C1.10 | Alt text: x-intercept converges rapidly to the root near 0.2549 | Frames 1-9 | confirmed |
| C1.11 | Wiring | `secantmethodaa.jl` and `.gif`; title and legend match | confirmed |

### Case 2: $f(x) = 1 - 10x + 25x^2$, $p_0 = 1.0$, $p_1 = 0.9$

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| C2.1 | Function and starting values | Script lines 12-14; Mathews `gr_327` | confirmed |
| C2.2 | $f = (1-5x)^2 = 25(x-0.2)^2$, double root at 0.2, $f'(0.2) = 0$ | Algebra | confirmed |
| C2.3 | Converges only linearly | Error ratio constant from $p_{13}$ on | confirmed |
| C2.4 | Ratio settles at $(\sqrt5-1)/2 \approx 0.618$ | $e_{29}/e_{28} = 0.6180339888$; exact identity $1/e_{n+1} = 1/e_n + 1/e_{n-1}$ holds to $8 \times 10^{-3986}$ | confirmed |
| C2.5 | Each step removes about 38% of the error | $1 - 0.618 = 0.382$ | confirmed |
| C2.6 | Iterates creep toward the root over many iterations | $p_{29} = 0.20000088$ after 28 steps | confirmed |
| C2.7 | Alt text: slow approach, linear behaviour | Frames | confirmed |
| C2.8 | Wiring | `secantmethodbb.jl` and `.gif` | confirmed |

### Case 3: $f(x) = \arctan x$, $p_0 = 1.35$, $p_1 = 1.30$

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| C3.1 | Function and starting values | Script lines 15-17; Mathews `gr_365` to `gr_367` | confirmed |
| C3.2 | Converges to 0 | Exact iterates to $p_{14}$ | confirmed |
| C3.3 | Jumps to the opposite side of the root each step | Signs $p_1$ to $p_{14}$: `+-+-+-+-+-+-+-` | confirmed |
| C3.4 | Flat slope makes the first step overshoot to negative $x$ | Secant slope 0.363; $p_2 = -1.22138$ | confirmed |
| C3.5 | Animation ends at $p_8$ | 7 frames; final legend `p8` | confirmed |
| C3.6 | Double precision returns $p_8$ as exactly 0 | `p8 = 0.0` | confirmed |
| C3.7 | $p_6 \approx -6.9 \times 10^{-12}$ | Double $-6.88865 \times 10^{-12}$; exact the same | confirmed |
| C3.8 | $p_7 \approx 4.8 \times 10^{-25}$ | Double $4.7983 \times 10^{-25}$; exact $4.8002 \times 10^{-25}$ | confirmed |
| C3.9 | Computed $\arctan x = x$ at $p_6$ and $p_7$ | Printed `f` is bit-identical to `p` | confirmed |
| C3.10 | So the secant through them passes through the origin | Both points lie on $y = x$ in double precision | confirmed |
| C3.11 | Exact-arithmetic $p_8 \approx -7.6 \times 10^{-48}$ | $-7.59285 \times 10^{-48}$ | confirmed |
| C3.12 | Alt text: oscillates across 0 with decreasing amplitude | $\lvert p_n \rvert$ strictly decreasing from $p_2$ | confirmed |
| C3.13 | Wiring | `secantmethodcc.jl` and `.gif` | confirmed |

### Case 4: $f(x) = x^3 - x + 3$, $p_0 = 2.0$, $p_1 = 1.0$

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| C4.1 | Function and starting values | Script lines 11-13; Mathews `gr_387` | confirmed |
| C4.2 | Real root near $-1.672$ | $-1.67169988166$; discriminant $-239$, so it is the only real root | confirmed |
| C4.3 | Starts positive and far from the root | Distances 3.67 and 2.67 | confirmed |
| C4.4 | Iterates wander | Side of root $p_0$ to $p_{17}$: `+++-+++++-++-++-++` | confirmed |
| C4.5 | Includes a large positive excursion | $p_6 = 3.1639$ | confirmed |
| C4.6 | Eventually converges | $p_{17}$ error $1.0 \times 10^{-15}$ | confirmed |
| C4.7 | Path is non-monotone | $p_3 = -3$, $p_6 = 3.16$, $p_9 = -3.03$ | confirmed |
| C4.8 | Heading: oscillating path to a distant root | The iterates swing back and forth across the root | confirmed |
| C4.9 | Alt text: positive and negative values, root near $-1.672$ | Frames; final legend `p17 = -1.6717` | confirmed |
| C4.10 | Wiring | `secantmethoddd.jl` and `.gif` | confirmed |

### Case 5: $f(x) = xe^{-x}$, $p_0 = 1.5$, $p_1 = 2.0$

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| C5.1 | Function and starting values | Script lines 11-13; Mathews `gr_416` | confirmed |
| C5.2 | Root at $x = 0$ | Direct | confirmed |
| C5.3 | Method diverges | Iterates strictly increasing through $p_{3001}$ | confirmed |
| C5.4 | Tail secant has a shallow negative slope, intercept to the right | $f' < 0$ for $x > 1$; every step positive | confirmed |
| C5.5 | Each step moves further from the root | Monotone increasing | confirmed |
| C5.6 | First jump to $p_2 \approx 4.11$ | 4.1138 | confirmed |
| C5.7 | After that each step is less than 1 | Largest step after $p_2$ is 0.97156, over 3000 iterates | confirmed |
| C5.8 | Step tends to $\ln 2 \approx 0.693$ | Step 0.70254 at $p_{100}$, 0.69414 at $p_{1000}$, 0.69348 at $p_{2999}$; fixed point of the step map is $\ln 2$ | confirmed |
| C5.9 | Stops at $p_{10} \approx 10.57$ | 10.5746; 9 frames | confirmed |
| C5.10 | $p_{10}$ is the first iterate past the right edge | Edge 10.1; $p_9 = 9.80$ | confirmed |
| C5.11 | $p_{16} \approx 15.11$ | 15.1060 | confirmed |
| C5.12 | Alt text: moves right until $p_{10}$ leaves the window | Frames 1-9; frame 9 labels the marker as off chart at the edge | confirmed |
| C5.13 | Wiring | `secantmethodee.jl` and `.gif` | confirmed |

### Case 6: $f(x) = \arctan x$, $p_0 = 1.60$, $p_1 = 1.50$

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| C6.1 | Function and starting values | Script lines 12-14; Mathews `gr_445` | confirmed |
| C6.2 | Slightly larger starts than Case 3 | 1.60, 1.50 against 1.35, 1.30 | confirmed |
| C6.3 | Converges to 0 | Exact iterates to $p_{15}$ | confirmed |
| C6.4 | Larger first overshoot | $\lvert p_2 \rvert = 1.842$ against 1.221 | confirmed |
| C6.5 | Later steps close in quickly | $p_3 = -0.0975$, $p_5 = -5.2 \times 10^{-5}$, $p_7 = -9.2 \times 10^{-17}$ | confirmed |
| C6.6 | Super-linear convergence | Error ratios tend to 0 | confirmed |
| C6.7 | $f''(0) = 0$ for arctan | $f'' = -2x/(1+x^2)^2$ | confirmed |
| C6.8 | Asymptotic order is 2 | Local orders 1.889, 2.059, 1.972, 2.015, 1.993, 2.004. Derivation: $x_{n+1} \approx -x_n x_{n-1}(x_n + x_{n-1})/3$, so $r^2 = r + 2$, $r = 2$ | confirmed |
| C6.9 | Alt text: converges after initial overshoot | Frames 1-6 | confirmed |
| C6.10 | Wiring | `secantmethodff.jl` and `.gif` | confirmed |

### Fidelity to the legacy archive

| # | Item | Evidence | Verdict |
|---|---|---|---|
| F1 | Cases 1-6 correspond to Mathews Examples 3-8 (Animations 1-6) | Link pages and `Secantaa` to `Secantff` | confirmed |
| F2 | Functions and starting values match | `gr_305`, `gr_327`, `gr_365`-`gr_367`, `gr_387`, `gr_416`, `gr_445` | confirmed |
| F3 | Behaviour labels match (fast, slow, oscillation, convergence, non-convergence, convergence) | Link page text | confirmed |
| F4 | Iterates match Mathews where displayed | Legacy frames: Case 3 through $p_5$, Case 4 through $p_{13}$, Case 5 through $p_9$, Case 6 through $p_6$ | confirmed |
| F5 | Mathews' `n` and plot range for Example 5 | Parameter image missing | could not determine |

### 3. Implementation checks

### All six scripts

**It is the method it claims to be.** Each runs the plain two-point secant recurrence
$p_{n+1} = p_n - f(p_n)(p_n - p_{n-1})/(f(p_n) - f(p_{n-1}))$, with no bracketing or other safeguard. The guard for a denominator below $10^{-14}$ never fires in any shown step (smallest denominator per case below).

**Evidence is current.** Each scratch script is byte-identical to the repository script, and each regenerated GIF is byte-identical to the committed GIF (`cmp`, all six).

**Geometry.** For every frame, `geom_<case>.jl` checked that the drawn segment lies on the secant line and inside the plot box, and compared the line's zero with the stored next iterate.

| Case | Frames | Last iterate | Guard fired | Smallest denominator | Max relative difference, line zero vs next iterate | Segment problems | Iterates outside window |
|---|---|---|---|---|---|---|---|
| aa | 9 | $p_{10}$ | 0 | $1.33 \times 10^{-14}$ | $1.7 \times 10^{-16}$ | 0 | none |
| bb | 28 | $p_{29}$ | 0 | $8.27 \times 10^{-11}$ | 0 | 0 | none |
| cc | 7 | $p_8$ | 0 | $6.89 \times 10^{-12}$ | $1.7 \times 10^{-3}$ (see below) | 0 | none |
| dd | 16 | $p_{17}$ | 0 | $1.77 \times 10^{-5}$ | $1.4 \times 10^{-16}$ | 0 | none |
| ee | 9 | $p_{10}$ | 0 | $5.48 \times 10^{-4}$ | $1.8 \times 10^{-16}$ | 0 | $p_{10}$ only, labelled off chart |
| ff | 6 | $p_7$ | 0 | $5.25 \times 10^{-5}$ | 0 | 0 | none |

The Case 3 difference is at frame 6, an absolute difference of $8.1 \times 10^{-28}$ on $p_7 \approx 4.8 \times 10^{-25}$. It is rounding from cancellation in that step, far below display resolution. Because no iterate leaves the window except $p_{10}$ in Case 5, none of the `clamp` calls changes a drawn point.

### Iterates, script against independent computation

Script values are from `inst_<case>.out`, independent values from `indep.out` (200 digits).

**aa, root 0.25485005902885**

| k | Script | Independent | Independent error |
|---|---|---|---|
| 2 | 0.4557507541631 | 0.45575075416315 | 0.200901 |
| 3 | 0.3207305327599 | 0.32073053275992 | 0.0658805 |
| 4 | 0.2637602526351 | 0.26376025263506 | 0.00891019 |
| 5 | 0.2552935134242 | 0.25529351342421 | $4.43454 \times 10^{-4}$ |
| 6 | 0.2548531741452 | 0.25485317414525 | $3.11512 \times 10^{-6}$ |
| 8 | 0.2548500590289 | 0.25485005902885 | $2.70752 \times 10^{-15}$ |

**bb, root 0.2 (reference exact)**

| k | Script | Independent | Error ratio |
|---|---|---|---|
| 2 | 0.5733333333333 | 0.57333333333333 | 0.533333 |
| 7 | 0.2350000000000 | 0.235 | 0.61875 |
| 15 | 0.2007447798909 | 0.20074477989094 | 0.618034 |
| 28 | 0.2000014295156 | 0.20000142951447 | 0.618034 |
| 29 | 0.2000008834857 | 0.20000088348853 | 0.618034 |

At $p_{29}$ the double-precision value differs from the exact value by $2.8 \times 10^{-12}$, below the 8 decimals shown in the legend.

**cc, root 0**

| k | Script | Independent |
|---|---|---|
| 2 | $-1.2213792056860$ | $-1.221379205686$ |
| 3 | 0.018036298196726 | 0.018036298196728 |
| 4 | $-0.0067232949785550$ | $-0.0067232949785557$ |
| 5 | $4.5722058130988 \times 10^{-7}$ | $4.5722058130981 \times 10^{-7}$ |
| 6 | $-6.8886493391089 \times 10^{-12}$ | $-6.8886493390955 \times 10^{-12}$ |
| 7 | $4.7982937876611 \times 10^{-25}$ | $4.8001833131674 \times 10^{-25}$ |
| 8 | 0.0 | $-7.5928483163731 \times 10^{-48}$ |

The growing relative difference at $p_6$ to $p_8$ is the double-precision effect the page describes.

**dd, root $-1.6716998816572$**

| k | Script | Independent | Independent error |
|---|---|---|---|
| 2 | 0.5 | 0.5 | 2.1717 |
| 3 | $-3.0$ | $-3.0$ | 1.3283 |
| 6 | 3.1639049160972 | 3.1639049160972 | 4.8356 |
| 9 | $-3.0342275767851$ | $-3.0342275767851$ | 1.36253 |
| 12 | $-1.7346585404889$ | $-1.7346585404889$ | 0.0629587 |
| 15 | $-1.6717022768625$ | $-1.6717022768625$ | $2.39521 \times 10^{-6}$ |
| 17 | $-1.6716998816572$ | $-1.6716998816572$ | $1.01251 \times 10^{-15}$ |

**ee, root 0 (iterates diverge)**

| k | Script | Independent |
|---|---|---|
| 2 | 4.1137988733264 | 4.1137988733264 |
| 3 | 4.8125063367527 | 4.8125063367527 |
| 5 | 6.5948675617903 | 6.5948675617903 |
| 9 | 9.8009866463166 | 9.8009866463166 |
| 10 | 10.574639777228 | 10.574639777228 |
| 16 | (beyond the script's run) | 15.105971719963 |

**ff, root 0**

| k | Script | Independent |
|---|---|---|
| 2 | $-1.8424619601336$ | $-1.8424619601336$ |
| 3 | $-0.097483386474739$ | $-0.097483386474737$ |
| 4 | 0.076193229514678 | 0.076193229514675 |
| 5 | $-5.2368150304113 \times 10^{-5}$ | $-5.2368150304106 \times 10^{-5}$ |
| 6 | $1.0111340931961 \times 10^{-7}$ | $1.0111340931958 \times 10^{-7}$ |
| 7 | $-9.2253442014789 \times 10^{-17}$ | $-9.2253449358628 \times 10^{-17}$ |

### Reference values

The scripts draw no separate reference curve or exact solution. Root values appear only in the page text and comments:

- Case 1: 0.25485005902885, from a 200-digit root solve, residual 0.
- Case 2: 0.2, exact by factorisation.
- Cases 3, 5, 6: 0, exact.
- Case 4: $-1.67169988166$, from a high-precision root solve.

### The picture shows what was computed

I viewed the contact sheets of all six GIFs. They show every frame of aa, cc, ee and ff, 10 of 28 frames of bb, and 8 of 16 frames of dd. I also viewed the final frames of bb, dd and ee individually.

- Titles match the function in the code.
- Legend indices are right: frame $k$ uses $p_{k-1}$ and $p_k$ and marks $p_{k+1}$.
- Legend values match the computed iterates at their displayed precision.
- Case 3 labels $p_8$ as a double-precision 0.
- Case 5, frame 9 places a hollow marker at the window edge and states both the real value (10.57) and that it is off chart.

The frames not viewed individually come from the same plotting code, and their geometry was checked numerically above.

