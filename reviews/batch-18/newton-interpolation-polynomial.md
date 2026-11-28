# Newton Interpolation Polynomial — batch 18 review, round 1 (overview mode)

SUMMARY: 0 Error, 0 Misleading, 1 Minor

Page: `pages/numerical-methods/newton-interpolation-polynomial/index.qmd` (light-pass batch 18, overview, action *extend*). Diff: `EV/diff.patch`. Scratch: `/tmp/claude-1001/-home-jason--claude-spares-spare-0ogoFf/f6c51b48-3d53-4b4d-8872-653429a6389a/scratchpad/work/review-18/newton-interpolation-polynomial/reviewer/` (`chk1.py`, `chk2.py`, plus the Mathews image montages `bounds.png`, `thm.png` and `hyp.png`). I did not run MATLAB or quarto, and I changed nothing in the repository. I consulted the Mathews archive: `n2003/NewtonPolyMod.html` and its formula images `NewtonPolyMod_gr_1–31` and `73–100`.

## 1. Findings

**F1 (Page text, Minor).** Index.qmd line 41: "for $1/(1+10x^2)$ on $[-1, 1]$ it falls to $0.135$ at degree 7 and then grows to $0.485$ with 16 nodes".
- **What is there:** "degree 7" is the frame's nominal degree (8 nodes). The function is even and the nodes are symmetric, so that interpolant actually has degree 6. The Animations introduction, which comes after the Description, says this explicitly for the even cases ("the frame titled degree 15 has degree 14"). The same sentence avoids the problem at its other end by writing "with 16 nodes" rather than "degree 15". So it is careful at one end and nominal at the other.
- **The numbers themselves are right.** chk2.py recomputes them at 60 digits: the largest error on [-1, 1] at 8 nodes is 0.1351, and at 16 nodes it is 0.4849.
- **Suggested correction:** "falls to $0.135$ with 8 nodes and then grows to $0.485$ with 16 nodes". The Lagrange page's alternative also works: "in the frame titled degree 7".

No other findings.

## 2. Claim ledger (the + lines of the diff)

