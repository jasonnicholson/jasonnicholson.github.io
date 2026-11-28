# The Mathews archive

The recovered copy of John H. Mathews' Cal State Fullerton site lived in `/home/jason/Desktop/math-fullerton/` until 2026-11-28. That folder was then archived to OneDrive as `math-fullerton.tgz` and deleted from the Desktop. It is a local git repository with no remote, and it holds:

- the Wayback Machine download, in `baseline/mathews/`: the `n2003/` numerical analysis modules, `a2001/Animations/` and the `c2003/` complex analysis course;
- the download notes (`Notes.md`). The per-module download log, `ToDo.md`, was deleted before archiving; it is in that repository's history at `33d39c13`;
- the `uv` project used to run `waybackup` (Python 3.14, `pywaybackup`).

The archive's own `README.md` also has restore steps, but they were written for a zip. The steps below are the ones that match the `.tgz`.

## Restoring it

1. Download `math-fullerton.tgz` from OneDrive.
2. List the archive. This tests that it reads cleanly and shows whether its entries start with `math-fullerton/`:

   ```bash
   tar -tzf ~/Downloads/math-fullerton.tgz | head
   ```

3. Extract it into the Desktop, so the folder comes back at its old path. This assumes the entries start with `math-fullerton/`; if they don't, make the folder first and extract into it with `-C ~/Desktop/math-fullerton`.

   ```bash
   tar -xzf ~/Downloads/math-fullerton.tgz -C ~/Desktop/
   ```

4. Confirm the history came back:

   ```bash
   git -C ~/Desktop/math-fullerton log --oneline -3
   ```

   The last commit should be `cbadaf1d` ("Update README for the archive …").
5. Browse the site: the pages are static HTML. Open a file such as `baseline/mathews/n2003/NewtonSearchMod.html` in a browser.
6. Only if you need to download more pages from the Wayback Machine:
   - run `uv sync` in the folder if `.venv/` is missing or broken;
   - follow `Notes.md`, and keep `--delay 6 --workers 1 --no-redirect` to avoid a soft ban.
