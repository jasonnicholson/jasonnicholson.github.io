# Newton-Raphson Method — animation review (round 8)

Page: `pages/numerical-methods/newton-raphson-method/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** There are 0 Error, 0 Misleading and 0 Minor findings.

Observations below the finding threshold:
- `newtoncc.gif` frame 8 has the legend `x₍7₎ = -0.0`. The true value is −1.56e−17, and the label shows it rounded to 5 digits (`round(x; digits=5)`, newtoncc.jl:58). This is a cosmetic display quirk and not misleading, because the iterate really is negative and essentially 0.
- The legend labels render as `x₍n₎`, with subscript parentheses around full-size digits (for example `x₍10₎`). They are readable, so this is cosmetic.

---



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `newtonaa.jl` | 0 | 6.9 | newtonaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtonbb.jl` | 0 | 6.6 | newtonbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtoncc.jl` | 0 | 7.0 | newtoncc.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtondd.jl` | 0 | 6.7 | newtondd.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtonee.jl` | 0 | 7.3 | newtonee.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtonff.jl` | 0 | 6.9 | newtonff.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `newtonaa.gif` | 6 | byte-identical | newtonaa |
| `newtonbb.gif` | 13 | byte-identical | newtonbb |
| `newtoncc.gif` | 9 | byte-identical | newtoncc |
| `newtondd.gif` | 11 | byte-identical | newtondd |
| `newtonee.gif` | 7 | byte-identical | newtonee |
| `newtonff.gif` | 7 | byte-identical | newtonff |

### Page references

