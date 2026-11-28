# Muller's Method — batch 16 review, round 1 (overview mode)

SUMMARY: 1 Error, 0 Misleading, 0 Minor

Page: `pages/numerical-methods/mullers-method/index.qmd` (overview page, light-pass batch 16). The diff changes only `index.qmd`. It adds the `## Description` (lines 10–50) and the explicit ids `{#case-1}`, `{#case-2}` and `{#case-3}` on the three case headings. No script or GIF changed, so the animations were not re-reviewed. I consulted the Mathews archive (`/home/jason/Desktop/math-fullerton/baseline/mathews/n2003/MullersMethodMod.html`, read as text). I did not run MATLAB or quarto, and I modified nothing in the repository. My scratch files are in `/tmp/claude-1001/-home-jason--claude-spares-spare-0ogoFf/f6c51b48-3d53-4b4d-8872-653429a6389a/scratchpad/work/review-16/mullers-method/reviewer/`: `chk.py`, `const.py`, `f3zero.py` and `wc.py`.

## 1. Findings

**F1 — Page text, Error. The order 1.84 is stated without the hypothesis f'''(p) ≠ 0.**
- **Location:** index.qmd, Description, lines 34–41: "In general, if $f \in C^3$ near a simple root $p$ ($f'(p) \neq 0$) and the iterates converge to it, the errors … satisfy $e_{n+1} \approx -\frac{f'''(p)}{6 f'(p)}\, e_n e_{n-1} e_{n-2}$, so the order is about 1.84".
- **What is wrong:** the error relation is correct. The conclusion "the order is about 1.84" holds only when f'''(p) ≠ 0. When f'''(p) = 0 the leading constant vanishes and the order is higher.
- **Evidence:** `f3zero.py` runs Muller's method at 600 digits on f(x) = x + x⁴. Its root p = 0 is simple, with f'(0) = 1 and f'''(0) = 0. Starting from (0.3, 0.2, 0.1), the successive order estimates log(e_n/e_{n−1}) / log(e_{n−1}/e_{n−2}) are 1.99, 2.14, 1.94, 2.00, 2.02, 1.99. That is order about 2, not 1.84.
- **Sibling page:** the Secant Method page from this same batch states the matching condition. Its line 32 reads "when $f''(p) \neq 0$ this makes the order … ≈ 1.618", and its line 45 covers the faster case. This page leaves that condition out.
- **Effect:** the error is in the safe direction (convergence is faster, not slower), so the practical harm is small. Still, it is a general claim that holds only under a hypothesis the page leaves out, and the brief classes that as an Error.
- **Suggested fix:** "…so, when $f'''(p) \neq 0$, the order is about 1.84, the real root of $\alpha^3 = \alpha^2 + \alpha + 1$ (if $f'''(p) = 0$ it is higher)."

No other findings.

## 2. Claim ledger (text added by the diff)

| # | Claim (page's words) | Verdict | Evidence |
|---|---|---|---|
| 1 | "solves a single equation f(x)=0, and it can find complex roots as well as real ones" | confirmed | Agrees with Mathews: "can be used to find real or complex zeros". The complex run in `chk.py` (ledger #20) shows it. |
| 2 | Like the Secant Method, uses only values of f, not f′ | confirmed | The formula on lines 17–26 uses f values only. |
| 3 | Parabola through three points p0, p1, p2; next iterate where it crosses the x-axis | confirmed | Matches `muller_step` in all three scripts. |
| 4 | P(x) = f(p2) + b(x−p2) + d(x−p2)² with h0, h1, δ0, δ1, d = (δ1−δ0)/(h1+h0), b = δ1 + h1·d | confirmed | Identical to `muller_step` in mullersaa/bb/cc.jl, in the same notation. The algebra is also standard: d = f[p0,p1,p2] and b = f[p1,p2] + h1·f[p0,p1,p2] = P′(p2). |
| 5 | p3 = p2 − 2f(p2)/(b ± √(b² − 4f(p2)d)) | confirmed | Same as the scripts (`E`, `p2 - 2*f2/E`). |
| 6 | Sign chosen to make the denominator larger in magnitude, picking the nearer root and avoiding cancellation | confirmed | The scripts use `abs(b+D) >= abs(b-D)`. A larger denominator gives the smaller step \|p3−p2\|. |
| 7 | Oldest point dropped; repeat with (p1, p2, p3); one new f value per step | confirmed | Scripts: `history[i+1] = (q1, q2, q3)`. Only f(p3) is new. |
| 8 | Three starting points must be distinct; no sign change or bracket needed | confirmed | Needed for h0, h1, h0+h1 ≠ 0. Case 1 starts on one side of the root, with f > 0 at all three points. |
| 9 | Convergence is only local | confirmed | Standard result. Not contradicted by any case. |
| 10 | If f ∈ C³ near a simple root and iterates converge: e_{n+1} ≈ −f'''(p)/(6f'(p)) · e_n e_{n−1} e_{n−2} | confirmed | `const.py`, 300 digits. For f = x³−2, the ratio e_n/(e_{n−1}e_{n−2}e_{n−3}) → −0.20998684, equal to −f'''/(6f′) = −0.20998684. For f = eˣ−2+sin x, it → −0.044935689 = C. Sign and constant are both right. C³ is sufficient, since the third divided difference tends to f'''(p)/6. |
| 11 | "so the order is about 1.84" | wrong as a general statement (F1) | True when f'''(p) ≠ 0: measured orders were 1.836–1.849 on both test functions. With f'''(p) = 0 it is about 2 (`f3zero.py`). |
| 12 | 1.84 is the real root of α³ = α² + α + 1 | confirmed | mpmath findroot gives 1.8392867552. |
| 13 | Faster than the secant method's 1.62 | confirmed | (1+√5)/2 = 1.618 < 1.839. |
| 14 | "as Mathews puts it, almost as fast as Newton's method" | confirmed | Mathews module: "near a simple root Muller's method converges faster than the secant method and almost as fast as Newton's method". The page's context is also a simple root. |
| 15 | All three cases on this page have double roots | confirmed | Case 1: (x−1)²(x+2). Case 2: sin(u)·u ≈ u² with u = x²−2, which has a simple zero at √2. Case 3: (x²−1)(x²−3)². |
| 16 | Case 2 and Case 3: computed order settles near 1.23 as the iteration continues past the frames shown | confirmed | `chk.py`, 400 digits, from the scripts' starting triples (0.8, 0.9, 1.0) and (1.3, 1.4, 1.5). Case 2 order estimates by iteration 9–24: 1.2316, 1.2322, 1.2307, 1.234, 1.2337, …, 1.2338. Case 3: 1.2252, 1.229, 1.2303, 1.233, …, 1.2338. The theoretical value is the root of 2α³ = α²+α+1, which is 1.23375. The real discriminant stays positive throughout both runs, so the real iteration continues. |
| 17 | Still superlinear; Newton only linear at a double root | confirmed | Standard result, and the order 1.234 > 1. The Accelerated/Modified Newton page (line 15) agrees: linear at multiple roots. |
| 18 | If the parabola does not cross the x-axis, b² − 4f(p2)d < 0 and the next iterate is complex | confirmed | Quadratic formula with d ≠ 0. |
| 19 | Case 1: this happens at every step; the animation takes the vertex; Mathews' program drops the square root | confirmed | I replicated the Float64 vertex variant. The discriminant is negative at all 8 steps: −20.16, −3.909, −0.5667, −0.03021, −1.007e−3, −1.097e−5, −2.157e−8, −6.525e−12. `mullersaa.jl` returns p2 − b/(2d) when disc < 0. The frames' legend reads "parabola (no real root)" and "vertex = next p₂". The statement about Mathews matches the Case 1 Behavior paragraph (line 60). |
| 20 | With complex arithmetic the iterates leave the real line, the first being 1.2873 + 0.3563i, and still converge to the double root p = 1 | confirmed | `chk.py` uses complex mpmath with the larger-modulus denominator. The first iterate is 1.2873016 + 0.35634479i. The iterates then go 1.0535+0.2872i, 0.9107+0.1536i, …, and the error to 1 reaches 1.1e−201, i.e. converged to p = 1, not −2. The first iterate agrees with the Case 1 Behavior paragraph. |
| 21 | Newton-Raphson needs f′ and converges quadratically at simple roots | confirmed | Standard result. |
| 22 | Accelerated and Modified Newton-Raphson restore that rate at multiple roots | confirmed | That page, line 16: "Two methods restore quadratic convergence." |
| 23 | Brent's method fits a parabola in the other direction (inverse quadratic interpolation) inside a sign-change bracket | confirmed | Standard description of Brent's method. |
| 24 | Lin-Bairstow reaches complex roots of polynomials using only real arithmetic | confirmed | Standard result: real quadratic factors. |
| 25 | Heading ids `{#case-1}`, `{#case-2}`, `{#case-3}` | confirmed | Present on lines 58, 66 and 74. The heading text is otherwise unchanged. |

## 3. Checks

**Scope of the diff.** The only change outside the Description is the three heading ids, and the overview standard allows exactly that. No Animations text, Behavior paragraph, alt text, script or GIF changed, and no sentence was moved.

**Consistency with the rest of the page:**
- The formulas use the scripts' own notation (p0, p1, p2, h0, h1, δ0, δ1, d, b).
- The Description's Case 1 statements agree with line 60: the complex first iterate 1.2873 + 0.3563i, the vertex variant, and Mathews' dropped square root.
- Its order of about 1.23 for Cases 2 and 3 agrees with the Case 3 Behavior ("order ≈ 1.23"). It correctly leaves out Case 1, whose real-part variant is stated as about 1.32 on line 60.
- It does not contradict the Animations introduction (line 54).
- I looked at the Case 1 contact sheet (`frames/mullersaa/sheet.png`). It shows the vertex marker, the inset heights falling from 8.00e−01 to 5.43e−13, and no axis crossings, which agrees with ledger #19.

**The six points:**
1. The problem: lines 12–14.
2. The core formula: display math on lines 17–26.
3. What it assumes: distinct points, no bracket, local convergence, C³ and a simple root. It is missing f'''(p) ≠ 0 for the order (F1).
4. How accurate it is: the error relation, order 1.84, and the double-root order 1.23 with links to Case 2 and Case 3.
5. When it fails or misleads: the complex step in real arithmetic, linked to Case 1, plus the slowdown at double roots.
6. Where it fits: one sentence linking four pages, plus the Secant link in the opening.

There are no callouts, proofs or theorem boxes.

**Word count.** My count is 390 words of prose with inline math counted as one word (`wc.py`; 403 raw tokens, of which 13 are bare punctuation). This matches the manifest and is inside 150–400.

**Links and anchors:**
- `#case-1`, `#case-2` and `#case-3` match the explicit ids.
- `../secant-method/`, `../newton-raphson-method/`, `../accelerated-and-modified-newton-raphson/`, `../brents-method/` and `../lin-bairstow-method/` all exist as directories under `pages/numerical-methods/`.

**Fidelity to Mathews.** The module describes the method only in prose: a parabola through three points, the quadratic formula, faster than secant and almost as fast as Newton near a simple root, real or complex zeros. The page agrees with all of it. No Fidelity findings.


## Independent check of F1 (a separate checker given only the allegation)

**F1: confirmed. Error is the right severity.**

The missing hypothesis is $f'''(p) \neq 0$. Lines 34–41 assume only $f \in C^3$ near a simple root and that the iterates converge. Under those assumptions the relation in the displayed formula holds. But when $f'''(p) = 0$ its leading coefficient $-f'''(p)/(6f'(p))$ is zero, the next term takes over, and the order is no longer 1.84. So "so the order is about 1.84" is false as stated.

**Counterexamples.** I ran a real Muller iteration in mpmath at 3000 digits, taking the larger-magnitude denominator, with starts $(0.5, 0.3, 0.2)$ and root $p = 0$. The script is `/tmp/claude-1001/-home-jason--claude-spares-spare-0ogoFf/f6c51b48-3d53-4b4d-8872-653429a6389a/scratchpad/work/review-16/mullers-method/checker/order.py`. Each row shows the last few values of $\log|e_{n+1}| / \log|e_n|$:

| $f(x)$ | $f'''(0)$ | Observed order |
|---|---|---|
| $x + x^3$ | $\neq 0$ | 1.8393, 1.8393, … (matches the page) |
| $\sin x$ | $\neq 0$ | 1.8411 → 1.8394 (matches) |
| $x + x^2$ (quadratic, $C^\infty$, simple root, converges) | $0$ | exact in one step; ratio about 4294, so no finite order |
| $x + x^2 + x^4$ | $0$, $f^{(4)} \neq 0$ | 2.0024, 1.9997, 1.9995, 2.0003, 2.0 |
| $x + x^2 + x^5$ | $0$, $f^{(4)} = 0$ | about 2.13 |

The quadratic is the simplest counterexample, since the parabola is the function itself. The order-2 case agrees with theory: when $f'''(p) = 0$ the error goes as about $e_n e_{n-1} e_{n-2}^2$, giving $\alpha^3 = \alpha^2 + \alpha + 2$, whose root is $\alpha = 2$.

**Severity.** By the brief's definition, a general claim that has counterexamples is false, so Error applies. In practice the exception is non-generic, and it makes convergence faster, not slower. A reader would only be misled about the case $f'''(p) = 0$. If the director weighs consequence over the letter of the claim, Misleading is the most it could be downgraded to. I'd keep Error, because the sentence is presented as a general theorem ("In general, if …").

**Suggested fix:** add the condition to line 34, e.g. "if $f \in C^3$ near a simple root $p$ ($f'(p) \neq 0$) with $f'''(p) \neq 0$ and the iterates converge to it …". Alternatively, keep the hypotheses and say "the order is at least about 1.84, and exactly that when $f'''(p) \neq 0$."

No MATLAB or quarto was run and the repository was not modified.
