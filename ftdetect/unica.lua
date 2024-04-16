local vim = vim

vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
    pattern = "*.unica",
    callback = function()
        vim.bo.filetype = "unica"
    end
})
