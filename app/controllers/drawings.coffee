# Spine = require('spine')
Drawing = require('models/drawing')
Node = require('models/node')
Link = require('models/link')

CanvasRenderer = require('views/canvas_renderer')
Toolbox = require('controllers/toolbox')

PetriNetPalette = require('models/petri_net_palette')
StateMachinePalette = require('models/state_machine_palette')

class Index extends Spine.Controller
  events:
    'click #new': 'create'
    
  constructor: ->
    super
    @active @render
  
  render: ->
    @html require('views/index')(drawings: Drawing.all())
  
  deactivate: ->
    super
    @html ''
    
  create: ->
    item = Drawing.create()
    @navigate '/drawings', item.id


class Show extends Spine.Controller
  constructor: ->
    super
    @active @change
  
  change: (params) =>
    @item = Drawing.find(params.id)
    console.log "Showing drawing #{@item}, which has #{@item.nodes().all().length} nodes and #{@item.links().all().length} links"
    @render()

  render: ->
    @html require('views/show')
    if @item
      new CanvasRenderer(drawing: @item, canvas: @$('#drawing')[0])
      new Toolbox(item: @item, el: @$('#toolbox'))  

  deactivate: ->
    super
    @html ''

class Drawings extends Spine.Stack
  controllers:
    index: Index
    show: Show
  
  constructor: ->
    super

    Drawing.fetch()
    Node.fetch()
    Link.fetch()
    new StateMachinePalette()
    # new PetriNetPalette()
    

module.exports = Drawings
