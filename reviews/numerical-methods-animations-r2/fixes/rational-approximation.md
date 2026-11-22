# Fix record: rational-approximation

Scratch evidence: `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r2fix/rational-approximation/fix/` (`mod.txt` = stripped module text, `upscale.jl` + `img/` = upscaled statement and code images, `r44check.py` = solvability check).

## Findings

### F1 — Minor (Fidelity) — fixed

- **Reproduced:** `sed 's/<[^>]*>//g' n2003/RationalApproxMod.html | sed '/^[[:space:]]*$/d'` lists five worked problems on $[-1,1]$: "Example 1", "Example 2", **"Exercise 3"** (the archive labels it this way, not "Example 3"), "Example 4", "Example 5". Examples 1 and 2 have parts (a) equally spaced nodes, (b) Chebyshev nodes, (c) Mathematica `MiniMaxApproximation`. Exercise 3 and Examples 4 and 5 have parts (a) and (b) only. Each has its own solution pages: lnk_2–4 (Ex 1), lnk_5–7 (Ex 2), lnk_8–9 (Ex 3), lnk_10–11 (Ex 4), lnk_12–13 (Ex 5). The page has one case (`rationalapproxaa.jl`/`.gif`, $e^x$, $[2/2]$), and nothing on it mentions the other four. The finding holds. One detail in it is corrected: item 3 is "Exercise 3", not "Ex. 3".
- **Decision:** R2-A, "add one sentence when a whole Mathews example or topic is left out … not add the example". Rational is named there explicitly. I added no cases.
- **Change:** `index.qmd`, new lines 30–31, at the end of the Animations intro, just before "### Case 1". These lines first went after the last embed; see "Round 2 after check" below for the move.
  - "No archived animation GIF is available for this topic, so the animation below is reconstructed from Example 1 of Mathews' Rational Approximation module."
  - "The module's Example 2, Exercise 3 and Examples 4–5, which build $[4/4]$ rational approximations on $[-1,1]$ for $e^x$ (Example 2, with equally spaced nodes, with Chebyshev nodes and with MiniMax) and for $\cos(\pi x/2)$, $\tan x$ and $\arctan x$ (Exercise 3 and Examples 4–5, with equally spaced nodes and with Chebyshev nodes), are not animated here."
- **Check:** see ledger. Each function and degree was checked in both the statement image and the solution code image, as the pattern advises when formulas are named.

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd l.30 | "No archived animation GIF is available for this topic" | `ls -R a2001/Animations/ \| grep -i -E 'rat\|pade'` → only `Interpolation/Pade/Pade01..07`; `grep -il rational a2001/Animations/*.html*` → no hits; `RationalApproxMod.html` links no animation | yes |
| l.30 | "reconstructed from Example 1 of Mathews' Rational Approximation module" | Ex 1 statement images gr_9 = "R₂,₂(x)", gr_10 = "f[x] = eˣ", interval [-1,1] in text; parts (a)/(b)/(c) = equal / Chebyshev / MiniMax, which match frames 1–3 of the page's GIF (round-2 ledger rows 4–5, 14) | yes |
| l.31 | "Example 2, Exercise 3 and Examples 4–5" (labels) | `grep -o -E '(Example\|Exercise) [0-9]' RationalApproxMod.html` → Example 1, Example 2, Exercise 3, Example 4, Example 5 | yes |
| l.31 | "$[4/4]$" for all four | Statement images gr_113, gr_216, gr_295, gr_375 all read "R₄,₄(x)" (upscaled 5×, viewed). Code images gr_116 (Ex 2), gr_219 (Ex 3), gr_298 (Ex 4), gr_378 (Ex 5) all set `n = 4; m = 4` | yes |
| l.31 | "on $[-1,1]$" | Statement text of all four: "over the interval [-1,1]" (mod.txt, lnk_5..13) | yes |
| l.31 | "for $e^x$ (Example 2 …)" | gr_114 "f[x] = eˣ"; gr_116 `f[x_] = eˣ` | yes |
| l.31 | "with equally spaced nodes, with Chebyshev nodes and with MiniMax" (Ex 2) | Statement text "2 (a) Use equally spaced interpolation nodes. 2 (b) Use Chebyshev interpolation nodes. 2 (c) Use Mathematica's built in MiniMaxApproximation procedure." Solution pages lnk_5, lnk_6, lnk_7 exist | yes |
| l.31 | "$\cos(\pi x/2)$" (Exercise 3) | gr_217 "f[x] = Cos[π/2 x]"; gr_219 `f[x_] = Cos[π/2 x]` | yes |
| l.31 | "$\tan x$" (Example 4) | gr_296 "f[x] = Tan[x]"; gr_298 `f[x_] = Tan[x]` | yes |
| l.31 | "$\arctan x$" (Example 5) | gr_376 "f[x] = ArcTan[x]"; gr_378 `f[x_] = ArcTan[x]` | yes |
| l.31 | "with equally spaced nodes and with Chebyshev nodes" (Ex 3–5) | Statement text has parts (a) equally spaced and (b) Chebyshev only, with no (c), for 3, 4 and 5. Solution pages lnk_8/9, 10/11, 12/13 | yes |
| l.31 | "build … rational approximations" (they exist) | `python3 -I r44check.py`: the linearized $[4/4]$ interpolation system $P(x_i)-f(x_i)Q(x_i)=0$, $Q(0)=1$, with 9 equally spaced nodes or 9 Chebyshev nodes (zeros of $T_9$), is nonsingular for every function and node set. Determinants: exp 1.30e-15 / 5.65e-15, cos(πx/2) 1.06e-9 / 4.18e-9, tan 3.51e-11 / 2.22e-10, atan 4.16e-11 / 1.05e-10 (40-digit mpmath; cond ≤ 3.4e8) | yes |
| l.31 | "are not animated here" | Page folder holds one script (`rationalapproxaa.jl`), one GIF and one case ($e^x$, $[2/2]$) | yes |

