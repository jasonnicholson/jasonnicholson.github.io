# Newton-Raphson Method — animation review (round 4)

Page: `pages/numerical-methods/newton-raphson-method/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** No Error, Misleading or Minor findings.

Observations that do not meet the bar for a finding (recorded so the clean result is auditable):
- `newtoncc.gif` frames 7–9 show legends `x₍6₎ = 0.0`, `x₍7₎ = -0.0`, `x₍8₎ = 0.0` (true values 2.86e-6, −1.56e-17, 0.0 in Float64; rounded to 5 digits). The signed zero is cosmetic and does not mislead.
- The page has no `## Description` section (the authoring conventions in `.github/agents/animation-page.agent.md` ask for one). That is content the page does not have, so it is not a finding under the review standard; noted only because it means there is no Description formula to check beyond the intro's iteration formula.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `newtonaa.jl` | 0 | 6.4 | newtonaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtonbb.jl` | 0 | 6.7 | newtonbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtoncc.jl` | 0 | 6.8 | newtoncc.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtondd.jl` | 0 | 7.4 | newtondd.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtonee.jl` | 0 | 6.5 | newtonee.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtonff.jl` | 0 | 8.1 | newtonff.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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
| 1 | Intro, l.12–13 | At each iterate a tangent line to f is drawn; its x-intercept gives $x_{n+1}=x_n-f(x_n)/f'(x_n)$ | All 6 scripts: `xs[i+1] = xs[i] - f(xs[i]) / fp(xs[i])`; drawn segment from $(x_n,f(x_n))$ to $(x_{n+1},0)$ has slope $f(x_n)/(x_n-x_{n+1}) = f'(x_n)$ by construction; `fp` matches mpmath numerical derivative (iterates agree, see §3) | confirmed |
| 2 | Intro l.14 | Sequence of tangent lines traces convergence or divergence | Frames of all 6 GIFs | confirmed |
| 3 | Case 1 heading | $f(x)=3e^x-4\cos x$, $x_0=1.0$ | `newtonaa.jl` l.10, 14; title in frames | confirmed |
| 4 | Case 1 heading | Quadratic convergence | errors 0.745, 0.225, 0.0309, 7.27e-4, 4.19e-7, 1.39e-13; $e_{n+1}/e_n^2$ → 0.7933 = $f''/(2f')$ at root (props.py) | confirmed |
| 5 | Case 1 | single positive root $x^*\approx0.2549$ | mpmath root 0.254850059028850; $f'=3e^x+4\sin x>0$ for $x>0$ so only one positive root | confirmed |
| 6 | Case 1 | infinitely many negative roots, outside the plotted window | roots −1.3812, −4.7191, −7.8537, … (one near each zero of cos as $e^x\to0$); window is [0, 1.5] | confirmed |
| 7 | Case 1 | $x_0$ on the convex side; each tangent lands between root and previous iterate; iterates decrease monotonically | $f''=3e^x+4\cos x\ge 7.73>0$ on [x*, 1] and $f>0$ there; iterates strictly decreasing, all > x* | confirmed |
| 8 | Case 1 | iterates 1, 0.4798, 0.2857, 0.2556, 0.254850, … | script: 1.0, 0.479752, 0.285738, 0.255577, 0.254850; mpmath identical to ≥15 digits | confirmed |
| 9 | Case 1 | correct digits roughly double each step | error exponents −0.6, −1.6, −3.1, −6.4, −12.9 | confirmed |
| 10 | Case 1 alt | rapid, monotone convergence from 1.0 to root at ≈0.2549 | frames 1–6; final legend x₍5₎ = 0.25485 | confirmed |
| 11 | Case 2 heading | $f(x)=(1-5x)^2$, $x_0=1.0$ | `newtonbb.jl` l.11, 15 | confirmed |
| 12 | Case 2 | double root at $x^*=0.2$; $f'(x^*)=0$ | $f'=-10(1-5x)$ vanishes at 0.2 | confirmed |
| 13 | Case 2 | linear convergence; each step roughly halves the error | Newton map is exactly $(x+0.2)/2$; script iterates 1, 0.6, 0.4, 0.3, 0.25, …, 0.2001953125 (error exactly halves) | confirmed |
| 14 | Case 2 alt | slow linear convergence to the double root at x=0.2 | 13 frames, last legend x₍12₎ = 0.2002 | confirmed |
| 15 | Case 3 heading | $f=\arctan x$, $x_0=1.35$, convergent | `newtoncc.jl` l.11, 15; iterates → 0 (x₈ = 0.0) | confirmed |
| 16 | Case 3 | only root $x^*=0$ | arctan strictly increasing | confirmed |
| 17 | Case 3 | converges only when $|x_0|<x_c\approx1.3917$ | root of $2x=(1+x^2)\arctan x$: 1.39174520; $N(x_c)=-x_c$ (2-cycle); test: 1.3917 → 0, 1.3918 → diverges | confirmed |
| 18 | Case 3 | 1.35 just inside; converges after several oscillating steps | iterates 1.35, −1.284, 1.124, −0.786, 0.292, −0.0163, 2.9e-6, −1.6e-17, 0: alternating sign, then fast | confirmed |
| 19 | Case 3 alt | convergent case starting just inside the critical radius at 1.35 | frames 1–9 | confirmed |
| 20 | Case 4 heading | $f=x^3-x+3$, $x_0=0.0$; cycling, non-convergence | `newtondd.jl` l.12, 16 | confirmed |
| 21 | Case 4 | one real root $x^*\approx-1.6717$ | numpy roots: −1.67169988, 0.8358 ± 1.0469i | confirmed |
| 22 | Case 4 | curve crosses the axis at the left of the window | xlims (−2, 3.5); crossing visible at ≈ −1.67 in all frames | confirmed |
| 23 | Case 4 | iterates drawn into an attracting 4-cycle ≈ 0.0074 → 3.0005 → 1.9619 → 1.1475 | fixed point of $N^4$: 0.0074461, 3.0004983, 1.9618967, 1.1475016; multiplier $\prod N'$ = 0.2325 < 1 (attracting); float run after 400 steps sits on these values | confirmed |
| 24 | Case 4 | never approach the root | all 11 computed iterates ≥ 0.0066; long run stays on the cycle | confirmed |
| 25 | Case 4 alt | settle into a 4-cycle near 0.0074, 3.0005, 1.9619, 1.1475; never reach root ≈ −1.6717 | frames 1–11, legends 0.0, 3.0, 1.9615, 1.1472, 0.0066, 3.0004, 1.9618, 1.1474, 0.0073, 3.0005, 1.9619 match script values | confirmed |
| 26 | Case 5 heading | $f=xe^{-x}$, $x_0=2.0$; divergence to infinity | `newtonee.jl` l.11, 15 | confirmed |
| 27 | Case 5 | only root 0; max of f at x=1; for x>1, f>0 and $f'=(1-x)e^{-x}<0$ | calculus; `fp` l.12 matches | confirmed |
| 28 | Case 5 | $x_{n+1}=x_n^2/(x_n-1)>x_n$ | algebra: $x - x/(1-x) = x^2/(x-1)$; closed form gives same sequence as script | confirmed |
| 29 | Case 5 | 2, 4, 5.33, 6.56, …, 10.02 after six steps | script: 2, 4, 5.3333, 6.5641, 7.7438, 8.8921, 10.0188 | confirmed |
| 30 | Case 5 | $f(x_n)\to0$; small residual does not mean a root is near | f: 0.271 → 4.46e-4 while x grows | confirmed |
| 31 | Case 5 alt | each tangent meets axis further right; iterates move away from 0 toward +∞ | frames 1–7; x₆ = 10.0188 inside window (0, 11), drawn at its true value | confirmed |
| 32 | Case 6 heading | $f=\arctan x$, $x_0=1.4$; divergent | `newtonff.jl` l.11, 15 | confirmed |
| 33 | Case 6 | 1.4 just outside $x_c\approx1.3917$ | see #17 | confirmed |
| 34 | Case 6 | iterates do not converge; escape toward larger $|x|$ | 1.4, −1.4136, 1.4501, −1.5506, 1.8471, −2.8936, 8.7103 (|x| strictly increasing); mpmath run exceeds 1e6 by step 9 | confirmed |
| 35 | Case 6 alt | divergent case just outside the critical radius at 1.4 | frames 1–7; last legend "x₍6₎ = 8.71 (out of range)" (true 8.7103), tangent from x₅ clipped at the right edge at y ≈ −0.40 (computed −0.396) | confirmed |
| 36 | Wiring | each case links/embeds `newtonaa…ff` in order, matching heading parameters | index.qmd l.23/25, 31/33, 40/42, 49/51, 58/60, 67/69; each GIF regenerated byte-identical from the script of the same name (manifest), and each script's f, x₀ match its heading | confirmed |
| 37 | Count | six cases | 6 headings, 6 scripts, 6 GIFs | confirmed |

### 3. Implementation checks

All six scripts implement plain Newton-Raphson (no damping, safeguards or hybrid steps): `xs[i+1] = xs[i] - f(xs[i]) / fp(xs[i])`. Each hand-coded derivative is correct (`3e^x+4sin x`, `-10(1-5x)`, `1/(1+x^2)`, `3x^2-1`, `(1-x)e^{-x}`); independently confirmed because my mpmath iteration uses a numerical derivative and reproduces every iterate. Reference values (roots, thresholds) are not drawn in the plots; the page's quoted references were checked in the ledger.

Script iterates (Float64, from `inst.out`) beside independent mpmath (50 digits):

| Script | n | Script | mpmath |
|---|---|---|---|
| aa | 1–5 | 0.47975201560571856, 0.28573835913112816, 0.2555769004716556, 0.2548504777343278, 0.25485005902898933 | 0.4797520156057186, 0.28573835913112816, 0.25557690047165571, 0.25485047773432775, 0.25485005902898934 |
| bb | 1–12 | 0.6, 0.4, 0.3, 0.25, …, 0.2001953125 | identical (exact halving) |
| cc | 1–6 | −1.2840911496321357, 1.1241231064736947, −0.7858718810026537, 0.2915539773939717, −0.016251001443270185, 2.861054894189724e-6 | −1.2840911496321356, 1.124123106473695, −0.78587188100265425, 0.29155397739397222, −0.016251001443270304, 2.861054894190198e-6 |
| dd | 1–10 | 3.0, 1.9615384615384615, 1.1471759614035466, 0.006579371480712082, 3.000389074071233, 1.961818175666325, 1.1474302284816027, 0.007256247552424044, 3.000473188773216, 1.9618786463602413 | same to ≥15 significant digits |
| ee | 1–6 | 4.0, 5.333333333333333, 6.564102564102564, 7.743826066406712, 8.892109843323993, 10.018818672756456 | same |
| ff | 1–6 | −1.4136186488037423, 1.4501293146283372, −1.5506259756377534, 1.84705408415019, −2.8935623931424104, 8.710325846983183 | same to ≥14 digits (expected amplification in a diverging run) |

Picture checks (frames viewed: all contact sheets plus the last frame of each GIF):
- **newtonaa** (6 frames): tangent segments from $(x_n,f(x_n))$ to $(x_{n+1},0)$, vertical drops to the curve, red marker at current iterate; legend index and value match the script (digits=5). Window [0,1.5]×[−2,10] contains everything. Correct.
- **newtonbb** (13 frames): same construction; f(1)=16 within ylims 18. Correct.
- **newtoncc** (9 frames): the draw guard requires both endpoints in [−3, 2.5]; all iterates are inside, so every step is drawn. Correct (legend −0.0 noted above, cosmetic).
- **newtondd** (11 frames): clamp to ylims (−4, 30) is never active (iterate f values in [2.99, 27.01]); x-guard never excludes a step. First tangent from (0,3) to (3,0) has slope −1 = f′(0). Root at −1.67 visible. Correct.
- **newtonee** (7 frames): all iterates ≤ 10.02 lie inside xlims (0, 11), so the "→ ∞" legend branch is never used and every point is drawn at its true value. Correct.
- **newtonff** (7 frames): last step's tangent from x₅ = −2.894 runs off the right edge (clipped by xlims, not by changing data); x₆ is labelled with its true value 8.71 and "(out of range)". Correct, not misleading.

Fidelity to the Mathews archive: Mathews' Examples 3–8 (Fast Convergence `3Exp[x]-4Cos[x]=0`, p₀=1.0; Slow Convergence `1-10x+25x^2=0`, p₀=1.0; Convergence, Oscillation `ArcTan[x]=0`, p₀=1.35; NON Convergence, Cycling `x^3-x+3=0`, p₀=0.0; NON Convergence, Diverging to Infinity `x e^{-x}=0`, p₀=2.0; NON Convergence, Divergent Oscillation `ArcTan[x]=0`, p₀=1.4) map one-to-one onto Cases 1–6 with identical functions and starting values. The a2001 animations for the cycling and divergent cases show p₄=0.00658, p₈=0.00726 and p₆=8.71033, matching the scripts. No archive case is dropped. No fidelity finding.

