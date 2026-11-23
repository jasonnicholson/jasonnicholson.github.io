# Legendre Polynomials — animation review (round 6)

Page: `pages/numerical-methods/legendre-polynomials/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I found no Error, Misleading, Minor or Fidelity findings.

Two observations that are not findings:
- The page has no `## Description` section, although the authoring conventions (`.github/agents/animation-page.agent.md`, line 12) require one. That is missing content, so it falls outside the review standard. It also means there are no Description formulas to check against the scripts. The only method formulas on the page are the recurrence and the $c_n$ formula in the Animations section, and I checked both (ledger entries 7 and 12).
- The page draws on two of the archive's examples: Example 6 (orthogonality of $P_0,\ldots,P_5$) for Case 1, and Example 8(b) for Case 2. It does not use Example 8(a) ($f=e^x$), Mathews' comparison with the discrete interpolation polynomial, or his choice of $n=4$. Case 2 instead runs to $N=8$. The archive has no animation for this topic; the only Legendre-related item under `a2001/Animations` is Gauss–Legendre quadrature, which is a different topic. The archive's Example 8(b) solution graphs (`gr_336`–`gr_343`) are missing from disk. I judge this a reasonable selection rather than a silent drop that a reader would notice: the page names its source example correctly and uses its function and interval exactly. So I am not reporting it as a Fidelity finding.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `legendrepolyaa.jl` | 0 | 6.1 | legendrepolyaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `legendrepolybb.jl` | 0 | 8.3 | legendrepolybb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `legendrepolyaa.gif` | 6 | byte-identical | legendrepolyaa |
| `legendrepolybb.gif` | 9 | byte-identical | legendrepolybb |

### Page references

- Scripts linked: `legendrepolyaa.jl`, `legendrepolybb.jl`
- GIFs embedded: 2
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

Each claim is quoted from `index.qmd`, followed by its verdict and the evidence.

