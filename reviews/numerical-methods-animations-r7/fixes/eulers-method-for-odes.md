# Fix record: eulers-method-for-odes

Scratch folder (all scripts and outputs): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r7fix/eulers-method-for-odes/fix/`

- `check.py` / `check.out`: independent Python check of F1 to F3 (own Euler and midpoint loops, DOP853 reference with rtol 1e-13, onset by root-finding).
- `check2.py` / `check2.out`: size of the error against the reference, perturbation experiment, decomposition of the error.
- `check3.py` / `check3.out`: checks of the final wording.
- `check4.py` / `check4.out`: sign and size of the local error against the inherited term, m = 50 to 100.
- `check5.py` / `check5.out`: largest |e|/Y over all nodes and before the onset (for the revised sentence after the checker's readability note).
- `inst_aa.jl`: instrumented copy of the script's own functions (its RK4 reference and `onset`).

Run with `/usr/bin/python3 <file>` and `julia inst_aa.jl`.

## Findings

### F1 — Misleading — fixed

- **Reproduced:** `check.py` and `inst_aa.jl` agree. Of the 110 steps at or after the onset (m = 10 to 100), the tangent factor $1+h f_y(t_n,Y_n)$ is below -1 at all 110. The true secant factor $A_n$ is below -1 at 99 and in [-1, 0) at 11, all for m = 10 to 40. The per-m table in the review reproduces exactly. Worked example (m = 25, t = 4.2): y = 0.44313, Y = 0.01392, e = +0.42921, A = -0.0212, tangent -3.838, next error -0.00932.
- **Two corrections to the finding's wording:**
  - "46 times smaller" is the next error against the inherited error (0.42921 / 0.00932 = 46). Against the tangent prediction of -1.647 it is 177 times smaller. The page quotes neither ratio.
  - The suggested sentence ("amplifying it with alternating sign") would still be false of the total error for m >= 50. There the error does not change sign at any in-band step (0 sign changes for each m = 50 to 100), and for m = 55 to 100 its size falls at every in-band step. The reason is that $e_{n+1}=A_n e_n+d_n$ and the local error $d_n$ is larger than $A_n e_n$ and opposite in sign at all 47 in-band steps for m = 50 to 100 (`check4.py`; for example m = 60, t = 4.25: $A e=+1.90\times10^{-5}$, $d=-3.35\times10^{-5}$, $e_{n+1}=-1.46\times10^{-5}$). What is amplified with alternating sign is the inherited part. A perturbation of 1e-9 added at the first in-band node alternates and grows at every step for m = 45 to 100 (final amplification 1.3e3 at m = 45, 73 at m = 60, 1.5 at m = 90), matching the product of the tangent factors (`check2.py`). The new sentence therefore says the step "adds its own local error" and that "the inherited part" is amplified.
- **Also avoided:** the old "From then on" opening, which echoes a wording D2 forbids.
- **Change:** `index.qmd` lines 62-69. Before: "From then on each step multiplies the error it inherits by $1+h\,\partial f/\partial y<-1$, amplifying it with alternating sign instead of damping it. At $m=10$ this starts at $t\approx2.92$". After: "There, while the error is small compared with the reference solution, each step multiplies the error it inherits by about $1+h\,\partial f/\partial y<-1$ and adds its own local error, so the inherited part is amplified with alternating sign. For $m=10$ to $40$ the error grows to more than $25$ times the reference solution at the same $t$, so this linear picture no longer holds and individual steps can shrink the error: at $m=25$ the step from $t=4.2$ takes it from $+0.429$ to $-0.009$. At $m=10$ the onset is at $t\approx2.92$".
- **Check:** `check3.py`. For in-band steps with |e|/Y < 0.1 (66 steps), all have A < -1 and A is within 3.6% of the tangent factor. The largest in-band |e|/Y is 25.4 to 68.8 for each of m = 10 to 40, and at most 0.226 for m >= 45. The m = 25 frame shows the spike at t = 4.2 collapsing at the next node.

### F2 — Minor — fixed (text only)

- **Reproduced:** `check.py`. `onset` reads `yref`. In-band step-start nodes whose own $h|f_y(t_n,y_n)|\le2$ match the review's counts in both cases, including all nodes in band for Case 2 at m = 14, 16, 18, 20, 24, and the two out-of-band nodes above 2 in Case 1 (m = 15 at t = 3.000, m = 25 at t = 3.200).
- **Change:** `index.qmd` line 33 (band definition: "evaluated along the reference solution rather than the plotted run"), line 62 (Case 1) and line 102 (Case 2) ("along the reference solution"), alt text lines 78 and 109 ("evaluated on the reference solution").
- **Not changed:** the frame legend and label. The finding offers the legend change as optional, and R7-D takes the smallest correct option, so both GIFs stay byte-identical.
- **Check:** the sentences "stays below 2 up to t = 5" (m = 110 to 150, and m = 120, 150 in Case 2) needed no qualifier: they hold on the reference (largest 1.875) and at the run's own nodes (largest 1.824 in Case 1, 1.675 in Case 2).

### F3 — Minor — fixed

- **Reproduced:** `check.py` and `inst_aa.jl`. The maximum error falls strictly across all 20 runs. Doubling ratios: 2.477, 2.658, 3.200, 7.921, 6.715, 6.756, 5.254 for m = 10 to 40; 2.031, 2.029, 2.024, 2.024, 2.019 for m = 45, 50, 55, 60, 70.
- **Change:** `index.qmd` line 58: "It falls at every refinement in the sweep and, from $m=45$ on, about halves when $m$ doubles".
- **Check:** as above. All five doubling pairs starting at m >= 45 give 2.02 to 2.03.

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| line 33 | band "evaluated along the reference solution rather than the plotted run" | script `onset` reads `yref`, `tref` (lines 63-65 of each script) | yes |
| line 58 | "from $m=45$ on, about halves when $m$ doubles" | `check.py` → ratios 2.019 to 2.031 for the five pairs from m = 45 | yes |
| line 62 | "$h\|\partial f/\partial y\|$ along the reference solution exceeds ... 2 before t = 5" for m = 10 to 100 | `check.py` → onset 2.923 to 4.949; none for m >= 110 (largest 1.875) | yes |
| lines 64-66 | "while the error is small ... multiplies ... by about $1+h\,\partial f/\partial y<-1$" | `check3.py` → tangent factor < -1 at 110/110; for \|e\|/Y < 0.1, 66 steps, A < -1 at all, within 3.6% | yes |
| lines 65-66 | "and adds its own local error" | exact identity $e_{n+1}=A_n e_n+d_n$; values in `check2.py`, `check4.py` | yes |
| line 66 | "the inherited part is amplified with alternating sign" | `check2.py` → 1e-9 perturbation alternates and grows at every step, m = 45 to 100 | yes |
| line 67 | "For m = 10 to 40 the error grows to more than 25 times the reference solution at the same t" (revised after the checker's readability note) | `check5.py` → largest \|e_n\|/Y(t_n) over all nodes: 217.9, 125.3, 88.0, 67.0, 47.1, 37.0, 25.4 for m = 10 to 40, and 0.88 at m = 45; largest before the onset 0.216 to 0.638, so "grows" holds. In-band step starts alone (`check3.py`): 67.1, 68.8, 46.0, 30.8, 33.7, 37.0, 25.4 | yes |
| lines 67-68 | "so this linear picture no longer holds and individual steps can shrink the error" | `check.py` → 11 steps with A in [-1, 0), all with e/Y >= 16; A differs from the tangent factor by up to 412% for \|e\|/Y >= 1 | yes |
| lines 68-69 | "at m = 25 the step from t = 4.2 takes it from +0.429 to -0.009" | `check.py`, `inst_aa.jl` → e = +0.42921, next -0.00932 | yes |
| line 69 | "At m = 10 the onset is at t ≈ 2.92" | `check.py` → 2.923 | yes |
| line 78 (alt) | "evaluated on the reference solution" | as line 33 | yes |
| line 102 | "along the reference solution exceeds 2 before t = 5" for m = 12 to 100 | `check.py` → onset 2.987 to 4.949 | yes |
| line 109 (alt) | "evaluated on the reference solution" | as line 33 | yes |

## Scripts and GIFs

- No scripts changed and no GIFs regenerated.
- Frames viewed at full size, extracted from the committed GIFs: Case 1 m = 25 (spike at t = 4.2 collapses at the next node, band from t ≈ 3.28) and Case 2 m = 14 (band from t ≈ 3.04 over a run whose nodes do not themselves exceed 2, the situation F2 describes).
- `git status -- pages/numerical-methods/eulers-method-for-odes`: only `index.qmd` modified.

## Legacy archive

Consulted: `n2003/Euler'sMethodMod.html` and its example links (Examples 1 to 12). The module gives the method and the $O(h)$ error analysis, and its only occurrences of "stability" are titles in the bibliography, so it has no statement about this instability to compare with. The round-7 review already compared all legacy $y(5)$ values and both animations with the page and found no Fidelity difference. None of these fixes changes a run, a parameter or a printed value.

