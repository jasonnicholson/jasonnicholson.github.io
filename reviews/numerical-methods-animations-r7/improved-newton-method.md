# Improved Newton Method — animation review (round 7)

Page: `pages/numerical-methods/improved-newton-method/`. Reported findings: **1 Error, 1 Misleading, 1 Minor**.

## Findings

### F1. Page match, **Error**: Case 5 gives the Method C candidates the wrong first index

- **Location:** `index.qmd` line 81: "($x_{1,1} \approx -1.41$ here) and $m = 2$ lands farther out ($x_{1,2} \approx -4.23$, with larger $|f|$)".
- **What is there:** the two trial points computed from the starting value $x_0 = 1.4$ are called $x_{1,1}$ and $x_{1,2}$.
- **What is true:** the page defines the notation at line 17 as $x_{n,m} = x_n - m\,f(x_n)/f'(x_n)$, so the first index is the base iterate. The points quoted are based at $x_0$ and are $x_{0,1}$ and $x_{0,2}$. Under the page's definition, $x_{1,1}$ and $x_{1,2}$ are different numbers with the opposite sign.

| Symbol | Value by the page's definition | Page says |
|---|---|---|
| $x_{0,1}$ | $-1.41362$ | (not named) |
| $x_{0,2}$ | $-4.22724$ | (not named) |
| $x_{1,1}$ | $+1.45013$ | $\approx -1.41$ |
| $x_{1,2}$ | $+4.31388$ | $\approx -4.23$ |

- **How I know:** `/usr/bin/python3 review/more.py`, section "Page notation", 60-digit arithmetic. The same values appear in the Method C trace in `indep.py` (step 0 rejects $-4.22724$; step 1 rejects $4.31388$).
- **Correction:** write $x_{0,1} \approx -1.41$ and $x_{0,2} \approx -4.23$. The numbers and the argument are otherwise right.

- **Independent check:** confirmed.

### F2. Page match, **Misleading**: Case 4 credits "the improved methods" with an advantage that needs $m$

- **Location:** `index.qmd` line 67: "This illustrates the core advantage of the improved methods: knowing $m$ unlocks quadratic convergence regardless of root order."
- **What is there:** knowing $m$ is presented as the core advantage of the improved methods as a group.
- **What is true:** only Method A uses $m$. Method B's formula has no $m$ and converges quadratically at both roots without it (computed $e_{n+1}/e_n^2 \to -1/6$ at the double root and $-1/9$ at the triple root). Method C, by the page's own line 17, "does not need $m$". In the module, needing $m$ is the stated *limitation* of Method A ("Method A has the disadvantage that the order m of the root must be known a priori"), and it is the reason Mathews introduces Method C. The sentence reverses that emphasis.
- **How I know:** `more.py` ("B on Ex1, Ex2"), `abc.py`, and the text of `NewtonImprovedMod.html` under "Limitations of Methods A and B".
- **Correction:** for example, "This illustrates Method A's advantage: when the multiplicity $m$ is known, the scaled step restores quadratic convergence at a root of any order. Methods B and C avoid needing $m$."

- **Independent check:** confirmed.

### F3. Page match, **Minor**: "quadratically if the root is simple" is false for the page's own simple-root function

- **Location:** `index.qmd` line 12: "it does so quadratically if the root is simple".
- **What is there:** an unqualified quadratic rate for every simple root of a smooth $f$.
- **What is true:** the rate is *at least* quadratic. It is higher when $f''$ vanishes at the root, and that is the case for Case 5's $f = \arctan x$ at $x = 0$. The Newton map there is $N(x) = -\tfrac{2}{3}x^3 + \tfrac{2}{15}x^5 + \dots$, so convergence inside the basin is cubic. By the module's Definition 1, which requires a positive constant $A$, this sequence does not have order 2.
- **How I know:** `sym.py` gives the series. `more.py`, Newton on arctan from $x_0 = 0.5$: $e_{n+1}/e_n^3 = -0.63648, -0.66582, -0.66667, -0.66667$, while $e_{n+1}/e_n^2 \to 0$ ($-0.318, 0.053, -2.2\times10^{-4}, 1.7\times10^{-11}$).
- **Correction:** "at least quadratically if the root is simple".

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `newtonimpaa.jl` | 0 | 6.6 | newtonimpaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtonimpbb.jl` | 0 | 6.5 | newtonimpbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtonimpcc.jl` | 0 | 7.4 | newtonimpcc.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtonimpdd.jl` | 0 | 7.2 | newtonimpdd.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtonimpee.jl` | 0 | 6.9 | newtonimpee.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `newtonimpaa.gif` | 11 | byte-identical | newtonimpaa |
| `newtonimpbb.gif` | 4 | byte-identical | newtonimpbb |
| `newtonimpcc.gif` | 13 | byte-identical | newtonimpcc |
| `newtonimpdd.gif` | 4 | byte-identical | newtonimpdd |
| `newtonimpee.gif` | 7 | byte-identical | newtonimpee |

