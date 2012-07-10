require = window.require

describe 'Drawing', ->
  Drawing = require('models/drawing')
  Palette = require('models/palette')

  it 'destroys nodes, links and palette when destroyed', ->
    @drawing = Drawing.create(name: 'test')
    @drawing.save()
    @drawing.nodes().create({}).save() # FIXME Spine.JS bug? should be able to create without any params
    @drawing.nodes().create({}).save()
    
    @drawing.links().create({}).save()
    
    @palette = Palette.create(drawing_id: @drawing.id).save()
    
    @drawing.destroy()
    
    expect(@drawing.nodes().all().length).toBe(0)
    expect(@drawing.links().all().length).toBe(0)
    expect(@drawing.palette()).toBeNull()
