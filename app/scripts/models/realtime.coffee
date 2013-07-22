rtc = require("models/rtc")

Spine.Model.Realtime =
  extended:->
    @bind('save',rtc.saveJSON)
    @bind('destroy',rtc.deleteJSON)

    Spine.Model.bind('Model:fileLoad',(map) =>
      @loadModelMap(map))

    Spine.Model.bind("Model:fileUpdate",(event) =>
      @modelMapUpdate(event))
     
    @idCounter = Math.random()


  loadModelMap: (map) ->
    console.log("load map "+@className)
    records = map.get(@className)
    JSONstring = ""
    if records
      JSONstring = records.values().toString()
    JSONrecord = "[" + JSONstring + "]"
    @refresh(JSONrecord or [], clear: true)
    @fetch()

  modelMapUpdate: (event) ->
    @unbind('save',rtc.saveJSON) # we dont want events to fire again on changes.
    @unbind('destroy',rtc.deleteJSON)
    console.log('modelMapUpdate')
    eventSource = event.property
    changeOnThisModel = eventSource.lastIndexOf(@className, 0) == 0
    if(changeOnThisModel)
      recordOld = @fromJSON(event.oldValue)
      recordNew = @fromJSON(event.newValue)
      if(recordNew)
        if(@exists(recordNew.id))
          recordLocal = @find(recordNew.id)
          localSel = recordLocal.attributes().selection
          recordNew.updateAttribute('selection', localSel) if localSel?
          recordLocal.updateAttributes(recordNew.attributes())
        else
          console.log('create')
          console.log(recordNew.attributes())
          @create(recordNew.attributes())
      else
        recordLocal = @find(recordOld.id)
        console.log('null delete '+recordLocal?)
        recordLocal.destroy()
   
    @bind('save',rtc.saveJSON)
    @bind('destroy',rtc.deleteJSON)

module?.exports = Spine.Model.Realtime


  # saveLocal: ->
  #   console.log('savelocal')
  #   result = JSON.stringify(@)
  #   localStorage[@className] = result

  # loadLocal: ->
  #   result = localStorage[@className]
  #   @refresh(result or [], clear: true)