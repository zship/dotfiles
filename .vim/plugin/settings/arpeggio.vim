call arpeggio#load()

Arpeggioinoremap kj <Esc>
"Arpeggiovnoremap kj <Esc>
Arpeggiocnoremap kj <Esc>
Arpeggioonoremap kj <Esc>


au BufEnter * call ApplyFtMappings()

fun! ApplyFtMappings()
	if &ft == 'javascript'
		""call arpeggio#map('i', 'bu', 0, 'fu' 'function()<Space>{}<Left><Left><Left><Left>')
		"call arpeggio#map('i', 'b', 0, 'fui' 'function()<Space>{}<Left><CR><CR><Up><Tab>')
		""Arpeggioinoremap <buffer> fu function() {}<Left><Left><Left><Left>
		Arpeggioinoremap <buffer> fu function() {}<Left><CR><CR><Up><Tab>
	endif
endfun
