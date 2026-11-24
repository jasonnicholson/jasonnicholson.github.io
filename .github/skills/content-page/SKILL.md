---
name: content-page
description: "Use whenever a numerical-methods page under pages/numerical-methods/ needs its text written or rewritten from the legacy Mathews archive: filling a skeleton page that still has \"(Planned)\" sections, writing the Description and worked examples a page needs before the animation-page skill animates it, or rewriting a text-only page (linear algebra, ODEs, PDEs, optimization, eigenvalues, series, models). Produces QMD pages with KaTeX math, callout-box definitions and theorems, and fully worked examples whose every number is computed and verified. Accepts a list of topic slugs. Not for building animations (use animation-page) or reviewing pages (use review-animations)."
---
You are a specialist at writing mathematical content pages for the jasonhnicholson.com numerical methods Quarto site. Your job is to convert legacy Mathews HTML pages into clean, self-contained Quarto `.qmd` pages with proper KaTeX math, callout-box definitions and theorems, and fully worked examples with verification.

> **Tool names.** This skill was written for VS Code Copilot. In Claude Code, `view_image` is the Read tool, `search_subagent` is the Agent tool, and `manage_todo_list` is the task list.

## Batch Size Guidance

**Aim for 3–5 pages per session.** This is the sweet spot that:
- Stays within the 20-image-per-session `view_image` budget (allocate ~4 images per page for key matrices/formulas)
- Keeps the todo list manageable and lets you verify each page before moving on
- Avoids context overflow for topics with many examples

Pages with only 2–3 simple examples (scalar equations, no large matrices) count as "light" — you can fit 5 light pages. Pages with 4+ examples involving 4×4 or larger matrices count as "heavy" — limit to 3 heavy pages per session.

If the user provides more than 5 pages, **acknowledge the full list, create todos for all of them, and process 3–5 per session**, stopping after that batch and reporting which remain.

## Constraints

- Never put code blocks (Julia, Mathematica, Python) on the page; the site would try to execute them.
- Never leave "Planned" placeholder sections — the page must be complete.
- Never guess matrix entries or formula coefficients — read the images to obtain exact values.
- Never move a flat `<topic>.qmd` to a folder — content pages stay flat; the animation-page skill moves a page when it animates it.
- Modify only the target topic pages.
- Always verify worked examples: substitute the solution back and show a verification table or equation.
- Never run MATLAB. Python (`/usr/bin/python3` with numpy, scipy, sympy, mpmath) and Julia are the tools for checking.

## Accuracy standard

The animation pages built from this archive were reviewed nine times, and almost every error was a plausible number or sentence that nobody computed. The same applies here.

- **Compute every result on the page** — solution vectors, eigenvalues, iterates, errors, integrals — with Python or Julia, and state it only to the precision the computation supports. Do not copy a result from an archive image or from memory without recomputing it; Mathews' numbers are claims too, and where they disagree with the computation the page follows the computation and says so.
- **Check every behaviour word** (converges, diverges, oscillates, monotone, "fast", stable) against the computed sequence, and every quantifier ("every", "always") over the whole range it covers.
- **Attach no textbook result to an example it does not fit** (a convergence order, error bound or stability condition) unless you have checked it for that example; label general statements as general.
- **Keep a claim ledger** outside the repository (the session scratchpad, or `$TMPDIR/content-ledgers/<slug>.md`): every number and behaviour sentence on the page, with the command and output that confirms it. Remove or reword anything you cannot confirm.

## Legacy Source Structure

All legacy module pages live under:
```
/home/jason/Desktop/math-fullerton/baseline/mathews/n2003/
```

For a topic named `FooBar`, the layout is:
```
n2003/FooBarMod.html                        ← top-level module page (theory + example list)
n2003/foobar/FooBarMod/
  Links/
    FooBarMod_lnk_1.html                   ← intro/title page (usually no useful content)
    FooBarMod_lnk_2.html                   ← Example 1 solution
    FooBarMod_lnk_3.html                   ← Example 2 solution
    ...
  Images/
    FooBarMod_gr_N.gif                     ← formula and output images (may be sparse)
```

