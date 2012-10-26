" Mappings for piping selections through shell commands

" PHP Replace visual selection with html entities, if appropriate
vnoremap <silent> <Leader>he :!php -R 'echo mb_convert_encoding($argn,"HTML-ENTITIES","UTF-8");'<CR>

" HTML Tidy for visual selections (write errors to /dev/null)
vnoremap <silent> <Leader>ht :!tidy -q --indent auto --input-encoding utf8 --output-encoding ascii --tidy-mark 0 --wrap 0 --vertical-space 1 --show-body-only 1 2>/dev/null<CR>
