-- Rewrites workspace-root-relative image paths (see ../SKILL.md "Images") for
-- the site build: `assets/images/x.jpg` -> `<depth-prefix>assets/images/x.jpg`,
-- where the prefix (passed in via `--metadata imgprefix=...`) accounts for how
-- deep the output HTML file sits relative to the workspace root (deeper than
-- the source .md file, because of the `site/` wrapper directory).

local prefix = ""

local function Meta(m)
  if m.imgprefix then
    prefix = pandoc.utils.stringify(m.imgprefix)
  end
end

local function Image(el)
  if el.src:match("^assets/") then
    el.src = prefix .. el.src
  end
  return el
end

-- Two explicit passes: Meta must be read before any Image is rewritten, and a
-- single implicit filter table processes element types in an unspecified
-- order relative to each other (confirmed: Image ran before Meta without this
-- split), so Meta is forced into its own earlier pass here.
return {
  { Meta = Meta },
  { Image = Image },
}
