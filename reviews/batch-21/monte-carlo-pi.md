# Monte Carlo Pi — batch 21 review, round 1 (overview mode)

SUMMARY: 0 Error, 0 Misleading, 1 Minor

Page: `pages/numerical-methods/monte-carlo-pi/index.qmd`, light-pass batch 21, overview (extend). The diff changes only index.qmd and no script or GIF. The committed GIF's frames match the manifest's frames.md5 set (6 frames, 630x630). I did consult the Mathews archive: `n2003/montecarlopimod.html`, plus its image `MonteCarloPiMod_gr_28.gif`, which reads "O(n^{-1/2})". I ran no MATLAB, no quarto, and nothing in the repository. My scratch files are in EV/reviewer/ (`vals.jl`).

## 1. Findings

**F1 — Page text, Minor.** Description line 30: "In [Case 1](#case-1) the first four frames quadruple $n$ each time, from 100 to 6400, and the printed standard error halves each time, from 0.1642 to 0.0205."
- **What is there now:** The GIF has 6 frames. Frame 1 is the opening frame with no points and no n. The Case 1 Behavior paragraph says so: "After the opening frame (quarter circle only, no points)…". The frames with n = 100, 400, 1600, 6400 are frames 2–5, not "the first four frames".
- **How I know:** I looked at the contact sheet `sheet.png` and the full-size frames 5 and 6. The script loops over `vcat(0, n_seq)`.
- **What is true:** The numbers in the sentence are correct (see C14).
- **Suggested fix:** "the first four frames with points (n = 100 to 6400) quadruple n each time…", or "frames 2–5 quadruple n…".

No other findings.

## 2. Claim ledger (diff + lines and the added heading id)

| # | Claim (page's words, abridged) | Verdict | Evidence |
|---|---|---|---|
| C1 | "measures an area by random sampling" | confirmed | Method definition; the script's hit test. |
| C2 | Quarter disk x²+y²≤1, x,y≥0, has area π/4 and lies in [0,1]², which has area 1 | confirmed | Elementary. |
| C3 | "samples random points uniformly in the unit square and counts how many lie inside" | confirmed | Script: `xs=rand(max_n)`, `ys=rand(max_n)`, `inside = xs.^2 .+ ys.^2 .<= 1.0`. |
| C4 | π̂_n = 4m/n (display, unchanged) | confirmed | Script: `pi_hat = 4*m/n`. Same notation (m, n). |
| C5 | Points must be independent and uniform, so each lands in the quarter disk with probability p = π/4, the ratio of the areas | confirmed | Elementary. |
| C6 | Case 1 uses a pseudorandom generator with a fixed seed, so it is reproducible; another seed gives a different estimate | confirmed | Script: `Random.seed!(12345)`. Re-running gives the frame values exactly. Seed 1 gives π̂_10000 = 3.1192, against 3.162 for seed 12345. |
| C7 | General result: m is binomial with mean np, so π̂_n is unbiased, and by the LLN it converges to π with probability 1 | confirmed | Bernoulli(p) i.i.d. sum; E[4m/n] = 4p = π; strong LLN. Labelled general, with its hypotheses ("Under these hypotheses"). |
| C8 | σ_n = 4√(p(1−p)/n) ≈ 1.642/√n, p = π/4 | confirmed | 4√(p(1−p)) = 1.642183. The script's `se` uses the same formula. |
| C9 | Mathews: converges very slowly, O(n^{-1/2}), a consequence of the CLT | confirmed (fidelity) | Module text says the values "converge very slowly of the order [O(n^{-1/2})]… a consequence of the Central Limit Theorem". The image gr_28 shows O(n^{-1/2}). |
| C10 | For large n, π̂_n is approximately normal, so ~95% of runs land within 1.96σ_n of π | confirmed | De Moivre–Laplace; np(1−p) ≥ 16.9 already at n = 100. Hedged "for large n". |
| C11 | The rate does not depend on dimension, hence MC is useful in many dimensions | confirmed | General: Var/n is independent of d for the n^{-1/2} rate. |
| C12 | Case 1 first frames: n goes 100→400→1600→6400 (quadrupling) | confirmed numbers; frame indexing wrong (F1) | Frames 2–5 show n = 100, 400, 1600, 6400. |
| C13 | The printed standard error halves each time | confirmed | Frames print 0.164218, 0.082109, 0.041055, 0.020527. |
| C14 | "from 0.1642 to 0.0205" | confirmed | Computed 0.1642183, 0.0205273. |
| C15 | Error of a single run is random and need not shrink as n grows | confirmed | Shown by C16. |
| C16 | Case 1: abs(π−π̂_n) is 0.0140 at n = 6400 but 0.0204 at n = 10 000 | confirmed | Computed 0.0140323 (m = 5049, π̂ = 3.155625) and 0.0204073 (m = 7905, π̂ = 3.162). Frames print 0.014032 and 0.020407. |
| C17 | "although the larger sample contains the smaller one" | confirmed | Script uses `idx = 1:n` on a single pre-drawn array (prefixes). |
| C18 | No guaranteed error bound, only a probable one | confirmed | The estimator is random. |
| C19 | Each extra correct decimal needs 100× as many points | confirmed | σ ∝ n^{-1/2}: σ/10 needs 100n. |
| C20 | Error below 0.0005 at 95% needs (1.96·1.642/0.0005)² ≈ 4.1×10⁷ points | confirmed | Computed 4.1430×10⁷ (4.1440×10⁷ with the unrounded constant). |
| C21 | Non-uniform or non-independent points (a poor generator) can bias the estimate, and σ_n then no longer describes the error | confirmed | Hedged "can". Non-uniform points change p. Dependence invalidates the binomial variance. |
| C22 | Monte Carlo Integration uses the same sampling with the sample-mean estimator instead of counting hits | confirmed | That page's line 13 defines the "sample-mean estimator". Its line 22 says hit-or-miss is on this page. |
| C23 | Simpson's Rule and the 2D Trapezoidal/Simpson Rules converge much faster in 1 or 2 dimensions for smooth integrands | confirmed | General: composite Simpson's error is O(N^{-4}) in 1D and O(N^{-2}) in 2D in total points N. Trapezoidal 2D is O(N^{-1}). All beat N^{-1/2}. Conditioned on "smooth". |
| C24 | Heading id `{#case-1}` added to the Case 1 heading; three `[Case 1](#case-1)` links | confirmed | The anchor exists. This is an allowed cross-reference edit. |

