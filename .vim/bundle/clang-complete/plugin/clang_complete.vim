"
" File: clang_complete.vim
" Author: Xavier Deguillard <deguilx@gmail.com>
"
" Description: Use of clang to complete in C/C++.
"
" Configuration: Each project can have a .clang_complete at his root,
"                containing the compiler options. This is useful if
"                you're using some non-standard include paths.
"                For simplicity, please don't put relative and
"                absolute include path on the same line. It is not
"                currently correctly handled.
"
" Options:
"  - g:clang_complete_auto:
"       if equal to 1, automatically complete after ->, ., ::
"       Default: 1
"
"  - g:clang_complete_copen:
"       if equal to 1, open quickfix window on error.
"       WARNING: segfault on unpatched vim!
"       Default: 0
"
"  - g:clang_hl_errors:
"       if equal to 1, it will highlight the warnings and errors the
"       same way clang does it.
"       Default: 1
"
"  - g:clang_periodic_quickfix:
"       if equal to 1, it will periodically update the quickfix window
"       Note: You could use the g:ClangUpdateQuickFix() to do the same
"             with a mapping.
"       Default: 0
"
"  - g:clang_snippets:
"       if equal to 1, it will do some snippets magic after a ( or a ,
"       inside function call. Not currently fully working.
"       Default: 0
"
" Todo: - Fix bugs
"       - Add snippets on Pattern and OVERLOAD (is it possible?)
"       - Parse fix-its and do something useful with it.
"

au FileType c,cpp,objc,objcpp call s:ClangCompleteInit()

let b:clang_exec = ''
let b:clang_parameters = ''
let b:clang_user_options = ''
let b:my_changedtick = 0

function s:ClangCompleteInit()
    let l:local_conf = findfile(".clang_complete", '.;')
    let b:clang_user_options = ''
    if l:local_conf != ""
        let l:opts = readfile(l:local_conf)
        for l:opt in l:opts
            " Better handling of absolute path
            " I don't know if those pattern will work on windows
            " platform
            if matchstr(l:opt, '-I\s*/') != ""
                let l:opt = substitute(l:opt, '-I\s*\(/\%(\w\|\\\s\)*\)',
                            \ '-I' . '\1', "g")
            else
                let l:opt = substitute(l:opt, '-I\s*\(\%(\w\|\\\s\)*\)',
                            \ '-I' . l:local_conf[:-16] . '\1', "g")
            endif
            let b:clang_user_options .= " " . l:opt
        endfor
    endif

    if !exists('g:clang_complete_auto')
        let g:clang_complete_auto = 1
    endif

    if !exists('g:clang_complete_copen')
        let g:clang_complete_copen = 0
    endif

    if !exists('g:clang_hl_errors')
        let g:clang_hl_errors = 1
    endif

    if !exists('g:clang_periodic_quickfix')
        let g:clang_periodic_quickfix = 0
    endif

    if !exists('g:clang_snippets')
        let g:clang_snippets = 0
    endif

    if g:clang_complete_auto == 1
        inoremap <expr> <buffer> <C-X><C-U> LaunchCompletion()
        inoremap <expr> <buffer> . CompleteDot()
        inoremap <expr> <buffer> > CompleteArrow()
        inoremap <expr> <buffer> : CompleteColon()
    endif

    let b:should_overload = 0
    let b:my_changedtick = b:changedtick
    let b:clang_exec = 'clang'
    let b:clang_parameters = '-x c'

    if &filetype == 'objc'
        let b:clang_parameters = '-x objective-c'
    endif

    if &filetype == 'cpp' || &filetype == 'objcpp'
        let b:clang_parameters .= '++'
    endif

    if expand('%:e') =~ 'h*'
        let b:clang_parameters .= '-header'
    endif

    setlocal completefunc=ClangComplete

    if g:clang_periodic_quickfix == 1
        au CursorHold,CursorHoldI <buffer> call s:DoPeriodicQuickFix()
    endif

    if g:clang_snippets == 1
        au CursorMovedI <buffer> call UpdateSnips()
    endif
endfunction

function s:GetKind(proto)
    if a:proto == ""
        return 't'
    endif
    let l:ret = match(a:proto, '^\[#')
    let l:params = match(a:proto, '(')
    if l:ret == -1 && l:params == -1
        return 't'
    endif
    if l:ret != -1 && l:params == -1
        return 'v'
    endif
    if l:params != -1
        return 'f'
    endif
    return 'm'
endfunction

function s:DoPeriodicQuickFix()
    " Don't do any superfluous reparsing.
    if b:my_changedtick == b:changedtick
        return
    endif
    let b:my_changedtick = b:changedtick

    let l:buf = getline(1, '$')
    let l:tempfile = expand('%:p:h') . '/' . localtime() . expand('%:t')
    try
        call writefile(l:buf, l:tempfile)
    catch /^Vim\%((\a\+)\)\=:E482/
        return
    endtry
    let l:escaped_tempfile = shellescape(l:tempfile)

    let l:command = b:clang_exec . " -cc1 -fsyntax-only"
                \ . " -fno-caret-diagnostics -fdiagnostics-print-source-range-info"
                \ . " " . l:escaped_tempfile
                \ . " " . b:clang_parameters . " " . b:clang_user_options

    let l:clang_output = split(system(l:command), "\n")
    call delete(l:tempfile)
    call s:ClangQuickFix(l:clang_output, l:tempfile)
