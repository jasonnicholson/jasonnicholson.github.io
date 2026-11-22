# Bisection Method — animation review (round 2)

Page: `pages/numerical-methods/bisection-method/`. Reported findings: **0 Error, 0 Misleading, 2 Minor**.

## Findings

### F1: Page match, Minor. The introduction says the shaded bracket is "known to contain a root", which is false for Case 2
- **Location:** `index.qmd` line 13: "The shaded region marks the current bracket $[a, b]$ that is known to contain a root (by the Intermediate Value Theorem)."
- **What is there now:** this sentence introduces "each animation below". In Case 2 ($\tan x$ on $[1,2]$), the shaded bracket never contains a root. It always contains the pole $\pi/2$ instead.
- **What is true:** each bracket is known to contain a *sign change* of $f$. It contains a root only when $f$ is continuous on the bracket. Case 2 (lines 30–32) makes exactly this point and so corrects the sentence, but the general statement above it is still false as written.
- **Evidence:** a scratch check (Python, `review/`) confirms that for all 12 steps $\tan a>0>\tan b$ and $a<\pi/2<b$. The only zeros of $\tan$ near the interval are $0$ and $\pi$, and both lie outside $[1,2]$.
- **Suggested correction:** "The shaded region marks the current bracket $[a,b]$, on which $f$ changes sign; when $f$ is continuous there, the Intermediate Value Theorem guarantees it contains a root."

- **Independent check:** not run (Minor finding, unverified)

### F2: Fidelity, Minor. Both starting intervals differ from Mathews' examples and the page gives no reason
- **Location:** `index.qmd` line 19 (Case 1, $[a_0,b_0]=[1,2]$) and line 28 (Case 2, $[a_0,b_0]=[1,2]$). The same values appear in `bisectionaa.jl` line 15 and `bisectionbb.jl` line 16.
- **What is there now:** both cases start on $[1,2]$.
- **What the archive has:**
  - Example 3 (Convergence) uses $x^3+4x^2-10=0$ on $[a,b]=[-1,2]$ (`gr_647`, `gr_648`). The legacy animation `Bisectionaa.gif` shows $I_1=\{0.5,2\}$, $p_1=1.25$, $p_2=1.625$, …, and reaches $p_{20}=1.36523$.
  - Example 4 ("Not a root located") uses $\tan x=0$ on $[a,b]=[0,2]$ (`gr_813`, `gr_814`). The legacy animation `Bisectionbb.gif` shows $I_1=\{1,2\}$, $p_1=1.5$, …, $p_{12}=1.57056$, $p_{18}=1.57080$.
- **Consequences:**
  - Case 2 is Mathews' run with its first step removed. The page's $c_k$ equal Mathews' $p_k$ (page $c_{12}=1.570557$, legacy $p_{12}=1.57056$), so the behaviour is preserved. What is lost is Mathews' detail that $\tan 0=0$ is a genuine root at the left end of his interval, which bisection walks away from on its way to the pole.
  - Case 1 has the same function and the same root. Its midpoint sequence differs from Mathews' (page: 1.5, 1.25, 1.375, …; Mathews: 0.5, 1.25, 1.625, …).
  - The scripts' plot windows (`xlims = (-1.0, 2.2)` and `(0.0, 2.2)`) still match Mathews' intervals. This suggests the change was deliberate but not explained.
  - Neither change is mathematically wrong. $[1,2]$ is arguably cleaner for Case 2, because $f(0)=0$ means Mathews' $[0,2]$ has no strict sign change.
- **Suggested correction:** either use Mathews' intervals, or add one sentence per case saying the bracket differs from the source example and why. For Case 2 this could read: "Mathews starts at $[0,2]$, where $\tan 0 = 0$ is itself a root; one bisection step gives $[1,2]$, used here."

No other findings.

**Observation, not a finding (content not yet present):** the page has no `## Description` section, although the authoring conventions (`.github/agents/animation-page.agent.md`) say to always create one. As a result there are no method formulas in a Description to check against the scripts.

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `bisectionaa.jl` | 0 | 6.4 | bisectionaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `bisectionbb.jl` | 0 | 6.8 | bisectionbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `bisectionaa.gif` | 13 | byte-identical | bisectionaa |
| `bisectionbb.gif` | 13 | byte-identical | bisectionbb |

