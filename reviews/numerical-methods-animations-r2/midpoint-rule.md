# Midpoint Rule — animation review (round 2)

Page: `pages/numerical-methods/midpoint-rule/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1. Fidelity, Minor: the page says the legacy midpoint animation is partly missing, but it is in the archive

- **Location:** `index.qmd` line 25: "Legacy midpoint animation assets are partially missing from the archive; this reconstruction uses the same function, interval, and density-increase pacing seen in the available quadrature GIFs."
- **What is there now:** The page says the midpoint animation had to be rebuilt from other quadrature GIFs because the midpoint assets are missing.
- **What is true instead:** The full legacy midpoint animation is in the archive at `/home/jason/Desktop/math-fullerton/baseline/mathews/a2001/Animations/Quadrature/Midpoint/Midpointaa.gif`, with its HTML wrapper `Midpointaa.html`. It has 24 frames: 2 title frames, then Sample Points = 1, 1, 2, 4, 6, 8, 10, 12, 14, 16, 20, 24, 28, 32, 40, 50, 60, 70, 80, 100, 120. It uses the same function $e^{-x}\sin(8x^{2/3})+1$ on $[0,2]$. Its approximations match the new script exactly: n=1 2.727929, 4 2.011118, 8 2.051517, 12 2.036937, 16 2.029606, 24 2.023254, 32 2.020644, 120 2.016771. The legacy GIF also marks each midpoint sample with a red dot and prints the function in the frame. The new GIF does neither, but that is not a correctness issue.
- **How I know:** I ran `find /home/jason/Desktop/math-fullerton/baseline/mathews -iname '*midpoint*'`, which lists `a2001/Animations/Quadrature/Midpoint/Midpointaa.gif`. Then I ran `julia .../tools/giftools.jl legacy_gif/src.gif legacy_gif/out` (24 frames) and read the labels and approximations from `legacy_gif/out/sheet.png`, `legacy_text.png` and `frame_024.png`. Only the module index page `n2003/midpointrule/MidpointRuleMod.html` is missing from the topic subfolder. It sits one level up, at `n2003/MidpointRuleMod.html`.
- **Severity reasoning:** This is a statement about where the page came from, not about the mathematics. The animation itself faithfully reproduces the legacy example: same function, interval, final n and values. It is still a false statement in the Animations section that readers will see, so I rate it Minor.
- **Suggested correction:** Replace line 25 with something like: "This reproduces Mathews' midpoint animation (same function, interval and final 120 sample points) with a slightly different sequence of sample counts." Or delete the sentence.

No Implementation or Page-match findings.

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `midpointaa.jl` | 0 | 7.3 | midpointaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `midpointaa.gif` | 25 | byte-identical | midpointaa |

### Page references

- Scripts linked: `midpointaa.jl`
- GIFs embedded: 1
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | Description l.12-16 | $M_n = \Delta x \sum_{i=0}^{n-1} f(a+(i+\tfrac12)\Delta x)$, $\Delta x=(b-a)/n$ | Script l.18-21 `dx*sum(f(a+(i+0.5)*dx) for i in 0:n-1)`, the same formula | confirmed |
| 2 | Description l.18 | "each subinterval contributes a rectangle centered at its midpoint sample" | Script l.32-40: rectangle on [xl,xr] with height f((xl+xr)/2). Frame heights at n=3 (0.536, 1.364, 0.817) and n=6 (1.557, 0.426, 1.312, ...) match the instrumented `f(xm)` values | confirmed |
| 3 | Description l.18 | "often much more accurate than left/right endpoint sums at the same n" | General statement. For this integrand the midpoint error is about 3x smaller than the left/right errors for n ≥ 8 (e.g. n=120: 0.00049 vs 0.00148 and 0.00119) | confirmed |
| 4 | Animations l.22-23 | function $y=e^{-x}\sin(8x^{2/3})+1$ on $[0,2]$ | Script l.8-9 | confirmed |
| 5 | l.23 | "Each frame increases sample-point density across the full interval and updates the integral estimate" | Frames 2-25 have n = 1,2,…,120, strictly increasing, with partitions over the full [0,2]. Frame 1 (n=0) shows only the curve, which is a harmless intro frame. All 25 frame hashes are distinct | confirmed |
| 6 | l.25 | "Legacy midpoint animation assets are partially missing from the archive" | The legacy `Midpointaa.gif` exists and is complete (see F1) | **wrong** (F1) |
| 7 | l.25 | "uses the same function, interval … seen in the available quadrature GIFs" | Same function and interval as legacy `Midpointaa.gif` | confirmed (the function and interval do match) |
| 8 | Case heading l.27 | "Midpoint Rule, $y=e^{-x}\sin(8x^{2/3})+1$" | Script l.8 | confirmed |
| 9 | Behavior l.29 | "Over the first few frames the estimate jumps above and below the integral" | Errors: n=1 +0.712, n=2 −0.785, n=3 −0.205, n=4 −0.0052, n=5 +0.0374 | confirmed |
| 10 | l.29 | "from 6 sample points on it stays above $\int_0^2 f\,dx$" | Errors are positive for every n ≥ 5 in the sequence (n=6 +0.0430 … n=120 +0.000492) | confirmed |
| 11 | l.29 | "…and decreases toward it in every frame" (from 6 on) | M: 2.059280 (6) > 2.056230 (7) > 2.051517 (8) > … > 2.016771 (120). Strictly decreasing over every consecutive pair from n=6. (The 5→6 step increases, which is why "from 6" is correct) | confirmed |
| 12 | l.29 | "$\int_0^2 f(x)\,dx \approx 2.016280$" | mpmath (t³ substitution, 30 digits): 2.0162797196170963…, which rounds to 2.016280 | confirmed |
| 13 | l.29 | "the last frame (120 sample points) gives 2.016771" | Script 2.016771455496156; mpmath 2.016771455; frame 25 shows "Approximation = 2.016771" | confirmed |
| 14 | l.29 | "still about 0.00049 high" | 0.000491736 | confirmed |
| 15 | l.29 | "From 4 sample points on, the midpoint estimate is closer to the integral than the left- or right-endpoint sum with the same number of subintervals" | |M−I| < min(|L−I|,|R−I|) for every n in the sequence ≥ 4 (n=4: 0.0052 vs 0.219/0.210). It fails at n=1,2,3, so "from 4" is right | confirmed |
| 16 | l.29 | "$f'$ unbounded at $x=0$ ($f'(x)\approx \tfrac{16}{3}x^{-1/3}$ near 0)" | mpmath ratio f'(x)/((16/3)x^{-1/3}) = 0.9943 (x=1e-3), 0.999997 (1e-6), 0.999999997 (1e-9) | confirmed |
| 17 | l.29 | "measured error shrinks like $O(\Delta x^{5/3})$ rather than $O(\Delta x^2)$" | Error ratios on halving: 12→24 2.962, 24→48 3.112, 48→96 3.147, … 3072→6144 3.1718, tending to 2^{5/3}=3.1748. This agrees with the generalized Euler–Maclaurin (Navot) term h^{1+β} for an x^{β} singularity, β=2/3 | confirmed |
| 18 | l.29 | "halving Δx divides it by about 3.11 (from 24 to 48 subintervals)" | 0.00697444/0.0022408 = 3.1125 | confirmed |
| 19 | l.29 | "tending to $2^{5/3}\approx 3.17$, instead of 4" | 2^{5/3}=3.1748; ratios above approach it | confirmed |
| 20 | Link l.31 | `[Julia source](midpointaa.jl)` | File exists and is the script for this case | confirmed |
| 21 | Embed l.33 | `midpointaa.gif` | Exists, 25 frames, byte-identical to regeneration (manifest) | confirmed |
| 22 | Alt text l.33 | "Midpoint Rule animation over [0,2]: each frame increases partition density and recomputes midpoint-rectangle area" | As in #5. Each frame's "Approximation" equals the computed M_n to 6 decimals (checked frames n=2,3,6,10,16,28,48,72,120) | confirmed |
| 23 | Derivation l.37 | For $f\in C^2$, global error $O(\Delta x^2)$, doubling n reduces error ≈4× | The script's own `midpoint_sum` on e^x over [0,2]: ratios 3.9945, 3.9986, 3.9997 | confirmed |
| 24 | Worked Example l.41 | approximation "converges as n grows" | Error falls from 0.043 (n=6) to 0.00049 (n=120), monotonically from n=6 | confirmed |
| 25 | Implementation Notes l.45 | "keeps axis limits fixed so only density and approximation change between frames" | Script l.14-15, 24: xlims=(0,2), ylims=(0,2.1) on every frame; confirmed in frames | confirmed |
| 26 | Frame title (GIF) | "Midpoint Rule" | Matches the method | confirmed |
| 27 | Frame label (GIF) | "Sample Points = n" | n = number of subintervals = number of midpoint samples | confirmed |

---

### 3. Implementation checks: `midpointaa.jl`

**Is it the method it claims to be?** Yes. `midpoint_sum(n)` is the composite midpoint rule with uniform $\Delta x=(b-a)/n$, sampling at $a+(i+\tfrac12)\Delta x$, $i=0..n-1$. This is the same formula as the Description. Rectangles are drawn on $[a+i\Delta x, a+(i+1)\Delta x]$ with height $f$ at the midpoint.

**Are the numbers right?** Yes.
- Instrumented copy (`review/inst.jl`, plotting removed, prints `approx`) compared with independent mpmath (`review/indep.py`, 30 digits). They agree at every n in the sequence to at least 9 digits. Examples (script / mpmath):
  - n=1: 2.7279291177723355 / 2.727929118
  - n=4: 2.011118372395021 / 2.011118372
  - n=6: 2.059279922009142 / 2.059279922
  - n=24: 2.0232541562652457 / 2.023254156
  - n=48: 2.018520515385868 / 2.018520515
  - n=120: 2.016771455496156 / 2.016771455
- Degree-of-precision check, running the script's own `midpoint_sum` extracted from the source file (`review/prec.jl`): the error for 1 and x is 0.0 exactly. For x² on [0,2] it is −0.6667, −0.1667, −0.04167 at n=1,2,4 (theory: −(b−a)h²f''/24 = −2/3 at n=1, then ÷4 per halving). For x³ it is −2, −0.5, −0.125. So the rule is exact through degree 1 and not degree 2, as the midpoint rule should be.
- Order on a smooth integrand (e^x, [0,2]) with the script's routine: error ratios 3.9945, 3.9986, 3.9997, which is order 2.

**Are its reference values right?** The script draws no reference value. The page's reference $\int_0^2 f = 2.016280$ was checked independently. mpmath with the substitution x=t³ (which removes the x^{2/3} singularity) gives 2.01627971961709632788727442192. Direct `mp.quad` over 40 subintervals gives the identical result.

**Does the picture show what was computed?**
- Frames 1 (n=0, curve only), 3 (n=2), 25 (n=120) were viewed at full size, and the contact sheet covers n=3, 6, 10, 16, 28, 48, 72, 120. Rectangle heights match the instrumented `f(midpoint)` values (n=2: 0.4257, 0.8055; n=3: 0.536, 1.364, 0.817; n=6: 1.557, 0.426, 1.312, …). Each rectangle top crosses the curve at its midpoint.
- Every frame's "Approximation = …" label equals `round(M_n, digits=6)`. Julia drops trailing zeros, so n=6 shows "2.05928" for 2.059280. That is cosmetic and correct.
- Axis window: f has range [0.3572, 1.9198] on [0,2] (max at x≈0.0804), which sits entirely inside ylims (0, 2.1). There is no clamping or masking, and nothing is clipped. The annotations at y=1.88 and 1.74 around x=1.15 do not overlap the curve or rectangles, which are ≤1.39 for x in about 0.6–2.
- Frame count: 25 (n=0 plus the 24 values of `n_seq`), all with distinct hashes. The page does not state a frame count.
- The committed GIF is byte-identical to the scratch regeneration (manifest).

