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

# TODO: for some reason this gets inserted twice if you refresh
# the page while viewing a room. Seems like an Ember bug. Or
# an Ian doesn't know anything about Ember bug.
Tocky.MessagesView = Ember.View.extend
  elementId: 'messages-list'
  attached: true
  willDestroyElement: ->
    $(window).off 'resize' # TODO: detach this shit properly with namespaces or summat
    $().off 'scroll'
  didInsertElement: ->
    $(window).on 'resize', (e) =>
      if @attached
        @scrollToBottom()
    @$().on 'scroll', (e) =>
      distanceToBottom = @get('maxScrollBottom') - @get('scrollBottom')
      @attached = distanceToBottom < 10
  scrollBottom: util.getter ->
    el = @get('element')
    el.scrollTop + el.clientHeight
  maxScrollBottom: util.getter ->
    @get('element').scrollHeight
  didInsertChild: ->
    if @attached
      @scrollToBottom()
  scrollToBottom: ->
    # TODO: this is inelegant; learn more about view lifecycles
    el = @get('element')
    if not el?
      return
    el.scrollTop = el.scrollHeight - el.clientHeight

Tocky.MessageView = Ember.View.extend
  classNames: ['message']
  classNameBindings: ['controller.isRepeatSender:repeat-sender', 'controller.isRepeatTime:quick']
  templateName: 'message'
  didInsertElement: ->
    @get('parentView').didInsertChild()

Tocky.InlineUserComponent = Ember.Component.extend
  tagName: 'span'
  classNames: ['inline-user']
  gravatarUrl: util.prop 'user.hash', ->
    hash = @get('user').get('hash')
    "https://secure.gravatar.com/avatar/#{hash}?s=20&d=mm"
