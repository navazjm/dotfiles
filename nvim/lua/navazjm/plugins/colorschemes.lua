return {
    {
        dir = "~/repos/ascua.nvim", -- Absolute or relative path to the plugin
        name = "ascua", -- Optional, to ensure a unique name
        dev = true,
        opts = {},
        config = function()
            vim.cmd("colorscheme ascua")
        end,
    },
}
