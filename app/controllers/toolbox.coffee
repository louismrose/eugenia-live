Spine = require('spine')
LinkTool = require('controllers/link_tool')
NodeTool = require('controllers/node_tool')
SelectTool = require('controllers/select_tool')
NodeShape = require ('models/node_shape')
LinkShape = require ('models/link_shape')

class Toolbox extends Spine.Controller
  events:
    "click a[data-tool-name]": "reactToToolSelection"
    "dblclick a": "showEditor"
  
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
      @html require('views/drawings/toolbox')(@item)
  
  showEditor: (event) =>
    link = $(event.currentTarget)
    toolName = link.data('toolName')
    
    unless toolName is 'select'
      @navigate("/palettes/#{@item.palette_id}/#{toolName}s/#{link.data('toolShape')}")
  
  reactToToolSelection: (event) =>
    link = $(event.currentTarget)

    @switchTo(link.data('toolName'))
    @currentTool.setParameter('shape', link.data('toolShape'))
    
    $("li.active").removeClass("active")
    link.parent().addClass("active")
    event.preventDefault()
    
  switchTo: (toolName) =>
    throw "There is no tool named '#{toolName}'" unless @tools[toolName]
    @currentTool = @tools[toolName]
    @currentTool.activate()

    
module.exports = Toolbox