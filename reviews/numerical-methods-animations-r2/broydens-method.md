# Broyden's Method — animation review (round 2)

Page: `pages/numerical-methods/broydens-method/`. Reported findings: **0 Error, 1 Misleading, 1 Minor**.

## Findings

### F1. Page match, **Misleading**: the frames cannot show the Broyden steps or the superlinear convergence that the text and alt text attribute to them

**Location**
- `index.qmd` line 68: "Each frame adds the next iterate $\mathbf{X}^{(k)}$, connected by a line so the path toward the root is visible."
- Line 74, Case A Behavior: "...the subsequent Broyden quasi-Newton updates converge superlinearly."
- Alt text, line 78: "iterates converge superlinearly to the root near (-0.088, 0.827)".
- Alt text, line 86: "iterates converge superlinearly to the root near (2.808, -1.664)".
- Plotting code: `broydenaa.jl` / `broydenbb.jl` lines 26–27 (fixed window x∈[-1,3.5], y∈[-2.5,2]) and line 102 (legend rounded to 4 decimals).

**What is there now.** The only movement visible in either GIF is the first, exact-Newton step X_0→X_1. Every Broyden step after that is below about one pixel, so the remaining frames look the same. The legend coordinates are rounded to 4 decimals, so they stop changing as well:
- Case A: the legend reads (-0.0881, 0.8271) for X_3, X_4, X_5 and X_6. Frames 4–7 are 4 of 7 frames with the same picture and the same numbers.
- Case B: the legend reads (2.8085, -1.6645) for X_4, X_5, X_6 and X_7. Frames 5–8 are 4 of 8 frames with the same picture and the same numbers.

Pixel diffs between consecutive committed frames confirm this. In Case A, frames 5→6 and 6→7 differ in only 55 and 53 pixels, all inside bbox x 437–443, y 56–65. That box is the subscript digit "X_k" in the legend. Case B frames 6→7 and 7→8 show the same pattern (53 and 59 pixels, same bbox). Step lengths at the GIF's scale (about 111 px per unit across the full 500 px canvas, and fewer inside the plot area):
- Case A: 20.7, 0.86, 0.03, 0.00, 0.00, 0.00 px
- Case B: 41.4, 2.9, 0.32, 0.06, 0.00, 0.00, 0.00 px

A viewer therefore sees one Newton jump followed by a picture that stays frozen for 4 frames. The Broyden updates, which are the subject of the page, are invisible. The superlinear rate also cannot be read from the frames, because neither an error nor a residual is displayed and the legend digits saturate. The claim of superlinear convergence is true of the computed sequence (see Part 3), but the animation the alt text describes does not show it. The line-68 sentence "the path toward the root is visible" is false from frame 3 on.

**How I know.** The committed frames were compared pixel by pixel (Python/PIL diff over `committed/<gif>/frame_*.png`). Step lengths and errors come from my independent run (`caseB.py`). The legend values are `round(·, digits=4)` of the iterates the instrumented scripts printed (Part 3).

**Suggested correction.** Choose one of these:
- (a) Add a second panel or inset to each GIF plotting log10‖X_k − X*‖, or log10‖F(X_k)‖, against k. This is where superlinear convergence becomes visible: the Case A residuals are 1.4, 5.4e-2, 1.6e-3, 1.3e-4, 1.3e-5, 2.4e-9, 6.9e-13.
- (b) Show ‖F(X_k)‖ in scientific notation in the legend, and/or more digits.
- (c) Add zoomed frames around the root after X_1.

Otherwise, reword line 68 and the two alt texts so they no longer claim the frames show the path or the rate. For example: "after the first (Newton) step the iterates are too close to the root to separate at this scale; the legend gives their coordinates."

- **Independent check:** confirmed with correction: the Broyden steps are invisible in the plot and the last 4 frames of each GIF are frozen, so superlinear convergence cannot be read from the animation; but the legend digits do change for the early Broyden steps (Case A: X1→X3; Case B: X1→X4), so that progress is visible as text, not motion. Minor: the canvas is 600×500 px (133 px/unit horizontally).

### F2. Fidelity, **Minor**: the example system is not Mathews' system, and the page gives no reason

**Location.** `index.qmd` line 66, and the header and `F` definition in both scripts (lines 3–4 and 13–14):
$f_1 = 1 - 4x + 2x^2 - 2y^2$, $f_2 = -4 + x^2 + 4y + y^2$.

**What the archive has.** The Mathews module uses one system throughout: Examples 1, 3 and 5 and the Broyden worked example. Images `BroydenMethodMod_gr_14.gif`, `gr_89.gif` and `gr_213.gif` were viewed upscaled, and all three show the same system:
$f_1 = 1 - 4x + 2x^2 - 2y^3$, $f_2 = -4 + x^4 + 4y + 4y^4$.

