# Fix record: pade-approximation

Scratch folder (evidence, re-runnable): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r2fix/pade-approximation/fix/`
- `lib.jl`: the page script up to (not including) `render_case`, so its functions are used unchanged.
- `dump.jl` → `dump.txt`: for every case, the coefficients, coefficient spread, the largest cond(B) among non-singular systems and its [m/n], the number of singular systems, and the number of degenerate frames.
- `indep.py` → `indep.txt`: independent check. Taylor coefficients from `mpmath.taylor` at 60 digits, the same Toeplitz matrix B built separately, the 2-norm condition number from `numpy.linalg.cond`, and the largest cond(B) per total order.
- `exact_sing.py` → `exact_sing.txt`: exact (sympy) count of singular B, and of inconsistent singular systems, for cases 05–20. The run was stopped after case 20 because sympy's handling of √(2π) made case 21 very slow; the later cases 13, 03 and 22 have no zero coefficients and are not needed.
- `exact_sing21.py` → `exact_sing21.txt`: case 21 in Q[s], s = 1/√(2π) → `21 singular 6 inconsistent 6 [(2,1),(4,1),(4,3),(6,1),(6,3),(8,1)]`.

## Findings

### F1 — Minor — fixed
- **Reproduced.** `julia dump.jl` (the script's own `series_coeffs_analytic` and `pade_linear`) gives the review's numbers:
  - case 03 (√x, x0 = 5): a_0 = 2.236, a_10 = −2.123e−9, largest regular cond(B) = 1.511e11 at [4/6];
  - case 13 (eˣ): a_10 = 2.756e−7, cond 6.357e7 at [4/6];
  - case 22 (Γ, x0 = 1): a_8 = 0.9981, cond 8.234e3 at [3/5].

  `python3 -I indep.py` reproduces every case's largest cond(B) and its [m/n] independently, to all 4 printed digits.

  None of the 27 cases has growing Taylor coefficients. The largest |a_k| is a_0 or a_1 in every case (`dump.txt`, columns max|a| and a0). So "because of how fast the coefficients grow" does not describe the page. The difficulty the script actually meets is twofold:
  - ill-conditioning of the denominator system, up to 1.5e11;
  - systems that are exactly singular: 176 frames in 13 cases, every one of them a degenerate frame (`dump.txt`: nsing = ndegframes in every case; the sum is 176).
- **The review's suggested wording was not used as written.** It says "especially when the Taylor coefficients span many orders of magnitude", and the check does not support that as a general rule:
  - The Spearman rank correlation between coefficient spread (max|a|/min nonzero |a|) and the largest cond(B) over the 27 cases is 0.36 (p = 0.063) (`indep.txt`).
  - Case 04 (1/√(1−x)) has a spread of 5.7 but cond 1.86e6.
  - Case 18 (J0) has a spread of 1.5e7 but cond 5.9e4.

  The review's line "the best-conditioned belong to a function whose coefficients stay near 1" is also inexact: cases 17 (1.1e2) and 16 (4.0e2) are better conditioned than case 22 (8.2e3). Neither line was put on the page.
- **Change.** `index.qmd` line 24, first sentence.
  - Before: "High-order Padé Approximants can be hard to compute because of how fast the coefficients grow."
  - After: "High-order Padé Approximants can be hard to compute because the linear system for the denominator coefficients can become badly conditioned as the order rises (for $\sqrt{x}$ about $x_0=5$, the $[4/6]$ system has condition number about $1.5\times10^{11}$), and because that system is singular for some entries $[m/n]$, the degenerate entries described above."
- **Check.** See the ledger. The quoted condition number is confirmed by two independent computations. "As the order rises" holds for the quoted case: its largest cond per total order rises at every step, 1.0, 1.1, 68, 430, 4.9e4, 4.9e5, 2.4e7, 2.9e8, 1.1e10, 1.5e11 for totals 1 to 10. "Singular for some entries, the degenerate entries" is confirmed in floating point by the script and in exact arithmetic (see the ledger).

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd l.24 | "the linear system for the denominator coefficients" | `pade_animations_all.jl` lines 338–372: q0 = 1, and B·q_tail = −a_{m+1..m+n} is solved for q1..qn; p then follows from q·a | yes |
| index.qmd l.24 | "can become badly conditioned as the order rises" | `indep.txt` and `dump.txt`: the largest cond(B) for total order ≤ 3 is at most 68 in all 27 cases, and at the top order it reaches 1.5e11 (case 03), 2.2e10 (02), 6.4e7 (13), 2.6e7 (06). This is "can", an existence claim. In the quoted case 03 the largest cond rises at every total order 1→10 (listed under F1 Check). | yes |
| index.qmd l.24 | "$\sqrt{x}$ about $x_0=5$, the $[4/6]$ system has condition number about $1.5\times10^{11}$" | `julia dump.jl` → `03 … maxcond_regular=1.511e+11 at [4/6]`; `python3 -I indep.py` → `03 maxcond=1.511e+11 at (4, 6)` (2-norm, numpy.linalg.cond and Julia `cond`). It is the largest on the page. | yes |
| index.qmd l.24 | "that system is singular for some entries $[m/n]$, the degenerate entries described above" | `dump.txt`: in each case the count of singular systems (cond > 1e14) equals the count of frames labelled "(degenerate)". Totals: 176 frames in cases 05, 07, 08, 09, 12, 14, 15, 16, 17, 18, 19, 20, 21, and 0 in the other 14 cases (largest regular cond 1.5e11, far below the 1e14 threshold). Exact arithmetic: `python3 -I -u exact_sing.py` (sympy series coefficients, exact det and ranks; cases 05–20) and `exact_sing21.py` (case 21, with s = 1/√(2π) as a symbol, which is valid because s is transcendental). The singular counts are 05: 10, 07: 10, 08: 20, 09: 15, 12: 14, 14: 2, 15: 15, 16: 20, 17: 14, 18: 15, 19: 20, 20: 15, 21: 6, for a total of 176. Every one is inconsistent (rank B < rank [B | rhs]), so no [m/n] with Q(x0) = 1 exists there. These are exactly the per-case degenerate-frame counts of the script. | yes |
| index.qmd l.24 | Rest of the paragraph (MATLAB/Chebfun sentences) | unchanged | n/a |

## Scripts and GIFs
- No script changed and no GIF regenerated: this is a text-only fix (the animation was not at fault).
- `git status --short -- pages/numerical-methods/pade-approximation` → ` M pages/numerical-methods/pade-approximation/index.qmd` only.

## Legacy archive
- **Consulted.** The page is at `/home/jason/Desktop/math-fullerton/baseline/mathews/n2003/PadeApproximationMod.html` (not in `pade/`; that folder holds only `Images/`, `Links/` and the proof PDF), together with `PadeApproximationProg.html`.
- **What it shows.** Background, the Padé theorem, and Examples 1–4 with animations. It says nothing about the computational difficulty or conditioning of high-order approximants: grepping the stripped text for "condition", "grow", "difficult" and "hard" finds nothing on the topic. So it neither supports nor contradicts the old or the new sentence.
- **Frame sequence.** The review's note on the legacy frame sequence (the diagonal S_{n,n} only) is listed in the review as not a finding, and is not acted on here.

## Notes
- I fixed only the first sentence of line 24. The rest of the paragraph has grammar slips noted by the reviewer as cosmetic and not counted, and I left it unchanged: "…of less than 20 fail at times for MATLAB's symbolic `pade` function fails". The capitalisation "Approximants" in the edited sentence is also the page's own and is kept.
- The reviewer's note about clamping off-scale values to the frame border (line 475) was recorded as not a finding, and I did not act on it.

## Resolution check (independent checker, not shown this record)

### Original findings
### F1 — resolved
- The false clause ("hard to compute because of how fast the coefficients grow") is gone from `index.qmd` line 24. It now reads: "...because the linear system for the denominator coefficients can become badly conditioned as the order rises (for $\sqrt{x}$ about $x_0=5$, the $[4/6]$ system has condition number about $1.5\times10^{11}$), and because that system is singular for some entries $[m/n]$, the degenerate entries described above."
- I checked each claim independently (scripts and outputs are in this folder):
  - **Conditioning grows with order.** `dumpcond.jl` loads the page's own functions from a scratch copy, `padelib.jl`, without the render loop, and gives the Float64 cond₂(B) for all 1614 (case, m, n). `exact.py` (sympy) builds B from exact coefficients for cases 01–21, with log 2 and 1/√(2π) as transcendental symbols. `hp.py` (mpmath at 100 digits, cross-checked at 130) does the same for the Γ and Y₀ cases 22–27. The cond₂ of the exact B, taken as the largest over the entries of each total order m+n, rises from about 1 at total order 1 to its largest value at total order 9–10 (8 for the 8-order cases) in every one of the 27 cases. It rises monotonically in 14 cases. In the symmetric cases (08, 09, 12, 15–20) it zigzags between odd and even totals, but the trend is still upward. Largest values: 03: 1.51e11; 02: 2.16e10; 13: 6.36e7; 06: 2.56e7; 04: 1.86e6; most others 1e2–1e6; 17: 115. So "can become badly conditioned as the order rises" is true. The word "can" correctly hedges cases that stay modest, such as 16, 17 and 20.
  - **The case 03 number.** For case 03 [4/6], cond₂ of the exact B is 1.51092e11, and the Float64 B the script builds gives 1.5109180e11. "About 1.5×10^11" is right. It is also the largest cond₂ of any regular system on the page.
  - **Singular entries, by exact rank.** Exactly 176 entries are singular, in 13 cases:

    | Case | Singular entries |
    |---|---|
    | 05 | 10 |
    | 07 | 10 |
    | 08 | 20 |
    | 09 | 15 |
    | 12 | 14 |
    | 14 | 2 |
    | 15 | 15 |
    | 16 | 20 |
    | 17 | 14 |
    | 18 | 15 |
    | 19 | 20 |
    | 20 | 15 |
    | 21 | 6 |

    Cases 01–04, 06, 10, 11 and 13 have no exactly singular entry. Neither do 22–27: their smallest singular value at 100 digits is 5.9e-7, far above the 1e-100 error, so they are provably regular. Every one of the 176 singular systems is **inconsistent**: rank[B|rhs] > rank B, so no R_{m,n} with Q(x0)=1 exists. There is no singular-but-consistent entry anywhere on the page. So "singular for some entries" is exactly true, and identifying those entries with "the degenerate entries described above" (entries with no such R_{m,n}) is an exact match on this page's table. The script's floating-point test (cond > 1e14) labels "(degenerate)" exactly these 176 entries and no others. The largest regular Float64 cond is 1.51e11 (03 [4/6]) and the smallest singular one is 4.73e16 (20 [1/5]). This also confirms the unchanged script comment on lines 361–362.
- The fixer left out the suggested correction's phrase about coefficients spanning many orders of magnitude. That is not required: the replacement makes no false claim and gives the right mechanism (denominator system conditioning and singular entries).
- No script or GIF was changed, and none needed to be: the finding was about text only.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd l.24 | "the linear system for the denominator coefficients can become badly conditioned as the order rises" | Exact-B cond₂, largest per total order, for all 27 cases: grows from ~1 to its largest at the top orders in every case (zigzag in symmetric cases). Up to 1.5e11 (03) and 2.2e10 (02) | True |
| index.qmd l.24 | "for √x about x0=5, the [4/6] system has condition number about 1.5×10^11" | Exact B (sympy coefficients, mpmath SVD): 1.51092e11. Float64 B in the script: 1.5109180e11 | True |
| index.qmd l.24 | "that system is singular for some entries [m/n]" | Exact rank: 176 singular entries in 13 cases | True |
| index.qmd l.24 | "the degenerate entries described above" (= entries with no R_{m,n}, line 19) | All 176 singular systems are inconsistent and none is singular-but-consistent, so the singular set equals the set with no R_{m,n}. The script's "(degenerate)" labels are exactly the same 176 entries | True |

### New problems
None. This rests on the exact and 100-digit computations above, which cover every one of the 1614 Padé entries on the page, and on the diff being a single-sentence text change.

Outside this check's scope: the unchanged sentence after the fix ("Total orders ... fail at times for MATLAB's symbolic `pade` function fails.") still has a doubled "fails". It is a grammar problem that predates the fix.

### Reproducibility and conventions
- **Reproducibility.** The diff changes only `index.qmd` (1 line). `git status` and `git diff --stat` on the page folder show no script or GIF changes, so there was nothing to regenerate.
- **Conventions.**
  - The Description (l.10) still comes before Outside Links, Video Animations and Animations (l.84).
  - There are 27 `[Julia source]` links and 27 `padeNN.gif` embeds, one per case.
  - Every embed has descriptive alt text.
  - There are no code blocks.
- **Files outside the page folder.** This fix touched none. Other modified files in the working tree (Chebyshev, Richardson, Tangent Parabola, and untracked fix records under `reviews/numerical-methods-animations-r2/fixes/`) belong to other pages' parallel fixes and are not in this page's diff.

**Final status:** committed
