# Fix record: numerical-differentiation

## Findings

### F1 — Minor (Fidelity) — fixed
- **Reproduced:** I listed every Example in the archive module:
  - `grep -n -E 'Example|Exploration|Project' /home/jason/Desktop/math-fullerton/baseline/mathews/n2003/NumericalDiffMod.html`
  - I stripped the module to text (`scratch/.../fix/mod.txt`, 315 lines) and read every solution page `Links/NumericalDiffMod_lnk_2..7,15,18.html`.
  - I viewed the statement images gr_20–31, 44–51, 91–98, 118–121, 262–263, 325–329, 52–53 in the montages `scratch/.../fix/proj1_imgs.png` and `scratch/.../fix/ex11_14.png`.

  The link-to-example map is: Ex 1 → lnk_2; Ex 2(a), 2(b), 2(c) → lnk_3, 4, 5; Ex 3 → lnk_6; Ex 4 → lnk_7; Ex 5 → lnk_8; Ex 6(a), 6(b) → lnk_9, 10; Ex 7 → lnk_11; Ex 8 → lnk_12; Ex 9–17 → lnk_13–21. The module has Examples 1–17 and no Explorations.
  - **Ex 1:** find and graph $f'''$ for $f=e^{-x}\sin x$, and find $M_3=\max_{[0,\pi]}|f'''|$ (gr_27–31).
  - **Ex 2(a):** $f'(0)$ with $h=0.1, 0.01, 0.001$ (gr_44–45).
  - **Ex 2(b):** $f'(0), f'(1), f'(2), f'(3)$ with the same steps (gr_46–47).
  - **Ex 2(c):** plot $D1(x,0.01)$ on $[0,\pi]$ and compare it with $f'$ (gr_48–51).
  - **Ex 3:** plot $|f'(x)-D1(x,0.01)|$ on $[0,\pi]$ against $EB1(0.01)$; the maximum is at $x=0$ (gr_91–98).
  - **Ex 4:** behaviour of $EB1(h)$: a table for $h=0.08$ down to $0.01$, with $O(h^2)$ behaviour (lnk_7).
  - **Ex 5–8:** Project II, second derivative.
  - **Ex 9, 10, 12, 13:** forward and backward first-derivative formulas.
  - **Ex 11, 14:** central first derivative at $x=1$.
  - **Ex 15–17:** second-derivative formulas.

  None of the solution pages for Ex 1, 2(a), 2(b), 3 or 4 contains an animation. The page's Case 1 frames (contact sheet `scratch/.../fix/aa/sheet.png`, 12 frames) show only $f'$ and $D_3(x,h)$, with no $f'''$ graph, error curve, bound or table. So the old sentence omitted Examples 1, 2(a), 2(b), 3 and 4. The finding holds.
- **Change:** `index.qmd`, line 26 (Animations intro, before Case 1, as R3-D requires). The old sentence listed only Ex 9, 10, 12, 13 and the second-derivative material. It is replaced by two sentences:
  - The first says which examples the cases follow: Case 1 extends Ex 2(c) from $h=0.01$ to a sweep of steps, and Case 2 follows Ex 11 and 14 at $x_0=1$.
  - The second lists "the module's other examples" as not animated: Project I Ex 1, 2(a)/(b), 3 and 4, then Ex 9, 10, 12 and 13, then Project II Ex 5–8 and Ex 15–17.

  The omitted examples are named by kind, and the sentence quotes no computed values.
- **Check:** Every one of Examples 1–17 is now accounted for exactly once:
  - animated: 2(c), 11 and 14;
  - listed as not animated: 1, 2(a), 2(b), 3, 4, 5–8, 9, 10, 12, 13 and 15–17.

  The membership of each example was read from the statement text and images above. The quantifier is "other examples", not "other items", because the module's theorems, proofs, program links and old lab project are not examples.

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd l.26 | "Case 1 extends Example 2(c) … the plot of $D_3(x,h)$ against $f'(x)$ on $[0,\pi]$" | gr_48–51: "Plot D1[x, 0.01] over [0, π], compare with f'[x] over [0, π]". The page's $D_3$ is Mathews' D1 (gr_23: `D1[x_,h_] = (f[x+h]-f[x-h])/(2h)`). numdiffaa.jl has `xlims = (0.0, pi)` and `central3`. | yes |
| index.qmd l.26 | "from the single step $h=0.01$ to a sequence of steps" | gr_48 gives `D1[x, 0.01]`. numdiffaa.jl `hs` = [0.5 … 0.01 … 0.001], 12 values. The frame tool on numdiffaa.gif gives 12 frames, and frame 9's title is "h = 0.01, max error ≈ 3.33e-05". | yes |
| index.qmd l.26 | "Case 2 follows Examples 11 and 14, the central difference at $x_0=1$" | gr_262–263 (Ex 11) and gr_325–327 (Ex 14) both give $f=e^{-x}\sin x$ and $f'[1.0]$. The Ex 14 code (gr_327) is `m=(f[X+H]-f[X-H])/(2H)` with X=1.0. The Ex 11 code images are absent, but the two legacy GIFs (CentralD1faa.gif and CentralDfaa.gif) print identical slopes. `python3 -I scratch/.../fix/check.py` shows that all 9 legacy values (h = 1.0 … 0.001) equal $D_3(1,h)$ to 6 dp. numdiffab.jl has `x0 = 1.0` and `msec = (yr-yl)/(2h)`. | yes |
| index.qmd l.26 | "the graph of $f'''$ used to bound the error (Example 1)" | gr_27–31: f = e^{-x} Sin x, f⁽³⁾[x], graph, M₃ = max_{0≤x≤π}\|f⁽³⁾\|. gr_21 gives EB1[h] ≤ M₃h²/6. | yes |
| index.qmd l.26 | "the tables of approximations (Examples 2(a) and 2(b))" | lnk_3 and lnk_4 text: "Compute numerical approximations … using step sizes h = 0.1, 0.01, 0.001"; lnk_4: "Where are the best approximations in this table". | yes |
| index.qmd l.26 | "the plot of the absolute error against the error bound (Example 3)" | gr_91–98: plot \|f'[x] − D1[x,0.01]\| on [0,π]; EB1[0.01]; \|f'−D1\| ≤ EB1[0.01]. | yes |
| index.qmd l.26 | "the study of how the bound shrinks with $h$ (Example 4)" | lnk_7: "Investigate the behavior of EB1[h]"; the table for h = 0.08, 0.04, 0.02, 0.01 is 0.00213, 0.000533, 0.000133, 0.0000333; halving h gives a factor of 1/4, i.e. O(h²) (gr_118–121). | yes |
| index.qmd l.26 | "(Examples 9, 10, 12 and 13)", "(Project II, Examples 5–8, and Examples 15–17)" | These are unchanged from the old sentence; I re-checked them against mod.txt ll.135–270: Ex 9/10 are two-point forward/backward, Ex 12/13 three-point forward/backward, Ex 5–8 Project II second derivative, and Ex 15–17 second derivative. | yes |
| index.qmd l.26 | "The module's other examples are not animated here" | Complete: the module has Examples 1–17, all of which are named above. The page's two GIFs (contact sheets aa/ and ab/) show only the $D_3$ profile and the $x_0=1$ secant/tangent. | yes |

