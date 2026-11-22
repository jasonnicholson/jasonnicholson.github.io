---
description: Direct a review of the Julia animations under pages/numerical-methods - is each implementation correct, and does each page match its animation
argument-hint: "[all | <page-slug> ... | \"<index section title>\"] [out=<report folder>]"
---

# Review director: numerical-methods animations

You are directing a review of the Julia animations in the Numerical Methods section of jasonhnicholson.com, which lives in `pages/numerical-methods/` of this repository. You plan the work, prepare the evidence, hand each page to a reviewer subagent, have the findings independently checked, and write the report.

This is a review. Nothing under version control is changed, and nothing is fixed. Jason decides what to fix after reading the report.

**Scope for this run:** $ARGUMENTS

An empty scope, `all`, or an unfilled placeholder means every page that has animations. Otherwise the scope is a list of page slugs (folder names such as `bisection-method`), or the title of a section in `pages/numerical-methods/index.qmd`, meaning the animation pages listed in that section. A page that already has a finished report from an earlier run is skipped unless it is named explicitly, so an interrupted run can be resumed by running the same scope again.

The arguments may also include `out=<folder>`, the report folder for this run; call it `$OUT` below. It defaults to `reviews/numerical-methods-animations`, which holds the round-1 review. A re-review after fixes uses a new folder for each round, for example `out=reviews/numerical-methods-animations-r2`, so that earlier rounds are kept. The skip-if-finished rule applies only within `$OUT`.

A re-review is a fresh, independent review. Neither you nor your reviewers read earlier rounds' reports or the fix records under `reviews/` before the findings of this round are written and checked, because a reviewer who knows what was fixed tends to check only that. After the round's findings are final, you may compare them with earlier rounds in the README, noting any earlier finding that has come back.

## Why this review exists

The pages were produced by AI agents working from an archived copy of John H. Mathews' numerical methods site. For each topic an agent wrote Julia Plots.jl scripts, ran them to produce GIFs, and wrote the page text around them. Jason, the site owner, has not checked the results, and the section index tells readers he expects many errors "even if the animations look correct".

He will work through your report and fix what it identifies. So the report has to give him two things: a list of what is actually wrong, each item stated precisely enough to fix without repeating your investigation, and an honest account of what was checked on the pages where nothing was found. Both kinds of mistake cost him. A false alarm sends him to investigate something that was fine. A missed error stays on a public teaching site with a reassuring review behind it.

The review answers two questions about every animation:

1. **Is the implementation correct?** Does the script compute what the named numerical method actually produces for the stated problem, and does the picture truthfully show what was computed?
2. **Does the page match the animation?** Is everything the page says about an animation true of the animation readers actually see?

## What is there

Each animated topic is a folder `pages/numerical-methods/<slug>/` holding `index.qmd`, one or more `.jl` scripts, and the GIFs those scripts produced. The page never executes code. It embeds the pre-generated GIF and links to the script as its source. When this prompt was written there were 53 such pages, 115 scripts and 280 GIFs, but build your own inventory rather than trusting those numbers.

Most scripts produce one GIF and are named after it (`bisectionaa.jl` makes `bisectionaa.gif`). Six pages are different: a single table-driven script named `*_all.jl` produces 27 to 31 GIFs, one per row of a case table, with file names built at run time. Those six pages hold well over half of all the GIFs.

Topic pages that are still flat `.qmd` files have no animations and are out of scope. So are the MATLAB `.m` files and the "Video Animations" sections on two pages, the "(Planned)" placeholder sections, and the "Legacy Animation Inventory (Stub)" sections.

`.github/agents/animation-page.agent.md` is the brief the authoring agents worked from. Read it. It tells you what they were asked to build and which habits they were given, for instance clamping diverging iterates to the axis limits to keep a plot readable.

## What counts as ground truth

Mathematics is the ground truth: what the named method produces for the stated problem, computed independently. Everything in the repository is a claim to be tested against that. Script comments and header lines are claims. Page text is a claim. A script that runs cleanly and a GIF that looks plausible are not evidence of correctness, which is exactly the trap Jason is warning his own readers about.

The legacy Mathews archive the authoring agents used is not on this machine, so fidelity to the original animations is not being checked and nobody should stall looking for it.

## Phase 1: prepare the evidence yourself

This phase is mechanical and you should do it directly with a script of your own, once, rather than having dozens of reviewers each improvise it. It gives every reviewer the same evidence and leaves them free for the work that needs judgment. Put everything under a scratch directory outside the repository, called `$WORK` below.

**Never run a script where it lives.** Every script writes its GIFs next to itself through `@__DIR__`, so running one inside its page folder overwrites committed, LFS-tracked GIFs. Copy the `.jl` files to `$WORK/<slug>/regen/` and run the copies. The output then lands in scratch.

