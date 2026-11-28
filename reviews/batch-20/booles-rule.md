# Boole's Rule — batch 20 review, round 1 (overview mode)

SUMMARY: 0 Error, 0 Misleading, 1 Minor

Page: `pages/numerical-methods/booles-rule/index.qmd`, light-pass batch 20, overview page (extend). Evidence folder: /tmp/claude-1001/-home-jason--claude-spares-spare-0ogoFf/f6c51b48-3d53-4b4d-8872-653429a6389a/scratchpad/work/review-20/booles-rule. My scratch files are in its `reviewer/` folder: `chk.py`, `mathews_rem.png` and `labels.png`.

I did not run MATLAB or quarto, did not modify the repository, and ran no state-changing git command. I did consult the Mathews archive: BooleRuleMod.html, including the corollary formula images gr_40 to gr_50.

## 1. Findings

**F1 (Minor, Page text, page match)**
- **Location:** index.qmd line 34: "on the first frame ($n=4$) the single quartic misses the peak …"
- **What is there now:** The GIF's first frame (frame_001.png) shows only $f$, with no partition. The Animations introduction (line 51) says so too: "After an opening frame showing only $f$". The $n=4$ partition, with "Sample Points = 5, Approximation = 1.553155", is frame_002.png.
- **What is true instead:** $n=4$ is the second frame, or the first quadrature frame.
- **How I know:** I viewed frame_001.png and frame_002.png. In boolesaa.jl the frames loop over `vcat(0, n_seq)`, so the first frame is $n=0$.
- **Suggested correction:** "on the first quadrature frame ($n=4$)" or "on the second frame ($n=4$)".

The rest of the sentence is confirmed (see ledger entries L18 to L20).

## 2. Claim ledger (diff `+` lines; the only change outside the Description is the heading id)

| # | Claim (page's words) | Verdict | Evidence |
|---|---|---|---|
| L1 | "Boole's rule approximates a definite integral … from values of $f$ at equally spaced points" | confirmed | Definition; the script uses `dx=(b-a)/n`. |
| L2 | $h=(b-a)/n$, $x_i=a+ih$, $f_i=f(x_i)$, $i=0..n$; the quartic through the five nodes on each $[x_{4k},x_{4k+4}]$ | confirmed | Matches `boole_sum` and the plotting loop (5-node `poly_coeffs` per block). |
| L3 | Composite formula $B_n=\frac{2h}{45}\sum(7,32,12,32,7)$ (unchanged display) | confirmed | Identical to the script's `boole_sum`. Exactness check below. |
| L4 | "Each quartic spans four subintervals, so $n$ must be a multiple of 4" | confirmed | Every value in `n_seq` is a multiple of 4. |
| L5 | "$B_n$ converge to the integral for any continuous $f$" | confirmed | All weights are positive and the composite sum is a positive combination of Riemann sums, with weights summing to $b-a$. |
| L6 | The error formula needs $f\in C^6[a,b]$ | confirmed | Mathews' corollary (gr_41) states $f\in C^6[a,b]$. |
| L7 | Exact for every polynomial of degree 5, though each panel uses a quartic | confirmed | Single-panel error for $x^d$ on $[0,1]$: 0 for $d=0..5$; $-3.72\times10^{-4}$ for $d=6$. |
| L8 | The degree-5 error cancels by symmetry about the panel midpoint; the first missed term involves $f^{(6)}$ | confirmed | Standard one-line intuition; consistent with L7. |
| L9 | Mathews' result: $\int f - B_n = -\frac{2(b-a)f^{(6)}(c)}{945}h^6$, $a<c<b$ | confirmed | Matches Mathews gr_40, gr_43, gr_45 exactly (viewed in reviewer/mathews_rem.png). For $x^6$ on $[0,1]$ with $n=4$: predicted $-2\cdot720/945\cdot(1/4)^6=-3.7202\times10^{-4}$, computed $-3.72024\times10^{-4}$. It also agrees with the per-panel term $-8h^7f^{(6)}/945$ on the Newton-Cotes page. |
| L10 | Error is $O(h^6)$ | confirmed | Follows from L9; matches Mathews gr_47. |
| L11 | The highest order of the four closed Newton-Cotes rules on this site | confirmed | newton-cotes-integration/index.qmd line 81 gives orders $h^2, h^4, h^4, h^6$ for the four rules. |
| L12 | Halving $h$ "typically divides it by about 64" | confirmed | $2^6=64$ for $C^6$ $f$; "typically" covers the case $f^{(6)}\to0$. Mathews' remark (gr_50) gives $(1/2)^6$. |
| L13 | Closed rules with ≥7 nodes per panel are exact to higher degree (7-node to degree 7) | confirmed | Even-$M$ symmetry: $M=6$ gives degree of precision 7; the 6-node rule ($M=5$) has degree 5, so "seven or more" is the right threshold. This sentence was carried over unchanged from the old text. |
| L14 | The animation does not show $O(h^6)$ because the integrand is not in $C^6[0,2]$ | confirmed | $f'$ is unbounded at 0 (L16), and the measured ratios are about 3.17 (L17). |
| L15 | Link "[Case 1](#case-1)" plus "shows what happens when that hypothesis fails" | confirmed | Heading id `{#case-1}` added at line 55; Case 1 is this integrand. |
| L16 | $f(x)=1+e^{-x}\sin(8x^{2/3})$ has $f'$ unbounded at $x=0$ | confirmed | $f'$ contains $\tfrac{16}{3}x^{-1/3}e^{-x}\cos(8x^{2/3})$, which tends to $\infty$; the function matches the script's `f`. |
| L17 | Error shrinks like $h^{5/3}$; the last two table rows give ratios 3.10 and 3.17, close to $2^{5/3}\approx3.17$, not 64 | confirmed | Computed ratios: 32/16 → 3.1007, 64/32 → 3.1725 (then 3.1819 and 3.1794 at 128 and 256). $2^{5/3}=3.1748$. The $x^{2/3}$ endpoint singularity gives $O(h^{1+2/3})$. |
| L18 | For $n$ from 48 to 120, Boole's error is about 0.85 times Simpson's at the same $n$ | confirmed | Computed ratio $(B_n-I)/(S_n-I)$ ranges from 0.8413 ($n=48$) to 0.8530 ($n=120$). |
| L19 | At $n=4$ the quartic misses the peak $f\approx1.92$ near $x\approx0.08$ | confirmed (but see F1 on "first frame") | Peak at $x=0.080384$, $f=1.919756$. Frame_002 shows the quartic dipping to about 0.12 there. |
| L20 | Error at $n=4$ is $-0.463$, more than twice the Trapezoidal Rule's $-0.214$ on the same five points | confirmed | $B_4-I=-0.463125$, $T_4-I=-0.214208$; ratio 2.16. |
| L21 | Table row n=4: $h=1/2$, $B_n=1.553155$, error $-0.4631$ | confirmed | Computed 1.5531547, −0.463125; frame_002 label shows 1.553155. |
| L22 | Row n=8: 1.963413, $-0.05287$, ratio 8.76 | confirmed | Computed 1.9634127, −0.052867, 8.7602; frame_003 shows 1.963413. |
| L23 | Row n=16: 2.007328, $-0.008952$, ratio 5.91 | confirmed | Computed 2.0073277, −0.00895199, 5.9056; frame_005 shows 2.007328. |
| L24 | Row n=32: 2.013393, $-0.002887$, ratio 3.10 | confirmed | Computed 2.0133926, −0.00288708, 3.1007; frame_009 shows 2.013393. |
| L25 | Row n=64: 2.015370, $-0.0009100$, ratio 3.17 | confirmed | Computed 2.0153697, −0.000910033, 3.1725; frame_017 shows 2.01537 (trailing zero dropped by `round`). |
| L26 | "The rows are frames of Case 1, each halving $h$"; $I\approx2.016280$; ratio = previous error / this error | confirmed | 4, 8, 16, 32 and 64 are all in `n_seq`. $I=2.016279719617$ by mpmath, computed two ways (substitution $x=t^3$, and split-interval quad); the two agree to 30 digits. The ratio definition matches my computation. |
| L27 | Boole's rule is the degree-4 Newton-Cotes member after trapezoidal, Simpson and Simpson 3/8 | confirmed | Newton-Cotes page: panel interpolant degrees 1 to 4. |
| L28 | $B_{2n}=(16S_{2n}-S_n)/15$ is one Richardson step | confirmed | Numerically $B_{2n}-(16S_{2n}-S_n)/15=0$ (at most $8\times10^{-31}$) for $n=4,8,16$. |
| L29 | It "forms the third column of Romberg Integration" | confirmed | romberg-integration/index.qmd line 26: "the third is [Boole's rule]". |
| L30 | Heading id `{#case-1}` (the only change outside the Description) | confirmed | An allowed cross-reference id; the heading text is unchanged. |

