# Fix record: improved-newton-method

Check script: `/usr/bin/python3 /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r7fix/improved-newton-method/fix/check.py` (mpmath at 400 digits, sympy). All numbers below are its output.

## Findings

### F1 — Error — fixed
- Reproduced: with the page's definition $x_{n,m} = x_n - m f(x_n)/f'(x_n)$, $f = \arctan$, $x_0 = 1.4$: $x_{0,1} = -1.4136186$, $x_{0,2} = -4.2272373$, $x_{1,1} = +1.4501293$, $x_{1,2} = +4.3138773$. The page's values $-1.41$ and $-4.23$ are the $x_{0,\cdot}$ points.
- Change: `index.qmd` Case 5, $x_{1,1} \to x_{0,1}$ and $x_{1,2} \to x_{0,2}$. Numbers unchanged.
- Check: $|f(x_{0,1})| = 0.95511826 < |f(x_{0,2})| = 1.3385055$, so "with larger $|f|$" holds. The Method C trace keeps $m = 1$ at all 7 steps computed and gives $-1.4136186, 1.4501293, -1.550626, 1.8470541, -2.8935624, 8.7103258, -103.24977$.

### F2 — Misleading — fixed
- Reproduced: Method B's formula has no $m$, and its $e_{n+1}/e_n^2$ reaches $-0.16666667$ at the double root and $-0.11111111$ at the triple root. Method C takes no $m$ as input and selects $m = 2, 3, 4$ at orders 2, 3, 4 from $x_0 = 1.3$. The module says "Method A has the disadvantage that the order m of the root must be known a priori".
- Change: `index.qmd` Case 4. "This illustrates the core advantage of the improved methods: knowing $m$ unlocks quadratic convergence regardless of root order." → "This illustrates Method A's advantage: when the multiplicity $m$ is known, the scaled step gives at least quadratic convergence to a root of any order from a close enough start. Methods B and C do not need $m$."
- Departure from the review's suggested wording, for accuracy:
  - "at least quadratic": writing $f = (x-r)^m g$ gives the exact error map $e_{n+1} = e_n^2\,g'/(m g + e_n g')$, so the rate exceeds 2 when $g'(r) = 0$. Computed for $f = (x-1)^2(1+(x-1)^2)$, $m = 2$: $e_{n+1}/e_n^2 \to 0$ ($5.03\times10^{-45}$ at step 4) and $e_{n+1}/e_n^3 \to 1$.
  - "from a close enough start": with $m = 1$, Method A is Newton, which diverges from $x_0 = 1.4$ in Case 5.
- Check: for $f = (x-1)^m(x+2)$, $m = 2,\dots,6$, $x_0 = 1.3$, Method A's $e_{n+1}/e_n^2$ reaches $1/(3m)$ to 8 digits (0.16666667, 0.11111111, 0.083333333, 0.066666667, 0.055555556).