- Scripts linked: `newtonaa.jl`, `newtonbb.jl`, `newtoncc.jl`, `newtondd.jl`, `newtonee.jl`, `newtonff.jl`
- GIFs embedded: 6
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| I1 | Intro | "At each iterate $x_n$, a tangent line … its x-intercept gives $x_{n+1}=x_n-f(x_n)/f'(x_n)$" | Every script uses `xs[i+1] = xs[i] - f/fp` with the correct analytic `fp`. Its iterates match the mpmath iterates that use numerical derivatives (table §3). The segment drawn from (x_n, f(x_n)) to (x_{n+1}, 0) lies on the tangent. | confirmed |
| I2 | Intro | "shows whether the iterates converge to a root, fall into a cycle, or diverge" | Cases 1–3 converge, case 4 cycles, and cases 5–6 diverge. | confirmed |
| I3 | Intro | "Julia source scripts … are linked under each case" | Six links, one per case. | confirmed |
| C1a | Case 1 heading | $f(x)=3e^x-4\cos x$, $x_0=1.0$ | newtonaa.jl:10,14. Same as Mathews Ex. 3 (3Exp[x]−4Cos[x], p0=1.0). | confirmed |
| C1b | Case 1 | "single positive root, $x^*\approx0.2549$" | mpmath root 0.25485005903. $f(0)=-1$, and $f'=3e^x+4\sin x>0$ for $x>0$, so the positive root is unique. | confirmed |
| C1c | Case 1 | "infinitely many negative roots, outside the plotted window" | $f\to -4\cos x$ as $x\to-\infty$, which changes sign on every half-period, for example $f(-\pi)>0$ and $f(-2\pi)<0$. The window is xlims=(0,1.5). | confirmed |
| C1d | Case 1 | "to the right of the root, where $f>0$ and $f''>0$" | $f''=3e^x+4\cos x>0$ on $[0.25,1]$, and $f(1)=5.99>0$. | confirmed |
| C1e | Case 1 | "iterates decrease monotonically … (1, 0.4798, 0.2857, 0.2556, 0.254850, …)" | Script: 1, 0.479752, 0.285738, 0.255577, 0.2548505, 0.2548501. mpmath gives the same values. | confirmed |
| C1f | Case 1 | "number of correct digits roughly doubles each step — quadratic" | Errors are 7.5e-1, 2.3e-1, 3.1e-2, 7.3e-4, 4.2e-7 and 1.4e-13. The ratio $e_{n+1}/e_n^2$ goes 0.41, 0.61, 0.76, 0.79, 0.79, which is constant. | confirmed |
| C1g | Case 1 alt | "rapid, monotone convergence from x₀=1.0 down to the root at x≈0.2549" | Frames 1–6 show it, and the final legend reads 0.25485. | confirmed |
| C2a | Case 2 heading | $f(x)=(1-5x)^2$, $x_0=1.0$ | newtonbb.jl:11,15. Same as Mathews Ex. 4 (1−10x+25x², p0=1.0). | confirmed |
| C2b | Case 2 | "double root at $x^*=0.2$", "$f'(x^*)=0$" | $f'=-10(1-5x)$ is 0 at 0.2. | confirmed |
| C2c | Case 2 | "degrades to linear convergence — each step roughly halves the error" | Iterates 1, 0.6, 0.4, 0.3, 0.25, 0.225, …, 0.2001953125. The error halves exactly, because the Newton map is $x_{n+1}-0.2=(x_n-0.2)/2$. | confirmed |
| C2d | Case 2 alt | "slow linear convergence to the double root at x=0.2" | 13 frames, and the final legend reads 0.2002. | confirmed |
| C3a | Case 3 heading | $f=\arctan x$, $x_0=1.35$ | newtoncc.jl:11,15. Same as Mathews Ex. 5. | confirmed |
| C3b | Case 3 | "only root is $x^*=0$" | arctan is strictly increasing with arctan 0 = 0. | confirmed |
| C3c | Case 3 | "converges only when $|x_0|<x_c\approx1.3917$" | Solving $2x=(1+x^2)\arctan x$ gives $x_c=1.3917452$. At $x_c$ the iterates form a 2-cycle, and beyond it they grow (see case 6). | confirmed |
| C3d | Case 3 | "converges but requires several oscillating steps before settling in" | 1.35, −1.2841, 1.1241, −0.7859, 0.2916, −0.01625, 2.86e-6, −1.56e-17, 0. The sign alternates and the iterates converge. | confirmed |
| C3e | Case 3 alt | "convergent case starting just inside the critical radius at x₀=1.35" | 1.35 < 1.3917 | confirmed |
| C4a | Case 4 heading | $f=x^3-x+3$, $x_0=0.0$ | newtondd.jl:12,16. Same as Mathews Ex. 6. | confirmed |
| C4b | Case 4 | "one real root, $x^*\approx-1.6717$" | polyroots gives −1.6716999 and 0.83585 ± 1.04687i. | confirmed |
| C4c | Case 4 | "crosses the axis at the left of the window" | xlims=(−2, 3.5), and the crossing is visible in every frame. | confirmed |
| C4d | Case 4 | "drawn into an attracting 4-cycle ≈ 0.0074 → 3.0005 → 1.9619 → 1.1475" | After 200 iterations the limit cycle is 0.0074461, 3.0004983, 1.9618967, 1.1475016. Its multiplier is $\prod N'(c_i)=0.2325<1$, so it is attracting. The script iterates 0, 3, 1.9615, 1.1472, 0.00658, 3.00039, 1.96182, 1.14743, 0.00726, 3.00047, 1.96188 approach it. | confirmed |
| C4e | Case 4 | "never approach the root" | All iterates are ≥ 0. | confirmed |
| C4f | Case 4 alt | the same cycle values and root | as above | confirmed |
| C5a | Case 5 heading | $f=xe^{-x}$, $x_0=2.0$ | newtonee.jl:11,15. Same as Mathews Ex. 7. | confirmed |
| C5b | Case 5 | "only root $x^*=0$; maximum of $f$ at $x=1$" | $f'=(1-x)e^{-x}$ | confirmed |
| C5c | Case 5 | "$x_{n+1}=x_n^2/(x_n-1)>x_n$" | Algebra gives $x - x/(1-x) = x^2/(x-1)$, and this is greater than $x$ for $x>1$. | confirmed |
| C5d | Case 5 | "(2, 4, 5.33, 6.56, …, 10.02 after six steps) while $f(x_n)\to0$" | Script: 2, 4, 5.3333, 6.5641, 7.7438, 8.8921, 10.0188. The residuals f are 0.27 … 4.5e-4. | confirmed |
| C5e | Case 5 alt | "each tangent line meets the axis further right" | Frames show it, and the last iterate 10.02 is inside xlims=(0, 11). | confirmed |
| C6a | Case 6 heading | $f=\arctan x$, $x_0=1.4$ | newtonff.jl:11,15. Same as Mathews Ex. 8. | confirmed |
| C6b | Case 6 | "just outside … $x_c\approx1.3917$" | 1.4 > 1.39175 | confirmed |
| C6c | Case 6 | "do not converge; they escape toward larger $|x|$" | 1.4, −1.4136, 1.4501, −1.5506, 1.8471, −2.8936, 8.7103. $|x_n|$ increases strictly. | confirmed |
| C6d | Case 6 alt | "divergent case starting just outside the critical radius" | as above | confirmed |
| W1 | Wiring | Each case links and embeds `newtonXX.jl`/`.gif` in order aa…ff | The function, x0 and title in each script match the heading of the case that embeds it, and the GIFs are byte-identical to fresh runs. | confirmed |
| D1 | Description | The page has no Description section; the only formula statement is I1. | n/a | n/a |
| F1 | Fidelity | Six cases map to Mathews' Examples 3–8 / Animations 1–6 | The functions and p0 values are identical, and the case titles match Mathews' (Fast, Slow, Convergence/Oscillation, Cycling, Diverging to Infinity, Divergent Oscillation). Mathews' Examples 1–2 (a cubic, without animation) are not animation cases. | confirmed, no departure |

