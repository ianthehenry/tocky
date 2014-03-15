Tocky.ApplicationRoute = Ember.Route.extend()

Tocky.Router.map ->
  @resource 'rooms', { path: '/rooms' }, ->
    @resource 'room', { path: '/:room_id' }

Tocky.RoomsRoute = Ember.Route.extend
  model: ->
    @store.find('room')

