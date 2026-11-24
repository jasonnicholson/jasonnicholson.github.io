# Runge-Kutta Method — animation review (round 7)

Page: `pages/numerical-methods/runge-kutta-method/`. Reported findings: **0 Error, 0 Misleading, 2 Minor**.

## Findings

### F1. Page match, Minor: $k_j$ is called a slope, then used as an increment

- **Location:** `index.qmd` line 12, "RK4 computes four slope estimates ($k_1, k_2, k_3, k_4$) per step and takes a weighted average"; line 18, "first always $y_i+k_3$, where $k_4$ is evaluated".
- **Now:** Line 12 defines the $k_j$ as slopes. Line 18 adds $k_3$ directly to $y_i$, which is only meaningful if $k_3$ is an increment. If $k_3$ were a slope the stage would be $y_i+h\,k_3$.
- **True:** The script uses increments, `k1 = h * f(t, y)` and so on, with `y + k3` as the fourth stage and `y + (k1 + 2k2 + 2k3 + k4)/6` as the update (`rungekuttaaa.jl` lines 28-32). The page's stage figures (minimum $-1.15$) are values of this increment form.
- **How I know:** Reading lines 28-32, and my independent RK4 in `indep.py` using $k_j=h f$, which reproduces all 21 $y(5)$ values and the minimum stage $-1.1542$.
- **Correction:** On line 12 write "RK4 computes four increments $k_j=h\,f(\cdot)$ from slope estimates ($k_1,k_2,k_3,k_4$) per step and adds their weighted average $(k_1+2k_2+2k_3+k_4)/6$ to $y_i$".

- **Independent check:** not run (Minor finding, unverified)

### F2. Page match, Minor: the "own truncation error" versus "carried error" split depends on a definition the page does not state

