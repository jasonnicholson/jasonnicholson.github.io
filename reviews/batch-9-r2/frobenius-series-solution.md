# Review: Frobenius Series Solution (batch 9, round 2)

**Findings: 0 Error, 0 Misleading, 3 Minor (unverified).**

This was a fresh, independent review: the reviewer read no earlier review or fix record and did not compare the page with any other copy. Legacy archive consulted: the module page, the Links pages for Examples 7–10, the surviving code and output images, the Proof page and the animation archive. Independent computations: mpmath at 30–50 digits (40-digit x* scans with root refinement), sympy series and residuals, an independent implementation of recurrence (5), SciPy Bessel zeros and a bounded minimiser.

## Findings

### F1 — Page match (cross-reference direction) — Minor (unverified): "the table above" is below

- **Location:** `index.qmd` line 40 (Case 2 Behavior): "So mode $n$ has $n - 1$ nodal circles, at the radii of the table above, which the titles give to four figures."
- **True instead:** the nodal-radii table (lines 521–527, "The surface of the vibrating drum") is below the Animations section. Every other above/below cross-reference on the page points the right way.
- **Fix:** "at the radii in the table of the vibrating-drum section below".

### F2 — Page match — Minor (unverified): "each two more terms" means one more nonzero term

- **Location:** line 32 (Case 1 Behavior): "From $N = 8$ on, each two more terms move $x^*$ about $0.76$ farther out."
- **True instead:** the numbers and direction are right (steps 0.7565–0.7621 for y₁ and 0.7525–0.7622 for y₂), but one step is N → N + 2, which adds one nonzero term (the odd coefficients are 0), as line 24 says. "Two more terms" can be read as two nonzero terms.
- **Evidence:** `xstar.py` (40-digit scan and root find).
- **Fix:** "From $N = 8$ on, each further nonzero term (two more powers of $x$) moves $x^*$ about $0.76$ farther out."

### F3 — Page text — Minor (unverified): a series about a general point is written about 0

- **Location:** line 12 (Description): "…has power-series solutions $\sum c_n x^n$ about any point where $P(x) \ne 0$."
- **True instead:** about a point x₀ with P(x₀) ≠ 0 the series is $\sum c_n (x - x_0)^n$.
- **Fix:** "…has power-series solutions $\sum c_n (x - x_0)^n$ about any point $x_0$ where $P(x_0) \ne 0$."

No Fidelity findings.

## Inventory (Phase 1)

3 scripts, 3 GIFs (13, 110 and the Case 3 surface animation); all run; every GIF byte-identical to what its script produces; every reference resolves.

## Claim ledger (whole page; 125 entries; reviewer's verdicts)

- **Description (1–7), Animations introduction (8–15):** confirmed (1's notation is F3).
- **Case 1 (16–30):** confirmed (22's wording is F2): x* widens with every partial sum, 0.1292 → 7.319 and 0.01587 → 6.939; smaller for y₂ at every N; S_N above/below by N mod 4; only S₀ for y₂ dips back (6.213 < x < 6.354).
- **Case 2 (31–49):** confirmed except 42 (F1), including the round-1 wording now in place: the minimum between λ₁ and λ₂ is J₀(3.8317) = −0.40276, and the sweep comes closest at λ = 3.8, whose frame shows −0.4026.
- **Case 3 (50–62):** confirmed, including the round-1 wording now in place: when pink rises, cyan falls, and vice versa.
- **Background, theorem, derivation (63–73):** confirmed (73's process claim CND; every x* reproduced).
- **Examples 1–6 (74–107), drum and Examples 7–10 (108–125):** confirmed (every coefficient and x* table; Bessel and Gamma closed forms; zeros, turning points and mode tables; Mathews' six-figure values).

## Implementation checks

- **frobeniusaa.jl:** recurrence (6) in exact rationals asserted against the closed forms; all 22 x* match to 4 s.f.; frames 1, 6, 11 checked.
- **frobeniusbb.jl:** Newton from kπ; zeros match mpmath and SciPy; 110 frames; frames 1, 14, 27, 50, 110 checked.
- **frobeniuscc.jl:** same zeros; periods, radii and frame times match; frames 1, 7, 13 checked.
