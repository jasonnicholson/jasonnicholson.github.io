# False Position or Regula Falsi Method — animation review (round 2)

Page: `pages/numerical-methods/false-position-or-regula-falsi-method/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page and in the script headers agrees with independently computed values and with the frames. Counts: Error 0, Misleading 0, Minor 0.

Observations that I judged *not* to be findings (recorded so the owner can see they were considered):

- The page has no `## Description` section (the agent conventions file requires one). Under the review standard this is "content the page does not yet have", so it is not a finding. The Animations introduction does describe the algorithm (secant through $(a,f(a))$, $(b,f(b))$, x-intercept $c$ replaces the same-sign endpoint), and that description matches the scripts.
- Both animations spend their final frames with no visible change: Case B frames 6-11 (c_5 to c_10) all carry the label `0.739085` and are visually identical; Case A frames 8-13 differ only in the legend digits. This is not misleading (the method genuinely has converged to plotting resolution), just slack.
- Case A frame 11 legend reads `c_10 = 1.36522` (5 decimals) because `round(1.3652195..., digits=6) = 1.36522` drops the trailing zero; correct value, cosmetic only.
- Case A frame 1: the "Initial bracket [-1.0, 2.0]" annotation slightly touches the right edge of the legend box; fully readable.
- Case A heading says only "Convergent" while Case B says "Convergent (one-sided)", although both are one-sided; Case A's Behavior paragraph states the one-sidedness explicitly, so a reader is not misled.
- Case B (`x - cos x` on [0,1]) has no counterpart in the Mathews archive; it is an added case, not a replacement of an archive case, so not a Fidelity finding. The archive's only animated example (Example 3, `RegulaFalsiaa.gif`, file not present in the archive) is Case A with the same function and interval.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `regulafalsiaa.jl` | 0 | 7.1 | regulafalsiaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `regulafalsibb.jl` | 0 | 7.1 | regulafalsibb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `regulafalsiaa.gif` | 13 | byte-identical | regulafalsiaa |
| `regulafalsibb.gif` | 11 | byte-identical | regulafalsibb |

### Page references

- Scripts linked: `regulafalsiaa.jl`, `regulafalsibb.jl`
- GIFs embedded: 2
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

Commands behind the evidence: `/usr/bin/python3 -I review/indep.py` (independent) and `julia review/inst_aa.jl`, `julia review/inst_bb.jl` (script values). Frames viewed: committed `regulafalsiaa/frame_001.png`, `frame_002.png`, `sheet.png` (frames 1,3,5,7,9,11,13); `regulafalsibb/frame_002.png`, `sheet.png` (all 11).

### Introduction

| # | Claim (page words) | Evidence | Verdict |
|---|---|---|---|
| I1 | "shows the **secant diagram** for Regula Falsi" | Both scripts draw the dashed line through the previous bracket endpoints and its x-intercept | confirmed |
| I2 | "a secant line is drawn through the two bracket endpoints $(a,f(a))$ and $(b,f(b))$; its x-intercept $c$ becomes the new estimate" | aa.jl L32/L88-91, bb.jl L29/L84-87: `c = (a f(b) - b f(a))/(f(b)-f(a))`, which equals the zero of the line through both points; independent form `c = b - f(b)(b-a)/(f(b)-f(a))` gives identical values | confirmed |
| I3 | "In each frame after the first, the dashed secant passes through the endpoints of the previous bracket" | secant built from `as[frame], bs[frame]` (previous); frame 2 of aa: dashed line passes through (-1,-7) and (2,14) | confirmed |
| I4 | "the shaded band shows the updated bracket, which has the new point $c$ (red) as one endpoint" | shading uses `as[frame+1], bs[frame+1]`; aa frame 2 band is [0,2] with red diamond at c_1 = 0; bb frame 2 band is [0.685,1] with red at 0.685073 | confirmed |
| I5 | "Regula Falsi weights the new point toward whichever endpoint has a smaller $\lvert f\rvert$ value" | $c = \frac{\lvert f(b)\rvert a + \lvert f(a)\rvert b}{\lvert f(a)\rvert+\lvert f(b)\rvert}$ when signs differ; weight on each endpoint is the other's $\lvert f\rvert$ | confirmed |
| I6 | "often giving faster convergence" (than bisection) | Case A asymptotic error ratio 0.25127, Case B 0.05009, both < 0.5 | confirmed (general claim, consistent with both cases) |
| I7 | "one endpoint can remain fixed for many iterations" | b fixed in all 12 (A) and 10 (B) iterations | confirmed |
| I8 | "Julia source scripts that generated these animations are linked under each case" | manifest: regenerated GIFs byte-identical to committed | confirmed |

