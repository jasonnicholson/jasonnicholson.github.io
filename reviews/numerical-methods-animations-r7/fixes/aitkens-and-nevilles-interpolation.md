# Fix record: aitkens-and-nevilles-interpolation

Scratch folder: `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r7fix/aitkens-and-nevilles-interpolation/fix/` (check script `check_f1.py`, archive text `module.txt`).

## Findings

### F1 — Misleading — fixed
- Reproduced: `/usr/bin/python3 -I fix/check_f1.py` builds Neville's and Aitken's tableaux in Mathews' lower-triangular layout (row j, column k, k+1 nodes) at 50 digits, records each entry's node set, and checks every entry against a direct Lagrange evaluation on that node set (max discrepancy 2.1e-50 or less in every run).
  - Example 3 (e^x, nodes 1 + i/4, x̂ = 1.8): 15 entries with k ≥ 1; the 5 diagonal entries (k,k), k = 1..5, agree, and they are exactly the entries whose node sets coincide ({x_0..x_k}); the other 10 differ. Diagonal (both): 2.718282, 5.188877, 5.960761, 6.048454, 6.0497, 6.049643. Last row: Neville 5.71011, 6.04436, 6.04928, 6.04961, 6.04964; Aitken 7.05073, 6.2129, 6.06162, 6.04977, 6.04964. Matches the review.
  - The data column (k = 0) is shared trivially.
  - Case 1 data (cos at kπ/4, x̂ = 0.3, 1.0, 2.9): the diagonal agrees, and so does the off-diagonal entry (4,3) although its node sets differ ({1,2,3,4} vs {0,1,2,4}), because the five cos data lie on a cubic. Linear data 2x + 1: all 15 entries agree. So entries on different node sets differ generically, not always, as the independent check said; the new sentence says "generally differ".
  - The old sentence "The intermediate entries differ" is therefore misleading: the whole diagonal sequence is shared.
- Change: `index.qmd` line 21. Before: "The intermediate entries differ, but both schemes end with the same interpolated value." After: "Entries built on different sets of nodes generally differ, but both schemes compute the interpolant on $x_0,\dots,x_k$ for every $k$, so they produce the same sequence $P_{0,0},P_{0,1},\dots,P_{0,n-1}$ (the diagonal of Mathews' two tableaux) and end with the same interpolated value." This is the review's wording with "generally" added, per the independent-check correction.
- Check: same script output as above. The archive's Example 2 says "The entries on the diagonal are equivalent", and Example 3 says twice "It is easy verify that the entries on the diagonal are the same", which confirms that in Mathews' layout the shared sequence is the diagonal.

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd l.21 | "Entries built on different sets of nodes generally differ" | `check_f1.py` → Ex. 3: 10 of 10 different-node-set entries differ; Case 1 data: 5 of 6 differ ((4,3) coincides); linear data: 0 of 10 differ → "generally" is the right quantifier | yes |
| index.qmd l.21 | "both schemes compute the interpolant on $x_0,\dots,x_k$ for every $k$" | `check_f1.py` → node set of (k,k) is {0..k} in both schemes for every k; entries equal direct Lagrange on that set (≤ 2.1e-50) | yes |
| index.qmd l.21 | "the same sequence $P_{0,0},\dots,P_{0,n-1}$ (the diagonal of Mathews' two tableaux)" | `check_f1.py` → diagonals identical in all 5 runs (Ex. 3: 2.718282 … 6.049643 both); archive lnk_3 and lnk_4 say "entries on the diagonal are the same/equivalent" | yes |
| index.qmd l.21 | "end with the same interpolated value" | unchanged claim; Ex. 3 final 6.049643 both | yes |

## Scripts and GIFs
- No scripts changed and no GIFs regenerated (text-only fix, D7/R7-D).
- `git status --short -- pages/numerical-methods/aitkens-and-nevilles-interpolation` → ` M .../index.qmd` only.

## Legacy archive
Consulted: `n2003/nevillealgorithm/NevilleAlgorithmMod/Links/NevilleAlgorithmMod_lnk_3.html` (Example 2, "The entries on the diagonal are equivalent.") and `NevilleAlgorithmMod_lnk_4.html` (Example 3, "It is easy verify that the entries on the diagonal are the same", for both tableaux). The fixed sentence agrees with the archive; the archive's numeric tableaux are images, so the values were taken from the independent computation.