| # | Claim (page wording) | Verdict | Evidence |
|---|---|---|---|
| 1 | Intro: "Each animation below illustrates Legendre polynomials $P_n(x)$ on $[-1,1]$" | confirmed | Both scripts use `x = range(-1.0, 1.0, length=500)` and `xlims=(-1,1)`. |
| 2 | Intro: "The first animation reveals $P_0$ through $P_5$ one per frame" | confirmed | `n_max = 5`, loop `0:n_max`. The committed GIF has 6 frames, and frame k shows $P_0..P_{k-1}$ (contact sheet). |
| 3 | Intro: "the second shows the Legendre series partial sums converging to $f(x)=e^{x}\cos(\pi x/2)$" | confirmed | The script has `f(x) = exp(x) * cos(π * x / 2)` and 9 frames for $S_0..S_8$. The max error falls to 7.74e-6 (entry 17). |
| 4 | Case 1 heading: "Successive polynomials $P_0, P_1, \ldots, P_5$" | confirmed | As in entry 2. |
| 5 | "Each $P_n$ is orthogonal to all lower-degree Legendre polynomials on $[-1,1]$" | confirmed | By mpmath quadrature (40 digits), $\max_{m\ne n\le5} \lvert\langle P_m,P_n\rangle\rvert = 3.1\times10^{-44}$. |
| 6 | "$P_n(1)=1$, $P_n(-1)=(-1)^n$" | confirmed | mpmath gives this for n=0..5. The script's own `legendre` also gives it for n=0..8 (from `bb_instr.jl`). The frames show every curve passing through (1,1), with odd-degree curves at (−1,−1). |
| 7 | "$P_n$ has exactly $n$ zeros in $(-1,1)$" | confirmed | `legroots` gives 0,1,2,3,4,5 roots, all inside the interval. $P_5$: ±0.9062, ±0.5385, 0. $P_4$: ±0.8611, ±0.3400. These match the crossings in frame 6. |
| 8 | "They are computed by the recurrence $(n+1)P_{n+1} = (2n+1)xP_n - nP_{n-1}$" | confirmed | The script (aa:20, bb:22) runs `P = ((2k-1)*x*Pprev1 - (k-1)*Pprev2)/k`, which is the page's recurrence with k=n+1. Its values at x=0.3 and x=−0.7 agree with mpmath to all printed digits for n=0..8. For example, $P_8(0.3)$ is −0.239074591015625 from the script and −0.239074591016 from mpmath. |
| 9 | Alt 1: "P_0 through P_5 added one per frame on the interval [-1, 1], showing their oscillatory character" | confirmed | Frames 1–6. |
| 10 | Link/embed Case 1: `legendrepolyaa.jl` / `legendrepolyaa.gif` | confirmed | The script writes `legendrepolyaa.gif`. Per the manifest, the regenerated GIF is byte-identical to the committed one. |
| 11 | Case 2 heading: "Legendre series for $f(x) = e^{x}\cos(\pi x/2)$" | confirmed | Matches `f` in the code and the plot title `exp(x)cos(πx/2)`. |
| 12 | "$S_N(x)=\sum_{n=0}^{N} c_n P_n(x)$ with $c_n = \tfrac{2n+1}{2}\int_{-1}^{1} f P_n\,dx$" | confirmed | Matches `legendre_coeff` (bb:38–42) and the partial-sum loop (bb:54–57). The integral uses 20-point Gauss–Legendre quadrature; see the implementation checks for its accuracy. |
| 13 | "converges to $f$ as $N\to\infty$" | confirmed | $f$ is entire, so its Legendre series converges uniformly. Numerically, $\lvert c_n\rvert$ decays to 7.2e-9 by n=11, and the max error falls monotonically from $N=1$ to 7.74e-6 at $N=8$. |
| 14 | "This $f$ is the function of Mathews' Example 8(b)" | confirmed | Archive image `LegendrePolyMod_gr_325.gif` reads `f[x] = e^x Cos[π/2 x]`, with interval `[-1, 1]` (`gr_323`). 8(a) is `e^x` (`gr_324`). |
| 15 | "it is neither even nor odd" | confirmed | On the 500-point grid, `np.allclose(F, F[::-1])` and `np.allclose(F, -F[::-1])` are both False. Also $c_1\ne0$ and $c_2\ne0$. |
| 16 | "every coefficient $c_0,\ldots,c_8$ is nonzero, so each frame adds a new term" | confirmed | From mpmath: 0.699044, 0.387536, −0.646504, −0.397214, −0.0562970, 0.00931625, 0.00377539, 0.000368653, −1.76477e-5. None is zero. |
| 17 | "Because $S_N$ minimises the integrated squared error rather than the maximum error, the max error need not fall at every step" | confirmed | The $L^2$ error decreases monotonically: 0.5596, 0.4615, 0.2140, 0.02688, 0.004242, 0.001487, 1.348e-4, 6.488e-6, 2.334e-6. The max error rises at N=1. |
| 18 | "it rises from 0.699 for $S_0$ to 1.09 for $S_1$" | confirmed | Independent: 0.699044 (at x=−1) and 1.08658 (at x=1). Script: 0.6990438, 1.0865797. |
| 19 | "then falls with each added term to $7.74\times10^{-6}$ for $S_8$" | confirmed | Independent max error on a 200001-point grid, N=1..8: 1.08658, 0.440076, 0.0622176, 0.0134349, 0.00411865, 3.79706e-4, 2.53844e-5, 7.7367e-6. This is strictly decreasing after N=1. The script's 500-point grid gives the same values to 6 digits, because the maximum always sits at x=±1. |
| 20 | Alt 2: "partial sums S_0 through S_8 … one per frame; every coefficient is nonzero, and the max error rises from 0.699 for S_0 to 1.09 for S_1, then falls with each added term to 7.74e-6 for S_8" | confirmed | As in entries 16, 18 and 19, plus the 9 frames. |
| 21 | Link/embed Case 2: `legendrepolybb.jl` / `legendrepolybb.gif` | confirmed | The script writes `legendrepolybb.gif`, and the regenerated GIF is byte-identical to the committed one. |
| 22 | Frame titles (Case 2) "max err = 0.699, 1.09, 0.44, 0.0622, 0.0134, 0.00412, 0.00038, 2.54e-5, 7.74e-6" | confirmed | These equal `round(err, sigdigits=3)` from the instrumented run, and they agree with the independent values. "0.00038" is 3.80e-4 with its trailing zero dropped. |
| 23 | Legends: Case 1 "P_k(x)" in colour order; Case 2 "f(x) = exp(x)cos(πx/2)" (solid blue), "S_n(x)" (dashed red) with the frame's n | confirmed | Plotting code at aa:41–45 and bb:68–70, checked against the contact sheets. |

### 3. Implementation checks

