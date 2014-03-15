Tocky.Message = DS.Model.extend({
  content: DS.attr('string'),
  isUnread: DS.attr('boolean'),
  room: DS.belongsTo('room'),
  time: DS.attr('date'),
  user: DS.attr('string')
});

Tocky.Room = DS.Model.extend({
  name: DS.attr('string'),
  messages: DS.hasMany('message')
});

// Tocky.ApplicationSerializer = DS.RESTSerializer.extend({
//   extractSingle: function(store, type, payload, id, requestType) {
//     var messages = payload.post.messages,
//         messageIds = messages.mapProperty('id');

//     payload.messages = messages;
//     payload.room.messages = messageIds;

//     return this._super.apply(this, arguments);
//   }
// });

Tocky.Room.FIXTURES = []
