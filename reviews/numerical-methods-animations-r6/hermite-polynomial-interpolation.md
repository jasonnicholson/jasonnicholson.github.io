# Hermite Polynomial Interpolation — animation review (round 6)

Page: `pages/numerical-methods/hermite-polynomial-interpolation/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page agrees with independently computed values at the precision stated, both scripts implement cubic Hermite interpolation correctly, and the frames show what was computed. Details and evidence follow in sections 2 and 3.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `hermitepolyaa.jl` | 0 | 5.8 | hermitepolyaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `hermitepolybb.jl` | 0 | 6.6 | hermitepolybb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `hermitepolyaa.gif` | 4 | byte-identical | hermitepolyaa |
| `hermitepolybb.gif` | 4 | byte-identical | hermitepolybb |

### Page references

- Scripts linked: `hermitepolyaa.jl`, `hermitepolybb.jl`
- GIFs embedded: 2
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Location | Claim (page wording) | Evidence | Verdict |
|---|---|---|---|---|
| D1 | Description | "For two endpoints $x_0,x_1$ with $h=x_1-x_0$ and $t=(x-x_0)/h$ … $H(x)=y_0H_{00}(t)+hy_0'H_{10}(t)+y_1H_{01}(t)+hy_1'H_{11}(t)$" | Both scripts use exactly this form (aa.jl l.26–31, bb.jl l.19–27). Standard basis $H_{00}=2t^3-3t^2+1$, $H_{10}=t^3-2t^2+t$, $H_{01}=-2t^3+3t^2$, $H_{11}=t^3-t^2$ (scripts l.10–13). Sympy: the combination for Case 2 equals the monomial-basis solution of the 4 endpoint conditions exactly (`s4-P = 0`). | confirmed |
| D2 | Description | "In piecewise form … a smooth $C^1$ approximation that preserves both value and slope at each node" | Instrumented aa.jl: node error 0.0, one-sided FD slope error ≤ 5.8e-7 (FD step 1e-6) at every node, n = 1…64. | confirmed |
| A1 | Animations intro | Cubic Hermite interpolates values and first derivatives at the endpoint nodes; Lagrange uses only values | Standard; matches implementation. | confirmed |
| A2 | Animations intro | "Mathews' Hermite polynomial module has no animation" | No Hermite/spline animation under `a2001/Animations/` (Interpolation has Chebyshev, FourierSeries, Lagrange, Pade, Series only; `grep -ril hermite` empty); module page has no animation link. | confirmed |
| A3 | Animations intro | Case 1 ($\sin x$ on $[0,2\pi]$) is the site's own example; Case 2 uses the endpoint data of the module's Example 1 | Archive Example 1 (lnk_2, image gr_18): $p(1)=2,p'(1)=1,p(3)=1,p'(3)=2$. No sin example in the module. | confirmed |
| A4 | Animations intro | Module's Examples 2 and 3 are a clamped and a natural cubic spline, not animated here | lnk_3 "clamped cubic spline", lnk_4 "natural cubic spline". | confirmed |
| C1a | Case 1 heading | Piecewise cubic Hermite for $\sin(x)$, refining the mesh | aa.jl l.36–43: f = sin, df = cos, nodes `range(0, 2π, length=n+1)`, n = 1,2,4,8. | confirmed |
| C1b | Case 1 Behavior | $n$ subintervals, each a cubic matching $f$, $f'$ at its endpoints | See D2. | confirmed |
| C1c | Case 1 Behavior | Max errors in the four frames are 0.425, 0.215, 0.0108, 0.000906 | Script (600-pt grid): 0.4253746, 0.2146006, 0.0107905, 0.0009061985. Independent (monomial-solve Hermite, 600-pt grid / 400 001-pt grid): 0.425375/0.425382, 0.214601/0.214602, 0.0107905/0.0107907, 0.000906198/0.000906216. mpmath critical point for n=1: sup = 0.4253816 at x = 1.79868 and 4.48451. Frame titles show the same four values. | confirmed |
| C1d | Case 1 Behavior | Doublings divide error by about 2.0, 19.9, 11.9 | Independent: 1.9822, 19.888, 11.907 (sup and 600-pt agree to 4 digits). | confirmed |
| C1e | Case 1 Behavior | Error is $O(h^4)$ for smooth $f$; ratio → 16 only on finer meshes: 15.0 (8→16), 15.7 (16→32), 15.9 (32→64) | Independent: 14.958, 15.742 (sup 15.738), 15.938 (sup 15.935); 64→128 ≈ 15.98–16.02. | confirmed |
| C1f | Case 1 Behavior | "these coarse meshes are not yet in the asymptotic range" | Ratios 1.98, 19.9, 11.9 are far from 16; consistent. | confirmed |
| C1g | Case 1 alt text | Shows n = 1,2,4,8; max error falls from 0.425 at n=1 to 0.000906 at n=8 | Frames 1–4 titles: n = 1,2,4,8 with 0.425, 0.215, 0.0108, 0.000906. | confirmed |
| C1h | Case 1 wiring | Link `hermitepolyaa.jl`, embed `hermitepolyaa.gif` | Script writes `hermitepolyaa.gif`; content is the sin(x) case. | confirmed |
| C1i | Case 1 count | "the four frames" | GIF has 4 frames. | confirmed |
| C2a | Case 2 heading | $p(1)=2$, $p'(1)=1$, $p(3)=1$, $p'(3)=2$ | bb.jl l.16–18. Matches archive gr_18. | confirmed |
| C2b | Case 2 Behavior | Four basis functions each carry one degree of freedom; weighted combination takes prescribed values and slopes at both endpoints | Sympy: final sum has value 2, slope 1 at x=1; value 1, slope 2 at x=3. | confirmed |
| C2c | Case 2 Behavior | $h=2$; slope weights $hy_0'=2$, $hy_1'=4$ | bb.jl l.19, 25, 27. | confirmed |
| C2d | Case 2 Behavior | Result $H(x)=x^3-\tfrac{23}{4}x^2+\tfrac{19}{2}x-\tfrac{11}{4}$, the cubic of Mathews' solution | Sympy solve of the 4 conditions gives exactly this; archive gr_32 shows $-11/4+19x/2-23x^2/4+x^3$. Script's final stage vs this polynomial: max diff 7.1e-15. | confirmed |
| C2e | Case 2 Behavior | Frames add the weighted terms one at a time and draw the running sum | bb.jl l.30–35, 55: stage k plots sum of first k terms only. Frames 1–4 titles: "y₀·H₀₀(t)", "+ h·y₀'·H₁₀(t)", "+ y₁·H₀₁(t)", "+ h·y₁'·H₁₁(t) = H(x)". | confirmed |
| C2f | Case 2 Behavior | Prescribed tangent lines as short dotted segments | bb.jl l.38–40: through (1,2) slope 1 on [0.75,1.25] → y 1.75–2.25; through (3,1) slope 2 on [2.75,3.25] → y 0.5–1.5. Frame 2 shows exactly these gray dotted segments. | confirmed |
| C2g | Case 2 Behavior | First two partial sums fall to 0 with zero slope at x=3, because $H_{00}$, $H_{10}$ have zero value and slope there | Sympy: $s_1=x^3/2-3x^2+9x/2$, $s_2=\tfrac34x^3-\tfrac{19}4x^2+\tfrac{33}4x-\tfrac94$; both value 0, slope 0 at x=3. Frames 1–2 show curves ending flat at y=0, inside ylims (−0.2, 3). | confirmed |
| C2h | Case 2 alt text | Running sum for the given data, one term per frame until complete cubic, which meets the dotted tangent segments at both endpoints | 4 frames, one term each; frame 4 curve passes (1,2) and (3,1) along the segments (slopes 1 and 2 confirmed above). | confirmed |
| C2i | Case 2 wiring | Link `hermitepolybb.jl`, embed `hermitepolybb.gif` | Script writes `hermitepolybb.gif`; content is the Example 1 data. | confirmed |

### 3. Implementation checks

### `hermitepolyaa.jl` (Case 1)

- **Method.** Piecewise cubic Hermite interpolation with exact $f$ and $f'$ at uniform nodes: on each $[x_i,x_{i+1}]$ it evaluates $y_iH_{00}+hy_i'H_{10}+y_{i+1}H_{01}+hy_{i+1}'H_{11}$ in $t=(x-x_i)/h$ with the standard basis (l.10–13, 28–31). Interval lookup by `searchsortedlast` clamped to $[1,n]$, so $x=2\pi$ uses the last interval. This is the method named.
- **Numbers.** Independent implementation in `indep.py` builds each cubic by solving the 4×4 monomial system for value/slope at both ends (no basis functions), so it does not rely on remembering the basis.

  | n | script err (600 pts) | independent 600 pts | independent sup (400 001 pts) |
  |---|---|---|---|
  | 1 | 0.4253746 | 0.425375 | 0.425382 (mpmath: 0.4253816) |
  | 2 | 0.2146006 | 0.214601 | 0.214602 |
  | 4 | 0.0107905 | 0.0107905 | 0.0107907 |
  | 8 | 9.061985e-4 | 9.06198e-4 | 9.06216e-4 |
  | 16 | 6.058396e-5 | 6.0584e-5 | 6.05856e-5 |
  | 32 | 3.848612e-6 | 3.84861e-6 | 3.84958e-6 |
  | 64 | 2.414771e-7 | 2.41477e-7 | 2.41588e-7 |

  Property checks: node values reproduced exactly (error 0.0); slopes at nodes reproduced to FD accuracy (≤ 5.8e-7 with step 1e-6); error ratio tends to 16 (14.96, 15.74, 15.94, ~16.0), the $O(h^4)$ rate.
- **Reference.** The "true" curve is `sin` from Julia Base; derivative `cos` is exact. The 600-point sampled maximum differs from the true sup only in the 5th–6th significant figure, so the 3-sig-fig titles are the true sup.
- **Picture.** Contact sheet and frames: blue sin, red dashed Hermite, black nodes at $n+1$ uniform points; titles show n and the 3-sig-fig error matching the computed values. ylims ±1.4 contain all curves (n=1 interpolant peaks at ±0.60, n=2 at ±0.79). Nothing clamped or hidden.

### `hermitepolybb.jl` (Case 2)

- **Method.** Single cubic Hermite on [1,3] with $h=2$, built as the weighted basis sum; frames show the cumulative sum of 1, 2, 3, 4 terms (l.24–35). This is the method named.
- **Numbers.** Sympy (independent): solution of the four endpoint conditions is $x^3-\tfrac{23}{4}x^2+\tfrac{19}{2}x-\tfrac{11}{4}$; the basis-sum formulation equals it identically. Instrumented script: final stage differs from that polynomial by at most 7.1e-15 on its 400-point grid; endpoint values 2 and 1 exactly; one-sided FD slopes 0.986 and 1.984 (grid step 0.005, consistent with 1 and 2). Partial-sum extrema: script vs sympy — $s_1$ max 2.0 / 2.0; $s_2$ max 2.10699 / 2.10700; $s_3$ max 2.15740 / 2.15741; $s_4$ min 0.654269 / 0.654268 at x≈2.629, max 2.09805 / 2.09805 at x≈1.205.
- **Reference.** No underlying $f$; the "reference" is Mathews' stated polynomial (archive gr_32), matched exactly; archive graph gr_31 shape (max ≈2.1 near 1.2, min ≈0.65 near 2.6) matches frame 4.
- **Picture.** Tangent segments built from the prescribed slopes through the prescribed points (verified coordinates above); endpoints marked at (1,2), (3,1); legend text "prescribed slopes y₀' = 1, y₁' = 2" and "endpoints (1, 2), (3, 1)" correct; xlims (0.7, 3.3) show both segments in full; ylims (−0.2, 3.0) contain all partial sums (range 0 to 2.157). Frame titles name the term added at each stage correctly.

### Fidelity to the legacy archive

Mathews' module has three examples (Example 1 clamped cubic Hermite; Examples 2 and 3 clamped and natural cubic splines) and no animation. The page uses Example 1's data exactly with Mathews' resulting cubic, and explicitly states that Case 1 is the site's own example and that Examples 2 and 3 are not animated. No undisclosed departure found.

