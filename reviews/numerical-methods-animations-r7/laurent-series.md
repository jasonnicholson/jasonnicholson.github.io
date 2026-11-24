# Laurent Series — animation review (round 7)

Page: `pages/numerical-methods/laurent-series/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** 0 Error, 0 Misleading, 0 Minor.

Every checkable claim on the page agreed with an independent computation at the precision stated. The evidence is in parts 2 and 3. Two things a reader of this report may want to weigh, neither of which I count as a finding:

- **Case 06 alt text**, "The sum follows the curve on both shaded intervals". In the last frame the sum is within 0.05 of $f$ on $(-2.314,-1.202)$ and $(1.389,2.725)$, which is 56% and 67% of the two shaded intervals. It departs near each interval end, as any truncation must near a pole or a convergence boundary. The Behavior paragraph gives the honest quantified version (error below 0.19 and 0.02 on the inner subintervals), so a reader is not misled.
- **Case 04**, "leaves the window near $x=5.69$". This is the exit to the right of the expansion point $x=3$, which is the direction the sentence is discussing. The polynomial also leaves the top of the window on the left, close to the pole at $x=1$.

**Could not determine:** the exact example functions in Mathews' module, because its formula images are missing locally (see "Legacy archive" in part 3). The page makes no claim that depends on them.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `laurent_animations_all.jl` | 0 | 19.9 | 8 GIFs (laurent01.gif … laurent08.gif) | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `laurent01.gif` | 14 | byte-identical | laurent_animations_all |
| `laurent02.gif` | 12 | byte-identical | laurent_animations_all |
| `laurent03.gif` | 10 | byte-identical | laurent_animations_all |
| `laurent04.gif` | 10 | byte-identical | laurent_animations_all |
| `laurent05.gif` | 14 | byte-identical | laurent_animations_all |
| `laurent06.gif` | 12 | byte-identical | laurent_animations_all |
| `laurent07.gif` | 12 | byte-identical | laurent_animations_all |
| `laurent08.gif` | 12 | byte-identical | laurent_animations_all |

### Page references

- Scripts linked: `laurent_animations_all.jl`, `laurent_animations_all.jl`, `laurent_animations_all.jl`, `laurent_animations_all.jl`, `laurent_animations_all.jl`, `laurent_animations_all.jl`, `laurent_animations_all.jl`, `laurent_animations_all.jl`
- GIFs embedded: 8
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

Verdicts: **C** confirmed, **W** wrong, **?** could not determine. Evidence codes refer to the checks in part 3.

### Description

| # | Claim (page's words) | Verdict | Evidence |
|---|---|---|---|
| D1 | $f=\sum a_k(x-x_0)^k$ with $a_k=\frac{1}{2\pi i}\oint_C f(z)(z-x_0)^{-k-1}dz$ | C | This integral, evaluated numerically, reproduces every script coefficient (A1) |
| D2 | $C$ is any positively oriented circle about $x_0$ in the annulus | C | Standard (Cauchy); radii used in A1 lie inside each annulus |
| D3 | Terms with $k<0$ form the principal part | C | Definition |
| D4 | Coefficients unique for a given annulus; several singularities give a different series in each annulus | C | Cases 05–07 computed: three different coefficient sets for one function (A1) |
| D5 | $f$ analytic on the whole disk: negative coefficients zero, series is Taylor | C | Cases 01, 02, 05: $\lvert a_k\rvert<10^{-61}$ for $k=-8..-1$ (A3) |
| D6 | $f$ analytic on a connected region containing the annulus with a non-removable singularity on or inside the inner circle: some negative power is nonzero | C | Proof: if all negative coefficients vanish, a power series $g$ analytic on the disk equals $f$ on the annulus. Any part of the region inside the inner circle joins the annulus within the disk, so $f=g$ there by the identity theorem and the singularity is removable, a contradiction |
| D7 | $(x-x_0)^{-k}$ is infinite at $x_0$ and tends to 0 as $\lvert x\rvert\to\infty$ | C | Elementary |
| D8 | A polynomial has no vertical asymptote and, unless constant, no horizontal asymptote | C | Elementary |

### Animations introduction

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| I1 | Each frame adds terms to the partial sum | C | Term counts strictly increase in all 8 cases (A2) |
| I2 | Sum blue, $f$ magenta | C | Code colours `steelblue`, `magenta`; frames |
| I3 | Dashed black lines are the asymptotes of $f$ | C | Case table against each $f$: 01 $y=0$; 02 $y=0$; 03 $x=0,y=0$; 04 $x=\pm1,y=1$; 05–07 $x=-3,x=1,y=0$; 08 $x=0,y=1$ |
| I4 | Green shading marks where the series converges on the real line | C | Region of each row matches the annulus; at every finite shading edge the terms do not tend to 0 (A5) |
| I5 | Orange is the Taylor polynomial about a regular point inside the shaded region, in the cases with negative powers | C | Cases 03, 04, 06, 07, 08 with centers 1, 3, 2, 5, 1, all inside shading; coefficients verified (A4) |
| I6 | Orange has the same number of terms as blue | C | Degree is `nterms-1` in every frame; no Taylor coefficient is zero (smallest $\lvert c_k\rvert$ 5.96e-8) (A4) |
| I7 | The legend lists the powers included | C | Labels dumped for all 96 frames match the power lists (A2) |

### Case 01, $\sin x/x$

| # | Claim | Verdict | Computed |
|---|---|---|---|
| 1a | Heading: function, about 0, all $x$; GIF title matches | C | Row 01; title "sin(x)/x about 0: every negative power vanishes" |
| 1b | Series $1-x^2/6+x^4/120-\cdots$, no negative power | C | A1, A3 |
| 1c | Singularity at 0 is removable; series is the Taylor series; converges for every $x$ | C | A3; entire series |
| 1d | Interval within 0.01 widens with every frame | C | 0.245, 1.054, 1.939, 2.811, 3.662, 4.497, 5.318, 6.128, 6.930, 7.725, 8.514, 9.298, 10.079, 10.856 |
| 1e | From about $\lvert x\rvert\le0.25$ to about $\lvert x\rvert\le10.9$ | C | 0.245 and 10.856 |
| 1f | Alt text: window $-14$ to 14, wider match each frame | C | `xlims`; 1d |
| 1g | Link and embed | C | `laurent_animations_all.jl`, `laurent01.gif` |

### Case 02, $1/(1+x^2)$

| # | Claim | Verdict | Computed |
|---|---|---|---|
| 2a | Heading; GIF title | C | Row 02 |
| 2b | Series $1-x^2+x^4-\cdots$, no negative powers | C | A1, A3 |
| 2c | Radius 1, set by poles at $\pm i$, not on the real line | C | Roots of $1+x^2$; terms at $x=\pm1$ have size 1 (A5) |
| 2d | At $x=0.9$ error falls every frame, 0.448 to 0.044 | C | Monotone; 0.4475, 0.0441 |
| 2e | At $x=1.2$ error grows every frame, 0.590 to 32.6 | C | Monotone; 0.5902, 32.5807 |
| 2f | Alt text: shaded $[-1,1]$; settle inside, swing away outside | C | Last-frame error below 0.05 on $(-0.905,0.905)$ |
| 2g | Link and embed | C | `laurent02.gif` |

### Case 03, $\sin x/x^3$

| # | Claim | Verdict | Computed |
|---|---|---|---|
| 3a | Heading; GIF title | C | Row 03 |
| 3b | $f=x^{-2}-\frac16+\frac{x^2}{120}-\cdots$ for $x\ne0$ | C | A1, A3 ($a_k=0$ for $k<-2$ and odd $k$) |
| 3c | $f-x^{-2}\to-\frac16$ as $x\to0$ | C | $a_0=-1/6$ |
| 3d | At $x=0.05$, $f=399.83$ | C | 399.83335 |
| 3e | Last sum has powers $-2$ to 16 and gives 399.83 | C | 399.83335 |
| 3f | Degree-9 Taylor about 1, same 10 terms, gives 40.6 | C | script 40.5912; mpmath 40.5912 |
| 3g | Full Taylor series about 1 converges only on $0<x<2$ | C | Radius 1; endpoint terms grow (51, 101, 201 at $k=50,100,200$) |
| 3h | Frame 1 sum tends to $y=0$; frame 2 to $-\frac16$; frames 3 on unbounded | C | Frame power lists; $a_0=-1/6$ |
| 3i | In Case 04 every partial sum tends to the horizontal asymptote | C | See 4c |
| 3j | Alt text: sums follow both sides; orange finite at 0, on the curve near 1, leaves before 2 | C | Orange departs by 0.05 at $x=1.614$ |
| 3k | Link and embed | C | `laurent03.gif` |

### Case 04, $(x^2+1)/(x^2-1)$

| # | Claim | Verdict | Computed |
|---|---|---|---|
| 4a | Heading; GIF title | C | Row 04 |
| 4b | $f=1+2x^{-2}+2x^{-4}+\cdots$ for $\lvert x\rvert>1$ | C | A1, A3 |
| 4c | Every partial sum tends to 1, the horizontal asymptote | C | Constant term 1, no positive power |
| 4d | Last frame powers $-18$ to 0, within 0.0011 on $1.5\le\lvert x\rvert\le10$ | C | Max error 0.0010826 |
| 4e | Degree-9 Taylor about 3, same 10 terms, leaves the window near 5.69 | C | Exits $y=-3$ at $x=5.6855$ |
| 4f | It equals $-3.06\times10^4$ at $x=10$, where $f=1.0202$ | C | $-30625.016$; 1.020202 |
| 4g | Full Taylor about 3 converges only on $1<x<5$ | C | Radius 2; endpoint term size 0.5 |
| 4h | At $x=0.5$ the last sum is $6.99\times10^5$, $f=-1.67$ | C | 699049; $-1.66667$ |
| 4i | Alt text: sums level off at $y=1$ outside $x=\pm1$; orange matches near 3, leaves before 5 | C | Orange departs by 0.05 at $x=4.69$ |
| 4j | Link and embed | C | `laurent04.gif` |

### Case 05, disk

| # | Claim | Verdict | Computed |
|---|---|---|---|
| 5a | Heading; GIF title | C | Row 05 |
| 5b | $f=\frac1{x-1}-\frac1{x+3}$; poles at 1 and $-3$; three regions | C | Partial fractions; A1 |
| 5c | $a_k=-1-(-1)^k/3^{k+1}$, $k\ge0$ | C | Max relative error 1.1e-16 against the Cauchy integral |
| 5d | At $x=0.5$: $-2.28559$ against $f=-2.28571$ | C | $-2.2855922$; $-2.2857143$ |
| 5e | At $x=1.5$: $-582$ against $f=1.78$ | C | $-582.08$; 1.7778 |
| 5f | Alt text: shaded $[-1,1]$; settle inside, leave outside; dashed $x=-3,1$, $y=0$ | C | Last-frame error below 0.05 on $(-0.843,0.734)$; frames |
| 5g | Link and embed | C | `laurent05.gif` |

### Case 06, annulus

| # | Claim | Verdict | Computed |
|---|---|---|---|
| 6a | Heading; GIF title | C | Row 06 |
| 6b | $a_k=-(-1)^k/3^{k+1}$ for $k\ge0$; $a_k=1$ for $k<0$ | C | Max relative error 8.5e-17 |
| 6c | One series covers $-3<x<-1$ and $1<x<3$ | C | Region; terms at $\pm1,\pm3$ do not tend to 0 (A5) |
| 6d | Last frame powers $-12$ to 12; error below 0.19 on $[-2.5,-1.5]$ | C | 0.18693 |
| 6e | Error below 0.02 on $[1.5,2.5]$ | C | 0.01700 |
| 6f | Degree-24 Taylor about 2, 25 terms, more accurate on second interval, error below $10^{-7}$ | C | 5.96e-8; smaller than the Laurent error at every grid point |
| 6g | Full Taylor about 2 converges only on $1<x<3$ | C | Radius 1; endpoint term size 1 |
| 6h | At $x=-2$ the polynomial is $3.8\times10^{14}$, $f=-1.33$ | C | 3.753e14; $-1.3333$ |
| 6i | Alt text: sum follows both shaded intervals, orange only the right-hand one | C | Blue within 0.05 on 56% and 67% of the intervals; orange on 0% of the left and 87% of the right |
| 6j | Link and embed | C | `laurent06.gif` |

### Case 07, exterior

| # | Claim | Verdict | Computed |
|---|---|---|---|
| 7a | Heading; GIF title | C | Row 07 |
| 7b | $a_{-k}=1-(-3)^{k-1}$, $k\ge1$ | C | Max relative error 1.8e-57 for $k=2..13$; $a_{-1}=0$ by the integral |
| 7c | $x^{-1}$ coefficient is zero; begins $4x^{-2}-8x^{-3}+28x^{-4}$ | C | A1, A3 |
| 7d | No constant or positive power; every sum tends to 0 | C | $\lvert a_k\rvert<2\times10^{-57}$, $k=-1..8$ |
| 7e | Last frame powers $-13$ to $-2$; error below $7\times10^{-4}$ on $5\le\lvert x\rvert\le12$ | C | 6.530e-4 |
| 7f | Degree-11 Taylor about 5, 12 terms, equals $-75.0$ at 12, $f=0.0242$ | C | $-74.963$; 0.024242 |
| 7g | Full Taylor about 5 converges only on $1<x<9$ | C | Radius 4; endpoint term size 0.25 |
| 7h | Alt text: sums follow toward $y=0$ both sides; orange leaves before 9 | C | Orange departs by 0.05 at $x=8.696$ |
| 7i | Link and embed | C | `laurent07.gif` |

### Case 08, $e^{1/x}$

| # | Claim | Verdict | Computed |
|---|---|---|---|
| 8a | Heading; GIF title | C | Row 08 |
| 8b | $e^{1/x}=1+x^{-1}+x^{-2}/2!+\cdots$ for $x\ne0$ | C | A1, A3 |
| 8c | Essential singularity; $f\to+\infty$ at $0^+$, $f\to0$ at $0^-$, $f\to1$ at infinity | C | Infinitely many nonzero negative coefficients; limits elementary |
| 8d | Every sum tends to 1 | C | $a_0=1$, no positive power |
| 8e | Every sum lies below $f$ for $x>0$ | C | The omitted tail is a sum of positive terms. Numerically $\min(f-S)=-8.9\times10^{-16}$, which is roundoff at large $x$ |
| 8f | Last sum powers $-11$ to 0 gives 147.6 at $x=0.2$, $f=148.4$ | C | 147.6038; 148.4132 |
| 8g | Degree-11 Taylor about 1, 12 terms, gives 44.5 | C | 44.5324 |
| 8h | Full Taylor about 1 converges only on $0<x<2$ | C | Radius 1; endpoint terms grow (3.4e4, 7.1e6, 1.7e10 at $k=50,100,200$) |
| 8i | Any sum with a negative power has a pole at 0 and departs from $f$ on the left | C | Leading term $a_{-n}x^{-n}$ |
| 8j | At $x=-0.1$ the last sum is about $-1163$, $f\approx4.5\times10^{-5}$ | C | $-1162.62$; 4.54e-5 |
| 8k | Alt text: rise along $x=0$ from the right, level off toward $y=1$, orange leaves before 2 | C | Orange departs by 0.05 at $x=1.572$; frames |
| 8l | Link and embed | C | `laurent08.gif` |

### 3. Implementation checks

### `laurent_animations_all.jl`

**It is the method it claims to be.** Each frame evaluates a truncated Laurent sum $\sum a_kx^k$ over the listed powers from a closed-form coefficient for that region. The comparison curve is a truncated Taylor polynomial evaluated by Horner's rule.

**The numbers are right.**

- **A1, coefficients.** For all 8 cases I evaluated $a_k=\frac1{2\pi}\int f(\rho e^{i\theta})(\rho e^{i\theta})^{-k}d\theta$ at 70 digits with a 256-point trapezoid rule, on a circle inside the case's region (`review/indep.py`). This does not use the page's or script's formulas.

  | Case | Radius | Coefficients | Max relative error, script vs integral |
  |---|---|---|---|
  | 01 | 1 | 27 | 1.3e-16 |
  | 02 | 1/2 | 23 | 8.0e-66 |
  | 03 | 1 | 19 | 7.8e-17 |
  | 04 | 2 | 19 | 2.6e-67 |
  | 05 | 1/2 | 14 | 1.1e-16 |
  | 06 | 2 | 25 | 8.5e-17 |
  | 07 | 5 | 12 | 1.8e-57 |
  | 08 | 1 | 12 | 8.6e-17 |

- **A2, frames.** Script dump for all 96 frames: first and last powers, nonzero term count and legend label. Term counts increase strictly in every case. Last frames: 01 powers 0..26 even (14 terms); 02 0..22 even (12); 03 $-2$..16 even (10); 04 $-18$..0 even (10); 05 0..13 (14); 06 $-12$..12 (25); 07 $-13$..$-2$ (12); 08 $-11$..0 (12).
- **A3, zero coefficients.** The Cauchy integral gives below $2\times10^{-57}$ for every coefficient the page says vanishes: negative powers in 01, 02, 05; $k<-2$ and odd $k$ in 03; positive and odd negative in 04; $k\ge-1$ in 07; positive in 08; odd in 01.
- **A4, Taylor comparison polynomials.** The same integral about the expansion point, for all coefficients in all frames:

  | Case | Center | Max degree | Max relative error | Smallest $\lvert c_k\rvert$ |
  |---|---|---|---|---|
  | 03 | 1 | 9 | 3.2e-16 | 0.841 |
  | 04 | 3 | 9 | 1.1e-69 | 9.8e-4 |
  | 06 | 2 | 24 | 5.6e-17 | 0.8 |
  | 07 | 5 | 11 | 1.0e-69 | 6.0e-8 |
  | 08 | 1 | 11 | 1.5e-16 | 2.72 |

- **A5, region edges.** Term sizes $\lvert a_kx^k\rvert$ at each finite shading edge do not tend to 0 (02: 1; 04: 2; 05: 1; 06: 1 at $\pm1$ and 1/3 at $\pm3$; 07: 1/3), so the open intervals are right. Taylor intervals: terms at the endpoint of each claimed interval stay bounded away from 0 or grow (ledger 3g, 4g, 6g, 7g, 8h).

**Reference values are right.** The magenta curve is the stated $f$ in each row. On the full plotting grid, for all 8 cases, the script's `yf` agrees with a separately written $f$ to at most 3.8e-16 relative (`review/gridcheck.py`). Cases 04–07 were written there in the partial-fraction or $1+2/(x^2-1)$ form rather than the script's form.

**The picture shows what was computed.**

- On every grid point of all 96 frames, the plotted Laurent sum agrees with my evaluation from the Cauchy coefficients to at most 3.6e-15 relative to the largest summand, and the plotted Taylor polynomial to at most 3.0e-15. The NaN patterns (breaks at poles and at $x=0$) match exactly.
- **Pixel check.** I re-rendered all eight GIFs from the independent coefficients and independent $f$ through the script's renderer (`review/rerender.jl`). Decoded frames differ from the committed GIFs in **0 pixels across all 96 frames** (`review/cmpframes.py`).
- Each pole in `poles` is inserted in the grid and set to NaN, so no spurious vertical line joins the two sides of a pole. Sheets and last frames confirm this.
- I read all eight contact sheets, and the last frames of Cases 01, 05, 06 and 08 at full size. Titles match the headings. Case 01 and 05 sheets omit the final frame, so those were viewed directly. No clamping is used. The y-limits hide large values of the sums outside the region, but the page states those values in the text, so nothing is misrepresented.

**Value probes**, script against independent:

| Quantity | Script | Independent |
|---|---|---|
| C03 $S(0.05)$ | 399.8333541654266 | 399.83335 |
| C03 $T_9(0.05)$ | 40.59119062232734 | 40.5912 |
| C04 $S(0.5)$ | 699049.0 | 699049.0 |
| C04 $T_9(10)$ | $-30625.016003608704$ | $-30625.016003608704$ |
| C05 $S(0.5)$ | $-2.2855922153981396$ | $-2.2855922153981396$ |
| C05 $S(1.5)$ | $-582.0807291666667$ | $-582.0807291666667$ |
| C06 $T_{24}(-2)$ | 3.7529996894754006e14 | 3.75299968947540e14 |
| C07 $T_{11}(12)$ | $-74.9627849280514$ | $-74.9627849280514$ |
| C08 $S(0.2)$ | 147.60384850489012 | 147.6038 |
| C08 $T_{11}(0.2)$ | 44.53235251562041 | 44.5324 |
| C08 $S(-0.1)$ | $-1162.6235369568699$ | $-1162.624$ |

### Legacy archive

Consulted: `/home/jason/Desktop/math-fullerton/baseline/mathews/c2003/LaurentSeriesMod.html` and its example links, read as text. The module has no animations (no "animat" text; no Laurent entry under `a2001/Animations`). Example 7.7 finds three Laurent series for one function, in a disk, an annulus and an exterior region, which is the structure of Cases 05–07.

The example functions could not be read because the formula images are missing locally, so I could not compare them with the page's functions. This does not produce a Fidelity finding: the page says plainly that its examples "were chosen for this page and are not attributed to him", so no archive case is silently dropped or misattributed.

