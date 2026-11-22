# Fix record: pade-approximation

Scratch folder (all evidence, re-runnable): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r3fix/pade-approximation/fix/`

## Findings

### F1 — Minor — fixed
- **Reproduced:** by reading `index.qmd`, and by checking the claims before rewriting them.
  - Line 12 had "rationale" 3 times. Line 20 had "for give $m$ and $n$". Line 24 read "Total orders … of less than 20 fail at times for MATLAB's symbolic `pade` function fails", which has two verbs.
  - **The derivative statement** (line 20) is correct once the typo is fixed. `deriv_match.py` (sympy, exact Baker [m/n]) gives f^(k)(x0) − R^(k)(x0) = 0 for k = 0…m+n in all four test entries: √x about 1 [2/3], eˣ about 0 [2/2], log x about 2 [3/2] and Γ about 2 [1/2]. At k = m+n+1 the difference is non-zero (−0.4922, 0.1667, −0.01875, −3.171). The review's 1,465-frame check (D5/D6) supports the same statement.
  - **The MATLAB claim** (line 24) was not reproduced as a failure. MATLAB R2026a (26.1.0.3346908, Update 5) is installed, so I ran it:
    - `matlab_pade_check.m` used exact symbolic `pade(f,x,x0,'Order',[m n])` on every [m/n] with 1 ≤ m+n ≤ 19, for sin, cos, tanh, atan and exp about 0, √x about 1, and log(1+x) about 0. Result: errors = 0 and NaN = 0 for all 7 functions.
    - `matlab_pade_vpa_check.m` reproduced the video script's "sym" branch (`digits(20); func = vpa(func(vpa(1.0)*x))`) for eˣ about 0. All 173 entries through total 17, plus the first entries of total 18, ran with no error (log in `vpa_log_case1_partial.txt`). Some entries with small m and large n were slow: [1/14] 1.7 s, [1/15] 7.2 s, [2/15] 8.6 s, [1/16] 30.8 s, [1/17] 133.9 s. [0/17] and [17/0] took 0.0 s. I stopped the run at [1/18] because each step in n was multiplying the time by about 4.
    - `matlab_pade_vpa_diag.m` ran [10/9] (total 19) in the same vpa setting for all 13 video cases. Every case returned ok in ≤ 2.2 s, and R(x0+0.1) equals f(x0+0.1) to the 15 digits printed (`vpa_diag_log.txt`).
    - So I could not confirm "fails below total order 20". The slowness is confirmed.
- **Change:** `index.qmd`
  - Line 12: "rationale" → "rational" (3×).
  - Line 20: "This really means derivatives match for give $m$ and $n$." → "Equivalently, $f^{(k)}(x_0)=R_{m,n}^{(k)}(x_0)$ for $k=0,\dots,m+n$."
  - Line 24: the garbled MATLAB sentence → "MATLAB's symbolic `pade` can be very slow for some entries below total order (numerator plus denominator order) 20: with the 20-digit `vpa` setting of the video script, the $[1/15]$, $[1/16]$ and $[1/17]$ entries for $e^x$ about 0 took about 7, 31 and 134 seconds in MATLAB R2026a."
- **Check:**
  - `grep -n -i 'rationale\|for give' index.qmd` → no matches.
  - The numbers in the new sentences are from the runs above (see the ledger).
  - The first draft said "slows sharply as the order rises". I dropped it because [10/9] took 0.1 s and [0/17] took 0.0 s, so the slowdown is not uniform in the order.

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd l.12 | "rational function approximation", "is a rational function", "Rational functions can have singularities/vertical-asymptotes and horizontal asymptotes" | Spelling fix only. The claim was confirmed by review D1/D3. | yes |
| index.qmd l.20 | "$f^{(k)}(x_0)=R_{m,n}^{(k)}(x_0)$ for $k=0,\dots,m+n$" | `/usr/bin/python3 -I deriv_match.py` → max \|diff\| = 0 for k = 0…m+n in 4 entries, non-zero at k = m+n+1. This is equivalent to the preceding sentence (Taylor coefficient k = f^(k)/k!). It applies to the non-degenerate entries, and the page's next sentence covers the degenerate ones. | yes |
| index.qmd l.24 | "can be very slow for some entries below total order … 20" | `matlab -batch matlab_pade_vpa_check` → [1/17] 133.9 s, with no errors through total 17. `matlab_pade_vpa_diag` → [10/9] ≤ 2.2 s in all 13 cases. "Some entries" is therefore the right quantifier. | yes |
| index.qmd l.24 | "20-digit `vpa` setting of the video script" | `pade_animation_code.m` "sym" branch: `digits(20); func = vpa(func(vpa(1.0)*x));`. This is the default `approach = "sym"`. | yes |
| index.qmd l.24 | "[1/15], [1/16], [1/17] … about 7, 31 and 134 seconds" | `vpa_log_case1_partial.txt` → 7.2 s, 30.8 s, 133.9 s. The timings are from one run on this machine and include a trivial `subs`/`double` evaluation. | yes (single run; "about") |
| index.qmd l.24 | "MATLAB R2026a" | `matlab -batch "disp(version)"` → 26.1.0.3346908 (R2026a) Update 5 | yes |

## Scripts and GIFs
- No scripts were changed and no GIFs were regenerated. The fix is text-only.
- `git status --short -- pages/numerical-methods/pade-approximation` → ` M pages/numerical-methods/pade-approximation/index.qmd` only.

## Legacy archive
- I consulted `n2003/PadeApproximationMod.html` (tags stripped). It shows the Padé theorem and links to the animations, and nothing in it bears on F1's wording.
- The review had already found that all 27 legacy animation rows match the page's cases.
- No fidelity change was needed.

## Notes
- **The MATLAB claim needs Jason's decision.** The original sentence said MATLAB's `pade` "fails at times" below total order 20. On R2026a, both the exact and the vpa set-ups produced no error for any entry I tested below 20. Coverage: all entries up to total 19 for 7 exact-symbolic functions, all entries through total 17 for eˣ about 0 (vpa), and [10/9] for all 13 video cases (vpa). I therefore replaced it with what I could measure, which is that some entries are slow. If Jason has a specific case that fails, for example on R2025b or with a function not tested here, he may want to restore a failure claim that names that case.
- **Small errors in the same Description that F1 did not list, left untouched:**
  - "Padé approximant's can converge" (stray apostrophe).
  - "Padé approximate" (should be "approximant"), in line 24's last sentence and line 30.
  - "Pade's approximate" (line 30).
- **Unchecked sentence:** "`padeapprox` from chebfun also struggles" was not checked, because Chebfun was not run.
- **Scratch mishap:** a `pkill -f matlab_pade_vpa_check` killed its own shell, because its own command line contained the pattern. This changed nothing in the repository.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence:
  - "rationale" no longer appears on the page (grep of index.qmd finds 0 matches). All three places now read "rational".
  - "for give $m$ and $n$" is replaced by "Equivalently, $f^{(k)}(x_0)=R_{m,n}^{(k)}(x_0)$ for $k=0,\dots,m+n$". This is true. A sympy check of e^x [2/2] about 0, sqrt(x) [2/3] about 5 and atan(x) [3/2] about 1/2 gives f^(k)−R^(k) = 0 at x0 for k ≤ m+n, and a nonzero value at k = m+n+1 (1/6, −63√5/2e6, −6684672/546875). The sentence comes before the page's existing caveat about degenerate entries, so it is not overstated.
  - The garbled "fail … fails" sentence is now one definite claim, and I measured it to be true (see ledger). It now says MATLAB's `pade` is *slow*, where the old sentence said it *fails*. The old claim of failure is gone rather than corrected, which is acceptable: the new claim is measured, and the old one could not be parsed.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| l.12 | "rational function approximation", "is a rational function", "Rational functions can have…" | Correct term. | OK |
| l.20 | "Equivalently, $f^{(k)}(x_0)=R_{m,n}^{(k)}(x_0)$ for $k=0,\dots,m+n$" | Sympy derivative check on 3 functions (above). Matching the Taylor expansion through order m+n is the same as matching derivatives 0…m+n. | OK |
| l.24 | "MATLAB's symbolic `pade` can be very slow for some entries below total order (numerator plus denominator order) 20" | [1/15], [1/16] and [1/17] have total orders 16, 17 and 18, all below 20. "Some" is right: [0/15] took 0.02 s, [1/10] 0.03 s and [2/15] 8.7 s. | OK |
| l.24 | "with the 20-digit `vpa` setting of the video script" | pade_animation_code.m sets `digits(20)` and `func = vpa(func(vpa(1.0)*x))` before calling `pade(func, x, expansionPoint, 'order', order)`. I reproduced this exactly. | OK |
| l.24 | "[1/15], [1/16] and [1/17] entries for $e^x$ about 0 took about 7, 31 and 134 seconds in MATLAB R2026a" | I re-measured with `matlab -batch` on R2026a (26.1.0.3346908 Update 5): [1/15] 7.18 s, [1/16] 31.04 s, [1/17] 137.95 s. Each result is a correct approximant: R − e^x at x = 0.01 is about 1e-23. | OK. The numbers reproduce (134 against 138 s is within "about"). |

Hedging: the sentence says "about", names the release, and words the claim as "can be very slow" for "some entries". For timings that depend on the machine, that is enough. Adding "on one machine" would be optional and is not a defect.

### New problems
None. This rests on:
- the derivative check;
- the three MATLAB re-measurements;
- the code-path match with pade_animation_code.m;
- grep showing no leftover "rationale", "for give" or "fails".

Older wording outside the scope of F1 is unchanged and was not introduced by this fix: "Padé approximant's", "approximate" for "approximant", and "Pade's approximate".

### Reproducibility and conventions
- No script or GIF changed (the fix diff touches only index.qmd text), so there was nothing to regenerate.
- Page structure is unchanged:
  - Description comes before Animations;
  - the case headings, embeds and source links are untouched;
  - index.qmd has 0 code fences.
- Outside the page folder, the only changes are review bookkeeping: reviews/numerical-methods-animations-r3/fix-plan/worklist.md (modified) and reviews/.../fixes/pade-approximation.md (new). No site or content file outside the page changed.
- MATLAB was run only from the scratch check folder, using padetime.m and padetime17.m. Both batch sessions exited. The only MATLAB process left running is the pre-existing MATLABConnector service host.

**Final status:** committed
