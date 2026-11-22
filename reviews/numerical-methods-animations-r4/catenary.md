# Catenary — animation review (round 4)

Page: `pages/numerical-methods/catenary/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I found no error, misleading statement, minor issue or fidelity departure that meets the review standard. Everything I checked is listed in the ledger and the implementation checks below.

Two things I noted that are **not findings**:

- Mathews writes the catenary as $y=c\cosh(x/c)-c$ (lowest point at the origin, images `CatenaryMod_gr_2.gif` and `gr_27`, plus `gr_3` in lnk_2), with parabola $x^2/(2c)$. The page uses the vertically shifted standard form $y=c\cosh(x/c)$ with parabola $x^2/(2c)+c$. This is a valid formulation that differs from the textbook's. The catenary-minus-parabola gap is identical in both forms, so none of the page's claims depend on the choice.
- The 500-point grid on $[-4,4]$ does not contain $x=0$ (the sampled minimum is at $x=\pm0.008$). The diamond marker is drawn at exactly $(0,c)$, and the difference cannot be seen.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `catenaryaa.jl` | 0 | 6.8 | catenaryaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `catenaryaa.gif` | 25 | byte-identical | catenaryaa |

### Page references

- Scripts linked: `catenaryaa.jl`
- GIFs embedded: 1
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | Intro, l.12 | catenary $y=c\cosh(x/c)$ | script l.13 `c .* cosh.(x ./ c)`; frame titles and legend | confirmed |
| 2 | l.12 | parabolic approximation $y=x^2/(2c)+c$ | script l.14 `x .^ 2 ./ (2c) .+ c` | confirmed |
| 3 | l.12 | $c$ increases from 0.5 to 4 | `range(0.5,4.0,length=25)`; instrumented: first=0.5, last=4.0; frame 1 title "c = 0.5", frame 25 "c = 4.0" | confirmed |
| 4 | l.12 | $c$ = horizontal tension / weight per unit length; larger $c$ is tauter and flatter | standard: $c=H/w$; for a fixed span, larger $c$ means less sag | confirmed |
| 5 | l.12 | the parabola is the first two terms of the Maclaurin series | sympy: $c\cosh(x/c)=c+x^2/(2c)+x^4/(24c^3)+x^6/(720c^5)+O(x^8)$ | confirmed |
| 6 | l.14 | Julia source scripts are linked under each case | l.23 links `catenaryaa.jl` | confirmed |
| 7 | l.16 | Case 1 follows Exploration 2 ("Approximated by a parabola"), which finds the Maclaurin series | Archive: in CatenaryMod.html the label "Exploration 2." links to lnk_3, titled "Approximated by a parabola", which asks "Find the Maclaurin series" | confirmed |
| 8 | l.17 | Exploration 1: catenaries with different $c$ are scaled copies of one shape | lnk_2: "the 'shape' of the curve is preserved ... merely magnified by the scale factor" | confirmed |
| 9 | l.17 | arc-length Exploration 3 | label "Exploration 3." links to lnk_4, "Arc Length" | confirmed |
| 10 | l.17 | catenary-fit section | CatenaryMod.html has a "Catenary Fit" section | confirmed |
| 11 | l.17 | Examples 1–2 solve numerically for the $c$ of the catenary through the origin and two points at equal height on either side of the $y$-axis, compute its arc length with Simpson's rule, and compare with the parabola through the same three points | lnk_5: `pts = {{-a,b},{0,0},{a,b}}`, a=10, b=6, "Solve the equation" $-c+c\cosh(10/c)=6$, "approximated numerically by using Simpson's rule"; lnk_6: parabola through the origin and (10,6), compared with the catenary | confirmed |
| 12 | l.17 | those items are not animated here | there is only one case and one script | confirmed |
| 13 | heading l.19 | Case 1: catenary vs parabola approximation as $c$ varies | the script and GIF show exactly this | confirmed |
| 14 | Behavior l.21 | for large $c$ the curves are nearly indistinguishable near $x=0$ | c=4: gap 6.5e-4 at x=1, 0.0105 at x=2, first exceeds 0.1 at \|x\|≈3.50, 0.172 at x=4. Frame 25 shows the curves overlapping except near the edges | confirmed |
| 15 | l.21 | for small $c$ the catenary climbs more steeply than the parabola | $\sinh u > u$ for $u>0$; frame 1 | confirmed |
| 16 | l.21 | at $c=0.5$ the gap passes 0.1 at $\|x\|\approx0.73$ | brentq: 0.72712; the script's grid first exceeds it at x=0.7295 | confirmed |
| 17 | l.21 | at $c=0.5$ the catenary leaves the top of the plot at $\|x\|\approx1.94$ | $0.5\cosh(2x)=12 \Rightarrow x=1.93538$; ylims=(0,12); frame 1 shows the exit at about 1.9 | confirmed |
| 18 | l.21 | ...the parabola at $\|x\|\approx3.39$ | $x^2+0.5=12 \Rightarrow x=\sqrt{11.5}=3.39116$; frame 1 shows the exit at about 3.4 | confirmed |
| 19 | l.21 | the catenary never lies below the parabola; difference $x^4/(24c^3)+x^6/(720c^5)+\cdots$ is positive for $x\ne0$ | sympy series as in #5 (all coefficients positive); the minimum gap on the grid is ≥ 0 for c=0.5, 2.25, 4 (1.4e-9, 1.5e-11, 2.7e-12) | confirmed |
| 20 | l.21 | the lowest point is always at $(0,c)$ | $\cosh$ has its minimum at 0; script l.28 marks $(0,c)$; frames show the diamond at the apex | confirmed |
| 21 | l.21 | the curves for parameter $c$ are the $c=1$ curves $y=\cosh x$, $y=x^2/2+1$ scaled by factor $c$ about the origin; flattening is from viewing larger copies through a fixed window | algebra: $(x,y)=c(u,\cosh u)$ and $c(u,u^2/2+1)\Rightarrow y=x^2/(2c)+c$. Instrumented: the residual of the script's arrays against $c\cdot f_1(x/c)$ is 0 (catenary) and ≤3.6e-15 (parabola). The axes are fixed at (-4,4)×(0,12) | confirmed |
| 22 | link l.23 | `[Julia source](catenaryaa.jl)` | the file exists and is the script that produces this GIF | confirmed |
| 23 | embed l.25 | embeds `catenaryaa.gif` | regenerated from a scratch copy, byte-identical (md5 158e49ee…) | confirmed |
| 24 | alt text l.25 | catenary vs parabola as $c$ sweeps from 0.5 to 4; the curves nearly coincide near the apex for large $c$ | as #1–3 and #14 | confirmed |
| 25 | frames | legend: blue solid = catenary, red dashed = parabola, black diamond = lowest point $(0,c)$ | script l.24–29; frames 1, 13 (sheet), 25 | confirmed |
| 26 | count | 25 frames | `length(c_values)=25`; 25 frames extracted | confirmed |

### 3. Implementation checks — `catenaryaa.jl`

- **It is the method it claims to be.** The page has no numerical method, only a function and its truncated Maclaurin series. The script evaluates $c\cosh(x/c)$ and $x^2/(2c)+c$ directly (l.13–14), and these match the title, the legend and the page.
- **The numbers are right.** In an instrumented copy (`review/instr.jl`, run with `julia instr.jl`), each script expression matches the independent Python/sympy value (`review/check.py`):

| quantity | script grid | independent |
|---|---|---|
| c=0.5: gap first > 0.1 | x=0.7295 (grid) | 0.72712 (brentq) |
| c=0.5: catenary > 12 | x=1.9479 (grid) | 1.93538 |
| c=0.5: parabola > 12 | x=3.4068 (grid) | 3.39116 |
| c=4: gap at x=4 | 0.172323 | 0.172323 |
| c=0.5: gap at x=4 | 728.7396 | 728.7396 |
| min gap, c=0.5 / 2.25 / 4 | 1.4e-9 / 1.5e-11 / 2.7e-12 (≥0) | ≥0 (series has all positive terms) |

  The differences in the "grid" rows are only the grid spacing of 0.016. The Maclaurin series is from sympy: `series(c*cosh(x/c), x, 0, 8)` gives `c + x**2/(2*c) + x**4/(24*c**3) + x**6/(720*c**5)`.
- **Its reference values are right.** There is no separate reference. The "approximation" is the two-term series, which sympy confirms.
- **The picture shows what was computed.** I viewed frame 1 (c=0.5), the contact sheet (c=0.5, 0.94, 1.38, 1.81, 2.25, 2.69, 3.12, 3.56, 4.0) and frame 25 (c=4.0). The curves, the apex diamond, the legend and the title c values match the code. The parameter values in the titles are `round(c,2)` of `range(0.5,4,25)`. Fixed axes (-4,4)×(0,12) clip the steep curves at small c, which is what the page describes (#17–18); no feature the page discusses falls outside the window. The legend at `:top` does not hide any curve crossing. Regeneration: the scratch copy is identical to the committed script, exit 0, and its output GIF is byte-identical to the committed GIF.

**Archive comparison.** Mathews' numbering is confirmed through the hyperlinks from the "Exploration N." labels: 1 → lnk_2 (scaling), 2 → lnk_3 (parabola / Maclaurin), 3 → lnk_4 (arc length). The Example 1 data (a=10, b=6, points (±10,6) and (0,0), Simpson's rule) and the Example 2 parabola comparison match the page's description. The archive images for the Exploration 2 graphs (`gr_30`–`gr_46`) are missing, so I could not see which $c$ Mathews plotted there. The page's sweep over $c\in[0.5,4]$ is the author's choice, and it does not misstate anything about Mathews' example.

