Drawing = require('models/drawing')
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
    
    
    drawing = Drawing.find(@params.d_id)
    palette = Palette.find(drawing.palette_id) 
    
    form = @extractFormData($(event.target)) 
    palette.nodeShapes().create(name: form.name).save()
    
    @back()
  
  cancel: (event) =>
    event.preventDefault()
    @back()
    
  back: =>
    @navigate('/drawings/' + @params.d_id)

  extractFormData: (form) =>
    result = {}
    for key in form.serializeArray()
      result[key.name] = key.value
    result
  
class Palettes extends Spine.Stack
  controllers:
    create: Create

module.exports = Palettes