### Page references

- Scripts linked: `bisectionaa.jl`, `bisectionbb.jl`
- GIFs embedded: 2
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | l.12 | "Each animation below shows the bracket-halving diagram for the bisection method" | Both scripts run plain bisection (see §3) and draw the bracket, the midpoint and the halved bracket | confirmed |
| 2 | l.13 | "The shaded region marks the current bracket $[a,b]$" | `shade_bracket!(p1, a_cur, b_cur, …)` with `a_cur = as[frame+1]`; frames show shading between the blue dashed lines | confirmed |
| 3 | l.13 | "…that is known to contain a root (by the Intermediate Value Theorem)" | True for Case 1 (invariant $f(a)f(b)<0$ holds at all 12 steps, $f$ continuous). False for Case 2 (pole, no root) | **wrong** for Case 2 (F1) |
| 4 | l.14 | "Each frame computes the midpoint $c=\tfrac{a+b}{2}$, evaluates $f(c)$, and narrows the bracket to the half that still contains the sign change" | Code lines 30–38 (aa) and 31–39 (bb): `c=(a+b)/2`; keeps $[a,c]$ if $f(a)f(c)<0$, else $[c,b]$. Frame 0 shows only the initial bracket, which is expected | confirmed |
| 5 | l.15 | "The top panel shows the full view" | Top panel uses fixed `xlims` and `ylims` covering the whole interval in every frame | confirmed |
| 6 | l.15 | "the bottom panel zooms in on the bracket from before the current step" | `a_prev = as[max(frame,1)]`; window is that bracket ±10 %; frames show the gray "before" lines at the window edges | confirmed |
| 7 | l.15 | "…narrower than a pixel in the full view (from step 8 on)" | Measured plot area: 473 px wide in both GIFs (border columns 115 and 588). aa: 0.00677 units/px, so the bracket is 1.15 px after step 7 and 0.58 px after step 8. bb: 0.00465 units/px, so 1.68 px after step 7 and 0.84 px after step 8 | confirmed |
| 8 | l.17 | Julia source linked under each case | Links on l.24 and l.34 | confirmed |
| 9 | l.19 | Case 1 is "Convergent" | Final bracket [1.364990234375, 1.365234375] contains $x^*=1.3652300134$ | confirmed |
| 10 | l.19 | $f(x)=x^3+4x^2-10$ | `bisectionaa.jl` l.14 and the frame titles | confirmed |
| 11 | l.19 | $[a_0,b_0]=[1,2]$ | `bisectionaa.jl` l.15 and frame 1 ("Initial bracket [1.0, 2.0]") | confirmed (differs from archive, F2) |
| 12 | l.21 | $f(1)=-5<0$, $f(2)=14>0$ | Computed: −5 and 14 | confirmed |
| 13 | l.21 | "the IVT guarantees a root in $[1,2]$" | Polynomial, so continuous; sign change | confirmed |
| 14 | l.22 | "$x^*\approx 1.3652$" | mpmath `findroot`: 1.36523001341409684…; numpy roots: one real root, 1.36523001 | confirmed |
| 15 | l.22 | "The bracket width halves each step" | Widths 1, 0.5, …, 0.00048828125 (instrumented script) | confirmed |
| 16 | l.22 | "error bound $|c_k-x^*|\le(b_0-a_0)/2^k$ shrinks monotonically" | Checked for k=1..12 with $c_1=1.5$; holds at every k (tightest at k=11: 4.84e-4 ≤ 4.88e-4). The bound $2^{-k}$ is monotone | confirmed |
| 17 | l.22 | "the midpoints themselves are not monotone and fall on both sides of the root" | Signs of $c_k-x^*$: + − + − − − + − + − − − | confirmed |
| 18 | l.24 | Case 1 link → `bisectionaa.jl` | Script is the $x^3+4x^2-10$, $[1,2]$ case | confirmed |
| 19 | l.26 | Embed `bisectionaa.gif` | Committed GIF is byte-identical to a scratch regeneration of `bisectionaa.jl` (manifest) | confirmed |
| 20 | l.26 alt | "bracket narrows around the root at x≈1.3652" | Final bracket contains 1.36523 | confirmed |
| 21 | l.26 alt | "over 12 steps" | `n_iters = 12`; 13 frames (frame 0 plus 12 steps); last frame titled "step 12" | confirmed |
| 22 | l.26 alt | "with a lower panel zoomed on each halving" | Frames 2–13 show the zoom with before and after brackets | confirmed |
| 23 | l.28 | Case 2 is "Spurious convergence (cautionary)" | Converges to the pole π/2 (see #27) | confirmed |
| 24 | l.28 | $f(x)=\tan(x)$, $[a_0,b_0]=[1,2]$ | `bisectionbb.jl` l.15–16 and the frame titles | confirmed (differs from archive, F2) |
| 25 | l.30 | $\tan(1)>0$, $\tan(2)<0$ | 1.5574077, −2.1850399 | confirmed |
| 26 | l.31 | "caused by the vertical asymptote at $x=\tfrac{\pi}{2}\approx1.5708$, not a true root" | π/2 = 1.5707963; no zero of tan in [1,2] | confirmed |
| 27 | l.32 | "Bisection converges to the asymptote" | Final bracket [1.570556640625, 1.57080078125] contains π/2. $|c_{12}-\pi/2|=2.397\times10^{-4}\le2^{-12}$. π/2 lies inside the bracket at every step | confirmed |
| 28 | l.32 | "the IVT guarantee requires $f$ to be continuous on $[a,b]$" | Standard hypothesis; tan is discontinuous at π/2 ∈ [1,2] | confirmed |
| 29 | l.34 | Case 2 link → `bisectionbb.jl` | Script is the tan, $[1,2]$ case | confirmed |
| 30 | l.36 | Embed `bisectionbb.gif` | Byte-identical to the regeneration (manifest) | confirmed |
| 31 | l.36 alt | "method converges to the asymptote at π/2, not a root" | As #27 | confirmed |
| 32 | l.36 alt | "with a lower panel zoomed on each halving" | Frames 2–13 | confirmed |
| 33 | frames | Legend values `c_k` (aa: c_2=1.25, c_4=1.3125, c_6=1.359375, c_8=1.363281, c_10=1.364258, c_12=1.36499) | Independent values 1.25, 1.3125, 1.359375, 1.36328125, 1.3642578125, 1.364990234375 | confirmed |
| 34 | frames | Legend values `c_k` (bb: c_2=1.75, c_4=1.5625, c_6=1.578125, c_7=1.570312, c_8=1.574219, c_10=1.571289, c_11=1.570801, c_12=1.570557) | Independent values 1.75, 1.5625, 1.578125, 1.5703125, 1.57421875, 1.5712890625, 1.57080078125, 1.570556640625 | confirmed |
| 35 | frames | Zoom titles "step k halves [a, b] of width w" | w = width before step k: 0.5 (k=2), 0.125 (k=4), …, 0.00048828125 (k=12) | confirmed |
| 36 | frames | Titles show the function in the code | "f(x) = x³ + 4x² − 10" and "f(x) = tan(x)" | confirmed |

No Description section exists, so there are no method-formula claims to check.

---

### 3. Implementation checks

Both scripts were copied (bisection loop only, with a print loop added) to `review/inst_aa.jl` and `review/inst_bb.jl` and run with `julia`. The independent computation was a separate bisection in Python (`/usr/bin/python3`), with the reference root from mpmath and numpy.

### `bisectionaa.jl`: $x^3+4x^2-10$ on $[1,2]$, 12 steps
- **Method:** standard bisection. The midpoint is `c=(a+b)/2`. The script keeps $[a,c]$ when $f(a)f(c)<0$ and $[c,b]$ otherwise, runs a fixed 12 steps with no tolerance stop, and has no hybrid or safeguard. An exact zero $f(c)=0$ would go to the else branch, which keeps $c$ as an endpoint, so this is harmless.
- **Numbers:** the script and Python agree exactly.

  | k | script $c_k$ | independent $c_k$ | $c_k-x^*$ | bound $2^{-k}$ |
  |---|---|---|---|---|
  | 1 | 1.500000000000 | 1.5 | +1.35e-1 | 5.0e-1 |
  | 2 | 1.250000000000 | 1.25 | −1.15e-1 | 2.5e-1 |
  | 3 | 1.375000000000 | 1.375 | +9.77e-3 | 1.25e-1 |
  | 4 | 1.312500000000 | 1.3125 | −5.27e-2 | 6.25e-2 |
  | 5 | 1.343750000000 | 1.34375 | −2.15e-2 | 3.13e-2 |
  | 6 | 1.359375000000 | 1.359375 | −5.86e-3 | 1.56e-2 |
  | 7 | 1.367187500000 | 1.3671875 | +1.96e-3 | 7.81e-3 |
  | 8 | 1.363281250000 | 1.36328125 | −1.95e-3 | 3.91e-3 |
  | 9 | 1.365234375000 | 1.365234375 | +4.36e-6 | 1.95e-3 |
  | 10 | 1.364257812500 | 1.3642578125 | −9.72e-4 | 9.77e-4 |
  | 11 | 1.364746093750 | 1.36474609375 | −4.84e-4 | 4.88e-4 |
  | 12 | 1.364990234375 | 1.364990234375 | −2.40e-4 | 2.44e-4 |

  The final bracket is [1.364990234375, 1.365234375]. The invariant $f(a)f(b)<0$ holds after every step (asserted in Python).
- **Reference value:** the "True root ≈ 1.3652" in the header comment (l.3) matches $x^*=1.36523001341$ (mpmath, 30 digits). It is the only real root; the other two are $-2.6826\pm0.3583i$.
- **Picture:** I viewed frames 1, 5 and 13 and the contact sheet (frames 1, 3, 5, 7, 9, 11, 13).
  - The red dot is at $(c_k,f(c_k))$, the diamond at $(c_k,0)$, and the dotted drop line joins them. Gray dots are the earlier midpoints on the curve.
  - The blue dashed lines and shading are the post-step bracket. In the zoom, the gray dashed lines are the pre-step bracket.
  - The legend index $k$ matches the step.
  - The zoom y-range covers the curve, $f(c)$ and 0, so nothing is clamped.
  - Cosmetic only: on the side the step keeps, the gray "before" line is hidden under the blue "after" line, and the frame-0 annotation overlaps the curve slightly. Neither misleads.
  - The committed GIF is byte-identical to the regeneration (manifest).

### `bisectionbb.jl`: $\tan x$ on $[1,2]$, 12 steps
- **Method:** the same plain bisection loop as aa.
- **Numbers:** the script and Python agree exactly. The midpoints are 1.5, 1.75, 1.625, 1.5625, 1.59375, 1.578125, 1.5703125, 1.57421875, 1.572265625, 1.5712890625, 1.57080078125, 1.570556640625.
  - $f(c_k)$ from the script: +14.10, −5.52, −18.43, +120.5, −43.56, −136.4, +2067, −292.2, −680.6, −2029, −2.245e5, +4172. These grow without bound, as expected near a pole, which is the opposite of what a root would give.
  - The final bracket is [1.570556640625, 1.57080078125], and it contains π/2 = 1.5707963268.
  - The invariants $\tan a>0>\tan b$ and $a<\pi/2<b$ hold at every step (asserted in Python).
- **Reference value:** π/2 is computed as `π / 2` in the code, so it is exact to double precision.
- **Picture:** I viewed frames 8 and 12 and the contact sheet.
  - Top panel: the curve is split at π/2 ± 0.02 and clamped to ±15. Midpoints with $|f(c)|>15$ (steps 4, 6, 7 and later) are drawn on the top or bottom border, and their legend gives only $c_k$, not $f(c_k)$.
  - Bottom panel: the zoom uses a y-range of ±1.1·max|f| over the window ends and the midpoint, so the midpoint is drawn at its true value (for example +2.07e3 at step 7 and −2.24e5 at step 11).
  - I judge the top-panel clamping to be an acceptable readability device and not a finding. The marker sits visibly on the frame edge, no clamped value is printed, and the zoom directly below shows the true value.
  - The orange asymptote line appears in both panels at π/2.
  - The committed GIF is byte-identical to the regeneration.

### What I did not check
- I did not check the rendered HTML of the page; I reviewed only the `.qmd` source.
- I did not view every individual frame at full size; the unviewed ones I saw only on the contact sheets. Because both GIFs regenerate byte-identically from the scripts, the plotting code determines every frame.

