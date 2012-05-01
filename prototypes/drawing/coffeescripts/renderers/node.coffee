###
  @depend ../namespace.js
###
class grumble.NodesRenderer

  constructor: ->
    grumble.Node.bind("refresh", @addAllNodes)
    grumble.Link.bind("refresh", @addAllLinks)
    grumble.Node.bind("create", @addOne)
    grumble.Link.bind("create", @addOne)
    grumble.Node.fetch()
    grumble.Link.fetch()
    
  addOne: (element) =>
    console.log("one element added")
    new grumble.NodeRenderer(element).render()
  
  addAllNodes: =>
    console.log("adding all " + grumble.Node.count() + " nodes")
    grumble.Node.each(@addOne)
    
  addAllLinks: =>
    console.log("adding all " + grumble.Link.count() + " links")
    grumble.Link.each(@addOne)
    

class grumble.NodeRenderer
  item: null
  el: null

  constructor: (item) ->
    @item = item
    @item.bind("update", @render)
    @item.bind("destroy", @remove)

  render: =>
    console.log("rendering " + @item)
    
    # TODO Replace with inheritance?
    if @item instanceof grumble.Node
      @renderNode()
    else
      @renderLink()
  
  renderNode: =>
    switch @item.shape
      when "rectangle" then @el = new paper.Path.Rectangle(@item.position, new paper.Size(100, 50))
      when "circle" then @el = new paper.Path.Circle(@item.position, 50)
      when "star" then @el = new paper.Path.Star(@item.position, 5, 20, 50)

    @el.links = [] # Domain model (FIXME: separate from node, which is part of the view)
    @el.spine_id = @item.id
    @el.fillColor = @item.fillColor
    @el.strokeColor = @item.strokeColor
    @el.dashArray = if @item.strokeStyle is 'solid' then [10, 0] else [10, 4]
  
  
  renderLink: =>
    console.log("there are now " + grumble.Link.count() + " links")
    console.log(@item)
    
    segments = for s in @item.segments
      new paper.Segment(s.point, s.handleIn, s.handleOut)
    
    @el = new paper.Path(segments)
    @el.spine_id = @item.id
    @el.strokeColor = @item.strokeColor
    @el.dashArray = if @item.strokeStyle is 'solid' then [10, 0] else [10, 4]

    # TODO trim the line in the tool
    # rather than hiding the overlap behind the nodes here
    @el.layer.insertChild(0, @el)
    paper.view.draw()
        
  remove: (node) =>
    @el.remove()
    