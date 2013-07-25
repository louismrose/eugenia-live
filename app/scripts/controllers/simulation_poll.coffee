Bacon = require('baconjs/dist/Bacon').Bacon

class SimulationPoll
  Boolean isRunning = false

  constructor: ->
    # If we make this and displayResolution a Bacon Property, we don't have to worry about updates anymore
    @timeStep = 0.04 # 25 frames per second

    @counter = new Counter()
    @runningStatus = new Bacon.Bus()
    # interval time in milliseconds, based on the timeStep
    @poll = Bacon.fromPoll 1000*@timeStep, => 
      new Bacon.Next =>
          @timeStep

    combine = (counter, increment) =>
      if @isRunning
         counter.ticks += increment
       return counter
    
    @counterProperty = @poll.scan(@counter, combine)

    @displayResolution = -Math.floor(Math.log(@timeStep)/Math.LN10)
    @counterProperty.onValue (val) =>
      $('#current-simulation-time').text(val.ticks.toFixed(@displayResolution))
    
    @currentTime = (@counterProperty.map ('.ticks')).skipDuplicates()

  ###
  # Start the polling mechanism, if  it hasn't been started already
  # Triggers a runningStatus change iff the polling mechanism 
  #  is started
  ###
  start: ->
    if @isRunning
      console.warn('Simulation Poll is already running! Use reset in order to reset time')
      return

    @isRunning = true 
    @runningStatus.push(@isRunning)

  ###
  # Stop the polling mechanism, if  it is currently running
  # Triggers a runningStatus change iff the polling mechanism 
  # is stopped.
  ###
  stop: ->
    if not @isRunning
      console.warn('Simulation is not running')
      return

    @isRunning = false
    @runningStatus.push(@isRunning)    

  ###
  # Stop the polling mechanism, if  it is currently running and 
  # returns the current time back to zero.
  #Triggers a runningStatus change iff the polling mechanism 
  # is stopped.
  ###
  reset: ->
    notify = not @isRunning

    if @isRunning
      @isRunning = false

    # Reset the clock
    @counter.ticks = 0

    if notify
      @runningStatus.push(@isRunning)

class Counter
  Number ticks = 0

  constructor: ->
    @ticks = 0

# For now just use a global; refactor into a Singleton later (see coffeescript Cookbook http://coffeescriptcookbook.com/chapters/design_patterns/singleton)
simulationPoll = new SimulationPoll()

module.exports = simulationPoll