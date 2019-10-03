" set colorscheme
syntax on
set background=dark
colorscheme peachpuff

set autoindent
au BufNewFile,BufRead *.yaml,*.yml so ~/.vim/yaml.vim

" add yaml stuffs
au! BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

set pastetoggle=<F2>

" fix keypad keys in tmux/urxvt
:inoremap <C-K> =                                                                             
:inoremap <Esc>Oo /                                                                           
:inoremap <Esc>Oj *                                                                           
:inoremap <Esc>Om -                                                                           
:inoremap <Esc>Ok +                                                                           
:inoremap <Esc>OM <Enter>                                                                     
:inoremap <Esc>On .
