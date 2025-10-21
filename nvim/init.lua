--
-- Author: Michael Navarro (https://github.com/navazjm)
--

-- In order to update plugins, you have to remove all subfolders in
-- "~/.local/share/nvim/site/pack/core/opt/" then open Neovim to which you
-- will be prompted to install plugins again.
-- sh: rm -rf ~/.local/share/nvim/site/pack/core/opt/* && nvim

-- local development of plugins:
--
vim.opt.rtp:prepend(vim.fn.expand("~/dev/ascua.nvim")) -- my custom color scheme (https://github.com/navazjm/ascua.nvim), nice little "plug"in. Man, I am so funny...kekw
--
-- **NOTE**: if plugin was first installed with vim.pack.add, you will need to
-- remove its subfolder from ~/.local/share/nvim/site/pack/core/opt/
-- ~/.local/share/nvim/site/pack/core/opt
--
-- end local development of plugins

local keymap = vim.keymap.set

-------------------------------------------------------------------------------
-- OPTIONS --
-------------------------------------------------------------------------------

vim.o.backup = false -- creates a backup file
vim.o.breakindent = true
vim.o.clipboard = "unnamedplus" -- allows neovim to access the system clipboard
vim.o.cmdheight = 2 -- more space in the neovim command line for displaying messages
vim.o.completeopt = "menuone,noselect,popup,fuzzy" -- mostly just for cmp
vim.o.conceallevel = 0 -- so that `` is visible in markdown files
vim.o.fileencoding = "utf-8" -- the encoding written to a file
vim.o.hlsearch = true -- highlight all matches on previous search pattern
vim.o.ignorecase = true -- ignore case in search patterns
vim.o.mouse = "a" -- allow the mouse to be used in neovim
vim.o.pumheight = 10 -- pop up menu height
vim.o.showmode = false -- we don't need to see things like -- INSERT -- anymore
vim.o.showtabline = 0 -- never show tabs
vim.o.smartcase = true -- smart case
vim.o.smartindent = true -- make indenting smarter again
vim.o.splitbelow = true -- force all horizontal splits to go below current window
vim.o.splitright = true -- force all vertical splits to go to the right of current window
vim.o.swapfile = false -- creates a swapfile
vim.o.termguicolors = true -- set term gui colors (most terminals support this)
vim.o.timeoutlen = 500 -- time to wait for a mapped sequence to complete (in milliseconds)
vim.o.undofile = true -- enable persistent undo
vim.o.updatetime = 300 -- faster completion (4000ms default)
vim.o.writebackup = false -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
vim.o.expandtab = true -- convert tabs to spaces
vim.o.shiftwidth = 4 -- the number of spaces inserted for each indentation
vim.o.tabstop = 4 -- insert 4 spaces for a tab
vim.o.softtabstop = 4
vim.o.cursorline = true -- highlight the current line
vim.o.number = true -- set numbered lines
vim.o.relativenumber = true -- set relative numbered lines
vim.o.numberwidth = 4 -- set number column width to 4 {default 4}
vim.o.signcolumn = "yes" -- always show the sign column, otherwise it would shift the text each time
vim.o.wrap = false -- display lines as one long line
vim.o.scrolloff = 8
vim.o.sidescrolloff = 8
vim.o.laststatus = 3
vim.o.colorcolumn = "80"
vim.o.spelllang = "en_us"
vim.opt.list = true
vim.opt.listchars = {
    -- space = "·",     -- Show ALL spaces as dots
    leadmultispace = "‧", -- Show leading spaces as dots
    tab = "→ ", -- Show tabs as arrows
    -- eol = "↴",       -- Show end of line (optional)
    trail = "•", -- Show trailing spaces
    extends = "⟩", -- Show line extends beyond screen
    precedes = "⟨", -- Show line precedes screen
}

vim.cmd("set whichwrap+=<,>,[,],h,l")
vim.cmd([[set iskeyword+=-]])

-- highlight animation on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank({ higroup = "cursor", timeout = 150 })
    end,
    pattern = "*",
})

-- help recognize razor files
vim.filetype.add({
    extension = {
        razor = "razor",
        cshtml = "razor",
    },
})

-------------------------------------------------------------------------------
-- PLUGINS --
-------------------------------------------------------------------------------

vim.pack.add({
    -- dependencies
    { src = "https://github.com/nvim-lua/plenary.nvim" }, -- utility lib that some plugins depend on...
    { src = "https://github.com/nvim-tree/nvim-web-devicons" }, -- NerdFont icons
    { src = "https://git.sr.ht/~whynothugo/lsp_lines.nvim" }, -- virtual line diagnostics
    -- main
    { src = "https://github.com/numToStr/Comment.nvim" }, -- easy code commenting
    { src = "https://github.com/ej-shafran/compile-mode.nvim" }, -- emacs like Compilation Mode (one thing emacs does right)
    { src = "https://github.com/stevearc/conform.nvim" }, -- code formatter
    { src = "https://github.com/lewis6991/gitsigns.nvim" }, -- git integration
    { src = "https://github.com/ibhagwan/fzf-lua" }, -- fuzzy finder
    { src = "https://github.com/lukas-reineke/indent-blankline.nvim" }, -- indent guides
    { src = "https://github.com/nvim-lualine/lualine.nvim" }, -- status line
    { src = "https://github.com/neovim/nvim-lspconfig" }, -- lsp
    { src = "https://github.com/SmiteshP/nvim-navic" }, -- breadcrumbs
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" }, -- better syntax highlighting
    { src = "https://github.com/JoosepAlviste/nvim-ts-context-commentstring" }, -- better code comment for files with multiple languages, like react
    { src = "https://github.com/stevearc/oil.nvim" }, -- file tree

    -- razor lsp
    { src = "https://github.com/tris203/rzls.nvim" },
    { src = "https://github.com/seblyng/roslyn.nvim" },
})
require("lsp_lines").setup({})
vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = { library = vim.api.nvim_get_runtime_file("", true) },
            telemetry = { enable = false },
        },
    },
})
local rzls_base_path = vim.fn.expand("~/tools/razor/artifacts/LanguageServer/Debug/net9.0/linux-x64")
require("rzls").setup({
    path = vim.fs.joinpath(rzls_base_path, "rzls"),
    on_attach = function(client, bufnr) end,
    capabilities = {},
})
vim.lsp.config("roslyn", {
    handlers = require("rzls.roslyn_handlers"),
    cmd = {
        "dotnet",
        vim.fn.expand("~/tools/roslyn/Microsoft.CodeAnalysis.LanguageServer.dll"),
        "--stdio",
        "--logLevel=Information",
        "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.log.get_filename()),
        "--razorSourceGenerator=" .. vim.fs.joinpath(rzls_base_path, "Microsoft.CodeAnalysis.Razor.Compiler.dll"),
        "--razorDesignTimePath="
            ..vim.fs.joinpath(rzls_base_path, "Targets", "Microsoft.NET.Sdk.Razor.DesignTime.targets"),
        "--extension",
        vim.fn.expand("~/tools/razor/artifacts/bin/Microsoft.VisualStudioCode.RazorExtension/Debug/net9.0/Microsoft.VisualStudioCode.RazorExtension.dll"),
    },
})
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local bufnr = args.buf
        local client =
            assert(vim.lsp.get_client_by_id(args.data.client_id), "must have valid client")
        if client.server_capabilities.documentSymbolProvider then
            require("nvim-navic").attach(client, bufnr)
        end

        if client:supports_method("textDocument/completion") then
            -- Default triggerCharacters is dot only { "." }
            --client.server_capabilities.completionProvider.triggerCharacters
            vim.lsp.completion.enable(true, client.id, bufnr, {
                autotrigger = true,
                convert = function(item)
                    return { abbr = item.label:gsub("%b()", "") }
                end,
            })
        end

        vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
        keymap("n", "gd", vim.lsp.buf.definition, { buffer = bufnr })
        keymap("n", "gdv", "<CMD>vsplit | lua vim.lsp.buf.definition()<CR>", { buffer = bufnr })
        keymap("n", "gdd", vim.lsp.buf.declaration, { buffer = bufnr })
        keymap("n", "gj", vim.lsp.buf.hover, { buffer = bufnr })
        keymap("n", "gr", vim.lsp.buf.references, { buffer = bufnr })
        keymap("n", "gt", vim.lsp.buf.type_definition, { buffer = bufnr })
        keymap("n", "gl", vim.diagnostic.open_float, { buffer = bufnr })
        keymap("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr })
        keymap("n", "<space>ca", vim.lsp.buf.code_action, { buffer = bufnr })
        keymap("n", "<leader>dn", function()
            vim.diagnostic.jump({ count = 1, float = true })
        end, { buffer = bufnr })
        keymap("n", "<leader>dp", function()
            vim.diagnostic.jump({ count = -1, float = true })
        end, { buffer = bufnr })

        vim.keymap.set("i", "<C-j>", vim.lsp.completion.get, { buffer = bufnr })
    end,
}) -- end LspAttach
vim.diagnostic.config({ virtual_text = false, virtual_lines = false })
vim.lsp.enable({"bashls", "clangd", "cmake", "lua_ls", "roslyn"})

require("Comment").setup({
    pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
}) -- end Comment

require("conform").setup({
    formatters_by_ft = {
        lua = { "stylua" },
    },
}) -- end conform

require("fzf-lua").setup({
    "hide",
    -- TODO: setup
}) -- end fzf-lua

require("gitsigns").setup({
    signs = {
        add = { text = "┃" },
        change = { text = "┃" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
    },
    signs_staged = {
        add = { text = "┃" },
        change = { text = "┃" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
    },
    signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
    numhl = true, -- Toggle with `:Gitsigns toggle_numhl`
    linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
    word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
    watch_gitdir = {
        interval = 1000,
        follow_files = true,
    },
    attach_to_untracked = true,
    -- similar to GitLens in VSCode
    current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false,
    },
    --                              who     , when            , commit hash  - commit msg
    current_line_blame_formatter = "<author>, <author_time:%c>, <abbrev_sha> - <summary>",
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil, -- Use default
    max_file_length = 40000,
    preview_config = {
        -- Options passed to nvim_open_win
        border = "single",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
    },
}) -- end gitsigns

require("ibl").setup({
    indent = {
        char = "⁞", -- "│", "▎", "┊", "", "⁞"
    },
    scope = {
        show_end = true,
    },
    whitespace = {
        highlight = "IblWhitespace",
        remove_blankline_trail = false,
    },
}) -- end indent-blankline

local lualine_progress = function()
    local current_line = vim.fn.line(".")
    local total_lines = vim.fn.line("$")
    local chars =
        { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
    local line_ratio = current_line / total_lines
    local index = math.ceil(line_ratio * #chars)
    return chars[index]
end

local lualine_spaces = function()
    return "spaces: " .. vim.bo[0].shiftwidth
end
local lualine_solution = function()
    local sln = vim.g.roslyn_nvim_selected_solution
    if sln == nil then
        return ""
    end
    return sln
end

require("lualine").setup({
    options = {
        icons_enabled = true,
        theme = "auto",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {},
        always_divide_middle = true,
        always_show_tabline = false,
        globalstatus = true,
    },
    sections = {
        lualine_a = {
            {
                "filetype",
                colored = false,
                icon_only = true,
                padding = { right = 0 },
            },
            {
                "filename",
                path = 4,
                padding = { left = 0 },
            },
            {
                "diagnostics",
                sources = { "nvim_diagnostic" },
                sections = { "error", "warn" },
                symbols = { error = " ", warn = " " },
                colored = false,
                update_in_insert = false,
                always_visible = true,
            },
        },
        lualine_b = {
            {
                "branch",
                icon = "",
            },
            {
                "diff",
                colored = false,
                symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
                cond = function()
                    return vim.fn.winwidth(0) > 80
                end,
            },
        },
        lualine_c = {
            {
                "mode",
                fmt = function(str)
                    return "-- " .. str .. " --"
                end,
            },
        },
        lualine_x = { lualine_solution, lualine_spaces, "encoding" },
        lualine_y = {
            {
                "location",
                padding = 0,
            },
        },
        lualine_z = { lualine_progress },
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
    },
    tabline = {},
    winbar = {
        lualine_c = {
            function()
                local navic = require("nvim-navic")
                local loc = navic.get_location()
                -- If there is no context, show a placeholder
                return loc ~= "" and loc or " "
            end,
        },
    },
    inactive_winbar = {},
    extensions = {},
}) -- end lualine

require("nvim-navic").setup({
    icons = {
        File = "󰈙 ",
        Module = " ",
        Namespace = "󰌗 ",
        Package = " ",
        Class = "󰌗 ",
        Method = "󰆧 ",
        Property = " ",
        Field = " ",
        Constructor = " ",
        Enum = "󰕘",
        Interface = "󰕘",
        Function = "󰊕 ",
        Variable = "󰆧 ",
        Constant = "󰏿 ",
        String = "󰀬 ",
        Number = "󰎠 ",
        Boolean = "◩ ",
        Array = "󰅪 ",
        Object = "󰅩 ",
        Key = "󰌋 ",
        Null = "󰟢 ",
        EnumMember = " ",
        Struct = "󰌗 ",
        Event = " ",
        Operator = "󰆕 ",
        TypeParameter = "󰊄 ",
    },
    lsp = {
        auto_attach = false,
        preference = nil,
    },
    highlight = false,
    separator = " > ",
    depth_limit = 0,
    depth_limit_indicator = "..",
    safe_output = true,
    lazy_update_context = false,
    click = false,
    format_text = function(text)
        return text
    end,
}) -- end nvim-navic

local ensure_installed = {
    "angular",
    "bash",
    "c",
    "c_sharp",
    "cpp",
    "css",
    "dockerfile",
    "editorconfig",
    "html",
    "javascript",
    "json",
    "lua",
    "luadoc",
    "make",
    "markdown",
    "markdown_inline",
    "powershell",
    "razor",
    "regex",
    "typescript",
    "vim",
    "vimdoc",
    "yaml",
}
local treesitter = require("nvim-treesitter")
treesitter.setup({
    -- A list of parser names, or "all" (the listed parsers MUST always be installed)
    ensure_installed = ensure_installed,
    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,
    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = true,
    -- List of parsers to ignore installing (or "all")
    ignore_install = {},
    highlight = {
        enable = true,
        -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
        -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
        -- the name of the parser)
        --
        -- list of language that will be disabled
        -- disable = { "c", "rust" },
        --
        -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
        disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
                return true
            end
        end,
        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
    },
})
local already_installed = treesitter.get_installed()
local parsers_to_install = vim.iter(ensure_installed)
    :filter(function(parser)
        return not vim.tbl_contains(already_installed, parser)
    end)
    :totable()
treesitter.install(parsers_to_install)
-- Auto-install and start parsers for any buffer
vim.api.nvim_create_autocmd({ "FileType" }, {
    desc = "Enable Treesitter",
    callback = function(event)
        local bufnr = event.buf
        local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })

        -- Skip if no filetype
        if filetype == "" then
            return
        end

        -- Get parser name based on filetype
        local parser_name = vim.treesitter.language.get_lang(filetype)
        if not parser_name then
            vim.notify(
                vim.inspect("No treesitter parser found for filetype: " .. filetype),
                vim.log.levels.WARN
            )
            return
        end

        -- Try to get existing parser
        local parser_configs = require("nvim-treesitter.parsers")
        if not parser_configs[parser_name] then
            return -- Parser not available, skip silently
        end

        local parser_exists = pcall(vim.treesitter.get_parser, bufnr, parser_name)

        if not parser_exists then
            -- check if parser is already installed
            if vim.tbl_contains(already_installed, parser_name) then
                vim.notify(
                    "Parser for " .. parser_name .. " already installed.",
                    vim.log.levels.INFO
                )
            else
                -- If not installed, install parser synchronously
                vim.notify("Installing parser for " .. parser_name, vim.log.levels.INFO)
                treesitter.install({ parser_name }):wait(300000) -- wait max. 5 minutes
            end
        end

        -- Start treesitter for this buffer
        vim.treesitter.start(bufnr, parser_name)
        -- Use regex based syntax-highlighting as fallback as some plugins might need it
        vim.bo[bufnr].syntax = "ON"
        -- Use treesitter for folds
        vim.wo.foldlevel = 99
        vim.wo.foldmethod = "expr"
        vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.wo.foldtext = "v:lua.vim.treesitter.foldtext()"
        -- Use treesitter for indentation
        vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
})

require("oil").setup({
    columns = { "icon" },
    keymaps = {
        ["g?"] = { "actions.show_help", mode = "n" },
        ["<CR>"] = "actions.select",
        ["<C-s>"] = { "actions.select", opts = { vertical = true } },
        ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
        ["<C-t>"] = { "actions.select", opts = { tab = true } },
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = { "actions.close", mode = "n" },
        ["<C-l>"] = "actions.refresh",
        ["-"] = { "actions.parent", mode = "n" },
        ["_"] = { "actions.open_cwd", mode = "n" },
        ["`"] = { "actions.cd", mode = "n" },
        ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
        ["gs"] = { "actions.change_sort", mode = "n" },
        ["gx"] = "actions.open_external",
        ["g."] = { "actions.toggle_hidden", mode = "n" },
        ["g\\"] = { "actions.toggle_trash", mode = "n" },
    },
    view_options = {
        show_hidden = true,
    },
}) -- end oil

-------------------------------------------------------------------------------
-- KEYMAPS --
-------------------------------------------------------------------------------

keymap("", "<Space>", "<Nop>")
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Normal --
keymap("n", "<leader>sn", "<CMD>source ~/.config/nvim/init.lua<CR>")

-- write current buffer
keymap("n", "<leader>w", "<CMD>w<CR>")
keymap("n", "<leader>wq", "<CMD>w | bd!<CR>")

-- close buffers
keymap("n", "<leader>q", "<CMD>bd!<CR>") -- close current buffer
keymap("n", "<leader>qa", "<CMD>silent! %bd|e#|bd#<CR>") -- close all buffers but the current one
keymap("n", "<leader>Q", "<CMD>qa!<CR>") -- quit Neovim entirely

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h")
keymap("n", "<C-j>", "<C-w>j")
keymap("n", "<C-k>", "<C-w>k")
keymap("n", "<C-l>", "<C-w>l")

-- Resize with Alt + hjkl
keymap("n", "<M-h>", "<CMD>vertical resize -2<CR>")
keymap("n", "<M-j>", "<CMD>resize +2<CR>")
keymap("n", "<M-k>", "<CMD>resize -2<CR>")
keymap("n", "<M-l>", "<CMD>vertical resize +2<CR>")

-- Navigate buffers
keymap("n", "<S-l>", "<CMD>bnext<CR>")
keymap("n", "<S-h>", "<CMD>bprevious<CR>")

-- Toggle spell checker
keymap("n", "<leader>sc", "<CMD>setlocal spell!<CR>")

-- Oil
keymap("n", "<leader>e", "<CMD>Oil<CR>")

-- git
keymap("n", "<leader>gj", "<CMD>lua require 'gitsigns'.next_hunk()<CR>")
keymap("n", "<leader>gk", "<CMD>lua require 'gitsigns'.prev_hunk()<CR>")
keymap("n", "<leader>gl", "<CMD>lua require 'gitsigns'.blame_line()<CR>")
keymap("n", "<leader>gp", "<CMD>lua require 'gitsigns'.preview_hunk()<CR>")
keymap("n", "<leader>gr", "<CMD>lua require 'gitsigns'.reset_hunk()<CR>")
keymap("n", "<leader>gR", "<CMD>lua require 'gitsigns'.reset_buffer()<CR>")
keymap("n", "<leader>gs", "<CMD>lua require 'gitsigns'.stage_hunk()<CR>")
keymap("n", "<leader>gu", "<CMD>lua require 'gitsigns'.undo_stage_hunk()<CR>")
keymap("n", "<leader>gd", "<CMD>Gitsigns diffthis HEAD<CR>")

-- FZF-Lua keymaps (converted from Telescope)
local fzf = require("fzf-lua")

vim.keymap.set("n", "<leader>?", fzf.oldfiles, { desc = "[?] Find recently opened files" })
vim.keymap.set("n", "<leader><space>", fzf.buffers, { desc = "[ ] Find existing buffers" })

-- Current buffer fuzzy find with similar styling to telescope dropdown
vim.keymap.set("n", "<leader>/", function()
    fzf.blines({
        winopts = {
            height = 0.4,
            width = 0.8,
            preview = { hidden = "hidden" },
        },
    })
end, { desc = "[/] Fuzzily search in current buffer" })

vim.keymap.set("n", "<leader>sf", fzf.files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>sh", fzf.helptags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sw", fzf.grep_cword, { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>sg", fzf.live_grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sd", fzf.diagnostics_document, { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>sk", fzf.keymaps, { desc = "[S]earch [K]eymaps" })
vim.keymap.set("n", "<leader>sm", fzf.manpages, { desc = "[S]earch [M]an Pages" })

-- format code
keymap("n", "<leader>f", require("conform").format)

-- toggle search result highlight
keymap("n", "<leader>h", "<CMD>set hlsearch!<CR>")

-- toggle virtual lines
keymap("", "<leader>l", function()
    local config = vim.diagnostic.config() or {}
    if config.virtual_lines then
        vim.diagnostic.config({ virtual_text = false, virtual_lines = false })
    else
        vim.diagnostic.config({ virtual_text = false, virtual_lines = true })
    end
end, { desc = "Toggle lsp_lines" })

-- open the manpage of the highlighted word in a vertical or horizontal split
local function get_man_page(split_cmd)
    local word = vim.fn.expand("<cword>")
    if word == "" then
        return
    end

    local handle = io.popen("man " .. word .. " | col -b 2>/dev/null")
    if not handle then
        vim.notify("Failed to check manual entry for '" .. word .. "'", vim.log.levels.ERROR)
        return
    end

    local result = handle:read("*a")
    handle:close()

    -- Check if the man page exists
    if not result or result:match("^%s*$") then
        vim.notify("No manual entry for '" .. word .. "'", vim.log.levels.ERROR)
        return
    end

    -- Open a temp buffer and set it to read-only with the man page content
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(result, "\n"))
    vim.bo[buf].modifiable = false
    vim.bo[buf].buftype = "nofile"

    -- Open the buffer in a vertical split
    vim.cmd(split_cmd)
    vim.api.nvim_win_set_buf(0, buf)
end
keymap("n", "<leader>m", function()
    get_man_page("vsp")
end)
keymap("n", "<leader>mv", function()
    get_man_page("sp")
end)

-- Compilation Mode specific keymappings
vim.api.nvim_create_autocmd("FileType", {
    pattern = "compilation",
    callback = function()
        keymap("n", "r", ":Recompile<CR>", { buffer = true, silent = true })
        keymap("n", "x", ":CompileInterrupt<CR>", { buffer = true, silent = true })
        -- follow pattern of cycling through search results
        keymap("n", "n", ":NextError<CR>", { buffer = true, silent = true })
        keymap("n", "N", ":PrevError<CR>", { buffer = true, silent = true })
    end,
})

-- Insert --

-- Visual --

-- Stay in indent mode
keymap("v", "<", "<gv")
keymap("v", ">", ">gv")

-- Move text up and down
keymap("v", "<M-j>", "<CMD>m .+1<CR>==")
keymap("v", "<M-k>", "<CMD>m .-2<CR>==")

-- Visual Block --

-- Move text up and down
keymap("x", "J", "<CMD>move '>+1<CR>gv-gv")
keymap("x", "K", "<CMD>move '<-2<CR>gv-gv")
keymap("x", "<M-j>", "<CMD>move '>+1<CR>gv-gv")
keymap("x", "<M-k>", "<CMD>move '<-2<CR>gv-gv")

-- Terminal Block --

keymap("t", "<leader>t", "<C-\\><C-n><C-w>h")

-------------------------------------------------------------------------------
-- Color Scheme --
-------------------------------------------------------------------------------

require("ascua").setup({
    bold_styles = false,
    color_overrides = {},
    group_overrides = {},
    italic_comments = false,
    underline_links = false,
    terminal_colors = true,
    transparent = true,
})
vim.cmd("colorscheme ascua")
