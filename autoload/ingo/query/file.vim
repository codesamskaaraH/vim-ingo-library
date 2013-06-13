" ingo/query/file.vim: Functions to query files from the user.
"
" DEPENDENCIES:
"
" Copyright: (C) 2012-2013 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.007.003	31-May-2013	Move into ingo-library.
"	002	30-Nov-2012	ENH: Allow Funcref action for
"				ingouserinteraction#BrowseDirForAction().
"	001	27-Jan-2012	file creation from 00ingomenu.vim.

function! ingo#query#file#Browse( save, title, initdir, default, browsefilter )
    if exists('b:browsefilter')
	let l:save_browsefilter = b:browsefilter
    endif
    if empty(a:browsefilter)
	unlet! b:browsefilter
    else
	let b:browsefilter = a:browsefilter . "All Files (*.*)\t*.*\n"
    endif
    try
	return browse(a:save, a:title, a:initdir, a:default)
    finally
	if exists('l:save_browsefilter')
	    let b:browsefilter = l:save_browsefilter
	else
	    unlet b:browsefilter
	endif
    endtry
endfunction
function! ingo#query#file#BrowseDirForAction( action, title, dirspec, browsefilter )
    let l:filespec = ingo#query#file#Browse(0, a:title, expand(a:dirspec), '')
    if ! empty(l:filespec)
	if type(a:action) == type(function('tr'))
	    call call(a:action, [l:filespec])
	else
	    execute a:action escapings#fnameescape(l:filespec)
	endif
    else
	echomsg 'Canceled opening of file.'
    endif
endfunction
function! ingo#query#file#BrowseDirForOpenFile( title, dirspec, browsefilter )
    call ingo#query#file#BrowseDirForAction(((exists(':Drop') == 2) ? 'Drop' : 'drop'), a:title, a:dirspec)
endfunction


" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :