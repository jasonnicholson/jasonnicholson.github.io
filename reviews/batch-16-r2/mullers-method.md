# Muller's Method — batch 16 review, round 2 (overview mode)

SUMMARY: 0 Error, 0 Misleading, 1 Minor

Review of `pages/numerical-methods/mullers-method/index.qmd`, light-pass batch 16 (r2), overview page (action *write*). EV = /tmp/claude-1001/-home-jason--claude-spares-spare-0ogoFf/f6c51b48-3d53-4b4d-8872-653429a6389a/scratchpad/work/review-16r2/mullers-method. Scratch scripts are in EV/reviewer/: muller.py, muller2.py, muller3.py, c1.py, sym.py, wc.py. I did not read `reviews/`, did not run MATLAB or quarto, and changed nothing in the repository. I consulted the Mathews archive: MullersMethodMod.html, the Mathematica `Muller` subroutine image MullersMethodMod_gr_5.gif, and mullersmethod/MullersMethodProof.pdf (textbook section 2.5).

## 1. Findings

**F1 (Page text, Minor): "nearest root" and "the first is 1.2873 + 0.3563i" leave out a tie.**
- **Where:** Description, "and the next iterate is the root of $P$ nearest $p_2$", "with the sign chosen to make the denominator larger in magnitude, which picks that nearer root", and "its iterates leave the real line (the first is $1.2873 + 0.3563i$)".
- **What is true:** When the discriminant is negative and $b$, $d$, $f(p_2)$ are real (the Case 1 situation), $|b + i\sqrt{-D}| = |b - i\sqrt{-D}|$. The two roots $1.2873 \pm 0.3563i$ are a conjugate pair, both exactly the same distance from $p_2$. So "nearest" does not pick one; the sign is a tie-break. My complex-arithmetic run (muller2.py, ties go to $+$) gives $1.2873016 + 0.35634479i$. Because $f$ is real, the other choice gives the conjugate path, and both converge to 1. The claim "still converge to the double root $p = 1$" holds either way.
- **Effect:** Small. A reader might think the method singles out the $+i$ root.
- **Suggested fix:** "(the first is one of the conjugate pair $1.2873 \pm 0.3563i$, which are equally near $p_2$)". Or add "with ties broken either way" after the sign rule.

No Error, Misleading or Fidelity findings.

Observations, not findings:
- Mathews' textbook (Proof PDF, section 2.5) says complex approximations' "imaginary components ... can be set equal to zero". That is the real-part (vertex) variant the animation uses. His Mathematica program instead sets disc = 0, which drops the square root; I confirmed this in gr_5.gif. The Description's statement that "Mathews' program drops the square root" is therefore accurate.
- Mathews' update rule keeps the two old points nearest $p_3$. The Description describes dropping the oldest point, which is what the scripts do and is the classical Muller rule. The Case 1 text already notes the difference. This is a valid variant, so it is not a finding.
- Mathews writes the parabola with $h_0 = p_0 - p_2$ and $h_1 = p_1 - p_2$, while the page uses divided differences. sym.py shows the two give identical $a = d$ and $b$, so this is a valid alternative formulation.

## 2. Claim ledger (diff `+` lines)

