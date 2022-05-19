set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "09062020"

let @r = ':w:C 09062020'
let @f = ':aguifg=#'

hi normal           guifg=#0fa3bf       guibg=#ffffaa       cterm=bold
hi nontext          guifg=magenta
hi comment          guifg=#f4aaaa       cterm=bold
hi constant         guifg=#bbbbbb
hi identifier       guifg=lightred
hi statement        guifg=#a580ff
hi preproc          guifg=darkgreen
hi type             guifg=darkyellow
hi special          guifg=#9999ee
hi underlined       guifg=#ff00ff
hi label            guifg=brown        cterm=bold
hi operator         guifg=darkgreen

hi directory         guifg=#a600bb      cterm=bold
hi cursorline        guibg=#ffffdd

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
hi title            guifg=white

hi moremsg          guifg=darkgreen     guibg=white
hi modemsg          guifg=black

" inverted fb-bg by Vim's defaults:
hi statuslinenc     guifg=white         guibg=blue
hi statusline       guifg=cyan          guibg=blue
hi vertsplit        guifg=blue          guibg=blue

hi statuslineterm   guifg=white         guibg=darkgreen
hi statuslinetermnc guifg=white         guibg=darkblue

hi tabline          guifg=blue          guibg=white
hi tablinesel       guifg=cyan          guibg=blue
" inverted fb-bg by Vim's defaults:
hi tablinefill      guifg=grey          guibg=blue

hi visual           guifg=white         guibg=darkyellow

hi diffchange       guifg=lightred         guibg=darkGreen
hi difftext         guifg=blue         guibg=olivedrab
hi diffadd          guifg=black         guibg=slateblue
hi diffdelete       guifg=black         guibg=coral    
                                                       
hi folded           guifg=black         guibg=orange   
hi foldcolumn       guifg=black         guibg=gray30   
hi cif0             guifg=gray

hi spellbad         guifg=red
