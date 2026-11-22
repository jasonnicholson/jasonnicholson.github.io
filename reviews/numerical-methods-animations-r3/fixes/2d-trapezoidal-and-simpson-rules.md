# Fix record: 2d-trapezoidal-and-simpson-rules

## R3-D move

- Before: lines 43–47 (hard-wrapped), the last paragraph of the Description.
- After: lines 51–55, in the Animations introduction, after the "Julia source scripts ..." line and before the Case 1 heading.
- Moved with it: the adjacent source sentence "The archived snapshot is incomplete for some intermediate image IDs, so these animations are reconstructed from the available formula and checkpoint assets." (old 43–44, new 51–52), which shared its paragraph.
- Wording adjusted: none. "these animations" reads better in the Animations section than it did in the Description. The Description's "Examples 1–6 of the archived module use" (line 13) stays, as it introduces the integral.

## Ledger of changed text

- "The archived snapshot is incomplete ..., so these animations are reconstructed ..." — moved, text unchanged (line wrapping kept).
- "The module's Example 7, ... is not animated here." — moved, text unchanged (line wrapping kept).

## Notes

- Round 3 had no findings on this page, so per R3-D the move is the only change. The sentence's list of omitted examples was not re-derived from the archive module; it is the round-2 text that the round-3 review passed.
- The sentence still names examples by number. The R2-A pattern now asks for no numbers, but the R3-D brief for no-finding pages forbids content changes, so the numbers are left as they were (flagged for the director).
- Only `index.qmd` changed; no scripts or GIFs.

## Resolution check (independent checker, not shown this record)

### 2d-trapezoidal-and-simpson-rules — resolved
- The passage was moved from the end of the Description section (just before `## Animations`) to lines 51–55, after the Animations introduction and the "Julia source scripts" line, and before `### Case 1`. It appears once.
- Wording and line wrapping are unchanged. "these animations are reconstructed" now sits inside Animations, which fits it better than Description did.
- Description (l.10) comes before Animations (l.43). Cases 1 and 2 keep their source links and embeds.
- New problems: none.

**Final status:** committed
