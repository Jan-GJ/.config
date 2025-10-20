--options
vim.opt.winborder = "rounded"
vim.opt.tabstop = 2
vim.opt.cursorcolumn = false
vim.opt.ignorecase = true
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.swapfile = false
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.incsearch = true
vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 8
vim.o.winborder = 'none'

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
map("n", "<leader>f", ":Pick files<CR>")
map("n", "<leader>h", ":Pick help<CR>")
map("n", "<leader>e", ":Oil<CR>")
map("n", "<leader>vd", vim.diagnostic.open_float)
map("n", "gd", vim.lsp.buf.definition)
map("n", "<leader>ps", function()
	require("telescope.builtin").live_grep()
end)
map("n", "<leader>ut", function()
	require("snacks").picker.undo()
end)
map("n", "<leader>gb", function()
	require("gitsigns").blame()
end)

--package manager
local plugins = {
	core = {
		{ src = 'https://github.com/neovim/nvim-lspconfig' },
		{ src = "https://github.com/nvim-lua/plenary.nvim" },
		{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
		{ src = "https://github.com/mason-org/mason.nvim" },
		{ src = "https://github.com/nvim-telescope/telescope.nvim" },
		{ src = "https://github.com/stevearc/oil.nvim" },
		{ src = "https://github.com/Saghen/blink.cmp" },    -- Autocompletion
		{ src = "https://github.com/stevearc/conform.nvim" }, -- Formatting
	},
	navigation = {
		{ src = "https://github.com/echasnovski/mini.pick" }, --TODO: replace by telescope
	},
	language_features = {
		{ src = "https://github.com/mfussenegger/nvim-lint" },
		{ src = "https://github.com/windwp/nvim-ts-autotag" },
		{ src = "https://github.com/windwp/nvim-autopairs" },
		{ src = "https://github.com/HiPhish/rainbow-delimiters.nvim" },
		commenting = {
			{ src = "https://github.com/numToStr/Comment.nvim" },
			{ src = "https://github.com/JoosepAlviste/nvim-ts-context-commentstring" },
		},
		{ src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
	},
	ui = {
		git = {
			{ src = "https://github.com/f-person/git-blame.nvim" },
			{ src = "https://github.com/lewis6991/gitsigns.nvim" },
		},
		{ src = "https://github.com/NvChad/showkeys",          opt = true },
		{ src = "https://github.com/folke/todo-comments.nvim" },
		{ src = "https://github.com/nvim-lualine/lualine.nvim" },
		{ src = "https://github.com/folke/snacks.nvim" },
		{ src = "https://github.com/j-hui/fidget.nvim" },
	},
	themes = {
		{ src = "https://github.com/vague2k/vague.nvim" },
		{ src = "https://github.com/ribru17/bamboo.nvim" },
		{ src = "https://github.com/folke/tokyonight.nvim" },
	},
	specific_language = {
		typst = {
			{ src = "https://github.com/chomosuke/typst-preview.nvim" },
		},
	},
}

local all_plugins = {}
local function flatten(tbl)
	if tbl.src then
		table.insert(all_plugins, tbl)
		return
	end
	for _, value in pairs(tbl) do
		if type(value) == "table" then
			flatten(value)
		end
	end
end
flatten(plugins)
vim.pack.add(all_plugins)

--plugin configs
require("oil").setup({
	view_options = {
		show_hidden = true,
	},
})
require("mason").setup({
	registries = {
		"github:mason-org/mason-registry",
		"github:mkindberg/ghostty-ls",
	},
})
require("mini.pick").setup()
require("telescope").setup({
	extensions = {},
})
require("todo-comments").setup()
require("nvim-ts-autotag").setup()
require("nvim-autopairs").setup()
require("gitsigns").setup()
require("fidget").setup({})

--showkeys
require("showkeys").setup({ position = "top-right" })
--blink
require("blink.cmp").setup({
	keymap = { preset = "enter" },
	snippets = {
		preset = "default",
	},
	appearance = {
		kind_icons = {
			Array         = " ",
			Boolean       = "󰨙 ",
			Class         = " ",
			Codeium       = "󰘦 ",
			Color         = " ",
			Control       = " ",
			Collapsed     = " ",
			Constant      = "󰏿 ",
			Constructor   = " ",
			Copilot       = " ",
			Enum          = " ",
			EnumMember    = " ",
			Event         = " ",
			Field         = " ",
			File          = " ",
			Folder        = " ",
			Function      = "󰊕 ",
			Interface     = " ",
			Key           = " ",
			Keyword       = " ",
			Method        = "󰊕 ",
			Module        = " ",
			Namespace     = "󰦮 ",
			Null          = " ",
			Number        = "󰎠 ",
			Object        = " ",
			Operator      = " ",
			Package       = " ",
			Property      = " ",
			Reference     = " ",
			Snippet       = "󱄽 ",
			String        = " ",
			Struct        = "󰆼 ",
			Supermaven    = " ",
			TabNine       = "󰏚 ",
			Text          = " ",
			TypeParameter = " ",
			Unit          = " ",
			Value         = " ",
			Variable      = "󰀫 ",
		},
		nerd_font_variant = "mono",
	},
	completion = {
		menu = {
			draw = {
				treesitter = { "lsp" },
				columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } }
			},
		},
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 200,
		},
		ghost_text = {
			enabled = vim.g.ai_cmp,
		},

		sources = {
			compat = {},
			default = { "lsp", "path", "snippets", "buffer" },
		},
		cmdline = {
			enabled = true,
			keymap = {
				preset = "cmdline",
				["<Right>"] = false,
				["<Left>"] = false,
			},
			completion = {
				list = { selection = { preselect = false } },
				menu = {
					auto_show = function(_ctx)
						return vim.fn.getcmdtype() == ":"
					end,
				},
				ghost_text = { enabled = true },
			},
		},
	},

})

