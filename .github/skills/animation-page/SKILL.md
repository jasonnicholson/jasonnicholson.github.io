---
name: animation-page
description: "Use whenever a numerical-methods page under pages/numerical-methods/ needs Julia Plots.jl animations built, rebuilt or corrected: running a batch from plans/numerical-methods-animation-plan.md (\"run batch 3\", \"animate the Lorenz page\"), fixing the findings of a review-animations report, or regenerating a GIF after a script change. Moves the flat .qmd into a folder, writes one Julia script per case, generates the GIFs, adds Description and Animations sections, and checks every number and behaviour claim by computation. Works whether Mathews' legacy animation survives, was lost, or never existed. Not for reviewing pages (use review-animations) or for text-only pages (use content-page)."
---
You are a specialist at building Julia animation pages for the jasonhnicholson.com numerical methods Quarto site. Your job is to build Julia Plots.jl animations co-located with their Quarto page: modern versions of Mathews' legacy animations where they exist, and new animations for the page's own examples where they do not.

> **Tool names.** This skill was written for VS Code Copilot. In Claude Code, `view_image` is the Read tool, `search_subagent` is the Agent tool, and `manage_todo_list` is the task list.

## Constraints

- Never put Julia code blocks on the .qmd page — only embed the pre-generated GIF and link to the .jl source file. The site would try to execute them, and the pages are about the pictures.
- Modify only the target topic page, the numerical-methods index, and the other copies of a script the target page shares (they must stay byte-identical).
- NEVER guess animation parameters — view the legacy GIF files first to determine function shape, domain, x₀, and convergence character.
- ALWAYS create a `## Description` section in each topic page, placed before `## Animations`.
- If legacy animated GIFs are missing, reconstruct animation parameters from worked examples, equations, and static graphs from the module links before scripting.
- **Mathematics is the ground truth.** The legacy archive tells you what each example was meant to be (function, interval, starting values, step, order, behaviour), but its numbers are claims to compute, not facts to copy. Where the archive and the mathematics disagree, the page follows the mathematics and says so in one sentence.
- Always use `@__DIR__` for GIF output paths in Julia scripts so the GIF saves next to the script regardless of working directory.
- NEVER run MATLAB. Python (`/usr/bin/python3` with numpy, scipy, sympy, mpmath) and Julia are the tools for checking.
- Follow the **Accuracy standard** below. It is not optional: it lists the mistakes nine independent review rounds found in the first 53 pages.

## Accuracy standard (lessons from nine review rounds)

The first 53 pages were reviewed nine times. Almost none of the errors were crashes. They were plausible sentences and numbers that nobody computed. Every page you build must avoid each of these.

**Numbers and claims**
- Compute every number that goes on the page, in a title, legend or alt text, with an independent check (mpmath, sympy or scipy, or a second Julia routine), and state it only to the precision the check supports. Typical misses were a root wrong in the third decimal and an integral quoted to more digits than were computed.
- Check every behaviour word against the computed sequence: converges, diverges, oscillates, alternates, monotone, overshoots, "fast", "tracks the reference". "Monotone" was written for alternating sequences more than once.
- Quantifiers and comparatives must be exactly true over the whole range they cover: "every iterate", "always", "coarser steps become unstable".
- Do not attach a textbook result to a case it does not fit. A convergence order, error constant or stability bound is stated for this problem only after you measure it. For example, step-halving ratios on a non-smooth integrand give order 5/3, not the rule's textbook order. A general statement may stay only when labelled as general ("for smooth f").
- Verify every reference curve or value: an "exact" solution must satisfy the equation and the initial condition, and a numerical reference must be accurate enough for the comparison it supports.
- Avoid timing claims. If one is needed, say what was measured, with what tool, and that it depends on the machine.

