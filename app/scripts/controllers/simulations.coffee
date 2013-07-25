#Spine = require('spine')
Bacon = require('baconjs/dist/Bacon').Bacon
Commander = require ('models/commands/commander')
PaletteSpecification = require('models/palette_specification')
Drawing = require('models/drawing')
CanvasRenderer = require('views/drawings/canvas_renderer')
#Toolbox = require('controllers/toolbox')
Selection = require('controllers/selection')
Spine.SubStack = require('lib/substack')

simulationPoll = require('controllers/simulation_poll')

class Simulation extends Spine.Controller
  events:
    'click [data-mode]' : 'changeMode'    

  constructor: ->
    super
    @active @change

  change: (params) =>    

    @commander = new Commander()
    # i think we should rename item to drawing, makes more sense in this context
    @item = Drawing.find(params.id)
    @item.clearSelection()

    @render()  

  changeMode: (event) =>
    event.preventDefault()
    @mode = $(event.target).data('mode')

    @navigate('/drawings', @item.id) if @mode is 'edit'

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

  constructor: (@item) ->
    super
    @render()
 
    getCurrentValue = (event) ->
      parseInt(event.currentTarget.value, 10) # always use base 10, even if it starts with 0 or 0x
    
    get = (id) ->
      $('#'+id).asEventStream('change').map(getCurrentValue)

    x = get('x')
    y = get('y')
    z = get('z')

    func = () ->
      body = $('#function')[0].value
      # TODO: build function and event streams based on properties etc
      argvalues = Array.prototype.slice.call(arguments)
      argnames = ['currentTime', 'x','y','z']

      builder = new FunctionBuilder(argnames, argvalues)
      builder.addBody body
      return builder.execute()
      
    f = Bacon.combineWith(func, simulationPoll.currentTime, x, y, z)
    f.onValue $('#f'), "attr", "value"

  stop: (event) =>
    simulationPoll.stop()

  start: (event) =>
    simulationPoll.currentTime.onValue (tick) =>
      for node in @item.nodes().all()
        node.simulate(tick)

    simulationPoll.start()

  startInteractive: (element) ->

    update = (currentTime, node) ->
      console.log('update')
      #console.log(node.getShape().behavior)
     ### for property, expression of node.getShape().behavior.tick
        console.log(property, expression)
        node.setPropertyValue(property, eval(expression))
###

      #node.moveTo([Math.cos(time) *100 + 200, Math.sin(time) * 100 + 200])

      #node.setPropertyValue("width", "" + Math.cos(time) * 100)
      #node.trigger("render")


    #Bacon.combineWith(updateWidth, simulationPoll.counter)

  reset: (event) =>
    simulationPoll.reset()

  render: =>
    simulationPoll.reset()
    @html require('views/drawings/simulation')(@item)

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

class Simulations extends Spine.SubStack
  controllers:
    simulate: Simulation
    
  routes:
    '/simulate/:id' : 'simulate'

module.exports = Simulations