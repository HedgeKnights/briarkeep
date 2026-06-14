local M = {}

local function get_flavour()
  local theme_file = vim.fn.expand("~/.config/hypr/themes/current/nvim-theme")
  local f = io.open(theme_file, "r")
  if f then
    local flavour = vim.trim(f:read("*l") or "")
    f:close()
    if flavour ~= "" then return flavour end
  end
  return "mocha"
end

function M.setup()
  require("catppuccin").setup({
    flavour = get_flavour(),
    transparent_background = true,
    term_colors = true,
    integrations = {
      nvimtree = true,
      treesitter = true,
      telescope = { enabled = true },
    },
  })

  vim.cmd.colorscheme "catppuccin"
end

function M.reload()
  local flavour = get_flavour()
  require("catppuccin").setup({ flavour = flavour, transparent_background = true, term_colors = true })
  vim.cmd.colorscheme "catppuccin"
end

return M
