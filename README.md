# Jason H Nicholson - Personal Website

## Publishing
This repo is source code for jasonhnicholson.com.

To publish the site, assuming no local render cache, run the following command:

```bash
quarto publish gh-pages --no-prompt
```

If publishing second or more time with a cache, run the following which saves the render time:

```bash
quarto publish gh-pages --no-render --no-prompt
```

## Extensions

### rchaput/acronyms

This extension is used for managing acronyms in the site. For more information, see [https://github.com/rchaput/acronyms](https://github.com/rchaput/acronyms) and [https://rchaput.github.io/acronyms/articles/options.html#insert_loa](https://rchaput.github.io/acronyms/articles/options.html#insert_loa)

## Copilot skills

### new-blank-blog-post

This repository includes a custom GitHub Copilot skill for creating a blank Quarto blog post in the correct date-based location.

The skill creates a new file in the format `posts/YYYY/MM/DD-<slug>.qmd`, derives the slug from the supplied title, and adds a minimal front matter plus writing scaffold. The skill definition is stored at [.github/skills/new-blank-blog-post/SKILL.md](.github/skills/new-blank-blog-post/SKILL.md).

Example usage:

```text
Follow instructions in #prompt:SKILL.md with these arguments: title "Sphinx Extension Learning"
```

This produces a file such as `posts/2026/08/21-sphinx-extension-learning.qmd` with the matching title and standard blog post template.

## Procedure to reduce history on gh-pages branch

Use a worktree to reduce the history of the gh-pages branch. This is useful if you have a large number of commits and want to reduce the size of the repository.

```bash
git fetch origin gh-pages
treeHash=$(git rev-parse 'origin/gh-pages^{tree}')
commitHash=$(git commit-tree "$treeHash" -m "Reset gh-pages history")
git push --force origin "$commitHash:refs/heads/gh-pages"
```

PowerShell:

```powershell
git fetch origin gh-pages
$treeHash = git rev-parse 'origin/gh-pages^{tree}'
$commitHash = git commit-tree $treeHash -m "Reset gh-pages history"
git push --force origin "${commitHash}:refs/heads/gh-pages"
```
## Numerical Methods pages

The pages under `pages/numerical-methods/` were built in 2026 from John H. Mathews' Numerical Analysis site, recovered from the Internet Archive.

### Regenerating an animation

Each animated case has its own Julia script next to its GIF in the page folder. The script writes the GIF next to itself (through `@__DIR__`), so running it from any directory overwrites the committed GIF:

```bash
julia pages/numerical-methods/<page>/<script>.jl
```

The GIFs were built with Julia 1.12.2 and the global environment's Plots 1.41.2 and SpecialFunctions 2.7.2 (the scripts also use the standard libraries LinearAlgebra, Printf and Random). Other Plots versions may draw the same frames with slightly different bytes. The GIFs are stored with Git LFS.

### Build history in git

The plans, review reports and Claude skills used to build the section were removed once it was finished. They are all in git history:

- the plans (`plans/`) and the skills (`.github/skills/{animation-page,content-page,review-animations,run-animation-batch}`, with symlinks in `.claude/skills/`) as of commit `f25e39c`;
- the review reports (`reviews/`) as of commit `f25e39c`, removed in `2220e83`.

To look at or bring back any of them:

```bash
git show f25e39c:plans/numerical-methods-light-pass-plan.md
```

```bash
git checkout f25e39c -- plans .github/skills/animation-page .github/skills/content-page .github/skills/review-animations .github/skills/run-animation-batch .claude/skills
```

The skills expect the Mathews archive at `/home/jason/Desktop/math-fullerton/` (see below).

### The Mathews archive

The recovered Mathews site lived in `/home/jason/Desktop/math-fullerton/`, a local git repository (no remote) holding the Wayback Machine download (`baseline/mathews/`: `n2003/` modules, `a2001/Animations/`, `c2003/` complex analysis), the download notes and the `uv` project used to run `waybackup`. It is archived as `math-fullerton.zip` in OneDrive, made without `.venv/` (which `uv sync` rebuilds). Its own `README.md` repeats these instructions. To create the zip:

```bash
cd ~/Desktop && zip -r -q math-fullerton.zip math-fullerton -x 'math-fullerton/.venv/*'
```

To restore it:

1. Download `math-fullerton.zip` from OneDrive.
2. Check it, then unzip it into the Desktop, so that the folder comes back at its old path:

   ```bash
   unzip -t ~/Downloads/math-fullerton.zip
   ```

   ```bash
   unzip ~/Downloads/math-fullerton.zip -d ~/Desktop/
   ```

3. Confirm the history came back:

   ```bash
   git -C ~/Desktop/math-fullerton log --oneline -3
   ```

4. Browse the pages by opening files such as `baseline/mathews/n2003/NewtonSearchMod.html` in a browser; they are static HTML.
5. Only to download more pages from the Wayback Machine: the zip leaves out `.venv/`, so recreate it with `uv sync` in the folder (Python 3.14, `pywaybackup`), then follow `Notes.md` (keep `--delay 6 --workers 1 --no-redirect` to avoid a soft ban).
