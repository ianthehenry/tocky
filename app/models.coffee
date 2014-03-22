window.TockySchema = EMS.Schema.create()
TockySchema.registerModel 'user',
  init: ->
    @set 'rooms', new Ember.Set()
TockySchema.registerModel 'room',
  init: ->
    @set 'messages', []
TockySchema.registerModel 'message'
