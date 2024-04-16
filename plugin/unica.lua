local vim = vim

local unica = require('unica')

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

