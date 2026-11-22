# Fix record: newton-interpolation-polynomial

**Scratch evidence** (re-runnable) is in `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r4fix/newton-interpolation-polynomial/fix/`. The checks of the shared symmetric-case notes are in the Lagrange page's scratch folder, `…/r4fix/lagrange-polynomial-interpolation-and-approximation/fix/`.

**Shared script (WP-B).** `lagnewt_animations_all.jl` is shared with `lagrange-polynomial-interpolation-and-approximation`. This round changed only its Case 14 node span, to Mathews' [−1.45, 1.45] (Lagrange F2; see that record). Both copies are byte-identical (`cmp`), and the 29 GIFs on the two pages are pairwise byte-identical.

## Findings

### F1 — Minor — fixed
**Reproduced.** In the old `index.qmd`, the headings read only `### Case 01` … `### Case 29`. Every alt text read "Newton interpolation animation for case NN from the legacy function-and-interval list." None of them named a function, an interval or a degree. The finding holds.

**Change.** In `index.qmd`, Cases 01–29:
- **Headings.** Each heading now gives the function and node interval, using the same text as the Lagrange page (for example, `### Case 14: $f(x)=\tan x$, nodes on $[-1.45, 1.45]$`).
- **Alt texts.** Each alt text is now the Lagrange page's alt text, with "Lagrange interpolants of" replaced by "Newton interpolating polynomials of". It names the function, the node interval, the degree range 1 to 15 and the window or domain.
- **Intro clause.** The intro clause "the Lagrange page gives each case's function and node interval" is now "each case heading gives the function and the node interval $[a, b]$".
- **Notes for Cases 14, 18, 19, 21 and 23.** These cases gained the same one-line notes as on the Lagrange page (Lagrange F1). The reused alt text carries that statement, so the page text had to match it. The notes use the divided-difference wording of the existing Case 12/13 notes: "… lies on the line through the two end nodes. Hence $f[x_0, x_1, x_2] = 0$, and the frames titled degree 1 and 2 show the same line."

**Check.** `python3 -I headings_match.py` and `spans.jl` + `spans.txt`:
- **Lagrange page.** The 29 Newton headings are identical to the Lagrange headings, and the 29 alt texts are identical apart from the prefix (0 mismatches).
- **Script.** Every heading's node interval equals the `resolved_span` that the script computes (all 29 OK, including ±3π for 12 and 13 and ±1.45 for 14). The function in every heading matches the script's `formula_label`.
- **Old text.** No old alt text remains (`grep -c 'legacy function-and-interval'` → 0).
- **Alt-text content.** For Cases 01–29 this was confirmed row by row in the round-4 Lagrange review (C01–C29). The only alt content changed this round is in Cases 14, 18, 19, 21 and 23, and the Lagrange record checks it.
- **Notes.** `odd_dd.py` gives f[−b, 0, b] = 0 to 40 digits for all five cases. `frames_equal.jl` gives max|P₂ − P₃| ≤ 7.1e-15 on the plot grid.

### F2 — Minor — fixed (sentence added; case kept)
**Reproduced.** Mathews' Newton module Example 1 (`n2003/NewtonPolyMod.html` lines 440–470; images `NewtonPolyMod_gr_109/110/111.gif`) gives:
- "Form the Newton polynomials of degree n = 1, 2, 3, 4, and 5 for the function f[x] = Cos[x] over the interval [x0, xn] using equally spaced nodes" {(k/5, cos(k/5))}, k = 0…5.
- Solution 1(b) (`gr_128/129.gif`) uses n = 2 with nodes (0, 1), (0.2, 0.980067), (0.4, 0.921061), on the interval [0, 0.4]. So degree n uses nodes x₀…xₙ, added one at a time, the same construction as the page's case.

The page uses nodes kπ/3 on [0, 2π] with degrees 0–6 and does not mention the difference. The finding holds.

**Change.** One sentence is appended to the divided-differences Behavior paragraph in `index.qmd`:

> "Mathews' Example 1 forms the same sequence for $\cos x$ with the nodes $x_k = k/5$ added one at a time (degrees 1 to 5, ending on $[0, 1]$); there each interpolant of degree 2 or more is within $1.2\times10^{-4}$ of $\cos x$ between its first and last node, so this case spaces the nodes $\pi/3$ apart to make each added term visible."

Script and GIF are unchanged.

**Why the case was kept.** R2-A says to follow Mathews for a parameter departure. Two things made this a judgement call:
- The divided-differences case is not a reproduction of a Mathews animation. The archive has no Newton animation; Example 1 is a static worked example.
- With Mathews' nodes the animation would show almost nothing after degree 1 (numbers below).