The sentences contain no computed result values, as the pattern requires.

## Scripts and GIFs
- No scripts changed and no GIFs regenerated. This is a text-only fix.
- `git status --short -- pages/numerical-methods/rational-approximation` → ` M pages/numerical-methods/rational-approximation/index.qmd` only. After the move, `git diff` shows 3 insertions (two note lines and a blank line) between the intro's "Julia source scripts…" line and "### Case 1", with no deletions.

## Legacy archive
- **Consulted:** `n2003/RationalApproxMod.html` and its `Links/` and `Images/`; `a2001/Animations/`.
- **What it showed:** five worked problems, as in the ledger. Example 1 matches the page's case. There is no animated GIF for rational approximation in `a2001/Animations/`; only Padé animations exist there.
- **Archive gaps:** the images for the Example 2(c) solution (gr_191 onward, referenced by lnk_7) are missing, and so are the Example 1(b) images (as round 2 noted). Neither affects the sentence, which uses only the statement text and images.
- **Difference from the page:** none that matters. The page computes the minimax approximant by Remez rather than Mathematica's `MiniMaxApproximation`, and round 2 confirmed that the coefficients match Mathews' output (gr_89).

## Round 2 after check
- The checker confirmed every fact in the note. It raised one new Minor issue about placement: after the Case 1 GIF, the two lines sat under "### Case 1" and read as part of that case.
- **Change:** both lines moved from after the Case 1 embed (old l.38–39) to the end of the Animations intro (now l.30–31), after "Julia source scripts … linked under each case." and before "### Case 1". The trailing whitespace of the file is back to the original.
- **Wording:** "so this animation is reconstructed" became "so the animation below is reconstructed", because before the case heading "this animation" has no picture next to it. That matches l.26, "The animation below follows…". "are not animated here" still means "on this page", which is true. The page has one case and one GIF. All other wording is unchanged, and no facts changed.
- **Check:** `git diff -- pages/numerical-methods/rational-approximation` shows only the 3 inserted lines before "### Case 1" and nothing after the embed.

## Notes
- The archive calls item 3 "Exercise 3", not "Example 3". The page keeps the archive's label so that a reader can find it in the module. A range "Examples 2–5" would have misnamed it.
- In the review's Why-only-Minor, the remark that $\tan x$ is instructive "near its poles" was not carried onto the page. The poles of $\tan x$ are at $\pm\pi/2$, outside $[-1,1]$.
- Example 4's solution adds an extra equation because $\tan x$ is odd (lnk_10/11 "Remark"). The note does not describe that detail. "build … rational approximations" stays true.
- Line 18 ("Mathews compares three constructions over a fixed interval") is true for Examples 1 and 2 and was left unchanged.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: the diff adds two sentences (index.qmd lines 38–39) that say the page animates Mathews' Example 1 only and name the omitted Example 2, Exercise 3 and Examples 4–5, with function, degree, interval and node types. R2-A asks for this ("add one sentence ... saying what was left out. Do not add the example"). I checked every element against the archive myself (see ledger), and all of them are correct. The note's placement is a separate Minor problem (see New problems). It does not affect whether the omission is now disclosed.

### Changed-text ledger

