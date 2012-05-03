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

  grumble.Element = (function(_super) {

    __extends(Element, _super);

    Element.name = 'Element';

    function Element() {
      return Element.__super__.constructor.apply(this, arguments);
    }

    Element.extend(Spine.Model.Local);

    return Element;

  })(Spine.Model);

}).call(this);


/*
  @depend element.js
*/


(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  grumble.Link = (function(_super) {

    __extends(Link, _super);

    Link.name = 'Link';

    Link.configure("Link", "sourceId", "targetId", "segments", "strokeColor", "strokeStyle");

    Link.extend(Spine.Model.Local);

    function Link(attributes) {
      this.target = __bind(this.target, this);

      this.source = __bind(this.source, this);

      this.removeFromNodes = __bind(this.removeFromNodes, this);

      this.addToNodes = __bind(this.addToNodes, this);

      var k, v;
      Link.__super__.constructor.apply(this, arguments);
      for (k in attributes) {
        v = attributes[k];
        this[k] = v;
      }
      this.bind("save", this.addToNodes);
      this.bind("destroy", this.removeFromNodes);
    }

    Link.prototype.addToNodes = function() {
      this.source().addLink(this.id);
      return this.target().addLink(this.id);
    };

    Link.prototype.removeFromNodes = function() {
      if (grumble.Node.exists(this.sourceId)) {
        this.source().removeLink(this.id);
      }
      if (grumble.Node.exists(this.targetId)) {
        return this.target().removeLink(this.id);
      }
    };

    Link.prototype.source = function() {
      return grumble.Node.find(this.sourceId);
    };

    Link.prototype.target = function() {
      return grumble.Node.find(this.targetId);
    };

    return Link;

  })(Spine.Model);

}).call(this);


/*
  @depend element.js
*/


(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; },
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  grumble.Node = (function(_super) {

    __extends(Node, _super);

    Node.name = 'Node';

    Node.configure("Node", "linkIds", "shape", "position", "fillColor", "strokeColor", "strokeStyle");

    Node.extend(Spine.Model.Local);

    function Node(attributes) {
      this.links = __bind(this.links, this);

      this.destroyLinks = __bind(this.destroyLinks, this);

      this.addLink = __bind(this.addLink, this);

      var k, v;
      Node.__super__.constructor.apply(this, arguments);
      for (k in attributes) {
        v = attributes[k];
        this[k] = v;
      }
      this.linkIds || (this.linkIds = []);
      this.bind("destroy", this.destroyLinks);
    }

    Node.prototype.addLink = function(id) {
      if (__indexOf.call(this.linkIds, id) < 0) {
        this.linkIds.push(id);
      }
      return this.save();
    };

    Node.prototype.removeLink = function(id) {
      return this.linkIds.remove(id);
    };

    Node.prototype.destroyLinks = function() {
      var id, _i, _len, _ref, _results;
      _ref = this.linkIds;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        id = _ref[_i];
        _results.push(grumble.Link.destroy(id));
      }
      return _results;
    };

    Node.prototype.links = function() {
      var id, _i, _len, _ref, _results;
      _ref = this.linkIds;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        id = _ref[_i];
        _results.push(grumble.Link.find(id));
      }
      return _results;
    };

    return Node;

  })(Spine.Model);

}).call(this);


/*
  @depend ../namespace.js
*/


(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  grumble.NodeRenderer = (function() {

    NodeRenderer.name = 'NodeRenderer';

    function NodeRenderer(item) {
      this.remove = __bind(this.remove, this);

      this.render = __bind(this.render, this);
      this.item = item;
      this.item.bind("update", this.render);
      this.item.bind("destroy", this.remove);
    }

    NodeRenderer.prototype.render = function() {
      var old_el;
      console.log("rendering " + this.item);
      old_el = this.el;
      switch (this.item.shape) {
        case "rectangle":
          this.el = new paper.Path.Rectangle(this.item.position, new paper.Size(100, 50));
          break;
        case "circle":
          this.el = new paper.Path.Circle(this.item.position, 50);
          break;
        case "star":
          this.el = new paper.Path.Star(this.item.position, 5, 20, 50);
      }
      this.el.position = this.item.position;
      this.el.spine_id = this.item.id;
      this.el.fillColor = this.item.fillColor;
      this.el.strokeColor = this.item.strokeColor;
      this.el.dashArray = this.item.strokeStyle === 'solid' ? [10, 0] : [10, 4];
      if (old_el) {
        this.el.selected = old_el.selected;
        return old_el.remove();
      }
    };

    NodeRenderer.prototype.remove = function() {
      return this.el.remove();
    };

    return NodeRenderer;

  })();

}).call(this);