### Case A

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| A1 | Heading: $f(x)=x^3+4x^2-10$ | aa.jl L15 | confirmed |
| A2 | Heading: $[a,b]=[-1,2]$ | aa.jl L16 `a0, b0 = -1.0, 2.0` | confirmed |
| A3 | Heading: "Convergent" | errors 1.365 -> 6.63e-7 over 12 iterations, monotone decreasing | confirmed |
| A4 | "converges to the real root $x^*\approx 1.3652$" | mpmath findroot: 1.36523001341410; f(root)=0; only real root (cubic discriminant: other two roots complex, see section 3) | confirmed |
| A5 | "The right endpoint $b=2$ stays fixed throughout" | script and independent: b = 2.0 after every one of 12 iterations | confirmed |
| A6 | "$f(-1)<0$" | f(-1) = -7 | confirmed |
| A7 | "every false-position point $c$ also satisfies $f(c)<0$" | f(c_k) = -10, -6.644, -2.389, -0.6652, ..., -1.095e-5 (all 12 negative) | confirmed |
| A8 | "($f$ is convex on the bracket)" | f'' = 6x+8 > 0 for x > -4/3, so convex on [-1,2] | confirmed |
| A9 | "the algorithm keeps replacing $a$ with $c$" | side chosen `a<-c` every step | confirmed |
| A10 | "$a = -1, 0, 0.8333, 1.2088, \dots$" | a_0..a_3 = -1, 0, 0.833333, 1.208791 | confirmed |
| A11 | "This one-sided stagnation is characteristic of Regula Falsi and distinguishes it from ... bisection" | qualitative; consistent with A5 and convexity argument | confirmed |
| A12 | Link `[Julia source](regulafalsiaa.jl)` and embed `regulafalsiaa.gif` belong to this case | file contents/title "f(x) = x³ + 4x² − 10" | confirmed |
| A13 | Alt: "for f(x)=x³+4x²−10 on [−1,2]" | as A1, A2 | confirmed |
| A14 | Alt: "the secant line from bracket endpoints walks toward the root near x=1.37" | frames 2-13: secant intercepts 0, 0.833, 1.209, 1.324, ... approach 1.3652 (rounds to 1.37) | confirmed |
| A15 | Alt: "with the right endpoint fixed" | frames: right blue marker at (2,14) in all frames | confirmed |
| A16 | Alt: "successive false-position points converging from the left" | c_k increasing, all < x* | confirmed |
| A17 | Script header L6: "b = 2 stays fixed and the error ratio ... settles at about 0.251" | observed ratio 0.251271 at k=11,12; theoretical $1 - f'(x^*)(b-x^*)/f(b) = 0.25127071$ | confirmed |
| A18 | Script header L5: "convergence is only linear" | constant ratio 0.2513 | confirmed |
| A19 | Script header L8: "True root ≈ 1.36523" | 1.3652300134 | confirmed |
| A20 | Script header L3: "Matches the legacy Mathews module example" | Mathews Example 3: $x^3+4x^2-10=0$, $[a,b]=[-1,2]$ (gr_432, gr_433, gr_434) | confirmed |