| # | Claim (page's words) | Verdict | Evidence |
|---|---|---|---|
| 1 | Solves a single equation $f(x)=0$ and can find complex roots as well as real ones | confirmed | Complex run converges to $p=1$; matches Mathews ("real or complex zeros") |
| 2 | Like the Secant Method, uses only values of $f$, not its derivative | confirmed | Scripts call only `f` |
| 3 | Parabola through three points $p_0, p_1, p_2$; next iterate where it crosses the x-axis | confirmed | Scripts mullersaa/bb/cc.jl |
| 4 | $P(x) = f(p_2) + b(x-p_2) + d(x-p_2)^2$ with the $h_0, h_1, \delta_0, \delta_1, d, b$ formulas | confirmed | Same as `muller_step` in all three scripts; sym.py shows $P$ interpolates all three points (residuals [0,0,0]) and equals Mathews' $a$, $b$ |
| 5 | $p_3 = p_2 - 2f(p_2)/(b \pm \sqrt{b^2 - 4f(p_2)d})$ | confirmed | Scripts compute `p2 - 2*f2/E` |
| 6 | Sign chosen to make the denominator larger in magnitude; picks the nearer root; avoids cancellation | confirmed, with tie caveat (F1) | Script rule `abs(b+D) >= abs(b-D)`; $\lvert z\rvert = 2\lvert f_2\rvert/\lvert E\rvert$ is minimised by the larger $\lvert E\rvert$ |
| 7 | Oldest point dropped; repeat with $(p_1, p_2, p_3)$ | confirmed | `history[i+1] = (q1, q2, q3)` |
| 8 | Each step costs one new value of $f$ | confirmed | True of the method (Mathews says the same); the script re-evaluates for plotting, which does not change the method |
| 9 | Starting points must be distinct; no sign change or bracket needed | confirmed | Divisions by $h_0$, $h_1$, $h_0+h_1$; Cases 2 and 3 start with all $f>0$ and converge |
| 10 | Convergence is only local | confirmed | Standard result; not contradicted by any case |
| 11 | If $f \in C^3$ near a simple root and the iterates converge, $e_{n+1} \approx -\frac{f'''(p)}{6f'(p)} e_n e_{n-1} e_{n-2}$, with $e_n = p_n - p$ | confirmed, sign included | muller3.py at 600 digits: $e^x-2$ ratio goes to −0.16666667 (predicted −1/6); $x^3+x-2$ goes to −0.25 (predicted −0.25) |
| 12 | When $f'''(p) \neq 0$ the order is about 1.84, the real root of $\alpha^3=\alpha^2+\alpha+1$ | confirmed | Root 1.8392868; $\sin x$ at 0 gives orders 1.85, 1.844, 1.836 |
| 13 | If $f'''(p) = 0$ the order is higher | confirmed (one example) | $x + x^4 + x^5$ at 0 gives orders about 1.96–2.01 |
| 14 | Faster than the secant method's 1.62 | confirmed | $(1+\sqrt5)/2 = 1.618$ |
| 15 | "As Mathews puts it, almost as fast as Newton's method" | confirmed (attribution) | MullersMethodMod.html: "near a simple root ... almost as fast as Newton's method" |
| 16 | All three cases have double roots | confirmed | $(x-1)^2(x+2)$; $\sin(u)\,u$ with $u = x^2-2$; $(x^2-1)(x^2-3)^2$ |
| 17 | In Case 2 and Case 3 the computed order settles near 1.23 as the iteration continues past the frames shown | confirmed | muller.py at 400 digits. Case 2 orders for $i = 11$–24: 1.2316, 1.2322, 1.2307, 1.234, 1.2337 … 1.2338. Case 3 for $i = 12$–24: 1.229, 1.2303, 1.233, 1.2334 … 1.2338. Inside the frames (iterates up to index 11) they still swing between 1.12 and 1.24. The limit 1.2338 matches the root of $2\alpha^3 = \alpha^2+\alpha+1$. |
| 18 | Still superlinear; Newton is only linear at a double root | confirmed | Standard: Newton's error ratio tends to $(m-1)/m = 1/2$ |
| 19 | Parabola need not cross the axis; then $b^2 - 4f(p_2)d < 0$ and the next iterate is complex | confirmed | Algebra |
| 20 | Real-only arithmetic cannot take the step | confirmed | Case 2 and 3 scripts raise an error on a negative discriminant |
| 21 | In Case 1 this happens at every step | confirmed | c1.py, all 8 frames, both float and mp: disc = −20.16, −3.909, −0.5667, −0.0302, −1.007e-3, −1.097e-5, −2.157e-8, −6.525e-12 |
| 22 | The animation takes the parabola's vertex instead | confirmed | `p2 - b/(2d)` in mullersaa.jl; frames show the open circle at the vertex (sheet.png) |
| 23 | Mathews' program drops the square root | confirmed | gr_5.gif: `If[b b > 4 a c, disc = Sqrt[...], disc = 0]` |
| 24 | With complex arithmetic the iterates leave the real line, the first is $1.2873 + 0.3563i$, and still converge to $p = 1$ | confirmed (sign is a tie-break, F1) | muller2.py: $1.2873016 + 0.35634479i$, then $1.0535 + 0.2872i$, $0.9107 + 0.1536i$, …; error falls to 1.1e-201 (the 400-digit floor for a double root), orders about 1.234 |
| 25 | Newton-Raphson needs $f'$ and converges quadratically at simple roots | confirmed | Standard |
| 26 | Accelerated/Modified Newton-Raphson restore that rate at multiple roots | confirmed | Agrees with that page, lines 15–20 |
| 27 | Brent's Method uses inverse quadratic interpolation inside a sign-change bracket | confirmed | brents-method/index.qmd line 16 |
| 28 | Lin-Bairstow reaches complex roots of polynomials using only real arithmetic | confirmed | lin-bairstow-method/index.qmd line 13 |
| 29 | Heading ids `{#case-1}`, `{#case-2}`, `{#case-3}` added; links `#case-1/2/3` | confirmed | The ids are on the three case headings and the anchors match |

## 3. Checks

**The six points of the standard:**
1. Problem: present (paragraph 1).
2. Core formula: present, as display math in the scripts' notation (p0, p1, p2, h, δ, d, b).
3. Assumptions: present (distinct points, no bracket needed, local convergence, $C^3$, simple root).
4. Accuracy: present (general error equation with its hypotheses, order 1.84, the $f'''(p)=0$ caveat, and the computed double-root order pointing to Cases 2 and 3, checked from the cases' own iterates).
5. Failure: present (complex step in Case 1, linked; local convergence).
6. Where it fits: present (Secant, Newton-Raphson, Accelerated/Modified NR, Brent, Lin-Bairstow).

There is no worked example (optional), no callout box, and no proof.

**Word count:** the manifest gives 397. My token count (wc.py) is 412, but it includes the "## Description" heading and about 15 standalone punctuation tokens left after replacing inline math. Corrected, it agrees with roughly 395–397. This is within 150–400, but only just.

**Links and anchors:**
- `../secant-method/`, `../newton-raphson-method/`, `../accelerated-and-modified-newton-raphson/`, `../brents-method/` and `../lin-bairstow-method/` all exist, each with an index.qmd.
- `#case-1`, `#case-2` and `#case-3` match the explicit heading ids.
- The manifest's mechanical checks: none found.

**Diff scope:**
- EV/diff.patch is identical to `git diff 147040f` for the page.
- Only index.qmd changed. No script or GIF changed, so the animations are not under review.
- Outside the Description the only changes are the three `{#case-N}` heading ids, which are allowed. No sentences were moved.

**Consistency with the rest of the page:**
- The Description's 1.23 order for Cases 2 and 3 agrees with Case 3's "order ≈ 1.23".
- It does not contradict Case 1's "≈ 1.32 for this real-part variant", because the Description does not state an order for Case 1.
- Its "oldest point is dropped" matches the Animations introduction.
- Its $1.2873 + 0.3563i$ matches Case 1's Behavior text.

**Frame cross-check:**
- mullersaa has 8 frames and mullersbb and mullerscc have 9 each.
- In the Case 1 sheet, no parabola reaches the axis and the vertex heights run from 8.00e-01 to 5.43e-13.
- The last Case 3 frame shows $p_2 = 1.73199$ and a step of 5.52e-05. My sequence gives $p_{10} = 1.73198780$ and $p_{11} = 1.73204300$, a step of 5.52e-5.
- Case 2's last step is $p_{11} - p_{10} = 3.58\text{e-}5$.
- So the frames end at errors near 3e-6 (Case 2) and 8e-6 (Case 3), and "past the frames shown" is accurate.
