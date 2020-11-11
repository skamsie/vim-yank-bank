if exists("g:yb_plugin_loaded")
  finish
endif
let g:yb_plugin_loaded = 1

" Return new list in reversed order
function! s:ListReverse(l)
  let new_list = deepcopy(a:l)
  call reverse(new_list)
  return new_list
endfunction

" Copy `register_reference` to first register from `register_list`
" and cycle the rest of the registers in the list by moving
" position to the next one in the list
function! s:PreserveYank(register_list, register_reference)
  let l:keys = a:register_list
  let l:reversed_keys = s:ListReverse(l:keys)

  for i in l:reversed_keys[:-2]
    exe "let @" . i . " = @" . l:keys[index(l:keys, i) - 1]
  endfor

  execute "let @" . l:keys[0] . ' = ' . a:register_reference
endfunction

" Save * register to a global variable (use with FocusLost event);
" on FocusGained we can check if * register is same with g:yb_star_reg and if
" it is, we don't update the custom clipboard registers.
" This is a guard to prevent situations where clipboard is set to 'unnamed',
" vim loses focus, and when it gets focus again, we would update the custom
" clipboard registers even if there was nothing copied
function! s:RememberClip()
  let g:yb_star_reg = @*
endfunction

" Save yanks
function! s:SaveLastYank(register_list)
  if v:event["regname"] == ""
    if v:event["operator"] == "y"
      call s:PreserveYank(a:register_list, '@"')
    endif
  endif
endfunction

" Save system clipboard
function! s:SaveLastClip(register_list)
  if exists("g:yb_star_reg") && g:yb_star_reg != @*
    call s:PreserveYank(a:register_list, '@*')
  endif
endfunction

function! s:YankBankCommand()
  let l:yanks = exists("g:yb_yank_registers") ? join(g:yb_yank_registers) : ""
  let l:clip = exists("g:yb_clip_registers") ? join(g:yb_clip_registers) : ""
  return ":reg(" . join([l:yanks, l:clip]) .")"
endfunction

if exists("g:yb_yank_registers")
  autocmd TextYankPost * call s:SaveLastYank(g:yb_yank_registers)
endif

if exists("g:yb_clip_registers")
  autocmd FocusGained * call s:SaveLastClip(g:yb_clip_registers)
  autocmd FocusLost * call s:RememberClip()
endif

command! YB exec s:YankBankCommand()
