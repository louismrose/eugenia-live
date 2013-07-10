Spine = require('spine')
Bacon = require('baconjs/dist/Bacon').Bacon

class Simulation extends Spine.Controller
  events:
    "click button[data-stop-simulation]" : "stop"
    "click button[data-start-simulation]" : "start"
    "click button[data-reset-simulation]" : "reset"
  constructor: ->
    super
    @render()
    getCurrentValue = (event) ->
      parseInt(event.currentTarget.value, 10)
    
    get = (id) ->
      $('#'+id).asEventStream('change').map(getCurrentValue)

    x = get('x')
    y = get('y')
    z = get('z')

    func = () ->
      body = $('#function')[0].value
      # TODO: build functionand event streams based on properties etc
      argvalues = Array.prototype.slice.call(arguments)
      argnames = ['currentTime', 'x','y','z']

      builder = new FunctionBuilder(argnames, argvalues)
      builder.addBody body
      return builder.execute()
      
    f = Bacon.combineWith(func, simulationPoll.currentTime, x, y, z)
    f.onValue $('#f'), "attr", "value"

  render: =>
    @html require('views/drawings/simulation')(@item) if @item

  stop: (event) =>
    simulationPoll.stop()

  start: (event) =>
    simulationPoll.start()

  reset: (event) =>
    simulationPoll.reset()

class SimulationPoll
  Boolean running = false

  constructor: ->
    @counter = new Counter()
    @poll = Bacon.fromPoll 1000, -> 
      new Bacon.Next ->
          1

    combine = (counter, increment) =>
      if @running
         counter.ticks += increment
       return counter

    @counterProperty = @poll.scan(@counter, combine)
    @counterProperty.onValue (val) ->
      $('#current-simulation-time').text(val.ticks)
    skip = (prev, cur) ->
       prev is cur
    @currentTime = (@counterProperty.map ('.ticks')).skipDuplicates(skip)

  start: ->
    if @running
      console.warn('Simulation Poll is already running! Use reset in order to reset time')
      return

    @running = true 
    return @poll

  stop: ->
    if not @running
      console.warn('Simulation is not running')
    @running = false

  reset: ->
    if @running
      @stop()

    @counter.ticks = 0

class Counter
  Number ticks = 0

  constructor: ->
    @ticks = 0

# For now just use a global; refactor into a Singleton later (see coffeescript Cookbook http://coffeescriptcookbook.com/chapters/design_patterns/singleton)
simulationPoll = new SimulationPoll()

class FunctionBuilder
  @args
  @values
  @body

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

module.exports = Simulation