-- Shared parser for the `::: quiz :::` fenced-div format (see ../SKILL.md).
-- Used by quiz-web.lua and quiz-epub.lua so the format is defined once.

-- A paragraph with no blank lines between its "Field: value" lines parses
-- as one Para with SoftBreak-separated inlines, not one Para per line —
-- split on those breaks so each field line is matched independently.
local function para_lines(para)
  local lines, current = {}, {}
  for _, inline in ipairs(para.content) do
    if inline.t == "SoftBreak" or inline.t == "LineBreak" then
      table.insert(lines, pandoc.utils.stringify(pandoc.Inlines(current)))
      current = {}
    else
      table.insert(current, inline)
    end
  end
  table.insert(lines, pandoc.utils.stringify(pandoc.Inlines(current)))
  return lines
end

-- A line starting a new field ("Q:", "Correct:", ...) opens that field;
-- any line that doesn't match one of the four prefixes is a soft-wrapped
-- continuation of whichever field is currently open, and gets appended to it
-- (a plain word-wrap and a genuine next field both arrive as SoftBreak, so
-- only the recognized prefixes can tell them apart).
local function parse(div)
  local q = {question = nil, choices = {}, correct = nil, right = nil, wrong = nil}
  for _, block in ipairs(div.content) do
    if block.t == "Para" or block.t == "Plain" then
      local field, buf = nil, nil
      local function flush()
        if field == "question" then q.question = buf
        elseif field == "correct" then q.correct = tonumber(buf)
        elseif field == "right" then q.right = buf
        elseif field == "wrong" then q.wrong = buf
        end
      end
      for _, text in ipairs(para_lines(block)) do
        local rest = text:match("^Q:%s*(.*)")
        if rest then
          flush(); field, buf = "question", rest
        else
          rest = text:match("^Correct:%s*(%d+)")
          if rest then
            flush(); field, buf = "correct", rest
          else
            rest = text:match("^Right feedback:%s*(.*)")
            if rest then
              flush(); field, buf = "right", rest
            else
              rest = text:match("^Wrong feedback:%s*(.*)")
              if rest then
                flush(); field, buf = "wrong", rest
              elseif field then
                buf = buf .. " " .. text
              end
            end
          end
        end
      end
      flush()
    elseif block.t == "OrderedList" then
      for _, item in ipairs(block.content) do
        table.insert(q.choices, pandoc.utils.stringify(item))
      end
    end
  end
  return q
end

return {parse = parse}
