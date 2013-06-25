" CommandCompleteDirForAction.vim: Define custom command to complete files from
" a specified directory.
"
" DESCRIPTION:
"   In GVIM, one can define a menu item which uses browse() in combination with
"   an Ex command to open a file browser dialog in a particular directory, lets
"   the user select a file, and then uses that file for a predefined Ex command.
"   This script provides a function to define similar custom commands for use
"   without a GUI file selector, relying instead on custom command completion.
"
" EXAMPLE:
"   Define a command :BrowseTemp that edits a text file from the system TEMP
"   directory. >
"	call CommandCompleteDirForAction#setup(
"	\   '',
"	\   'BrowseTemp',
"	\   'edit',
"	\   (exists('$TEMP') ? $TEMP : '/tmp'),
"	\   '*.txt',
"	\   '',
"	\   ''
"	\)
"   You can then use the new command with file completion:
"	:BrowseTemp f<Tab> -> :BrowseTemp foo.txt
"
" INSTALLATION:
"   Put the script into your user or system Vim autoload directory (e.g.
"   ~/.vim/autoload).

" DEPENDENCIES:
"   - escapings.vim autoload script
"   - ingo/cmdargs/file.vim autoload script
"   - ingo/msg.vim autoload script

" Copyright: (C) 2009-2013 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"	017	10-Jun-2013	Better handling for errors from :echoerr.
"	016	01-Jun-2013	Move ingofileargs.vim into ingo-library.
"	015	31-May-2013	Minor refactoring.
"	014	23-Mar-2013	ENH: Allow determining the a:dirspec during
"				runtime by taking a Funcref instead of string.
"				Use error handling functions from ingo/msg.vim.
"	013	28-Jan-2013	Handle ++enc= and +cmd file options and
"				commands. This requires an extension of the
"				a:parameters.action,
"				a:parameters.FilenameProcessingFunction and
"				a:parameters.FilespecProcessingFunction values
"				to take and return an additional
"				fileOptionsAndCommands argument.
"	012	28-Dec-2012	Apply special logic to support lnum 0 with
"				a:parameters.commandAttributes = "-range=-1"
"				described at :help ingo-command-lnum.
"	011	13-Sep-2012	ENH: Added
"				a:parameters.FilespecProcessingFunction to allow
"				processing of both dirspec and filename.
"				This is now used by the :Vim command to expand
"				arbitrary <SID> numbers to the corresponding
"				full path.
"				FIX: Actually abort the processing when
"				a:parameters.FilenameProcessingFunction returns
"				an empty filename (as was documented).
"	010	14-May-2012	ENH: Allow special "%" value or Funcref for
"				a:parameters.defaultFilename.
"				FIX: Don't append <bang> to a:Action of type
"				command; this should be contained in a:Action =
"				"MyCommand<bang>".
"				Handle custom exceptions thrown from Funcrefs.
"	009	27-Jan-2012	ENH: Get <bang> information into s:Command() and
"				pass this on to a:Action, and make this
"				accessible to a:Action Funcrefs via a context
"				object g:CommandCompleteDirForAction_Context.
"	008	21-Sep-2011	ENH: action and postAction now also support
"				Funcrefs instead of Ex commands.
"				Generated command now actually demands argument
"				unless a:parameters.defaultFilename is given.
"				a:parameters.defaultFilename can be empty,
"				resulting in a command with optional argument
"				and no filename passed to a:parameters.action;
"				the action (probably a Funcref) is supposed to
"				handle this. Beforehand, the command would be
"				aborted if the filename was empty.
"	007	22-Jan-2011	Collapsed s:CommandWithOptionalArgument(),
"				s:CommandWithPostAction() and the direct
"				definition for a non-optional, non-postAction
"				command into s:Command(), which already handles
"				all cases anyway, getting rid of the
"				conditional.
"				ENH: Added
"				a:parameters.FilenameProcessingFunction to allow
"				processing of the completed or typed filespec.
"				This is used by the :Vim command to correct the
"				.vimrc to ../.vimrc when the name is fully
"				typed, not completed.
"	006	10-Dec-2010	ENH: Added a:parameters.overrideCompleteFunction
"				and returning the generated completion function
"				name in order to allow hooking into the
"				completion. This is used by the :Vim command to
"				also offer .vimrc and .gvimrc completion
"				candidates.
"	005	27-Aug-2010	FIX: Filtering out subdirectories from the file
"				completion candidates.
"				ENH: Added a:parameters.isIncludeSubdirs flag to
"				allow inclusion of subdirectories. Made this
"				work even when a browsefilter is set.
"	004	06-Jul-2010	Simplified CommandCompleteDirForAction#setup()
"				interface via parameter hash that allows to omit
"				defaults and makes it more easy to extend.
"				Implemented a:parameters.postAction, e.g. to
"				:setfiletype after opening the file.
"	003	27-Oct-2009	BUG: With optional argument, the a:filename
"				passed to s:CommandWithOptionalArgument() must
"				not be escaped, only all other filespec
"				fragments.
"	002	26-Oct-2009	Added to arguments: a:commandAttributes e.g. to
"				make buffer-local commands, a:defaultFilename to
"				make the filename argument optional.
"	001	26-Oct-2009	file creation
let s:save_cpo = &cpo
set cpo&vim

