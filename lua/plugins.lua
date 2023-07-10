-- lsp zero
    local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

    -- Auto-install lazy.nvim if not present
    if not vim.loop.fs_stat(lazypath) then
      print('Installing lazy.nvim....')
      vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
      })
    end

    vim.opt.rtp:prepend(lazypath)

    require('lazy').setup({
      {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        dependencies = {
          -- LSP Support
          {'neovim/nvim-lspconfig'},             -- Required
          {                                      -- Optional
            'williamboman/mason.nvim',
            build = function()
              pcall(vim.cmd, 'MasonUpdate')
            end,
          },
          {'williamboman/mason-lspconfig.nvim'}, -- Optional

          -- Autocompletion
          {'hrsh7th/nvim-cmp'},     -- Required
          {'hrsh7th/cmp-nvim-lsp'}, -- Required
          {'L3MON4D3/LuaSnip'},     -- Required
          -- Themes
          {'Mofiqul/dracula.nvim'},
          -- End of themes
          -- tmux navigator
          {'christoomey/vim-tmux-navigator'},
          -- end of tmux navigator
          -- flash.nvim
          {
           "folke/flash.nvim",
           event = "VeryLazy",
           ---@type Flash.Config
           opts = {},
           keys = {
             {
               "s",
               mode = { "n", "x", "o" },
               function()
                 require("flash").jump()
               end,
               desc = "Flash",
             },
             {
               "S",
               mode = { "n", "o", "x" },
               function()
                 require("flash").treesitter()
               end,
               desc = "Flash Treesitter",
             },
             {
               "r",
               mode = "o",
               function()
                 require("flash").remote()
               end,
               desc = "Remote Flash",
             },
             {
               "R",
               mode = { "o", "x" },
               function()
                 require("flash").treesitter_search()
               end,
               desc = "Flash Treesitter Search",
             },
             {
               "<c-s>",
               mode = { "c" },
               function()
                 require("flash").toggle()
               end,
               desc = "Toggle Flash Search",
             },
           },
         },
          -- end of flash.nvim
          -- Obsidian
           {
              "epwalsh/obsidian.nvim",
              lazy = true,
              event = { "BufReadPre path/to/my-vault/**.md" },
              -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand':
              -- event = { "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md" },
              dependencies = {
                -- Required.
                "nvim-lua/plenary.nvim",
            
                -- Optional, for completion.
                "hrsh7th/nvim-cmp",
            
                -- Optional, for search and quick-switch functionality.
                "nvim-telescope/telescope.nvim",
            
                -- Optional, an alternative to telescope for search and quick-switch functionality.
                -- "ibhagwan/fzf-lua"
            
                -- Optional, another alternative to telescope for search and quick-switch functionality.
                -- "junegunn/fzf",
                -- "junegunn/fzf.vim"
            
                -- Optional, alternative to nvim-treesitter for syntax highlighting.
                "godlygeek/tabular",
                "preservim/vim-markdown",
              },
              opts = {
                dir = "~/my-vault",  -- no need to call 'vim.fn.expand' here
            
                -- Optional, if you keep notes in a specific subdirectory of your vault.
                notes_subdir = "notes",
            
                -- Optional, set the log level for Obsidian. This is an integer corresponding to one of the log
                -- levels defined by "vim.log.levels.*" or nil, which is equivalent to DEBUG (1).
                log_level = vim.log.levels.DEBUG,
            
                daily_notes = {
                  -- Optional, if you keep daily notes in a separate directory.
                  folder = "notes/dailies",
                  -- Optional, if you want to change the date format for daily notes.
                  date_format = "%Y-%m-%d"
                },
            
                -- Optional, completion.
                completion = {
                  -- If using nvim-cmp, otherwise set to false
                  nvim_cmp = true,
                  -- Trigger completion at 2 chars
                  min_chars = 2,
                  -- Where to put new notes created from completion. Valid options are
                  --  * "current_dir" - put new notes in same directory as the current buffer.
                  --  * "notes_subdir" - put new notes in the default notes subdirectory.
                  new_notes_location = "current_dir"
                },
            
                -- Optional, customize how names/IDs for new notes are created.
                note_id_func = function(title)
                  -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
                  -- In this case a note with the title 'My new note' will given an ID that looks
                  -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
                  local suffix = ""
                  if title ~= nil then
                    -- If title is given, transform it into valid file name.
                    suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
                  else
                    -- If title is nil, just add 4 random uppercase letters to the suffix.
                    for _ = 1, 4 do
                      suffix = suffix .. string.char(math.random(65, 90))
                    end
                  end
                  return tostring(os.time()) .. "-" .. suffix
                end,
            
                -- Optional, set to true if you don't want Obsidian to manage frontmatter.
                disable_frontmatter = false,
            
                -- Optional, alternatively you can customize the frontmatter data.
                note_frontmatter_func = function(note)
                  -- This is equivalent to the default frontmatter function.
                  local out = { id = note.id, aliases = note.aliases, tags = note.tags }
                  -- `note.metadata` contains any manually added fields in the frontmatter.
                  -- So here we just make sure those fields are kept in the frontmatter.
                  if note.metadata ~= nil and require("obsidian").util.table_length(note.metadata) > 0 then
                    for k, v in pairs(note.metadata) do
                      out[k] = v
                    end
                  end
                  return out
                end,
            
--                -- Optional, for templates (see below).
--                templates = {
--                  subdir = "templates",
--                  date_format = "%Y-%m-%d-%a",
--                  time_format = "%H:%M",
--                },
            
                -- Optional, by default when you use `:ObsidianFollowLink` on a link to an external
                -- URL it will be ignored but you can customize this behavior here.
                follow_url_func = function(url)
                  -- Open the URL in the default web browser.
                  vim.fn.jobstart({"open", url})  -- Mac OS
                  -- vim.fn.jobstart({"xdg-open", url})  -- linux
                end,
            
                -- Optional, set to true if you use the Obsidian Advanced URI plugin.
                -- https://github.com/Vinzent03/obsidian-advanced-uri
                use_advanced_uri = true,
            
                -- Optional, set to true to force ':ObsidianOpen' to bring the app to the foreground.
                open_app_foreground = false,
            
                -- Optional, by default commands like `:ObsidianSearch` will attempt to use
                -- telescope.nvim, fzf-lua, and fzf.nvim (in that order), and use the
                -- first one they find. By setting this option to your preferred
                -- finder you can attempt it first. Note that if the specified finder
                -- is not installed, or if it the command does not support it, the
                -- remaining finders will be attempted in the original order.
                finder = "telescope.nvim",
              },
              config = function(_, opts)
                require("obsidian").setup(opts)
            
                -- Optional, override the 'gf' keymap to utilize Obsidian's search functionality.
                -- see also: 'follow_url_func' config option above.
                vim.keymap.set("n", "gf", function()
                  if require("obsidian").util.cursor_on_markdown_link() then
                    return "<cmd>ObsidianFollowLink<CR>"
                  else
                    return "gf"
                  end
                end, { noremap = false, expr = true })
              end,
            },
          -- end of Obsidian
          -- Git related plugins
          {'tpope/vim-fugitive'},
          {'tpope/vim-rhubarb'},
          {'lewis6991/gitsigns.nvim'},
          -- end of git related plugins
          -- which key is it?
          {
           'folke/which-key.nvim',
           event = 'VeryLazy',
           init = function()
             vim.o.timeout = true
             vim.o.timeoutlen = 300
           end,
           opts = {
             -- your configuration comes here
             -- or leave it empty to use the default settings
             -- refer to the configuration section below
           }
         },
          -- Oh that's what key it is!
          -- vim surround
          {'tpope/vim-surround'},
          -- end of vim surround
          -- Auto pais
          {
           'windwp/nvim-autopairs',
           event = "InsertEnter",
           opts = {} -- this is equalent to setup({}) function
        },
          -- end of auto pairs
        }
      }
    })

    local lsp = require('lsp-zero').preset({})

    lsp.on_attach(function(client, bufnr)
      lsp.default_keymaps({buffer = bufnr})
    end)

    -- (Optional) Configure lua language server for neovim
    require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

    lsp.setup()
-- End of lsp zero
