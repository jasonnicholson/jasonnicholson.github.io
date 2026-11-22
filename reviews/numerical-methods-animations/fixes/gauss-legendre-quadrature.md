# Fix record: gauss-legendre-quadrature

Scratch folder (all evidence, re-runnable):
`/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/work/gauss-legendre-quadrature/fix/`
(below written as `$FIX`). Scripts are in `$FIX/scripts/`, outputs in `$FIX/*.out`, frames in `$FIX/before/` (committed GIF) and `$FIX/legacy/` (Mathews' GIF).

- `order.py`: run as `cd $FIX/scripts && /usr/bin/python3 -I order.py`, output `$FIX/order.out`. Independent of the repo script. Gauss-Legendre nodes are found in mpmath at 40 digits by Newton's method on $P_n$ (three-term recurrence), seeded from scipy `roots_legendre`. Weights are $2/((1-t^2)P_n'(t)^2)$. The rule is applied on $[0,2]$ as $\sum w_i f(1+t_i)$.
- `script_values.jl`: run as `cd $FIX/scripts && julia script_values.jl`, output `$FIX/script_values.out`. It is lines 1-61 of the repo script (plotting removed) plus prints of `true_int`, every frame's `approx` and its label text, and `frame_states`.

## Findings

### F1 — Misleading — fixed

- **Reproduced:** `order.py`.
  - Reference $I = 2.0162797196170963278872744219151$. Two mpmath methods agree: substitution $x=t^3$ then tanh-sinh, and tanh-sinh on 80 panels. They differ by $-4.6\times10^{-41}$.
  - Errors $E(n)=I_n-I$ under doubling, with ratio $E(n/2)/E(n)$ and $p=\log_2$ of the ratio:

    | n | E(n) | ratio | p |
    |---|---|---|---|
    | 8 | $1.632\times10^{-3}$ | | |
    | 16 | $1.770\times10^{-4}$ | 9.223 | 3.205 |
    | 32 | $1.835\times10^{-5}$ | 9.645 | 3.270 |
    | 64 | $1.864\times10^{-6}$ | 9.841 | 3.299 |
    | 128 | $1.873\times10^{-7}$ | 9.954 | 3.315 |
    | 256 | $1.870\times10^{-8}$ | 10.015 | 3.324 |
    | 512 | $1.861\times10^{-9}$ | 10.047 | 3.329 |
    | 1024 | $1.850\times10^{-10}$ | 10.063 | 3.331 |

    For comparison, $2^{10/3}=10.0794$ and $10/3=3.333$.
  - Least-squares slope of $\log E$ against $\log n$ over the animation frames: $-3.214$ for $n=6..64$ and $-3.285$ for $n=16..64$.
  - Smooth control $1+e^{-x}\sin 8x$ on $[0,2]$, 40-digit sums: $E=-3.2\times10^{-3}$ (n=6), $3.5\times10^{-5}$ (8), $3.3\times10^{-10}$ (12), $1.8\times10^{-13}$ (14), $4.2\times10^{-17}$ (16), $-4.9\times10^{-25}$ (20). The reference is checked against the closed form (difference 0). In double precision (numpy `leggauss`) the error at n=16 is $-4.4\times10^{-16}$, which is roundoff.
  - The finding holds. "Stabilizes rapidly" hides algebraic convergence with order tending to $10/3$, and the error is still $1.86\times10^{-6}$ at the last frame. The checker's correction also holds: frame value 2.016282 against $I=2.016280$ differ in the 7th significant digit.
- **Change:** text only, `index.qmd` line 35 (Behavior) and line 39 (alt text). The animation is right, so per D1 and D7 the script and GIF are unchanged.
  - Line 35: "As $n$ grows, the node distribution becomes denser and the weighted estimate stabilizes rapidly." → four sentences:
    - where the estimate goes, how it moves, and the last frame's value and error;
    - the D1 cause sentence, verbatim;
    - the measured algebraic rate, with the doubling factor;
    - the smooth-integrand contrast.

    The first sentence of the Behavior paragraph is unchanged.
  - Line 39 (alt text): "…recomputed as order increases, and the integral estimate converges" → "…recomputed as the number of nodes increases from 2 to 64, and the integral estimate settles toward 2.016280, reaching 2.016282 at 64 nodes".