--treesitter
require("nvim-treesitter.configs").setup({
	modules = {},
	ignore_install = {},
	sync_install = false,
	ensure_installed = {
		"bash",
		"c",
		"diff",
		"lua",
		"luadoc",
		"json5",
		"markdown",
		"markdown_inline",
		"query",
		"vim",
		"vimdoc",
		"typescript",
		"javascript",
		"html",
		"typst",
	},
	auto_install = true,
	highlight = { enable = true },
})

--conform
require("conform").setup({
	formatters = {
		biome = {
			require_cwd = true,
		},
		["biome-organize-imports"] = {
			require_cwd = true,
		},
		prettierd = {
			require_cwd = true,
		},
	},
	formatters_by_ft = {
		javascriptreact = {
			"prettierd",
			"biome",
			"biome-organize-imports",
		},
		typescriptreact = {
			"prettierd",
			"biome",
			"biome-organize-imports",
		},
		javascript = {
			"prettierd",
			"biome",
			"biome-organize-imports",
		},
		typescript = {
			"prettierd",
			"biome",
			"biome-organize-imports",
		},
	},
	format_on_save = { --INFO: this automatically creates the autocmd for BufWritePre
		timeout_ms = 500,
		lsp_format = "fallback",
	},
})

vim.env.ESLINT_D_PPID = vim.fn.getpid()
require("lint").linters_by_ft = {
	javascript = {
		"eslint_d",
	},
	typescript = {
		"eslint_d",
	},
	javascriptreact = {
		"eslint_d",
	},
	typescriptreact = {
		"eslint_d",
	},
}

--snacks
---@diagnostic disable-next-line: unnecessary-if
if package.loaded["snacks"] then
	package.loaded["snacks"] = nil
end
require("snacks").setup({
	--disabled
	bigfile = { enabled = false },
	dashboard = { enabled = false },
	explorer = { enabled = false },
	input = { enabled = false },
	picker = { enabled = false },
	quickfile = { enabled = false },
	scroll = { enabled = false },
	words = { enabled = false },
	statuscolumn = { enabled = false },
	--enabled
	indent = { enabled = true },
	notifier = { enabled = true },
	scope = { enabled = true },
})

--comment
local comment = require("Comment")
comment.setup({
	pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
})

--lualine
require("lualine").setup({
	options = {
		icons_enabled = false,
		theme = "tokyonight",
		component_separators = { left = "|", right = "|" },
		section_separators = { left = "", right = "" },
		globalstatus = true,
	},
	sections = {
		lualine_c = { { "filename", path = 1 } },
		lualine_x = { "encoding" },
		lualine_y = {},
	},
})

--vim setup
vim.lsp.enable({ "emmylua_ls", "tinymist", "vtsls", "tailwindcss", "jsonls" })
vim.lsp.config("emmylua_ls", {
	cmd = { "emmylua_ls" },
	settings = {
		Lua = {
			workspace = {
				library = {
					vim.env.VIMRUNTIME
				}
			}
		}
	}
})
vim.diagnostic.config({
	virtual_lines = {
		current_line = true,
	},
})

--theme
vim.cmd [[colorscheme tokyonight-night]]
