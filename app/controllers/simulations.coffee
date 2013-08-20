#Spine = require('spine')
Bacon = require('baconjs/dist/Bacon').Bacon
Commander = require ('models/commands/commander')
PaletteSpecification = require('models/palette_specification')
Drawing = require('models/drawing')
CanvasRenderer = require('views/drawings/canvas_renderer')
#Toolbox = require('controllers/toolbox')
Selection = require('controllers/selection')
Spine.SubStack = require('lib/substack')

FunctionBuilder = require('controllers/helpers/function_builder')

simulationPoll = require('controllers/simulation_poll')
Node = require('models/node')
ExpressionEvaluator = require('models/helper/expression_evaluator')

class Simulation extends Spine.Controller
  events:
    'click [data-mode]' : 'changeMode'    

  constructor: ->
    super
    # prevent rendering from the constructor, as it will register a simulation loop on the Bacon stream, which I don't know how/when to get rid of
    @constructing = true
    @active @change
    @constructing = false

  change: (params) =>    

    @commander = new Commander()
    # i think we should rename item to drawing, makes more sense in this context
    @item = Drawing.find(params.id)
    @item.clearSelection()

    @render() unless @constructing

  changeMode: (event) =>
    event.preventDefault()
    @mode = $(event.target).data('mode')

    if @mode is 'edit'
      @navigate('/drawings', @item.id) 

      @simulation.deactivate()
      # reset the simulation in case we switch to a different view (not just the drawing)
      @simulation.reset()

  render: =>
    # if we navigate directly to here (without the intermediate drawing), then 
    # the Toolbox is not instantiated, so we cannot select any items on the canvas
    # Should this be refactored, so that the selection mechanism is independent of 
    # the existence of the Toolbox?
    @html require('views/drawings/simulate')(@item)

    new CanvasRenderer(drawing: @item, canvas: @$('#drawing')[0])
    @simulation = new SimulationControl(drawing: @drawing, commander: @commander, item: @item, el: @$('#simulation'))
    @selection = new Selection(commander: @commander, item: @item, el: @$('#selection'), readOnly: true)
  
  ###
  # The SubStack implementation currently does not call the deactivate properly, so 
  # it is hard to make the simulation stop when this controller is deactivated.
  activate: ->
      console.log('activate simulation')
      super

  deactivate: ->
    console.log 'deactivate simulation'
    simulationPoll.reset()
    @

    ###

class SimulationControl extends Spine.Controller
  events:
    "click button[data-stop-simulation]" : "stop"
    "click button[data-start-simulation]" : "start"
    "click button[data-reset-simulation]" : "reset"

  addBehavior: (element) ->
    if element.getShape().behavior # and link.getShape().behavior
      behavior = element.getShape().behavior
      for eventDefinition of behavior

        ## refactor to a new function
        bracketIndex = eventDefinition.indexOf('[')
        unless bracketIndex is -1
          eventName = eventDefinition.substr(0,bracketIndex)
          closingBracketIndex = eventDefinition.indexOf(']')
          closingBracketIndex = eventDefinition.length+1 if closingBracketIndex <= 0
          eventGuard = eventDefinition[bracketIndex+1.. closingBracketIndex-1]
        else
          eventName = eventDefinition
          eventGuard = "true"

        # create the associative objects/maps, if none existed yet
        @eventMap[eventName] = {} unless @eventMap[eventName] 
        @eventMap[eventName][element.paperId()] = {} unless @eventMap[eventName][element.paperId()]
        @eventMap[eventName][element.paperId()][eventGuard]= [] unless @eventMap[eventName][element.paperId()][eventGuard]

        # concat the expressions to the ones that were already defined
        Array.prototype.push.apply(@eventMap[eventName][element.paperId()][eventGuard], behavior[eventDefinition])


  constructor: (@item) ->
    super
    @changeCommands = []
    @render()

    #console.log("Building event->trigger map")
    @eventMap = {}
    for node in @item.nodes().all()
      @addBehavior(node)
    for link in @item.links().all()
      @addBehavior(link)

    #console.log(@eventMap)

    @expressionEvaluator = new ExpressionEvaluator

    @unsub = simulationPoll.currentTime.onValue (tick) =>
      if tick is 0
        return
      simulationPoll.calculatingSimulation = true
      @setters = []
      
      #console.log('Priming simulation tick')
      @primeSimulation()
      # use @events as a FIFO queue; @events.push() to add an element to the end of the queue, and @events.shift() to get one from the front of the queue
      
      while event = @events.shift()
        unless (event.target)
          @fireAll(event.name, event.context)
        else
          @fire(event.target, event.name, event.context)
        #console.log('Fired '+ event.name, event.target, '(' + @events.length+' events remaining)')
      ###for node in @item.nodes().all()
        newSetters = node.simulate(@)
        # gather all the triggers, built by the simulation statements
        setters = setters.concat(newSetters)
###
      # fire all the setters
      #console.group('executing setters')
      while setter = @setters.shift()
        if setter instanceof Function
          #console.log('setter', setter)
          setter()

      #console.groupEnd()
      simulationPoll.calculatingSimulation = false

  primeSimulation: () ->
    @events = []
    @triggerAll('tick', {"Math" : Math, simulationControl: @}) # add stuff to the environment if it should be available to the user as an object

  addSetters: (setters) =>
    # Repeated push is fastest in most browsers: http://jsperf.com/concat-vs-repeated-push-vs-push-apply/4
    setters = [setters] unless setters instanceof Array
    # http://discontinuously.com/2012/05/iteration-in-coffeescript/
    for i in [0..setters.length-1] by 1
      @setters.push(setters[i])

  triggerAll:(name, environment) =>
    #if name in @eventMap
    #  for element of @eventMap[name]
    #    @trigger(node, name, context)
    @events.push({name: name, context:environment})

  trigger: (elements, name, environment) =>
    unless elements instanceof Array
      # check for Collection, or if it is a single element:
      elements = [elements]

    for element in elements
      @events.push({name: name, target: element, context: environment})

  fire: (element, event, environment, global = false) =>
    # find and fire all triggers that listen to this event
    if listening = @eventMap[event]
      if listening[element.paperId()]
        # for each guarded list of triggers
        for guard of listening[element.paperId()]
          if @expressionEvaluator.evaluate(element, guard, environment)
            # fire each trigger, as the guard allows us
            #console.group("Activating triggers", event, guard)
            for trigger in listening[element.paperId()][guard]
              #console.log("Executing", trigger, 'on', element.paperId())
              newSetters = @expressionEvaluator.execute(element, @, trigger, environment)
              @addSetters(newSetters)
            #console.groupEnd()
          else
            #console.log('event not activated, guard not satisfied', element, event, guard)
      else if not global
        console.warn('Element is not listening to this event', element, event)
    else
      console.warn('Nobody is listening to this event', event)

  fireAll: (event, environment) =>
    #console.group("fireall", event)
    for node in @item.nodes().all()
      #console.log("fireall", event, node.id)
      @fire(node, event, environment, true)
    #console.groupEnd()
    for link in @item.links().all()
      @fire(link, event, environment, true)

  stop: (event) =>
    simulationPoll.stop()

  start: (event) =>
    simulationPoll.start()

  reset: (event) =>
    simulationPoll.reset()

  render: =>
    simulationPoll.reset()
    @html require('views/drawings/simulation')(@item)

  deactivate: =>
    @unsub()

class Simulations extends Spine.SubStack
  controllers:
    simulate: Simulation
    
  routes:
    '/simulate/:id' : 'simulate'

module.exports = Simulations