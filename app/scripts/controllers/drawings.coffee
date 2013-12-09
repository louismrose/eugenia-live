define [
  'spine'
  'lib/substack'
  'models/palette_specification'
  'models/drawing'
  'models/commands/commander'
  'views/drawings/index'
  'views/drawings/show'
  'views/drawings/canvas_renderer'
  'controllers/toolbox'
  'controllers/selection'
], (Spine, SubStack, PaletteSpecification, Drawing, Commander, IndexTemplate, ShowTemplate, CanvasRenderer, Toolbox, Selection) ->

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
      @html IndexTemplate(context)
      $('[data-toggle=popover]').popover()
    
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
      drawing = Drawing.find(id)
      if confirm("Are you sure you want delete drawing '#{drawing.name}'?")
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
      # LoggingCommander = require ('models/commands/logging_commander')
      # @commander = new LoggingCommander(new Commander())
      @commander = new Commander()
      @item = Drawing.find(params.id)
      @item.clearSelection()
      @log "Palette: #{@item.palette().id}"
      @render()
  
    render: ->
      #[THANOS]: In order to have access to the name of the drawings and other information related to them we have to pass the context argument
      #to the Template of the Show.eco file. This is done with the following lines.
      context2 =
        drawings: @item
      #[THANOS]: It was @html ShowTemplate
      @html ShowTemplate(context2)

      if @item
        new CanvasRenderer(drawing: @item, canvas: @$('#drawing')[0])
        @toolbox = new Toolbox(commander: @commander, item: @item, el: @$('#toolbox'))
        `myToolbox = this.toolbox;`
        @selection = new Selection(commander: @commander, item: @item, el: @$('#selection'))

  
    deactivate: ->
      super
      @toolbox.release() if @toolbox

  class Drawings extends SubStack
    controllers:
      index: Index
      show: Show
    
    routes:
      '/drawings'     : 'index'
      '/drawings/:id' : 'show'

    default: 'index'