**Method**
- The code must run the method the page names. When it runs a variant (for example Netlib `zeroin` instead of Brent's ALGOL test, a real-part variant of Muller, or Mathews' "Modified Euler", which is the midpoint method), name the variant on the page.
- For ODE methods, check stability at the chosen step before drawing conclusions. Mathews' ODE animations sweep the step count m and print y at the end point. Reproduce his printed values as the check, and describe exactly which m are unstable and which converge.

**What the picture shows**
- Labels use significant figures, never fixed decimals that round a nonzero value to `0.0` or print `-0.0`. Use the template's `fmt(x)` (`@sprintf("%.4g", x)`, with more digits only where a check supports them). An iterate that is exactly 0.0 in Float64 is labelled as a double-precision result, and no frame may show an iterate the method never computed.
- Do not clamp silently. A diverging or off-scale value keeps its true value in the computation and in its label. Only the drawn position may be limited, and the clamp must be visible: use the template's `ydraw(y)`, which limits plotted coordinates to one y-span beyond the axes so the curve visibly leaves the frame, and never draw a clamped run as a flat line along the frame edge.
- Break curves at poles explicitly. List every pole in the window, insert a NaN there, and do not rely on a grid point happening to land on the pole.
- The feature the text describes must be visible in every frame it is described for. Zoom per frame when the action shrinks, as on Muller's Method.
- Titles, legends and labels must fit inside the frame and not hide the feature. Read the first, middle and last frames at full size.

**Fidelity to Mathews**
- Follow Mathews for the parameters of each example (function, interval, starting point, centre, step, maximum order or degree) and for the picture elements his animation had (sample-point markers, bars, tolerance bands). Depart only when his version would be mathematically wrong, and then say why in one sentence on the page.
- When the archive has an example or animation that the page does not animate, add one sentence to the Animations introduction, before Case 1, saying what is left out. Check that sentence against **every** example in the module, not just the ones that look relevant.
- Do not write "legacy GIF missing" without searching `a2001/Animations/` as well as `n2003/`. If archive images are missing, attribute nothing to Mathews that you could not read.
- When a whole animation is new, with no Mathews original, say so in the Animations introduction.

**Consistency and wiring**
- Each case's heading, Behavior paragraph, alt text and the GIF's own title must agree with the script's parameters and with each other. In table-driven scripts, check every row, not a sample.
- A script shared between pages stays byte-identical in every copy.
- Every committed GIF must be exactly what its committed script produces: regenerate, then check with `git status` that only the intended files changed.

**Your build ledger**
Before you report a page as done, write a claim ledger outside the repository (the session scratchpad if your host has one, otherwise `$TMPDIR/animation-ledgers/<slug>.md`). List every sentence, heading, alt text, title and label on the page that states a number or a behaviour. Next to each, record the computation that confirms it (command and output). A claim you cannot confirm is removed or reworded. When the batch is done, have it checked by the `review-animations` skill.

## Folder Structure

```
pages/numerical-methods/<topic-slug>/
  index.qmd          ← Quarto page (moved from flat <topic-slug>.qmd)
  <prefix>aa.jl      ← Julia script for case aa
  <prefix>aa.gif     ← pre-generated GIF output
  <prefix>bb.jl
  <prefix>bb.gif
  ...
```

## Module Page Structure

All legacy module pages live under:
```
/home/jason/Desktop/math-fullerton/baseline/mathews/n2003/
```

Legacy **animations** are mostly elsewhere, under `/home/jason/Desktop/math-fullerton/baseline/mathews/a2001/Animations/<Area>/<Topic>/` (for example `OrdinaryDE/Milne1/Milneaa.gif`). Module pages link to them in their Animations paragraph. Some linked animation folders hold only HTML, which means the GIF is lost. Complex-analysis modules are under `c2003/`. The plan in `plans/numerical-methods-animation-plan.md` lists what survives for each page that has no animations yet.

