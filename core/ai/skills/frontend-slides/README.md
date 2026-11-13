# Frontend Slides

Vendored from https://github.com/bbosoo/frontend-slides at commit `9906a34d640d2111f724544cbc50f7f130569ae1`. The original skill was created by [Zara Zhang](https://github.com/zarazhangrui) and is licensed under the MIT License.

## Local changes

This edition supports creating browser-native HTML presentations from scratch and improving existing HTML decks. We removed these upstream capabilities:

- `scripts/extract-pptx.py` and the PowerPoint conversion workflow because this repository only needs scratch-built HTML decks.
- `scripts/deploy.sh` and the Vercel workflow because the audited helper has unsafe path handling and cleanup behavior.
- `scripts/export-pdf.sh` and the PDF workflow because the audited local server permits path traversal and local-file disclosure.
- Unselected bold themes. This manual vendored copy contains only the eight chosen themes.

## Imported bold themes

- `block-frame`
- `blue-professional`
- `mat`
- `pink-script`
- `playful`
- `scatterbrain`
- `signal`
- `vellum`

Open [template-gallery.html](template-gallery.html) to review every upstream theme before changing the manual selection.
