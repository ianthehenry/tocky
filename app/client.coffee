pluralize = (typeName) -> typeName + 's'
just = (obj) ->
  new Ember.RSVP.Promise (resolve, reject) ->
    resolve(obj)
fail = (message) ->
  new Ember.RSVP.Promise (resolve, reject) ->
    reject(message)

normalizeMessagesPayload = (payload) ->
  users = {}
  for message in payload.messages
    user = message.user
    message.user = user.id
    users[user.id] = user
  payload.users = (user for id, user of users)

window.TockyClient = Ember.Object.extend
  headers: {}
  init: ->
    @store = new EMS.Store(TockySchema)
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

  loadMessages: (room) ->
    @ajax 'GET', ['rooms', room.get('id'), 'messages'], {limit: 30}
    .then (payload) =>
      normalizeMessagesPayload(payload)
      @pushMany 'user', payload.users
      messages = @pushMany 'message', payload.messages
      for message in messages
        message.set('user', @store.find('user', message.get('user')))
        message.set('room', room)
      room.get('messages').addObjects messages
  loadUsers: (room) ->
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

  # currently ignores the user argument; it must be called with the logged in user
  # theoretically this should instantly create a local object
  # and then try to push it. for science, you know
  pushMessage: (room, payload) ->
    user = @store.find('user', payload.message.user.id)
    delete payload.message.user
    message = @store.upsert 'message', payload.message
    message.set 'user', user
    room.get('messages').addObject message
