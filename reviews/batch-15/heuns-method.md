# Heun's Method — batch 15 review (round 1)

Page: `pages/numerical-methods/heuns-method/` (new page). Mode: full review of both cases; the Description (all new text) checked in overview mode; also the one-line edits to the Euler's Method and Predictor-Corrector pages.

**Result: 0 Error, 0 Misleading, 2 Minor.** Minor findings are reported unverified by the skill's rule; F1 was also found independently by the calibration reviewer (whose report on a planted copy is otherwise discarded).

Archive consulted: module HTML, its 12 solution pages, `Heun'sMethodProof.pdf` (pdftotext; Mathews and Fink §9.3), and all 36 frames of `a2001/Animations/OrdinaryDE/Heun1/Heunaa.gif`.

Independent reference: scipy DOP853 (rtol 2.3e-14, atol 1e-18), cross-checked with Radau: y(5) = 0.00811992046486797; solution maximum 1.4497667 at t = 0.88356, minimum on [0, 5] at t = 5.

## Findings

### F1. Minor — Page text (Description) and script comment: "m ≤ 68" includes m = 1 and 2

- **Location:** `index.qmd` line 43: "For $m \le 68$ some predictions $p_{n+1}$ are negative, so those runs also depend on how $\sqrt[3]{y}$ is taken there". Same claim in the comment at `heunsmethodaa.jl` line 17.
- **What is true:** negative predictions occur exactly for m = 3 to 68 (smallest at m = 68 is −3.15e-5; at m = 69 it is +1.73e-3; none for m = 69..399). At m = 1 the only prediction is p₁ = 6 (y₁ = −16.714, but no cube root of a negative is taken). At m = 2 the predictions are 3.5 and 7.978; the run depends on the cube root through y₁ = −1.2447, not through a prediction.
- **How we know:** reviewer's scan of m = 1..399 (`desc.py`): "m with negative predictions: [3 … 68], count 66"; the calibration reviewer's independent scan gave the same.
- **Effect:** small; the conclusion (coarse runs depend on the cube-root branch) still holds.
- **Correction:** "For $3 \le m \le 68$ some predictions $p_{n+1}$ are negative (and for $m \le 2$ some computed $y_n$ are), so …"; same change in the script comment.

### F2. Minor — Page text (Description, overview point 4): the order statement does not point to the case that shows it

- **Location:** `index.qmd` line 23: "the global error … is $O(h^2)$: for small $h$, halving $h$ divides the error by about 4, against 2 for Euler's method."
- **What is there:** no case link. Case 2's right panel shows exactly this (slopes per halving 2.00–2.11 for Heun against 1.00–1.01 for Euler; fits 2.02 and 1.00). The Description links Case 2 only at line 38, for a different point.
- **Standard:** "Where an animation on the page shows this, point to the case."
- **Correction:** end line 23 with "([Case 2](#case-2), right panel)".

## Unresolved

None.

## Inventory (director's Phase 1)

- Scripts: `heunsmethodaa.jl` → `heunsmethodaa.gif` (21 frames); `heunsmethodbb.jl` → `heunsmethodbb.gif` (10 frames). Both ran in scratch; both GIFs byte-identical to the committed files.
- No control characters, leftover placeholder sections, localhost links or code blocks; every page link and case anchor resolves; every `.jl`/`.gif` is referenced; the section index links the page.
- Description prose: 368 words (director and reviewer agree). Within 150–400.

## Claim ledger (reviewer)

Line numbers refer to `index.qmd`. C = confirmed, W = wrong.

### Description

| # | Claim | Verdict |
|---|---|---|
| D1 | L12: problem statement and grid | C |
| D2 | L13: integral form, trapezoid rule, Euler prediction | C (Mathews 9.3, eqs 3–6) |
| D3 | L15–18: predictor and corrector formulas | C (Mathews eq 6; both scripts) |
| D4 | L20: also called improved or modified Euler | C |
| D5 | L20: Mathews' modified Euler is the midpoint method | C (Euler page L21–24) |
| D6 | L22: f continuous and Lipschitz in y | C (module text) |
| D7 | L22: precision theorem assumes y ∈ C³ | C (PDF Theorem 9.4) |
| D8 | L23: local O(h³), global and final global O(h²) | C (general; Theorem 9.4) |
| D9 | L23: halving h divides error by about 4, against 2 for Euler | C (table 4.25 → 4.03; Case 2 Euler 1.99–2.01) |
| D10 | L25: y(5) = 0.0081199205 | C |
| D11 | L26: f not Lipschitz near y = 0 | C |
| D12 | L26: solution never falls below y(5) | C |
| D13 | L27: y₁₅₀ = 0.0081236, Mathews' last frame | C (0.0081235818; legacy frame 36) |
| D14 | L32–36: all 30 table entries | C (e.g. 0.0081203664 / 4.4593e-7 / 7.6993e-5 / 8.21 / 4.25) |
| D15 | L38: at m = 150 Heun's error at t = 5 about twice Euler's | C (2.13) |
| D16 | L38: larger than Euler's up to m = 205 | C (larger for m = 39..205, smaller for 206..999) |
| D17 | L38: largest error 69 times smaller than Euler's | C (68.65) |
| D18 | L38: link to Case 2 | C |
| D19 | L40: factor 1 + z + z²/2; ≤ 1 only on −2 ≤ z ≤ 0 | C |
| D20 | L41: ∂f/∂y reaches −41.3 at t = 5 | C (−41.2554; monotone along the solution) |
| D21 | L41: threshold h ≈ 0.0485 (m ≤ 103) | C (0.048478; 103.14) |
| D22 | L41: every run with m ≤ 103 ends with a larger error than before onset | C (all m = 1..103) |
| D23 | L41: link to Case 1 | C |
| D24 | L42: m = 70 onset 4.40, error 1.0e-4 → 9.0e-3, y₇₀ = 0.0171 ≈ 2·y(5) | C |
| D25 | L43: for m ≤ 68 some predictions negative | W at m = 1, 2 only (F1) |
| D26 | L45: equation (4) of Predictor-Corrector | C |
| D27 | L45: second-order RK; RK4, Taylor reach higher orders | C (general; links exist) |
| D28 | Six points and limits | C except point 4 lacks a case pointer (F2); 368 words; 5-row table; no callouts or proofs |

