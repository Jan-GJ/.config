-- options
local opt = vim.opt
opt.fillchars = { foldopen = "", foldclose = "", fold = " ", foldsep = " ", diff = "╱", eob = " " }
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
opt.colorcolumn = "80"
opt.foldcolumn = "1"

local function raise_file_descriptor_limit()
	if vim.uv.os_uname().sysname ~= "Darwin" then
		return
	end

	local ok, ffi = pcall(require, "ffi")
	if not ok then
		return
	end

	pcall(ffi.cdef, [[
		typedef unsigned long long rlim_t;
		struct rlimit {
			rlim_t rlim_cur;
			rlim_t rlim_max;
		};
		int getrlimit(int resource, struct rlimit *rlp);
		int setrlimit(int resource, const struct rlimit *rlp);
	]])

	local limit = ffi.new("struct rlimit[1]")
	local rlimit_nofile = 8
	local target = 4096

	if ffi.C.getrlimit(rlimit_nofile, limit) ~= 0 then
		return
	end

	local current = tonumber(limit[0].rlim_cur)
	local maximum = tonumber(limit[0].rlim_max)
	if not current or current >= target then
		return
	end

	if maximum and maximum > 0 then
		target = math.min(target, maximum)
	end

	limit[0].rlim_cur = target
	pcall(ffi.C.setrlimit, rlimit_nofile, limit)
end

raise_file_descriptor_limit()

-- globals
local vim_global = vim.g
vim_global.mapleader = " "
vim_global.loaded_ruby_provider = 0
vim_global.loaded_python3_provider = 0
vim_global.loaded_perl_provider = 0

-- vom lsp error display
vim.diagnostic.config({
	virtual_lines = {
		current_line = true
	}
})

local function configure_lsp_capabilities(capabilities)
	capabilities = capabilities or vim.lsp.protocol.make_client_capabilities()
	capabilities.workspace = capabilities.workspace or {}
	capabilities.workspace.didChangeWatchedFiles = {
		dynamicRegistration = false
	}

	vim.lsp.config("*", {
		capabilities = capabilities
	})
end

configure_lsp_capabilities()

local max_treesitter_file_size = 1024 * 1024

local function is_normal_file_buffer(bufnr)
	if not vim.api.nvim_buf_is_valid(bufnr) or not vim.api.nvim_buf_is_loaded(bufnr) then
		return false
	end

	if vim.bo[bufnr].buftype ~= "" then
		return false
	end

	local name = vim.api.nvim_buf_get_name(bufnr)
	if name == "" then
		return false
	end

	local size = vim.fn.getfsize(name)
	return size >= 0 and size <= max_treesitter_file_size
end

local function get_treesitter_lang(bufnr)
	local filetype = vim.bo[bufnr].filetype
	if filetype == "" then
		return nil
	end

	return vim.treesitter.language.get_lang(filetype) or filetype
end

local function has_treesitter_parser(lang)
	if not lang then
		return false
	end

	return pcall(vim.treesitter.language.add, lang)
end