So I took the review's suggested correction: keep the case and say what Mathews did and why the page differs, in one sentence, as the R2-A "keep the page" clause asks. The director may prefer to switch to Mathews' nodes. That would need a new script run and new Behavior numbers.

**Check.**
- `python3 -I mathews_ex1.py` (mpmath, 40 digits, 4001-point scans) gives Mathews' nodes k/5 with max|Pₙ − cos| on [0, n/5]:

  | n | max error on [0, n/5] |
  |---|---|
  | 1 | 4.97e-3 |
  | 2 | 1.165e-4 |
  | 3 | 6.4e-5 |
  | 4 | 4.2e-6 |
  | 5 | 1.35e-6 |

  So degree ≥ 2 is within 1.2e-4. On all of [0, 1], the errors for n = 2, 3, 4 are 0.031, 0.0072 and 1.5e-4.
- `python3 -I change_size.py`: on the page's case, each added term changes the drawn curve, clipped to the ±1.6 window, by at least 1.0 (n = 1…6: 2.6, 1.22, 3.2, 1.35, 1.6, 1.0). That supports "make each added term visible".
- The same script reproduces the existing page numbers. For degree 6 the max error on [0, 2π] is 0.0071163, matching the page's 0.0071.

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| Case 01–29 headings | function + "nodes on [a, b]" | `headings_match.py` → identical to Lagrange headings; `spans.jl` → every interval = script `resolved_span` (29 OK) | yes |
| Case 14 heading/alt | [−1.45, 1.45], "between the poles of f at x = ±π/2" | script row 47; 1.45 < π/2; nearest node 0.1208 from a pole (Lagrange `ylim14.jl`) | yes |
| Case 01–29 alt texts | Lagrange alt with prefix "Newton interpolating polynomials of" | `headings_match.py` → 0 mismatches; content confirmed by the r4 Lagrange review C01–C29 (unchanged GIFs) | yes |
| Alt 14/18/19/21/23 | "the frames at degrees 1 and 2 show the same straight line" | `frames_equal.jl` → max\|P₂−P₃\| = 7.1e-15, 4.4e-16, 8.9e-16, 2.6e-18, 3.3e-16 | yes |
| Notes 14/18/19/21 | "<f> is odd and the nodes are symmetric about 0", "middle of three nodes, (0, 0)" | `odd_dd.py` → max\|f(x)+f(−x)\| = 0, f(0) = 0; spans symmetric (`spans.txt`) | yes |
| Note 23 | "$f(x)-\tfrac12$ is odd", "(0, ½)" | `odd_dd.py` → 5.7e-42, f(0) = 0.5 | yes |
| Notes | "Hence $f[x_0, x_1, x_2] = 0$" | `odd_dd.py` → f[−b,0,b] = 0.0 (14, 18, 19, 21), −4.8e-43 (23) at 40 digits | yes |
| Intro | "each case heading gives the function and the node interval $[a, b]$" | every heading now has both (`spans.txt` comparison) | yes |
| Divided-differences Behavior | "Mathews' Example 1 … nodes $x_k = k/5$ added one at a time (degrees 1 to 5, ending on $[0, 1]$)" | `NewtonPolyMod.html` Example 1 text; `gr_111` (node list k = 0…5); `gr_128/129` (n = 2 uses k = 0…2 on [0, 0.4]) | yes |
| same | "within $1.2\times10^{-4}$ … between its first and last node" (degree ≥ 2) | `mathews_ex1.py` → max over n = 2…5 = 1.165e-4 | yes |
| same | "spaces the nodes $\pi/3$ apart to make each added term visible" | `change_size.py` → each added term moves the drawn curve by ≥ 1.0 in a 3.2-high window | yes |

## Scripts and GIFs
- **Scripts changed:** `lagnewt_animations_all.jl` (Case 14 span, for Lagrange F2), identical to the Lagrange copy. `newtpolyaa.jl` is unchanged.
- **Regenerated:** `julia lagnewt_animations_all.jl` was run in this folder. Only `lagnewt14.gif` changed, and it is byte-identical to the Lagrange page's new `lagnewt14.gif`. The frames viewed are listed in the Lagrange record (sheet; frames 1, 2, 5, 10).
- **git status of the page folder:** `M index.qmd`, `M lagnewt14.gif`, `M lagnewt_animations_all.jl`.

## Legacy archive
Consulted.
- **Example 1:** `NewtonPolyMod.html` Example 1 is cos x with nodes k/5, degrees 1–5, interval [x₀, xₙ] ⊂ [0, 1]. The solution images for n = 1, 3, 4 and 5 (`gr_112…125`, `gr_146…211`) are not in the archive. Only n = 2 (`gr_126–129`) is, and it confirms the node rule.
- **Cases 01–29:** these follow the shared Lagrange & Newton animation index. For Case 14 the page now uses the nodes of Mathews' Lagrange Example 11, which links to Animation 14.

