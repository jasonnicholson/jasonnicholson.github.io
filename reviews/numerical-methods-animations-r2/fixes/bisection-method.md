# Fix record: bisection-method

Scratch folder (evidence, re-runnable): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r2fix/bisection-method/fix/`
- `check.py`: independent bisection in Python/mpmath for both new intervals (run with `/usr/bin/python3 check.py`).
- `inst_aa.jl`, `inst_bb.jl`: the scripts' own parameter and bisection blocks plus a print loop (run with `julia inst_aa.jl`).
- `measure.py`: plot-area width in pixels from the regenerated frames.
- `legacy_aa/`, `legacy_bb/`: frames of Mathews' `Bisectionaa.gif` and `Bisectionbb.gif`; `new_aa/`, `new_bb/`: frames of the regenerated GIFs.

## Findings

### F1 — Minor — fixed
- Reproduced: the intro sentence (l.13) said the shaded bracket "is known to contain a root (by the Intermediate Value Theorem)". In Case 2, every bracket after step 1 contains no zero of tan. `check.py` asserts $\tan a>0>\tan b$ and $a<\pi/2<b$ after every step k=1..12. The only zero of tan in $[0,2]$ is 0, and it lies outside every bracket from step 1 on (brackets start at $a\ge1$).
- Change: `index.qmd` l.13, from "…that is known to contain a root (by the Intermediate Value Theorem)." to "The shaded region marks the current bracket $[a, b]$; when $f$ is continuous on $[a, b]$ and $f(a)$, $f(b)$ have opposite signs, the Intermediate Value Theorem guarantees that it contains a root."
- Check: the new sentence states the IVT hypotheses (continuity and opposite end signs) as a general statement. It is true for Case 1: polynomial, and `check.py` gives `inv=True` (f(a)f(b)<0) after all 12 steps. It does not apply to Case 2, which fails continuity on every bracket and, on $[0,2]$, also has $f(a)=0$. So it no longer claims anything false for Case 2.

### F2 — Minor — fixed (followed Mathews, per R2-A)
- Reproduced: archive `n2003/bisection/BisectionMod/Links/BisectionMod_lnk_4.html` (Example 3, "Convergence") uses $x^3+4x^2-10=0$ on `[a, b] = [-1, 2]` (formula images gr_647 and gr_648, viewed). `BisectionMod_lnk_5.html` (Example 4, "Not a root located") uses tan x on `[a, b] = [0, 2]` (gr_813 and gr_814, viewed). The page and scripts had $[1,2]$ for both.
- Change:
  - `bisectionaa.jl`: `a0, b0 = 1.0, 2.0` → `-1.0, 2.0`.
  - `bisectionbb.jl`: `a0, b0 = 1.0, 2.0` → `0.0, 2.0`.
  - Header comments in both scripts updated.
  - Picture follow-ups caused by the new intervals:
    - top-panel `xlims` widened: aa (-1.0,2.2) → (-1.2,2.2); bb (0.0,2.2) → (-0.2,2.2). With the old limits, the initial bracket's left line lay on the frame border, and so did the root at x=0 that the Case 2 text now describes.
    - The frame-0 "Initial bracket" annotation moved from y = 0.85·ymax to 0.6·ymax. With the new midpoints (0.5 and 1.0), it was hidden under the legend (seen in the first regeneration).
  - `index.qmd`: both headings, the Case 1 first Behavior sentence, the Case 2 Behavior (rewritten), the Case 2 alt text, and "from step 8 on" → "from step 9 on".
- Check: R2-A says to follow Mathews for intervals. Neither interval makes the page mathematically wrong:
  - On $[-1,2]$, $f(-1)=-7$ and $f(2)=14$, so there is a strict sign change and the cubic's only real root, 1.3652300134, lies inside.
  - On $[0,2]$, $f(0)=0$, so there is no strict sign change. The script's rule (keep $[a,c]$ if $f(a)f(c)<0$, else $[c,b]$) keeps $[1,2]$ at step 1, which is exactly Mathews' $I_1=\{1,2\}$. The page now says this explicitly instead of hiding it.
  - The script and the independent computation agree exactly at every step (tables below). The regenerated iterates reproduce Mathews' printed legacy values, shifted by one index because Mathews' $p_k$ is our $c_{k+1}$:
    - aa: $p_1=1.25$, $p_2=1.625$, $p_4=1.34375$, $p_5=1.39063$, $p_7=1.35547$, $p_8=1.36133$, $p_{11}=1.36499$, $p_{14}=1.36526$, $p_{17}=p_{20}=1.36523$, $I_1=\{0.5,2\}$, $I_4=\{1.25,1.4375\}$.
    - bb: $I_1=\{1,2\}$, $p_1=1.5$, $p_2=1.75$, $p_4=1.5625$, $p_7=1.57031$, $p_9=1.57227$, $p_{12}=1.57056$, $p_{15}=1.57077$, $p_{18}=1.57080$.
    - All match `check.py`'s "legacy p_k" lists.

Independent check of `check.py` and `inst_*.jl` (identical in both):

| k | Case 1 $c_k$ | $f(c_k)$ | $c_k-x^*$ | $3/2^k$ | Case 2 $c_k$ | $\tan c_k$ |
|---|---|---|---|---|---|---|
| 1 | 0.5 | −8.875 | −8.652e-1 | 1.5 | 1.0 | +1.557 |
| 2 | 1.25 | −1.797 | −1.152e-1 | 7.5e-1 | 1.5 | +14.10 |
| 3 | 1.625 | +4.854 | +2.598e-1 | 3.75e-1 | 1.75 | −5.520 |
| 4 | 1.4375 | +1.236 | +7.227e-2 | 1.875e-1 | 1.625 | −18.43 |
| 5 | 1.34375 | −0.3510 | −2.148e-2 | 9.375e-2 | 1.5625 | +120.5 |
| 6 | 1.390625 | +0.4246 | +2.539e-2 | 4.688e-2 | 1.59375 | −43.56 |
| 7 | 1.3671875 | +0.03236 | +1.957e-3 | 2.344e-2 | 1.578125 | −136.4 |
| 8 | 1.35546875 | −0.1604 | −9.761e-3 | 1.172e-2 | 1.5703125 | +2067 |
| 9 | 1.361328125 | −0.06431 | −3.902e-3 | 5.859e-3 | 1.57421875 | −292.2 |
| 10 | 1.3642578125 | −0.01605 | −9.722e-4 | 2.930e-3 | 1.572265625 | −680.6 |
| 11 | 1.36572265625 | +0.008137 | +4.926e-4 | 1.465e-3 | 1.5712890625 | −2029 |
| 12 | 1.364990234375 | −0.003959 | −2.398e-4 | 7.324e-4 | 1.57080078125 | −2.245e5 |

Final brackets:
- Case 1: [1.364990234375, 1.36572265625], which contains $x^*=1.36523001341$.
- Case 2: [1.5703125, 1.57080078125], which contains $\pi/2=1.5707963268$; $|c_{12}-\pi/2|=4.45\times10^{-6}$.

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd l.13 | "when $f$ is continuous on $[a,b]$ and $f(a)$, $f(b)$ have opposite signs, the IVT guarantees that it contains a root" | General IVT statement with both hypotheses stated; see F1 | yes |
| index.qmd l.15 | "(from step 9 on)" | `measure.py` → plot area 473 px (border columns 115 and 588) in both GIFs. aa: 0.007188 units/px, bracket 1.63 px after step 8 and 0.82 px after step 9. bb: 0.005074 units/px, 1.54 px after step 8 and 0.77 px after step 9 | yes |
| index.qmd l.19 heading | $[a_0,b_0]=[-1,2]$ | `bisectionaa.jl` `a0, b0 = -1.0, 2.0`; frame 1 reads "Initial bracket [-1.0, 2.0]" | yes |
| index.qmd l.21 | $f(-1)=-7<0$, $f(2)=14>0$; IVT root in $[-1,2]$ | `check.py` → `f(-1) = -7.0  f(2) = 14.0`; polynomial is continuous | yes |
| index.qmd l.22 (unchanged words, new case) | $x^*\approx1.3652$; width halves each step; bound $(b_0-a_0)/2^k$ holds and shrinks; midpoints not monotone, on both sides | `check.py`: x* = 1.36523001341409684576 (only real root, numpy). Widths 3, 1.5, …, 0.00146484375. `ok=True` for k=1..12 (tightest at k=12: 2.40e-4 ≤ 7.32e-4). Signs of $c_k-x^*$: − − + + − + + − − − + −. Not monotone, since 1.625 > 1.4375 | yes |
| index.qmd l.26 alt (unchanged) | "bracket narrows around the root at x≈1.3652 over 12 steps" | Final bracket contains x*; `n_iters = 12`; 13 frames, last zoom titled "step 12" | yes |
| index.qmd l.28 heading | $[a_0,b_0]=[0,2]$ | `bisectionbb.jl` `a0, b0 = 0.0, 2.0`; frame 1 reads "Initial bracket [0.0, 2.0]" | yes |
| index.qmd l.30 | "$f(0)=\tan(0)=0$, so the starting bracket has a genuine root at its left end" | `check.py` → `tan(0) = 0.0`; frame 1 shows the curve through (0,0) on the left bracket line | yes |
| index.qmd l.31 | "first midpoint is $c_1=1$; since $f(0)f(1)=0$ is not negative, bisection keeps $[1,2]$ and walks away from that root" | `inst_bb.jl` → `1 c=1.0 … after=[1.0, 2.0]`. The script's test is `f(a)*f(c) < 0`, else keep [c,b]; 0·1.557 = 0. Every later bracket has a ≥ 1 (`check.py`) | yes |
| index.qmd l.32 | "$\tan 1>0$, $\tan 2<0$ … caused by the vertical asymptote at $x=\pi/2\approx1.5708$, not a root: tan has no zero in $[1,2]$" | `check.py` → tan(1)=1.5574, tan(2)=−2.1850, π/2=1.5707963. The zeros of tan are kπ; the only one in [0,2] is 0 | yes |
| index.qmd l.33 (unchanged) | "Bisection converges to the asymptote" | `check.py`: π/2 lies inside every bracket for k=1..12; final width 4.88e-4; $|f(c_k)|$ grows to 2.2e5 | yes |
| index.qmd l.36 alt | "starting on [0, 2]: the first step leaves the root at x=0, then the method converges to the asymptote at π/2, not a root" | As l.30–33. Alt text checked with `quarto pandoc` (the nested brackets render in `alt`) | yes |
| bisectionaa.jl header | "interval [-1, 2] (Mathews, Bisection Method module, Example 3)" | Archive lnk_4 and gr_648 "[a, b] = [-1, 2]" | yes |
| bisectionbb.jl header | "interval [0, 2] (Mathews … Example 4)"; "tan(0)=0 is a root at the left end, but f(a)f(c)=0 at the first midpoint c=1, so the step keeps [1, 2]…" | Archive lnk_5 and gr_814 "[a, b] = [0, 2]"; `inst_bb.jl` step 1 | yes |
| GIF labels (both) | legend `c_k`, zoom titles "step k halves [a, b] of width w", "Initial bracket [...]" | Frames viewed. aa: c_1 = 0.5, c_9 = 1.361328, c_12 = 1.36499, widths 3.0 … 0.01171875 (step 9) … 0.00146484375 (step 12). bb: c_1 = 1.0, c_2 = 1.5, c_4 = 1.625, c_6 = 1.59375, c_8 = 1.570312, c_10 = 1.572266, c_12 = 1.570801, widths 2.0 … 0.0009765625. All match the table rounded to 6 decimals | yes |

## Scripts and GIFs
- Scripts changed: `bisectionaa.jl` and `bisectionbb.jl` (interval, top-panel xlims, frame-0 annotation height, header comments). Both were regenerated in place with `julia bisectionaa.jl` and `julia bisectionbb.jl`.
- Frames viewed at full size:
  - aa: frames 1, 2, 10 and 13. bb: frames 1, 2 and 13. Contact sheets for both.
  - Frame 1 (both): the initial bracket lines sit inside the frame, at columns 143/560 (aa) and 155/548 (bb), as computed from the xlims. The annotation is clear of the legend and the curve. In bb, the curve passes through (0,0) on the left bracket line.
  - Frame 2 (both): the red dot is at $(c_1,f(c_1))$ and the diamond at $(c_1,0)$. The zoom shows the gray "before" bracket ([-1,2] and [0,2]) and the blue "after" bracket ([0.5,2] and [1,2]). In bb, the kept half is $[1,2]$ and the root at 0 is left behind.
  - Frame 13 (both): legend $c_{12}$ is correct. The zoom title shows the width before step 12 (0.00146484375 and 0.0009765625) and is not clipped. In bb, the midpoint is at its true value −2.24e5 in the zoom. The top panel clamps it to the bottom border, a pre-existing device that the r2 review judged acceptable.
- `git status --short -- pages/numerical-methods/bisection-method`: `M bisectionaa.gif`, `M bisectionaa.jl`, `M bisectionbb.gif`, `M bisectionbb.jl`, `M index.qmd`. These are the expected files only; neither script is unchanged, so there is no byte-identity case.
- Independent resolution check: pending (director).

## Legacy archive
Consulted:
- `n2003/BisectionMod.html` and `n2003/bisection/BisectionMod/Links/BisectionMod_lnk_4.html` and `_lnk_5.html`, as text. The formula images gr_647, gr_648 and gr_814 were viewed.
- `a2001/Animations/RootFinding/BisectionMethod/Bisectionaa.gif` (31 frames) and `Bisectionbb.gif` (29 frames), via the frame tool.

What they showed:
- Example 3 is $x^3+4x^2-10=0$ on $[-1,2]$. Example 4 is $\tan x=0$ on $[0,2]$. Example 4's note says "The bisection method located a pole".
- Mathews runs 20 steps (aa) and 18 steps (bb). His $I_k$/$p_k$ labels are offset by one from the page's $c_k$, as listed under F2.

The page now uses Mathews' intervals and plot windows, with a 0.2 margin added on the left of each window. It keeps 12 steps per case: the step count is not a finding, and 12 steps already show convergence to 4 significant figures.

## Notes
- The page has no `## Description` section, although the conventions require one. This is a pre-existing gap and not a finding, so nothing was added.
- The Case 2 top panel clamps $|f(c)|>15$ to the border (pre-existing; the r2 review judged it acceptable). At step 12, $c_{12}$ is 4.45e-6 from π/2, so its marker sits on the asymptote line.
- R2-A did not settle the step count. I kept `n_iters = 12` rather than Mathews' 20/18, as the smallest change.

