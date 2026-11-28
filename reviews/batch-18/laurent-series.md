# Laurent series — batch 18 review, round 1 (overview mode)

SUMMARY: 0 Error, 0 Misleading, 1 Minor

Page: `pages/numerical-methods/laurent-series/index.qmd`, light-pass batch 18, overview mode (extend).
Evidence: EV = /tmp/claude-1001/-home-jason--claude-spares-spare-0ogoFf/f6c51b48-3d53-4b4d-8872-653429a6389a/scratchpad/work/review-18/laurent-series. My check script is at EV/reviewer/check.py. It uses exact Fractions for Cases 02, 05 and 06, and mpmath at 40 digits for Case 08.

I consulted the Mathews archive: `c2003/LaurentSeriesMod.html`, read as text. I did not run MATLAB or quarto, and I modified nothing in the repository.

## Part 1: Findings

**F1. Page text, Minor.** Description, line 32: "Outside the largest annulus on which $f$ is analytic, the series diverges: … the disk series of [Case 05](#case-05) …"
- **What is there now.** The general claim is true when "the largest annulus" means the largest annulus about $x_0$ that contains the series' own annulus. As worded it reads as if a function has a single largest annulus of analyticity. The sentence then cites Cases 05–07's function, $4/((x-1)(x+3))$, which has three maximal annuli about 0: $|x|<1$, $1<|x|<3$ and $|x|>3$. Taken literally, a reader cannot tell which one bounds the Case 05 disk series.
- **What is true instead.** The disk series diverges outside $|x|<1$, its own maximal annulus. My computation confirms it: at $x=1.5$ the partial sum over powers 0..13 is $-582.08$, against $f=1.7778$.
- **Suggested correction.** "Outside the largest annulus about $x_0$ that contains the series' own annulus and on which $f$ is analytic, the series diverges". A shorter version: "Beyond the singularities that bound its annulus, the series diverges".

## Part 2: Claim ledger

The ledger covers the `+` lines of the diff. Every entry is confirmed except where the verdict says otherwise.

**L1.** "A Laurent series expands $f$ in negative as well as positive powers of $x-x_0$ to represent it around a singularity, or between singularities, where no Taylor series about $x_0$ exists or converges."
- Confirmed. Cases 03 and 08 have no Taylor series about 0. In Cases 04, 06 and 07, the Taylor series about 0 does not converge in the region.

**L2.** The coefficient formula and "where $C$ is any positively oriented circle about $x_0$ inside the annulus".
- This line was only re-wrapped. It matches Mathews (7-23).

**L3.** "The terms with $k<0$ form the principal part."
- Re-wrapped only, unchanged.

**L4.** "Laurent's theorem needs only $0\le r<R\le\infty$ and $f$ analytic in the annulus, whatever singularities $f$ has inside the inner circle or outside the outer one."
- Confirmed. This is Mathews Theorem 7.8.

**L5.** "For a given annulus the coefficients are unique, but … a different series in each annulus about the same center."
- Re-wrapped only, unchanged. Mathews Theorem 7.9(i) and Example 7.7 agree.

**L6.** The analytic-disk sentence and the non-removable-singularity sentence.
- Re-wrapped only. They are word for word the old text.

**L7.** "Those powers do what a polynomial cannot: for $k>0$, $(x-x_0)^{-k}$ is infinite at $x_0$ and tends to 0 as $|x|\to\infty$, while a polynomial has no vertical asymptote and, unless constant, no horizontal one."
- Confirmed. This condenses an old sentence and the meaning is preserved.

**L8.** "the series converges absolutely in the annulus and uniformly on every closed subannulus $\rho_1\le|x-x_0|\le\rho_2$ with $r<\rho_1<\rho_2<R$."
- Confirmed. It is a standard result, and Mathews Theorem 7.7 gives the uniform part.

**L9.** "dropping the powers above $N$ leaves an error $O(q^N)$ for every $q$ with $|x-x_0|/R<q<1$, and dropping those below $-M$ leaves $O(q^M)$ for every $q$ with $r/|x-x_0|<q<1$."
- Confirmed. The Cauchy estimates give $|a_k|\le M(\rho)\rho^{-k}$ for $\rho<R$ and $|a_{-k}|\le M(\rho)\rho^{k}$ for $\rho>r$.
- The geometric tails are then $O((|x|/\rho)^{N+1})$ and $O((\rho/|x|)^{M+1})$, and $\rho$ ranges over the stated intervals for $q$.
- The hypotheses are stated correctly, with strict inequality for $q$.

**L10.** "In Case 02, at $x=0.9$ with $R=1$, each frame adds the next even power and multiplies the error by exactly $0.81=0.9^2$."
- Confirmed. The frames are `0:2:2m` for $m=0..11$, which is 12 frames.
- The exact error is $|f-S_m| = 0.81^{m+1}/1.81$. The set of successive absolute-error ratios is exactly {81/100}, running from 0.44751 to 0.04407.
- The ratio holds for the absolute error, which is how the page uses "error" throughout. The signed error alternates, with ratio $-0.81$.
- This is consistent with L9: the rate per power is $0.9=|x|/R$.

**L11.** "Outside the largest annulus on which $f$ is analytic, the series diverges".
- True under the intended reading. The wording is imprecise; see F1.

**L12.** "in Case 02 the error at $x=1.2$ grows with every frame".
- Confirmed. The ratio is exactly $1.44$ per frame, from 0.5902 to 32.58, so it strictly increases.

**L13.** "the disk series of Case 05, used at $x=1.5$, gives $-582$ against $f=1.78$".
- Confirmed: the sum over powers 0..13 is $-582.081$ and $f=1.7778$.
- This agrees with the Case 05 Behavior text, which says the same.

**L14.** "Near either circle convergence is slow: in the last frame of Case 06 the error is $0.0013$ at $x=2$, but $3.19$ at $x=1.1$ and $6.44$ at $x=-2.9$."
- Confirmed. With powers $-12..12$ (12 frames, the last being $-12..12$), the errors are 0.0012718, 3.18631 and 6.43573.
- This agrees with the Case 06 Behavior text, which gives an error below 0.02 on $[1.5, 2.5]$.
- The last frame (frame_012.png) shows the blue sum leaving $f$ visibly near $x=-2.9$. Near $x=1.1$ both curves run off the top of the window, as expected.

**L15.** "In Case 08, where $r=0$, the last sum's error exceeds $0.01$ for every $0<|x|<0.27$."
- Confirmed. The last sum covers powers $-11..0$.
- I scanned $|x|$ on a $10^{-5}$ grid. The smallest $|x|$ with error ≤ 0.01 is 0.28470 for $x>0$ and 0.27174 for $x<0$. Sample errors: 0.0193 at $x=0.27$ and 0.0108 at $x=-0.27$.
- So 0.27 is a valid bound on both sides, and it is the tighter, left-hand one.

**L16.** "With no negative powers a Laurent series is a Taylor series".
- Confirmed.

**L17.** "its positive and negative parts are power series in $x-x_0$ and $1/(x-x_0)$".
- Confirmed.

**L18.** "Padé approximation follows poles and asymptotes with a rational function instead."
- Confirmed. This is a qualitative claim and it is correct.

**L19.** The new heading ids `{#case-02}`, `{#case-05}`, `{#case-06}` and `{#case-08}`.
- Each is on the heading that is that case, and the links in the Description resolve to them. There are no duplicate ids.

**L20.** The links `../maclaurin-and-taylor-series/`, `../power-series/` and `../pade-approximation/`.
- Confirmed: each directory has an index.qmd.

## Part 3: Checks

**The six points of the standard.** All six are present, in order:
1. The problem: line 12.
2. The core formula: display math in the $x$, $x_0$, $a_k$ notation that the script's coefficient functions use.
3. What it assumes: lines 13 and 21.
4. How accurate it is: lines 28–30, a general result with its hypotheses, checked on Case 02.
5. When it fails or misleads: lines 32–34. These cover divergence outside the annulus (Cases 02 and 05) and slow convergence near the circles (Cases 06 and 08), all linked.
6. Where it fits: line 36.

The Description has no proofs and no theorem boxes.

**Word count.** I recounted independently, with inline math as one word and display math excluded, and got 398. That is within 150–400, though at the top of the range.

**Consistency with the rest of the page.** The new numbers agree with the Case 02, 05, 06 and 08 Behavior texts: 0.448 → 0.044 and 0.590 → 32.6 for Case 02, $-582$ vs 1.78 for Case 05, and an error below 0.02 on $[1.5, 2.5]$ for Case 06. There are no contradictions.

**Scope of the diff.** The changes outside the Description are only the four explicit heading ids, which the standard allows. The script and GIFs are unchanged; the diff touches index.qmd only. Frame counts are 14/12/10/10/14/12/12/12 and match the script's frame lists.

**Reference values.** The coefficients the script uses for Cases 05, 06 and 08 are correct. I derived them from the partial fractions $1/(x-1) - 1/(x+3)$ and from $e^{1/x}$, and every error I computed was taken against the true $f$, not against page values.

**Fidelity.** The Laurent theorem hypotheses, the coefficient integral and the uniform convergence on closed subannuli match Mathews Theorems 7.7 and 7.8. There are no Fidelity findings.
