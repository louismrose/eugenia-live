Spine = require('spine')
Bacon = require('baconjs/dist/Bacon').Bacon

# For now just use a global; refactor into a Singleton later (see coffeescript Cookbook http://coffeescriptcookbook.com/chapters/design_patterns/singleton)

class Simulation extends Spine.Controller
  events:
    "click button[data-stop-simulation]" : "stop"
    "click button[data-start-simulation]" : "start"
    "click button[data-reset-simulation]" : "reset"
  constructor: ->
    super
    @render()

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
  start: ->
    if @running
      console.warn('Simulation Poll is already running! Use reset in order to reset time')
      return

    print = (val) ->
    
    i = 0;
    @poll = Bacon.fromPoll 1000, -> 
      new Bacon.Next ->
          1

    #poll.onValue(print)
    combine = (counter, increment) =>
      if @running
         counter.ticks += increment
       return counter

    if not @counter
      @counter = new Counter()
      @counterProperty = @poll.scan(@counter, combine)
      @counterProperty.onValue (val) ->
        $('#current-simulation-time').text(val.ticks)


    @running = true 
  stop: ->

    if not @running
      console.warn('Simulation is not running')
    @running = false
  reset: ->
    if @running
      @stop()

    @counter.ticks = 0

simulationPoll = new SimulationPoll()

class Counter
  Number ticks = 0

  constructor: ->
    @ticks = 0

module.exports = Simulation