
let s:Watch = {}
let s:watch_counter = 0

" ** Public methods

" Constructor of new watch. 
function! s:Watch.new(expr)
  let var = copy(self)
  let var.expr = a:expr
  let var.value = ""
  let var.evaluated = 0
  let s:watch_counter += 1
  let var.id = s:watch_counter
  return var
endfunction


" Sets the value for the watch expression
function! s:Watch.set_value(val) dict
  let self.value = a:val
  let self.evaluated = 1
endfunction

" Renders the watch
function! s:Watch.render() dict
  let val = self.evaluated ? self.value : "<NOT EVALUATED>"
  return self.id . " " . self.expr . " = " . val . "\n"
endfunction
