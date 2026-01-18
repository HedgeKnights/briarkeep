local M = {}

function M.setup()
  require("catppuccin").setup({
    flavour = "mocha", -- latte, frappe, macchiato, mocha
    transparent_background = true, -- Matches Ghostty's background
    term_colors = true,
    integrations = {
      nvimtree = true,
      treesitter = true,
      telescope = { enabled = true },
      -- Add more integrations as you add plugins
    },
  })

  -- Actually activate the theme
  vim.cmd.colorscheme "catppuccin"
end

return M
