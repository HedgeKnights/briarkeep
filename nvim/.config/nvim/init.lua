vim.g.mapleader = " "
vim.g.maplocalleader = " "
-- Set up the runtime path to include Lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)

-- Now set up Lazy.nvim
require('lazy').setup({
  -- Add NvimTree plugin
{
  'nvim-tree/nvim-tree.lua',
  config = function()
    require('nvim-tree').setup {}
    vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "NvimTree: Toggle" })
  end
},
    -- You can add other plugins here later if you want
})

-- General Settings
-- Editor Settings
vim.o.number = true

