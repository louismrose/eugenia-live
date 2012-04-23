(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  paper.GrumbleTool = (function(_super) {

    __extends(GrumbleTool, _super);

    GrumbleTool.name = 'GrumbleTool';

    function GrumbleTool() {
      return GrumbleTool.__super__.constructor.apply(this, arguments);
    }

    GrumbleTool.prototype.onKeyDown = function(event) {
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
          copy = window.clipboard.clone();
          copy.position.x += 10;
          copy.position.y += 10;
          copy.selected = true;
          return window.clipboard = copy;
        }
      }
    };

    return GrumbleTool;

  })(paper.Tool);

}).call(this);

(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  paper.LinkTool = (function(_super) {

    __extends(LinkTool, _super);

    LinkTool.name = 'LinkTool';

    function LinkTool() {
      return LinkTool.__super__.constructor.apply(this, arguments);
    }

    LinkTool.prototype.parameters = {};

    LinkTool.prototype.currentLink = null;

    LinkTool.prototype.linkLayer = null;

    LinkTool.prototype.onMouseMove = function(event) {
      var hitResult;
      hitResult = paper.project.hitTest(event.point);
      paper.project.activeLayer.selected = false;
      if (hitResult) {
        return hitResult.item.selected = true;
      }
    };

    LinkTool.prototype.onMouseDrag = function(event) {
      var hitResult;
      if (!this.currentLink) {
        this.linkLayer = new paper.Layer();
        this.currentLink = new paper.Path([event.point]);
        this.currentLink.strokeColor = 'black';
      }
      this.currentLink.add(event.point);
      hitResult = paper.project.layers[0].hitTest(event.point);
      if (hitResult) {
        paper.project.layers[0].selected = false;
        return hitResult.item.selected = true;
      }
    };

    LinkTool.prototype.onMouseUp = function(event) {
      var hitResult;
      if (this.currentLink) {
        this.currentLink.simplify();
        paper.project.layers[0].activate();
        hitResult = paper.project.activeLayer.hitTest(event.point);
        if (hitResult) {
          paper.project.activeLayer.insertChild(0, this.currentLink);
        }
        paper.project.activeLayer.selected = false;
        this.linkLayer.remove();
        this.currentLink = null;
        return this.linkLayer = null;
      }
    };

    return LinkTool;

  })(paper.GrumbleTool);

}).call(this);

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

  })(paper.GrumbleTool);

}).call(this);

(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  paper.SelectTool = (function(_super) {

    __extends(SelectTool, _super);

    SelectTool.name = 'SelectTool';

    function SelectTool() {
      return SelectTool.__super__.constructor.apply(this, arguments);
    }

    SelectTool.prototype.parameters = {};

    SelectTool.prototype.onMouseDown = function(event) {
      var hitResult;
      hitResult = paper.project.hitTest(event.point);
      paper.project.activeLayer.selected = false;
      if (hitResult) {
        return hitResult.item.selected = true;
      }
    };

    SelectTool.prototype.onMouseDrag = function(event) {
      if (paper.project.selectedItems[0]) {
        return paper.project.selectedItems[0].position = event.point;
      }
    };

    return SelectTool;

  })(paper.GrumbleTool);

}).call(this);

(function() {

  paper.Toolbox = (function() {

    Toolbox.name = 'Toolbox';

    function Toolbox() {}

    Toolbox.prototype.install = function() {
      this.createTools();
      this.reactToToolSelection();
      return this.reactToToolConfiguration();
    };

    Toolbox.prototype.createTools = function() {
      return window.tools = {
        node: new paper.NodeTool(),
        select: new paper.SelectTool(),
        link: new paper.LinkTool()
      };
    };

    Toolbox.prototype.reactToToolSelection = function() {
      return $('body').on('click', 'a[data-tool]', function(event) {
        var tool, tool_name;
        tool_name = $(this).attr('data-tool');
        tool = window.tools[tool_name];
        if (tool) {
          return tool.activate();
        }
      });
    };

    Toolbox.prototype.reactToToolConfiguration = function() {
      return $('body').on('click', 'button[data-tool-parameter-value]', function(event) {
        var key, value;
        value = $(this).attr('data-tool-parameter-value');
        key = $(this).parent().attr('data-tool-parameter');
        if (!paper.tool.parameters) {
          paper.tool.parameters = {};
        }
        return paper.tool.parameters[key] = value;
      });
    };

    return Toolbox;

  })();

}).call(this);

(function() {

  window.onload = function() {
    paper.setup($('canvas')[0]);
    paper.view.draw();
    paper.toolbox = new paper.Toolbox();
    return paper.toolbox.install();
  };

}).call(this);

