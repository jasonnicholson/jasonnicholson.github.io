# False Position or Regula Falsi Method — animation review (round 7)

Page: `pages/numerical-methods/false-position-or-regula-falsi-method/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Error: 0. Misleading: 0. Minor: 0.

Every checkable claim on the page was compared with computed values and with the frames (section 2). Both scripts run plain Regula Falsi on the stated problem and draw what they compute (section 3).

Items examined and deliberately not filed, so the owner can overrule them:

- **No `## Description` section.** The page goes straight to `## Animations`, although `.github/agents/animation-page.agent.md` requires a Description. The brief excludes content a page does not yet have, so this is not a finding. It does mean there were no Description formulas to check; the page's method statements are all in the Animations introduction.
- **Frame 0 of Case A: annotation overlaps the legend box.** "Initial bracket [-1.0, 2.0]" starts inside the right edge of the legend. All text stays readable and the value is correct, so it is cosmetic.
- **Case B alt text: "the secant ... converges to the Dottie number".** A line does not converge to a number; the intended object is the secant's x-intercept, which does converge (error 1.1e-13 at step 10). The limiting line passes through $(x^*, 0)$ and $(1, f(1))$. Shorthand that does not change what a reader concludes.
- **Case B frames 5 to 10 look alike.** The legend shows 0.739085 in all six because the true iterates differ only beyond the sixth decimal (error 3.5e-7 at c_5). The frames are distinct by hash and the labels are correct rounded values.
- **Case B is not a Mathews example.** It is an addition, the page does not attribute it to the archive, and no archive case was displaced (section 4).



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `regulafalsiaa.jl` | 0 | 9.6 | regulafalsiaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `regulafalsibb.jl` | 0 | 7.6 | regulafalsibb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `regulafalsiaa.gif` | 13 | byte-identical | regulafalsiaa |
| `regulafalsibb.gif` | 11 | byte-identical | regulafalsibb |

### Page references

- Scripts linked: `regulafalsiaa.jl`, `regulafalsibb.jl`
- GIFs embedded: 2
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

Verdicts come from: `review/indep.py` (60-digit mpmath iteration), `review/geom.py` (line fit by linear solve, not the page's formula), `review/inst_aa.jl`, `inst_bb.jl`, `sec_aa.jl`, `sec_bb.jl` (the scripts' own loops instrumented), and the committed frames.

### Introduction

| # | Claim (page wording) | Evidence | Verdict |
|---|---|---|---|
| I1 | Each animation shows the "secant diagram" | Both GIFs, all frames after the first | confirmed |
| I2 | "a secant line is drawn through the two bracket endpoints $(a, f(a))$ and $(b, f(b))$" | Secant residual at both endpoints, all frames: max 3.7e-15 (A), 8.7e-17 (B) | confirmed |
| I3 | "its x-intercept $c$ becomes the new estimate" | Secant residual at c is inside the same bound; c from independent line solve equals script's | confirmed |
| I4 | "In each frame after the first, the dashed secant passes through the endpoints of the previous bracket" | Code uses `as[frame]`, `bs[frame]`; frame 1 of A passes through (-1,-7) and (2,14) | confirmed |
| I5 | "the shaded band shows the updated bracket" | Band uses `as[frame+1]`, `bs[frame+1]`; frame 1 of A shades [0, 2] | confirmed |
| I6 | updated bracket "has the new point $c$ (red) as one endpoint" | Asserted for every frame in `sec_*.jl`; c drawn red | confirmed |
| I7 | Bisection "uses the midpoint"; Regula Falsi "weights the new point toward whichever endpoint has a smaller $\lvert f\rvert$ value" | $c = (a\lvert f(b)\rvert + b\lvert f(a)\rvert)/(\lvert f(a)\rvert+\lvert f(b)\rvert)$ checked to 1e-12 and c nearer the smaller-$\lvert f\rvert$ endpoint at all 22 steps | confirmed |
| I8 | "often giving faster convergence" | Error after the same step count, RF vs bisection midpoint: A 6.6e-7 vs 1.3e-4; B 1.1e-13 vs 3.2e-4. The hedge "often" is a general statement; confirmed for both cases shown | confirmed |
| I9 | "one endpoint can remain fixed for many iterations" | b fixed for all 12 (A) and all 10 (B) steps | confirmed |
| I10 | Julia sources "are linked under each case" | Links present under both cases, both files exist | confirmed |

