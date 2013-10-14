define [
  'models/commands/change_property'
  'models/node'
], (ChangeProperty, Node) ->

  describe 'ChangeProperty', ->
    beforeEach ->
      @node = Node.create()
      @node.properties.set("name", "old")
      @command = new ChangeProperty(@node, "name", "new")

    afterEach ->
      @node.destroy()

    it "changes the value of the node's property", ->
      @command.run()
      expect(@node.properties.get("name")).toBe("new")
  
    it "restores the value of the node's property when undone", ->
      @command.run()
      @command.undo()
  
      expect(@node.properties.get("name")).toBe("old")