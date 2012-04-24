(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  paper.NodeTool = (function(_super) {

    __extends(NodeTool, _super);

    NodeTool.name = 'NodeTool';

    function NodeTool() {
      return NodeTool.__super__.constructor.apply(this, arguments);
    }

    NodeTool.prototype.parameters = {
      'shape': 'rectangle',
      'fill_colour': 'white',
      'stroke_colour': 'black',
      'stroke_style': 'solid'
    };

    NodeTool.prototype.onMouseDown = function(event) {
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
      n.dashArray = this.parameters['stroke_style'] === 'solid' ? [10, 0] : [10, 4];
      if (paper.project.selectedItems[0]) {
        return paper.project.selectedItems[0].selected = false;
      }
    };

    return NodeTool;

  })(grumble.Tool);

}).call(this);
