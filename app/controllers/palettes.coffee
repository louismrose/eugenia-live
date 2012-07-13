Drawing = require('models/drawing')
NodeShape = require('models/node_shape')
LinkShape = require('models/link_shape')
Palette = require('models/palette')

class JsonNotation
  serialise: (item) ->
    JSON.stringify(item, null, 2)
    
  deserialise: (definition) ->
    JSON.parse(definition)

class EugeniaNotation
  serialise: (item) ->
    if item.elements
       @serialiseNode(item)
    else
       @serialiseLink(item)
  
  serialiseNode: (item) ->
    properties = ''
    
    if item.elements.length > 0
      e = item.elements[0]
      e.borderColor or= 'black'
      e.fillColor or= 'white'
      e.figure or= 'rectangle'
      e.size or= {width: 10, height: 10}
      
      properties = "border.color=\"#{e.borderColor}\", " +
                   "color=\"#{e.fillColor}\", " +
                   "figure=\"#{e.figure}\", " +
                   "size=\"#{e.size.width},#{e.size.height}\""
    
    """
    @gmf.node(#{properties})
    class #{item.name} {
    }
    """
  
  serialiseLink: (item) ->
    item.style or= "solid"
    item.color or= "black"
    
    """
    @gmf.link(style="#{item.style}", color="#{item.color}")
    class #{item.name} {
      
    }
    """
  
  deserialise: (definition) ->
    if definition.match(/@gmf.node/)
      @deserialiseNode(definition)
    else
      @deserialiseLink(definition)
  
  deserialiseNode: (definition) ->
    node = {}
    node.name = @deserialiseName(definition)
    
    properties = @deserialiseProperties(definition)
    
    if properties['border.color']
      properties.borderColor = properties['border.color']
      delete properties['border.color']
      
    if properties.color
      properties.fillColor = properties.color
      delete properties.color
      
    if properties.size
      [width, height] = properties.size.split(",")[0..1]
      properties.size =
        width: parseInt(width)
        height: parseInt(height)
    
    node.elements = [properties]
    
    console.log(node)
    node
    
  deserialiseLink: (definition) ->
    link = @deserialiseProperties(definition)
    link.name = @deserialiseName(definition)
    link
    
  deserialiseName: (definition) ->
    class_pattern = /class\s+(\w*)/
    definition.match(class_pattern)[1]
    
  deserialiseProperties: (definition) ->
    result = {}
    
    properties_pattern = /@gmf\.\w*\((.*)\)/
    properties = definition.match(properties_pattern)[1]
    for property in properties.split(', ')
      property_pattern = /([^=]*)="([^"]*)"/
      [key, value] = property.match(property_pattern)[1..2]
      result[key] = value
    
    result
    


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
      verb: @constructor.name
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
  node: =>
    new NodeShape(name: "TheNode", elements: [{}], palette_id: @palette.id)
    
  link: =>
    new LinkShape(name: "TheLink", palette_id: @palette.id)


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