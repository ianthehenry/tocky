window.Wocket = Ember.Object.extend
  init: (host, @me, client) ->
    @queuedMessages = []
    @set 'client', client
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
  flushIfDone: util.observes 'client.messagesSyncing', ->
    if @get('client.messagesSyncing') > 0
      return
    for args in @queuedMessages
      @handlers.chat.apply(this, args)
    @queuedMessages = []
  handlers:
    logOn: (roomDatas, state) ->
      rooms = @get('client').pushMany('room', roomDatas)
      @me.get('rooms').addObjects rooms
      return
    chat: (messageData, roomData) ->
      if @get('client.messagesSyncing') > 0
        @queuedMessages.push arguments
        return

      @get('client').find 'room', roomData.id, true
      .then (room) =>
        @get('client').pushMessage room, {message: messageData}
      .catch (message) =>
        debugger
      return
  willDestroy: ->
    @connection.disconnect()
    @connection = null