## Resolution check (independent checker, not shown this record)

Scratch: `.../r2fix/bisection-method/check/` (calc.py, run/, frames_aa/, frames_bb/, leg_all.png).

### Original findings

### F1 — resolved
- The old line 13 ("known to contain a root (by the IVT)") is gone. The new sentence says: "The shaded region marks the current bracket $[a,b]$; when $f$ is continuous on $[a,b]$ and $f(a)$, $f(b)$ have opposite signs, the IVT guarantees that it contains a root." This is the IVT stated with both of its hypotheses, so it is true. It no longer claims a root for Case 2.
- Consistency with Case 2's new start $[0,2]$: no sentence claims a strict sign change on $[0,2]$, and none claims the IVT guarantee there.
  - Line 30 says $f(0)=0$, a root at the left end.
  - Line 31 says $f(0)f(1)=0$ "is not negative".
  - Line 32 puts the sign change on $[1,2]$ only, and says correctly that tan has no zero there.
  - Line 33 credits the failure to the missing continuity.
- Line 14 ("narrows the bracket to the half that still contains the sign change") stays defensible at Case 2 step 1:
  - the kept half $[1,2]$ has $\tan 1 = 1.5574 > 0 > \tan 2 = -2.1850$;
  - $[0,2]$ itself contains that sign change in its interior, at the pole;
  - the discarded half $[0,1]$ has no sign change, since $f(0)=0$ and $f>0$ on $(0,1]$.
