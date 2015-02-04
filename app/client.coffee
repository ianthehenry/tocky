pluralize = (typeName) -> typeName + 's'
just = (obj) ->
  new Ember.RSVP.Promise (resolve, reject) ->
    resolve(obj)
fail = (message) ->
  new Ember.RSVP.Promise (resolve, reject) ->
    reject(message)

serializers =
  user: new EMS.Serializer 'user',
    id: {}
    name: {}
    email: {}
    hash: {}
  message: new EMS.Serializer 'message',
    id: {}
    time:
      transform: (a) -> new Date(a)
    content: {}
    viewed:
      key: 'unread'
      transform: (a) -> !a
  room: new EMS.Serializer 'room',
    id: {}
    name: {}

serializers.message.map 'user', {key: 'sender', transform: serializers.user}

window.TockyClient = Ember.Object.extend
  headers: {}
  init: ->
    @store = new EMS.Store(TockySchema, serializers)
  ajax: (method, urlComponents, params) ->
    $.ajax ['http://localhost:3000'].concat(urlComponents).join('/'),
      type: method
      headers: @headers
      data: params

  find: (typeName, id, cached=false) ->
    model = @store.find typeName, id
    if model?
      return just model
    else if cached
      return fail "#{typeName}##{id} is not cached"

    @ajax 'GET', [pluralize(typeName), id]
    .then (payload) =>
      @store.create typeName, payload[typeName]

  pushMany: (typeName, datas) ->
    for data in datas
      @store.upsert typeName, data

  loadMessages: (target) ->
    key = 'room'
    @ajax 'GET', ["#{key}s", target.get('id'), 'messages'], {limit: 30}
    .then (payload) =>
      messages = @pushMany 'message', payload.messages
      for message in messages
        message.set(key, target)
      target.get('messages').addObjects messages
  loadUserships: (room) ->
    @ajax 'GET', ['rooms', room.get('id'), 'usership']
    .then (payload) =>
      users = @pushMany 'user', payload.users
      room.get('users').addObjects users
  messagesSyncing: 0
  postMessage: (room, content) ->
    postData = {content}
    @incrementProperty('messagesSyncing')
    @ajax 'POST', ['rooms', room.get('id'), 'messages'], {content}
    .then (payload) =>
      @decrementProperty('messagesSyncing')
      @pushMessage room, payload
    .fail (error) =>
      @decrementProperty('messagesSyncing')
      debugger

  pushMessage: (room, payload) ->
    message = @store.upsert 'message', payload.message
    room.get('messages').addObject message
