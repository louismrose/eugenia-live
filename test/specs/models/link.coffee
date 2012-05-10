require = window.require

describe 'Link', ->
  Link = require('models/link')

  it 'allows Paper.js segments to be serialisable', ->
    s = [new paper.Segment(new paper.Point(10, 5))]

    # Ensure that this functionality is necessary
    expect(-> JSON.stringify(s)).toThrow("JSON.stringify cannot serialize cyclic structures.")

    link = new Link({segments: s})
    expect(=> JSON.stringify(link.segments)).not.toThrow()