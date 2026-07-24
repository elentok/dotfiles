-- Rewrites cross-doc links (see ../SKILL.md "Cross-doc links") for the
-- EPUB build: `path.md#anchor` -> `#anchor` (the whole book is one file,
-- so the anchor alone reaches the target chapter).

function Link(el)
  local path, frag = el.target:match("^(.-%.md)(#.+)$")
  if path then
    el.target = frag
  end
  return el
end
