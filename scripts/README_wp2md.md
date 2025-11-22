# WordPress XML -> Markdown converter

A small helper to convert a WordPress export XML file to Markdown files with YAML front matter.

Usage

1. Create a Python virtualenv (optional but recommended):

```bash
python3 -m venv .venv
source .venv/bin/activate
```

2. Install requirements:

```bash
pip install -r scripts/requirements.txt
```

3. Run the converter:

```bash
python3 scripts/wp2md.py haleengineeringandsimulation.WordPress.2025-11-22.xml -o imported_wp
```

4. Optionally download media referenced by `wp:attachment_url` tags:

```bash
python3 scripts/wp2md.py haleengineeringandsimulation.WordPress.2025-11-22.xml -o imported_wp --download-media
```

Output layout

- `imported_wp/posts/` - blog posts (filename prefixed with date when available)
- `imported_wp/pages/` - pages
- `imported_wp/media/` - downloaded media when `--download-media` is used
- `imported_wp/media_map.json` - mapping of original attachment URLs to local files

Notes & next steps

- The script converts HTML to Markdown using `html2text`. The Markdown may need manual cleanup,
  especially for embedded shortcodes or complex HTML.
- Image links are left pointing at the original URLs. If you download media, `media_map.json`
  contains a mapping you can use to rewrite links across the Markdown files.
- I can run the conversion for you, download media, and/or implement automatic link rewriting — tell me which.
