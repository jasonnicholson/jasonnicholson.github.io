# Review: Power Series (batch 9, round 1)

**Findings: 1 Error (independently confirmed), 0 Misleading, 1 Minor (unverified).** (The reviewer's report that the section index links the deleted flat `power-series.qmd` is withdrawn: section-index links are changed in each page's "Add animations" commit, after this review.)

No Mathews module exists for this topic, so no archive and no Fidelity check. Independent computations: Python with mpmath at 40–150 digits and sympy (Airy, Legendre, and √(1+x²) about 0 and 1), double-precision summation variants, bisection for every shaded-interval edge.

## Findings

### F1 — Page match — Error (confirmed by an independent checker): the 0.4140 step is between the wrong frames

- **Location:** `index.qmd` line 36 (Case 1 Behavior): "most of the animation shows its left end moving out, by less in each frame: from $0.4140$ between $N = 15$ and $18$ to $0.2372$ between $N = 84$ and $87$."
- **True instead:** the left end of the interval where |S_N − Ai| < 10⁻³ is at −2.70546 (N = 15), −3.14784 (N = 18), −3.56175 (N = 21), so it moves 0.44238 between N = 15 and 18 and 0.41392 (0.4139 to 4 s.f., not 0.4140) between N = 18 and 21. The 84 → 87 move 0.23716 matches. The moves decrease strictly, so "by less in each frame" holds.
- **Evidence:** reviewer `ex1b.py`, `ex1c.py` (40 digits); checker `check/left.py` (80 digits, the script's definition clipped to [−10, 3]); committed frames 5, 6, 7 of `powerseriesaa.gif` (titles −2.705, −3.148, −3.562).
- **Fix:** "from $0.4139$ between $N = 18$ and $21$ (after the right end reaches $x = 3$) to $0.2372$ between $N = 84$ and $87$", or keep N = 15 and 18 and quote $0.4424$.

### F2 — Page match (direction word) — Minor (unverified): "farther from N = 4 on" fails at N = 4

- **Location:** line 306 (Example 3): "At $x = 1.5$ the partial sums fall alternately above and below the exact value $1.80278$ and, from $N = 4$ on, each is farther from it than the one before".
- **True instead:** |S_N(1.5) − 1.80278| is 0.3222 at N = 2 and 0.3106 at N = 4, so S₄ is closer; from N = 6 on every error is larger than the one before (0.4013, 0.5998, …, checked to N = 300). The alternation is confirmed.
- **Evidence:** `ex3.py`: `err1.5 N=0,2,4,6 ['0.8028','0.3222','0.3106','0.4013',...]`, `farther from N=4 (vs N=2)? False`, `from N=6 on all farther True`.
- **Fix:** "from $N = 6$ on".

## Inventory (Phase 1)

3 scripts, 3 GIFs (43, 22, 22 frames); all run; every GIF byte-identical to what its script produces; every reference in the page folder resolves.

## Claim ledger (whole page; 145 entries; reviewer's verdicts)

- **Description (1–8):** confirmed (ordinary points, recurrence, radius to the nearest complex singular point, divergence outside the disk; three examples).
- **Animations introduction (9–19):** confirmed (panels, shading, x₀ ± R lines, leaving-window drawing with true labels, 256-bit sums; Examples 2–3 animated to N = 40; y = x not animated).
- **Case 1, Airy (20–39):** confirmed except 30 (F1): [−0.4667, 0.4661] at N = 3, [−2.227, 2.210] at N = 12; reaches x = 3 from N = 18, whole window from N = 90; error at x = −10 above 1 up to N = 75, largest 2.264e6 at N = 24, below 1e−10 from N = 111, 5.359e−15 at N = 120; S₃ spike at −2.905.
- **Case 2, Legendre (40–50):** confirmed: every term after the first negative, S_N decreasing toward y; x* = 0.2321, 0.6604, 0.8050, 0.8951; y leaves the window at ±0.9993; S_N(±1.1) = −1.647, −3.212, −10.15.
- **Case 3, √(1+x²) (51–67):** confirmed: disks of radius 1 and √2; intervals at N = 40; left end of the series about 1 moves back at N = 6, 10, …, 38; S₄₀(1.5) = −2.402e4; 4.859e−22 for the series about 1; the interval about 0 would pass x = 1 at N = 54.
- **Theory, Examples 1–3 (68–139):** confirmed except 124 (F2) (Ai(0), Ai′(0); recurrences and products; residual identity; all error tables; x = 1.1 minimum 0.0300 at N = 16; root-test values; re-centred coefficients).
- **Practical notes (140–145):** confirmed except 142, CND: the double-precision error 4.2e−9 of S₁₂₀(−10) depends on the summation (variants give 3.0e−9 to 6.3e−9; Horner reproduces 4.25e−9); about seven correct digits confirmed.

## Implementation checks

- **powerseriesaa.jl:** recurrence (3) in exact rationals combined with Ai(0), Ai′(0); coefficients match mpmath's Taylor coefficients to 6e−157; errors and all 40 edges match the independent bisection; frames 1, 8, 40 checked.
- **powerseriesbb.jl:** recurrence (4) asserted against −1/(2k−1); x* for all 20 frames match; reference 1 − x artanh x verified by sympy; frames 5 and 20 checked.
- **powerseriescc.jl:** recurrences (5) and (6) asserted; Horner sums in t = x − x₀; both edge sequences match; frames 2 and 20 checked.