endfunction

function s:ClangQuickFix(clang_output, tempfname)
    " Clear the bad spell, the user may have corrected them.
    syntax clear SpellBad
    syntax clear SpellLocal
    let l:list = []
    for l:line in a:clang_output
        let l:erridx = match(l:line, '\%(error\|warning\): ')
        if l:erridx == -1
            " Error are always at the beginning.
            if l:line[:11] == 'COMPLETION: ' || l:line[:9] == 'OVERLOAD: '
                break
            endif
            continue
        endif
        let l:pattern = '^\(.*\):\(\d*\):\(\d*\):\(\%({\d\+:\d\+-\d\+:\d\+}\)*\)'
        let l:tmp = matchstr(l:line, l:pattern)
        let l:fname = substitute(l:tmp, l:pattern, '\1', '')
        if l:fname == a:tempfname
            let l:fname = "%"
        endif
        let l:bufnr = bufnr(l:fname, 1)
        let l:lnum = substitute(l:tmp, l:pattern, '\2', '')
        let l:col = substitute(l:tmp, l:pattern, '\3', '')
        let l:errors = substitute(l:tmp, l:pattern, '\4', '')
        if l:line[l:erridx] == 'e'
            let l:text = l:line[l:erridx + 7:]
            let l:type = 'E'
            let l:hlgroup = " SpellBad "
        else
            let l:text = l:line[l:erridx + 9:]
            let l:type = 'W'
            let l:hlgroup = " SpellLocal "
        endif
        let l:item = {
                    \ "bufnr": l:bufnr,
                    \ "lnum": l:lnum,
                    \ "col": l:col,
                    \ "text": l:text,
                    \ "type": l:type }
        let l:list = add(l:list, l:item)

        if g:clang_hl_errors == 0 || l:fname != "%"
            continue
        endif

        " Highlighting the ^
        let l:pat = '/\%' . l:lnum . 'l' . '\%' . l:col . 'c./'
        exe "syntax match" . l:hlgroup . l:pat

        if l:errors == ""
            continue
        endif
        let l:ranges = split(l:errors, '}')
        for l:range in l:ranges
            " Doing precise error and warning handling.
            " The highlight will be the same as clang's carets.
            let l:pattern = '{\%(\d\+\):\(\d\+\)-\%(\d\+\):\(\d\+\)'
            let l:tmp = matchstr(l:range, l:pattern)
            let l:startcol = substitute(l:tmp, l:pattern, '\1', '')
            let l:endcol = substitute(l:tmp, l:pattern, '\2', '')
            " Highlighting the ~~~~
            let l:pat = '/\%' . l:lnum . 'l'
                        \ . '\%' . l:startcol . 'c'
                        \ . '.*'
                        \ . '\%' . l:endcol . 'c/'
            exe "syntax match" . l:hlgroup . l:pat
        endfor
    endfor
    call setqflist(l:list)
    doautocmd QuickFixCmdPost make
    " The following line cause vim to segfault. A patch is ready on vim
    " mailing list but not currently upstream, I will update it as soon
    " as it's upstream. If you want to have error reporting will you're
    " coding, you could open at hand the quickfix window, and it will be
    " updated.
    " http://groups.google.com/group/vim_dev/browse_thread/thread/5ff146af941b10da
    if g:clang_complete_copen == 1
        " We should get back to the original buffer
        " It seems that with this fix, unpatched vim does not crash,
        " which is quite strange...
        let l:bufnr = bufnr("%")
        cwindow
        let l:winbufnr = bufwinnr(l:bufnr)
        exe l:winbufnr . "wincmd w"
    endif
endfunction

function s:DemangleProto(prototype)
    let l:proto = substitute(a:prototype, '[#', "", "g")
    let l:proto = substitute(l:proto, '#]', ' ', "g")
    let l:proto = substitute(l:proto, '#>', "", "g")
    let l:proto = substitute(l:proto, '<#', "", "g")
    " TODO: add a candidate for each optional parameter
    let l:proto = substitute(l:proto, '{#', "", "g")
    let l:proto = substitute(l:proto, '#}', "", "g")

    return l:proto
endfunction