### Case A

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| A1 | "Convergent" | Error 1.365 to 6.6e-7 over 12 steps | confirmed |
| A2 | $f(x) = x^3 + 4x^2 - 10$ | Script line 15; GIF title and legend | confirmed |
| A3 | $[a, b] = [-1, 2]$ | Script line 16; frame 0 | confirmed |
| A4 | "the real root $x^* \approx 1.3652$" | 1.3652300134; `numpy.roots` gives one real root and a complex pair | confirmed |
| A5 | "right endpoint $b = 2$ stays fixed throughout" | `nextb = 2.0` at all 12 steps; follows for all steps from convexity | confirmed |
| A6 | "$f(-1) < 0$" | f(-1) = -7 | confirmed |
| A7 | "every false-position point $c$ also satisfies $f(c) < 0$" | All 12 values negative, -10 to -1.1e-5 | confirmed |
| A8 | "$f$ is convex on the bracket" | $f'' = 6x + 8 \ge 2$ on [-1, 2] | confirmed |
| A9 | "keeps replacing $a$ with $c$" | `nexta = c` at all 12 steps | confirmed |
| A10 | "$a = -1, 0, 0.8333, 1.2088, \dots$" | -1, 0, 0.83333, 1.20879 | confirmed |
| A11 | One-sided stagnation "is characteristic of Regula Falsi and distinguishes it from the symmetric bracketing of bisection" | For strictly convex or concave f the same endpoint is always retained. Bisection on this problem moved left 7 and right 5 times in 12 steps | confirmed |
| A12 | Source link is this case | `regulafalsiaa.jl` runs this f and interval | confirmed |
| A13 | Embed is this case | `regulafalsiaa.gif`, byte-identical to a fresh run of the script | confirmed |
| A14 | Alt: "f(x)=x³+4x²−10 on [−1,2]" | As A2, A3 | confirmed |
| A15 | Alt: secant "walks toward the root near x=1.37" | Intercepts rise to 1.365229; root rounds to 1.37 | confirmed |
| A16 | Alt: "right endpoint fixed and successive false-position points converging from the left" | c strictly increasing, all below root | confirmed |

### Case B

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| B1 | "Convergent (one-sided)" | Error 0.054 to 1.1e-13 over 10 steps; b never moves | confirmed |
| B2 | $f(x) = x - \cos(x)$ | Script line 12; GIF title and legend | confirmed |
| B3 | $[a, b] = [0, 1]$ | Script line 13; frame 0 | confirmed |
| B4 | "Dottie number" $x^* \approx 0.7391$ | 0.7390851332 (mpmath and brentq) | confirmed |
| B5 | "the unique fixed point of cosine" | $\frac{d}{dx}(x - \cos x) = 1 + \sin x \ge 0$ with isolated zeros, so strictly increasing and one real root | confirmed |
| B6 | "$b = 1$ (where $f(1) \approx 0.4597$)" | f(1) = 0.45969769 | confirmed |
| B7 | $b = 1$ "remains fixed throughout" | `nextb = 1.0` at all 10 steps | confirmed |
| B8 | "$f$ is convex on $[0, 1]$" | $f'' = \cos x \ge 0.5403$ on [0, 1] | confirmed |
| B9 | "every false-position point satisfies $f(c) < 0$" | All 10 negative, -0.0893 to -1.9e-13 | confirmed |
| B10 | "the points advance from the left" | c strictly increasing, all below root | confirmed |
| B11 | "$c = 0.6851, 0.7363, 0.7389, \dots$" | 0.685073, 0.736299, 0.738945 | confirmed |
| B12 | "the bracket shrinks only on the left side" | Only a moves; width goes from 1 to 0.260915 and tends to $1 - x^*$ = 0.260915, not to 0 | confirmed |
| B13 | "the secant intercept homes in on the root accurately" | \|c_10 - x*\| = 1.1e-13 | confirmed |
| B14 | Source link is this case | `regulafalsibb.jl` runs this f and interval | confirmed |
| B15 | Embed is this case | `regulafalsibb.gif`, byte-identical to a fresh run | confirmed |
| B16 | Alt: "f(x)=x−cos(x) on [0,1]" | As B2, B3 | confirmed |
| B17 | Alt: converges "to the Dottie number x*≈0.739" | Intercept does; see the note in section 1 | confirmed |
| B18 | Alt: "right endpoint fixed at 1 while the left endpoint steps in" | As B7, B10 | confirmed |