The Description contradicts nothing in the Animations section. The intro gives n = 100…10000 and the Behavior paragraph's "fluctuates but trends toward π" agrees with C15/C16. The Behavior paragraph's 0.68–1.35 standard-error ratios match the computed 0.684–1.349.

## 3. Checks

- **Six points of the overview standard:** all present.
  1. Problem: the first three sentences.
  2. Core formula: the π̂_n display, in the script's notation.
  3. Assumptions: independent, uniform points (paragraph 2).
  4. Accuracy: unbiased, LLN, σ_n display, O(n^{-1/2}) and the CLT 95% band. It is labelled as general and checked against Case 1's printed standard errors.
  5. Failure modes: non-monotone single-run error, shown in Case 1 with computed values; the slow rate with a 4.1×10⁷ example; a poor generator.
  6. Where it fits: the last sentence, linking Monte Carlo Integration, Simpson's Rule and 2D Trapezoidal/Simpson.

  There are no proofs or theorem boxes.
- **Word count:** the manifest gives 398. My own count is 408 raw tokens, including about 11 punctuation-only tokens left after inline math (e.g. "$x,y\ge 0$,"), so about 397–398. It is within 150–400, but only just.
- **Links and anchors:**
  - `#case-1` matches the explicit id on the Case 1 heading.
  - `../monte-carlo-integration/`, `../simpsons-rule-for-numerical-integration/` and `../2d-trapezoidal-and-simpson-rules/` each exist with an index.qmd.
  - `[Julia source](montecarlopiaa.jl)` and the GIF embed are unchanged and the files exist.
- **Scope of the diff:**
  - Description rewritten and extended. The old sentences were replaced, not moved out of Animations.
  - Outside the Description, the only change is `{#case-1}` on the Case 1 heading, which is allowed.
  - No script, GIF or other section is changed.
- **Numbers:** I recomputed every Case 1 value independently in Julia with the script's seed and draws (`EV/reviewer/vals.jl`). For n = 100, 400, 1600, 6400, 10000:
  - m: 73, 306, 1270, 5049, 7905
  - π̂: 2.92, 3.06, 3.175, 3.155625, 3.162
  - abs(error): 0.221593, 0.081593, 0.033407, 0.014032, 0.020407
  - se: 0.164218, 0.082109, 0.041055, 0.020527, 0.016422

  All match the printed text in frames 2–6.
