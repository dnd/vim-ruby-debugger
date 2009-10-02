" *** WindowWatches class (start)

" Inherits WindowWatches from Window
let s:WindowWatches = copy(s:Window)

let s:WindowWatches.watches_eval = []

" ** Public methods

function! s:WindowWatches.bind_mappings()
  nnoremap <buffer> d :call <SID>window_watches_delete_node()<cr>
endfunction


" Returns string that contains all watches (for Window.display())
function! s:WindowWatches.render() dict
  let watches = ""
  let watches .= self.title . "\n"
  if !g:RubyDebugger.is_running()
    let watches .= "<Server not running. Watches not current.>\n"
  elseif !empty(filter(copy(g:RubyDebugger.watches), "v:val.evaluated == 0"))
    call s:send_watches_for_eval()
  endif
  let id = 1
  for watch in g:RubyDebugger.watches
    let watches .= watch.render()
    let id += 1
  endfor
  return watches
endfunction

" Sends the watches for evaluation
function s:send_watches_for_eval()
  call g:RubyDebugger.logger.put("Watches to evaluate: " . len(g:RubyDebugger.watches))
  let l:to_eval = "vrd_watches = ["
  for watch in g:RubyDebugger.watches
    call g:RubyDebugger.logger.put("Eval watch: " . watch.expr)
    let l:to_eval .= "\"" . substitute(watch.expr, '\"', '\\"', "g") . "\", "
  endfor
  let l:to_eval = strpart(l:to_eval, 0, strlen(l:to_eval) - 2)
  let l:to_eval .= "].inject([]) {|r, e| r << "
        \. "begin\\n"
        \. "x = eval(e).inspect\\n"
        \. "rescue => e\\ne.to_s end}"
        "if x.nil? then '|vrd_nil|'\\n"
        "elsif x.is_a?(Numeric) or x.is_a?(String) then x\\n"
        "elsif x.is_a?(TrueClass) or x.is_a?(FalseClass) or x.is_a?(Symbol) then 
        "\"|vrd_#{x.inspect}|\"\\n"
        "else x.inspect\\n"
        "end\\n"
  call g:RubyDebugger.logger.put("Sending watches for evaluation: " . l:to_eval)
  call g:RubyDebugger.eval(l:to_eval)
endfunction


" Sets the eval results received from the server
function! s:WindowWatches.set_watches_eval(raw) dict
  call self._log("Received watches eval: " . a:raw)
  let results = eval(a:raw)
  let id = 0
  for result in results
    let g:RubyDebugger.watches[id].value = result
    let g:RubyDebugger.watches[id].evaluated = 1
    let id += 1
  endfor
  call s:watches_window.open()
endfunction


" Delete watch under cursor
function! s:window_watches_delete_node()
  let id = s:window_watches_get_selected_id()
  call g:RubyDebugger.logger.put("Preparing to delete watch id: " . id)
  if id > 0
    call g:RubyDebugger.remove_watch(id)
  endif
endfunction

" Gets the selected watch
function! s:window_watches_get_selected_id()
  let line = getline(".") 
  let match = matchlist(line, '^\(\d\+\)') 
  return get(match, 1)
endfunction


" Add syntax highlighting
function! s:WindowWatches.setup_syntax_highlighting() dict
    execute "syn match rdebugTitle #" . self.title . "#"

    syn match rdebugId "^\d\+\s" contained nextgroup=rdebugDebuggerId
    syn match rdebugDebuggerId "\d*\s" contained nextgroup=rdebugFile
    syn match rdebugFile ".*:" contained nextgroup=rdebugLine
    syn match rdebugLine "\d\+" contained

    syn match rdebugWrapper "^\d\+.*" contains=rdebugId transparent

    hi def link rdebugId Directory
    hi def link rdebugDebuggerId Type
    hi def link rdebugFile Normal
    hi def link rdebugLine Special
endfunction


" *** WindowWatches class (end)


