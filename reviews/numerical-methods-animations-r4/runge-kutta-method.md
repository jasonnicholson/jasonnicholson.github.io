# Runge-Kutta Method — animation review (round 4)

Page: `pages/numerical-methods/runge-kutta-method/`. Reported findings: **0 Error, 1 Misleading, 0 Minor**.

## Findings

### F1 — Page match, Misleading: the upturn is explained by stability and truncation error, but in every run that turns upward an RK4 stage value goes below y = 0, and the upturn depends on how ∛y is extended to negative y

**Location:** `index.qmd` line 12 ("for smooth $f$ this gives $O(h^5)$ local truncation error…") and line 18, the stability/"What the runs do" explanation, together with the shaded "h·|∂f/∂y| > 2.785 on reference" region that the GIF draws in frames m = 12–70.

**What is there now:** The page puts the linear-stability bound ($h|\partial f/\partial y| > 2.785$ along the reference, drawn as a shaded region) first. It then decomposes the error into "that step's own truncation error" (m = 12–18) and carried error "which that step multiplies by 2.9 to 18.6" (m = 20–56). It also says the bound "concerns small departures from the reference, not the drawn run". Every number in this is correct (see the ledger). But the page never says what actually produces the large one-step error and the amplification factors up to 18.6.

**What is true instead:** In every run m = 12–52, the RK4 stage argument $y_i + k_3$ (where $k_4$ is evaluated) becomes negative. The script's `f` then uses Julia's real `cbrt`, so $f = 1 + t|y|^{1/3} > 1$, a large positive slope. At $y = 0$, $f$ is not smooth, and not even Lipschitz in $y$. In the runs that turn upward, the first negative stage falls at or just after the first upward step. For m = 56–150 no stage goes negative.
- `negstage.py` output (step start t, stage, value): m=12: (2.917, y+k3, −0.121) … 8 negative stages; m=20: (3.25, y+k3, −0.013) … 9; m=36: (4.306, y+k3, −0.0017) … 5; m=52: (4.904, y+k3, −0.0086), 1 stage; m=56, 60, 70, 80: none. The overall minimum stage argument is −1.154 (`minmax.py`).
- The upturn depends on how ∛ is extended to negative arguments (`clip.py`). With $f = 1 - t\,\max(y,0)^{1/3}$ instead of the real cube root, y(5) becomes: m=12: −0.239 (vs 0.588), m=20: 0.0054 (vs 0.289), m=28: 0.0199 (vs 0.111), m=36: 0.0285 (vs 0.0835), m=44: 0.0219 (vs 0.0605), m=52: 0.0213 (vs 0.0377). m=56 is unchanged (0.0099) because it has no negative stage.
- The multiplier 18.6 at m=36 cannot come from the linear stability function: on the real axis near the limit, |R(z)| is only slightly above 1. It comes from the stage crossing zero. The first negative stage of m=36 is in exactly the first upward step (t = 4.306).

A reader sees the shaded "stability" band and the sentence "for smooth $f$ … $O(h^5)$". They will conclude that the tail upturn is RK4 linear instability or ordinary truncation error. In fact it is the method stepping through $y=0$, where $\sqrt[3]{y}$ is singular, and its shape is set by the real-cube-root convention. The page partly disclaims the stability reading ("for m = 12 to 24 the run's own h|∂f/∂y| stays below 2.42"), but it never names the actual cause.

**How I know:** `/usr/bin/python3 -I review/negstage.py`, `review/clip.py` and `review/minmax.py`, with outputs as quoted above.

**Suggested correction:** Add one or two sentences to the Behavior paragraph. For example: "In every run that turns upward (m = 12 to 52), the stage value $y_i+k_3$ at which $k_4$ is evaluated falls below 0, where $\sqrt[3]{y}$ is not differentiable. With the real cube root, $f = 1 + t|y|^{1/3} > 1$ there, which drives the run upward. With $\sqrt[3]{\max(y,0)}$ the m = 20 run would instead end near 0.005." Also state that the script (like Mathews) uses the real cube root for $y<0$. In line 12, qualify "for smooth $f$" by noting that this $f$ is not smooth at $y=0$, which the coarse runs reach. Optionally, reword the shaded-region legend or text so it does not read as the explanation of the upturn.

