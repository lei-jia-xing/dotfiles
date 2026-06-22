vim.loader.enable()
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.undofile = true
vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 0
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.breakindent = true
vim.opt.signcolumn = "yes"
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.confirm = true
vim.opt.cursorline = true
vim.opt.updatetime = 200
vim.opt.timeoutlen = 300
vim.opt.wrap = false
vim.opt.scrolloff = 10
vim.opt.foldenable = false

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.mouse = "a"
vim.opt.showmode = false

vim.schedule(function()
	vim.opt.clipboard = "unnamedplus"
end)

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.diagnostic.config({
	update_in_insert = false,
	severity_sort = true,
	float = { border = "rounded", source = "if_many" },
	underline = { severity = { min = vim.diagnostic.severity.WARN } },

	-- Can switch between these as you prefer
	virtual_text = true, -- Text shows up at the end of the line
	virtual_lines = false, -- Text shows up underneath the line, with virtual lines

	jump = {
		on_jump = function(diagnostic, bufnr)
			if diagnostic then
				vim.diagnostic.open_float({ bufnr = bufnr })
			end
		end,
	},
	signs = false,
})

vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Show [Code] line [D]iagnostic" })

vim.keymap.set("n", "]e", function()
	vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR })
end, { desc = "Next [E]rror" })
vim.keymap.set("n", "[e", function()
	vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR })
end, { desc = "Previous [E]rror" })

vim.keymap.set("n", "]w", function()
	vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.WARN })
end, { desc = "Next [W]arning" })
vim.keymap.set("n", "[w", function()
	vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.WARN })
end, { desc = "Previous [W]arning" })

vim.keymap.set("n", "<C-/>", "<cmd>terminal<cr>", { desc = "Enter terminal mode" })
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
vim.keymap.set("n", "<M-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
vim.keymap.set("n", "<M-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
vim.keymap.set("n", "<M-Left>", "<cmd>vertical resize -4<cr>", { desc = "Decrease window width" })
vim.keymap.set("n", "<M-Right>", "<cmd>vertical resize +4<cr>", { desc = "Increase window width" })
vim.keymap.set("n", "<leader>ws", "<cmd>split<cr>", { desc = "Split window" })
vim.keymap.set("n", "<leader>wv", "<cmd>vsplit<cr>", { desc = "Vertical split window" })

local lsp_augroup = vim.api.nvim_create_augroup("lsp", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
	group = lsp_augroup,
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if not client then
			return
		end

		if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
			vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
			vim.keymap.set("n", "<leader>uh", function()
				local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = args.buf })
				vim.lsp.inlay_hint.enable(not enabled, { bufnr = args.buf })
			end, { buffer = args.buf, desc = "Toggle inlay [H]ints" })
		end

		if client:supports_method(vim.lsp.protocol.Methods.textDocument_codeLens) then
			vim.lsp.codelens.enable(false, { bufnr = args.buf })
			vim.keymap.set("n", "<leader>cl", vim.lsp.codelens.run, {
				buffer = args.buf,
				desc = "[C]ode [L]ens run",
			})
			vim.keymap.set("n", "<leader>uL", function()
				local enabled = vim.lsp.codelens.is_enabled({ bufnr = args.buf })
				vim.lsp.codelens.enable(not enabled, { bufnr = args.buf })
			end, { buffer = args.buf, desc = "Toggle Code[L]ens" })
		end

		if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
			local highlight_group = vim.api.nvim_create_augroup("lsp-highlight-" .. args.buf, { clear = true })
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				group = highlight_group,
				buffer = args.buf,
				callback = vim.lsp.buf.document_highlight,
			})
			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				group = highlight_group,
				buffer = args.buf,
				callback = vim.lsp.buf.clear_references,
			})
			vim.api.nvim_create_autocmd("LspDetach", {
				group = highlight_group,
				buffer = args.buf,
				callback = function()
					vim.lsp.buf.clear_references()
					vim.api.nvim_clear_autocmds({ group = highlight_group, buffer = args.buf })
				end,
			})
		end
	end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking text",
	callback = function()
		vim.hl.on_yank()
	end,
})

