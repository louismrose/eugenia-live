require = window.require

describe 'Node', ->
  Node = require('models/node')

  beforeEach -> @n = new Node()

  it 'adds links by ID', ->
    @n.addLink("2")
    @n.addLink("3")
    expect(@n.linkIds).toEqual(["2", "3"])

  it 'does not allow duplicate IDs', ->
    @n.addLink("2")
    @n.addLink("2")
    expect(@n.linkIds).toEqual(["2"])