**Julia environment.** The scripts run against Jason's global Julia environment with a plain `julia <script>.jl`. Beyond the standard library they use only Plots, plus SpecialFunctions in the six `*_all.jl` scripts, and the global environment provides both (Plots 1.41.2 and SpecialFunctions 2.9.2 when this was written). In that environment, scratch copies of the six `*_all.jl` scripts and a single-GIF script reproduced all 173 of their committed GIFs byte for byte.

Check that both packages load before you start. If one does not, say so in the report and leave the global environment alone, since changing it is Jason's call. To keep going, create a throwaway environment in scratch and put it behind the global one on the load path:

```bash
julia --project="$WORK/env" -e 'using Pkg; Pkg.add("SpecialFunctions")'
JULIA_LOAD_PATH="@v#.#:$WORK/env:@stdlib" julia "$WORK/<slug>/regen/<script>.jl"
```

The order matters there. With the global environment first, Plots resolves exactly as it did when the GIFs were made.

A warm run takes about 3 seconds for a single-GIF script and 15 to 20 seconds for most of the table-driven ones, with the Padé script closer to 80, so regenerating everything is a matter of minutes and can run several at a time. A first run after packages change adds roughly a minute of precompilation.

**Compare decoded frames, not just bytes.** Identical bytes prove the committed GIF is what the committed script produces. Different bytes prove nothing on their own: the same script under slightly different package versions produced files that differed in size but had identical frames. So when bytes differ, compare frame hashes before drawing any conclusion.

**Looking at frames.** An image viewer shows only the first frame of a GIF, and this machine has no system ffmpeg or ImageMagick. Plots bundles ffmpeg, and this works:

```julia
# usage: julia giftools.jl <gif> <outdir>
using Plots
gifpath, outdir = ARGS
mkpath(outdir)
ff(args...) = Plots.FFMPEG.exe("-v", "error", "-y", args...)

# every frame as a PNG
ff("-i", gifpath, joinpath(outdir, "frame_%03d.png"))
n = count(endswith(".png"), readdir(outdir))

# one contact sheet of up to 12 evenly spaced frames, 4 per row
k = max(1, cld(n, 12)); rows = cld(cld(n, k), 4)
ff("-i", gifpath, "-vf", "select='not(mod(n\\,$k))',scale=420:-1,tile=4x$rows",
   "-frames:v", "1", "-vsync", "0", joinpath(outdir, "sheet.png"))

# per-frame hashes of the decoded pixels, for comparing two GIFs
ff("-i", gifpath, "-pix_fmt", "rgb24", "-f", "framemd5", joinpath(outdir, "frames.md5"))
println(n, " frames")
```

The contact sheet is enough to follow the progression. Small legend text is only reliably readable in the full-size frames.

**What to produce.** For every page in scope:

- An inventory: the scripts, the GIFs on disk, the files the page links and embeds, and which script produces which GIF. For the table-driven scripts the only reliable way to learn the mapping is to run the copy and see which files appear.
- A regeneration result for every script: whether it ran, any error output, and for each GIF it produced whether the frames match the committed file.
- Frames, a contact sheet and frame hashes extracted from each **committed** GIF, since that is what readers see.
- A manifest for the page that records all of this, which you will hand to its reviewer.

Some mismatches fall out of this phase with no judgment needed, and they go straight into the report as inventory findings: a script that fails to run, a committed GIF whose frames differ from what its script produces, a GIF or script on disk that the page never references, a page reference to a file that does not exist, a GIF that no script produces, and an animation page that the section index does not link. If frame hashes differ on nearly every page, suspect the environment before suspecting the GIFs, look at a few pairs side by side, and report a GIF as stale only when its content really differs.

## Phase 2: one reviewer per page

Give each page to a fresh subagent. Reviewing a page takes close reading of code, independent computation and looking at many images, and doing that for dozens of pages in your own context would crowd out the judgment you need for directing. Run several reviewers at a time.

A reviewer starts with nothing but your brief, so the brief carries everything it needs: the page folder, the path to that page's prepared evidence and manifest, the commands for running Julia with the right load path, the rule about never running scripts in place, and the whole of the "Review standard" section below. Hand that section over in full rather than summarising it. The parts that prevent a shallow review are the parts a summary drops.

The six table-driven pages need a different shape of review. The algorithm is shared, so it is checked once. What multiplies is the case table: every row's function, interval and parameters has to agree with the page's heading and caption for that case and with the title visible in that case's GIF. If one page is too much for one reviewer, split it by case range and make one of the reviewers responsible for the shared algorithm. Two of these pages carry copies of a script with the same file name, so have a reviewer diff them and say whether they have drifted apart.

