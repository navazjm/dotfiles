return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",

            { "j-hui/fidget.nvim", opts = {} },
            { "https://git.sr.ht/~whynothugo/lsp_lines.nvim" },

            -- Autoformatting
            "stevearc/conform.nvim",

            -- Schema information
            "b0o/SchemaStore.nvim",
        },
        config = function()
            local capabilities = nil
            if pcall(require, "cmp_nvim_lsp") then
                capabilities = require("cmp_nvim_lsp").default_capabilities()
            end

            local lspconfig = require("lspconfig")

            local servers = {
                bashls = true,
                gopls = {
                    settings = {
                        gopls = {
                            hints = {
                                assignVariableTypes = true,
                                compositeLiteralFields = true,
                                compositeLiteralTypes = true,
                                constantValues = true,
                                functionTypeParameters = true,
                                parameterNames = true,
                                rangeVariableTypes = true,
                            },
                        },
                    },
                },
                lua_ls = {
                    server_capabilities = {
                        semanticTokensProvider = vim.NIL,
                    },
                    settings = {
                        Lua = {
                            runtime = {
                                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                                version = "LuaJIT",
                            },
                            diagnostics = {
                                enable = true,
                                -- Get the language server to recognize the `vim` global
                                globals = { "vim", "use" },
                                -- Use `luacheck` for diagnostics
                                checkThirdParty = false, -- Turn off third-party checks (optional)
                            },
                            workspace = {
                                -- Make the server aware of Neovim runtime files
                                library = vim.api.nvim_get_runtime_file("", true),
                            },
                        },
                    },
                },
                templ = true,
                -- Enabled biome formatting, turn off all the other ones generally
                biome = true,
                ts_ls = {
                    server_capabilities = {
                        documentFormattingProvider = false,
                    },
                },
                jsonls = {
                    server_capabilities = {
                        documentFormattingProvider = false,
                    },
                    settings = {
                        json = {
                            schemas = require("schemastore").json.schemas(),
                            validate = { enable = true },
                        },
                    },
                },

                clangd = {
                    -- cmd = { "clangd", unpack(require("custom.clangd").flags) },
                    -- TODO: Could include cmd, but not sure those were all relevant flags.
                    --    looks like something i would have added while i was floundering
                    cmd = { "clangd", "--compile-commands-dir=./" },
                    init_options = { clangdFileStatus = true },
                },

                tailwindcss = {
                    init_options = {
                        userLanguages = {
                            elixir = "phoenix-heex",
                            eruby = "erb",
                            heex = "phoenix-heex",
                        },
                    },
                    settings = {
                        tailwindCSS = {
                            experimental = {
                                classRegex = {
                                    [[class: "([^"]*)]],
                                },
                            },
                            -- filetypes_include = { "heex" },
                            -- init_options = {
                            --   userLanguages = {
                            --     elixir = "html-eex",
                            --     eelixir = "html-eex",
                            --     heex = "html-eex",
                            --   },
                            -- },
                        },
                    },
                },
            }

            local servers_to_install = vim.tbl_filter(function(key)
                local t = servers[key]
                if type(t) == "table" then
                    return not t.manual_install
                else
                    return t
                end
            end, vim.tbl_keys(servers))

            require("mason").setup()
            local ensure_installed = {
                "stylua",
                "lua_ls",
                -- "tailwind-language-server",
            }

            vim.list_extend(ensure_installed, servers_to_install)
            require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

            for name, config in pairs(servers) do
                if config == true then
                    config = {}
                end
                config = vim.tbl_deep_extend("force", {}, {
                    capabilities = capabilities,
                }, config)

                lspconfig[name].setup(config)
            end

            -- Create LspLuacheck command for running luacheck manually
            vim.api.nvim_create_user_command("LspLuacheck", function()
                vim.cmd("!luacheck %")
            end, { desc = "Run luacheck manually on current Lua file" })

            local disable_semantic_tokens = {
                lua = true,
            }

            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local bufnr = args.buf
                    local client = assert(vim.lsp.get_client_by_id(args.data.client_id), "must have valid client")

                    -- Attach nvim-navic if the server supports document symbols
                    if client.server_capabilities.documentSymbolProvider then
                        require("nvim-navic").attach(client, bufnr)
                    end

                    local settings = servers[client.name]
                    if type(settings) ~= "table" then
                        settings = {}
                    end

                    local builtin = require("telescope.builtin")

                    vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
                    --[[ vim.keymap.set("n", "gd", builtin.lsp_definitions, { buffer = 0 }) ]]
                    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = 0 })
                    vim.keymap.set("n", "gdv", ":vsplit | lua vim.lsp.buf.definition()<CR>", { buffer = 0 })
                    vim.keymap.set("n", "gdd", vim.lsp.buf.declaration, { buffer = 0 })
                    vim.keymap.set("n", "gj", vim.lsp.buf.hover, { buffer = 0 })
                    --[[ vim.keymap.set("n", "gr", builtin.lsp_references, { buffer = 0 }) ]]
                    vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = 0 })
                    vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, { buffer = 0 })
                    vim.keymap.set("n", "gl", vim.diagnostic.open_float, { buffer = 0 })
                    --[[ vim.api.nvim_buf_set_keymap( ]]
                    --[[     bufnr, ]]
                    --[[     "n", ]]
                    --[[     "gl", ]]
                    --[[     '<cmd>lua vim.diagnostic.open_float({ border = "rounded" })<CR>', ]]
                    --[[     { noremap = true, silent = true } ]]
                    --[[ ) ]]

                    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = 0 })
                    vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, { buffer = 0 })
                    vim.keymap.set("n", "<space>wd", builtin.lsp_document_symbols, { buffer = 0 })

                    local filetype = vim.bo[bufnr].filetype
                    if disable_semantic_tokens[filetype] then
                        client.server_capabilities.semanticTokensProvider = nil
                    end

                    -- Override server capabilities
                    if settings.server_capabilities then
                        for k, v in pairs(settings.server_capabilities) do
                            if v == vim.NIL then
                                ---@diagnostic disable-next-line: cast-local-type
                                v = nil
                            end

                            client.server_capabilities[k] = v
                        end
                    end
                end,
            })

            -- Autoformatting Setup
            local conform = require("conform")
            conform.setup({
                formatters_by_ft = {
                    lua = { "stylua" },
                    c = { "clang_format" },
                    cpp = { "clang_format" },
                },
                formatters = {
                    clang_format = {
                        prepend_args = { "--style=file", "--fallback-style=LLVM" },
                    },
                },
                format_on_save = function(bufnr)
                    -- Disable "format_on_save lsp_fallback" for languages that don't
                    -- have a well standardized coding style. You can add additional
                    -- languages here or re-enable it for the disabled ones.
                    --[[ local disable_filetypes = { c = true, cpp = true } ]]
                    local disable_filetypes = {}
                    return {
                        timeout_ms = 500,
                        lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
                    }
                end,
            })

            conform.formatters.injected = {
                options = {
                    ignore_errors = false,
                    lang_to_formatters = {
                        sql = { "sleek" },
                    },
                },
            }

            require("lsp_lines").setup()
            vim.diagnostic.config({ virtual_text = false, virtual_lines = false })

            -- toggle virtual lines
            vim.keymap.set("", "<leader>l", function()
                local config = vim.diagnostic.config() or {}
                if config.virtual_lines then
                    vim.diagnostic.config({ virtual_text = false, virtual_lines = false })
                else
                    vim.diagnostic.config({ virtual_text = false, virtual_lines = true })
                end
            end, { desc = "Toggle lsp_lines" })
        end,
    },
}