## Notes

- **For the director:** the frame legend still reads "h·|∂f/∂y| > 2" without "on reference". This was the optional part of F2. If Jason wants it, it is a one-string change in each script plus a regeneration of both GIFs.
- The adjacent, unchanged sentence "$\partial f/\partial y$ is strongly negative late in the run, which damps the error made earlier" was rechecked because the new text sits next to it. From the node of the largest error to t = 5, the product of $|1+h f_y|$ along the reference is 2.3e-5 at m = 55 and smaller for every larger m in the sweep (`check3.py`), so the net effect is damping even with the amplifying steps in the band.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: the universal "From then on each step multiplies the error it inherits by 1+h∂f/∂y<−1" is gone. The replacement (index.qmd 64-69) restricts the linear factor to "while the error is small compared with the reference solution", says "about", adds the local error, and says that for m=10 to 40 the linear picture fails and individual steps can shrink the error. Independent recomputation (check/chk.py, Euler runs and RK4 reference with ≥50 000 steps per node, as in the script): over the 110 steps starting at/after onset, the secant factor A_n is below −1 at 99 and in [−1,0) at 11, all for m=10 to 40, exactly the review's table. For m=45 to 100 A_n lies in [−3.65, −1.00), all below −1. m=25 step from t=4.2: e_n=+0.42921 → e_{n+1}=−0.00932, A_n=−0.021, matching "+0.429 to −0.009". Max |e_n|/Y_n is 218 (m=10), 125, 88, 67, 47.1, 37, 25.4 (m=40), then 0.88 at m=45, so "more than 25 times the reference value" for m=10 to 40 is true and sharp. Frame m=25 (frame_004.png) shows the spike at t=4.2 collapsing to near the reference at t=4.4.

