# Fix record: richardson-extrapolation

Scratch evidence: `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r7fix/richardson-extrapolation/fix/` (`indep.py`, `scriptvals.jl`, `img/` legacy statement images as PNG, `aa/` and `ab/` frame extractions).

## Findings

### F1 — Minor (Fidelity) — fixed

- Reproduced: read the archive's full module (`n2003/RichardsonExtrapMod.html`) and every example link page (`richardsonextrap/RichardsonExtrapMod/Links/RichardsonExtrapMod_lnk_2..11.html`). The module has Examples 1, 2(a), 2(b), 3, 4, 5, 6, 7, 8, 9, 10. The page's intro accounted for 1, 3, 4, 5, 8, 9, 10 and the pictures of 8–10; 2(a), 2(b), 6 and 7 were missing. Example 2(b) appeared only in a code comment (`richexaa.jl` line 21). Statement images (converted with ffmpeg to `img/`) show:
  - Example 6 (gr_148): $D_{five}[x,h] = \frac{4D_{three}[x,h]-D_{three}[x,2h]}{3}$.
  - Example 7 (gr_153–158): $f=e^{-x}\sin x$; $D_{three}[1.0,0.02]$, $D_{three}[1.0,0.01]$, $\frac{4D_{three}[1.0,0.01]-D_{three}[1.0,0.02]}{3}$, $D_{five}[1.0,0.01]$, $f'[1.0]$.
  - Example 2(a) (gr_57, 58, 65): table of $D_{five}[x,0.1]$, $D_{five}[x,0.01]$ and $f'[x]$ for $x=0,1,2,3$.
  - Example 2(b) (gr_59, 60): plot $D_{five}[x,0.01]$ over $[0,\pi]$ and compare with $f'$.
  - Definitions (gr_27, gr_32): $D_{three}[x,h]=\frac{f[x+h]-f[x-h]}{2h}$; $D_{five}[x,h]=\frac{f[x-2h]-8f[x-h]+8f[x+h]-f[x+2h]}{12h}$.
- The review's check line said "not run"; I confirmed the finding (above) and its numbers (Check, below). The finding's suggested sentence did not cover Example 2(b), which the R3-B rule requires, so the added text accounts for it as well.
- Change: `index.qmd`, Animations intro, two lines added after line 33 (no other change):
  - "Example 7, the module's worked extrapolation, combines $D_3(1,0.02)$ and $D_3(1,0.01)$ into the five-point value at spacing $0.01$, which is $D_5(1,0.02)$; its error is the $h=0.02$ point of Case 2 and is not shown separately, and Example 2(b)'s plot of the five-point formula at spacing $0.01$ over $[0,\pi]$ is the $h=0.02$ frame of Case 1."
  - "Example 2(a)'s table at $x=0,1,2,3$ and Example 6's proof that the five-point formula at spacing $h$ equals $\frac{4D_3(x,h)-D_3(x,2h)}{3}$ are not animated either."
