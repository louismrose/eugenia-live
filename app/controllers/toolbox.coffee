Spine = require('spine')
LinkTool = require('controllers/link_tool')
NodeTool = require('controllers/node_tool')
SelectTool = require('controllers/select_tool')
NodeShape = require ('models/node_shape')
LinkShape = require ('models/link_shape')

class Toolbox extends Spine.Controller
  events:
    "click a": "reactToToolSelection" 
  
  constructor: ->
    super
    @render()
    @tools =
      node:   new NodeTool(drawing: @item)
      select: new SelectTool(drawing: @item)
      link:   new LinkTool(drawing: @item)
    @switchTo("node")
    
  render: =>
    if @item
      # FIXME:
      #  it should be possible to use @item.palette() 
      #  rather than the following two lines, but this
      #  doesn't seem to work?
      Palette = require('models/palette')
      palette = Palette.find(@item.palette_id)
      
      @html require('views/toolbox')(palette)
  
  reactToToolSelection: (event) =>
    link = $(event.currentTarget)

    @switchTo(link.data('toolName'))
    @configureCurrentToolWith("shape", link.data('toolShape'))
    
    $("li.active").removeClass("active")
    link.parent().addClass("active")
    event.preventDefault()
    
  switchTo: (toolName) =>
    throw "There is no tool named '#{toolName}'" unless @tools[toolName]
    @currentTool = @tools[toolName]
    @currentTool.activate()
  
  configureCurrentToolWith: (parameterKey, parameterValue) =>
    @currentTool.setParameter(parameterKey, parameterValue)
    
module.exports = Toolbox