For a topic named `FooBar`, the layout is:
```
n2003/FooBarMod.html                        ← top-level module page (lists examples)
n2003/foobar/FooBarMod/
  Links/
    FooBarMod_lnk_1.html                   ← intro/background
    FooBarMod_lnk_2.html                   ← Example 1 solution
    FooBarMod_lnk_3.html                   ← Example 2 solution
    FooBarMod_lnk_4.html                   ← Example 3 solution
    ...
  Images/
    FooBarMod_gr_N.gif                     ← formula and graph images
```

Images in the `Images/` directory are **inline formula GIFs** (HEIGHT ~17–20 px), **Mathematica output blocks** (~30–100 px) and **graph plots** (HEIGHT ≥ 100 px, typically 178). Read the HTML as text first. View a formula or output image only when the text lacks the function or a parameter, and view graph plots for the domain and the shape of the behaviour.

## Image budget

Images are expensive: VS Code Copilot's `view_image` is limited to 20 per session, and in any host each image costs context. Delegate image reading to subagents (`search_subagent` in Copilot, the Agent tool in Claude Code); each has its own budget.

**Primary strategy — delegate image reading to subagents:**
- Spawn one `search_subagent` per example (lnk_2, lnk_3, …). Each subagent can view up to 20 images for that example and return: the function formula, starting values, graph domain (xlims/ylims), and root location.
- Reserve the main agent's 20-image budget for verifying the generated GIFs only (one view per GIF after running the Julia scripts).

**Fallback — reduce views needed before calling subagents:**
- Use `cat ... | sed 's/<[^>]*>//g' | sed '/^[[:space:]]*$/d'` to read HTML as plain text first — this often reveals numeric starting values directly without spending any image views.
- Use `grep -n 'HEIGHT=[1-9][0-9]\{2\}' <lnk_N>.html` to identify which GIF numbers are graph plots (HEIGHT ≥ 100) vs. formula GIFs (HEIGHT ~17px), so subagents only view graph-sized images.
- To find which GIF holds a given formula, extract the IMG tag context: `grep -B2 -A2 'gr_N.gif' | sed 's/<[^>]*>//g'`.

## Legacy Availability Decision

Use this decision path at the start of each topic:

1. Check whether legacy animated GIFs exist for the topic or examples.
2. If animated GIFs exist, use them to calibrate frame progression, geometry, and visual pacing.
3. If animated GIFs do not exist, use worked examples (lnk_2, lnk_3, ...) plus static graph/formula GIFs to infer equation, parameters, and expected behavior.
4. If archive files are incomplete (missing referenced image IDs), proceed with complete examples only and note the limitation in the page text briefly.
5. If there is no legacy animation at all (most pages in batches 4–9 of the plan), or no module page (Logistic Curve, Power Series), design the animation from the page's own worked example, which the `content-page` skill writes first. Choose parameters that show the behaviour the text describes, compute them, and say in the Animations introduction that the animation is new and has no Mathews original.

## Batch Mode (one plan batch, 3–7 pages)

When asked to process a batch:

1. Build a queue of the batch's topic slugs (from `plans/numerical-methods-animation-plan.md` when a batch number is given, or from `plans/numerical-methods-light-pass-plan.md` for batch 15 and later).
2. Perform read-only discovery in parallel across queued topics (module page, links, image inventory).
3. Process edits topic-by-topic (folder move, scripts, qmd update, index link), then generate GIFs topic-by-topic to keep failures isolated.
4. Reserve the main agent image-view budget for final GIF verification only; use subagents for legacy extraction per topic/example.
5. Keep a per-topic checklist: discovered → scripted → generated → frames checked → ledger → rendered → reviewed.
6. After all five are processed, run renders for each updated topic page and then do a final pass on index links.

## Workflow

