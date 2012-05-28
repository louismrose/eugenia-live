require = window.require

describe 'Drawing', ->
  Drawing = require('models/drawing')

  it 'destroys nodes and links when destroyed', ->
    @drawing = Drawing.create(name: 'test')
    @drawing.save()
    @drawing.nodes().create({}).save() # FIXME Spine.JS bug? should be able to create without any params
    @drawing.nodes().create({}).save()
    
    @drawing.links().create({}).save()
    
    @drawing.destroy()
    
    expect(@drawing.nodes().all().length).toBe(0)
    expect(@drawing.links().all().length).toBe(0)