-- package manager
local plugins = {
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/HiPhish/rainbow-delimiters.nvim" },
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
	{ src = "https://github.com/brenoprata10/nvim-highlight-colors" },

	{ src = "https://github.com/nvim-lualine/lualine.nvim" },
	{ src = "https://github.com/chomosuke/typst-preview.nvim" },
	{ src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
	{ src = "https://github.com/folke/snacks.nvim" },
	{ src = "https://github.com/saghen/blink.lib" },
	{ src = "https://github.com/Saghen/blink.cmp" },
	{ src = "https://github.com/L3MON4D3/LuaSnip" },

	{ src = "https://github.com/folke/tokyonight.nvim" },
	{ src = "https://github.com/olimorris/onedarkpro.nvim" },
	{ src = "https://github.com/dmtrKovalenko/fff.nvim" }
	-- { src = "https://github.com/zbirenbaum/copilot.lua" },
	-- { src = "https://github.com/copilotlsp-nvim/copilot-lsp" }
}
vim.g.rainbow_delimiters = {
	blacklist = { "oil" },
	condition = function (bufnr)
		if not is_normal_file_buffer(bufnr) then
			return false
		end

		return has_treesitter_parser(get_treesitter_lang(bufnr))
	end
}
vim.pack.add(plugins)

-- plugins
require "mason".setup {}
require "telescope".setup {}
require "gitsigns".setup {
	current_line_blame = true,
	current_line_blame_opts = {
		delay = 500,
		virt_text_pos = "eol"
	}
}
require "mason-lspconfig".setup {}
require "todo-comments".setup {}
require "nvim-ts-autotag".setup {}
require "nvim-autopairs".setup {}
require "nvim-highlight-colors".setup {
	render = 'virtual',
	virtual_symbol = '⏺',
	virtual_symbol_suffix = '',
	virtual_symbol_prefix = ' ',
	virtual_symbol_position = 'eow',
	enable_tailwind = true
}

-- gitsigns
local gitsigns = require "gitsigns"

-- keybinds
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
map("n", "<leader>f", function ()
	require("fff").find_files()
end, { desc = "FFF find files" }
)
map("n", "<leader>h", ":Telescope help_tags<CR>")
map("n", "<leader>e", ":Oil<CR>")
map("n", "<leader>vd", vim.diagnostic.open_float)
map("n", "gd", vim.lsp.buf.definition)
map("n", "<leader>ps", function ()
	require("fff").live_grep()
end, { desc = "FFF live grep" }
)
map("n", "<leader>ut", function ()
	require "snacks".picker.undo()
end)
map("n", "<leader>gb", gitsigns.blame)

-- treesitter
local nvim_treesitter = require "nvim-treesitter"
nvim_treesitter.setup {}
local treesitter_parsers = require "nvim-treesitter.parsers"
local parser_install_started = {}

vim.api.nvim_create_autocmd('FileType', {
	desc = 'Install Treesitter parser',
	callback = function (event)
		if not is_normal_file_buffer(event.buf) then
			return
		end

		local lang = get_treesitter_lang(event.buf)
		if not lang or parser_install_started[lang] or has_treesitter_parser(lang) then
			return
		end

		local parser = treesitter_parsers[lang]
		if not parser or parser.tier == 4 then
			return
		end

		parser_install_started[lang] = true
		vim.schedule(function ()
			nvim_treesitter.install({ lang }, { max_jobs = 1 })
		end)
	end
})
vim.api.nvim_create_autocmd("FileType", {
	desc = "Enable Treesitter features",
	callback = function (event)
		if not is_normal_file_buffer(event.buf) then
			return
		end

		local lang = get_treesitter_lang(event.buf)
		if not has_treesitter_parser(lang) then
			return
		end

		local ok, highlights = pcall(vim.treesitter.query.get, lang, "highlights")
		if ok and highlights then
			pcall(vim.treesitter.start, event.buf, lang)
		end

		local has_indents
		ok, has_indents = pcall(vim.treesitter.query.get, lang, "indents")
		if ok and has_indents then
			vim.bo[event.buf].indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
		end

		local has_folds
		ok, has_folds = pcall(vim.treesitter.query.get, lang, "folds")
		if ok and has_folds then
			local win = vim.fn.bufwinid(event.buf)
			if win ~= -1 then
				vim.wo[win].foldmethod = "expr"
				vim.wo[win].foldexpr = "v:lua.vim.treesitter.foldexpr()"
			end
		end
	end
})

-- oil
require 'oil'.setup {
	view_options = {
		show_hidden = true
	}
}

-- fidget
local fidget = require "fidget"
fidget.setup {}
vim.notify = fidget.notify

-- comment
require "ts_context_commentstring".setup { enable_autocmd = false }
require "Comment".setup { pre_hook = require "ts_context_commentstring.integrations.comment_nvim".create_pre_hook() }

require "lualine".setup {
	options = {
		icons_enabled = false,
		theme = "tokyonight-night",
		component_separators = { left = "|", right = "|" },
		section_separators = { left = "", right = "" },
		globalstatus = true
	},
	sections = {
		lualine_c = { { "filename", path = 1 } },
		lualine_x = {
			"encoding",
			"filetype",
			{
				function ()
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
			}
		},
		lualine_y = {}
	}
}

-- conform
require "conform".setup {
	formatters = {
		oxfmt = {
			require_cwd = true
		},
		biome = {
			require_cwd = true
		},
		["biome-organize-imports"] = {
			require_cwd = true
		},
		prettierd = {
			require_cwd = true
		}
	},
	formatters_by_ft = {
		json = {
			"oxfmt"
		},
		javascriptreact = {
			"oxfmt",
			"prettierd",
			"biome",
			"biome-organize-imports"
		},
		yaml = {
			"oxfmt"
		},
		typescriptreact = {
			"oxfmt",
			"prettierd",
			"biome",
			"biome-organize-imports"
		},
		javascript = {
			"oxfmt",
			"prettierd",
			"biome",
			"biome-organize-imports"
		},
		typescript = {
			"oxfmt",
			"prettierd",
			"biome",
			"biome-organize-imports"
		}
	},
	format_on_save = { --INFO: this automatically creates the autocmd for BufWritePre
		timeout_ms = 500,
		lsp_format = "fallback"
	}
}

-- snacks
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
	indent = { enabled = false },
	scope = { enabled = true }
})

-- fff
require("fff").setup({})
local fff_download = require("fff.download")
if vim.fn.filereadable(fff_download.get_binary_path()) == 0 then
	pcall(fff_download.download_or_build_binary)
end

-- Luasnip
require "luasnip".setup {}

