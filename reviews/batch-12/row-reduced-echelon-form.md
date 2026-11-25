# Review: Row Reduced Echelon Form (batch 12, text-only)

Page: `pages/numerical-methods/row-reduced-echelon-form.qmd` (281 lines). Module: `n2003/EchelonFormMod.html` ("Row Reduce Echelon Form"), example folder `n2003/echelenform/EchelonFormMod/` (6 link pages). The reviewer consulted the archive (module, Links 2–6, images gr_9–11, gr_13, gr_78, gr_133, gr_252, gr_336, gr_337).

**Findings: 1 Error, 1 Misleading, 2 Minor.** Both the Error and the Misleading finding were confirmed by an independent check.

## Findings

### F1. Page text, Error: Example 2 calls a non-RREF matrix "RREF", and its last row is not the RREF row

*Independent check: **confirmed** (Error). `S3 == S3.rref()[0]` is False; the Step 3 matrix breaks the page's own definition (lines 31–32) three ways; the page itself says RREF is unique (lines 37–40), so "RREF contains $[0\ 0\ 0\mid -1]$" is simply false. The inconsistency conclusion and the ranks are right.*

- **Location:** line 197, `| RREF contains row $[0\ 0\ 0\mid -1]$ | contradiction $0=-1$ |`, referring to the matrix after Step 3 (lines 176–182).
- **True:** the Step 3 matrix `[[1,1,-2,1],[0,-1,10,-7],[0,0,0,-1]]` is an echelon form, not RREF (row 2 leads with −1, column 2 has a 1 above that pivot, the last row leads with −1). The RREF of M is `[[1,0,8,0],[0,1,-10,0],[0,0,0,1]]` (pivots in columns 1, 2, 4); its last row is $[0\ 0\ 0\mid 1]$, i.e. 0 = 1. "No solution" still holds.
- **Fix:** either "Echelon form after Step 3 contains row $[0\ 0\ 0\mid -1]$", or add a Step 4 finishing the reduction to the true RREF and read $[0\ 0\ 0\mid 1]$ (and adjust lines 185–189).

### F2. Page text, Misleading: the Gauss-Jordan algorithm (lines 73–78) omits what to do when a column has no usable pivot

*Independent check: **confirmed** (Misleading). Examples 2 (column 3) and 3 (columns 3 and 4) both hit the case; with a skip rule and a current-pivot-row pointer all three reproduce sympy's RREF. Step 3 also never limits the row search to rows at or below the current one: in Example 2's column 3, rows 1 and 2 hold nonzero entries, and swapping one in would destroy the reduction.*

- **Location:** line 74, "Move left to right through pivot columns."; line 75, "For each pivot column, swap rows if needed to get a nonzero pivot."
- **True:** the steps assume a nonzero pivot can always be found; they never say to skip a column with no nonzero entry at or below the current pivot row (keeping the same pivot row), never restrict swaps to rows below, and "pivot columns" is circular (they are known only after the reduction). Run literally, Example 2 restricted to A's columns gives `[[1,0,8,-6],[0,1,-10,7],[0,0,0,-1]]`, not RREF; archive Example 5 fails if one stops at a missing pivot.
- **Fix:** "Keep a current pivot row r (start at row 1). Move left to right through the columns. In each column, look for a nonzero entry in rows r and below. If there is none, go to the next column with r unchanged (it becomes a free-variable column). Otherwise swap that row into row r, scale it so the pivot is 1, eliminate every other entry in the column, and increase r by 1."

### F3. Fidelity, Minor (unverified): archive Examples 4 and 5 dropped, including the only case with a free variable in a middle column

- **Archive:** Ex 4 (gr_252): three copies of $4x_1+3x_2+2x_3=12$, RREF `[[1,3/4,1/2,3],0,0]`, rank 1. Ex 5 (gr_337): 5×5 system, b = (1, 2, −6, 4, −4), RREF `[[1,2,0,0,3,4],[0,0,1,0,0,-1],[0,0,0,1,0,0],0,0]`, pivots in columns 1, 3, 4, rank 3, free $x_2, x_5$ — the point of Mathews' "Free Variables" section (his FreeVariables subroutine, gr_336). Line 273's "nonpivot columns identify free variables immediately" is never shown with non-trailing free columns.
- **Fix:** restore Example 5 under "Free Variables In Practice" ($x_2 = s$, $x_5 = u$, $x_1 = 4 - 2s - 3u$, $x_3 = -1$, $x_4 = 0$); optionally Example 4; or say they are omitted.

### F4. Fidelity, Minor (unverified): rank is used throughout but never defined

- **Location:** lines 42–68, 132, 198, 265. Mathews defines it just before the theorem: "The number of nonzero rows in the reduced row echelon form of a matrix is called the rank". **Fix:** add that definition before "Rank Criteria".

## Inventory (mechanical checks)

No control characters, no leftover "(Planned)" / "Animation Focus" / legacy stub, no `localhost` link, no code block, no link to a missing target.

## Claim ledger (condensed; 42 entries)

Confirmed: augmented matrix (1); the four RREF conditions (Mathews (i)–(iv)); uniqueness of the RREF; rank criteria (2)–(4) (match gr_9–11; complete for m×n over ℝ); line 80 (rank undefined, F4); Example 1's system (gr_13), RREF `[[1,0,0,10],[0,1,0,-13],[0,0,1,-2]]`, $x = (10, -13, -2)$, verification rows 1, −4, −5, unique (det −1); Example 2's system (gr_78), Steps 2 and 3, "0 = −1" read from the echelon form, ranks 2 < 3, no solution; Example 3's system (gr_133), RREF `[[1,0,-10,18],[0,1,8,-13],[0,0,0,0]]`, parametric solution (null space (10, −8, 1)), verification rows 5, −3, 2, ranks 2 < 3; free-variable remarks; summary; markup (`\tag` inside `$$`, `\mid` in tables).

Not confirmed: the algorithm as complete (F2); line 197 (F1); Examples 4–5 and the rank definition (F3, F4).

## Checks

sympy exact: Ex 1 det −1, ranks 3; Ex 2 Step 2 and Step 3 matrices as on the page, true RREF as in F1, det 0, ranks 2 and 3; Ex 3 RREF as on the page, $A\,x(t) = (5, -3, 2)$ for all $t$. The page's algorithm (`gj.py`) under "stop" and "skip" readings: only "skip, over all columns of M" reproduces `rref()` for Examples 1–3 and archive Example 5. Archive Examples 4–5 as in F3. Nothing undetermined.
