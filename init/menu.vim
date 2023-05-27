"======================================================================
"
" menu.vim - 
"
" Created by skywind on 2017/07/06
" Last Modified: 2017/07/06 16:59:26
"
"======================================================================



"----------------------------------------------------------------------
" internal help
"----------------------------------------------------------------------

function! menu#FindInProject()
	let p = vimmake#get_root('%')
	echohl Type
	call inputsave()
	let t = input('find word ('. p.'): ', expand('<cword>'))
	call inputrestore()
	echohl None
	redraw | echo "" | redraw
	if strlen(t) > 0
		silent exec "GrepCode! ".fnameescape(t)
		call asclib#quickfix_title('- searching "'. t. '"')
	endif
endfunc

function! menu#DelimitSwitch(on)
	if a:on
		exec "DelimitMateOn"
	else
		exec "DelimitMateOff"
	endif
endfunc

function! menu#TogglePaste()
	if &paste
		set nopaste
	else
		set paste
	endif
endfunc

function! menu#CurrentWord(limit)
	let text = expand('<cword>')
	if len(text) < a:limit
		return text
	endif
	return text[:a:limit] . '..'
endfunc

function! menu#CurrentFile(limit)
	let text = expand('%:t')
	if len(text) < a:limit
		return text
	endif
	return text[:a:limit] . '..'
endfunc


function! menu#Escope(what)
	let p = expand('%')
	let t = expand('<cword>')
	let m = {}
	let m["s"] = "string symbol"
	let m['g'] = 'definition'
	let m['d'] = 'functions called by this'
	let m['c'] = 'functions calling this'
	let m['t'] = 'string'
	let m['e'] = 'egrep pattern'
	let m['f'] = 'file'
	let m['i'] = 'files #including this file'
	let m['a'] = 'places where this symbol is assigned'
	if a:what == 'f' || a:what == 'i'
		let t = expand('<cfile>')
	endif
	echohl Type
	call inputsave()
	let t = input('find '.m[a:what].' of ('. p.'): ', t)
	call inputrestore()
	echohl None
	redraw | echo "" | redraw
	if t == ''
		return 0
	endif
	exec 'GscopeFind '. a:what. ' ' . fnameescape(t)
endfunc

function! menu#DashHelp()
	let t = expand('<cword>')
	echohl Type
	call inputsave()
	let t = input('Search help of ('. &ft .'): ', t)
	call inputrestore()
	echohl None
	redraw | echo "" | redraw
	if t == ''
		return 0
	endif
	call asclib#utils#dash_ft(&ft, t)
endfunc


function! menu#ReadUrl()
	let t = expand('<cword>')
	echohl Type
	call inputsave()
	let t = input('Read URL from: ')
	call inputrestore()
	echohl None
	redraw | echo "" | redraw
	if t == ''
		return 0
	endif
	if executable('curl')
		exec '.-1r !curl -sL '.shellescape(t)
	elseif executable('wget')
		exec '.-1r !wget --no-check-certificate -qO- '.shellescape(t)
	else
		echo "require wget or curl"
	endif
endfunc

"----------------------------------------------------------------------
" initialize menu
"----------------------------------------------------------------------

call quickmenu#current(0)
call quickmenu#reset()

call quickmenu#append('# GNU Global Find', '')
call quickmenu#append('Definition', 'call menu#Escope("g")', 'find (g): this definition')
call quickmenu#append('Symbol', 'call menu#Escope("s")', 'find (s): this symbol')
call quickmenu#append('Called by', 'call menu#Escope("d")', 'find (d): functions called by this')
call quickmenu#append('Functions calling', 'call menu#Escope("c")', 'find (c): functions calling this')
call quickmenu#append('Text string', 'call menu#Escope("t")', 'find (t): this text string')
call quickmenu#append('Egrep pattern', 'call menu#Escope("e")', 'find (e): this egrep pattern')
call quickmenu#append('Find file', 'call menu#Escope("f")', 'find (f): this file')
call quickmenu#append('Files including', 'call menu#Escope("i")', 'find (i): files #including this file')
" call quickmenu#append('Reset database', 'GscopeKill')
" call quickmenu#append('Reindex', 'Es! build gtags %')

call quickmenu#append('# Tools', '')

call quickmenu#append('Trailing Space', 'call StripTrailingWhitespace()', 'Strip trailing whitespace')
call quickmenu#append('Signify refresh', 'SignifyRefresh', 'update signify')
call quickmenu#append('Calendar', 'Calendar', 'show Calendar')
call quickmenu#append('Paste mode line', 'PasteVimModeLine', 'paste vim mode line here')
call quickmenu#append('Dash Help', 'call menu#DashHelp()', 'open dash or zeal to view keywords in docsets')
call quickmenu#append('Read URL', 'call menu#ReadUrl()', 'load content from url')



"----------------------------------------------------------------------
" second menu
"----------------------------------------------------------------------
call quickmenu#current(1)
call quickmenu#reset()

call quickmenu#append('# Terminal', '')
call quickmenu#append('Open Terminal Below', 'belowright term ++rows=10', 'Open terminal below current window')
call quickmenu#append('Open Python Below', 'belowright term ++rows=10 python', 'Open python below current window')

call quickmenu#append('# Debug', '')


