-- Renders `::: quiz :::` divs (see ../SKILL.md) as a static answer key:
-- choices listed, correct answer given as a number, never the full choice
-- text repeated (map decision: issues/06-quiz-representation.md).

local script_dir = PANDOC_SCRIPT_FILE:match("(.*/)")
local quiz_parse = dofile(script_dir .. "quiz_parse.lua")

function Div(el)
  if not el.classes:includes("quiz") then return nil end
  local q = quiz_parse.parse(el)

  local items = {}
  for _, choice in ipairs(q.choices) do
    table.insert(items, {pandoc.Para({pandoc.Str(choice)})})
  end

  local blocks = {
    pandoc.Para({pandoc.Strong({pandoc.Str(q.question)})}),
    pandoc.OrderedList(items),
    pandoc.Para({pandoc.Emph({pandoc.Str("Answer: " .. q.correct)})}),
  }

  return pandoc.Div(blocks, pandoc.Attr("", {"quiz-static"}))
end