1. **Read the top-level module page** with `cat ... | sed 's/<[^>]*>//g' | sed '/^[[:space:]]*$/d'` to identify how many examples exist and what functions/roots are described.
2. **Check legacy asset availability** for the topic (animated GIFs, static graph GIFs, and missing IDs) with `ls`, `grep`, and link-file image references.
3. **Read each example link HTML** (lnk_2, lnk_3, …) the same way to extract plain-text clues: root value, Newton starting value, Muller starting triple. Numeric values are often visible without viewing any images.
4. **Spawn one subagent per example** to view formula and graph GIFs for that example. Provide the subagent with: the lnk_N.html path, the Images/ directory path, and the graph-sized GIF numbers from step 3. Ask it to return: the function definition, parameter values, domain, and root location.
5. **Determine the functions analytically** from subagent/static-example results. Verify roots and convergence character mathematically.
6. **Move the flat .qmd to a folder:**
   - `mkdir -p pages/numerical-methods/<topic> && git mv pages/numerical-methods/<topic>.qmd pages/numerical-methods/<topic>/index.qmd`
   - Update `bibliography:` depth by one level (e.g., `../../references.bib` → `../../../references.bib`)
   - Change the back link `← [Numerical Methods](./)` to `← [Numerical Methods](../)` (otherwise the moved page links to itself)
   - Update href in `pages/numerical-methods/index.qmd` from `<topic>.qmd` → `<topic>/`
   - Remove a "Legacy Animation Inventory (Stub)" section once its archive paths are noted; its `localhost:8000` links are dead on the published site
7. **Create one .jl script per case** using the Julia script template below
8. **Run all scripts** from the page folder: `cd pages/numerical-methods/<topic> && julia <script>.jl`
9. **Check each GIF's frames.** A GIF viewed directly shows only its first frame. Run `julia .github/skills/animation-page/scripts/giftools.jl <gif> <outdir-outside-repo>` and look at the contact sheet, then the first, middle and last frames at full size (titles and legends are only readable there).
10. **Add or update a Description section** in `index.qmd` with a concise method overview and key mathematical context.
11. **Add an Animations section** to `index.qmd` using the .qmd template below, directly after the Description. Page order: back link, source line, `## Description`, `## Animations`, then the page's remaining sections.
12. **Write the build ledger** (see the Accuracy standard) and fix or remove every claim it cannot confirm.
13. **Render the page** with `quarto render pages/numerical-methods/<topic>/index.qmd`.
14. **When the batch is finished,** commit it on its own branch (`batch-<N>`), or ask Jason first if he has not authorised commits, so the review sees a fixed state. Then review it with the `review-animations` skill, scoped to the batch (`batch=<N>` or its slugs, with `out=reviews/batch-<N>`), before it is merged.
15. **Fix from the review.** Reproduce each finding before changing anything, fix it under this skill's Accuracy standard (or record it as not reproduced, with evidence), then re-review the changed pages into a new folder (`out=reviews/batch-<N>-r2`). Repeat until a round has no Error or Misleading findings.

## .qmd Description Section Template

Insert before the "Animations" section:

```markdown
## Description

<1-3 short paragraphs explaining the numerical method, what problem it solves, and the core update rule or geometric idea.>

<Include key equations in KaTeX where useful, e.g. $x_{n+1}=g(x_n)$ or method-specific formulas.>
```

## Julia Script Template