### F3 — Minor — fixed
- Reproduced: sympy gives $N(x) = -\tfrac23 x^3 + \tfrac{2}{15} x^5 + O(x^7)$ for Newton on $\arctan$. From $x_0 = 0.5$: $e_{n+1}/e_n^3 = -0.636476, -0.665825, -0.666667, -0.666667$, while $e_{n+1}/e_n^2 = -0.318238, 0.0529727, -2.23535\times10^{-4}, 1.67543\times10^{-11}$.
- Change: `index.qmd` line 12, "it does so quadratically if the root is simple" → "it does so at least quadratically if the root is simple".
- Check: the wording covers both cases. Exactly quadratic at the simple root $x = -2$ of $(x-1)^2(x+2)$: $e_{n+1}/e_n^2 \to -0.66666667$, equal to the exact $f''/(2f') = -2/3$. Faster than quadratic for $\arctan$ at 0, as above.

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| Description, line 12 | "at least quadratically if the root is simple" | `check.py` F3: cubic for arctan; quadratic at $x=-2$ with limit $-2/3$ | Yes |
| Description, line 19 (coordinator request) | "Started close enough to a multiple root, Methods A and B converge to it at least quadratically." | `check2.py`, symbolic $m$, $f = e^m G(e)$, $G(0) = g_0 \ne 0$: both maps have $N(0) = N'(0) = 0$, with $e^2$ coefficients $+g_1/(m g_0)$ (A) and $-g_1/(m g_0)$ (B); B's denominator at the root is $m g_0^2 \ne 0$. Order exactly 2 for $G = 3 + e$, $m = 2,3,4$ (A: $1/6, 1/9, 1/12$; B: the negatives). Order 3 for $G = 1 + e^2$, $m = 2,3,4$ (A: $e_{n+1}/e_n^3 \to 1, 2/3, 1/2$; B: $-2, -4/3, -1$), matching the symbolic $e^3$ coefficients $2g_2/(m g_0)$ and $-4g_2/(m g_0)$ | Yes |
| Animations introduction, line 26 (coordinator request) | "started close enough, Method A (accelerated) restores at least quadratic convergence by multiplying the Newton step by the root's multiplicity $m$" | The sentence is about the general method: it follows a general clause on "multiple roots" and names no case, so it takes the general wording. Same `check2.py` results for A. "started close enough" because the order result is local. Cases 2 and 4 are exactly quadratic (limits $1/6$, $1/9$) and keep their own wording | Yes |
| Case 4 | "Method A's advantage" | Only Method A's formula contains $m$ as an input (page lines 15–17) | Yes |
| Case 4 | "when the multiplicity $m$ is known, the scaled step gives at least quadratic convergence to a root of any order" | Error map above; `check.py` F2: limits $1/(3m)$ for $m = 2..6$; rate above 2 when $g'(r)=0$ | Yes |
| Case 4 | "from a close enough start" | `check.py`: $m=1$ from 1.4 has growing $|x_n|$ (1.4, 1.4136, 1.4501, …) | Yes |
| Case 4 | "Methods B and C do not need $m$" | B formula has no $m$, limits $-1/6$, $-1/9$; C selects 2, 3, 4 by itself | Yes |
| Case 5 | $x_{0,1} \approx -1.41$ | $-1.4136186$ | Yes |
| Case 5 | $x_{0,2} \approx -4.23$, larger $|f|$ | $-4.2272373$; $|f|$ 1.3385055 > 0.95511826 | Yes |

## Scripts and GIFs
- No script changed and no GIF regenerated. All three findings are text errors, and the review confirmed the animations match the computed values (R7-D, D7).
- `git status --short -- pages/numerical-methods/improved-newton-method` after the fix: ` M pages/numerical-methods/improved-newton-method/index.qmd` only.

## Legacy archive
Consulted `n2003/NewtonImprovedMod.html`, section "Limitations of Methods A and B" and the start of "Method C". It states that Method A needs the order $m$ a priori and that determining it is often laborious. It lists Method B's own disadvantage: it needs $f$, $f'$ and $f''$, and $u$ may have poles at zeros of $f'$ that are not roots of $f$. It introduces Method C with $m$ "not known a priori". The fixed Case 4 sentence agrees with this. Case 5 ($\arctan$) is not one of the module's examples, and the page does not claim it is.

## Notes
- At the coordinator's request, the two general sentences with the same imprecision as F3 (lines 19 and 26) now say "at least quadratically" and "at least quadratic"; line 26 also gained "started close enough". No finding names them; see the ledger. Check script: `/usr/bin/python3 /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r7fix/improved-newton-method/fix/check2.py`.
- The Case 2 and Case 4 headings, Behavior text and alt text still say "quadratic". They are about those specific functions, where the order is exactly 2 ($g'(1) \ne 0$, limits $1/6$ and $1/9$), so they are correct and unchanged.
- The review's suggested F2 wording was tightened as described under F2.

## Resolution check (independent checker, not shown this record)

Evidence script: `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r7fix/improved-newton-method/check/verify.py` (mpmath at 600 digits, sympy derivatives; run with `/usr/bin/python3`).

### Original findings

### F1 — resolved
- Evidence: line 82 now reads $x_{0,1} \approx -1.41$ and $x_{0,2} \approx -4.23$. By the page's definition ($x_{n,m} = x_n - m f(x_n)/f'(x_n)$) from $x_0 = 1.4$: $x_{0,1} = -1.4136186$, $x_{0,2} = -4.2272373$, with $|f| = 0.955$ and $1.339$, so "larger $|f|$" holds. For comparison, $x_{1,1} = +1.4501$ and $x_{1,2} = +4.3139$, so the old labels were wrong and the new ones are right. The surrounding argument still holds. On a log grid over $x \in [10^{-6}, 10^{6}]$ (1201 points, no violations) the $m=1$ step always lands on the other side of 0, and the $m=2$ trial always has larger $|f|$. Over 10 steps Method C picks $m = 1$ every time and matches Newton exactly, reaching $|x_{10}| = 2.9\times10^{17}$.

### F2 — resolved
- Evidence: lines 67–68 now credit Method A alone: "when the multiplicity $m$ is known, the scaled step gives at least quadratic convergence to a root of any order from a close enough start". A new line adds "Methods B and C do not need $m$". Measured orders for Method A with the correct $m$: 2.0 on $(x-1)^2(x+2)$, $(x-1)^3(x+2)$, $(x-1)^4 e^x$ and $(x-1)^5(x+3)$, and 3.0 on $\sin^2 x$ and $\sin^3 x$. So "at least quadratic" is the accurate wording. Method B's formula has no $m$ and reaches order 2.0 on the Case 4 function. Method C, with no $m$ given, also converges there from 1.3 (errors $8.8\times10^{-3}$, $8.6\times10^{-6}$, $8.3\times10^{-12}$, $7.6\times10^{-24}$, …).

### F3 — resolved
- Evidence: line 12 now says "at least quadratically if the root is simple". I reproduced the finding before judging the fix. Newton on $\arctan$ from 0.5 has measured order 3.0, while $x^2-2$ and $e^x-2$ have order 2.0. The fixer also changed lines 19 and 26 the same way; both are checked in the ledger below.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| l.12 | "at least quadratically if the root is simple" | Newton orders: arctan 3.0, $x^2-2$ 2.0, $e^x-2$ 2.0 | true |
| l.12 (unchanged half) | "only linearly if the root has multiplicity $m\ge2$" | error ratio 0.5 (double root), 0.666667 (triple root) $=(m-1)/m$ | true |
| l.19 | "Started close enough to a multiple root, Methods A and B converge to it at least quadratically" | A and B orders 2.0 at $m=2..5$, 3.0 on $\sin^2$, $\sin^3$; B's denominator $f'^2-ff'' \sim m e^{2m-2}h^2 \ne 0$ near the root | true |
| l.26 | "started close enough, Method A … restores at least quadratic convergence by multiplying the Newton step by … $m$" | same runs as l.19 | true |
| l.67 | "Method A's advantage: when $m$ is known, the scaled step gives at least quadratic convergence to a root of any order from a close enough start" | A orders ≥ 2 for $m = 1$ (Newton at a simple root) through 5 | true |
| l.68 | "Methods B and C do not need $m$" | B's formula has no $m$, order 2.0 on the Case 4 $f$; C converges on the Case 4 $f$ without $m$ | true |
| l.82 | $x_{0,1}\approx-1.41$ | $-1.4136186$ | true |
| l.82 | $x_{0,2}\approx-4.23$, larger $\lvert f\rvert$ | $-4.2272373$; $\lvert f\rvert$ 1.339 > 0.955 | true |
| context l.66 (unchanged) | iterates 1.3, 1.008824, 1.000009, $x_3$ within $10^{-11}$ | 1.008823529, 1.000008617, $\lvert x_3-1\rvert = 8.25\times10^{-12}$ | true |
| context l.79, 81 (unchanged) | $x_c\approx1.3917$; Method B iterates 0.6316, 0.1712, 0.00625, $3.25\times10^{-7}$ | $x_c = 1.3917452$; B iterates 0.6316, 0.1712, 0.006247, $3.25\times10^{-7}$, positive and decreasing | true |

### New problems
None. This rests on three things. Every changed sentence and number checks out (ledger above). The new "at least" wording is strictly more accurate than the old text: the $\sin^m$ and arctan runs show orders above 2. The changed sentences don't contradict the unchanged headings or Behavior lines that say "quadratic" for Cases 2 and 4, because on those functions the order is exactly 2 (measured 2.0).

### Reproducibility and conventions
- Only `index.qmd` changed in the page folder (`git status --porcelain` and fix.diff agree). No script or GIF changed, so there was nothing to regenerate or compare frames for. The committed GIFs are unchanged from HEAD.
- Conventions hold: `## Description` (l.10) comes before `## Animations` (l.21). There are 5 `[Julia source]` links and 5 GIF embeds, one per case, with descriptive alt text unchanged. There are no code fences, and the "(Planned)" stubs are untouched.
- Outside the page folder: fix.diff covers this page folder only. The working tree has other pages modified (see the branch's git status), but nothing in this page's diff touches them, so I can't attribute them to this fix. Whether this fixer touched files elsewhere can only be confirmed from the director's per-page staging.

**Final status:** committed
