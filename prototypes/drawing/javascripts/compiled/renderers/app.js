
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
