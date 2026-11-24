# Fix record: runge-kutta-method

Scratch evidence: `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r7fix/runge-kutta-method/fix/` (`split.py`, `stages.py`; run with `/usr/bin/python3`).

## Findings

### F1 — Minor — fixed
- Reproduced: `rungekuttaaa.jl` lines 28-32 define `k1 = h*f(t,y)`, ..., `k4 = h*f(t+h, y+k3)` and update `y + (k1+2k2+2k3+k4)/6`, so the $k_j$ are increments, while `index.qmd` line 12 called them "slope estimates". My independent Python RK4 in the same increment form (`split.py`) reproduces the page's $y(5)$ = 0.5883471, 0.2891074, 0.0376958 for $m$ = 12, 20, 52, and `stages.py` shows the first negative stage is $y_i+k_3$ in all 13 runs $m=12$ to $52$ (minimum $-1.1542$ at $m=12$; $m=56$ minimum $+0.0048$). So line 18's "$y_i+k_3$" is right only with $k_j$ as increments.
- Change: `index.qmd` line 12, "RK4 computes four slope estimates ($k_1, k_2, k_3, k_4$) per step and takes a weighted average" → "RK4 computes four increments $k_j = h\,f(\cdot)$ from slope estimates ($k_1, k_2, k_3, k_4$) per step and adds their weighted average $(k_1+2k_2+2k_3+k_4)/6$ to $y_i$".
- Check: the new wording matches script lines 28-32 term by term; line 18's "$y_i+k_3$, where $k_4$ is evaluated" now agrees with it (script line 31).

### F2 — Minor — fixed
- Reproduced: `/usr/bin/python3 split.py` (my own script; exact solution via DOP853 on $u=y^{1/3}$, $u'=(1-tu)/(3u^2)$, rtol 1e-13; reference $Y(5)=0.008119920464867956$). For the first upward step after the peak in each run $m=12$ to $56$:
  - Split A (own = $\Phi(t_i,Y(t_i))-Y(t_{i+1})$): own share 93.7–99.9% for $m=12$–18; 0.3–20.0% for $m=20$–56; carried part = 2.91–18.57 × $e_i$ for $m=20$–56.
  - Split B (own = $y_{i+1}-z(t_{i+1})$, $z$ the exact solution through $(t_i,y_i)$): own share 98.7–99.9% for all $m=12$–56; exact-flow gain on $e_i$ 0.048–0.130 for $m=12$–18 and 0.023–0.061 for $m=20$–56.
  - $e_{i+1}=0.1681$ for $m=12$ (step $2.9167\to3.3333$).
  The page's figures are split A's; the contrast at $m=20$ exists only under split A. Finding holds.
- Change: `index.qmd` line 18, "is that step's own truncation error, not an earlier error grown. For $m=20$ to $56$ the error after the first upward step is mostly error carried from earlier steps, which that step multiplies by $2.9$ to $18.6$." → "is what that step produces even when started from the exact $y(t_i)$. For $m=20$ to $56$ the first upward step started from the exact $y(t_i)$ would produce only $0.3$ to $20\%$ of the error after it; the rest comes from the error already present at $t_i$, which RK4's step map multiplies by $2.9$ to $18.6$, whereas the exact flow over that step would shrink it to $2$ to $6\%$ of its size."
- Check: every number is from the `split.py` summary lines (below). The review's draft said "2 to 6%" for the exact flow; this matches my $m=20$–56 range 0.023–0.061 (the review's "2 to 13%" covers all $m=12$–56, including $m=14$ at 0.130, which the new sentence does not cover).

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| line 12 | "four increments $k_j = h\,f(\cdot)$ from slope estimates" | script lines 28-31 `k1 = h * f(...)` | yes |
| line 12 | "adds their weighted average $(k_1+2k_2+2k_3+k_4)/6$ to $y_i$" | script line 32 `ys[i+1] = y + (k1 + 2k2 + 2k3 + k4)/6` | yes |
| line 18 | "$94$ to $100\%$ ... is what that step produces even when started from the exact $y(t_i)$" ($m=12$–18) | `split.py` → "m=12..18: A own% 93.7..99.9" | yes |
| line 18 | "$0.168$ for $m=12$" (unchanged number) | `split.py` → m=12 e_i+1 = +1.681e-01 | yes |
| line 18 | "first upward step ... would produce only $0.3$ to $20\%$" ($m=20$–56) | `split.py` → "m=20..56: A own% 0.3..20.0" | yes |
| line 18 | "RK4's step map multiplies by $2.9$ to $18.6$" | `split.py` → "A gain 2.91..18.57" | yes |
| line 18 | "exact flow over that step would shrink it to $2$ to $6\%$" | `split.py` → "m=20..56: B gain 0.023..0.061" | yes |

