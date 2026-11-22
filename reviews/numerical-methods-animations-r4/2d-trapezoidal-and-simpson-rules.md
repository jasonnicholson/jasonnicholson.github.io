# 2D Trapezoidal and Simpson Rules — animation review (round 4)

Page: `pages/numerical-methods/2d-trapezoidal-and-simpson-rules/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


None. I found no error, misleading statement, minor defect or fidelity departure that meets the review standard.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `simpson2daa.jl` | 0 | 9.3 | simpson2daa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `trapezoidal2daa.jl` | 0 | 8.1 | trapezoidal2daa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `simpson2daa.gif` | 8 | byte-identical | simpson2daa |
| `trapezoidal2daa.gif` | 8 | byte-identical | trapezoidal2daa |

### Page references

- Scripts linked: `trapezoidal2daa.jl`, `simpson2daa.jl`
- GIFs embedded: 2
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| D1 | Description | "Examples 1-6 of the archived module use I = ∫0^1∫0^1 8e^{-x^2-y^4} dy dx" | Archive images gr_43 (Ex 1), gr_67 (Ex 2), gr_87 (Ex 3), gr_108 (Ex 4), gr_132 (Ex 5), gr_153 (Ex 6) all show this integral | confirmed |
| D2 | Description | surface z = 8e^{-x^2-y^4} over R = [0,1]x[0,1] | Both scripts line 9 `f(x,y)=8*exp(-(x^2)-(y^4))`, limits (0,1) | confirmed |
| D3 | Description | I_T formula: hk ΣΣ w_i w_j f, w_0=w_m=1/2, interior 1 | Scripts lines 25-39 (trap) implement exactly this; script routine exact for x·y (err 0), not for x²y² (err 0.02951) - degree-1 tensor rule | confirmed |
| D4 | Description | I_S formula: hk/9 ΣΣ a_i a_j f, a = 1,4,2,...,4,1 | Simpson script lines 25-40; exact for x³y³, x³y² (err 0), not for x⁴ (n=2 err 8.33e-3, n=4 err 5.21e-4, ratio 16) | confirmed |
| D5 | Description | h=(b-a)/m, k=(d-c)/n, x_i=a+ih, y_j=c+jk; weights in y same with n | Scripts use `range(...,length=n+1)`, hx=hy=1/n (m=n on this page) | confirmed |
| D6 | Description | "For Simpson's rule m and n must be even" | Correct; n_seq = [2,4,6,8,10,12,16,20] all even | confirmed |
| A1 | Animations intro | "Each animation shows full-domain mesh refinement on [0,1]x[0,1] for f(x,y)=8e^{-x^2-y^4}" | Both scripts recompute the rule over the whole square for each n; frames show the full square | confirmed |
| A2 | Animations intro | "archived benchmark I ≈ 5.04756680717" | mpmath: I = 5.04756680716753966…; separable form 8·(√π/2)erf(1)·∫e^{-y⁴} gives the same; ref − I = 2.46e-12 (correct rounding to 11 decimals). Archive gr_90 prints 5.04756680717 | confirmed |
| A3 | Animations intro | "Julia source scripts ... are linked under each case" | Case 1 links `trapezoidal2daa.jl`, Case 2 links `simpson2daa.jl` | confirmed |
| A4 | Animations intro | "The archived snapshot is incomplete for some intermediate image IDs" | gr_46-66 (Ex 1 outputs/plots), gr_68-86 (Ex 2), gr_154-183 (Ex 6) are missing from `Images/` | confirmed |
| A5 | Animations intro | "reconstructed from the available formula and checkpoint assets" | Surviving checkpoints: trap 10x10 = 5.0360837636, 20x20 = 5.04469842165 (gr_92/94, also gr_137/139); Simpson Mathews m=5 → 5.04764458608 (gr_124), m=10 → 5.04757148312 (gr_131). Mathews' Simpson uses 2m subintervals, so these are the 10x10 and 20x20 panel meshes. Script values: T10 = 5.036083764, T20 = 5.044698422, S10 = 5.047644586, S20 = 5.047571483 - all agree | confirmed |
| A6 | Animations intro | "Example 7 ... inner limits of integration are functions of x (a non-rectangular region), is not animated here" | Archive gr_193: ∫0^2 ∫_{x²}^{√(8x)} e^{-x√y} dy dx; gr_197 shows the curved region. No script animates it | confirmed |
| C1-1 | Case 1 heading | "2D Trapezoidal Rule, f(x,y)=8e^{-x^2-y^4}" | trapezoidal2daa.jl line 9; frame titles "2D Trapezoidal Rule on [0,1] x [0,1]" | confirmed |
| C1-2 | Case 1 Behavior | "coarse-to-fine tensor grid updates over the whole square each frame" | Frames 1-8: mesh 2,4,6,8,10,12,16,20; grid lines span the square in every frame | confirmed |
| C1-3 | Case 1 Behavior | "converges toward the archived reference value" | errors 0.298479071, 0.072222116, 0.031962102, 0.017953588, 0.011483044, 0.007971632, 0.004482543, 0.002868386 (independent = script = frame titles), monotone decreasing | confirmed |
| C1-4 | Case 1 Behavior | "visible second-order error decay under refinement" | Error ratios on halving: 2→4: 4.13, 4→8: 4.02, 8→16: 4.005, 10→20: 4.003; 20→40: 4.001 | confirmed |
| C1-5 | Case 1 Behavior | "black lines join the sample nodes with straight segments: ... grid lines of the piecewise-bilinear interpolant, whose integral is the trapezoidal value I_T" | `gridlines` (lines 44-53) plots f at nodes joined by straight segments along every x_i and y_j. interp.py: ∫ bilinear interpolant = 4.749087736005076 (n=2), 4.975344691378608 (n=4) = I_T | confirmed |
| C1-6 | Case 1 alt text | "coloured surface of f ... straight black grid lines through the sample nodes (the bilinear interpolant), full-grid refinement from 2x2 to 20x20, and convergence to the archived benchmark integral" | Frames 1 and 8; titles show mesh 2x2 ... 20x20 and decreasing error | confirmed |
| C1-7 | Case 1 wiring | link `trapezoidal2daa.jl`, embed `trapezoidal2daa.gif` | That script writes that GIF (line 88); byte-identical regeneration | confirmed |
| C2-1 | Case 2 heading | "2D Simpson Rule, f(x,y)=8e^{-x^2-y^4}" | simpson2daa.jl line 9; frame titles "2D Simpson Rule" | confirmed |
| C2-2 | Case 2 Behavior | "Simpson tensor-product weights are recomputed on each refined mesh" | `simpson2d(n)` builds ax, ay for each n | confirmed |
| C2-3 | Case 2 Behavior | "Compared with trapezoidal refinement, the Simpson estimate reaches high accuracy with fewer refinements" | Simpson errors 5.87e-2, 4.24e-3, 6.68e-4, 1.96e-4, 7.78e-5, 3.69e-5, 1.15e-5, 4.68e-6; Simpson 6x6 (6.68e-4) already beats trapezoid 20x20 (2.87e-3); halving ratio 10→20: 16.6, 20→40: 16.1 (fourth order) | confirmed |
| C2-4 | Case 2 Behavior | "black curves are the quadratics through the sample nodes over each pair of panels along every grid line: ... piecewise-biquadratic interpolant (one patch per 2x2 block of panels), whose integral is the Simpson value I_S" | `quadpieces` uses panels [t_k, t_{k+2}], k odd (1-based), Lagrange quadratic; node reproduction error 0.0 (n=4). interp.py: ∫ biquadratic interpolant = 5.1062626244475435 (n=2), 5.051811626509 (n=4) = I_S | confirmed |
| C2-5 | Case 2 Behavior | "On the 2x2 mesh they differ from the trapezoidal straight lines by up to 0.51 in z" | instr.jl: max gap 0.51095 at (x=0, y=0.25), quadratic 8.2686 vs line 7.7577 (gap of a quadratic minus its chord is maximal at the panel midpoint, which is a sample point) | confirmed |
| C2-6 | Case 2 alt text | "black piecewise-quadratic grid curves through the sample nodes (the biquadratic interpolant), tensor-product Simpson refinement from 2x2 to 20x20, and convergence toward the archived benchmark integral" | Frames 1-8 | confirmed |
| C2-7 | Case 2 wiring | link `simpson2daa.jl`, embed `simpson2daa.gif` | That script writes that GIF (line 107); byte-identical regeneration | confirmed |
| S1 | simpson2daa.jl line 14 comment | "the n=2 quadratic along x=0 peaks at about 8.30" | max of curves at n=2: 8.2973 at (0, 0.1875) (sampled); zlims 8.4 contains it; all later frames max ≤ 8.038 | confirmed |
| S2 | both scripts line 16 comment | archived checkpoints at 10x10 and 20x20 | See A5 | confirmed |

### 3. Implementation checks

### trapezoidal2daa.jl
- **Method:** composite tensor-product trapezoidal rule, weights 1/2 at the ends and 1 inside on each axis, times h·k (lines 19-40). The page's Description matches. Script routine with f replaced: exact for x·y (err 0), err 0.029514 for x²y², 0.08125 for x⁴ at n=2 - degree of precision 1 in each variable, as expected.
- **Numbers:** script values (instr.jl) vs independent numpy (indep.py), n = 2..20:
  4.749087736 / 4.749087736; 4.975344691 / same; 5.015604706 / same; 5.029613219 / same; 5.036083764 / same; 5.039595175 / same; 5.043084264 / same; 5.044698422 / same. Archive checkpoints 5.0360837636 (10x10) and 5.04469842165 (20x20) agree. Error ratio on halving h → 4.00.
- **Reference:** 5.04756680717 vs mpmath 5.0475668071675397; reference error 2.5e-12, far below the smallest displayed error (2.87e-3).
- **Picture:** surface matrix built as `Zf[y,x]` which is the orientation Plots expects (rows = y); since f(x,y) ≠ f(y,x) (e.g. f(0.5,0) = 6.23, f(0,0.5) = 7.52), a transposed surface would sit visibly off the black node lines, and in frames 1 and 8 the lines lie on the surface. Grid lines are straight node-to-node segments in x and y (bilinear interpolant's grid lines). Titles show mesh, I_T and |error| to 9 decimals and match the computed values in all 8 frames (contact sheet). zlims (0, 8.2) contains max f = 8. No clamping or masking.

### simpson2daa.jl
- **Method:** composite tensor-product Simpson 1/3 rule, weights 1,4,2,...,2,4,1 per axis times h·k/9 (lines 19-41). Weight index logic: array index i ↔ node i-1, odd node → 4, even interior → 2; checked by exactness: script routine exact for x·y, x²y², x³y², x³y³ (err 0), not for x⁴ (n=2 err 8.333e-3, n=4 err 5.208e-4, ratio 16) - degree of precision 3 per variable, as Simpson should be.
- **Numbers:** script vs independent: 5.106262624 / same; 5.051811627 / same; 5.048234773 / same; 5.047762777 / same; 5.047644586 / same; 5.047603712 / same; 5.047578304 / same; 5.047571483 / same. Archive Simpson checkpoints (Mathews m=5, m=10, i.e. 10 and 20 subintervals) 5.04764458608 and 5.04757148312 agree. Error ratio on halving h: 16.6 (10→20), 16.1 (20→40).
- **Reference:** as above; smallest displayed error 4.676e-6 is ~2e6 times larger than the reference's own error, so all displayed |error| values are trustworthy to the digits shown.
- **Picture:** `quadpieces` draws, on each pair of panels, the Lagrange quadratic through the three node values, sampled at 17 points per pair (midpoint included); the curves pass through every node (error 0) and are exactly the grid-line traces of the piecewise-biquadratic interpolant, whose integral equals I_S (interp.py). Frame 1 shows the expected overshoot above 8 near (0, 0.19); zlims (0, 8.4) keeps it in view. Titles match computed values in all 8 frames. No clamping or masking.

### Legacy archive / fidelity
- Archive examples 1-6 all use the page's integrand on [0,1]²; Ex 1/3 trapezoid at 10x10 and 20x20, Ex 4/5 Simpson at Mathews m=5, 10 (10x10, 20x20 subintervals), Ex 6 compares them. The animations include both checkpoint meshes for both rules and reproduce the archived values. Ex 2 (analytic value) is represented by the benchmark. Ex 7 (non-rectangular region) is explicitly disclosed as not animated.
- The archive itself has errors the page does not copy: Example 1's statement says "composite Simpson's rule" while its solution runs Trapezoidal2D, and Example 5's "Simpson" error images (gr_137, gr_139, gr_141) show the trapezoidal values 5.0360837636 / 5.04469842165 and error 0.01148... The page avoids both.
- The page's Simpson convention (m panels, m even) differs from Mathews' (2m subintervals); this is a valid formulation, not a finding.
- No fidelity finding.

### Could not determine
- Nothing material. I did not check the page against the conventions file `animation-page.agent.md` beyond the content claims above, since style/structure conventions are outside the review standard.

