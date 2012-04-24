(function() {

  window.onload = function() {
    paper.setup($('canvas')[0]);
    paper.view.draw();
    return new grumble.Toolbox().install();
  };

}).call(this);
