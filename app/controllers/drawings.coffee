# Spine = require('spine')
PaletteSpecification = require('models/palette_specification')
Drawing = require('models/drawing')

Spine.SubStack = require('lib/substack')
CanvasRenderer = require('views/drawings/canvas_renderer')
Toolbox = require('controllers/toolbox')
Selection = require('controllers/selection')
Commander = require ('models/commands/commander')


class Index extends Spine.Controller
  events:
    'submit form': 'create'
    'click .delete': 'delete'
    
  constructor: ->
    super
    @active @render
  
  render: ->
    context =
      drawings: Drawing.all()
      palette_specs: PaletteSpecification.all()
    @log(context)
    @html require('views/drawings/index')(context)
    
  create: (event) =>
    event.preventDefault()
    
    form = @extractFormData($(event.target)) 
    item = Drawing.create(name: form.name)
    
    if item and item.save()
      palette = PaletteSpecification.find(form.palette_specification_id).instantiate()
      palette.drawing_id = item.id
      palette.save()
      @navigate '/drawings', item.id
    else
      @$('input#name').focus()

  delete: (event) =>
    button = @$(event.currentTarget)
    id = button.data('id')
    Drawing.destroy(id)
    @render()

  extractFormData: (form) =>
    result = {}
    for key in form.serializeArray()
      result[key.name] = key.value
    result

class Show extends Spine.Controller
  constructor: ->
    super
    @active @change
  
  change: (params) =>
    @commander = new Commander()
    @item = Drawing.find(params.id)
    @item.clearSelection()
    @log "Palette: #{@item.palette().id}"
    @render()

  render: ->
    @html require('views/drawings/show')
    if @item
      new CanvasRenderer(drawing: @item, canvas: @$('#drawing')[0])
      @toolbox = new Toolbox(commander: @commander, item: @item, el: @$('#toolbox'))  
      @selection = new Selection(commander: @commander, item: @item, el: @$('#selection'))

  deactivate: ->
    super
    @toolbox.release() if @toolbox

class Drawings extends Spine.SubStack
  controllers:
    index: Index
    show: Show
    
  routes:
    '/drawings'     : 'index'
    '/drawings/:id' : 'show'

  default: 'index'

module.exports = Drawings