1. "Given $n+1$ points … distinct nodes … polynomial of degree at most $n$ that passes through all of them." Confirmed: this is the standard statement, and Mathews states the same.
2. "That polynomial is unique." Confirmed: this is a standard result.
3. Newton form $P_n(x)=a_0+\dots+a_n\prod_{j<n}(x-x_j)$ with $a_k=f[x_0,\ldots,x_k]$. Confirmed. It matches Mathews' gr_15 and gr_23. newtpolyaa.jl implements it: `divided_diff` returns the top diagonal, and `newton_eval` is Horner on that diagonal.
4. "built column by column from $f[x_k]=f(x_k)$" and the recurrence $f[x_i..x_{i+j}] = (f[x_{i+1}..x_{i+j}] - f[x_i..x_{i+j-1}])/(x_{i+j}-x_i)$. Confirmed. It is Mathews' gr_30 rewritten with the index $i$ starting from the left. The script's loop `d[i]=(d[i]-d[i-1])/(xs[i]-xs[i-j+1])` is the same recurrence. Running the same algorithm at 60 digits reproduces the Behavior paragraph's $a_0..a_5$ = 1, −0.0996671, −0.488402, 0.0490076, 0.0381225, −0.00396205.
5. "Newton and Lagrange forms produce the same polynomial" (an old sentence, kept). Confirmed: this follows from uniqueness.
6. $P_n=P_{n-1}+a_n\prod_{j<n}(x-x_j)$, "a new node adds one term and leaves $a_0..a_{n-1}$ unchanged, as the divided-differences case shows frame by frame". Confirmed. The top diagonal of the table depends only on $x_0..x_k$. Each newtpolyaa frame adds one node, and its title names only the new coefficient. I read all five frames: they show a_1 = −0.0996671 through a_5 = −0.00396205, matching my values.
7. "The divided-difference table takes $n(n+1)/2$ divisions". Confirmed: $\sum_{j=1}^{n}(n+1-j) = n(n+1)/2$.
8. "nested multiplication then evaluates $P_n(x)$ with $n$ multiplications". Confirmed: Horner on $n+1$ coefficients uses $n$ multiplications, as in the script's `newton_eval`.
9. "The nodes must be distinct, since each divided difference divides by $x_{i+j}-x_i$; building $P_n$ needs nothing else." Confirmed.
10. Error theorem: "if $f\in C^{n+1}[a,b]$ and $x, x_0..x_n$ lie in $[a,b]$, then for some $c$ in $[a,b]$, $f(x)-P_n(x)=f^{(n+1)}(c)/(n+1)!\,\prod(x-x_k)$". Confirmed, and it is faithful to Mathews: his hypothesis $f\in C^{n+1}[a,b]$ is gr_10 to gr_11, and his remainder with $c=c(x)\in[a,b]$ is gr_23 to gr_25. The hypothesis is stated as a general result.
11. Equally spaced bounds "for $n=1$ to $5$, from $M_2h^2/8$ to $\frac{10+7\sqrt7}{1215}M_6h^6$", with $M_{n+1}$ on $[x_0,x_n]$ and the bound on $[x_0,x_n]$. Confirmed against Mathews' gr_86 to gr_100 (all five bounds, each on $[x_0,x_n]$) and gr_84 to gr_85 ($M_{n+1}$ for $x_0<x<x_n$). I also checked the constants independently: the maximum of $|\prod_{k=0}^n(t-k)|$ on $[0,n]$, divided by $(n+1)!$, is 0.125, 0.06415003, 0.04166667, 0.03026194, 0.02347346. These equal $1/8$, $1/(9\sqrt3)$, $1/24$, $\sqrt{4750+290\sqrt{145}}/3000$ and $(10+7\sqrt7)/1215$ (chk1.py).
12. "so for a fixed degree the error is $O(h^{n+1})$". Confirmed as a general result under the stated bounded $M_{n+1}$.
13. Case dd, $h=0.2$: "largest error … $4.97\times10^{-3}$ at degree 1 against the bound $5.00\times10^{-3}$". Confirmed. My largest error on [0, 0.2] is 4.97089e-3. The bound is $M_2=\max_{[0,0.2]}|\cos|=1$ times $0.04/8$, which is 5.000e-3. Frame 1's title reads 4.97e-03.
14. Case dd: "$1.35\times10^{-6}$ at degree 5 against $1.50\times10^{-6}$". Confirmed. My largest error on [0, 1] is 1.34999e-6. The bound is $M_6=1$ times 0.0234735 times $0.2^6$, which is 1.5023e-6. Frame 5's title reads 1.35e-06.
15. "Raising the degree on equally spaced nodes does not always help." Confirmed by items 16 and 17.
16. "For $e^x$ on $[-2,3]$ the largest error on the node interval falls to $3.05\times10^{-10}$ at degree 15 ([Case 15])". Confirmed. At 60 digits on a grid of 3001 points, the errors at degrees 1, 2, 3, 4, 5, 7, 9, 11, 13 and 15 are 9.647, 3.335, 1.001, 0.2667, 0.0635, 2.63e-3, 7.57e-5, 1.58e-6, 2.49e-8 and 3.053e-10, falling monotonically. The script's nodes for Case 15 are `auto_span` on (−2, 3), and f is finite throughout, so the nodes span exactly [−2, 3]. In the frames (contact sheet and last frame), the curves visibly coincide from degree 5 on.
17. Case 08: "falls to $0.135$ at degree 7 and then grows to $0.485$ with 16 nodes, in oscillations next to the end nodes (Runge's phenomenon)". Confirmed. The errors are 0.909, 0.488, 0.479, 0.315, 0.203, 0.1351 (8 nodes), then 0.173, 0.236, 0.334, 0.4849 (16 nodes). The decrease is monotone up to 8 nodes, and the increase after it is monotone. The maximum at 16 nodes is at x = ±0.963, between the last two nodes. Frame 10 shows the overshoots to about 0.58 next to x = ±1. See F1 for the nominal "degree 7".
18. "Outside $[x_0,x_n]$ the product … grows quickly, so extrapolation is unreliable". Confirmed as a general statement.
19. Case 04: "the degree-15 interpolant is $64.5$ at $x=2.5$, where $\sqrt{2.5}\approx1.58$". Confirmed: $P_{15}(2.5)$ = 64.5416 and $\sqrt{2.5}$ = 1.58114 (16 equally spaced nodes on [0, 2], 60 digits). Frame 10 of lagnewt04 shows the interpolant leaving the top of the plot (y = 4) near x ≈ 2.25. The value at 2.5 is therefore off-screen, consistent with the text, which does not claim the frame shows 64.5.
20. The "Cases 01–29 … Lagrange page" sentence: its words are unchanged and its link changed from `…/index.qmd` to the directory form. Confirmed; this is an allowed link edit, and the target exists.
21. "[Aitken's and Neville's Interpolation] evaluate the same polynomial at one point with a similar recursive tableau". Confirmed against that page's Description.
22. "[Chebyshev Approximation Polynomial] clusters the nodes near the ends to tame the oscillations of Case 08". Confirmed. The Chebyshev page says exactly this, links back to `#case-08` here, and quotes 0.48 for 16 equally spaced nodes, consistent with item 17.
23. "[Hermite …] also matches derivative values; [Cubic Splines] join low-degree pieces instead of raising the degree". Confirmed: both are standard descriptions and both pages exist.
24. Heading ids `{#case-04}`, `{#case-08}`, `{#case-15}` and `{#case-dd}` are on the right headings (lines 67, 83, 117 and 185) and have no duplicates. Confirmed.

