Drawing = require('models/drawing')
NodeShape = require('models/node_shape')
LinkShape = require('models/link_shape')
Palette = require('models/palette')

class Define extends Spine.Controller
  events:
    'submit form': 'define'
    'click #delete': 'delete'
    'click #cancel': 'cancel'
    
  constructor: ->
    super
    @active @change
  
  change: (params) ->
    @params = params
    @type = @params.type[0..-2]
    @palette = Drawing.find(@params.d_id).palette()
    @render()
    
  render: ->
    context = 
      json: @json()
      verb: @constructor.name
      type: @type
    @html require('views/palettes/define')(context)
  
  json: =>
    JSON.stringify(@removeIds(@item().toJSON()), null, 2)
  
  item: =>
    if @type is 'node'
      @_item ?= @node()
    else
      @_item ?= @link()
  
  deactivate: ->
    super
    @html ''
    @_item = null
    
  define: (event) =>
    event.preventDefault()
    
    form = @extractFormData($(event.target)) 
    
    try
      nsData = @removeIds(JSON.parse(form.definition))      
      @item().updateAttributes(nsData).save()
      @back()
    catch error
      @log(error.message)
  
  delete: (event) =>
    event.preventDefault()
    @item().destroy()
    @back()
  
  cancel: (event) =>
    event.preventDefault()
    @back()
    
  back: =>
    @deactivate()
    @navigate('/drawings/' + @params.d_id)

  removeIds: (o) =>
    delete o.id
    delete o.palette_id
    o

  extractFormData: (form) =>
    result = {}
    for key in form.serializeArray()
      result[key.name] = key.value
    result


class Create extends Define
  node: =>
    new NodeShape(name: "", elements: [{}], palette_id: @palette.id)

  link: =>
    new LinkShape(name: "", palette_id: @palette.id)

class Update extends Define      
  node: =>
    @palette.nodeShapes().find(@params.id)

  link: =>
    @palette.linkShapes().find(@params.id)

class Palettes extends Spine.Stack
  controllers:
    create: Create
    edit: Update

module.exports = Palettes