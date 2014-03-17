Tocky.AuthenticatedView = Ember.View.extend
  elementId: 'body'

Tocky.SmartTextComponent = Ember.TextArea.extend
  becomeFocused: util.on 'didInsertElement', ->
    @$().focus()
  preventBlur: util.on 'focusOut', (e) ->
    unless @get('isDestroying')
      # sue me
      setTimeout (=> @$().focus()), 0


  keyDown: (e) ->
    if e.which == 13 and not e.shiftKey
      @sendAction('enter-down')
      e.preventDefault()
