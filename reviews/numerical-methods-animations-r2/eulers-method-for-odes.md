# Euler's Method for ODE's — animation review (round 2)

Page: `pages/numerical-methods/eulers-method-for-odes/`. Reported findings: **0 Error, 2 Misleading, 0 Minor**.

## Findings

### F1 — Fidelity, Misleading: Mathews' "Modified Euler" is the midpoint method, but the page runs Heun and says it reconstructed Example 12

**Where:**
- `index.qmd` lines 34–36: "these are reconstructed from the module's worked-example equations and parameters (Examples 11-12)".
- Line 54, case heading: "Case 2 - Modified Euler (Heun), same IVP and grid".
- Lines 21–23 (Description): "The modified Euler (Heun) predictor-corrector method averages endpoint slopes".
- `eulersmethodbb.jl` lines 42–47: a trapezoidal predictor-corrector (Heun).

**What the page says:** Case 2 reconstructs the module's Modified Euler example (Example 12), and Modified Euler is Heun.

**What is true:** In this legacy module, "Modified Euler" is the **explicit midpoint method**, not Heun. Three pieces of archive evidence show this:
- **The module's own algorithm** (`Euler'sMethodMod_gr_42.gif`, the Mathematica `MEuler` subroutine): `Y[[j+1]] = Y[[j]] + h f[T[[j]] + h/2, Y[[j]] + h/2 f[T[[j]], Y[[j]]]]`.
- **Example 12's printed n = 40 table** (`Euler'sMethodMod_gr_255.gif`) ends at y(5) = 0.0761463. My midpoint implementation reproduces it exactly: `0.076146277`, with t = 1 → 1.44193, t = 2 → 0.858479, t = 3 → 0.0913999 and t = 4 → 0.0189838, all matching the table. Heun at n = 40 gives 0.250635 instead.
- **The legacy animation `MEuleraa.gif`** ("Modified Euler Method") annotates y(5) for m = 12, 14, 18, 20, 28, 32, 44, 56, 80, 120 as 0.1958729, 0.1846256, 0.9529541, 0.8146072, 0.3841123, 0.1347559, 0.0628993, 0.0365908, 0.008372, 0.0081251. My midpoint method reproduces all ten to 7 digits. My Heun does not: it gives 1.3861201, 1.1345801, 0.8097869, … for the same m.

