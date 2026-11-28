# Cubic Splines — batch 19 review, round 1 (overview mode)

SUMMARY: 0 Error, 0 Misleading, 0 Minor

Page: `pages/numerical-methods/cubic-splines/index.qmd` (light-pass batch 19, overview, action *extend*). EV = /tmp/claude-1001/-home-jason--claude-spares-spare-0ogoFf/f6c51b48-3d53-4b4d-8872-653429a6389a/scratchpad/work/review-19/cubic-splines. My scratch files are in EV/reviewer/: check.py (symbolic formula checks, convergence table, frame errors, location of the cos error), rates.py (natural, clamped and not-a-knot rates on uniform and non-uniform meshes) and wc.py (word count). I did not run MATLAB or quarto, and I changed nothing in the repository. I consulted the Mathews archive (n2003/CubicSplinesMod.html, read as text).

## 1. Findings

None.

These are notes only, not findings:
- Line 37 says the strictly diagonally dominant system "is solved without pivoting in $O(n)$ operations". That is a true general statement. Case 1's script (cubicsplineaa.jl, `A \ b` on a dense matrix) instead solves the same tridiagonal system with general dense LU, which is O(n³). The system and the formulas are the ones the script uses. Only the solver differs, and the page does not claim that the script uses the O(n) algorithm.
- The `$\cos x$` column of the table is an extra example, not an animated case. The standard prefers the page's own problem, and the `$\sin x$` column is that problem. The cos column is the only way the page shows the natural-end-condition failure it describes, so I do not count it as a breach.

## 2. Claim ledger (the + lines of diff.patch)

Formulas and algorithm
1. Data $(x_i,y_i)$, $i=0..n$, nodes $a=x_0<\dots<x_n=b$, one cubic $S_i$ per panel $[x_i,x_{i+1}]$, $y_i=f(x_i)$. Confirmed. This matches the script's `xs`, `ys` and per-panel evaluation.
2. $S$, $S'$ and $S''$ are continuous at the interior nodes. Confirmed. This is the definition, and it matches Mathews' properties I–IV.
3. $h_i=x_{i+1}-x_i$, $M_i=S''(x_i)$, and $S''$ is linear on each panel. Confirmed.
4. The displayed formula for $S_i(x)$. Confirmed. sympy gives $S_i(x_i)=y_i$, $S_i(x_{i+1})=y_{i+1}$, $S_i''(x_i)=M_i$ and $S_i''(x_{i+1})=M_{i+1}$, with all residuals exactly 0. The formula is term for term the script's `spline_eval_point`.
5. The tridiagonal system $h_{i-1}M_{i-1}+2(h_{i-1}+h_i)M_i+h_iM_{i+1}=6(\dots)$, $i=1..n-1$, comes from continuity of $S'$. Confirmed. sympy gives $6(S'_\text{right}-S'_\text{left})+(\text{LHS}-\text{RHS}) \equiv 0$ at the shared node. It matches the script's `A` and `b` row for row.
6. "$n-1$ equations in $n+1$ unknowns, so two end conditions close the system". Confirmed.
7. Natural spline: $S''(x_0)=S''(x_n)=0$, that is $M_0=M_n=0$. Confirmed. The script sets M[1] = M[end] = 0.
8. A clamped spline prescribes $S'(a)=f'(a)$ and $S'(b)=f'(b)$. Confirmed. This is Mathews' clamped lemma.
9. "Mathews shows that either choice gives a unique spline". Confirmed. The module has a Natural Spline lemma and a Clamped Spline lemma, each stating "There exists a unique cubic spline …" with a proof.
10. The system is strictly diagonally dominant, so it can be solved without pivoting in O(n) operations. Confirmed. The diagonal $2(h_{i-1}+h_i)$ exceeds the off-diagonal sum $h_{i-1}+h_i$ in every row, and this also holds for the clamped rows. Thomas elimination is O(n).

General accuracy results
11. For $f\in C^4[a,b]$ with clamped or not-a-knot ends, the maximum error is $O(h^4)$, with h the largest $h_i$. Confirmed as a standard general result and checked numerically on cos over [0, 2π]. Uniform mesh, n = 64→128: clamped ratio 16.01, not-a-knot ratio 15.94. A non-uniform mesh with h the largest $h_i$: clamped 16.02, not-a-knot 15.89.
12. With natural ends the error is only $O(h^2)$ unless $f''(a)=f''(b)=0$. The error sits near an end where $f''\ne0$, and away from the ends it is still $O(h^4)$. Confirmed. Natural cos: ratios 4.25, 4.06, 4.02, 4.00. The natural error on [1, 2π−1] has ratio 16.01 at n = 64→128, and 14.8 at n = 64→128 on the non-uniform mesh.
13. Case 1 interpolates sin on [0, 2π], $\sin''(0)=\sin''(2\pi)=0$, so the natural spline keeps $O(h^4)$. Confirmed. The script uses f = sin on range(0, 2π). The ratios in the table are about 16.
14. Case 1's frames have 3 to 9 nodes and are too coarse to show the rate cleanly. Confirmed. The frames use 3, 4, 5, 6, 7 and 9 nodes, and their titles read 1.0, 0.109, 0.02, 0.00896, 0.00407 and 0.00107. My recomputation on the script's 600-point grid gives the same values. Only one pair of frames halves h (5 → 9 nodes), with ratio 18.7.
15. $\cos''(0)=-1$. Confirmed.

Table (natural spline, max |S − f| over [0, 2π]; my values from the panel-wise bounded maximisation plus a dense grid, and cross-checked against scipy CubicSpline 'natural')
16. n=8, h=π/4: sin 1.066e-3, cos 3.280e-2. Confirmed: 1.0661e-3 and 3.2796e-2.
17. n=16: sin 6.312e-5 (ratio 16.89), cos 7.724e-3 (ratio 4.25). Confirmed: 6.3121e-5 / 16.889 and 7.7243e-3 / 4.246.
18. n=32: sin 3.889e-6 (16.23), cos 1.902e-3 (4.06). Confirmed: 3.8893e-6 / 16.229 and 1.9022e-3 / 4.061.
19. n=64: sin 2.422e-7 (16.06), cos 4.738e-4 (4.02). Confirmed: 2.4221e-7 / 16.058 and 4.7376e-4 / 4.015.
20. n=128: sin 1.512e-8 (16.01), cos 1.183e-4 (4.00). Confirmed: 1.5124e-8 / 16.014 and 1.1833e-4 / 4.004.
21. The n = 8 row continues the last frame: 8 panels is 9 nodes. Confirmed. The frame shows 0.00107 and the table shows 1.066e-3.
22. "Each ratio is the previous error over this one", and halving h divides the error by about 16 for sin and about 4 for cos. Confirmed.

Failure modes
23. In the first frame of Case 1, the nodes 0, π and 2π are all zeros of sin, so $S\equiv0$ and the maximum error is 1. Confirmed. The computed M is about 1e-16, so S is zero to rounding. Frame 1 shows a flat dashed line, and its title reads "max err ≈ 1.0".
24. With natural ends and $f''(a)$ or $f''(b)\ne0$, the cos error falls only like $h^2$. Confirmed (see 12).
25. The largest cos error "always lies in the first or last panel". Confirmed for every n from 2 to 19 and for n = 32, 64 and 128. The argmax was in panel 0 or panel n−1 every time.

Where it fits (links)
26. Lagrange and Newton interpolation fit one polynomial whose degree grows with the number of nodes. Confirmed, and both pages exist.
27. Hermite interpolation also matches slopes. Confirmed. hermite-polynomial-interpolation/index.qmd line 12 says it matches values and first derivatives.
28. B-splines and Bézier curves shape curves from control points. Confirmed: b-splines line 12 and bezier-curves line 12.
29. Tri-Diagonal Matrices solves the system above. Confirmed. pages/numerical-methods/tri-diagonal-matrices.qmd exists, and `../tri-diagonal-matrices.qmd` is the form three other pages already use for this link.
30. Cubic Spline Quadrature integrates the natural spline. Confirmed. cubic-spline-quadrature/index.qmd line 13 reads "It fits the natural cubic spline … and integrates the spline exactly."

Outside the Description
31. The only change is the heading id `### Case 1 — … {#case-1}`. It is an allowed cross-reference id, and both `[Case 1](#case-1)` links (lines 41 and 55) resolve to it. Confirmed.

## 3. Checks

Six points of the overview standard:
1. **Problem.** Present (lines 12–13).
2. **Core formula.** Present, in display math (lines 19, 25 and 32), in the script's notation ($h_i$, $M_i$, the panel formula and the system match cubicsplineaa.jl).
3. **Assumptions.** Present: strictly increasing nodes, two end conditions, $f\in C^4[a,b]$ for the error result, and the natural-end hypothesis $f''(a)=f''(b)=0$.
4. **Accuracy.** Present. It is stated as a general result with its hypotheses, it is tied to Case 1, and I verified it with the case's own function (ledger 11–22).
5. **Failure modes.** Present: two failure modes, the first linked to Case 1 frame 1, and both confirmed.
6. **Where it fits.** Present, and all links resolve.

The optional worked example is a 5-row table, within the limit of about six rows. The Description has no proofs and no callout boxes.

Word count: 393 words of prose by my own recount (wc.py: inline math counted as 1 word, display math and table rows excluded). This matches the manifest and is within 150–400.

Links and anchors: all 7 relative links point at existing pages, and the `#case-1` anchor is defined on the Case 1 heading. Judged from the source, the markup should render: `\Bigl`/`\Bigr` are supported in KaTeX, the `$$` blocks are balanced, and the table header and alignment row are well formed.

Scope of the diff: one file changed (index.qmd), with 42 insertions and 5 deletions, against both the working tree and branch point 147040f. No script or GIF changed, so the animation is not under review. I looked at the contact sheet and at frame 1 only to check claims 14, 21 and 23. The unchanged Animations introduction and Case 1's Behavior paragraph agree with the new Description: natural ends exact for sin, O(h⁴), O(h²) when f″ ≠ 0 at an end, 3 to 9 nodes too few to show the rate.

Fidelity: the definition, the natural and clamped end conditions, and the uniqueness of both match Mathews' module. The module gives no error-order result, so the accuracy statements are additions and do not contradict it. Nothing on the page departs from the module.
