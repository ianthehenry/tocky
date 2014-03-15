Tocky.Message = DS.Model.extend
  content: DS.attr('string')
  isUnread: DS.attr('boolean')
  room: DS.belongsTo('room')
  time: DS.attr('date')
  user: DS.attr('string')

Tocky.Room = DS.Model.extend
  name: DS.attr('string')
  messages: DS.hasMany('message')