function! s:RemoveDirspec( filespec, dirspecs )
    for l:dirspec in a:dirspecs
	if strpart(a:filespec, 0, strlen(l:dirspec)) ==# l:dirspec
	    return strpart(a:filespec, strlen(l:dirspec))
	endif
    endfor
    return a:filespec
endfunction
function! s:CompleteFiles( dirspec, browsefilter, wildignore, isIncludeSubdirs, argLead )
    try
	let l:dirspec = (type(a:dirspec) == 2 ? call(a:dirspec, []) : a:dirspec)
    catch /^Vim\%((\a\+)\)\=:E/
	throw ingo#msg#MsgFromVimException()   " Don't swallow Vimscript errors.
    catch /^Vim\%((\a\+)\)\=:/
	call ingo#msg#VimExceptionMsg()        " Errors from :echoerr.
    catch
	call ingo#msg#ErrorMsg(v:exception)
	sleep 1 " Otherwise, the error isn't visible from inside the command-line completion function.
	return []
    endtry

    let l:browsefilter = (empty(a:browsefilter) ? '*' : a:browsefilter)
    let l:filespecWildcard = l:dirspec . a:argLead . l:browsefilter
    let l:save_wildignore = &wildignore
    if type(a:wildignore) == type('')
	let &wildignore = a:wildignore
    endif
    try
	let l:filespecs = split(glob(l:filespecWildcard), "\n")

	if a:isIncludeSubdirs
	    " If the l:dirspec itself contains wildcards, there may be multiple
	    " matches.
	    let l:pathSeparator = (exists('+shellslash') && ! &shellslash ? '\' : '/')
	    let l:resolvedDirspecs = split(glob(l:dirspec), "\n")

	    " If there is a browsefilter, we need to add all directories
	    " separately, as most of them probably have been filtered away by
	    " the (file-based) a:browsefilter.
	    if ! empty(a:browsefilter)
		let l:dirspecWildcard = l:dirspec . a:argLead . '*' . l:pathSeparator
		call extend(l:filespecs, split(glob(l:dirspecWildcard), "\n"))
		call sort(l:filespecs) " Weave the directories into the files.
	    else
		" glob() doesn't add a trailing path separator on directories
		" unless the glob pattern has one at the end. Append the path
		" separator here to be consistent with the alternative block
		" above, the built-in completion, and because it makes sense to
		" show the path separator, because then autocompletion of the
		" directory contents can quickly be continued.
		call map(l:filespecs, 'isdirectory(v:val) ? v:val . l:pathSeparator : v:val')
	    endif

	    return map(
	    \   l:filespecs,
	    \   'escapings#fnameescape(s:RemoveDirspec(v:val, l:resolvedDirspecs))'
	    \)
	else
	    return map(
	    \   filter(
	    \	    l:filespecs,
	    \	    '! isdirectory(v:val)'
	    \   ),
	    \   'escapings#fnameescape(fnamemodify(v:val, ":t"))'
	    \)
	endif
    finally
	let &wildignore = l:save_wildignore
    endtry
endfunction

function! s:Command( isBang, Action, PostAction, DefaultFilename, FilenameProcessingFunction, FilespecProcessingFunction, dirspec, filename )
    try
"****Dechomsg '****' a:isBang string(a:Action) string(a:PostAction) string(a:DefaultFilename) string(a:FilenameProcessingFunction) string(a:FilespecProcessingFunction) string(a:dirspec) string(a:filename)
	let l:dirspec = (type(a:dirspec) == 2 ? call(a:dirspec, []) : a:dirspec)

	" Detach any file options or commands for assembling the filespec.
	let [l:fileOptionsAndCommands, l:filename] = ingo#cmdargs#file#FilterEscapedFileOptionsAndCommands(a:filename)
"****D echomsg '****' string(l:filename) string(l:fileOptionsAndCommands)
	" Set up a context object so that Funcrefs can have access to the
	" information whether <bang> was given.
	let g:CommandCompleteDirForAction_Context = { 'bang': a:isBang }

	" l:filename comes from the custom command, and must be taken as is (the
	" custom completion will have already escaped the completion).
	" All other filespec fragments still need escaping.

	if empty(l:filename)
	    if type(a:DefaultFilename) == 2
		let l:unescapedFilename = call(a:DefaultFilename, [l:dirspec])
	    elseif a:DefaultFilename ==# '%'
		let l:unescapedFilename = expand('%:t')
	    else
		let l:unescapedFilename = a:DefaultFilename
	    endif
	    let l:filename = escapings#fnameescape(l:unescapedFilename)
	endif

	if ! empty(a:FilenameProcessingFunction)
	    let l:processedFilename = call(a:FilenameProcessingFunction, [l:filename, l:fileOptionsAndCommands])
	    if empty(l:processedFilename) || empty(l:processedFilename[0])
		return
	    else
		let [l:filename, l:fileOptionsAndCommands] = l:processedFilename
	    endif
	endif
	if ! empty(a:FilespecProcessingFunction)
	    let l:processedFilespec = call(a:FilespecProcessingFunction, [l:dirspec, l:filename, l:fileOptionsAndCommands])
	    if empty(l:processedFilespec) || empty(join(l:processedFilespec[0:1], ''))
		return
	    else
		let [l:dirspec, l:filename, l:fileOptionsAndCommands] = l:processedFilespec
	    endif
	endif

	if type(a:Action) == 2
	    call call(a:Action, [escapings#fnameescape(l:dirspec), l:filename, l:fileOptionsAndCommands])
	else
	    execute a:Action l:fileOptionsAndCommands . escapings#fnameescape(l:dirspec) . l:filename
	endif

	if ! empty(a:PostAction)
	    if type(a:PostAction) == 2
		call call(a:PostAction, [])
	    else
		execute a:PostAction
	    endif
	endif
    catch /^Vim\%((\a\+)\)\=:E/
	call ingo#msg#VimExceptionMsg()
    catch
	call ingo#msg#ErrorMsg(v:exception)
    finally
	unlet! g:CommandCompleteDirForAction_Context
    endtry
endfunction

let s:count = 0
function! CommandCompleteDirForAction#setup( command, dirspec, parameters )
"*******************************************************************************
"* PURPOSE:
"   Define a custom a:command that takes an (potentially optional) single file
"   argument and executes the a:parameters.action command or Funcref with it.
"   The command will have a custom completion that completes files from
"   a:dirspec, with a:parameters.browsefilter applied and
"   a:parameters.wildignore extensions filtered out. The custom completion will
"   return the list of file (/ directory / subdir path) names found. Those
"   should be interpreted relative to (and thus do not include) a:dirspec.
"* ASSUMPTIONS / PRECONDITIONS:
"   None.
"* EFFECTS / POSTCONDITIONS:
"   Defines custom a:command that takes one filename argument, which will have
"   filename completion from a:dirspec. Unless a:parameters.defaultFilename is
"   provided, the filename argument is mandatory.
"* INPUTS:
"   a:command   Name of the custom command to be defined.
"   a:dirspec	Directory (including trailing path separator!) from which
"		files will be completed.
"		Or Funcref to a function that takes no arguments and returns the
"		dirspec.
"
"   a:parameters.commandAttributes
"	    Optional :command {attr}, e.g. <buffer>, -bang, -range.
"	    Funcrefs can access the <bang> via
"	    g:CommandCompleteDirForAction_Context.bang.
"   a:parameters.action
"	    Ex command (e.g. 'edit', '<line1>read') to be invoked with the
"	    completed filespec. Default is the :drop / :Drop command.
"	    Or Funcref to a function that takes the dirspec, filename (both
"	    already escaped for use in an Ex command), and potential
"	    fileOptionsAndCommands (e.g. ++enc=latin1 +set\ ft=c) and performs
"	    the action itself.
"   a:parameters.postAction
"	    Ex command to be invoked after the file has been opened via
"	    a:parameters.action. Default empty.
"	    Or Funcref to a function that takes no arguments and performs the
"	    post actions itself.
"   a:parameters.browsefilter
"	    File wildcard (e.g. '*.txt') used for filtering the files in
"	    a:dirspec. Default is empty string to include all (non-hidden) files.
"	    Does not apply to subdirectories.
"   a:parameters.wildignore
"	    Comma-separated list of file extensions to be ignored. This is
"	    similar to a:parameters.browsefilter, but with inverted semantics,
"	    only file extensions, and multiple possible values. Use empty string
"	    to disable and pass 0 (the default) to keep the current global
"	    'wildignore' setting.
"   a:parameters.isIncludeSubdirs
"	    Flag whether subdirectories will be included in the completion
"	    matches. By default, only files in a:dirspec itself will be offered.
"   a:parameters.defaultFilename
"	    If specified, the command will not require the filename argument,
"	    and default to this filename if none is specified.
"	    The special value "%" will be replaced with the current buffer's
"	    filename.
"	    Or Funcref to a function that takes the dirspec and returns the
"	    filename.
"	    This can resolve to an empty string; however, then your
"	    a:parameters.action has to cope with that (e.g. by putting up a
"	    browse dialog).
"   a:parameters.overrideCompleteFunction
"	    If not empty, will be used as the :command -complete=customlist,...
"	    completion function name. This hook can be used to manipulate the
"	    completion list. This overriding completion function probably will
"	    still invoke the generated custom completion function, which is
"	    therefore returned from this setup function.
"   a:parameters.FilenameProcessingFunction
"	    If not empty, will be passed the completed (or default) filespec and
"	    potential fileOptionsAndCommands, and expects a similar List of
"	    [filespec, fileOptionsAndCommands] in return. (Or an empty List,
"	    which will abort the command.)
"   a:parameters.FilespecProcessingFunction
"	    If not empty, will be passed the (not escaped) dirspec, the
"	    completed (or default) filespec, and the potential
"	    fileOptionsAndCommands, and expects a similar List of [dirspec,
"	    filespec, fileOptionsAndCommands] in return. (Or an empty List,
"	    which will abort the command.)
"
"* RETURN VALUES:
"   Name of the generated custom completion function.
"*******************************************************************************
    let l:commandAttributes = get(a:parameters, 'commandAttributes', '')
    let l:Action = get(a:parameters, 'action', ((exists(':Drop') == 2) ? 'Drop' : 'drop'))
    let l:PostAction = get(a:parameters, 'postAction', '')
    let l:browsefilter = get(a:parameters, 'browsefilter', '')
    let l:wildignore = get(a:parameters, 'wildignore', 0)
    let l:isIncludeSubdirs = get(a:parameters, 'isIncludeSubdirs', 0)
    let l:DefaultFilename = get(a:parameters, 'defaultFilename', '')
    let l:FilenameProcessingFunction = get(a:parameters, 'FilenameProcessingFunction', '')
    let l:FilespecProcessingFunction = get(a:parameters, 'FilespecProcessingFunction', '')

    let s:count += 1
    let l:generatedCompleteFunctionName = 'CompleteDir' . s:count
    let l:completeFunctionName = get(a:parameters, 'overrideCompleteFunction', l:generatedCompleteFunctionName)
    execute
    \	printf("function! %s(ArgLead, CmdLine, CursorPos)\n", l:generatedCompleteFunctionName) .
    \	printf("    return s:CompleteFiles(%s, %s, %s, %d, a:ArgLead)\n",
    \	    string(a:dirspec), string(l:browsefilter), string(l:wildignore), l:isIncludeSubdirs
    \	) .    "endfunction"

    execute printf('command! -bar -nargs=%s -complete=customlist,%s %s %s call <SID>Command(<bang>0, %s, %s, %s, %s, %s, %s, <q-args>)',
    \	(has_key(a:parameters, 'defaultFilename') ? '?' : '1'),
    \   l:completeFunctionName,
    \   l:commandAttributes,
    \   a:command,
    \   (l:commandAttributes =~# '-range=-1' && l:Action =~# '^<line[12]>,\@!' ?
    \       '(<line2> == 1 ? <line1> : <line2>) . ' . string(l:Action[7:]) :
    \	    string(l:Action)
    \   ),
    \   string(l:PostAction),
    \   string(l:DefaultFilename),
    \	string(l:FilenameProcessingFunction),
    \	string(l:FilespecProcessingFunction),
    \   string(a:dirspec),
    \)

    return l:generatedCompleteFunctionName
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
