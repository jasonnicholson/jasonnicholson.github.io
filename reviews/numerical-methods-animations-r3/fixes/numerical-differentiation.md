# Fix record: numerical-differentiation

## R3-D move

- Before: line 42, after the Case 2 embed, before "## Derivation Notes".
- After: line 26, in the Animations introduction, after its only paragraph ("Each animation below shows finite-difference derivative behavior ...") and before the Case 1 heading. The page has no "Julia source scripts ..." line, so it follows the intro's last paragraph.
- Wording adjusted: none. "The module" follows the intro's "from the source module".

## Ledger of changed text

- "The module's forward- and backward-difference formulas ... are not animated here." — moved, text unchanged.

## Notes

- Round 3 had no findings on this page, so per R3-D the move is the only change. The sentence's list of omitted examples was not re-derived from the archive module; it is the round-2 text that the round-3 review passed.
- The sentence still names examples by number. The R2-A pattern now asks for no numbers, but the R3-D brief for no-finding pages forbids content changes, so the numbers are left as they were (flagged for the director).
- Only `index.qmd` changed; no scripts or GIFs.
- The page has no "Julia source scripts that generated these animations are linked under each case." line; not added, since the move is the only change.

## Resolution check (independent checker, not shown this record)

### numerical-differentiation — resolved
- The sentence was moved from after the Case 2 embed to line 26, after "Each animation below shows ..." and before `### Case 1`. It appears once.
- Wording is unchanged and reads as a statement about the module.
- Description comes before Animations. Cases 1 and 2 keep their source links and embeds. Derivation Notes follows unchanged.
- New problems: none. (This page has no "Julia source scripts ... linked under each case" line in its introduction. That was already the case and is outside this fix.)

**Final status:** committed
