set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "17102019"

hi Normal         guifg=yellow        guibg=#aaaaaa       cterm=bold
hi NonText        guifg=magenta
hi comment        guifg=#00aa00       cterm=bold
hi constant       guifg=cyan
hi identifier     guifg=darkred
hi statement      guifg=white
hi preproc        guifg=darkgreen
hi type           guifg=black
hi special        guifg=darkmagenta
hi Underlined     guifg=cyan
hi label          guifg=yellow       cterm=bold
hi operator       guifg=orange

hi ErrorMsg       guifg=orange        guibg=darkBlue
hi WarningMsg     guifg=cyan          guibg=darkBlue
hi ModeMsg        guifg=yellow       cterm=bold
hi MoreMsg        guifg=yellow       cterm=bold
hi Error          guifg=red           guibg=darkBlue

hi Todo           guifg=black         guibg=orange
hi Cursor         guifg=black         guibg=white
hi Search         guifg=black         guibg=orange
hi IncSearch      guifg=black         guibg=yellow
hi LineNr         guifg=cyan
hi title          guifg=white

hi StatusLineNC   guifg=black         guibg=blue
hi StatusLine     guifg=cyan          guibg=blue
hi VertSplit      guifg=blue          guibg=blue

hi Visual         guifg=black         guibg=darkCyan

hi DiffChange     guifg=black         guibg=darkGreen
hi DiffText       guifg=black         guibg=olivedrab
hi DiffAdd        guifg=black         guibg=slateblue
hi DiffDelete     guifg=black         guibg=coral    
                                                     
hi Folded         guifg=black         guibg=orange   
hi FoldColumn     guifg=black         guibg=gray30   
hi cIf0           guifg=gray

hi SpellBad       guifg=red
