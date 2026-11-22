# Fix record: gauss-legendre-quadrature

Scratch evidence: `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r4fix/gauss-legendre-quadrature/fix/` (`smooth.py`, `trunc.py`, `smooth.jl`).

## Findings

### F1 — Minor — fixed
- Reproduced: the exact integral of the smooth contrast integrand g(x) = 1 + e^{-x} sin 8x on [0,2] is I = 2 + (8 − e^{-2}(sin 16 + 8 cos 16))/65 = 2.139627760200245653 (mpmath 40 digits; `mp.quad` agrees to all digits). fl(I) − I = 1.566e-16 and the Float64 spacing at I is 4.44e-16, so no Float64 result can have error 4e-17.
  - `julia smooth.jl` (the page script's own Golub-Welsch routine, error against the 256-bit I): n=12 3.312e-10, n=14 1.862e-13, n=16 1.045e-15, n=18 −7.316e-16.
  - `/usr/bin/python3 -I smooth.py` (numpy `leggauss` / scipy `fixed_quad`): n=14 1.845e-13 / 1.840e-13; n=16 −2.875e-16 / −7.316e-16; n=18 1.566e-16 / 1.566e-16; n=20 1.566e-16 / −2.875e-16.
  - `/usr/bin/python3 -I trunc.py` (nodes Newton-refined and weights computed in 50-digit mpmath, so this is the rule's truncation error in exact arithmetic): n=12 3.3117e-10, n=14 1.8463e-13, **n=16 4.1656e-17**, n=18 2.4566e-21.
  - So the old "4×10⁻¹⁷" is the rule's exact-arithmetic truncation error at n=16, which is below double-precision round-off. A Float64 computation like the page's gets an error of about 3e-16 to 1e-15. The finding holds as stated: the value cannot occur in a double-precision run.
- Change: `index.qmd` line 35, last sentence. "…already has error $4\times10^{-17}$ at $n=16$." → "…already has error about $1.8\times10^{-13}$ at $n=14$ and reaches double-precision round-off level (about $10^{-15}$ or less) by $n=16$."
  - I wrote 1.8e-13 rather than the review's suggested 1.9e-13. The exact-arithmetic value is 1.846e-13, numpy gives 1.845e-13, and only the script's eigenvalue routine gives 1.862e-13.
- Check: the numbers above. Every Float64 implementation has |error| ≤ 1.05e-15 at n=16, 18 and 20 (at round-off level, "about 10⁻¹⁵ or less"). At n=14 every implementation gives 1.84e-13 to 1.86e-13 (rounds to "about 1.8×10⁻¹³").

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd l.35, last sentence | "error about $1.8\times10^{-13}$ at $n=14$" | `python3 -I trunc.py` → 1.8463e-13; `python3 -I smooth.py` → 1.845e-13 (numpy), 1.840e-13 (scipy); `julia smooth.jl` → 1.862e-13 | yes |
| same | "reaches double-precision round-off level (about $10^{-15}$ or less) by $n=16$" | `julia smooth.jl` n=16 1.045e-15, n=18 −7.3e-16; `smooth.py` n=16 −2.9e-16 / −7.3e-16, n=18 1.6e-16, n=20 1.6e-16 / −2.9e-16; truncation alone at n=16 is 4.2e-17 < spacing 4.44e-16 (`trunc.py`, `smooth.py`) | yes |
| same | integrand "$1+e^{-x}\sin 8x$ on $[0,2]$" (unchanged) | closed form = `mp.quad` = 2.1396277602002456530 | yes |

## Scripts and GIFs
- No scripts changed and no GIFs regenerated. The finding is in the page text only, and the review found the committed GIF byte-identical to a regeneration.
- `git status --short -- pages/numerical-methods/gauss-legendre-quadrature` → ` M pages/numerical-methods/gauss-legendre-quadrature/index.qmd` (only).

## Legacy archive
- Consulted: `n2003/GaussianQuadMod.html` and `gaussianquad/GaussianQuadMod/Links/*.html` (text stripped). The example functions are in images, not in the text.
- The round-4 review had already confirmed that archive Example 6 uses f(x) = 1 + e^{-x} sin(8x^{2/3}) on [0,2], the page's integrand.
- The smooth contrast integrand 1 + e^{-x} sin 8x does not appear in the archive text. It is the page's own comparison, so the archive has no bearing on F1.

## Notes
- The two cosmetic points in the review (the function label slightly overlapping the "2.0" y tick, and the frame-2 label "True / Numerical Quadrature") are not findings and were not touched.
- Nothing outside the page folder was touched apart from this record.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- The diff changes one sentence in `index.qmd` (Case 1 Behavior, last sentence). "already has error $4\times10^{-17}$ at $n=16$" became "already has error about $1.8\times10^{-13}$ at $n=14$ and reaches double-precision round-off level (about $10^{-15}$ or less) by $n=16$".
- Independent check (`check/smooth.py`): I computed the exact integral $I = 2 + (8 - e^{-2}(\sin 16 + 8\cos 16))/65 = 2.13962776020024565\ldots$ and confirmed it against `mpmath.quad` (difference 0 at 50 digits). I built the Gauss-Legendre nodes and weights at 50 digits by Newton iteration on $P_n$ and compared them with numpy `leggauss` in Float64.
  - Exact-arithmetic rule error: n=12 3.31e-10, n=13 -8.75e-12, **n=14 1.846e-13**, n=15 -3.1e-15, n=16 4.17e-17, n=17 -4.2e-19.
  - Float64 rule error (numpy) against the true I: n=14 1.845e-13, n=15 -3.8e-15, **n=16 -2.9e-16**, n=17 -7.3e-16, n=18 1.6e-16. fl(I) - I = 1.566e-16.
  - The finding's own data from the script's Golub-Welsch routine gives 1.861e-13 at n=14, and 8.9e-16 / 1.05e-15 at n=16.
- "about 1.8e-13 at n=14" is right: the exact value is 1.846e-13 and the Float64 values are 1.845e-13 and 1.861e-13. "Round-off level (about 1e-15 or less) by n=16" is also right: every Float64 result at n>=16 lies between 1.6e-16 and 1.05e-15, and the truncation error (4e-17) is below round-off.
- Side note, not a defect: the old "4e-17" was in fact the exact-arithmetic truncation error at n=16 (4.17e-17). It is still not attainable in Float64, as the finding said. The new wording is true under either reading.
- The script and GIF were not involved. Neither the frames nor the script show this smooth contrast, so there is nothing else to change.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd Case 1 Behavior, last sentence | "smooth integrand $1+e^{-x}\sin 8x$ on $[0,2]$" | Unchanged from before; the exact I was checked by closed form vs mpmath.quad | OK |
| same | "error about $1.8\times10^{-13}$ at $n=14$" | 50-digit GL: 1.846e-13; Float64 numpy: 1.845e-13; script GW: 1.861e-13 | OK |
| same | "double-precision round-off level (about $10^{-15}$ or less) by $n=16$" | Float64 errors at n=16..18: 2.9e-16, 7.3e-16, 1.6e-16 (numpy); 8.9e-16 / 1.05e-15 (script GW); truncation 4.2e-17 < eps(2.14)=4.4e-16 | OK |

### New problems
None. This rests on three things:
- the diff is a single sentence, and every number in it was recomputed above;
- no other text, alt text, script or GIF in the page folder changed (`git status` for the folder shows only `index.qmd` modified);
- the rest of the paragraph is byte-identical to before.

### Reproducibility and conventions
- No script or GIF changed in this page folder, so there was nothing to regenerate. `gausslegendreaa.jl` and `gausslegendreaa.gif` match HEAD.
- Conventions hold. Description comes before Animations, Case 1 has a `[Julia source](gausslegendreaa.jl)` link and a GIF embed with descriptive alt text, and the page has no code blocks.
- Files outside the folder: the working tree has modifications in other numerical-methods page folders and untracked review folders. These belong to other pages' fixes in this round. The diff for this page touches only `pages/numerical-methods/gauss-legendre-quadrature/index.qmd`.

**Final status:** committed
