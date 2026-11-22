# Verification: rational-approximation

## A1 — confirmed with correction
- What I checked: Ran a copy of the script's fitting code (no plotting) to get the Chebyshev-interpolant coefficients c_ch and the "MinMax" result c_mm. I then wrote my own Remez exchange in mpmath (40 digits) for the true minimax [2/2] approximant of exp on [-1,1], with denominator normalised to b0=1 and the error measured as |(f-R)/f|, the same as the script. I compared signed relative-error extrema for c_ch, c_mm and the true minimax.
- Evidence: verify/copy.jl, verify/remez.py, verify/extrema.py, verify/cmm.txt.
  - True minimax: E* = 8.6797864e-5. It equioscillates exactly at x = -1, -0.8123, -0.3124, 0.3124, 0.8123, 1 with alternating signs (6 = m+n+2 points). Its coefficients are a = (0.99999999623, 0.49978562, 0.08159270), b = (-0.49978563, 0.08159270).
  - Script's c_mm: max rel err 8.8459e-5, which is 1.9% above E*. Its extrema alternate in sign but do not equioscillate: |e| = 8.846, 8.846, 8.441, 8.441, 8.846, 8.844 (×1e-5), min/max = 0.954. The coordinate search left a0 = 1 and b1 exactly unchanged from c_ch.
  - Chebyshev interpolant c_ch: max 8.9419e-5. Extrema are 8.942, 8.763, 8.475, 8.474, 8.764, 8.941 (×1e-5), min/max = 0.948.
  - The "MinMax" step therefore removes only (8.942-8.846)/(8.942-8.680) ≈ 37% of the possible reduction in max error. As de la Vallée Poussin predicts, c_mm's smallest alternating extremum, 8.441e-5, is ≤ E* ≤ 8.846e-5.
- Severity: Misleading is fairer than Error. The page says "MinMax-style" and only claims the step "reduce[s]" the max relative error, which is literally true (8.94e-5 → 8.85e-5). But the frame title "MinMax relative-error search" and line 18's description of a MiniMax construction lead a reader to think frame 3 shows the minimax approximant. It does not: the error is not equioscillating and is about 2% above optimal.
- Correction to the allegation: Two parts are true: the error does not equioscillate, and the max error is larger than the true minimax's. The claim that the "flatter, more uniform profile is not what the script produces" is overstated. c_mm's profile is slightly flatter and more uniform than the Chebyshev one (extremal min/max 0.954 vs 0.948, max 8.85e-5 vs 8.94e-5), just far from equal-ripple. In practice the difference cannot be seen at all because of A2. Minor extra point: frame 3 still plots the Chebyshev nodes as "nodes", but c_mm is not constructed to interpolate them.

## A2 — confirmed
- What I checked: Viewed committed frames 1 and 3 at full size and compared the error magnitudes with ylims=(0.0, 0.01) at rationalapproxaa.jl line 130.
- Evidence: committed/rationalapproxaa/frame_001.png and frame_003.png. The largest errors are 1.59e-4 (equal nodes), 8.94e-5 (Chebyshev) and 8.85e-5 (MinMax). These fill 1.6%, 0.9% and 0.9% of the panel height, a few pixels. All three curves lie flat on the x-axis and look nearly identical. The equioscillation structure, the 2x difference between equal and Chebyshev nodes, and the "flatter" MinMax profile described at lines 32–33 cannot be seen. The only evidence on screen is the max-error number in the top-panel legend.
- Severity: Misleading is fair. The plotted data are correct, but the panel cannot show the comparison the page tells the reader to see. A y-limit of about 2e-4 would show it.
- Correction to the allegation: none (line ~130 is correct).
