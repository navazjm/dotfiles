local status_ok, mason = pcall(require, "mason")
if not status_ok then
    return
end

local status_ok_1, mason_lspconfig = pcall(require, "mason-lspconfig")
if not status_ok_1 then
    return
end

local servers = {
    "cssls",
    "cssmodules_ls",
    "emmet_ls",
    "html",
    "lua_ls",
    "tsserver",
    "clangd",
    "gopls",
    "rust_analyzer",
}

local settings = {
    ui = {
        border = "rounded",
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
        },
    },
    log_level = vim.log.levels.INFO,
    max_concurrent_installers = 4,
}

mason.setup(settings)
mason_lspconfig.setup({
    ensure_installed = servers,
    automatic_installation = true,
})

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
    return
end

local opts = {}

for _, server in pairs(servers) do
    opts = {
        on_attach = require("navazjm.lsp.handlers").on_attach,
        capabilities = require("navazjm.lsp.handlers").capabilities,
    }

    server = vim.split(server, "@")[1]

    if server == "tsserver" then
        local tsserver_opts = require "navazjm.lsp.settings.tsserver"
        opts = vim.tbl_deep_extend("force", tsserver_opts, opts)
    end

    if server == "emmet_ls" then
        local emmet_ls_opts = require "navazjm.lsp.settings.emmet_ls"
        opts = vim.tbl_deep_extend("force", emmet_ls_opts, opts)
    end

    if server == "clangd" then
        local clangd_opts = require "navazjm.lsp.settings.clangd"
        opts = vim.tbl_deep_extend("force", clangd_opts, opts)
    end

    lspconfig[server].setup(opts)
    ::continue::
end

-- TODO: add something to installer later
-- require("lspconfig").motoko.setup {}
