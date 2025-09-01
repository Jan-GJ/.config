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
	Snacks.picker.undo()
end)
map("n", "<leader>gb", function()
	require("gitsigns").blame()
end)

--package manager
local plugins = {
	core = {
		{ src = "https://github.com/nvim-lua/plenary.nvim" },
		{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
		{ src = "https://github.com/mason-org/mason.nvim" },
	},
	navigation = {
		{ src = "https://github.com/nvim-telescope/telescope.nvim" },
		{ src = "https://github.com/stevearc/oil.nvim" },
		{ src = "https://github.com/echasnovski/mini.pick" },
	},
	language_features = {
		{ src = "https://github.com/Saghen/blink.cmp" }, -- Autocompletion
		{ src = "https://github.com/windwp/nvim-ts-autotag" },
		{ src = "https://github.com/windwp/nvim-autopairs" },
		{ src = "https://github.com/HiPhish/rainbow-delimiters.nvim" },
		{ src = "https://github.com/mfussenegger/nvim-lint" },
		{ src = "https://github.com/stevearc/conform.nvim" }, -- Formatting
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
		{ src = "https://github.com/NvChad/showkeys", opt = true },
		{ src = "https://github.com/folke/todo-comments.nvim" },
		{ src = "https://github.com/nvim-lualine/lualine.nvim" },
		{ src = "https://github.com/folke/snacks.nvim" },
		{ src = "https://github.com/j-hui/fidget.nvim" },
	},
	themes = {
		{ src = "https://github.com/vague2k/vague.nvim" },
		{ src = "https://github.com/ribru17/bamboo.nvim" },
	},
	specific_language = {
		typst = {
			{ src = "https://github.com/chomosuke/typst-preview.nvim" },
		},
		obsidian = {
			{ src = "https://github.com/obsidian-nvim/obsidian.nvim" },
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
require("oil").setup()
require("mason").setup()
require("mini.pick").setup()
require("telescope").setup()
require("todo-comments").setup()
require("nvim-ts-autotag").setup()
require("nvim-autopairs").setup()
require("gitsigns").setup()
require("fidget").setup({})

--obisidan
require("obsidian").setup({
	legacy_commands = false,
	workspaces = {
		{
			name = "University",
			path = "~/Sync/Obsidian Vaults/",
		},
	},
})

--showkeys
require("showkeys").setup({ position = "top-right" })

--blink
require("blink.cmp").setup({
	keymap = { preset = "enter" },
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
	formatters_by_ft = {
		lua = { "stylua" },
		json = { "jq" },
		javascriptreact = { "prettierd" },
		typescriptreact = { "prettierd" },
		javascript = { "prettierd" },
		typescript = { "prettierd" },
	},
	format_on_save = { --INFO: this automatically creates the autocmd for BufWritePre
		timeout_ms = 500,
		lsp_format = "fallback",
	},
})

--lint
vim.env.ESLINT_D_PPID = vim.fn.getpid()
require("lint").linters_by_ft = {
	javascript = { "eslint_d" },
	typescript = { "eslint_d" },
	javascriptreact = { "eslint_d" },
	typescriptreact = { "eslint_d" },
}

--snacks
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
local custom_lualine_theme = require("lualine.themes.iceberg_dark")
custom_lualine_theme.normal.c.bg = "#000000"
require("lualine").setup({
	options = {
		icons_enabled = false,
		theme = custom_lualine_theme,
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
vim.lsp.enable({ "lua_ls", "tinymist", "vtsls", "tailwindcss" })
vim.diagnostic.config({
	virtual_lines = {
		current_line = true,
	},
})
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function()
		require("lint").try_lint()
	end,
})

--theme
local function load_theme(theme_name)
	local ok, mod = pcall(require, theme_name)
	if ok and mod and type(mod.setup) == "function" then
		mod.setup({ transparent = true })
		vim.cmd("colorscheme " .. theme_name)
		vim.cmd(":hi statusline guibg=NONE")
	else
		vim.notify("Failed to load theme: " .. tostring(theme_name), vim.log.levels.ERROR)
	end
end

load_theme("bamboo")