(Severity rationale: everything stated is true, so this is not an Error. But the most visible behaviour in the animation is attributed by implication to the wrong mechanism.)

No other findings.

---

- **Independent check:** confirmed with correction: every visible upturn (m = 12–52) comes from RK4 stages below y = 0 and depends on how the cube root is extended to y < 0; but m = 56 turns up with no negative stage, and the first upward step for m = 28, 32, 40, 44, 48, 52 has all stages positive (independent checker, allegation only).


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `rungekuttaaa.jl` | 0 | 13.0 | rungekuttaaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `rungekuttaaa.gif` | 21 | byte-identical | rungekuttaaa |

### Page references

- Scripts linked: `rungekuttaaa.jl`
- GIFs embedded: 1
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

Sources: S = script `rungekuttaaa.jl`; P = my independent Python (`indep.py`: own RK4 from the Butcher table, reference by scipy DOP853 at rtol 1e-13, Radau, and mpmath `odefun` Taylor at 30 digits); J = instrumented script copy (`rk_instr.jl`); F = committed frames.

| # | Claim (page wording) | Evidence | Verdict |
|---|---|---|---|
| 1 | IVP $y' = 1 - t\sqrt[3]{y}$, $y(0)=1$ over $[0,5]$ | S lines 11, 13–14; frame titles "y' = 1 - t·y^(1/3), y(0) = 1" | confirmed |
| 2 | "Each frame is a complete RK4 run with $m$ subintervals ($h=5/m$)" | S `rk4(m)`, one per frame; F titles "h = 5/m" | confirmed |
| 3 | "21 values of Mathews' animation, m = 12, 14, …, 150" (exact list) | S line 15 matches the list; the legacy GIF's 21 distinct non-blank frames read m = 12,14,16,18,20,24,28,32,36,40,44,48,52,56,60,70,80,90,100,120,150 (`legacy_labels.png`); committed GIF has 21 frames | confirmed |
| 4 | "drawn over a fine-step reference solution" | S line 38, RK4 with 50 000 steps; J yex5 = 0.00811992046486796; mpmath 0.008119920464867961 (agrees to ~1e-17) | confirmed |
| 5 | "labelled with the computed $y(5)$ and its error" | F annotations y(5), error; values match J and P (row 13 onward) | confirmed |
| 6 | RK4 uses four slopes $k_1..k_4$ and a weighted average | S lines 28–32 = classic RK4 (weights 1,2,2,1)/6; matches my Butcher-table RK4 to 10 digits for all m | confirmed |
| 7 | "for smooth $f$ … $O(h^5)$ local and $O(h^4)$ global error" | Error at t=2 for m=20,40,80,160,320: 4.221e-6, 2.959e-7, 1.924e-8, 1.221e-9, 7.678e-11; ratios 14.3, 15.4, 15.8, 15.9 → order 4. True as stated, but see F1 about "smooth" | confirmed (see F1) |
| 8 | Reference rises from 1 to "about 1.4498 near t=0.88" | P: peak at t = 0.883556, y = 1.449767; J: max(yref) = 1.449767 at 0.8836 | confirmed |
| 9 | "then decays toward the nullcline $y=1/t^3$ (where $y'=0$)" | $y'=0 \iff t y^{1/3}=1 \iff y=1/t^3$; y(5)=0.008120 > 1/125 = 0.008, so y'<0 and the solution sits just above the nullcline | confirmed |
| 10 | Reference $y(5)=0.0081199$ | 0.0081199205 (P, mpmath, J) | confirmed |
| 11 | "For m=12 through 52 the computed curve visibly turns upward before t=5" | Upward steps after the peak (P): m=12:5 … m=48:3, m=52:2 (last dy 0.0267, visible in F frame 13). Every m = 12–52 has ≥2 upward steps | confirmed |
| 12 | y(5) ≈ 0.588 (m=12), 0.289 (m=20), 0.0377 (m=52) | 0.5883471, 0.2891074, 0.0376958 (J = P) | confirmed |
| 13 | "at m=56 it still turns upward on the last step, but only by $8.1\times10^{-4}$ … ends at $y(5)\approx0.0099$" | m=56 has exactly one upward step, t 4.9107→5.0000 (the last), dy = 8.053e-4; y(5) = 0.0098571; F frame 14 shows no visible upturn | confirmed |
| 14 | "The error in y(5) falls at every refinement in the sweep" | |err| strictly decreasing over all 21 m (P "mono" on every row) | confirmed |
| 15 | Errors 3.4e-4 (m=60), 2.8e-5 (m=70), 6.8e-6 (m=80), 1.8e-7 (m=150) | +3.4307e-4, +2.7648e-5, +6.8045e-6, +1.7572e-7 | confirmed |
| 16 | "at m=150 … $y(5)\approx0.0081201$" | 0.0081200962 | confirmed |
| 17 | ∂f/∂y along reference "reaches −41.3 at t=5" | −41.2554; |∂f/∂y| along the reference is maximal at t = 5 | confirmed |
| 18 | RK4 linear stability limit 2.785 | P: root of \|R(z)\|=1 on the negative axis = 2.785294; S bisection 2.7852935634 | confirmed |
| 19 | Exceeded "for steps longer than about h=0.0675 (m≤74; here m=12 to 70)" | h_crit = 2.785294/41.2554 = 0.067513, m_crit = 74.06; onsets exist for m=12…70 and not for m≥80 (J) | confirmed |
| 20 | "(the shaded region in those frames)" | S line 74 vspan [ton, 5]; F frames 1–16 shaded, 17–21 not | confirmed |
| 21 | "m=70: from t≈4.91" | onset 4.9082 (P), 4.9083 (J); F frame 16 "from t ≈ 4.91" | confirmed |
| 22 | "at m=12 it starts at t≈3.10" | 3.1032/3.1033; F frame 1 "≈ 3.10" | confirmed |
| 23 | "For m=80 to 150, h|∂f/∂y| along the reference stays below 2.785 up to t=5" | onset none for 80, 90, 100, 120, 150; F text "< 2.785 up to t = 5" | confirmed |
| 24 | "for m=12 to 24 the run's own h|∂f/∂y| stays below 2.42" | max over the run's grid values: 1.589, 1.316, 1.932, 1.570, 1.996, 2.418 | confirmed (at grid values; the stages are not covered, see F1) |
| 25 | "for m=12 to 18 the upturn begins with one long step that starts before the shaded region (t≈2.92 to 3.33 for m=12)" | First upward step / onset: m=12 2.917→3.333 / 3.103; m=14 2.857 / 3.162; m=16 3.125 / 3.219; m=18 3.056 / 3.278 | confirmed |
| 26 | "94 to 100% of the error just after it (0.168 for m=12) is that step's own truncation error" | Local error from exact start / error after the step: 99.6% (m=12, e=0.16815), 99.9%, 93.7%, 98.0% | confirmed (93.7 rounds to 94) |
| 27 | "For m=20 to 56 the error after the first upward step is mostly error carried … multiplies by 2.9 to 18.6" | Carried fraction ≥ 80% (m=20) and up to 99.7%; multiplier (carried / error before) 5.01, 6.93, 2.91, 5.66, 18.57, 3.57, 4.06, 4.24, 4.06, 3.65 → range 2.91–18.57 | confirmed (mechanism: see F1) |
| 28 | "For m=60 and 70 the bound is crossed but the run does not turn upward" | onsets 4.666 and 4.908; 0 upward steps after the peak | confirmed |
| 29 | Wiring: `[Julia source](rungekuttaaa.jl)`, embed `rungekuttaaa.gif` | Both files present; the script writes this GIF; the manifest shows byte-identical regeneration | confirmed |
| 30 | Alt text: gray reference "peaks near 1.45 at t ≈ 0.88 and decays to 0.0081 at t = 5" | see 8 and 10; F gray70 reference curve | confirmed |
| 31 | Alt text: "For m = 12 to 52 the run visibly turns upward … y(5) = 0.588 for m = 12 (at m = 56 the upturn is too small to see)" | see 11–13 | confirmed |
| 32 | Alt text: "for m = 12 to 70 a shaded region marks where h·|∂f/∂y|, evaluated along the reference solution, exceeds 2.785" | see 19–20 | confirmed |
| 33 | Alt text: "the runs settle onto the reference as m grows, with y(5) = 0.0081201 at m = 150" | see 14 and 16; F frames 17–21 overlay the reference | confirmed |
| 34 | Case heading: "$m = 12$ to $150$ subintervals" | S line 15 | confirmed |
| 35 | Fidelity to Mathews: same ODE, IC, interval, m sequence | Legacy frames: "y' = 1 − t∛y", m sequence identical, and every legacy y(5) label equals the script's value to 7 digits (e.g. 0.5883471, 0.4685529, 0.3876236, …, 0.0081476, 0.0081267, 0.0081227, 0.0081213, 0.0081204, 0.0081201) | confirmed |