### Case B

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| B1 | Heading: $f(x)=x-\cos(x)$ | bb.jl L12 | confirmed |
| B2 | Heading: $[a,b]=[0,1]$ | bb.jl L13 | confirmed |
| B3 | Heading: "Convergent (one-sided)" | errors 0.054 -> 1.1e-13; b fixed throughout | confirmed |
| B4 | "converges to the Dottie number $x^*\approx 0.7391$" | findroot: 0.739085133215161 | confirmed |
| B5 | "the unique fixed point of cosine" | f' = 1 + sin x >= 0 with equality only at isolated points, so f strictly increasing, single real zero | confirmed |
| B6 | "The right endpoint $b=1$ ... remains fixed throughout" | b = 1.0 after all 10 iterations | confirmed |
| B7 | "$f(1)\approx 0.4597$" | 0.45969769 | confirmed |
| B8 | "$f$ is convex on $[0,1]$" | f'' = cos x > 0 on [0,1] | confirmed |
| B9 | "every false-position point satisfies $f(c)<0$" | f(c_k) = -0.0893, -0.00466, -2.34e-4, ..., -1.85e-13 (all 10 negative) | confirmed |
| B10 | "$c = 0.6851, 0.7363, 0.7389, \dots$" | 0.685073, 0.736299, 0.738945 | confirmed |
| B11 | "the bracket shrinks only on the left side, yet the secant intercept homes in on the root accurately" | a increases to 0.7390851332, b = 1; final error 1.1e-13 | confirmed |
| B12 | Link `regulafalsibb.jl` and embed `regulafalsibb.gif` belong to this case | title "f(x) = x − cos(x)" in frames | confirmed |
| B13 | Alt: "for f(x)=x−cos(x) on [0,1]" | as B1, B2 | confirmed |
| B14 | Alt: "converges to the Dottie number x*≈0.739" | 0.7391 | confirmed |
| B15 | Alt: "with the right endpoint fixed at 1 while the left endpoint steps in" | frames: right marker at (1, 0.4597) throughout; shaded band's left edge moves 0 -> 0.685 -> 0.736 -> ... | confirmed |
| B16 | Script header L3-4: "right endpoint stays fixed at 1 ... c points converge from the left" | as B6, B11 | confirmed |
| B17 | Script header L5: "Root: x* ≈ 0.7391 (Dottie number)" | as B4 | confirmed |

### Wiring / counts

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| W1 | Two cases, each with one script link and one GIF embed | index.qmd L21/23, L29/31 | confirmed |
| W2 | Page linked from section index | `pages/numerical-methods/index.qmd` L15 | confirmed |

Not in ledger (excluded per standard): "Source inspiration: [@mathewsSite]" (attribution).

### 3. Implementation checks

### `regulafalsiaa.jl`

1. **Is the named method.** Classic (unmodified) Regula Falsi: each step computes the secant x-intercept of the current bracket and replaces the endpoint whose f has the same sign as f(c) (`if f(a)*f(c) < 0 then b=c else a=c`). Not Illinois/Anderson-Björck/Pegasus; no safeguard; fixed iteration count 12. The page describes this same variant (it emphasises the fixed endpoint, which the modified variants are designed to avoid). Mathews uses the same plain variant with a predetermined iteration count (archive "Implementation" text); Mathews' Example 3 call used 15 iterations, the script uses 12, immaterial.
2. **Numbers.** Script (Float64) vs independent (mpmath, 40 digits, algebraically different update formula `c = b - f(b)(b-a)/(f(b)-f(a))`):

| k | script c_k | independent c_k | f(c_k) | err ratio |
|---|---|---|---|---|
| 1 | 0.0 | 0.0 | -10 | – |
| 2 | 0.8333333333333334 | 0.833333333333 | -6.6435 | 0.3896 |
| 3 | 1.2087912087912087 | 1.20879120879 | -2.3890 | 0.2941 |
| 4 | 1.32412611057995 | 1.32412611058 | -0.66516 | 0.2627 |
| 5 | 1.3547812233663692 | 1.35478122337 | -0.17166 | 0.2542 |
| 6 | 1.362596802578731 | 1.36259680258 | -0.043427 | 0.2520 |
| 8 | 1.365063606246616 | 1.36506360625 | -0.0027477 | 0.25132 |
| 10 | 1.365219506354675 | 1.36521950635 | -1.7351e-4 | 0.251274 |
| 12 | 1.36522935002777 | 1.36522935003 | -1.0955e-5 | 0.251271 |

   Agreement to all printed digits. Rate check that does not depend on a remembered formula: the observed ratio converges to 0.251271, matching the fixed-endpoint linear-rate value $1-f'(x^*)(b-x^*)/f(b) = 0.25127071$.
