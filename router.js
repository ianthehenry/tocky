Tocky.ApplicationRoute = Ember.Route.extend({
  model: function() {
  }
})

Tocky.Router.map(function() {
  this.resource('rooms', { path: '/rooms' }, function() {
    this.resource('room', { path: '/:room_id' });
  });
});

Tocky.RoomsRoute = Ember.Route.extend({
  model: function() {
    return this.store.find('room');
  }
});

