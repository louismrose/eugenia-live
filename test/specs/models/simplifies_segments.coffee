require = window.require

describe 'SimplifiesSegments', ->
  SimplifiesSegments = require('models/simplifies_segments')

  beforeEach ->
    @segments = [new paper.Segment(new paper.Point(10, 5))]

  it 'is necessary because Paper.js segments cannot be serialised', ->
    expect(=> JSON.stringify(@segments)).toThrow("Converting circular structure to JSON")

  it 'simplifies segments and allows serialisation', ->
    simplifiedSegments = new SimplifiesSegments().for(@segments)
    expect(=> JSON.stringify(simplifiedSegments)).not.toThrow()