| Location | Text / number | Check | Verdict |
|---|---|---|---|
| l.38 | "No archived animation GIF is available for this topic" | `a2001/Animations/` holds Derivative, Interpolation (Chebyshev, FourierSeries, Lagrange, Pade, Series), Optimization, OrdinaryDE, Quadrature, Riemann and RootFinding. `grep -ril rational` over `a2001/Animations` finds nothing, and no file in `a2001` references RationalApprox. The Pade animations link only to PadeApproximationMod.html, and they are centre-based Padé, not node-based rational approximation. The `n2003/rationalapprox/` tree has 0 multi-frame GIFs (I checked n_frames of every GIF with PIL). | true |
| l.38 | "reconstructed from Example 1 of Mathews' Rational Approximation module" | In RationalApproxMod.html, Example 1 is R_{2,2} (gr_9) for f[x]=e^x (gr_10) on [-1,1], using (a) equal nodes, (b) Chebyshev nodes and (c) MiniMaxApproximation. That matches Case 1 (e^x, [2/2], [-1,1], equal / Chebyshev / MinMax). | true |
| l.39 | labels "Example 2, Exercise 3 and Examples 4–5" | The archive headings are "Example 2.", "Exercise 3.", "Example 4." and "Example 5." (HTML lines 86, 105, 120 and 135). | true; "Exercise 3" is exact (the finding loosely said "Ex. 3") |
| l.39 | "[4/4]" for all four | gr_113, gr_216, gr_295 and gr_375 each render "R_{4,4}(x)" (I viewed them upscaled). Every solution page (lnk_5–13) says "There were 9 coefficients to determine". | true |
| l.39 | "on [-1,1]" | The module text and each solution page lnk_5–13 say "over the interval [-1,1]", and the error is found over [-1,1]. Graphs are drawn over [-2,2], which is a display choice and not the approximation interval. | true |
| l.39 | e^x for Example 2 | gr_114 renders "f[x] = e^x". | true |
| l.39 | Example 2 uses equally spaced nodes, Chebyshev nodes and MiniMax | 2(a) "equally spaced interpolation nodes", 2(b) "Chebyshev interpolation nodes", 2(c) "Mathematica's built in MiniMaxApproximation" (lnk_5, lnk_6, lnk_7). | true |
| l.39 | cos(πx/2), tan x, arctan x | gr_217 renders "Cos[π/2 x]", gr_296 "Tan[x]" and gr_376 "ArcTan[x]", in the order Exercise 3, Example 4, Example 5. | true |
| l.39 | Exercise 3 and Examples 4–5 use equally spaced and Chebyshev nodes (no MiniMax) | Each of these has only parts (a) "equally spaced" and (b) "Chebyshev" (module text, lnk_8–13). | true |
| l.39 | "are not animated here" | The page has one case (Case 1, e^x [2/2]). | true |

The new lines contain no other numbers or claims. The fix changed no heading, alt text, title or label.

### New problems

### N1 — Minor: the page-level note sits inside Case 1's subsection
- Location: index.qmd lines 38–39, after the Case 1 GIF embed (line 36) and under `### Case 1 — Rational [2/2] for e^x ...` (line 30). No heading separates them.
- Evidence: both sentences are about the page as a whole: no archived GIF exists for the topic, and the other module examples are not animated. As placed, they render as the last paragraph of Case 1, after its figure. The second sentence, about Example 2 [4/4] and the cos, tan and arctan examples, then reads as a remark about Case 1. The original finding suggested putting it after line 26, the Animations-section intro. Moving both lines to between line 26 and line 28, or just before the `### Case 1` heading, would make them read as section-level. The content is correct, so this is Minor.
- Side note, not a defect: R2-A says "one sentence". The fixer used two, one for the missing GIF and one for the omitted examples. Both are true.

No other new problems. That conclusion rests on the archive checks in the ledger above, and on the fact that the diff touches only index.qmd and changes no script or GIF.

### Reproducibility and conventions
- Changed files in the page folder: only `index.qmd`, with 3 inserted lines (`git diff --stat HEAD`). `rationalapproxaa.jl` and `rationalapproxaa.gif` are unchanged, so no regeneration or frame check was needed.
- Conventions are still met: Description (line 10) comes before Animations (line 24), Case 1 has a source link (line 34) and a GIF embed (line 36), the alt text is descriptive, and there are no code blocks (0 backtick fences).
- Files outside the page folder: the fix.diff for this page lists only this folder. The working tree has many other modified files under other page folders. Those belong to parallel fixes of other pages, and none is used by this page.

### Re-check

I re-checked this against the updated fix.diff and the live `git diff HEAD` of the page folder. They are identical: blob 15fece8..14c69c7, one hunk, 3 inserted lines and nothing removed.

- **Placement:** the two note lines are now lines 30–31. They sit in the Animations intro, after "Julia source scripts ... linked under each case." (line 28) and before `### Case 1 — ...` (line 33), with a blank line on each side. They render as a section-level paragraph ahead of the first case heading, so they read as page-level. N1 is resolved. The two lines that previously followed the Case 1 GIF are gone, and the file now ends at the GIF embed as it does at HEAD.
- **Wording:** the only change is "so this animation is reconstructed" becoming "so the animation below is reconstructed". The page has exactly one animation, `rationalapproxaa.gif` in Case 1, and it comes after line 30. That animation is Mathews' Example 1 (e^x, R_{2,2}, [-1,1], equal, Chebyshev and MiniMax), so the sentence is true where it now sits. Line 31 is byte-for-byte the same text whose claims I checked in the ledger above: Example 2, Exercise 3 and Examples 4–5, all [4/4] on [-1,1], with the functions and node types as stated. It is still true.
- **Nothing else changed:** `git status --porcelain` for the folder shows only `M index.qmd`. The diff has no `-` lines, and the .jl and .gif are untouched. Lines 1–29 and 33 onward are the HEAD text.

Status after the re-check: F1 is resolved and N1 is resolved. No new problems.

**Final status:** committed
