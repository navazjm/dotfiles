--[[ return { ]]
--[[     "rebelot/kanagawa.nvim", ]]
--[[     lazy = false, -- make sure we load this during startup if it is your main colorscheme ]]
--[[     priority = 1000, -- make sure to load this before all the other start plugins ]]
--[[     config = function() ]]
--[[         vim.cmd.colorscheme("kanagawa-dragon") ]]
--[[     end, ]]
--[[ } ]]

return {
    "sainnhe/gruvbox-material",
    name = "gruvbox-material",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
        vim.g.gruvbox_material_background = "medium" -- soft, medium, hard
        vim.cmd.colorscheme("gruvbox-material")
    end,
}
