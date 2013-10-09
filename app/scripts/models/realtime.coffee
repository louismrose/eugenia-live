define [
  'rtc'
], (rtc) ->

  Spine.Model.Realtime =
    extended:->
      @bind('update',rtc.updateJSON)
      @bind('create',rtc.createJSON)
      @bind('destroy',rtc.deleteJSON)

      Spine.Model.bind('Model:fileLoad',(map) =>
        @loadModelMap(map))

      Spine.Model.bind("Model:fileUpdate",(event) =>
        @modelMapUpdate(event))
     
      @idCounter = Math.random() 
      # random initial value of counter helps to avoid ID conflicts

   # called when a realtime model is loaded. Finds existing instances of this Model type and loads them
    loadModelMap: (map) ->
      console.log("load map "+@className)
      records = map.get(@className)
      JSONstring = ""
      if records
        JSONstring = records.values().toString()
      JSONrecord = "[" + JSONstring + "]"
      @refresh(JSONrecord or [], clear: true)
      @fetch()
    # called each time an edit is applied remotely on collaborative map
    modelMapUpdate: (event) ->
      # we dont want events to fire again on changes.
      @unbind('update',rtc.updateJSON) 
      @unbind('destroy',rtc.deleteJSON)
      @unbind('create',rtc.createJSON)
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
            console.log('create:  '+@className)
            console.log(recordNew.attributes())
            @create(recordNew.attributes())
        else
          recordLocal = @find(recordOld.id)
          console.log('null delete '+recordLocal?)
          recordLocal.destroy()
      # with model updated, add the listeners again.
      @bind('update',rtc.updateJSON)
      @bind('create',rtc.createJSON)
      @bind('destroy',rtc.deleteJSON)