define [
  'controllers/tool'
  'models/commands/create_link'
], (Tool, CreateLink) ->

  class LinkTool extends Tool
    parameters: {'shape' : null}
    drafting: false
  
    onMouseMove: (event) =>
      if @parameters.shape
        @clearSelection()
        @select(@hitTester.nodeAt(event.point))
  
    onMouseDown: (event) =>
      if @parameters.shape and @hitTester.nodeAt(event.point)
        @drafting = true
        @draftLink = new DraftLink(event.point)

    onMouseDrag: (event) =>
      if @drafting
        @draftLink.extendTo(event.point)
        @changeSelectionTo(@hitTester.nodeAt(event.point)) if @hitTester.nodeAt(event.point)
  
    onMouseUp: (event) =>
      if @drafting 
        if @hitTester.nodeAt(event.point)
          path = @draftLink.finalise()
          @parameters.sourceId = @hitTester.nodeAt(path.firstSegment.point).id
          @parameters.targetId = @hitTester.nodeAt(path.lastSegment.point).id
          @parameters.segments = path.segments
          @run(new CreateLink(@drawing, @parameters))
      
        @draftLink.remove()
        @clearSelection()
        @drafting = false
        #[THANOS] Change the highlighted tool to select and then get the global variable myToolbox and switch the current tool to select
        document.getElementById("toolbox").getElementsByClassName("active")[0].setAttribute('class', '')
        document.getElementById("sel").setAttribute('class', 'active')
        myToolbox.switchTo("select")


    class DraftLink
      constructor: (origin) ->
        @path = new paper.Path([origin])
        @path.layer.insertChild(0, @path) # force to bottom
        @path.strokeColor = 'black'
        @path.dashArray = [10, 4] # dash

      extendTo: (point) ->
        @path.add(point)

      finalise: () ->
        @path.simplify(100)
        @path
    
      remove: ->
        @path.remove()