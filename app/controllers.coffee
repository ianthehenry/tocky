Tocky.ApplicationController = Ember.Controller.extend
  savedTransition: null

Tocky.AuthenticatedController = Ember.ObjectController.extend
  init: ->
    socket = io.connect 'http://localhost:3000'

    socket.on 'connect', =>
      console.log 'connected'
    socket.on 'disconnect', =>
      console.log "disconnected"
    socket.on 'message', (message) =>
      console.log "message #{message}"

    @_super(arguments...)


Tocky.RoomController = Ember.ObjectController.extend
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
        room: @get('model')
      @get('model.messages').then (messages) ->
        messages.pushObject(message)
      message.save()

Tocky.LoginController = Ember.Controller.extend
  email: "user@user.user"
  password: "user"
