--options
local opt = vim.opt
opt.winborder = "rounded"
opt.tabstop = 2
opt.cursorcolumn = false
opt.ignorecase = true
opt.shiftwidth = 2
opt.smartindent = true
opt.wrap = false
opt.number = true
opt.relativenumber = true
opt.swapfile = false
opt.termguicolors = true
opt.undofile = true
opt.undolevels = 10000
opt.incsearch = true
opt.signcolumn = "yes"
opt.scrolloff = 8
opt.winborder = 'none'

--keybinds
local map = vim.keymap.set
vim.g.mapleader = " "
map("n", "<leader>o", ":update<CR> :source<CR>")
map("n", "<leader>w", ":write<CR>")
map("n", "<leader>q", ":quit<CR>")
map({ "n", "v", "x" }, "<leader>y", '"+y<CR>')
map({ "n", "v", "x" }, "<leader>d", '"+d<CR>')
map({ "n", "v", "x" }, "<leader>s", ":e #<CR>")
map({ "n", "v", "x" }, "<leader>S", ":sf #<CR>")
map("n", "<Esc>", "<cmd>nohlsearch<CR>")
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")
map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
map("n", "<leader>f", ":Telescope find_files<CR>")
map("n", "<leader>h", ":Telescope help_tags<CR>")
map("n", "<leader>e", ":Oil<CR>")
map("n", "<leader>vd", vim.diagnostic.open_float)
map("n", "gd", vim.lsp.buf.definition)
map("n", "<leader>ps", ":Telescope live_grep<CR>")
map("n", "<leader>ut", function()
	require("snacks").picker.undo()
end)
map("n", "<leader>gb", function()
	require("gitsigns").blame()
end)

--package manager
local plugins = {
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/folke/tokyonight.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
	{src = "https://github.com/sar/ultra-darkplus.nvim" },
	-- { src = 'https://github.com/neovim/nvim-lspconfig' },
	-- { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	-- { src = "https://github.com/Saghen/blink.cmp" },
	-- { src = "https://github.com/stevearc/conform.nvim" },
	-- { src = "https://github.com/numToStr/Comment.nvim" },
	-- { src = "https://github.com/HiPhish/rainbow-delimiters.nvim" },
	-- { src = "https://github.com/JoosepAlviste/nvim-ts-context-commentstring" },
	-- { src = "https://github.com/mfussenegger/nvim-lint" },
	-- { src = "https://github.com/windwp/nvim-ts-autotag" },
	-- { src = "https://github.com/windwp/nvim-autopairs" },
	-- { src = "https://github.com/L3MON4D3/LuaSnip" },
	-- { src = "https://github.com/f-person/git-blame.nvim" },
	-- { src = "https://github.com/lewis6991/gitsigns.nvim" },
	-- { src = "https://github.com/folke/todo-comments.nvim" },
	-- { src = "https://github.com/nvim-lualine/lualine.nvim" },
	-- { src = "https://github.com/folke/snacks.nvim" },
	-- { src = "https://github.com/j-hui/fidget.nvim" },
	-- { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
	-- { src = "https://github.com/chomosuke/typst-preview.nvim" },
	-- { src = "https://github.com/zbirenbaum/copilot.lua" },
	-- { src = "https://github.com/copilotlsp-nvim/copilot-lsp" }
}
vim.pack.add(plugins)

--plugin configs
require("oil").setup({
	view_options = {
		show_hidden = true,
}})
	

require("mason").setup({})
require("telescope").setup({})
-- require("todo-comments").setup({})
-- require("nvim-ts-autotag").setup({})
-- require("nvim-autopairs").setup({})
-- require("gitsigns").setup({})
-- require("fidget").setup({})

--Luasnip
-- require("luasnip").setup({})

-- --blink
-- require("blink.cmp").setup({
-- 	keymap = { preset = "enter" },
-- 	snippets = {
-- 		preset = "luasnip",
-- 	},
-- 	appearance = {
-- 		kind_icons = {
-- 			Array         = " ",
-- 			Boolean       = "󰨙 ",
-- 			Class         = " ",
-- 			Codeium       = "󰘦 ",
-- 			Color         = " ",
-- 			Control       = " ",
-- 			Collapsed     = " ",
-- 			Constant      = "󰏿 ",
-- 			Constructor   = " ",
-- 			Copilot       = " ",
-- 			Enum          = " ",
-- 			EnumMember    = " ",
-- 			Event         = " ",
-- 			Field         = " ",
-- 			File          = " ",
-- 			Folder        = " ",
-- 			Function      = "󰊕 ",
-- 			Interface     = " ",
-- 			Key           = " ",
-- 			Keyword       = " ",
-- 			Method        = "󰊕 ",
-- 			Module        = " ",
-- 			Namespace     = "󰦮 ",
-- 			Null          = " ",
-- 			Number        = "󰎠 ",
-- 			Object        = " ",
-- 			Operator      = " ",
-- 			Package       = " ",
-- 			Property      = " ",
-- 			Reference     = " ",
-- 			Snippet       = "󱄽 ",
-- 			String        = " ",
-- 			Struct        = "󰆼 ",
-- 			Supermaven    = " ",
-- 			TabNine       = "󰏚 ",
-- 			Text          = " ",
-- 			TypeParameter = " ",
-- 			Unit          = " ",
-- 			Value         = " ",
-- 			Variable      = "󰀫 ",
-- 		},
-- 		nerd_font_variant = "mono",
-- 	},
-- 	completion = {
-- 		menu = {
-- 			draw = {
-- 				treesitter = { "lsp" },
-- 				columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } }
-- 			},
-- 		},
-- 		documentation = {
-- 			auto_show = true,
-- 			auto_show_delay_ms = 200,
-- 		},
-- 		-- ghost_text = {
-- 		-- 	enabled = vim.g.ai_cmp,
-- 		-- },
--
-- 	},
-- 	sources = {
-- 		default = { "lsp", "path", "snippets", "buffer" },
-- 	},
-- 	-- cmdline = {
-- 	-- 	enabled = true,
-- 	-- 	keymap = {
-- 	-- 		preset = "cmdline",
-- 	-- 		["<Right>"] = false,
-- 	-- 		["<Left>"] = false,
-- 	-- 	},
-- 	-- 	completion = {
-- 	-- 		list = { selection = { preselect = false } },
-- 	-- 		menu = {
-- 	-- 			auto_show = function(_ctx)
-- 	-- 				return vim.fn.getcmdtype() == ":"
-- 	-- 			end,
-- 	-- 		},
-- 	-- 		ghost_text = { enabled = true },
-- 	-- 	},
-- 	-- },
-- })

-- --treesitter
-- require("nvim-treesitter").setup()
-- require("nvim-treesitter.configs").setup({
-- 	modules = {},
-- 	ignore_install = {},
-- 	sync_install = false,
-- 	ensure_installed = {
-- 		"bash",
-- 		"c",
-- 		"diff",
-- 		"lua",
-- 		"luadoc",
-- 		"json5",
-- 		"markdown",
-- 		"markdown_inline",
-- 		"query",
-- 		"vim",
-- 		"vimdoc",
-- 		"typescript",
-- 		"javascript",
-- 		"html",
-- 		"typst",
-- 	},
-- 	auto_install = true,
-- 	highlight = { enable = true },
-- })
--
-- --conform
-- require("conform").setup({
-- 	formatters = {
-- 		biome = {
-- 			require_cwd = true,
-- 		},
-- 		["biome-organize-imports"] = {
-- 			require_cwd = true,
-- 		},
-- 		prettierd = {
-- 			require_cwd = true,
-- 		},
-- 	},
-- 	formatters_by_ft = {
-- 		javascriptreact = {
-- 			"prettierd",
-- 			"biome",
-- 			"biome-organize-imports",
-- 		},
-- 		typescriptreact = {
-- 			"prettierd",
-- 			"biome",
-- 			"biome-organize-imports",
-- 		},
-- 		javascript = {
-- 			"prettierd",
-- 			"biome",
-- 			"biome-organize-imports",
-- 		},
-- 		typescript = {
-- 			"prettierd",
-- 			"biome",
-- 			"biome-organize-imports",
-- 		},
-- 	},
-- 	format_on_save = { --INFO: this automatically creates the autocmd for BufWritePre
-- 		timeout_ms = 500,
-- 		lsp_format = "fallback",
-- 	},
-- })
--
-- vim.env.ESLINT_D_PPID = vim.fn.getpid()
-- require("lint").linters_by_ft = {
-- 	javascript = {
-- 		"eslint_d",
-- 	},
-- 	typescript = {
-- 		"eslint_d",
-- 	},
-- 	javascriptreact = {
-- 		"eslint_d",
-- 	},
-- 	typescriptreact = {
-- 		"eslint_d",
-- 	},
-- }
--
-- --snacks
-- ---@diagnostic disable-next-line: unnecessary-if
-- if package.loaded["snacks"] then
-- 	package.loaded["snacks"] = nil
-- end
-- require("snacks").setup({
-- 	--disabled
-- 	bigfile = { enabled = false },
-- 	dashboard = { enabled = false },
-- 	explorer = { enabled = false },
-- 	input = { enabled = false },
-- 	picker = { enabled = false },
-- 	quickfile = { enabled = false },
-- 	scroll = { enabled = false },
-- 	words = { enabled = false },
-- 	statuscolumn = { enabled = false },
-- 	--enabled
-- 	indent = { enabled = true },
-- 	notifier = { enabled = true },
-- 	scope = { enabled = true },
-- })
--
-- --comment
-- require("Comment").setup({
-- 	pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
-- })
--
-- --lualine
-- require("lualine").setup({
-- 	options = {
-- 		icons_enabled = false,
-- 		theme = "tokyonight",
-- 		component_separators = { left = "|", right = "|" },
-- 		section_separators = { left = "", right = "" },
-- 		globalstatus = true,
-- 	},
-- 	sections = {
-- 		lualine_c = { { "filename", path = 1 } },
-- 		lualine_x = { "encoding" },
-- 		lualine_y = {},
-- 	},
-- })
--
-- --copilot
-- require('copilot').setup({
-- 	panel = {
-- 		enabled = false,
-- 	},
-- 	suggestion = {
-- 		enabled = true,
-- 		auto_trigger = true,
-- 		keymap = {
-- 			accept = "<TAB>",
-- 		},
-- 	},
-- 	nes = {
-- 		enabled = false, -- requires copilot-lsp as a dependency
-- 		auto_trigger = false,
-- 	},
-- })
--
-- vim.api.nvim_create_autocmd("User", {
-- 	pattern = "BlinkCmpMenuOpen",
-- 	callback = function()
-- 		vim.b.copilot_suggestion_hidden = true
-- 	end,
-- })
--
-- vim.api.nvim_create_autocmd("User", {
-- 	pattern = "BlinkCmpMenuClose",
-- 	callback = function()
-- 		vim.b.copilot_suggestion_hidden = false
-- 	end,
-- })
--
-- vim.api.nvim_create_autocmd("InsertLeave", {
-- 	callback = function()
-- 		-- Dismiss Copilot ghost text when exiting insert mode
-- 		local ok, copilot_suggestion = pcall(require, "copilot.suggestion")
-- 		if ok and copilot_suggestion then
-- 			copilot_suggestion.dismiss()
-- 		end
-- 	end,
-- })
--
-- --vim setup
-- vim.lsp.enable({ "emmylua_ls", 
-- "gh-actions-language-server", "tinymist", "vtsls", "tailwindcss", "jsonls", "css-lsp",	"clangd" 
-- })
-- vim.lsp.config("emmylua_ls", {
-- 	cmd = { "emmylua_ls" },
-- 	settings = {
-- 		Lua = {
-- 			workspace = {
-- 				library = {
-- 					vim.env.VIMRUNTIME,
-- 				}
-- 			}
-- 		}
-- 	}
-- })
-- -- clangd config for platform.io embeded programming
-- vim.lsp.config("clangd", {
-- 	cmd = {
-- 		"clangd",
-- 		"--background-index",
-- 		"--clang-tidy",
-- 		"--header-insertion=iwyu",
-- 		"--completion-style=detailed",
-- 		"--function-arg-placeholders",
-- 		"--fallback-style=llvm",
-- 		"--query-driver=**", -- 👈 THIS IS THE KEY FIX
-- 	}
-- })
-- vim.lsp.config("tailwindcss", {
-- 	cmd = { "tailwindcss-language-server", "--stdio" },
-- 	settings = {
-- 		tailwindCSS = {
-- 			-- Add your custom class attributes
-- 			classAttributes = {
-- 				"class",
-- 				"className",
-- 				"headerClassName",
-- 				"contentContainerClassName",
-- 				"columnWrapperClassName",
-- 				"endFillColorClassName",
-- 				"imageClassName",
-- 				"tintColorClassName",
-- 				"ios_backgroundColorClassName",
-- 				"thumbColorClassName",
-- 				"trackColorOnClassName",
-- 				"trackColorOffClassName",
-- 				"selectionColorClassName",
-- 				"cursorColorClassName",
-- 				"underlineColorAndroidClassName",
-- 				"placeholderTextColorClassName",
-- 				"selectionHandleColorClassName",
-- 				"colorsClassName",
-- 				"progressBackgroundColorClassName",
-- 				"titleColorClassName",
-- 				"underlayColorClassName",
-- 				"colorClassName",
-- 				"drawerBackgroundColorClassName",
-- 				"statusBarBackgroundColorClassName",
-- 				"backdropColorClassName",
-- 				"backgroundColorClassName",
-- 				"ListFooterComponentClassName",
-- 				"ListHeaderComponentClassName",
-- 			},
-- 			classFunctions = { "useResolveClassNames" },
-- 		},
-- 	}
-- })
--
-- vim.diagnostic.config({
-- 	virtual_lines = {
-- 		current_line = true,
-- 	},
-- })

--theme
vim.cmd([[colorscheme ultradark]])
