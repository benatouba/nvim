" YAML plus Jinja regions, with no archived plugin or extra parser required.
if exists('b:current_syntax')
  finish
endif
runtime! syntax/yaml.vim
unlet! b:current_syntax

syntax keyword slsJinjaKeyword contained if elif else endif for endfor in set endset with endwith from import include macro endmacro call endcall filter endfilter do load_yaml endload load_json load_text import_yaml import_json import_text as block endblock extends not and or is recursive
syntax keyword slsJinjaConstant contained true false none True False None
syntax keyword slsJinjaSalt contained salt pillar grains opts config
syntax match slsJinjaFilter contained /|\s*\zs[a-zA-Z_][a-zA-Z0-9_]*/
syntax region slsJinjaString contained start=+'+ skip=+\\.+ end=+'+
syntax region slsJinjaString contained start=+"+ skip=+\\.+ end=+"+
syntax region slsJinjaExpression matchgroup=slsJinjaDelimiter start=+{{-\?+ end=+-\?}}+ contains=slsJinjaKeyword,slsJinjaConstant,slsJinjaSalt,slsJinjaFilter,slsJinjaString containedin=ALL
syntax region slsJinjaStatement matchgroup=slsJinjaDelimiter start=+{%-\?+ end=+-\?%}+ contains=slsJinjaKeyword,slsJinjaConstant,slsJinjaSalt,slsJinjaFilter,slsJinjaString containedin=ALL
syntax region slsJinjaComment start=+{#-\?+ end=+-\?#}+ containedin=ALL
syntax match slsRenderer /^#!.*/

highlight default link slsJinjaKeyword Statement
highlight default link slsJinjaConstant Constant
highlight default link slsJinjaSalt Identifier
highlight default link slsJinjaFilter Function
highlight default link slsJinjaString String
highlight default link slsJinjaDelimiter PreProc
highlight default link slsJinjaComment Comment
highlight default link slsRenderer PreProc
let b:current_syntax = 'sls'
