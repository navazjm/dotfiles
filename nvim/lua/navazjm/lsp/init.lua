local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
	return
end

require("navazjm.lsp.mason")
require("navazjm.lsp.handlers").setup()
require("navazjm.lsp.null-ls")