Mathews' Example 5 (lnk_7) has two parts, (i) and (ii), each "near" a starting point. I computed (`mathews_sys.py`, sympy resultant) that this system has exactly two real solutions, near (0.061770, 0.724491) and (1.556097, -0.575651). That is consistent with the two-part example. The page swaps in a different, lower-degree system with four real roots and does not say so. Its two cases are not Mathews' two cases.

**Could not determine:** Mathews' actual starting vectors for Example 5. The lnk_7 page references 29 images, and only the system image (gr_213) is present in `Images/`. The starting points, results and graph images are missing.

The page's own system is internally consistent and correctly solved, so this does not make anything on the page false.

**Suggested correction.** Either use Mathews' system with one case near each of its two real roots, or add one sentence saying the system is a simplified variant of Mathews' Example 5 and why it was chosen. The agent conventions (`animation-page.agent.md` line 72) also ask for a short note in the page text when archive images are missing.

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `broydenaa.jl` | 0 | 6.8 | broydenaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `broydenbb.jl` | 0 | 7.4 | broydenbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `broydenaa.gif` | 7 | byte-identical | broydenaa |
| `broydenbb.gif` | 8 | byte-identical | broydenbb |

### Page references

- Scripts linked: `broydenaa.jl`, `broydenbb.jl`
- GIFs embedded: 2
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Page text (own words) | Location | Evidence | Verdict |
|---|---|---|---|---|
| 1 | Newton's method requires "all $n^2$ partial derivatives" of the Jacobian each iteration | l.12, l.20 | Definition of the Jacobian | confirmed |
| 2 | Newton step $J\Delta X = -F$, $X^{k+1}=X^k+\Delta X$ | l.18 | Standard | confirmed |
| 3 | Newton converges quadratically near a simple root | l.20 | Standard. My Newton run from (0,1) gives errors 7.9e-3, 1.1e-5, 4.4e-11 | confirmed |
| 4 | Central-difference $M_{ij}$ formula; "$2n^2$ additional function evaluations per iteration" | l.26–28 | 2n vector evaluations × n components = 2n² scalar evaluations | confirmed (counting scalar component evaluations) |
| 5 | Secant condition $B_{k+1}s_k=y_k$ with $s_k$, $y_k$ as defined | l.34–36 | Numerical check: ‖B_{k+1}s−y‖ ≤ 2.2e-16 at every step, both cases | confirmed |
| 6 | Broyden update $B_{k+1}=B_k+(y-B s)s^T/(s^Ts)$ is the Frobenius-closest matrix satisfying the secant condition, and the correction is rank 1 | l.38–42 | Numerical: rank(B_{k+1}−B_k)=1, and (B_{k+1}−B_k)v=0 for v⊥s (≤1.5e-16). Least-change property is standard | confirmed |
| 7 | Update costs O(n²) arithmetic and no extra function evaluations beyond F(X^{k+1}) | l.42 | Outer product; the script evaluates F once per iteration (l.46) | confirmed |
| 8 | Algorithm: Step 0 uses the exact Jacobian $B_0=J(X^{(0)})$ and one Newton step; then evaluate F, update B, solve $B_k\Delta X=-F$, update X | l.46–56 | Script l.40–61 does exactly this, with the same indexing | confirmed |
| 9 | Broyden converges superlinearly near a simple root, slower than quadratic | l.60 | Standard (Broyden–Dennis–Moré). Computed error ratios → 0 (Part 3) | confirmed |
| 10 | System $f_1 = 1-4x+2x^2-2y^2$, $f_2=-4+x^2+4y+y^2$ | l.66 | Matches script l.3–4, l.13–14, and the contour arrays l.74–75 | confirmed (but see F2 for archive fidelity) |
| 11 | Blue curve is $f_1=0$, red curve is $f_2=0$ | l.68 | Script l.85–88. Frames show a blue hyperbola $(x-1)^2-y^2=1/2$ (vertices x≈0.293, 1.707) and a red circle $x^2+(y+2)^2=8$ (top at (0, 0.828)) | confirmed |
| 12 | The system has four real solutions | l.68 | sympy resultant $16x^4-32x^3-104x^2+184x+17$ has 4 real roots, each giving one real intersection: (-2.4632,-3.3902), (-0.0881,0.8271), (1.7429,0.2277), (2.8085,-1.6645) | confirmed |
| 13 | Three solutions near (-0.088, 0.827), (1.743, 0.228), (2.808, -1.664) | l.68 | True values (-0.0881260, 0.8270539), (1.7428519, 0.2276596), (2.8084571, -1.6644870) | confirmed |
| 14 | Those three lie inside the plotted window (the fourth does not) | l.68 | Window x∈[-1,3.5], y∈[-2.5,2]. The fourth root (-2.463,-3.390) is outside | confirmed |
| 15 | "Each frame adds the next iterate X^(k), connected by a line" | l.68 | Code l.91–102 adds one iterate per frame and connects them with a line | confirmed (mechanically) |
| 16 | "...so the path toward the root is visible" | l.68 | Steps after X_1 are ≤0.86 px (A) and ≤2.9 px (B) | **wrong** from frame 3 on (F1) |
| 17 | Case A heading: X^(0)=(0,1), root ≈ (-0.088, 0.827) | l.72 | Script l.23 (0.0, 1.0). Converges to (-0.088125989949, 0.827053909973) | confirmed |
| 18 | Case A starts near the upper-left intersection | l.74 | Distance 0.194 from that root. It is the upper-left of the three visible roots | confirmed |
| 19 | Case A: the initial exact Newton step lands close to the root | l.74 | X_1 = (-0.083333, 0.833333), error 7.9e-3 (from 0.194). Hand check: J(0,1)=[[-4,-4],[0,6]], F=(-1,1), giving Δ=(-1/12,-1/6) | confirmed |
| 20 | Case A: subsequent Broyden updates converge superlinearly | l.74 | Errors 7.9e-3, 2.6e-4, 2.9e-5, 2.9e-6, 5.1e-10, 1.5e-13. Ratios 0.033, 0.11, 0.10, 1.8e-4, 3e-4 → 0 | confirmed of the computation. Not visible in the GIF (F1) |
| 21 | Case A: Jacobian updated by rank-1 formula without new derivative evaluations | l.74 | Script l.56. `Jac` is called only at l.40 | confirmed |
| 22 | Case A link `broydenaa.jl` and embed `broydenaa.gif` are this case | l.76, 78 | Script x0=(0,1), title "solution near (-0.088, 0.827)", writes broydenaa.gif. GIF frame 1 legend X_0 = (0.0, 1.0) | confirmed |
| 23 | Case A alt text: start (0,1), converges superlinearly to root near (-0.088,0.827), f1 blue / f2 red | l.78 | As rows 11, 17, 20 | parameters confirmed. "converge superlinearly" as a description of the animation is not shown (F1) |
| 24 | Case B heading: X^(0)=(2.5,-1.5), root ≈ (2.808, -1.664) | l.80 | Script l.23 (2.5, -1.5). Converges to (2.808457052195, -1.664486980915) | confirmed |
| 25 | Case B starts near the lower-right intersection and converges to that solution | l.82 | Distance 0.350. Final iterate equals that root to 4e-14 | confirmed |
| 26 | Case B: method is starting-point dependent; a different initial guess finds a different root | l.82 | A and B reach different roots | confirmed |
| 27 | Case B link `broydenbb.jl` and embed `broydenbb.gif` are this case | l.84, 86 | Script x0=(2.5,-1.5), title "solution near (2.808, -1.664)", writes broydenbb.gif. Frame 1 legend X_0 = (2.5, -1.5) | confirmed |
| 28 | Case B alt text: converges superlinearly to (2.808, -1.664) | l.86 | Errors 2.5e-2, 2.5e-3, 5.1e-4, 2.2e-5, 8.6e-8, 3.2e-11, 4.3e-14. Ratios 0.099, 0.21, 0.043, 3.9e-3, 3.8e-4 → 0 | confirmed of the computation. Not visible in the GIF (F1) |
| 29 | GIF titles match the page roots | frames | Titles "solution near (-0.088, 0.827)" and "solution near (2.808, -1.664)" | confirmed |
| 30 | Frame counts (implicit: one iterate per frame) | — | A: 7 iterates X_0..X_6, 7 frames. B: 8 iterates X_0..X_7, 8 frames | confirmed |
| 31 | Source inspiration: Mathews | l.8 | The archive's system differs | see F2 |

