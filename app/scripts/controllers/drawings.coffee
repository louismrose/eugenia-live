# define [
#   'spine'
#   'substack'
#   'models/palette_specification'
#   'models/drawing'
#   'models/commands/commander'
#   'views/drawings/canvas_renderer'
#   'controllers/toolbox'
#   'controllers/selection'
# ], (Spine, SubStack, PaletteSpecification, Drawing, Commander, CanvasRenderer, Toolbox, Selection) ->

define [
  'spine'
  'lib/substack'
  'models/palette_specification'
  'models/drawing',
  'views/drawings/index'
  'spine_route'
], (Spine, SubStack, PaletteSpecification, Drawing, IndexTemplate) ->

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
      @html IndexTemplate(context)
    
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

  # class Show extends Spine.Controller
  #   constructor: ->
  #     super
  #     @active @change
  # 
  #   change: (params) =>
  #     # LoggingCommander = require ('models/commands/logging_commander')
  #     # @commander = new LoggingCommander(new Commander())
  #     @commander = new Commander()
  #     @item = Drawing.find(params.id)
  #     @item.clearSelection()
  #     @log "Palette: #{@item.palette().id}"
  #     @render()
  # 
  #   render: ->
  #     @html require('views/drawings/show')
  #     if @item
  #       new CanvasRenderer(drawing: @item, canvas: @$('#drawing')[0])
  #       @toolbox = new Toolbox(commander: @commander, item: @item, el: @$('#toolbox'))  
  #       @selection = new Selection(commander: @commander, item: @item, el: @$('#selection'))
  # 
  #   deactivate: ->
  #     super
  #     @toolbox.release() if @toolbox

  class Drawings extends SubStack
    controllers:
      index: Index
    
    routes:
      '/drawings'     : 'index'

    default: 'index'
