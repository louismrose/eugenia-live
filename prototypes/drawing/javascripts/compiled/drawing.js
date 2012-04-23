(function() {

  window.onload = function() {
    paper.setup($('canvas')[0]);
    paper.view.draw();
    paper.toolbox = new paper.Toolbox();
    return paper.toolbox.install();
  };

}).call(this);
