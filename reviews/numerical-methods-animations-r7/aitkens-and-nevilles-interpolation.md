# Aitken's and Neville's Interpolation — animation review (round 7)

Page: `pages/numerical-methods/aitkens-and-nevilles-interpolation/`. Reported findings: **0 Error, 1 Misleading, 0 Minor**.

## Findings

### F1. Page match, Misleading: "The intermediate entries differ" hides that the two tableaux share their whole diagonal

- **Location:** `index.qmd` line 21, Description: "The intermediate entries differ, but both schemes end with the same interpolated value."
- **What is there now:** the sentence says the two schemes agree only at the end.
- **What is true:** each scheme computes the interpolant on $x_0,\dots,x_k$ for every $k$. By uniqueness these entries are identical, so Aitken's and Neville's tableaux agree on their **entire diagonal**, $P_{0,0},P_{0,1},\dots,P_{0,n-1}$, not only in the last entry. Only the off-diagonal entries, which are built on different node sets, differ.
- **Why it matters here:** the shared sequence is exactly what Case 2 animates and quotes (2.718282, 5.188877, 5.960761, 6.048454, 6.049700, 6.049643). A reader of line 21 would conclude that Aitken's scheme produces different intermediate approximations and that those values are particular to Neville's. Mathews' module makes the opposite point: "Aitken's and Neville's methods agree on the diagonal", and in Example 3 "the entries on the diagonal are the same".
- **How I know:** `/usr/bin/python3 review/check3.py review` builds both tableaux in Mathews' row/column layout at 50 digits and compares every entry beyond the data column.

  | Data | Entries compared | Agree | Differ |
  |---|---|---|---|
  | Example 3, $e^x$, $\hat x=1.8$ | 15 | the 5 diagonal entries $(r,r)$, $r=1..5$ | 10 |
  | Example 6, $J_0$, $\hat x=1.8$ | 15 | the 5 diagonal entries $(r,r)$, $r=1..5$ | 10 |

  Example 3 diagonal, both schemes: 2.718282, 5.188877, 5.960761, 6.048454, 6.0497, 6.049643.
  Example 3 last row, where they differ: Neville 5.71011, 6.04436, 6.04928, 6.04961, 6.04964; Aitken 7.05073, 6.2129, 6.06162, 6.04977, 6.04964. Both rows match Mathews' printed tableaux (images `gr_298`, `gr_310`).
- **Suggested correction:** replace the sentence with: "Entries built on different sets of nodes differ, but both schemes compute the interpolant on $x_0,\dots,x_k$ for every $k$, so they produce the same sequence $P_{0,0},P_{0,1},\dots,P_{0,n-1}$ (the diagonal of Mathews' two tableaux) and end with the same interpolated value."

---

- **Independent check:** confirmed with correction. In Mathews' lower-triangular layout the shared entries are the diagonal, which is the top row P_{0,j} in the page's notation; the first column (the data) is shared too. This needs the same node order. Only the strictly sub-diagonal entries in columns k ≥ 1 differ, and they differ generically, not always (for linear data they coincide). The sentence does not literally say "only"; the defect is the unqualified "intermediate entries differ".


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `nevilleaa.jl` | 0 | 6.2 | nevilleaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `nevillebb.jl` | 0 | 7.3 | nevillebb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

Verdicts come from the instrumented script copies, the independent computation (`review/indep.py`, `check2.py`, `check3.py`: 50 to 60 digit Vandermonde solves, not Neville), and the frames.

### Description

| # | Claim (page's words) | Verdict | Evidence |
|---|---|---|---|
| D1 | Neville evaluates "the unique polynomial of degree at most $n-1$" through the data "without first converting to expanded polynomial coefficients" | Confirmed | Code evaluates pointwise; no coefficients formed |
| D2 | $P_{i,i}=y_i$; $P_{i,j}=\frac{(x-x_i)P_{i+1,j}-(x-x_j)P_{i,j-1}}{x_j-x_i}$ | Confirmed | All 21 entries $P_{i,j}$ for Case 2 equal the direct interpolant on $x_i..x_j$ (0 failures, tolerance $10^{-40}$) |
| D3 | Final value is $P_{0,n-1}(x)$ | Confirmed | Script returns `P[1, deg+1]`; equals direct solve |
| D4 | Aitken at stage $k$ combines the interpolant on $x_0..x_{k-1}$ with the one on $x_0..x_{k-2},x_j$ | Confirmed | Implemented exactly so; every entry equals direct interpolant on $x_0..x_{k-1},x_j$ (0 failures); reproduces Mathews' Aitken tableau |
| D5 | "every entry in a column shares the same leading nodes" | Confirmed | Follows from D4 |
| D6 | Neville "combines interpolants on neighbouring runs of consecutive nodes" | Confirmed | D2 |
| D7 | "The intermediate entries differ" | **Wrong as stated (F1)** | 5 of 15 entries agree, the whole diagonal |
| D8 | "both schemes end with the same interpolated value" | Confirmed | 6.049643 both |
| D9 | "The animations below use Neville's scheme" | Confirmed | Both scripts |