### `legendrepolyaa.jl`
- **Is it the method it claims to be?** Yes. It evaluates $P_n$ by the standard three-term (Bonnet) recurrence, the same one stated on the page.
- **Are the numbers right?** The `legendre` function is textually identical to the one in `legendrepolybb.jl` (checked with `diff`). Its values at x ∈ {0.3, −0.7, 1, −1} for n=0..8 agree with `mpmath.legendre` to every printed digit (see entry 8). Extrema I computed independently on a fine grid: $P_2$ min −0.5000, $P_3$ local extrema ±0.447, $P_4$ min −0.4286. These match what frame 6 shows.
- **Reference values:** none are used.
- **Does the picture show what was computed?** Yes. The 6 frames add one curve each with the right label and colour. The axis limits (−1.3, 1.3) contain everything, since every $\lvert P_n\rvert\le1$ on the interval. The legend sits in the upper right, but the common point (1,1) remains visible. The frame-1 title "P₀ … P_0" is awkward but accurate.

### `legendrepolybb.jl`
- **Is it the method it claims to be?** Yes. It computes the truncated Legendre (continuous least-squares) series, with $c_n=\frac{2n+1}{2}\int fP_n$, and plots the partial sums $S_0..S_8$. This is the same construction as Mathews' Theorem (Legendre Series Approximation) and his `lnk_16`/`lnk_17` code.
- **Is the quadrature right?** `gauss_legendre` is the Golub–Welsch method with off-diagonal $k/\sqrt{4k^2-1}$. For m=20, the weights sum to 1.9999999999999998. The rule integrates $x^{38}$ to 0.05128205128205075 (exact value 0.05128205128205128) and $x^{39}$ to 8e-16 (exact 0). It does not integrate $x^{40}$ exactly: 0.04878048780205 against 0.04878048780488. So its degree of precision is 39, as a 20-point Gauss rule's should be.
- **Are the numbers right?** The script and an independent mpmath adaptive quadrature at 40 digits agree on every coefficient to at least 12 significant figures:

  | n | script $c_n$ | mpmath $c_n$ |
  |---|---|---|
  | 0 | 0.6990438437957872 | 0.699043843795788 |
  | 1 | 0.38753580939387533 | 0.387535809393875 |
  | 2 | −0.6465040300987617 | −0.646504030098766 |
  | 3 | −0.39721354789070035 | −0.397213547890703 |
  | 4 | −0.0562969811584088 | −0.0562969811584083 |
  | 5 | 0.009316251038287279 | 0.00931625103829338 |
  | 6 | 0.0037753858196282524 | 0.0037753858196378 |
  | 7 | 0.000368653487362814 | 0.000368653487357218 |
  | 8 | −1.764768765977293e-5 | −1.76476876689254e-5 |

  The max error agrees as well, script against independent:

  | N | script | independent |
  |---|---|---|
  | 0 | 0.69904384 | 0.699044 |
  | 1 | 1.08657965 | 1.08658 |
  | 2 | 0.44007562 | 0.440076 |
  | 3 | 0.06221755 | 0.0622176 |
  | 4 | 0.01343491 | 0.0134349 |
  | 5 | 0.00411865 | 0.00411865 |
  | 6 | 3.797058e-4 | 3.79706e-4 |
  | 7 | 2.538439e-5 | 2.53844e-5 |
  | 8 | 7.736699e-6 | 7.7367e-6 |

- **Is the reference right?** The "true" curve is `f.(x)` evaluated exactly, the same function as in the title and on the page. On the plotted grid, $f$ ranges over [0, 1.2102], with its maximum near x=0.363.
- **Does the picture show what was computed?** Yes. The red dashed $S_N$ uses the coefficients above and the frame's n. On the plotted grid the partial sums span [−0.335, 1.2102] (lowest is $S_2$ at x=−1, highest $S_8$), which sits inside ylims (−1.3, 1.3), so nothing is clipped. From $S_4$ onward the two curves look identical, as they should for errors of 1e-2 or less, and the title reports the error. There are 9 frames, $S_0..S_8$.

### Commands
- `/usr/bin/python3 -I review/indep.py`: independent checks of the Case 1 properties, the coefficients, the max error on a 200001-point grid and on the 500-point grid, and the $L^2$ error.
- `julia review/bb_instr.jl`: the instrumented copy, printing the script's coefficients, max errors and title-rounded errors, the quadrature exactness for degrees 38–41, and the recurrence values for $P_0..P_8$.
- Inline `/usr/bin/python3 -I -c …`: mpmath values of $P_n$ at 0.3 and −0.7, the plot extents of $S_N$, and the parity test.
- I viewed the frames through the contact sheets for both GIFs and at full size for `legendrepolyaa` frame 6.

