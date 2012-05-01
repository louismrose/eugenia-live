###
  @depend tools/toolbox.js
  @depend renderers/canvas_renderer.js
###
Array::remove = (e) -> @[t..t] = [] if (t = @indexOf(e)) > -1

window.onload = ->
  paper.setup($('canvas')[0])

  new grumble.CanvasRenderer().install()
  new grumble.Toolbox().install()
  
  paper.view.draw()
  