-- helper method
local gh = function(repo)
	return "https://github.com/" .. repo
end
-- local cb = function(repo)
-- 	return "https://codeberg.org/" .. repo
-- end

local plugins = {
	-- colorscheme
	gh("catppuccin/nvim"),

	gh("nvim-tree/nvim-web-devicons"),
	gh("MunifTanjim/nui.nvim"),
	gh("nvim-lua/plenary.nvim"),
	gh("ibhagwan/fzf-lua"),
	gh("windwp/nvim-autopairs"),
	gh("lukas-reineke/indent-blankline.nvim"),
	gh("saghen/blink.cmp"),
	gh("numToStr/Comment.nvim"),
	gh("stevearc/conform.nvim"),
	gh("lewis6991/gitsigns.nvim"),
	gh("nmac427/guess-indent.nvim"),
	gh("neovim/nvim-lspconfig"),
	gh("folke/lazydev.nvim"),
	gh("nvim-lualine/lualine.nvim"),
	gh("rafamadriz/friendly-snippets"),
	gh("L3MON4D3/LuaSnip"),
	gh("iamcco/markdown-preview.nvim"),
	gh("MeanderingProgrammer/render-markdown.nvim"),
	gh("nvim-mini/mini.ai"),
	gh("nvim-mini/mini.hipatterns"),
	gh("nvim-mini/mini.move"),
	gh("NeogitOrg/neogit"),
	gh("sindrets/diffview.nvim"),
	gh("folke/noice.nvim"),
	gh("rcarriga/nvim-notify"),
	gh("mfussenegger/nvim-lint"),
	gh("kylechui/nvim-surround"),
	gh("nvim-treesitter/nvim-treesitter-textobjects"),
	gh("nvim-treesitter/nvim-treesitter"),
	gh("windwp/nvim-ts-autotag"),
	gh("stevearc/oil.nvim"),
	gh("refractalize/oil-git-status.nvim"),
	gh("folke/todo-comments.nvim"),
	gh("xiyaowong/transparent.nvim"),
	gh("folke/which-key.nvim"),
}

vim.pack.add(plugins)

-- update all the plugins
vim.api.nvim_create_user_command("PackUpdate", function()
	vim.pack.update()
end, { desc = "Update all the plugin installed" })

-- uninstall plugin
vim.api.nvim_create_user_command("PackUninstall", function(opts)
	local plugin = opts.fargs
	vim.pack.del(plugin)
end, { desc = "Uninstall specfic plugins", nargs = "+", complete = "packadd" })

-- reinstall plugin
vim.api.nvim_create_user_command("PackReinstall", function(opts)
	local plugin = opts.fargs
	vim.pack.del(plugin)
	vim.pack.add(plugin)
end, { desc = "Reinstall specfic plugins", nargs = "+", complete = "packadd" })

-- colorscheme
vim.cmd.colorscheme("catppuccin-mocha")

-- blink
require("blink.cmp").setup({
	keymap = { preset = "default" },
	cmdline = {
		enabled = true,
	},
	appearance = {
		nerd_font_variant = "mono",
	},

	completion = { documentation = { auto_show = false } },

	-- Default list of enabled providers defined so that you can extend it
	-- elsewhere in your config, without redefining it, due to `opts_extend`
	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
	},
	signature = {
		enabled = true,
	},

	fuzzy = { implementation = "prefer_rust_with_warning" },
})

