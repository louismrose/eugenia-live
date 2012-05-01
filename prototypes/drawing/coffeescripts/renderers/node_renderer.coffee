###
  @depend ../namespace.js
###
class grumble.NodeRenderer

  constructor: (item) ->
    @item = item
    @item.bind("update", @render)
    @item.bind("destroy", @remove)

  render: =>
    console.log("rendering " + @item)
    
    switch @item.shape
      when "rectangle" then @el = new paper.Path.Rectangle(@item.position, new paper.Size(100, 50))
      when "circle" then @el = new paper.Path.Circle(@item.position, 50)
      when "star" then @el = new paper.Path.Star(@item.position, 5, 20, 50)

    @el.links = [] # Domain model (FIXME: separate from node, which is part of the view)
    @el.spine_id = @item.id
    @el.fillColor = @item.fillColor
    @el.strokeColor = @item.strokeColor
    @el.dashArray = if @item.strokeStyle is 'solid' then [10, 0] else [10, 4]
  
  remove: (node) =>
    @el.remove()
    