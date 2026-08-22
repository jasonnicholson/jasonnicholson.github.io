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

The skill creates a new file in the format `posts/YYYY/MM/YYYY-MM-DD-<slug>.qmd`, derives the slug from the supplied title, and adds a minimal front matter plus writing scaffold. The skill definition is stored at [.github/skills/new-blank-blog-post/SKILL.md](.github/skills/new-blank-blog-post/SKILL.md).

Example usage:

```text
Follow instructions in #prompt:SKILL.md with these arguments: title "Sphinx Extension Learning"
```

This produces a file such as `posts/2026/08/2026-08-21-sphinx-extension-learning.qmd` with the matching title and standard blog post template.

## Procedure to reduce history on gh-pages branch

Use a worktree to reduce the history of the gh-pages branch. This is useful if you have a large number of commits and want to reduce the size of the repository.

```bash
$treeHash = git rev-parse gh-pages^{tree}
$commitHash = git commit-tree $treeHash -m "Reset gh-pages history"
git push origin $commitHash:gh-pages --force
```