---

### 3. Implementation checks

Both scripts are identical except for the start point, title and output name (`diff` shows only lines 1–6, 23, 29, 105–106).

### `broydenaa.jl`

**It is the method it claims to be.** This is Broyden's "good" method (Broyden's first method, direct update of B, not of B⁻¹). B_0 is the exact Jacobian and gives one Newton step (l.40–42). After that, each iteration evaluates F once, applies the rank-1 update B += (y − Bs)sᵀ/(sᵀs), and solves B ΔX = −F (l.45–61). This is exactly the algorithm on page l.46–56 and in Mathews' `Broyden` subroutine (`gr_211.gif`, which uses the same Step 0 and the same update). There are no hidden safeguards. The stopping rules are ‖F‖<1e-12 or sᵀs<1e-20, with a cap of 10 Broyden iterations.

**Jacobian.** Finite-difference check at 3 random points: max |FD − J| ≤ 3.5e-10. The code's [-4+4x, -4y; 2x, 4+2y] equals the sympy Jacobian.

**The numbers are right.** For the instrumented copy (`broydenaa_instr.jl`, plotting removed, prints iterates) set beside my independent numpy implementation (`indep.py`), all 12 printed digits agree at every k:

| k | script | independent | ‖F‖ |
|---|---|---|---|
| 0 | (0.000000000000, 1.000000000000) | same | 1.414 |
| 1 | (-0.083333333333, 0.833333333333) | same (hand: (-1/12, 5/6)) | 5.42e-2 |
| 2 | (-0.088150289017, 0.827312138728) | same | 1.65e-3 |
| 3 | (-0.088097247459, 0.827056434024) | same | 1.34e-4 |
| 4 | (-0.088128867770, 0.827053714599) | same | 1.32e-5 |
| 5 | (-0.088125990459, 0.827053909924) | same | 2.39e-9 |
| 6 | (-0.088125989949, 0.827053909973) | same | 6.94e-13 |