## Notes
- **Notes beyond F1's literal scope.** The symmetric-case notes in Cases 14, 18, 19, 21 and 23 were not asked for by a Newton finding. They were added because the reused alt texts state the same fact, and the GIFs are the same files as on the Lagrange page (Lagrange F1).
- **R2-A ambiguity on F2.** See "Why the case was kept" under F2.
- **Pre-existing convention gap.** Cases 01–29 have no `**Behavior:**` paragraphs. No finding names this, so none were added.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: all 29 headings now name the function and the node interval, and all 29 alt texts name the function, node interval, degree range and plot window. The intro (line 20) now says "each case heading gives the function and the node interval $[a, b]$".
- **Against the Lagrange page.** After mapping "Newton interpolating polynomials" ↔ "Lagrange interpolants" and removing the added "Hence $f[x_0,x_1,x_2]=0$" sentence, a programmatic diff of headings, notes and alt texts shows the two pages identical. The only remaining differences are the Case 12 and 13 notes, which were already there and were not changed.
- **Against the script, all 29 cases.** I ran the shipped case table through the script's own `resolved_span`/`equal_nodes`/ylims logic (`../lagrange-.../check/ana/analyze.jl`).
  - Node interval, every case: 01 [−1.5, 0.9]; 02 [−0.9, 1.5]; 03 [−1.5, 0.9]; 04 [0, 2]; 05 [0, 8]; 06 [0, 10]; 07 [−1.5, 0.95]; 08 [−1, 1]; 09 [0.02, 2]; 10 [0.02, 4]; 11 [−0.98, 1]; 12–13 [−3π, 3π]; 14 [−1.45, 1.45]; 15 [−2, 3]; 16 [−2, 4]; 17 [−4, 4]; 18 [−2.2, 2.2]; 19 [−1, 1]; 20–21 [−10.2, 10.2]; 22–23 [−3, 3]; 24 [0.05, 2]; 25 [0.05, 4]; 26 [0.5, 5]; 27 [0.5, 20]; 28 [0.5, 10]; 29 [0.5, 4]. Every heading matches, and no frame trims its nodes.
  - Windows in the alt texts: 01/03/07 [−1.6, 1.5]; 02 [−1.5, 1.6]; 04–06 [0, 10.5]; 08/11 and 19 [−1.5, 1.5]; 09–10 [−0.5, 4.1]; 14 [−π, π]; 24–26 [−0.2, 5.2]; 27–29 [0, 22]; the rest use "the same interval". All match the script's xlims.
  - Domain clauses: f is finite on [−1.6, 0.997] for Case 07, on x > 0 for 09–10, on x > −1 for 11, and on [−0.998, 0.998] for 19 (sampled).
  - "Beyond the pole f ≤ −2, below the window" (Cases 01/02): the window's lower y-limit is −1.646 > −2.
  - Case 12 nodes are multiples of π at 2, 3 and 4 nodes, and frames 1 to 3 differ by 2e-31. Case 13 nodes are odd multiples of π at 2 and 4 nodes.
- **Against the GIF titles.** I built title strips of frame 1 and frame 10 for all 29 Newton-folder GIFs (`check/titles/sheetA.png`, `sheetB.png`). Each reads "Interpolation Case NN: f(x) = <label>, degree 1" / "degree 15", with labels matching the headings:
  - 1/(1-x), 1/(1+x), 1/(1-x)^2, sqrt, 1/sqrt(1-x), 1/(1+10x^2);
  - log = ln, log(1+x), sin, cos, tan, exp;
  - cos(x)*exp(-x) = e^{−x}cos x, cosh, atan, asin;
  - besselj(0/1,x) = J₀/J₁, normal_pdf, normal_cdf, gamma, bessely(0,x) = Y₀.
  - Degree range 1 to 15 is confirmed for every case.
- **Symmetric-case notes (Cases 14, 18, 19, 21, 23), which no finding asked for.**
  - The 3-node middle node is exactly (0, 0), or (0, 0.5) in Case 23.
  - f[x0,x1,x2] is exactly 0 in floating point for all five.
  - max|P(2 nodes) − P(3 nodes)| is 7.1e-15, 4.4e-16, 8.9e-16, 2.6e-18 and 3.3e-16.
  - I viewed frames 1 and 2 of each; they show the same line.
  - The added "Hence f[x0,x1,x2] = 0" is the right reason: the coefficient a₂ of the 3-node Newton form vanishes, so P₂ is the line through the first two nodes, which is the line through all three.