### Prominent frame content, checked against the page

| # | Item | Evidence | Verdict |
|---|---|---|---|
| F1 | Titles name the function in the code | Both GIFs | confirmed |
| F2 | Legend `c_k` values, all 22 labels | Read from cropped legends of every frame (`review/legends.png`), equal to the rounded computed values | confirmed |
| F3 | Frame 0 annotation of each GIF | "[-1.0, 2.0]", "[0.0, 1.0]" | confirmed |
| F4 | Features the page discusses are inside the axes | Root, both endpoints and all iterates are visible; no clamping or masking is used; f(2) = 14 is within ylim 16, f(1) = 0.46 within ylim 0.5 | confirmed |

No claim was left undetermined.

### 3. Implementation checks

### `regulafalsiaa.jl`

- **Method.** Plain Regula Falsi: $c = (a f(b) - b f(a))/(f(b) - f(a))$, keeping the sign-changing subinterval. No Illinois or other modified-weight variant. Convergence is linear, as expected for that method.
- **Numbers.** Script, independent 60-digit run and Mathews' printed table (Example 3, 0-based there) agree:

| k | Script c_k | Independent (mpmath) | Mathews c_{k-1} | f(c_k) | error |
|---|---|---|---|---|---|
| 1 | 0.0 | 0.0 | 0. | -10 | 1.365 |
| 2 | 0.8333333333333334 | 0.83333333333333 | 0.833333333333333 | -6.6435 | 0.5319 |
| 3 | 1.2087912087912087 | 1.2087912087912 | 1.208791208791209 | -2.3890 | 0.1564 |
| 4 | 1.32412611057995 | 1.32412611058 | 1.32412611057995 | -0.66516 | 0.0411 |
| 5 | 1.3547812233663692 | 1.3547812233664 | 1.354781223366369 | -0.17166 | 0.01045 |
| 6 | 1.362596802578731 | 1.3625968025787 | 1.362596802578731 | -0.043427 | 2.633e-3 |
| 7 | 1.364567874259778 | 1.3645678742598 | 1.364567874259778 | -0.010931 | 6.621e-4 |
| 8 | 1.365063606246616 | 1.3650636062466 | 1.365063606246616 | -0.0027477 | 1.664e-4 |
| 9 | 1.3651881982101728 | 1.3651881982102 | 1.365188198210173 | -6.905e-4 | 4.182e-5 |
| 10 | 1.365219506354675 | 1.3652195063547 | 1.365219506354675 | -1.7351e-4 | 1.051e-5 |
| 11 | 1.36522737329005 | 1.3652273732901 | 1.36522737329005 | -4.3597e-5 | 2.640e-6 |
| 12 | 1.36522935002777 | 1.3652293500278 | 1.36522935002777 | -1.0955e-5 | 6.634e-7 |

