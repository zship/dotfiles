"let g:EclimHome = '/usr/local/eclipse-helios/plugins/org.eclim_1.6.1'
"let g:EclimHome = '/home/zach/.eclipse/org.eclipse.platform_3.6.1_793567567/plugins/org.eclim_1.6.3'
let g:EclimHome = '/home/zach/.eclipse/org.eclipse.platform_3.7.0_155965261/plugins/org.eclim_1.7.6'
"let g:EclimEclipseHome = '/usr/local/eclipse-helios'
"let g:EclimEclipseHome = '/home/zach/.eclipse/org.eclipse.platform_3.6.1_793567567'
let g:EclimEclipseHome = '/home/zach/.eclipse/org.eclipse.platform_3.7.0_155965261'
let g:EclimHtmlValidate = 0
let g:EclimXmlValidate = 0
let g:EclimJavaSearchMapping = 0
let g:EclimJavascriptValidate = 0

"Damn it!  This is why I keep getting private static final Log logger =
"LogFactory.getLog([classname]) in every single file! This 'feature' can burn
"in hell!
let g:EclimLoggingDisabled = 1
let g:EclimJavascriptLintEnabled = 0

" Ant shortcuts
nnoremap <Leader>ax :Ant xmlc<CR><CR>
nnoremap <Leader>ac :Ant clean<CR><CR>
nnoremap <Leader>ab :Ant build<CR><CR>
nnoremap <Leader>ad :Ant deploy<CR><CR>
nnoremap <Leader>ar :Ant reload<CR><CR>

" Eclim shortcuts
nnoremap <Leader>pr :ProjectRefresh<CR>

"if !exists("eclim_autocommands_loaded")
	"let eclim_autocommands_loaded = 1

	"fun! EclimEnableIf()
		"let eclim_enabled_ft = ['java']
		"" Don't strip on these filetypes
		"if index(eclim_enabled_ft, &ft) != -1
			"EclimEnable
			"let g:EclimLogLevel = 5
			"let g:EclimSignLevel = 5
			"let g:EclimShowCurrentError = 1
		"else
			"EclimDisable
			"let g:EclimLogLevel = 0
			"let g:EclimSignLevel = 0
			"let g:EclimShowCurrentError = 0
		"endif
	"endfun

	"autocmd BufEnter * call EclimEnableIf()
"endif