/*
  @depend ../namespace.js
*/


(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  grumble.LinkRenderer = (function() {

    LinkRenderer.name = 'LinkRenderer';

    function LinkRenderer(item) {
      this.remove = __bind(this.remove, this);

      this.render = __bind(this.render, this);
      this.item = item;
      this.item.bind("update", this.render);
      this.item.bind("destroy", this.remove);
    }

    LinkRenderer.prototype.render = function() {
      var old_el, s, segments;
      console.log("rendering " + this.item);
      old_el = this.el;
      segments = (function() {
        var _i, _len, _ref, _results;
        _ref = this.item.segments;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          s = _ref[_i];
          _results.push(new paper.Segment(s.point, s.handleIn, s.handleOut));
        }
        return _results;
      }).call(this);
      this.el = new paper.Path(segments);
      this.el.spine_id = this.item.id;
      this.el.strokeColor = this.item.strokeColor;
      this.el.dashArray = this.item.strokeStyle === 'solid' ? [10, 0] : [10, 4];
      this.el.layer.insertChild(0, this.el);
      if (old_el) {
        this.el.selected = old_el.selected;
        return old_el.remove();
      }
    };

    LinkRenderer.prototype.remove = function() {
      return this.el.remove();
    };

    return LinkRenderer;

  })();

}).call(this);


/*
  @depend ../namespace.js
  @depend node_renderer.js
  @depend link_renderer.js
*/


