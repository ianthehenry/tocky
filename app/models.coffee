Tocky.Message = DS.Model.extend
  content: DS.attr('string')
  isUnread: DS.attr('boolean')
  room: DS.belongsTo('room')
  time: DS.attr('date')
  user: DS.belongsTo('user')

Tocky.Room = DS.Model.extend
  name: DS.attr('string')
  messages: DS.hasMany('message')
  users: DS.hasMany('user', { async: true })

Tocky.User = DS.Model.extend
  name: DS.attr('string')
  email: DS.attr('string')
