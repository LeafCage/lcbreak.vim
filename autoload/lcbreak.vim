let s:save_cpo = &cpo| set cpo&vim
"=============================================================================
let s:V = vital#of('lcbreak')
let s:LI = s:V.import('Lclib.Info')
function! lcbreak#add() "{{{
  let funcbgn = s:__ret_funcbgn()
  if !funcbgn
    breakadd here
    call s:__add_finaly()
    return
  endif
  let funcname = s:__get_funcname(getline(funcbgn))
  exe 'breakadd func '. (line('.') - funcbgn). ' '. funcname
  call s:__add_finaly()
endfunction
"}}}
function! s:__ret_funcbgn() "{{{
  let funcbgn = search('^\s*\<fu\%[nction]\>', 'bcnW', search('^\s*\<endf\%[unction]\>', 'bcnW'))
  if funcbgn > 0
    return funcbgn
  endif
endfunction
"}}}
function! s:__get_funcname(str) "{{{
  let funcname = matchstr(a:str, '^\s*fu\%[nction]!\?\s\+\zs\S.\+', '', '')
  let funcname = matchstr(funcname, '^\([[:alnum:]_#:]\|\({.\+}\|<SID>\)\)\+\ze(')
  if funcname =~? '^s:\|^<SID>'
    let id = s:LI.get_script_id(expand('%:p'))
    let funcname = substitute(funcname, '^s:\|^<SID>', '<SNR>'. id. '_', '')
  endif
  return funcname
endfunction
"}}}
function! s:__add_finaly() "{{{
  let breaklists = split(s:_redir('breaklist'), "\n")
  let nr = matchstr(breaklists[-1], '^\s*\zs\d\+')
  ec 'break '. nr. ' を設置しました。breakdel '. nr. ' で削除できます。'
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

"=============================================================================
function! lcbreak#del(_whole) "{{{
  let funcbgn = s:__ret_funcbgn()
  let lnum = a:_whole ? '' : funcbgn ? line('.')-funcbgn : line('.')
  if !funcbgn
    exe 'breakdel file '. lnum. ' '. expand('%:p')
    return
  endif
  let funcname = s:__get_funcname(getline(funcbgn))
  exe 'breakdel func '. lnum. ' '. funcname
endfunction
"}}}


"=============================================================================
let &cpo = s:save_cpo| unlet s:save_cpo
