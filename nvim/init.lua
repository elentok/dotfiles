require("elentok/loadtime")
local util = require("elentok/util")
util.safe_require("impatient")

vim.api.nvim_command("source $DOTF/nvim/init-legacy.vim")

require("elentok")
-- disable for now (https://github.com/wbthomason/packer.nvim/issues/201)
-- require("packer_compiled")