-- conform
require("conform").setup({
	-- format_on_save = {
	-- 	lsp_format = "fallback",
	-- },
	formatters_by_ft = {
		lua = { "stylua" },
		cmake = { "cmake_format" },
		javascript = { "prettier" },
		typescript = { "prettier" },
		javascriptreact = { "prettier" },
		typescriptreact = { "prettier" },
		vue = { "prettier" },
		python = { "ruff_format", "ruff_organize_imports" },
		go = { "gofumpt", "goimports" },
		rust = { "rustfmt" },
		c = { "clang-format" },
		cpp = { "clang-format" },
		kotlin = { "ktlint" },
		sh = { "shfmt" },
		bash = { "shfmt" },
		zsh = { "shfmt" },
		html = { "prettier" },
		css = { "prettier" },
		json = { "prettier" },
		yaml = { "prettier" },
		tex = { "latexindent" },
		latex = { "latexindent" },
		bib = { "bibtex-tidy" },
	},
})
vim.keymap.set("n", "<leader>cf", function()
	require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "[C]onform current [F]ile" })

-- reset default keymap
-- - <grx>: vim.lsp.codelens.run()
-- - <gra>: vim.lsp.buf.code_action()
-- - <grn>: vim.lsp.buf.rename()
-- - <grr>: vim.lsp.buf.references()
-- - <grt>: vim.lsp.buf.type_definition()
-- - <gri>: vim.lsp.buf.implementation()

vim.keymap.del("n", "grx")
vim.keymap.del("n", "gra")
vim.keymap.del("n", "grn")
vim.keymap.del("n", "grr")
vim.keymap.del("n", "grt")
vim.keymap.del("n", "gri")
vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, {
	desc = "[C]ode [R]ename",
})
-- fzf-lua
require("fzf-lua").setup({
	ui_select = true,
})

local function fzf_call(fn, opts)
	return function()
		require("fzf-lua")[fn](opts)
	end
end

vim.keymap.set("n", "<leader>ff", fzf_call("files"), { desc = "Find [F]iles" })
vim.keymap.set("n", "<leader>fb", fzf_call("buffers"), { desc = "Find [B]uffers" })
vim.keymap.set("n", "<leader>ft", fzf_call("tabs"), { desc = "Find [T]abs" })
vim.keymap.set("n", "<leader>fc", function()
	require("fzf-lua").files({ cwd = vim.fn.stdpath("config") })
end, { desc = "Find [C]onfig files" })
vim.keymap.set("n", "gr", fzf_call("lsp_references"), { desc = "LSP [R]eferences" })
vim.keymap.set("n", "gd", fzf_call("lsp_definitions"), { desc = "LSP [D]efinitions" })
vim.keymap.set("n", "gD", fzf_call("lsp_declarations"), { desc = "LSP [D]eclarations" })
vim.keymap.set("n", "gi", fzf_call("lsp_implementations"), { desc = "LSP [I]mplementations" })
vim.keymap.set("n", "<leader>ca", fzf_call("lsp_code_actions"), { desc = "LSP [C]ode [A]ctions" })
vim.keymap.set("n", "<leader>sm", fzf_call("marks"), { desc = "[S]earch [M]arks" })
vim.keymap.set("n", "<leader>sM", fzf_call("manpages"), { desc = "[S]earch [M]anpages" })
vim.keymap.set("n", "<leader>st", "<cmd>TodoFzfLua<cr>", { desc = "[S]earch [T]odo" })
vim.keymap.set("n", "<leader>n", "<cmd>NoiceFzf<cr>", { desc = "[N]oice history" })
vim.keymap.set("n", "<leader>so", fzf_call("nvim_options"), { desc = "[S]earch neovim [O]ption" })
vim.keymap.set("n", "<leader>su", fzf_call("undotree"), { desc = "[S]earch [U]ndotree" })
vim.keymap.set("n", "<leader>sh", fzf_call("helptags"), { desc = "Find [H]elp tags" })
vim.keymap.set("n", "<leader>sH", fzf_call("highlights"), { desc = "[S]earch [H]ighlights" })
vim.keymap.set("n", "<leader>sc", fzf_call("command_history"), { desc = "[S]earch [C]ommand history" })
vim.keymap.set("n", "<leader>sC", fzf_call("commands"), { desc = "[S]earch [C]ommands" })
vim.keymap.set("n", "<leader>sg", fzf_call("live_grep_native"), { desc = "[S]earch Live [G]rep" })
vim.keymap.set("n", "<leader>sk", fzf_call("keymaps"), { desc = "[S]earch [K]eymaps" })
vim.keymap.set("n", "<leader>ss", fzf_call("lsp_document_symbols"), { desc = "[S]earch document [S]ymbols" })
vim.keymap.set("n", "<leader>sS", fzf_call("lsp_live_workspace_symbols"), { desc = "[S]earch workspace [S]ymbols" })
vim.keymap.set("n", "<leader>sd", fzf_call("diagnostics_workspace"), { desc = "[S]earch workspace [D]iagnostics" })
vim.keymap.set("n", "<leader>sD", fzf_call("diagnostics_document"), { desc = "[S]earch document [D]iagnostics" })
vim.keymap.set("n", "<leader>sq", fzf_call("quickfix"), { desc = "[S]earch [Q]uickfix list" })
vim.keymap.set("n", "<leader>sr", fzf_call("registers"), { desc = "[S]earch [R]egisters" })
vim.keymap.set("n", "<leader>sa", fzf_call("autocmds"), { desc = "[S]earch [A]utocmds" })
vim.keymap.set("n", "<leader>sz", fzf_call("zoxide"), { desc = "[S]earch [Z]oxide" })
vim.keymap.set("n", "<leader>uC", fzf_call("colorschemes"), { desc = "[U]I colorschemes" })
vim.keymap.set("n", "<leader>uc", fzf_call("awesome_colorschemes"), { desc = "[U]I awesome_colorschemes" })
vim.keymap.set("n", "<leader>gf", fzf_call("git_bcommits"), { desc = "[G]it [F]ile history" })

