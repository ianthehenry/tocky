meMixin = Ember.Mixin.create
  me: (key) ->
    me = @get('controllers.authenticated').get('model')
    if key then me.get(key) else me

Tocky.ApplicationController = Ember.Controller.extend
  savedTransition: null

Tocky.AuthenticatedController = Ember.ObjectController.extend
  socketState: Ember.computed.alias('wocket.state')

Tocky.RoomController = Ember.ObjectController.extend meMixin,
  needs: ['authenticated']
  actions:
    sendMessage: ->
      text = @get('nextMessageText')
      @set('nextMessageText', "")
      if text.trim().length == 0
        return
      message = @store.createRecord 'message',
        content: text
        time: new Date()
        isUnread: false
        user: @me()
        room: @get('model')
      @get('model.messages').then (messages) ->
        messages.pushObject(message)
      message.save()

Tocky.MessageController = Ember.ObjectController.extend
  needs: ['messages']
  htmlContent: util.prop 'model.content', ->
    # TODO: obviously
    @get('model.content')
    .replace(/&/g, '&amp;')
    .replace(/>/g, '&gt;')
    .replace(/</g, '&lt;')
  formatTime: (jsDate) ->
    moment(jsDate).format('h:mm A')
  time: util.prop 'model.time', ->
    @formatTime(@get('model.time'))
  isRepeatSender: util.getter ->
    prevSender = @get('previousMessage.user')
    currentSender = @get('model.user')
    return prevSender == currentSender
  isRepeatTime: util.getter ->
    @formatTime(@get('model.time')) == @formatTime(@get('previousMessage.time'))
  previousMessage: util.prop ->
    # TODO: quadratic; doesn't update properly
    index = @parentController.indexOf(@get('model'))
    if index == 0
      return null
    else
      return @parentController.objectAt(index - 1)

Tocky.LoginController = Ember.Controller.extend
  email: "user@user.user"
  password: "user"
