let s:save_cpo = &cpo| set cpo&vim
"=============================================================================
"指定のファイルのscript idを返す
"EX: ec s:get_script_id('%') #=> 14
function! s:get_script_id(path) "{{{
  let scriptfs = split(s:_redir('scriptnames'), "\n")
  for s in scriptfs
    let [id, path] = s:__get_script_id8path(s)
    Vee1, [id, path]
    if path =~# fnamemodify(expand(a:path), ':p:gs?\\?/?')
      return id
    endif
  endfor
endfunction
"}}}
function! s:_redir(cmd) "{{{
  let save_vfile = &verbosefile
  set verbosefile=
  redir => res
    silent! execute a:cmd
  redir END
  let &verbosefile = save_vfile
  return res
endfunction
"}}}
function! s:__get_script_id8path(script_info_line) "{{{
  let p = matchlist(a:script_info_line, '^\s*\(\d\+\):\s*\(.*\)$')
  if empty(p)
    return [0, '']
  endif
  let [id, path] = p[1 : 2]
  let path = fnamemodify(path, ':p:gs?\\?/?')
  return [id, path]
endfunction
"}}}

"======================================
"SIDからpathを返す
function! s:get_script_path(sid) "{{{
  let scriptfs = split(s:_redir('scriptnames'), "\n")
  for s in scriptfs
    let [id, path] = s:__get_script_id8path(s)
    if id == a:sid
      return path
    endif
  endfor
endfunction
"}}}

"=============================================================================
"設置されているsignの[lnum,id,name]を収めたリストを返す。a:bufnrが0で全てのバッファ。
"EX: gv_lnum8id8name_ofSign(0) #=> [[40, '333', 'SearchStart']]
"NOTE: そのsignがどのバッファにあるのかを教えてくれない
function! s:gv_lnum8id8name_ofSign(_bufnr) "{{{
  if a:_bufnr
    let signplace = s:_redir('sign place buffer='. a:bufnr)
  else
    let signplace = s:_redir('sign place')
  endif
  redir END
  let signplacelist = split(signplace, '\n')
  call map(signplacelist, 'matchlist(v:val, ''=\(\d\+\).\+=\(\d\+\).\+=\(\S\+\)'')[1:3]')
  call filter(signplacelist, '!empty(v:val)')
  for picked in signplacelist
    let picked[0] = str2nr(picked[0])
  endfor
  return signplacelist
endfun "}}}

"=============================================================================
"指定したhighlightを取得する
"EX: gs_highlight_define('DiffAdd') #=> DiffAdd     term=bold guibg=DarkBlue
function! s:gs_highlight_define(hi_group_name) "{{{
  let hl = s:_redir('hi '. a:hi_group_name)
  let hl = substitute(hl, '[\r\n]', '', 'g')
  let hl = substitute(hl, 'xxx', '', '')
  return hl
endfunction "}}}

"=============================================================================
"viminfoファイルが作られるpathを取得する
function! s:get_viminfoPath() "{{{
  return substitute(&vi, '^.\{-1,}n', '', '')
endfunction
"}}}

"=============================================================================
let &cpo = s:save_cpo| unlet s:save_cpo
