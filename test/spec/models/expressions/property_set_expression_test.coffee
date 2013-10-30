define [
  'models/expressions/property_set_expression'
], (PropertySetExpression) ->

  describe 'PropertySetExpression', ->
    describe "appliesFor", ->
      it "accepts strings of form ${..}", ->
        expect(PropertySetExpression.appliesFor("${color}")).toBeTruthy()

      it "rejects non-strings", ->
        expect(PropertySetExpression.appliesFor(42)).toBeFalsy()
        expect(PropertySetExpression.appliesFor(true)).toBeFalsy()
        expect(PropertySetExpression.appliesFor({})).toBeFalsy()
        expect(PropertySetExpression.appliesFor(undefined)).toBeFalsy()

      it "rejects plain strings", ->
        expect(PropertySetExpression.appliesFor("color")).toBeFalsy()
        expect(PropertySetExpression.appliesFor("")).toBeFalsy()

      it "rejects plain strings starting with $", ->
        expect(PropertySetExpression.appliesFor("$color")).toBeFalsy()

    
    describe "evaluate", ->
      it 'replaces all property references with property values', ->
        properties = new FakePropertySet(forename: "John", surname: "Doe", title: "Mr.")
        expression = new PropertySetExpression("${surname}: ${title} ${forename} ${surname}", properties)
        expect(expression.evaluate()).toBe("Doe: Mr. John Doe")
      
      it 'coerces numbers', ->
        properties = new FakePropertySet(width: "50")
        expression = new PropertySetExpression("${width}", properties)
        expect(expression.evaluate()).toBe(50)
        
      it 'evaluates to "undefined" when property does not exist ', ->
        properties = new FakePropertySet(color: undefined)
        expression = new PropertySetExpression("${color}", properties)
        expect(expression.evaluate()).toBe(undefined)
    
    class FakePropertySet
      constructor: (@properties) ->
      get: (property) ->
        @properties[property]