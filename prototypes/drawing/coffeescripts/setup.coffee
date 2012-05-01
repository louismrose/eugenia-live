###
  @depend tools/toolbox.js
  @depend models/node.js
###
window.onload = ->
  paper.setup($('canvas')[0])

  new grumble.Toolbox().install()
  new grumble.NodesRenderer
  
  paper.view.draw()
  