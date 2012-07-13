Drawing = require('models/drawing')
NodeShape = require('models/node_shape')
Palette = require('models/palette')

class Create extends Spine.Controller
  events:
    'submit form': 'create'
    'click #cancel': 'cancel'
    
  constructor: ->
    super
    @active @change
  
  change: (params) ->
    @params = params
    @log(params)
    @render()
  render: ->
    @html require('views/palettes/new')(@params)
  
  deactivate: ->
    super
    @html ''
    
  create: (event) =>
    event.preventDefault()
    
    form = @extractFormData($(event.target)) 
    
    try
      nsData = JSON.parse(form.definition)
      palette = Drawing.find(@params.d_id).palette()
      palette.nodeShapes().create(nsData).save()
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

class Edit extends Spine.Controller
  events:
    'submit form': 'edit'
    'click #cancel': 'cancel'

  constructor: ->
    super
    @active @change

  change: (params) ->    
    @params = params
    palette = Drawing.find(@params.d_id).palette()
    @shape = palette.nodeShapes().find(@params.id)
    @render()

  render: ->
    @html require('views/palettes/edit')(@shape)

  deactivate: ->
    super
    @html ''

  edit: (event) =>
    event.preventDefault()

    form = @extractFormData($(event.target)) 

    try
      nsData = JSON.parse(form.definition)
      @shape.updateAttributes(nsData).save()
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

  
class Palettes extends Spine.Stack
  controllers:
    create: Create
    edit: Edit

module.exports = Palettes