- **Check:** every number was recomputed (see ledger). `git diff` shows only the lines named here and under F2.

### F2 — Minor — fixed

- **Reproduced:** `script_values.jl` prints `nframes = 24` and the states `:intro1, :intro2, :intro3, 2, 3, 4, 5, 6, 8, 10, 12, 14, 16, 18, 20, 24, 28, 32, 36, 40, 44, 48, 56, 64`.
  - I viewed frames 1-4 of the committed GIF at full size (`$FIX/before/f1_2_3_4.png`). Frames 1 and 3 show only the curve and the title. Frame 2 adds "True / Numerical Quadrature / I = 2.01628". Frame 4 shows "Sample Points = 2".
  - The page has one animation, so "Each animation below" (plural) is wrong, and "Each frame increases the quadrature order" fails for frames 1-3.
  - The finding holds.
- **Change:** `index.qmd` lines 28-29. Per D7 the text was changed, not the animation.
  - "Each animation below shows …" → "The animation below shows …".
  - "Each frame increases the quadrature order $n$ and recomputes nodes and weights across the full interval." → "It opens with three frames of the integrand alone, the second also showing the reference value $I\approx2.01628$. Each later frame uses more nodes, $n=2,3,4,5,6,8,10,\dots,20,24,28,\dots,48,56,64$, and recomputes nodes and weights across the full interval."
