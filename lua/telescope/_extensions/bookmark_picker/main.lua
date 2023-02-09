P = function(v)
    print(vim.inspect(v))
    return v
end

local has_telescope, telescope = pcall(require, "telescope")

if not has_telescope then
    error("This plugins requires nvim-telescope/telescope.nvim")
end

local M = {}
local actions = require("telescope.actions")
local actions_state = require("telescope.actions.state")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local conf = require("telescope.config").values

local load_bookmark = function(prompt_bufnr)
    -- local bookmark = actions_state.get_selected_entry(prompt_bufnr).value
    local bookmark = actions_state.get_selected_entry().value
    -- P(bookmark)
    actions.close(prompt_bufnr)
    vim.cmd("e " .. bookmark)
end

local bookmark_picker = function(bookmarks, opts)
    pickers
        .new(opts, {
            prompt_title = "Select a bookmark",
            results_title = "bookmarks",
            finder = finders.new_table({
                results = bookmarks,
                entry_maker = function(entry)
                    return {
                        value = entry.path,
                        display = entry.name,
                        ordinal = entry.name,
                    }
                end,
            }),
            sorter = conf.file_sorter({}),
            attach_mappings = function(prompt_bufnr, map)
                map("i", "<CR>", load_bookmark)
                return true
            end,
        })
        :find()
end

local bookmarks_file = vim.fn.expand("~/.config/gtk-3.0/bookmarks")

M.setup = function(ext_config)
    bookmarks_file = ext_config.bookmarks_file or vim.fn.expand("~/.config/gtk-3.0/bookmarks")
end

local hex_to_char = function(x)
    return string.char(tonumber(x, 16))
end

local unescape = function(url)
    return url:gsub("%%(%x%x)", hex_to_char)
end

local stripFile = function(str)
    return string.gsub(str, "^file:///", "/")
end

M.run_bookmark_picker = function(opts)
    opts = opts or {}
    local handle = vim.loop.fs_open(vim.fn.expand(bookmarks_file), "r", 0)
    P(handle)
    if handle == nil then
        print("Setup correct 'bookmarks_file': \"" .. bookmarks_file .. '" does not seem to exist. Cancelling')
        return
    end
    if type(handle) == "string" then
        vim.api.nvim_err_writeln(handle)
        return
    end

    local file_contents = ""
    local read = vim.loop.fs_read(handle, 1000)
    local bookmarks = {}
    while read ~= "" do
        file_contents = read
        read = vim.loop.fs_read(handle, 1000)
    end
    for line in vim.gsplit(file_contents, "\n") do
        local bookmark
        for i, entry in ipairs(vim.split(line, " ")) do
            if i == 1 then
                bookmark = entry
            else
                table.insert(bookmarks, { name = entry, path = stripFile(unescape(bookmark)) })
            end
        end
    end

    bookmark_picker(bookmarks, opts)
end

-- return telescope.register_extension {exports = {sessions = run_sessions_picker}}
return M
