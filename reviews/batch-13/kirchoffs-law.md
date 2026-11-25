# Review: Kirchoff's Law (batch 13, text-only)

Page: `pages/numerical-methods/kirchoffs-law.qmd` (224 lines). Module: `n2003/KirchoffMod.html` ("Kirchoff's Law"), example folder `n2003/kirchoff/KirchoffMod/` (7 link pages). The reviewer consulted the archive (module, all 7 link pages, images gr_1, 2, 4, 27, 49, 50, 52, 80, 107, 108, 110, 138). All three worked examples are correct, and systems (3)–(5) match Mathews' equations and figures.

**Findings: 0 Error, 1 Misleading, 4 Minor.** The Misleading finding was confirmed by an independent check.

## Findings

### F1. Page text / Fidelity, Misleading: the sign pattern of system (5) cannot be worked out from anything on the page

*Independent check: **confirmed** (Misleading, low end). Mathews' gr_108 matches (5) term for term; from the enlarged figure gr_107, $i_1$ runs clockwise and $i_2, i_3$ counterclockwise; $r_3$ (loops 1–2) and $r_4$ (loops 1–3) carry both currents the same way (+), $r_5$ (loops 2–3) opposite ways (−). Networks 1 and 2 have every loop clockwise, hence only negative off-diagonals in (3) and (4). With all loops clockwise, Example 3's answer would be (3, −5, −1): the same physical currents.*

- **Location:** lines 163–171, system (5) with $+r_3$, $+r_4$, $-r_5$; rule (1) at lines 15–23; lines 36, 102, 163 introduce each system only as "From the module's …".
- **Now:** no diagrams, no loop orientations, no statement of shared resistors. A reader applying (1) with one orientation expects all off-diagonals negative and will take (5) for a typo.
- **True:** (5) is right for Mathews' figure (reproduced as $BRB^\top$ with the orientations above).
- **Fix:** add the three network diagrams (redrawn), or describe each network's loops in words; for Network #3 say "$i_1$ is taken clockwise and $i_2$, $i_3$ counterclockwise", and that $r_3$ is shared by loops 1–2, $r_4$ by 1–3, $r_5$ by 2–3; add the rule: a resistor shared by loops $j$ and $k$ adds $+r$ to the $(j,k)$ entries when both currents pass through it in the same direction, $-r$ when opposite.

### F2. Page text, Minor (unverified): the term $R\,I$ in definition (1) is ambiguous for shared resistors

- **Location:** lines 17–22. With loop currents, the drop across a shared resistor is $R(i_j \pm i_k)$, which is where every off-diagonal term comes from. **Fix:** "where $I$ is the net current through each resistor (the sum or difference of the loop currents sharing it)", or merge with F1's rule.

### F3. Page text, Minor (unverified): "and the coefficient matrix is nonsingular" is listed as a separate condition

- **Location:** line 213. With one equation per independent loop, $A = BRB^\top$ with $R$ positive diagonal is symmetric positive definite, so always nonsingular (all six archive systems have positive eigenvalues). **Fix:** "With positive resistances and one equation per independent loop, the coefficient matrix is symmetric positive definite, so the currents are always uniquely determined. When resistances differ by orders of magnitude the system can still be ill-conditioned …"

### F4. Fidelity, Minor (unverified): three of Mathews' six examples dropped, including the only one with a negative current

- **Archive (recomputed exactly):** Ex 2 (network 1, all r = 10, $e_1 = 55$): $i = (2, 1/2)$. Ex 4 (network 2): $i = (3/5, 1/4, 1/20)$. Ex 6 (network 3, $r = (1, 2, 4, 3, 1, 5)$, $e = (41, 38)$): $A$ = [[8,4,3],[4,7,−1],[3,−1,9]], $i = (4, 3, -1)$ — the archive's only negative loop current. **Fix:** restore at least Ex 6 with a sentence on what a negative loop current means, or note that one example per network is kept.

### F5. Page text, Minor (unverified): the physicist's name is misspelled

- **Location:** lines 2, 12, 218, "Kirchoff". Gustav Kirchhoff's name is spelled "Kirchhoff"; the page carried Mathews' module-title spelling over. **Fix:** use "Kirchhoff" in the body; the title and slug may stay to match the archive, perhaps with a note.

## Inventory (mechanical checks)

No control characters, no leftover "(Planned)" / "Animation Focus" / legacy stub, no `localhost` link, no code block, no link to a missing target.

## Claim ledger (condensed; 34 entries)

Confirmed: KVL; loop currents give linear systems; definition (1) as a statement (F2); $A\mathbf i = \mathbf b$; Network #1 two loops, system (3) (gr_2, gr_1, both clockwise); Example 1 data (Mathews Ex 1), substituted system, matrix, $(7/10, 1/10)$, both rows; Network #2 three loops, system (4) (gr_50, gr_49); Example 2 data (Mathews Ex 3), substituted system, $(13/10, 3/10, 1/10)$, det 72000, all rows; Network #3 three loops, two sources; system (5) (gr_108; orientation unstated, F1); Example 3 data (Mathews Ex 5), $(3, 5, 1)$, det 83, all rows; the near-singular sensitivity remark; the summary algorithm (run on network 3); markup.

Not confirmed: line 213's separate nonsingularity condition (F3); spelling (F5).

## Checks

Systems built from the symbolic formulas and data only, solved exactly: page Ex 1 (7/10, 1/10), eig 27.64, 72.36; Ex 2 (13/10, 3/10, 1/10), eig 23.54, 40, 76.46; Ex 3 (3, 5, 1), eig 1.649, 6.102, 8.249; dropped Mathews Ex 2, 4, 6 as in F4, all positive definite. Loop systems checked against the figures; $BRB^\top$ for network 3 reproduces (5) symbolically. Nothing undetermined.
