# Taylor Series Method for ODE's — animation review (round 3)

Page: `pages/numerical-methods/taylor-series-method-for-odes/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I found no Error, Misleading or Minor finding. Every claim on the page that I could check came out right at the precision stated. Every computed value in both scripts matches an independent computation. The legacy departures are disclosed and justified, and I reproduced Mathews' own numbers to confirm the explanation the page gives (see 3.3).

Counts: Error 0, Misleading 0, Minor 0.

Observation, not a finding: the shaded "h·|∂f/∂y| > limit" region is computed along the *reference* solution (`onset(h)` scans `tref, yref`), not along the computed run. The page doesn't say which. This is the natural reading of "∂f/∂y … reaches −41.3 at t=5", and it doesn't change any conclusion. I also checked the true linearised per-step amplification ∂Φ/∂y of the Taylor map along the reference (§3.4). It first exceeds 1 between 0.03 and 0.17 after the shaded onset in every shaded frame, and it never exceeds 1 for unshaded frames. The shading is therefore a faithful proxy for where errors actually grow.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `taylorderivativeaa.jl` | 0 | 11.3 | taylorderivativeaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `taylorderivativebb.jl` | 0 | 8.8 | taylorderivativebb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `taylorderivativeaa.gif` | 21 | byte-identical | taylorderivativeaa |
| `taylorderivativebb.gif` | 21 | byte-identical | taylorderivativebb |

### Page references

- Scripts linked: `taylorderivativeaa.jl`, `taylorderivativebb.jl`
- GIFs embedded: 2
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

Evidence key:
- [D] = instrumented scratch copies of the scripts (`review/instr_aa.jl`, `instr_bb.jl`, which dump every run to `dump_aa.txt` / `dump_bb.txt`).
- [I] = independent Python computation (`review/indep.py`: sympy derivatives, mpmath 30-digit Taylor runs, mpmath `odefun` and scipy DOP853 rtol 1e-13 reference).
- [C] = `review/claims.py` / `compare.py` output.
- [A] = `review/amp.py` (amplification factor).
- [M] = `review/mathews_variant.py`.
- [L] = legacy GIF label strips `review/legacy_aa/labels.png`, `legacy_bb/labels.png`.
- [F] = committed frames.

### Intro (Animations section)
| # | Claim (page words) | Evidence | Verdict |
|---|---|---|---|
| 1 | IVP $y'=1-t\sqrt[3]{y}$, $y(0)=1$ over $[0,5]$ | code lines 19, 26–27; frame titles [F] | confirmed |
| 2 | each frame a complete run with $m$ subintervals, $h=5/m$ | `taylor3/4(m)`, `h=(T-t0)/m` | confirmed |
| 3 | 21 values of Mathews' animations, m = 12,14,16,18,20,24,28,32,36,40,44,48,52,56,60,70,80,90,100,120,150 | `ms` in code; 21 frames per GIF (manifest); legacy GIFs have exactly these 21 m (plus a blank first frame) [L] | confirmed |
| 4 | drawn over a fine-step reference solution | 50 000-step same-order Taylor; max node diff vs DOP853 1.0e-12 (`stab_ref.py`) | confirmed |
| 5 | labelled with computed y(5) and its error | annotate lines 95–96 [F] | confirmed |
| 6 | points below y=−0.3 marked by triangles on bottom edge, true minimum printed | lines 87–101; frame 1 of each GIF shows triangles and "min y = −8.597 at t ≈ 4.58" / "−3.115 at 4.17" [F], matching [C] | confirmed |
| 7 | $\sqrt[3]{y}$ is the real cube root, runs that go negative stay real | `cbrt` throughout | confirmed |
| 8 | Taylor method computes higher derivatives analytically, $y_{n+1}=y_n+hy'_n+\frac{h^2}{2}y''_n+\cdots$, local accuracy $O(h^{p+1})$ | derivatives verified symbolically (§3); global order measured (row 13/34) implies local $p+1$ | confirmed |
| 9 | source scripts linked under each case | links lines 20, 28 | confirmed |

### Case 1 (order 3)
| # | Claim | Evidence | Verdict |
|---|---|---|---|
| 10 | heading: order 3, same IVP, m = 12 to 150 | script aa | confirmed |
| 11 | p=3, three derivative terms per step | `yd1, yd2, yd3` | confirmed |
| 12 | local error $O(h^4)$ | follows from 13 | confirmed |
| 13 | global error $O(h^3)$ | [I] max node error m=100/200/400: 1.327e-5, 1.579e-6, 1.916e-7 (ratios 8.4, 8.2); y(5) error ratio 100→200 8.06 | confirmed |
| 14 | same order as RK3; requires explicit symbolic derivatives | definitional | confirmed |
| 15 | reference rises to about 1.4498 near t=0.88 | DOP853: peak 1.44977 at t=0.88356; script yref peak 1.449767 at 0.8836 | confirmed |
| 16 | reference y(5)=0.0081199 | mpmath odefun 0.00811992046486796; DOP853 0.008119920464867971; script 0.008119920464867961 | confirmed |
| 17 | m=12 through 36 visibly leave the reference in the tail | max node error m=12…36: 8.6, 109, 0.58, 0.13, 1.20, 0.048, 0.15, 0.15, 0.029; m=36 bump at t=4.86 visible in frame 9 [F] | confirmed |
| 18 | ends at y(5) ≈ −4.47 for m=12 | −4.46765486 [D]=[I] | confirmed |
| 19 | −109 for m=14 | −109.074926 | confirmed |
| 20 | m=20 jumps from 0.0068 at t=4 to 1.22 at t=4.25, ends 0.0895 | nodes 0.006795 (t=4), 1.21616 (t=4.25), y(5)=0.0895215 | confirmed |
| 21 | from m=40 on each run decreases steadily after its peak | strictly decreasing after argmax for every m ≥ 40 [C] | confirmed |
| 22 | …and stays within 3×10⁻⁴ of the reference at every node | max node error m=40: 2.504e-4 (largest for m ≥ 40) | confirmed |
| 23 | m=100 largest node error 1.3e-5 | 1.327e-5 | confirmed |
| 24 | m=100 error in y(5) −1.2e-9 | −1.186e-9 | confirmed |
| 25 | ∂f/∂y = −t/(3y^{2/3}) reaches −41.3 at t=5 | −41.2554 (independent: −5/(3·0.0081199^{2/3})) | confirmed |
| 26 | threshold h ≈ 0.0609 (m ≤ 82; here 12 to 80) | 2.512745/41.25541 = 0.060907; 5/0.060907 = 82.09; script onset non-null exactly for m ≤ 80 in the sweep | confirmed |
| 27 | order-3 Taylor stability limit 2.513 | numpy roots of R(z)=±1: −2.5127453 (script 2.5127453) | confirmed |
| 28 | on y'=λy, λ<0 real, the method amplifies errors once h|λ| exceeds the limit | R(z)=1+z+z²/2+z³/6 has R'>0 everywhere, so R(z)<−1 for all z<−2.5127 | confirmed |
| 29 | stability is the cause of the departures | true amplification ∂Φ/∂y exceeds 1 only inside the shaded region (onset 0.03–0.12 later than shading) and reaches −680 (m=12), −18.5 (m=36), −1.03 (m=80) at t=5; never exceeds 1 for m ≥ 82 [A] | confirmed |
| 30 | for m=12 to 48 error at t=5 larger than at last node before the shaded region | true for m=12…48, false from m=52 (e.g. m=48: 4.66e-7 vs 9.19e-8; m=52: 1.06e-9 vs 6.04e-8) [C] | confirmed |
| 31 | m=80 shading from t ≈ 4.96 | onset 4.9578 | confirmed |
| 32 | for m=52 to 80 error in y(5) below 3.1e-9 | 1.06e-9, 3.091e-9, 2.93e-9, 2.40e-9, 1.92e-9 | confirmed (narrowly at m=56) |
| 33 | at m=12 the shading starts at t ≈ 3.07 | 3.0664 | confirmed |
| 34 | m=90 to 150: h|∂f/∂y| below 2.513 up to t=5 | onset `nothing`; frames say "< 2.513 up to t = 5" | confirmed |
| 35 | Mathews' printed y(5) reproduced to every printed digit for 19 of 21 m; exceptions m=12, 14 | Legacy labels [L] vs script: 16: 0.1563161/0.156316091; 18: 0.1341734/0.134173423; 20: 0.0895215/0.0895215073; 24: −0.0401212/−0.0401211668; 28: −0.0212395/−0.0212394771; 32: 0.0127828/0.0127828087; 36: 0.0251901/0.0251900742; 40: 0.0083511/0.00835112448; 44: 0.00816/0.00816003528; 48: 0.0081204/0.00812038603; 52–150: 0.0081199 / 0.0081199x. m=12: 0.1766603 vs −4.4677; m=14: −3.4636068 vs −109.07 | confirmed |
| 36 | m=12 and 14 runs go negative before t=5 | first negative node t=4.167 (m=12), 4.643 (m=14); m=24, 28 go negative only at the final node | confirmed |
| 37 | Mathews' formulas replace each y^{k/3} by sign(y)|y|^{k/3} | Mathematica code in archive images gr_220–228 / gr_258–267 shows exactly these ReplaceAll rules (k=1,2,4,5, and 8 for order 4) | confirmed |
| 38 | for even k and y<0 this has opposite sign to (∛y)^k | algebra | confirmed |
| 39 | so his frames show different values, e.g. y(5)=0.1766603 at m=12 | Mathews' rule implemented independently [M] reproduces **all 42** printed legacy values (e.g. order 3 m=12 0.1766603, m=14 −3.463607; order 4 m=16 −554.4455) | confirmed |

### Case 1 alt text
| # | Claim | Evidence | Verdict |
|---|---|---|---|
| 40 | gray reference peaks near 1.45 at t≈0.88, decays to 0.0081 at t=5 | rows 15–16 | confirmed |
| 41 | m=12 to 36 leave the reference in the tail | row 17 | confirmed |
| 42 | drop off the bottom for m=12 and 14 (only) | mins −8.597, −109.07; m=24/28 mins −0.040/−0.021 stay above −0.3 | confirmed |
| 43 | spikes to 1.22 at m=20 | 1.21616 | confirmed |
| 44 | m=12 to 80 shaded where h·|∂f/∂y| exceeds 2.513 | row 26, frames | confirmed |
| 45 | from m=40 on the run lies on the reference; y(5)=0.0081199 at m=150 | rows 21–22; 0.00811992009 | confirmed |

### Case 2 (order 4)
| # | Claim | Evidence | Verdict |
|---|---|---|---|
| 46 | heading: order 4, same IVP, m=12 to 150 | script bb | confirmed |
| 47 | four derivative terms, all analytic | `yd1_f…yd4_f`; yd4 verified symbolically equal to the true 4th total derivative (sympy difference 0) | confirmed |
| 48 | local $O(h^5)$, global $O(h^4)$, same order as RK4 | max node error m=100/200/400: 8.02e-7, 4.58e-8, 2.71e-9 (ratios 17.5, 16.9) | confirmed |
| 49 | m=12 through 32 visibly leave the reference and go negative; exact solution stays positive | all eight runs have a negative node (first at t = 4.17, 3.93, 3.75, 4.44, 4.25, 4.58, 4.82, 5.0); exact min on [0,5] = 0.0081199 > 0 | confirmed |
| 50 | y(5) ≈ −7666 for m=16 | −7665.8734 | confirmed |
| 51 | m=20 turns negative at t=4.25, about −10.4 at t=4.5, ends y(5) ≈ −5.25 | −0.0465 (4.25), −10.434 (4.5), −5.2535 | confirmed |
| 52 | y(5) ≈ −0.081 for m=32 | −0.080650975 | confirmed |
| 53 | from m=36 on, within 2.7e-3 of reference at every node | max node error m=36 2.651e-3; m=40 1.361e-3; decreasing after | confirmed |
| 54 | at m=36 and 40 it turns up once near the end by about 0.0015 and 0.0005, too little to see | single rise of 0.00148 at t=4.861 (m=36) and 0.00055 at t=5 (m=40); none for m ≥ 44 | confirmed |
| 55 | from m=40 on the error in y(5) falls at every refinement, to 4.8e-12 at m=150 | |err|: 1.36e-3, 5.18e-5, 2.55e-6, 2.29e-7, 3.56e-8, 8.24e-9, 7.16e-10, 1.81e-10, 7.45e-11, 3.85e-11, 1.42e-11, 4.76e-12 (strictly decreasing) | confirmed |
| 56 | m=100 largest node error 8.0e-7, more than 16 times smaller than order 3's 1.3e-5 | 8.021e-7; 1.327e-5/8.021e-7 = 16.5 | confirmed |
| 57 | threshold h ≈ 0.0675 (m ≤ 74; here 12 to 70) | 2.785294/41.25541 = 0.067513; 5/0.067513 = 74.06; onset non-null exactly for m ≤ 70 | confirmed |
| 58 | order-4 stability limit 2.785 | numpy roots: −2.7852936 | confirmed |
| 59 | for all of m=12…70 the error at t=5 is larger than at the last node before the shaded region | true for every one of the 16 shaded m [C] (e.g. m=70: 7.16e-10 vs 5.50e-10) | confirmed |
| 60 | m=70 shading from t≈4.91; m=12 from t≈3.10 | 4.9083; 3.1033 | confirmed |
| 61 | m=80 to 150 below 2.785 up to t=5 | onset `nothing` | confirmed |
| 62 | Mathews reproduced to every printed digit for m=32 to 150 | legacy [L] vs script: −0.080651/−0.080650975; 0.0081972/0.0081971908; 0.0094813/0.00948133086; 0.0081717/0.00817171592; 0.0081225/0.00812246813; 0.0081201/0.00812014931; 0.00812/0.00811995607; 60–150: 0.0081199 | confirmed |
| 63 | m=12 to 28 go negative before t=5; Mathews' values differ, e.g. 0.0711898 at m=20 | first-negative times row 49; legacy m=20 = 0.0711898, reproduced by [M]; script −5.2535 | confirmed |
| 64 | the cause is again stability | ∂Φ/∂y > 1 only inside the shaded region (onset 0.05–0.17 later), reaching 2641 (m=12), 22.5 (m=36), 1.12 (m=70) at t=5; never > 1 for m ≥ 74 [A] | confirmed |

### Case 2 alt text
| # | Claim | Evidence | Verdict |
|---|---|---|---|
| 65 | m=12 to 32 go negative in the tail | row 49 | confirmed |
| 66 | drop off the bottom for m=12 to 28 | mins −3.115, −0.738, −7750.7, −19.88, −10.43, −1504.7, −951.4 (all < −0.3); m=32 min −0.0807 stays in window | confirmed |
| 67 | as low as −7751 at m=16 | −7750.7 at t=4.0625; frame 3 prints "min y = −7751 at t ≈ 4.06" | confirmed |
| 68 | m=12 to 70 shaded where h·|∂f/∂y| > 2.785 | row 57 | confirmed |
| 69 | from m=36 on the run lies on the reference; y(5)=0.0081199 at m=150 | rows 53; 0.00811992047 | confirmed |

### Wiring
| # | Claim | Evidence | Verdict |
|---|---|---|---|
| 70 | Case 1 link/embed → order-3 script/GIF | `taylorderivativeaa.jl`/`.gif`; GIF titles "Taylor order 3" | confirmed |
| 71 | Case 2 link/embed → order-4 script/GIF | `taylorderivativebb.jl`/`.gif`; titles "Taylor order 4" | confirmed |
| 72 | committed GIFs are what the scripts produce | manifest: both byte-identical on regeneration | confirmed |

The page has no separate Description section stating formulas, so the method description consists of rows 8, 11, 47.

### 3. Implementation checks

### 3.1 `taylorderivativeaa.jl` — Taylor order 3

- **Is the method it claims to be.** Each step is $y+hy'+\frac{h^2}{2}y''+\frac{h^3}{6}y'''$, with the total derivatives along $y'=f$. That is the classical Taylor method of order 3, run as a fixed-step sweep. The derivatives were checked with sympy (`indep.py`). Writing $y=c^3$ and $d/dt = \partial_t + \partial_c\cdot f/(3c^2)$, the script's `yd2` and `yd3` equal the true second and third total derivatives exactly (the symbolic difference simplifies to 0). They also agree with sympy's direct differentiation of $y(t)$ for $y>0$ at a sample point (difference 0). Because they are rational in $c=\operatorname{cbrt}(y)$, they remain the correct derivatives of the real-cube-root ODE for $y<0$.
- **The numbers are right.** I ran an independent mpmath implementation (30 digits, derivatives generated symbolically) for all 21 m. The maximum relative difference from the script's node values is ≤ 1.9e-13, apart from the unstable m=14 run at 1.8e-11, where round-off is amplified about 680× per step. y(5) values for both columns are in ledger rows 18–35. Measured order: halving h divides the maximum node error by 8.4 and 8.2, and the y(5) error by 8.06, as expected for order 3.
- **Its reference values are right.** The reference is the same method run with 50 000 steps. Its maximum node difference from DOP853 (rtol 1e-13) is 1.0e-12. Its y(5) = 0.008119920464867961 agrees with mpmath `odefun`, 0.00811992046486796. The smallest error annotated in any frame is 3.7e-10, far above the reference's error. Stability limit: bisection gives 2.5127453266183286, and numpy roots of R(z)=−1 give −2.5127453266183255.
- **The picture shows what was computed.** I viewed contact sheets and frame 1. The title function and h match the code. The orange polyline goes through the computed nodes. The red dot at (5, y(5)) is drawn only when y(5) ≥ −0.3. Off-scale nodes appear as triangles at −0.3, and the true minimum is printed: frame 1 reads "min y = −8.597 at t ≈ 4.58", which matches the dump. Shading starts at the printed onset. The annotations' y(5) and error values equal the dumped values. Fixed y-limits (−0.3, 1.8) clip only the diverging m=12 and 14 runs, and the frames say so in the legend and annotation.

### 3.2 `taylorderivativebb.jl` — Taylor order 4

- **Is the method it claims to be.** The step adds $\frac{h^4}{24}y''''$ to the order-3 step. `yd4_f` is $(27c^7+18c^5t^2-39c^4t+3c^3t^4+18c^3-15c^2t^3+22ct^2-10t)/(27c^8)$. Sympy shows it equals the true fourth total derivative (difference 0). It is also the same expression as Mathews' printed $y''''$ (archive image gr_262, multiplied by $y^{1/3}$ top and bottom). It is classical order-4 Taylor.
- **The numbers are right.** Against the independent mpmath runs, the maximum relative node difference is ≤ 4.8e-10 on the violently unstable runs (m=28 reaches −951) and ≤ 4e-14 for m ≥ 40. Measured order: maximum node error ratios on halving are 17.5 and 16.9, as expected for order 4.
- **Its reference values are right.** The 50 000-step order-4 reference has a maximum node difference from DOP853 of 1.0e-12 (the DOP853 floor), and y(5) is identical to case 1's to 1e-17. The smallest annotated error, 4.8e-12 at m=150, is far above the reference's own error in y(5), which is about 1e-17 against mpmath. Stability limit: 2.785293563405282 by bisection, and −2.7852935634052853 from numpy roots of R(z)=1.
- **The picture shows what was computed.** The plotting code is the same as case 1. Frame 3 (m=16) shows triangles at t=4.06, 4.38, 4.69 and 5.0, which are exactly the nodes below −0.3 in the dump. Its min annotation reads −7751 at t ≈ 4.06, and its shading starts at 3.22. The contact sheet shows m=36 to 150 on the reference, shading only through m=70, and "< 2.785 up to t = 5" from m=80.

### 3.3 Legacy fidelity

Mathews' examples 11 and 12 (order 3 and order 4 Taylor for $y'=1-t\sqrt[3]{y}$, $y(0)=1$, $[0,5]$) and his two animations use exactly the page's IVP, interval, orders and 21 values of m. His frames show only the computed run, with no reference curve. The page differs from him only where a run goes negative before t=5, and it says so: the order-3 frames for m=12 and 14, and the order-4 frames for m=12 to 28.

The archive's Mathematica code (images gr_220–228, gr_258–267) replaces each $y^{k/3}$ with $\operatorname{Sign}[y]\,\lvert y\rvert^{k/3}$. I implemented that rule independently (`mathews_variant.py`), and it reproduces every one of the 42 values printed in his frames. For example, order 3 gives m=12 0.1766603 and m=14 −3.463607, and order 4 gives m=12 0.4929678, m=16 −554.4455 and m=20 0.0711898. So the page's explanation is correct. Its real-cube-root values are the mathematically correct ones, since the sign rule flips the sign of the even powers and so stops being the derivative of $1-t\sqrt[3]{y}$ for $y<0$. The departure is therefore justified and disclosed, and I raise no Fidelity finding.

### 3.4 Stability attribution (independent check)

`amp.py` forms the exact step map $\Phi(t,y,h)$ for each order. It evaluates $\partial\Phi/\partial y$ along the DOP853 solution and finds the first t where $|\partial\Phi/\partial y|>1$:

| order | m | shading onset (script) | first $|\partial\Phi/\partial y|>1$ | $\partial\Phi/\partial y$ at t=5 |
|---|---|---|---|---|
| 3 | 12 | 3.066 | 3.108 | −679.9 |
| 3 | 36 | 3.826 | 3.891 | −18.5 |
| 3 | 80 | 4.958 | 4.987 | −1.03 |
| 3 | 82, 90 | 4.998, none | never | −0.93, −0.62 |
| 4 | 12 | 3.103 | 3.161 | 2640.8 |
| 4 | 36 | 3.954 | 4.051 | 22.5 |
| 4 | 70 | 4.908 | 4.958 | 1.12 |
| 4 | 74, 80 | 4.999, none | never | 0.89, 0.65 |

The h·|∂f/∂y| test tracks the real amplification region closely. This supports the page's statement that stability is the cause.