- **Check:** the sequence was compared element by element with `frame_states` (ledger). Frame 2's label is "I = 2.01628".

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd:28 | "The animation below" (singular) | `ls` of the page folder: one GIF, `gausslegendreaa.gif`, one embed | yes |
| index.qmd:29 | "opens with three frames of the integrand alone" | `script_values.jl` → states 1-3 are `:intro1, :intro2, :intro3`. Frames 1-3 viewed: curve and title only, no bars or nodes | yes |
| index.qmd:29 | "the second also showing the reference value $I\approx2.01628$" | frame 2 reads "I = 2.01628". `script_values.jl` → `true_int = 2.0162797061281728`, label `I = 2.01628`. Against `order.py` $I=2.01627971962$, the label's error is $1.35\times10^{-8}$, so it is correct to the digits shown | yes |
| index.qmd:29 | "Each later frame uses more nodes, $n=2,3,4,5,6,8,10,\dots,20,24,28,\dots,48,56,64$" | `script_values.jl` states 4-24 = 2,3,4,5,6,8,10,12,14,16,18,20,24,28,32,36,40,44,48,56,64. These are strictly increasing: steps of 1 to 6, then 2 to 20, then 4 to 48, then 56 and 64. Frames 4 and 24 read "Sample Points = 2" and "= 64" | yes |
| index.qmd:29 | "recomputes nodes and weights across the full interval" (kept) | script line 79 calls `gauss_legendre_sum(n)` on $[a,b]=[0,2]$ every frame (round-1 ledger row 9) | yes |
| index.qmd:35 | "the nodes become denser" | round-1 ledger row 12: minimum bar width falls from 1.0 (n=2) to $2.18\times10^{-3}$ (n=64). n increases in every frame (row above) | yes |
| index.qmd:35 | "settles toward $I\approx2.016280$" | `order.py` → I = 2.0162797196170963…; rounds to 2.016280 | yes |
| index.qmd:35 | "from $n=6$ on it decreases in every frame" | `order.py` → "frames n>=6: I_n strictly decreasing: True all E>0: True". It also holds for every integer $n=6..64$. Before that the signs of $E$ for n=2..5 are −,+,+,−, so the claim is not made earlier | yes |
| index.qmd:35 | "the last frame ($n=64$) gives 2.016282" | `order.py` → $I_{64}$ = 2.01628158386076. `script_values.jl` → `64 2.0162815838607595 label: Approximation = 2.016282`. `$FIX/before/frame_024.png` reads "Sample Points = 64, Approximation = 2.016282" | yes |
| index.qmd:35 | "still about $1.9\times10^{-6}$ high" | `order.py` → $E(64)=+1.864\times10^{-6}$ | yes |
| index.qmd:35 | "The $x^{2/3}$ term makes $f'$ unbounded at $x=0$ ($f'(x)\approx\tfrac{16}{3}x^{-1/3}$ near $0$)" | `order.py` (sympy) → `16/(3*x**(1/3)) + O(1)`. Also $f'(10^{-6})=533.3318$ against $533.3333$ | yes |
| index.qmd:35 | "so the textbook error order, which assumes smooth $f$, does not hold for this integrand" | The textbook Gauss-Legendre remainder involves $f^{(2n)}(\xi)$ and needs $f\in C^{2n}$. Mathews' error theorem for n=2..5 is stated with $f^{(4)},\dots,f^{(10)}$. Here $f\notin C^1[0,2]$ (row above). The smooth control converges to $4\times10^{-17}$ by n=16, but this integrand only reaches $1.8\times10^{-4}$ there | yes |
| index.qmd:35 | "shrinks only algebraically, like $O(n^{-10/3})$" | `order.py` doubling table: p = 3.205, 3.270, 3.299, 3.315, 3.324, 3.329, 3.331 (n=16…1024), rising toward 10/3 = 3.333. LS slope over the frames $n=16..64$ is $-3.285$. This matches the known $n^{-2(1+\alpha)}$ rate for an endpoint $x^{\alpha}$ term with $\alpha=2/3$; that rate is used only as a cross-check, since the page states the measured rate | yes |
| index.qmd:35 | "doubling $n$ divides it by about 9.8 (from 32 to 64 nodes)" | `order.py` in-animation pairs: 32→64 ratio 9.8415. Both n=32 and n=64 are frames | yes |
| index.qmd:35 | "tending to $2^{10/3}\approx 10.08$" | `order.py` → 2^(10/3) = 10.0794. Ratios 9.22, 9.65, 9.84, 9.95, 10.015, 10.047, 10.063 (n=16…1024) rise steadily toward it | yes |
| index.qmd:35 | "the smooth integrand $1+e^{-x}\sin 8x$ on $[0,2]$ already has error $4\times10^{-17}$ at $n=16$" | `order.py` smooth control, 40-digit sums → n=16: 4.166e-17. Reference 2.13962776020024565… agrees with the closed form $2+\operatorname{Im}\frac{1-e^{(-1+8i)2}}{1-8i}$ (difference 0) | yes |
| index.qmd:39 (alt) | "recomputed as the number of nodes increases from 2 to 64" | `script_values.jl` frame states: first n = 2, last n = 64, strictly increasing | yes |
| index.qmd:39 (alt) | "settles toward 2.016280, reaching 2.016282 at 64 nodes" | as for line 35: I rounds to 2.016280, $I_{64}$ label 2.016282, decreasing for every frame from n=6 | yes |

Unchanged and still consistent: the case heading "Increasing-Order Gauss-Legendre Rule" (n strictly increasing), the GIF's own title "Gauss-Legendre Rule For Numerical Quadrature", and the first Behavior sentence (round-1 ledger row 11: bar area equals $w_i f(x_i)$ to $10^{-16}$).

## Scripts and GIFs

- No script was changed and no GIF was regenerated, because the animation is correct.
  - `script_values.jl` reproduces every labelled value. Each of the 21 values agrees with `order.py` to all printed digits (e.g. n=40: 2.016288522137825 vs 2.01628852213783), and the 6-digit labels match.
  - One display detail, not changed: n=18 is labelled "2.0164" because `round` drops the trailing zeros of 2.016400. The number is not false.
