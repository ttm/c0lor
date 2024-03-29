" main file of the c0lor plugin for Vim {{{3
" Author: Renato Fabbri
" Date: 2019/Sep/09 (when I rewrote this header)
" Copyright: Public domain
" Acknowledgments:
" vim_use email list (discussion forum)
" Dra. Cristina Ferreira de Oliveira (VICG/ICMC/USP),
" FAPESP (project 2017/05838-3)

" paths:
" ../README.md
" ../doc/c0lor.txt
" Load Once: {{{3
if exists("g:loaded_c0lorplugin") && (exists("g:c0lor_not_hacking") || exists("g:prv_not_hacking_all"))
 finish
endif
let g:loaded_c0lorplugin = "v0.03b"
let g:c0lor_dir = expand("<sfile>:p:h:h") . '/'
let g:c0lor = {}
let g:c0lor.paths = {}
let g:c0lor.paths.dir = g:c0lor_dir
let g:c0lor.paths.script = g:c0lor.paths.dir . 'plugin/c0lor.vim'

" au ColorScheme * hi SpellBad cterm=undercurl

" MAPPINGS: {{{1
" -- c0los leader is <space> and commands start with c, change here: {{{3
let g:mapleader = " "
nn <leader>c :cal CRandColorscheme()<CR>
nn <leader>ca :cal CRandColorscheme()<CR>
nn <leader>cc :cal CChange()<CR>
nn <leader>ch :exec 'vs ' . g:c0lor.paths.script<CR>
nn <leader>ci :cal CInit()<CR>
nn <leader>cl :cal CLoadColorscheme()<CR>
nn <leader>co :cal StandardColorsOrig()<CR>
nn <leader>cp :cal CCarryAction('p', 'c')<CR>
nn <leader>cr :cal CRandColorApply('f')<CR>
nn <leader>cs :cal CSaveColorscheme()<CR>
nn <leader>cw :ec CStack2b()<CR>
nn <leader>cy :cal CCarryAction('y', 'c')<CR>

nn <leader>cA :cal ApplyCCS(Choose(keys(g:ccs)))<CR>
nn <leader>cH :cal CInfo()<CR>
nn <leader>cI :exe 'hi ' . CStack2b()<CR>
nn <leader>cO :cal MakeColorsWindow(3)<CR>
nn <leader>cR :cal CRandColorApply('b')<CR>
nn <leader>cW :ec CStack()<CR>
nn <leader>cT :exe 'so ' . $VIMRUNTIME . '/colors/tools/check_colors.vim'<CR>

nn <leader>c<leader>c :cal CColor()<CR>
nn <leader>c<leader>o :highlight<CR>
nn <leader>c<leader>O :exe 'sp ' . g:c0lor.paths.dir . 'c0lors/'<CR>:exe 'sp ' . $VIMRUNTIME . '/colors/'<CR>

" find more useful mappings to show defined syntax groups and their colors TTM

" COMMANDS: {{{1
" -- MAIN: {{{3
com! -nargs=1 -complete=customlist,GetCSs Colorscheme exe 'so ' . g:c0lor.paths.dir . 'c0lors/' . <q-args> . '.vim'
" FUNCTIONS: {{{1
" -- MAIN {{{2
fu! CInit() " {{{3
  " Should initialize the whole coloring system.
  " If not only changing the color under cursor, should be used
  let s:ground = 'fg'
  let g:c0lor.ground = s:ground
  " disabled because rgb.txt was not found!!
  cal StandardColors()

  " creates the dictionary with colors on foreground and background
  " default, temporary and buffer in s:dcoulorsd, s:tcolorsd and s:colors
  let s:colors = {}
  cal GetColors(0)
  " ec '===> buffer color:' s:colors['buffer']
  cal GetColors(1)
  " ec ':::> temp color:' s:colors['temp']
  cal GetColors(2)
  " ec '---> default color:' s:colors['default']
  " initialize mappings
  " make named_colors0 and named_colors with the name of the colors:
  " 0: from documentation :h gui-colors
  " : from $VIMRUNTIME/rgb.txt
  " get all variables to the g:colors_all (new)
  " and g:colors_all_ (new) global variables
  cal GetAll()
  cal StandardColorSchemes()
  cal CommandColorSchemes()
  let g:c0lor.initialized = 1
  let g:c0lor.minit = l:
endf 
fu! CChange() " {{{3
  " should integrate bold italics and underline (strikeout?) TTM
  let sid = hlID('Normal')
  let sfg = synIDattr(synIDtrans(sid), "fg")
  let sbg = synIDattr(synIDtrans(sid), "bg")
  let name = CStack()[-1][-1]
  let g:asdasd = l:name
  if (len(name) > 0) && (name != 'Normal')
    let fg = map(synstack(line('.'), col('.')), 'synIDattr(synIDtrans(v:val), "fg")')[-1]
    if fg == ''
      let fg = sfg
    en
    let bg = map(synstack(line('.'), col('.')), 'synIDattr(synIDtrans(v:val), "bg")')[-1]
    if bg == ''
      let bg = sbg
    en
  el
    let name = 'Normal'
    let fg = sfg
    let bg = sbg
  en
  if has_key(s:named_colors, tolower(fg))
    let fg_named = fg
    let fg = s:named_colors[tolower(fg)]['hex']
  en
  if fg[0] != '#'
    let fg = "#" . fg
  en
  let rgb = [fg[1:2], fg[3:4], fg[5:6]]
  let rgb_ = map(rgb, 'str2nr(v:val, "16")')

  if has_key(s:named_colors, tolower(bg))
    let bg_named = bg
    let bg = s:named_colors[tolower(bg)]['hex']
  en
  if bg[0] != '#'
    let bg = "#" . bg
  en
  let rgbb = [bg[1:2], bg[3:4], bg[5:6]]
  let rgbb_ = map(rgbb, 'str2nr(v:val, "16")')

  let color = {'fg':[l:rgb, l:rgb_, l:fg], 'bg':[l:rgbb, l:rgbb_, l:bg]}

  let [fg_, bg_] = [fg, bg]
  " ec [fg_, bg_]
  let c = 'char_placeholder'
  let who = 'fg'
  " ec 'initial colors are fg, bs:' fg bg
  ec fg_ bg_ "| Command (h): "
  cal getchar(1)
  let emphn = 0
  let emph = ['bold', 'underline', 'bold,underline', 'NONE']
  let name_ = name
  wh c != 'n'
      let mex = 1  " chosen key Makes for an EXecution ?
      let c = nr2char(getchar())
      if c == 't'
        if who == 'fg'
          let who = 'bg'
          let mcmd = 'echo "on the background color"'
        el
          let who = 'fg'
          let mcmd = 'echo "on the foreground color"'
        en
      elsei c == 'N'
        if name == 'Normal'
          let name = name_
        el
          let name_ = name
          let name = 'Normal'
        en
        let mcmd = 'ec "toggled selected and Normal highlighting group"'
      elsei c == 'i'
        let [rgb_, rgbb_] = [rgbb_, rgb_]
        let mcmd = 'echo "colors inverted"'
        let fg_ = CHex(rgb_[0], rgb_[1], rgb_[2])
        exe 'hi' name 'guifg=' . fg_
        let bg_ = CHex(rgbb_[0], rgbb_[1], rgbb_[2])
        exe 'hi' name 'guibg=' . bg_
      elsei c == 'p' " power, preeminence, prominance
        let emphn  = ( emphn + 1 ) % len(emph)
        exe 'hi' name 'cterm=' . emph[emphn]
        let mcmd = ''
      elsei c == 'P' " power, preeminence, prominance
        let emphn  = ( emphn + 3 ) % len(emph)
        exe 'hi' name 'cterm=' . emph[emphn]
        let mcmd = ''
      elsei c == "h"
        ec "~ help (Change Color tool, c0lor plugin) ~\n\nrewq gfds bvcx' to sweep RGB color space (see :help color);\n'i p t' to Invert fg-bg, change emPhasis, toggle fg/bg;\n'N' to toggle selected and Normal groups;\n'h n' for Help quit/_next.\n(press any key)"
        cal getchar()
        let mcmd = ''
      elsei who == 'fg'
        let rgb_ = IncRGB(rgb_, c)
        let fg_ = CHex(rgb_,0,0)
        let mcmd = printf('hi %s guifg=%s', name, fg_)
      elsei who == 'bg'
        let rgbb_ = IncRGB(rgbb_, c)
        let bg_ = CHex(rgbb_,0,0)
        let mcmd = printf('hi %s guibg=%s', name, bg_)
      el
        let mex = 0
      en
      if mex
        exe mcmd
        redr
        ec fg_ bg_ "| Command (h): "
      en
  endw
  let g:me = l:
  let g:mi = a:
