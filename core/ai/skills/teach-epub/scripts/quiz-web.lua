-- Renders `::: quiz :::` divs (see ../SKILL.md) as the interactive
-- click-to-answer widget. assets/quiz-widget.html supplies the click
-- behaviour and is injected once per page by build.py.

local script_dir = PANDOC_SCRIPT_FILE:match("(.*/)")
local quiz_parse = dofile(script_dir .. "quiz_parse.lua")

local letters = {"1", "2", "3", "4", "5", "6"}

function Div(el)
  if not el.classes:includes("quiz") then return nil end
  local q = quiz_parse.parse(el)

  local buttons = {}
  for i, choice in ipairs(q.choices) do
    table.insert(buttons, string.format(
      '<button data-choice="%s">%s</button>', letters[i], choice))
  end

  local html = string.format(
    '<div class="quiz" data-answer="%s" data-feedback-correct="%s" data-feedback-incorrect="%s">\n'
    .. '  <div class="q">%s</div>\n'
    .. '  <div class="choices">%s</div>\n'
    .. '  <div class="feedback"></div>\n'
    .. '</div>',
    letters[q.correct], q.right or "", q.wrong or "",
    q.question, table.concat(buttons, "\n"))

  return pandoc.RawBlock("html", html)
end
