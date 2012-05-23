# Spine = require('spine')
CanvasRenderer = require('views/canvas_renderer')
Toolbox = require('controllers/toolbox')

PetriNetPalette = require('models/petri_net_palette')
StateMachinePalette = require('models/state_machine_palette')

class Drawings extends Spine.Controller
  constructor: ->
    super
    
    console.log("Loading drawing with id #{@id}")
    @render()
    @createDelegates()
    
  render: ->
    @html require('views/show')
    
  createDelegates: ->
    new StateMachinePalette()
    # new PetriNetPalette()
    new CanvasRenderer(@$('#drawing')[0])
    new Toolbox(el: @$('#toolbox'))
      
module.exports = Drawings
