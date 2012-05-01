
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