-- nvim-autopairs
require("nvim-autopairs").setup()
-- indent-blankline
require("ibl").setup()
-- nvim-surround
require("nvim-surround").setup()
-- gitsigns
local gs = require("gitsigns")
vim.keymap.set("n", "]h", function()
	gs.nav_hunk("next")
end, { desc = "Next [H]unk" })
vim.keymap.set("n", "[h", function()
	gs.nav_hunk("prev")
end, { desc = "Previous [H]unk" })
vim.keymap.set("n", "<leader>gb", function()
	gs.blame()
end, { desc = "[G]it [B]lame" })
-- guess-indent
require("guess-indent").setup({})

-- lazydev
require("lazydev").setup()

-- lspconfig
vim.lsp.enable("clangd")
vim.lsp.enable("csharp_ls")
vim.lsp.enable("neocmake")
vim.lsp.enable("gopls")
vim.lsp.enable("jdtls")
vim.lsp.enable("kotlin_lsp")
vim.lsp.enable("lua_ls")
vim.lsp.enable("ty")
vim.lsp.enable("zls")
vim.lsp.enable("rust_analyzer")
vim.lsp.enable("hls")
vim.lsp.enable("ts_ls")
vim.lsp.enable("tailwindcss")
vim.lsp.enable("vue_ls")
vim.lsp.enable("jsonls")
vim.lsp.enable("texlab")
vim.lsp.enable("marksman")
-- lualine
require("lualine").setup({})
-- luasnip
require("luasnip.loaders.from_vscode").lazy_load()
-- markdown-preview
vim.keymap.set("n", "<leader>cp", "<cmd>MarkdownPreviewToggle<cr>", { desc = "Markdown Preview" })
-- mini.ai
require("mini.ai").setup({
	custom_textobjects = {
		-- Whole buffer
		g = function()
			local from = { line = 1, col = 1 }
			local to = {
				line = vim.fn.line("$"),
				col = math.max(vim.fn.getline("$"):len(), 1),
			}
			return { from = from, to = to }
		end,
	},
})
-- mini.hipatterns
local hipatterns = require("mini.hipatterns")
hipatterns.setup({
	highlighters = {
		hex_color = hipatterns.gen_highlighter.hex_color(),
	},
})
-- mini.move
require("mini.move").setup()
-- neogit
require("neogit").setup({
	graph_style = "kitty",
	integrations = {
		diffview = true,
		fzf_lua = true,
	},
	disable_context_highlighting = true,
})
vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<cr>", { desc = "[G]it wrapper neo[G]it" })
vim.keymap.set("n", "<leader>gG", "<cmd>Neogit cwd=%:p:h<cr>", { desc = "Show Neogit UI (current buffer dir)" })
-- noice
require("noice").setup({
	lsp = {
		override = {
			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
			["vim.lsp.util.stylize_markdown"] = true,
		},
	},
	presets = {
		long_message_to_split = true, -- long messages will be sent to a split
		lsp_doc_border = true
	},
})
-- notify
require("notify").setup({
	merge_duplicates = true,
	background_colour = "#00000000",
})
-- linter
local lint = require("lint")
lint.linters_by_ft = {
	dockerfile = { "hadolint" },
	python = { "ruff" },
	javascript = { "eslint" },
	typescript = { "eslint" },
	javascriptreact = { "eslint" },
	typescriptreact = { "eslint" },
	vue = { "eslint" },
	sh = { "shellcheck" },
	bash = { "shellcheck" },
	zsh = { "shellcheck" },
	yaml = { "yamllint" },
}

