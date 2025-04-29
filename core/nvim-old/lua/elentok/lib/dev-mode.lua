local is_dev_mode = true

local gitconfig = vim.env.HOME .. '/.dotfiles/.git/config'
for line in io.lines(gitconfig) do
  if string.find(line, 'https://github.com/elentok') then
    is_dev_mode = false
    break
  end
end

return  is_dev_mode