### F2 — resolved
- Evidence: the Behavior paragraph now adds a sentence on Mathews' Example 1. Checked against the archive (`NewtonPolyMod_lnk_2.html`; images gr_109, 110, 111, 146 and 189 viewed):
  - "Example 1 … cos x with the nodes x_k = k/5 added one at a time (degrees 1 to 5, ending on [0, 1])": f[x] = Cos[x]; node list {(k/5, cos(k/5))}, k = 0…5; Solution 1(c) uses k = 0…3 for degree 3 and 1(e) uses k = 0…5 for degree 5.
  - "each interpolant of degree 2 or more is within 1.2×10⁻⁴ of cos x between its first and last node": I computed max|P_n − cos| on [0, n/5] (40-digit mpmath, 20001 points). It is 1.165e-4 (degree 2), 6.4e-5, 4.2e-6 and 1.35e-6 (degree 5), so the bound holds. Degree 1 is 5.0e-3 and is correctly excluded.
  - The stated reason (nodes spaced π/3 apart to make each term visible) agrees with these numbers.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| Intro line 20 | "each case heading gives the function and the node interval $[a, b]$" | all 29 headings plus the divided-differences heading | correct |
| Case 01–29 headings (29) | function and node interval | analyze.jl spans; GIF titles | all correct |
| Case 01–29 alt texts (29) | function, node interval, degree 1 to 15, window or domain clauses, pole clauses | xlims, spans, ylims, finite support, titles deg 1/15 | all correct |
| Case 01/02 alt | beyond the pole f ≤ −2, below the window | f = 1/(1∓x) ≤ −2 beyond the pole within the window; y-limit −1.646 | correct |
| Case 12/13 alt | nodes multiples / odd multiples of π at deg 1, 2, 3 / 1, 3; line y = 0 / y = −1 | node lists; frame difference 2e-31 | correct |
| Case 14 heading, note, alt | [−1.45, 1.45], between poles ±π/2; tan odd; (0,0) collinear; f[x0,x1,x2] = 0; deg 1 and 2 same line; f on [−π, π] broken at poles | 1.45 < π/2; difference 7.1e-15; full-size frames 1, 2, 5, 10 viewed | correct |
| Case 18 note and alt | arctan odd, (0,0), f[x0,x1,x2] = 0, same line | difference 4.4e-16; frames viewed | correct |
| Case 19 note and alt | arcsin odd, (0,0), f[x0,x1,x2] = 0, same line; window [−1.5, 1.5], f on [−1, 1] | difference 8.9e-16; frames viewed | correct |
| Case 21 note and alt | J₁ odd, (0,0), f[x0,x1,x2] = 0, same line | difference 2.6e-18; frames viewed | correct |
| Case 23 note and alt | f − ½ odd, (0, ½), f[x0,x1,x2] = 0, same line | f(0) = 0.5; difference 3.3e-16; frames viewed | correct |
| Divided-differences Behavior, added sentence | Mathews Ex. 1: cos x, x_k = k/5, degrees 1–5, ending on [0, 1] | archive gr_109/110/111/146/189 | correct |
| same | within 1.2×10⁻⁴ for degree ≥ 2 between first and last node | max error 1.165e-4 (degree 2) down to 1.35e-6 | correct |
| Script lines 45–47 | Case 14 nodes (−1.45, 1.45), comment citing Mathews' static example | gr_444: aa = −1.45, bb = 1.45, window [−π, π] | correct |

### New problems
None. This rests on:
- every heading and alt text, all 29, checked against the script's case table and computed spans, windows and y-limits;
- the frame 1 and frame 10 title strips of all 29 GIFs;
- high-precision checks of the five symmetric-case notes and of the Example 1 error bound;
- the archive images.

### Reproducibility and conventions
- I ran a scratch copy of the shared script. All 29 outputs are byte-identical to the committed GIFs in both folders, including the new lagnewt14.gif (sha256 8630171a…).
- The two `lagnewt_animations_all.jl` copies are byte-identical (cmp).
- In this folder only lagnewt14.gif changed among the GIFs. It is identical to the Lagrange folder's copy, and all 29 lagnewt GIFs agree across the folders. newtpolyaa.gif and newtpolyaa.jl are unchanged.
- Conventions:
  - Description (line 10) comes before Animations (line 22);
  - source links: one for Cases 01–29 and one for the divided-differences case;
  - 30 GIF embeds, all with descriptive alt text;
  - no code blocks.
- Files changed outside the two WP-B page folders: none in the site. The only other working-tree items are the untracked fix records under `reviews/numerical-methods-animations-r4/fixes/`, which I did not read.

**Final status:** committed
