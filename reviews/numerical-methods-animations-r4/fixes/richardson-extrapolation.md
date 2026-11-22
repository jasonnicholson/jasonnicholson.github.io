# Fix record: richardson-extrapolation

## Findings
### F1 — Minor (Fidelity) — fixed
- Reproduced: read `n2003/RichardsonExtrapMod.html` and its solution pages `Links/RichardsonExtrapMod_lnk_2..11.html` as text (each `lnk_N` is Example N−1), and viewed the surviving statement and solution images (stacked into `scratchpad/r4fix/richardson-extrapolation/fix/legacy/*.png` with `fix/stack.py`). The page's Animations intro accounted for Examples 8–10 only; nothing on the page mentions the truncation-error bound (`grep -n -i -E 'bound|M_5|f\^\{\(5\)\}' index.qmd` → no match before the fix). Checked every example of the module:
  - Ex 1: graph $f^{(5)}$, find $M_5=\max_{0\le x\le\pi}|f^{(5)}(x)|$ (statement image gr_34–38; the HTML text says "third derivative", but the formula images say $f^{(5)}$ and $M_5$; archive typo). Not on the page.
  - Ex 2: (a) table of $D_\text{five}(x,0.1)$, $D_\text{five}(x,0.01)$, $f'(x)$ at x = 0, 1, 2, 3; (b) plots of $D_\text{five}(x,0.01)$ and $f'$ on $[0,\pi]$ (solution images gr_65, gr_90, gr_93). Covered by Case 1: Mathews' $D_\text{five}(x,0.01)$ is the page's $D_5(x,0.02)$, and h = 0.02 is a Case 1 frame.
  - Ex 3: plot $|f'-D_\text{five}(x,0.01)|$ on $[0,\pi]$, compute $EB_\text{five}(0.01)$ and check $|\text{error}|\le EB$; aside on enlarging the interval to $[-2h,\pi+2h]$. Not on the page.
  - Ex 4: $EB_\text{five}(h/2)=EB_\text{five}(h)/16$ ($O(h^4)$), table of $EB_\text{five}$ for h = 0.08, 0.04, 0.02, 0.01, plot of the actual error for h = 0.02, 0.01 (image gr_117–138). Not on the page.
  - Ex 5: compare $EB_\text{three}$ with $EB_\text{five}$ (statement images gr_139–140). Not on the page. The review did not list Example 5 (it called 5–7 "numeric/symbolic"), but it is also a bound example and is wholly absent, so the sentence includes it (R3-B: check every example).
  - Ex 6: derivation of $D_\text{five}(x,h)=(4D_\text{three}(x,h)-D_\text{three}(x,2h))/3$ (gr_148): same content as the page's Derivation Notes.
  - Ex 7: $D_\text{three}(1,0.02)$, $D_\text{three}(1,0.01)$, extrapolation, $D_\text{five}(1,0.01)$, $f'(1)$ (gr_153–158): these are the page's Case 2 points at h = 0.02 and 0.01 (`richexab.jl` line 15 `hs` contains both).
  - Ex 8–10: already accounted for by the existing intro sentences.
- Computation behind the bound examples (`/usr/bin/python3 -I fix/check_f1.py`, mpmath 40 digits):
  - $f^{(5)}=-4\sqrt2\,e^{-x}\cos(x+\pi/4)$; $M_5=4$ at x = 0 on $[0,\pi]$; $f^{(3)}=2\sqrt2\,e^{-x}\sin(x+\pi/4)$, $M_3=2$.
  - $EB_\text{five}(h)=M_5h^4/30$: 5.4613e-6, 3.4133e-7, 2.1333e-8, 1.3333e-9 for h = 0.08, 0.04, 0.02, 0.01 (ratio exactly 1/16 per halving).
  - Actual error at x = 0: $|f'(0)-D_\text{five}(0,h)|$ = 2.1335365e-8 (h = 0.02), 1.3333651e-9 (h = 0.01), which are Mathews' printed 2.13354e-8 and 1.33336e-9. These are the horizontal lines in his Example 4 plot, and they are actual errors, not bounds. The review called them "bounds" and gave the second as 1.33e-8; it is 1.33e-9. Neither number goes on the page.
  - Ex 3: max actual error on $[0,\pi]$ at h = 0.01 is 1.3333651e-9 > $EB_\text{five}(0.01)$ = 1.3333333e-9, which is why Mathews adds the aside. With $M_5$ on $[-2h,\pi+2h]$ (4.16160 at x = −0.02), the bound is 1.3872e-9, which holds.
