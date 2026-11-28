# Euler's Method for ODE's — batch 22 review, round 2 (overview mode)

SUMMARY: 0 Error, 0 Misleading, 0 Minor

Review of `pages/numerical-methods/eulers-method-for-odes/index.qmd`, light-pass batch 22 (r2), overview mode. Evidence folder: /tmp/claude-1001/-home-jason--claude-spares-spare-0ogoFf/f6c51b48-3d53-4b4d-8872-653429a6389a/scratchpad/work/review-22r2/eulers-method-for-odes ; scratch files are in its `reviewer/` subfolder (check.py, mathews_thm.png, mathews_meuler.png, crops.png). I did not run MATLAB or quarto, did not modify the repository, did not run the page's scripts, and did not read anything under `reviews/`. I consulted the Mathews archive (`n2003/Euler'sMethodMod.html` and its formula images gr_18, 20, 22, 23, 28 and 36–41).

## 1. Findings

None.

Two things I looked at and decided are not findings:
- Word count. I count 400 words of prose: inline math counts as 1 word, link text is counted, display math and table rows are not. This matches the manifest and sits exactly on the 400-word upper limit, so it is not a breach.
- Line 42 says "late in the run ∂f/∂y is strongly negative and damps the error made earlier". Line 46 says that for m ≤ 103, h|∂f/∂y| goes above 2 before t = 5, where the error is amplified, not damped. These do not contradict each other. The damping happens before the onset. The example that line 43 attaches to the damping claim is m = 150, where max h|∂f/∂y| = 5/150 · 41.26 = 1.375 < 2, so every factor (|1+z| for Euler; 1+z+z²/2, which lies between 0.5 and 1, for modified Euler) is at most 1. Case 1's Behavior paragraph also says the amplified part stays too small to see for m = 50 to 100.

## 2. Claim ledger (+ lines of the diff)

Independent computation: the reference is scipy DOP853 with rtol 1e-13 and atol 1e-15, using a dense output. My own Euler and midpoint loops are in reviewer/check.py. As a cross-check, a separate RK4 run with 50 000 steps gives y(5) = 0.0081199205.

| # | Claim (page's words, line) | Verdict | Evidence |
|---|---|---|---|
| L1 | IVP y' = f(t,y), y(t0)=y0 on [t0,b]; y_n ≈ y(t_n) at t_n = t0 + nh, m subintervals, h = (b − t0)/m (12–13) | confirmed | Matches the scripts (h = (T − t0)/m, ts = t0 + i·h) and Mathews' algorithm |
| L2 | y_{n+1} = y_n + h f(t_n,y_n), t_{n+1} = t_n + h (16) | confirmed | Matches eulersmethodaa.jl line 28 |
| L3 | Mathews' modified Euler is the explicit midpoint method y_{n+1} = y_n + h f(t_n + h/2, y_n + (h/2) f(t_n,y_n)) (19–23) | confirmed | Matches eulersmethodbb.jl line 30 and Mathews' algorithm image (gr_40) exactly |
| L4 | Mathews' Euler theorem assumes f continuous and Lipschitz in y; his precision theorem assumes y ∈ C²[t0,b] (25) | confirmed | Archive text ("continuous and satisfies a Lipschits condition in the variable y"); image gr_18 = "y(t) ∈ C²[t0, b]" |
| L5 | In general, local truncation error O(h²), global error O(h), so halving h roughly halves the error (26) | confirmed | Archive images gr_20 = O(h²) and gr_22 = \|e_k\| = O(h¹); stated as a general result under those hypotheses; Euler's observed p is 1.01–1.02 (table), 1.007 for m = 150→300 and 1.003 for 300→600 |
| L6 | For smooth enough f, modified Euler's global error is O(h²); halving h divides it by about 4 (27) | confirmed | Mathews (gr_28: "known to be O(h²)"); observed p is 2.09 (150→300) and 2.04 (300→600), giving 2^2.04 ≈ 4.1 |
| L7 | Animated IVP y' = 1 − t∛y, y(0) = 1 on [0,5] with y(5) = 0.0081199 (29) | confirmed | Matches the scripts; y(5) = 0.008119920 (DOP853), 0.0081199205 (RK4 50k) |
| L8 | f is not Lipschitz near y = 0 (30) | confirmed | ∂f/∂y = −t/(3y^{2/3}) is unbounded as y → 0⁺ for t > 0 |
| L9 | The solution never falls below y(5) (30) | confirmed | min of y on [0,5] is 0.008119920 at t = 5.00000; y decreases monotonically after its peak (1.44977 at t = 0.8836) |
| L10 | The table rows are the five finest m that Case 1 and Case 2 share (31) | confirmed | Case 1 ∩ Case 2 m-lists = {20, 40, 60, 70, 80, 90, 100, 120, 150}; the five finest are 80, 90, 100, 120, 150 |
| L11 | p = ln(E_prev/E)/ln(m/m_prev) against the row above (31) | confirmed | This is the correct observed order when E ∝ m^{−p} |
| L12 | p is about 1 for Euler and 2.1 to 2.3 for modified Euler (32) | confirmed | Euler p: 1.016, 1.017, 1.012, 1.011; modified Euler p: 2.257, 2.163, 2.203, 2.142 |
| L13 | Falling to 2.04 from m = 300 to 600 (32) | confirmed | Computed p(300→600) = 2.044 |
| L14 | Row m = 80: h 0.0625, Euler 4.25e-2, ME 6.27e-4 | confirmed | 4.248e-2; 6.2747e-4. Frames: 4.2e-02 and 6.3e-04 |
| L15 | Row m = 90: h 0.05556, 3.77e-2 (p 1.02), 4.81e-4 (p 2.26) | confirmed | 3.769e-2, p 1.016; 4.810e-4, p 2.257. Frames: 3.8e-02 and 4.8e-04 |
| L16 | Row m = 100: h 0.05, 3.39e-2 (1.02), 3.83e-4 (2.16) | confirmed | 3.386e-2, p 1.017; 3.830e-4, p 2.163. Frames: 3.4e-02 and 3.8e-04 |
| L17 | Row m = 120: h 0.04167, 2.82e-2 (1.01), 2.56e-4 (2.20) | confirmed | 2.816e-2, p 1.012; 2.563e-4, p 2.203. Frames: 2.8e-02 and 2.6e-04 |
| L18 | Row m = 150: h 0.03333, 2.25e-2 (1.01), 1.59e-4 (2.14) | confirmed | 2.247e-2, p 1.011; 1.589e-4, p 2.142. Frames: 2.2e-02 and 1.6e-04 |
| L19 | The error at t = 5 alone misleads (Cases 1 and 2); late in the run ∂f/∂y is strongly negative and damps earlier error (42) | confirmed | At m = 150 the end error is about 10⁴ (Euler) and 87 (ME) times smaller than the largest error; max h\|f_y\| at m = 150 is 1.375 < 2. Consistent with the Case 1 and Case 2 Behavior text |
| L20 | At m = 150, Euler's error at t = 5 is −1.7e-6 and modified Euler's is 1.8e-6 (43) | confirmed | −1.72e-6 and +1.82e-6; frames show −1.7e-06 and +1.8e-06 |
| L21 | Euler's largest error is about 140 times larger (43) | confirmed | 2.247e-2 / 1.589e-4 = 141.4 |
| L22 | On y' = λy, each step multiplies the inherited error by 1+z (Euler) or 1+z+z²/2 (ME), z = hλ (45) | confirmed | Exact for the linear test equation: one step of each method maps y to R(z)·y |
| L23 | For real z < 0 both have size ≤ 1 only for −2 ≤ z ≤ 0 (45) | confirmed | \|1+z\| ≤ 1 ⇔ z ∈ [−2,0]; 1+z+z²/2 has minimum 1/2 at z = −1, equals 1 at z = −2 and z = 0, and is > 1 for z < −2 |
| L24 | ∂f/∂y = −t/(3y^{2/3}) reaches −41.3 at t = 5 (46) | confirmed | −41.2554; \|f_y\| along the solution is largest at t = 5 |
| L25 | For m ≤ 103, h\|∂f/∂y\| along the solution exceeds 2 before t = 5, the shaded region (46) | confirmed | Onset t = 4.9495 (m = 100), 4.9818 (102), 4.9978 (103); never for m = 104 or 110. Shading appears up to m = 100 and is absent at m = 120, 140, 150 in the frames |
| L26 | Euler runs for m = 10 to 40 zig-zag and dip below zero although the solution stays positive (Case 1) (47) | confirmed | Run minima are −0.4624, −0.1702, −0.1315, −0.1163, −0.0322, −0.0452, −0.0174 for m = 10 to 40; m = 45 has min +0.0067; the tail increments alternate in sign; the frames agree |
| L27 | ME runs zig-zag for m = 12 to 24 (Case 2) (47) | confirmed | The tails alternate in sign (frames for m = 12, 16, 20); consistent with the Case 2 Behavior text |
| L28 | ME runs turn upward before t = 5 for m = 28 to 60 (Case 2) (47) | confirmed | Rise after the run minimum is 0.350 (m = 28), 0.057 (40), 0.015 (60); 0.0008 at m = 70 and none at m = 80, matching Case 2's "too small to see" |
| L29 | Heun's Method corrects an Euler predictor with the trapezoidal rule and is also of order 2 (49) | confirmed | Standard result; this text was carried over unchanged from the old Description |
| L30 | Links: ../heuns-method/, ../big-o-truncation-error/, ../taylor-series-method-for-odes/, ../runge-kutta-method/, ../runge-kutta-fehlberg-method/, ../predictor-corrector-methods/, ../adams-bashforth-moulton-method/ (49) | confirmed | Each folder exists with an index.qmd |
| L31 | Heading ids {#case-1} and {#case-2} added to the Case 1 and Case 2 headings; links [Case 1](#case-1) and [Case 2](#case-2) (31, 42, 47; diff at lines 66 and 104) | confirmed | Explicit ids match the links, and Case 1 and Case 2 are the right cases (Euler and modified Euler GIFs) |

## 3. Checks (overview mode; the diff changes no script or GIF)

**Six points of the standard:**
1. Problem: present (lines 12–13).
2. Core formula: both methods are given as display math in the page's notation (lines 16 and 22), and they are the formulas the scripts implement.
3. Assumptions: present (line 25, with Mathews' hypotheses; line 30 applies them to the animated problem).
4. Accuracy: present (lines 26–27), stated as general results with their conditions. It is confirmed on the page's own problem by the table and by the p values I recomputed, and it points to Case 1 and Case 2.
5. Failure modes: present. The error at t = 5 is misleading (lines 42–43), and coarse grids are unstable (lines 45–47). Both are linked to the cases and both show in the frames.
6. Where it fits: present (line 49).

**Limits:**
- Prose is 400 words by my count, which is within 150–400 (at the cap).
- The table has 5 rows (at most about six are allowed), uses the page's own problem, and adds what the animations don't show (3 significant figures and observed orders).
- No proofs, no callout boxes, no Mathematica or MATLAB code.

**Scope of the diff:**
- Outside the Description, the only changes are the two heading ids {#case-1} and {#case-2}, which are allowed.
- The Description's earlier sentences were rewritten, not moved out of the Animations introduction; the Animations introduction is unchanged.

**Contradictions with the rest of the page:** none found. The Description's numbers (m ranges, −41.3, m ≤ 103, 140×, 2.2e-2, 1.6e-4, ±1.7/1.8e-6) agree with the Case 1 and Case 2 Behavior paragraphs and alt texts, and with the frames I viewed: both contact sheets, plus the full-size label regions of frames aa 14, 15, 17, 20 and bb 17–21.

**Markup:**
- All math is in valid KaTeX syntax: \Bigl…\Bigr, \sqrt[3]{y}, E_{\text{prev}}, inline $…$ in table cells.
- The table is valid pipe-table syntax with right-aligned columns.

**Fidelity:** the Euler theorem's hypotheses and orders and the modified Euler formula all agree with Mathews' module.
