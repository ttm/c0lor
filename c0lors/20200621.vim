set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "21062020"

let @r = ':w:C 21062020'
let @f = ':aguifg=#'

hi normal           guifg=#af6666       guibg=#ffcccc       cterm=bold
hi nontext          guifg=magenta
hi comment          guifg=#cc9999       cterm=bold
hi constant         guifg=#ff6666
hi identifier       guifg=#bb5599
hi statement        guifg=#a5a080
hi preproc          guifg=#997744
hi type             guifg=#990000
hi special          guifg=#9999ee
hi underlined       guifg=#ff00ff
hi label            guifg=brown        cterm=bold
hi operator         guifg=darkgreen
" for ^M ^[ etc (appears as contant hi group when scrutinized):
hi specialkey       guifg=#ff00ff

hi directory         guifg=#a600bb      cterm=bold

hi errormsg         guifg=orange        guibg=darkBlue
hi warningmsg       guifg=cyan          guibg=darkBlue
hi modemsg          guifg=yellow        cterm=bold
hi moremsg          guifg=yellow        cterm=bold
hi error            guifg=red           guibg=darkBlue

hi todo             guifg=black         guibg=orange
hi cursor           guifg=black         guibg=white
hi search           guifg=black         guibg=orange
hi incsearch        guifg=black         guibg=yellow
hi linenr           guifg=#ffaaaa
hi cursorlinenr     guifg=lightred
hi cursorline        guibg=#ffbbbb
hi title            guifg=white

hi moremsg          guifg=darkgreen     guibg=white
hi modemsg          guifg=black

" inverted fb-bg by Vim's defaults:
hi statusline     guifg=#888888       guibg=#ddaaaa
hi statuslinenc       guifg=#aa7777       guibg=#663100
hi vertsplit        guifg=#331100       guibg=#773300

hi statuslineterm   guifg=#ffcc99       guibg=#ffffbb
hi statuslinetermnc guifg=#7799bb       guibg=#cccc99

hi tabline          guifg=#999999       guibg=#333333
hi tablinesel       guifg=#333333       guibg=#999999
" inverted fb-bg by Vim's defaults:
hi tablinefill      guifg=grey          guibg=blue

hi visual           guifg=white         guibg=darkyellow

hi diffchange       guifg=lightred      guibg=darkGreen
hi difftext         guifg=blue          guibg=olivedrab
hi diffadd          guifg=black         guibg=slateblue
hi diffdelete       guifg=black         guibg=coral    
                                                       
hi folded           guifg=black         guibg=orange   
hi foldcolumn       guifg=black         guibg=gray30   
hi cif0             guifg=gray

hi spellbad         guifg=red
