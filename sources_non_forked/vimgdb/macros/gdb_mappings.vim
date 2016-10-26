" Mappings example for use with gdb
" Maintainer:	<xdegaye at users dot sourceforge dot net>
" Last Change:	Mar 6 2006

if ! has("gdb")
    finish
endif

let s:gdb_k = 1
function! ToggleGDB()
    if getwinvar(0,'&statusline') != ""
        :set autochdir
        :cd %:p:h
        :only
        set statusline=
        :call <SID>Toggle()
    else
        set statusline+=%F%m%r%h%w\ [POS=%04l,%04v]\ [%p%%]\ [LEN=%L]\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]
        :set noautochdir
        :call <SID>Toggle()
    endif
endfunction

function! SToggleGDB()
    :MiniBufExplorer
    set statusline+=%F%m%r%h%w\ [POS=%04l,%04v]\ [%p%%]\ [LEN=%L]\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]
    :call <SID>Toggle()
endfunction

nmap <F7>  :call ToggleGDB()<cr>
nmap <S-F7>  :call <SID>Toggle()<cr>

" nmap <S-F7>  :call SToggleGDB()<cr>
" nmap <F7>  :call <SID>Toggle()<CR>

" Toggle between vim default and custom mappings
function! s:Toggle()
    if s:gdb_k
	let s:gdb_k = 0

	map <Space> :call gdb("")<CR>
	nmap <silent> Z :call gdb("\032")<CR>

	nmap <silent> B :call gdb("info breakpoints")<CR>
	nmap <silent> L :call gdb("info locals")<CR>
	nmap <silent> A :call gdb("info args")<CR>
	nmap <silent> S :call gdb("step")<CR>
	nmap <silent> I :call gdb("stepi")<CR>
	nmap <silent> N :call gdb("next")<CR>
	nmap <silent> X :call gdb("nexti")<CR>
	nmap <silent> F :call gdb("finish")<CR>
	nmap <silent> R :call gdb("run")<CR>
	nmap <silent> Q :call gdb("quit")<CR>
	nmap <silent> C :call gdb("continue")<CR>
	nmap <silent> W :call gdb("where")<CR>
	nmap <silent> U :call gdb("up")<CR>
	nmap <silent> D :call gdb("down")<CR>

	" set/clear bp at current line
	nmap <silent> B :call <SID>Breakpoint("break")<CR>
	nmap <silent> E :call <SID>Breakpoint("clear")<CR>

	" print value at cursor
	nmap <silent> P :call gdb("print " . expand("<cword>"))<CR>

	" display Visual selected expression
	vmap <silent> P y:call gdb("createvar " . "<C-R>"")<CR>

	" print value referenced by word at cursor
	nmap <silent> X :call gdb("print *" . expand("<cword>"))<CR>
    
    if expand("%:e")=="go"
    exec ":call gdb(\"pwd\")"
    silent exec ":!go build -gcflags \"-N -l\" -o " . expand("%:r") . " " .  expand("%")
    exec ":call gdb(\"file \" . expand(\"%:r\"))"
    endif
	
    echohl ErrorMsg
	echo "gdb keys mapped"
	echohl None

    " Restore vim defaults
    else
	let s:gdb_k = 1
	nunmap <Space>
	nunmap <C-Z>

	nunmap B
	nunmap L
	nunmap A
	nunmap S
	nunmap I
	nunmap <C-N>
	nunmap X
	nunmap F
	nunmap R
	nunmap Q
	nunmap C
	nunmap W
	nunmap <C-U>
	nunmap <C-D>

	nunmap <C-B>
	nunmap <C-E>
	nunmap <C-P>
	nunmap <C-X>
    
    if expand("%:e")=="go"
    silent exec "!rm -f " . expand("%:r")
    endif

	echohl ErrorMsg
	echo "gdb keys reset to default"
	echohl None
    endif
endfunction

" Run cmd on the current line in assembly or symbolic source code
" parameter cmd may be 'break' or 'clear'
function! s:Breakpoint(cmd)
    " An asm buffer (a 'nofile')
    if &buftype == "nofile"
	" line start with address 0xhhhh...
	let s = substitute(getline("."), "^\\s*\\(0x\\x\\+\\).*$", "*\\1", "")
	if s != "*"
	    call gdb(a:cmd . " " . s)
	endif
    " A source file
    else
	let s = "\"" . fnamemodify(expand("%"), ":p") . ":" . line(".") . "\""
	call gdb(a:cmd . " " . s)
    endif
endfunction

" map vimGdb keys
"call s:Toggle()


