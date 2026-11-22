# Fix record: monte-carlo-pi

## R3-D move

- Before: lines 38–39, after the Case 1 embed, at the end of the file.
- After: lines 30–31, in the Animations introduction, after the "Julia source scripts ..." line and before the Case 1 heading.
- Moved with it: the source sentence "No archived animation GIF is available for this topic in the current snapshot, so ... reconstructed from Example 1 of Mathews' Monte Carlo Pi module." (old 38, new 30).
- Wording adjusted: yes. "so this animation is reconstructed" became "so the animation below is reconstructed": "this animation" pointed back at the embed it used to follow, and before Case 1 nothing has been shown yet. "the animation below" matches the intro's "Each animation below".

## Ledger of changed text

- "No archived animation GIF is available ..., so the animation below is reconstructed from Example 1 of Mathews' Monte Carlo Pi module." — adjusted ("this animation" → "the animation below"); checked that the page has exactly one case, so the singular is right, and that the referent is now the Case 1 embed that follows.
- "The module's Examples 2–7, ... are not animated here." — moved, text unchanged.

## Notes

- Round 3 had no findings on this page, so per R3-D the move is the only change. The sentence's list of omitted examples was not re-derived from the archive module; it is the round-2 text that the round-3 review passed.
- The sentence still names examples by number. The R2-A pattern now asks for no numbers, but the R3-D brief for no-finding pages forbids content changes, so the numbers are left as they were (flagged for the director).
- Only `index.qmd` changed; no scripts or GIFs.
- Rendered with `quarto render pages/numerical-methods/monte-carlo-pi/index.qmd`: builds; in the output HTML both sentences come before the Case 1 heading.

## Resolution check (independent checker, not shown this record)

### monte-carlo-pi — resolved
- The passage was moved from after the Case 1 embed to lines 30–31, before `### Case 1`. It appears once.
- One wording change: "so this animation is reconstructed" became "so the animation below is reconstructed". The change is needed because the sentence now comes before the animation. It is true: the page has exactly one case (Case 1, montecarlopiaa.gif). The named examples (Example 1, Examples 2–7) are unchanged.
- Description comes before Animations. Case 1 keeps its source link and embed.
- New problems: none. (The introduction's existing "Each animation below" and "these animations" are plural although the page has one animation. This was already there and the move did not cause it. Minor, not part of R3-D.)

**Final status:** committed
