let s:save_cpo = &cpo| set cpo&vim
"=============================================================================
"関数内だと:breakadd func {lnum} {name} と同じ効果。{lnum}と{name}は自動取得さ
"れる
"関数外だと:breakadd here と同じ効果
command! -nargs=0   BreakaddHere    call lcbreak#add()


"関数内だと:breakdel func {lnum} {name} と同じ効果。{lnum}と{name}は自動取得さ
"れる
"関数外だと:breakdel here と同じ効果
command! -nargs=0   BreakdelHere    call lcbreak#del(0)


"その関数内のbreakpointを全削除する
"関数外だとそのソースファイル内のbreakpointを全削除する
command! -nargs=0   BreakdelWhole    call lcbreak#del(1)

"=============================================================================
let &cpo = s:save_cpo| unlet s:save_cpo
