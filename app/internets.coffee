TockyAdapter = DS.RESTAdapter.extend
  host: 'http://localhost:3000'

Tocky.ApplicationAdapter = TockyAdapter
Tocky.MessageAdapter = TockyAdapter.extend
  createRecord: (store, type, record) ->
    serializer = store.serializerFor(type.typeKey)
    data = serializer.serialize record, { includeId: true }
    url = [@urlPrefix(), 'rooms', record.get('room.id'), 'messages'].join('/')
    return @ajax url, 'POST', { data }

Tocky.MessageSerializer = DS.RESTSerializer.extend
  extractSingle: (store, type, payload, id, requestType) ->
    payload.users = [payload.message.user]
    payload.message.user = payload.message.user.id
    @_super(arguments...)
  extractArray: (store, type, payload, id, requestType) ->
    users = {}
    for message in payload.messages
      user = message.user
      message.user = user.id
      users[user.id] = user
    payload.users = (user for id, user of users)
    @_super(arguments...)

Tocky.RoomSerializer = DS.RESTSerializer.extend
  extractArray: (store, type, payload, id, requestType) ->
    for room in payload.rooms
      room.links =
        users: "/rooms/#{room.id}/usership"
        messages: "/rooms/#{room.id}/messages"

    @_super(arguments...)
