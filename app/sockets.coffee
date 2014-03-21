window.Wocket = Ember.Object.extend
  init: (host, @store, @user) ->
    @connection = io.connect host
    @set('state', 'connecting')
    hasConnectedBefore = false

    @connection.on 'connect', =>
      $.post 'http://localhost:3000/join',
        socket_id: @connection.socket.sessionid
        reconnect: hasConnectedBefore
      .fail (..., error) =>
        console.error error
      @set('state', 'connected')
      hasConnectedBefore = true
    @connection.on 'disconnect', =>
      @set('state', 'disconnected')

    @connection.on 'message', ({event, data: args}) =>
      @handlers[event]?.apply(this, args)

    @_super(arguments...)
  handlers:
    logOn: (rooms, state) ->
      @store.pushPayload('room', {rooms})
      Ember.RSVP.all(@store.find('room', id) for {id} in rooms).then (rooms) =>
        rooms.forEach (room) =>
          @user.get('rooms').pushObject room
      return
    chat: (message, room) ->
      message.room = room.id
      message.user = message.user.id
      @store.pushPayload('message', {messages: [message]})
      # yes, this shit again
      @store.find('message', message.id).then (message) =>
        if message.get('user') != @user
          message.get('room.messages').then (messages) =>
            messages.pushObject message
  willDestroy: ->
    @connection.disconnect()
    @connection = null