- **Location:** `index.qmd` line 18, "$94$ to $100\%$ of the error just after it ($0.168$ for $m=12$) is that step's own truncation error, not an earlier error grown. For $m=20$ to $56$ the error after the first upward step is mostly error carried from earlier steps, which that step multiplies by $2.9$ to $18.6$."
- **Now:** The sentence presents two different mechanisms, $m\le18$ versus $m\ge20$, as plain fact, without saying how the error is divided.
- **True:** The figures are right for one standard split, and that split is the only one under which the contrast exists.
  - **Split A (the page's, unstated):** own error $=\Phi(t_i,Y(t_i))-Y(t_{i+1})$, the step taken from the *exact* value. Own share: $93.7$ to $99.9\%$ for $m=12$ to $18$; $0.3$ to $20.0\%$ for $m=20$ to $56$. The carried part is $2.91$ to $18.57$ times $e_i$. This reproduces the page.
  - **Split B (equally standard local error):** own error $=y_{i+1}-z(t_{i+1})$, where $z$ is the exact solution through the *computed* $(t_i,y_i)$. Own share: $98.7$ to $99.9\%$ for **all** $m=12$ to $56$, and the exact flow shrinks the incoming error to $2$ to $13\%$ of $e_i$.
  - Under B there is no change of regime at $m=20$. A reader who knows local error in the B sense would find the sentence false for $m=20$ to $56$.
- **How I know:** `/usr/bin/python3 split.py` in the review folder (exact solution by DOP853 on the smooth form $u=y^{1/3}$, rtol $10^{-13}$). Selected rows:

  | m | $e_i$ | $e_{i+1}$ | A: own % | A: gain on $e_i$ | B: own % | B: exact-flow gain |
  |---|---|---|---|---|---|---|
  | 12 | +5.792e-03 | +1.681e-01 | 99.6 | 0.11 | 99.8 | 0.051 |
  | 16 | +1.283e-02 | +1.098e-01 | 93.7 | 0.54 | 99.4 | 0.048 |
  | 20 | +1.152e-02 | +7.214e-02 | 20.0 | 5.01 | 99.0 | 0.061 |
  | 28 | +2.706e-03 | +8.156e-03 | 3.4 | 2.91 | 98.7 | 0.040 |
  | 36 | +1.780e-03 | +3.315e-02 | 0.3 | 18.57 | 99.9 | 0.023 |
  | 56 | +4.710e-04 | +1.737e-03 | 1.0 | 3.65 | 99.2 | 0.028 |

- **Correction:** State the measure. For example: "...$94$ to $100\%$ of the error just after it ($0.168$ for $m=12$) is what that step produces even when started from the exact $y(t_i)$. For $m=20$ to $56$ the same step started from the exact value would produce only $0.3$ to $20\%$ of the error; the rest comes from the earlier error, which RK4's step map multiplies by $2.9$ to $18.6$, whereas the exact flow would shrink it to $2$ to $6\%$."

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `rungekuttaaa.jl` | 0 | 13.4 | rungekuttaaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `rungekuttaaa.gif` | 21 | byte-identical | rungekuttaaa |

### Page references

- Scripts linked: `rungekuttaaa.jl`
- GIFs embedded: 1
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

All line numbers are in `index.qmd`. "Confirmed" means checked against my own computation or the frames.

### Introduction (line 12)

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| 1 | IVP $y'=1-t\sqrt[3]{y}$, $y(0)=1$ on $[0,5]$ | script lines 11-14; Mathews `gr_155` shows the same IVP | confirmed |
| 2 | Repeats Mathews' step-refinement sweep | legacy frames: one complete curve per $m$; printed $y(5)$ agree (table, section 3) | confirmed |
| 3 | Each frame is a complete RK4 run, $h=5/m$ | script lines 21-35, 62-64 | confirmed |
| 4 | 21 values $m=12,\dots,150$, as listed, are Mathews' | read from legacy frames 4-36: the same 21 values in order | confirmed |
| 5 | Drawn over a fine-step reference | 50,000-step RK4 vs mpmath: both $0.00811992046486796$ | confirmed |
| 6 | Each frame labelled with computed $y(5)$ and its error | all 21 frames read (`allframes_labels.png`) | confirmed |
| 7 | "four slope estimates ($k_1..k_4$)" | script's $k_j$ are $h\cdot$slope | **wrong in wording (F1)** |
| 8 | Weighted average | script line 32; order test | confirmed |
| 9 | $O(h^5)$ local, $O(h^4)$ global for smooth $f$ | script's `rk4` on $y'=y\cos t$: halving ratios 12.84, 14.75, 15.44, 15.73, 15.87 | confirmed |
| 10 | $f$ not smooth at $y=0$; $\partial f/\partial y=-t/(3y^{2/3})$ unbounded | differentiation (for $t\ne0$) | confirmed |
| 11 | Coarser runs evaluate $f$ at negative $y$ | stages below 0 for $m=12$ to $52$ | confirmed |

### Case heading, links, embed (lines 14-22)

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| 12 | Heading: RK4 sweep, this IVP, $m=12$ to $150$ | script `ms` | confirmed |
| 13 | Source link is the script of this case | `rungekuttaaa.jl` exists, makes this GIF | confirmed |
| 14 | Embed is this case's GIF | byte-identical to regeneration (manifest; `cmp`) | confirmed |

### Behavior paragraph (line 18)

| # | Claim | Independent value | Verdict |
|---|---|---|---|
| 15 | Reference rises to about $1.4498$ near $t=0.88$ | $1.449767$ at $t=0.883556$ | confirmed |
| 16 | Then decays toward nullcline $y=1/t^3$ (where $y'=0$) | monotone decay after peak; $y(5)-1/125=1.2\times10^{-4}$ | confirmed |
| 17 | Reference $y(5)=0.0081199$ | $0.008119920465$ (DOP853, Radau, mpmath agree) | confirmed |
| 18 | $m=12$ to $52$ visibly turn upward before $t=5$ | upward steps in each; frames | confirmed |
| 19 | $y(5)\approx0.588$, $0.289$, $0.0377$ for $m=12,20,52$ | $0.5883471$, $0.2891074$, $0.0376958$ | confirmed |
| 20 | $m=56$ turns up on last step only, by $8.1\times10^{-4}$, too little to see | one upward step, $4.911\to5$, $8.053\times10^{-4}$ (under 1 pixel); frame 14 | confirmed |
| 21 | $m=56$ ends at $\approx0.0099$ | $0.0098571$ | confirmed |
| 22 | Error in $y(5)$ falls at every refinement | $|e|$ strictly decreasing over all 21 | confirmed |
| 23 | $3.4\times10^{-4}$ at $m=60$ | $3.43\times10^{-4}$ | confirmed |
| 24 | $2.8\times10^{-5}$ at $m=70$ | $2.76\times10^{-5}$ | confirmed |
| 25 | $6.8\times10^{-6}$ at $m=80$ | $6.80\times10^{-6}$ | confirmed |
| 26 | $1.8\times10^{-7}$ at $m=150$, $y(5)\approx0.0081201$ | $1.76\times10^{-7}$; $0.0081201$ | confirmed |
| 27 | $\partial f/\partial y$ along reference reaches $-41.3$ at $t=5$ | $-41.2554$; $|f_y|$ monotone increasing on $[0,5]$ | confirmed |
| 28 | Critical $h\approx0.0675$, i.e. $m\le74$ | $h^*=0.067513$, $m^*=74.06$ | confirmed |
| 29 | RK4 real-axis limit $2.785$ | $2.7852936$ (independent root find) | confirmed |
| 30 | $m=12$ to $70$ exceed the limit before $t=5$; shaded in those frames | onset exists for those 16 values; all 16 frames shaded, $m\ge80$ not | confirmed |
| 31 | $m=70$ from $t\approx4.91$ | $4.908$; frame label 4.91 | confirmed |
| 32 | $m=12$ from $t\approx3.10$ | $3.103$; frame label 3.10 | confirmed |
| 33 | $m=80$ to $150$ stay below $2.785$ up to $t=5$ | largest is $m=80$: $0.0625\times41.255=2.578$ | confirmed |
| 34 | For $m=12$ to $24$ run's own $h|f_y|$ at grid values stays below $2.42$ | maximum $2.418$ ($m=24$, $t=3.54$) | confirmed |
| 35 | $m=12$ to $18$: upturn begins with a long step starting before the shaded region | start $2.917, 2.857, 3.125, 3.056$; onset $3.103, 3.162, 3.219, 3.278$ | confirmed |
| 36 | $m=12$: that step is $t\approx2.92$ to $3.33$ | $2.9167\to3.3333$ | confirmed |
| 37 | $94$ to $100\%$ of error after it is that step's own truncation error | $93.7$ to $99.9\%$ under split A | confirmed as a number; **definition unstated (F2)** |
| 38 | Error after it is $0.168$ for $m=12$ | $0.16815$ | confirmed |
| 39 | $m=20$ to $56$: error mostly carried from earlier steps | $80$ to $99.7\%$ under split A; $0.1$ to $1.3\%$ under split B | **depends on definition (F2)** |
| 40 | That step multiplies it by $2.9$ to $18.6$ | $2.91$ to $18.57$ (split A) | confirmed |
| 41 | $m=60$ and $70$ cross the bound, no upward turn | no upward step in either | confirmed |
| 42 | Upturn size depends on the cube-root branch for $y<0$ | real root vs clamped runs differ (below) | confirmed |
| 43 | Negative stage in every run $m=12$ to $52$ and no other | exact set found | confirmed |
| 44 | As low as $-1.15$ | $-1.1542$ ($m=12$) | confirmed |
| 45 | First negative stage is always $y_i+k_3$ | true in all 13 runs | confirmed |
| 46 | In first upward step for $m=12$ to $24$ and $36$ | offset 0 for those | confirmed |
| 47 | In the step after it for $m=28,32$ and $40$ to $52$ | offset 1 for those | confirmed |
| 48 | $\sqrt[3]{y}$ not differentiable at 0 | elementary | confirmed |
| 49 | Script takes the real cube root | `cbrt`, line 11 | confirmed |
| 50 | Mathews' printed $y(5)$ show he did too | all 21 agree within $4.9\times10^{-8}$ (print rounding); clamped runs differ by $0.016$ to $0.83$ for $m\le52$ | confirmed |
| 51 | There $f=1+t|y|^{1/3}>1$ | algebra, $t>0$, $y<0$ | confirmed |
| 52 | Clamped: summed upward steps shrink in each run $m=12$ to $52$ | true for all 13 | confirmed |
| 53 | $0.46\to0$ for $m=12$ | $0.45966\to0$ exactly | confirmed |
| 54 | $0.028\to0.012$ for $m=52$ | $0.02795\to0.01153$ | confirmed |
| 55 | Clamped $y(5)=-0.239$, $0.0054$, $0.021$ for $m=12,20,52$ | $-0.23919$, $0.00543$, $0.02128$ | confirmed |
| 56 | $m=56$ has no negative stage, rise unchanged | minimum stage $+0.0048$; rise $8.0526\times10^{-4}$ both ways | confirmed |

### Alt text (line 22)

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| 57 | Each frame a complete run, $m=12$ to $150$ | as #3, #4 | confirmed |
| 58 | Gray reference peaks near $1.45$ at $t\approx0.88$, decays to $0.0081$ | as #15, #17; frames | confirmed |
| 59 | $m=12$ to $52$ visibly turn up; $y(5)=0.588$ at $m=12$; $m=56$ too small to see | as #18 to #20 | confirmed |
| 60 | $m=12$ to $70$ shaded for $h|f_y|>2.785$ along reference | as #30; script line 56 uses `tref`, `yref` | confirmed |
| 61 | Runs settle on the reference; $y(5)=0.0081201$ at $m=150$ | as #22, #26 | confirmed |

The page has no `## Description` section, so no Description claims exist. Under the review standard, absent content is not a finding. The placeholder and legacy-inventory sections were left out as instructed.

---

### 3. Implementation checks: `rungekuttaaa.jl`

**It is the method it claims to be.** Lines 26-33 are classical RK4 (stages at $t,\ t+h/2,\ t+h/2,\ t+h$; weights $1,2,2,1$ over 6), written with increments. Running the script's own `rk4` on $y'=y\cos t$, $y(0)=1$, exact $e^{\sin t}$ (`inst/inst2.jl`) gives step-halving error ratios 12.84, 14.75, 15.44, 15.73, 15.87, approaching $2^4$. On this page's IVP an independent RK4 gives ratios 22.28, 18.82, 17.40, 16.70, 16.35 from $m=150$ to $4800$.

**The numbers are right.** Script values (instrumented scratch copy), an independent Python implementation and Mathews' printed values agree for all 21 runs; see the table below. The script's min and max grid comment (line 18: $0.0081$, $1.4498$, stages to $-1.15$) is confirmed: $0.008120$, $1.449751$, $-1.1542$. The stability limit comment ($2.7853$) is confirmed: $2.7852936$.

**Its reference values are right.** The reference is 50,000-step RK4 and gives $y(5)=0.008119920464868$. It agrees with DOP853 on $u=y^{1/3}$ ($0.008119920464868$), Radau on the original form ($0.008119920464869$), and mpmath Taylor at 25 digits ($0.00811992046486796$). The 100,000-step run differs from it by $1.7\times10^{-18}$. The reference stays positive throughout, so the cube-root singularity does not affect it.

**The picture shows what was computed.** All 21 frames were read: titles, $m$, $h$, $y(5)$, error, and shading onset match the computed values. The run is drawn at its true grid values; no clamping or masking is used, and every grid value lies inside the $y$ limits $(-0.05, 1.8)$. The shading runs from the first reference-grid crossing to $t=5$; because $|f_y|$ is monotone along the reference, that is the whole region where the criterion holds. The GIF is byte-identical to a scratch regeneration of the unchanged script. Stage values below $-0.05$ are not plotted, but they are not grid values and the page reports them in text.

| m | script $y(5)$ | independent $y(5)$ | Mathews printed | script error label | shading onset | upward steps | min stage |
|---|---|---|---|---|---|---|---|
| 12 | 0.5883471 | 0.5883471 | 0.5883471 | +5.8e-01 | 3.10 | 5 | -1.1542 |
| 14 | 0.4685529 | 0.4685529 | 0.4685529 | +4.6e-01 | 3.16 | 5 | -0.8366 |
| 16 | 0.3876236 | 0.3876236 | 0.3876236 | +3.8e-01 | 3.22 | 5 | -0.7969 |
| 18 | 0.3316264 | 0.3316264 | 0.3316264 | +3.2e-01 | 3.28 | 6 | -0.6580 |
| 20 | 0.2891074 | 0.2891074 | 0.2891074 | +2.8e-01 | 3.34 | 6 | -0.5497 |
| 24 | 0.2274383 | 0.2274383 | 0.2274383 | +2.2e-01 | 3.49 | 6 | -0.3944 |
| 28 | 0.1108585 | 0.1108585 | 0.1108585 | +1.0e-01 | 3.65 | 6 | -0.2181 |
| 32 | 0.1082442 | 0.1082442 | 0.1082442 | +1.0e-01 | 3.81 | 6 | -0.1495 |
| 36 | 0.0834665 | 0.0834665 | 0.0834665 | +7.5e-02 | 3.95 | 5 | -0.0972 |
| 40 | 0.0698482 | 0.0698482 | 0.0698482 | +6.2e-02 | 4.09 | 5 | -0.0675 |
| 44 | 0.0604713 | 0.0604713 | 0.0604713 | +5.2e-02 | 4.22 | 4 | -0.0489 |
| 48 | 0.0538504 | 0.0538504 | 0.0538504 | +4.6e-02 | 4.34 | 3 | -0.0424 |
| 52 | 0.0376958 | 0.0376958 | 0.0376958 | +3.0e-02 | 4.45 | 2 | -0.0086 |
| 56 | 0.0098571 | 0.0098571 | 0.0098571 | +1.7e-03 | 4.56 | 1 | 0.0048 |
| 60 | 0.0084630 | 0.0084630 | 0.008463 | +3.4e-04 | 4.67 | 0 | 0.0073 |
| 70 | 0.0081476 | 0.0081476 | 0.0081476 | +2.8e-05 | 4.91 | 0 | 0.0080 |
| 80 | 0.0081267 | 0.0081267 | 0.0081267 | +6.8e-06 | none | 0 | 0.0081 |
| 90 | 0.0081227 | 0.0081227 | 0.0081227 | +2.8e-06 | none | 0 | 0.0081 |
| 100 | 0.0081213 | 0.0081213 | 0.0081213 | +1.4e-06 | none | 0 | 0.0081 |
| 120 | 0.0081204 | 0.0081204 | 0.0081204 | +5.2e-07 | none | 0 | 0.0081 |
| 150 | 0.0081201 | 0.0081201 | 0.0081201 | +1.8e-07 | none | 0 | 0.0081 |

**Fidelity to the archive.** The IVP, interval, 21 values of $m$ and printed $y(5)$ all match Mathews' animation. No departure found. The page adds a reference curve, an error label and stability shading to the same sweep. Examples 1 to 10 of the module are static worked examples outside the animation; they are not an archive case dropped from the Animations section.

**Could not determine.** The Example 11 solution images in the archive (`gr_156` onward) are missing, so I could not read Mathews' Mathematica code for the cube root. His use of the real root is inferred from his 21 printed $y(5)$ values, which the real-root run reproduces and the clamped variant does not.

