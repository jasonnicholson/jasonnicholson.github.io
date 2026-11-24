# Fix record: graeffes-method

Scratch evidence: `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r7fix/graeffes-method/fix/` (`check.py`, `overflow.py`, run with `/usr/bin/python3`).

## Findings

### F1 — Minor — fixed
- Reproduced: `check.py` expands $E(t)^2 - tO(t)^2$ with sympy and gets `[c4**2, 2*c2*c4 - c3**2, 2*c0*c4 - 2*c1*c3 + c2**2, 2*c0*c2 - c1**2, c0**2]`, which matches `graeffe_step` in both scripts. The identity with $p(\sqrt t)p(-\sqrt t)$ gives a difference of 0. Case 1: the step gives $p_1$ = `[1, -30, 273, -820, 576]`, and sympy root-squaring gives the same; squaring each coefficient would give `[1, 4, 169, 196, 576]`. Only the end coefficients are squared outright.
- Change: `index.qmd` line 50: "The scripts square the coefficients in exact integer arithmetic, because in double precision they overflow at $m = 8$:" → "The scripts carry out the root-squaring step on the coefficients in exact integer arithmetic, because in double precision the coefficients overflow at $m = 8$:". The numbers that follow are unchanged.
- Check: `overflow.py` (independent Float64 vs exact-integer loop): first non-finite Float64 coefficient at m = 8 in both cases; exact $p_8$ maxima are 2.1581e353 (Case 1) and 8.6361e434 (Case 2), so "about 2.2 × 10^353" and "8.6 × 10^434" still hold.

### F2 — Minor — fixed
- Reproduced: `check.py` computes the Case 2 estimates at 600 digits (mpmath) from the exact integer coefficients. The error ratios $e_{m+1}/e_m$ for the $r_1$ and $r_2$ estimates are: 0→1 0.604 / 0.2819; 1→2 0.3999 / 0.7521; 2→3 0.4686 / 0.5498; 3→4 0.4889 / 0.5115; 4→5 0.4946 / 0.5054; … 9→10 0.4998 / 0.5002. The absolute errors of the $r_2$ estimate for m = 0..4 are 3.556, 1.002, 0.7538, 0.4144, 0.212. The first two steps are not halvings. From m = 2 on, every ratio lies in [0.4686, 0.5498] and tends to 1/2.
- Change: `index.qmd` line 62: "converge **linearly** — the error is halved each iteration rather than squared —" → "converge **linearly** — from $m = 2$ on, the error is roughly halved each iteration rather than squared —". This follows the review's suggestion, but says "roughly" because the ratio at 2→3 is 0.47/0.55.
- Check: the same ratio table as above, covering every step from m = 2 to m = 10.

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd l.50 | "carry out the root-squaring step on the coefficients" | `python3 check.py` → step = expansion of E²−tO²; p₁ = [1,−30,273,−820,576] = sympy root-squaring | yes |
| index.qmd l.50 | "the coefficients overflow at $m = 8$" (number unchanged) | `python3 overflow.py` → first non-finite Float64 at m = 8, both cases | yes |
| index.qmd l.62 | "from $m = 2$ on" | `python3 check.py` → ratios for 0→1 (0.604, 0.282) and 1→2 (0.400, 0.752) are not ≈ 0.5; for m ≥ 2 they are 0.469–0.550 | yes |
| index.qmd l.62 | "roughly halved each iteration" | same → for m ≥ 2, ratios lie in [0.4686, 0.5498] and reach 0.4998/0.5002 at 9→10 | yes |

## Scripts and GIFs
- No scripts changed and no GIFs regenerated. Both findings are text-only (D7/R7-D).
- `git status --short -- pages/numerical-methods/graeffes-method` → ` M index.qmd` only.

## Legacy archive
Consulted. `n2003/graeffemethod/GraeffeMethodMod/Links/GraeffeMethodMod_lnk_7.html` is Mathews' "Repeated Real" example. It says the larger repeated root converges linearly and the two smaller roots quadratically, which matches Case 2 and the computation. The main module HTML file is not present under `GraeffeMethodMod/` (only `Images/` and `Links/`), and `a2001/Animations/` has no Graeffe folder. The fixes do not touch fidelity, and the page still follows Mathews' polynomials.

## Notes
- No decision ambiguities. The fixes are text-only, under R7-D/D7.
- Not touched: the alt text for Case 2 says "linear convergence" with no rate, and the GIF annotation says "linear". Both stay accurate.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: line 50 now reads "carry out the root-squaring step on the coefficients in exact integer arithmetic". Independent check (`check/c.py`, `check/d.py`): root squaring computed as p(y)p(-y) by plain polynomial multiplication, keeping only even powers, without using the script's closed-form d-formulas. Case 1 p1 = [1, -30, 273, -820, 576] and Case 2 p1 = [1, -55, 879, -3325, 2500]. These match the script's `graeffe_step`. The scripts use BigInt (`c0 = big.(...)`). The new sentence is true.

### F2 — resolved
- Evidence: line 62 now reads "from $m = 2$ on, the error is roughly halved each iteration". Independent error ratios for the Case 2 double-root estimates against 5, computed in exact integers and then mpmath at 60 digits:
  - r1: 0.604, 0.400, 0.469, 0.489, 0.495, 0.497, 0.499, 0.499, 0.4997, 0.4998.
  - r2: 0.282, 0.752, 0.550, 0.512, 0.505, 0.503, 0.501, 0.501, 0.5003, 0.5002.
  
  The two irregular steps (0→1 and 1→2) are now excluded. From the 2→3 step on, every ratio is within 0.47 to 0.55, so "roughly halved" is accurate.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd l.50 | "carry out the root-squaring step on the coefficients in exact integer arithmetic" | Matches graeffesaa.jl/graeffesab.jl (BigInt, Graeffe step). Independent p(y)p(-y) gives the same p1 | OK |
| index.qmd l.50 | "in double precision the coefficients overflow at $m = 8$" (only the wording changed) | Max coefficient at m=7 is 4.65e176 (Case 1) and 2.94e217 (Case 2), both below 1.8e308. At m=8 both are above it | OK |
| index.qmd l.50 | 2.2e353 (Case 1), 8.6e434 (Case 2) (unchanged) | Exact: 2.16e353 and 8.64e434 | OK |
| index.qmd l.62 | "from $m = 2$ on, the error is roughly halved each iteration" | Ratios from step 2→3 on lie in [0.469, 0.550] and tend to 0.5. Earlier steps are 0.28 to 0.75 | OK |

### New problems
None. The diff is two sentence edits in index.qmd. No script or GIF changed (git status of the page folder shows only index.qmd modified). Every number in the changed sentences was recomputed independently, as above. The rest of the Case 2 paragraph (claims about the complex pair) is untouched by the diff.

### Reproducibility and conventions
- No script or GIF changed, so there is nothing to regenerate. The committed GIFs are unchanged from HEAD.
- The page conventions still hold: Description comes before Animations; each case has a source link and an embed; the alt text is descriptive; there are no code blocks. The fix's diff touches only `pages/numerical-methods/graeffes-method/index.qmd`.

**Final status:** committed
