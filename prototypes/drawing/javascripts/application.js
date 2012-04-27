(function() {
  var exports;

  exports = this;

  exports.grumble = {};

}).call(this);


/*
  @depend ../namespace.js
*/


(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  grumble.Tool = (function(_super) {

    __extends(Tool, _super);

    Tool.name = 'Tool';

    function Tool() {
      return Tool.__super__.constructor.apply(this, arguments);
    }

    Tool.prototype.onKeyDown = function(event) {
      var copy, item, link, _i, _len, _ref, _results;
      if (event.key === 'delete') {
        item = paper.project.selectedItems[0];
        if (item) {
          item.remove();
          if (item.links) {
            _ref = item.links;
            _results = [];
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              link = _ref[_i];
              _results.push(link.remove());
            }
            return _results;
          }
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

    return Tool;

  })(paper.Tool);

}).call(this);


/*
  @depend tool.js
*/


(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  paper.LinkTool = (function(_super) {
    var DraftLink, DraftingLayer;

    __extends(LinkTool, _super);

    LinkTool.name = 'LinkTool';

    function LinkTool() {
      return LinkTool.__super__.constructor.apply(this, arguments);
    }

    LinkTool.prototype.parameters = {};

    LinkTool.prototype.draftLink = null;

    LinkTool.prototype.draftingLayer = null;

    LinkTool.prototype.drafting = false;

    LinkTool.prototype.onMouseMove = function(event) {
      var hitResult;
      hitResult = paper.project.hitTest(event.point);
      paper.project.activeLayer.selected = false;
      if (hitResult && hitResult.item.closed) {
        return hitResult.item.selected = true;
      }
    };

    LinkTool.prototype.onMouseDown = function(event) {
      var hitResult;
      hitResult = paper.project.activeLayer.hitTest(event.point);
      if (hitResult) {
        this.drafting = true;
        this.draftingLayer = new DraftingLayer(paper.project.activeLayer);
        return this.draftLink = new DraftLink(event.point);
      }
    };

    LinkTool.prototype.onMouseDrag = function(event) {
      var hitResult;
      if (this.drafting) {
        this.draftLink.extendTo(event.point);
        hitResult = this.draftingLayer.hitTest(event.point);
        if (hitResult && hitResult.item.closed) {
          paper.project.layers[0].selected = false;
          return hitResult.item.selected = true;
        }
      }
    };

    LinkTool.prototype.onMouseUp = function(event) {
      var hitResult, link, source, target;
      if (this.drafting) {
        hitResult = this.draftingLayer.hitTest(event.point);
        if (hitResult && hitResult.item.closed) {
          link = this.draftLink.finalise();
          source = this.draftingLayer.hitTest(link.firstSegment.point).item;
          target = this.draftingLayer.hitTest(link.lastSegment.point).item;
          source.links.push(link);
          if (source !== target) {
            target.links.push(link);
          }
          link.source = source;
          link.target = target;
          this.draftingLayer.commit();
          this.draftingLayer.dispose();
        }
        this.draftingLayer.dispose();
        paper.project.activeLayer.selected = false;
        return this.drafting = false;
      }
    };

    DraftingLayer = (function() {

      DraftingLayer.name = 'DraftingLayer';

      DraftingLayer.prototype.parent = null;

      DraftingLayer.prototype.layer = null;

      function DraftingLayer(parent) {
        this.parent = parent;
        this.layer = new paper.Layer();
      }

      DraftingLayer.prototype.hitTest = function(point) {
        return this.parent.hitTest(point);
      };

      DraftingLayer.prototype.commit = function() {
        return this.parent.insertChildren(0, this.layer.children);
      };

      DraftingLayer.prototype.dispose = function() {
        this.layer.remove();
        return this.parent.activate();
      };

      return DraftingLayer;

    })();

    DraftLink = (function() {

      DraftLink.name = 'DraftLink';

      DraftLink.prototype.path = null;

      function DraftLink(origin) {
        this.path = new paper.Path([origin]);
        this.path.strokeColor = 'black';
        this.path.dashArray = [10, 4];
      }

      DraftLink.prototype.extendTo = function(point) {
        return this.path.add(point);
      };

      DraftLink.prototype.finalise = function() {
        this.path.simplify(100);
        this.path.dashArray = [10, 0];
        return this.path;
      };

      return DraftLink;

    })();

    return LinkTool;

  })(grumble.Tool);

}).call(this);


/*
  @depend tool.js
*/


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
      n.links = [];
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


/*
  @depend tool.js
*/


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

    SelectTool.prototype.origin = null;

    SelectTool.prototype.onMouseDown = function(event) {
      var hitResult;
      hitResult = paper.project.hitTest(event.point);
      paper.project.activeLayer.selected = false;
      if (hitResult) {
        hitResult.item.selected = true;
        return this.origin = hitResult.item.position;
      }
    };

    SelectTool.prototype.onMouseDrag = function(event) {
      var item;
      item = paper.project.selectedItems[0];
      if (item && item.closed) {
        return item.position = event.point;
      }
    };

    SelectTool.prototype.onMouseUp = function(event) {
      var item, link, _i, _len, _ref, _results;
      item = paper.project.selectedItems[0];
      if (item && item.links) {
        _ref = item.links;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          link = _ref[_i];
          _results.push(this.reconnect(link, item));
        }
        return _results;
      }
    };

    SelectTool.prototype.reconnect = function(link, item) {
      var offset;
      if (link.source === item) {
        offset = link.firstSegment.point.subtract(this.origin);
        link.removeSegment(0);
        link.insert(0, item.position.add(offset));
      }
      if (link.target === item) {
        offset = link.lastSegment.point.subtract(this.origin);
        link.removeSegment(link.segments.size - 1);
        link.add(item.position.add(offset));
      }
      return link.simplify(100);
    };

    return SelectTool;

  })(grumble.Tool);

}).call(this);

(function() {

  grumble.Toolbox = (function() {

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


/*
  @depend tools/toolbox.js
*/


(function() {

  window.onload = function() {
    paper.setup($('canvas')[0]);
    paper.view.draw();
    return new grumble.Toolbox().install();
  };

}).call(this);

