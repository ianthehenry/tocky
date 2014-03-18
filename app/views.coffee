Tocky.AuthenticatedView = Ember.View.extend
  elementId: 'body'

Tocky.SmartTextComponent = Ember.TextArea.extend
  becomeFocused: util.on 'didInsertElement', ->
    @$().focus()
  preventBlur: util.on 'focusOut', (e) ->
    # sue me
    setTimeout =>
      unless @get('isDestroying') or @get('isDestroyed')
        @$().focus()
    , 0


  keyDown: (e) ->
    if e.which == 13 and not e.shiftKey
      @sendAction('enter-down')
      e.preventDefault()


Tocky.InlineUserComponent = Ember.Component.extend
  tagName: 'span'
  classNames: ['user']
  gravatarUrl: util.prop 'user.hash', ->
    hash = @get('user').get('hash')
    "https://secure.gravatar.com/avatar/#{hash}?s=20&d=mm"