- The script's rule `f(a)*f(c) < 0 ? [a,c] : [c,b]` yields $[1,2]$, because Float64 `tan(0.0)` is exactly 0 (calc.py: prod = 0.0). That matches the text.

### F2 — resolved
- Both cases now use Mathews' intervals, per R2-A ("Bisection intervals" is listed explicitly there).
  - Case 1 is $[-1,2]$ and Case 2 is $[0,2]$, in index.qmd headings, `bisectionaa.jl` line 16 and `bisectionbb.jl` line 19.
  - I checked the archive images `BisectionMod_gr_647/648/813/814.gif`. They read "x^3+4x^2-10=0, [a,b]=[-1,2]" and "Tan[x]=0, [a,b]=[0,2]".
- Computed sequences:
  - Case 1: c = 0.5, 1.25, 1.625, 1.4375, …, matching the legacy GIF ($I_1=\{0.5,2\}$, then 1.25, 1.625).
  - Case 2: c = 1, 1.5, 1.75, 1.625, …, matching the legacy GIF ($I_1=\{1,2\}$, $p_1=1.5$).
- Mathews' detail that $\tan 0 = 0$ is a genuine root that bisection walks away from is now on the page (lines 30–31), in the alt text and in the GIF (frames 0 and 1 show the curve crossing at x=0, and the bracket moves to [1,2]).
- Note, not a defect: the page indexes the first midpoint as $c_1$, while Mathews' animation starts at $p_0$. So the page's $c_k$ equals Mathews' $p_{k-1}$. The page makes no claim that depends on this.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd l.13 | IVT conditional sentence | Correct statement of IVT; consistent with Case 2 | OK |
| l.15 | "narrower than a pixel … (from step 9 on)" | Plot-area width measured from frames is about 473 px (x from about 115 to 588). Case 1 (3.4 units): step 8 width 0.01172 is 1.63 px, step 9 width 0.00586 is 0.82 px. Case 2 (2.4 units): step 8 is 1.54 px, step 9 is 0.77 px. The statement holds for any plot area between about 310 and 580 px. | OK |
| l.19 heading | $[a_0,b_0]=[-1,2]$ | script a0,b0 = -1,2; archive gr_648 | OK |
| l.21 | $f(-1)=-7<0$, $f(2)=14>0$, IVT gives a root in $[-1,2]$ | -1+4-10=-7; 8+16-10=14; f is continuous | OK |
| l.22 (unchanged, re-checked under new $b_0-a_0=3$) | $\lvert c_k-x^*\rvert\le(b_0-a_0)/2^k$; midpoints on both sides | Holds for k=1..12 against mpmath root 1.3652300134. The sides go −,−,+,+,−,+,+,−,−,−,+,−. | OK |
| l.26 alt (unchanged) | root ≈1.3652, 12 steps | n_iters=12; root checked | OK |
| l.28 heading | $[a_0,b_0]=[0,2]$ | script; archive gr_814 | OK |
| l.30 | $\tan 0=0$, root at left end | exact | OK |
| l.31 | $c_1=1$; $f(0)f(1)=0$ not negative, so keep $[1,2]$ | (0+2)/2=1; prod=0.0 in run; else-branch gives [1,2]; frame 1 shows it | OK |
| l.32 | $\tan 1>0$, $\tan 2<0$; asymptote $\pi/2\approx1.5708$; no zero of tan in $[1,2]$ | 1.5574, −2.1850; zeros of tan are $k\pi$, and $\pi\approx3.14>2$ | OK |
| l.33 (unchanged) | converges to the asymptote | $a<\pi/2<b$ at every step 1..12; final bracket [1.5703125, 1.57080078] contains 1.5707963 | OK |
| l.37 alt | "starting on [0, 2]: the first step leaves the root at x=0, then … converges to the asymptote at π/2" | matches frames 0, 1 and 12 | OK |
| bisectionaa.jl header, xlims (-1.2,2.2), annotation y=0.6·ylims[2] | comments and values | frame 0: x=-1 line visible, label "Initial bracket [-1.0, 2.0]" clear of the legend | OK |
| bisectionbb.jl header comment | "f(a)f(c) = 0 at the first midpoint c = 1, so the step keeps [1, 2]" | as above | OK |
| bisectionbb.jl xlims (-0.2,2.2), annotation | | frame 0: root at 0 and the x=0 bracket line visible; label "Initial bracket [0.0, 2.0]" clear of the legend | OK |
| GIF labels | c_6 = 1.390625 (aa); c_12 = 1.36499 (aa); c_12 = 1.570801 (bb); zoom titles "width 0.09375", "0.00146484375", "0.0009765625" | calc.py: c_6 = 1.390625; c_12 = 1.364990234 (prints 1.36499 after rounding to 6 digits); c_12 = 1.57080078; widths before step 6, 12 (aa) and 12 (bb) match | OK |

