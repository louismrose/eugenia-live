define [
  'controllers/tool'
  'models/node'
  'models/commands/move_node'
], (Tool, Node, MoveNode) ->

  class SelectTool extends Tool
    parameters: {}
    # [THANOS]: In order to avoid checking all the time if our node crossed any other all the time, we set up a flag which is true when our node is 
    # inside another node (crossingNodeSelected set to true). When our node exits from the other node this flag is set back to false and
    # the program keeps searching until our node enters another one.
    crossingNodeSelected = false
    # [THANOS]: These are probably not needed but we may need them in the future. Each of these are flags that let us know if a corner of our node 
    # crossed another node.
    crossingNode1 = false
    crossingNode2 = false
    crossingNode3 = false
    crossingNode4 = false
    itemClicked = null

    onMouseDown: (event) =>
      @clearSelection()
      @select(@hitTester.nodeOrLinkAt(event.point))
      @current = event.point
      @start = event.point
      
    onMouseDrag: (event) =>
      for item in @selection() when item instanceof Node
        @run(new MoveNode(item, event.point.subtract(@current)), undoable: false)
        @current = event.point
        # [THANOS]: Get the upper Left corner point
        itemClicked = event.item
        theBounds = event.item.getChildren()[0].getBounds()
        # [THANOS]: Get the x1, x2, y1, y2 coordinates to find all the four corners
        x1 = theBounds.point.x
        y1 = theBounds.point.y
        x2 = x1 + event.item.getChildren()[0].bounds.width
        y2 = y1 + event.item.getChildren()[0].bounds.height
        leftUpCorner = new paper.Point(x1, y1)
        rightUpCorner = new paper.Point(x2, y1)
        leftDownCorner = new paper.Point(x1, y2)
        rightDownCorner = new paper.Point(x2, y2)
        # [THANOS]: Check if there's at least one corner that crosses another element. If yes, then turn the appropriate flag to true and 
        # set the node that we found in the variable crossingNode.
        if @hitTester.nodeOrLinkAt(leftUpCorner) 
          crossingNode1 = true
          crossingNode = @hitTester.nodeOrLinkAt(leftUpCorner)
        else if @hitTester.nodeOrLinkAt(rightUpCorner)  
          crossingNode2 = true
          crossingNode = @hitTester.nodeOrLinkAt(rightUpCorner)
        else if @hitTester.nodeOrLinkAt(leftDownCorner)  
          crossingNode3 = true
          crossingNode = @hitTester.nodeOrLinkAt(leftDownCorner)
        else if @hitTester.nodeOrLinkAt(rightDownCorner)  
          crossingNode4 = true
          crossingNode = @hitTester.nodeOrLinkAt(rightDownCorner) 
        #console.log("cn1: " + crossingNode1 + " cn2: " + crossingNode2 + " cn3: " + crossingNode3 + " cn4: " + crossingNode4)
        #console.log("x1: " + x1 + " x2: " + x2 + " y1: " + y1 + " y2: " + y2)
        #crossingNode = @hitTester.nodeOrLinkAt(theBounds.point)
        # [THANOS]: If we have found a crossingNode and there's no node highlighted (selected) then highlight this crossingNode
        if crossingNode && not crossingNodeSelected
          crossingNodeSelected = @select(crossingNode)
          #console.log ("Entered...")
        # [THANOS]: If there's no crossing node found but there's one crossingNode that is selected that means that we exit the current 
        # crossed node. So, clear all the selected and just select the node that we initally picked to move around to find other nodes.
        else if not crossingNode && crossingNodeSelected
          @clearSelection()
          @select(@hitTester.nodeOrLinkAt(event.point))
          @current = event.point
          @start = event.point
        # [THANOS]: Set all the flags to false because we exited the node and we are ready to look for another. 
          crossingNodeSelected = false
          crossingNode1 = false
          crossingNode2 = false
          crossingNode3 = false
          crossingNode4 = false
          #console.log ("Exited...")
          
    onMouseUp: (event) =>
      # [THANOS]: If we did a MouseUp inside another node that that means that we would like to group these 2 nodes
      if crossingNodeSelected
        console.log ("Group!!")
        itemClicked.bringToFront()
      # [THANOS]: Always reset the flags when the mouse is up meaning that in our next drag we will search for crossing nodes.  
      crossingNodeSelected = false
      crossingNode1 = false
      crossingNode2 = false
      crossingNode3 = false
      crossingNode4 = false
      
      for item in @selection() when item instanceof Node
        @commander.add(new MoveNode(item, event.point.subtract(@start)))