### F2 — resolved
- Evidence: line 33-34 now says the band is evaluated "along the reference solution rather than the plotted run"; lines 62-63 (Case 1) and 102 (Case 2) say "along the reference solution"; both alt texts say "evaluated on the reference solution". The scripts' `onset` reads `yref`, so the text now describes what the code draws. The frame legend "h·|∂f/∂y| > 2" and label "h·|∂f/∂y| > 2 from t ≈ ..." are unchanged. The review marked the legend change as optional, and R7-D says to take the smallest correct option, so the page is now unambiguous without it.

### F3 — resolved
- Evidence: the sentence now reads "falls at every refinement in the sweep and, from m=45 on, about halves when m doubles". Recomputed doubling ratios: 2.48, 2.66, 3.20, 7.92, 6.71, 6.76, 5.25 (m=10 to 40), then 2.031, 2.029, 2.024, 2.024, 2.019 (m=45, 50, 55, 60, 70). Strict decrease across all 20 m: True. Values 5.7e-2 (m=60), 2.8e-2 (m=120), 2.2e-2 (m=150) are confirmed.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| l.33-34 | band "evaluated along the reference solution rather than the plotted run" | script `onset` loops over `tref, yref` | true |
| l.58-59 | "from m=45 on, about halves when m doubles" | ratios 2.02-2.03 for m≥45, 2.48-7.92 for m≤40 | true |
| l.59-60 | 5.7e-2 / 2.8e-2 / 2.2e-2 at m=60/120/150 | recomputed 0.057 / 0.028 / 0.022 | true |
| l.61-63 | h=0.0485, m≤103, "along the reference solution exceeds 2 before t=5" | max over the reference of |f_y| is 41.255 at t=5, so h_crit=0.04848 and m_crit=103.14 | true |
| l.64-66 | "while the error is small ... multiplies ... by about 1+h∂f/∂y<−1 and adds its own local error, so the inherited part is amplified with alternating sign" | linearization of e_{n+1}=A_n e_n+d_n; for m≥45 every post-onset A_n < −1 | true |
| l.66-67 | "For m=10 to 40 the error grows to more than 25 times the reference solution at the same t, so ..." (revised) | max |e|/Y: 218 down to 25.4 (m=40); 0.88 at m=45 | true, clear |
| l.67-68 | "individual steps can shrink the error" | 11 steps with A_n in [−1,0), all at m=10 to 40 | true |
| l.68-69 | m=25, step from t=4.2: +0.429 → −0.009 | +0.42921 → −0.00932 | true |
| l.69 | "At m=10 the onset is at t≈2.92" | 2.923 | true |
| l.102-103 | Case 2 "along the reference solution exceeds 2 before t=5" | same `onset` code in eulersmethodbb.jl | true |
| alt text aa / bb | "evaluated on the reference solution" | as above | true |