---

### 3. Implementation checks — `rungekuttaaa.jl`

**It is the method it claims to be.** Lines 26–33 are the classical 4-stage RK4: c = (0, ½, ½, 1); a21 = ½, a32 = ½, a43 = 1; b = (1, 2, 2, 1)/6. I checked this two independent ways. (a) My own RK4, driven by an explicit Butcher table (`indep.py`), reproduces the script's y(5) to all 10 printed digits for all 21 m. (b) An order check on the smooth part (error at t=2) gives ratios 14.3 → 15.9 under halving, i.e. order 4. The stability-limit routine bisects |R(z)| = 1 with R the RK4 stability polynomial; the result 2.7852936 agrees with brentq (2.785294).

**The numbers are right.** Script (J) vs independent (P) y(5):
m=12 0.5883470625 / 0.5883471; m=20 0.2891074072 / 0.2891074; m=36 0.0834665077 / 0.0834665; m=52 0.0376958174 / 0.0376958; m=56 0.0098570759 / 0.0098571; m=60 0.0084629872 / 0.0084630; m=70 0.0081475680 / 0.0081476; m=80 0.0081267250 / 0.0081267; m=150 0.0081200962 / 0.0081201. All 21 agree. Onset times (J vs P) agree to 1e-4 for all 16 shaded cases. The legacy Mathews frames carry the same 7-digit y(5) values for all 21 m.

