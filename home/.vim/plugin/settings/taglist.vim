nnoremap <silent> <A-d> :TlistToggle<CR>
let Tlist_Show_One_File = 1
let Tlist_Enable_Fold_Column = 0
let Tlist_GainFocus_On_ToggleOpen = 1
let Tlist_Display_Prototype = 1

" actionscript language
let tlist_actionscript_settings = 'actionscript;c:class;f:method;p:property;v:variable'

" Regenerate ctags
nnoremap <Leader>ct :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR><CR>

" Tags action
"set tags=tags;/
"set tags+=~/.vim/tags/qt4
