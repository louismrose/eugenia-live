Drawing = require('models/drawing')
NodeShape = require('models/node_shape')
Palette = require('models/palette')

class Define extends Spine.Controller
  events:
    'submit form': 'define'
    'click #cancel': 'cancel'
    
  constructor: ->
    super
    @active @change
  
  change: (params) ->
    @params = params
    @palette = Drawing.find(@params.d_id).palette()
    @render()
    
  render: ->
    context =
      item: @item()
      verb: @constructor.name
    @html require('views/palettes/define')(context)
  
  deactivate: ->
    super
    @html ''
    
  define: (event) =>
    event.preventDefault()
    
    form = @extractFormData($(event.target)) 
    
    try
      nsData = JSON.parse(form.definition)
      @item().updateAttributes(nsData).save()
      @back()
    catch error
      @log(error.message)
  
  cancel: (event) =>
    event.preventDefault()
    @back()
    
  back: =>
    @deactivate()
    @navigate('/drawings/' + @params.d_id)

  extractFormData: (form) =>
    result = {}
    for key in form.serializeArray()
      result[key.name] = key.value
    result


class Create extends Define
  item: =>
    @_item ?= new NodeShape(name: "", elements: [{}], palette_id: @palette.id)


class Update extends Define  
  item: =>
    @_item ?= @palette.nodeShapes().find(@params.id)


class Palettes extends Spine.Stack
  controllers:
    create: Create
    edit: Update

module.exports = Palettes