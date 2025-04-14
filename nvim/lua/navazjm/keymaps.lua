local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

-------------------------------------------------------------------------------
-- Normal --
-------------------------------------------------------------------------------

-- keymap to close buffers
keymap("n", "<leader>q", ":bd!<CR>", opts)

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize with Alt + hjkl
keymap("n", "<M-h>", ":vertical resize -2<CR>", opts)
keymap("n", "<M-j>", ":resize +2<CR>", opts)
keymap("n", "<M-k>", ":resize -2<CR>", opts)
keymap("n", "<M-l>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Toggle spell checker __
keymap("n", "<leader>sc", ":setlocal spell!<CR>", opts)

-- Oil --
keymap("n", "<leader>e", "<CMD>Oil<CR>", opts)
vim.keymap.set("n", "<space>ee", require("oil").toggle_float)

-- -- git --
keymap("n", "<leader>gj", "<cmd>lua require 'gitsigns'.next_hunk()<cr>", opts)
keymap("n", "<leader>gk", "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", opts)
keymap("n", "<leader>gl", "<cmd>lua require 'gitsigns'.blame_line()<cr>", opts)
keymap("n", "<leader>gp", "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", opts)
keymap("n", "<leader>gr", "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", opts)
keymap("n", "<leader>gR", "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", opts)
keymap("n", "<leader>gs", "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", opts)
keymap("n", "<leader>gu", "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>", opts)
keymap("n", "<leader>go", "<cmd>Telescope git_status<cr>", opts)
keymap("n", "<leader>gb", "<cmd>Telescope git_branches<cr>", opts)
keymap("n", "<leader>gc", "<cmd>Telescope git_commits<cr>", opts)
keymap("n", "<leader>gd", "<cmd>Gitsigns diffthis HEAD<cr>", opts)

-- Telescope keymaps --
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>?", builtin.oldfiles, { desc = "[?] Find recently opened files" })
vim.keymap.set("n", "<leader><space>", builtin.buffers, { desc = "[ ] Find existing buffers" })
vim.keymap.set("n", "<leader>/", function()
    -- You can pass additional configuration to telescope to change theme, layout, etc.
    builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
        winblend = 10,
        previewer = false,
    }))
end, { desc = "[/] Fuzzily search in current buffer]" })

vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
vim.keymap.set("n", "<leader>sm", builtin.man_pages, { desc = "[S]earch [M]an Pages" })

-- Keymap to open the manpage of the highlighted word in a vertical or horizontal split
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

local function get_man_page_vsp()
    get_man_page("vsp")
end
local function get_man_page_sp()
    get_man_page("sp")
end

vim.keymap.set("n", "<leader>m", get_man_page_sp, opts)
vim.keymap.set("n", "<leader>mv", get_man_page_vsp, opts)

-------------------------------------------------------------------------------
-- Insert --
-------------------------------------------------------------------------------

keymap("i", "<C-f>", "<ESC>", opts)

-------------------------------------------------------------------------------
-- Visual --
-------------------------------------------------------------------------------

-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<M-j>", ":m .+1<CR>==", opts)
keymap("v", "<M-k>", ":m .-2<CR>==", opts)
keymap("v", "p", '"_dP', opts)

-------------------------------------------------------------------------------
-- Visual Block --
-------------------------------------------------------------------------------

-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<M-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<M-k>", ":move '<-2<CR>gv-gv", opts)

-------------------------------------------------------------------------------
-- Terminal Block --
-------------------------------------------------------------------------------

keymap("t", "<leader>t", "<C-\\><C-n><C-w>h", opts)