::: {.callout-warning}
**Images may be missing.** Always `ls .../Images/ | sort -V` before deciding which images to view.
The directory often contains only a fraction of the GIFs referenced in the HTML
(e.g., only gr_1–gr_20 and gr_87+). Do NOT attempt to view images that do not exist.
:::

## Image Classification

Images fall into two classes:

| Class | Typical HEIGHT | Content | Useful? |
|-------|---------------|---------|---------|
| Inline formula | ~17–20 px | Rendered math (subscripts, fractions, Greek letters) | **Yes** — view to read matrix entries and formulas |
| Mathematica output block | ~30–100 px | Full computation output, result matrices | **Yes** — view to confirm what Mathews computed (then recompute it) |
| Graph / plot | ≥ 100 px (typically 178) | Plots of functions, trajectories, iterates | When the example's setup (domain, parameters, initial values) is only shown there |

Use `grep -i "height" .../Links/FooBarMod_lnk_N.html | head -40` to identify image heights before deciding which to view.

## 20-Image View Limit

Images are expensive: VS Code Copilot's `view_image` is limited to 20 per session, and in any host each image costs context. Budget carefully:

1. First try `cat ... | sed 's/<[^>]*>//g' | sed '/^[[:space:]]*$/d'` — plain text often reveals numerical values (scalars, simple fractions) without any image views.
2. Use `grep -B1 -A1 'gr_N.gif' .../Links/FooBarMod_lnk_N.html | sed 's/<[^>]*>//g'` to see surrounding text for context on what a given image contains.
3. View formula-sized images (`HEIGHT ~17–61`) for matrix rows, equation right-hand sides, and solution vectors.
4. Spawn a subagent (`search_subagent` in Copilot, the Agent tool in Claude Code) for a single example when you need more than ~8 images for that example — each subagent has its own image budget.

## Workflow

### Setup (once per session)

1. **Create a todo item for every page** in the requested list using `manage_todo_list`. Use the topic slug as the title.
2. If more than 5 pages were requested, note that you will process the first batch now and list the remaining slugs at the end.

### Per-page loop (repeat for each page)

Mark the current page todo as **in-progress**, then:

1. **Find the legacy source.** Module names do not follow the slug (`lu-factorization` is `LUFactorMod.html`, `triangular-systems-and-back-substitution` is `backsubstitutionmod.html`). Use the module link in the page's "Legacy Animation Inventory (Stub)" if it has one, otherwise search the module titles: `grep -il '<key word>' /home/jason/Desktop/math-fullerton/baseline/mathews/n2003/*[Mm]od.html`. Some topics have no module (Logistic Curve, Power Series); write those from standard sources and say the page has no Mathews original.

2. **Read the top-level module HTML** (`cat .../FooBarMod.html | sed 's/<[^>]*>//g' | sed '/^[[:space:]]*$/d'`) to identify:
   - The topic name and subsections (e.g., back-substitution, forward-substitution, application)
   - How many examples exist
   - The general algorithm formulas (often visible as plain text even without images)

3. **Read each example link HTML** (`lnk_2`, `lnk_3`, …) the same way to extract:
   - The problem statement (what system to solve)
   - Any numeric values visible in plain text

4. **List available images** (`ls .../Images/ | sort -V`) and note the gap between what the HTML references and what actually exists.

5. **View key formula images** (spending at most ~4 image views per page from the session budget) to extract exact matrix entries, vectors, and results:
   - The system matrix image referenced in each example's problem statement
   - Result images showing the solution vector
   - Prioritize images whose HEIGHT is between 38–130 px (contain matrices and results, not just a single symbol)
   - Spawn a `search_subagent` for an individual example if that example alone requires more than 8 image views

6. **Derive all formulas analytically** from the data you have:
   - Compute every solution and intermediate value with Python or Julia before writing it on the page, and record the check in the claim ledger
   - Fill in any missing intermediate steps from first principles

7. **Overwrite the stub `.qmd`** with the complete page (do not create a new file).
   - If the page is in an animation batch of `plans/numerical-methods-animation-plan.md`, open the page with a `## Description` section (1–3 paragraphs: the problem, the method, the core formula) so the animation-page skill can add `## Animations` directly after it.
   - Before removing a "Legacy Animation Inventory (Stub)", make sure its archive paths are recorded in the plan; its `localhost:8000` links are dead on the published site, so they must not stay on the page.

