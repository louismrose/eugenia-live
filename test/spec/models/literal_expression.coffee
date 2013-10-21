define [
  'models/literal_expression'
], (LiteralExpression) ->

  describe 'LiteralExpression', ->
    it 'foo evaluates to foo', ->
      expression = new LiteralExpression("foo")
      expect(expression.evaluate()).toBe("foo")