window.onload = ->
  paper.setup($('canvas')[0])      
  paper.view.draw()

  paper.toolbox = new paper.Toolbox()
  paper.toolbox.install()
