define [
  'paper'
  'viewmodels/drawings/paths/label'
], (paper, Label) ->

  describe 'Label', ->
    describe 'on construction', -> 
      it 'creates a Paper.js PointText', ->
        path = createLabel()
        expect(path._paperItem instanceof paper.PointText).toBeTruthy()
    
      it 'trims text longer than the length', ->
        path = createLabel(length: 7, text: '1234567890')
        expect(path.text()).toEqual('1234...')

      it 'does not trim text of precisely the right length', ->
        path = createLabel(length: 7, text: '1234567')
        expect(path.text()).toEqual('1234567')

      it 'displays the label in the specified colour', ->
        path = createLabel(color: 'red')
        expect(path.fillColor().toCSS()).toEqual("rgb(255,0,0)")
    
    describe 'redraw', ->
      beforeEach ->
        @path = createLabel()
      
      it 'updates colour', ->
        @path.redraw({ color: 'red' })
        expect(@path.fillColor().toCSS()).toEqual("rgb(255,0,0)")
        
      it 'updates length', ->
        path = createLabel(text: '1234567890', length: 50)
        path.redraw(length: 7)
        expect(path.text()).toEqual('1234...')
        
      it 'updates text', ->
        @path.redraw({ text: '1234' })
        expect(@path.text()).toEqual("1234")

      it 'updates text and respects length', ->
        path = createLabel(length: 7)
        path.redraw(text: '1234567890')
        expect(path.text()).toEqual('1234...')
    
    
    createLabel = (properties = {}) ->
      properties.color = 'blue' unless properties.color
      new Label(properties)
    