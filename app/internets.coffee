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
  normalizePayload: (type, payload) ->
    payload.users = [payload.message.user]
    payload.message.user = payload.message.user.id
    payload
