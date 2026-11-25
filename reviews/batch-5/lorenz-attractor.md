# Review: Lorenz Attractor (batch 5, round 1)

**Findings: 1 Error (independently confirmed), 0 Misleading, 3 Minor (unverified).**

Legacy archive consulted: the module HTML, link pages lnk_1–lnk_7, the surviving equation images gr_8, 18, 113, 114, 240–248, 302–304; no Lorenz or Rössler animation under `a2001/Animations`. Independent computations: an own Julia Taylor integrator (order 32, step 0.005, 256-bit for Lorenz; order 30, step 0.01 for Rössler to t = 200) with dense output, reruns at other orders and precisions, the scripts' reference routines run verbatim, Benettin Lyapunov estimates, and Python/sympy/SciPy checks with an own RK4.

## Findings

### F1 — Page match — Error (confirmed by an independent checker): the after-spike minimum distance from the z-axis is misquoted

- **Location:** `index.qmd` line 315 (The Rössler Attractor): "In Example 5, after each of the first six spikes with $z > 5$, the distance from the $z$-axis drops from a maximum of $10.4$ to $12.4$ in the three time units before the spike to a minimum of $2.5$ to $5.6$ within four time units after it."
- **True instead:** the "before" range is right (12.38, 11.02, 11.25, 10.40, 12.22, 11.57). The smallest √(x²+y²) within four time units after the spikes at t = 6.26, 23.72, 35.46, 47.26, 58.93, 76.42 is 1.77, 3.97, 3.59, 4.97, 2.02, 3.06, so the range is **1.8 to 5.0**; each minimum comes about 0.3–0.4 time units after the peak in z.
- **Evidence:** reviewer `ross.py` on the dense order-30 Taylor reference (and the RK4 h = 0.05 grid: 1.77, 3.97, 3.60, 4.96); checker `check/ross.py`–`ross3.py` (SciPy DOP853 at 1e-12 and 1e-13, dense sampling, bounded minimiser: 1.76689, 3.97250, 3.58891, 4.97418, 2.01526, 3.05940). Coarser sampling, measuring after z falls below 5, or using the RK path all fail to give 2.5–5.6.
- **Fix:** "…to a minimum of $1.8$ to $5.0$ within four time units after it."

### F2 — Page match — Minor (unverified): Example 6's tallest spikes quoted from the 0.01 grid

- **Location:** line 54 (Case 3): "Example 6 has eight; the four tallest, from $51.77$ to $65.95$, make its attractor much taller."; alt text line 58: "up to 23.65 in Example 5 and 65.95 in Example 6".
- **True instead:** the four tallest spikes of the true solution are 63.18, 58.34, **51.80** and **65.975** (at t = 42.77); 51.77 and 65.95 are the reference's largest values on its 0.01 step grid. Example 6 on the same page correctly says the maxima reach 65.98. (The orange RK path peaks at 51.84 and 65.83 on its h = 0.05 grid.)
- **Fix:** "from $51.80$ to $65.98$" (line 54) and "65.98" (line 58).

### F3 — Page match — Minor (unverified): two first-crossing times in Example 1's m-table use the 0.02 grid without saying so

- **Location:** Example 1 Verification table (lines 205–211): $m = 2000$ → $7.24$ and $m = 8000$ → $18.82$ in the column "First $t$ with distance $> 1$".
- **True instead:** checked at every RK4 step the crossings are t = 7.23 (m = 2000; distance 1.0376, 0.9806 at 7.22) and 18.8025 (m = 8000; 1.0171, 0.9955 at 18.80). The page's values are what checking only at t = 0, 0.02, 0.04, … gives; the m = 1000 row's paragraph says so, the table does not. The other rows are confirmed (6.86, 15.04, never with max 0.425).
- **Fix:** change to 7.23 and 18.80, or add "(checked at $t = 0, 0.02, \ldots$)" to the column header.

### F4 — Page match — Minor (unverified, low confidence): the Rössler Lyapunov estimates look low

