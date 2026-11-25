# Review: Projectile Motion (batch 6, round 1)

**Findings: 1 Error (independently confirmed), 0 Misleading, 1 Minor (unverified).**

Legacy archive consulted: `ProjectileMotionMod.html`, Links lnk_2–lnk_9, images 90, 103, 131, 143, 148, 149, 223, 224, 253–260, 273, 280, 281, 287, 300, 307, 308, 330–375 (images 39–87, 377–396 and 398–411 are missing); `a2001/Animations` has no projectile animation. Independent computations: closed forms, mpmath quadrature for model (iv), SciPy DOP853 and Radau with events, an own double-precision RK4.

## Findings

### F1 — Page match (background physics) — Error (confirmed by an independent checker): Millikan's oil drops are put in the quadratic-drag regime

- **Location:** `index.qmd` line 108 ("Vertical motion with air resistance"): "A very slow object in a viscous fluid feels a drag proportional to its speed; faster objects (and Millikan's oil drops, as Mathews notes) are better described by a drag proportional to the square of the speed."
- **True instead:** Millikan's oil drops are the classic case of linear (Stokes) drag, F = 6πηrv; Millikan found the drop radius from Stokes' law, with a Cunningham slip correction that makes the drag *smaller* than Stokes', not a v² term. The page repeats Mathews' own error (his module: "there are examples, such as Millikan's oil drop experiment, when the drag force is proportional to the square of the velocity"), but states it as fact.
- **Evidence:** checker's `check/re.py` (Stokes terminal speed and Reynolds number; air η = 1.82e-5 Pa·s, ρ_air = 1.20, ρ_oil = 900 kg/m³): r = 1 µm gives v_t = 0.108 mm/s and Re = 1.4e-5; r = 0.5–6 µm gives Re from 1.8e-6 to 3.1e-3. Quadratic drag needs Re of order 10³; the Oseen correction 3Re/16 is at most about 6e-4. The reviewer's order-of-magnitude estimate agrees (Re ≈ 1e-5).
- **Fix:** "A very slow or very small object in a viscous fluid (Millikan's oil drops are the classic example) feels a drag proportional to its speed; fast, large objects are better described by a drag proportional to the square of the speed." Add that Mathews' module cites Millikan's drops for quadratic drag, which is backwards.

### F2 — Page match (Example 7 reconstruction) — Minor (unverified): RK4 ends at the data point only with the root finder's full-precision b and V

- **Location:** line 376: "The speeds are shown to two decimals; the computations use the root finder's values. Running Mathews' RK4 with $n = 100$ on $[0, b]$, $b$ the time in the sixth column, ends at the data point to four decimals in every case."
- **True instead:** read literally, b is the four-decimal printed time. With the printed b and full-precision V, the endpoints are (506.5001, −0.0002), (470.0006, −0.0010), (370.0014, 114.9989), (414.9981, 85.0017); with printed V and b, case 4 ends at (415.0026, 85.0060). With full-precision V and b every case ends at the data point to four decimals.
- **Evidence:** `/usr/bin/python3 p7b.py` in the review folder.
- **Fix:** "with $b$ the root finder's time (shown rounded in the sixth column)", or say the endpoint is within 0.01 ft of the data point when the rounded table values are used.

No Fidelity findings.

## Inventory (Phase 1)

3 scripts, 3 GIFs (119 frames for Cases 1 and 2; 89 for Case 3); all run; every GIF byte-identical to what its script produces; every reference resolves.

## Claim ledger (whole page; 139 entries; reviewer's verdicts)

- **Description (1–3):** confirmed (classical RK4; closed forms only for (i)–(iii) in part; g = 32).
- **Animations introduction (4–12):** confirmed (all new; colours from the archive; tops and impacts from closed forms and the 128-bit reference for (iv), whose accuracy was checked against an independent quadrature).
- **Case 1 (13–32):** confirmed: drags 43.95, 25.98, 12 order the tops (6.915 < 7.314 < 7.961 < 9.375); tops 885.0, 984.2, 1131, 1406; each descent longer, each landing slower (−239.8, −194.7, −210.6), short of the terminal velocities; heights at t = 20; error growth and sign changes; (iii) largest before 7.6, (iv) after; halving ratios 16.0–16.1, 4.4–10.3, 1.6–17.9.
- **Case 2 (33–46):** confirmed: top 6.915/885.0; one-formula symmetric, back at 0 at 13.83 with −300, asymptote 19.48; two-piece falls more slowly, lands at 14.90 at −194.7; RK4 within 1.63e-4; 205.1 vs 8.943 at t = 13.8.
- **Case 3 (47–66):** confirmed: frictionless slowest at the top (92.88, 86.61), landing 127.8 (3 ft drop); drag balls climb higher (181.5, 166.0) and peak past the middle; slower than both frictionless balls from 2.325 s; slowest after the top (63.99, 72.55); land at 84.59, 95.51; wrong model 199.7 ft, (541.37, 30.55), lands at 553.27 at 148.8 ft/s > 126.5.
- **No-drag motion (67–72):** confirmed (range, 44.83°, 31.8°, 2812.5 and 2435.70).
- **Vertical models (73–77):** 73 wrong (F1); the rest confirmed (Example 1's FindRoot CND, images lost).
- **Examples 1–4 and the table (78–106):** confirmed (closed forms satisfy their ODEs; all printed values; Mathews' U, Z forms with 5.63355 and 4074.82; Example 4 quadrature; y₃ < y₄ < y₂ everywhere; crossovers at v = 104.86 and 64).
- **Baseball, Examples 5–8 (107–139):** confirmed except 130 (F2) (every table; Example 6's exact solution; Example 7 speeds, times, apexes; Example 8's blow-up at 9.491 and landing speed).

## Implementation checks

- **projectileaa.jl:** classical RK4, h = 0.2; tops, impacts, y(20) and maximum errors identical to the independent run (6.43e-13 vs own 7.16e-13 for (i), both rounding level); (iv) reference accurate to the digits printed; frames 1, 41, 85, 119 checked; off-panel points leave the frame with true values noted.
- **projectilebb.jl:** RK4 on the single |v| equation; every quoted value matches; V, Y, U, Z verified; frame 119 checked.
- **projectilecc.jl:** Mathews' Runge4D on four models; fine-step events agree with DOP853/Radau to every digit; frames checked.
