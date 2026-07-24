# heewoong-me.github.io

The source for my personal academic homepage, live at
**<https://heewoong-me.github.io>**.

It is a **stripped-down [al-folio](https://github.com/alshedivat/al-folio)**
site: I kept only what a two-page **About + News** homepage needs and removed
the theme's blog, projects, bibliography, CV and demo content. The About page
is assembled by `_layouts/about.liquid` from a handful of small data files, so
updating the site is mostly editing YAML.

## What lives where

Everything on the site is edited from one of these files:

| To change… | Edit |
| --- | --- |
| Name, site URL, description, feature toggles | `_config.yml` |
| Intro paragraph + the contact/CV/social icon row | `_pages/about.md` |
| Profile photo | `assets/img/my_pic.png` |
| CV PDF (linked from the icon row) | `assets/pdf/heewoong_cv.pdf` |
| Education entries | `_data/education.yml` |
| Publications | `_data/publications.yml` |
| Co-author homepage links (for publication author names) | `_data/authors.yml` |
| Work experience | `_data/work.yml` |
| Honors | `_data/honors.yml` |
| News items (shown on About and `/news/`) | `_news/*.md` |

A couple of behaviors worth knowing:

- **Publications** are rendered by `_includes/publications.liquid`, not the al-folio
  bibliography engine. It auto-numbers entries `[C1], [C2], …` (newest first) and
  **bolds my own name**. Any co-author whose key exists in `_data/authors.yml` is
  linked to their homepage.
- **News items** render inline; they are set to `output: false` in `_config.yml`, so
  no standalone `/news/<item>/` pages are generated.

## Local preview

Requires Docker. From the repo root:

```bash
docker compose up
```

Then open <http://localhost:8080>. The site rebuilds automatically as you edit
files. Stop with `Ctrl-C` (or `docker compose down`).

## Deployment

Pushing to `main` triggers `.github/workflows/deploy.yml`, which builds the site
with Jekyll, purges unused CSS, and publishes the result to the `gh-pages`
branch. `gh-pages` is generated output — never edit it by hand.

## Credit

Built on [al-folio](https://github.com/alshedivat/al-folio) by Maruan Al-Shedivat
and contributors, released under the MIT License. See `LICENSE`.