---

### 3. Implementation checks

All six scripts run plain Newton-Raphson, $x_{n+1}=x_n-f(x_n)/f'(x_n)$, with hand-coded derivatives. I checked each derivative against numerical differentiation through the agreement of the iterates. There are no safeguards or variants. Each script plots the curve in magenta, a steelblue segment from $(x_n,f(x_n))$ to $(x_{n+1},0)$ (which lies on the tangent line), a vertical drop to $(x_{n+1},f(x_{n+1}))$, and a red marker on the current iterate with a legend label $x_{(n)}$. The frame count is n_iters+1.

Script values (`instr.out`, Float64) compared with independent values (`indep.py`, mpmath at 40 digits):

| Script | Script iterates | Independent | Agreement |
|---|---|---|---|
| aa | 1, 0.47975201560572, 0.28573835913113, 0.25557690047166, 0.25485047773433, 0.25485005902899 | 0.4797520156, 0.2857383591, 0.2555769005, 0.2548504777, 0.254850059 | ~1e-15 |
| bb | 1, 0.6, 0.4, 0.3, 0.25, …, 0.2001953125 | identical, exact dyadic values | exact |
| cc | 1.35, −1.28409114963, 1.12412310647, −0.78587188100, 0.29155397739, −0.016251001443, 2.861054894e-6, −1.5613e-17, 0.0 | the same; the last two are −1.561303e-17 and 2.5e-51 | agree to Float64 limits (x7 is roundoff-dominated) |
| dd | 0, 3, 1.96153846, 1.14717596, 0.00657937, 3.00038907, 1.96181818, 1.14743023, 0.00725625, 3.00047319, 1.96187865 | identical to 10 s.f. | ~1e-12 |
| ee | 2, 4, 5.33333, 6.56410, 7.74383, 8.89211, 10.01882 | identical | exact to printed digits |
| ff | 1.4, −1.41361865, 1.45012931, −1.55062598, 1.84705408, −2.89356239, 8.71032585 | identical | ~1e-9 printed |

Point by point:
- **It is the method it claims to be:** yes, standard Newton-Raphson in all six scripts.
- **The numbers are right:** yes, as the table shows. The property checks also pass: quadratic error ratio about 0.79 in aa, exact halving in bb, an attracting 4-cycle with multiplier 0.23 in dd, the closed-form map $x^2/(x-1)$ in ee, and $x_c$ from $2x=(1+x^2)\arctan x$ for cc and ff.
- **The reference values are right:** the scripts draw no reference curve. The page's roots (0.2549, 0.2, 0, −1.6717, 0, 0) and $x_c=1.3917$ were verified independently.
- **The picture shows what was computed:** I viewed the contact sheets of all six GIFs and full-resolution legend crops for dd and cc. The markers sit on the curve at the computed iterates, and the legend values match `instr.out` at the printed precision. The title function matches the code in every script. The display devices are as follows:
  - cc, ee: the code skips off-window segments, but no iterate leaves the window.
  - dd: the code clamps y-values, but no value exceeds ylims, since the maximum f is 27.01 against a top of 30.
  - ff: the last tangent is clipped at x=5. At the edge it has y ≈ −0.40, which matches $f(x_5)+f'(x_5)(5-x_5)=-0.396$. The off-window $x_6=8.71$ is labelled "(out of range)" with its true value, so nothing is misrepresented.
  - aa, bb: the curve is clipped above ylims, but no element that is discussed falls outside the window.

