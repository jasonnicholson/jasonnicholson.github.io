# Review: Fibonacci Search (batch 1, round 1)

**Result: 0 Error, 0 Misleading, 1 Minor** (unverified, as the review skill allows for Minor findings). Every number and table cell on the page was checked against the reviewer's own exact-rational and mpmath computation, the frames of all three GIFs, and the legacy archive.

The legacy archive was consulted:
- `FibonacciSearchMod.html` and the solution pages `Links/lnk_2`–`lnk_4`;
- the images: the subroutine (gr_167, gr_242), the Example 1 table (gr_228), and the ten Example 2 graphs (gr_246–264);
- all 31 distinct frames of `a2001/Animations/Optimization/Fibonacci1/Fibonacciaa.gif`.

## Findings

### F1. Minor (picture): the Case 3 split comparison cannot be seen in the zoom panel
- **Where:** the last three frames of `fibonaccicc.gif` (`frame_021`–`023`), drawn by `draw_frame(n-2)` in `fibonaccicc.jl`. The bottom panel's y-range there is `zy = (-0.08ymax, 1.12ymax)`, over a window 1.16(b₁₈ − a₁₈) wide.
- **What the page promises:** line 24 says the bottom panel exists "so the comparison of $f(c_k)$ with $f(d_k)$ stays visible". That holds for every step, k = 0…17, in all three GIFs. The reviewer checked k = 14–17 in Case 3 and k = 26 and 28 in Case 2.
- **What is there now:** in the extra split frame the two points are too close to separate.
  - c′₁₈ = 0.450208295 and d₁₈ = 0.450210122 are 1.83e-6 apart, in a window about 2.1e-4 wide. That is about 4 px.
  - Their heights differ by 1.14e-10, on an axis spanning about 2.6e-8. That is about 1 px.
  - The two blue dots, each about 12 px across, overlap completely.
  - Only the title ("Split with e = 0.01: f(c′) − f(d) = -1.139e-10, keep [a, d]") and the green bar show the result.
- **Why only Minor:** the page text does not claim the split is visible (Case 3 Behavior, line 48, says "only 1.8e-6 to the left"), and the title is correct.
- **Suggested fix:** either add "(the dots overlap; the title gives the sign)" to the Case 3 Behavior paragraph, or zoom the split frame on [c′ − 5(d − c′), d + 5(d − c′)].

## Unresolved

None.

## Inventory (Phase 1)

- **Scripts:** `fibonacciaa.jl`, `fibonaccibb.jl`, `fibonaccicc.jl`.
- **GIFs:** 13, 33 and 23 frames decoded (11, 31 and 21 distinct): 1 start frame, plus 10, 30 and 19 steps, plus one split frame in cc, plus 2 held frames.
- Every file is referenced by the page and no reference is missing. The section index links `fibonacci-search/`.
- All three GIFs regenerate byte-identically from scratch copies.

## Claim ledger (whole page): 93 entries, all confirmed

Entry 10 is confirmed with the F1 caveat. Selected evidence (C = confirmed):

**Description (lines 12–20)**
- The squeeze rule and the evaluation count match script lines 61–81. **C**
- n is the smallest integer with F_n > L/ε. **C**
- r_k = F_{n−1−k}/F_{n−k}, and the last interval is 2L/F_n. **C**
- The final errors are within bound: 5.11e-4 < 6.94e-3, 1.94e-7 < 4.59e-7, and 2.65e-5 < 9.14e-5. **C**

**Animations introduction (lines 24–28)**
- The panels, colours, titles, green bar and first and last frames are as described (frames aa/001–002, bb/030, cc/021). **C**
- No labels clash in any frame. **C**
- The module has two examples and one animation, of Example 2. **C**
- Case 1 uses Mathews' tolerance, from gr_245: `FibonacciSearch[a0, b0, 7.0×10^-3]`. **C**
- Mathews' tie rule (`If[Yc < Yd, …]`) differs from the page's, and no comparison in any run is a tie. The smallest exact |diff| is 8.27e-14. **C**

**Case 1**
- F₁₂ = 144 > 142.857, so there are 10 steps. **C**
- The squeeze pattern: L at k = 0, 2, 4, 5, 8. **C**
- Every bracket contains √10/5. **C**
- p̂ = 91/144 = 0.631944, 5.1109e-4 from p. **C**