-- blink
require "blink.cmp".setup {
	keymap = { preset = "enter" },
	snippets = {
		preset = "luasnip"
	},
	appearance = {
		kind_icons = {
			Array = " ",
			Boolean = "󰨙 ",
			Class = " ",
			Codeium = "󰘦 ",
			Color = " ",
			Control = " ",
			Collapsed = " ",
			Constant = "󰏿 ",
			Constructor = " ",
			Copilot = " ",
			Enum = " ",
			EnumMember = " ",
			Event = " ",
			Field = " ",
			File = " ",
			Folder = " ",
			Function = "󰊕 ",
			Interface = " ",
			Key = " ",
			Keyword = " ",
			Method = "󰊕 ",
			Module = " ",
			Namespace = "󰦮 ",
			Null = " ",
			Number = "󰎠 ",
			Object = " ",
			Operator = " ",
			Package = " ",
			Property = " ",
			Reference = " ",
			Snippet = "󱄽 ",
			String = " ",
			Struct = "󰆼 ",
			Supermaven = " ",
			TabNine = "󰏚 ",
			Text = " ",
			TypeParameter = " ",
			Unit = " ",
			Value = " ",
			Variable = "󰀫 "
		},
		nerd_font_variant = "mono"
	},
	completion = {
		menu = {
			draw = {
				treesitter = { "lsp" },
				columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } }
			}
		},
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 200
		}
		-- ghost_text = {
		-- 	enabled = vim.g.ai_cmp,
		-- },
	},
	sources = {
		default = { "lsp", "path", "snippets", "buffer" }
	}
}
configure_lsp_capabilities(require("blink.cmp").get_lsp_capabilities(nil, true))

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

local util = require 'lspconfig.util'
vim.lsp.config("oxfmt", {
	cmd = function (dispatchers, config)
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
		'markdown'
	},
	workspace_required = true,
	root_dir = function (bufnr, on_dir)
		local fname = vim.api.nvim_buf_get_name(bufnr)

		-- Oxfmt resolves configuration by walking upward and using the nearest config file
		-- to the file being processed. We therefore compute the root directory by locating
		-- the closest `.oxfmtrc.json` / `.oxfmtrc.jsonc` (or `package.json` fallback) above the buffer.
		local root_markers = util.insert_package_json({ '.oxfmtrc.json', '.oxfmtrc.jsonc' }, 'oxfmt', fname)
		on_dir(vim.fs.dirname(vim.fs.find(root_markers, { path = fname, upward = true })[1]))
	end
})

local function oxlint_conf_mentions_typescript(root_dir)
	local fn = vim.fs.joinpath(root_dir, '.oxlintrc.json')
	for line in io.lines(fn) do
		if line:find('typescript') then
			return true
		end
	end
	return false
end

vim.lsp.config("oxlint", {
	cmd = function (dispatchers, config)
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
		'astro'
	},
	root_markers = { '.oxlintrc.json', 'oxlint.config.ts' },
	workspace_required = true,

	on_attach = function (client, bufnr)
		vim.api.nvim_buf_create_user_command(
			bufnr, 'LspOxlintFixAll',
			function ()
				client:exec_cmd({
					title = 'Apply Oxlint automatic fixes',
					command = 'oxc.fixAll',
					arguments = { { uri = vim.uri_from_bufnr(bufnr) } }
				})
			end,
			{
				desc = 'Apply Oxlint automatic fixes'
			}
		)
		vim.api.nvim_create_autocmd('BufWritePre', {
			buffer = bufnr,
			callback = function ()
				client:exec_cmd({
					title = 'Apply Oxlint automatic fixes',
					command = 'oxc.fixAll',
					arguments = { { uri = vim.uri_from_bufnr(bufnr) } }
				}, { bufnr = bufnr })
			end
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
	before_init = function (init_params, config)
		local settings = config.settings or {}
		if settings.typeAware == nil and vim.fn.executable('tsgo') == 1 then
			local ok, res = pcall(oxlint_conf_mentions_typescript, config.root_dir)
			if ok and res then
				settings = vim.tbl_extend('force', settings, { typeAware = true })
			end
		end
		local init_options = config.init_options or {}
		init_options.settings = vim.tbl_extend(
			'force',
			init_options.settings or {}, --[[@as table]]
			settings
		)

		init_params.initializationOptions = init_options
	end
})

vim.filetype.add({
	extension = {
		env = "sh"
	},
	filename = {
		[".env"] = "sh"
	},
	pattern = {
		["%.env%.[%w_.-]+"] = "sh"
	}
})

-- theme
local function apply_transparent_background()
	local groups = {
		"Normal", "NormalNC", "NormalFloat", "FloatBorder", "FloatTitle", "SignColumn", "FoldColumn", "LineNr",
		"CursorLineNr", "CursorLine", "CursorColumn", "ColorColumn", "EndOfBuffer", "StatusLine", "StatusLineNC", "TabLine",
		"TabLineFill", "WinBar", "WinBarNC", "WinSeparator", "Pmenu", "PmenuSel"
	}

	for _, group in ipairs(groups) do
		-- vim.cmd("highlight " .. group .. " guibg=NONE ctermbg=NONE")
	end
end

vim.api.nvim_create_autocmd("ColorScheme", {
	desc = "Keep editor backgrounds transparent",
	callback = apply_transparent_background
})
vim.cmd([[colorscheme tokyonight-night]])
apply_transparent_background()
