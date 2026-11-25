# Review: Fourier series (batch 14, animation page)

Page: `pages/numerical-methods/fourier-series/index.qmd` with 10 scripts and 10 GIFs (Cases 1–10; Cases 6 and 7, `fourierfftaa` and `fourierfftbb`, new in this batch; old Cases 6–8 renumbered 8–10). The plan asks for this page to be reviewed in full, so the claim ledger covers the whole page: Description, Animations, definitions, theorems and Examples 1–7.

The reviewer consulted the archive: the module and its link pages and images (including Mathews' printed outputs), both legacy animation index pages, and the frames of all four surviving legacy GIFs.

**Calibration page.** This was the run's only page and its pilot. The reviewer worked on a scratch copy of the folder with two planted errors (Case 7's peak at $m = 9$ changed to 3.257; Case 6's error said to fall at every frame). The reviewer found both, and they were its only findings. They are removed. The copy had the same line count as the page.

**Findings: 0 Error, 0 Misleading, 0 Minor.**

## Inventory (Phase 1, by the director)

| Script | GIF | Case | Regenerated |
|---|---|---|---|
| fourierseriesaa.jl | fourierseriesaa.gif | 1 | byte-identical |
| fourierseriesbb.jl | fourierseriesbb.gif | 2 | byte-identical |
| fourierseriescc.jl | fourierseriescc.gif | 3 | byte-identical |
| fourierseriesdd.jl | fourierseriesdd.gif | 4 | byte-identical |
| fourierseriesee.jl | fourierseriesee.gif | 5 | byte-identical |
| fourierfftaa.jl | fourierfftaa.gif | 6 (new) | byte-identical |
| fourierfftbb.jl | fourierfftbb.gif | 7 (new) | byte-identical |
| fourierfftcc.jl | fourierfftcc.gif | 8 | byte-identical |
| fourierfftdd.jl | fourierfftdd.gif | 9 | byte-identical |
| fourierfftee.jl | fourierfftee.gif | 10 | byte-identical |

Julia global environment, Plots 1.41.2. Every script and GIF is linked and embedded by the page; no missing or unreferenced file. The section index links the page; the retired FFT page's URL redirects to it.

## Claim ledger (condensed; about 120 entries)

Confirmed, apart from the two planted claims:

- **Description and introduction:** the series, the discrete series and the DFT relation (numpy convention), least squares and interpolation, the Gibbs constant; the case frame scheme and colours, which title number each case shows, the direct sums agreeing with the FFT.
- **Fidelity claims:** the ten animations on Mathews' index pages, the four surviving GIFs, the degree sequences read from his frames (Case 5: 25 frames; Cases 8–10: 1, 3, …, 17 and 1, …, 17), and the identification of the two lost discrete-series functions (bullet colours, image sizes, a byte-identical fifth formula image).
- **Cases 1–5:** every value and monotonicity claim (e.g. 0.2976 → 0.02447; peak 2 → 3.582 at $2\pi - \pi/(m+1)$; overshoots 0.5477, 0.5615 against the Gibbs 0.5623; 1.273 → 1.179 above 1.17898; 2.580 → 0.1568; 3.942, then 3.673–3.734).
- **Case 6:** symmetries, odd $m$ only, interpolation, error at the corners up to $m = 11$, falling to 0.02976 at $m = 13$ and rising to 0.03322 at $m = 17$ at $x \approx 0.0705$, below $S_{17}$'s 0.03533.
- **Case 7:** $a_j = 0$, $b_2 = -0.9898$, interpolation, peak rising to 3.227 at $m = 9$ and falling to 3.115, above π only for $6 \le m \le 15$, 0.2018 above the line, $S_{17}$ 3.528 and 0.5607.
- **Cases 8–10:** as before, every value reconfirmed.
- **Theorems:** discrete orthogonality, (9), aliasing.
- **Examples 1–7:** every number, table row and comparison with Mathews' printed output, including the reconstruction of his "wrong" 13-point fit and the Mathematica `Fourier` convention.
- **Wiring and markup.**

## Implementation checks

Instrumented copies of all 10 scripts print values identical (to 6 decimals) to the reviewer's independent Python computation: sympy coefficients for the Fourier-series scripts, numpy FFT and direct sums for the discrete ones, on 200,001–400,001-point grids with refinement. The methods are the ones named. The pictures (sheets for all ten, key frames at full size) show what was computed, with nothing clamped. No numerically computed reference curves are used; the Gibbs constants were checked with `scipy.special.sici`.
