###
  @depend ../namespace.js
###
class grumble.LinkRenderer

  constructor: (item) ->
    @item = item
    @item.bind("update", @render)
    @item.bind("destroy", @remove)

  render: =>
    console.log("rendering " + @item)
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
    