- **Rate.** Observed error ratio settles at 0.251271. The theoretical value with b fixed, $1 - f'(x^*)(b - x^*)/(f(b) - f(x^*))$, is 0.25127071. The script comment's "about 0.251" (line 6) is right.
- **Reference values.** Comment root 1.36523 (line 8); true root 1.3652300134, residual 0 at 60 digits. Brentq agrees. The script draws no separate "exact" value.
- **Picture.** Secant built from the previous bracket, through both its endpoints and c (max residual 3.7e-15). Band is the updated bracket. Gray diamonds are earlier c values `1:(frame-1)`, red is the current one. 13 frames (initial plus 12), all distinct. Axis limits show every feature; nothing is clamped. Frames 1, 2, 3, 5, 7, 9, 11 and 13 were viewed, and the legends of all frames.

### `regulafalsibb.jl`

- **Method.** Same plain Regula Falsi.
- **Numbers.**

| k | Script c_k | Independent (mpmath) | f(c_k) | error |
|---|---|---|---|---|
| 1 | 0.6850733573260451 | 0.68507335732605 | -0.089299 | 0.05401 |
| 2 | 0.736298997613654 | 0.73629899761365 | -0.00466 | 2.786e-3 |
| 3 | 0.7389453559657132 | 0.73894535596571 | -2.3393e-4 | 1.398e-4 |
| 4 | 0.7390781308800257 | 0.73907813088003 | -1.1719e-5 | 7.002e-6 |
| 5 | 0.7390847824489231 | 0.73908478244892 | -5.8705e-7 | 3.508e-7 |
| 6 | 0.7390851156443783 | 0.73908511564438 | -2.9407e-8 | 1.757e-8 |
| 7 | 0.7390851323349952 | 0.739085132335 | -1.4731e-9 | 8.802e-10 |
| 8 | 0.7390851331710709 | 0.73908513317107 | -7.3789e-11 | 4.409e-11 |
| 9 | 0.7390851332129521 | 0.73908513321295 | -3.6963e-12 | 2.209e-12 |
| 10 | 0.73908513321505 | 0.73908513321505 | -1.8516e-13 | 1.106e-13 |

- **Rate.** Observed ratio 0.0500926; theoretical 0.05009256.
- **Floating point.** The concern at this accuracy is a rounding-induced sign flip that would move b. It does not happen: all 10 computed f(c) are negative in double precision and `nextb` stays 1.0.
- **Reference values.** Comment root 0.7391 (line 5); true 0.7390851332.
- **Picture.** Same construction (max residual 8.7e-17). 11 frames (initial plus 10), all distinct. Frames 1, 2 and 11 viewed at full size, plus the 11-frame contact sheet and the legends of all frames.

### Reproducibility

`cmp` shows both committed GIFs byte-identical to fresh scratch runs, so the frames reviewed are what these scripts produce. `git status --short` in the repository was empty after the work.

### 4. Legacy archive

Consulted `n2003/RegulaFalsiMod.html`, `regulafalsi/RegulaFalsiMod/Links/RegulaFalsiMod_lnk_1..4.html`, the formula and graph images, and `a2001/Animations/RootFinding/RegulaFalsi/`.

- **Example 3** ("Convergence", the only case under "Various Scenarios and Animations"): $x^3 + 4x^2 - 10 = 0$ on $[-1, 2]$, 15 iterations. This is Case A. The script's "Matches the legacy Mathews module example" (line 3) is correct, and its 12 iterates equal Mathews' first 12 to the printed digits. Stopping at 12 of the 15 steps does not change any claim.
- **Example 1**: same cubic on $[1, 2]$ with a subroutine call, no animation.
- **Example 2**: `RegulaFalsi[0, 1, 30]`, a caution about an interval where the cubic has no sign change (f(0) = -10, f(1) = -5). No animation.
- **Could not determine:** the motion of the legacy animation. `RegulaFalsiaa.html` references `RegulaFalsiaa.gif`, but that file is not in the archive. Image `RegulaFalsiMod_gr_13.gif` is also missing. Neither affects a verdict, since Example 3's code and iteration table are present.
- No fidelity finding. The one archive animation is reproduced, and Examples 1 and 2 are static subroutine demonstrations rather than animation cases.

