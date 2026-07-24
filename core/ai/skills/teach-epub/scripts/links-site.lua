-- Rewrites cross-doc links (see ../SKILL.md "Cross-doc links") for the
-- site build: `path.md#anchor` -> `path.html#anchor`.

function Link(el)
  local path, frag = el.target:match("^(.-%.md)(#?.*)$")
  if path then
    el.target = path:gsub("%.md$", ".html") .. frag
  end
  return el
end
