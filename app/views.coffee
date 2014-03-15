Tocky.ApplicationView = Ember.View.extend
  elementId: 'body'

Tocky.SmartTextComponent = Ember.TextArea.extend
  becomeFocused: util.on 'didInsertElement', ->
    @$().focus()
  keyDown: (e) ->
    if e.which == 13 and not e.shiftKey
      @sendAction('enter-down')
      e.preventDefault()
