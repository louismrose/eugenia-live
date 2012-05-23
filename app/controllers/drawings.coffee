# Spine = require('spine')
Drawing = require('models/drawing')
Node = require('models/node')
Link = require('models/link')

CanvasRenderer = require('views/canvas_renderer')
Toolbox = require('controllers/toolbox')

PetriNetPalette = require('models/petri_net_palette')
StateMachinePalette = require('models/state_machine_palette')

class Drawings extends Spine.Controller
  constructor: ->
    super

    Drawing.fetch()
    Node.fetch()
    Link.fetch()
    
    @item = Drawing.findOrCreate(@id)
    console.log("Loading drawing #{@item}, which has #{@item.nodes().all().length} nodes and #{@item.links().all().length} links")
    
    @render()
    @createDelegates()
    
    
  render: ->
    @html require('views/show')
    
  createDelegates: ->
    new StateMachinePalette()
    # new PetriNetPalette()
    new CanvasRenderer(drawing: @item, canvas: @$('#drawing')[0])
    new Toolbox(item: @item, el: @$('#toolbox'))
    
  release: ->
    console.log("Released drawing with id=#{@id}")
    super
      
module.exports = Drawings