**Start with a pilot.** Review three or four pages first, chosen to span the kinds of topic: a root finder, a quadrature rule, an ODE method and one table-driven page. Read those reports critically before launching the rest, because a weakness in your brief will otherwise repeat on every page. Include `bisection-method` in the pilot as a known-answer check. When this was written, its page gave the root of $x^3 + 4x^2 - 10$ as about 1.3688 where the true value is 1.36523, and described the midpoints as converging monotonically when they alternate sides. If the page still says those things and the review comes back clean, the brief is not working and needs fixing before you go further.

If the bisection errors have since been fixed, calibrate with a planted error instead:

1. Copy one pilot page's folder into scratch.
2. Introduce two errors into the copy: one quoted number that is wrong in the third significant digit, and one behaviour sentence that the computed sequence contradicts. Record both in your notes.
3. Point that pilot reviewer at the copy.

If the reviewer misses either planted error, the brief needs fixing. That page is then reviewed again from the real folder, and the planted errors never appear in the report. If the calibration works, continue with the remaining pages without waiting for anyone's go-ahead.

**Read every report as evidence, not as a verdict.** A clean result is a claim like any other, and given what Jason expects it deserves more suspicion, not less. A report that says a page is fine but shows no independently computed numbers and no claim-by-claim checking has not established anything, so send that page out again with a note on what was missing. Spot-check a few results yourself where it is cheap.

## Review standard

*This section is written for the reviewer of a single page. Pass it on in full.*

You are reviewing one page of a public teaching site about numerical methods: its `index.qmd`, the Julia scripts beside it, and the GIFs those scripts produced. The page and scripts were written by an AI agent and have not been checked by a person. The owner expects errors and will fix what you find, so he needs to know what is actually wrong and exactly where. He also needs to be able to trust a clean result, which means showing what you checked.

Do not modify anything in the repository. Never run a script from its own folder, because it would overwrite the committed GIF. Work on copies in the scratch folder you were given. Extracted frames and a manifest for this page are already there.

Treat the mathematics as the ground truth and everything else as a claim: the script's comments and header lines, the page text, and the look of the GIF. The typical error here is not a crash. It is something plausible that nobody verified, such as a root quoted to four decimals that is wrong in the third, or a sentence describing behaviour that the computed values contradict.

### Question 1: is the implementation correct?

Establish four things for each script.

*It is the method it claims to be.* The algorithm the code runs is the method named in the page title and case headings, not a neighbouring method and not a simplification passing under the name. Hybrid and multi-stage methods deserve particular care: root finders with safeguards, predictor-corrector pairs, adaptive step-size schemes, and anything defined by a table of coefficients. A legitimate variant of a method is not an error, but name which variant it is, because the page may describe a different one.

*The numbers are right.* The values the script computes (iterates, nodes, weights, coefficients, approximations, error estimates) are what the method produces for the stated problem. Reading the code and finding it reasonable does not establish this. Instrument a scratch copy so it prints the values it computes, write your own independent computation of what the method should produce, and compare the two. Wherever you can, prefer a check whose outcome does not depend on your remembering a formula correctly, since your memory of a coefficient table is as fallible as the author's was. Properties make good checks of this kind:

- A quadrature rule integrates polynomials exactly up to its degree of precision and not beyond it.
- A method of order $p$ shrinks its error by about $2^p$ when the step is halved.
- An interpolant reproduces its data at the nodes.
- A least-squares fit leaves a residual orthogonal to its basis functions.
- A claimed root gives a residual near zero, and the iterates approach it at the method's known rate.
- An orthogonal polynomial family satisfies its recurrence and orthogonality relation.
- A series or rational approximation matches the function's derivatives at the expansion point to the stated order.

Running the script's own routine on a problem with a known closed-form answer is another strong check.

*Its reference values are right.* Many scripts draw a "true" root, an "exact" solution curve or an "exact" integral for comparison. Verify these independently. An exact solution has to satisfy the differential equation and the initial condition. A reference computed numerically has to be accurate enough for the comparison it supports.

*The picture shows what was computed.* A script can compute correctly and still draw wrongly. Look at the extracted frames, the first, several in the middle and the last, alongside the plotting code. Check that each geometric element is built from the right quantities: a tangent drawn at the current iterate with the right slope, a secant through the right two points, panels with heights taken at the right sample points, a fitted curve that passes where it should. Check that titles, legend entries and annotations report the right quantity with the right index, and that the function in the title is the function in the code. Then consider the display devices: clamping values to the axis limits, masking with NaN near singularities, the axis limits themselves, the number of frames. These are acceptable when they keep a plot readable. They are a finding when they change what a viewer would conclude, for example a diverging iterate drawn and labelled at its clamped value as if that were the real value, or the feature the page talks about falling outside the visible window.

