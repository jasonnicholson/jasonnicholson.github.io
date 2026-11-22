# Fix record: romberg-integration

Scratch folder (all evidence, re-runnable):
`/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/work/romberg-integration/fix/`
(below written as `$FIX`). Scripts are in `$FIX/scripts/`, outputs in `$FIX/*.out`.

- `romb.py` (run `/usr/bin/python3 -I romb.py`, output `$FIX/romb.out`): independent Romberg table in mpmath at 40 digits (trapezoid sums at exact nodes $i\cdot 2/2^{k-1}$), the reference integral, row-wise errors, the smooth contrast, doubling ratios for column 1 and the diagonal to $n=16384$, and the sympy series of $f'$.
- `romb2.py` (output `$FIX/romb2.out`): doubling ratios for columns 1–5 (and 1–8 at the last row) for the page's $f$, for the smooth $1+e^{-x}\sin 8x$ and for $e^x$; diagonal-best check for rows 4–15; 17-digit values of the page's table.
- `script_values.jl` (run `julia script_values.jl`, output `$FIX/script_values.out`): the fixed `rombergaa.jl` up to the animation loop, printing each table row exactly as the GIF formats it.

## Findings

### F1 — Misleading — fixed

- **Reproduced:** `romb.py`.
  - Reference $I = 2.01627971961709632788727442192$: substitution $x=t^3$ then tanh-sinh, and direct tanh-sinh on 80 panels, differ by $-4.6\times10^{-41}$.
  - sympy: $f'$ series at 0 is `16/(3*x**(1/3)) + O(1)`, so $f\notin C^1[0,2]$.
  - Doubling ratios $E(n/2)/E(n)$: trapezoid column 2.947 (n=16), 3.115, 3.151, 3.162 (n=128), …, 3.1733 (n=16384); diagonal 5.72 (n=16), 2.93, 3.18 (n=64), 3.18 (n=128), …, 3.1749 (n=16384). $2^{5/3}=3.1748$. `romb2.py`: columns 1–8 at the last row ($n=16384$) give 3.1733, 3.1749 ×7 — every column converges at order 5/3.
  - Trapezoid/diagonal error ratio at m=17..129: 4.59, 4.32, 4.37, 4.39; asymptotically 4.446 (n=16384).
  - $R_{8,8} = 2.0160067495$, error $-2.730\times10^{-4}$; $R_{8,1}$ error $-1.199\times10^{-3}$. Smooth $1+e^{-x}\sin 8x$ (exact $I_s = 2 + (8-e^{-2}(\sin16+8\cos16))/65$): $|R_{8,8}-I_s| = 2.24\times10^{-12}$.
  - Controls (`romb2.py`): for $1+e^{-x}\sin8x$ and $e^x$ the column-$j$ ratios tend to $4^j$ (4.0000, 16.0000, 64.0001, 256.001, 1024.01), so the routine attains the smooth-case orders.
  - The finding holds as corrected by the checker: line 21 was already qualified "for smooth integrands"; the problem is that the page never says the animated example is not smooth and does not get the acceleration.
