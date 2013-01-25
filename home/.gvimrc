if has("gui_macvim")
	" Disable all Mac 'Command key' mappings (so we can map over them)
	macmenu File.New\ Window                            key=<nop>
	macmenu File.New\ Tab                               key=<nop>
	macmenu File.Open\.\.\.                             key=<nop>
	macmenu File.Open\ Tab\.\.\.<Tab>:tabnew            key=<nop>
	macmenu File.Open\ Recent                           key=<nop>
	macmenu File.Close\ Window<Tab>:qa                  key=<nop>
	macmenu File.Close                                  key=<nop>
	macmenu File.Save<Tab>:w                            key=<nop>
	macmenu File.Save\ All                              key=<nop>
	macmenu File.Save\ As\.\.\.<Tab>:sav                key=<nop>
	macmenu File.Print                                  key=<nop>
	macmenu Edit.Undo<Tab>u                             key=<nop>
	macmenu Edit.Redo<Tab>^R                            key=<nop>
	macmenu Edit.Cut<Tab>"+x                            key=<nop>
	macmenu Edit.Copy<Tab>"+y                           key=<nop>
	macmenu Edit.Paste<Tab>"+gP                         key=<nop>
	macmenu Edit.Select\ All<Tab>ggVG                   key=<nop>
	macmenu Edit.Find.Find\.\.\.                        key=<nop>
	macmenu Edit.Find.Find\ Next                        key=<nop>
	macmenu Edit.Find.Find\ Previous                    key=<nop>
	macmenu Edit.Find.Use\ Selection\ for\ Find         key=<nop>
	macmenu Edit.Font.Show\ Fonts                       key=<nop>
	macmenu Edit.Font.Bigger                            key=<nop>
	macmenu Edit.Font.Smaller                           key=<nop>
	macmenu Edit.Special\ Characters\.\.\.              key=<nop>
	macmenu Tools.Spelling.To\ Next\ error<Tab>]s       key=<nop>
	macmenu Tools.Spelling.Suggest\ Corrections<Tab>z=  key=<nop>
	macmenu Tools.Make<Tab>:make                        key=<nop>
	macmenu Tools.List\ Errors<Tab>:cl                  key=<nop>
	macmenu Tools.Next\ Error<Tab>:cn                   key=<nop>
	macmenu Tools.Previous\ Error<Tab>:cp               key=<nop>
	macmenu Tools.Older\ List<Tab>:cold                 key=<nop>
	macmenu Tools.Newer\ List<Tab>:cnew                 key=<nop>
	macmenu Window.Minimize                             key=<nop>
	macmenu Window.Minimize\ All                        key=<nop>
	macmenu Window.Zoom                                 key=<nop>
	macmenu Window.Zoom\ All                            key=<nop>
	macmenu Window.Toggle\ Full\ Screen\ Mode           key=<nop>
	macmenu Window.Select\ Next\ Tab                    key=<nop>
	macmenu Window.Select\ Previous\ Tab                key=<nop>
	macmenu Window.Bring\ All\ To\ Front                key=<nop>
	macmenu Help.MacVim\ Help                           key=<nop>
	macmenu Help.MacVim\ Website                        key=<nop>

	" keypad with Command+Shift
	lnoremap <D-U> 7
	lnoremap <D-I> 8
	lnoremap <D-O> 9
	lnoremap <D-J> 4
	lnoremap <D-K> 5
	lnoremap <D-L> 6
	lnoremap <D-M> 1
	lnoremap <D-lt> 2
	lnoremap <D->> 3
	lnoremap <D-S-Space> 0
	lnoremap <D-:> +
	lnoremap <D-P> -

	nnoremap <D-U> :7<C-^>
	nnoremap <D-I> :8<C-^>
	nnoremap <D-O> :9<C-^>
	nnoremap <D-J> :4<C-^>
	nnoremap <D-K> :5<C-^>
	nnoremap <D-L> :6<C-^>
	nnoremap <D-M> :1<C-^>
	nnoremap <D-lt> :2<C-^>
	nnoremap <D->> :3<C-^>
	nnoremap <D-S-Space> :0<C-^>
endif
