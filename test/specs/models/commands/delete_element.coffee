require = window.require

describe 'DeleteElement', ->
  DeleteElement = require('models/commands/delete_element')
  Drawing = require('models/drawing')

  beforeEach ->
    @drawing = new Drawing()
    @node = @drawing.addNode({})
    @link = @drawing.addLink({})

  afterEach -> # only needed because Spine saves data to the web browser's local storage!
    @drawing.destroy() if @drawing

  it 'deletes the element when it is a node', ->
    command = new DeleteElement(@drawing, @node)
    command.run()
    expect(@drawing.nodes().all().length).toBe(0)
    
  it 'deletes the element when it is a link', ->
    command = new DeleteElement(@drawing, @link)
    command.run()
    expect(@drawing.links().all().length).toBe(0)
    