## Scripts and GIFs
- No scripts were changed and no GIFs regenerated. The fix is text-only.
- I extracted both committed GIFs to `scratch/.../fix/aa` and `scratch/.../fix/ab` to confirm what the cases show and do not show.
- `git status --short -- pages/numerical-methods/numerical-differentiation` gives only ` M pages/numerical-methods/numerical-differentiation/index.qmd`.

## Legacy archive
- **Consulted.** The main module is `n2003/NumericalDiffMod.html`; its solution pages and images are under `n2003/differentiation/NumericalDiffMod/`.
- **Legacy GIFs.** The review says the legacy GIFs are absent, but they are present at `/home/jason/Desktop/math-fullerton/baseline/mathews/a2001/Animations/Derivative/CentralD2.1f/CentralD1faa.gif` and `.../CentralD2.2f/CentralDfaa.gif`, 38 frames each.
  - Both show $f(x)=e^{-x}\sin x$ on $[0,2.1]$ at $x_0=1$, with h = 1.0, 0.8, 0.6, 0.4, 0.2, 0.08, 0.04, 0.008, 0.001.
  - CentralDfaa draws the chord through $x_0\pm h$, as the page's Case 2 does. CentralD1faa draws the slope-$m$ line through $(x_0,f(x_0))$ together with the interpolating parabola.
  - Their printed slopes equal $D_3(1,h)$ (check.py above).
  - The page's Case 2 uses a different h list and the window $[0,\pi]$. This is immaterial and was not part of any finding, so it was left alone.
