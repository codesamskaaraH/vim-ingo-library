INGO-LIBRARY   
===============================================================================
_by Ingo Karkat_

DESCRIPTION
------------------------------------------------------------------------------

This library contains common autoload functions that are used by almost all of
my plugins (http://www.vim.org/account/profile.php?user_id=9713). Instead of
duplicating the functionality, or installing potentially conflicting versions
with each plugin, this one core dependency fosters a lean Vim runtime and
easier plugin updates.

### RELATED WORKS

Other authors have published separate support libraries, too:

- genutils ([vimscript #197](http://www.vim.org/scripts/script.php?script_id=197)) by Hari Krishna Dara
- lh-vim-lib ([vimscript #214](http://www.vim.org/scripts/script.php?script_id=214)) by Luc Hermitte
- cecutil ([vimscript #1066](http://www.vim.org/scripts/script.php?script_id=1066)) by DrChip
- tlib ([vimscript #1863](http://www.vim.org/scripts/script.php?script_id=1863)) by Thomas Link
- TOVL ([vimscript #1963](http://www.vim.org/scripts/script.php?script_id=1963)) by Marc Weber
- l9 ([vimscript #3252](http://www.vim.org/scripts/script.php?script_id=3252)) by Takeshi Nishida
- anwolib ([vimscript #3800](http://www.vim.org/scripts/script.php?script_id=3800)) by Andy Wokula
- vim-misc ([vimscript #4597](http://www.vim.org/scripts/script.php?script_id=4597)) by Peter Odding
- maktaba (https://github.com/google/maktaba) by Google
- vital (https://github.com/vim-jp/vital.vim) by the Japanese Vim user group
- underscore.vim ([vimscript #5149](http://www.vim.org/scripts/script.php?script_id=5149)) by haya14busa provides functional
  programming functions and depends on the (rather complex) vital library

There have been initiatives to gather and consolidate useful functions into a
"standard Vim library", but these efforts have mostly fizzled out.

USAGE
------------------------------------------------------------------------------

    This library is mainly intended to be used by my own plugins. However, I try
    to maintain backwards compatibility as much as possible. Feel free to use the
    library for your own plugins and customizations, too. I'd also like to hear
    from you if you have additions or comments.

### EXCEPTION HANDLING

For exceptional conditions (e.g. cannot locate window that should be there)
and programming errors (e.g. passing a wrong variable type to a library
function), error strings are |:throw|n. These are prefixed with (something
resembling) the short function name, so that it's possible to :catch these
and e.g. convert them into a proper error (e.g. via
ingo#err#SetCustomException()).

INSTALLATION
------------------------------------------------------------------------------

The code is hosted in a Git repo at
    https://github.com/inkarkat/vim-ingo-library
You can use your favorite plugin manager, or "git clone" into a directory used
for Vim packages. Releases are on the "stable" branch, the latest unstable
development snapshot on "master".

This script is also packaged as a vimball. If you have the "gunzip"
decompressor in your PATH, simply edit the \*.vmb.gz package in Vim; otherwise,
decompress the archive first, e.g. using WinZip. Inside Vim, install by
sourcing the vimball or via the :UseVimball command.

    vim ingo-library*.vmb.gz
    :so %

To uninstall, use the :RmVimball command.

### DEPENDENCIES

- Requires Vim 7.0 or higher.

CONTRIBUTING
------------------------------------------------------------------------------

Report any bugs, send patches, or suggest features via the issue tracker at
https://github.com/inkarkat/vim-ingo-library/issues or email (address below).

HISTORY
------------------------------------------------------------------------------

##### 1.032   RELEASEME
- ingo#query#get#{Register,Mark}(): Avoid throwing E523 on invalid user input
  when executed e.g. from within a :map-expr.
- Add ingo/subst/replacement.vim module with functions originally in
  PatternsOnText.vim ([vimscript #4602](http://www.vim.org/scripts/script.php?script_id=4602)).
- Add ingo/lines/empty.vim module.
- CHG: Rename ingo#str#split#First() to ingo#str#split#MatchFirst() and add
  ingo#str#split#StrFirst() variant that uses a fixed string, not a pattern.
- Add ingo/list/lcs.vim module.
- Add ingo#list#IsEmpty().
- Add ingo/collection/find.vim module.
- Add ingo/window.vim and ingo/window/adjacent modules.
- Add ingo#list#Matches().
- Add ingo/list/sequence.vim module.
- Add ingo#fs#path#IsAbsolute() and ingo#fs#path#IsUpwards().
- Add ingo/area/frompattern.vim module.

##### 1.031   27-Jun-2017
- FIX: Potentially invalid indexing of l:otherResult[l:i] in
  s:GetUnjoinedResult(). Use get() for inner List access, too.
- Add special ingo#compat#synstack to work around missing patch 7.2.014:
  synstack() doesn't work in an empty line.
- BUG: ingo#comments#SplitIndentAndText() and
  ingo#comments#RemoveCommentPrefix() fail with nestable comment prefixes with
  "E688: More targets than List items".

##### 1.030   26-May-2017
- Add escaping of additional values to ingo#option#Join() and split into
  ingo#option#Append() and ingo#option#Prepend().
- Offer simpler ingo#option#JoinEscaped() and ingo#option#JoinUnescaped() for
  actual joining of values split via ingo#option#Split() /
  ingo#option#SplitAndUnescape().
- Add ingo#str#EndsWith() variant of ingo#fs#path#split#Contains().
- Add ingo#regexp#comments#GetFlexibleWhitespaceAndCommentPrefixPattern().
- Add ingo/hlgroup.vim module.
- Add ingo#cursor#StartInsert() and ingo#cursor#StartAppend().
- Add ingo/compat/command.vim module.
- Add ingo#plugin#setting#Default().
- BUG: ingo#mbyte#virtcol#GetVirtColOfCurrentCharacter() yields wrong values
  with single-width multibyte characters, and at the beginning of the line
  (column 1). Need to start with offset 1 (not 0), and account for that
  (subtract 1) in the final return. Need to check that the virtcol argument
  will be larger than 0.
- Add ingo#format#Dict() variant of ingo#format#Format() that only handles
  identifier placeholders and a Dict containing them.
- ENH: ingo#format#Format(): Also handle a:fmt without any "%" items without
  error.
- Add ingo#compat#DictKey(), as Vim 7.4.1707 now allows using an empty
  dictionary key.
- Add ingo#os#IsWindowsShell().
- Generalize functions into ingo/nary.vim and delegate ingo#binary#...()
  functions to those. Add ingo/nary.vim module.
- ENH: ingo#regexp#collection#LiteralToRegexp(): Support inverted collection
  via optional a:isInvert flag.
- Add ingo#strdisplaywidth#CutLeft() variant of ingo#strdisplaywidth#strleft()
  that returns both parts. Same for ingo#strdisplaywidth#strright().
- CHG: Rename ill-named ingo#strdisplaywidth#pad#Middle() to
  ingo#strdisplaywidth#pad#Center().
- Add "real" ingo#strdisplaywidth#pad#Middle() that inserts the padding in the
  middle of the string / between the two passed string parts.
- Add ingo#fs#path#split#PathAndName().
- Add ingo#text#ReplaceChar(), a combination of ingo#text#GetChar(),
  ingo#text#Remove(), and ingo#text#Insert().
- Add ingo#err#Command() for an alternative way of passing back [error]
  commands to be executed.
- ingo#syntaxitem#IsOnSyntax(): Factor out synstack() emulation into
  ingo#compat#synstack() and unify similar function variants.
- ENH: ingo#syntaxitem#IsOnSyntax(): Allow optional a:stopItemPattern to avoid
  considering syntax items at the bottom of the stack.
- Add ingo#compat#synstack().
- Add ingo/dict/count.vim module.
- Add ingo/digest.vim module.
- Add ingo#buffer#VisibleList().

##### 1.029   24-Jan-2017
- CHG: ingo#comments#RemoveCommentPrefix() isn't useful as it omits any indent
  before the comment prefix. Change its implementation to just erase the
  prefix itself.
- Add ingo#comments#SplitIndentAndText() to provide what
  ingo#comments#RemoveCommentPrefix() was previously used to: The line broken
  into indent (before, after, and with the comment prefix), and the remaining
  text.
- Add ingo#indent#Split(), a simpler version of
  ingo#comments#SplitIndentAndText().
- Add ingo#fs#traversal#FindFirstContainedInUpDir().
- ingo#range#lines#Get(): A single (a:isGetAllRanges = 0) /.../ range already
  clobbers the last search pattern. Save and restore if necessary, and base
  didClobberSearchHistory on that check.
- ingo#range#lines#Get(): Drop the ^ anchor for the range check to also detect
  /.../ as the end of the range.
- Add ingo#cmdargs#register#ParsePrependedWritableRegister() alternative to
  ingo#cmdargs#register#ParseAppendedWritableRegister().
- BUG: Optional a:position argument to ingo#window#preview#SplitToPreview() is
  mistakenly truncated to [1:2]. Inline the l:cursor and l:bufnr variables;
  they are only used in the function call, anyway.
- Add ingo/str/find.vim module.
- Add ingo/str/fromrange.vim module.
- Add ingo#pos#SameLineIs[OnOr]After/Before() variants.
- Add ingo/regexp/build.vim module.
- Add ingo#err#SetAndBeep().
- FIX: ingo#query#get#Char() does not beep when validExpr is given and invalid
  character pressed.
- Add ingo#query#get#ValidChar() variant that loops until a valid character
  has been pressed.
- Add ingo/range/invert.vim module.
- Add ingo/line/replace.vim and ingo/lines/replace.vim modules.
- Extract ingo#range#merge#FromLnums() from ingo#range#merge#Merge().
- ingo#range#lines#Get(): If the range is a backwards-looking ?{pattern}?, we
  need to attempt the match on any line with :global/^/... Else, the border
  behavior is inconsistent: ranges that extend the passed range at the bottom
  are (partially) included, but ranges that extend at the front would not be.
- Add ingo/math.vim, ingo/binary.vim and ingo/list/split.vim modules.
- Add ingo#comments#SplitAll(), a more powerful variant of
  ingo#comments#SplitIndentAndText().
- Add ingo#compat#systemlist().
- Add ingo#escape#OnlyUnescaped().
- Add ingo#msg#ColoredMsg() and ingo#msg#ColoredStatusMsg().
- Add ingo/query/recall.vim module.
- Add ingo#register#GetAsList().
- FIX: ingo#format#Format(): An invalid %0$ references the last passed
  argument instead of yielding the empty string (as [argument-index$] is
  1-based). Add bounds check to avoid that
- FIX: ingo#format#Format(): Also support escaping via "%%", as in printf().
- Add ingo#subst#FirstSubstitution(), ingo#subst#FirstPattern(),
  ingo#subst#FirstParameter().
- Add ingo#regexp#collection#Expr().
- BUG: ingo#regexp#magic#Normalize() also processes the contents of
  collections [...]; especially the escaping of "]" wreaks havoc on the
  pattern. Rename s:ConvertMagicness() into
  ingo#regexp#magic#ConvertMagicnessOfElement() and introduce intermediate
  s:ConvertMagicnessOfFragment() that first separates collections from other
  elements and only invokes the former on those other elements.
- Add ingo#collections#fromsplit#MapItemsAndSeparators().

##### 1.028   30-Nov-2016
- ENH: Also support optional a:flagsMatchCount in
  ingo#cmdargs#pattern#ParseUnescaped() and
  ingo#cmdargs#pattern#ParseUnescapedWithLiteralWholeWord().
- Add missing ingo#cmdargs#pattern#ParseWithLiteralWholeWord() variant.
- ingo#codec#URL#Decode(): Also convert the character set to UTF-8 to properly
  handle non-ASCII characters. For example, %C3%9C should decode to "Ü", not
  to "É".
- Add ingo#collections#SeparateItemsAndSeparators(), a variant of
  ingo#collections#SplitKeepSeparators().
- Add ingo/collections/fromsplit.vim module.
- Add ingo#list#Join().
- Add ingo/compat/window.vim module.
- Add ingo/fs/path/asfilename.vim module.
- Add ingo/list/find.vim module.
- Add ingo#option#Join().
- FIX: Correct delegation in ingo#buffer#temp#Execute(); wrong recursive call
  was used (after 1.027).
- ENH: Add optional a:isSilent argument to ingo#buffer#temp#Execute().
- ENH: Add optional a:reservedColumns also to ingo#avoidprompt#TruncateTo(),
  and pass this from ingo#avoidprompt#Truncate().
- ingo#avoidprompt#TruncateTo(): The strright() cannot precisely account for
  the rendering of tab widths. Check the result, and if necessary, remove
  further characters until we go below the limit.
- ENH: Add optional {context} to all ingo#err#... functions, in case other
  custom commands can be called between error setting and checking, to avoid
  clobbering of your error message.
- Add ingo/buffer/locate.vim module.
- Add ingo/window/locate.vim module.
- Add ingo/indent.vim module.
- Add ingo#compat#getcurpos().

##### 1.027   30-Sep-2016
- Add ingo#buffer#temp#ExecuteWithText() and ingo#buffer#temp#CallWithText()
  variants that pre-initialize the buffer (a common use case).
- Add ingo#msg#MsgFromShellError().
- ENH: ingo#query#fromlist#Query(): Support headless (testing) mode via
  g:IngoLibrary\_QueryChoices, like ingo#query#Confirm() already does.
- Expose ingo#query#fromlist#RenderList(). Expose
  ingo#query#StripAccellerator().
- ENH: ingo#cmdargs#pattern#Parse(): Add second optional a:flagsMatchCount
  argument, similar to what ingo#cmdargs#substitute#Parse() has in a:options.
- Add ingo#cmdargs#pattern#RawParse().
- Add ingo/regexp/collection.vim module.
- Add ingo#str#trd().

##### 1.026   11-Aug-2016
- Add ingo#strdisplaywidth#pad#Middle().
- Add ingo/format/columns.vim module.
- ENH: ingo#avoidprompt#TruncateTo() and ingo#strdisplaywidth#TruncateTo()
  have a configurable ellipsis string g:IngoLibrary\_TruncateEllipsis, now
  defaulting to a single-char UTF-8 variant if we're in such encoding. Thanks
  to Daniel Hahler for sending a patch! It also handles pathologically small
  lengths that only show / cut into the ellipsis.
- Add ingo#compat#strgetchar() and ingo#compat#strcharpart(), introduced in
  Vim 7.4.1730.
- Support ingo#compat#strchars() optional {skipcc} argument, introduced in Vim
  7.4.755.

##### 1.025   09-Aug-2016
- Add ingo#str#Contains().
- Add ingo#fs#path#split#Contains().
- ingo#subst#pairs#Substitute(): Canonicalize path separators in
  {replacement}, too. This is important to match further pairs, too, as the
  pattern is always in canonical form, so the replacement has to be, too.
- ingo#subst#pairs#Substitute() and ingo#subst#pairs#Split(): Only
  canonicalize path separators in {replacement} on demand, via additional
  a:isCanonicalizeReplacement argument. Some clients may not need iterative
  replacement, and treat the wildcard as a convenient regexp-shorthand, not
  overly filesystem-related.
- ENH: Allow passing to ingo#subst#pairs#Substitute() [wildcard, replacement]
  Lists instead of {wildcard}={replacement} Strings, too.
- Add ingo#collections#Partition().
- Add ingo#text#frompattern#GetAroundHere().
- Add ingo#cmdline#showmode#TemporaryNoShowMode() variant of
  ingo#cmdline#showmode#OneLineTemporaryNoShowMode().
- ENH: Enable customization of ingo#window#special#IsSpecialWindow() via
  g:IngoLibrary\_SpecialWindowPredicates.
- Add ingo#query#Question().
- ENH: Make ingo#window#special#SaveSpecialWindowSize() return sum of special
  windows' widths and sum of special windows' heights.
- Add ingo/swap.vim module.
- Add ingo#collections#unique#Insert() and ingo#collections#unique#Add().
- BUG: Unescaped backslash resulted in unclosed [...] regexp collection
  causing ingo#escape#file#fnameunescape() to fail to escape on Unix.
- Add ingo#text#GetCharBefore() variant of ingo#text#GetChar().
- Add optional a:characterOffset to ingo#record#PositionAndLocation().
- Add ingo#regexp#MakeStartWordSearch() ingo#regexp#MakeEndWordSearch()
  variants of ingo#regexp#MakeWholeWordSearch().
- Add ingo#pos#IsInsideVisualSelection().
- Add ingo#escape#command#mapunescape().
- ENH: Add second optional flag a:isKeepDirectories to
  ingo#cmdargs#glob#Expand() / ingo#cmdargs#glob#ExpandSingle().
- Add ingo#range#borders#StartAndEndRange().
- Add ingo#msg#VerboseMsg().
- Add ingo#compat#sha256(), with a fallback to an external sha256sum command.
- Add ingo#collections#Reduce().
- Add ingo/actions/iterations.vim module.
- Add ingo/actions/special.vim module.
- Add ingo#collections#differences#ContainsLoosely() and
  ingo#collections#differences#ContainsStrictly().
- Add ingo#buffer#ExistOtherLoadedBuffers().
- FIX: Temporarily reset 'switchbuf' in ingo#buffer#visible#Execute() and
  ingo#buffer#temp#Execute(), to avoid that "usetab" switched to another tab
  page.
- ingo#msg#HighlightMsg(): Make a:hlgroup optional, default to 'None' (so the
  function is useful to return to normal highlighting).
- Add ingo#msg#HighlightN(), an :echon variant.

##### 1.024   23-Apr-2015
- FIX: Also correctly set change marks when replacing entire buffer with
  ingo#lines#Replace().
- Add ingo/collections/differences.vim module.
- Add ingo/compat/regexp.vim module.
- Add ingo/encoding.vim module.
- Add ingo/str/join.vim module.
- Add ingo#option#SplitAndUnescape().
- Add ingo#list#Zip() and ingo#list#ZipLongest().
- ingo#buffer#visible#Execute(): Restore the window layout when the buffer is
  visible but in a window with 0 height / width. And restore the previous
  window when the buffer isn't visible yet. Add a check that the command
  hasn't switched to another window (and go back if true) before closing the
  split window.
- Add ingo/regexp/virtcols.vim module.
- Add ingo#str#GetVirtCols() and ingo#text#RemoveVirtCol().
- FIX: Off-by-one: Allow column 1 in ingo#text#Remove().
- BUG: ingo#buffer#scratch#Create() with existing scratch buffer yields "E95:
  Buffer with this name already exists" instead of reusing the buffer.
- Keep current cursor position when ingo#buffer#scratch#Create() removes the
  first empty line in the scratch buffer.
- ingo#text#frompattern#GetHere(): Do not move the cursor (to the end of the
  matched pattern); this is unexpected and can be easily avoided.
- FIX: ingo#cmdargs#GetStringExpr(): Escape (unescaped) double quotes when the
  argument contains backslashes; else, the expansion of \x will silently fail.
- Add ingo#cmdargs#GetUnescapedExpr(); when there's no need for empty
  expressions, the removal of the (single / double) quotes may be unexpected.
- ingo#text#Insert(): Also allow insertion one beyond the last line (in column
  1), just like setline() allows.
- Rename ingo#date#format#Human() to ingo#date#format#Preferred(), default to
  %x value for strftime(), and allow to customize that (even dynamically,
  maybe based on 'spelllang').
- Add optional a:templateForNewBuffer argument to ingo#fs#tempfile#Make() and
  ensure (by default) that the temp file isn't yet loaded in a Vim buffer
  (which would generate "E139: file is loaded in another buffer" on the usual
  :write, :saveas commands).
- Add ingo#compat#shiftwidth(), taken from :h shiftwidth().

##### 1.023   09-Feb-2015
- ENH: Make ingo#selection#frompattern#GetPositions() automatically convert
  \%# in the passed a:pattern to the hard-coded cursor column.
- Add ingo#collections#mapsort().
- Add ingo/collections/memoized.vim module.
- ENH: Add optional a:isReturnAsList flag to ingo#buffer#temp#Execute() and
  ingo#buffer#temp#Call().
- ENH: Also allow passing an items List to ingo#dict#Mirror() and
  ingo#dict#AddMirrored() (useful to influence which key from equal values is
  used).
- ENH: Also support optional a:isEnsureUniqueness flag for
  ingo#dict#FromItems().
- Expose ingo#regexp#MakeWholeWordSearch().
- Add ingo#plugin#setting#GetTabLocal().
- ENH: Add a:isFile flag to ingo#escape#file#bufnameescape() in order to do
  full matching on scratch buffer names. There, the expansion to a full
  absolute path must be skipped in order to match.
- ENH: Add a:isGetAllRanges optional argument to ingo#range#lines#Get().
- Add ingo#strdisplaywidth#TruncateTo().
- Add ingo/str/frompattern.vim module.
- Add ingo/folds/persistence.vim module.
- Add ingo#cmdargs#pattern#IsDelimited().
- Support ingo#query#fromlist#Query() querying of more than 10 elements by
  number. Break listing of query choices into multiple lines when the overall
  question doesn't fit in a single line.
- Add ingo/event.vim module.
- Add ingo/range/merge.vim module.
- Add ingo#filetype#IsPrimary().
- Add ingo#plugin#setting#GetScope().
- Add ingo#regexp#fromwildcard#AnchoredToPathBoundaries().
- Use :close! in ingo#buffer#visible#Execute() to handle modified buffers when
  :set nohidden, too.
- Improve heuristics of ingo#window#quickfix#IsQuickfixList() to also handle
  empty location list (with non-empty quickfix list).
- Minor: ingo#text#Remove(): Correct exception prefix.
- Add ingo#window#quickfix#TranslateVirtualColToByteCount() from
  autoload/QuickFixCurrentNumber.vim.

##### 1.022   26-Sep-2014
- Add ingo#pos#Before() and ingo#pos#After().
- Move LineJuggler#FoldClosed() and LineJuggler#FoldClosedEnd() into
  ingo-library as ingo#range#NetStart() and ingo#range#NetEnd().
- Add ingo/regexp/pairs.vim module.
- Add ingo#compat#glob() and ingo#compat#globpath().
- ingo#range#lines#Get() needs to consider and temporarily disable closed
  folds when resolving /{pattern}/ ranges.

##### 1.021   10-Jul-2014
- Add ingo#compat#uniq().
- Add ingo#option#Contains() and ingo#option#ContainsOneOf().
- BUG: Wrong position type causes ingo#selection#position#get() to be one-off
  with :set selection=exclusive and when the cursor is after the selection.
- Use built-in changenr() in ingo#undo#GetChangeNumber(); actually, the entire
  function could be replaced by the built-in, if it would not just return one
  less than the number of the undone change after undo. We want the result to
  represent the current change, regardless of what undo / redo was done
  earlier. Change the implementation to test for whether the current change is
  the last in the buffer, and if not, make a no-op change to get to an
  explicit change state.
- Simplify ingo#buffer#temprange#Execute() by using changenr(). Keep using
  ingo#undo#GetChangeNumber() because we need to create a new no-op change
  when there was a previous :undo.
- Add ingo/smartcase.vim module.
- FIX: ingo#cmdargs#substitute#Parse() branch for special case of {flags}
  without /pat/string/ must only be entered when a:arguments is not empty.
- ENH: Allow to pass path separator to ingo#regexp#fromwildcard#Convert() and
  ingo#regexp#fromwildcard#IsWildcardPathPattern().
- Add ingo/collections/permute.vim module.
- Add ingo#window#preview#OpenFilespec(), a wrapper around :pedit that
  performs the fnameescape() and obeys the custom g:previewwindowsplitmode.

##### 1.020   11-Jun-2014
- Add ingo/dict/find.vim module.
- Use ingo#escape#Unescape() in ingo#cmdargs#pattern#Unescape(). Add
  ingo#cmdargs#pattern#ParseUnescaped() to avoid the double and inefficient
  ingo#cmdargs#pattern#Unescape(ingo#cmdargs#pattern#Parse()) so far used by
  many clients.
- Add ingo#cmdargs#pattern#ParseUnescapedWithLiteralWholeWord() for the common
  [/]{pattern}[/ behavior as built-in commands like |:djump|]. When the
  pattern isn't delimited by /.../, the returned pattern is modified so that
  only literal whole words are matched. so far used by many clients.
- CHG: At ingo#regexp#FromLiteralText(), add the a:isWholeWordSearch also on
  either side, or when there are non-keyword characters in the middle of the
  text. The \* command behavior where this is modeled after only handles a
  smaller subset, and this extension looks sensible and DWIM.
- Add ingo#compat#abs().
- Factor out and expose ingo#text#Replace#Area().
- CHG: When replacing at the cursor position, also jump to the beginning of
  the replacement. This is more consistent with Vim's default behavior.
- Add ingo/record.vim module.
- ENH: Allow passing optional a:tabnr to
  ingo#window#preview#IsPreviewWindowVisible().
- Factor out ingo#window#preview#OpenBuffer().
- CHG: Change optional a:cursor argument of
  ingo#window#preview#SplitToPreview() from 4-tuple getpos()-style to [lnum,
  col]-style.
- Add ingo/query/fromlist.vim module.
- Add ingo/option.vim module.
- Add ingo/join.vim module.
- Expose ingo#actions#GetValExpr().
- Add ingo/range/lines.vim module.
- ENH: Add a:options.commandExpr to ingo#cmdargs#range#Parse().

##### 1.019   24-May-2014
- Add ingo#plugin#setting#BooleanToStringValue().
- Add ingo#strdisplaywidth#GetMinMax().
- Add ingo/undo.vim module.
- Add ingo/query.vim module.
- Add ingo/pos.vim module.
- Add optional a:isBeep argument to ingo#msg#ErrorMsg().
- ingo#fs#path#Normalize(): Don't normalize to Cygwin /cygdrive/x/... when the
  chosen path separator is "\". This would result in a mixed separator style
  that is not actually handled.
- ingo#fs#path#Normalize(): Add special normalization to "C:/" on Cygwin via
  ":/" path separator argument.
- In ingo#actions#EvaluateWithValOrFunc(), remove any occurrence of "v:val"
  instead of passing an empty list or empty string. This is useful for
  invoking functions (an expression, not Funcref) with optional arguments.
- ENH: Make ingo#lines#Replace() handle replacement with nothing (empty List)
  and replacing the entire buffer (without leaving an additional empty line).
- Correct ingo#query#confirm#AutoAccelerators() default choice when not given
  (1 instead of 0). Avoid using the default choice's first character as
  accelerator unless in GUI dialog, as the plain text confirm() assigns a
  default accelerator.
- Move subs/URL.vim into ingo-library as ingo/codec/URL.vim module.
- Allow optional a:ignorecase argument for ingo#str#StartsWith() and
  ingo#str#EndsWith().
- Add ingo#fs#path#IsCaseInsensitive().
- Add ingo#str#Equals() for when it's convenient to pass in the a:ignorecase
  flag. This avoids coding the conditional between ==# and ==? yourself.
- Add ingo/fs/path/split.vim module.
- Add ingo#fs#path#Exists().
- FIX: Correct ingo#escape#file#wildcardescape() of \* and ? on Windows.

##### 1.018   14-Apr-2014
- FIX: Off-by-one: Allow column 1 in ingo#text#Insert(). Add special cases for
  insertion at front and end of line (in the hope that this is more
  efficient).
- Add ingo#escape#file#wildcardescape().
- I18N: Correctly capture last multi-byte character in ingo#text#Get(); don't
  just add one to the end column, but instead match at the column itself, too.
- Add optional a:isExclusive flag to ingo#text#Get(), as clients may end up
  with that position, and doing a correct I18N-safe decrease before getting
  the text is a hen-and-egg problem.
- Add ingo/buffer/temprange.vim module.
- Add ingo#cursor#IsAtEndOfLine().
- FIX: Off-by-one in emulated ingo#compat#strdisplaywidth() reported one too
  few.

##### 1.017   13-Mar-2014
- CHG: Make ingo#cmdargs#file#FilterFileOptionsAndCommands() return the
  options and commands in a List, not as a joined String. This allows clients
  to easily re-escape them and handle multiple ones, e.g. ++ff=dos +setf\ foo.
- Add workarounds for fnameescape() bugs on Windows for ! and [] characters.
- Add ingo#escape#UnescapeExpr().
- Add ingo/str/restricted.vim module.
- Make ingo#query#get#Char() only abort on <Esc> when that character is not in
  the validExpr (to allow to explicitly query it).
- Add ingo/query/substitute.vim module.
- Add ingo/subst/expr/emulation.vim module.
- Add ingo/cmdargs/register.vim module.

##### 1.016   22-Jan-2014
- Add ingo#window#quickfix#GetList() and ingo#window#quickfix#SetList().
- Add ingo/cursor.vim module.
- Add ingo#text#Insert() and ingo#text#Remove().
- Add ingo#str#StartsWith() and ingo#str#EndsWith().
- Add ingo#dict#Mirror() and ingo#dict#AddMirrored().
- BUG: Wrap :autocmd! undo\_ftplugin\_N in :execute to that superordinated
  ftplugins can append additional undo commands without causing "E216: No such
  group or event: undo\_ftplugin\_N|setlocal".
- Add ingo/motion/helper.vim module.
- Add ingo/motion/omap.vim module.
- Add ingo/subst/pairs.vim module.
- Add ingo/plugin/compiler.vim module.
- Move ingo#escape#shellcommand#shellcmdescape() to
  ingo#compat#shellcommand#escape(), as it is only required for older Vim
  versions.

##### 1.015   28-Nov-2013
- Add ingo/format.vim module.
- FIX: Actually return the result of a Funcref passed to
  ingo#register#KeepRegisterExecuteOrFunc().
- Make buffer argument of ingo#buffer#IsBlank() optional, defaulting to the
  current buffer.
- Allow use of ingo#buffer#IsEmpty() with other buffers.
- CHG: Pass _all_ additional arguments of ingo#actions#ValueOrFunc(),
  ingo#actions#NormalOrFunc(), ingo#actions#ExecuteOrFunc(),
  ingo#actions#EvaluateOrFunc() instead of only the first (interpreted as a
  List of arguments) when passed a Funcref as a:Action.
- Add ingo#compat#setpos().
- Add ingo/print.vim module.

##### 1.014   14-Nov-2013
- Add ingo/date/format.vim module.
- Add ingo#os#PathSeparator().
- Add ingo/foldtext.vim module.
- Add ingo#os#IsCygwin().
- ingo#fs#path#Normalize(): Also convert between the different D:\ and
  /cygdrive/d/ notations on Windows and Cygwin.
- Add ingo#text#frompattern#GetHere().
- Add ingo/date/epoch.vim module.
- Add ingo#buffer#IsPersisted().
- Add ingo/list.vim module.
- Add ingo/query/confirm.vim module.
- Add ingo#text#GetChar().
- Add ingo/regexp/fromwildcard.vim module (contributed by the EditSimilar.vim
  plugin). In constrast to the simpler ingo#regexp#FromWildcard(), this
  handles the full range of wildcards and considers the path separators on
  different platforms.
- Add ingo#register#KeepRegisterExecuteOrFunc().
- Add ingo#actions#ValueOrFunc().
- Add ingo/funcref.vim module.
- Add month and year granularity to ingo#date#HumanReltime().
- Add ingo/units.vim module.

##### 1.013   13-Sep-2013
- Also avoid clobbering the last change ('.') in ingo#selection#Get() when
  'cpo' contains "y".
- Name the temp buffer for ingo#buffer#temp#Execute() and re-use previous
  instances to avoid increasing the buffer numbers and output of :ls!.
- CHG: Make a:isIgnoreIndent flag to ingo#comments#CheckComment() optional and
  add a:isStripNonEssentialWhiteSpaceFromCommentString, which is also on by
  default for DWIM.
- CHG: Don't strip whitespace in ingo#comments#RemoveCommentPrefix(); with the
  changed ingo#comments#CheckComment() default behavior, this isn't necessary,
  and is unexpected.
- ingo#comments#RenderComment: When the text starts with indent identical to
  what 'commentstring' would render, avoid having duplicate indent.
- Minor: Return last search pattern instead of empty string on
  ingo#search#pattern#GetLastForwardSearch(0).
- Avoid using \ze in ingo#regexp#comments#CommentToExpression(). It may be
  used in a larger expression that still wants to match after the prefix.
- FIX: Correct case of ingo#os#IsWin\*() function names.
- ingo#regexp#FromWildcard(): Limit \* glob matching to individual path
  components and add \*\* for cross-directory matching.
- Consistently use operating system detection functions from ingo/os.vim
  within the ingo-library.

##### 1.012   05-Sep-2013
- CHG: Change return value format of ingo#selection#frompattern#GetPositions()
  to better match the arguments of functions like ingo#text#Get().
- Add ingo/os.vim module.
- Add ingo#compat#fnameescape() and ingo#compat#shellescape() from
  escapings.vim.
- Add remaining former escapings.vim functions as ingo/escape/shellcommand.vim
  and ingo/escape/file.vim modules.
- Add ingo/motion/boundary.vim module.
- Add ingo#compat#maparg().
- Add ingo/escape/command.vim module.
- Add ingo/text/frompattern.vim module.

##### 1.011   02-Aug-2013
- Add ingo/range.vim module.
- Add ingo/register.vim module.
- Make ingo#collections#ToDict() handle empty list items via an optional
  a:emptyValue argument. This also distinguishes it from ingo#dict#FromKeys().
- ENH: Handle empty list items in ingo#collections#Unique() and
  ingo#collections#UniqueStable().
- Add ingo/gui/position.vim module.
- Add ingo/filetype.vim module.
- Add ingo/ftplugin/onbufwinenter.vim module.
- Add ingo/selection/frompattern.vim module.
- Add ingo/text.vim module.
- Add ingo/ftplugin/windowsettings.vim module.
- Add ingo/text/replace.vim module.
- FIX: Use the rules for the /pattern/ separator as stated in :help E146 for
  ingo#cmdargs#pattern#Parse() and ingo#cmdargs#substitute#Parse().
- FIX: Off-by-one in ingo#strdisplaywidth#HasMoreThan() and
  ingo#strdisplaywidth#strleft().
- Add ingo#str#Reverse().
- ingo#fs#traversal#FindLastContainedInUpDir now defaults to the current
  buffer's directory; omit the argument.
- Add ingo#actions#EvaluateWithValOrFunc().
- Extract ingo#fs#path#IsUncPathRoot().
- Add ingo#fs#traversal#FindDirUpwards().

##### 1.010   09-Jul-2013
- Add ingo/actions.vim module.
- Add ingo/cursor/move.vim module.
- Add ingo#collections#unique#AddNew() and
  ingo#collections#unique#InsertNew().
- Add ingo/selection/position.vim module.
- Add ingo/plugin/marks.vim module.
- Add ingo/date.vim module.
- Add ingo#buffer#IsEmpty().
- Add ingo/buffer/scratch.vim module.
- Add ingo/cmdargs/command.vim module.
- Add ingo/cmdargs/commandcommands.vim module.
- Add ingo/cmdargs/range.vim module.

##### 1.009   03-Jul-2013
- Minor: Make substitute() robust against 'ignorecase' in various functions.
- Add ingo/subst.vim module.
- Add ingo/escape.vim module.
- Add ingo/regexp/comments.vim module.
- Add ingo/cmdline/showmode.vim module.
- Add ingo/str.vim module.
- Add ingo/strdisplaywidth/pad.vim module.
- Add ingo/dict.vim module.
- Add ingo#msg#HighlightMsg(), and allow to pass an optional highlight group
  to ingo#msg#StatusMsg().
- Add ingo#collections#Flatten() and ingo#collections#Flatten1().
- Move ingo#collections#MakeUnique() to ingo/collections/unique.vim.
- Add ingo#collections#unique#ExtendWithNew().
- Add ingo#fs#path#Equals().
- Add ingo#tabstops#RenderMultiLine(), as ingo#tabstops#Render() does not
  properly render multi-line text.
- Add ingo/str/split.vim module.
- FIX: Avoid E108: No such variable: "b:browsefilter" in
  ingo#query#file#Browse().

##### 1.008   13-Jun-2013
- Fix missing argument error for ingo#query#file#BrowseDirForOpenFile() and
  ingo#query#file#BrowseDirForAction().
- Implement ingo#compat#strdisplaywidth() emulation inside the library;
  EchoWithoutScrolling.vim isn't used for that any more.
- Add ingo/avoidprompt.vim, ingo/strdisplaywidth.vim, and ingo/tabstops
  modules, containing the former EchoWithoutScrolling.vim functions.
- Add ingo/buffer/temp.vim and ingo/buffer/visible.vim modules.
- Add ingo/regexp/previoussubstitution.vim module.

##### 1.007   06-Jun-2013
- Add ingo/query/get.vim module.
- Add ingo/query/file.vim module.
- Add ingo/fs/path.vim module.
- Add ingo/fs/tempfile.vim module.
- Add ingo/cmdargs/file.vim module.
- Add ingo/cmdargs/glob.vim module.
- CHG: Move most functions from ingo/cmdargs.vim to new modules
  ingo/cmdargs/pattern.vim and ingo/cmdargs/substitute.vim.
- Add ingo/compat/complete.vim module.

##### 1.006   29-May-2013
- Add ingo/cmdrangeconverter.vim module.
- Add ingo#mapmaker.vim module.
- Add optional isReturnError flag on
  ingo#window#switches#GotoPreviousWindow().
- Add ingo#msg#StatusMsg().
- Add ingo/selection/patternmatch.vim module.
- Add ingo/selection.vim module.
- Add ingo/search/pattern.vim module.
- Add ingo/regexp.vim module.
- Add ingo/regexp/magic.vim module.
- Add ingo/collections/rotate.vim module.
- Redesign ingo#cmdargs#ParseSubstituteArgument() to the existing use cases.
- Add ingo/buffer.vim module.

##### 1.005   02-May-2013
- Add ingo/plugin/setting.vim module.
- Add ingo/plugin/cmdcomplete.vim module.
- Add ingo/search/buffer.vim module.
- Add ingo/number.vim module.
- Add ingo#err#IsSet() for those cases when wrapping the command in :if does
  not work (e.g. :call'ing a range function).
- Add ingo#syntaxitem.vim module.
- Add ingo#comments.vim module.

##### 1.004   10-Apr-2013
- Add ingo/compat.vim module.
- Add ingo/folds.vim module.
- Add ingo/lines module.
- Add ingo/matches module.
- Add ingo/mbyte/virtcol module.
- Add ingo/window/\* modules.
- FIX: ingo#external#LaunchGvim() broken with "E117: Unknown function: s:externalLaunch".

##### 1.003   27-Mar-2013
- Add ingo#msg#ShellError().
- Add ingo#system#Chomped().
- Add ingo/fs/traversal.vim module.
- Add search/timelimited.vim module.

##### 1.002   08-Mar-2013
- Minor: Allow to specify filespec of GVIM executable in
  ingo#external#LaunchGvim().
- Add err module for LineJugglerCommands.vim plugin.

##### 1.001   21-Feb-2013
- Add cmdargs and collections modules for use by PatternsOnText.vim plugin.

##### 1.000   12-Feb-2013
- First published version as separate shared library.

##### 0.001   05-Jan-2009
- Started development of shared autoload functionality.

------------------------------------------------------------------------------
Copyright: (C) 2009-2017 Ingo Karkat -
Contains URL encoding / decoding algorithms written by Tim Pope. -
The [VIM LICENSE](http://vimdoc.sourceforge.net/htmldoc/uganda.html#license) applies to this plugin.

Maintainer:     Ingo Karkat <ingo@karkat.de>
