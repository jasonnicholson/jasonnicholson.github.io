# Chebyshev Approximation Polynomial — batch 19 review, round 1 (overview mode)

SUMMARY: 0 Error, 0 Misleading, 0 Minor

# Review: chebyshev-approximation-polynomial (light-pass batch 19, overview, action *extend*)

Scope: the diff changes only `pages/numerical-methods/chebyshev-approximation-polynomial/index.qmd`. It rewrites and extends `## Description` and adds four explicit heading ids (`{#case-04}`, `{#case-08}`, `{#case-15}`, `{#case-19}`). No script or GIF changed, so the animations are not under review. I did not run MATLAB or quarto, and I modified nothing in the repository. All my work is in EV/reviewer/: `check.py` (mpmath, 50 digits), `dbl.py` (double-precision barycentric, the same as the script's) and `mathews_thm.png` (the module's formula images).

Mathews archive: **consulted.** I read `n2003/ChebyshevPolyMod.html` as text and its formula images `ChebyshevPolyMod_gr_170`–`196` (the Lagrange–Chebyshev theorem and algorithm).

## 1. Findings

None.

I checked every number, general result, case pointer and link in the new text, and all of them hold. Details are in the ledger.

## 2. Claim ledger (+ lines of the diff)

| # | Claim (page's words) | Verdict | Evidence |
|---|---|---|---|
| L1 | $P_{n-1}$ of degree at most $n-1$ interpolates $f$ at $n$ Chebyshev nodes, $P_{n-1}(x_k)=f(x_k)$ | confirmed | Script: n nodes, barycentric interpolant, title "degree ≤ n−1" |
| L2 | "Chebyshev-node interpolation uses clustered nodes … Runge-type endpoint blow-up." (2 sentences) | confirmed, unchanged | The words are identical to the old text; the diff only splits the lines |
| L3 | $t_k=\cos((2k-1)\pi/(2n))$ are the roots of $T_n(t)=\cos(n\arccos t)$, mapped from $[-1,1]$ to $[a,b]$ | confirmed | $\cos(n\cdot(2k-1)\pi/(2n))=\cos((2k-1)\pi/2)=0$. The display formula matches `chebyshev_nodes` (center + radius·cos) |
| L4 | Mathews' series $P_{n-1}=\sum c_jT_j(t)$, with $c_0=\frac1n\sum f(x_k)$ and $c_j=\frac2n\sum f(x_k)\cos(j(2k-1)\pi/(2n))$ | confirmed | In check.py, for e^x on [−2,3] with n=6, the series equals the Lagrange interpolant to 15 digits at x=−1.7, 0.3, 2.9 and 4 (e.g. 18.1781100280893 for both). It matches Mathews gr_188–196 after the shift n+1 → n nodes |
| L5 | "The animations evaluate the same polynomial in barycentric Lagrange form." | confirmed | Script: `barycentric_weights` and `barycentric_eval` (second form inside the nodes, first form outside) |
| L6 | Building $P_{n-1}$ needs only the values $f(x_k)$ | confirmed | Follows from L4 and L5 |
| L7 | Bound: if $f\in C^n[a,b]$, then for every $x\in[a,b]$, $\lvert f-P_{n-1}\rvert\le \frac{2(b-a)^n}{4^n n!}\max\lvert f^{(n)}\rvert$ | confirmed | Mathews gr_181–184 states it for $P_n$ with n+1 nodes and $C^{n+1}$; re-indexed it is exactly this. Independently, $\max\lvert\prod(t-t_k)\rvert=2^{1-n}$, times $((b-a)/2)^n$, gives $2(b-a)^n/4^n$ |
| L8 | The factor $2(b-a)^n/4^n$ is the largest value of $\lvert\prod(x-x_k)\rvert$ on [a,b], and no other n nodes make it smaller | confirmed | n=16 on [−1,1]: grid maximum 3.0517578125e−5 = 2⁻¹⁵, exactly the formula. The minimal property is the minimax property of monic $T_n$ (Mathews gr minimax theorem) |
| L9 | For 16 nodes on [−1,1], equally spaced nodes make it 44 times larger | confirmed | Equispaced maximum 1.34550e−3; ratio 44.09 |
| L10 | Case 15, e^x on [−2,3]: largest error with 16 nodes is $7.1\times10^{-12}$ | confirmed | 7.101e−12 (mpmath). The script-equivalent double-precision barycentric gives 7.105e−12 |
| L11 | Case 15 bound is $6.8\times10^{-11}$ | confirmed | $2\cdot5^{16}/(4^{16}\,16!)\cdot e^3$ = 6.8211e−11 |
| L12 | Case 08, 1/(1+10x²) on [−1,1]: error falls by a factor of about 3.47 for every four nodes added | confirmed | Ratios for n = 12→16, 16→20, 20→24, 24→28, 28→32 are 3.470, 3.4718, 3.472, 3.472, 3.472. The theoretical rate is $\rho^4$ with $\rho=1/\sqrt{10}+\sqrt{1.1}=1.365$, so $\rho^4=3.47$ |
| L13 | …from $1.4\times10^{-2}$ at 16 nodes to $9.5\times10^{-5}$ at 32 | confirmed | 1.3763e−2 and 9.4714e−5 |
| L14 | 16 equally spaced nodes leave an error of 0.48 | confirmed | 0.48492 (at x=±0.963). Consistent with the Newton and Lagrange pages' 0.485 |
| L15 | The bound is about 3050 at 16 nodes and grows with n | confirmed | 3051.76 at n=16. It grows to 1.9e4, 1.19e5, 7.45e5 and 4.66e6 at n=20, 24, 28, 32 (≈ 2·(√10/2)ⁿ) |
| L16 | Beyond [a,b] the interpolant is extrapolation and leaves f quickly; Case 04, 16 nodes on [0,2]: $P_{15}(3)\approx5.0\times10^4$ against $\sqrt3\approx1.73$ | confirmed | 50375.4 (mpmath) and 50375.38 (double, first barycentric form). Frame cheby04/frame_010 shows the blue curve leaving the frame just past x≈2.2 |
| L17 | The bound covers only [a,b] | confirmed | The theorem says "for all x ∈ [a,b]" (Mathews gr_184) |
| L18 | When f has an infinite derivative at an endpoint, the theorem does not apply and convergence is slow | confirmed | √x′(0)=∞ and arcsin′(±1)=∞, so f ∉ C¹[a,b] |
| L19 | √x on [0,2] (Case 04): largest error at an endpoint, only halves from 8 to 16 nodes | confirmed | n=8: 0.088816 at x=0; n=16: 0.044248 at x=0; ratio 2.01 |
| L20 | arcsin x on [−1,1] (Case 19): the same claim | confirmed | n=8: 0.12421 at x=±1; n=16: 0.06240 at x=±1; ratio 1.99. Frame cheby19/frame_010 shows the small mismatch at the ends |
| L21 | Lagrange and Newton pages hold the same interpolation with equally spaced nodes | confirmed | Both pages exist and use equally spaced nodes |
| L22 | Newton's Case 08 shows the Runge oscillation of 1/(1+10x²) | confirmed | Newton page line 83: `### Case 08: $f(x)=1/(1+10x^2)$, nodes on $[-1, 1]$ {#case-08}`, equally spaced nodes, Runge text at line 41 |
| L23 | Rational Approximation also uses Chebyshev nodes | confirmed | rational-approximation/index.qmd lines 21 and 43 |
| L24 | Least-Squares Polynomials and Legendre Polynomials fit by least squares instead | confirmed | least-squares-polynomials line 12; legendre-polynomials line 13 (continuous least squares) |
| L25 | Ids added: `{#case-04}`, `{#case-08}`, `{#case-15}`, `{#case-19}` | confirmed | Each matches its link. The second mention "(Case 04)" is unlinked, which is harmless |

