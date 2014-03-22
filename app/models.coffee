window.TockySchema = EMS.Schema.create()
TockySchema.registerModel 'user',
  init: ->
    @set 'rooms', []
TockySchema.registerModel 'room',
  init: ->
    @set 'messages', []
TockySchema.registerModel 'message'