### Animations introduction

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| I1 | Each frame adds one node and shows $P_{0,j}$ through the first $j+1$ nodes | Confirmed | `xs[1:deg+1]`; frames |
| I2 | Case 1: $\cos x$, 5 nodes $0,\pi/4,\pi/2,3\pi/4,\pi$, $j=0..4$ | Confirmed | `nevilleaa.jl` 30-31, 45; 5 frames |
| I3 | Case 2: $e^x$, 6 nodes $1+i/4$, $j=0..5$ | Confirmed | `nevillebb.jl` 30-31, 45; 6 frames |
| I4 | Source scripts linked under each case | Confirmed | Lines 35, 43 |
| I5 | No archived animation GIF; module has only static examples | Confirmed | 0 multi-frame GIFs among the module's images; no Neville or Aitken entry under `a2001/Animations` |
| I6 | Case 2 animates Example 3: $e^x$, $x_i=1+i/4$, $i=0..5$, $\hat x=1.8$ | Confirmed | Archive `gr_295` |
| I7 | Case 1 is the page's own example | Confirmed | Archive functions: $e^x$ (Examples 1, 2, 3, 5), $J_0$ (4, 6, 7); no cosine |
| I8 | Case 1 shows adding a node can increase error, and symmetric nodes can make $P_{0,4}=P_{0,3}$ | Confirmed | C3, C8 |
| I9 | Other examples and what they plot (inventory sentences) | Out of scope by the brief; consistent where seen | Example 3, 4, 5 plots reach degree 3, 4, 2; Example 1 plot seen. Example 6 solution images `gr_499`-`gr_504` are absent from the archive, so its tableau was read from Example 7's identical problem only |

### Case 1