let b:col = 0
function ClangComplete(findstart, base)
    if a:findstart
        let l:line = getline('.')
        let l:start = col('.') - 1
        let l:wsstart = l:start
        if l:line[l:wsstart - 1] =~ '\s'
            while l:wsstart > 0 && l:line[l:wsstart - 1] =~ '\s'
                let l:wsstart -= 1
            endwhile
        endif
        if l:line[l:wsstart - 1] =~ '[(,]'
            let b:should_overload = 1
            let b:col = l:wsstart + 1
            return l:wsstart
        endif
        let b:should_overload = 0
        while l:start > 0 && l:line[l:start - 1] =~ '\i'
            let l:start -= 1
        endwhile
        let b:col = l:start + 1
        return l:start
    else
        let l:buf = getline(1, '$')
        let l:tempfile = expand('%:p:h') . '/' . localtime() . expand('%:t')
        try
            call writefile(l:buf, l:tempfile)
        catch /^Vim\%((\a\+)\)\=:E482/
            return {}
        endtry
        let l:escaped_tempfile = shellescape(l:tempfile)

        let l:command = b:clang_exec . " -cc1 -fsyntax-only"
                    \ . " -fno-caret-diagnostics -fdiagnostics-print-source-range-info"
                    \ . " -code-completion-at=" . l:escaped_tempfile . ":"
                    \ . line('.') . ":" . b:col . " " . l:escaped_tempfile
                    \ . " " . b:clang_parameters . " " . b:clang_user_options
        let l:clang_output = split(system(l:command), "\n")
        call delete(l:tempfile)

        call s:ClangQuickFix(l:clang_output, l:tempfile)
        if v:shell_error
            return {}
        endif
        if l:clang_output == []
            return {}
        endif

        let l:res = []
        for l:line in l:clang_output
            if l:line[:11] == 'COMPLETION: ' && b:should_overload != 1
                let l:value = l:line[12:]

                if l:value !~ '^' . a:base
                    continue
                endif

                " We can do something smarter for Pattern.
                " My idea is to have some sort of snippets.
                " It could be great if it can be done.
                " feedkeys() can be the solution.
                if l:value =~ 'Pattern'
                    if g:clang_snippets != 1
                        continue
                    endif

                    let l:value = l:value[10:]
                endif

                let l:colonidx = stridx(l:value, " : ")
                if l:colonidx == -1
                    let l:word = s:DemangleProto(l:value)
                    let l:proto = l:value
                else
                    let l:word = l:value[:l:colonidx - 1]
                    let l:proto = l:value[l:colonidx + 3:]
                endif

                " WTF is that?
                if l:word =~ '(Hidden)'
                    let l:word = l:word[:-10]
                endif

                let l:wabbr = l:word

                let l:kind = s:GetKind(l:proto)
                let l:proto = s:DemangleProto(l:proto)

            elseif l:line[:9] == 'OVERLOAD: ' && b:should_overload == 1
                        \ && g:clang_snippets == 1

                " The comment on Pattern also apply here.
                let l:value = l:line[10:]
                let l:snip_size = stridx(l:value, '#>') - stridx(l:value, '<#') - 4
                let l:word = substitute(l:value, '.*<#', "", "g")
                let l:word = substitute(l:word, '#>.*', "[SNIP" . l:snip_size . "]", "g")
                let l:wabbr = substitute(l:word, '\[SNIP\d\+\]', "", "g")
                let l:proto = s:DemangleProto(l:value)
                let l:kind = ""

            else
                continue
            endif

            let l:item = {
                        \ "word": l:word,
                        \ "abbr": l:wabbr,
                        \ "menu": l:proto,
                        \ "info": l:proto,
                        \ "dup": 1,
                        \ "kind": l:kind }

            call add(l:res, l:item)
        endfor
        return l:res
    endif
endfunction

function ShouldComplete()
    if (getline(".") =~ '#\s*\(include\|import\)')
        return 0
    else
        return match(synIDattr(synID(line("."), col(".") - 1, 1), "name"),
                    \'\C\<cComment\|\<cCppString\|\<cString') == -1
endfunction

function LaunchCompletion()
    if ShouldComplete()
        return "\<C-X>\<C-U>"
    else
        return ""
    endif
endfunction

function CompleteDot()
    return '.' . LaunchCompletion()
endfunction

function CompleteArrow()
    if getline('.')[col('.') - 2] != '-'
        return '>'
    endif
    return '>' . LaunchCompletion()
endfunction

function CompleteColon()
    if getline('.')[col('.') - 2] != ':'
        return ':'
    endif
    return ':' . LaunchCompletion()
endfunction

function UpdateSnips()
    if pumvisible() != 0
        return ""
    endif
    let l:line = getline(".")
    let l:pattern = '\[SNIP\(\d\+\)\]'
    let l:tmp = matchstr(l:line, l:pattern)
    if l:tmp == ""
        return ""
    endif
    let l:size = substitute(l:tmp, l:pattern, '\1', "g")
    let l:line = substitute(l:line, l:pattern, "", "g")
    let l:cursor_pos = getpos(".")
    let l:cursor_pos[2] -= (len(l:tmp) + 1)
    call setline(".", l:line)
    call setpos(".", l:cursor_pos)

    call feedkeys("\<esc>")
    exe "normal v" . l:size . "h\<C-G>"
endfunction

" May be used in a mapping to update the quickfix window.
function g:ClangUpdateQuickFix()
    call s:DoPeriodicQuickFix()
    return ""
endfunction
