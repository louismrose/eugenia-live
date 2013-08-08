define [
  'models/commands/delete_element'
  'models/drawing'
  'models/node'
  'models/link'
], (DeleteElement, Drawing, Node, Link) ->

  describe 'DeleteElement', ->
    beforeEach ->
      Node.deleteAll()
      Link.deleteAll()
      @drawing = new Drawing()

    it 'deletes the element when it is a node', ->
      node = @drawing.addNode({})
      command = new DeleteElement(@drawing, node)
      command.run()
      expect(@drawing.nodes().all()).toEqual([])
    
    it 'deletes the element when it is a link', ->
      link = @drawing.addLink({})
      command = new DeleteElement(@drawing, link)
      command.run()
      expect(@drawing.links().all().length).toBe(0)