### Page references

- Scripts linked: `newtonimpaa.jl`, `newtonimpbb.jl`, `newtonimpcc.jl`, `newtonimpdd.jl`, `newtonimpee.jl`
- GIFs embedded: 5
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

Verdicts come from my own computation, the script parameters and the frames.

### Description

| # | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|
| D1 | Newton formula $x_{n+1} = x_n - f(x_n)/f'(x_n)$ | Matches `aa`, `cc`, `ee` code | Confirmed |
| D2 | Converges "quadratically if the root is simple" | Cubic for arctan | **Wrong as stated (F3)** |
| D3 | "only linearly if the root has multiplicity $m \ge 2$" | Ratios to 0.5000 and 0.6668; `sym.py` slopes 1/2 and 2/3 | Confirmed |
| D4 | Mathews compares three improvements | Module: Methods A, B, C | Confirmed |
| D5 | Method A formula | Module image gr_37; `bb`, `dd` code | Confirmed |
| D6 | Method B is Newton on $u = f/f'$, with the stated formula | Module gr_51, gr_56. Formula and direct Newton on $u$ agree to 6 printed digits at every iterate | Confirmed |
| D7 | $u$ has a simple root where $f$ has a multiple one | Module text; quadratic B convergence at orders 2, 3, 4 | Confirmed |
| D8 | Method C does not need $m$; trial points $x_n - m f/f'$ from $m = 1$; continue while $|f|$ decreases; take the last such point | Module gr_76 and the algorithm in gr_115 (`While |y2| < |y1|`). My implementation of that algorithm picks $m = 2, 3, 4$ at orders 2, 3, 4 | Confirmed |
| D9 | Started close enough, A and B converge quadratically to a multiple root | A: ratio to 1/6, 1/9. B: to -1/6, -1/9 | Confirmed |
| D10 | Animations show standard Newton and Method A; Case 5 also discusses B and C | Scripts and Case 5 text | Confirmed |

### Animations introduction

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| I1 | Cases 1–4 have a multiple root at $x = 1$ | `sympy.factor` | Confirmed |
| I2 | Case 5 uses $\arctan x$, simple root at 0 | Code; $f'(0) = 1$ | Confirmed |
| I3 | Standard Newton (1, 3, 5): slanted line is the tangent at $x_n$ | Plotted-series dump: slope equals $f'(x_n)$, relative error at most $2.7\times10^{-10}$ | Confirmed |
| I4 | Method A (2, 4): line of slope $f'(x_n)/m$ | Same dump: relative error at most $9.7\times10^{-12}$ | Confirmed |
| I5 | Slanted line runs $(x_n, f(x_n))$ to $(x_{n+1}, 0)$ | All 66 plotted segments match 50-digit endpoints within $3\times10^{-12}$ | Confirmed |
| I6 | Vertical line runs $(x_{n+1}, 0)$ to $(x_{n+1}, f(x_{n+1}))$ | Same | Confirmed |
| I7 | Standard Newton degrades to linear at multiple roots; A restores quadratic by scaling the step by $m$ | Computed sequences; `sym.py` error maps | Confirmed |
| I8 | Julia sources are linked under each case | Lines in `index.qmd`; manifest | Confirmed |
| I9 | Cases 1–4 follow Mathews' Examples 1 and 2 | gr_124–126, gr_165–167: same $f$, $p_0 = 1.3$, $p = 1$ | Confirmed |
| I10 | Example 3 compares the methods at a quadruple root | gr_191–193; $(x-1)^4(x+2)$ by sympy | Confirmed |
| I11 | Method B and C iterations and the caveats are not animated | Five scripts, none runs B or C | Confirmed |
| I12 | Example 1's caveat plots rounding noise in expanded $f$ near the double root | lnk_4 text; gr_155 and gr_159 show noise at $10^{-16}$ | Confirmed |
| I13 | Example 2's caveat runs A with $m = 2$ at the triple root, converging only linearly | gr_186–190. Error map slope 1/3; my $e_n$ = 0.10588, 0.036087, 0.012124 match Mathews' $p_1$–$p_3$ | Confirmed |

