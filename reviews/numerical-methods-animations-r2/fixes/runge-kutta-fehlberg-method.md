# Fix record: runge-kutta-fehlberg-method

Scratch folder (evidence): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r2fix/runge-kutta-fehlberg-method/fix/`

Both findings are text-only. No script or GIF changed.

## Findings

### F1 — Minor — fixed
- Reproduced: `ls pages/numerical-methods | grep -i -E 'heun|modif|improv'` → only `accelerated-and-modified-newton-raphson` and `improved-newton-method`, so there is no Modified Euler page. `grep -rln 'sqrt\[3\]' --include=index.qmd pages/numerical-methods` → the IVP $y'=1-t\sqrt[3]{y}$ appears on the Euler, Runge-Kutta, Taylor-series, ABM and RKF pages. `grep -n '^### Case' eulers-method-for-odes/index.qmd` → Case 1 "Forward Euler ..." and Case 2 "Modified Euler (midpoint) ..., same IVP" (working tree, after the R2-D change). Output in `f1_check.txt`.
- Change: `index.qmd` Animations intro. "...the same IVP shown on the Adams-Bashforth-Moulton, Euler, and Modified Euler pages:" → "...the same IVP shown on the Euler's Method page (in both its forward Euler and modified Euler cases) and on the Runge-Kutta, Taylor Series and Adams-Bashforth-Moulton pages:".
- Check: each named page has the IVP with $y(0)=1$ on $[0,5]$. Euler l.30 and both cases (l.42, l.71); Runge-Kutta l.12/16; Taylor l.12/16/24; ABM l.24/32.

### F2 — Minor — fixed
- Reproduced: in the archive's `n2003/RungeKuttaFehlbergMod.html` (stripped) Examples 1–8 are listed. Statement images: Ex 1/2/3 `gr_27`, `gr_44`, `gr_56` are $y'=1+y^2$; Ex 6 `gr_103/104/105` are $y'=t^2+y^2$, $y(0.0)=0.5$, $[0.0,1.5]$; Ex 7 `gr_120/122` are the same ODE on $[0.0,1.5]$, with the closed form in `gr_123` (BesselJ/Gamma); Ex 8 `gr_144/145` are $y'=t^2+y^2$, $y(0)=1/2$, solved by DSolve (`gr_146`), result `gr_154` = `gr_123`. Ex 6 solution code: `gr_106` `f[t_,y_]=t^2+y^2`; `gr_108` `RKF45[0.0,1.5,0.5,0.000001]`; `gr_114` `RKF54[...]`. The page never mentioned Examples 6–8, and the provenance paragraph followed the Case 2 introduction, so "this animation" read as Case 2.
- Change: `index.qmd` Animations intro, reordered and reworded.
  - The provenance sentence moved up directly under the Case 1 introduction, with "this animation" → "the first animation".
  - The R2-A left-out sentence was added on the next source line (same paragraph), in the Monte Carlo pattern.
  - The Case 2 introduction now follows, with one added sentence saying that this IVP is not one of the module's examples and is used for comparison with the other ODE pages.
- Check: see the ledger. The closed form was checked numerically (`python3 -I ex7_check.py`).

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| Animations intro, provenance | "...the first animation is reconstructed from the worked-example equations..." | Case 1 IVP = Mathews Ex 1 (`gr_27/28/29`, as confirmed by round-2 review A1). No RKF animation exists in the archive: `grep -ril 'fehlberg\|rkf' a2001/` → nothing; `a2001/Animations/OrdinaryDE/` has Adams1, Euler1, Heun1, MEuler1, Milne1, RungeKutta1, Taylor* only. So the existing "did not include legacy RKF animated GIF portals" is still true. | yes |
| Animations intro | "The module's Examples 6–8" | `grep` of the module HTML: Examples 1–8. Ex 6 solves, Ex 7 compares, Ex 8 DSolve (stripped text of `_lnk_7/8/9`) | yes |
| same | "a second problem, the Riccati equation $y' = t^2 + y^2$" | Statement images `gr_103` (Ex 6), `gr_120` (Ex 7), `gr_144` (Ex 8) and solution code `gr_106` all read $y'=t^2+y^2$. It is Riccati: $y'=q_0(t)+q_1(t)y+q_2(t)y^2$ with $q_0=t^2$, $q_1=0$, $q_2=1$ (the module also calls it a Riccati equation in the Ex 7 statement). It is "second" because Ex 1–5 use $y'=1+y^2$ (`gr_27`, `gr_44`, `gr_56`; Ex 4/5 refer to Ex 1). | yes |
| same | "with the module's RKF45 and RKF54 subroutines (Example 6)" | `gr_15` defines `RKF45[a0_,b0_,α_,ε_]` and `gr_26` defines `RKF54[...]` in the module. Ex 6 code: `gr_108` calls `RKF45[a,b,α,0.000001]` and `gr_114` calls `RKF54[a,b,α,0.000001]`. | yes |
| same | "compare those results with its closed-form Bessel-function solution (Example 7)" | Ex 7 statement says "compare it with the solutions that were found in Example 6". `gr_130` shows `Show[graph3, graph1]` (analytic + RKF45). `gr_123`/`gr_124` give $y=t(8\pi J_{-3/4}(t^2/2)+\sqrt2 J_{3/4}(t^2/2)\Gamma(-1/4)^2)/(-8\pi J_{1/4}(t^2/2)+\sqrt2 J_{-1/4}(t^2/2)\Gamma(-1/4)^2)$. `python3 -I ex7_check.py` → Y(1e-12)=0.50000000000025; max residual $|Y'-(t^2+Y^2)|$ at t=0.1..1.5 = 5.3e-17; max |Y − DOP853(rtol 1e-13)| on [0.01,1.5] = 3.4e-12; Y(1.5)=20.99530804 (Mathews' RKF45 list `gr_119` ends at {1.5, 20.9953}). So it is a genuine closed-form solution of the Ex 6 IVP. | yes |
| same | "and derive that solution with Mathematica's DSolve (Example 8)" | `gr_146`: `DSolve[{y'[t]==t^2+y[t]^2, y[0]==1/2}, y[t], t]`, then FullSimplify; `gr_154` result is identical to `gr_123`. | yes |
| same | "are not animated here" | The page has 2 cases: Case 1 $y'=1+y^2$, Case 2 $y'=1-t\sqrt[3]{y}$. Folder has only `rungekuttafehlbergaa/bb.{jl,gif}`. | yes |
| Case 2 intro | "...the same IVP shown on the Euler's Method page (in both its forward Euler and modified Euler cases) and on the Runge-Kutta, Taylor Series and Adams-Bashforth-Moulton pages" | F1 check above (`f1_check.txt`). Page titles: "Euler's Method for ODE's", "Runge-Kutta Method", "Taylor Series Method for ODE's", "Adams-Bashforth-Moulton Method". | yes |
| Case 2 intro | "This IVP is not one of the module's examples; it is used here so that this page can be compared with those pages." | The module's examples use only $y'=1+y^2$ (Ex 1–5) and $y'=t^2+y^2$ (Ex 6–8); see the statement images above. | yes |

No numbers were added except the example numbers.

## Scripts and GIFs
- Scripts changed: none. GIFs regenerated: none. The page text change cites no frame or value.
- `git status --short -- pages/numerical-methods/runge-kutta-fehlberg-method` → ` M pages/numerical-methods/runge-kutta-fehlberg-method/index.qmd` only.

## Legacy archive
Consulted: `n2003/RungeKuttaFehlbergMod.html`, its `Links/_lnk_2..9` solution pages, and the images in `rungekuttafehlberg/RungeKuttaFehlbergMod/Images/`.
- Example 1 ($y'=1+y^2$, $y(0)=0.5$, $[0,1.1]$) is what Case 1 reconstructs.
- Examples 2–3 re-solve that problem with NDSolve and DSolve.
- Examples 4–5 measure the errors of the Example 1 RKF45 and RKF54 runs.
- Examples 6–8 treat $y'=t^2+y^2$, $y(0)=0.5$ on $[0,1.5]$: RKF45 and RKF54 runs with tol 1e-6, comparison with the Bessel closed form, and DSolve.
- The Example 1 solution images (`gr_30`–`gr_43`) are missing from this snapshot.
- `a2001/Animations/` has no RKF animation, so the page's "no legacy RKF animated GIF portals" statement stays.
- Case 2 is not from the module. It is kept, and now labelled as such, because it is the shared cross-page IVP.

## Notes
- **Scope of the left-out sentence.** It names Examples 6–8, which concern the second problem and are the subject of F2. Examples 2–5 are left out of the sentence on purpose. They re-solve or measure the error of the Example 1 problem, which Case 1 shows: its exact curve is the DSolve solution of Example 3, and Case 1 quotes RKF45 and RKF54 errors at t = 1.1. The page's errors come from a different step controller from Mathews' (see the round-2 review's notes). Neither NDSolve nor Mathews' own error tables are on the page. If Jason wants every unanimated example named, Examples 2–5 could be added to the sentence ("which re-solve the Example 1 problem with Mathematica's NDSolve and DSolve and measure the errors of its RKF45 and RKF54 runs").
- **Placement.** The R2-A pattern puts the sentence after the source-note sentence. On this page that note is in the Animations intro, not at the end, so the sentence goes there, directly after the (moved) provenance sentence.
- **Euler page.** The F1 wording relies on the Euler page's working-tree state, where its second case is "Modified Euler (midpoint)" under R2-D. The phrase "modified Euler case" holds either way.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: The phrase "Adams-Bashforth-Moulton, Euler, and Modified Euler pages" is gone (diff lines 30-31 removed). It now reads "the same IVP shown on the Euler's Method page (in both its forward Euler and modified Euler cases) and on the Runge-Kutta, Taylor Series and Adams-Bashforth-Moulton pages" (index.qmd 38-40). I checked every page it names, and none of them has changes in the working tree:
  - `eulers-method-for-odes/index.qmd`: IVP $y'=1-t\sqrt[3]{y}$, $y(0)=1$, $0\le t\le5$ at line 30. Case 1 is "Forward Euler step-refinement sweep" (line 42). Case 2 is "Modified Euler (midpoint) step-refinement sweep, same IVP" (line 71). So the "both its forward Euler and modified Euler cases" wording is right, and it also fits the R2-D renaming.
  - `runge-kutta-method/index.qmd`: same IVP on $[0,5]$ (lines 12, 16).
  - `taylor-series-method-for-odes/index.qmd` (title "Taylor Series Method for ODE's"): same IVP, Cases 1 and 2 (lines 12, 16, 24).
  - `adams-bashforth-moulton-method/index.qmd`: same IVP, $0\le t\le5$ (lines 24, 32).
  - There is still no separate Modified Euler page (`ls pages/numerical-methods | grep -i euler` lists only `eulers-method-for-odes`). The new text no longer claims one.

### F2 — resolved
- Evidence, provenance sentence: it now says "the first animation is reconstructed ..." (line 31). It has moved up so that it directly follows the Case 1 / Example 1 introduction (lines 25-28) and comes before the Case 2 introduction (lines 38-44), so it now refers to the right case. The claim itself is still true:
  - `a2001/Animations/` has no RKF animation. `OrdinaryDE/` holds only Adams1, Euler1, Heun1, MEuler1, Milne1, RungeKutta1, Taylor, Taylor1 and Taylor2.
  - `grep -ril fehlberg` over `a2001/Animations` finds nothing.
  - So this is not a stale "legacy GIF missing" note of the kind R2-A covers.
- Evidence, the omitted examples: a new sentence (lines 33-36) says Examples 6–8 are not animated, which follows R2-A ("add one sentence ... saying what was left out"). I checked each part of it against the archive (`RungeKuttaFehlbergMod.html` and `Links/..._lnk_7/8/9.html`, viewing images gr_103–154):
  - "a second problem": the images show that Examples 1–5 all use $y'=1+y^2$, $y(0)=0.5$, $[0,1.1]$ (gr_27–29, 44–46, 56–58; Examples 4/5 are error studies of Example 1). Example 6 is the first different IVP. True.
  - "the Riccati equation $y'=t^2+y^2$": gr_103 is $y'=t^2+y^2$ (gr_104: $y(0)=0.5$; gr_105: $[0,1.5]$), and the Example 7 text says "This D.E. is known to be a Riccati equation." True.
  - "with the module's RKF45 and RKF54 subroutines (Example 6)": `lnk_7` calls `RKF45set = RKF45[a,b,α,0.000001]` (gr_108) and `RKF54set = RKF54[a,b,α,0.000001]` (gr_114), and plots and prints both. True.
  - "compare those results with its closed-form Bessel-function solution (Example 7)": `lnk_8` defines Y[t] as a ratio of BesselJ[±1/4, ±3/4, t²/2] terms with Gamma[-1/4]² (gr_123, 129), then runs Show[graph3, graph1] (RKF45) and Show[graph3, graph2] (RKF54). True.
  - "derive that solution with Mathematica's DSolve (Example 8)": `lnk_9` runs `DSolve[{y'[t]==t^2+y[t]^2, y[0]==1/2}, y[t], t]` and then Simplify/FullSimplify. The last line is the same Bessel ratio (gr_146–154). True.
  - I recomputed the closed form myself (mpmath, 30 digits). Y(1e-8) = 0.5000000025. The ODE residual is below 1e-26 at t = 0.5, 1, 1.4 and 1.5. Y(1.5) = 20.9953080383, which matches mpmath `odefun` to 12 digits and is close to Mathews' printed RKF54 value of 20.9953 and RKF45 value of 20.9957 (gr_113/119). So the archive's Example 7 formula really is the solution. The page adds no number for this.
- The Case 2 sentence "This IVP is not one of the module's examples; it is used here so that this page can be compared with those pages" (lines 43-44) is true: the module's examples use only $1+y^2$ and $t^2+y^2$. It also answers the finding's first suggested correction.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| l.31 | "the first animation is reconstructed from the worked-example equations ..." | Placed after the Case 1 intro; there is no RKF animation in a2001/Animations | OK |
| l.33 | "Examples 6–8 ... a second problem" | Ex 1–5 all use $1+y^2$ (gr_27–58); Ex 6 is the first new IVP | OK |
| l.33-34 | "the Riccati equation $y'=t^2+y^2$" | gr_103; Ex 7 text "Riccati equation" | OK |
| l.34 | "module's RKF45 and RKF54 subroutines (Example 6)" | gr_108 RKF45[...,0.000001], gr_114 RKF54[...] | OK |
| l.35 | "closed-form Bessel-function solution (Example 7)" | gr_123; residual check by mpmath, Y(1.5)=20.99530804 | OK |
| l.36 | "derive that solution with Mathematica's DSolve (Example 8)" | lnk_9, gr_146–154 | OK |
| l.36 | "are not animated here" | Neither animation uses $t^2+y^2$ (script bb uses $1-t\sqrt[3]{y}$; aa uses $1+y^2$) | OK |
| l.38-40 | Euler (forward and modified cases), Runge-Kutta, Taylor Series, ABM pages carry the IVP | grep of each index.qmd (lines listed under F1) | OK |
| l.41-42 | IVP, $[0,5]$, "fixed-step RK4 at $h=10^{-4}$" (moved, unchanged) | `rungekuttafehlbergbb.jl` l.76 `rk4_reference(f,t0,tf,y0,1e-4)` | OK |
| l.43-44 | "not one of the module's examples; used ... so this page can be compared with those pages" | Module examples are only $1+y^2$ and $t^2+y^2$ | OK |

### New problems
None. This rests on:
- checking every new clause against the archive images and links;
- confirming that all four named pages carry the IVP and the named cases;
- the mpmath check of the closed form.

Two optional style points, which are not defects:
- The sentence at l.33-36 is long: one relative clause carries three verbs. It could be split for readability.
- It names the Riccati ODE without $y(0)=0.5$ on $[0,1.5]$. R2-A does not require these.

### Reproducibility and conventions
- Reproducibility: the fix changes only `index.qmd` (13 insertions, 6 deletions). No script or GIF in the page folder changed (`git status` of the folder), so there was nothing to regenerate.
- Conventions: Description comes before Animations. Each case has a source link and an embed with descriptive alt text (lines 59/61, 78/80). There are no code blocks.
- Other files: the fix diff touches no file outside the page folder. The working tree does have changes on other pages (Chebyshev, Lagrange, Legendre, etc.), but they come from other fixers working in parallel and are not part of this fix.

**Final status:** committed