- **Archive inconsistency.** The Example 2(a) statement asks for $f'(0)$ (gr_44), but its solution code sets `X = 1.0` (gr_52). The page quotes no Example 2 values, so this has no effect.

## Notes
- **Review suggestion not used.** The review suggested also saying "Case 1 reports only the maximum error in its title". I did not add it, because the R3-D sentence is a statement about the source and the finding is fully resolved by completing the list. Case 1's titles do report "max error ≈ …" for each h (contact sheet).
- **Convention gaps.** None were noted beyond those already present. The page has Description, Animations and Derivation Notes sections.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: The fix rewrites `index.qmd` line 26 only (diff: one changed line; no script or GIF changed). I re-inventoried the archive module `n2003/NumericalDiffMod.html` from its text, all 21 link pages `differentiation/NumericalDiffMod/Links/NumericalDiffMod_lnk_{1..21}.html`, and the formula and solution images that survive. The module's worked content is: Project I (Examples 1, 2(a), 2(b), 2(c), 3 with 3(a) and 3(b), and 4), Project II (Examples 5, 6(a), 6(b), 7 and 8), and the "Various Scenarios" Examples 9–17. The rest is two theorems, two "Aside" limit remarks, links to animations, programs, the bibliography and an external "Old Lab Project" (`df.htm`, not in the archive). None of these is an example.
- Every example is now accounted for by the new sentence:
  - **Shown:** 2(c) by Case 1; 11 and 14 by Case 2.
  - **Not animated:** 1, 2(a), 2(b), 3 and 4 (Project I); 9, 10, 12 and 13 (forward and backward differences for the first derivative); 5–8 (Project II); 15–17 (second derivative).
  - The second-derivative group lists both "Project II, Examples 5–8" and "Examples 15–17".
  - No example is missing or listed twice. The false implication that the finding reported (that Project I was covered) is gone.