### Case 1

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| C1.1 | Standard Newton, $f = x^3 - 3x + 2$, $x_0 = 1.3$ | `newtonimpaa.jl` lines 11, 15, 27 | Confirmed |
| C1.2 | $f = (x-1)^2(x+2)$, double root at 1 | sympy | Confirmed |
| C1.3 | $f'(x^*) = 0$ at a multiple root | $f' = 3(x-1)(x+1)$ | Confirmed |
| C1.4 | "Each step only halves the error" | Ratios 0.5217, 0.5121, …, 0.50005 | Confirmed |
| C1.5 | Creeps slowly over many steps | After 10 steps $e = 3.21\times10^{-4}$ | Confirmed |
| C1.6 | Alt text: slow linear convergence from 1.3 | Frames and sequence | Confirmed |
| C1.7 | Link and embed are this case | `newtonimpaa.jl`, `newtonimpaa.gif` | Confirmed |

### Case 2

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| C2.1 | Method A, $m = 2$, same $f$ and $x_0$ | `newtonimpbb.jl` lines 14–20, 31 | Confirmed |
| C2.2 | Formula as printed | Code line 31 | Confirmed |
| C2.3 | Restores quadratic convergence | $e$ = 0.01304, $2.817\times10^{-5}$, $1.323\times10^{-10}$; $e_{n+1}/e_n^2 \to 1/6$ | Confirmed |
| C2.4 | Rapid compared with Case 1; same function and start | Error $1.3\times10^{-10}$ in 3 steps against $3.2\times10^{-4}$ in 10 | Confirmed |
| C2.5 | Alt text: "in just a few steps" | 3 steps | Confirmed |
| C2.6 | Link and embed are this case | `newtonimpbb.*` | Confirmed |

### Case 3

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| C3.1 | Standard Newton, quartic, $x_0 = 1.3$ | `newtonimpcc.jl` lines 11, 15, 27 | Confirmed |
| C3.2 | $f = (x-1)^3(x+2)$, triple root | sympy | Confirmed |
| C3.3 | Asymptotic constant $(m-1)/m$ | Module gr_35; `sym.py` | Confirmed |
| C3.4 | For a triple root 2/3; each iterate reduces the error by 1/3 | Ratios 0.6765, …, 0.66680 | Confirmed |
| C3.5 | Slower than the double-root case | 2/3 against 1/2 | Confirmed |
| C3.6 | Alt text and wiring | `newtonimpcc.*` | Confirmed |

### Case 4

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| C4.1 | Method A, $m = 3$, same quartic, $x_0 = 1.3$ | `newtonimpdd.jl` lines 14–20, 31 | Confirmed |
| C4.2 | Restores quadratic convergence | $e_{n+1}/e_n^2$ = 0.0980, 0.1107, 0.1111, limit 1/9 | Confirmed |
| C4.3 | Iterates 1.3, 1.008824, 1.000009 | 1.0088235, 1.0000086; legend labels agree | Confirmed |
| C4.4 | $x_3$ within $10^{-11}$, labelled 1.0 | $e_3 = 8.25\times10^{-12}$; frame legend "1.0" | Confirmed |
| C4.5 | "core advantage of the improved methods: knowing $m$" | Only A uses $m$ | **Misleading (F2)** |
| C4.6 | Alt text and wiring | `newtonimpdd.*` | Confirmed |

### Case 5

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| C5.1 | Standard Newton, $\arctan x$, $x_0 = 1.4$ | `newtonimpee.jl` lines 11, 15, 27 | Confirmed |
| C5.2 | Simple root at 0 | $f'(0) = 1$ | Confirmed |
| C5.3 | Converges only when $|x_0| < x_c \approx 1.3917$ | $x_c = 1.39174520027$ solves $(1+x^2)\arctan x = 2x$. 1.39174 converges, 1.39175 diverges | Confirmed |
| C5.4 | 1.4 is just outside | Yes | Confirmed |
| C5.5 | Each tangent overshoots further | $|x_n|$ = 1.4, 1.4136, 1.4501, 1.5506, 1.8471, 2.8936, 8.7103 | Confirmed |
| C5.6 | Iterates escape toward $\pm\infty$ | Alternating signs, $x_7 = -103.25$, $x_8 = 16540.6$ | Confirmed |
| C5.7 | Method A with $m = 1$ is standard Newton | Identity | Confirmed |
| C5.8 | $u = (1+x^2)\arctan x$ | sympy | Confirmed |
| C5.9 | $u$ increasing and convex for $x > 0$ | $u' = 1 + 2x\arctan x > 0$; $u'' = 2\arctan x + 2x/(1+x^2) > 0$ | Confirmed |
| C5.10 | B iterates decrease monotonically | 1.4, 0.631573, 0.171166, 0.00624689, $3.25005\times10^{-7}$, $4.58\times10^{-20}$ | Confirmed |
| C5.11 | Values 0.6316, 0.1712, 0.00625, $3.25\times10^{-7}$ | Same | Confirmed |
| C5.12 | The $m = 1$ step always crosses 0 | $\arctan x > x/(1+x^2)$ for $x > 0$, since the difference is 0 at 0 and has derivative $2x^2/(1+x^2)^2$ | Confirmed |
| C5.13 | Values $\approx -1.41$ and $\approx -4.23$, with larger $|f|$ at the second | $-1.41362$, $-4.22724$; $|f|$ = 0.955118, 1.33851 | Confirmed |
| C5.14 | These are $x_{1,1}$ and $x_{1,2}$ | They are $x_{0,1}$ and $x_{0,2}$ | **Wrong (F1)** |
| C5.15 | C keeps $m = 1$ at every step and diverges as Newton does | With $s = (1+x^2)\arctan x$, the crossing gives $|x - 2s| = 2|s| - |x| > |s| - |x| = |x - s|$, and $|\arctan|$ is increasing in $|x|$. Trace over 7 steps agrees | Confirmed |
| C5.16 | A and C do not repair this failure | Computed | Confirmed |
| C5.17 | Alt text: divergent oscillation from 1.4 | Sequence and frames | Confirmed |
| C5.18 | Link and embed are this case | `newtonimpee.*` | Confirmed |

---

### 3. Implementation checks

Common to all scripts: the committed GIFs are byte-identical to the regenerated ones (manifest). I checked the last frame's plotted series directly by dumping them from a scratch copy (`series/`), and checked the marker position in every committed frame by pixel fit (`geom.py`).

| Script | Method run | Iterates vs 60-digit | Frames | Marker fit (max px residual x, y) | Plotted segments vs 50-digit |
|---|---|---|---|---|---|
| `newtonimpaa.jl` | Standard Newton | max diff $8.7\times10^{-14}$ | 11 | 0.12, 0.12 | 20 of 20, within $8.7\times10^{-14}$ |
| `newtonimpbb.jl` | Method A, $m = 2$ | $1.4\times10^{-16}$ | 4 | 0.01, 0.20 | 6 of 6, within $1.5\times10^{-16}$ |
| `newtonimpcc.jl` | Standard Newton | $3.0\times10^{-12}$ | 13 | 0.12, 0.16 | 24 of 24, within $3.0\times10^{-12}$ |
| `newtonimpdd.jl` | Method A, $m = 3$ | $5.4\times10^{-17}$ | 4 | 0.03, 0.02 | 6 of 6, within $9.9\times10^{-17}$ |
| `newtonimpee.jl` | Standard Newton | $2.1\times10^{-13}$ | 7 | 0.14, 0.08 (6 markers) | 10 of 10, within $2.9\times10^{-14}$ |

### Script and independent values side by side

| Case | $n$ | Script $x_n$ | Independent (60-digit) |
|---|---|---|---|
| 1 | 1 | 1.1565217391304348 | 1.1565217391304 |
| 1 | 10 | 1.0003213616712867 | 1.0003213616712 |
| 2 | 1 | 1.0130434782608697 | 1.0130434782609 |
| 2 | 3 | 1.000000000132272 | 1.0000000001323 |
| 3 | 1 | 1.2029411764705882 | 1.2029411764706 |
| 3 | 12 | 1.0024225476442639 | 1.0024225476413 |
| 4 | 1 | 1.0088235294117647 | 1.0088235294118 |
| 4 | 3 | 1.0000000000082498 | 1.0000000000082 |
| 5 | 1 | -1.4136186488037423 | -1.413618649 |
| 5 | 6 | 8.710325846983183 | 8.710325847 |