## Scripts and GIFs
- No script changed; no GIF regenerated (both findings are text-only, R7-D/D7).
- `git status --short -- pages/numerical-methods/runge-kutta-method` → ` M pages/numerical-methods/runge-kutta-method/index.qmd` only.

## Legacy archive
Consulted: `n2003/RungeKuttaMod.html` (and `n2003/rungekutta/RungeKuttaMod/`). Its formulas are images, so the text does not show whether Mathews writes the $k_j$ as slopes or increments; neither finding depends on the archive. Earlier rounds already matched the sweep's $m$ values and Mathews' printed $y(5)$ (review claims #4, #50); nothing changed here affects that.

## Notes
- The sentence "not an earlier error grown" for $m=12$–18 was dropped in favour of the stated measure; under both splits the own share there is at least 93.7%, so nothing true was lost.
- Page has no `## Description` section (pre-existing convention gap, not a finding); not added.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: line 12 now reads "RK4 computes four increments $k_j = h\,f(\cdot)$ from slope estimates ($k_1,\dots,k_4$) per step and adds their weighted average $(k_1+2k_2+2k_3+k_4)/6$ to $y_i$". This matches `rungekuttaaa.jl` lines 28-32 (`k1 = h*f(t,y)` ... `y + (k1+2k2+2k3+k4)/6`). With $k_j$ defined as increments, line 18's "$y_i+k_3$, where $k_4$ is evaluated" is consistent (script line 31). The parenthetical still sits right after "slope estimates", but $k_j=h\,f$ is stated explicitly, and this is the wording the finding suggested.

### F2 — resolved
- Evidence: the split is now stated. "What that step produces even when started from the exact $y(t_i)$" means own $=\Phi(t_i,Y(t_i))-Y(t_{i+1})$. "The rest" is $\Phi(t_i,y_i)-\Phi(t_i,Y(t_i))$. I recomputed this independently (`check/split.py`: exact flow by DOP853 on $u=y^{1/3}$ at rtol 1e-13; the first upward step is the first $i$ after the computed peak with $y_{i+1}>y_i$). The two parts sum to $e_{i+1}$ exactly (residual 0).
  - m=12..18: own share 99.6, 99.9, 93.7, 98.0 %. The page says "94 to 100%" (OK). $e_{i+1}=0.1681$ for m=12 (OK).
  - m=20..56: own share 20.0, 1.5, 3.4, 1.6, 0.3, 3.0, 1.7, 1.2, 1.0, 1.0 %. The page says "0.3 to 20%" (OK).
  - Secant gain $(\Phi(y_i)-\Phi(Y_i))/e_i$ for m=20..56: 5.01, 6.93, 2.91, 5.66, 18.57, 3.57, 4.06, 4.24, 4.06, 3.65. The page says "2.9 to 18.6" (OK).
  - Exact-flow gain $(z(t_{i+1})-Y(t_{i+1}))/e_i$ for m=20..56: 0.061, 0.044, 0.040, 0.028, 0.023, 0.028, 0.027, 0.027, 0.027, 0.028. The page says "2 to 6% of its size" (OK). Over m=12..56 the range would be 2 to 13%, but the sentence is about m=20..56 only, so 6% is correct.
  - The regime contrast is now stated as a property of that measure, so a reader no longer takes it for local error in the other (split B) sense.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| l.12 | $k_j=h\,f(\cdot)$ increments | script l.28-31 | OK |
| l.12 | update adds $(k_1+2k_2+2k_3+k_4)/6$ to $y_i$ | script l.32 | OK |
| l.18 | "94 to 100%", m=12..18, from exact $y(t_i)$ | split.py: 93.7 to 99.9 | OK |
| l.18 | $0.168$ for m=12 | 0.1681 | OK |
| l.18 | "0.3 to 20%", m=20..56 | 0.3 to 20.0 | OK |
| l.18 | "the rest comes from the error already present at $t_i$" | own + carried = $e_{i+1}$ exactly | OK |
| l.18 | RK4 step map multiplies by "2.9 to 18.6" | 2.91 to 18.57 | OK |
| l.18 | exact flow shrinks it "to 2 to 6%" | 2.3 to 6.1% | OK |

### New problems
None. This rests on recomputing every changed number with an independent RK4 and high-precision exact flow, and on the decomposition closing exactly. The other unchanged figures in the same output also agree with the page: y(5) for m=12, 20, 52, 56; errors at m=60, 70, 80, 150; no upward step for m≥60.

### Reproducibility and conventions
- Only `index.qmd` changed in the page folder (git status/diff --stat). Script and GIF are unchanged, so no rerun was needed and the GIF still matches the script.
- Description precedes the Animations, there is one source link and one embed, the alt text is descriptive and unchanged, and there are no code blocks.
- Other modified files in the working tree (lagrange, adaptive-simpsons, …) belong to other pages' fixes. The fix diff for this page touches nothing outside its folder.

**Final status:** committed
