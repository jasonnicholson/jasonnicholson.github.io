# The Mathews archive

The recovered copy of John H. Mathews' Cal State Fullerton site lived in `/home/jason/Desktop/math-fullerton/`. It is a local git repository with no remote. It holds:

- the Wayback Machine download, in `baseline/mathews/`: the `n2003/` numerical analysis modules, `a2001/Animations/` and the `c2003/` complex analysis course;
- the download notes (`Notes.md`; the per-module download log `ToDo.md` was deleted before archiving and is in that repository's history at `33d39c13`);
- the `uv` project used to run `waybackup` (Python 3.14, `pywaybackup`).

It is archived as `math-fullerton.zip` in OneDrive. The folder's own `README.md` repeats these instructions, so they travel inside the zip.

## Making the zip

Leave out `.venv/` (57 MB), which `uv sync` rebuilds:

```bash
cd ~/Desktop && zip -r -q math-fullerton.zip math-fullerton -x 'math-fullerton/.venv/*'
```

On 2026-11-28 this made a 138 MB zip. A test restore of it had the full git history.

## Restoring it

1. Download `math-fullerton.zip` from OneDrive.
2. Test the zip:

   ```bash
   unzip -t ~/Downloads/math-fullerton.zip
   ```

3. Unzip it into the Desktop, so the folder comes back at its old path:

   ```bash
   unzip ~/Downloads/math-fullerton.zip -d ~/Desktop/
   ```

4. Confirm the history came back:

   ```bash
   git -C ~/Desktop/math-fullerton log --oneline -3
   ```

5. Browse the site: the pages are static HTML. Open a file such as `baseline/mathews/n2003/NewtonSearchMod.html` in a browser.
6. Only if you need to download more pages from the Wayback Machine:
   - recreate `.venv/` with `uv sync` in the folder;
   - follow `Notes.md`, and keep `--delay 6 --workers 1 --no-redirect` to avoid a soft ban.
