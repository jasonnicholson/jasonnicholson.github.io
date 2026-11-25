# Batch 14 review (Fourier series)

Scope: the Fourier series page, reviewed in full on 2026-11-25 after batch 14 added Cases 6 and 7 (Mathews' lost discrete-series animations FFT1 and FFT2) and retired the FFT and Trigonometric Polynomials page in its favour.

- **Archive:** found and consulted (module, link pages, output images, legacy index pages, surviving legacy GIF frames).
- **Environment:** Julia global environment (Plots 1.41.2) and `/usr/bin/python3` (numpy, scipy, sympy, mpmath). No MATLAB, no quarto by the reviewer. All 10 scripts regenerate byte-identical GIFs.
- **Calibration:** the page was reviewed on a scratch copy with two planted errors; the reviewer found both, and they were its only findings.

**Totals: 0 Error, 0 Misleading, 0 Minor.**

| Page | Scripts | GIFs | Error | Misleading | Minor | Status |
|---|---|---|---|---|---|---|
| [fourier-series](fourier-series.md) | 10 | 10 | 0 | 0 | 0 | reviewed (calibration pilot) |

The citation edits of batch 14 (task D) were checked separately, as the plan specifies, by an independent checker. It confirmed the two `references.bib` entries against the publisher and library records, and found that the Powell sentence claims only what Powell's paper supports. It verified the predictor-corrector order theorem by computation: 66 of 66 predictor/corrector/$m$ combinations agree with its three cases. It confirmed that Lambert is now cited only for the page's source chapter, because the theorem could not be found in his book. Its one optional note is that the Predictor-Corrector introduction still says the page draws on Lambert's chapter, although batch 4 drafted it from standard knowledge. That line is left for Jason.

## Closing (batch 14 run, 2026-11-25)

**Tasks, one commit each:**
- **A, retire FFT and Trigonometric Polynomials:** the folder is deleted. The Curve Fitting index entry now points at `fourier-series/#discrete-fourier-series-from-equally-spaced-data`, labelled "(on the Fourier series page)". The Fourier series page's front matter has `aliases: ../fft-and-trigonometric-polynomials/index.html`; the rendered redirect page was checked, and it forwards to the Fourier series page. This is the first use of `aliases` on the site.
- **E, rebuild FFT1 and FFT2:** `fourierfftaa.jl` and `fourierfftbb.jl` are now Cases 6 and 7, built the same way as Mathews' surviving discrete-series animations. The old Cases 6–8 are now Cases 8–10, and the Animations introduction and Example 7 are extended. Both GIFs regenerate byte-identically. Case 6 shows odd degrees only, because the even-$j$ terms of the 36 samples of $\lvert x-\pi\rvert$ were computed to vanish. Case 7 shows every degree.
- **D, citations:** `powell1964efficient` and `lambert1991numerical` are added to `references.bib` and cited by key. Powell's termination result was confirmed from the abstract and secondary sources, plus a computation. The predictor-corrector order theorem could not be found in Lambert's book from any source the agent could read, so its heading now says "(general)". The theorem was verified by computation (66 of 66 cases), and Lambert is cited only for the page's source chapter.

**Review:** one round of the whole Fourier series page, with 0 findings after calibration. The citation edits were independently checked, as the plan specifies, instead of a full re-review.

**Decisions taken for Jason (revisit if wanted):**
- The degrees of Cases 6 and 7 (odd $m \le 17$, and $m = 1..17$) and the $n = 36$ midpoint-sample convention are inferred from Mathews' surviving FFT animations, because the lost ones' frames are gone. The page says so.
- The Predictor-Corrector introduction still says the page draws "in particular" on Lambert's chapter on predictor-corrector methods. The checker suggests "standard treatments such as …", because batch 4 wrote the page from standard knowledge, not from the book.
- `batch-14` is stacked on `batch-13`, not branched from `main` as the follow-on plan suggested. Both edit the plan's status list and adjacent rows of its page table, so separate branches would conflict there. Batch 14's own commits touch only the index, the Fourier series, Powell and Predictor-Corrector pages, `references.bib`, the plan and `reviews/batch-14`.
- The section index's status note ("60–80% done", in Jason's own words) is not updated. The follow-on plan asks for that after the last batch, but it is his voice and his call.

**Commits on `batch-14`:** Retire the FFT and Trigonometric Polynomials page (task A); Add Fourier series discrete-series Cases 6 and 7 (task E); Add Powell (1964) and Lambert (1991) citations (task D); Add batch 14 review; Mark batch 14 done.
