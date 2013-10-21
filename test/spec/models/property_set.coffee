define [
  'models/property_set'
], (PropertySet) ->

  describe 'PropertySet', ->
    beforeEach ->
        @shape = jasmine.createSpyObj('shape', ['defaultPropertyValues'])
        @shape.defaultPropertyValues.andCallFake(-> {name: '', title: 'Ms.'})
                
    
    describe 'on initialisation', ->
      it 'takes defaults from shape', ->
        propertySet = new PropertySet(@shape)
        
        expect(propertySet.size()).toBe(2)
        expect(propertySet.get('name')).toBe('')
        expect(propertySet.get('title')).toBe('Ms.')
      
      it 'does not replace existing value with default from shape', ->
        propertySet = new PropertySet(@shape, {title: 'Sir.'})
        expect(propertySet.get('title')).toBe('Sir.')
      
      it 'removes existing value if defaults from shape exclude this property', ->
        propertySet = new PropertySet(@shape, {age: 24})
        expect(propertySet.has('age')).toBeFalsy()


    describe 'calling all()', ->
      it 'removes defunct properties if defaults have changed', ->
        propertySet = new PropertySet(@shape)
        
        @shape.defaultPropertyValues.andCallFake(-> {name: ''})
        
        propertySet.all()
        expect(propertySet.has('title')).toBeFalsy()
        

    describe 'calling set()', ->
      it 'changes value', ->
        propertySet = new PropertySet(@shape)
        propertySet.set('name', 'John Doe')
        expect(propertySet.get('name')).toBe('John Doe')
        
      it 'triggers event', ->
        @subscriber = jasmine.createSpyObj('shape', ['changed'])
        
        propertySet = new PropertySet(@shape)
        propertySet.bind('propertyChanged', @subscriber.changed)
        propertySet.set('name', 'John Doe')
        
        expect(@subscriber.changed.callCount).toBe(1)
        
      
    describe 'calling remove()', ->
      it 'removes value', ->
        propertySet = new PropertySet(@shape)
        propertySet.remove('name')
        expect(propertySet.has('name')).toBeFalsy()
        
        
      it 'triggers event', ->
        @subscriber = jasmine.createSpyObj('shape', ['removed'])
        
        propertySet = new PropertySet(@shape)
        propertySet.bind('propertyRemoved', @subscriber.removed)
        propertySet.remove('name')
        
        expect(@subscriber.removed.callCount).toBe(1)
        
        
    describe 'resolve', ->
      it 'instantiates an expression via the factory', ->
        expression = jasmine.createSpyObj('shape', ['evaluate'])
        
        factory = jasmine.createSpyObj('shape', ['expressionFor'])
        factory.expressionFor.andReturn(expression)
        
        propertySet = new PropertySet(@shape, {}, factory)
        propertySet.resolve('name')
        expect(expression.evaluate).toHaveBeenCalled()
        
      it 'returns the default value when the expression evaluates to undefined', ->
        expression = jasmine.createSpyObj('shape', ['evaluate'])
        expression.evaluate.andReturn(undefined)
        
        factory = jasmine.createSpyObj('shape', ['expressionFor'])
        factory.expressionFor.andReturn(expression)
        
        propertySet = new PropertySet(@shape, {}, factory)
        result = propertySet.resolve('name', 'default')
        expect(result).toEqual('default')
        
        