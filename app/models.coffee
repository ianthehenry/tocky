window.TockySchema = EMS.Schema.create()
TockySchema.registerModel 'user',
  init: ->
    @set 'rooms', new Ember.Set()
TockySchema.registerModel 'room',
  init: ->
    @set 'users', new Ember.Set()
    @set 'messages', new Ember.Set()
TockySchema.registerModel 'message'
