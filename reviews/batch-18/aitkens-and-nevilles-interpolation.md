# Aitken's and Neville's Interpolation — batch 18 review, round 1 (overview mode)

SUMMARY: 0 Error, 0 Misleading, 0 Minor

Review of `aitkens-and-nevilles-interpolation` (light-pass batch 18, overview mode, action *extend*). Page: /home/jason/Desktop/jasonhnicholson.com/pages/numerical-methods/aitkens-and-nevilles-interpolation/index.qmd. Diff: EV/diff.patch. The diff changes only index.qmd. It touches no script and no GIF, so the animations were not re-reviewed. I did not run MATLAB or quarto and modified nothing in the repository. My scratch scripts are in /tmp/claude-1001/-home-jason--claude-spares-spare-0ogoFf/f6c51b48-3d53-4b4d-8872-653429a6389a/scratchpad/work/review-18/aitkens-and-nevilles-interpolation/reviewer/ (chk.py, romb.py).

I consulted the Mathews archive: /home/jason/Desktop/math-fullerton/baseline/mathews/n2003/NevilleAlgorithmMod.html, read as text.

## 1. Findings

None.

I considered two possible findings and rejected both:
- **"the change between successive diagonal entries estimates the error of the earlier one" (line 44).** The sentence gives no condition, but the identity it rests on is stated beside it. The case right after it (Case 1, line 49) shows exactly when the estimate fails. A reader is not misled, so this is not a finding.
- **"Mathews tests convergence on these values" (line 44).** The module says "one usually tests for convergence of these values". The page's wording is a fair paraphrase, so this is not a Fidelity finding.

## 2. Claim ledger (the + lines of the diff)

| # | Claim (page wording) | Verdict | Evidence |
|---|---|---|---|
| 1 | Line 12/13: the first sentence is split onto two lines; the words are unchanged | confirmed | diff |
| 2 | "Here $P_{i,j}$ is the interpolant on the consecutive nodes $x_i,\dots,x_j$" | confirmed | chk.py: every Neville $P_{i,j}$ equals the Lagrange interpolant on $x_i..x_j$ to within 1e-25 (7 random nodes, mp 40 digits) |
| 3 | The final value at $x$ is $P_{0,n-1}(x)$ (kept from the old text) | confirmed | same check |
| 4 | Aitken: $Q_{0,j}=y_j$, $Q_{k,j}$ is the interpolant on $x_0..x_{k-1},x_j$, and $Q_{k,j}=[(x-x_{k-1})Q_{k-1,j}-(x-x_j)Q_{k-1,k-1}]/(x_j-x_{k-1})$ for $j\ge k$ | confirmed | chk.py: the recursion as written, run on 7 random nodes, agrees with the Lagrange interpolant on $\{x_0..x_{k-1},x_j\}$ to 3e-40. It matches Mathews' rule ("same row, preceding column" plus "top row, preceding column") |
| 5 | "At stage $k$ it combines the interpolant on $x_0..x_{k-1}$ with the interpolant on $x_0..x_{k-2},x_j$, so every entry in a column shares the same leading nodes"; Neville combines neighbouring consecutive runs | confirmed | follows from #4 and the Neville formula |
| 6 | Both schemes produce the same sequence $Q_{k,k}=P_{0,k}$, $k=0..n-1$, the diagonal of Mathews' two tableaux, with the same final value | confirmed | chk.py: max \|Q_kk − P_0k\| = 9e-41. Mathews: "Aitken's and Neville's methods agree on the diagonal" |
| 7 | "The animations below use Neville's scheme" | confirmed | both scripts call `neville_table` (Neville recursion) |
| 8 | Both recursions need only the $y_i$ and distinct nodes (they divide by node differences); the nodes need not be equally spaced | confirmed | denominators $x_j-x_i$ and $x_j-x_{k-1}$; the random unequal nodes in #2 and #4 work |
| 9 | Each query point costs $n(n-1)/2$ new tableau entries | confirmed | chk.py counts: Neville 21, Aitken 21, $n(n-1)/2=21$ for $n=7$ |
| 10 | Remainder: if $f\in C^{j+1}$ on an interval $I$ containing $x$ and $x_0..x_j$, then $f(x)-P_{0,j}(x)=f^{(j+1)}(c)/(j+1)!\,\prod_{i=0}^{j}(x-x_i)$ for some $c\in I$; same polynomial as Lagrange | confirmed | standard theorem with sufficient hypotheses (distinct nodes stated on line 35); agrees with Mathews' remainder theorem |
| 11 | $f-P_{0,j-1}=(P_{0,j}-P_{0,j-1})+(f-P_{0,j})$, so the change estimates the earlier error | confirmed | algebraic identity |
| 12 | Mathews tests convergence on these values | confirmed (paraphrase) | module: "one usually tests for convergence of these values" |
| 13 | Case 2: each error at $\hat x=1.8$ lies within the remainder bounds with $e^1\le f^{(j+1)}(c)\le e^{\max(x_j,1.8)}$ | confirmed | bounds against errors, j=0..5: [2.17, 4.84] vs 3.331; [0.598, 1.331] vs 0.8608; [0.0598, 0.1331] vs 0.08889; [7.48e-4, 1.66e-3] vs 1.193e-3; [−8.13e-5, −2.99e-5] vs −5.226e-5; [2.24e-6, 7.83e-6] vs 4.339e-6. All inside |
| 14 | Case 2 changes 2.47, 0.772, 0.0877, 1.25e-3, −5.66e-5 | confirmed | computed 2.4706, 0.77188, 0.087694, 1.2453e-3, −5.659e-5 |
| 15 | Case 2 errors 3.33, 0.861, 0.0889, 1.19e-3, −5.23e-5 of $P_{0,0..4}$ | confirmed | computed 3.3314, 0.86077, 0.088887, 1.1931e-3, −5.2256e-5. They also match the GIF legends (frames 1–5 of nevillebb) |
| 16 | "the changes … track the errors" | confirmed | the ratio of change to error is 0.74, 0.90, 0.99, 1.04, 1.08, and the signs agree |
| 17 | "Adding a node does not guarantee a smaller error" | confirmed | Case 1: max error goes 0.899 → 1.657 from j=1 to j=2 |
| 18 | Case 1: $P_{0,2}$ uses $0,\pi/4,\pi/2$, so at $x=\pi$ it extrapolates; $\prod_i(x-x_i)$ is 11.6 there | confirmed | $3\pi^3/8=11.627$ |
| 19 | "against at most 0.19 between the nodes" | confirmed | max of $\|x(x-\pi/4)(x-\pi/2)\|$ on $[0,\pi/2]$ = 0.18647 |
| 20 | Largest error on $[0,\pi]$ rises from 0.90 to 1.66 | confirmed | 0.89880 → 1.65685, the latter at $x=\pi$ ($P_{0,2}(\pi)=-2.6569$). Agrees with the Case 1 Behavior paragraph and frame 3 |
| 21 | In Case 1, $P_{0,4}=P_{0,3}$, so the last change is zero everywhere | confirmed | max \|P04−P03\| on a grid = 1.4e-40; nevilleaa frames 4 and 5 show the same curve |
| 22 | Yet $P_{0,3}$ is in error by up to 8.1e-3 on $[0,\pi]$ | confirmed | 8.0677e-3 |
| 23 | Same polynomial as the Lagrange and Newton forms | confirmed | uniqueness theorem |
| 24 | Chebyshev Approximation chooses nodes that keep the product term small | confirmed | the Chebyshev page (line 39) says its nodes minimise the max of $\|\prod(x-x_k)\|$ |
| 25 | Romberg is Neville's scheme in $h^2$, applied to trapezoidal sums, evaluated at $h^2=0$ | confirmed | romb.py: Neville at t=0 on $t_i=h_i^2$ (h halving, ∫₀¹eˣ) reproduces the Romberg table $R_{i,k}=P_{i-k,i}(0)$ to 4.4e-16. Consistent with the Romberg page's "Richardson Extrapolation applied to the Trapezoidal Rule" |
| 26 | Aitken's interpolation is a different method from Aitken's Δ² acceleration | confirmed | different methods |
| 27 | Heading id `{#case-1}` added to the Case 1 heading | confirmed | allowed cross-reference id; the link `[Case 1](#case-1)` matches |
| 28 | Heading id `{#case-2}` added to the Case 2 heading | confirmed | allowed; `[Case 2](#case-2)` matches |