**Its reference values are right.** The reference (RK4, 50 000 steps) gives y(5) = 0.00811992046486796. That agrees with scipy DOP853 (rtol 1e-13) = Radau = 0.00811992046487 and with mpmath Taylor `odefun` = 0.008119920464867961. The peak is 1.449767 at t = 0.8836 (brentq on f(t, Y(t)) = 0 gives t = 0.883556). The reference stays positive (min ≈ 0.00812), so ∂f/∂y is finite along it. The code comment on line 18 ("every computed value of every run lies inside (min 0.0081, max 1.4498)") is correct for grid values (`minmax.py`: overall min 0.008120, max 1.449751). Stage values are not covered by that comment and reach −1.154 (F1).

**The picture shows what was computed.** I viewed frames 1 (m=12), 14 (m=56), 16 (m=70) and the contact sheet (m = 12, 16, 20, 28, 36, 44, 52, 60, 80, 100, 150). The magenta polyline with markers is (ts, ys) of the run; the red dot is (5, y(5)); the gray curve is the reference; the shaded band is [onset, 5]. Annotations print y(5) to 7 decimals, the error to 1 significant figure and the onset to 2 decimals, all matching J. The axis window (−0.1..5.1 × −0.05..1.8) contains every grid value of every run, so no clamping or hidden behaviour. 21 frames at fps 1, one per m. The title formula matches the code. The legend wording "on reference" matches what is computed (S line 56 uses tref/yref).

**Additional observation (part of F1):** f is evaluated at negative stage arguments in m = 12–52 (`negstage.py`). Julia `cbrt` returns the real cube root there, and so does Mathews (his values match). This is a legitimate reading of ∛y, but the upturn depends on it (`clip.py`).

