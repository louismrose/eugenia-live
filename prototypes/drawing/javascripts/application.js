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

    Link.configure("Link", "segments", "strokeColor", "strokeStyle");

    Link.extend(Spine.Model.Local);

    function Link(attributes) {
      this.target = __bind(this.target, this);

      this.source = __bind(this.source, this);

      this.updateNodes = __bind(this.updateNodes, this);

      var k, v;
      Link.__super__.constructor.apply(this, arguments);
      for (k in attributes) {
        v = attributes[k];
        this[k] = v;
      }
      this.bind("save", this.updateNodes);
    }

    Link.prototype.updateNodes = function() {
      if (this.source_id) {
        this.source().addLink(this.id);
      }
      if (this.source_id !== this.target_id) {
        return this.target().addLink(this.id);
      }
    };

    Link.prototype.source = function() {
      return grumble.Node.find(this.source_id);
    };

    Link.prototype.target = function() {
      return grumble.Node.find(this.target_id);
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
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  grumble.Node = (function(_super) {

    __extends(Node, _super);

    Node.name = 'Node';

    Node.configure("Node", "link_ids", "shape", "position", "fillColor", "strokeColor", "strokeStyle");

    Node.extend(Spine.Model.Local);

    function Node(attributes) {
      this.destroyLinks = __bind(this.destroyLinks, this);

      this.addLink = __bind(this.addLink, this);

      var k, v;
      Node.__super__.constructor.apply(this, arguments);
      for (k in attributes) {
        v = attributes[k];
        this[k] = v;
      }
      this.link_ids = [];
      this.bind("destroy", this.destroyLinks);
    }

    Node.prototype.addLink = function(id) {
      return this.link_ids.push(id);
    };

    Node.prototype.destroyLinks = function() {
      var id, _i, _len, _ref, _results;
      _ref = this.link_ids;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        id = _ref[_i];
        _results.push(grumble.Link.destroy(id));
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
      console.log("rendering " + this.item);
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
      this.el.links = [];
      this.el.spine_id = this.item.id;
      this.el.fillColor = this.item.fillColor;
      this.el.strokeColor = this.item.strokeColor;
      return this.el.dashArray = this.item.strokeStyle === 'solid' ? [10, 0] : [10, 4];
    };

    NodeRenderer.prototype.remove = function(node) {
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
      var s, segments;
      console.log("rendering " + this.item);
      console.log("there are now " + grumble.Link.count() + " links");
      console.log(this.item);
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
      return paper.view.draw();
    };

    LinkRenderer.prototype.remove = function(node) {
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

  grumble.AppRenderer = (function() {

    AppRenderer.name = 'AppRenderer';

    AppRenderer.prototype.renderers = {};

    function AppRenderer() {
      this.addOne = __bind(this.addOne, this);

      this.addAll = __bind(this.addAll, this);

      var _this = this;
      grumble.Node.bind("refresh", function() {
        return _this.addAll(grumble.Node);
      });
      grumble.Link.bind("refresh", function() {
        return _this.addAll(grumble.Link);
      });
      grumble.Node.bind("create", this.addOne);
      grumble.Link.bind("create", this.addOne);
      grumble.Node.fetch();
      grumble.Link.fetch();
    }

    AppRenderer.prototype.addAll = function(type) {
      console.log("adding all " + type.count() + " " + type.name + "s");
      return type.each(this.addOne);
    };

    AppRenderer.prototype.addOne = function(element) {
      var renderer;
      renderer = grumble[element.constructor.name + "Renderer"];
      if (renderer) {
        return new renderer(element).render();
      } else {
        return console.warn("no renderer attached for " + element);
      }
    };

    return AppRenderer;

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

      this.install = __bind(this.install, this);

    }

    CanvasRenderer.prototype.renderers = {};

    CanvasRenderer.prototype.install = function() {
      var _this = this;
      grumble.Node.bind("refresh", function() {
        return _this.addAll(grumble.Node);
      });
      grumble.Link.bind("refresh", function() {
        return _this.addAll(grumble.Link);
      });
      grumble.Node.bind("create", this.addOne);
      grumble.Link.bind("create", this.addOne);
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
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  grumble.LinkRenderer = (function() {

    LinkRenderer.name = 'LinkRenderer';

    LinkRenderer.prototype.item = null;

    LinkRenderer.prototype.el = null;

    function LinkRenderer(item) {
      this.remove = __bind(this.remove, this);

      this.render = __bind(this.render, this);
      this.item = item;
      this.item.bind("update", this.render);
      this.item.bind("destroy", this.remove);
    }

    LinkRenderer.prototype.render = function() {
      var s, segments;
      console.log("rendering " + this.item);
      console.log("there are now " + grumble.Link.count() + " links");
      console.log(this.item);
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
      return paper.view.draw();
    };

    LinkRenderer.prototype.remove = function(node) {
      return this.el.remove();
    };

    return LinkRenderer;

  })();

}).call(this);


/*
  @depend ../namespace.js
*/


(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  grumble.NodesRenderer = (function() {

    NodesRenderer.name = 'NodesRenderer';

    function NodesRenderer() {
      this.addAllLinks = __bind(this.addAllLinks, this);

      this.addAllNodes = __bind(this.addAllNodes, this);

      this.addOne = __bind(this.addOne, this);
      grumble.Node.bind("refresh", this.addAllNodes);
      grumble.Link.bind("refresh", this.addAllLinks);
      grumble.Node.bind("create", this.addOne);
      grumble.Link.bind("create", this.addOne);
      grumble.Node.fetch();
      grumble.Link.fetch();
    }

    NodesRenderer.prototype.addOne = function(element) {
      console.log("one element added");
      return new grumble.NodeRenderer(element).render();
    };

    NodesRenderer.prototype.addAllNodes = function() {
      console.log("adding all " + grumble.Node.count() + " nodes");
      return grumble.Node.each(this.addOne);
    };

    NodesRenderer.prototype.addAllLinks = function() {
      console.log("adding all " + grumble.Link.count() + " links");
      return grumble.Link.each(this.addOne);
    };

    return NodesRenderer;

  })();

  grumble.NodeRenderer = (function() {

    NodeRenderer.name = 'NodeRenderer';

    NodeRenderer.prototype.item = null;

    NodeRenderer.prototype.el = null;

    function NodeRenderer(item) {
      this.remove = __bind(this.remove, this);

      this.renderLink = __bind(this.renderLink, this);

      this.renderNode = __bind(this.renderNode, this);

      this.render = __bind(this.render, this);
      this.item = item;
      this.item.bind("update", this.render);
      this.item.bind("destroy", this.remove);
    }

    NodeRenderer.prototype.render = function() {
      console.log("rendering " + this.item);
      if (this.item instanceof grumble.Node) {
        return this.renderNode();
      } else {
        return this.renderLink();
      }
    };

    NodeRenderer.prototype.renderNode = function() {
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
      this.el.links = [];
      this.el.spine_id = this.item.id;
      this.el.fillColor = this.item.fillColor;
      this.el.strokeColor = this.item.strokeColor;
      return this.el.dashArray = this.item.strokeStyle === 'solid' ? [10, 0] : [10, 4];
    };

    NodeRenderer.prototype.renderLink = function() {
      var s, segments;
      console.log("there are now " + grumble.Link.count() + " links");
      console.log(this.item);
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
      return paper.view.draw();
    };

    NodeRenderer.prototype.remove = function(node) {
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

  grumble.NodeRenderer = (function() {

    NodeRenderer.name = 'NodeRenderer';

    NodeRenderer.prototype.item = null;

    NodeRenderer.prototype.el = null;

    function NodeRenderer(item) {
      this.remove = __bind(this.remove, this);

      this.render = __bind(this.render, this);
      this.item = item;
      this.item.bind("update", this.render);
      this.item.bind("destroy", this.remove);
    }

    NodeRenderer.prototype.render = function() {
      console.log("rendering " + this.item);
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
      this.el.links = [];
      this.el.spine_id = this.item.id;
      this.el.fillColor = this.item.fillColor;
      this.el.strokeColor = this.item.strokeColor;
      return this.el.dashArray = this.item.strokeStyle === 'solid' ? [10, 0] : [10, 4];
    };

    NodeRenderer.prototype.remove = function(node) {
      return this.el.remove();
    };

    return NodeRenderer;

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

  paper.LinkTool = (function(_super) {
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
          attributes.source_id = this.draftingLayer.hitTest(link.firstSegment.point).item.spine_id;
          attributes.target_id = this.draftingLayer.hitTest(link.lastSegment.point).item.spine_id;
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

  paper.NodeTool = (function(_super) {

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
  @depend renderers/canvas_renderer.js
*/


(function() {

  window.onload = function() {
    paper.setup($('canvas')[0]);
    new grumble.Toolbox().install();
    new grumble.CanvasRenderer().install();
    return paper.view.draw();
  };

}).call(this);