- I extracted the committed GIF's frames with `giftools.jl` into `$FIX/before/` (24 frames). I checked the contact sheet and frames 1, 2, 3, 4 and 24 at full size.
  - The bars run between midpoints of adjacent nodes, and the red verticals sit at the nodes.
  - The labels match the computed n and $I_n$.
  - The curve fits inside the window.
- `git status --short -- pages/numerical-methods/gauss-legendre-quadrature` →
  ` M pages/numerical-methods/gauss-legendre-quadrature/index.qmd` (only).

## Legacy archive

Consulted.

- **Module.** `n2003/GaussianQuadMod.html` gives:
  - the n = 2…5 rules and their error terms (which involve $f^{(2n)}$);
  - the shifted rule for $[a,b]$;
  - a link to `a2001/Animations/Quadrature/GaussLegendre/GaussLegendreaa.gif`.

  Example 4's solution (`Links/GaussianQuadMod_lnk_6.html`) says only "In all four cases, Gauss-Legendre quadrature is more accurate."
- **Mathews' animation.** Frames are in `$FIX/legacy/`. It uses the same $y=e^{-x}\sin(8x^{2/3})+1$ on $[0,2]$ and the same titles ("Gauss-Legendre Rule / Numerical Quadrature").
  - It opens with two title-only frames and has no "True … I =" frame.
  - It then shows n = 2, 4, 6, …, 40 (even n only).
  - Its labels agree to 6 digits with Gauss-Legendre values computed by `legacy_values.py` (run as `/usr/bin/python3 -I $FIX/scripts/legacy_values.py`, output `$FIX/legacy_values.out`; numpy `leggauss`, all even n from 2 to 40). The labels compared are those I read on the contact sheet and on frames 2, 4, 6 and 24: 1.154628 (n=2), 2.106664 (4), 2.019465 (6), 2.017086 (10), 2.016553 (14), 2.016400 (18), 2.016342 (22), 2.016316 (26), 2.016302 (30), 2.016295 (34), 2.016290 (38).
  - The one difference is n=40, where Mathews shows 2.016288 and the correctly rounded value is 2.016289 ($I_{40}$ = 2.0162885221, `order.py` and `script_values.jl`). This is probably truncation on his side. Our frame shows 2.016289, which is right.
  - Mathews' bars differ from ours. His bar widths are the weights, laid end to end, and his bar heights are $f(x_i)$. The site's bars end at midpoints between nodes and have height $w_if(x_i)/\text{width}$. Both give bar area $w_i f(x_i)$, and the page does not describe the geometry beyond "weighted sample contributions", so nothing was changed.
- The archive makes no convergence-rate claim for this integrand. Its error-theorem images `GaussianQuadMod_gr_88.gif` to `_gr_91.gif`, which I viewed, read $\frac{1}{135}f^{(4)}(c)$, $\frac{1}{15750}f^{(6)}(c)$, $\frac{1}{3472875}f^{(8)}(c)$ and $\frac{1}{1237732650}f^{(10)}(c)$ for n = 2…5 on $[-1,1]$. These error terms need $f^{(2n)}$, which this $f$ does not have at $x=0$. The page now says so through the D1 sentence. Per D1 the archive's integrand is kept.

## Notes

- **D1 adaptation.** Gauss-Legendre has no $h$, so the D1 rate sentence is written in $n$: "doubling $n$ divides it by about R (from n₁ to 2n₁ nodes), tending to $2^{10/3}$". The order was measured in the same way as on the Trapezoidal page, with mpmath at 40 digits, a doubling sequence, the in-animation pairs, an LS slope over the frames and a smooth control.
  - The Description has no convergence-order statement for Gauss-Legendre. It states only "exact for polynomials up to degree $2n-1$", which is a statement about polynomials and needs no smoothness label.
  - I did not add a textbook order there, since that would be new content. So the cause sentence's "the textbook error order" refers to the standard result, not to a sentence on this page. Jason may want a one-line Description statement such as "for $f\in C^{2n}[a,b]$ the error is $\frac{(b-a)^{2n+1}(n!)^4}{(2n+1)[(2n)!]^3}f^{(2n)}(\xi)$". It was not added. Its constant was checked against Mathews' four constants: `python3 -c` with exact fractions, $2^{2n+1}(n!)^4/((2n+1)[(2n)!]^3)$ → 1/135, 1/15750, 1/3472875, 1/1237732650 for n = 2…5.