endf
fu! IncRGB(co, ch) " {{{3
  let co = a:co
  let c = a:ch

  if c == '1' " 0
    let [co[0], co[1]] = [co[1], co[0]]
  elsei c == '2'
    let [co[1], co[2]] = [co[2], co[1]]
  elsei c == '3'
    let [co[0], co[2]] = [co[2], co[0]]
  elsei c == '4'
    let co = [co[2], co[0], co[1]]
  elsei c == '5'
    let co = [co[1], co[2], co[0]]
  elsei c == 't'
    let co[0] = 255 - co[0]
    let co[1] = 255 - co[1]
    let co[2] = 255 - co[2]
  elsei c == 'r' " 1
    let co[0] = (16 + co[0]) % 256
  elsei c == 'g'
    let co[1] = (16 + co[1]) % 256
  elsei c == 'b'
    let co[2] = (16 + co[2]) % 256
  elsei c == 'R'
    let co[0] = (240 + co[0]) % 256
  elsei c == 'G'
    let co[1] = (240 + co[1]) % 256
  elsei c == 'B'
    let co[2] = (240 + co[2]) % 256
  elsei c == 'w' " 2
    let co[0] = (1 + co[0]) % 256
  elsei c == 'd'
    let co[1] = (1 + co[1]) % 256
  elsei c == 'c'
    let co[2] = (1 + co[2]) % 256
  elsei c == 'W'
    let co[0] = (255 + co[0]) % 256
  elsei c == 'D'
    let co[1] = (255 + co[1]) % 256
  elsei c == 'C'
    let co[2] = (255 + co[2]) % 256
  elsei c == 'e' " 3
    let co[1] = (16 + co[1]) % 256
    let co[2] = (16 + co[2]) % 256
  elsei c == 'f'
    let co[0] = (16 + co[0]) % 256
    let co[2] = (16 + co[2]) % 256
  elsei c == 'v'
    let co[0] = (16 + co[0]) % 256
    let co[1] = (16 + co[1]) % 256
  elsei c == 'E'
    let co[1] = (240 + co[1]) % 256
    let co[2] = (240 + co[2]) % 256
  elsei c == 'F'
    let co[0] = (240 + co[0]) % 256
    let co[2] = (240 + co[2]) % 256
  elsei c == 'V'
    let co[0] = (240 + co[0]) % 256
    let co[1] = (240 + co[1]) % 256
  elsei c == 'q' " 4
    let co[1] = (1 + co[1]) % 256
    let co[2] = (1 + co[2]) % 256
  elsei c == 's'
    let co[0] = (1 + co[0]) % 256
    let co[2] = (1 + co[2]) % 256
  elsei c == 'x'
    let co[0] = (1 + co[0]) % 256
    let co[1] = (1 + co[1]) % 256
  elsei c == 'Q'
    let co[1] = (255 + co[1]) % 256
    let co[2] = (255 + co[2]) % 256
  elsei c == 'S'
    let co[0] = (255 + co[0]) % 256
    let co[2] = (255 + co[2]) % 256
  elsei c == 'X'
    let co[0] = (255 + co[0]) % 256
    let co[1] = (255 + co[1]) % 256
  en
  retu co
endf
fu! CStack2b() " {{{3
  " a short version of CStack2()
  let name = synIDattr(synIDtrans(synID(line("."), col("."), 1)), "name")
  if len(name) == 0
    let name = 'Normal'
  en
  retu name
endf
fu! CStack2() " {{{3
  " just the last result of CStack()
  let name = CStack()[-1]
  if type(name) == 3
    let name = name[-1]
  en
  if len(name) == 0
    let name = 'Normal'
  en
  retu name
endf
fu! CStack() " {{{3
  " Show syntax highlighting groups for word under cursor
  " last item should be the group last considered, i.e. the most relevant.
  " If it is linked to some other group, you might find it with 
  " synIDtrans
  if !exists("*synstack")
    retu
  en
  let a = map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
  " intermediaries
  let b = map(synstack(line('.'), col('.')), 'synIDattr(synIDtrans(v:val), "name")')
  let c = []
  let i = 0
  wh i < len(a)
    if a[i] != b[i]
      cal add(c, [a[i], b[i]])
    el
      cal add(c, a[i])
    en
    let i += 1
  endw
  if len(c) == 0
    let c = [['Normal']]
  en
  retu c
endf
fu! ApplyCCS(ccsname) " {{{3
  " command color scheme in g:ccs, created by CommandColorSchemes
  let l:coms = g:ccs[a:ccsname]
  if type(a:ccsname) == 0
    let l:coms = ['colo blue', 'hi Normal  guifg=#0fffe0 guibg=#03800b']
  en
  for c in l:coms
    exe c
  endfo
  redraw
  ec 'command colorscheme loaded: '
  ec a:ccsname
  ec l:coms
  let g:c0lor.ccsname = a:ccsname
endf
let g:qwee = 'asdasd'
fu! CRandColorApply(...) " {{{3
  " Change current color randomly
  let g:asddsa =  a:
  if a:1 == 'b'
    exe 'hi ' . CStack2() . ' guibg=' . CRandColor()
  el
    exe 'hi ' . CStack2() . ' guifg=' . CRandColor()
  en

endf
fu! CRandColorscheme() " {{{3
  let g:mfiles = split(system("ls " . g:c0lor.paths.dir . 'c0lors'), '\n')
  cal filter(g:mfiles, 'v:val =~# ".*\.vim$"')
  let ind = str2nr(matchstr(reltimestr(reltime()), '\v\.@<=\d+')[1:]) % (len(g:mfiles) - 1)
  let cs = g:mfiles[ind]
  exe 'so ' . g:c0lor.paths.dir . 'c0lors/' . cs
  redr
  ec 'loaded c0lorscheme ' . substitute(cs, '\.vim$', '', '')
  let g:ccsname = cs
endf

fu! CSaveColorscheme(name) " {{{3
  " colorscheme gets saved to ../c0lors/ folder
  " load with :C[olorscheme]
  let g:maa = a:
  let g:mll = l:
endf

fu! CLoadColorscheme() " {{{3
endf