### The four points

- **It is the method it claims to be.** `aa`, `cc`, `ee` run $x - f/f'$; `bb`, `dd` run $x - m f/f'$ with the correct $m$. Headings, titles and code agree. No script implements Method B or C, and the page says so. I implemented both independently to check the page's statements about them.
- **The numbers are right.** See the tables above. The script derivatives equal the symbolic derivatives (`sym.py` differences are 0). Exact error maps: Newton at the double root $e(2e+3)/(3(e+2))$; A at $m=2$: $e^2/(3(e+2))$; Newton at the triple root $3e(e+2)/(4e+9)$; A at $m=3$: $e^2/(4e+9)$.
- **Its reference values are right.** The root $x = 1$ is exact by factorization, and $x = 0$ for arctan is exact. The critical value is $x_c = 1.39174520027$.
- **The picture shows what was computed.** All drawn segments and markers match the independent values. Titles name the function in the code. Legend labels carry the right index and value in every frame.

### Script comments checked

| Comment | Result |
|---|---|
| `bb` line 13: expanded $f(1 + 1.3\times10^{-10}) = 0.0$, true $5.1\times10^{-20}$ | $0.0$; $5.07\times10^{-20}$ |
| `bb` line 19: $x_3$ within $1.4\times10^{-10}$; 4th step lands on 1 exactly, then 0/0 | $1.32\times10^{-10}$; step 4 gives 1.0; step 5 gives NaN |
| `dd` line 13: expanded $f(1 + 6.4\times10^{-7}) = -8.9\times10^{-16}$, true $+7.9\times10^{-19}$ | $-8.88\times10^{-16}$; $7.86\times10^{-19}$ |
| `dd` line 19: $x_3$ within $10^{-11}$; 4th step lands on 1, then 0/0 | $8.25\times10^{-12}$; step 4 gives 1.0; step 5 gives NaN |
| `ee` line 3: 1.4 just above $\approx 1.3917$ | Confirmed |

### Display devices considered and accepted

- **Case 5, last frame.** The step from $x_5 = -2.8936$ to $x_6 = 8.71$ is not drawn because $x_6$ is outside the window, and no marker is plotted. The legend reports "x₆ = 8.71 (out of range)", which is the true value, so the viewer's conclusion (divergence) is correct. Not a finding.
- **Cases 1–4, late steps.** Late segments are drawn (confirmed in the series dump) but are shorter than a pixel or sit under the marker at this axis scale. In `geom.py` their colour-hit fraction falls to 0 for that reason. The legend carries the iterate values. Not a finding.
- **Label "1.0"** for $x_3$ in Cases 2 and 4 is rounding to 6 decimals, and Case 4's text says so. Not a finding.
- **Expanded $f$ in Cases 1 and 3.** Their last errors are $3.2\times10^{-4}$ and $2.4\times10^{-3}$, far from the cancellation region. The largest effect on an iterate is $3\times10^{-12}$. Not a finding.

### Legacy archive

Consulted: `NewtonImprovedMod.html`, Links 1–6, and the formula, table and graph images gr_35, 37, 51, 56, 75–77, 110–115, 124–126, 145, 155, 159, 165–167, 179, 185–193.

- Cases 1–4 use Mathews' functions and $p_0 = 1.3$.
- Mathews' Method A $p_3 = 1.0000000001359235$ in Example 1 differs from the script's $1.000000000132272$. The script is right (exact $e_3 = 1.32272\times10^{-10}$). Mathews evaluates the expanded $f$, which is the rounding noise his own caveat describes. A correct departure, not a finding.
- Mathews' Method B values in Example 1 ($p_1 = 0.98765$, $p_3 = 0.99999999989$) agree with my computation.
- Case 5 (arctan) is not one of the module's three examples, and the page does not claim it is.
- The omission of Example 3, Methods B and C and the caveats is stated on the page, so it is not a silent drop.

### Could not determine

Nothing on the page was left undetermined. I did not review the separate Newton's Method animations in `a2001/Animations/RootFinding/NewtonMethod/`, because the brief names only `newtonimproved/` for this topic and the page makes no claim about them.

