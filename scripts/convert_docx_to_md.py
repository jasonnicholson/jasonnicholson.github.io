#!/usr/bin/env python3
"""
Convert a .docx to Markdown using mammoth for .docx->HTML and html2text for HTML->Markdown.
Usage: convert_docx_to_md.py input.docx output.md media_dir
"""
import sys
import os
import io

try:
    import mammoth
    import html2text
except Exception as e:
    print("Missing dependencies; please install mammoth and html2text in the venv:")
    print("  .venv/bin/pip install mammoth html2text")
    raise


def main(argv):
    if len(argv) < 4:
        print("Usage: convert_docx_to_md.py input.docx output.md media_dir")
        return 2
    infile = argv[1]
    outfile = argv[2]
    media_dir = argv[3]

    os.makedirs(media_dir, exist_ok=True)

    image_counter = {"n": 0}

    def write_image(image):
        # image.content_type like 'image/png'
        image_counter['n'] += 1
        content_type = image.content_type or 'application/octet-stream'
        ext = content_type.split('/')[-1].split(';')[0]
        name = f"image{image_counter['n']}.{ext}"
        outpath = os.path.join(media_dir, name)
        # mammoth's Image may expose an "open()" returning a file-like object.
        # Use open() then read(), falling back to image.read() for older versions.
        imgdata = None
        try:
            # image.open() returns a closable resource; use as a context manager
            try:
                with image.open() as stream:
                    imgdata = stream.read()
            except TypeError:
                # fallback: if it's not a context manager, try to call and read
                stream = image.open()
                if hasattr(stream, 'read'):
                    imgdata = stream.read()
                else:
                    raise
        except Exception:
            if hasattr(image, 'read'):
                imgdata = image.read()
            else:
                raise
        with open(outpath, 'wb') as f:
            f.write(imgdata)
        # Return a path relative to the output markdown file
        rel = os.path.relpath(outpath, os.path.dirname(os.path.abspath(outfile)))
        # Use POSIX-style forward slashes for the site
        rel = rel.replace(os.path.sep, '/')
        return {"src": rel}

    with open(infile, 'rb') as docx_file:
        result = mammoth.convert_to_html(docx_file, convert_image=mammoth.images.img_element(write_image))
        html = result.value
        messages = result.messages

    # Convert HTML to markdown
    h = html2text.HTML2Text()
    h.body_width = 0
    h.unicode_snob = True
    md = h.handle(html)

    # Optionally, add a front-matter title based on filename
    title = os.path.splitext(os.path.basename(outfile))[0].replace('-', ' ').replace('_', ' ')
    fm = f"---\ntitle: \"{title}\"\n---\n\n"

    with open(outfile, 'w', encoding='utf-8') as f:
        f.write(fm)
        f.write(md)

    print(f"Wrote {outfile}")
    if messages:
        print("Conversion messages:")
        for m in messages:
            print(m)

    return 0

if __name__ == '__main__':
    sys.exit(main(sys.argv))
