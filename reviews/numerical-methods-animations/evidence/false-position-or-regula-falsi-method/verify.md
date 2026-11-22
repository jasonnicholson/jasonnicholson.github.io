# Verification: false-position-or-regula-falsi-method

## A1 — confirmed
- What I checked: the real root of x^3 + 4x^2 − 10 to high precision (mpmath findroot + polyroots), and the iterates the script produces.
- Evidence: verify/rf.py -> verify/rf_out.txt. The only real root is x* = 1.365230013414097 (the other two roots are complex, −2.6826 ± 0.3583i). The residual at 1.3688 is f(1.3688) ≈ +0.059, not 0. The committed GIF's last frame (frame 12 on the contact sheet) labels c_12 = 1.365229, which matches the computed value and not 1.3688.
- Severity: fair. The number is simply wrong, from the third decimal on (1.3652 vs 1.3688). The alt text at index.qmd line 23 says "near x=1.37", which rounds correctly from 1.365 and is fine.
- Correction to the allegation: none. Both locations are right (index.qmd line 19 and regulafalsiaa.jl line 6). They should read x* ≈ 1.3652.

## A2 — confirmed
- What I checked: which endpoint gets replaced at each of the 12 iterations, using the script's own update rule.
- Evidence: verify/rf_out.txt. f(−1) = −7 < 0 and f(2) = 14 > 0. Every c_k (0, 0.8333, 1.2088, 1.3241, …, 1.365229) has f(c_k) < 0, so f(a)·f(c) > 0 every time and a ← c. The left endpoint therefore moves from −1 to 0 at the first step and keeps moving after that. b = 2 stays fixed through all 12 iterations. The contact sheet shows the same: the blue bracket dot stays at (2, 14) and the shaded bracket's left edge moves right.
- Severity: fair. The sentence states the opposite of what happens. It also contradicts itself: the same sentence says "keeps replacing a with c while b = 2 holds", which is correct. The alt text at line 23 ("with the right endpoint fixed") is correct and conflicts with the prose.
- Correction to the allegation: none. Only the clause "The left endpoint a = −1 stays fixed throughout" is wrong. The rest of the sentence's mechanism (f(c) < 0, so a is replaced and b = 2 holds) is right.

## A3 — confirmed
- What I checked: endpoint updates for f(x) = x − cos x on [0, 1] over 10 iterations.
- Evidence: verify/rf_out.txt. f(0) = −1 and f(1) = +0.4597. Every c_k (0.68507, 0.73630, 0.73895, …, 0.7390851332) has f(c_k) < 0, so a ← c every time. a moves 0 → 0.685 → 0.736 → … while b = 1 stays fixed. The iterates increase monotonically toward x* = 0.7390851332 from below, so they come from the left. The bracket shrinks only on the left side. Committed frame_010.png (c_9 = 0.739085) shows the bracket as about [0.739, 1] with the fixed dot at (1, 0.46). The root value 0.7391 on line 27 is correct.
- Severity: fair. All three statements are reversed relative to the computation: a fixed (actually b), advancing from the right (actually from the left), shrinking on the right (actually on the left). The alt text at line 31 ("left endpoint fixed at 0 while the right endpoint steps in") and the script comments at regulafalsibb.jl lines 3–4 are wrong in the same way.
- Correction to the allegation: none.
