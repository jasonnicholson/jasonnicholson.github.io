# Verification: bisection-method

## A1 — confirmed
- What I checked: computed the real root of f(x)=x³+4x²−10 with mpmath (30 digits) and evaluated f at the claimed value 1.3688.
- Evidence: verify/check.py (`/usr/bin/python3 -I check.py`). Root x* = 1.365230013414097. f(1.3688) = +0.0591 (not a root); f is increasing on [1,2] (f' = 3x²+8x > 0), so this is the only root in [1,2]. 1.3688 is off by 3.6e-3, which is about 15× the final bracket width (2.4e-4) after 12 steps. The script's own last frame shows c_12 = 1.36499 and a final bracket of [1.364990, 1.365234], which contains 1.365230 and does not contain 1.3688. So the page contradicts its own animation. The wrong value appears at index.qmd line 21, in the alt text at line 25 ("x≈1.3688"), and in the header comment at bisectionaa.jl line 3. The correct value is ≈1.3652.
- Severity: Error is fair. The stated numerical value is false, and a reader comparing it to the GIF labels would see that they disagree.
- Correction to the allegation: none. The locations are correct.

## A2 — confirmed
- What I checked: reproduced the script's bisection loop exactly (same update rule, Float64) and checked the sign of successive differences of the midpoints and of c − x*. I also checked the midpoint labels in the committed frames (sheet.png: c_2=1.25, c_4=1.3125, c_6=1.359375, c_8=1.363281, c_10=1.364258, c_12=1.36499), which match the computation.
- Evidence: verify/check.py. The midpoints are 1.5, 1.25, 1.375, 1.3125, 1.34375, 1.359375, 1.3671875, 1.36328125, 1.365234375, 1.3642578125, 1.36474609375, 1.364990234375. The signs of successive differences are [-,+,-,+,+,+,-,+,-,+,+], and c − x* changes sign 6 times (c1, c3, c7 and c9 are above the root; the rest are below). The sequence is neither monotone nor one-sided. It oscillates around the root, and |c − x*| is not monotone either (c9 has error 4.4e-6, then c10 has error 9.7e-4).
- Severity: Error is fair. "Monotonically" is false for this sequence. What does hold is that the bracket width halves each step, so |c_n − x*| ≤ (b0 − a0)/2^n.
- Correction to the allegation: none.
