require = window.require

describe 'Link', ->
  Link = require('models/link')
  Node = require('models/node')

  beforeEach ->
    @s = new Node(); @s.save()
    @t = new Node(); @t.save()
    @l = new Link({sourceId: @s.id, targetId: @t.id})

  it 'updates source and target nodes after save', ->
    @l.save()
    expect(@s.linkIds).toEqual([@l.id])
    expect(@t.linkIds).toEqual([@l.id])
    
  it 'updates source and target nodes after delete', ->
    @l.save()
    @l.destroy()
    expect(@s.linkIds).toEqual([])
    expect(@t.linkIds).toEqual([])
    
    
  it 'allows Paper.js segments to be serialisable', ->
    segments = [new paper.Segment(new paper.Point(10, 5))]

    # Ensure that this functionality is necessary
    expect(-> JSON.stringify(segments)).toThrow("JSON.stringify cannot serialize cyclic structures.")

    @l.updateSegments(segments)
    expect(=> JSON.stringify(@l.segments)).not.toThrow()