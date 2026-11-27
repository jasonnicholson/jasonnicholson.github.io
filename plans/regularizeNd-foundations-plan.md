# regularizeNd foundations: implementation plan

Written 2026-11-27.

## Revision 2026-11-27 (supersedes the page map below)

The original Math for Mere Mortals material is three articles, each published in two or three parts. The series is therefore written as **three article-level pages**, not seven part-level pages. Each page keeps the flow of its original article (same order of concepts, same order of worked figures) while the prose, figures, and code are written independently.

| Local page | Original article (WordPress post IDs) | Parts merged |
|---|---|---|
| `pages/regularizeNd/foundations-2d-data.qmd` | Introduction to Regularizing with 2D Data (157, 221, 223) | 3 of 3 |
| `pages/regularizeNd/foundations-regularizedata2d-spreadsheet.qmd` | RegularizeData2D, the Excel Spreadsheet Function (276, 335) | 2 of 2 |
| `pages/regularizeNd/foundations-3d-data.qmd` | Introduction to Regularizing 3D Data (407, 474) | 2 of 2 |

Rules that apply to the revised pages:

- The three pages are the only new foundation pages. The earlier drafts `foundation-01` through `foundation-06` are superseded. They are kept in git history (checkpoint `be64650`) and removed only after the replacements pass review.
- Each page follows the common page contract below, applied to the whole article. "Foundations 1..7" references in the contract mean the sections of the merged page.
- Each page's section order mirrors its original article. The original's graphics are replaced by locally generated figures that show the same mechanism.
- Prose is written independently. Do not copy the original text, figures, or spreadsheet material.
- Attribution, numerical, and out-of-scope rules are unchanged. Keep the caveats from the Copilot session: the normal-equation conditioning warning at fine grids, and the claim that the original's "stable across resolutions" statement is stronger than the calculation supports.

## Goal

Replace the external Math for Mere Mortals articles currently linked from `pages/regularizeNd/index.qmd` with an independently written, self-hosted foundation series. The new series will preserve the conceptual path that explains how regularized gridded fitting works internally, while keeping the existing eight-part `regularizeNd` tutorial series usable without extra prerequisites.

The local pages must be usable as prerequisites to `deep-dive-regularizeNd-design.qmd`. They are not prerequisites for someone who only wants to call `regularizeNd` and tune its public options.

This is an adaptation and attribution project, not a copy of the WordPress content. Every local page will be independently derived, use local calculations and examples, and retain conspicuous links to the corresponding original article or articles.

## Reader paths

Expose two paths from the regularizeNd home page:

1. **Use regularizeNd**: Parts 1-8 and the existing package examples. No foundations series is required.
2. **Understand the internals**: Foundations 1-7, followed by the deep-dive article and then Parts 6-8 when relevant.

The index should explain this distinction before either list. It should not label the foundations series as required reading for normal use.

## Proposed local pages

All foundation pages will live in `pages/regularizeNd/` and use the following progression.

