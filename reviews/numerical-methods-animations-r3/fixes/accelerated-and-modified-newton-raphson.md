# Fix record: accelerated-and-modified-newton-raphson

## R3-D move

- Before: lines 56–57, after the Case 3 embed, at the end of the Animations section.
- After: lines 30–31, in the Animations introduction, after "Julia source scripts that generated these animations are linked under each case." and before the Case 1 heading.
- Moved with it: line 56 (old) / 30 (new), "The three cases reproduce Examples 1(b), 2 and 4 of Mathews' ... module ...", the source sentence naming the examples the animations follow.
- Wording adjusted: none. "The three cases" reads correctly before the cases (the intro already introduces the three methods).

## Ledger of changed text

- "The three cases reproduce Examples 1(b), 2 and 4 ..." — moved, text unchanged.
- "The module's Examples 1(a), 3, 5 and 6, ... are not animated here." — moved, text unchanged.

## Notes

- Round 3 had no findings on this page, so per R3-D the move is the only change. The sentence's list of omitted examples was not re-derived from the archive module; it is the round-2 text that the round-3 review passed.
- The sentence still names examples by number. The R2-A pattern now asks for no numbers, but the R3-D brief for no-finding pages forbids content changes, so the numbers are left as they were (flagged for the director).
- Only `index.qmd` changed; no scripts or GIFs.

## Resolution check (independent checker, not shown this record)

### accelerated-and-modified-newton-raphson — resolved
- The two-sentence passage was removed from after the Case 3 embed and placed after "Julia source scripts ... linked under each case." (lines 30–31), before `### Case 1`. It appears nowhere else.
- Wording is unchanged. "The three cases reproduce ..." reads as a statement about the source in the introduction, which already describes Cases 1–3.
- Description (l.10) comes before Animations (l.24). Cases 1–3 each keep their `[Julia source]` link and GIF embed.
- New problems: none.

**Final status:** committed
