###
  @depend tools/toolbox.js
###
window.onload = ->
  paper.setup($('canvas')[0])      
  paper.view.draw()

  new grumble.Toolbox().install()