- Change: `index.qmd` line 33 (new, in the Animations intro after the Examples 8–10 sentence, before Case 1 per R3-D):
  "Nor are the module's truncation-error-bound examples: Examples 1, 3, 4 and 5 estimate $M_5=\max|f^{(5)}|$ on $[0,\pi]$ from a graph of $f^{(5)}$, check the resulting five-point error bound against the actual error, show the bound's $O(h^4)$ scaling, and compare it with the three-point bound; Case 1 annotates the actual maximum errors instead."
  This follows the review's suggested sentence with Example 5 added. I did not take the alternative (overlay the bound in Case 1): R2-A says to add one sentence, not the example.
- Check: re-read lines 30–33 in place. Each clause maps to one example in order (1: graph and $M_5$; 3: bound against actual error; 4: $O(h^4)$ scaling; 5: compared with three-point bound). Case 1's annotation is `@sprintf("max|error D3| ≈ %.2e   max|error D5| ≈ %.2e", …)` (`richexaa.jl` l.55). Frame 9 of the committed `richexaa.gif` shows "max|error D3| ≈ 3.33e-05   max|error D5| ≈ 8.33e-11". No bound is drawn in Case 1 or Case 2 (Case 2's guides are slope-2/slope-4 lines anchored at h = 0.5).

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd l.33 | "Examples 1, 3, 4 and 5" are the truncation-error-bound examples | Text of lnk_2, lnk_4, lnk_5, lnk_6 plus statement images (`fix/legacy/lnk2_3stmt.png`, `lnk5.png`, `ex5_6_7stmt.png`): each works with $M_5$/$EB_\text{five}$ (Ex 5 also $EB_\text{three}$). Examples 2, 6, 7 have no bound (gr_57–64, gr_148, gr_153–158) | yes |
| index.qmd l.33 | "estimate $M_5=\max\|f^{(5)}\|$ on $[0,\pi]$ from a graph of $f^{(5)}$" (Ex 1) | gr_34–38: "f⁽⁵⁾[x]", "M₅ = max_{0≤x≤π} \|f⁽⁵⁾[x]\|"; HTML: "Look at its graph and estimate the value". check_f1.py: M5 = 4 at x = 0 (not on the page) | yes |
| index.qmd l.33 | "check the resulting five-point error bound against the actual error" (Ex 3) | gr_95–99: "\|f'[x] − D_five[x,0.01]\|", "EB_five[0.01]", "\|f'[x]−D_five[x,0.01]\| ≤ EB_five[0.01]" on [0,π] | yes |
| index.qmd l.33 | "show the bound's $O(h^4)$ scaling" (Ex 4) | lnk5.png: "EB_five[h/2] == 1/16 EB_five[h]" → True, "O(h⁴)"; check_f1.py EB ratios exactly 1/16 | yes |
| index.qmd l.33 | "compare it with the three-point bound" (Ex 5) | gr_139–140: "EB_three[0.01] or EB_five[0.01]", "EB_three[0.01] or EB_five[0.1]" | yes |
| index.qmd l.33 | "Case 1 annotates the actual maximum errors instead" | richexaa.jl l.28–29, 55 (max over an 800-point grid of \|D−f'\| on [0,π]); frame_009.png shows both annotations. Review table: labels match 50-digit maxima to 3 digits | yes |
| index.qmd l.33 | "not animated" (Nor are…) for 1, 3, 4, 5 | `grep -n -i -E 'bound\|M_5\|f\^\{\(5\)\}'` on the old page → no match; no script draws a bound | yes |

No numbers were added to the page.

## Scripts and GIFs
- No scripts changed, no GIFs regenerated (text-only fix).
- Frames of the committed `richexaa.gif` were extracted to `scratchpad/r4fix/richardson-extrapolation/fix/frames_aa/` (9 frames), and frame 9 was viewed to confirm the max-error annotation cited by the new sentence.
- `git status --short -- pages/numerical-methods/richardson-extrapolation` → ` M pages/numerical-methods/richardson-extrapolation/index.qmd` only.

## Legacy archive
Consulted: `n2003/RichardsonExtrapMod.html` and `richardsonextrap/RichardsonExtrapMod/Links/RichardsonExtrapMod_lnk_1..11.html`. Images gr_39–56 and gr_100–112 are missing from the archive (Example 1's solution graphs and Example 3's solution plot), so the content of Examples 1 and 3 was taken from their statement images and HTML text. Example 2's solution graphs and Example 4's solution plot survive. The archive has one typo: Example 1's HTML text says "third derivative" while its formula images say $f^{(5)}$ and $M_5$. The images agree with the five-point remainder, so the page follows them. No other difference: the page now states that the bound examples are omitted, and it does not reproduce them.

## Notes
- Two corrections to the review's own detail, neither affecting the page: (1) the 2.13e-8 and 1.33e-9 values in Mathews' Example 4 plot are actual errors at x = 0, not bounds, and the second is 1.33e-9, not 1.33e-8; (2) Example 5 is a bound example too and is now included in the omitted list.
- Notation: Mathews' $D_\text{five}(x,h)$ uses spacing h, and the page's $D_5(x,h)$ uses spacing h/2 (already stated in the intro). The new sentence quotes no h-dependent number, so no conversion is needed.
- Pre-existing conventions were not touched.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: the diff adds one sentence to the Animations intro, before Case 1 (as R2-A and R3-D require): "Nor are the module's truncation-error-bound examples: Examples 1, 3, 4 and 5 estimate $M_5=\max|f^{(5)}|$ on $[0,\pi]$ from a graph of $f^{(5)}$, check the resulting five-point error bound against the actual error, show the bound's $O(h^4)$ scaling, and compare it with the three-point bound; Case 1 annotates the actual maximum errors instead."
- I checked it against the archive's formula images. Images 39–56, 100–112 and 141–147 (the solutions to Examples 1, 3 and 5) are missing from the archive, so for those I used the problem statements. I stacked them in `check/legacy/*.png`.
  - Ex 1 (gr_34–38): $f=e^{-x}\sin x$; graph $f^{(5)}$; $M_5=\max_{0\le x\le\pi}|f^{(5)}(x)|$. The prose says "third derivative", but the formulas say $f^{(5)}$. The sentence matches the formulas.
  - Ex 3 (gr_95–99): plot $|f'-D_\text{five}(x,0.01)|$ on $[0,\pi]$, compute $EB_\text{five}(0.01)$, and check $|f'-D_\text{five}|\le EB_\text{five}$. This matches "check the resulting five-point error bound against the actual error".
  - Ex 4 (gr_113–138): $EB_\text{five}(h/2)=EB_\text{five}(h)/16$, the "O(h^4)" table for h = 0.08…0.01, and a plot of the actual errors against the bounds. This matches "show the bound's $O(h^4)$ scaling".
  - Ex 5 (gr_139–140): which is smaller, $EB_\text{three}(0.01)$ or $EB_\text{five}(0.01)$, and $EB_\text{three}(0.01)$ or $EB_\text{five}(0.1)$. This matches "compare it with the three-point bound".
- Case 1 (`richexaa.jl`, lines 55–59) annotates "max|error D3| ≈ … max|error D5| ≈ …" on every frame, so "Case 1 annotates the actual maximum errors instead" is true.
- The sentence writes no $EB$ formula in $h$. That avoids a clash of notation: Mathews' $D_\text{five}(x,h)$ has spacing $h$, while the page's $D_5(x,h)$ has spacing $h/2$. Had the review's suggested formula $EB_\text{five}(h)=M_5h^4/30$ been written next to the page's $D_5(x,h)$, it would have been off by a factor of 16.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd Animations intro, line 33 | "Examples 1, 3, 4 and 5" are the truncation-error-bound examples | Read all 10 archive examples (main page plus lnk_2–lnk_11 problem statements). Ex 1, 3, 4 and 5 are the only ones about $M_5$ or $EB$. Ex 2 is $D_\text{five}$ values and a profile (Case 1). Ex 6 is the Richardson identity (Description and Derivation Notes). Ex 7 is $D_\text{five}(1,0.01)$, which is the page's $D_5(1,0.02)$; h = 0.02 is in `richexab.jl` `hs`, so it is a Case 2 point. Ex 8 is Case 2. Ex 9–10 are already stated as not animated. | correct |
| same | $M_5=\max\lvert f^{(5)}\rvert$ on $[0,\pi]$ | sympy: $f^{(5)}=-4\sqrt2 e^{-x}\cos(x+\pi/4)$. Max of the absolute value on [0,π] is 4.000 at x = 0. This matches Mathews' $EB_\text{five}(h)=2h^4/15=M_5h^4/30$ with $M_5=4$, and matches gr_37 (interval $0\le x\le\pi$). | correct |
| same | "from a graph of $f^{(5)}$" | Ex 1 says: "Graph $f^{(5)}[x]$ … Look at its graph and estimate the value $M_5$". | correct |
| same | "check the resulting five-point error bound against the actual error" | Ex 3 statement. mpmath (40 digits): max actual error of $D_\text{five}$ on [0,π] is 2.13354e-8 for h = 0.02 and 1.33337e-9 for h = 0.01. The bounds are 2.13333e-8 and 1.33333e-9. Both maxima are at x = 0 and exceed the bound by a hair; this is Mathews' "aside" about the enlarged interval. The sentence says "check" and does not claim the bound holds, so it stays true. | correct |
| same | "the bound's $O(h^4)$ scaling" | Ex 4: $EB_\text{five}(h)$ = 5.4613e-6, 3.4133e-7, 2.1333e-8, 1.3333e-9 for h = 0.08, 0.04, 0.02, 0.01. Recomputed exactly; each halving gives a ratio of 16. | correct |
| same | "compare it with the three-point bound" | Ex 5. $M_3=2$ (computed), so $EB_\text{three}(0.01)$ = 3.33e-5. $EB_\text{five}(0.01)$ = 1.33e-9 and $EB_\text{five}(0.1)$ = 1.33e-5. | correct |
| same | "Case 1 annotates the actual maximum errors instead" | `richexaa.jl` annotate! of err3 and err5, the maxima over [0,π]. | correct |

### New problems
None. This rests on the following:
- The only change is one added sentence; scripts and GIFs are untouched.
- Every clause and implied number was recomputed (sympy and mpmath) or matched to the archive's formula images.
- The sentence was checked against all ten archive examples, and every example is now accounted for, animated or not. Ex 6 and 7 are not named in the intro, but they are on the page: Ex 6 in the Description and Derivation Notes, Ex 7 as a Case 2 point. The finding called them numeric or symbolic and not a gap.
- The new sentence sits in the Animations intro, after the Examples 9–10 sentence and before Case 1, per R3-D. "Nor are…" reads correctly after "…are not animated here, and neither are…".

### Reproducibility and conventions
- Only `pages/numerical-methods/richardson-extrapolation/index.qmd` changed in the page folder (`git diff HEAD --name-only -- .`). The fix changed no scripts or GIFs, so there was nothing to regenerate. The other modified files in the working tree belong to other pages' fixes, not to this diff.
- The conventions still hold:
  - Description comes before Animations.
  - Each case has a source link and an embed.
  - The alt text is unchanged and descriptive.
  - There are no code blocks.
  - The new LaTeX ($M_5=\max|f^{(5)}|$, $[0,\pi]$, $O(h^4)$) is well-formed.

**Final status:** committed
