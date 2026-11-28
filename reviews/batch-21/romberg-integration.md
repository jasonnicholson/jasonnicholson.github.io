# Romberg Integration — batch 21 review, round 1 (overview mode)

SUMMARY: 0 Error, 0 Misleading, 0 Minor

Page: `pages/numerical-methods/romberg-integration/index.qmd` (light-pass batch 21, overview, action *extend*). Evidence: EV=/tmp/claude-1001/-home-jason--claude-spares-spare-0ogoFf/f6c51b48-3d53-4b4d-8872-653429a6389a/scratchpad/work/review-21/romberg-integration. Scratch work is in EV/reviewer/ (chk.py, plus enlarged Mathews formula images m9.png, m10.png, m21.png). I did not run MATLAB or quarto and did not modify the repository. The diff changes no script or GIF (only index.qmd), so the animation is not under review. I looked at the last frame only to cross-check the claims.

Mathews archive: I consulted /home/jason/Desktop/math-fullerton/baseline/mathews/n2003/RombergMod.html as text. The termination formula appears only as images, so I read RombergMod_gr_9/10/21.gif: "|R_{j,j} − R_{j−1,j−1}| < tol", and in the program "Abs[R[[j,j]] − R[[j−1,j−1]]] < tol".

## 1. Findings

None.

One note that I am not counting as a finding: "halving h divides it by about 4^j" assumes the leading coefficient c_j is nonzero. For periodic integrands it is zero, and the error falls much faster. That is better behaviour, not worse, and it is standard textbook phrasing, so a reader is not misled.

## 2. Claim ledger (the diff's + lines and the reworded sentences)

The reference value I is 2.016279719617096327887…, computed with mpmath at 40 digits. Two routes give the same digits: the substituted smooth integral, and a direct 49-piece split of the original. The script's I_ref = 2.0162797196170963 agrees with it.

