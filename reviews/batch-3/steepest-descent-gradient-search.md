# Review: Steepest Descent - Gradient Search (batch 3, round 1)

**Findings: 1 Error (confirmed by an independent check), 0 Misleading, 2 Minor (unverified).**

Legacy archive consulted: `GradientSearchMod.html` and lnk_1–lnk_7; program images gr_56 (GradSearch/Qmin) and gr_166 (the Example 5 drawing program); every output table gr_80 (Ex 1), gr_96 (Ex 2), gr_116, gr_121, gr_129 (Ex 3 i/ii/iii), gr_158 (Ex 4); the δ/ε call images gr_79, 95, 115, 120, 128, 157; function images gr_102, gr_135, gr_167; illustration gr_16; animation pages `Gradientaa.html`, `Gradient.html`. Independent computation: a separate Python/mpmath implementation of Mathews' Qmin/GradSearch at 60, 120 and 300 digits, with and without his in-loop `If[h<δ, cond=1]`; exact line minima by bisection on φ′; sympy resultant for Ex 3; exact rationals for Ex 1 and Ex 4.

## Findings

### F1 — Page match — Error: wrong "counter removed" iteration counts for Example 3(ii) and 3(iii)

- **Location:** `index.qmd` line 397, Example 3: "With the counter removed, Mathews' tolerances δ = ε = 10^{-14} are met only after $111$ and $91$ iterations."
- **True instead:** with Mathews' algorithm and no work counter, the runs from (2, 1.5) and (−2, 1.5) stop after **113** and **103** iterations, the same at 100, 120, 150, 200 and 300 digits. Below about 100 digits the count depends on the precision; 111 and 91 appear at none tried:

| Arithmetic | Run (ii) | Run (iii) |
|---|---:|---:|
| 30 digits | 112 | 108 |
| 40 digits | 113 | 106 |
| 50 digits | 103 | 108 |
| 60 digits (what the page says it used) | 106 | 104 |
| 77 digits (≈ the scripts' 256-bit) | 113 | 105 |
| 80 digits | 108 | 102 |
| 100 to 300 digits | 113 | 103 |
| Float64 | 59 | 62 |

- **Why:** near the end the steps are about 1e-12 long and Err is about 1e-22; the run stops only when the next trial step min(h, |h_k|, |h_k − h|, |h_k − 2h|) happens to fall below 1e-14, and each parabola fit on such short steps loses digits (60- and 120-digit trajectories differ by 1e-55 at iteration 16, 3e-29 at 56, 1e-18 at 70, where their bracketing moves first differ).
- **Related:** the Description's "agrees with a 120-digit run to more than 50 digits" is true for the six tabulated runs (largest coordinate difference 3e-52) but not for these two counter-removed runs.
- **Fix:** "only after 113 and 103 iterations", with a note that the count needs about 100-digit arithmetic because the run ends when |h_k − h| happens to drop below 10⁻¹⁴; or "only after more than 100 iterations". (The parallel Ex 1 (34) and Ex 2 (28) counts are the same at every precision.)
- **Independent check: CONFIRMED** (both the counts and the Description sentence), by a checker given only the allegation. Two independent implementations (Python/mpmath by digits, Julia BigFloat by bits) of the page's described algorithm, with the counter restored, reproduce the page's 15 and 16 steps (counter 63). With the counter removed: **113** (counter 509) and **103** (counter 487) at every precision from about 100 digits to 2000 digits and at 333, 512 and 1024 bits; 40–95 digits give 103–115 for (ii) and 102–108 for (iii); 200 bits gives 111 and 103 (the only place 111 appears); 256 bits gives 115 and 104; IEEE double gives 58 (then the fit's denominator is 0) and 62; 91 never appears. Err is below 1e-14 from about iteration 50; the run then stops the first time the next trial step dips to ≤ 1e-14 while it hovers between 1.3e-14 and 5e-14 (1000-digit run of (ii): 1.34e-14 to 1.35e-13 at k = 103–111, 7.5e-15 at k = 112). The 60- and 120-digit counter-removed runs first differ by more than 1e-50 at k = 23 and 21, by up to 2.4e-18 and 4.4e-18 at worst, and stop at 106/104 versus 113/103; the tabulated counter-limited runs agree to ~1e-55. Checker's suggested text: "only after 113 and 103 iterations", with a note that these counts need about 100 significant digits (40–95 digits give 103–115 and 102–108; machine arithmetic gives 58 and 62).

### F2 — Page (theorem statement) — Minor (unverified): "exact local minimiser" does not imply descent

- **Location:** lines 129–135, "Theorem — Properties with an exact line search (general)": assumes "each $h_k > 0$ be an exact local minimiser of $\varphi_k$", concludes in item 1 "so $f$ decreases strictly".
- **True instead:** φ′(0) < 0 does not make φ(h_k) < φ(0) for an arbitrary local minimiser. Counterexample (n = 1): f(x) = cos 2πx − 3x from P₀ = 0.7 (f′ = 2.976 > 0, S = −1); γ = 1.12078 is an exact local minimiser of φ₀ (f″ = 34.7 > 0 at x = −0.42078) yet f rises from −2.40902 to +0.38368; the first local minimiser γ = 0.12078 does decrease f.
- **Fix:** assume "$h_k$ is the first local minimiser of $\varphi_k$ on $(0, \infty)$" or "a global minimiser on $[0, \infty)$". Conclusions hold for every run on the page.

### F3 — Fidelity and implementation — Minor (unverified): Mathews' in-loop `h < δ` exit missing from the description and the scripts

- **Location:** page lines 159–163 (the line search "repeats, at most 15 times" with three bullets); line 24 (the scripts run Mathews' line search "exactly as described"); `gradsearch` in all four scripts (`while j < jmax && cond == 0`).
- **True instead:** Mathews' Qmin (gr_56) also has `j = j + 1; If[h < δ, cond = 1]` inside the bracketing loop. It changes nothing on this page: the smallest h in any run stays above δ (Ex 3(i) 2.649e-10, Ex 4 3.725e-10, δ = 1e-10), and the iterates are identical with and without the check for all six runs and the counter-removed runs.
- **Fix:** add a fourth bullet ("the loop also stops if $h < \delta$"), and either add the check to the scripts or say it never triggers in these runs.

## Inventory (Phase 1)

4 scripts, 4 GIFs; all run; `gradientaa.gif` (19 frames), `gradientbb.gif` (12), `gradientcc.gif` (41), `gradientdd.gif` (11) byte-identical to what their scripts produce; every reference resolves; no unreferenced file; the section index links the page.

## Claim ledger (whole page; reviewer's verdicts; 117 entries)

- **Description (1–5):** confirmed, except 5 for the counter-removed runs (F1).
- **Animations introduction (6–19):** all confirmed (panel elements; middle-panel levels f* + (f(P_k) − f*){0.1, 0.2, 0.4, 0.6, 0.8}, Mathews' gr_166 levels; post-loop trial points vs Mathews' pre-loop points and 5h segment; scripts at 256 bits match every table cell; "Under Construction" animation page; Example 5 output lost gr_168–206; Ex 5 window [2.5, 3.05] × [1.6, 2.15]; wiring).
- **Case 1 (20–28):** all confirmed: vertex = exact line minimum (h_k/γ* − 1 ≤ 1e-52); 1–4 doublings, never a halving; within 0.5673° of an axis, 90.0000° turns; ratio exactly 8670000/34690201; f + 7 from 3.0303 to 7.022e-10; P₁₆ 3.411e-5 from (3, 2); P₃ on inside the Ex 5 window; counter 64.
- **Case 2 (29–36):** all confirmed: φ₀(1) = 892.1648, six halvings; h₀ 0.606% short; across-valley 9.4933e-6 to 8.1273e-5 within 0.00386%; down-valley 5–8 doublings overshooting 0.056%–0.395%; counter 61; 1.674e-4.
- **Case 3 (37–45):** all confirmed: path lengths 0.025961, 0.22873, 0.28273; horizontal first steps, ≤ 1.0997° from an axis; run (i) 7 steps to 1.361e-11; counters 63; 0.004633, 0.003658; shortfalls ≤ 0.0384%, 1.651%, 2.006%.
- **Case 4 (46–53):** all confirmed: level curves exact circles centred on y = −x; h₀ = 4.819 vs 3.293; P₁ farther (4.283 vs 3.606); 0.7120, 0.6947, 0.8125, 0.9513; within 0.4876°; last search 15 halvings, not bracketed; P₈ 5.206e-20 away; counter 47.
- **Gradient section (54–58), method section (59–64):** confirmed, except 60 item 1 under the stated hypothesis (F2).
- **Mathews' implementation (65–70):** confirmed, with the in-loop exit omitted (F3); leftover f value in the first line of each Mathews table confirmed for all six.
- **Example 1 (71–82):** all confirmed, including exact rationals P₁ = (25656/10303, 10253/10303), 34 iterations without the counter, Mathews within 1.63e-11 and 4.49e-13.
- **Example 2 (83–93):** all confirmed, including κ ≈ 2508, 28 iterations without the counter, Mathews within 3.17e-11.
- **Example 3 (94–103):** confirmed except 100 (F1); 101 (gradient zero to 40 digits by 50-digit Newton) could not determine as a process claim; points confirmed (gradients ~1e-38).
- **Example 4 (104–116):** confirmed; 108 and the textbook agreement in 109 could not determine (textbook not available to the reviewer). Note on 114: the listed distance factors start from P₂ as the context says; the P₁ → P₂ factor 0.42 is not listed.
- **Example 5 (117):** confirmed.

## Implementation checks

All four scripts share one engine (steepest descent with a normalised direction, Mathews' Qmin bracketing with jmax = 15, one parabola-vertex step (3), Mathews' next-h rule, Err rule, counter j + 1, stop `count < 60 && (h > δ || Err > ε)`); the only deviation is the missing in-loop `h < δ` exit (F3), which has no effect. Script logs (256-bit) against the reviewer's 60-digit run: Ex 1 h₀ = 1.500222028, h₁₅ = 4.61367833e-5, P₁₆ = (2.999969402, 1.999984929); Ex 2 h₀ = 0.01332998765, γ* = 0.01341121672, h₈ = 0.000238231227, P₉ = (1.000071141, 1.000151509); Ex 3 final points (−0.02503609333, 0.0009402078319), (2.144840635, 1.584357508), (−2.178585108, 1.605145694); Ex 4 h₀ = 4.818676039, last search 15 H moves, h_k = 6.376830569e-11, final distance 5.206e-20 — all identical. Every table cell matches to its last printed digit; 60- and 120-digit runs agree to ≥ 51 digits. References P* verified (Ex 3 minima polished by 256-bit Newton, matching the resultant roots to 13 digits). Frames aa/1, aa/16, bb/1, bb/3, cc/1, cc/7, cc/8, cc/38, dd/1, dd/8 checked: titles, trial points, parabola, vertex and γ* markers, contour levels and scale labels correct; frame counts 19, 12, 41, 11; no clamping. No Error or Misleading issue in the drawing.
