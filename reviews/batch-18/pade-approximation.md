# Padé Approximation — batch 18 review, round 1 (overview mode)

SUMMARY: 0 Error, 0 Misleading, 0 Minor

Page: `pages/numerical-methods/pade-approximation/index.qmd`, light-pass batch 18, overview page (action *check*). The diff changes only `index.qmd`. No script or GIF changed, so the animations stayed out of scope. I did not run MATLAB or quarto, and I modified nothing in the repository. My scratch files are in `/tmp/claude-1001/-home-jason--claude-spares-spare-0ogoFf/f6c51b48-3d53-4b4d-8872-653429a6389a/scratchpad/work/review-18/pade-approximation/reviewer/`:
- `pade_funcs.jl` is lines 11–449 of the page script, with plotting and rendering removed.
- `probe.jl` and `probe2.jl` instrument those functions.
- `indep.py` is an independent check in sympy, mpmath and numpy.

I consulted the Mathews archive (`n2003/PadeApproximationMod.html` and its theorem images `_gr_5` to `_gr_8`).

## 1. Findings

None.

Observations below the threshold for a finding (not counted):
- The MATLAB timing paragraph (line 27) is old text. The diff touched that line only to add the link `in [Case 03](#case-03)`, but because the whole line is a `+` line, I list it in the ledger. Its MATLAB and chebfun claims are could-not-determine because I was told not to run MATLAB. It is a timing remark, not a MATLAB procedure, so it does not break the standard's "Left out" rule.
- The Description is 399 words, one under the 400-word limit. Any further addition would breach it.
- Mathews states his theorem about 0 (Maclaurin) and writes R_{n,m} = P_n/Q_m. The page writes "near x_0" and uses R_{m,n} = P_m/Q_n. Since the order is m+n either way, the hypothesis C^{m+n} is the same. Generalizing to x_0 fits the page's cases with x_0 ≠ 0. This is not a Fidelity finding.

## 2. Claim ledger (the `+` lines of the diff)

L1. (line 20, words unchanged; the line was split) "the Taylor expansion of R_{m,n} about x_0 matches the target function through order m+n. Equivalently, f^(k)(x_0) = R^(k)(x_0), k = 0..m+n."
- **Confirmed.** This is the standard definition. Q_n(x_0) = 1 makes R smooth at x_0. The script's `pade_linear` imposes exactly these conditions: a Toeplitz system for q_1..q_n from the coefficients m+1..m+n, then p = (q·a) truncated to degree m.

L2. "Mathews' theorem assumes f ∈ C^{m+n} near x_0, so these derivatives exist."
- **Confirmed.**
- Mathews' theorem image `_gr_5` reads "f ∈ C^{n+m}", and `_gr_7` requires a Maclaurin expansion of degree at least n+m.
- The hypothesis is enough for f^(k)(x_0) to exist for k ≤ m+n.
- Every case is analytic at its x_0.

L3. (old text plus a new link) "When Taylor coefficients vanish … some entries [m/n] have no such R_{m,n}. Those frames show the lower-order entry … the legend says so, for example 'Padé [2/1] = [1/0] (degenerate)' in Case 08."
- **Confirmed.**
- For sin x the coefficients are a = (0, 1, 0, −1/6). The [2/1] system is 0·q_1 = 1/6, which has no solution (sympy `solve` returns []).
- The reduced entry [1/0] = x matches only through order 2, since x − sin x = x³/6 + …, so its order is lower than 3.
- The script's `pade_from_series` gives frame 9 of Case 08 the label "[2/1] = [1/0] (degenerate)".
- `frames/pade08/frame_009.png` shows the legend "Padé [2/1] = [1/0] (degenerate)", drawn as the line y = x.

L4. "In Case 16, the Taylor polynomial [10/0] of arctan x …"
- **Confirmed.** Frame 66 of `pade16.gif` is labelled "Padé [10/0]". In the script, n = 0 returns the Taylor coefficients a_0..a_10, with a_10 = 0.

L5. "… whose series converges only for |x| ≤ 1 …"
- **Confirmed.** The radius of convergence is 1 (branch points at ±i), and the series converges at both ±1 by the alternating series test.

L6. "… is off by 43.2 at x = 2 …"
- **Confirmed.**
- Script functions: T10(2) = 44.336508, atan 2 = 1.107149, error = 43.229359.
- Independent sympy check: 43.22935922.
- Frame 66 agrees: the Taylor curve leaves the window near x ≈ ±1.37.

