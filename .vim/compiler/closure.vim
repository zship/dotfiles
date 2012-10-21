if exists("current_compiler")
  finish
endif
 
let current_compiler = "closure"
 
" java -jar /home/zach/closure-compiler.jar --warning_level=VERBOSE --jscomp_error=checkTypes --jscomp_error=accessControls --jscomp_off=checkVars --jscomp_off=missingProperties
setlocal makeprg=java\ -jar\ /home/zach/closure-compiler.jar\ --js=%:p\ --warning_level=VERBOSE\ --jscomp_error=checkTypes\ --jscomp_error=accessControls\ --jscomp_off=checkVars\ --jscomp_off=missingProperties
setlocal errorformat=%E%f:%l:\ %m,%-Z%p^,%-C%.%#,%-G%.%#
