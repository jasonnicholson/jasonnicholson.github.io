# Fix record: madsen-reid-method

Scratch evidence: `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r4fix/madsen-reid-method/fix/` (`trace_aa.jl`, `trace_ab.jl`, `trace_ac.jl`, `realdemo.py`, `realdemo2.py`).

## Findings

### F1 — Minor — fixed
- **Reproduced:**
  - Code: in all three scripts the only statements that can give a real step an imaginary part are the four `alterdirection` calls (saddle, line 91; r0 cap, line 103; two helpful halvings, line 134; rounding domain, line 151). Every other change to `dz` or the trial point is a real scaling (`dz *= complex(0.5)`, `wz -= dz`, lines 124–127).
  - `python3 -I realdemo.py`: `alterdirection(1, 0.5) = (0.3+0.4j)`, `alterdirection(-0.37, 0.5) = (-0.111-0.148j)`, angle atan2(0.8, 0.6) = 53.1301°. A rotated real step is never real, so the rotation has no counterpart on the real axis.
  - Scripts' lines 178–181 stop with an error if any iterate or Newton point leaves the real axis.
  - The old note's "reliable alternative to trust-region methods" has no support on the page or in either reference. The finding holds.
- **Change:** `index.qmd` line 39, the "Note on generalization" blockquote. Before: the whole structure, including the direction alteration, "translates directly" to scalar and vector problems and is "a reliable alternative to trust-region methods", plus a remark that Horner makes |f|² cheap. After: only part of the structure carries over. For a real f(x) = 0, the descent test, the lengthening and halving and the Kantorovich-style switch need only f and f′ in real arithmetic, and Cases 1 and 2 never leave the real axis. The lengthening bound n + 1 and Adams' stopping bound come from the polynomial. The 53.13° rotation (×(0.6 + 0.8i)) needs f to be defined off the real axis, as Case 3 uses it, and it has no counterpart on the real axis; the method defines none for systems. The trust-region and Horner sentences are removed.
- **Check:** see the ledger. No script or GIF changed.

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd l.39 | "Only part of this structure carries over to equations that are not polynomials" | It summarises the sentences below, each of which is checked | yes |
| index.qmd l.39 | Descent test, lengthening and halving, and the Kantorovich-style switch "need only f and f′ in real arithmetic" for a real f | Code: the descent test compares `feval` values (lines 121, 130); the trial points are real multiples of dz (lines 124–127); the stage test (lines 96–100) uses f, f′(z_k), f′(z_{k−1}) and the z's, so with real z and dz everything stays real. `python3 -I realdemo.py` applies the same search to sin²x (a non-polynomial with a double root at π) from 2.5: k = 2 at steps 1–4, errors 1.05e-1, 3.92e-4, 2.01e-11, 0. `realdemo2.py` applies it to atan x from 1.5, where plain Newton diverges: step 1 is halved once (x = −0.0970), step 2 is Stage 1 plain, steps 3–4 are Stage 2, ending at x = 0. Everything stays real. | yes |
| index.qmd l.39 | "Cases 1 and 2 never leave the real axis" | `julia trace_aa.jl` / `trace_ab.jl` (copies of the scripts' compute section): max \|imag z\| = 0.0; no cap, saddle or rounding branch taken | yes |
| index.qmd l.39 | "lengthening bound n + 1 and Adams' stopping bound come from the polynomial's degree and coefficients" | Code: `for i in 1:n` with `k = i + 1` (lines 122, 132), so k ≤ n + 1 with n the degree; `upperbound(a, n, z)` (lines 43–57) is built from the coefficients a. realdemo.py had to choose n by hand and needed its own stop (it raised ZeroDivisionError until a stop rule was added) | yes |
| index.qmd l.39 | "The 53.13° rotation multiplies the step by the complex number 0.6 + 0.8i" | `alterdirection` lines 59–64; atan2(0.8, 0.6) = 53.1301° (realdemo.py) | yes |
| index.qmd l.39 | "(Case 3 uses it)" | `julia trace_ac.jl`: kinds = [:halved, :rotated, :plain, :stage2], max \|imag z\| = 2.024 | yes |
| index.qmd l.39 | "it has no counterpart for a real equation on the real axis" | alterdirection of a nonzero real step has imaginary part 0.8·dz·m ≠ 0 (realdemo.py output above). No 53.13° rotation of a nonzero real number stays on the real line. | yes |
| index.qmd l.39 | "the method defines none for a system F(x) = 0" | `newton_real` and Madsen & Reid (AERE-R 7986, "Fortran Subroutines for Finding Polynomial Zeros") treat a single polynomial in one complex variable only. The page does not claim more (I avoided "no counterpart", because ℝ² can be identified with ℂ) | yes |
| index.qmd l.39 | Removed: "reliable alternative to trust-region methods", "translates directly", the Horner remark | `grep -n "trust-region\|translates directly\|Horner" index.qmd` → no matches | yes |

## Scripts and GIFs
- No script changed and no GIF regenerated: the fix is text only. The scripts' compute sections were run from scratch copies (`trace_*.jl`, lines 1–177 of each script plus one summary line), so the repo GIFs were not touched.
- `git status --short -- pages/numerical-methods/madsen-reid-method` → ` M pages/numerical-methods/madsen-reid-method/index.qmd` only (1 insertion, 1 deletion).

## Legacy archive
Consulted. `grep -ril "madsen|damped newton"` over `n2003/` finds only bibliography link pages: Nels Madsen under Pivoting, and Hald & Kaj Madsen under Newton Search. The archive has no Madsen-Reid topic, so there is nothing to compare for fidelity.

## Notes
- The page is otherwise unchanged, including the Description's "robust, globally convergent" (review D28, CND, not a finding).
- `realdemo.py` and `realdemo2.py` are demonstrations of the real-arithmetic structure, not a port of `newton_real`. Their stage test is a simplified transliteration, and the page cites no numbers from them.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: The old note (overstating that the whole structure, including direction alteration, "translates directly" to real scalar equations and systems, and calling it "a reliable alternative to trust-region methods") is replaced (index.qmd line 39). "trust" no longer appears anywhere on the page. The new note limits what carries over to the descent test on |f|², the lengthening and halving, and the Kantorovich-style switch. It says the 53.13° rotation needs complex evaluation and has no counterpart for real equations or for systems. This matches the code: `alterdirection` (scripts lines 59–64) multiplies by m(0.6+0.8i). Every other operation in `newton_real_iterates` stays real when z and dz are real. I re-ran the scripts: Cases 1 and 2 finish with every iterate and Newton point real (the guard at lines 178–181 did not fire). Case 3 step 2 is `rotated`, z2 = 0.359375 + 0.8125i. The new note also adds that the lengthening bound n+1 and Adams' bound depend on the polynomial. That is true: the lengthening loop is `for i in 1:n` with k = i+1, so the cap is (n+1)Δz, and `upperbound(a, n, z)` is built from the coefficients and degree.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| l.39 | "Only part of this structure carries over to equations that are not polynomials" | Rotation needs complex arithmetic; the bounds depend on degree and coefficients (see below) | True |
| l.39 | descent test on \|f\|², lengthening, halving, Kantorovich-style switch "need only f and f′ in real arithmetic" | Read code: with real z and dz, `feval`, the stage test (f2/u vs u/f/4, built from f, f′(z_k), f′(z_{k−1}) and z's), the `wz -= dz` lengthening and `dz *= 0.5` halving are all real | True |
| l.39 | "Cases 1 and 2 never leave the real axis" | Re-ran madsreidaa.jl and madsreidab.jl: all imag parts 0, guard not triggered | True |
| l.39 | "lengthening bound n + 1 … from the polynomial's degree" | Loop `for i in 1:n`, k = i+1 → up to (n+1)Δz (also stated l.14) | True |
| l.39 | "Adams' stopping bound … from … coefficients" | `upperbound(a,n,z)` uses the Horner recurrence on the coefficients | True |
| l.39 | "53.13°" / "0.6 + 0.8i" | atan2(0.8,0.6) = 53.1301°, \|0.6+0.8i\| = 1 | True |
| l.39 | "needs an f that can be evaluated off the real axis, as a polynomial can (Case 3 uses it)" | Case 3 trace: step 2 `rotated`, z2 = 0.359375+0.8125i | True |
| l.39 | "no counterpart for a real equation on the real axis, and the method defines none for a system" | A real-line step has no 53.13° rotation; the method (Madsen–Reid 1975 / newton_real) is for polynomials only | True |

### New problems
None. This rests on the code reading and re-run traces above, and on the diff touching only line 39 of index.qmd. One nuance, not a defect: as implemented, the halving branch hands off to the rotation after two helpful halvings, and the r0 cap also rotates. So a real-equation version would need its own substitute at those points. The note's sentence on the rotation covers this implicitly.

### Reproducibility and conventions
- No scripts or GIFs changed. I still ran all three scripts from scratch copies: madsreidaa.gif, madsreidab.gif and madsreidac.gif are byte-identical to the committed files (`cmp`). No frame inspection was needed, because no GIF changed.
- `git diff HEAD --stat` on the page folder: only index.qmd, 1 line. The other modified files in the working tree are in other pages' folders, from separate fixes, and are not part of this page's diff.
- Conventions are intact: Description before Animations, a Julia source link and a GIF embed with descriptive alt text for each of the 3 cases, and no code blocks (0 ``` fences).

**Final status:** committed
