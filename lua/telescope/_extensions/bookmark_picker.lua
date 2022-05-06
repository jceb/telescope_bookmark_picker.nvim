local has_telescope, telescope = pcall(require, "telescope")
local main = require("telescope._extensions.bookmark_picker.main")

if not has_telescope then
    error("This plugins requires nvim-telescope/telescope.nvim")
end

return telescope.register_extension({
    -- exporter has to have same name as the extension -> bookmark_picker
    exports = { bookmark_picker = main.run_bookmark_picker },
    setup = main.setup,
})
