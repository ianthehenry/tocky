Tocky.Message = DS.Model.extend
  content: DS.attr 'string'
  isUnread: DS.attr 'boolean'
  room: DS.belongsTo 'room', inverse: 'messages'
  time: DS.attr 'date'
  user: DS.belongsTo 'user'

Tocky.Room = DS.Model.extend
  name: DS.attr 'string'
  messages: DS.hasMany 'message', async: true, inverse: 'room'
  users: DS.hasMany 'user', async: true, inverse: 'rooms'

Tocky.User = DS.Model.extend
  name: DS.attr 'string'
  email: DS.attr 'string'
  hash: DS.attr 'string'
  rooms: DS.hasMany 'room', async: true, inverse: 'users'
