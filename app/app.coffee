gui = require('nw.gui')
win = gui.Window.get()

$(window).on 'keydown', (e) ->
  if e.which == 82 and e.metaKey
    gui.App.clearCache()
    win.reloadIgnoringCache()

window.Tocky = Ember.Application.create
  LOG_TRANSITIONS: true
  LOG_ACTIVE_GENERATION: true
  LOG_MODULE_RESOLVER: true