- Check: `/usr/bin/python3 indep.py` (sympy + mpmath, 60 digits) and `julia scriptvals.jl` (the scripts' own `d3`/`d5`); outputs under the ledger. Frame 8 of `richexaa.gif` titled "h = 0.02" (viewed `aa/frame_008.png`); `richexab.gif` frame 12 shows 12 points including $h=0.02$ (viewed `ab/frame_012.png`).

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd l.34 | Example 7 combines $D_3(1,0.02)$ and $D_3(1,0.01)$ | Archive gr_154–156 show exactly these and $\frac{4D_{three}[1.0,0.01]-D_{three}[1.0,0.02]}{3}$; page $D_3$ = archive $D_{three}$ (gr_27 vs page eq.) | yes |
| index.qmd l.34 | "into the five-point value at spacing 0.01" | `indep.py` → extrap = -0.110793765454408, Dfive(1,0.01) = -0.110793765454408 | yes |
| index.qmd l.34 | "which is $D_5(1,0.02)$" | sympy `simplify(page_D5(x,h) - Dfive(x,h/2))` → 0; `scriptvals.jl` → script d5(1,0.02) = -0.1107937654544075 = Ex7 combination -0.1107937654544075 (bitwise same expression) | yes |
| index.qmd l.34 | "its error is the $h=0.02$ point of Case 2" | `scriptvals.jl` → index of 0.02 in richexab `hs` = 8; richexab plots `abs(d5(x0,h)-fp(x0))` with x0 = 1.0; error = 1.477e-10 (`indep.py`: -1.47709e-10) | yes |
| index.qmd l.34 | "not shown separately" | richexab.jl has no label/annotation for the point (script read; frame 12 viewed) | yes |
| index.qmd l.34 | Example 2(b) plots five-point formula at spacing 0.01 over $[0,\pi]$ | Archive gr_59 ($D_{five}[x,0.01]$), gr_60 ($[0,\pi]$) | yes |
| index.qmd l.34 | "is the $h=0.02$ frame of Case 1" | `scriptvals.jl` → index of 0.02 in richexaa `hs` = 8; max over the script's 800-point grid of \|d5(x,0.02) − dfive(x,0.01)\| = 1.9e-15; frame 8 title "h = 0.02", plots f′ too | yes |
| index.qmd l.35 | Example 2(a)'s table at $x=0,1,2,3$ not animated | Archive gr_57/58/65: table of $D_{five}[x,0.1]$, $D_{five}[x,0.01]$, $f'[x]$, x = 0..3; no script tabulates it | yes |
| index.qmd l.35 | Example 6: five-point formula at spacing $h$ equals $\frac{4D_3(x,h)-D_3(x,2h)}{3}$ | Archive gr_148; sympy `simplify(Dfive(x,h) - (4D3(x,h)-D3(x,2h))/3)` → 0 | yes |
| index.qmd l.35 | Example 6 not animated | It is a proof; no script or GIF shows it | yes |
| index.qmd l.31–35 | Inventory now complete | Module main page and link pages list Examples 1, 2(a), 2(b), 3–10 only; each is now named | yes |

Command outputs:

```
$ /usr/bin/python3 indep.py
Ex6 identity Dfive(x,h)-(4D3(x,h)-D3(x,2h))/3 = 0
page D5(x,h)-Dfive(x,h/2) = 0
D3(1,0.02)= -0.110725987917718
D3(1,0.01)= -0.110776821070235
extrap   = -0.110793765454408
Dfive(1,0.01)= -0.110793765454408
f'(1)    = -0.110793765306699
extrap err = -1.47709e-10

$ julia scriptvals.jl
d3(1,0.02)=-0.11072598791771887 d3(1,0.01)=-0.11077682107023534
Ex7 (4d3(1,.01)-d3(1,.02))/3 = -0.1107937654544075
script d5(1,0.02) = -0.1107937654544075  dfive(1,0.01) = -0.11079376545440658
Case2 hs index of 0.02: 8
Case1 hs index of 0.02: 8
Case1 h=0.02 max|d5(x,0.02)-dfive(x,0.01)| on grid = 1.8596235662471372e-15
```

## Scripts and GIFs

- No script changed; no GIF regenerated (text-only fix under R7-B/R7-D).
- Frames viewed (extracted from the committed GIFs): `richexaa.gif` frame 8 (title h = 0.02, f′, D3, D5 curves, annotation 1.33e-04 / 1.33e-09); `richexab.gif` frame 12 (all 12 points).
- `git status --short -- pages/numerical-methods/richardson-extrapolation` → ` M pages/numerical-methods/richardson-extrapolation/index.qmd` only.

## Legacy archive

Consulted: `n2003/RichardsonExtrapMod.html` (main module text) and `n2003/richardsonextrap/RichardsonExtrapMod/Links/*.html` plus the statement images. (The brief's path `richardsonextrap/RichardsonExtrapMod.html` does not exist; the module HTML is one level up.) It shows Examples 1–10 as listed above, with Example 2 split into (a) and (b). All archive statements used were recomputed (sympy/mpmath) before being put on the page. No difference between archive and page remains for these examples; the page accounts for each one.

## Notes

- The review's suggested sentence omitted Example 2(b); added it per R3-B ("checked against every example in the module").
- Example 2(a)'s $x=1$ entries correspond to Case 2's $h=0.2$ and $h=0.02$ points; this was not added, to keep the change small (the statement "table not animated" is true as written).
- Placement follows R3-D: the sentences are in the Animations introduction, before Case 1.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: Two sentences were added after the inventory (index.qmd lines 34–35). They account for Example 7 (it maps to the h=0.02 point of Case 2), Example 2(b) (it maps to the h=0.02 frame of Case 1), and Examples 2(a) and 6 (not animated). I checked the inventory against every example in the archived module (RichardsonExtrapMod.html and Links lnk_2..lnk_11, Examples 1–10). Every one is now accounted for: 1, 3, 4, 5 (not animated), 2(a) (not animated), 2(b) (Case 1, h=0.02), 6 (not animated), 7 (Case 2, h=0.02), 8 (Case 2), 9–10 and the Example 8–10 pictures (not animated). Each claim checks out (see the ledger).

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| l.34 | Example 7 combines $D_3(1,0.02)$ and $D_3(1,0.01)$ | Legacy gr_153–156: f=e^{-x}sin x, Dthree[1.0,0.02], Dthree[1.0,0.01], (4Dthree[1,0.01]-Dthree[1,0.02])/3 | true |
| l.34 | "into the five-point value at spacing 0.01" | 60-digit mpmath: extrapolated -0.1107937654544081… equals the direct 5-point stencil at h=0.01 (gr_157 Dfive[1.0,0.01]) to 1e-60 | true |
| l.34 | "which is $D_5(1,0.02)$" | Page's $D_5(x,h)=(4D_3(x,h/2)-D_3(x,h))/3$ at h=0.02 is exactly that combination. Script's Float64 d5(1,0.02)=-0.1107937654544075 | true |
| l.34 | "its error is the h=0.02 point of Case 2" | richexab.jl hs includes 0.02 (8th entry). Error 1.477e-10 (mp and Float64 agree). Frame 8 of richexab.gif shows its leftmost orange marker at h≈10^-1.7, ≈1.5e-10 | true |
| l.34 | Example 2(b) plots the five-point formula at spacing 0.01 over $[0,\pi]$ | gr_59–62: Dfive[x,0.01] on [0,π] compared with f'[x] | true |
| l.34 | "is the h=0.02 frame of Case 1" | richexaa.jl hs includes 0.02, plotted on 800 points of [0,π]. d5(x,0.02) differs from the spacing-0.01 five-point stencil by at most 7.5e-15 on that grid. Frame 8 title reads "h = 0.02", with f'(x) drawn. The frame also draws D3, which is harmless | true |
| l.35 | Example 2(a)'s table at x=0,1,2,3 | gr_57–58: f'[0..3] for h=0.1, 0.01. Solution text says "this table" | true |
| l.35 | Example 6: five-point formula at spacing h = $\frac{4D_3(x,h)-D_3(x,2h)}{3}$ | gr_148 gives this identity. gr_12/gr_33 confirm Dfive[x,h] uses x±h, x±2h. sympy residual of (4D3(h)-D3(2h))/3 − stencil = 0 | true |
| l.35 | "are not animated either" | Neither script computes values at x=0,2,3 or animates the identity | true |

### New problems
None. This rests on: every changed sentence verified above by high-precision and symbolic computation; the full Examples 1–10 inventory cross-checked against the archived module and its solution links; frame 8 of both GIFs inspected at full size; no script or GIF changed.

### Reproducibility and conventions
- Only index.qmd changed (git status and diff --stat of the page folder: 2 insertions). No script or GIF changed, so nothing needed regenerating. The committed GIFs decode to 9 and 12 frames as expected.
- The other modified paths in the working tree belong to other pages' round-7 fixes. Nothing outside this page folder is attributable to this fix.
- Conventions intact: Description before Animations, a source link and an embed per case, descriptive alt text unchanged, no code blocks.

**Final status:** committed
