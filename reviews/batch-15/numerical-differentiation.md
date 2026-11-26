# Numerical Differentiation — batch 15 review (round 1)

Page: `pages/numerical-methods/numerical-differentiation/` (extend, plus 4 new cases). Mode: overview mode for the changed text (Description, Animations introduction, links, heading ids); full review of the new Cases 3–6 (`numdiffac.jl` … `numdiffaf.jl`). Cases 1–2 unchanged and not under review.

**Result: 0 Error, 0 Misleading, 0 Minor.**

The clean result rests on recorded evidence: every table cell recomputed in Python and Julia; every error term by sympy Taylor expansion with its hypothesis; all 116 values printed in Mathews' four legacy GIFs transcribed and matched; halving ratios checked over every pair; the "not animated" list checked against every example of the module; first, middle and last frames of each new GIF inspected against the code.

Archive consulted: module text, solution pages for Examples 9, 10, 12 (images), the missing Example 13 images, theorem images, and every frame of `a2001/Animations/Derivative/{ForwardD1f,ForwardD2f,BackwardD1f,BackwardD2f}`.

Reviewer's observation (not a finding): the Description's failure modes (roundoff, noisy data) link to no case, because no animation reaches small enough h to show roundoff; the standard only says "prefer" an animated failure mode. Case 5's large-h behaviour (D₂⁻ has the wrong sign for h ≥ 0.45) could serve as a link if wanted.

## Findings

None.

## Unresolved

None.

## Inventory (director's Phase 1)

- Scripts: `numdiffaa.jl`, `numdiffab.jl` (unchanged, 12 frames each), `numdiffac.jl` (34), `numdiffad.jl` (24), `numdiffae.jl` (34), `numdiffaf.jl` (24). All ran in scratch; all six GIFs byte-identical to the committed files.
- No control characters, leftover placeholder sections, localhost links or code blocks; every page link and case anchor resolves; every `.jl`/`.gif` is referenced; the section index links the page.
- Description prose: 392 words (director and reviewer agree). Within 150–400.

## Claim ledger (reviewer)

### Description (`+` lines and the moved sentence)

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| D1 | Each formula differentiates the interpolating polynomial at its points | confirmed | by hand; module Background |
| D2 | One-sided formulas $D_2^\pm$, $D_3^\pm$; subscript counts points | confirmed | sympy; Mathews' Ex 9, 10, 12 |
| D3 | $D_3^{(2)}$ | confirmed | sympy; gr_12 |
| D4 | $f'=D_2^\pm\mp\tfrac h2 f''(c)$ | confirmed | sympy |
| D5 | $f'=D_3^\pm+\tfrac{h^2}3 f'''(c)$ | confirmed | sympy; single-c form via divided differences |
| D6 | $f'=D_3-\tfrac{h^2}6 f'''(c)$ | confirmed | sympy; gr_5 |
| D7 | $f''=D_3^{(2)}-\tfrac{h^2}{12}f^{(4)}(c)$ | confirmed | sympy; gr_13 (module writes $f^{(4)}[x]$, page correctly $c$) |
| D8 | Hypothesis: derivative continuous on the interval spanned; $c$ in it | confirmed | sufficient (Lagrange remainder, IVT, MVT for divided differences) |
| D9 | Two-point O(h) (Cases 3, 5); three-point O(h²) (Cases 4, 6) | confirmed | ratios 1.198 → 1.9991; 2.834 → 2.0009; 3.052 → 3.9982; 4.731 → 4.0018 |
| D10 | Central 1/6 is half the one-sided 1/3 | confirmed | |
| D11 | Cases 1, 2 show $D_3$ approaching $f'$ as h falls to 0.001 | confirmed | scripts' h lists |
| D12–D17 | Table at x = 1, double precision, all 20 cells | confirmed | Python and Julia agree (e.g. h = 1e-8: 3.2973e-9, 3.2973e-9, 5.2175e-10, 1.5758e-1) |
| D18 | Tenfold cut divides errors by about 10 / 100 until roundoff | confirmed | 9.25, 9.92, 9.99; 91.9, 99.2, 99.9; $D_3^{(2)}$ 33 at 1e-4 (roundoff) |
| D19 | Backward within about 20% of forward; $D_2^-$ opposite sign | confirmed | −1.186 … −1.000; 1.200 … 1.000 |
| D20 | Moved sentence, words unchanged | confirmed | diff |
| D21 | Cancellation explanation, ε ≈ 2.2e-16 | confirmed | predicted optima 2e-8, 6e-6, 1e-4 |
| D22 | Best powers of ten: 1e-8, 1e-5 (error ~1e-11), 1e-4 | confirmed | |
| D23 | At 1e-8 the $D_3^{(2)}$ error is 40% of $\lvert f''(1)\rvert$ | confirmed | 0.396 |
| D24 | Measured-data errors magnified the same way | confirmed (qualitative) | |
| D25 | Related-page sentence | confirmed | Richardson line 23/26 |
| D26 | Six points; 5-row table; no proofs or callouts | confirmed | |
| D27 | Word count ≤ 400 | confirmed | 392 |

