# Derive Numerical Differentiation Formulae — animation review (round 7)

Page: `pages/numerical-methods/derive-numerical-differentiation-formulae/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Errors 0, Misleading 0, Minor 0, across implementation, page match and fidelity.


#### Observed and deliberately not reported

These are real properties of the page. Each is below the finding threshold in the review standard, and each is recorded so the owner can overrule that judgement.

1. **Case 1 dashed line is parallel to the chord, not the chord.** `diffformaa.jl:31` draws the line through $(x_0,f(x_0))$ with the central-difference slope, so it does not pass through the outer stencil points (at $h=0.6$ the line is 0.3394 at $x=0.4$, while $f(0.4)=0.2610$). The legend says "formula slope" and the alt text says "slope line"; neither calls it a secant, and the slope drawn is the slope computed.
2. **Case 3 legend covers part of the curves.** The opaque legend hides the curves for $x\in[2.677,3.036]$ in every frame, and so hides the right end of the stencil window $\pi-2h$ in 3 of 11 frames ($h=0.18,0.12,0.08$). No claim on the page depends on seeing that end, and the window is stated in the title.
3. **The 5.9e-11 in Case 3 depends on the sampling grid.** It is a rounding maximum over the script's 700 points, and the page quotes it correctly as what the frame shows. Other grids give 5.6e-11 to 9.3e-11 at $h=0.002$. The rise from $h=0.005$ occurred at all six densities tested (350, 700, 701, 1400, 7000, 70000), so the page's qualitative claim is robust.
4. **Forward and backward formulas are not on the page.** The archive's appendix generates them symbolically. The page states its scope as central formulas and the archive has no worked numerical case for them, so this is content the page does not have rather than a dropped case.

## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `diffformaa.jl` | 0 | 8.3 | diffformaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `diffformab.jl` | 0 | 8.0 | diffformab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `diffformac.jl` | 0 | 9.0 | diffformac.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `diffformaa.gif` | 12 | byte-identical | diffformaa |
| `diffformab.gif` | 11 | byte-identical | diffformab |
| `diffformac.gif` | 11 | byte-identical | diffformac |

### Page references

- Scripts linked: `diffformaa.jl`, `diffformab.jl`, `diffformac.jl`
- GIFs embedded: 3
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | Description | Central formulas "derived from Taylor expansions and solved in parallel as small linear systems" | Archive text and images: Taylor equations solved together with `Solve` | Confirmed |
| 2 | Description | Legacy module derives "first- and second-derivative formulas together" | Archive: "parallel development" | Confirmed |
| 3 | Description | For symmetric stencils, odd and even Taylor terms cancel predictably | Moment systems: only the expected moments survive for each derivative | Confirmed |
| 4 | Description | Wider stencils "can significantly improve accuracy for smooth functions" | Case 2 err3/err5 is 108 at $h=0.35$, about $1.1\times10^5$ at $h=0.01$ | Confirmed |
| 5 | Animations intro | Test function $f(x)=e^{-x}\sin x$ in each animation | Line 8 or 9 of each script; frames | Confirmed |
| 6 | Animations intro | Case 1 is three-point first derivative | `diffformaa.jl:11` | Confirmed |
| 7 | Animations intro | Cases 2 and 3 compare three- and five-point stencils for first and second derivative | `diffformab.jl:12-13`, `diffformac.jl:12-13` | Confirmed |
| 8 | Animations intro | Legacy module "derives the formulas symbolically and has no numerical example" | No "example" in any of the 4 HTML files; all 20 graph-sized images are symbolic Mathematica output | Confirmed |
| 9 | Case 1 heading | $f'(x_0)\approx [f(x_0+h)-f(x_0-h)]/(2h)$ | Derived weights $[-1/2,0,1/2]$; script matches | Confirmed |
| 10 | Case 1 Behavior | Slope "converges to the tangent slope as $h$ decreases" | Error falls monotonically, 6.144e-2 to 1.694e-7 | Confirmed |
| 11 | Case 1 Behavior | "second-order accuracy" | Observed order 2.000 to 2.009 across all 11 step changes | Confirmed |
| 12 | Case 1 alt | Stencil points and slope line converging to tangent "at x0 equals 1" | `x0 = 1.0`; markers within 0.38 px of computed positions | Confirmed |
| 13 | Case 1 link/embed | `diffformaa.jl`, `diffformaa.gif` | Instrumented copy reproduces the committed GIF byte for byte | Confirmed |
| 14 | Case 2 heading | $[f(x_0-2h)-8f(x_0-h)+8f(x_0+h)-f(x_0+2h)]/(12h)$ | Derived weights $[1/12,-2/3,0,2/3,-1/12]$; script matches | Confirmed |
| 15 | Case 2 Behavior | Cancels lower-order terms, "error drops faster than the three-point estimate for the same $h$" | Observed orders 3.78 to 4.00 against 2.00; err5 < err3 in all 11 frames | Confirmed |
| 16 | Case 2 Behavior | Green line "already lies on the red true tangent at $h=0.35$" | Frame 1 | Confirmed |
| 17 | Case 2 Behavior | Lines "differ by about 0.1 pixel at their ends" | $1.9193\times10^{-4}\times0.9\times391/0.65=0.104$ px, with the plot height measured from the frame | Confirmed |
| 18 | Case 2 Behavior | Five-point error is read from the $\lvert$err5$\rvert$ value printed in each frame | All 11 frames print it; values match the script | Confirmed |
| 19 | Case 2 alt | Stencil samples, dashed three-point line approaching tangent | Frames; dashed slope fit at $h=0.35$ is -0.08990 against -0.08998 | Confirmed |
| 20 | Case 2 alt | Five-point line on true tangent "in every frame", both errors printed | Largest offset is 0.104 px, in frame 1 | Confirmed |
| 21 | Case 2 link/embed | `diffformab.jl`, `diffformab.gif` | Byte-identical regeneration | Confirmed |
| 22 | Case 3 heading | Formulas on $[2h,\pi-2h]$ | `diffformac.jl:23`; printed window endpoints for all 11 $h$ | Confirmed |
| 23 | Case 3 Behavior | Compares $f''$ against the three- and five-point stencils | Derived weights $[1,-2,1]$ and $[-1/12,4/3,-5/2,4/3,-1/12]$; $f''$ verified symbolically | Confirmed |
| 24 | Case 3 Behavior | "both stencils use only points in $[0,\pi]$" | Over all frames, $\min(x-2h)=0$ and $\max(x+2h)-\pi=-1.2\times10^{-16}$ | Confirmed |
| 25 | Case 3 Behavior | Maximum errors "taken over this window" | `diffformac.jl:29-30` | Confirmed |
| 26 | Case 3 Behavior | "From $h=0.35$ to $h=0.005$ both maximum errors shrink" | Both sequences strictly decrease (table in section 3) | Confirmed |
| 27 | Case 3 Behavior | Five-point "stays closer in every frame" | Closer in maximum error in all 11 frames, and pointwise at all 700 points of every frame | Confirmed |
| 28 | Case 3 Behavior | At $h=0.002$ the five-point maximum error rises "from $5.5\times10^{-11}$ to $5.9\times10^{-11}$" | Script 5.516e-11 then 5.892e-11; frames print 5.52e-11 and 5.89e-11 | Confirmed |
| 29 | Case 3 Behavior | The rise is "because floating-point rounding now outweighs its truncation error" | 50-digit evaluation of the same stencil gives max 5.50e-11 at $h=0.005$ and 1.417e-12 at $h=0.002$; the floating-point value at $h=0.002$ is 42 times the truncation error | Confirmed |
| 30 | Case 3 alt | Exact curve on 0 to $\pi$, stencil curves on $2h$ to $\pi-2h$ | `diffformac.jl:21,23`; green begins at $x=0.698$ in frame 1 | Confirmed |
| 31 | Case 3 link/embed | `diffformac.jl`, `diffformac.gif` | Byte-identical regeneration | Confirmed |
| 32 | Derivation Notes | Taylor expansion of $f(x\pm h)$ | Standard expansion; matches the archive's equations | Confirmed |
| 33 | Derivation Notes | Three-point $f'$ is $O(h^2)$ | Leading moment $k=3$ | Confirmed |
| 34 | Derivation Notes | Three-point $f''$ is $O(h^2)$ | Leading moment $k=4$ | Confirmed |
| 35 | Derivation Notes | Five-point $f'$ and $f''$ are $O(h^4)$ | Leading moments $k=5$ and $k=6$; archive remainders $\tfrac1{30}h^4f^{(5)}$ and $\tfrac1{90}h^4f^{(6)}$ | Confirmed |
| 36 | Derivation Notes | Five-point $f'''$ and $f^{(4)}$ are "only $O(h^2)$" | Leading moments $k=5$ and $k=6$; archive remainders $h^2$ | Confirmed |

### 3. Implementation checks

The three scripts share one function and derivative set: `sympy` confirms the coded $f'$ and $f''$ are the derivatives of $f(x)=e^{-x}\sin x$ (difference simplifies to 0). Each instrumented copy regenerated its committed GIF byte for byte, so the numbers below are the numbers drawn.

### `diffformaa.jl`: three-point first derivative

- **Method:** the central difference; weights agree with the moment-system derivation.
- **Numbers:** across all 12 $h$, the script agrees with a 60-digit evaluation of the same formula to a relative 1.5e-13.
- **Reference:** $f'(1)=-0.110793765306699$ from the closed form and from `mp.diff`.
- **Picture:** markers lie within 0.38 px of $(x_0\pm h,f)$ in frames 1 to 4. The dashed fit at $h=0.6$ has slope -0.04932 (script -0.049354) and passes through $(1,0.3098)$ ($f(1)=0.30956$). Titles and annotations carry the right $h$ and values in all 12 frames.

| $h$ | Script approx | 60-digit approx | Error | Order |
|---|---|---|---|---|
| 0.6 | -0.049354 | -0.04935374268 | 6.144e-2 | |
| 0.4 | -0.083592 | -0.08359181012 | 2.720e-2 | 2.009 |
| 0.25 | -0.100189 | -0.1001894114 | 1.060e-2 | 2.004 |
| 0.15 | -0.106979 | -0.10697946 | 3.814e-3 | 2.002 |
| 0.1 | -0.109099 | -0.1090989768 | 1.695e-3 | 2.001 |
| 0.07 | -0.109963 | -0.109963411 | 8.304e-4 | 2.000 |
| 0.05 | -0.110370 | -0.1103701372 | 4.236e-4 | 2.000 |
| 0.03 | -0.110641 | -0.1106412645 | 1.525e-4 | 2.000 |
| 0.02 | -0.110726 | -0.1107259879 | 6.778e-5 | 2.000 |
| 0.01 | -0.110777 | -0.1107768211 | 1.694e-5 | 2.000 |
| 0.005 | -0.110790 | -0.1107895293 | 4.236e-6 | 2.000 |
| 0.001 | -0.110794 | -0.1107935959 | 1.694e-7 | 2.000 |

### `diffformab.jl`: five-point first derivative

- **Method:** the standard five-point central difference; weights agree with the derivation.
- **Numbers:** script and 60-digit stencil values differ by at most 1.8e-14 (three-point) and 2.0e-14 (five-point). At $h=0.002$ the frame prints 2.16e-13: this is the true error of the floating-point result (2.1604e-13 against the 60-digit $f'(1)$), while the exact-arithmetic truncation error is 2.3636e-13. The printed value is correct for what was computed.
- **Reference:** same $f'(1)$ as above.
- **Picture:** the four off-tangent stencil markers lie at their computed positions in frame 1 (for example $x=0.3$ at column 129.1 against 129.3). The dashed slope fit is -0.08990 against -0.08998. The script comment "at most $|err5|=1.92$e-4" is correct.

| $h$ | Script err3 | Script err5 | 60-digit err3 | 60-digit err5 | Order 3 | Order 5 |
|---|---|---|---|---|---|---|
| 0.35 | 2.08e-2 | 1.92e-4 | 2.081e-2 | 1.919e-4 | | |
| 0.25 | 1.06e-2 | 5.38e-5 | 1.060e-2 | 5.376e-5 | 2.004 | 3.782 |
| 0.18 | 5.49e-3 | 1.50e-5 | 5.494e-3 | 1.496e-5 | 2.002 | 3.894 |
| 0.12 | 2.44e-3 | 3.02e-6 | 2.441e-3 | 3.015e-6 | 2.001 | 3.950 |
| 0.08 | 1.08e-3 | 6.01e-7 | 1.085e-3 | 6.009e-7 | 2.000 | 3.978 |
| 0.05 | 4.24e-4 | 9.21e-8 | 4.236e-4 | 9.208e-8 | 2.000 | 3.991 |
| 0.03 | 1.53e-4 | 1.20e-8 | 1.525e-4 | 1.195e-8 | 2.000 | 3.997 |
| 0.02 | 6.78e-5 | 2.36e-9 | 6.778e-5 | 2.363e-9 | 2.000 | 3.999 |
| 0.01 | 1.69e-5 | 1.48e-10 | 1.694e-5 | 1.477e-10 | 2.000 | 4.000 |
| 0.005 | 4.24e-6 | 9.24e-12 | 4.236e-6 | 9.233e-12 | 2.000 | 4.000 |
| 0.002 | 6.78e-7 | 2.16e-13 | 6.778e-7 | 2.364e-13 | 2.000 | 4.000 |

### `diffformac.jl`: second-derivative profiles

- **Method:** three-point and five-point central second differences; weights agree with the derivation.
- **Numbers:** see the table; floating-point and 50-digit maxima agree until rounding takes over at $h=0.002$ for the five-point stencil.
- **Reference:** $f''(x)=-2e^{-x}\cos x$, verified symbolically.
- **Picture:** in frame 1 the green curve starts at $x=0.698$ (window 0.700) and stays within 0.82 px of $f''$ at the 38 sampled columns. Printed errors match the script in all 11 frames. The vertical limits contain the full $f''$ range on $[0,\pi]$ (minimum -2, maximum about 0.134).

| $h$ | Float max err3 | Float max err5 | 50-digit max err3 | 50-digit max err5 | Points where 5-pt is not closer |
|---|---|---|---|---|---|
| 0.35 | 1.306e-2 | 5.158e-4 | 1.306e-2 | 5.158e-4 | 0 |
| 0.25 | 6.689e-3 | 1.859e-4 | 6.689e-3 | 1.859e-4 | 0 |
| 0.18 | 3.474e-3 | 6.106e-5 | 3.474e-3 | 6.106e-5 | 0 |
| 0.12 | 1.546e-3 | 1.409e-5 | 1.546e-3 | 1.409e-5 | 0 |
| 0.08 | 6.875e-4 | 3.063e-6 | 6.875e-4 | 3.063e-6 | 0 |
| 0.05 | 2.686e-4 | 5.002e-7 | 2.686e-4 | 5.002e-7 | 0 |
| 0.03 | 9.671e-5 | 6.769e-8 | 9.671e-5 | 6.769e-8 | 0 |
| 0.02 | 4.299e-5 | 1.365e-8 | 4.299e-5 | 1.365e-8 | 0 |
| 0.01 | 1.075e-5 | 8.711e-10 | 1.075e-5 | 8.711e-10 | 0 |
| 0.005 | 2.687e-6 | 5.516e-11 | 2.687e-6 | 5.500e-11 | 0 |
| 0.002 | 4.299e-7 | 5.892e-11 | 4.299e-7 | 1.417e-12 | 0 |

### Could not determine

Nothing on the page was left undetermined. History and attribution claims were excluded as the brief directs.