- I added one contrast sentence (the smooth integrand at n=16), following the round-1 suggested fix. It shows what "rapid" would mean for Gauss-Legendre.
- **Line 41, unchanged.** It reads "This page follows the archived module equation and compares $I_n$ … against a high-resolution numerical reference". The archive's shifted rule matches the page's formula. The "reference" is a 120001-point trapezoid value with error $1.35\times10^{-8}$, and it appears only in frame 2. The sentence names no finding and is not false, so it was left alone.
- **Template sentence, unchanged.** "Julia source scripts that generated these animations are linked under each case" is the shared page template. It is plural, but F2 did not name it, so it was left alone.
- **Convention gaps, not touched.** The page lacks the "(Planned)" stubs that other pages have, and its explanatory paragraph sits after the embed. Neither is a finding.
- Nothing outside the page folder was touched, apart from this record.

## Resolution check (independent checker, not shown this record)

The fix changes only `index.qmd`, in 4 lines. `gausslegendreaa.jl` and `gausslegendreaa.gif` are unchanged from HEAD (`git diff --quiet HEAD` on both).

The reference values come from `check/num.py`. It uses mpmath at 40 digits. Gauss-Legendre nodes and weights are computed by Newton iteration on $P_n$. $I$ is computed twice: by direct `mp.quad`, and after the substitution $x=u^3$, which removes the singularity. Both give 2.0162797196170963278872744…

### Original findings

### F1 — resolved
- Evidence: The sentence "the weighted estimate stabilizes rapidly" is gone. Its replacement says the estimate settles toward 2.016280, decreases monotonically from $n=6$, and is 2.016282 at $n=64$, about $1.9\times10^{-6}$ high. It says the convergence is only algebraic, $O(n^{-10/3})$, because $f'$ is unbounded at 0, and it gives the smooth-integrand contrast. Every number checks; see the ledger. My errors $I_n-I$ are: n=6 +3.19e-3, n=8 +1.63e-3, …, n=32 +1.835e-5, n=56 +2.90e-6, n=64 +1.864e-6. The values decrease strictly at every step from n=6 to n=64, and all of them are above $I$. The error ratio from 16 to 32 is 9.65 and from 32 to 64 is 9.84. These rise toward $2^{10/3}=10.079$, which is consistent with the $n^{-2\alpha-2}$ law for an endpoint $x^{\alpha}$ term with $\alpha=2/3$. The alt text now also states the settling value and the $n=64$ value.

