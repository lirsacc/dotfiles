" Map Ctrl + p to open fuzzy find (FZF)
set rtp+=/usr/local/opt/fzf
nnoremap <c-p> :FZF<cr>

let $FZF_DEFAULT_COMMAND = 'ag --literal --files-with-matches --nocolor --hidden -g ""'
