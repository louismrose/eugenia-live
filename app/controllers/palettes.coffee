JsonNotation = require("controllers/notations/json_notation")
EugeniaNotation = require("controllers/notations/eugenia_notation")

Drawing = require('models/drawing')
NodeShape = require('models/node_shape')
LinkShape = require('models/link_shape')
Palette = require('models/palette')

class Define extends Spine.Controller
  events:
    'submit form': 'define'
    'click [data-notation]' : 'changeNotation'
    'click #delete': 'delete'
    'click #cancel': 'cancel'
  
  constructor: ->
    super
    @notations = 
      json: new JsonNotation
      eugenia: new EugeniaNotation
    @notation = 'json'
    @active @change
  
  currentNotation: =>
    @notations[@notation]
  
  change: (params) ->
    @params = params
    @type = @params.type[0..-2]
    @palette = Drawing.find(@params.d_id).palette()
    @render()

  changeNotation: (event) =>
    event.preventDefault()
    @notation = $(event.target).data('notation')
    @render()
  
  render: ->
    context = 
      serialisation: @currentNotation().serialise(@safe(@item()))
      example: @currentNotation().serialise(@safe(@example()))
      verb: @verb()
      type: @type
      notation: @notation
    @html require('views/palettes/define')(context)
  
  safe: (o) =>
    @removeIds(o.toJSON())
  
  item: =>
    if @type is 'node'
      @_item ?= @node()
    else
      @_item ?= @link()
      
  example: =>
    if @type is 'node'
      @_example ?= @example_node()
    else
      @_example ?= @example_link()
  
  example_node: =>
    new NodeShape
      name: "InitialState"
      elements: [
        "figure": "circle",
        "size": {"width": 10, "height": 10},
        "fillColor": "white",
        "borderColor": "black"
      ]
  
  example_link: =>
    new LinkShape
      name: "Link"
      color: "gray"
      style: "dashed"
  
  deactivate: ->
    super
    @html ''
    @_item = null
    
  define: (event) =>
    event.preventDefault()
    
    form = @extractFormData($(event.target)) 
    
    try
      nsData = @removeIds(@currentNotation().deserialise(form.definition))      
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
  verb: =>
    "Create"
  
  node: =>
    new NodeShape(name: "TheNode", elements: [{}], palette_id: @palette.id)
    
  link: =>
    new LinkShape(name: "TheLink", palette_id: @palette.id)


class Update extends Define      
  verb: =>
    "Update"
  
  node: =>
    @palette.nodeShapes().find(@params.id)

  link: =>
    @palette.linkShapes().find(@params.id)


class Show extends Spine.Controller
  constructor: ->
    super
    @active @change

  change: (params) =>
    @item = Palette.find(params.id)
    @render()

  render: ->
    context =
      eugenia: new EugeniaNotation().serialisePalette(@item)

    @html require('views/palettes/show')(context)

  deactivate: ->
    super
    @html ''

class Palettes extends Spine.Stack
  controllers:
    create: Create
    edit: Update
    show: Show

module.exports = Palettes