
/*
  @depend tool.js
*/


(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  grumble.NodeTool = (function(_super) {

    __extends(NodeTool, _super);

    NodeTool.name = 'NodeTool';

    function NodeTool() {
      return NodeTool.__super__.constructor.apply(this, arguments);
    }

    NodeTool.prototype.parameters = {
      'shape': 'rectangle',
      'fillColor': 'white',
      'strokeColor': 'black',
      'strokeStyle': 'solid'
    };

    NodeTool.prototype.onMouseDown = function(event) {
      this.parameters.position = event.point;
      new grumble.Node(this.parameters).save();
      return this.clearSelection();
    };

    return NodeTool;

  })(grumble.Tool);

}).call(this);