### New problems
None. This rests on the following:
- every changed sentence and number was recomputed (calc.py, mpmath at 40 digits);
- the archive was checked for both intervals;
- the first, middle and last frames of both GIFs were viewed at full size, plus the bb contact sheet.

In those frames:
- the zoom panels show the correct before and after brackets and the correct midpoint;
- frame 1 of Case 2 correctly shows the bracket leaving [0,2] for [1,2];
- the titles fit and the labels are legible.

Remaining behaviour is pre-existing and unchanged by this fix. In the Case 2 top panel, late midpoints are drawn clamped to ±15 because the true values lie off the scale; the zoom panel shows them at their true values.

### Reproducibility and conventions
- Both scripts were run from scratch copies (`check/run/`). `cmp` shows that both output GIFs are byte-identical to the working-tree GIFs (600×978, 13 frames each).
- Page: a source link and a GIF embed per case, descriptive alt text, no code blocks.
- The page still has no `## Description` section. This was a pre-existing observation in the original review and was not introduced by this fix; it remains a convention gap.
- The fix diff touches only `pages/numerical-methods/bisection-method/`. The other modified paths in `git status` (monte-carlo-pi, runge-kutta-method, simpsons-rule, reviews/…-r2/fixes/) belong to other pages' work and are not part of this diff.

**Final status:** committed
