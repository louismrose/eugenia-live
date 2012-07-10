# Spine = require('spine')
PaletteSpecification = require('models/palette_specification')
Palette = require ('models/palette')
Drawing = require('models/drawing')
Node = require('models/node')
Link = require('models/link')

CanvasRenderer = require('views/drawings/canvas_renderer')
Toolbox = require('controllers/toolbox')


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
    @html require('views/drawings/index')(context)
  
  deactivate: ->
    super
    @html ''
    
  create: (event) =>
    event.preventDefault()
    
    form = @extractFormData($(event.target)) 
    palette = PaletteSpecification.find(form.palette_specification_id).instantiate()
    item = palette.drawings().create(name: form.name)
    
    if item and item.save()
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
    @item = Drawing.find(params.id)
    @log "Palette: #{@item.palette_id}"
    @render()

  render: ->
    @html require('views/drawings/show')
    if @item
      new CanvasRenderer(drawing: @item, canvas: @$('#drawing')[0])
      @toolbox = new Toolbox(item: @item, el: @$('#toolbox'))  

  deactivate: ->
    super
    @html ''
    @toolbox.release() if @toolbox

class Drawings extends Spine.Stack
  controllers:
    index: Index
    show: Show
  
  constructor: ->
    super

    PaletteSpecification.fetch()
    Palette.fetch()
    Drawing.fetch()
    Node.fetch()
    Link.fetch()    

module.exports = Drawings
