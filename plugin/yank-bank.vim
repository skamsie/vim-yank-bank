" return new list in reversed order
function! s:ListReverse(l)
  let new_list = deepcopy(a:l)
  call reverse(new_list)
  return new_list
endfunction

" copy `register_reference` to first register from `register_list`
" and cycle the rest of registers by moving position to the next
" one in the list
function! s:PreserveYank(register_list, register_reference)
  let l:keys = a:register_list
  let l:reversed_keys = s:ListReverse(l:keys)

  for i in l:reversed_keys[:-2]
    exe "let @" . i . " = @" . l:keys[index(l:keys, i) - 1]
  endfor

  execute "let @" . l:keys[0] . ' = ' . a:register_reference
endfunction

" save yanks
function! s:SaveLastYank(register_list)
  if v:event["regname"] == ""
    if v:event["operator"] == "y"
      call s:PreserveYank(a:register_list, '@"')
    endif
  endif
endfunction

" save system clipboard
function! s:SaveLastClip(register_list)
  call s:PreserveYank(a:register_list, '@*')
endfunction

augroup yb_yanks
  if exists("g:yb_yank_registers")
    autocmd!
    autocmd TextYankPost * call s:SaveLastYank(g:yb_yank_registers)
  endif
augroup END

augroup yb_clip
  if exists("g:yb_clip_registers")
    autocmd!
    autocmd FocusGained * call s:SaveLastClip(g:yb_clip_registers)
  endif
augroup END
