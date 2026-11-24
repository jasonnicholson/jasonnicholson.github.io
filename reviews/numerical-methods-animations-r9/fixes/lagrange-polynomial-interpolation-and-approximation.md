# Fix record: lagrange-polynomial-interpolation-and-approximation

Covers both pages that share `lagnewt_animations_all.jl`: Lagrange (`pages/numerical-methods/lagrange-polynomial-interpolation-and-approximation/`) and Newton Interpolation (`pages/numerical-methods/newton-interpolation-polynomial/`), under R9-B.

Scratch evidence: `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r9fix/lagrange-polynomial-interpolation-and-approximation/fix/` (`repro.jl`, `ylims.jl`).

## Findings

### F1 — Minor — fixed (comment only, per R9-B)

- **Reproduced:** `julia repro.jl` loads the script's definitions without rendering and prints:
  - `index of exact 0.0: 38  x[i-1]=-0.005405405405405406 x[i+1]=0.005405405405405406`
  - `gamma(0.0)=Inf  safe_eval=NaN`
  - `gamma(x[i-1])=-185.58258858451293  gamma(x[i+1])=184.42810422284606`
  - `case 24/25/26 poles=Float64[] xlims=(-0.2, 5.2)`
  - Other grid lengths (999, 1001, 1200, 2000) over [−0.2, 5.2] do not contain an exact 0.0, so the break depends on the grid length 1000.
  - A scan of all 29 windows found no other unlisted pole. The NaN points in Cases 07, 09–11 and 19 are where f is undefined (one side of the window). The single NaN in Cases 27–29 is Y₀(0) at the window's left end. Only Cases 24–26 have an unlisted pole inside the window.
  - `julia ylims.jl`: the committed y-limits for 24–26 are (−17.558, 37.335), so the clamp band is (−72.451, 92.228). Without the exact grid hit, the neighbours −185.6 and 184.4 would be clamped to −72.451 and 92.228 and joined by a near-vertical segment at x ≈ 0. With `poles=[0.0]`, the y-limits would become (−2.662, 21.841), (−2.191, 21.791) and (−5.033, 27.111) for Cases 24, 25 and 26. This confirms that the alternative changes the pictures.
  - Independent check (mpmath, 30 digits): Γ(−0.005405405405405406) = −185.5825885845129, Γ(0.005405405405405406) = 184.4281042228461, and Γ(±1e−20) = ±1e20. This confirms the simple pole at 0 and agrees with the Julia values. In mpmath, −0.2 + 37·(5.4/999) = 2.06e−18. Julia's `range` (TwicePrecision) returns exactly 0.0 there, as the Julia output above shows.
- **Change:** `lagnewt_animations_all.jl` (both copies, kept byte-identical):
  - Field comment, before: `poles::Vector{Float64}  # poles of f inside the window (empty if none)`. After: a three-line comment above the field: "Poles at which f is broken explicitly, with the y-limits taken from f on the node interval. Not every pole in the window is listed: Γ's pole at x = 0 in Cases 24-26 is not (see the note on those rows)."
  - New comment above rows 24–26: "Cases 24-26: Γ's pole at x = 0 lies in the window but is not in `poles`, so the y-limits come from the whole window. f still breaks at 0 only because the plot grid range(-0.2, 5.2, length=1000) has x[38] == 0.0 exactly, gamma(0.0) == Inf and safe_eval makes that NaN. With another grid or window, add poles=[0.0] (which also changes the y-limits)."
  - The case table is unchanged.
- **Check:**
  - `cmp` of the two copies reports them identical.
  - Both pages regenerated in place (`julia lagnewt_animations_all.jl`, 29 GIFs each).
  - `git status --short` on both page folders lists only the two `.jl` files. All 58 GIFs are byte-identical to the committed ones.

## Ledger of changed text

No `index.qmd` text changed. Only script comments changed.

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| `poles` field comment | "Poles at which f is broken explicitly, with the y-limits taken from f on the node interval" | Script: `has_pole` selects `robust_ylims` over `range(span...)` and builds `yf` with NaN at each listed pole | yes |
| `poles` field comment | "Γ's pole at x = 0 in Cases 24-26 is not [listed]" | `repro.jl` → `poles=Float64[]` for 24–26; mpmath Γ(±1e−20) = ±1e20 | yes |
| Rows 24–26 comment | "the y-limits come from the whole window" | Script: `has_pole` is false, so `robust_ylims(ytrue)` is used; `ylims.jl` → (−17.558, 37.335) | yes |
| Rows 24–26 comment | "range(-0.2, 5.2, length=1000) has x[38] == 0.0 exactly, gamma(0.0) == Inf and safe_eval makes that NaN" | `repro.jl` → `index of exact 0.0: 38`, `gamma(0.0)=Inf safe_eval=NaN` | yes |
| Rows 24–26 comment | "With another grid or window, add poles=[0.0] (which also changes the y-limits)" | `repro.jl`: lengths 999/1001/1200/2000 have no exact 0. `ylims.jl`: neighbours clamped to −72.451/92.228 (a connector would be drawn); with poles, y-limits (−2.662, 21.841), etc. | yes |

