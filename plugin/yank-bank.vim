if exists('g:yank_bank_loaded') || &cp
  finish
endif
let g:yank_bank_loaded = 1

function! s:ListReverse(l)
  let new_list = deepcopy(a:l)
  call reverse(new_list)
  return new_list
endfunction

function! s:SaveLastYank()
  if v:event["regname"] == ""
    if v:event["operator"] == "y"
      let l:keys = ["j", "k", "l"]
      let l:reversed_keys = s:ListReverse(l:keys)

      for i in l:reversed_keys[:-2]
        exe "let @" . i . " = @" . l:keys[index(l:keys, i) - 1]
      endfor

      execute "let @" . l:keys[0] . ' = @"'
    endif
  endif
endfunction

function! s:SaveLastClip()
  let l:keys = ["a", "b", "c"]
  let l:reversed_keys = s:ListReverse(l:keys)

  for i in l:reversed_keys[:-2]
    exe "let @" . i . " = @" . l:keys[index(l:keys, i) - 1]
  endfor

  execute "let @" . l:keys[0] . " = @*"
endfunction

autocmd TextYankPost * call s:SaveLastYank()
autocmd FocusGained * call s:SaveLastClip()
