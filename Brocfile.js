module.exports = function (broccoli) {
  var coffee = require('broccoli-coffee');
  var stylus = require('broccoli-stylus');

  var dependencies = new broccoli.MergedTree(broccoli.bowerTrees());
  var scripts = coffee(broccoli.makeTree('app'));
  var styles = stylus(broccoli.makeTree('app/styles'));

  return [dependencies, scripts, styles];
}
