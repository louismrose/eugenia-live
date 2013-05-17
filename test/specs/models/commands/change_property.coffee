require = window.require

describe 'ChangeProperty', ->
  ChangeProperty = require('models/commands/change_property')
  Node = require('models/node')

  beforeEach ->
    @node = new Node()
    @node.setPropertyValue("name", "old")
    @command = new ChangeProperty(@node, "name", "new")


  it "changes the value of the node's property", ->
    @command.run()
    expect(@node.getPropertyValue("name")).toBe("new")
  
  it "restores the value of the node's property when undone", ->
    @command.run()
    @command.undo()
  
    expect(@node.getPropertyValue("name")).toBe("old")