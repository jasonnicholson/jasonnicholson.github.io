#!/usr/bin/env python3
"""
Rewrite media URLs in Markdown files to local downloaded media paths.

Usage:
  python scripts/rewrite_media_links.py imported_wp

This reads `imported_wp/media_map.json` (created by `wp2md.py --download-media`)
and replaces occurrences of the original URLs in all Markdown files under
`imported_wp/posts/` and `imported_wp/pages/` with relative paths to the
downloaded files.
"""
import json
import os
import sys
from pathlib import Path


def load_map(root):
    path = os.path.join(root, 'media_map.json')
    if not os.path.exists(path):
        print('media_map.json not found in', root)
        return {}
    with open(path, 'r', encoding='utf-8') as f:
        return json.load(f)


def rewrite_in_file(md_path, mapping, root):
    changed = False
    with open(md_path, 'r', encoding='utf-8') as f:
        txt = f.read()

    for orig, local in mapping.items():
        # compute relative path from this md file to the local media file
        absolute_local = os.path.join(root, local)
        rel = os.path.relpath(absolute_local, start=os.path.dirname(md_path))
        # use POSIX-style forward slashes for Markdown
        rel = Path(rel).as_posix()
        if orig in txt:
            txt = txt.replace(orig, rel)
            changed = True

    if changed:
        with open(md_path, 'w', encoding='utf-8') as f:
            f.write(txt)
    return changed


def main():
    if len(sys.argv) < 2:
        print('Usage: rewrite_media_links.py imported_wp')
        sys.exit(2)

    root = sys.argv[1]
    mapping = load_map(root)
    if not mapping:
        print('No mapping to rewrite. Exiting.')
        return

    md_dirs = [os.path.join(root, 'posts'), os.path.join(root, 'pages')]
    total = 0
    updated = 0
    for md_dir in md_dirs:
        if not os.path.isdir(md_dir):
            continue
        for dirpath, _, files in os.walk(md_dir):
            for fn in files:
                if not fn.lower().endswith('.md'):
                    continue
                md_path = os.path.join(dirpath, fn)
                total += 1
                if rewrite_in_file(md_path, mapping, root):
                    updated += 1

    print(f'Rewrote links in {updated} of {total} markdown files')


if __name__ == '__main__':
    main()
