# Aitken's and Neville's Interpolation — animation review (round 9)

Page: `pages/numerical-methods/aitkens-and-nevilles-interpolation/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim in the Description and Animations sections agrees with my independent computation and with the frames.

Not reported (cosmetic, below the threshold): GR renders the labels `P_{0,j}` literally with underscore and braces rather than as subscripts; the text is still unambiguous. The Case 1 Behavior paragraph uses $n$ for a degree while the Description uses $n$ for a point count; each usage is internally consistent.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `nevilleaa.jl` | 0 | 9.0 | nevilleaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `nevillebb.jl` | 0 | 16.9 | nevillebb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `nevilleaa.gif` | 5 | byte-identical | nevilleaa |
| `nevillebb.gif` | 6 | byte-identical | nevillebb |

### Page references

- Scripts linked: `nevilleaa.jl`, `nevillebb.jl`
- GIFs embedded: 2
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Location | Claim (page's words) | Verdict | Evidence |
|---|---|---|---|---|
| D1 | Description | Neville recurrence $P_{i,i}=y_i$, $P_{i,j}=\frac{(x-x_i)P_{i+1,j}-(x-x_j)P_{i,j-1}}{x_j-x_i}$ | confirmed | Substituting $x=x_i$ gives $P_{i,j-1}(x_i)=y_i$, $x=x_j$ gives $P_{i+1,j}(x_j)=y_j$; identical to both scripts lines 22-23 |
| D2 | Description | final value is $P_{0,n-1}(x)$, the unique polynomial of degree ≤ n−1 | confirmed | scripts return `P[1, deg+1]`; node residuals ≤ 9e-16; cubic $x^3-2x$ reproduced to 8.9e-15 |
| D3 | Description | Aitken stage k combines interpolant on $x_0..x_{k-1}$ with that on $x_0..x_{k-2},x_j$; columns share leading nodes; Neville combines neighbouring runs | confirmed | matches Mathews' Aitken rule ({same row, preceding column} with {top row, preceding column}) and Neville rule ({same row} with {preceding row}) in NevilleAlgorithmMod.html; index algebra checked |
| D4 | Description | both schemes produce the same sequence $P_{0,0},…,P_{0,n-1}$ (diagonal of Mathews' two tableaux) | confirmed | Mathews' Example 3 "Observation: diagonal entries are the same"; Example 2 image gr_290 shows Neville = Aitken values |
| D5 | Description | animations use Neville's scheme | confirmed | both scripts run the Neville recurrence |
| A1 | Intro | each frame adds one node and shows $P_{0,j}$ through first j+1 nodes | confirmed | `interp_degree` uses `xs[1:deg+1]`; frames show j+1 black nodes |
| A2 | Intro | Case 1: cos x at 5 nodes 0, π/4, π/2, 3π/4, π, j=0..4 | confirmed | nevilleaa.jl l.30-31, loop 0:4; 5 frames |
| A3 | Intro | Case 2: e^x at 6 nodes $x_i=1+i/4$, j=0..5 | confirmed | nevillebb.jl l.30-31, loop 0:5; 6 frames |
| A4 | Intro | No archived animation GIF for this topic; module has only static examples | confirmed | no Neville/Aitken entry under `a2001/Animations/` (Interpolation has Chebyshev, Fourier, Lagrange, Pade, Series only) |
| A5 | Intro | Case 2 animates Example 3: e^x, $x_i=1+i/4$, i=0..5, x̂=1.8 | confirmed | archive gr_295: `f[x_]=e^x; x_i=1.0+i/4; x̂=1.8; Table[x_i,{i,0,5}]` |
| A6 | Intro | Case 1 is the page's own example | confirmed | no cos example among Examples 1-7 (Ex1,3,5 e^x; Ex2,4,7 BesselJ0 / others) |
| A7 | Intro | Example 1 builds a quadratic through three nodes by recursion and plots f with each linear interpolant and the quadratic | confirmed | archive gr_82..121: P_{0,1}, P_{1,2}, P_{0,2}, P_{0,1,2}, R_{0,1,2} plotted with f |
| A8 | Intro | Examples 2-7 fill in Aitken's and Neville's tableaux at a single evaluation point | confirmed (Ex 6 partly) | example statements in Mod.html and lnk_3..8 text; Example 6 images gr_495-504 are missing from the snapshot, so its content was judged from its text only |
| A9 | Intro | Examples 3-5 plot successive interpolants up to degree 3, 4 and 2 | confirmed | gr_306 (Ex3: P0..P_{0,1,2,3}), gr_351 (Ex4: up to P_{0,1,2,3,4}), gr_405 (Ex5: up to P_{0,1,2}) |
| A10 | Intro | Case 2 carries Example 3's picture on to degree 5 | confirmed | frames 1-6 of nevillebb |
| A11 | Intro | Examples 1, 2, 4-7 and Theory/Proof explorations not animated | confirmed | only two cases on page |
| C1-1 | Case 1 heading | $P_{0,0}$ through $P_{0,4}$ for cos x | confirmed | 5 frames, titles P_{0,0}..P_{0,4} |
| C1-2 | Behavior | Neville builds degree ≤ n from two of degree ≤ n−1 with the stated formula | confirmed | same as D1 |
| C1-3 | Behavior | max error on [0,π]: 2.00 (j=0) | confirmed | mpmath 2.000000; script grid 1.99999990 |
| C1-4 | Behavior | 0.90 (j=1) | confirmed | 0.898805 at x=2.759 |
| C1-5 | Behavior | 1.66 (j=2) at x=π, where quadratic reaches −2.66 | confirmed | 1.656854 at x=π; $P_{0,2}(\pi)=-2.656854$ |
| C1-6 | Behavior | 8.1×10⁻³ (j=3) | confirmed | 0.00806767 at x=2.8587 |
| C1-7 | Behavior | adding a node does not always reduce the error | confirmed | sequence 2.00, 0.90, 1.66, 0.0081, 0.0081 |
| C1-8 | Behavior | cubic $P_{0,3}$ passes through (π,−1) because cos is odd about π/2 | confirmed | $P_{0,3}(\pi)=-1.0000000000000002$; cos(π/2+t)=−sin t is odd |
| C1-9 | Behavior | $P_{0,4}=P_{0,3}$; last two frames show the same curve | confirmed | mpmath max|P04−P03| = 9e-41; script 6.7e-16; frames 4/5 curves identical, title of frame 5 says "P_{0,4} = P_{0,3}, degree 3" |
| C1-10 | Link/embed | `nevilleaa.jl` / `nevilleaa.gif` | confirmed | correct script and GIF for cos case |
| C1-11 | Alt text | nodes 0..π, degree-0 constant to P_{0,4}, same cubic as P_{0,3} | confirmed | frames 1-5 |
| C2-1 | Case 2 heading | Example 3, $P_{0,0}$..$P_{0,5}$ for e^x at x̂=1.8 | confirmed | 6 frames, x̂ line at 1.8 |
| C2-2 | Behavior | nodes 1, 1.25, …, 2.25; each frame marks $P_{0,j}(1.8)$, top-row entry of Neville's tableau | confirmed | green diamond at (1.8, p_hat); `P[1,deg+1]` is the top row of the script's tableau |
| C2-3 | Behavior | values 2.718282, 5.188877, 5.960761, 6.048454, 6.049700, 6.049643 | confirmed | mpmath 2.71828183, 5.18887744, 5.96076058, 6.04845436, 6.04969972, 6.04964313; script identical |
| C2-4 | Behavior | match diagonal of Mathews' Neville tableau | confirmed | archive gr_298: 2.71828, 5.18888, 5.96076, 6.04845, 6.0497, 6.04964 (Mathews' 6 s.f.) |
| C2-5 | Behavior | approach $e^{1.8}=6.049647$ | confirmed | 6.04964746 |
| C2-6 | Behavior | error $e^{1.8}-P_{0,j}(1.8)$: 3.33, 0.861, 0.0889, 1.19e-3, −5.23e-5, 4.34e-6; falls in size each step; negative only at j=4 | confirmed | 3.33137, 0.86077, 0.0888869, 0.00119311, −5.22557e-5, 4.3387e-6 |
| C2-7 | Behavior | largest error on [1,2.25] falls each step, 6.77 (j=0) to 3.2e-5 (j=5) | confirmed | 6.769, 2.909, 0.7163, 0.09347, 0.005024, 3.182e-5 |
| C2-8 | Behavior | from j=4 on indistinguishable at plot scale; at j=3 parts only toward right edge | confirmed | max |P−e^x| on plot window: j=3 0.121 (visible near x>2.1 in frame 4), j=4 0.0078 (<0.5 px at 8.5 y-units / ~400 px); frames 5-6 show overlap |
| C2-9 | Behavior | legend carries values at x̂ | confirmed | legend: f(1.8)=6.049647, P_{0,j}(1.8) and difference, frames 1-6 |
| C2-10 | Link/embed | `nevillebb.jl` / `nevillebb.gif` | confirmed | |
| C2-11 | Alt text | nodes 1..2.25, degree 0 to 5, marker approaches e^1.8 = 6.049647, ends at 6.049643 | confirmed | frame 6 legend 6.049643 |

### 3. Implementation checks

### nevilleaa.jl
- **Method:** classical Neville tableau `P[i,j]` over nodes i..j, recurrence exactly as D1. For each degree the table is rebuilt on the first deg+1 nodes and `P[1,deg+1]` returned; that equals the top-row entry of the full table. Legitimate Neville, no substitution.
- **Numbers:** instrumented copy `review/nevilleaa_instr.jl` vs independent Lagrange evaluation in mpmath (`review/indep.py`, 40 digits):

| j | script max err (grid) | mpmath max err | script P(π) | mpmath P(π) |
|---|---|---|---|---|
| 0 | 1.99999990 | 2.000000 | 1.0 | 1 |
| 1 | 0.89880475 | 0.898805 | −0.17157288 | −0.171573 |
| 2 | 1.65585889 (grid) | 1.656854 at π | −2.65685425 | −2.65685 |
| 3 | 0.00806758 | 0.00806767 | −1.0000000000000002 | −1 |
| 4 | 0.00806758 | 0.00806767 | −1.0 | −1 |

  (j=2 grid max is below the exact value only because the 500-point grid's nearest point to π is not π itself.) Node residuals ≤ 1.1e-16; reproduces cubic $x^3-2x$ to 8.9e-15; max|P_{0,4}−P_{0,3}| = 6.7e-16.
- **Reference:** `cos` from Base; no numerical reference.
- **Picture:** frames 1-5 inspected (contact sheet, frame 3 at full size). Red dashed curve is `P_vals` from the same routine; black nodes are `xs[1:deg+1]`; ylims (−3, 1.4) contain all curves (quadratic min −2.882 at x=π+0.1, per comment l.53 and mpmath); no clamping or masking. Titles carry correct j, degree and node count; frame 5 title correctly states degree 3.

### nevillebb.jl
- **Method:** same Neville routine; also evaluated at x̂=1.8 for the marker.
- **Numbers:** instrumented copy `review/nevillebb_instr.jl` vs mpmath:

| j | script P_{0,j}(1.8) | mpmath | script err | mpmath err |
|---|---|---|---|---|
| 0 | 2.71828183 | 2.71828183 | 3.33137 | 3.33137 |
| 1 | 5.18887744 | 5.18887744 | 0.86077 | 0.86077 |
| 2 | 5.96076058 | 5.96076058 | 0.0888869 | 0.0888869 |
| 3 | 6.04845436 | 6.04845436 | 0.00119311 | 0.00119311 |
| 4 | 6.04969972 | 6.04969972 | −5.22557e-5 | −5.22557e-5 |
| 5 | 6.04964313 | 6.04964313 | 4.3387e-6 | 4.3387e-6 |

  Node residuals ≤ 8.9e-16. Plot-window ranges of each $P_{0,j}$ (2.56 to 9.97) lie inside ylims (2, 10.5).
- **Reference:** `exp` from Base; f(1.8)=6.04964746 matches mpmath.
- **Picture:** frames 1-6 inspected (contact sheet, frame 4 full size). Diamond sits at (1.8, P_{0,j}(1.8)); legend values match the table above to the printed precision; x̂ line at 1.8; no clamping. Legend in top-left does not cover any curve (curves there are near y≈2.6-3).

### Fidelity (archive)
Example 3 parameters (f=e^x, $x_i=1+i/4$, i=0..5, x̂=1.8) and its Neville diagonal are reproduced exactly. Case 1 is a declared departure (page's own cos example), and the non-animated Examples 1, 2, 4-7 are listed with accurate descriptions. No fidelity finding.

