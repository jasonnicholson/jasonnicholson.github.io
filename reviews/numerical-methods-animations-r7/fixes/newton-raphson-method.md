# Fix record: newton-raphson-method

Scratch: `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r7fix/newton-raphson-method/fix/` (`check.py` → `check.out`, `check2.py` → `check2.out`; run with `/usr/bin/python3 -I <script>`).

## Findings

### F1 — Misleading — fixed
- Reproduced: `check.py` (mpmath, 60 digits). Root $x^*=0.25485005902885$. Zero of $f''=3e^x+4\cos x$ left of the root: $-1.707243147$. Sampled minimum of $f''$ on $[-1.697, 1.5]$: $0.0451>0$, so $f$ is convex on both sides of the root. First steps: $x_0=1.0\to x_1=0.47975202$ (lands between); $x_0=0\to0.33333333$, $0.1\to0.27887789$, $0.2\to0.25742646$ (all overshoot past $x^*$). So "convex side" is not the reason. The reason is $f\,f''>0$ to the right of the root.
- Change: `index.qmd:21`, "on the convex side of the root" → "to the right of the root, where $f > 0$ and $f'' > 0$".
- Check: `check.py`: every iterate from $x_0=1$ satisfies $x_n>x_{n+1}>x^*$, and $f>0$, $f''>0$ at each iterate (True). `check2.py`: on a grid over $(x^*, 50]$, $f>0$ and $f''>0$ everywhere (min $f''=7.74$). Analytically, $f'' \ge 3e^x-4>0$ for $x>\ln(4/3)=0.2877$, and $\cos x>0$ covers $[x^*, 0.2877]$. So the clause holds on the whole right side, not just at the iterates.

### F2 — Minor — fixed
- Reproduced: `check.py`. Iterates from 1.35: 1.35, −1.2841, 1.1241, −0.78587, 0.29155, −0.016251, 2.8611e-6, −1.5613e-17, 2.5373e-51. The signs alternate at every step (True) and $|x_n|$ strictly decreases (True). $x_c=1.39174520027073$, so $x_0/x_c=0.97001$. $(\arctan)''=-2x/(1+x^2)^2$ is zero only at $x=0$, which is the root, so the heading's "near inflection point" names the wrong feature. Mathews' Example 5 title (archive, line 178–180 of the stripped text) is "Convergence, Oscillation".
- Change: `index.qmd:35`, "Case 3 — Convergent near inflection point, …" → "Case 3 — Convergence with oscillation, $f(x) = \arctan(x)$, $x_0 = 1.35$".
- Check: the heading now agrees with the Behavior paragraph ("several oscillating steps"), the alt text ("convergent case starting just inside the critical radius") and the script header (`newtoncc.jl:2`, "Convergence with Oscillation"). The GIF title "Newton-Raphson: f(x) = arctan(x)" names no feature, so no regeneration is needed.

### F3 — Minor — fixed
- Reproduced: `check.py`. Case 4: real root −1.671699882. $x_0=0$ is 1.6717 from it, and the minimum distance over iterates 1–4000 is 1.6783. The last four iterates are 3.0005, 1.9619, 1.1475, 0.00744608, so this is a cycle. Case 5: 2, 4, 5.33333, …, 10.0188 (moves away from the root 0). Case 6: 1.4, −1.41362, 1.45013, −1.55063, 1.84705, −2.89356, 8.71033, −103.25, 16540.6, with $|x_n|$ strictly increasing (True). Only Cases 1–3 move toward a root.
- Change: `index.qmd:14`, "The sequence of tangent lines traces the convergence (or divergence) toward a root." → "The sequence of tangent lines shows whether the iterates converge to a root, fall into a cycle, or diverge."
- Check: each of the six cases fits exactly one of the three outcomes. Cases 1–3 converge (to 0.2548501, to 0.2 and to 0). Case 4 cycles (above). Cases 5 and 6 diverge (|x_n| increases without settling, as computed above).

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd:14 | "shows whether the iterates converge to a root, fall into a cycle, or diverge" | `check.py` → C1–C3 converge; C4 min dist 1.6783 over 4000 iterates, last 4 on the cycle; C5 increasing to 10.0188; C6 $|x_n|$ increasing to 16540.6 | yes |
| index.qmd:21 | "to the right of the root, where $f > 0$ and $f'' > 0$" | `check2.py` → on $(x^*,50]$ all f>0 and f''>0, min f''=7.74; `check.py` → x₀=1 > x* and all iterates > x* | yes |
| index.qmd:35 | "Case 3 — Convergence with oscillation" | `check.py` → signs alternate True, $|x_n|$ strictly decreasing True, final 2.5373e-51 | yes |

No numbers were added or changed. The existing numbers in the edited lines (1, 0.4798, 0.2857, 0.2556, 0.254850; $x_0=1.35$) match `check.out` (1.0, 0.479752, 0.2857384, 0.2555769, 0.2548505).

## Scripts and GIFs
- No scripts changed and no GIFs regenerated. All three fixes are text-only (R7-D, D7). None of the three findings says the picture misleads, and the GIF titles name no feature.
- `git status --short -- pages/numerical-methods/newton-raphson-method` → ` M pages/numerical-methods/newton-raphson-method/index.qmd` only.