### New problems
- None. The Minor readability item I raised earlier (lines 66-68: three coordinate clauses and the vague "reference value") is fixed by the revision. The sentence now reads "For $m=10$ to $40$ the error grows to more than $25$ times the reference solution at the same $t$, so this linear picture no longer holds and individual steps can shrink the error: at $m=25$ the step from $t=4.2$ takes it from $+0.429$ to $-0.009$."
- Re-check of lines 62-70 as a whole, recomputed in check/chk.py and check/chk2.py:
  - Shading along the reference for m≤103: |f_y| peaks at 41.255 at t=5, so h_crit=0.04848 and m_crit=103.1.
  - Linear factor <−1 while the error is small: true for every post-onset step at m≥45.
  - max |e|/Y(t): 218, 125, 88, 67, 47.1, 37 and 25.4 for m=10 to 40, then 0.88 at m=45, so "more than 25 times" holds and is exact to the range.
  - m=25 step: +0.42921 → −0.00932.
  - m=10 onset: 2.923.
  - |e(5)| exceeds |e| at the last node before onset for every m=10 to 45 (for example 0.00714 vs 8.1e-5 at m=45). It is smaller for every m=50 to 100.
  - Onsets: 3.950 (m=50) and 4.950 (m=100).
  - The runs for m=50 to 100 decrease monotonically after their peak.
  - The passage is true and reads clearly. The cause comes before its consequence, joined by "so", and the colon introduces the example.
- This rests on recomputing every changed number (above), comparing the m=25 frame, and confirming that scripts and GIFs are unchanged.

### Reproducibility and conventions
- Only index.qmd changed in the page folder (`git diff HEAD` on the .jl and .gif files is empty), so there is no GIF to regenerate. The committed GIFs are the HEAD GIFs, and the frames I extracted for aa match the scripts' quantities.
- Conventions kept: Description before Animations, one source link and one embed per case, descriptive alt text, no code blocks.
- Outside this page folder, the working tree also has changes to catenary, improved-newton-method, newton-interpolation-polynomial (and lagrange GIFs), and the fix-plan README. They belong to other pages' fixes or the director, and none touch this page. The page's own diff contains only index.qmd.

**Final status:** committed
