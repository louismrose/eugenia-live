require = window.require

describe 'DeleteLink', ->
  DeleteLink = require('models/commands/delete_link')
  Drawing = require('models/drawing')

  beforeEach ->
    @drawing = new Drawing()
    @parameters =
      shape: "Transition"
      sourceId: "c1"
      targetId: "c2"
      segments:
        [
          point: {x: 5, y: 4}
          handleIn: {x: 3, y: 2}
          handleOut: {x: 1, y: 0}
        ]
    link = @drawing.addLink(@parameters)
    @command = new DeleteLink(@drawing, link)

  afterEach -> # only needed because Spine saves data to the web browser's local storage!
    @drawing.destroy() if @drawing

  it 'deletes the link when executed', ->
    @command.run()
    expect(@drawing.links().all().length).toBe(0)
    
  it 'recreates the link when undone', ->
    @command.run()
    @command.undo()
    
    expect(@drawing.links().all().length).toBe(1)

    link = @drawing.links().first()
    expect(link.shape).toEqual(@parameters.shape)
    expect(link.sourceId).toEqual(@parameters.sourceId)
    expect(link.targetId).toEqual(@parameters.targetId)
    expect(link.segments).toEqual(@parameters.segments)
    

  it 'changes ids when rebased', ->
    @command.run()
    @command.rebase("c1", "c3")
    @command.undo()

    expect(@drawing.links().all().length).toBe(1)

    link = @drawing.links().first()
    expect(link.shape).toEqual(@parameters.shape)
    expect(link.sourceId).toEqual("c3")
    expect(link.targetId).toEqual(@parameters.targetId)
    expect(link.segments).toEqual(@parameters.segments)