## Legacy archive
- Consulted: `/home/jason/Desktop/math-fullerton/baseline/mathews/n2003/Newton'sMethodMod.html`. The brief's path `newtonsmethod/Newton'sMethodMod.html` does not exist. That folder holds only `Images/` and `Links/` subfolders, and the module HTML is one level up in `n2003/`.
- Examples 3–8 are titled Fast Convergence; Slow Convergence; Convergence, Oscillation; NON Convergence, Cycling; NON Convergence, Diverging to Infinity; NON Convergence, Divergent Oscillation. The F2 heading now matches Example 5's title, and the F3 sentence covers all three kinds of outcome in these titles. No difference between the archive and the fixed page.

## Notes
- Pre-existing convention gap, not touched: the page has no `## Description` section (the method formula sits in the Animations introduction). No finding names this.
- Cosmetic note from the review, not a finding and not touched: the `newtoncc.jl` legends for $x_6$–$x_8$ round to `0.0`/`-0.0`.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: line 21 now reads "to the right of the root, where $f > 0$ and $f'' > 0$". mpmath (40 digits): $x^* = 0.25485005902885$; on $(x^*, 1]$ min $f = 0.0018 > 0$ (at the left end, near the root), min $f'' = 7.74 > 0$, min $f' = 4.88 > 0$. The stated reason is the real one: with $f(x_n) > 0$ and $f$ convex on $[x^*, x_n]$, convexity gives $f'(x_n) \ge f(x_n)/(x_n - x^*) > 0$, so $x_{n+1} < x_n$. The tangent lies below the curve, so its value at $x^*$ is $\le 0$, which gives $x_{n+1} \ge x^*$. Hence the iterates decrease monotonically. Counter-check (same convex arc, $f<0$): $x_0 = 0, 0.1, 0.2$ give $x_1 = 0.3333, 0.2789, 0.2574$, all past $x^*$, so the sign of $f$ (i.e. $f f''>0$) is what decides it. Iterates 1, 0.47975, 0.28574, 0.25558, 0.254850, matching the page. Errors 0.745, 0.225, 0.0309, 7.27e-4, 4.19e-7, 1.39e-13, 1.53e-26: the number of correct digits roughly doubles.

### F2 — resolved
- Evidence: the heading is now "Case 3 — Convergence with oscillation, $f(x) = \arctan(x)$, $x_0 = 1.35$". Iterates from 1.35: -1.2841, 1.1241, -0.78587, 0.29155, -0.016251, 2.86e-6, -1.56e-17, 2.54e-51. The signs alternate and $|x_n|$ decreases, so the heading is true. It agrees with the script header (`newtoncc.jl:2`). The GIF frames (unchanged, 9 frames; frames 2 and 9 viewed at full size) show the tangents alternating sides and closing in on 0. $x_c = 1.3917452$, so 1.35 is inside it. No "inflection" remains in the page folder (grep).

### F3 — resolved
- Evidence: line 14 now reads "shows whether the iterates converge to a root, fall into a cycle, or diverge". Each case is covered:
  - Cases 1-3 converge (Case 2: 1, 0.6, 0.4, 0.3, 0.25, ... toward 0.2).
  - Case 4 falls into an attracting 4-cycle: after 4000 steps the last values are 3.0005, 1.9619, 1.1475, 0.00745, and the iterates never come closer than 1.678 to the root at -1.6717.
  - Case 5 diverges: 2, 4, 5.333, ..., 10.019.
  - Case 6 diverges: |x| grows 1.4, 1.414, 1.450, 1.551, 1.847, 2.894, 8.710.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd:14 | "converge to a root, fall into a cycle, or diverge" | iteration of all six cases (above) | true |
| index.qmd:21 | "to the right of the root, where $f>0$ and $f''>0$" | sampled signs on $(x^*,1]$; convexity argument; left-start counterexamples | true, and it is the correct reason for monotone convergence |
| index.qmd:21 (unchanged numbers) | 1, 0.4798, 0.2857, 0.2556, 0.254850 | mpmath Newton | true |
| index.qmd:35 | "Convergence with oscillation", $x_0=1.35$ | iterates alternate in sign with decreasing modulus; $1.35 < x_c = 1.39175$ | true |

### New problems
None. This rests on the following: the diff touches only three text lines of index.qmd; each was checked numerically above; there are no script or GIF changes; and grep finds no leftover "inflection", "convex side" or "toward a root".

### Reproducibility and conventions
- No script or GIF changed (git status of the page folder: only index.qmd modified), so there is no regeneration to reproduce.
- Every case still has a source link and an embed with descriptive alt text, and there are no code blocks. The headings and alt text stay consistent (the Case 3 alt text says "convergent case starting just inside the critical radius").
- The page has no "Description" section before "## Animations". That was so before this fix and the fix did not touch it.
- Files outside the page folder are also modified in the working tree (other pages of this round). The fix diff for this page is confined to the page folder.

**Final status:** committed