- The descriptions are accurate:
  - **Example 1:** graphs f''' and finds M3 = 2, giving EB1[h] = h²/3 (gr_32–43).
  - **Example 2(a):** f'(1) at h = 0.1, 0.01, 0.001, with the details, plus an h = 1e-12 aside (gr_52–82). The problem image says f'[0], but the solution computes at X = 1.0, an inconsistency in Mathews.
  - **Example 2(b):** "Where are the best approximations in this table".
  - **Example 3:** plots |f'(x) − D1[x,0.01]| on [0,π]. Part 3(a) gives the bound EB1[0.01] and the inequality |f' − D1| ≤ EB1; part 3(b) notes that the maximum is at x = 0.
  - **Example 4:** behaviour of EB1[h] under halving, with the table h = 0.08…0.01 and graphs.
- The Case 1 claim matches Example 2(c) (gr_48–51, gr_85–90): D1[x,0.01] is plotted on [0,π] against f'(x). The script's h-sequence includes 0.01, so "from the single step h=0.01 to a sequence of steps" is true. The Case 2 claim matches Examples 11 and 14: f = e^{-x} sin x, f'(1.0), central difference (gr_262–263, gr_325–345).
- No script or GIF change was needed or made, so the script and GIF parts of the check do not apply.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd l.26 | "Case 1 extends Example 2(c) … the plot of $D_3(x,h)$ against $f'(x)$ on $[0,\pi]$" | gr_48–51: Plot D1[x,0.01] over [0,π] and compare with f'(x); solution gr_85–90 is two plots on [0,π]. Mathews calls it D1. The page uses its own name D_3 for the identical formula (defined at l.17, matching gr_20). | correct (notation is the page's own) |
| l.26 | "from the single step $h=0.01$ to a sequence of steps" | gr_48 shows h = 0.01. `numdiffaa.jl` hs = 0.5…0.001, which includes 0.01. | correct |
| l.26 | "Case 2 follows Examples 11 and 14, the central difference at $x_0=1$" | gr_262/263 and gr_325/326: f = e^{-x} sin x, f'[1.0]. Ex 11 uses "two points, central"; Ex 14 uses "three points, central" (gr_327: m = (f[X+H]−f[X−H])/(2H), X = 1.0). Both are the same formula. My 40-digit run reproduces Mathews' printed values: f'(1) = −0.110793765307; D(1,h) for h = 0.5, 0.2, 0.1, 0.05, 0.02, 0.01 = −0.0682151, −0.104010, −0.109099, −0.110370, −0.110726, −0.110777. These match gr_330–345. | correct |
| l.26 | "the graph of $f'''$ used to bound the error (Example 1)" | gr_34–43: plot of f''' on [0,π]; M3 = 2; EB1[h] = h²/3. mpmath: max \|f'''\| on [0,π] = 2.0 at x = 0; f'''(π) = −0.0864278. | correct |
| l.26 | "the tables of approximations (Examples 2(a) and 2(b))" | 2(b) is a table (lnk_4 text). 2(a) is a printed list of three approximations with intermediate steps (gr_53–71), so "tables" is loose for 2(a) but not misleading. | correct (slightly loose) |
| l.26 | "the plot of the absolute error against the error bound (Example 3)" | lnk_6: plot \|f' − D1[x,0.01]\| on [0,π], then 3(a) EB1[0.01] with \|f' − D1\| ≤ EB1[0.01]. mpmath: max error 3.3333e-5 at x = 0, bound h²/3 = 3.33333e-5. Solution images gr_99–117 are missing from the archive; the claim rests on the problem text. | correct |
| l.26 | "the study of how the bound shrinks with $h$ (Example 4)" | lnk_7: EB1[h] table at h = 0.08, 0.04, 0.02, 0.01 = 0.0021333, 0.0005333, 0.0001333, 0.0000333 (mpmath agrees exactly, 2h²/6), plus "O(h²) behaviour" graphs. | correct |
| l.26 | "the forward- and backward-difference formulas for the first derivative (Examples 9, 10, 12 and 13)" | Text: 9 two-point forward, 10 two-point backward, 12 three-point forward, 13 three-point backward, all for f'(1.0). | correct (unchanged from before) |
| l.26 | "the formulas for the second derivative (Project II, Examples 5–8, and Examples 15–17)" | Project II = Examples 5–8 (f^{(4)}, D2 approximations, error, EB2 table). Examples 15–17 are the forward, backward and central second derivative. | correct (unchanged from before) |
| l.26 | completeness: "The module's other examples are not animated here" | Union of the covered and the listed examples = {1, 2(a), 2(b), 2(c), 3, 4, 5, 6(a), 6(b), 7, 8, 9, …, 17}, the full set. The two "Aside" limit remarks and the theorems are not examples. | correct |

### New problems
None. This rests on:
- the full example inventory above, from the module text and all 21 link pages;
- the image checks of 2(c), 11 and 14;
- 40-digit reproduction of every number Mathews prints that the sentence relies on (M3, EB1 table, error maximum at x = 0, D(1,h) sequence).

Two observations, neither a defect:
- The page calls Mathews' D1[x,h] $D_3(x,h)$. This is consistent with the page's own definition at l.17, but a reader comparing with the module will see D1.
- Example 2(a) is a printed list of three approximations rather than a table.

### Reproducibility and conventions
- **Scripts and GIFs:** none changed. `git status` of the page folder shows only `index.qmd` modified; `numdiffaa.jl`, `numdiffab.jl` and both GIFs equal HEAD. There was nothing to regenerate.
- **Files outside the page folder:** the fix diff for this page lists only `index.qmd`. The other working-tree modifications in the repo belong to other pages' slugs and are not part of this fix.
- **Conventions are kept:**
  - Description (l.10) comes before Animations (l.22).
  - The "not animated" sentence sits in the Animations introduction, before Case 1 (R3-D).
  - Each case has a `[Julia source]` link and a GIF embed with descriptive alt text.
  - There are no code blocks.

**Final status:** committed