```julia
# <prefix><id>.jl
# <Topic> animation: <description of this case>
# Produces: <prefix><id>.gif

using Plots
using Printf
gr()

# Significant-figure label: never rounds a nonzero value to 0.0, never prints -0.0
fmt(x) = x == 0 ? "0 (double-precision zero)" : @sprintf("%.4g", x)

# Drawn position only: lets an off-scale curve visibly leave the frame instead of
# running along its edge. Labels and computations always use the true value.
ydraw(y, yl) = clamp(y, yl[1] - (yl[2] - yl[1]), yl[2] + (yl[2] - yl[1]))

# --- Parameters ---
g(x) = ...           # iteration function
x0   = ...           # starting point
n_iters = 12         # number of frames (use fewer for fast-diverging cases)

xlims = (0.0, 4.0)   # adjust to topic domain
ylims = (0.0, 4.0)

title_str = "<Topic>: g(x) = ..."

# --- Pre-compute iterates ---
xs = Vector{Float64}(undef, n_iters + 1)
xs[1] = x0
for i in 1:n_iters
    xs[i+1] = g(xs[i])
end

# --- Cobweb path (vertical then horizontal steps) ---
cobweb_x = [xs[1]]
cobweb_y = [xs[1]]
for i in 1:n_iters
    push!(cobweb_x, xs[i],   xs[i+1])
    push!(cobweb_y, xs[i+1], xs[i+1])
end

# --- Backdrop ---
xplot = range(xlims[1], xlims[2], length=400)

# --- Animation (one staircase step per frame) ---
anim = @animate for frame in 0:n_iters
    plot(size=(600,600), xlims=xlims, ylims=ylims,
         xlabel="x", ylabel="y", title=title_str,
         legend=:topleft, grid=true, framestyle=:box,
         background_color=:white)

    plot!(collect(xlims), collect(xlims); color=:green,   lw=2, label="y = x")
    plot!(xplot, g.(xplot);               color=:magenta, lw=2, label="y = g(x)")

    n_pts = 1 + 2*frame
    if n_pts >= 2
        plot!(cobweb_x[1:n_pts], cobweb_y[1:n_pts]; color=:steelblue, lw=1.5, label="")
    end

    x_cur = xs[frame+1]
    scatter!([x_cur], [x_cur]; color=:red, ms=6,
             label="x_$(frame) = $(fmt(x_cur))")
end

gif(anim, joinpath(@__DIR__, "<prefix><id>.gif"); fps=2)
println("Saved: <prefix><id>.gif")
```

**Notes:**
- `fps=2` gives slow, readable playback — increase for faster topics
- For diverging cases, reduce `n_iters` (e.g., 8) and keep every iterate's true value in its label. Limit only the drawn position, visibly, as the Accuracy standard describes; never `clamp` the iterate itself
- For non-cobweb topics (Newton's method, bisection), replace the cobweb path section with the topic-specific geometric construction

## .qmd Animations Section Template

Insert directly after the Description section:

```markdown
## Animations

Each animation below shows the **<diagram type>** for <topic>. <1–2 sentence explanation of what the diagram shows and how to read it>.

Julia source scripts that generated these animations are linked under each case.

### Case N — <behavior label>, $g(x) = ...$, $x_0 = ...$

**Behavior:** <1–2 sentences explaining convergence/divergence and the mathematical reason ($|g'(x^*)| < 1$ or $> 1$).>

[Julia source](<prefix><id>.jl)

![<Descriptive alt text for accessibility>](<prefix><id>.gif)
```

**Rules:**
- No code blocks on the page — source file link + GIF embed only
- Alt text must describe what the animation shows
- Use KaTeX math ($...$) in case headers and behavior descriptions
- A `## Description` section is required on every page (do not skip it)

## Known Working Environment

- Julia global environment: Plots.jl v1.41.2 with GR backend
- `gr()` call activates the GR backend explicitly
- GIF output: `gif(anim, path; fps=N)`
- Output paths use `@__DIR__`, so a script writes its GIF next to itself from any working directory

## Useful Shell Patterns

```bash
# Strip HTML tags and blank lines from a module page
cat /home/jason/Desktop/math-fullerton/baseline/mathews/n2003/<TopicMod>.html \
  | sed 's/<[^>]*>//g' | sed '/^[[:space:]]*$/d'

# Find all graph-sized images in an example link file (HEIGHT >= 100)
grep -n 'HEIGHT=[1-9][0-9]\{2\}' .../Links/<TopicMod>_lnk_N.html

# Find image context (what surrounds a given GIF reference)
grep -B3 -A1 'gr_N.gif' .../Links/<TopicMod>_lnk_N.html | sed 's/<[^>]*>//g'

# List available image files (to check which GIF numbers exist)
ls .../Images/ | sort -V
```