## 3. Checks

**Six points of the standard**
1. Problem: line 12. Present.
2. Core formula: Newton form plus the divided-difference recurrence, as display math in the script's notation. Present.
3. Assumptions: distinct nodes for construction, and $C^{n+1}$ for the error term. Present.
4. Accuracy: the general remainder, Mathews' equal-spacing bounds and $O(h^{n+1})$, each labelled general, then checked against the dd case's own values (items 13 and 14). Present.
5. Failure modes: Runge's phenomenon in Case 08 and extrapolation in Case 04, both linked. Present.
6. Where it fits: line 45. Present.

There are no proofs, callout boxes or MATLAB/Mathematica procedures, and no worked example (none was needed).

**Word count.** The manifest gives 388, and my own count gives about 389. Both are within 150–400.

**Links.** All the relative page links resolve:
- `../lagrange-polynomial-interpolation-and-approximation/`
- `../aitkens-and-nevilles-interpolation/`
- `../chebyshev-approximation-polynomial/`
- `../hermite-polynomial-interpolation/`
- `../cubic-splines/`

Each of these has an `index.qmd`. The directory form matches the approved pilot pages, for example `../secant-method/`. All four anchors (`#case-dd`, `#case-15`, `#case-08`, `#case-04`) match explicit heading ids.

**Diff scope.** Outside the Description, the diff only adds the four `{#…}` ids to case headings, which is allowed. It changes no scripts or GIFs, and nothing was moved out of the Animations introduction.

**Consistency with the rest of the page.** Items 13, 14 and 16–19 agree with the dd Behavior paragraph and the frame titles. They also agree with the Lagrange page (3.05e-10, 0.135, 0.485, 64.5) and the Chebyshev page (0.48). I found no contradictions.

**Frames examined:** the lagnewt08 contact sheet and frame 10, lagnewt04 frame 10, the lagnewt15 contact sheet, and all five frames of newtpolyaa on its contact sheet.

**Animations.** These are not under review, since the diff does not touch a script or a GIF.
