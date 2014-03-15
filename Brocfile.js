module.exports = function (broccoli) {
  var coffee = require('broccoli-coffee');
  var stylus = require('broccoli-stylus');
  // var js = require('broccoli-static-compiler');

  var dependencies = new broccoli.MergedTree(broccoli.bowerTrees());
  var scripts = coffee(broccoli.makeTree('app'), { bare: true });
  var styles = stylus(broccoli.makeTree('styles'));

  return [dependencies, scripts, styles];
}