### Animations introduction

| # | Claim | Verdict |
|---|---|---|
| A1 | Same IVP, real cube root | C |
| A2 | Case 1 rebuilds Heunaa.gif as on the Euler page | C |
| A3 | RK4 reference with 50 000 steps | C |
| A4 | Labels y(5), error at t = 5, largest error | C |
| A5 | Red band where h\|∂f/∂y\| > 2 along the reference | C (band valid since \|∂f/∂y\| monotone) |
| A6 | Case 2 new, log-log errors for three methods | C |
| A7 | Legacy GIF: 36 frames, 21 runs, every y(5) agrees to 7 decimals | C (all 21 read) |
| A8 | Example 11 links to it | C (lnk_12) |
| A9 | Not-animated list | C (lnk_5, 9, 10, 11 and the PDF) |

### Case 1

| # | Claim | Verdict |
|---|---|---|
| C1–C2 | m = 12 to 150; the 21 values | C |
| C3 | Peak ≈ 1.4498 near t = 0.88; y(5) = 0.0081199 | C |
| C4 | No computed y_n negative | C |
| C5–C6 | m = 12–60 turn up; rises 1.17, 0.071; end 1.386, 0.0832 | C (1.174, 0.0712) |
| C7 | Downward steps at m = 36, 40, 48–60, at most 0.036 | C (0.0355) |
| C8 | m = 70 upturn 0.0070; y(5) ≈ 0.0171 | C |
| C9 | From m = 80 on, monotone after the peak | C |
| C10 | Negative predictions for m = 12–60, none from 70 | C |
| C11–C13 | Onset 2.99 → 4.95; error at t = 5 larger than before onset; none for 120, 150 | C |
| C14 | Heun's factor ≥ 1/2, > 1 beyond limit; Euler's < −1 | C |
| C15 | Error positive from onset to t = 5 for m = 12..100 | C |
| C16 | Turns at t = 2.81–3.06 before the band, runs 15–77% above | C |
| C17 | Error at t = 5 falls every refinement, +1.4 → +3.7e-6 | C |
| C18 | Largest error at t = 5 for m = 12–70 (one step before at 52, 60) | C |
| C19–C20 | From m = 80, largest error at t = 3.08–3.12; 1.9–89 times the t = 5 error | C |
| C21 | Falls by 3.96 vs (150/80)² ≈ 3.5 | C |
| C22 | 69× Euler's, ≈ 2× midpoint's; t = 5 error ≈ 2× either | C |
| C23–C24 | Alt text; wiring | C |

### Case 2

| # | Claim | Verdict |
|---|---|---|
| E1–E2 | m = 125..16000; h 0.04 → 3.125e-4; all h < 0.0485; last frame ×3 | C |
| E3–E6 | Panels, signs, RK4 400 000 reference, guide lines, slope definition | C |
| E7 | Right-panel slopes and fits | C (1.000–1.008; 2.002–2.111; fits 1.002, 2.026, 2.024) |
| E8–E9 | Heun vs midpoint 2.05–2.07; vs Euler 56 and ≈ 8200; locations | C |
| E10 | Euler slopes at t = 5 0.99–1.00; 1.3e4 smaller than its largest | C |
| E11–E12 | Midpoint/Heun slopes at t = 5 and fits | C |
| E13 | At h = 0.04 Heun 8.5e-6 vs Euler 2.1e-6; smaller from 0.02 | C |
| E14–E15 | Alt text; wiring | C |

### Other pages

| # | Claim | Verdict |
|---|---|---|
| O1 | Euler page: "Heun's Method, which corrects an Euler predictor with the trapezoidal rule, is also of order 2" | C |
| O2 | Predictor-Corrector page: link added to the existing sentence | C |

## Implementation checks

- **`heunsmethodaa.jl`:** classic Heun (Euler predictor, trapezoidal corrector), not the midpoint method. Its `heun()` copied verbatim and run on Mathews' Example 9.6 (y′ = (t − y)/2, y(0) = 1, h = 0.25) gives y₁ = 0.8984375 and y₁₂ = 1.672269, Mathews' values; the end error falls by about 4 per halving against the exact solution. Instrumented copy agrees with the reviewer's Python for all 21 runs to every printed digit (e.g. m = 150: 0.0081235818 / +3.6613e-6 / 3.2734e-4 at t = 3.1000). Reference RK4 y(5) = 0.008119920465 matches DOP853. Frames 1, 15, 16, 17, 21 and the contact sheet viewed: band, labels and window correct; nothing clamped.
- **`heunsmethodbb.jl`:** `euler_step`, `mid_step`, `heun_step` are forward Euler, explicit midpoint and Heun. Instrumented copy agrees with the reviewer's Python to all printed digits (Heun error at t = 5 +8.4770e-6 … +1.0318e-10; Heun largest 4.8280e-4 … 2.5583e-8); every slope sequence identical. Reference RK4 400 000 steps matches DOP853. Frames 1 and 10 viewed: points inside the axes, guide lines through the smallest-h points, printed slopes correct.
- **Fidelity:** Case 1 reproduces Heunaa.gif (same IVP, 21 m values, printed y(5) values); Case 2 declared new; not-animated examples listed accurately. No Fidelity findings.
