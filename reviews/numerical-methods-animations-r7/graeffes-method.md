# Graeffe's Method — animation review (round 7)

Page: `pages/numerical-methods/graeffes-method/`. Reported findings: **0 Error, 0 Misleading, 2 Minor**.

## Findings

### F1. Page match, Minor: the scripts do not "square the coefficients"

- **Location:** `index.qmd` line 50: "The scripts square the coefficients in exact integer arithmetic".
- **Now:** The sentence says the operation applied to the coefficients is squaring.
- **True:** The scripts apply the root-squaring step. Only the two end coefficients are squared outright. The middle ones combine squares and cross products (`graeffesaa.jl` lines 24-28, `graeffesab.jl` lines 22-26):
  `d3 = 2*c4*c2 - c3^2`, `d2 = c2^2 + 2*c4*c0 - 2*c3*c1`, `d1 = 2*c2*c0 - c1^2`.
- **How I know:** `checks.py` expands $E(t)^2 - tO(t)^2$ symbolically and gets exactly those coefficients. For Case 1, $p_0 = [1,-2,-13,14,24]$ gives $p_1 = [1,-30,273,-820,576]$, whereas squaring each coefficient would give $[1,4,169,196,576]$.
- **Suggested correction:** "The scripts carry out the root-squaring step on the coefficients in exact integer arithmetic, because in double precision the coefficients overflow at $m = 8$: ..."

- **Independent check:** not run (Minor finding, unverified)

### F2. Page match, Minor: "halved each iteration" is not true of the first two steps

- **Location:** `index.qmd` line 62: "converge **linearly** — the error is halved each iteration rather than squared".
- **Now:** The halving is stated for every iteration, with no qualifier. The Case 1 paragraph, by contrast, explicitly separates its irregular first steps.
- **True:** The asymptotic rate is exactly 1/2, but the first two steps are not halvings.

| Step | $e_{m+1}/e_m$, $r_1$ estimate | $e_{m+1}/e_m$, $r_2$ estimate |
|---|---|---|
| 0→1 | 0.604 | **0.282** |
| 1→2 | **0.400** | **0.752** |
| 2→3 | 0.469 | 0.550 |
| 3→4 | 0.489 | 0.512 |
| 4→5 | 0.495 | 0.505 |
| 9→10 | 0.4998 | 0.5002 |

- **How I know:** `indep.py`, "Case2" error-ratio table. Absolute errors of the $r_2$ estimate are 3.556, 1.002, 0.754, 0.414, 0.212 for $m = 0$ to $4$.
- **Suggested correction:** "converge **linearly** — from about $m = 2$ on, the error is halved each iteration rather than squared".

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `graeffesaa.jl` | 0 | 7.9 | graeffesaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `graeffesab.jl` | 0 | 7.4 | graeffesab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `graeffesaa.gif` | 9 | byte-identical | graeffesaa |
| `graeffesab.gif` | 11 | byte-identical | graeffesab |

### Page references

- Scripts linked: `graeffesaa.jl`, `graeffesab.jl`
- GIFs embedded: 2
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

### Description

