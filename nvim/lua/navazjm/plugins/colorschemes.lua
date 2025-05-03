return {
    {
        dir = "~/repos/ascua.nvim", -- Absolute or relative path to the plugin
        name = "ascua", -- Optional, to ensure a unique name
        dev = true,
        opts = {
            bold_styles = false,
            color_overrides = {},
            group_overrides = {},
            italic_comments = false,
            underline_links = false,
            terminal_colors = true,
            transparent = true,
        },
        config = true,
        init = function()
            vim.cmd("colorscheme ascua")
        end,
    },
}