8. **Render the page** with `quarto render pages/numerical-methods/<topic>.qmd` and fix any error.

9. Mark the page todo as **completed** before moving to the next page.

## QMD Page Structure

```markdown
---
title: "<Topic Title>"
bibliography: ../../references.bib   ← adjust depth if page is in a subfolder
---

← [Numerical Methods](./)

Source inspiration: [@mathewsSite].

## <Section 1 — Main Algorithm Topic>

### <Subsection: Background or Definition>

::: {.callout-note appearance="simple"}
## Definition — <Name>
<definition text with KaTeX>
:::

<prose explanation>

$$
<numbered display equation>
\tag{1}
$$

::: {.callout-tip appearance="simple"}
## Theorem — <Name>
<theorem statement>
:::

### Algorithm

<algorithm description with display math>

### Example N — <brief description>

<problem statement with the system in display math>

**Step 1**: ...
$$x_n = ...$$

**Step 2**: ...
$$x_{n-1} = ...$$

...

The solution is
$$\mathbf{x} = (\ldots).$$

**Verification:**

| Row | Left-hand side | Right-hand side |
|-----|---------------|-----------------|
| 1 | <computation> | <b₁> ✓ |
| 2 | ...            | <b₂> ✓ |
...

## <Section 2 — Secondary Algorithm, if present>

...

## Application: <Application Topic>

<context paragraph tying the two algorithms together>

### Example N

...
```

## KaTeX Conventions

- Use `$$...$$` for display math (block equations, systems, matrices).
- Use `$...$` for inline math.
- Number important equations with `\tag{1}`, `\tag{2}`, etc.
- Use `\begin{pmatrix}...\end{pmatrix}` for matrices.
- Use `\mathbf{x}` for solution vectors.
- Use `\checkmark` (renders as ✓) in verification tables.
- Use `\underbrace{...}_{label}` to annotate named matrices in examples.
- Use `\tfrac{}{}` for inline fractions within display math to keep things compact.
- The `\tag` command must appear inside `$$...$$`, not outside.

## Callout Box Usage

| Box | Use for |
|-----|---------|
| `{.callout-note appearance="simple"}` | Definitions |
| `{.callout-tip appearance="simple"}` | Theorems and uniqueness results |
| `{.callout-warning appearance="simple"}` | Cautions, special cases, numerical pitfalls |
| `{.callout-important appearance="simple"}` | Key formulas readers must remember |

## Worked Example Standards

Every worked example must include:

1. **Problem statement** — the system in display math, or the problem description.
2. **Step-by-step solution** — one display equation per step, labeled "**Step 1**:", etc.
3. **Final answer** — boxed in a display equation or clearly stated.
4. **Verification** — confirm the answer in the way that fits the problem: substitute back into a linear system (a table when there are several equations), check the residual of a root or a minimiser, compare an ODE or PDE solution with the exact solution or a high-accuracy reference, or show the error falling at the expected rate as the step shrinks.

If an example has a variant (e.g., part (a) and part (b)), note what changed from the previous case and abbreviate the repeated steps.

## Useful Shell Patterns

```bash
# Strip HTML tags and blank lines
cat /home/jason/Desktop/math-fullerton/baseline/mathews/n2003/<TopicMod>.html \
  | sed 's/<[^>]*>//g' | sed '/^[[:space:]]*$/d'

# List images that actually exist (critical — many are missing)
ls /home/jason/Desktop/math-fullerton/baseline/mathews/n2003/<topic>/<TopicMod>/Images/ | sort -V

# Find image heights in a specific link file
grep -i "height" .../Links/<TopicMod>_lnk_N.html | head -40

# See text context surrounding a specific image reference
grep -B2 -A2 'gr_N.gif' .../Links/<TopicMod>_lnk_N.html | sed 's/<[^>]*>//g'

# List all GIF references in a link file (to know what images are used)
grep -o 'gr_[0-9]*\.gif' .../Links/<TopicMod>_lnk_N.html | sort -V | uniq
```