| # | Claim (page's words) | Line | Verdict | Evidence |
|---|---|---|---|---|
| 1 | $p_1(x) = (-1)^n p(\sqrt x)\,p(-\sqrt x)$ has roots $r_i^2$, degree $n$ | 20-22 | Confirmed | sympy identity holds for degrees 3, 4, 4 and 5 (`checks.py`) |
| 2 | $m$ applications give roots $r_i^{2^m}$ | 24 | Confirmed | Follows by induction from #1. Direct check: Case 1 $p_8$ coefficients match $(r_1\cdots r_k)^{256}$ (#7) |
| 3 | Ratios raised to $2^m$ separate the roots | 24 | Confirmed | Follows from #2; $(4/3)^{32} \approx 9.97\times10^3$ |
| 4 | $\lvert r_k\rvert^{2^m} \approx \lvert c_{n-k}/c_{n-k+1}\rvert$ | 30 | Confirmed | Script estimates converge to the true magnitudes (#14) |
| 5 | $\lvert r_k\rvert \approx \lvert c_{n-k}/c_{n-k+1}\rvert^{1/2^m}$; this is what the scripts compute | 34 | Confirmed | `mag_estimates`, index mapping `c[k+1]/c[k]` with descending storage |
| 6 | Sign chosen by which of $p(\pm\lvert r_k\rvert)$ is nearly zero | 36 | Confirmed | Case 1: $p(4)=0$, $p(-3)=0$, $p(2)=0$, $p(-1)=0$; the opposite signs give 144, −24, −24, 24. The scripts plot magnitudes only and the page says so (line 48) |
| 7 | $\lvert c_{n-k}/c_n\rvert \approx (\lvert r_1\rvert\cdots\lvert r_k\rvert)^{2^m}$ | 42 | Confirmed | Case 1, $m=8$: relative deviation 1.0e-32, 8.3e-46, 8.6e-78, 0 for $k=1..4$ |
| 8 | Real roots of distinct magnitude: error decreases quadratically, accurate digits roughly double, like Newton | 40 | Confirmed, with a note | Digit ratios in #15. Note: $e_{m+1}/e_m^2$ for $r_1$ is 1.007, 2.01, 4.0, 8.0, 16.0, so the classical asymptotic constant is unbounded (the error carries a $1/2^m$ factor). The order is 2 in the digit-doubling sense the page states, so I did not make this a finding |
| 9 | Special cases need modified formulas | 44 | Confirmed | Double-root and complex-pair behaviour in #19-#25 |

### Animations introduction

| # | Claim | Line | Verdict | Evidence |
|---|---|---|---|---|
| 10 | Each animation shows the estimates over $m = 0, 1, 2, \ldots$ | 48 | Confirmed | Frames: 9 ($m=0..8$), 11 ($m=0..10$) |
| 11 | Dashed lines mark true magnitudes; coloured traces show estimates | 48 | Confirmed | Plot code and frames |
| 12 | Scripts use exact integer arithmetic | 50 | Confirmed | `BigInt` coefficients. Wording of "square the coefficients" is **F1** |
| 13 | Double precision overflows at $m=8$; largest $p_8$ coefficient ≈ $2.2\times10^{353}$ (Case 1), $8.6\times10^{434}$ (Case 2) | 50 | Confirmed | Independent Float64 loop: first non-finite at $m=8$ in both. Exact maxima $2.1581\times10^{353}$, $8.6362\times10^{434}$ |

### Case 1

| # | Claim | Line | Verdict | Evidence |
|---|---|---|---|---|
| 14 | $f=(x+1)(x-2)(x+3)(x-4)$, true $\lvert r_k\rvert \in \{1,2,3,4\}$; script coefficients $[1,-2,-13,14,24]$ | 52 | Confirmed | sympy expansion and factorisation; `numpy.roots` gives 4, −3, 2, −1 |
| 15 | From $m=3$ on, correct digits in each estimate roughly double | 54 | Confirmed | Digit ratios, $m=3..7$: $r_1$ 1.68, 1.72, 1.78, 1.85, 1.90; $r_2$ 1.52, 1.68, 1.78, 1.85, 1.90; $r_3$ 1.73, 1.78, 1.83, 1.88, 1.93; $r_4$ 1.83, 1.85, 1.89, 1.93, 1.96 |
| 16 | $r_2$ estimate is 3.017 at $m=1$, moves away to 2.941 at $m=2$ | 54 | Confirmed | 3.0166206, 2.9409171; error grows ×3.55 |
| 17 | $\lvert r_1\rvert/\lvert r_2\rvert = 4/3$; a few squarings separate them | 54 | Confirmed | $(4/3)^{2^m}$ = 9.99 at $m=3$, 99.8 at $m=4$, $9.97\times10^3$ at $m=5$ |
| 18 | Link and embed are `graeffesaa`; alt text: roots −3, −1, 2, 4, traces move onto dashed lines | 56-58 | Confirmed | Files exist; frames match; manifest: committed GIF byte-identical to regeneration |

### Case 2

| # | Claim | Line | Verdict | Evidence |
|---|---|---|---|---|
| 19 | $f=(x-1)(x+2)(x-5)^2$, true $\lvert r_k\rvert \in \{1,2,5,5\}$; script coefficients $[1,-9,13,45,-50]$ | 60 | Confirmed | sympy expansion and factorisation |
| 20 | Double-root estimates converge linearly | 62 | Confirmed | Error ratio → 0.5 |
| 21 | "the error is halved each iteration" | 62 | **Wrong for the first two steps (F2)** | Ratios 0.28-0.75 there; 0.47-0.55 from $m=2$ on |
| 22 | Separated-root condition never holds for equal magnitudes | 62 | Confirmed | Ratio of the two magnitudes is 1 for every $m$ |
| 23 | Simple roots $\lvert r\rvert = 1, 2$ converge quadratically | 62 | Confirmed | Digits for $r_3$: 3.49, 6.05, 11.14, 21.07, 40.64, 79.47, 156.84, 311.27 ($m=3..10$); $r_4$ similar |
| 24 | A real pair $\pm r$ behaves the same because one squaring gives a double root | 62 | Confirmed | Mathews' Example 9, roots $\pm5, 2, -1$: $p_m$ is identical to Case 2's for all $m=1..10$ |
| 25 | Roots $3\pm4i, 2, 1$: top two estimates cross back and forth over 5, error does not halve, grows $m=4\to5$ and $m=7\to8$ | 62 | Confirmed | Sign of (estimate − 5), $m=0..10$: `+-+-+-++-++` and `0+-+-+--+--`. Growth ×2.07/×2.18 at 4→5, ×1.07/×1.08 at 7→8. The second estimate also grows at 0→1, from an exact 5.0; the page does not say these are the only growth steps |
| 26 | Link and embed are `graeffesab`; alt text: double root at 5, simple roots 1 and −2; two blue traces slow, crimson and orange fast | 64-66 | Confirmed | Colours in code and frames; manifest byte-identical |
| 27 | Final-frame annotation: $r_1, r_2$ linear; $r_3, r_4$ quadratic | GIF | Confirmed | Frame 11; rates as in #20 and #23 |

---

### 3. Implementation checks

### `graeffesaa.jl`

- **It is the method claimed.** Dandelin-Graeffe root squaring with separated-root coefficient-ratio estimates. The step matches the symbolic expansion of $E(t)^2 - tO(t)^2$ for degree 4 and my separate implementation via $(-1)^n p(x)p(-x)$.
- **The numbers are right.** Script Float64 estimates versus my 400-digit values, rounded to Float64: **maximum difference 0 over all $m$ and $k$** (`checks2.py`).

| $m$ | Script estimates | Independent |
|---|---|---|
| 0 | 2.0, 6.5, 1.0769, 1.7143 | 2.0, 6.5, 1.0769, 1.7143 |
| 1 | 5.4772, 3.0166, 1.7331, 0.83812 | 5.4772, 3.0166, 1.7331, 0.83812 |
| 2 | 4.3376, 2.9409, 1.9174, 0.98123 | 4.3376, 2.9409, 1.9174, 0.98123 |
| 4 | 4.0025, 2.9984, 1.9998, 0.99999904 | 4.0025, 2.9984, 1.9998, 0.99999904 |
| 8 | 4.0, 3.0, 2.0, 1.0 | 4.0, 3.0, 2.0, 1.0 (relative errors down to 3.4e-80) |

- **Reference values are right.** 4, 3, 2, 1 are the exact root magnitudes (sympy factorisation).
- **The picture shows what was computed.** Markers read from `frame_009.png` agree with the values for all 36 points, with maximum deviation 0.010 data units (under one pixel). No clamping or masking; every value is inside the axis limits. Title, legend and labels are correct. The committed GIF is byte-identical to a scratch regeneration.

### `graeffesab.jl`

- **It is the method claimed.** Same step and estimator as Case 1.
- **The numbers are right.** Maximum difference from the independent values is **0** over all $m$ and $k$.

| $m$ | Script estimates | Independent |
|---|---|---|
| 0 | 9.0, 1.4444, 3.4615, 1.1111 | 9.0, 1.4444, 3.4615, 1.1111 |
| 1 | 7.4162, 3.9977, 1.9449, 0.86711 | 7.4162, 3.9977, 1.9449, 0.86711 |
| 5 | 5.1095, 4.8929, 2.0000, 1.0000 | 5.1095, 4.8929, 2.0000, 1.0000 |
| 10 | 5.00339, 4.99662, 2.0, 1.0 | 5.00339, 4.99662, 2.0, 1.0 |

- **Reference values are right.** 5, 5, 2, 1 are the exact magnitudes.
- **The picture shows what was computed.** Crimson and orange markers in `frame_011.png` agree within 0.012 data units. Both blue traces are resolved and agree within 0.013 for $m \le 5$. From $m = 6$ the two blue markers overlap on screen (gap 0.108 data units, about 4.6 px, shrinking), so they read as one marker. The page describes both as approaching 5, so this does not mislead. No clamping or masking; every value is inside the axis limits. The committed GIF is byte-identical to a scratch regeneration.

---

### Archive comparison

Read `GraeffeMethodMod.html`, all example links and the available formula images. The archive has no Graeffe animation; `a2001/Animations/` has no Graeffe folder. The archive is a set of nine worked examples.

| Archive example | Polynomial or roots | On the page |
|---|---|---|
| 1 | Three widely separated quartics, separated-root theorem only | Theorem stated, not animated |
| 2, 3, 4 | $(x-4)(x+3)(x-2)(x+1)$ | **Case 1**, same polynomial |
| 5 | Roots $5, -3, 2, -1, 1/2, -1/5$ | Not used |
| 6 | $x^4 - 9x^3 + 13x^2 + 45x - 50$ | **Case 2**, same polynomial |
| 7 | Repeated root; **could not determine the polynomial** because `gr_434.gif` is missing from the archive | Not used |
| 8 | Degree 7, roots $10, 2, -1, -5, 1/2, -1/5, 1/10$ | Not used |
| 9 | $x^4 - x^3 - 27x^2 + 25x + 50$, roots $\pm5, 2, -1$ | Described in the Case 2 text, not animated |

Both animated cases are faithful to Mathews. His statement that the repeated root converges linearly and the simple roots quadratically is confirmed by computation. I did not record the unanimated examples as a Fidelity finding: the archive has no animation for them, the page does not claim to cover every example, and the one distinct behaviour among them (Example 9) is covered in the text and checked at ledger #24. The owner may still want to add Example 9 as a third case, but that is new content rather than an error.

History and attribution claims were left out, as the brief directs.

