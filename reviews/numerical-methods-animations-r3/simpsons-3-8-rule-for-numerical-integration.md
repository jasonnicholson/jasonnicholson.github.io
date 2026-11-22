# Simpson's 3/8 Rule for Numerical Integration — animation review (round 3)

Page: `pages/numerical-methods/simpsons-3-8-rule-for-numerical-integration/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page was confirmed against an independent computation or the frames. Details are in the ledger and implementation checks below.

Observations that are not findings, because they mislead no one:
- The in-frame label uses `round(approx; digits=6)`, which drops trailing zeros. So some frames show five decimals, for example "2.01517" (n=72), "2.01572" (n=108) and "2.01581" (n=120), where the legacy GIF shows "2.015170" and "2.015810". The values are correct to the digits shown.
- The intro says "Each frame recomputes the approximation". Frame 1 shows only f, but the alt text says so explicitly ("after an opening frame showing only f").
- "Each animation below" introduces a single animation. That is the template phrasing from the page conventions.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `simpson38aa.jl` | 0 | 8.9 | simpson38aa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `simpson38aa.gif` | 24 | byte-identical | simpson38aa |

### Page references

- Scripts linked: `simpson38aa.jl`
- GIFs embedded: 1
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | Description | "applies cubic interpolation on blocks of three subintervals" | Instrumented copy fits the cubic through 4 points on each panel and integrates it exactly. The sum over panels equals `simpson38_sum(n)` to within 3e-15 for every n in the sequence. | confirmed |
| 2 | Description | $h=(b-a)/n$, n divisible by 3; weights 1, 3 (i not ≡ 0 mod 3), 2 (interior i ≡ 0 mod 3), times 3h/8 | Matches the code at lines 25–30. Degree-of-precision test with the script's formula (n=6 on [0,2]): x^0..x^3 exact (2, 2, 2.6667, 4); x^4 gives 6.4074 against 6.4 exact; x^5 gives 10.7037 against 10.6667. Degree 3, as the 3/8 rule should be. | confirmed |
| 3 | Description | "For smooth f (C^4 on [a,b]) ... $S^{3/8}_n - I = O(h^4)$" | Standard result: composite error $-(b-a)h^4 f^{(4)}(\xi)/80$. | confirmed |
| 4 | Description | "higher-order refinement of trapezoidal geometry using piecewise cubic panels" | Qualitative framing. The piecewise-cubic part is confirmed (#1). | confirmed (qualitative) |
| 5 | Intro | Interval $[0,2]$, $y=e^{-x}\sin(8x^{2/3})+1$ | Script lines 8–9: `f(x)=exp(-x)*sin(8*x^(2/3))+1`, `a,b=0,2`. | confirmed |
| 6 | Intro | "Each frame recomputes the approximation across the full interval with a denser partition where n remains a multiple of 3" | `n_seq` = 3,6,...,36,42,...,72,81,...,108,120: all multiples of 3 and strictly increasing. Each frame spans the full [0,2]. Frame 1 has n=0 (f only), as the alt text states. | confirmed |
| 7 | Intro | "Red dots mark the sample points $x_i$" | Lines 71–73: scatter at $a+i\,dx$, i=0..n, in red. Frames 2 and 24 show n+1 dots (4 and 121). | confirmed |
| 8 | Intro | "vertical red lines mark the panel boundaries $x_{3k}$" | Lines 58–61: lines at i=0:3:n, from 0 to f(x). Frame 2 shows lines at x=0 and x=2 only (n=3), and frame 24 shows 41 lines. | confirmed |
| 9 | Intro | "Julia source scripts ... linked under each case" | `[Julia source](simpson38aa.jl)` is present, and the file exists. | confirmed |
| 10 | Case 1 heading | Composite 3/8 rule, $f(x)=e^{-x}\sin(8x^{2/3})+1$ on $[0,2]$ | Same as #5. The method is the composite 3/8 rule (#1, #2). | confirmed |
| 11 | Behavior | "Piecewise cubic panels over triplets of subintervals are rebuilt at increasing density" | Same as #1 and #6. The frames show this. | confirmed |
| 12 | Behavior | "Every approximation shown lies below the true integral" | Independent errors S−I are negative for all 23 n (from −0.2258 to −0.000469). | confirmed |
| 13 | Behavior | $\int_0^2 f\,dx \approx 2.016280$ | mpmath gives 2.0162797196170963 by two routes (split quad, and substitution x=t^3). It rounds to 2.016280. | confirmed |
| 14 | Behavior | "The error grows from 4 to 7 sample points" | \|e\|: n=3 gives 0.132066; n=6 gives 0.225809. | confirmed |
| 15 | Behavior | "then shrinks at every later frame" | The successive ratios \|e_prev\|/\|e\| are all >1 from n=9 onward (2.54, 2.25, 1.79, ..., 1.19). | confirmed |
| 16 | Behavior | "the last frame (121 sample points) gives 2.01581, about 0.00047 low" | Script: 2.015810410863725. Independent: 2.015810411. Error −0.000469309. Frame 24 reads "Sample Points = 121, Approximation = 2.01581". | confirmed |
| 17 | Behavior | "$f'$ unbounded at $x=0$ ($f'(x)\approx \tfrac{16}{3}x^{-1/3}$ near 0)" | The ratio f'(x)/((16/3)x^{-1/3}) is 0.99431 at 1e-3, 0.999997 at 1e-6 and 0.9999999975 at 1e-9. | confirmed |
| 18 | Behavior | "textbook error order ... does not hold for this integrand" | Measured ratios are about 3.2 rather than 16 (#20). | confirmed |
| 19 | Behavior | "measured error shrinks like $O(h^{5/3})$" | The error ratio under halving converges to $2^{5/3}$: 3.3963 (30→60), 3.2238, 3.1890, 3.1801, 3.1771, 3.1759, 3.17535, 3.17507 (3840→7680). $2^{5/3}=3.17480$. | confirmed |
| 20 | Behavior | "halving h divides it by about 3.22 (from 60 to 120 subintervals), tending to $2^{5/3}\approx 3.17$, instead of 16" | e(60)/e(120) = 3.2238. The limit is 3.1748. | confirmed |
| 21 | Alt text | "after an opening frame showing only f, each frame shows the sample points as red dots, the panel boundaries as vertical red lines, the piecewise cubic panels and the global approximation" | Frame 1 shows only the magenta f. Frames 2–24 show dots, boundary lines, pink-filled cubic panels and the "Approximation =" label. | confirmed |
| 22 | Wiring | Link `simpson38aa.jl`, embed `simpson38aa.gif` belong to this case | Both files exist in the page folder. The GIF is the script's byte-identical output, and the script's parameters match the heading. | confirmed |
| 23 | Counts (implicit) | One case | One script and one GIF with 24 frames = 1 opening frame + 23 values of n. | confirmed |
| 24 | Legacy note | "reconstructs Mathews' archived animation `Simpsonaa.gif`" | The legacy GIF `a2001/Animations/Quadrature/Simpson38/Simpsonaa.gif` has the same function (labelled in-frame as $y=e^{-x}\sin(8x^{2/3})+1$), the same interval, the same pink panels, red dots and red divider lines. | confirmed |
| 25 | Legacy note | "same integrand and interval and ends at the same 121-point approximation, 2.015810" | Legacy last frame: "Sample Points = 121, Approximation = 2.015810". Ours: 2.0158104. | confirmed |
| 26 | Legacy note | "steps through a different sequence of intermediate n" | Legacy sample-point counts are 4, 4, 7, 10, 13, 16, 19, 25, 31, 37, 43, 49, 55, 61, 67, 73, 79, 85, 91, 106, 121, after 3 title frames. Ours are 4, 7, 10, ..., 37, 43, 49, 55, 61, 67, 73, 82, 91, 100, 109, 121. The sequences differ. | confirmed |

### 3. Implementation checks: `simpson38aa.jl`

**It is the method it claims to be.** `simpson38_sum` (lines 25–30) is the composite Simpson 3/8 rule. The ends get weight 1. Interior indices with i mod 3 ≠ 0 get weight 3, and interior indices with i mod 3 = 0 (3:3:n−3) get weight 2, all times 3h/8. For n=3 the weight-2 sum is empty, which is handled. The degree-of-precision test gives exact results through x^3 and a failure at x^4, so the rule has degree 3. Nothing is a neighbouring method.

**The numbers are right.** I ran the script's routine in the instrumented copy `instr.jl` and an independent mpmath implementation in `indep.py`. Selected values, script against independent:

| n | script | independent | S − I |
|---|---|---|---|
| 3 | 1.8842140994188474 | 1.884214099 | −0.132066 |
| 6 | 1.790470481304736 | 1.790470481 | −0.225809 |
| 9 | 1.9272339711446245 | 1.927233971 | −0.0890457 |
| 30 | 2.0111411216067023 | 2.011141122 | −0.0051386 |
| 60 | 2.0147667415686947 | 2.014766742 | −0.00151298 |
| 72 | 2.015170132082283 | 2.015170132 | −0.00110959 |
| 120 | 2.015810410863725 | 2.015810411 | −0.000469309 |

All 23 values agree to the 10 digits printed. The legacy GIF's printed values agree as well: 1.884214, 1.790470, 1.927234, 1.994094, 2.008397, 2.012595, 2.014059, 2.014767, 2.015170 and 2.015810.

**Its reference values are right.** The script draws no exact curve and no exact integral; it plots f itself. The page's "true" integral 2.016280 is confirmed: mpmath gives 2.01627971961709632788727 by two independent quadratures, one with the singular endpoint split and one with the substitution x=t^3.

**The picture shows what was computed.**
- Each panel's cubic is built from the 4 points x_{3k}..x_{3k+3} with a Vandermonde solve and drawn with fill to 0.
- The exact integral of the drawn cubics equals the annotated approximation to ≤3e-15 for every n, so the shaded area is the reported number.
- Divider lines are drawn at x_{3k} up to f(x_{3k}), and the dots at all x_i.
- The cubic values range over [0.2011, 1.9395] and f peaks at 1.9198, so everything lies inside ylims (0, 2.1). No clamping happens and the fill never crosses below 0.
- xlims (−0.03, 2.03) leave the endpoints visible.
- The annotation reports n+1 sample points and the rule's value for that n.
- I viewed frames 1, 2 and 24 and the contact sheet (frames at n=6, 12, 18, 24, 30, 36, 48, 60, 72, 90 and 108). Each frame's labels match the computed values.
- The title "Simpson's 3/8 Rule / Numerical Quadrature" does not name f. The page names it, so this is not a mismatch.

**Fidelity to legacy.** The archive has one 3/8-rule animation, `Simpsonaa.gif`, and the page reproduces it: same function, interval and display elements, and the same final 121-point value. The different intermediate sequence is disclosed in the page's legacy note. The module page's "Example 1" is a worked example, not an animation, and the page's Worked Example section is a placeholder that is out of scope. No archive animation is dropped.

