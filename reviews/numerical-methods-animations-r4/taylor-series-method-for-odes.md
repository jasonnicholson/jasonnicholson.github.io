# Taylor Series Method for ODE's — animation review (round 4)

Page: `pages/numerical-methods/taylor-series-method-for-odes/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1: Page match, Minor. The stated mechanism for Mathews' differing values is not reproduced

- **Location:** `index.qmd` line 18, Case 1 Behavior: "…where Mathews' derivative formulas replace each $y^{k/3}$ by $\operatorname{sign}(y)\,|y|^{k/3}$, which for even $k$ and $y<0$ has the opposite sign to $(\sqrt[3]{y})^k$, so his frames show different values (for example $y(5)=0.1766603$ at $m=12$)." The same claim is repeated at line 26, Case 2: "where his derivative formulas (as in Case 1) differ from the real cube root…".
- **What is there now:** a specific claim about how Mathews' code handled $y^{k/3}$ for negative $y$. It is offered as the cause of his different $y(5)$ for order 3, m = 12 and 14, and for order 4, m = 12 to 28.
- **What I found:** I implemented the stated rule, replacing $y^{k/3}$ by $\operatorname{sign}(y)|y|^{k/3}$, in the two natural forms of the derivatives:
  - fully expanded into monomials $t^a y^{k/3}$;
  - the script's nested form, with $y^{-2/3}$ and $y^{-5/3}$ multiplying $y'$ and $y''$.

  Neither form reproduces Mathews' printed values:

  | case | Mathews (legacy frame) | sign rule, expanded | sign rule, nested | real cbrt (page/script) |
  |---|---|---|---|---|
  | order 3, m=12 | 0.1766603 | −0.0155424 | 0.2110644 | −4.4676549 |
  | order 3, m=14 | −3.4636068 | −2.5022195 | −97.3489870 | −109.0749263 |
  | order 4, m=20 | 0.0711898 | 0.0337018 | — | −5.2535013 |
  | order 4, m=16 | −554.44545 | 509.6130667 | — | −7665.8734003 |

  Other variants also failed: |y|^{k/3}, the real part of the principal complex power, complex arithmetic throughout, and taking the real part of each step (`review/signvariant*.py`, `review/variant4.py`). None gives 0.1766603. The underlying statement is correct: Mathews' values differ only for runs that go negative before t = 5, and the real cube root gives different values there. I confirmed this for every case; see the ledger. The specific sign(y)|y|^{k/3} mechanism, however, is asserted without support, and my reconstruction of it contradicts it.
- **How I know:** `/usr/bin/python3 review/signvariant.py`, `review/signvariant2.py`, `review/signvariant3.py`, `review/variant4.py`. The legacy values come from `review/crop_aa/all.png` and `review/crop_bb/all.png`.
- **Suggested correction:** drop the mechanism and keep the verifiable statement. For example: "…the exceptions are m = 12 and 14, whose runs go negative before t = 5. There Mathews' frames use a different (unreproduced) treatment of $y^{1/3}$ for negative $y$ and show different values (for example $y(5)=0.1766603$ at $m=12$)." Make the same change in Case 2.

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `taylorderivativeaa.jl` | 0 | 11.8 | taylorderivativeaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `taylorderivativebb.jl` | 0 | 9.0 | taylorderivativebb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `taylorderivativeaa.gif` | 21 | byte-identical | taylorderivativeaa |
| `taylorderivativebb.gif` | 21 | byte-identical | taylorderivativebb |

### Page references

- Scripts linked: `taylorderivativeaa.jl`, `taylorderivativebb.jl`
- GIFs embedded: 2
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

Abbreviations: **C** = confirmed, **W** = wrong, **?** = could not determine.

### Introduction (line 12)
| # | Claim | Evidence | Verdict |
|---|---|---|---|
| 1 | IVP is $y'=1-t\sqrt[3]{y}$, $y(0)=1$, on $[0,5]$ | script lines 18–27; frame titles | C |
| 2 | Each frame is a complete run with m subintervals, $h=5/m$ | `taylor3/4(m)`, `h=(T-t0)/m` | C |
| 3 | 21 values m = 12,14,…,150, the same as Mathews' animations | `ms` array; both GIFs have 21 frames; legacy GIFs have the same 21 m labels | C |
| 4 | Drawn over a fine-step reference solution | Same method with 50,000 steps. y(5) = 0.00811992046487 vs mpmath 0.00811992046486796 | C |
| 5 | Labelled with computed y(5) and its error | annotate lines 95–96; frames | C |
| 6 | Points below y = −0.3 are marked by triangles on the bottom edge, and the true minimum is printed | lines 74, 87–89, 99–101; frames m=12/14 (order 3) and m=12–28 (order 4) show the triangles and "min y = … (off scale)" | C |
| 7 | $\sqrt[3]{y}$ is the real cube root | `cbrt` used throughout | C |
| 8 | Derivatives are computed analytically and advanced by a truncated Taylor series, with local accuracy O(h^{p+1}) | Derivatives checked symbolically. One-step error ratio when h is halved: order 3 gives 16.0 (h^4), order 4 gives 32.6 to 36 (h^5) (`review/lte.py`) | C |

### Case 1 (order 3), heading and Behavior (lines 16–18)
| # | Claim | Evidence | Verdict |
|---|---|---|---|
| 9 | Order 3, $m=12$ to $150$ | script | C |
| 10 | Three derivative terms per step | y', y'', y''' (line 22) | C |
| 11 | LTE O(h^4), global O(h^3) | LTE ratio 16.0. Max node error m=60→120: 6.72e−5→7.64e−6, ratio 8.8 | C |
| 12 | Reference rises to about 1.4498 near t = 0.88 | mpmath peak y = 1.4497667 at t = 0.88356; script ref peak 1.449767 at t = 0.8836 | C |
| 13 | Reference y(5) = 0.0081199 | 0.00811992046 | C |
| 14 | m = 12 to 36 visibly leave the reference in the tail | Max node errors 8.6, 109, 0.58, 0.13, 1.2, 0.048, 0.15, 0.15, 0.029; the bumps are visible in the frames (m=24 and m=36 checked individually) | C |
| 15 | y(5) ≈ −4.47 (m=12), −109 (m=14) | −4.4676549, −109.0749263 | C |
| 16 | m=20: 0.0068 at t=4, 1.22 at t=4.25, ends at 0.0895 | 0.0067951, 1.2162, 0.0895215 | C |
| 17 | From m=40 each run decreases steadily after its peak | No increase after the peak for any m ≥ 40 (`review/stab.py`) | C |
| 18 | From m=40 within 3e−4 at every node | m=40 max 2.50e−4, then decreasing | C |
| 19 | m=100: largest node error 1.3e−5, y(5) error −1.2e−9 | 1.327e−5, −1.186e−9 | C |
| 20 | ∂f/∂y = −t/(3y^{2/3}) reaches −41.3 at t=5 | 41.2554 (max on [0,5], monotone in t) | C |
| 21 | Threshold h ≈ 0.0609 (m ≤ 82); shading for m = 12 to 80 | h* = 0.06091, m* = 82.09; frames m=12–80 shaded, m=90–150 not | C |
| 22 | Order-3 stability limit 2.513 | Root of \|1−z+z²/2−z³/6\|=1: 2.512745 | C |
| 23 | On y'=λy, errors are amplified once h\|λ\| exceeds the limit | Standard property of R(z) on the negative real axis | C |
| 24 | For m=12–48, error at t=5 is larger than at the last node before the shading | True for every m in 12–48 (for example m=48: 4.66e−7 vs 9.19e−8) | C |
| 25 | m=80 shading from t ≈ 4.96 | onset 4.958 | C |
| 26 | m=52–80: \|error in y(5)\| < 3.1e−9 | Max 3.091e−9 (m=56) | C |
| 27 | m=12 shading from t ≈ 3.07 | 3.066 | C |
| 28 | m=90–150 stay below the limit | h·41.26 = 2.29, 2.06, 1.72, 1.38 | C |
| 29 | Mathews' printed y(5) is reproduced for 19 of 21 m; the exceptions are m=12 and 14 | All 19 legacy labels m=16…150 match the script to every printed digit (for example 0.1563161, −0.0401212, 0.0251901, 0.00816, 0.0081204). m=12 and 14 differ | C |
| 30 | m=12 and 14 go negative before t=5 | First negative node at t = 4.167 and 4.643 | C |
| 31 | Cause: Mathews' sign(y)\|y\|^{k/3} formulas | Not reproduced (F1) | ? (F1) |
| 32 | Mathews' m=12 value 0.1766603 | Legacy frame reads 0.1766603 | C |

### Case 1 alt text (line 22)
| # | Claim | Verdict |
|---|---|---|
| 33 | Gray reference peaks near 1.45 at t ≈ 0.88 and decays to 0.0081 | C |
| 34 | m=12–36 leave the reference; m=12 and 14 drop off the bottom; m=20 spikes to 1.22 | C (nodes below −0.3: m=12 has 2, m=14 has 1; no others) |
| 35 | Shading for m=12–80 where h·\|∂f/∂y\| > 2.513 | C |
| 36 | From m=40 on the reference; y(5)=0.0081199 at m=150 | C |

### Case 2 (order 4), heading and Behavior (lines 24–26)
| # | Claim | Evidence | Verdict |
|---|---|---|---|
| 37 | Order 4; four derivative terms, all computed analytically | y'''' closed form equals my sympy total derivative (`indep.py`: "script y'''' matches: True") | C |
| 38 | LTE O(h^5), global O(h^4) | LTE ratio about 32. Max node error m=60→120: 6.72e−6→3.77e−7, ratio 17.9 | C |
| 39 | m=12–32 leave the reference and go negative | Each of m=12,14,16,18,20,24,28,32 has a negative node (first at 4.17, 3.93, 3.75, 4.44, 4.25, 4.58, 4.82, 5.0) | C |
| 40 | y(5) ≈ −7666 (m=16) | −7665.8734 | C |
| 41 | m=20: negative at t=4.25, about −10.4 at t=4.5, y(5) ≈ −5.25 | −0.0465, −10.434, −5.2535 | C |
| 42 | y(5) ≈ −0.081 (m=32) | −0.080651 | C |
| 43 | From m=36 within 2.7e−3 at every node | m=36: 2.651e−3; m=40: 1.36e−3; then smaller | C |
| 44 | m=36 and 40 turn up once near the end, by about 0.0015 and 0.0005 | +0.0015 at t=4.861 (m=36); +0.00055 at t=5 (m=40); one rise each | C |
| 45 | From m=40, error in y(5) falls at every refinement, to 4.8e−12 at m=150 | 1.36e−3, 5.18e−5, 2.55e−6, 2.29e−7, 3.56e−8, 8.2e−9, 7.2e−10, 1.8e−10, 7.4e−11, 3.8e−11, 1.4e−11, 4.76e−12 | C |
| 46 | m=100: max node error 8.0e−7, more than 16 times smaller than order 3's 1.3e−5 | 8.021e−7; ratio 16.5 | C |
| 47 | Threshold h ≈ 0.0675 (m ≤ 74); shading for m=12–70 | h* = 0.06751, m* = 74.06; frames agree | C |
| 48 | Order-4 stability limit 2.785 | 2.785294 | C |
| 49 | For all m=12–70, error at t=5 is larger than at the last node before the shading | True for every m (for example m=70: 7.16e−10 vs 5.50e−10) | C |
| 50 | m=70 shading from t ≈ 4.91; m=12 from t ≈ 3.10 | 4.908; 3.103 | C |
| 51 | m=80–150 stay below the limit | C |
| 52 | Mathews' y(5) is reproduced for m=32–150 | Legacy −0.080651, 0.0081972, 0.0094813, 0.0081717, 0.0081225, 0.0081201, 0.00812, 0.0081199×7 all match | C |
| 53 | m=12–28 go negative before t=5 | See #39 | C |
| 54 | Mathews' m=20 value 0.0711898 | Legacy frame reads 0.0711898 | C |
| 55 | Cause: derivative formulas "as in Case 1" | See F1 | ? (F1) |

### Case 2 alt text (line 30)
| # | Claim | Verdict |
|---|---|---|
| 56 | m=12–32 go negative; m=12–28 drop off the bottom; as low as −7751 at m=16 | C (nodes below −0.3 for m=12–28 only; min −7750.73) |
| 57 | Shading for m=12–70 | C |
| 58 | From m=36 on the reference; y(5) = 0.0081199 at m=150 | C |

### Wiring
| # | Claim | Verdict |
|---|---|---|
| 59 | The Case 1 link and embed are `taylorderivativeaa.jl`/`.gif` (order 3) | C |
| 60 | The Case 2 link and embed are `taylorderivativebb.jl`/`.gif` (order 4) | C |
| 61 | The committed GIFs are what the scripts produce | C (manifest: byte-identical regeneration) |

---

### 3. Implementation checks

### `taylorderivativeaa.jl` (Taylor order 3)
- **Method:** a plain Taylor series method of order 3, $y_{n+1}=y_n+hy'+\tfrac{h^2}{2}y''+\tfrac{h^3}{6}y'''$, with derivatives taken as total derivatives along $y'=f$. With sympy I derived $y''$ and $y'''$ independently, writing $y=c^3$ and $d/dy=(1/3c^2)\,d/dc$. The script's `yd2` and `yd3` are symbolically identical to them (`review/lte.py`: "script yd2 ok: True yd3 ok: True"). Taking $c=\mathrm{cbrt}(y)$ makes the formulas valid for negative y as well, because the derivative of the real cube root is $1/(3c^2)$ on both sides of 0.
- **Numbers:** I instrumented a scratch copy (`review/inst_aa.jl`) and ran an independent Python implementation (`review/indep.py`). y(5) agrees for all 21 m to every printed digit, for example m=12 −4.4676549 vs −4.4676549, m=20 0.0895215 vs 0.0895215, m=100 0.0081199 with error −1.19e−9 vs −1.186e−9. The one-step error ratio when h is halved is 16.0, so the LTE is O(h^4), and the global error ratio is about 8.8. Onset times agree between the script and my brentq onset computed on the mpmath solution, for example m=24: 3.400 vs 3.399 (the script's onset is taken on the 1e−4 reference grid).
- **Reference:** the order-3 run with 50,000 steps gives y(5) = 0.00811992046487. A 30-digit mpmath `odefun` gives 0.00811992046486796. The peak is 1.449767 at 0.8836 against mpmath's 1.4497667 at 0.88356. That is accurate enough for the smallest error displayed (3.7e−10, which agrees with my mpmath-based error of −3.714e−10).
- **Picture:** I viewed the contact sheet and frames 2, 6, 9 and 10 individually. The orange polyline is drawn through the computed nodes and the gray reference underneath. The shading starts at the computed onset and covers m=12–80. Triangles mark only the nodes below −0.3, at their true t, and the printed min y is the true value (−8.597 at 4.58, −109.1 at 5.00). The red endpoint is omitted only when y(5) is off scale. Titles state "h = 5/m" with the right m. The annotation values match the instrumented output. The fixed ylims (−0.3, 1.8) do not hide any feature the page discusses; the off-scale values are flagged and printed.

### `taylorderivativebb.jl` (Taylor order 4)
- **Method:** a plain order-4 Taylor method. `yd4_f` is a hand-simplified closed form, and sympy confirms it equals the total derivative of y''' along f ("script y'''' matches: True"). `yd2_f` and `yd3_f` are the same as in the order-3 script (verified).
- **Numbers:** agree with my implementation to every printed digit for all 21 m, for example m=16 −7665.8734003, m=40 0.0094813, m=150 error +4.76e−12 vs +4.762e−12. The one-step error ratio is about 32, so the LTE is O(h^5), and the global error ratio is 17.9.
- **Reference:** the order-4 run with 50,000 steps gives y(5) = 0.00811992046487, matching mpmath as above.
- **Picture:** I viewed the contact sheet and frames 2, 8, 9 and 10. Same structure as the order-3 animation. Triangles appear for m=12–28 at the right nodes (for example m=14 shows one triangle at t=3.93 and min −0.7376). Shading covers m=12–70. The m=32 endpoint at −0.0807 is drawn in the window. Annotations match the instrumented output.

### Stability-limit computation (both scripts)
`stab_limit()` bisects \|R(z)\|=1 on [−3,−2], giving 2.512745 for order 3 and 2.785294 for order 4. I computed the roots independently with brentq on 1−z+z²/2−z³/6(+z⁴/24) and got 2.5127453 and 2.7852936. The script's `fy` is ∂f/∂y = −t/(3 cbrt(y)²), which is correct. Along the solution, \|∂f/∂y\| increases monotonically to 41.2554 at t=5.

### Legacy fidelity
The archive's two animations are Taylor order 3 and order 4 for $y'=1-t\sqrt[3]{y}$, $y(0)=1$ on [0,5], with the same 21 values of m. The page reproduces both. It differs only where a run goes negative before t=5, and it says so; using the real cube root there is mathematically justified. No archive case is dropped, and there are no Fidelity findings. The one problem is the unsupported explanation of Mathews' arithmetic (F1).

