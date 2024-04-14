local vim = vim

local unica = require('unica')

-- There's probably a better way to do this .ftspec?
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
    pattern = "*.unica",
    callback = function()
        vim.opt.syntax = "txt"
        vim.opt.textwidth = 100
    end
})

vim.api.nvim_create_user_command(
    'UnicaH1',
    function(opts)
        local align = opts.args or "left"
        unica.toggle_h1(opts.line1, opts.line2, align)
    end,
    {range = true, nargs = "?"}
)

vim.api.nvim_create_user_command(
    'UnicaH2',
    function(opts)
        local align = opts.args or "left"
        unica.toggle_h2(opts.line1, opts.line2, align)
    end,
    {range = true, nargs = "?"}
)

vim.api.nvim_create_user_command(
    'UnicaH3',
    function(opts)
        local align = opts.args or "left"
        unica.toggle_h3(opts.line1, opts.line2, align)
    end,
    {range = true, nargs = "?"}
)

vim.api.nvim_create_user_command(
    'UnicaAlignLeft',
    function(opts)
        unica.align_left(opts.line1, opts.line2)
    end,
    {range = true, nargs = 0}
)

vim.api.nvim_create_user_command(
    'UnicaAlignCenter',
    function(opts)
        unica.align_center(opts.line1, opts.line2)
    end,
    {range = true, nargs = 0}
)

vim.api.nvim_create_user_command(
    'UnicaAlignRight',
    function(opts)
        unica.align_right(opts.line1, opts.line2)
    end,
    {range = true, nargs = 0}
)

vim.api.nvim_create_user_command(
    'UnicaDiv',
    function()
        unica.insert_div()
    end,
    {range = false, nargs = 0}
)


--vim.api.nvim_set_keymap('n', '<leader>.<Space>', ':UnicaDiv<CR>', {noremap = true, silent = true})
--vim.api.nvim_set_keymap('n', '<leader>.t', ':UnicaH1<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('', '<leader>1', ':UnicaH1<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('', '<leader>2', ':UnicaH2<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('', '<leader>3', ':UnicaH3<CR>', {noremap = true, silent = true})
--vim.api.nvim_set_keymap('i', '<C-=>', '<ESC>:r!date "+\\%Y-\\%m-\\%d"<CR>', {noremap = true, silent = true})
--vim.api.nvim_set_keymap('n', '<leader>.d', ':r!date "+\\%Y-\\%m-\\%d"<CR>', {noremap = true, silent = true})