local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
	group = lint_augroup,
	callback = function(args)
		local buf = args.buf
		local buftype = vim.bo[buf].buftype
		local filetype = vim.bo[buf].filetype
		if buftype ~= "" or filetype == "" then
			return
		end
		lint.try_lint()
	end,
})
-- treesitter-textobjects
vim.keymap.set({ "x", "o" }, "af", function()
	require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "if", function()
	require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
end)

vim.keymap.set({ "x", "o" }, "ac", function()
	require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "ic", function()
	require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
end)

vim.keymap.set({ "x", "o" }, "aa", function()
	require("nvim-treesitter-textobjects.select").select_textobject("@parameter.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "ia", function()
	require("nvim-treesitter-textobjects.select").select_textobject("@parameter.inner", "textobjects")
end)

vim.keymap.set({ "n", "x", "o" }, "]f", function()
	require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "[f", function()
	require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
end)

vim.keymap.set({ "n", "x", "o" }, "]c", function()
	require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "[c", function()
	require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects")
end)

vim.keymap.set({ "n", "x", "o" }, "]a", function()
	require("nvim-treesitter-textobjects.move").goto_next_start("@parameter.inner", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "[a", function()
	require("nvim-treesitter-textobjects.move").goto_previous_start("@parameter.inner", "textobjects")
end)

-- treesitter
require("nvim-treesitter").install({
	"html",
	"javascript",
	"typescript",
	"vue",
	"rust",
	"zig",
	"cmake",
	"cpp",
	"c",
	"c_sharp",
	"cmake",
	"glsl",
	"java",
	"kotlin",
	"lua",
	"python",
	"go",
	"dockerfile",
	"bash",
	"fish",
	"nix",
	"markdown",
	"markdown_inline",
	"latex",
	"vim",
	"vimdoc",
	"query",
})

vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		local buf, filetype = args.buf, args.match

		local language = vim.treesitter.language.get_lang(filetype)
		if not language then
			return
		end

		-- check if parser exists and load it
		if not vim.treesitter.language.add(language) then
			return
		end
		-- enables syntax highlighting and other treesitter features
		vim.treesitter.start(buf, language)

		-- enables treesitter based folds
		-- for more info on folds see `:help folds`
		vim.wo.foldmethod = "expr"
		vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"

		-- vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})
-- nvim-ts-autotag
require("nvim-ts-autotag").setup()
-- oil
require("oil").setup({
	columns = {
		"icon",
		"permissions",
		"size",
		"mtime",
	},
	win_options = {
		signcolumn = "yes:2",
	},
	delete_to_trash = true,
	skip_confirm_for_simple_edits = true,
	watch_for_changes = true,
})
vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "Open parent directory" })
-- oil-git-status
require("oil-git-status").setup({})
-- todo-comments
require("todo-comments").setup({})
-- which-key
require("which-key").setup()
