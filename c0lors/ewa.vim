set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "zzewa"
hi Normal guibg=#FF7F50 guifg=pink
hi Constant guifg=red
hi PreProc guifg=lightpink
hi Identifier guifg=darkred

" Number
" Statement
" Type
" Special
