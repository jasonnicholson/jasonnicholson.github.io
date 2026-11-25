# Review round 2: Triangular Systems and Back Substitution (batch 11, text-only)

Page: `pages/numerical-methods/triangular-systems-and-back-substitution.qmd` (after the round-1 fixes). Module: `n2003/backsubstitutionmod.html`, example folder `n2003/backsubstitution/BackSubstitutionMod/`. The reviewer consulted the archive (module, all 5 link pages, images gr_19, 20, 103, 132, 135, 142; solution images gr_21–86 are missing) and did not read earlier rounds' reports.

**Findings: 0 Error, 0 Misleading, 1 Minor** (unverified, as the skill allows for Minor findings).

## Findings

### F1. Fidelity, Minor: Example 1 changes Mathews' system and gives no reason

- **Location:** lines 70–82 (Example 1(a), row 2 `0 & 3 & -2 & -4`) and the note at lines 81–82, "(Mathews' version of this example has second row $(0, -2, 7, -4)$, which gives the integer solution $(3, -4, -1, 2)$; the second row used here differs from his.)"; carried into Example 1(b), lines 115–120.
- **True:** the disclosure is accurate (gr_19: Mathews' system has solution $(3,-4,-1,2)$; gr_20: his 1(b) with $a_{44} = 7$ has $(67/14, 34/21, -1/21, 6/7) \approx (4.7857, 1.6190, -0.0476, 0.8571)$), and the page's own versions are correct. But nothing forces the change, and it trades Mathews' integer answer for fractions.
- **Fix:** restore Mathews' row 2 in both parts and recompute (1(a): $x_4 = 2$, $x_3 = -1$, $x_2 = -4$, $x_1 = 3$; 1(b): $x_4 = 6/7$, $x_3 = -1/21$, $x_2 = 34/21$, $x_1 = 67/14$), dropping the note; or keep the page's system and say why it departs.

(Round 1 kept the page's matrix with a disclosure sentence as the smallest correct option; this round asks for the reason or the original.)

## Inventory (mechanical checks, rerun after the fixes)

No control characters, no leftover "(Planned)" / "Animation Focus" / legacy stub, no `localhost` link, no code block, no link to a missing target.

## Claim ledger (condensed; 47 entries)

Confirmed, apart from F1: both definitions, forms (1) and (2), both theorems with $a_{ii} \ne 0$, the back- and forward-substitution formulas (run as written); Example 1(a) every step, the solution $(47/12, -1/3, -1, 2)$ and all four verification rows; Example 1(b) every step, $(1027/252, -11/9, -1/21, 6/7)$ and its decimals; the callout's "dramatically alter" (qualitatively, for this example); Example 2 (Mathews' system, every step, $(5/3, 23/3, -43/3, 305/6)$, the decimal verification); the Newton form with distinct nodes, the corrected triangularity reason, the system, Example 3's matrix, $\mathbf c = (4, -2, 1/2, 1/12)$, $P(t)$ (equal to sympy's interpolant) and $P(1), P(2), P(4), P(5)$; markup.

## Checks

sympy exact (`check.py`): `back()` and `fwd()` as written on every example, cross-checked with `LUsolve` (zero residuals); Mathews' original 1(a)/(b) solved for F1. Nothing undetermined.