| Local page | Working title | Original Math for Mere Mortals source(s) | New local focus |
|---|---|---|---|
| `foundation-01-fidelity.qmd` | Foundations 1: Fidelity Equations | [Introduction to Regularizing with 2D Data, Part 1](https://mathformeremortals.wordpress.com/2013/01/29/introduction-to-regularizing-with-2d-data-part-1-of-3/) | Frame the noisy, irregular samples to regular-grid problem; construct the linear fidelity matrix from 1D interpolation; use a fully reproducible five-point example. |
| `foundation-02-smoothness-and-least-squares.qmd` | Foundations 2: Smoothness and Least Squares | [Introduction to Regularizing with 2D Data, Part 2](https://mathformeremortals.wordpress.com/2013/01/31/introduction-to-regularizing-with-2d-data-part-2-of-3/) | Derive second-difference smoothness rows, stack fidelity and regularization rows, normalize equation counts, and solve the resulting least-squares problem. |
| `foundation-03-normalization-and-residuals.qmd` | Foundations 3: Normalization and Residuals | [Introduction to Regularizing with 2D Data, Part 3](https://mathformeremortals.wordpress.com/2013/01/31/introduction-to-regularizing-with-2d-data-part-3-of-3/) | Complete the five-point example, inspect fidelity and smoothness residuals, and demonstrate why row-count normalization keeps the fitted curve stable as grid resolution changes. |
| `foundation-04-from-equations-to-code.qmd` | Foundations 4: From Equations to Efficient Code | [RegularizeData2D, Part 1](https://mathformeremortals.wordpress.com/2013/02/13/regularizedata2d-the-excel-spreadsheet-function-for-regularizing-2d-data-part-1-of-2/) | Translate the mathematical system into sparse matrix assembly and explain why a solver should avoid explicit inverses and unnecessary dense products. Use regularizeNd terminology, not VBA-specific interface details. |
| `foundation-05-project-and-solve.qmd` | Foundations 5: Projecting and Solving the 1D System | [RegularizeData2D, Part 2](https://mathformeremortals.wordpress.com/2013/02/17/regularizedata2d-the-excel-spreadsheet-function-for-regularizing-2d-data-part-2-of-2/) | Trace one row contribution into $A_f^T A_f$, $L^T L$, and $A_f^T y$; solve a small sparse system and compare it with forming the matrices explicitly. |
| `foundation-06-bilinear-grid-indexing.qmd` | Foundations 6: Bilinear Interpolation and Grid Indexing | [Introduction to Regularizing 3D Data, Part 1](https://mathformeremortals.wordpress.com/2013/07/22/introduction-to-regularizing-3d-data-part-1-of-2/) | Map a 2D rectilinear grid into one vector, construct bilinear fidelity weights, and explain edge and exact-node cases. Clarify the site's terminology: a surface with two inputs is called 3D data in the originals and 2D input by regularizeNd. |
| `foundation-07-surface-system.qmd` | Foundations 7: Assembling the Surface System | [Introduction to Regularizing 3D Data, Part 2](https://mathformeremortals.wordpress.com/2013/07/24/introduction-to-regularizing-3d-data-part-2-of-2/) | Assemble derivatives along both grid axes, count regularization rows, normalize the full system, solve a small 3-by-3 or 5-by-5 surface, and unwrap the solution into `ndgrid` order. |

The first three pages replace the conceptual 2D introduction; the next two replace the implementation-oriented 2D articles; the final two generalize to a surface. A new page may link to existing deep-dive sections when that avoids duplicating an explanation, but each foundation page must still stand alone at the reader's expected level.

## Common page contract

Each foundation page must use the same structure:

1. A prerequisite line stating the local page(s) to read first.
2. A short learning goal.
3. A prominent `Source and attribution` note naming the exact original article, original author/site when identifiable, publication date, and URL.
4. The statement that the local article is an independent implementation and modernization, not a transcription.
5. A worked numerical example with all values checked by executable code.
6. Diagrams or matrix visualizations generated by the site or committed local assets.
7. A section connecting the concept to the corresponding `regularizeNdMatrices` or `regularizeNd` behavior.
8. A `How this differs from the original` note where regularizeNd differs in interpolation, normalization, indexing, sparse solver strategy, or terminology.
9. Back, previous, and next navigation.
10. A transition to the next foundation page, with Foundation 7 ending in a link to the deep-dive article.

Do not embed remote screenshots, download remote spreadsheets as the published source of truth, or copy the original prose verbatim. The original articles remain linked as historical references. Recreate diagrams from the underlying equations and use locally generated or licensed visual assets.

## Attribution and reference policy

- Add a bibliography entry for each source article in `references.bib`, using the original title, site, date, and canonical URL.
- Put the original URL in the visible `Source and attribution` note on every mapped page in addition to the bibliography citation. Readers must not have to open a citation to identify the source.
- On the regularizeNd index, group the originals under `Historical sources and lineage`; state that the local foundations are the maintained versions and the external URLs are retained for attribution and comparison.
- Attribute the source to the site, **Math for Mere Mortals**, and link the articles. Do not name an individual author.
- In the deep-dive introduction and Part 8, add a short link back to the local foundation series and distinguish three things: the original educational articles, historical MATLAB/File Exchange tools, and the independent regularizeNd implementation.
- Preserve the original titles and links in the plan's source table so future migrations can audit coverage even if the regularizeNd index later changes.

## Content ownership and overlap

The plan should reduce, not compound, existing overlap.

- Foundation 1 should be linked from Part 1 as optional theory for readers who want to understand the fidelity equations.
- Foundation 2 should own the introductory derivation of the smoothness block. Part 2 should remain focused on using and tuning `smoothness`.
- Foundation 3 should own the worked residual and resolution-normalization explanation. The corresponding deep-dive material may summarize and link rather than repeat the entire derivation.
- Foundations 4-5 should provide the bridge to efficient assembly. The current deep-dive solver and scaling sections remain the regularizeNd-specific authority.
- Foundations 6-7 should own the 2D-input-to-vector indexing walkthrough. The deep-dive fidelity and nD-unwrapping sections may retain concise implementation-specific examples and link back for the introductory derivation.
- Part 8 should continue to own migration from `gridfit` and `RegularizeData3D`; the foundations series is mathematical and algorithmic, not a substitute for migration guidance.

## Implementation phases

### Phase 1: Capture and lock the scope

1. Confirm the numerical examples and terminology from all seven originals are represented in the page map.
2. Add the seven source articles to `references.bib` and validate the keys with a render.
3. Create a small local data fixture for Foundations 1-5. Record exact input coordinates, output-grid coordinates, smoothness values, matrices, solution, and residuals in a reproducible test script or notebook.
4. Create a small 2D input fixture for Foundations 6-7 with at least one exact grid point, one edge point, and one interior point.
5. Reproduce all planned numerical claims in MATLAB and, where practical, compare against a direct least-squares reference independently assembled in code.

### Phase 2: Write the 1D conceptual sequence

1. Write Foundations 1-3 in order.
2. Use the same fixture throughout so readers can see fidelity, regularization, the complete system, and residuals accumulate rather than switch examples.
3. Include source notes for all three original 2D introduction articles.
4. Check that no statement claims the method interpolates every point exactly; it solves a weighted least-squares compromise unless the penalty is effectively zero.

### Phase 3: Write the 1D implementation bridge

1. Write Foundations 4-5 using the saved 1D fixture.
2. Demonstrate sparse assembly and the normal-equation projection without teaching an explicit matrix inverse as the normal implementation path.
3. Compare conceptual dense assembly with sparse or direct stencil-based assembly by operation count or sparsity, not unsupported timing claims.
4. Link Foundation 4 from the `Code Anchors` area of the deep dive and Foundation 5 from the solver area.

### Phase 4: Write the surface sequence

1. Write Foundations 6-7 using one consistent surface fixture.
2. Generate local diagrams for grid-to-vector indexing, bilinear corner weights, derivative direction, sparse pattern, and vector-to-grid unwrapping.
3. State clearly that regularizeNd uses `ndgrid` order and that the original articles may describe a different visual numbering convention.
4. Derive the surface smoothness equation counts from the actual grid dimensions and verify the counts in code.

### Phase 5: Integrate reader paths

1. Replace the generic external-article list on `pages/regularizeNd/index.qmd` with:
   - `Tutorial Series: use regularizeNd`
   - `Foundations: understand the internals`
   - `Deep-Dive Scientific Article`
   - `Historical sources and lineage`
2. Add an explicit note: foundations are prerequisites to the deep dive, optional for ordinary use.
3. Update the deep dive opening to link to the seven-page sequence and label which foundations to complete before continuing.
4. Update Part 8's lineage section to link to the maintained local foundations and retain direct links to original articles as historical sources.
5. Add related-page navigation consistently across all new and linked pages.

### Phase 6: Review and publish

For every page, review both correctness and source fidelity.

- Recompute all numeric examples from the committed source script or test fixture.
- Check every visible matrix, weighting sum, equation count, residual, and plotted solution.
- Confirm each page's source map matches the table in this plan.
- Confirm the page does not imply that the original prose, screenshots, or downloaded spreadsheets were copied into the site.
- Run one pass specifically for reader-path clarity: tutorial users should not be sent unnecessarily through the foundations; deep-dive readers should see the complete prerequisite chain.
- Run a Quarto render of the regularizeNd section, then inspect generated links and headings on the index and deep dive.
- After publication, keep the external article URLs visible but do not make the site depend on them for diagrams, equations, data, or navigation.

## Review questions

The implementation is ready when all are true:

1. Can a reader understand the internal formulation from the local site if every WordPress page is unavailable?
2. Can a reader identify exactly which original article inspired each local page?
3. Does every reproduced calculation agree with the committed fixtures?
4. Are the local pages clearly optional for users of the public regularizeNd API but clearly prerequisite to the deep dive?
5. Does the deep dive avoid duplicating the full foundation derivation while still remaining readable as a technical reference?
6. Are original Excel/VBA interface details omitted unless they teach a still-relevant implementation principle?
7. Is `gridfit`/`RegularizeData3D` migration kept in Part 8 rather than confused with the mathematical foundations?

## Out of scope

- Mirroring or redistributing the original WordPress pages, screenshots, spreadsheet files, or VBA source.
- Reimplementing the historical Excel functions as a deliverable of this series.
- Making the eight existing usage tutorials depend on the foundation series.
- Replacing `regularizeNd` code documentation with introductory mathematics.
- Claiming that regularizeNd is a line-for-line descendant of the historical implementations.
