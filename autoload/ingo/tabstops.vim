" ingo/tabstops.vim: Functions to render and deal with the dynamic width of <Tab> characters.
"
" KNOWN PROBLEMS:
"  - The assumption index == char width doesn't work for unprintable ASCII and
"    any non-ASCII characters.
"
" Copyright: (C) 2008-2013 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.009.005	07-Jun-2013	Move into ingo-library.
"	004	05-Jun-2013	In EchoWithoutScrolling#RenderTabs(), make
"				a:tabstop and a:startColumn optional.
"	003	15-May-2009	Added utility function
"				EchoWithoutScrolling#TranslateLineBreaks() to
"				help clients who want to echo a single line, but
"				have text that potentially contains line breaks.
"	002	16-Aug-2008	Split off TruncateTo() from Truncate().
"	001	22-Jul-2008	file creation

function! ingo#tabstops#DisplayWidth( column, tabstop )
    return a:tabstop - (a:column - 1) % a:tabstop
endfunction
function! ingo#tabstops#Render( text, ... )
"*******************************************************************************
"* PURPOSE:
"   Replaces <Tab> characters in a:text with the correct amount of <Space>,
"   depending on the a:tabstop value. a:startColumn specifies at which start
"   column a:text will be printed.
"* ASSUMPTIONS / PRECONDITIONS:
"   none
"* EFFECTS / POSTCONDITIONS:
"   none
"* INPUTS:
"   a:text	    Text to be rendered.
"   a:tabstop	    tabstop value (The built-in :echo command always uses a
"		    fixed value of 8; it isn't affected by the 'tabstop'
"		    setting.) Defaults to the buffer's 'tabstop' value.
"   a:startColumn   Column at which the text is to be rendered (default 1).
"* RETURN VALUES:
"   a:text with replaced <Tab> characters.
"*******************************************************************************
    if a:text !~# "\t"
	return a:text
    endif

    let l:tabstop = (a:0 ? a:1 : &l:tabstop)
    let l:startColumn = (a:0 > 1 ? a:2 : 1)
    let l:pos = 0
    let l:text = a:text
    while l:pos < strlen(l:text)
	" FIXME: The assumption index == char width doesn't work for unprintable
	" ASCII and any non-ASCII characters.
	let l:pos = stridx( l:text, "\t", l:pos )
	if l:pos == -1
	    break
	endif
	let l:text = strpart(l:text, 0, l:pos) . repeat(' ', ingo#tabstops#DisplayWidth(l:pos + l:startColumn, l:tabstop)) . strpart(l:text, l:pos + 1)
    endwhile

    return l:text
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :