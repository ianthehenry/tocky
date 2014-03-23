window.TockySchema = EMS.Schema.create()
TockySchema.registerType 'user',
  init: ->
    @set 'rooms', new Ember.Set()
TockySchema.registerType 'room',
  init: ->
    @set 'users', new Ember.Set()
    @set 'messages', new Ember.Set()
TockySchema.registerType 'message'