## Notes
- The page's $P_{i,j}$ notation is Neville's (nodes $x_i..x_j$), so $P_{0,j}$ is the top row in the page's layout and the diagonal in Mathews'. The parenthetical names Mathews' layout explicitly, and this is consistent with Case 2's Behavior ("the top-row entry of Neville's tableau … match the diagonal of Mathews' Neville tableau").
- The shared diagonal assumes both schemes use the same node order, which the Description implies (one list $x_0,\dots,x_{n-1}$). The sentence does not spell this out.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: the diff changes one sentence, `index.qmd` line 21. "The intermediate entries differ, but both schemes end with the same interpolated value" is gone. The new sentence is: "Entries built on different sets of nodes generally differ, but both schemes compute the interpolant on $x_0,\dots,x_k$ for every $k$, so they produce the same sequence $P_{0,0},\dots,P_{0,n-1}$ (the diagonal of Mathews' two tableaux) and end with the same interpolated value."
- My own check is `check/tab.py`. It builds both tableaux in Mathews' lower-triangular layout at 50 digits, with Aitken's recursion as the page describes it (combine the interpolant on $x_0..x_{k-1}$ with the one on $x_0..x_{k-2},x_r$). It checks each diagonal entry against a direct Lagrange evaluation on $x_0..x_r$.
  - Example 3 ($e^x$, $\hat x=1.8$): 5 entries agree, all of them diagonal; 10 differ. The diagonal is 2.718282, 5.188877, 5.960761, 6.048454, 6.0497, 6.049643. The last rows (N 5.71011 … 6.04964; A 7.05073, 6.2129, 6.06162, 6.04977, 6.04964) match the finding.
  - Example 6 ($J_0$): 5 diagonal entries agree and 10 entries differ.
  - "Generally" is the right qualifier. With linear data all 15 entries coincide. With Case 1's symmetric cos nodes at $t=1$, one off-diagonal entry, (4,3), coincides.
  - Mathews' NevilleAlgorithmMod.html says "Aitken's and Neville's methods agree on the diagonal", which matches the parenthetical.
- The notation is consistent with the rest of the page. $P_{0,k}$ is the interpolant on $x_0..x_k$, which is the top row in the page's $P_{i,j}$ indexing and the diagonal in Mathews' layout. Case 2 already says "top-row entry of Neville's tableau … match the diagonal of Mathews' Neville tableau".
- No script or GIF was involved.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd l.21 | "Entries built on different sets of nodes generally differ" | tab.py: Ex3 10/15 differ, Ex6 10/15 differ, linear data 0 differ, cos-symmetric case 1 off-diagonal coincidence | True ("generally" correct) |
| index.qmd l.21 | "both schemes compute the interpolant on $x_0,\dots,x_k$ for every $k$" | Diagonal entries of both tableaux equal Lagrange interpolant on $x_0..x_r$ to 1e-40 (assert) | True |
| index.qmd l.21 | "same sequence $P_{0,0},P_{0,1},\dots,P_{0,n-1}$" | Index range $0..n-1$ matches the $n$-node convention of line 12 and the final value $P_{0,n-1}$ | True |
| index.qmd l.21 | "(the diagonal of Mathews' two tableaux)" | Mathews' layout (row r, column k = nodes x_{r-k}..x_r for Neville; x_0..x_{k-1},x_r for Aitken): entry (r,r) is on x_0..x_r in both; Mathews' text "agree on the diagonal" | True |
| index.qmd l.21 | "end with the same interpolated value" | Ex3 both 6.049643; Ex6 both 0.3399864 | True |

### New problems
None. This rests on:
- the diff touching only line 21;
- the independent 50-digit tableau computation above;
- the sentence being consistent with the unchanged notation and with Case 2's text.

### Reproducibility and conventions
- No script or GIF changed (the diff's status lists only index.qmd), so there was nothing to regenerate.
- The page still has Description before Animations, a Julia source link and a GIF embed with descriptive alt text for each of Case 1 and Case 2, and no code blocks.
- In the page folder, git status shows only index.qmd modified, and `git status` on `.github/` and `references.bib` shows no changes.
- Other modified pages and the untracked `reviews/…-r7/` files in the working tree belong to the parallel round-7 workflow and cannot be attributed to this fix.

**Final status:** committed
