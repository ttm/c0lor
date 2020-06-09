set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "06062020"

let @r = ':w:C 06062020'
let @f = ':aguifg=#'

hi Normal         guifg=#ffa3bf        guibg=#00808c       cterm=bold
hi NonText        guifg=magenta
hi comment        guifg=#f4aaaa       cterm=bold
hi constant       guifg=#ffffff
hi identifier     guifg=lightred
hi statement      guifg=#a580ff
hi preproc        guifg=#c04c6d
hi type           guifg=yellow
hi special        guifg=#9999ee
hi Underlined     guifg=#ff00ff
hi label          guifg=yellow       cterm=bold
hi operator       guifg=green

hi Directory       guifg=#a600bb cterm=bold
hi CursorLine      guibg=#440000

hi ErrorMsg       guifg=orange        guibg=darkBlue
hi WarningMsg     guifg=cyan          guibg=darkBlue
hi ModeMsg        guifg=yellow       cterm=bold
hi MoreMsg        guifg=yellow       cterm=bold
hi Error          guifg=red           guibg=darkBlue

hi Todo           guifg=black         guibg=orange
hi Cursor         guifg=black         guibg=white
hi Search         guifg=black         guibg=orange
hi IncSearch      guifg=black         guibg=yellow
hi LineNr         guifg=lightcyan
hi CursorLineNr   guifg=lightred
hi title          guifg=white

hi StatusLineNC   guifg=white         guibg=blue
hi StatusLine     guifg=cyan          guibg=blue
hi VertSplit      guifg=blue          guibg=blue
hi StatusLineTermNC guibg=brown

hi StatusLineTerm guibg=darkyellow
hi StatusLineTermNC guibg=lightblue

hi Visual         guifg=black         guibg=darkCyan

hi DiffChange     guifg=black         guibg=darkGreen
hi DiffText       guifg=black         guibg=olivedrab
hi DiffAdd        guifg=black         guibg=slateblue
hi DiffDelete     guifg=black         guibg=coral    
                                                     
hi Folded         guifg=black         guibg=orange   
hi FoldColumn     guifg=black         guibg=gray30   
hi cIf0           guifg=gray

hi SpellBad       guifg=red