L7. "… while [5/5] stays within 0.016 on all of [−2, 2]."
- **Confirmed.**
- Independent sympy Padé: R = x(64x⁴ + 735x² + 945) / (15(15x⁴ + 70x² + 63)). Here q_5 = 0, so the [5/5] entry exists and equals the [5/4] entry, as expected for an odd function.
- Maximum error on [−2, 2]: 0.0155499672 (mpmath, 4001 points), reached at x = ±2.
- Script: 0.015550 on its 900-point grid and 0.015549967 on 400 001 points. Its coefficients match.
- Frame 61 is labelled "Padé [5/5]" with no degenerate note, and the curve lies on arctan across the whole window.

L8. (old text, new link) "for √x about x_0 = 5 in Case 03, the [4/6] system has condition number about 1.5×10^11"
- **Confirmed.**
- Script `pade_linear(a,4,6)`: cond(B) = 1.511e11. This is also the largest condition number in Case 03.
- Independent numpy check on the same Toeplitz layout: 1.5109e11.
- Frame 60 of `pade03.gif` is [4/6].

L9. (old text on the same line) "… and because that system is singular for some entries [m/n], the degenerate entries described above."
- **Confirmed for this table.** I checked all 27 cases (`probe2.jl`). No entry has a singular but consistent system, so on this page singular and degenerate pick out the same entries.

L10. (old text on the same line) "MATLAB's symbolic `pade` can be very slow for some entries below total order 20 … [1/15], [1/16], [1/17] for e^x took about 7, 31 and 134 seconds in MATLAB R2026a."
- **Could not determine.** I was told not to run MATLAB.

L11. (old text on the same line) "`padeapprox` from chebfun also struggles."
- **Could not determine.** It is a vague claim and chebfun is not available here.

L12. "The [m/0] entries are the Taylor polynomials of Maclaurin and Taylor Series …"
- **Confirmed.** With n = 0, the conditions reduce to P_m = the Taylor polynomial of degree m, and the script's n == 0 branch returns a[1:m+1].
- The link `../maclaurin-and-taylor-series/` resolves to an existing page folder.

L13. "… and Rational Approximation fits P_m/Q_n on an interval instead of at a point."
- **Confirmed.** `../rational-approximation/index.qmd` exists. Its Description builds R_{m,n} on [a, b] from nodes and by MinMax, and it links back to this page in the same terms.

L14. Heading ids `{#case-03}`, `{#case-08}`, `{#case-16}` and the links `#case-03`, `#case-08`, `#case-16`.
- **Confirmed.** Each id sits on the heading of the case it names, and each link matches its id exactly.

## 3. Checks

**Six points of the overview standard:**
1. Problem: paragraph 1 (old text). Present.
2. Core formula: the display R_{m,n} = P_m/Q_n with Q_n(x_0) = 1. It uses the script's notation (expansion in z = x − x_0, q_0 = 1). Present.
3. Assumptions: f ∈ C^{m+n} (new), plus the existence caveat for degenerate entries. Present.
4. Accuracy: derivatives match through order m+n, stated as general and conditional on the entry existing. It is illustrated by Case 16, which I verified (L6, L7). Present.
5. Failure modes: degenerate entries (Case 08 link) and ill-conditioning (Case 03 link). Present.
6. Where it fits: the new sentence linking Maclaurin and Taylor Series and Rational Approximation. Present.

**Limits:**
- My own count of the Description prose (lines 12–31, inline math counted as one word, display math excluded) is 399 words, the same as the manifest and within 150–400.
- There are no callouts, theorem boxes or proofs.

**Links and anchors:** all resolve (see L12–L14). The manifest's mechanical checks found nothing.

**Scope of the diff:**
- Inside the Description: new text, plus one line split with its words unchanged.
- Outside the Description: only the three explicit heading ids. Nothing else in the Animations sections, Video Animations or Outside Links changed. No script or GIF changed.

**Consistency with the rest of the page:**
- The new text contradicts nothing in the Animations introduction, which says m+n ≤ 10 for Case 16 (so [10/0] and [5/5] are both frames), or in the case headings (Case 16 is arctan on [−2, 2] with x_0 = 0, as the script has it).
- The script's own coefficient table for arctan is a_{2m+1} = (−1)^m/(2m+1), and `probe.jl` printed it, so the numbers in L6 and L7 come from the same table the GIF uses.
