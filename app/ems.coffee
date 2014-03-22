assert = (val, message) ->
  console.assert(val, message)

Schema = Ember.Object.extend
  init: ->
    @ModelClass = Ember.Object.extend
      schema: this
      createRecord: (data) ->
        @create(data)
    @models = {}
  registerModel: (typeName, attributes) ->
    @models[typeName] = @ModelClass.extend(attributes ? {})
    @models[typeName].typeName = typeName

Store = Ember.Object.extend
  init: (@schema) ->
    @reset()
  reset: ->
    @_cache = {}
    for typeName, type of @schema.models
      @_cache[typeName] = {}
    return
  find: (typeName, id) ->
    @_cache[typeName][id]
  _insert: (model) ->
    @_cache[model.constructor.typeName][model.get('id')] = model
  upsert: (typeName, data) ->
    model = @find(typeName, data.id)
    if model?
      @update model, data
    else
      @create(typeName, data)
  update: (model, data) ->
    assert(data.id == model.get('id'))
    for own key, value of data
      model.set(key, value)
  create: (typeName, data) ->
    @_insert @schema.models[typeName].create data

window.EMS = {Schema, Store}
