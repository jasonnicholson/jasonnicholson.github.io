#!/usr/bin/env python3
"""
Convert WordPress XML export to Markdown files with YAML front matter.

Usage:
  python scripts/wp2md.py path/to/export.xml -o imported_wp [--download-media]

This script uses `html2text` to convert post HTML to Markdown and optionally
downloads attachment URLs found in the export.
"""
import argparse
import os
import re
import sys
import json
from datetime import datetime
import xml.etree.ElementTree as ET

try:
    import html2text
except Exception:
    print("Missing dependency `html2text`. Install with: pip install -r scripts/requirements.txt")
    raise

try:
    import requests
except Exception:
    requests = None


def slugify(s):
    s = s or ""
    s = s.strip().lower()
    s = re.sub(r"[^a-z0-9]+", "-", s)
    s = re.sub(r"-+", "-", s)
    s = s.strip("-")
    return s or "untitled"


def text_from_html(html):
    h = html2text.HTML2Text()
    h.ignore_images = False
    h.ignore_links = False
    h.body_width = 0
    return h.handle(html or "")


def parse_wp_xml(xmlpath):
    tree = ET.parse(xmlpath)
    root = tree.getroot()
    items = []

    for item in root.findall('.//item'):
        data = {
            'title': '',
            'link': '',
            'pubDate': '',
            'content': '',
            'post_date': '',
            'post_name': '',
            'post_type': '',
            'post_status': '',
            'attachment_url': [],
            'categories': [],
            'tags': [],
            'wp_post_id': None,
        }

        for child in item:
            tag = child.tag
            if '}' in tag:
                local = tag.split('}', 1)[1]
            else:
                local = tag

            if local == 'title':
                data['title'] = child.text or ''
            elif local == 'link':
                data['link'] = child.text or ''
            elif local == 'pubDate':
                data['pubDate'] = child.text or ''
            elif local == 'encoded':
                data['content'] = child.text or ''
            elif local == 'post_date':
                data['post_date'] = child.text or ''
            elif local == 'post_name':
                data['post_name'] = child.text or ''
            elif local == 'post_type':
                data['post_type'] = child.text or ''
            elif local in ('status', 'post_status'):
                data['post_status'] = child.text or ''
            elif local == 'attachment_url':
                if child.text:
                    data['attachment_url'].append(child.text)
            elif local == 'post_id' or local == 'post_id':
                data['wp_post_id'] = child.text or None
            elif local == 'category':
                domain = child.get('domain') or ''
                cat_text = child.text or ''
                if domain == 'category':
                    data['categories'].append(cat_text)
                elif domain in ('post_tag', 'tag'):
                    data['tags'].append(cat_text)

        items.append(data)

    return items


def write_markdown(item, outdir):
    post_type = item.get('post_type') or 'post'
    status = item.get('post_status') or 'publish'

    date = item.get('post_date') or item.get('pubDate')
    if date:
        try:
            # try WordPress date format
            dt = datetime.fromisoformat(date[:19])
        except Exception:
            try:
                dt = datetime.strptime(date, '%a, %d %b %Y %H:%M:%S %z')
            except Exception:
                dt = None
    else:
        dt = None

    slug = item.get('post_name') or slugify(item.get('title'))
    if dt:
        date_prefix = dt.strftime('%Y-%m-%d')
    else:
        date_prefix = ''

    filename = slug
    if post_type == 'post' and date_prefix:
        filename = f"{date_prefix}-{slug}.md"
    else:
        filename = f"{slug}.md"

    subdir = 'posts' if post_type == 'post' else 'pages'
    folder = os.path.join(outdir, subdir)
    os.makedirs(folder, exist_ok=True)
    path = os.path.join(folder, filename)

    front = []
    front.append('---')
    title_escaped = item.get('title', '').replace('"', '\\"')
    front.append(f'title: "{title_escaped}"')
    if dt:
        front.append(f"date: {dt.isoformat()}")
    front.append(f"draft: {str(status != 'publish').lower()}")
    if item.get('categories'):
        cats = '[' + ', '.join([f'"{c}"' for c in item.get('categories')]) + ']'
        front.append(f"categories: {cats}")
    if item.get('tags'):
        tags = '[' + ', '.join([f'"{t}"' for t in item.get('tags')]) + ']'
        front.append(f"tags: {tags}")
    front.append(f"slug: {slug}")
    if item.get('link'):
        front.append(f"original_link: \"{item.get('link')}\"")
    if item.get('wp_post_id'):
        front.append(f"wp_post_id: {item.get('wp_post_id')}")
    if item.get('attachment_url'):
        front.append(f"attachments: {json.dumps(item.get('attachment_url'))}")
    front.append('---\n')

    content_md = text_from_html(item.get('content') or '')

    with open(path, 'w', encoding='utf-8') as f:
        f.write('\n'.join(front))
        f.write(content_md)

    return path


def download_attachments(items, outdir):
    if requests is None:
        print('`requests` not installed; cannot download attachments. Install requirements and try again.')
        return {}

    media_dir = os.path.join(outdir, 'media')
    os.makedirs(media_dir, exist_ok=True)
    mapping = {}
    for item in items:
        for url in item.get('attachment_url', []):
            try:
                r = requests.get(url, timeout=30)
                if r.status_code == 200:
                    fname = os.path.basename(url.split('?')[0]) or slugify(url)
                    local = os.path.join('media', fname)
                    with open(os.path.join(outdir, local), 'wb') as fh:
                        fh.write(r.content)
                    mapping[url] = local
                    print(f'Downloaded {url} -> {local}')
                else:
                    print(f'Failed to download {url}: HTTP {r.status_code}')
            except Exception as e:
                print(f'Error downloading {url}: {e}')
    with open(os.path.join(outdir, 'media_map.json'), 'w', encoding='utf-8') as m:
        json.dump(mapping, m, indent=2)
    return mapping


def main():
    p = argparse.ArgumentParser(description='Convert WP XML to Markdown')
    p.add_argument('xmlfile', help='WordPress export XML file')
    p.add_argument('-o', '--out', default='imported_wp', help='Output directory')
    p.add_argument('--download-media', action='store_true', help='Attempt to download attachment URLs')
    args = p.parse_args()

    xmlfile = args.xmlfile
    outdir = args.out

    if not os.path.exists(xmlfile):
        print('XML file not found:', xmlfile)
        sys.exit(2)

    print('Parsing XML...')
    items = parse_wp_xml(xmlfile)
    print(f'Found {len(items)} items')

    written = []
    for item in items:
        # skip WP items that are attachments only
        if (item.get('post_type') or '').lower() == 'attachment':
            continue
        # write published and draft posts/pages
        path = write_markdown(item, outdir)
        written.append(path)

    print(f'Wrote {len(written)} markdown files under {outdir}')

    if args.download_media:
        print('Downloading attachments...')
        mapping = download_attachments(items, outdir)
        print(f'Downloaded {len(mapping)} attachments (see media_map.json)')


if __name__ == '__main__':
    main()