Mathews treats Heun's method in a separate module (`n2003/Heun'sMethodMod.html`, "uses Euler's method as a predictor and then correcting the predictor").

The page's Heun implementation is a correct, legitimate method, and the page describes it consistently with itself. The problem is fidelity: the page tells the reader that Case 2 reconstructs the module's Modified Euler example, but it implements a different second-order method. Some page numbers therefore disagree with the module's Example 12. At n = 40 the page says Modified Euler "end[s] at y(5)≈0.251, about 31 times the exact value", while the module's Modified Euler gives 0.0761 there, about 9.4 times the exact value.

**How I know:**
```
python3 (midpoint, f = 1 - t*sign(y)*|y|^(1/3)), m = 12..120  -> 0.1958729 0.1846256 0.9529541 0.8146072 0.3841123 0.1347559 0.0628993 0.0365908 0.0083720 0.0081251
python3 (Heun), m = 12..120                                    -> 1.3861201 1.1345801 0.8097869 0.7006200 0.4339377 0.3555663 0.2139159 0.1400866 0.0088075 0.0081306
python3 midpoint n=40: y(5) = 0.076146277 ; n=200: y(5) = 0.008120604, max|err| = 8.66e-5
```

**Suggested correction:** choose one of the following.
- **(a) Follow the module.** Change the update in `eulersmethodbb.jl` to the midpoint form, `ys[i+1] = ys[i] + h*f(ts[i] + h/2, ys[i] + (h/2)*f(ts[i], ys[i]))`. Then:
  - Retitle Case 2 and the GIF title "Modified Euler (midpoint)".
  - Rewrite the Description sentence to say it evaluates the slope at the midpoint of the step.
  - Update the Case 2 numbers. At h = 0.025: y(5) ≈ 0.0081206, max deviation from the reference 8.7e-5. At n = 40: y(5) ≈ 0.0761, max error 0.068. The stability statement is unchanged, because the midpoint method and Heun share the stability polynomial 1 + z + z²/2.
- **(b) Keep Heun.** State explicitly that Mathews' module uses the midpoint form under the name "Modified Euler", and that this case shows Heun's trapezoidal predictor-corrector instead. Also remove "Examples 11-12" as the claimed source of Case 2.

- **Independent check:** confirmed (checker reproduced Mathews' MEuler as the explicit midpoint method from the archive)

### F2 — Fidelity, Misleading: the legacy animations exist and show a step-refinement sweep, but the page says they are missing and animates a single fine step

**Where:** `index.qmd` lines 34–36: "Legacy archive note: the original `Euleraa.gif` and `MEuleraa.gif` files were missing from the recovered animation folders, so these are reconstructed …". Also the overall design of both animations (lines 27–32).

**What the page says:** the original GIFs are missing, and the page animates a single trajectory at h = 0.025 being built five steps per frame.

**What is true:** both files are present in the archive:
- `a2001/Animations/OrdinaryDE/Euler1/Euleraa.gif`: 30 frames.
- `a2001/Animations/OrdinaryDE/MEuler1/MEuleraa.gif`: 32 frames.

Each is a **refinement sweep over the number of subintervals**, and each frame annotates the computed y(5):
- **Euler:** m = 10, 15, 25, 30, 40, 50, 70, 100, 130.
- **Modified Euler:** m = 12 to 120.

The sweep's teaching point is the zig-zag blow-up on coarse grids and the convergence as m grows. In the page's animations that point is absent: both GIFs show only the well-behaved h = 0.025 run, and the coarse-grid instability appears only in the prose of the Behavior paragraphs. The prose is numerically correct (see the ledger).

I re-verified the legacy Euler annotations independently, and all 9 match my Euler to 7 digits: 1.7774834, 1.0252058, 0.5522923, 0.3907263, −0.0174406, 0.0080988, 0.0081163, 0.0081174, 0.0081179. So the legacy animation is mathematically sound and was a usable reference.

I could not determine whether the GIFs were absent from the archive at the moment the page was first written. Their mtime is 2026-04-28 and the page's first commit is 2026-05-01. Against the archive as it stands, the note is false, and the departure it justifies drops the archive's animation subject.

**How I know:** `ls -la .../a2001/Animations/OrdinaryDE/{Euler1,MEuler1}/`; `julia giftools.jl <legacy gif> review/legacy_euler` (and the same for `legacy_meuler`); contact sheets viewed; the Python reproduction of the y(5) annotations described above.

**Suggested correction:** delete or correct the "missing" note. Then either add an animation per method that sweeps m as the legacy GIFs do, or keep the current animations and state that the legacy animations sweep the step count and that the page instead shows a single fine-grid run, with the coarse-grid behaviour described in the text.

---

- **Independent check:** confirmed (both legacy GIFs are present in the archive)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `eulersmethodaa.jl` | 0 | 8.0 | eulersmethodaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `eulersmethodbb.jl` | 0 | 8.3 | eulersmethodbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `eulersmethodaa.gif` | 41 | byte-identical | eulersmethodaa |
| `eulersmethodbb.gif` | 41 | byte-identical | eulersmethodbb |

### Page references

- Scripts linked: `eulersmethodaa.jl`, `eulersmethodbb.jl`
- GIFs embedded: 2
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Location | Claim (page wording) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | Description l.17 | $y_{n+1}=y_n+h f(t_n,y_n)$, $t_{n+1}=t_n+h$ | `eulersmethodaa.jl` l.42–44 is exactly this; Python reimplementation matches Julia to 5.6e-17 | confirmed |
| 2 | Description l.20–21 | local truncation error $O(h^2)$, global $O(h)$, "reducing the step size improves accuracy linearly" | max global error at n = 200/400/800/1600: 1.681e-2, 8.378e-3, 4.181e-3, 2.089e-3; ratios 2.007, 2.004, 2.002 | confirmed |
| 3 | Description l.21–23 | modified Euler (Heun) predictor-corrector "averages endpoint slopes", global $O(h^2)$ | `eulersmethodbb.jl` l.43–46 averages k1 at $(t_n,y_n)$ and k2 at $(t_{n+1},y^{pred})$; error ratios 4.180, 4.087, 4.043 | confirmed for Heun. That Mathews' "modified Euler" is Heun is wrong: see F1 |
| 4 | Animations l.27–28 | IVP $y'=1-t\sqrt[3]{y}$, $y(0)=1$, $0\le t\le5$ | Both scripts l.8, 29–30, 39 | confirmed |
| 5 | l.28 | $n=200$ steps, $h=0.025$ | Both scripts l.31, 34 | confirmed |
| 6 | l.29 | "Each frame adds five steps (0.125 in $t$)" | `stride = 5`, h = 0.025; frames at indices 1, 6, …, 201 (41 frames, committed GIFs have 41 frames); frame 15 marker is y_70 at t = 1.75 | confirmed |
| 7 | l.29–30 | "the connecting curve passes through every computed point" | `plot!(ts[1:frame], ys[1:frame])` plots all points | confirmed |
| 8 | l.31–32 | dashed black curve = "high-accuracy reference … fixed-step RK4 at $h=10^{-4}$" | `rk4_reference` is classical RK4 with h = 1e-4 (50000 steps, consistent grid); differs from DOP853 (rtol 1e-13) by at most 9.4e-13; dashed black line with that label in the frames | confirmed |
| 9 | l.34–36 | original GIFs missing; reconstructed from Examples 11–12 | GIFs present in archive; Example 12 is the midpoint method | wrong (F1, F2) |
| 10 | Case 1 heading l.38 | Forward Euler, same IVP, $n=200$, $h=0.025$ | `eulersmethodaa.jl`; GIF title "Euler Method, h = 0.025: y' = 1 - t*cbrt(y), y(0)=1" | confirmed |
| 11 | l.40 | Euler "runs above the dashed RK4 reference until $t=2.9$" | e > 0 at every grid point up to t = 2.900; sign change between 2.900 and 2.925 | confirmed |
| 12 | l.41 | "by at most $0.017$ near $t=1.7$" | max e = 0.016814 at t = 1.675 | confirmed |
| 13 | l.41 | "after that it lies just below, by less than $0.002$" | all e < 0 for t > 2.925; min e = −0.0018723 at t = 3.125 | confirmed |
| 14 | l.42 | "ends at $y(5)\approx0.0081186$ against the exact $0.0081199$" | Julia 0.008118629840; Python 0.00811862984; DOP853 0.00811992046487; mpmath odefun 0.00811992046486796 | confirmed |
| 15 | l.42–43 | "For steps longer than about $h=0.0485$, $h\|\partial f/\partial y\|$ exceeds … 2 before $t=5$" | $\|f_y\|$ along the exact solution is increasing and reaches its max at t = 5; 2/41.2554 = 0.04848 | confirmed |
| 16 | l.44 | "$\partial f/\partial y=-t/(3y^{2/3})$ reaches $-41.3$ at $t=5$" | correct derivative; −41.2554 at t = 5 | confirmed |
| 17 | l.45–46 | "just above $h=0.0485$ this affects only the last steps" | Euler n = 103 (h = 0.04854): y(5) = 0.0081174, max error 0.033 (at the hump, not a blow-up); n = 100: y(5) = 0.0081174 | confirmed |
| 18 | l.46 | at the legacy module's $h=0.125$ ($n=40$) | Example 11 Mathematica code (`gr_229`): `n = 40` on [0, 5] | confirmed |
| 19 | l.46 | instability "starts at $t\approx3.68$" | $0.125\|f_y\| > 2$ first at t = 3.6805 | confirmed |
| 20 | l.47 | "computed values zig-zag after $t=4.25$" | n = 40 values: 4.25: 0.012943, 4.375: 0.013212 (up), 4.5: 0.008929 (down), 4.625: 0.017233 (up), 4.75: −0.007095, 4.875: 0.231996, 5: −0.017441 | confirmed |
| 21 | l.47 | "jump to $0.232$ at $t=4.875$" | 0.231996; also matches archive table `gr_233` | confirmed |
| 22 | l.48 | "end at $y(5)\approx-0.0174$, although the exact solution stays positive" | −0.0174406; minimum of the exact solution on [0, 5] is 0.00811992 > 0 | confirmed |
| 23 | l.50 | Case 1 link → `eulersmethodaa.jl` | file exists, is the Euler script | confirmed |
| 24 | l.52 alt | "magenta trace builds five steps per frame" | magenta line, stride 5 | confirmed |
| 25 | l.52 alt | "runs slightly above the dashed RK4 reference over the hump" | e > 0 on (0, 2.9], max 0.017; visible gap in frame 15 | confirmed |
| 26 | l.52 alt | "peak about 1.46 near t = 0.9" | Euler max 1.46151 at t = 0.900 | confirmed |
| 27 | l.52 alt | "follows it down to y ≈ 0.0081 at t = 5" | 0.0081186; last frame shows trace on the reference | confirmed |
| 28 | l.52 | embed → `eulersmethodaa.gif` | committed GIF byte-identical to regen of `eulersmethodaa.jl` (manifest) | confirmed |
| 29 | Case 2 heading l.54 | "Modified Euler (Heun), same IVP and grid" | `eulersmethodbb.jl` is Heun, n = 200; GIF title "Modified Euler, h = 0.025: …" | confirmed as Heun; naming vs legacy: see F1 |
| 30 | l.56–57 | Heun stays "within $1.8\times10^{-4}$ of the dashed RK4 reference" | max\|y − RK4 ref\| = 1.7838e-4 (at t = 3.075) | confirmed |
| 31 | l.57–58 | "against $0.017$ for forward Euler on the same grid" | 0.016814 | confirmed |
| 32 | l.58 | Heun "ends at $y(5)\approx0.0081213$" | Julia 0.00812127828; Python 0.008121278284 | confirmed |
| 33 | l.58–59 | "Heun has the same stability limit as Euler, $h\|\partial f/\partial y\|<2$" | the stability polynomial $1+z+z^2/2$ has $\|\cdot\|\le1$ on the real axis exactly for $z\in[-2,0]$ | confirmed |
| 34 | l.59–60 | at $h=0.125$, errors amplified "from $t\approx3.68$" | same threshold as #19 | confirmed |
| 35 | l.60–61 | "stays within $0.0071$ of the reference up to $t=3.875$" | Heun n = 40: max\|err\| for t ≤ 3.875 is 0.00708 (at t = 3.25) | confirmed |
| 36 | l.61 | "then its values turn upward" | Heun n = 40 values reach their minimum at t = 3.875 (0.024152), then 0.02688, 0.04395, 0.1404, … | confirmed |
| 37 | l.61–62 | "end at $y(5)\approx0.251$, about 31 times the exact value" | 0.250635; 0.250635/0.00811992 = 30.87 | confirmed (for Heun; the module's Modified Euler gives 0.0761: see F1) |
| 38 | l.64 | Case 2 link → `eulersmethodbb.jl` | file exists, is the Heun script | confirmed |
| 39 | l.66 alt | "lies on the dashed RK4 reference throughout" | max deviation 1.8e-4, under one pixel at this y-scale (≈ 0.0045 per pixel); frame 41 shows the trace covering the reference | confirmed |
| 40 | l.66 alt | "rising to about 1.45 near t = 0.9" | Heun max 1.44970 at t = 0.875 | confirmed |
| 41 | l.66 alt | "falling to y ≈ 0.0081 at t = 5" | 0.0081213 | confirmed |
| 42 | l.66 | embed → `eulersmethodbb.gif` | byte-identical to regen of `eulersmethodbb.jl` (manifest) | confirmed |
| 43 | Counts | two cases, two scripts, two GIFs | manifest: 2 scripts, 2 GIFs, both linked and embedded | confirmed |

The legacy-inventory stub (lines 80–100) and the placeholder sections were excluded, as instructed.

---

### 3. Implementation checks

### `eulersmethodaa.jl` (forward Euler)

- **Is the method it claims to be:** yes. Line 43 is `ys[i+1] = ys[i] + h*f(ts[i], ys[i])`, the explicit forward Euler step. `cbrt` is the real cube root, so it equals Mathews' `Sign[y] Abs[y]^(1/3)`; y stays positive at h = 0.025 in any case.
- **Numbers are right:** the instrumented copy wrote all 201 values. My independent Python Euler differs from them by at most 5.55e-17. y(5): script 0.008118629840021034, mine 0.00811862984. The first-order property holds: error ratios under step halving are 2.007, 2.004 and 2.002.
- **Reference is right:** the RK4 reference at h = 1e-4 has y(5) = 0.008119920464867961. DOP853 (rtol 1e-13) gives 0.00811992046487 and mpmath `odefun` (30 digits) gives 0.00811992046486796. The maximum difference from DOP853 at the sampled points is 9.4e-13. The finite-difference ODE residual of the DOP853 dense solution is 6e-9, and the initial condition is y(0) = 1. The reference is far more accurate than the 1e-3-scale comparisons it supports.
- **Picture shows what was computed:** I viewed the contact sheet (frames 1, 5, 9, …, 41) and frame 15 in full.
  - Each frame draws `ts[1:frame]` and `ys[1:frame]`. The red marker is at `(ts[frame], ys[frame])` with label `y_(frame-1)`: y_0 in frame 1, y_70 at t = 1.75 in frame 15, y_200 at t = 5 in frame 41, so the indices are correct.
  - The title states the right h and f.
  - The limits (−0.1, 1.55) × (−0.1, 5.1) contain the whole trajectory (min 0.0081, max 1.4615), so nothing is clamped.
  - The above-the-reference gap over the hump is visible, matching the 0.017 maximum.
  - The committed GIF is byte-identical to the regenerated one.

### `eulersmethodbb.jl` (Heun)

- **Is the method it claims to be:** the code is Heun's method, the trapezoidal predictor-corrector with an Euler predictor and a single correction (lines 43–46). It is labelled "Modified Euler". That is a common name for Heun in many texts, but it is not this module's Modified Euler, which is the midpoint method (F1).
- **Numbers are right:** my Python Heun matches the script's 201 values to 2.2e-16. y(5): script 0.00812127828435098, mine 0.008121278284. The second-order property holds: error ratios are 4.180, 4.087 and 4.043.
- **Reference is right:** it is the same reference as in the first script; see above.
- **Picture shows what was computed:** contact sheet and frame 41 viewed. The marker labels y_0 … y_200 are correct, the title matches the code, and nothing is clipped (max 1.4497). The trace sits on the reference at plotting resolution, as the 1.8e-4 maximum deviation implies. The committed GIF is byte-identical to the regenerated one.

### Coarse-grid claims in the prose (no script; checked independently)

| Quantity | Page | Independent |
|---|---|---|
| $f_y$ at t = 5 | −41.3 | −41.2554 |
| Stability threshold h | ≈ 0.0485 | 0.04848 |
| Onset at h = 0.125 | t ≈ 3.68 | 3.6805 |
| Euler n = 40, y(4.875) | 0.232 | 0.231996 |
| Euler n = 40, y(5) | −0.0174 | −0.0174406 (also matches Mathews' printed table) |
| Heun n = 40, max error up to t = 3.875 | 0.0071 | 0.00708 |
| Heun n = 40, y(5) | 0.251 | 0.250635 |
| Ratio to exact | ≈ 31 | 30.87 |

