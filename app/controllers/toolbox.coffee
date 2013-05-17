Spine = require('spine')
LinkTool = require('controllers/link_tool')
NodeTool = require('controllers/node_tool')
SelectTool = require('controllers/select_tool')
NodeShape = require ('models/node_shape')
LinkShape = require ('models/link_shape')
Commander = require ('models/commands/commander')

class Toolbox extends Spine.Controller
  events:
    "click a[data-tool-name]": "reactToToolSelection"
    "dblclick a": "showEditor"
  
  constructor: ->
    super
    @render()
    commander = new Commander()
    @tools =
      node:   new NodeTool(commander: commander, drawing: @item)
      select: new SelectTool(commander: commander, drawing: @item)
      link:   new LinkTool(commander: commander, drawing: @item)
    @switchTo("select")
    
  render: =>
    @html require('views/drawings/toolbox')(@item) if @item
  
  showEditor: (event) =>
    event.preventDefault()
    link = $(event.currentTarget)
    toolName = link.data('toolName')
    
    unless toolName is 'select'
      @navigate("/drawings/#{@item.id}/#{toolName}s/#{link.data('toolShape')}")
  
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