# Richardson Extrapolation — animation review (round 6)

Page: `pages/numerical-methods/richardson-extrapolation/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I found no Error, Misleading or Minor findings.

These are observations that I judged not to be findings, recorded so the clean result can be checked:

- **Case 1 visibility.** From h = 0.12 onward (frames 4 to 9), D3, D5 and f' cannot be told apart at the plot's scale. Only the annotation separates them, and it is correct. The orange D5 line also mostly covers the black f' line in every frame. In frames 1 to 3 the dashed D3 curve visibly departs while D5 sits on f', so the Behavior claim is still visible. I treat this as cosmetic.
- **Case 2 axes.** The axes rescale every frame, and frames 1 to 8 have fractional-decade tick labels such as 10^-0.2. This is cosmetic and does not change any conclusion.
- **Naming of D5.** The page's $D_5(x,h)=(4D_3(x,h/2)-D_3(x,h))/3$ is Mathews' $D_{five}(x,h/2)$: the archive defines $D_{five}(x,h)=(4D_{three}(x,h)-D_{three}(x,2h))/3$. The page states this relabelling explicitly in line 31 ("five-point formula for $f'$ with spacing $h/2$"), so it is a disclosed variant, not a mismatch.
- **Legacy examples the page does not name.** Examples 2, 6 and 7 are not named in the text, but each is covered:
  - Example 2(b) plots $D_{five}(x,0.01)$ and $D_{five}(x,0.1)$ on $[0,\pi]$. These are Case 1's frames at h = 0.02 and h = 0.2.
  - Example 6, the identity, is the Derivation Notes.
  - Example 7 is $(4D_3(1,0.01)-D_3(1,0.02))/3$. This is Case 2's point at h = 0.02, with error 1.477e-10.
  - The only content left out is Example 2(a)'s table at x = 0, 1, 2, 3. I do not consider that a departure that matters.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `richexaa.jl` | 0 | 8.9 | richexaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `richexab.jl` | 0 | 6.8 | richexab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `richexaa.gif` | 9 | byte-identical | richexaa |
| `richexab.gif` | 12 | byte-identical | richexab |

### Page references

- Scripts linked: `richexaa.jl`, `richexab.jl`
- GIFs embedded: 2
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | Description, line 12 | "combines two finite-difference estimates with different step sizes so that the leading truncation term cancels" | The algebra in #6, and e5/h^4 tends to a constant (see #19) | confirmed |
| 2 | line 12 | legacy module presents it as "a refinement of the central three-point derivative for $f(x)=e^{-x}\sin(x)$ over $[0,\pi]$" | Archive images gr_1 to 38: $D_{three}$, $D_{five}$ and the Richardson theorem. Example 1 uses f = e^-x Sin x and $M_5=\max_{0\le x\le\pi}$; Example 2 uses $[0,\pi]$ | confirmed |
| 3 | line 17 | $D_3(x,h)=\frac{f(x+h)-f(x-h)}{2h}$ | Matches the archive's $D_{three}$ (gr_4) and both scripts' `d3` | confirmed |
| 4 | line 23 | $D_5(x,h)=\frac{4D_3(x,h/2)-D_3(x,h)}{3}$ | Both scripts' `d5` (line 13 in richexaa.jl, line 12 in richexab.jl) | confirmed |
| 5 | line 26 | "upgrades ... from $O(h^2)$ to $O(h^4)$ for smooth functions" | At x0 = 1, e3/h^2 = 0.16944 and e5/h^4 = 0.000923 are constant (see #19); for Case 1, see #14 | confirmed |
| 6 | Derivation Notes, lines 53 to 60 | If $D_3=f'+C_2h^2+C_4h^4+\cdots$ then $(4D_3(h/2)-D_3(h))/3=f'+O(h^4)$; "$C_2h^2$ contribution cancels exactly" | Algebra: $4C_2h^2/4-C_2h^2=0$, which leaves $-C_4h^4/4$. Numerically, $C_2=f'''(1)/6=0.169441995$ and $C_4/4=f^{(5)}(1)/480=0.000923281$ (sympy), matching the limits in #19 | confirmed |
| 7 | Animations intro, line 30 | "Each animation ... compares the base central difference with Richardson extrapolation for the legacy test function and interval" | Both scripts use f = e^-x sin x. Case 1 covers [0, π]; Case 2 uses x0 = 1, which lies in [0, π] | confirmed |
| 8 | line 31 | "Case 2 plots the error of the estimate in the legacy module's Example 8" | Example 8 (lnk_9, gr_174) is the five-point f'(1.0) for f = e^-x Sin x. Case 2 plots \|D5(1,h) − f'(1)\| | confirmed |
| 9 | line 31 | "$D_5(x,h)$ is that example's five-point formula for $f'$ with spacing $h/2$" | Over 800 grid points per h, \|D5(x,h) − stencil(x, H = h/2)\| ≤ 4.5e-50 in 50-digit arithmetic. Example 8's H = 0.5 value is reproduced: −0.1114634336 against Mathews' −0.111463434 | confirmed |
| 10 | line 31 | "evaluated here over a different list of step sizes" | Example 8 uses H = {0.5, 0.2, 0.1, 0.05, 0.02, 0.01}. The script uses hs = [0.5 … 0.0015], so H = hs/2 | confirmed |
| 11 | line 32 | Examples 9 to 10 "use five-point central-difference formulas to approximate the second and third derivatives at the same point", and are not animated | gr_195 and gr_216: the d2 and d3 five-point stencils at X = 1.0; there is no script for them | confirmed |
| 12 | line 32 | Examples 8 to 10 draw "the five stencil points with a line, parabola or cubic through the centre point"; not animated | gr_174, gr_175, gr_195, gr_216: g is linear, quadratic and cubic about X, drawn with 5 dots. Neither script draws this | confirmed |
| 13 | line 33 | Examples 1, 3, 4 and 5 "estimate $M_5$ … from a graph of $f^{(5)}$, check the resulting five-point error bound against the actual error, show the bound's $O(h^4)$ scaling, and compare it with the three-point bound" | Archive text and images: Example 1 estimates M5 from a graph (gr_34 to 38). The graph image gr_39 to 56 is missing on disk, but the text says "Graph … estimate". Example 3 checks \|f'−D_five(x,0.01)\| ≤ EB_five[0.01] (gr_95 to 99). Example 4 shows EB_five[h/2] = EB_five[h]/16 (gr_117 to 138). Example 5 compares EB_three with EB_five (gr_139 to 140). The Example 1 text says "third derivative", but its formula images show f^(5), as the page says | confirmed |
| 14 | line 33 | "Case 1 annotates the actual maximum errors instead" | All 9 frame annotations equal my 50-digit max errors to the printed 3 digits (table in §3) | confirmed |
| 15 | Case 1 heading | "profile comparison, $D_3(x,h)$ vs. $D_5(x,h)$" | Frames plot f', D3 and D5 against x on [0, π] | confirmed |
| 16 | Case 1 Behavior | "Both approximations converge as $h$ shrinks" | max\|err D3\| falls monotonically from 8.13e-2 to 3.33e-5, and max\|err D5\| from 5.29e-4 to 8.33e-11 | confirmed |
| 17 | Case 1 Behavior | "the Richardson curve tracks $f'(x)$ much more closely because the dominant $h^2$ error term is canceled" | err5/err3 is 6.5e-3 at h = 0.5 and 2.5e-6 at h = 0.01. Visible in frames 1 to 3; in later frames only the annotation shows it (see observation) | confirmed |
| 18 | Case 1 link, embed and alt text | `richexaa.jl` / `richexaa.gif`; "comparing D3 and Richardson D5 derivative curves against the true derivative over 0 to pi for decreasing h" | The script writes richexaa.gif; hs decreases from 0.5 to 0.01; xlims = (0, π) | confirmed |
| 19 | Case 2 heading | "pointwise convergence at $x_0=1$ on log-log axes" | `x0 = 1.0`, `xaxis=:log, yaxis=:log`; the frame title says "x0 = 1" | confirmed |
| 20 | Case 2 Behavior | "error slope for the three-point formula follows approximately $O(h^2)$" | Float64 e3/h^2 = 0.17031, 0.16981, …, 0.16944. The exact-arithmetic value is the same; the limit is $f'''(1)/6=0.169442$ | confirmed |
| 21 | Case 2 Behavior | "Richardson extrapolation follows approximately $O(h^4)$ before roundoff effects appear" | Float64 e5/h^4 = 8.60e-4 … 9.30e-4 for h from 0.5 to 0.006; the limit is 9.2328e-4. At h = 0.003 and 0.0015 the Float64 errors are 4.26e-14 and 1.29e-14, against true truncation errors of 7.48e-14 and 4.67e-15 (50 digits), so roundoff dominates exactly where the plotted curve leaves the guide in frames 11 and 12 | confirmed |
| 22 | Case 2 link, embed and alt text | `richexab.jl` / `richexab.gif`; "log-log error curves versus h at x0 equals 1 showing second-order and fourth-order convergence trends" | The script writes richexab.gif; the frames show both error curves with O(h^2) and O(h^4) guides | confirmed |
| 23 | Frames: legends and titles | Case 1 legend "D5(x,h) = (4D3(x,h/2)-D3(x,h))/3" with title "h = …"; Case 2 legend "\|D3(1,h)-f'(1)\|" and "\|D5(1,h)-f'(1)\|" | These match the code and the page notation | confirmed |

### 3. Implementation checks

### `richexaa.jl` (Case 1)

**The method is what it claims.** The script runs `d3` as the central three-point difference and `d5 = (4 d3(h/2) − d3(h))/3`, which is Richardson extrapolation of D3 with ratio 2. In 50-digit arithmetic, this is identical to Mathews' five-point stencil with H = h/2: the largest difference is 4.5e-50.

**The numbers are right.** The table sets the instrumented script's output against my independent maxima, computed with mpmath at 50 digits on the same 800-point grid. A finer check (`contmax.py`, step 1e-5 on [0, 0.05]) agrees to 6 digits. The maximum D5 error is at x = 0 for every h.

| h | script err3 | independent | script err5 | independent | annotation |
|---|---|---|---|---|---|
| 0.5 | 0.0812769 | 8.1277e-02 | 5.28527e-04 | 5.2853e-04 | 8.13e-02 / 5.29e-04 |
| 0.32 | 0.0337856 | 3.3786e-02 | 8.79123e-05 | 8.7912e-05 | 3.38e-02 / 8.79e-05 |
| 0.2 | 0.0132801 | 1.3280e-02 | 1.33650e-05 | 1.3365e-05 | 1.33e-02 / 1.34e-05 |
| 0.12 | 4.79308e-03 | 4.7931e-03 | 1.72948e-06 | 1.7295e-06 | 4.79e-03 / 1.73e-06 |
| 0.08 | 2.13197e-03 | 2.1320e-03 | 3.41463e-07 | 3.4146e-07 | 2.13e-03 / 3.41e-07 |
| 0.05 | 8.33125e-04 | 8.3312e-04 | 5.20911e-08 | 5.2091e-08 | 8.33e-04 / 5.21e-08 |
| 0.03 | 2.99973e-04 | 2.9997e-04 | 6.75036e-09 | 6.7504e-09 | 3.00e-04 / 6.75e-09 |
| 0.02 | 1.33328e-04 | 1.3333e-04 | 1.33337e-09 | 1.3334e-09 | 1.33e-04 / 1.33e-09 |
| 0.01 | 3.33330e-05 | 3.3333e-05 | 8.33340e-11 | 8.3334e-11 | 3.33e-05 / 8.33e-11 |

Order checks: from h = 0.02 to 0.01, err3 falls by a factor of 4.00 and err5 by 16.0.

As a cross-check against the legacy module, Mathews' Example 3 prints |f'(0) − D_five(0, 0.01)| = 1.33336e-9 and 2.13354e-8 for D_five(0, 0.02). My values are 1.33337e-9 and 2.13354e-8. The first equals the page's h = 0.02 frame.

**The reference values are right.** fp(x) = e^-x (cos x − sin x). Sympy confirms that d/dx[e^-x sin x] minus this expression simplifies to 0.

**The picture shows what was computed.** I viewed all 9 frames (contact sheet) and frame 1 at full size:
- The curves are f', D3 and D5 evaluated on the same x grid.
- The y-limits (−1, 1.1) contain every plotted value: max D3 = 1.0812 at h = 0.5, and min D5 = −0.2080. Nothing is clipped.
- The title's h equals the frame's h.
- D3 and D5 near x = 0 use f(x − h) with x − h < 0, which is legitimate because f is defined there. The script comment says so, and Mathews' Example 2(b) does the same.

### `richexab.jl` (Case 2)

**The method is what it claims.** It uses the same `d3` and `d5` as Case 1, at x0 = 1.

**The numbers are right.** The instrumented Float64 errors are set against exact-arithmetic errors at 50 digits:

| h | script e3 | exact e3 | script e5 | exact e5 |
|---|---|---|---|---|
| 0.5 | 4.257869e-02 | 4.257869e-02 | 5.375918e-05 | 5.375918e-05 |
| 0.2 | 6.783537e-03 | 6.783537e-03 | 1.461109e-06 | 1.461109e-06 |
| 0.05 | 4.236281e-04 | 4.236281e-04 | 5.766570e-09 | 5.766569e-09 |
| 0.02 | 6.777739e-05 | 6.777739e-05 | 1.477083e-10 | 1.477089e-10 |
| 0.01 | 1.694424e-05 | 1.694424e-05 | 9.238929e-12 | 9.232562e-12 |
| 0.006 | 6.099917e-06 | 6.099917e-06 | 1.205230e-12 | 1.196561e-12 |
| 0.003 | 1.524978e-06 | 1.524978e-06 | 4.259093e-14 | 7.478561e-14 |
| 0.0015 | 3.812445e-07 | 3.812445e-07 | 1.292022e-14 | 4.674109e-15 |

- All 12 values of e3 agree.
- e5 agrees to about 1% down to h = 0.006.
- At h = 0.003 and 0.0015 the Float64 values depart from the truncation error. This is the roundoff the page describes; the roundoff scale is about 2.2e-16 × 0.3 / h.
- The guide constants are c2 = 0.170315 and c4 = 8.6015e-4. Both are anchored at the h = 0.5 point, which is what the code comment says ("near the first data point").

**The reference values are right.** f'(1) = −0.11079376530669926 in closed form. mpmath's numerical differentiation gives the same value, and so does Mathews (−0.110793765).

**The picture shows what was computed.** I viewed all 12 frames:
- Frame k plots the first k values of h, on log-log axes.
- The guides span the plotted range of h.
- In the final frame the D5 curve leaves the h^4 guide at its last two points, matching the computed roundoff.
- There are 12 frames, equal to length(hs).
- There is no clamping or masking.

