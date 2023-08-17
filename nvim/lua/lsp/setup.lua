local lspconfig = require("lspconfig")
local opts = {}
local clang_opts = require("lsp.settings.clangd")
opts = vim.tbl_deep_extend("force", clang_opts, opts)
opts.on_attach = function(client, bufnr)
	require("lsp.handlers").on_attach(client, bufnr)

	local caps = client.server_capabilities
	if caps.semanticTokensProvider and caps.semanticTokensProvider.full then
		local augroup = vim.api.nvim_create_augroup("SemanticTokens", {})
		vim.api.nvim_create_autocmd("TextChanged", {
			group = augroup,
			buffer = bufnr,
			callback = function()
				vim.lsp.buf.semantic_tokens_full()
			end,
		})
		-- fire it first time on load as well
		vim.lsp.buf.semantic_tokens_full()
	end
end

lspconfig["clangd"].setup(opts)