- **Change (D1 default: keep the integrand):**
  - `index.qmd:21` (Description): added the textbook statement with its hypothesis, before the existing sentence (unchanged): "For smooth $f$ ($f\in C^{2j}[a,b]$ for column $j$), the trapezoidal error expands in even powers of $h$, $T_n-I=c_1h^2+c_2h^4+\cdots$; each extrapolation removes the leading term, so column $j$ has error $O(h^{2j})$."
  - `index.qmd:33` (Behavior): added the D1 cause sentence verbatim, then the measured-rate sentence and the last frame's value against $I$ (full text in the ledger).
  - `index.qmd:37` (alt text): "diagonal estimates converge" → the table lists $R[k,1]$, $R[k,k]$ and $R[k,k]-I$, "which is still -2.7e-04 at 129 sample points".
  - `rombergaa.jl`: added `I_ref = 2.0162797196170963` (with its provenance comment), an error column $R[k,k]-I$ (`%+.1e`) and an "I = 2.016280" line to the table panel (the finding's suggestion to show the reference value; done together with F3, which needed the table rewritten anyway).
- **Check:** ledger below; new frames viewed (Scripts and GIFs).

### F2 — Minor — fixed

- **Reproduced:** `romb.py`, "Errors E = R - I, row-wise". At k=2 (m=3) $|E|$ = 0.357 (j=1), 0.475 (j=2): diagonal worst. At k=3 (m=5) $|E|$ = 0.214, 0.405, 0.463: diagonal worst. Rows k=4..8 (m=9..129): diagonal is the minimum-error entry. `romb2.py`: the diagonal is the most accurate entry of its row for every row k=4..15 (`True`).
- **Change:** `index.qmd:33` "The diagonal entry $R_{k,k}$ provides the best estimate at that stage." → "The diagonal entry $R_{k,k}$ is the table's estimate at each stage; it is the most accurate entry in its row from $m=9$ on, but at $m=3$ and $m=5$ it is the least accurate." The review's suggested causal phrase "once the mesh resolves the oscillations" was not used because it was not computed.
- **Check:** as reproduced above.

### F3 — Minor — fixed

- **Reproduced:** committed frames extracted to `$FIX/orig_frames/`; `frame_009.png` at full size shows rows 4–8 clipped after the 3rd–4th column ("2.015994  2.01"); the diagonal column is never visible in the table.
- **Change:** `rombergaa.jl` table panel: rows now print `k, m, R[k,1], R[k,k], R[k,k]-I` instead of the full row; header "k m R[k,1] ... R[k,k]" → "k m R[k,1] R[k,k] R[k,k] - I"; added "I = 2.016280" at the panel foot. This is the finding's own alternative ("print just $R_{k,1}$ and $R_{k,k}$ (plus the error against $I$)"); panel size, layout and fonts are unchanged. The full triangle cannot fit the panel at font size 8 (row 8 alone is ~90 characters at 6 decimals).
- **Check:** `$FIX/new_frames/frame_009.png` (full size): all 8 rows fully visible, last row "8 129 2.015080 2.016007 -2.7e-04", nothing clipped. Values match `script_values.out` and `romb.out` (below).

### Round 2 after check — Minor — fixed

- **Problem (from the resolution check):** the new $R[k,k]-I$ column shows row k=1 (one panel, +1.6e-03) more accurate than rows 2–6, and the page explained m=3 and m=5 but not m=2.
- **Reproduced:** `cd $FIX/scripts && /usr/bin/python3 -I round2.py` (output `$FIX/round2.out`). $|R_{k,k}-I|$ for m=2..129: 0.0016, 0.47, 0.46, 0.046, 0.0081, 0.0028, 0.00087, 0.00027; k=1 error is smaller than rows 2–6; decreasing at every step except 1→2. Coincidence: $T_1=f(0)+f(2)=1+1.017925=2.017925$ while $f$ ranges over [0.357, 1.920]; the same one-panel rule on $[0,1.8]$, $[0,1.9]$, $[0,2.1]$, $[0,2.2]$ has errors −0.124, −0.059, +0.047, +0.072 (29–75× larger), and on the smooth control $1+e^{-x}\sin8x$ over $[0,2]$ it is −0.179.
- **Change:** `index.qmd:33`, after the F2 sentence, added: "Its error is not monotone: $|R_{k,k}-I|$ is $1.6\times10^{-3}$ at $m=2$, then $0.47$, $0.46$, $0.046$, $8.1\times10^{-3}$, $2.8\times10^{-3}$, $8.7\times10^{-4}$, $2.7\times10^{-4}$; the one-panel value at $m=2$, $f(0)+f(2)=2.017925$, is close only by coincidence."
- **Check:** ledger rows marked "Round 2". The values match the GIF's error column (`script_values.out`) to the stated precision.

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd:21 | "For smooth $f$ ($f\in C^{2j}[a,b]$ for column $j$), the trapezoidal error expands in even powers of $h$, $T_n-I=c_1h^2+c_2h^4+\cdots$" | Euler–Maclaurin: $f\in C^{2m+2}$ gives $T-I=\sum_{i\le m}c_ih^{2i}+O(h^{2m+2})$; column $j$ removes $m=j-1$ terms, so needs $C^{2j}$. Numerical: `romb2.py` column-1 ratios → 4.0000 for $e^x$ and $1+e^{-x}\sin8x$. | yes |
| index.qmd:21 | "each extrapolation removes the leading term, so column $j$ has error $O(h^{2j})$" | `romb2.py` smooth controls: column $j$ ratios → $4^j$: 4.0000, 16.0000, 64.0001/64.0000, 256.0010/256.0000, 1024.0106/1023.9944 | yes |
| index.qmd:33 | "most accurate entry in its row from $m=9$ on" | `romb.py`: rows k=4..8 diag_is_best=True; `romb2.py`: rows 4..15 → True | yes |
| index.qmd:33 | "at $m=3$ and $m=5$ it is the least accurate" | `romb.py`: k=2 worst col j=2 (0.475 vs 0.357); k=3 worst col j=3 (0.463 vs 0.405, 0.214) | yes |
| index.qmd:33 (Round 2) | "Its error is not monotone: $\lvert R_{k,k}-I\rvert$ is $1.6\times10^{-3}$ at $m=2$, then 0.47, 0.46, 0.046, $8.1\times10^{-3}$, $2.8\times10^{-3}$, $8.7\times10^{-4}$, $2.7\times10^{-4}$" | `round2.py`: 0.0016, 0.47, 0.46, 0.046, 0.0081, 0.0028, 0.00087, 0.00027; decreasing flags [False, True×6] | yes |
| index.qmd:33 (Round 2) | "the one-panel value at $m=2$, $f(0)+f(2)=2.017925$, is close only by coincidence" | `round2.py`: f(0)=1, f(2)=1.017924816, sum 2.017924816; one-panel errors on [0,1.8..2.2] −0.124, −0.059, +0.047, +0.072; smooth control −0.179 | yes |
| index.qmd:33 | D1 cause sentence (verbatim), "$f'(x)\approx\tfrac{16}{3}x^{-1/3}$" | `romb.py` sympy: `16/(3*x**(1/3)) + O(1)` | yes |
| index.qmd:33 | "The measured error of every column, the diagonal included, shrinks like $O(h^{5/3})$ rather than $O(h^{2j})$" | `romb2.py`: column ratios at n=16384: 3.1733, 3.1749 (j=2..8); diag 3.1749; $2^{5/3}=3.1748$ | yes |
| index.qmd:33 | "halving $h$ divides the diagonal error by about 3.18 (from 64 to 128 subintervals)" | `romb.py`: k=8 (n=128) diag ratio 3.1829. n=64 and n=128 are frames m=65, m=129 | yes |
| index.qmd:33 | "tending to $2^{5/3}\approx 3.17$" | `romb.py`: diag ratio 3.1754 (n=2048) … 3.1749 (n=16384); $2^{5/3}=3.1748$ | yes |
| index.qmd:33 | "lowers the error only by a constant factor (about 4.4 against the trapezoid column at 129 sample points)" | `romb.py`: trap/diag error ratio 4.394 at n=128; 4.412 … 4.446 for n=256…16384 (constant, not growing) | yes |
| index.qmd:33 | "$R_{8,8}=2.016007$" | `romb2.py`: 2.0160067495163767; `script_values.out` label 2.016007; frame 9 shows "R[k,k] = 2.016007" | yes |
| index.qmd:33 | "still $2.7\times10^{-4}$ below $I\approx 2.016280$" | `romb.py`: diag err −2.730e-04; I = 2.01627971961709… | yes |
| index.qmd:37 (alt) | "table adds one row per frame, listing R[k,1], R[k,k] and the diagonal's error R[k,k] - I" | new frames 2–9 add one row each with these three columns (`$FIX/new_frames/sheet.png`) | yes |
| index.qmd:37 (alt) | "still -2.7e-04 at 129 sample points" | `script_values.out` row 8: −2.7e-04; frame 9 | yes |
| rombergaa.jl:12 | `I_ref = 2.0162797196170963` | `romb2.py`: I to 17 sig = 2.0162797196170963 | yes |
| GIF table rows | k=1..8: `+1.6e-03, +4.7e-01, -4.6e-01, -4.6e-02, -8.1e-03, -2.8e-03, -8.7e-04, -2.7e-04` | `script_values.out` matches mpmath errors in `romb2.py`: 0.0016451, 0.474981, −0.463125, −0.046355, −0.00810552, −0.00276416, −0.000868835, −0.00027297 | yes |
| GIF table rows | R[k,1] and R[k,k] columns | `script_values.out` = `romb.out` table (6 decimals), every row | yes |
| GIF table foot | "I = 2.016280" | `romb.py` I | yes |
| GIF header | "k m R[k,1] R[k,k] R[k,k] - I" | matches the printed columns | yes |

The case heading, the GIF titles ("Romberg Integration", "Romberg Table"), the left-panel labels and the Animations intro (line 26) are unchanged; they make no rate claim and remain true.

## Scripts and GIFs

- `rombergaa.jl` changed (reference constant, table-panel rows, header, foot line). `rombergaa.gif` regenerated with `julia rombergaa.jl` from the page folder.
- Frames: committed → `$FIX/orig_frames/` (9 frames); new → `$FIX/new_frames/` (9 frames). Viewed new frame 4 (m=5), frame 9 (m=129) at full size and the contact sheet.
  - Trapezoids and curve unchanged (built from $f$ at nodes $a+ih$).
  - Table: every row fully visible, no clipping; values match `script_values.out` and mpmath.
  - Frame 1 (no mesh yet) shows only the header and "I = 2.016280".
- `git status --short -- pages/numerical-methods/romberg-integration` →
  ` M .../index.qmd`, ` M .../rombergaa.gif`, ` M .../rombergaa.jl` (only these).

## Legacy archive

Consulted.

- `n2003/RombergMod.html` Example 6 (`RombergMod_lnk_7.html`) applies Romberg integration to this same integrand on $[0,2]$ with tol = 0.001 and sample counts m = 2, 3, 5, 9, 17, 33, 65, 129 — the page's sequence. Its animation `a2001/Animations/Quadrature/Rombeg/Rombergaa.gif` (frames in `$FIX/legacy_frames/`) shows the trapezoids and "Approximation =" 2.491261, 1.553155, 1.969925, 2.008174, 2.013516, 2.015411, 2.016007 for m = 3..129, the diagonal values of our table to 6 digits (`romb.py`). Mathews shows no table and no reference value.
- 129 is where tol = 0.001 stops: $|R_{8,8}-R_{7,7}| = 5.96\times10^{-4}<0.001$ and $|R_{7,7}-R_{6,6}| = 1.90\times10^{-3}$ (from the table in `romb.out`). Neither the archive nor our page says the final value is only accurate to about $3\times10^{-4}$; the page now does.
- The archive's theorem/proof images are formula-sized (not viewed); the Romberg proof page has no text statement of the smoothness hypothesis, so the $C^{2j}$ hypothesis was checked against the Euler–Maclaurin statement and numerically, not against the archive.

## Notes

- D1 template adaptation: Romberg has no single textbook order (column $j$ is $O(h^{2j})$), so the rate sentence reads "rather than $O(h^{2j})$" and replaces "instead of $2^{p}$" with the constant-factor statement.
- The Description's existing sentence ("converge quickly for smooth integrands, often outperforming …") is kept unchanged after the new sentence; the two now both mention smoothness, which is slightly repetitive but correct.
- No issues noticed outside this page.

## Resolution check (independent checker, not shown this record)

Scripts and outputs in this folder: `indep.py` (mpmath, 40 digits: reference integral, full Romberg table to 8193 points, row-wise best/worst columns, step-halving ratios per column), `run/` (scratch rerun of rombergaa.jl), `frames/` (committed GIF), `frames_run/` (rerun GIF), `frames_old/` (pre-fix GIF from HEAD via `git lfs smudge`).

### Original findings

### F1 — resolved
- The fixer took option (a): kept the integrand and explained on the page why Romberg does not accelerate it. index.qmd:33 now says $f'$ is unbounded at 0, that every column, the diagonal included, converges like $O(h^{5/3})$, and that $R_{8,8}=2.016007$ is still $2.7\times10^{-4}$ below $I\approx2.016280$. Line 21 now gives the smoothness condition behind the error expansion.
- Independent check (indep.py): $I=2.0162797196170963278872744\ldots$. Three different quadratures agree to 40 digits: the $x=t^3$ substitution, a split at $10^{-6}$ with direct quadrature, and an 8-panel $t$ split. Step-halving error ratios tend to 3.1749 for columns 1–4 and the diagonal; $\log_2 3.1749=1.6667=5/3$. $R_{8,8}-I=-2.730\times10^{-4}$. $T_{128}-I=-1.199\times10^{-3}$. The ratio of the two is 4.39.
- The frame now shows $I = 2.016280$ and an $R_{k,k}-I$ column, so a viewer can see the slow convergence directly (last frame: −2.7e-04).
- Claims about smooth $f$ checked with $1+e^{-x}\sin 8x$: measured orders for columns 1–4 are 2.0, 4.0, 6.0, 8.0, which matches the new line 21.

### F2 — resolved
- The old sentence "provides the best estimate at that stage" is gone. The new sentence reads: "is the table's estimate at each stage; it is the most accurate entry in its row from $m=9$ on, but at $m=3$ and $m=5$ it is the least accurate."
- Independent check (indep.py), most and least accurate column per row. m=3: best col 1 (0.357), worst col 2 = diagonal (0.475). m=5: best col 1 (0.214), worst col 3 = diagonal (0.463). For m=9, 17, 33, 65 and 129 the most accurate column is the diagonal. The new text is true.

### F3 — resolved
- The fixer took the suggested alternative: the table panel now lists k, m, $R_{k,1}$, $R_{k,k}$, $R_{k,k}-I$, with $I$ at the foot. In the full-size frames 001, 005 and 009, every row through k=8 (m=129) fits inside the panel; nothing is clipped. The header names exactly the columns shown. The alt text no longer promises a triangle filling row by row; it describes what is drawn.
- Every displayed number matches indep.py (rounded to the printed format):
  - $R_{k,1}$: 2.017925, 2.372927, 1.802071, 1.906595, 1.979056, 2.004331, 2.012488, 2.015080
  - $R_{k,k}$: 2.017925, 2.491261, 1.553155, 1.969925, 2.008174, 2.013516, 2.015411, 2.016007
  - errors: +1.6e-03, +4.7e-01 (exact 0.47498), −4.6e-01, −4.6e-02, −8.1e-03, −2.8e-03, −8.7e-04, −2.7e-04
- The full triangle is still not drawn. The page now only describes it in general terms at line 21, which is true of the method, so this is acceptable.

### Changed-text ledger

| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd:21 | "For smooth $f$ ($f\in C^{2j}[a,b]$ for column $j$) … $T_n-I=c_1h^2+c_2h^4+\cdots$" | Euler–Maclaurin with remainder: for $f\in C^{2j}$, $T-I=\sum_{i<j}c_ih^{2i}+O(h^{2j})$ | true |
| index.qmd:21 | "each extrapolation removes the leading term, so column $j$ has error $O(h^{2j})$" | measured orders 2.0/4.0/6.0/8.0 on smooth $1+e^{-x}\sin 8x$ | true |
| index.qmd:33 | "$R_{k,k}$ is the table's estimate at each stage" | definitional | true |
| index.qmd:33 | "most accurate entry in its row from $m=9$ on" | best column = diagonal for m=9…129 | true |
| index.qmd:33 | "at $m=3$ and $m=5$ it is the least accurate" | 0.475 vs 0.357; 0.463 vs 0.404, 0.214 | true |
| index.qmd:33 | "$f'(x)\approx\tfrac{16}{3}x^{-1/3}$ near 0" | $x^{1/3}f'(x)$ at $x=10^{-6},10^{-9},10^{-12}$: 5.33332, 5.3333333, 5.3333333 | true |
| index.qmd:33 | "every column, the diagonal included, shrinks like $O(h^{5/3})$" | ratios → 3.1749 for cols 1–4 and the diagonal (n up to 8192) | true |
| index.qmd:33 | "divides the diagonal error by about 3.18 (from 64 to 128 subintervals)" | 3.1793 | true |
| index.qmd:33 | "tending to $2^{5/3}\approx3.17$" | 3.17480 (3.17 truncated; 3.175 to 4 s.f.) | true |
| index.qmd:33 | "about 4.4 against the trapezoid column at 129 sample points" | 1.199e-3 / 2.730e-4 = 4.394 | true |
| index.qmd:33 | "$R_{8,8}=2.016007$ … $2.7\times10^{-4}$ below $I\approx2.016280$" | 2.01600675; −2.730e-4; I = 2.01627972 | true |
| index.qmd:37 alt | "adds one row per frame, listing R[k,1], R[k,k] and … R[k,k] - I, which is still -2.7e-04 at 129 sample points" | frames 001/005/009; −2.730e-4 | true |
| rombergaa.jl:11–12 | `I_ref = 2.0162797196170963` and its comment | matches 40-digit value to all 17 digits; the $x=t^3$ substitution does make the integrand smooth ($3t^2(1+e^{-t^3}\sin 8t^2)$) | true |
| rombergaa.jl:67–69 | comment + header "k m R[k,1] R[k,k] R[k,k] - I" | matches printed columns | true |
| rombergaa.jl:71 | row format `%.6f %.6f %+.1e` of R[k,1], R[k,k], R[k,k]-I_ref | values checked above | true |
| rombergaa.jl:75 | "I = 2.016280" | true value rounded to 6 dp | true |

### New problems

### N1 — Minor — The new error column shows the k=1 row as more accurate than rows 2–6, and nothing explains why
- **Location:** GIF table, row 1 (`+1.6e-03`); index.qmd:33.
- **Evidence:** the one-panel trapezoid $R_{1,1}=2.017925$ has error $+1.645\times10^{-3}$. That is smaller than every error up to and including k=6 ($-2.8\times10^{-3}$), and only rows 7–8 beat it. This is a coincidence (step-halving ratio 0.0046 at the first step). Before the fix no error was shown, so a viewer could not see it. Now the sequence +1.6e-03, +4.7e-01, −4.6e-01, … is the first thing in the table, and the page text explains m=3 and m=5 but not m=2. A one-clause note (for example "the $m=2$ value is close to $I$ by coincidence") would remove the puzzle. This does not make any statement on the page false.

No other new problems. This rests on: every changed sentence and number checked above; the full-size frames 001, 005 and 009 inspected (labels legible, no clipping, the left panel is unchanged from the pre-fix frame 009, and the faint grid lines in the table panel were already in the pre-fix GIF); and the R recurrence and trapezoid code unchanged.

### Reproducibility and conventions

- `rombergaa.jl` was run from a scratch copy (`run/`). Output sha256 `a4fb23d6…70b7f` is identical to the committed GIF and to the LFS pointer oid; decoded framemd5 is identical; 9 frames.
- Conventions hold:
  - Description comes before Animations.
  - The case has a `[Julia source](rombergaa.jl)` link and an embed.
  - The alt text is descriptive.
  - There are no code blocks.
- Changed files in the page folder: index.qmd, rombergaa.jl, rombergaa.gif only.
- Tracked files outside `pages/numerical-methods/`: none changed.
- Untracked fix notes exist under `reviews/numerical-methods-animations/fixes/`, including `romberg-integration.md`. These are workflow notes, not site content.

### Re-check

What changed since the first check: one sentence was added to index.qmd:33. `rombergaa.jl` and `rombergaa.gif` are unchanged: the diff is the same, the GIF sha256 is still `a4fb23d6…70b7f` (equal to my scratch rerun), and both files keep their 22:40 mtimes. No file outside the page folder changed.

The coordinator's note said the new text gives "a computed sensitivity to the right endpoint". The page contains no such statement: grep finds no "endpoint" or "sensitiv" in index.qmd or fix.diff. I ran the sensitivity check myself (see below) as support for the "coincidence" claim. It does not appear on the page.

### N1 — resolved
- New text: "Its error is not monotone: $|R_{k,k}-I|$ is $1.6\times10^{-3}$ at $m=2$, then $0.47$, $0.46$, $0.046$, $8.1\times10^{-3}$, $2.8\times10^{-3}$, $8.7\times10^{-4}$, $2.7\times10^{-4}$; the one-panel value at $m=2$, $f(0)+f(2)=2.017925$, is close only by coincidence."
- Ledger (indep.py, recheck.py):

| Text / number | Computed | Verdict |
|---|---|---|
| not monotone | 1.645e-3 → 0.475 (rises), then decreases | true |
| 1.6e-3 (m=2) | 1.645e-3 | true |
| 0.47 (m=3) | 0.47498 | true (truncated, 2 s.f.) |
| 0.46 (m=5) | 0.4631 | true |
| 0.046 (m=9) | 0.04635 | true |
| 8.1e-3 (m=17) | 8.106e-3 | true |
| 2.8e-3 (m=33) | 2.764e-3 | true |
| 8.7e-4 (m=65) | 8.688e-4 | true |
| 2.7e-4 (m=129) | 2.730e-4 | true |
| $f(0)+f(2)=2.017925$ is the one-panel value | $T_1=\tfrac{h}{2}(f(0)+f(2))$ with $h=2$; $f(0)+f(2)=2.0179248$ | true |
| "close only by coincidence" | recheck.py: one-panel error $T_1(b)-I(b)$ on $[0,b]$ changes sign at b ≈ 2.0. It is −5.9e-2 at b=1.9, −2.7e-2 at 1.95, +1.6e-3 at 2.0, +2.7e-2 at 2.05, +4.7e-2 at 2.1, and up to ±0.2 over b ∈ [1.6, 2.4]. The 2-panel error stays at 0.07–0.36 over the same range. | true |

- The m=0.47 entry is $0.47498$, which rounds to 0.47 at 2 s.f. It also matches the frame's `+4.7e-01`.

### F1 — still resolved
None of the earlier F1 text changed, and the earlier checks still hold. The new sentence agrees with them: errors decrease by about 3.18 per halving at the end.

### F2 — still resolved
The best/worst-in-row sentence is unchanged and true. The new non-monotone sentence is consistent with it.

### F3 — still resolved
Script and GIF unchanged. The numbers quoted in the new sentence match the GIF's error column to the shown precision.

### New problems (re-check)
None. This rests on: every new number checked against 40-digit values; the coincidence claim checked by varying the right endpoint; the GIF and script unchanged and still byte-reproducible; and conventions unchanged (Description, then Animations, source link and embed, alt text, no code blocks).

**Final status:** committed
