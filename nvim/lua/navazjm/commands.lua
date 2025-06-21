vim.api.nvim_create_user_command("BDA", function()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    vim.cmd("bd " .. buf)
  end
end, {})

vim.api.nvim_create_user_command("BDC", function()
  local current = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and buf ~= current then
      vim.cmd("bd " .. buf)
    end
  end
end, {})
