class LinkRenderer

  constructor: (item) ->
    @item = item
    @item.bind("update", @render)
    @item.bind("destroy", @remove)

  render: =>
    console.log("rendering " + @item)
    
    old_el =  @el
    
    segments = for s in @item.segments
      new paper.Segment(s.point, s.handleIn, s.handleOut)
  
    @el = new paper.Path(segments)
    @el.spine_id = @item.id
    @el.strokeColor = @item.strokeColor
    @el.dashArray = if @item.strokeStyle is 'solid' then [10, 0] else [10, 4]

    # TODO trim the line in the tool
    # rather than hiding the overlap behind the nodes here
    @el.layer.insertChild(0, @el)
    
    if old_el
      @el.selected = old_el.selected
      old_el.remove()
        
  remove: =>
    @el.remove()
    
module.exports = LinkRenderer