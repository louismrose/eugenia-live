require('lib/setup')

# Spine = require('spine')
CanvasRenderer = require ('views/canvas_renderer')
Toolbox = require ('controllers/toolbox')

Array::remove = (e) -> @[t..t] = [] if (t = @indexOf(e)) > -1

class App extends Spine.Controller
  constructor: ->
    super

    @log('hello!')

    window.onload = ->
      paper.setup($('canvas')[0])
    
      new CanvasRenderer().install()
      new Toolbox().install()
    
      paper.view.draw()
      
module.exports = App
    