" ingo/ftplugin/converter/external.vim: Build a file converter via an external command.
"
" DEPENDENCIES:
"   - ingo/buffer/scratch.vim autoload script
"   - ingo/compat.vim autoload script
"   - ingo/err.vim autoload script
"   - ingo/format.vim autoload script
"   - ingo/ftplugin/converter/external.vim autoload script
"
" Copyright: (C) 2017 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>

function! s:GetName( externalCommandDefinition )
    return (has_key(a:externalCommandDefinition, 'name') ? a:externalCommandDefinition.name : fnamemodify(a:externalCommandDefinition.command, ':t'))
endfunction
function! ingo#ftplugin#converter#external#GetNames( externalCommandDefinitions )
    return map(copy(a:externalCommandDefinitions), "s:GetName(v:val)")
endfunction

function! s:GetExternalCommandDefinition( externalCommandDefinitionsVariable, arguments )
    execute 'let l:externalCommandDefinitions =' a:externalCommandDefinitionsVariable
    if empty(l:externalCommandDefinitions)
	throw printf('external: No converters are configured in %s.', a:externalCommandDefinitionsVariable)
    elseif empty(a:arguments)
	if len(l:externalCommandDefinitions) > 1
	    throw printf('external: Multiple converters are available; choose one: ', join(ingo#ftplugin#converter#external#GetNames(l:externalCommandDefinitions), ', '))
	endif

	let l:command = l:externalCommandDefinitions[0]
    else
	let l:command = get(filter(copy(l:externalCommandDefinitions), 'a:arguments == s:GetName(v:val)'), 0, '')
	if empty(l:command)
	    throw printf('external: No such converter: %s', a:arguments)
	endif
    endif

    return l:command
endfunction

function! s:ObtainText( commandDefinition, filespec )
    let l:command = call('ingo#format#Format', [a:commandDefinition.commandline] + map([a:commandDefinition.command, expand(a:filespec)], 'ingo#compat#shellescape(v:val)'))
    let l:result = ingo#compat#systemlist(l:command)
    if v:shell_error != 0
	throw 'external: Conversion failed: shell returned ' . v:shell_error . (empty(l:result) ? '' : ': ' . join(l:result))
    endif

    return l:result
endfunction

function! ingo#ftplugin#converter#external#ToText( externalCommandDefinitionsVariable, arguments, filespec )
    try
	let l:commandDefinition = s:GetExternalCommandDefinition(a:externalCommandDefinitionsVariable, a:arguments)
	let l:text = s:ObtainText(l:commandDefinition, a:filespec)

	silent %delete _
	setlocal endofline nobinary fileencoding<
	call setline(1, l:text)
	call setpos("'[", [0, 1, 1, 0])
	call setpos("']", [0, line('$'), 1, 0])

	let &l:filetype = get(l:commandDefinition, 'filetype', 'text')

	setlocal nomodifiable nomodified
	return 1
    catch /^external:/
	call ingo#err#SetCustomException('external')
	return 0
    endtry
endfunction
function! ingo#ftplugin#converter#external#ExtractText( externalCommandDefinitionsVariable, mods, arguments, filespec )
    try
	let l:commandDefinition = s:GetExternalCommandDefinition(a:externalCommandDefinitionsVariable, a:arguments)
	let l:text = s:ObtainText(l:commandDefinition, a:filespec)

	let l:status = ingo#buffer#scratch#Create('', expand('%:r') . '.' . get(l:commandDefinition, 'extension', 'txt'), 1, l:text, (empty(a:mods) ? 'enew' : a:mods . ' new'))
	if l:status == 0
	    call ingo#err#Set('Failed to open scratch buffer.')
	    return 0
	endif
	return 1
    catch /^external:/
	call ingo#err#SetCustomException('external')
	return 0
    endtry
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
