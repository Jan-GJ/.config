--options
local opt = vim.opt
opt.fillchars = {
	foldopen = "",
	foldclose = "",
	fold = " ",
	foldsep = " ",
	diff = "╱",
	eob = " ",
}
opt.clipboard = vim.env.SSH_CONNECTION and "" or "unnamedplus"
opt.foldlevel = 99
opt.foldtext = ""
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
opt.foldcolumn = "1"

--globals
local vim_global = vim.g
vim_global.mapleader = " "
vim_global.loaded_ruby_provider = 0
vim_global.loaded_python3_provider = 0
vim_global.loaded_perl_provider = 0

--vom lsp error display
vim.diagnostic.config({
	virtual_lines = {
		current_lin = true,
	},
})

--package manager
local plugins = {
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/ellisonleao/gruvbox.nvim" },
	{ src = "https://github.com/projekt0n/github-nvim-theme" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/j-hui/fidget.nvim" },
	{ src = "https://github.com/windwp/nvim-ts-autotag" },
	{ src = "https://github.com/windwp/nvim-autopairs" },
	{ src = "https://github.com/folke/todo-comments.nvim" },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/numToStr/Comment.nvim" },
	{ src = "https://github.com/JoosepAlviste/nvim-ts-context-commentstring" },
	{ src = "https://github.com/HiPhish/rainbow-delimiters.nvim" },
	{ src = "https://github.com/f-person/git-blame.nvim" },
	{ src = "https://github.com/nvim-lualine/lualine.nvim" },
	{ src = "https://github.com/chomosuke/typst-preview.nvim" },
	{ src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
	{ src = "https://github.com/folke/snacks.nvim" },
	{ src = "https://github.com/Saghen/blink.cmp" },
	{ src = "https://github.com/L3MON4D3/LuaSnip" },
	{ src = "https://github.com/soulsam480/nvim-oxlint" }

	-- { src = "https://github.com/zbirenbaum/copilot.lua" },
	-- { src = "https://github.com/copilotlsp-nvim/copilot-lsp" }
	-- { src = "https://github.com/mfussenegger/nvim-lint" },
}
vim.pack.add(plugins)

--plugins
require "mason".setup {}
require "telescope".setup {}
require "gitsigns".setup {}
require "mason-lspconfig".setup {}
require "todo-comments".setup {}
require "nvim-ts-autotag".setup {}
require "nvim-autopairs".setup {}

--gitsigns
local gitsigns = require "gitsigns"

--keybinds
local map = vim.keymap.set
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
	require "snacks".picker.undo()
end)
map("n", "<leader>gb", gitsigns.blame)

--treesitter
local nvim_treesitter = require "nvim-treesitter"
nvim_treesitter.setup {}
vim.api.nvim_create_autocmd('FileType', {
	desc = 'Install Treesitter parser',
	callback = function(event)
		local lang = vim.treesitter.language.get_lang(event.match) or event.match
		nvim_treesitter.install({ lang })
	end,
})
vim.api.nvim_create_autocmd("FileType", {
	desc = "Enable Treesitter features",
	callback = function(event)
		local lang = vim.treesitter.language.get_lang(event.match) or event.match
		if vim.treesitter.query.get(lang, "highlights") then
			vim.treesitter.start()
		end
		if vim.treesitter.query.get(lang, "indents") then
			vim.bo.indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
		end

		if vim.treesitter.query.get(lang, "folds") then
			vim.wo.foldmethod = "expr"
			vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
		end
	end,
})

--oil
require 'oil'.setup {
	view_options = {
		show_hidden = true,
	}
}

--fidget
local fidget = require "fidget"
fidget.setup {}
vim.notify = fidget.notify

--comment
require "Comment".setup {
	pre_hook = require "ts_context_commentstring.integrations.comment_nvim".create_pre_hook(),
}

--lualine
require "lualine".setup {
	options = {
		icons_enabled = false,
		theme = "github_dark_high_contrast",
		component_separators = { left = "|", right = "|" },
		section_separators = { left = "", right = "" },
		globalstatus = true,
	},
	sections = {
		lualine_c = { { "filename", path = 1 } },
		lualine_x = { "encoding", "filetype",
			{
				function()
					local format = vim.bo.fileformat
					if format == 'unix' then
						return 'LF'
					elseif format == 'dos' then
						return 'CRLF'
					elseif format == 'mac' then
						return 'CR'
					end
					return format
				end
			},
		},
		lualine_y = {},
	},
}

--conform
require "conform".setup {
	formatters = {
		oxfmt = {
			require_cwd = true,
		},
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
		json = {
			"oxfmt"
		},
		javascriptreact = {
			"oxfmt",
			"prettierd",
			"biome",
			"biome-organize-imports",
		},
		yaml = {
			"oxfmt"
		},
		typescriptreact = {
			"oxfmt",
			"prettierd",
			"biome",
			"biome-organize-imports",
		},
		javascript = {
			"oxfmt",
			"prettierd",
			"biome",
			"biome-organize-imports",
		},
		typescript = {
			"oxfmt",
			"prettierd",
			"biome",
			"biome-organize-imports",
		},
	},
	format_on_save = { --INFO: this automatically creates the autocmd for BufWritePre
		timeout_ms = 500,
		lsp_format = "fallback",
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
	notifier = { enabled = false },
	--enabled
	indent = { enabled = true },
	scope = { enabled = true },
})

--Luasnip
require "luasnip".setup {}

--blink
require "blink.cmp".setup {
	keymap = { preset = "enter" },
	snippets = {
		preset = "luasnip",
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
		-- ghost_text = {
		-- 	enabled = vim.g.ai_cmp,
		-- },

	},
	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
	},
	-- cmdline = {
	-- 	enabled = true,
	-- 	keymap = {
	-- 		preset = "cmdline",
	-- 		["<Right>"] = false,
	-- 		["<Left>"] = false,
	-- 	},
	-- 	completion = {
	-- 		list = { selection = { preselect = false } },
	-- 		menu = {
	-- 			auto_show = function(_ctx)
	-- 				return vim.fn.getcmdtype() == ":"
	-- 			end,
	-- 		},
	-- 		ghost_text = { enabled = true },
	-- 	},
	-- },
}


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
--
--
local util = require 'lspconfig.util'
vim.lsp.config("oxfmt",

	{
		cmd = function(dispatchers, config)
			local cmd = 'oxfmt'
			local local_cmd = (config or {}).root_dir and config.root_dir .. '/node_modules/.bin/oxfmt'
			if local_cmd and vim.fn.executable(local_cmd) == 1 then
				cmd = local_cmd
			end
			return vim.lsp.rpc.start({ cmd, '--lsp' }, dispatchers)
		end,
		filetypes = {
			'javascript',
			'javascriptreact',
			'typescript',
			'typescriptreact',
			'toml',
			'json',
			'jsonc',
			'json5',
			'yaml',
			'html',
			'vue',
			'handlebars',
			'css',
			'scss',
			'less',
			'graphql',
			'markdown',
		},
		workspace_required = true,
		root_dir = function(bufnr, on_dir)
			local fname = vim.api.nvim_buf_get_name(bufnr)

			-- Oxfmt resolves configuration by walking upward and using the nearest config file
			-- to the file being processed. We therefore compute the root directory by locating
			-- the closest `.oxfmtrc.json` / `.oxfmtrc.jsonc` (or `package.json` fallback) above the buffer.
			local root_markers = util.insert_package_json({ '.oxfmtrc.json', '.oxfmtrc.jsonc' }, 'oxfmt', fname)
			on_dir(vim.fs.dirname(vim.fs.find(root_markers, { path = fname, upward = true })[1]))
		end,
	}

)

local function oxlint_conf_mentions_typescript(root_dir)
	local fn = vim.fs.joinpath(root_dir, '.oxlintrc.json')
	for line in io.lines(fn) do
		if line:find('typescript') then
			return true
		end
	end
	return false
end



vim.lsp.config("oxlint",
	{
		cmd = function(dispatchers, config)
			local cmd = 'oxlint'
			local local_cmd = (config or {}).root_dir and config.root_dir .. '/node_modules/.bin/oxlint'
			if local_cmd and vim.fn.executable(local_cmd) == 1 then
				cmd = local_cmd
			end
			return vim.lsp.rpc.start({ cmd, '--lsp' }, dispatchers)
		end,
		filetypes = {
			'javascript',
			'javascriptreact',
			'typescript',
			'typescriptreact',
			'vue',
			'svelte',
			'astro',
		},
		root_markers = { '.oxlintrc.json', 'oxlint.config.ts' },
		workspace_required = true,

		on_attach = function(client, bufnr)
			vim.api.nvim_buf_create_user_command(bufnr, 'LspOxlintFixAll', function()
				client:exec_cmd({
					title = 'Apply Oxlint automatic fixes',
					command = 'oxc.fixAll',
					arguments = { { uri = vim.uri_from_bufnr(bufnr) } },
				})
			end, {
				desc = 'Apply Oxlint automatic fixes',
			})
			vim.api.nvim_create_autocmd('BufWritePre', {
				buffer = bufnr,
				callback = function()
					client:exec_cmd({
						title = 'Apply Oxlint automatic fixes',
						command = 'oxc.fixAll',
						arguments = { { uri = vim.uri_from_bufnr(bufnr) } },
					}, { bufnr = bufnr })
				end,
			})
		end,


		settings = {
			-- run = 'onType',
			-- configPath = nil,
			-- tsConfigPath = nil,
			-- unusedDisableDirectives = 'allow',
			-- typeAware = false,
			-- disableNestedConfig = false,
			-- fixKind = 'safe_fix',
		},
		before_init = function(init_params, config)
			local settings = config.settings or {}
			if settings.typeAware == nil and vim.fn.executable('tsgolint') == 1 then
				local ok, res = pcall(oxlint_conf_mentions_typescript, config.root_dir)
				if ok and res then
					settings = vim.tbl_extend('force', settings, { typeAware = true })
				end
			end
			local init_options = config.init_options or {}
			init_options.settings = vim.tbl_extend('force', init_options.settings or {} --[[@as table]], settings)

			init_params.initializationOptions = init_options
		end,
	}
)


vim.filetype.add({
	extension = {
		env = "sh",
	},
	filename = {
		[".env"] = "sh",
	},
	pattern = {
		["%.env%.[%w_.-]+"] = "sh",
	},
})

--theme
require "github-theme".setup {
	options = {
		transparent = true
	}
}
vim.cmd([[colorscheme github_dark_high_contrast]])