Consistency with the rest of the page: the Behavior paragraph (line 57) gives 2.015961 at 121 points (computed 2.0159612; frame_024 shows 2.015961), an error of about $3.2\times10^{-4}$ (computed $-3.1854\times10^{-4}$), and a ratio of about 3.18 from 60 to 120 (computed 3.18196). The new Description does not contradict any of these, and there is no other section to check against.

## 3. Checks

- **Scope of the diff:** Only index.qmd changed. No script or GIF changed, so the animations are not under review. Outside the Description, the only change is `{#case-1}` on the Case 1 heading, which is allowed. No sentences were moved out of the Animations introduction; it is unchanged. The old Description sentences were rewritten inside the Description, and the "seven or more nodes" sentence was kept word for word.
- **Six points:**
  1. The problem: present (line 12).
  2. The core formula: present (display at line 15, in the script's notation).
  3. What it assumes: present ($n$ a multiple of 4; $f\in C^6$; lines 19–20).
  4. How accurate it is: present (general error term, labelled as general with its hypothesis; lines 22–29).
  5. When it fails or misleads: present (non-$C^6$ integrand, linked to Case 1; coarse partition; lines 31–34).
  6. Where it fits: present (line 46, linking Newton-Cotes, Simpson 3/8, Richardson and Romberg).
- **Worked example table:** 5 rows (limit about 6). It uses the page's own animated problem and adds digits the GIF does not show (errors and ratios).
- **Nothing the standard leaves out:** no proofs, theorem boxes or code procedures.
- **Word count:** manifest 389; my independent count 390. Both are within 150–400.
- **Links:**
  - `#case-1` resolves to the explicit id at line 55.
  - All of these exist as `<slug>/index.qmd`: `../simpsons-rule-for-numerical-integration/`, `../trapezoidal-rule-for-numerical-integration/`, `../newton-cotes-integration/`, `../simpsons-3-8-rule-for-numerical-integration/`, `../richardson-extrapolation/`, `../romberg-integration/`.
- **Markup:** inline and display math look well formed in the source (`$$` pairs balanced, table pipes aligned). Quarto was not run.
- **Fidelity:** the hypothesis $f\in C^6[a,b]$, the error term with its sign and constant, $a<c<b$, $O(h^6)$, and the factor-of-64 remark all match Mathews' corollary and remark. No Fidelity finding.
- **General results:** each is stated with its hypothesis ($C^6$). The page explicitly declines to attach $O(h^6)$ to Case 1, and the $h^{5/3}$ rate it does attach to Case 1 is confirmed from the case's own computed errors.
