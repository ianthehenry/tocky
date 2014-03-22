window.Wocket = Ember.Object.extend
  init: (host, @me, @client) ->
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
      for room in @client.pushMany('room', rooms)
        @me.get('rooms').pushObject room
      return
    chat: (messageData, roomData) ->
      # we will probably receive a chat message before the POST response
      # has come back when we create a message.
      # this is gross and annoying, so we suspend operations until
      # the client is not creating any messages (because the only
      # way to tie it together is with the ID)
      # our current way of doing this is...hacky, to say the least
      if messageData.user.id == @me.get('id')
        console.log 'ignoring a chat that we made...possibly in another window'
        return
      @client.find 'room', roomData.id, true
      .then (room) =>
        @client.pushMessage room, {message: messageData}
      .catch (message) =>
        debugger
      return
  willDestroy: ->
    @connection.disconnect()
    @connection = null