" -- MAIN experimental {{{2
fu! CColor() " {{{3
  ec 'Sketch. Nothing useful implemented in CColor() for an end-user'
  let l:c = 'char_placeholder'
  let g:action = v:none
  let g:sname = v:none
  wh c != 'q'
    ec 'type H for help, q to quit, else ciLs is implemented: '
    let l:c = nr2char(getchar())
    ec l:c
    ec index(['c', 'L', 's'], l:c)
    if l:c == 'H'
      ec 'c is change'
      ec 'i is init'
      ec 'L is luck'
      ec 's is (print) stack of syntax groups'
    elsei l:c == 'i'
      cal CInit()
    elsei index(['c', 'L', 's'], l:c) >= 0
      let g:action = l:c
    en
    if g:action != v:none
      while l:c != 'q'
        ec 'type H for help, q to quit, else cntslb is implemented: '
        let l:c = nr2char(getchar())
        if l:c == 'H'
          ec 'c is cursor'
          ec 'n is Normal'
          ec 't is tab'
          ec 's is spell'
          ec 'l is status line'
          ec 'b is number column'
        elsei l:c == 'c'
          let g:sname = CStack()[-1][-1]
        elsei l:c == 'n'
          let g:sname = 'Normal'
        elsei l:c == 't'
          wh l:c != 'q'
            ec 'type H for help, q to quit, else tsf is implemented: '
            let l:c = nr2char(getchar())
            if l:c == 'H'
              ec 't is TabLine'
              ec 's is TabLineSel'
              ec 'f is TabLineFill'
            elsei index(['t', 's', 'f'], l:c) >= 0
              let g:sname = 't'.l:c
            en
            if g:sname != v:none
              let l:c = 'q'
            en
          endw
        elsei l:c == 's'
          let g:sname = 'SpellBad'
        elsei l:c == 'l'
          wh l:c != 'q'
            ec 'type H for help, q to quit, else sntT is implemented: '
            let l:c = nr2char(getchar())
            if l:c == 'H'
              ec 's is StatusLine'
              ec 'n is StatusLineNC'
              ec 't is StatusLineTerm'
              ec 'T is StatusLineTermNC'
            elsei index(['s', 'n', 't', 'T'], l:c) >= 0
              let g:sname = 'l'.l:c
            en
            if g:sname != v:none
              let l:c = 'q'
            en
          endw
        elsei l:c == 'b'  " number column
          wh l:c != 'q'
            ec 'type H for help, q to quit, else nN is implemented: '
            let l:c = nr2char(getchar())
            if l:c == 'H'
              ec 'n is LineNr'
              ec 'N is CursorLineNr'
            elsei index(['n', 'N'], l:c) >= 0
              let g:sname = 'b'.l:c
            en
            if g:sname != v:none
              let l:c = 'q'
            en
          endw
        en
        if g:sname != v:none
          let l:c = 'q'
        en
      endw
    en
  endw
  cal CCarryAction(g:action, g:sname)
endf
let g:color = {}
let g:color.actions = {'y': 'yank', 'a': 'apply', 'c': 'change', 'L': 'luck',
      \'s': 'stack', 'l': 'load', 'k': 'keep', 'i': 'init', 'h': 'hack', 'H': 'help'}
let g:color.snames = {'n': 'Normal', 'tt': 'TabLine', 'ts': 'TabLineSel',
      \'tf': 'TabLineFill', 'sb': 'Spellbad', 'sr': 'SpellRare',
      \'nn': 'LineNr', 'nN': 'CursorLineNr', 'ls': 'StatusLine',
      \'ln': 'StatusLineNC', 'lt': 'StatusLineTerm', 'lT': 'StatusLineTermNC'}
" :h synIDattr
let g:c0lor.chars = [ "name", "font", "sp", "fg#", "bg#", "sp#", "bold", "italic", "reverse", "inverse", "standout", "underline", "undercurl", "strike"]
fu! CCarryAction(action, sname)
  if ( a:sname == 'c' ) || ( a:sname == 'p')
    " yank cursor fg and bg
    let iid = synIDtrans(synID(line("."), col("."), 1))
  en
  if a:action == 'y'
    let g:c0lor.clip = {}
    for i in g:c0lor.chars
      let g:c0lor.clip[i] = synIDattr(l:iid, i)
    endfo
    let g:c0lor.clip.cbold = synIDattr(l:iid, 'bold', 'cterm')
    let g:c0lor.clip.cunderline = synIDattr(l:iid, 'underline', 'cterm')
  elsei a:action == 'p'
    let hi = 'hi ' . CStack2b()
    let c = g:c0lor.clip
    let emph = ['bold', 'underline', 'bold,underline', 'NONE']
    let cterm = l:emph[3]
    if ( l:c.cbold == 1 ) && ( l:c.cunderline == 1 )
      let l:cterm = l:emph[2]
    elsei l:c.cunderline == 1
      let l:cterm = l:emph[1]
    elsei l:c.cbold == 1
      let l:cterm = l:emph[0]
    en
    let hi = l:hi . ' cterm=' . l:cterm
    if len(l:c["fg#"]) > 0
      let hi = l:hi . ' guifg=' . l:c['fg#']
    en
    if len(l:c["bg#"]) > 0
      let hi = l:hi . ' guibg=' . l:c['bg#']
    en
  en
  let a = 4
endf
" -- UTILS {{{2
" -- utils info Generators {{{2
" -- utils color Generators {{{2
fu! CRandColor(...) " {{{3
  " Return random RGB in Hex notation: #RRGGBB
  py3 import random as r
  py3 rgb = [r.randint(0,255) for i in range(3)]
  retu CHex(py3eval("rgb"))
endf
" -- utils colorscheme Generators {{{2
fu! CHex(...) " {{{3
  " Return RGB in Hex notation: #RRGGBB
  " expects a list [r, g, b] with values in [0, 255]
  " works both Hex(2,3,4) as Hex([2,3,4])
  let g:asd = a:
  if type(a:1) == 3
     retu printf("#%02x%02x%02x", a:1[0], a:1[1], a:1[2])
  el
     retu printf("#%02x%02x%02x", a:1, a:2, a:3)
  en
endf
fu! CGrayScale(from,to,ncolors) " {{{3
  " nsteps = ncolors - 1
  let walk = a:to - a:from
  let colors = map(range(a:ncolors), "'#' . repeat(printf('%02x', a:from + v:val*walk/(a:ncolors - 1)), 3)")
  retu colors
endf
fu! MakeLRGBD() " {{{3
  let mean_colors = [[255, 128, 0],
                   \ [0, 255, 128],
                   \ [128, 0, 255],
                   \ [0, 128, 255],
                   \ [255, 0, 128],
                   \ [128, 255, 0]]
  let l = []
  let bwg = [[0,0,0],[255,255,255],[128,128,128]]
  for c in mean_colors
    let cs_ = MkRotationFlipCS(c) + bwg
    cal add(l, cs_)
  endfor
  " added instantiation of dict because it was not found (23/03/2020):
  let g:colors_all['cs'] = {}
  let g:colors_all['cs']['lmean_doc'] = 'has bw and colors in between. should have precedence given by the bg'
  let g:colors_all['cs']['lmean'] = l
endfu
fu! MkRotationFlipCS(color) " {{{3
  let c = a:color
  let f = [255 - c[0], 255 - c[1], 255 - c[2]]
  let cs =   [c,
           \ [c[2], c[0], c[1]],
           \ [c[1], c[2], c[0]],
           \  f,
           \ [f[2], f[0], f[1]],
           \ [f[1], f[2], f[0]]
           \ ]
  return cs
