###
  @depend tools/toolbox.js
  @depend renderers/canvas_renderer.js
###
window.onload = ->
  paper.setup($('canvas')[0])

  new grumble.Toolbox().install()
  new grumble.CanvasRenderer().install()
  
  paper.view.draw()
  