return {
{
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000, -- Essential: Load the theme before everything else
  config = function()
    -- This calls the file: lua/theme/init.lua
    require("theme").setup() 
  end,
},
{
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup({})
      -- Restoring your leader + e keybind
      vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle File Tree" })
    end,
  },
 {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      -- Add your preferred languages to this list
      ensure_installed = { 
        "lua", 
        "python", 
        "javascript", 
        "typescript", 
        "vim", 
        "vimdoc", 
        "query",
        "markdown",
        "markdown_inline"
      },
      highlight = { enable = true },
      indent = { enable = true },
    },
    config = function(_, opts)
      local status, treesitter = pcall(require, "nvim-treesitter.configs")
      if status then
        treesitter.setup(opts)
      end
    end,
  }, 
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help" })
    end,
  },

  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },

  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup({})
    end,
  },
}

