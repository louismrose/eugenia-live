class FunctionBuilder
  @args = []
  @values = []
  @body = ''

  constructor: (args, values)->
    @args = Array()
    @values = Array()
    @body = ''    

    @addArguments(args, values)

  addArgument: (name, value) ->
    @args.push(name)
    @values.push(value)

  addArguments: (args, values) ->
    throw 'Cannot add arguments if their names aren\'t supplied' unless args.length is values.length
    @args = @args.concat(args)
    @values = @values.concat(values)

  addBody: (body) ->
    @body = @body.concat(body)

  execute: ->
    # VERY NAIVE and UNSAFE execution of external code!
    # surround with try/catch?
    
    eval @buildFunction()
    

  buildFunction: ->
    # with or without forced return statement?
    'someFunc = function(' + (@args.join(',')) + '){'+@body+'};someFunc.apply(null, this.values);'

module.exports = FunctionBuilder