### Question 2: does the page match the animation?

Begin by building a claim ledger, before you form a view about whether the page is right. Go through the page's Animations section, including the introduction, every case heading, every "Behavior" paragraph, every image alt text and every source link and embed, and also the parts of the Description that state the method's formulas or algorithm. List each checkable claim in the page's own words. Then check every entry against evidence you produced yourself: the script's parameters, your independent computation, and the frames. Writing the claims down first is what stops you from reading the page charitably once you understand what the author meant.

The claims to look for:

- **Parameters:** the function, starting values, interval, step size, number of points, order.
- **Numerical results:** a root, an integral, an error, an iteration count, a convergence rate.
- **Behaviour:** converges, diverges, oscillates, is monotone, is fast or slow, tracks the reference closely. Check these against the computed sequence, not against an impression of the picture.
- **What the diagram shows:** which colour or marker stands for what, and what each frame adds.
- **Counts:** how many steps, frames or cases there are.
- **Wiring:** each case's link and embed point at the script and GIF that really are that case, with the parameters in the heading.
- **Method description:** the formulas and algorithm in the Description are the ones the script implements. A page that describes one variant while the script runs another is a mismatch even when both are valid.

A stated number is wrong when it disagrees with the true value at the precision it is stated to, beyond ordinary rounding of the last digit. Look in the other direction as well: anything prominent in the frames, such as the title, the legend values or the final result, that contradicts the page.

Leave out claims about history and attribution, and the placeholder and legacy-inventory sections.

### What is not a finding

Code style, naming, performance, choice of colours, a valid formulation that differs from the textbook's, suggestions for better teaching, and content the page does not yet have. A cosmetic issue becomes a finding only when it makes the animation misleading or unreadable. Padding the report with these makes the real errors harder to find.

### What to write

Write your full report to the file named in your brief, and send back only a short summary: a count of findings by severity and one line per finding.

The report has three parts.

1. **Findings.** For each one: whether it concerns the implementation or the page match; a severity; the exact location (file and line, or the page text quoted); what is there now; what is true instead; how you know, with the command you ran and the numbers it gave; and the specific correction you suggest. Use three severities. *Error* means something is false or computed wrongly. *Misleading* means it is defensible in a narrow sense but a reader would come away with the wrong idea. *Minor* means it is real but of little consequence.
2. **The claim ledger**, complete, with a verdict for every entry including the ones that passed: confirmed, wrong, or could not determine.
3. **Implementation checks.** For each script, what you established about the four points above and the evidence, including the numbers from your independent computation set beside the script's.

If you could not determine something, say so and say why. An honest "could not determine" is useful. A guess written as a conclusion is not, and neither is a pass given to something you did not actually check.

## Phase 3: check the findings independently

A finding that turns out to be false wastes Jason's time and weakens his trust in the rest of the report, so every finding rated error or misleading is checked by someone who did not produce it.

For each page with such findings, give a fresh subagent the allegations only: where the problem is said to be and what is said to be wrong, without the reviewer's reasoning or evidence. Ask it to work out for itself whether each one is true, by its own computation or its own look at the frames, and to answer confirmed, refuted or unresolved with its evidence. Withholding the reviewer's argument is deliberate. A checker shown a persuasive argument tends to agree with it.

Confirmed findings go into the report. Refuted ones are dropped, with a one-line note in the page's file so the disagreement is visible. Unresolved ones are reported as unresolved, with both views. Minor findings can be reported without this check, labelled as unverified.

## Phase 4: the report

Write the report to `$OUT` at the repository root (default `reviews/numerical-methods-animations/`), with one file per page named `<slug>.md` and a `README.md` that summarises the run. Write each page's file as soon as that page is finished, since those files are what make the run resumable. Quarto renders only `.qmd` files in this project, so the folder does not affect the site.

Each page file holds the confirmed findings first and in order of severity, then anything unresolved, then the inventory results from Phase 1, then the claim ledger and implementation checks as supporting detail.

The `README.md` is what Jason reads first, so lead with what he most needs: how many pages were reviewed and how many were not and why, the total findings by severity, and the most serious findings across the whole section. Follow that with a table of one row per page (scripts, GIFs, errors, misleading, minor, status), and then any pattern that recurs across pages, such as a class of mistake the authoring agents made repeatedly, because a pattern points to errors beyond the ones individually found.

Before you finish, confirm with `git status` that no tracked file has changed and that the only new path is `$OUT`. Uncommitted changes that were already present when the run started do not count, but report them. Do not commit anything. Then tell Jason, in a few sentences, where the report is, the headline numbers, the handful of findings he should look at first, and anything that could not be reviewed.