### F2 — resolved
- Evidence: "Each animation below" now reads "The animation below". "Each frame increases the quadrature order" is replaced by an accurate account. The animation opens with three frames of the integrand alone, and the second shows the reference value $I\approx2.01628$. Later frames use $n=2,3,4,5,6,8,10,\dots,20,24,28,\dots,48,56,64$. That list matches `n_seq` in the script: the evens from 10 to 20, then steps of 4 to 48, then 56 and 64. The frame extraction gives 24 frames. I viewed them myself: frames 1 and 3 show only the curve, and frame 2 shows "True / Numerical Quadrature / I = 2.01628". The finding's side remark, that the true value never appears next to an approximation, was not a requested change. The page no longer implies otherwise.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd:28 | "The animation below" (singular) | One GIF is embedded on the page | correct |
| index.qmd:29 | "opens with three frames of the integrand alone, the second also showing … $I\approx2.01628$" | Frames 1–3 viewed. Frame 2 text is "I = 2.01628". The script's trapezoidal reference rounds to 2.016280, and Julia drops the trailing zero | correct |
| index.qmd:29 | $n=2,3,4,5,6,8,10,\dots,20,24,28,\dots,48,56,64$ | Matches `n_seq` (21 values). Frame count 3 + 21 = 24 | correct |
| index.qmd:35 | "settles toward $I\approx2.016280$" | mpmath $I$ = 2.01627971962 | correct |
| index.qmd:35 | "from $n=6$ on it decreases in every frame" | Strictly decreasing 6→8→…→64. It is not monotone before 6: 5→6 rises | correct |
| index.qmd:35 | "last frame ($n=64$) gives 2.016282" | Double-precision GL gives 2.01628158 → 2.016282. Frame 24 reads "Approximation = 2.016282" | correct |
| index.qmd:35 | "still about $1.9\times10^{-6}$ high" | Error +1.864e-6 | correct |
| index.qmd:35 | "$f'$ unbounded at $x=0$ ($f'(x)\approx\tfrac{16}{3}x^{-1/3}$ near 0)" | $f'=e^{-x}[\cos(8x^{2/3})\tfrac{16}{3}x^{-1/3}-\sin(8x^{2/3})]$. Its leading term as $x\to0$ is $\tfrac{16}{3}x^{-1/3}$ | correct |
| index.qmd:35 | "textbook error order, which assumes smooth $f$, does not hold" | The standard GL remainder needs $f^{(2n)}$ on $[a,b]$, and that fails here | correct |
| index.qmd:35 | "$O(n^{-10/3})$" | Measured local orders are 3.27 (16→32) and 3.30 (32→64), rising toward 3.333 | correct |
| index.qmd:35 | "doubling $n$ divides it by about 9.8 (from 32 to 64 nodes)" | 1.835e-5 / 1.864e-6 = 9.84 | correct |
| index.qmd:35 | "tending to $2^{10/3}\approx10.08$" | $2^{10/3}=10.0794$. The ratios 9.65 and 9.84 rise toward it | correct |
| index.qmd:35 | "smooth integrand $1+e^{-x}\sin 8x$ on $[0,2]$ already has error $4\times10^{-17}$ at $n=16$" | Exact-arithmetic (40-digit) GL error is +4.17e-17. In double precision the computed error is roundoff-dominated (−8.9e-16 here). The statement is about the rule and is true | correct |
| index.qmd:39 alt | "number of nodes increases from 2 to 64 … settles toward 2.016280, reaching 2.016282 at 64 nodes" | As above | correct |

### New problems
None. This rests on the following:
- Every changed sentence and number was recomputed independently in the ledger above.
- The GIF and script are untouched, and the regenerated GIF is byte-identical to the committed one.
- I viewed the full-size frames 2 and 24 and the contact sheet. The approximation values in the frames (2.332149, 2.014623, 2.017912, 2.016729, 2.016457, 2.016365, 2.016308, 2.016292, 2.016286, 2.016283, 2.016282) match my double-precision GL sums.

One nuance, not a problem: the $4\times10^{-17}$ figure is below double-precision roundoff, so a reader reproducing it in Float64 would see about 1e-15. The sentence makes a true statement about the rule's error.

### Reproducibility and conventions
- I copied `gausslegendreaa.jl` to `check/run/` and ran it with plain `julia`. Its output `gausslegendreaa.gif` is byte-identical to the committed GIF (`cmp`). The GIF has 24 frames.
- Conventions are kept:
  - Description comes before Animations.
  - There is one case, with a `[Julia source](gausslegendreaa.jl)` link and a GIF embed.
  - The alt text is descriptive.
  - The page has no code blocks.
- The diff for this page touches only `pages/numerical-methods/gauss-legendre-quadrature/index.qmd`. The working tree has other modified files, but they belong to other pages' fixes in the same batch. The untracked file `reviews/numerical-methods-animations/fixes/gauss-legendre-quadrature.md` is the fixer's report, and it is outside the site pages.

**Final status:** committed
