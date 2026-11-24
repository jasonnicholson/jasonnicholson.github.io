# Fix record: adams-bashforth-moulton-method

## Findings
### F1 — Misleading — fixed
- Reproduced: two independent computations, in the scratch folder
  `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r7fix/adams-bashforth-moulton-method/fix/`.
  - `/usr/bin/python3 -I check.py`: my own ABM4 PECE with RK4 start, against an mpmath `odefun` reference (30 digits), exact y(5) = 0.008119920464867961:
    - m = 12: y5 = 0.0214088, ratio 2.6366, abs. error 0.01329, rel. error 163.7%, max node error 0.7364 at t = 4.1667
    - m = 56: y5 = 0.0167970, ratio 2.0686, abs. error 0.00868
    - m = 70: y5 = 0.0102009, ratio 1.2563, abs. error 0.00208 (25.6%)
  - `julia instr.jl` (lines 1–78 of the page script, plus prints; reference = the script's RK4 at h = 1e-4, y(5) = 0.0081199205): m = 12 y5 = 0.0214088, ratio 2.6366, abs. error 0.01329. The m = 56 and m = 70 values match the Python ones.
  - So "a close end value" is true only in absolute terms. The m = 12 end value is 2.64 times the exact value, while the same paragraph judges m = 70 (25.6%) and n = 50 (17 times) relatively. The finding holds.
- Change: `index.qmd` lines 40–42. Before: "and a close end value can hide a bad run: at $m=12$, $y(5)=0.0214$, although the run is off by $0.74$ at $t\approx4.17$." After: "and a small absolute end error can hide a much worse run: at $m=12$, $y(5)=0.0214$ is off by only $0.013$ (though that is still 2.6 times the exact value), while the run is off by $0.74$ at $t\approx4.17$." This is the review's suggested wording, taken unchanged.
- Check: every number in the new sentence was recomputed (see the ledger). The alt text and the GIF title say nothing about "close", so nothing else changes. This is a text-only fix under R7-D/D7, because the finding does not say the picture misleads.

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd l.40–41 | "a small absolute end error can hide a much worse run" | abs. end error 0.0133 against max node error 0.7364 in the same run (check.py, instr.jl) | yes |
| index.qmd l.41 | $y(5)=0.0214$ at $m=12$ | check.py and instr.jl → 0.0214088 | yes |
| index.qmd l.41 | "off by only $0.013$" | check.py and instr.jl → +0.01329 | yes |
| index.qmd l.42 | "2.6 times the exact value" | check.py and instr.jl → ratio 2.6366 | yes |
| index.qmd l.42 | "off by $0.74$ at $t\approx4.17$" (unchanged number) | check.py → max node error 0.7364 at t = 4.1667 | yes |

## Scripts and GIFs
- No scripts changed and no GIFs regenerated. The instrumented copy ran only in the scratch folder.
- `git status --short -- pages/numerical-methods/adams-bashforth-moulton-method` → ` M pages/numerical-methods/adams-bashforth-moulton-method/index.qmd` (only).

## Legacy archive
Consulted. `n2003/AdamsBashforthMod.html` lists one animation, "Animations for the Adams-Bashforth-Moulton Method", which is Example 11, the same ODE as the page. The round-7 review reports that the page's 21 values of m and all 21 y(5) labels match Mathews' animation. The archive has no wording about m = 12, so nothing in it bears on this text fix.

## Notes
- No decision ambiguity: R7-A (fix all) and R7-D (text fix, smallest correct option) cover the finding.
- Nothing outside the page folder was touched, except this record.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: the phrase "a close end value can hide a bad run" is gone. In its place: "a small absolute end error can hide a much worse run: at $m=12$, $y(5)=0.0214$ is off by only $0.013$ (though that is still 2.6 times the exact value), while the run is off by $0.74$ at $t\approx4.17$."
- I checked this with my own Python ABM4 (RK4 start, PECE with AB4/AM4 coefficients), using an mpmath `odefun` reference at 30 digits with the real cube root (`check/abm.py`). Results: exact $y(5)=0.00811992046$. At m=12, $y(5)=0.0214088$, error $+0.013289$, ratio 2.6366, and the largest node error is $0.73637$ at $t=4.16667$. Every number in the new sentence matches.
- The new sentence now judges the end value in both absolute and relative terms. It no longer conflicts with "26% of $y(5)$" at m=70 (I get 25.6%) or with "about 17 times" at n=50.
- Script and GIF are unchanged, which is correct because the finding was about the text only.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd l.40 | "a small absolute end error can hide a much worse run" | m=12 end error 0.0133 against max node error 0.736, a factor of 55 | true |
| index.qmd l.41 | $y(5)=0.0214$ at $m=12$ | 0.0214088 | true |
| index.qmd l.41 | "off by only $0.013$" | +0.013289 | true |
| index.qmd l.42 | "2.6 times the exact value" | 0.0214088 / 0.0081199 = 2.637 | true |
| index.qmd l.42 | "off by $0.74$ at $t\approx4.17$" | 0.73637 at t = 4.16667 | true |
| unchanged context l.43-44 (spot check) | $9.6\times10^{-2}$ at m=60, $2.1\times10^{-3}$ at m=70 (26%) | 0.09555, 0.002081 (25.6%) | true |

### New problems
None. This rests on three points. All five new claims match an independent high-precision computation. The edit is limited to one sentence of index.qmd (3 lines in, 2 out). No script, GIF or alt text changed.

### Reproducibility and conventions
- In the page folder only index.qmd is modified (`git status`, `git diff --stat`). The .jl and .gif are unchanged from HEAD, so nothing needed regenerating and there was no script to rerun.
- Conventions still hold. Description comes before Animations, there is a Julia source link and a GIF embed for the single case, the alt text is descriptive, and there are no code fences (0 matches for ```).
- Files outside the page folder: the branch's working tree has many changes to other pages, from other fixers in this round. The page-folder diff shows nothing from this fix outside this folder, but I cannot tell from here which fixer changed which file.

**Final status:** committed
