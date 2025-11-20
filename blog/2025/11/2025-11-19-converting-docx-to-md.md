+++
title = "Converting a docx to md - Math, tables, and html"
date = Date(2025, 11, 19)
+++

I used pandoc to convert a word file to .md. 

```bash
$ .venv/bin/pandoc -s -f docx -t gfm "Newton Method Musings.docx" --extract-media=media -o Newton-Method-Musings_pandoc.md
```

The following warnings were generated.

```plaintext
[WARNING] Could not convert TeX math \frac{\partial F}{\partial x} = 0, rendering as TeX
[WARNING] Could not convert TeX math \frac{\partial F}{\partial x}, rendering as TeX
[WARNING] Could not convert TeX math D = \left( \frac{\partial^{2}F}{\partial x^{2}} \right)^{- 1}\left( - \frac{\partial F}{\partial x} \right), rendering as TeX
[WARNING] Could not convert TeX math \frac{\partial^{2}F}{\partial x^{2}}, rendering as TeX
[WARNING] Could not convert TeX math \frac{\partial^{2}F}{\partial x^{2}}, rendering as TeX
[WARNING] Could not convert TeX math D = \left( \frac{\partial\ F}{\partial x} \right)^{- 1}( - F), rendering as TeX
[WARNING] Could not convert TeX math \frac{\partial\ F}{\partial x}, rendering as TeX
[WARNING] Could not convert TeX math \frac{\partial^{2}F}{\partial x^{2}}, rendering as TeX
[WARNING] Could not convert TeX math \frac{\partial\ F}{\partial x}, rendering as TeX
[WARNING] Could not convert TeX math \frac{\partial\ F}{\partial x}, rendering as TeX
```

The problem was that the inline TeX inside an html did not get rendered correct like shown below.

```plaintext
$\frac{\partial F}{\partial x}$
```

The solution was to convert the `$...$` to `\(...\)`. 

```plaintext
\(\frac{\partial F}{\partial x}\)
```

The context was the following.

```html
<tr class="even">
<td><p>The gradient is 0 at minimum</p>
<p><span class="math display">$$\frac{\partial F}{\partial x} =
0$$</span></p>
<p>Where</p>
<p>\(\frac{\partial F}{\partial x}\) is a
vector value function of the <span class="math inline"><em>x</em></span>
vector.</p></td>
<td><p><span class="math display"><em>F</em>(<em>x</em>) = 0</span></p>
<p>Where</p>
<ul>
<li><p><span class="math inline"><em>F</em>(<em>x</em>)</span> is a
vector value function of
```