Property checks: the secant condition holds to ≤1.1e-16 at every update; the update is rank 1 and acts as zero on s⊥. Errors against the 40-digit mpmath root shrink superlinearly (ratios 0.041, 0.033, 0.11, 0.10, 1.8e-4, 3e-4). For comparison, Newton from the same start takes 3 steps to reach 4e-11. Broyden takes 5 to reach 5e-10, consistent with "slower than Newton".

**Reference values.** The root (-0.088126, 0.827054) quoted in the title, header comment and page was checked against mpmath `findroot` at 40 digits, (-0.0881259899488592, 0.8270539099733372), and against a sympy resultant root. It is correct to the 3 decimals quoted.

**The picture shows what was computed.**
- Contours are built from the same f1, f2 on a 400×400 grid, with the arrays indexed [y, x] as Plots expects. The frames show the correct hyperbola and circle (row 11).
- The iterate path, the previous-iterate markers and the current red marker use `iterates[1:frame+1]`. The legend index `X_$(frame)` matches the iterate index.
- The title matches the code's root.
- The legend entries `f₁(x,y) = 0` / `f₂(x,y) = 0` requested at l.86/88 do not render; the GR backend drops contour labels. The page text supplies the colour key, so this is not a finding.
- There is no clamping or masking.
- The axis window and 4-decimal legend make every step after X_1 invisible. See F1.

### `broydenbb.jl`

**Method.** This is the same code as broydenaa; see above.

**The numbers are right.** For the instrumented copy against `indep.py`, all 12 printed digits agree at every k:

| k | script = independent | ‖F‖ | error to root |
|---|---|---|---|
| 0 | (2.500000000000, -1.500000000000) | 1.80 | 3.50e-1 |
| 1 | (2.833333333333, -1.666666666667) | 2.17e-1 | 2.50e-2 |
| 2 | (2.807291666667, -1.666666666667) | 2.43e-2 | 2.47e-3 |
| 3 | (2.808315742840, -1.663995517682) | 2.30e-3 | 5.11e-4 |
| 4 | (2.808461459893, -1.664508433441) | 1.11e-4 | 2.19e-5 |
| 5 | (2.808457068862, -1.664487064758) | 4.39e-7 | 8.55e-8 |
| 6 | (2.808457052202, -1.664486980946) | 1.60e-10 | 3.22e-11 |
| 7 | (2.808457052195, -1.664486980915) | 2.16e-13 | 4.29e-14 |

The secant condition holds to ≤2.2e-16, and the updates are rank 1. Error ratios are 0.071, 0.099, 0.21, 0.043, 3.9e-3, 3.8e-4, which is superlinear. Newton from the same start takes 4 steps to reach machine precision; Broyden takes 7.

**Reference values.** The root (2.808, -1.664) was checked against mpmath (2.808457052195061, -1.664486980914554). It is correct to 3 decimals.

**Picture.** The construction is the same as Case A and correct. The step X_0→X_1 is the only visible segment. X_1 overshoots the root by 0.025 (about 2–3 px), which cannot be seen. The legend reads (2.8085, -1.6645) from X_4 to X_7. See F1.

### Legacy archive notes

- `BroydenMethodMod.html` covers Newton (Example 1), Pseudo-Newton (Example 3) and Broyden (Example 5) on the system in F2, plus 3D and 4D exercises.
- Mathews' `Broyden` subroutine (`gr_211.gif`) matches the scripts' algorithm: exact A_0, one Newton step, then A_1 = A_0 + (Y − A_0 S)Sᵀ/d with d = S·S.
- The Example 5 solution images (starting points, iterates and graphs) are missing from the archive, so Mathews' starting points could not be determined.

