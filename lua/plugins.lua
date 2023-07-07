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
