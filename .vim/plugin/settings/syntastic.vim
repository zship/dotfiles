"let g:syntastic_enable_signs=1
"let g:syntastic_auto_loc_list=1
"let g:syntastic_disabled_filetypes = ['java']
let g:syntastic_mode_map = {
	\'mode': 'active',
	\'active_filetypes': ['javascript', 'sh'],
	\'passive_filetypes': ['java']
\}

let g:syntastic_javascript_checker='jshint'