(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  grumble.CanvasRenderer = (function() {

    CanvasRenderer.name = 'CanvasRenderer';

    function CanvasRenderer() {
      this.addOne = __bind(this.addOne, this);

      this.addAll = __bind(this.addAll, this);

      this.fetchDrawing = __bind(this.fetchDrawing, this);

      this.bindToChangeEvents = __bind(this.bindToChangeEvents, this);

      this.install = __bind(this.install, this);

    }

    CanvasRenderer.prototype.install = function() {
      this.bindToChangeEvents();
      return this.fetchDrawing();
    };

    CanvasRenderer.prototype.bindToChangeEvents = function() {
      var _this = this;
      grumble.Node.bind("refresh", function() {
        return _this.addAll(grumble.Node);
      });
      grumble.Link.bind("refresh", function() {
        return _this.addAll(grumble.Link);
      });
      grumble.Node.bind("create", this.addOne);
      return grumble.Link.bind("create", this.addOne);
    };

    CanvasRenderer.prototype.fetchDrawing = function(client) {
      grumble.Node.fetch();
      return grumble.Link.fetch();
    };

    CanvasRenderer.prototype.addAll = function(type) {
      console.log("adding all " + type.count() + " " + type.name + "s");
      return type.each(this.addOne);
    };

    CanvasRenderer.prototype.addOne = function(element) {
      var renderer;
      renderer = grumble[element.constructor.name + "Renderer"];
      if (renderer) {
        return new renderer(element).render();
      } else {
        return console.warn("no renderer attached for " + element);
      }
    };

    return CanvasRenderer;

  })();

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
      var copy, selection;
      if (event.key === 'delete') {
        selection = paper.project.selectedItems[0];
        if (selection) {
          if (selection.closed) {
            return grumble.Node.destroy(selection.spine_id);
          } else {
            return grumble.Link.destroy(selection.spine_id);
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

  grumble.LinkTool = (function(_super) {
    var DraftLink, DraftingLayer;

    __extends(LinkTool, _super);

    LinkTool.name = 'LinkTool';

    function LinkTool() {
      return LinkTool.__super__.constructor.apply(this, arguments);
    }

    LinkTool.prototype.parameters = {
      'strokeColor': 'black',
      'strokeStyle': 'solid'
    };

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
      var attributes, hitResult, l, link, s;
      if (this.drafting) {
        hitResult = this.draftingLayer.hitTest(event.point);
        if (hitResult && hitResult.item.closed) {
          attributes = this.parameters;
          link = this.draftLink.finalise();
          attributes.sourceId = this.draftingLayer.hitTest(link.firstSegment.point).item.spine_id;
          attributes.targetId = this.draftingLayer.hitTest(link.lastSegment.point).item.spine_id;
          this.draftingLayer.dispose();
          attributes.segments = (function() {
            var _i, _len, _ref, _results;
            _ref = link.segments;
            _results = [];
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              s = _ref[_i];
              _results.push({
                point: {
                  x: s.point.x,
                  y: s.point.y
                },
                handleIn: {
                  x: s.handleIn.x,
                  y: s.handleIn.y
                },
                handleOut: {
                  x: s.handleOut.x,
                  y: s.handleOut.y
                }
              });
            }
            return _results;
          })();
          console.log("creating link");
          l = new grumble.Link(attributes);
          console.log("created: " + l);
          l.save();
          console.log("saved");
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
      var attributes, node;
      attributes = this.parameters;
      attributes['position'] = event.point;
      node = new grumble.Node(this.parameters);
      console.log("created:");
      console.log(node);
      node.save();
      console.log("saved");
      if (paper.project.selectedItems[0]) {
        return paper.project.selectedItems[0].selected = false;
      }
    };

    return NodeTool;

  })(grumble.Tool);

}).call(this);


/*
  @depend tool.js
  @depend ../models/node.js
*/


(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  grumble.SelectTool = (function(_super) {

    __extends(SelectTool, _super);

    SelectTool.name = 'SelectTool';

    function SelectTool() {
      return SelectTool.__super__.constructor.apply(this, arguments);
    }

    SelectTool.prototype.parameters = {};

    SelectTool.prototype.origin = null;

    SelectTool.prototype.destination = null;

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
      var item, link, node, _i, _len, _ref;
      item = paper.project.selectedItems[0];
      if (item && item.closed) {
        this.destination = event.point;
        node = grumble.Node.find(item.spine_id);
        node.position = this.destination;
        _ref = node.links();
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          link = _ref[_i];
          this.reconnect(link, node);
        }
        return node.save();
      }
    };

    SelectTool.prototype.reconnect = function(link, node) {
      var el, offset, s;
      el = this.elementFor(link);
      console.log("Reconnecting " + link + " to " + node);
      console.log("Using " + el);
      if (link.sourceId === node.id) {
        offset = el.firstSegment.point.subtract(this.origin);
        el.removeSegment(0);
        el.insert(0, this.destination.add(offset));
      }
      if (link.targetId === node.id) {
        offset = el.lastSegment.point.subtract(this.origin);
        el.removeSegment(link.segments.size - 1);
        el.add(this.destination.add(offset));
      }
      el.simplify(100);
      link.segments = (function() {
        var _i, _len, _ref, _results;
        _ref = el.segments;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          s = _ref[_i];
          _results.push({
            point: {
              x: s.point.x,
              y: s.point.y
            },
            handleIn: {
              x: s.handleIn.x,
              y: s.handleIn.y
            },
            handleOut: {
              x: s.handleOut.x,
              y: s.handleOut.y
            }
          });
        }
        return _results;
      })();
      return link.save();
    };

    SelectTool.prototype.elementFor = function(link) {
      var el, matches;
      matches = (function() {
        var _i, _len, _ref, _results;
        _ref = paper.project.activeLayer.children;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          el = _ref[_i];
          if (el.spine_id === link.id && !el.closed) {
            _results.push(el);
          }
        }
        return _results;
      })();
      return matches[0];
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
      return grumble.tools = {
        node: new grumble.NodeTool(),
        select: new grumble.SelectTool(),
        link: new grumble.LinkTool()
      };
    };

    Toolbox.prototype.reactToToolSelection = function() {
      return $('body').on('click', 'a[data-tool]', function(event) {
        var tool, tool_name;
        tool_name = $(this).attr('data-tool');
        tool = grumble.tools[tool_name];
        if (tool) {
          return tool.activate();
        }
      });
    };

    Toolbox.prototype.reactToToolConfiguration = function() {
      return $('body').on('click', 'button[data-tool-parameter-value]', function(event) {
        var key, value, _base;
        value = $(this).attr('data-tool-parameter-value');
        key = $(this).parent().attr('data-tool-parameter');
        (_base = grumble.tool).parameters || (_base.parameters = {});
        return grumble.tool.parameters[key] = value;
      });
    };

    return Toolbox;

  })();

}).call(this);


/*
  @depend tools/toolbox.js
  @depend renderers/canvas_renderer.js
*/


(function() {

  Array.prototype.remove = function(e) {
    var t, _ref;
    if ((t = this.indexOf(e)) > -1) {
      return ([].splice.apply(this, [t, t - t + 1].concat(_ref = [])), _ref);
    }
  };

  window.onload = function() {
    paper.setup($('canvas')[0]);
    new grumble.CanvasRenderer().install();
    new grumble.Toolbox().install();
    return paper.view.draw();
  };

}).call(this);