| # | Claim | Verdict | Independent value |
|---|---|---|---|
| C1 | Heading: $P_{0,0}$ through $P_{0,4}$ for $\cos x$ | Confirmed | Frame titles |
| C2 | Degree $n$ built from two of degree $n-1$, with the formula | Confirmed | D2 (here $n$ is a degree, in the Description a point count; each statement is true as written) |
| C3 | Largest error on $[0,\pi]$: 2.00 at $j=0$ | Confirmed | 2.0 at $x=\pi$ |
| C4 | 0.90 at $j=1$ | Confirmed | 0.89880 at $x=2.7594$ |
| C5 | 1.66 at $j=2$, at $x=\pi$ | Confirmed | 1.65685 at $x=\pi$ |
| C6 | Quadratic reaches $-2.66$ at $\pi$ | Confirmed | $-2.65685$ |
| C7 | $8.1\times10^{-3}$ at $j=3$ | Confirmed | $8.0677\times10^{-3}$ |
| C8 | $P_{0,3}(\pi)=-1$; $P_{0,4}=P_{0,3}$ because $\cos$ is odd about $\pi/2$ | Confirmed | $P_{0,3}(\pi)+1=5\times10^{-61}$; degree-4 coefficient $-1\times10^{-61}$; the antisymmetric data force an odd interpolant about $\pi/2$ |
| C9 | Last two frames show the same curve | Confirmed | Script curves differ by at most $6.7\times10^{-16}$; frames 4 and 5 differ only in title, legend and the fifth node marker (pixel diff, 113 px outside title/legend, all in the marker's box) |
| C10 | Alt text: nodes, degree-0 to five-node $P_{0,4}$, same cubic as $P_{0,3}$ | Confirmed | As above |
| C11 | Link and embed | Confirmed | `nevilleaa.jl`, `nevilleaa.gif`; GIF byte-identical on regeneration |

### Case 2

| # | Claim | Verdict | Independent value |
|---|---|---|---|
| E1 | Heading: Mathews' Example 3, $P_{0,0}$ to $P_{0,5}$, $\hat x=1.8$ | Confirmed | `gr_295`; frames |
| E2 | Nodes $1,1.25,\dots,2.25$ | Confirmed | Script line 31 |
| E3 | Each frame marks $P_{0,j}(1.8)$, the top-row entry | Confirmed | Line 47 returns `P[1, deg+1]` |
| E4 | Values 2.718282, 5.188877, 5.960761, 6.048454, 6.049700, 6.049643 | Confirmed | 2.718281828, 5.188877441, 5.960760585, 6.048454357, 6.04969972, 6.049643126 |
| E5 | These match the diagonal of Mathews' tableau | Confirmed | `gr_298`, `gr_303`: 2.71828, 5.18888, 5.96076, 6.04845, 6.0497, 6.04964; final 6.049643 |
| E6 | $e^{1.8}=6.049647$ | Confirmed | 6.04964746 |
| E7 | Errors 3.33, 0.861, 0.0889, $1.19\times10^{-3}$, $-5.23\times10^{-5}$, $4.34\times10^{-6}$ | Confirmed | 3.33137, 0.86077, 0.0888869, 0.00119311, $-5.22557\times10^{-5}$, $4.3387\times10^{-6}$; Mathews' `gr_303` agrees |
| E8 | Error falls in size at each step; negative only at $j=4$ | Confirmed | Ratios 0.258, 0.103, 0.0134, 0.0438, 0.083 |
| E9 | Largest error on $[1,2.25]$ falls at each step, 6.77 to $3.2\times10^{-5}$ | Confirmed | 6.7695, 2.9091, 0.7163, 0.09347, 0.005024, $3.182\times10^{-5}$ (at $x=2.1667$) |
| E10 | From $j=4$ on, indistinguishable at plot scale | Confirmed | About 49.75 px per $y$ unit; largest gap in window at $j=4$ is 0.0078, or 0.39 px |
| E11 | At $j=3$ they part only toward the right edge | Confirmed | Gap under 1 px up to $x=2.0$ (0.88 px), then 1.9 px at 2.1, 4.7 px at 2.25, 6.0 px at 2.3; frame 4 |
| E12 | Legend carries the values at $\hat x$ | Confirmed | Frames 1-6 show the values in E4 and E7 |
| E13 | Alt text: nodes, degree 0 to 5, marker at 1.8, approaches 6.049647, ends at 6.049643 | Confirmed | As above |
| E14 | Link and embed | Confirmed | `nevillebb.jl`, `nevillebb.gif`; GIF byte-identical on regeneration |

---

### 3. Implementation checks

Scratch copies were instrumented to dump each frame's plotted curve and title (`review/aa/`, `review/bb/`). Instrumented runs reproduce the committed GIFs byte for byte (md5 `e3cf6917...` and `9777ad0f...`).

### `nevilleaa.jl`

- **Method:** true Neville recursion over consecutive runs, evaluated pointwise at 500 grid points on the first `deg+1` nodes.
- **Numbers:** plotted curves against an independent Vandermonde solve at 50 digits:

  | $j$ | max difference over 500 points | Script max error on $[0,\pi]$ grid | Independent max error |
  |---|---|---|---|
  | 0 | 0 | 2 | 2.0 |
  | 1 | $4.1\times10^{-16}$ | 0.8988 | 0.89880 |
  | 2 | $7.4\times10^{-16}$ | 1.6559 (grid misses $x=\pi$) | 1.65685 |
  | 3 | $6.8\times10^{-16}$ | 0.0080676 | 0.0080677 |
  | 4 | $4.7\times10^{-16}$ | 0.0080676 | 0.0080677 |

- **Reference values:** the blue curve is `cos` itself. Interpolants reproduce their nodes (residual at most $6\times10^{-61}$ in the independent solve).
- **Picture:** curves, nodes and titles carry the right index; the frame 5 title correctly says degree 3. `ylims=(-3.0, 1.4)` contains every curve (window range at most $[-2.8821, 1.0373]$), so nothing is clipped. Comment line 53 ("≈ -2.88 at x = π + 0.1") is right: $-2.88209$.

### `nevillebb.jl`

- **Method:** the same Neville recursion, on Mathews' Example 3 data.
- **Numbers:**

  | $j$ | Script $P_{0,j}(1.8)$ | Independent | Script error | Independent error | Curve max difference |
  |---|---|---|---|---|---|
  | 0 | 2.718281828459 | 2.718281828 | 3.33136564 | 3.33137 | $1.5\times10^{-16}$ |
  | 1 | 5.188877441268 | 5.188877441 | 0.86077002 | 0.86077 | $3.0\times10^{-15}$ |
  | 2 | 5.960760584502 | 5.960760585 | 0.08888688 | 0.0888869 | $1.1\times10^{-14}$ |
  | 3 | 6.048454357059 | 6.048454357 | 0.00119311 | 0.00119311 | $2.0\times10^{-14}$ |
  | 4 | 6.049699720074 | 6.04969972 | $-5.22557\times10^{-5}$ | $-5.22557\times10^{-5}$ | $1.4\times10^{-14}$ |
  | 5 | 6.049643125714 | 6.049643126 | $4.33870\times10^{-6}$ | $4.3387\times10^{-6}$ | $4.1\times10^{-15}$ |

- **Reference values:** $e^{1.8}=6.04964746$ by mpmath; the script's `exp` agrees. Mathews' printed tableau and error list match.
- **Picture:** the diamond is at $(1.8,P_{0,j}(1.8))$, the line at $\hat x$, and legend values are the computed ones with the right index. `ylims=(2.0, 10.5)` contains every curve (window range at most $[2.5639, 9.9741]$).

### Could not determine

Nothing that affects a page claim. Example 6's solution images (`gr_499`-`gr_504`) are missing from the archive; the page's only statement about Example 6 is in the out-of-scope inventory paragraph.