3. **Reference values.** Header root 1.36523 vs 1.3652300134 (residual 0 at 40 digits). Uniqueness of the real root: f has local max at x = -8/3 with f(-8/3) = -512/27 + 256/9 - 10 = -14/27 ≈ -0.519 < 0, so only one real root. No reference curve is drawn; nothing else to verify.
4. **Picture.** Frame 1: curve, blue endpoints at (-1,-7) and (2,14), band [-1,2], annotation. Frame 2: dashed secant through (-1,-7) and (2,14) (checked visually: crosses the curve at x=-1, passes through (0,0) intercept), red diamond at c_1 = 0 with dotted drop to (0,-10), band [0,2], legend `c_1 = 0.0`. Sheet frames 3-13: legend indices match `cs[frame]` (c_2 = 0.833333, c_4 = 1.324126, c_6 = 1.362597, c_8 = 1.365064, c_10 = 1.36522, c_12 = 1.365229), gray diamonds accumulate at earlier c's, band [c_k, 2]. Title function equals the code function. Axis limits x ∈ [-1.5, 2.5], y ∈ [-14, 16] contain the bracket, the root and both endpoint values; the curve exits the top above x ≈ 2.1, which hides nothing the page discusses. No clamping or masking. Frame count 13 = initial + 12 iterations.

### `regulafalsibb.jl`

1. **Is the named method.** Identical algorithm to aa (plain Regula Falsi, 10 iterations).
2. **Numbers.**

| k | script c_k | independent c_k | f(c_k) | err ratio |
|---|---|---|---|---|
| 1 | 0.6850733573260451 | 0.685073357326 | -0.089299 | – |
| 2 | 0.736298997613654 | 0.736298997614 | -0.0046600 | 0.05158 |
| 3 | 0.7389453559657132 | 0.738945355966 | -2.3393e-4 | 0.05017 |
| 4 | 0.7390781308800257 | 0.73907813088 | -1.1719e-5 | 0.050096 |
| 5 | 0.7390847824489231 | 0.739084782449 | -5.8705e-7 | 0.050093 |
| 7 | 0.7390851323349952 | 0.739085132335 | -1.4731e-9 | 0.0500926 |
| 10 | 0.73908513321505 | 0.739085133215 | -1.8519e-13 | 0.0500926 |

   Agreement to all printed digits; observed ratio 0.0500926 equals the theoretical fixed-endpoint rate 0.05009256.
3. **Reference values.** Root 0.7391 vs 0.739085133215161 (residual -5e-42). f(1) = 0.45969769.
4. **Picture.** Frame 1: endpoints (0,-1) and (1,0.4597), band [0,1]. Frame 2: dashed secant through (0,-1) and (1,0.4597), red diamond at 0.685073, dot at f(c) = -0.0893, band [0.685,1], legend `c_1 = 0.685073`. Sheet frames 3-11: indices and values match `cs[frame]`; from c_5 onward labels all read 0.739085 (true to 6 digits). Title function matches code. Limits x ∈ [-0.2, 1.3], y ∈ [-1.2, 0.5] contain f(0) = -1 and f(1) = 0.4597. No clamping. Frame count 11 = initial + 10 iterations.

### Legacy archive

Mathews' module has three examples, all on $x^3+4x^2-10$: Example 1 on [1,2] (10 iterations, no animation), Example 2 (a subroutine call; no graph), Example 3 "Convergence" on [-1,2] with "Animation 1" linking to `a2001/Animations/RootFinding/RegulaFalsi/RegulaFalsiaa.html`, whose `RegulaFalsiaa.gif` is not in the archive. Mathews' plot range for Example 3 is x ∈ [-1.05, 2.05], y ∈ [-10, 15] (gr_434, gr_521), consistent with the script's window. Case A reproduces Example 3; the archive has no other animation that the page drops. Case B is an addition. No Fidelity findings.