## Scripts and GIFs

- Script changed (comments only): `lagnewt_animations_all.jl` on both pages, byte-identical (`cmp`).
- GIFs regenerated: all 29 on each page. None changed, so no new frames needed viewing. The committed lagnewt24–26 frames were already reviewed (round-9 review §1 and ledger row 38: f broken at 0, with no connector).
- `git status --short -- <both page folders>` after regeneration:
  ```
   M pages/numerical-methods/lagrange-polynomial-interpolation-and-approximation/lagnewt_animations_all.jl
   M pages/numerical-methods/newton-interpolation-polynomial/lagnewt_animations_all.jl
  ```

## Legacy archive

Consulted briefly: `n2003/lagrangepoly/` has no text about Γ (a grep for "gamma" returned nothing). The round-9 review attributes the Γ intervals to the legacy animation index. This fix changes no case parameters, so the archive has no bearing on it.

## Notes

- Page text: the Lagrange page says "f is broken at each of its poles (Cases 01–03, 14 and 24–26)" (`index.qmd` line 25). The Newton page has no such sentence; `grep -i 'off-scale\|24–26'` on it finds nothing, and its Γ alt texts do not mention the pole. The Lagrange sentence stays true of the committed GIFs, and the comment fix does not make it untrue. No `index.qmd` change was made.
- Jason's open choice (R9-B): adding `poles=[0.0]` to rows 24–26 would make the break independent of the grid. It would also change those cases' y-limits (as computed above) and their six GIFs (three per page).
- The working tree also shows a change to `pages/numerical-methods/newton-raphson-method/` from another fixer. I did not touch it.

## Resolution check (independent checker, not shown this record)

### Original findings
### F1 — resolved
- The fixer took the comment-only option (R9-B). The false field comment "poles of f inside the window (empty if none)" is gone. The new field comment (lines 17-19) and the row note (lines 62-66) were each tested in scratch copies (see ledger).
- Code unchanged. GIFs unchanged and regenerate byte-identical. The page sentence "f is broken at each of its poles (Cases 01–03, 14 and 24–26)" still holds for the committed GIFs: yf has a NaN at x = 0.0 in cases 24-26, and frame 1 of lagnewt24.gif shows the break.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| jl l.17-18 | poles: f broken explicitly, y-limits from f on node interval | code l.190-193 and 210-215; listed-pole cases 01-03 and 14 have a NaN exactly at each pole; ylims_f comes from robust_ylims over range(span..., 1000) | true |
| jl l.18-19 | not every pole in the window is listed; Γ's pole at 0 in 24-26 is not | scanned all 29 cases: the only unlisted real pole in a window is Γ at 0. The others (07 sqrt, 09-11 log, 19 asin domain, 27-29 Y0 log at the window edge) are not poles | true |
| jl l.62-63 | pole not in `poles`, so y-limits come from the whole window | has_pole = false → robust_ylims(ytrue) over xplot on [-0.2, 5.2]. ylims (-17.56, 37.33). With poles=[0.0] they become (-2.66, 21.84) / (-2.19, 21.79) / (-5.03, 27.11) for 24/25/26 | true |
| jl l.63-65 | grid range(-0.2,5.2,length=1000), x[38] == 0.0, gamma(0.0) == Inf, safe_eval → NaN | Julia: x[38] = 0.0 (true), gamma(0.0) = Inf, safe_eval(gamma, 0.0) = NaN; yf has exactly 1 NaN, at x = 0 | true |
| jl l.63-66 | breaks "only because" of that; another grid needs poles=[0.0] | scratch copy with length 1001: 0 NaNs. The neighbours are clamped to exactly ylims∓yspan (-72.03, 91.60) and joined, and the rendered frame shows a vertical magenta line at x ≈ 0 (the committed frame has none). Adding poles=[0.0] changes the y-limits, as the comment says | true (some other lengths, e.g. 919, 946, 973, 1027, also hit 0 exactly; "another grid" is advice, not a false claim) |

### New problems
None. This rests on: a comment-only diff, every claim tested above, 58/58 GIFs byte-identical, and both copies byte-identical.

### Reproducibility and conventions
- The two copies of lagnewt_animations_all.jl are byte-identical (cmp).
- Each scratch copy regenerated all 29 GIFs, byte-identical to the committed GIFs in its own page folder (58/58).
- index.qmd is untouched on both pages. The fix diff touches only the two .jl files. Other working-tree changes (newton-raphson-method, the fix-plan README, reviews r9) are outside this fix's diff.

**Final status:** committed
