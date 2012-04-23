(function() {

  window.onload = function() {
    var canvas;
    canvas = document.getElementById('myCanvas');
    paper.setup(canvas);
    paper.view.draw();
    $('body').on('click', 'a[data-tool]', function(event) {
      var tool, tool_name;
      tool_name = $(this).attr('data-tool');
      tool = window.tools[tool_name];
      if (tool) {
        return tool.activate();
      }
    });
    $('body').on('click', 'button[data-tool-parameter-value]', function(event) {
      var key, value;
      value = $(this).attr('data-tool-parameter-value');
      key = $(this).parent().attr('data-tool-parameter');
      if (!paper.tool.parameters) {
        paper.tool.parameters = {};
      }
      return paper.tool.parameters[key] = value;
    });
    window.tools = {};
    window.tools['node'] = new paper.Tool();
    window.tools['node'].parameters = {
      'shape': 'rectangle',
      'fill_colour': 'white',
      'stroke_colour': 'black',
      'stroke_style': 'solid'
    };
    window.tools['node'].onMouseDown = function(event) {
      var n;
      switch (this.parameters['shape']) {
        case "rectangle":
          n = new paper.Path.Rectangle(event.point, new paper.Size(100, 50));
          break;
        case "circle":
          n = new paper.Path.Circle(event.point, 50);
          break;
        case "star":
          n = new paper.Path.Star(event.point, 5, 20, 50);
      }
      n.fillColor = this.parameters['fill_colour'];
      n.strokeColor = this.parameters['stroke_colour'];
      return n.dashArray = this.parameters['stroke_style'] === 'solid' ? [10, 0] : [10, 4];
    };
    window.tools['select'] = new paper.Tool();
    window.tools['select'].onMouseDown = function(event) {
      var hitResult;
      hitResult = paper.project.hitTest(event.point);
      paper.project.activeLayer.selected = false;
      if (hitResult) {
        return hitResult.item.selected = true;
      }
    };
    window.tools['select'].onMouseDrag = function(event) {
      if (paper.project.selectedItems[0]) {
        return paper.project.selectedItems[0].position = event.point;
      }
    };
    return window.tools['select'].onKeyDown = function(event) {
      var copy;
      if (event.key === 'delete') {
        if (paper.project.selectedItems[0]) {
          return paper.project.selectedItems[0].remove();
        }
      } else if (event.modifiers.command && event.key === 'c') {
        return window.clipboard = paper.project.selectedItems[0];
      } else if (event.modifiers.command && event.key === 'v') {
        if (window.clipboard) {
          if (paper.project.selectedItems[0]) {
            paper.project.selectedItems[0].selected = false;
          }
          copy = clipboard.clone();
          copy.position.x += 10;
          copy.position.y += 10;
          return copy.selected = true;
        }
      }
    };
  };

}).call(this);
