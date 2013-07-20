define [
  'spine'
  'rtc'
], (Spine, rtc) ->

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
      localStorage[@className] = JSONrecord
      @refresh(JSONrecord or [], clear: true)
      @fetch()

    modelMapUpdate: (event) ->
      @unbind('save',rtc.saveJSON) # we dont want events to fire again on changes.
      @unbind('destroy',rtc.deleteJSON)
      eventSource = event.property
      changeOnThisModel = eventSource.lastIndexOf(@className, 0) == 0
      if(changeOnThisModel)
        recordOld = @fromJSON(event.oldValue)
        recordNew = @fromJSON(event.newValue)
        if(recordNew)
          if(@exists(recordNew.id))
            recordLocal = @find(recordNew.id)
            recordLocal.updateAttributes(recordNew.attributes())
            # console.log('exists - update '+ recordLocal?)
          else
            console.log('create')
            @create(recordNew.attributes())
        else
          recordLocal = @find(recordOld.id)
          console.log('null delete '+recordLocal?)
          recordLocal.destroy()
      @bind('save',rtc.saveJSON)
      @bind('destroy',rtc.deleteJSON)

module?.exports = Spine.Model.Realtime