let g:decimal_separator_col=90
let g:beancount_decimal_separator="."

inoremap . .<C-O>:AlignCommodity<CR>
nnoremap <buffer> <leader>= :AlignCommodity<CR>
vnoremap <buffer> <leader>= :AlignCommodity<CR>
