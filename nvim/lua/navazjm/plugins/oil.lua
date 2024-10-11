return {
    "stevearc/oil.nvim",
    opts = {
        columns = { "icon" },
        keymaps = {
            ["<C-h>"] = false,
            ["<C-l>"] = false,
            ["<C-k>"] = false,
            ["<C-j>"] = false,
            ["<M-h>"] = "actions.select_split",
        },
        view_options = {
            show_hidden = true,
        },
    },
}