1. "approximates ∫_a^b f dx by building a lower triangular table from composite trapezoidal sums and taking a diagonal entry as the answer": **confirmed.** It matches the script (R is k×k, filled for j ≤ k) and Mathews.
2. "Row k starts with T_{2^{k−1}} on 2^{k−1} subintervals of width h=(b−a)/2^{k−1}, which uses m=2^{k−1}+1 sample points": **confirmed.** The script uses n = m_seq[k]−1 with m_seq = 2,3,5,…,129, so n = 1,2,4,…,128 = 2^{k−1}.
3. "Halving h keeps every old sample, so a new row costs only the new midpoints": **confirmed** as a property of the method. The script recomputes the full sums, but that changes no value, and the sentence describes the method, not the script.
4. Display math R_{k,1}=T_{2^{k−1}} and R_{k,j}=R_{k,j−1}+(R_{k,j−1}−R_{k−1,j−1})/(4^{j−1}−1), j=2..k: **confirmed.** It is identical to the script's loop and is Mathews' rule. Only the connecting text changed.
5. "As Mathews runs it, the table grows one row at a time until |R_{k,k}−R_{k−1,k−1}|<tol, and R_{k,k} is the estimate": **confirmed** against the archive images above.
6. "For smooth f (f∈C^{2j}[a,b] for column j), the trapezoidal error expands in even powers of h, T_n−I=c_1h²+c_2h⁴+⋯; each extrapolation removes the leading term, so column j has error O(h^{2j}), and halving h divides it by about 4^j": **confirmed** as a general result. Euler–Maclaurin with f∈C^{2j} leaves an O(h^{2j}) remainder that tends to c_j h^{2j}. The hypothesis is stated and the claim is labelled general. See the note above about c_j = 0.
7. "The second column is Simpson's rule and the third is Boole's rule, each on 2^{k−1} subintervals": **confirmed** numerically. For k=4 (8 subintervals of the page's f), my independent composite Simpson sum minus R_{4,2} is 0.0, and my composite Boole sum (weights 7,32,12,32,14,…; factor 2h/45) minus R_{4,3} is 0.0.
8. "This builds a triangular table whose diagonal entries converge quickly for smooth integrands, often outperforming raw trapezoidal refinement…": this is the pre-existing sentence, moved under the new paragraph with its words unchanged. **Confirmed** as a general qualitative claim. The smooth substituted integrand shows it: diagonal error 3.8e-10 against a trapezoid error of order 1e-4 or more.
9. "In Case 1, f(x)=1+e^{−x}sin(8x^{2/3}) has f′ unbounded at x=0": **confirmed.** f′ ≈ (16/3)x^{−1/3} near 0, which agrees with the Animations text.
10. "the error no longer expands in even powers of h, and the extrapolation weights cancel the wrong terms": **confirmed.** The x^{2/3} singularity brings in non-even powers, with h^{5/3} leading. The measured ratios in item 11 show it.
11. "From 64 to 128 subintervals, halving h divides the error of every column by 3.16 to 3.20, close to 2^{5/3}≈3.17": **confirmed.** The error ratios (row 7)/(row 8) by column are 3.1616, 3.2021, 3.1819, 3.1824, 3.1825, 3.1825 and 3.1825 for j=1..7, and 3.1829 for the diagonal R_{7,7}→R_{8,8}. 2^{5/3} = 3.1748.
12. "so R_{8,8} is only about 4.4 times closer to I than R_{8,1}": **confirmed.** |R_{8,1}−I| / |R_{8,8}−I| = 4.3941.
13. "at m=3 and m=5 the diagonal error is larger than the trapezoidal error": **confirmed.** At m=3 it is 0.475 against 0.357; at m=5, 0.463 against 0.214. The last frame's table shows the same values (R[k,1] 2.372927/1.802071, R[k,k] 2.491261/1.553155).
14. "After the substitution x=t³, the integrand 3t²(1+e^{−t³}sin 8t²) on [0,∛2] is smooth": **confirmed.** dx = 3t² dt, x^{2/3} = t², x=2 ↔ t=2^{1/3}, and the integrand is entire. Its integral equals I to 40 digits.
15. "the same 129 sample points give an R_{8,8} within 4×10⁻¹⁰ of I": **confirmed.** |G_{8,8}−I| = 3.83e-10 (8 rows means 129 points).
16. The "Where it fits" sentence (Romberg = Richardson Extrapolation applied to the Trapezoidal Rule; Gauss-Legendre and Adaptive Simpson are alternatives that place or refine nodes): **confirmed.**
17. Heading id `{#case-1}` added to the Case 1 heading, and the Description's link `[Case 1](#case-1)`: **confirmed.** The id is explicit and matches the link. This is the allowed cross-reference edit.
18. Links ../simpsons-rule-for-numerical-integration/, ../booles-rule/, ../richardson-extrapolation/, ../trapezoidal-rule-for-numerical-integration/, ../gauss-legendre-quadrature/ and ../adaptive-simpsons-rule/: **confirmed.** Each folder has an index.qmd.

## 3. Checks

**Six points of the overview standard:**
1. Problem: present (the first sentence).
2. Core formula: present, as display math in the page's notation (R_{k,j}, T, h, m, I, the same as the table and annotations in the GIF).
3. What it assumes: present (f∈C^{2j}[a,b] for column j).
4. How accurate it is: present (O(h^{2j}), factor about 4^j, labelled general, with its hypothesis).
5. When it fails or misleads: present. Non-smooth f, linked to Case 1, with numbers computed from that case, plus the coarse-row failure and the cure.
6. Where it fits: present, as one sentence with four links (Simpson and Boole are also linked in the body).

Nothing the standard excludes is present: no proofs, no theorem boxes, no Mathematica or MATLAB code, no worked-example table.

**Word count:** 329 words of prose by my own count (inline math counted as 1, display math excluded). This matches the manifest's 329 and is within 150–400.

**Consistency with the rest of the page:** the Description's Case 1 numbers (3.16–3.20, 2^{5/3}, factor 4.4, the m=3 and m=5 behaviour, 129 points) agree with the Behavior paragraph (diagonal ratio about 3.18, factor about 4.4, R_{8,8}=2.016007, error 2.7e-4, diagonal least accurate at m=3 and 5) and with the last frame's table. I found no contradiction.

**Diff scope:** outside the Description, the only change is the `{#case-1}` id on the Case 1 heading, which is allowed. Inside the Description, the old sentence "Romberg integration accelerates composite trapezoidal approximations with Richardson extrapolation" and the bridge "then higher columns are formed by" were reworded. That is new text, and I checked it above (items 1–4). The other old sentences remain with their words unchanged, apart from the added clause "and halving h divides it by about 4^j" (item 6).

**Markup:** I judged it from the source. `\sqrt[3]{2}`, `\text{tol}`, `\left(\right)` and the `$$` blocks are all valid KaTeX.

**Script and GIF:** neither is changed by the diff, so I did not review them. As a cross-check, my independent Romberg table (mpmath) reproduces every R[k,1], R[k,k] and error shown in frame_009 to the displayed digits.