### Animations introduction and headings

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| A1 | Cases 3–6 rebuild Examples 9, 12, 10, 13 at $x_0=1$ | confirmed | lnk_13, 16, 14, 17 link the four GIFs |
| A2 | With his steps h | confirmed | legacy frames; scripts identical except final 0.0005 (A6) |
| A3 | His window 0 ≤ x ≤ 2.1 | confirmed | Mathematica PlotRange; scripts |
| A4 | True tangent added | confirmed | |
| A5 | Every printed f′(1) value reproduced to six decimals | confirmed | all 34 + 34 + 24 + 24 |
| A6 | Last legacy frame prints h = 0.001 but its value is h = 0.0005 in the O(h) GIFs | confirmed | D₂⁺ −0.110992 vs −0.110893 (legacy −0.110893); D₂⁻ −0.110595 vs −0.110694 (legacy −0.110694) |
| A7 | Updated "not animated" list | confirmed | covers exactly the unanimated examples |
| A8 | Heading ids and Description links | confirmed | |
| A9 | Case headings | confirmed | |

### Cases 3–6

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| C3.1–C3.7 | Case 3: h 1 → 0.0005; f′(1) ≈ −0.110794; error positive; grows 0.07571 → 0.07594 then shrinks; ratios 1.20, 1.92, 2.00; last 0.1987h vs 0.1988h; alt text | confirmed | 0.0757061, 0.0759357; 1.1982, 1.9150, 1.9991; 0.198681 vs 0.198766 |
| C4.1–C4.5 | Case 4: parabola slope, tangency; h 0.5 → 0.0005; error 0.05066 → 8.468e-8 decreasing; ratios 3.05, 3.81, 4.00; 0.3387h² vs 0.3389h² | confirmed | |
| C5.1–C5.8 | Case 5: $D_2^->0$ exactly for h ≥ 0.45; left point on rising side (origin at h = 1); negative from 0.4; above f′(1), \|error\| shrinking; ratios 2.83, 2.09, 2.00; from above vs Case 3 from below; −0.1989h; alt text | confirmed | |
| C6.1–C6.7 | Case 6: parabola, tangency; error 0.1237 → 8.476e-8; ratios 4.73, 4.18, 4.00; from above vs Case 4; 0.3390h²; Example 13 solution lost but GIF survives; every printed value is $D_3^-$ | confirmed | gr_306–324 absent; all 24 match |

Consistency with unchanged text: Derivation Notes and Cases 1–2 are not contradicted.

## Implementation checks (Cases 3–6)

- **Method:** each script computes the formula its heading names (`(yr − y0)/h`; `(−3y0 + 4y1 − y2)/(2h)`; `(y0 − yl)/h`; `(3y0 − 4y1 + y2)/(2h)`); the parabola coefficient makes p interpolate all three stencil points and its slope at $x_0$ is the difference quotient.
- **Numbers:** instrumented scratch copies against 40-digit mpmath: maximum relative error difference 4.8e-10 (ac), 1.5e-6 (ad), 4.6e-10 (ae), 1.9e-6 (af; double-precision roundoff on errors near 1e-7). No 4-significant-figure label disagrees; every 6-decimal D label equals the legacy value. E.g. Case 6, h = 0.5: D = −0.234466, error 0.1237 (mpmath 0.123672).
- **Reference:** $f'(x)=e^{-x}(\cos x-\sin x)$ exact; $f'(1)=-0.1107937653$.
- **Picture:** frames 1, middle and last of each GIF: secants through their stencil points, tangent intercept 0.420 = f(1) − f′(1), parabolas through the orange points with the dotted line tangent at $x_0$; titles correct; clipping (Case 5's h = 1 secant, Case 6's parabola) does not change the conclusion; stencils asserted inside [0, 2.1].
- **Fidelity:** function, $x_0$, h sequences, x-window and printed values match Mathews; departures (added tangent, final h = 0.0005, y-window (−0.1, 0.55) vs his (0, 0.45)) are deliberate.
