return {
    {
        "rebelot/kanagawa.nvim",
        lazy = false, -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function() end,
    },
    {
        "sainnhe/gruvbox-material",
        name = "gruvbox-material",
        lazy = false,
        priority = 1000,
        opts = {},
        config = function()
            vim.g.gruvbox_material_background = "medium" -- soft, medium, hard
        end,
    },
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
    },
    {
        "navazjm/plastic.nvim",
        dependencies = { "rktjmp/lush.nvim" },
        name = "plastic",
        lazy = false,
        priority = 1000,
        config = function() end,
    },
}
