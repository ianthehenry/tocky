Wocky.Router.map(function() {
  this.resource('rooms', { path: '/rooms' }, function() {
    this.resource('room', { path: '/:room_id' });
  });
});

Wocky.RoomsRoute = Ember.Route.extend({
  model: function() {
    return this.store.find('room');
  }
});