- **Location:** line 355 (Example 5 Verification): "estimated as $0.0649$ and $0.0671$ from runs of length $2000$ and $4000$ … errors grow $13$ to $14$ times more slowly than for the Lorenz system."
- **What was found:** the reviewer's Benettin estimates (RK4 h = 0.01 or 0.005, two starts, several transients and renormalisation intervals, T = 2000, 4000, 10000) all lie between 0.0694 and 0.0757 (literature about 0.0714), every one higher than the page's; with converged exponents (about 0.906 and 0.071) the ratio is about 12.7. The page's figures may be genuine output of some estimator.
- **Fix:** recheck the estimator; if confirmed, say "about 0.07" and "about 13 times more slowly".

Rounding near-misses noted by the reviewer, not findings: the fourth error ratio "16.6" (2-norm 16.548) and the last z maximum "35.28" (35.2746).

## Inventory (Phase 1)

3 scripts, 3 GIFs (231 frames for Case 1); all run; every GIF byte-identical to what its script produces; every reference resolves.

## Claim ledger (whole page; reviewer's verdicts)

- **Description (D1–D6), Animations introduction (A1–A8):** confirmed (equations; unstable C± with eigenvalues 0.094 ± 10.19i; RK4 vector form; reference Taylor order 30, 200-bit, within 2.13e-14 of independent references on [0, 50]; holds; no archive animation; omitted examples and graphs).
- **Case 1 (C1.1–C1.14):** confirmed: first > 0.01 at 1.72; 0.164 at t = 2, 0.0394 at t = 5 (not steady); first > 1 at 6.86 and stays above (min 1.035); 44.2 at 15.90; 10 vs 12 sign changes; end values and distance 8.24.
- **Case 2 (C2.1–C2.13):** confirmed: growth ≈ 1e-10 e^{0.90t}; LS slope 0.853; thresholds 7.09, 18.93, 24.97; then 0.49–45.35; 28 and 31 sign changes; end points.
- **Case 3 (C3.1–C3.15):** confirmed except C3.7 and the alt text C3.13 (F2): spikes 0.3–0.6 after x maxima above c; Example 5's four spikes, tallest 23.65 at 6.26; Example 6's eight; ends 0.057 and 0.47; first > 0.1 at 26.50.
- **Lorenz equations (T1–T21):** confirmed (symmetry, divergence, equilibria, eigenvalues, Routh–Hurwitz, r_H = 470/19, factorisation, scan, ω and period).
- **RK section (R1–R4):** confirmed (ratios 21.0 → 16.3 approaching 16).
- **Example 1 (E1.1–E1.13):** confirmed except E1.9 (F3); Lyapunov digits E1.11 CND (own 0.9046–0.9070).
- **Example 2 (E2.1–E2.8):** confirmed (LSODA step counts; reference table; solver table; sign changes).
- **Examples 3 and 4 (E3.1–E4.9):** confirmed (start B; tables; z maxima increasing 29.40 → 35.28; distance windows from C+; Lyapunov digits CND, positive confirmed).
- **Rössler and Examples 5–6 (S1–E6.8):** confirmed except S4 (F1) and E5.7–E5.8 (F4): equilibria table; tables; 8.60 and 6.83 turns; z < 1 for 87 %; boxes; within 0.058; order-25 run identical.

## Implementation checks

- **lorenzaa.jl:** classical RK4; order-30 Taylor reference with correct Cauchy-product recurrences; Z₁₀₀₀, distances, crossings and sign counts identical to the independent run; frames 1, 70, 101, 201 checked; nothing clamped.
- **lorenzbb.jl:** two order-30 Taylor runs in 200-bit; thresholds, distances, slope and end points identical; frames 101 and 201 checked.
- **lorenzcc.jl:** same RK4; Rössler recurrence correct; reference bit-identical to the independent one at every 0.01 point on [0, 50]; frames 30 and 201 checked; drawn spike tops are RK grid values (acceptable).
