require('lib/setup')

# Spine = require('spine')
CanvasRenderer = require ('views/canvas_renderer')
Toolbox = require ('controllers/toolbox')

class App extends Spine.Controller
  constructor: ->
    super

    new CanvasRenderer($('canvas')[0])
    new Toolbox(el: $('#toolbox'))
      
module.exports = App
    