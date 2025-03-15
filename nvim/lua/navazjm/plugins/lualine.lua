local hide_in_width = function()
    return vim.fn.winwidth(0) > 80
end

local diagnostics = {
    "diagnostics",
    sources = { "nvim_diagnostic" },
    sections = { "error", "warn" },
    symbols = { error = " ", warn = " " },
    colored = false,
    update_in_insert = false,
    always_visible = true,
}

local diff = {
    "diff",
    colored = false,
    symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
    cond = hide_in_width,
}

local mode = {
    "mode",
    fmt = function(str)
        return "-- " .. str .. " --"
    end,
}

local filename = {
    "filename",
    path = 4,
}

local filetype = {
    "filetype",
    colored = false,
    icon_only = true,
}

local branch = {
    "branch",
    icon = "",
}

local location = {
    "location",
    padding = 0,
}

-- cool function for progress
local progress = function()
    local current_line = vim.fn.line(".")
    local total_lines = vim.fn.line("$")
    local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
    local line_ratio = current_line / total_lines
    local index = math.ceil(line_ratio * #chars)
    return chars[index]
end

local spaces = function()
    return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
end

return {
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            options = {
                icons_enabled = true,
                theme = "base16",
                component_separators = { left = "", right = "" },
                section_separators = { left = "", right = "" },
                disabled_filetypes = {},
                always_divide_middle = true,
                always_show_tabline = false,
                globalstatus = true,
            },
            sections = {
                -- weird spacing issue with filetype, going to ignore for now
                --[[ lualine_a = { filetype, filename, diagnostics }, ]]
                lualine_a = { filename, diagnostics },
                lualine_b = { branch, diff },
                lualine_c = { mode },
                lualine_x = { spaces, "encoding" },
                lualine_y = { location },
                lualine_z = { progress },
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
                        return navic.is_available() and navic.get_location() or ""
                    end,
                },
            },
            inactive_winbar = {
                lualine_c = { "filename" },
            },
            extensions = {},
        },
    },

    -- Simple winbar/statusline plugin that shows your current code context (breadcrumbs)
    {
        "SmiteshP/nvim-navic",
        dependencies = "neovim/nvim-lspconfig",
        config = function()
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
            })
        end,
    },
}