**Case 2**
- The legacy GIF has 31 distinct frames: a start frame and 30 steps, so n = 32 and F₃₂ = 2 178 309. **C**
- 1/F₃₂ = 4.5907e-7 and 1/F₃₁ = 7.4279e-7. **C**
- `golden_cmp.py` finds no mismatches between Mathews' 30 six-decimal lists and either Fibonacci n = 32 or a golden ratio search. **C**
- F₂₂/F₃₂ = 0.008131. **C**
- The smallest |diff| is 8.2669e-14, which is 5957 ulp at f(p). **C**
- The Float64 decisions equal the exact ones. **C**
- p̂ = 0.632455725978, 1.9394e-7 from p. **C**
- The width is 9.181e-7. **C**

**Case 3**
- p = 0.450183611295. **C**
- The |diff| for k = 14…17: 4.82e-8, 6.95e-8, 4.26e-9, 1.61e-8. **C**
- p̂ is 2.6511e-5 from p. **C**
- c′ = 0.450208295, 1.827e-6 left of d. **C**
- f(c′) − f(d) = −1.1389e-10. **C**
- The final bracket is 9.1358e-5 long and contains p. **C**

**Derivation, theorem and algorithm (lines 58–181)**
- The algebra was rechecked. **C**
- The ratio list for n = 21. **C**
- r₅ = 0.61803445 and r₆ = 0.61803279. **C**

**Example 1**
- All 19 rows × 9 columns (`tables.py`, 0 mismatches; they also match Mathews' gr_228). **C**
- Every point is a multiple of 1/10946. **C**
- The split values. **C**
- The verification table: f(p) = −0.232465575158, 8.558e-10, f′ values −1.579e-4 and 6.456e-5. **C**

**Example 2**
- All 10 rows × 9 columns. **C**
- f(p) = 0.0952284594984. **C**
- 6.603e-7. **C**
- f′(0.625) = −0.037061 and f′(0.638889) = 0.033051. **C**
- The split gives 0.09522952717, and the bracket is 0.0070833 long, which exceeds 0.007. **C**

**Fibonacci versus golden ratio**
- |r₁₀ − ρ| = 5.6e-5. **C**
- The table entries: 9.3185e-5, 1.0696e-4, 0.87118; 7.0833e-3, 8.1306e-3, 0.87119. **C**
- The ratio range [0.864158, 0.873898] for n ≥ 5, with limit 0.871184. **C**

**Implementation notes**
- The 1e-10 comparison, against √eps = 1.49e-8. **C**
- The Float64 unimodality claim holds on a grid centred on p. It is not robust to the grid offset: 92% of offsets give unimodal at 1e-8 and 0% at 1e-9. **C**

## Implementation checks

The three scripts are identical apart from their parameter blocks (checked with `diff`).

- **`fibonacciaa.jl` (Case 1).**
  - **Method:** textbook Fibonacci search, reusing the surviving point. It uses the page's tie rule.
  - **Numbers:** every a, c, d, b, f(c), f(d) and decision at k = 0…9 equals the exact rational computation to 12 significant figures. For example, at k = 7 the script gives c = 0.631944444444 and f(c) = 0.0952291197808.
  - **Reference:** p = √10/5 = (4/25)^{1/4}.
  - **Frames:** 001, 002 and 011 were checked.
- **`fibonaccibb.jl` (Case 2).**
  - **Numbers:** all 30 steps are within 1e-14 of the exact rationals, and every decision agrees.
  - **Frames:** 030 and 031 were checked. The top panel reproduces Mathews' window (−0.05…1.05 by 0…0.75).
- **`fibonaccicc.jl` (Case 3).**
  - **Method:** the same routine, plus Mathews' split c′ = a + (1/2 − e)(b − a).
  - **Numbers:** all 19 steps and the split values match mpmath. The script's 8-step Newton reference p = 0.450183611295 matches mpmath's 0.450183611294874.
  - **Frames:** 018 and 021 were checked; see F1.

The reviewer's scratch work is in `$WORK/review-batch-1/fibonacci-search/reviewer/` (session scratchpad): `indep.py`, `tables.py`, `golden_cmp.py`, `unimodal_fp.jl` and the instrumented `fib*_instr.jl` and `fib*_chk.jl`.
