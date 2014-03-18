meMixin = Ember.Mixin.create
  me: (key) ->
    me = @get('controllers.authenticated').get('model')
    if key then me.get(key) else me

Tocky.ApplicationController = Ember.Controller.extend
  savedTransition: null

Tocky.AuthenticatedController = Ember.ObjectController.extend meMixin,
  needs: ['authenticated']
  init: ->
    wocket = io.connect 'http://localhost:3000'
    @set('socketState', 'connecting')
    hasConnectedBefore = false

    wocket.on 'connect', =>
      $.post 'http://localhost:3000/join',
        socket_id: wocket.socket.sessionid
        reconnect: hasConnectedBefore
      .fail (..., error) =>
        console.error error
      @set('socketState', 'connected')
      hasConnectedBefore = true
    wocket.on 'disconnect', =>
      @set('socketState', 'disconnected')

    wocket.on 'message', ({event, data: args}) =>
      @socketHandlers[event]?.apply(this, args)

    @_super(arguments...)
  socketHandlers:
    logOn: (rooms, state) ->
      @store.pushPayload('room', {rooms})
      Ember.RSVP.all(@store.find('room', id) for {id} in rooms).then (rooms) =>
        rooms.forEach (room) =>
          @me('rooms').pushObject room
      return
    chat: (message, room) ->
      message.room = room.id
      message.user = message.user.id
      @store.pushPayload('message', {messages: [message]})
      # yes, this shit again
      @store.find('message', message.id).then (message) =>
        if message.get('user') != @me()
          message.get('room.messages').then (messages) =>
            messages.pushObject message
      return

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

Tocky.LoginController = Ember.Controller.extend
  email: "user@user.user"
  password: "user"