## 3. Checks

**Six points of the overview standard:**
1. Problem: line 12.
2. Core formula: display math for Neville (lines 15–20) and Aitken (26–29), in the scripts' notation (`P[i,j]`, same recursion).
3. Assumptions: line 35 (values and distinct nodes, unequal spacing allowed) and the $C^{j+1}$ hypothesis on line 38.
4. Accuracy: the remainder term with hypotheses (38–42), pointed at Case 2 and checked on Case 2's own numbers (#13–16).
5. Failure modes: extrapolation raising the error, and the convergence test fooled by $P_{0,4}=P_{0,3}$, both linked to Case 1 and computed (#17–22).
6. Where it fits: line 51.

There are no proofs, no theorem or definition callouts, no MATLAB or Mathematica. All six points are present.

**Word count:** I recomputed it independently (inline math = 1 word, display math removed, link targets stripped): 399, which matches the manifest. That is within 150–400, at the upper edge.

**Links and anchors:** these all exist as `<dir>/index.qmd`:
- ../lagrange-polynomial-interpolation-and-approximation/
- ../newton-interpolation-polynomial/
- ../chebyshev-approximation-polynomial/
- ../romberg-integration/
- ../aitken-method-and-steffensen-acceleration/

`#case-1` and `#case-2` resolve to the explicit heading ids added in the diff.

**Scope of the diff:**
- Outside the Description, the only changes are the two heading ids, which are allowed.
- The Animations introduction, Behavior paragraphs, alt texts and source links are unchanged.
- Inside the Description, the old Aitken sentences were kept. The only change is the notation "$P_{0,0},\dots,P_{0,n-1}$" → "$Q_{k,k}=P_{0,k}$, $k=0..n-1$", which I checked as new text (#6).
- The new text contradicts nothing in the Animations sections. The Case 1 numbers (0.90, 1.66, −2.66 at π, 8.1e-3) and the Case 2 values and errors agree with the Behavior paragraphs and with the GIF legends and titles I viewed (contact sheets of nevilleaa and nevillebb).

**Scripts:** unchanged by the diff and not under review. I read them only to confirm they implement the Neville recursion the Description states.