endfu

" utils experimental {{{2
fu! HiFile() " {{{3
  " Does a bad job... But the idea is good, enhance it! TTM
  " run to hightlight the buffer with the highlight output
  " e.g. after :Split sy or :Split hi
    let i = 1
    wh i <= line("$")
        if strlen(getline(i)) > 0 && len(split(getline(i))) > 2
            let w = split(getline(i))[0]
            exe "syn match " . w . " /\\(" . w . "\\s\\+\\)\\@<=xxx/"
        en
        let i += 1
    endw
endf
" utils API {{{2
fu! CIsInitialized() " {{{3
 if exists("color.initialized")
    retu 1
  el
    retu 0
  en
endf
fu! CheckColor(c) " {{{3
  let c = copy(a:c)
  for i in range(len(c))
    if c[i] > 255
      let c[i] = 255
    elsei c[i] < 0
      let c[i] = 0
    en
  endfo
  retu c
endf
fu! GetColors(which) " {{{3
  " Populates the s:colors dictionary with default (which=2), temp (1) and buffer (0) colors
  let sid = hlID('Normal')
  let sfg = synIDattr(synIDtrans(sid), "fg")
  let sbg = synIDattr(synIDtrans(sid), "bg")
  let name = map(synstack(line('.'), col('.')), 'synIDattr(synIDtrans(v:val), "name")')
  if len(name) > 0
    let name = name[-1]
  el
    let name = 'Normal'
  en
  let fg = map(synstack(line('.'), col('.')), 'synIDattr(synIDtrans(v:val), "fg")')
  if fg == []
    let name = synIDattr(synIDtrans(sid), "name")
    let fg = sfg
    " let fg = "#FFFFFF"
  el
    let fg = fg[-1]
  en
  if has_key(s:named_colors, tolower(fg))
    let fg_named = fg
    let fg = s:named_colors[tolower(fg)]['hex']
    " ec fg_named
  en
  if fg[0] != '#'
    let fg = "#" . fg
  en
  " ec 'fg:' fg
  let rgb = [fg[1:2], fg[3:4], fg[5:6]]
  let rgb_ = map(rgb, 'str2nr(v:val, "16")')

  let bg = map(synstack(line('.'), col('.')), 'synIDattr(synIDtrans(v:val), "bg")')
  if bg == []
    let namebg = synIDattr(synIDtrans(sid), "name")
    let bg = sbg
    " let bg = "#FFFFFF"
  el
    let bg = bg[-1]
  en
  if has_key(s:named_colors, tolower(bg))
    let bg_named = bg
    let bg = s:named_colors[tolower(bg)]['hex']
    " ec bg_named
  en
  if bg[0] != '#'
    let bg = "#" . bg
  en
  " ec 'bg:' bg
  let rgbb = [bg[1:2], bg[3:4], bg[5:6]]
  let rgbb_ = map(rgbb, 'str2nr(v:val, "16")')
  " simple dictionary
  let d = {'fg' : {'r': rgb_[0], 'g': rgb_[1], 'b': rgb_[2]}, 'bg' : {'r': rgbb_[0], 'g': rgbb_[1], 'b': rgbb_[2]}, 'rgb': {'fg': fg, 'bg': bg}}
  if a:which == 2  " default color, to be used when the color has no specification of fg or bg
    let s:colors['default'] = d
  elsei a:which == 1  " temporary
    let s:colors['temp'] = d
  el  " buffer, should be updated whenever a color is manipulated
    let s:colors['buffer'] = l:
  en
  let g:scolors = s:colors
endf
fu! GetAll() " {{{3
  let g:colors_all = s:
  let g:colors_all_ = []
  for vkey in keys(s:)
    cal add(g:colors_all_ , vkey)
  endfo
endf
fu! StandardColorsOrig() " {{{3
  "  Shows the named colors available as fg and bg against default fg and bg    
  " Restore normal highlighting by typing ":call clearmatches()"

  " - Read file $VIMRUNTIME/rgb.txt
  " - Delete lines where color name is not a single word (duplicates).
  " - Delete "grey" lines (duplicate "gray"; there are a few more "gray").
  " Add matches so each color name is highlighted in its color.
  cal clearmatches()
  new
  setl buftype=nofile bufhidden=hide noswapfile
  0r $VIMRUNTIME/rgb.txt
  let find_color = '^\s*\(\d\+\s*\)\{3}\zs\w*$'
  sil execute 'v/'.find_color.'/d'
  " silent g/grey/d
  let namedcolors=[]
  1
  wh search(find_color, 'W') > 0
      let w = expand('<cword>')
      cal add(namedcolors, w)
  endw

  for w in namedcolors
      exe 'hi col_'.w.' guifg=NONE guibg='.w
      exe 'hi col_'.w.'_fg guifg='.w.' guibg=NONE'
      exe '%s/\<'.w.'\>/'.printf("%-36s%s", w, w).'/g'

      cal matchadd('col_'.w, '\<'.w.'\>', -1)
      " determine second string by that with large # of spaces before it
      cal matchadd('col_'.w.'_fg', ' \{10,}\<'.w.'\>', -1)
  endfo
  1
  noh
endf
fu! MakeColorsWindow(colors) " {{{3
  " colors=0,1,2,3 for 
  " only the most basic colors against default, against default and B&W
  " All named colors against default, against default and B&W
  if a:colors < 2
    let nc = s:named_colors0
  el
    let nc = keys(s:named_colors_)
  en

  cal clearmatches()
  new
  setl buftype=nofile bufhidden=hide noswapfile
  0read $VIMRUNTIME/rgb.txt
  " silent g/grey/d
  1
  ec 'ignore errors'
  for w_ in l:nc
     if w_ == ''
       con
     en
      " default bg against color in fg,
      " default fg against color in bg
      " black fg against color in bg
      " white fg against color in bg
      " black bg against color in fg,
      " white bg against color in fg
      let w = substitute(w_, " ", "__", "g")
      let w__ = copy(w_)
      if w_ =~ ' '
        let w_ = "'" . w_ . "'"
      en
      " echo 'hi col_' . w . '_fg guifg=' . w_ . ' guibg=NONE'
      " echo 'hi col_' . w . '_bg guifg=NONE guibg=' . w_
      " echo w w_ w__
      exe 'hi col_' . w . '_fg guifg=' . w_ . ' guibg=NONE'
      exe 'hi col_' . w . '_bg guifg=NONE guibg=' . w_
      if a:colors % 2 == 1
        " echo 'aaaaaaaaaaaaa ' w
        exe 'hi col_' . w . '_bfg guifg=black guibg=' . w_
        exe 'hi col_' . w . '_wfg guifg=white guibg=' . w_
        exe 'hi col_' . w . '_bbg guifg=' . w_ . ' guibg=black'
        exe 'hi col_' . w . '_wbg guifg=' . w_ . ' guibg=white'
        exe '%s/\s\s' . w__ . '$/' . printf("  %s Foreground, %s Background, %s BFG, %s WFG, %s BBG, %s WBG", w__, w__, w__, w__, w__, w__) . '/g'
        cal matchadd('col_' . w . '_bfg', '\<' . w__ . ' BFG\>', -1)
        cal matchadd('col_' . w . '_wfg', '\<' . w__ . ' WFG\>', -1)
        cal matchadd('col_' . w . '_bbg', '\<' . w__ . ' BBG\>', -1)
        cal matchadd('col_' . w . '_wbg', '\<' . w__ . ' WBG\>', -1)
      el
        exe '%s/\s\s' . tolower(w__) . '$/'.printf("%s Foreground, %s Background", w, w).'/g'
      en
      cal matchadd('col_' . w . '_fg',  '\<' . w__ . ' Foreground\>', -1)
      cal matchadd('col_' . w . '_bg',  '\<' . w__ . ' Background\>', -1)

      " determine second string by that with large # of spaces before it
  endfo
  1
  noh
  let g:banana = l:
endf
fu! ColorsNotFound() " {{{3
  let cnotf = []
  let cc = keys(s:named_colors)
  for c in s:named_colors0
    if index(cc, tolower(c)) >= 0
      " color found, pass
    el
      cal add(cnotf, c)
    en
  endfo
  let s:cnotf = cnotf
  let s:named_colors['lightred']  = '#ff8b8b'
  let s:named_colors_['LightRed'] = '#ff8b8b'
  let s:named_colors['lightmagenta']  = '#ff8bff'
  let s:named_colors_['LightMagenta'] = '#ff8bff'
  let s:named_colors['darkyellow']  = '#8b8b00'
  let s:named_colors_['DarkYellow'] = '#8b8b00'
endf
fu! StandardColors() " {{{3
  " This function gets all the names of the all the colors on the system
  " See MakeColorsWindow(3) to display all named colors
  " as foreground and background against
  " black, white and default colors in a window

  " these names are from from :h gui-colors in Jan/05/2018
  let s:named_colors0 = ['Red', 'LightRed', 'DarkRed', 'Green', 'LightGreen', 'DarkGreen', 'SeaGreen', 'Blue', 'LightBlue', 'DarkBlue', 'SlateBlue', 'Cyan', 'LightCyan', 'DarkCyan', 'Magenta', 'LightMagenta', 'DarkMagenta', 'Yellow', 'LightYellow', 'Brown', 'DarkYellow', 'Gray', 'LightGray', 'DarkGray', 'Black', 'White', 'Orange', 'Purple', 'Violet']
  cal clearmatches()
  new
  setl buftype=nofile bufhidden=hide noswapfile
  let fn = g:c0lor_dir . 'plugin/data/rgb.txt'
  exe 'sil 0read ' .  fn
  " - Delete lines where color name is not a single word (duplicates).
  " - Delete "grey" lines (duplicate "gray"; there are a few more "gray").
  "   TTM ??
  let tline = 1
  let mline = line('$')
  let named_colors = {}
  let named_colors_ = {}
  wh tline <=  mline
    exe tline
    norm yy
    if @" == ''
      let tline += 1
      con
    en
    let [r, g, b, name] = [str2nr(@"[0:2]), str2nr(@"[4:6]), str2nr(@"[8:10]), @"[13:-2]]
    let mhex = CHex(r,g,b)
    " if name =~ 'gray'
    "   echo r g b mhex name
    " endif
    " echo r g b mhex name
    let tempdict = {'r'   :   r,
                  \ 'g'   :   g,
                  \ 'b'   :   b,
                  \ 'hex' :   mhex}
    let named_colors[tolower(name)] = tempdict
    let named_colors_[name] = tempdict
    let tline += 1
  endw
  let g:chicrute=55
  unl named_colors['']  " find out why I am getting this 000 '' color...
  let s:named_colors = named_colors
  let s:named_colors_ = named_colors_
  let g:named_colors = named_colors
  let g:named_colors_ = named_colors_
  cal ColorsNotFound()
  cal SpecialColors()
  q
endf
fu! SpecialColors() " {{{3
  " blood reds, blues, etcsss
  " from https://en.wikipedia.org/wiki/Blood_red
  let blood = ['#660000', '#aa0000', '#af111c', '#830303', '#7e3517']
  let most10 = ['#3f5d7d', '#279b61', '#008ab8', '#993333', '#a3e496', '#95cae4', '#cc3333', '#ffcc33', '#ffff7a', '#cc6699']
  let g:color_named = l:
endf
" -- AUX {{{2
fu! Choose(alist) " {{{
  if type(a:alist) == 4
    let ind = str2nr(matchstr(reltimestr(reltime()), '\v\.@<=\d+')[1:]) % (len(keys(a:alist)) - 1)
    let ind = keys(a:alist)[ind]
  el
    let ind = str2nr(matchstr(reltimestr(reltime()), '\v\.@<=\d+')[1:]) % (len(a:alist) - 1)
  en
  let c = a:alist[l:ind]
  retu c
endf " }}}
fu! ParseOrixas() " {{{
  let f = readfile(expand('%:p:h') . '/data/orixas1.txt')
  let os = []
  let infos = {}
  for o in f[1:]
    if o =~ '.*:'
      let name = tolower(substitute(o, ':.*', '', ''))
      let info = substitute(o, '.*:', '', '')
      let info_ = substitute(info, '\s\{2,\}', ' ', 'g')
      cal add(os, name)
      if !has_key(infos, name)
        let infos[name] = []
      en
      cal add(infos[name], info_)
    en
  endfo
  let g:f = f
  let os_ = filter(copy(os), 'index(os, v:val, v:key+1)==-1')
  let g:os = sort(os_)
  let g:infos = infos
  retu os
endf " }}}
fu! AfricanCS() " {{{
  " https://www.pinterest.com/pin/456974693425216689/
  let synon = {'osanha': 'ossain', 'xapanã': 'xapana',
        \ 'oxaguiã': 'oxaguia', 'omulu': 'umulu',
        \ 'yansa': 'iansa'}
  " let allnames = ParseOrixas()
  let allnames = ['cosme', 'exu', 'ibeji', 'obaluaie', 'ogum', 'oxala', 'oxum', 'oxossi', 'pomba gira', 'preto velho', 'xango', 'xapana', 'yansa', 'yemanja', 'yori', 'yorima']
  let morenames = ['umulu', 'nana', 'olorum', 'ossain', 'oxaguia', 'oxumare', 'oba', 'ewa', 'logun ede', 'iroko']
  let palletes = {}
  let palletes.exu = ['redblood', 'black', 'yellow']
  let palletes.exu_ = MkPallte12(palletes.exu)
  let cs = {}
  let cs.exu = MkCS(palletes.exu_)
  " call ApplyCS(cs.exu
endfu " }}}
fu! MkPalette12(pallete) " {{{
  " return a 12 colors pallete from what comes
  " assuming pallete is a sequence of lists with three
  " values in [0,255] for rgb.
  let nder = 12.0/len(a:pallete)
  let colors = []
  for color in a:pallete
    let sum = 0
    for c in color
      let sum += c
    endfo
    let sum = sum/3
    let c_ = [color]
    let nder_ = 1
    if sum > 128 " closer to white, move to black
      wh nder_ < nder
        let color2 = GetShade(color2, 0.5)
        cal add(c_, color2)
        let nder_ += 1
      endw
    el " closer to black, move to white
      wh nder_ < nder
        let color2 = GetTint(color, 0.5)
        cal add(c_, color2)
        let nder_ += 1
      endw
    en
    cal extend(colors, c_)
  endfo
  " while len(colors) < 12
  "   let acolor = MaxDiff(colors)
  "   call add(colors, acolor)
  " endwhile
  return colors
endfu " }}}
" -- AUX complete {{{2
fu! GetCSs(ArgLead, CmdLine, CursorPos) " {{{
  let g:mcmd = "ls " . g:c0lor.paths.dir . 'c0lors'
  let g:mfiles = split(system("ls " . g:c0lor.paths.dir . 'c0lors'), '\n')
  cal filter(g:mfiles, 'v:val =~# "^' . a:ArgLead . '.*\.vim$"')
  " cal filter(g:mfiles, 'v:val =~# "^' . a:ArgLead . '"')
  cal map(g:mfiles, 'substitute(v:val,".vim$","", "g")')
  " ec a:ArgLead . a:CmdLine . a:CursorPos
  retu g:mfiles
endfu " }}}
fu! MaxDiff(colors) " {{{
  " Return a color that is maximally different from all the colors given
endfu " }}}
fu! MkCS(pallete) " {{{
  " Return a CS relating each basic group to a color
endfu " }}}
fu! CommandColorSchemes() " {{{
  let cs = {}
  let cs.green1 = ['colo blue', 'hi Normal  guifg=#0fffe0 guibg=#03800b']
  let cs.green2 = ['colo torte', 'highlight Normal guifg=white  guibg=darkGreen', 'hi Folded guifg=darkgreen']
  
  let cs.yellow1 = ['colo morning', 'hi Normal guibg=#ffff00', 'hi Constant cterm=bold guifg=#a0a010 guibg=NONE', 'hi Search guibg=lightblue']

  let cs.red1 = ['colo koehler', 'hi Normal guibg=#800000']
  let cs.red1c = ['colo koehler', 'hi Normal guibg=#800000', 'hi Folded guifg=cyan guibg=#bb0000', 'hi Visual guibg=darkyellow cterm=bold']
  let cs.red1c_ = ['colo koehler', 'hi Normal guifg=lightgreen guibg=#660000', 'hi Folded guifg=cyan guibg=#bb0000', 'hi Visual guibg=yellow guibg=darkyellow cterm=bold']
  let cs.red1b = ['colo koehler', 'hi Normal guibg=#900000', 'hi Visual guibg=darkred']
  let cs.red1b_ = ['colo koehler', 'hi Normal guibg=#830303', 'hi Visual guibg=darkred']
  let cs.red2 = ['colo koehler', 'hi Normal guibg=#ff0000', 'hi Visual guibg=darkred']
  let cs.red3 = ['colo koehler', 'hi Normal guibg=#ff8833']
  let cs.red4 = ['colo koehler', 'highlight Normal guifg=black guibg=red', 'highlight Comment guifg=black guibg=red gui=bold']
  let cs.red4 = ['colo koehler', 'highlight Normal guifg=black guibg=red', 'highlight Comment guifg=black guibg=red gui=bold', 'hi Constant guifg=#004444 cterm=NONE', 'hi Constant cterm=bold guifg=#900000', 'hi Comment cterm=bold guifg=#606000', 'hi Type guifg=#600060']
  let cs.red5 = ['colo torte', 'hi Folded guibg=#702020 guifg=#000000 cterm=bold', 'hi Comment ctermfg=12 guifg=#d0808f', 'hi Constant guifg=#ff0000', 'hi Identifier cterm=bold guifg=#e00f4f', 'hi Normal guifg=#ac3c3c guibg=Black', 'hi vimIsCommand cterm=bold guifg=#9c3c00', 'hi vimFunction guifg=#bcbc0c', 'hi vimOperParen cterm=bold guifg=#fc2c2c']
  let cs.redblackl = ['colo koehler', 'hi Normal guibg=#800000']
  let cs.passivepink1 = ['colo koehler', 'hi Normal guibg=#ff91af', 'hi Comment guifg=#888888', 'hi Identifier guifg=#bb7777', 'hi Constant guifg=#ffcccc', 'hi PreProc guifg=#888088', 'hi Special guifg=#8f3580', 'hi Type guifg=#508f60']
  
  let cs.exu1 = cs.red4
  " exuX is for now starting with blood red:
  " https://en.wikipedia.org/wiki/Blood_red
  " g:color_named.blood
  " and then adding many other stuff.

  " Holy spirit: (many colors, each with a specific simbolism, look for them)

  let cs.blue1 = ['colo blue', 'hi Normal guibg=#0000ff']
  let cs.blue2 = ['colo blue', 'hi Normal guibg=#444488']

  let cs.blue2 = ['colo blue', 'hi Normal guibg=#444488']
  
  let cs._notes = {}
  let cs._notes.red1_4 = '~mythologically related to exu through yellow and red'
  let g:ccs = cs
endfu " }}}
fu! StandardColorSchemes() " {{{
  let s:scs = {'desc': 'dictionary for all color schemes'}
  let s:scs['Monochromatic'] = {'desc': 'one color shades'}
  let s:scs['Analogous'] = {'desc': 'one color shades'}
  let s:scs['LGray'] = {'desc': 'linear grayscale colorschemes'}
  " print(["%x" % ((i*255)//(N-1),) for i in range(N)])
  let s:scs['LGray']['2bit'] = ['#000000', '#ffffff', '#555555', '#aaaaaa']
  let vals4b = ['0', '24', '48', '6d', '91', 'b6', 'da', 'ff']
  let s:scs['LGray']['4bit'] = map(vals4b, '"#" . v:val . v:val  . v:val')
  let s:scs['LRGB'] = {'desc': 'linear maximum distance RGB colorschemes'}
  let s:scs['ERGB'] = {'desc': 'exponential maximum distance RGB colorschemes'}
  let s:scs['ERGB'] = {'desc2': 'Weber-Fechner laws'}
  let s:scs['PRGB'] = {'desc': 'power-law maximum distance RGB colorschemes'}
  let s:scs['PRGB'] = {'desc2': "Steven's laws"}
  let s:scs['PRGB'] = {'desc2': "Steven's laws"}
  " Linear distance maximization
  cal MakeLRGBD()
  " LF, EF, EF Frequency-related colorschemes (translate with wlrgb)
  " using harmonic series
  " how is rgb related to final frequency of the light?
  " RRGB randomic coloschemes
  " EERGB PPRGB Double Web-Fech and Stev laws
  " Arbitrary series or rgb or final frequency
endf " }}}
fu! ApplyCS2(cs) " {{{
  " Most basic: 1 bg + 8fg + 3fg = 12 colors
  " Basic grouping of them?
  " Basic partitioning of them?
  " As in :h 
  let c = a:cs
  exe "hi Normal     guibg=" . Hex(c[0]) . " guifg=" . Hex(c[1])
  exe "hi Comment    guifg=" . Hex(c[2])
  exe "hi Constant   guifg=" . Hex(c[3])
  exe "hi Identifier guifg=" . Hex(c[4])
  exe "hi Statement  guifg=" . Hex(c[5])
  exe "hi PreProc    guifg=" . Hex(c[6])
  exe "hi Type       guifg=" . Hex(c[7])
  exe "hi Special    guifg=" . Hex(c[8])

  hi Underlined gui=underline
  hi Error gui=reverse
  hi Todo guifg=black guibg=white
endf " }}}

fu! Warp(where, distortion) " {{{
  " Make cs more white or black or gray or tend
  " to a specific color
endfu " }}}
fu! GetShade(color, factor) " {{{
  " new intensity = current intensity * (1 – shade factor)
  " factor = 1 => black
  let f = 1 - a:factor
  let c = map(a:color, "v:val*f")
  let c_ = CheckColor(c) " to enable the use of negative factor
  return c_
endfu " }}}
fu! GetTint(color, factor) " {{{
  " new intensity = current intensity + (255 – current intensity) * tint factor
  " factor = 1 => white
  let c = map(a:color, "v:val + (255 - v:val) * a:factor")
  let c_ = CheckColor(c) " to enable the use of negative factor
  return c_
endfu " }}}
fu! GetTone(color, factor) " {{{
  " Algorithm made as whished... TODO: find out the canonic routine
  " factor = 1 => gray
  let value = (a:color[0] + a:color[1] + a:color[2])/3
  let c = map(a:color, "v:val + (value - v:val) * a:factor")
  let c_ = CheckColor(c) " to enable the use of negative factor
  return c_
endfu " }}}
" Anti-Shade Tint and Tone: away from black, white or gray
" Anti-shade is a tint? an anti-tint is a shade?
" An anti-tone is a what?
" -- EXP {{{2
fu! IncrementColor(c, g) " {{{3
  " c='r', g='f' : color and foreground
  GetColors(0)  " creates the dictionary in next line
  let s:colors[l:g][l:c] = (colors[l:g][l:c] + 16 ) % 256
  RefreshColors()  " should update the colors of the cursor position
endf
fu! SwitchGround() " {{{3
  " To keep a record in our color server
  if s:ground == 'fg'
    s:ground = 'bg'
  el
    s:ground = 'fg'
  en
endf
fu! RefreshColors() " {{{3
  " to do what???
  " apply c to current colorscheme
  let c = s:colors
  let g = s:ground
  let g:fg_ = Hex(c[g],0,0)
endf
fu! InitializeDynamics() " {{{3
  " to keep track of the tickers___:
  let s:timers = []
  let s:counters = range(10)
  let s:ncounters = 0
  let s:patterns = {}
  let s:mpatterns = {'wave': 'call WavePattern()', 'std': 'call StandardPattern()', 'wobble': 'call Wobble()', 'silence': 'call BypassPattern'}
  cal timer_stopall()
  let s:tickerids = []
endf
fu! TickColor(timer) " {{{3
  let s:anum = 0
  let s:tick = 1
  " default:
  " change some of the colors (of text and bg)
  " at the window in some patterns
  while s:tick == 1
    echo "banana =" s:anum
    let s:anum += 1
  endwhile
endfunc
fu! StartTick() " {{{3
  s:tickerids.push( timer_start(400, TickColor(), {'repeat': 3}) )
endfunction
""""""""""""""""""" {{{3 Minimal Patterner
fu! MyHandler(timer)
  echo 'Handler called' s:i
  let s:i += 1
endfunc
func! MyTimer(repeat, period)
  let s:i = 0
  let timer = timer_start(a:period, 'MyHandler',
        \ {'repeat': a:repeat})
  call add(s:timers, timer)
endfu
"""""""""""" Don't Know {{{3
" make a rhythm on numbers by updating a variable with list
" of numbers or patterns
"
" one calls the other to repeat n times.
" displacement/offset might be performed with repeat=1, period=silence)
" pattern(offset=2000, repeat=4, period=500)
fu! MyHandler2(offset, timer, makeoffset)
  echo 'Handler called' s:counters
  if a:makeoffset == 1
    call MyHandler2(a:offset, 1, )
  let s:counters[i] += 1
endfunc

func! MyTimer2(offset, repeat, period)
  let timer = timer_start(a:period, 'MyHandler2',
        \ {'repeat': a:repeat, 'offset': a:offset, 'makeOffset': 1})
  call add(s:timers, timer)
endfu
" let s:pattern = s:MyTimer2
""""""""""""""""""" {{{3 Z-Patterner
fu! StandardPattern()
  let s:counters[s:ncounters] += s:ncounters
  let s:ncounters = (s:ncounters + 1) % len(s:counters)
endf
fu! BypassPattern()
  " for silence
  let foo = 'bar'
endf
fu! Pattern1(value)
  let s:counters[a:value] += a:value
endf
fu! WavePattern()
  call Voice(100, 20, 'std')
  call Voice(1, 1000, 'silence')
  call Voice(100, 20, 'std')
endf
fu! Wobble(nlines)
  " Make curent line and next ones wobble
  let i = 0
  let mstart = system("echo $RANDOM")
  wh i < nlines
    exec line('.')+i . 'center' 30+(i*1+mstart)%80
    let i += 1
  endw
endf
fu! PWobble()
  " let timer = timer_start(500, 'Wobble')
  " let timer = timer_start(500, 'Wobble',
  "      			\ {'repeat': a:repeat})
  cal Voice(3, 200, 'Wobble(5)')
endf
fu! OverallPattern()
  cal Voice(-1, 2000, 'PWobble')
endf
fu! MyHandler3(timerID)
  " a:timer is the number of repeats.
  " the duration is set by MyTimer3(timer=a:timer, duration=XXX)
  let foo = copy(s:counters)
  if !has_key(s:patterns, a:timerID)
    " call StandardPattern()
    cal BypassPattern()
  el
    exe s:patterns[a:timerID]
  en
  " let rand = system("echo $RANDOM")%len(s:counters)
  " echo [rand, len(s:counters)]
  " let s:counters[rand] += rand
  let bar = [s:ncounters, len(s:counters)]
  " echo bar 'Handler called' foo
  "     \ '\nHandler finished' s:counters ' ' a:timer
  ec bar 'Handler called' foo
      \ '\nHandler finished' s:counters ' ' a:timerID
endf

func! MyTimer3(repeats, duration, value)
  " timer is number of subsequent timer onsets
  " duration is period in ms
  " value is simpy not being used
  let timerID_ = timer_start(a:duration, 'MyHandler3',
        \ {'repeat': a:repeats})
  echo timerID_
  let s:patterns[timerID_] = "call Pattern1(". a:value .")"
  call add(s:timers, timerID_)
endfu
" let s:pattern = s:MyTimer3
"
"
" }}}
""""""""""""""""""" {{{3 Z-Patterner2
fu! SporkVoice(timerID)
  " a:timer is the number of repeats.
  " the duration is set by MyTimer3(timer=a:timer, duration=XXX)
  let foo = copy(s:counters)
  if !has_key(s:patterns, a:timerID)
    " call StandardPattern()
    cal BypassPattern()
  el
    exe s:patterns[a:timerID]
  en
  " let rand = system("echo $RANDOM")%len(s:counters)
  " echo [rand, len(s:counters)]
  " let s:counters[rand] += rand
  let bar = [s:ncounters, len(s:counters)]
  " echo bar 'Handler called' foo
  "     \ '\nHandler finished' s:counters ' ' a:timer
  ec bar 'Handler called' foo
      \ '\nHandler finished' s:counters ' ' a:timerID
endf

fu! Voice(repeats, duration, patternID) " {{{
  " timer is number of subsequent timer onsets
  " duration is period in ms
  " value is simpy not being used
  let timerID_ = timer_start(a:duration, 'SporkVoice',
        \ {'repeat': a:repeats})
  echo timerID_
  if type(a:patternID) == 0
    let s:patterns[timerID_] = "call Pattern1(". a:value .")"
  elsei has_key(s:mpatterns, a:patternID)
    let s:patterns[timerID_] = s:mpatterns[a:patternID]
  else
    let s:patterns[timerID_] = 'call' a:patternID
  en
  call add(s:timers, timerID_)
endfu " }}}
" let s:pattern = s:MyTimer3
" -- VARIABLES {{{2
" original, claro, escuro, dessaturado, saturado, tomate
let g:color.colors = {'terracotta' : ['#e2725b'. '#edab9e'. '#ca4023'. '#d17d6b'. '#f2664a'. '#ff6347']}
" -- NOTE {{{2
" -------- notes {{{3
"  TODO:
"  - use CIELab and CIELuv
" pallete: choice of colors
" scheme: association of colors with syntax groups
" :sy creates groups and associates them to textual elements
" :hi associates them to display parameters: colors + (bold + italics + underline + reverse)
" underline + strikeout)

" tgc was only for gVim, you don't get the gui=undercurl there.
"
" Script minimal documentation {{{
" most advanced run: 
" basic run: \z to create color variables based on the cursor position
" and \c to change color under cursor.
" MakeColorsWindow dont match colors in the window made by running colors.vim
"
" All commands are in <C-\> namespace and are valid for all modes.
" Start the system with <C-\>I (reloads all files from all plugins)
" or <C-\>i (reloads current file) 
" Look at the global variables g:colors_all and g:colors_all_ after
" starting.
" Check mappings in realcolor/mappings.vim to grasp overall functionality
" }}}

" -Structure: Auto loaded by vim's plugin system {{{
" ### so realcolors/cs.vim
"
" ### so realcolors/tools.vim
" InitializeColors() - calls functions markied with ***
" GetColors(default)  ***
" StandardColors() ***
" StandardColorSchemes() ***
" GetAll() ***
" ChgColor() - Masterpiece. TODO: enhance key mappings
" SynStack()                
" MkBlack()                
" MakeColorsWindow(colors)  - Masterpiece. Shows named colors agains b&w and Normal fg/bg. TODO: make it work for all 0 1 2 3
" StandardColorsOrig() - Masterpiece. Shows the named colors available as fg
" and bg against default fg abd bg
"
" Undeveloped, maybe remove:
" IncrementColor(c, g) -  changes s:colors and uses RefreshColors() TODO
" SwitchGround() - global variable ground
" RefreshColors() TODO
"
" ### so realcolors/mappings.vim
" <C-\> standard routines
"
" ### so realcolors/dynamic.vim
" Wobble(nlines)           
" TickColor(timer)         
" StartTick()              
"
" ### ascii art ??
" }}}

" References {{{
" /usr/local/share/vim/vim80/doc/syntax.txt
" * For the preferred and minor groups
" }}}


" TODO {{{
" * Account for coloring that does not appear with <c-\> s as is: search
" highligh when typing and afterwards, spellbad, other spell classes?
" Lines number bar. statusbar and tabs bar colors. Colors of the command-line
" * Relation of all basic syn groups and their colors
" * tradutor de verbose de syntax highlighting para colorscheme
" * Integrate Python & vim to convert freq to RGB
" make exercises with each of the vim's python-related functions
" * Write to list or report bug to Vim git: spellbad is lost in colorscheme blue (and other standard colorschemes) when set termguicolors in terminal because no cterm=undercurl or gui(fg/bg).
"   - Show my solution let mysyntaxfile = '~/.vim/syntax/mysyntaxfileTTM.vim'
" * A function that analyses the current file and outputs
" a window with each of the colors used and their hi group and
" specifications.
" It should also allow then that the user toggles the original file
" between normal text view and another with each char substituted with
" the corresponding FG colors and their numbers and another
" with the BG colors and their numbers.
"
" * Commands to add new syntax group, match words and patterns,
" associate with other colors.
" Grab words and patterns under cursor, e.g. to add or remove
" words to a group, or use the same color settings
"
" * Think about making a mode to ease the syntax highlighting
" modifications

" * hlsearch and spellbad should one be bold and underline to avoid
" collision with programming language colors.
" * hlsearch and spellbad should use two of the cues: color, bold, underline.
" (italics?)

" * syntime report to get the syntax highlighting scheme being used
" }}}

" Further notes: {{{
" Color many of the substitute patterns.
" Color the @" and @. registers.

" Make colorscheme with X11 colors:
" :echo filter(copy(colors_all['named1']), 'v:val[0:2]=="X11"')
"
" syntax change undo
" increment/decrement rgb
" in the char under cursor

" start a function that receives
" the modifications throug the
" keys RGB and before it (rewq, gfds, bvcx).
" for backgound, press j and use the same keys.
" uppercase is used for more resolution.

" q quits.

" Another functionality:
" Makes a color pallete from the special colors
" or other palletes that are special or
" that are derived from a color or set of colors.

" Another functionality:
" swap two colors grabed from cursor.
" rotate all the colors maintaining the background
" or not.

" find make tests with synID trans false and true
" We have the syngroups givem by synstack
" and the effectively used one, given
" by synIDtrans

" their name might be found with
" synIDattr

" If set hi group from synstack,
" the link used beforehand is lost.
" e.g.  :hi vimHiGuiFgBg guifg=#000000
" Makes you loose the link to gruvboxYellow
" }}}

" Function to the the SID as a last resort {{{
" function s:MYSID()
"   return matchstr(expand('<sfile>'),  '<SNR>\zs\d\+\ze_SID$')
" endfun
" let s:mysid = s:SID()
" }}}
" csnotes {{{3
" COLOR PRINCIPLES OF MAN STATES OF MATTER
" 
" Violet Chaya, or Etheric Double Ether
" 
" Indigo Higher Manas, or Spiritual Intelligence, Critical State called Air
" 
" Blue Auric Envelope, Steam or Vapor
" 
" Green Lower Manas, or Animal Soul, Critical State
" 
" Yellow Buddhi, or Spiritual Soul, Water
" 
" Orange,  Prana, or Life Principle, Critical State
" 
" Red Kama Rupa, or Seat of Animal Life, Ice
" 
" ==
" the patternwork of color in the Bible, namely that red refers to
" flesh; yellow--trial; blue--the Word or healing power of Almighty
" God; green--immortality; purple--royalty or priesthood
" 
" ==
" " Secret Doctrine of the Rosicrucians 
" PART XII
" THE AURA AND AURIC COLORS
" http://www.sacred-texts.com/sro/sdr/sdr13.htm
" 
" ==
" https://www.psychologytoday.com/blog/people-places-and-things/201504/the-surprising-effect-color-your-mind-and-mood
" 
" ==
" masculine: bold colors, shades
" feminine: soft colors, tints
" 
" ==
" http://www.mythsdreamssymbols.com/ddcolors.html
" 
" https://www.scienceofpeople.com/10-ways-color-affects-your-mood/
" 
" Maker miler pink (passive pink)
" 
" color psychology:
" http://www.arttherapyblog.com/online/color-psychology-psychologica-effects-of-colors/#.Wl87LnWnHQo
" 
" make color schemes for each day of the week,
" for liturgical 
" white, the symbol of light, typifies innocence and purity, joy and
" glory; red, the language of fire and blood, indicates burning charity
" and the martyrs' generous sacrifice; green, the hue of plants and
" trees, bespeaks the hope of life eternal; violet, the gloomy cast of
" the mortified, denotes affliction and melancholy; while black, the
" universal emblem of mourning, signifies the sorrow of death and the
" sombreness of the tomb.
" http://www.newadvent.org/cathen/04134a.htm
" 
" http://www.crivoice.org/symbols/colorsmeaning.html
" -- FINAL {{{2
" -- final commands and file settings {{{3
if !CIsInitialized()
  cal CInit()
en
" vim:foldlevel=2:
