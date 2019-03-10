" Test removing character classes and similar.

scriptencoding utf-8

call vimtest#StartTap()
call vimtap#Plan(9)

call vimtap#Is(ingo#regexp#deconstruct#RemoveCharacterClasses('foobar'), 'foobar', 'no character classes')

call vimtap#Is(ingo#regexp#deconstruct#RemoveCharacterClasses('f\k\kbar'), 'fbar', 'a character class')
call vimtap#Is(ingo#regexp#deconstruct#RemoveCharacterClasses('fo[abcopq]!'), 'fo…!', 'simple collection')
call vimtap#Is(ingo#regexp#deconstruct#RemoveCharacterClasses('fo[[:alnum:]xyz][^a-z]!'), 'fo……!', 'multiple collections')
call vimtap#Is(ingo#regexp#deconstruct#RemoveCharacterClasses('fo\_[abcopq]!'), 'fo…!', 'collection including EOL')

call vimtap#Is(ingo#regexp#deconstruct#RemoveCharacterClasses('[[]foo[]]b[a]r[^!]'), '[foo]bar…', 'single-literal collections')

call vimtap#Is(ingo#regexp#deconstruct#RemoveCharacterClasses('foo\%[bar]quux'), 'foobarquux', 'optional sequence')
call vimtap#Is(ingo#regexp#deconstruct#RemoveCharacterClasses('r\%[[eo]ad]'), "r…ad", 'optional sequence with character class inside')
call vimtap#Is(ingo#regexp#deconstruct#RemoveCharacterClasses('index\%[[[]0[]]]'), 'index[0]', 'optional sequence with square brackets')

call vimtest#Quit()