Agreement with the rest of the page: the Animations introduction says the case 08 frames go to 20, 24, 28 and 32 nodes, which agrees with L12–L13. Its "degree at most n−1" agrees with L1. Its "outside them the blue curve is extrapolation and can leave the frame" agrees with L16. I found no contradiction with the Animations section or with the Lagrange and Newton pages (their equally spaced √x figure, 0.0485 at degree 15, is a different construction from this page's Chebyshev 0.044).

## 3. Checks

**The six points of the overview standard:**
1. **Problem:** present (first sentence).
2. **Core formula:** present, as the node formula and the Chebyshev-series display, in the script's notation (a, b, n nodes, k=1..n).
3. **Assumptions:** present. Construction needs only $f(x_k)$; the error bound needs $f\in C^n[a,b]$.
4. **Accuracy:** present. It is a general bound with its hypothesis, checked on Case 15 (bound satisfied) and Case 08 (geometric rate, bound uninformative).
5. **Failures:** present. There are two: extrapolation (Case 04) and endpoint singularity (Cases 04 and 19).
6. **Where it fits:** present (last paragraph).

There are no proofs or callout boxes.

**Word count:** 386 by my own count (inline math counted as 1 word, display math excluded), matching the manifest. This is within 150–400.

**Links and anchors:** `#case-04`, `#case-08`, `#case-15` and `#case-19` each match an explicit id the diff added. All five page links exist: `lagrange-polynomial-interpolation-and-approximation/`, `newton-interpolation-polynomial/`, `rational-approximation/`, `least-squares-polynomials/` and `legendre-polynomials/`. `newton-interpolation-polynomial/#case-08` exists and is the 1/(1+10x²) case.

**Diff scope:** outside the Description, the only changes are the four heading ids, which the standard allows. The two pre-existing Description sentences are unchanged in wording. No script or GIF changed.

**Frames inspected:**
- cheby04: frame_010 (n=16)
- cheby08: the contact sheet (n=2 to 28)
- cheby15: frame_010 (n=16)
- cheby19: frame_010 (n=16)

What each pointed-to case shows agrees with the text.

**Fidelity:** the bound and the coefficient formulas are Mathews' (gr_183, gr_190–193) with the node count shifted from n+1 to n. The hypothesis $C^{n+1}$ for $P_n$ becomes $C^n$ for $P_{n-1}$, so it is preserved correctly. I found no fidelity departure.
