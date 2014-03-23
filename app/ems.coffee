Schema = Ember.Object.extend
  init: ->
    @ModelClass = Ember.Object.extend
      schema: this
      createRecord: (data) ->
        @create(data)
    @types = {}
  registerType: (typeName, attributes) ->
    @types[typeName] = @ModelClass.extend(attributes ? {})
    @types[typeName].typeName = typeName

Serializer = Ember.Object.extend
  init: (@typeName, @attrs={}) ->
  map: (key, mapping) ->
    @attrs[key] = mapping
  loadInto: (model, data) ->
    prev_id = model.get('id')
    for own rawKey, rawValue of data
      mapping = @attrs[rawKey]
      if not mapping?
        continue
      @mapAttr model, rawKey, rawValue, mapping
    util.assert (!prev_id? or model.get('id') == prev_id), "cannot change id of a model!"
    return
  mapAttr: (model, rawKey, rawValue, mapping) ->
    key = mapping.key ? rawKey
    value = @applyTransform(mapping.transform, rawValue, model.store)
    model.set key, value
  applyTransform: (transform, rawValue, store) ->
    if not transform?
      return rawValue
    if transform instanceof Serializer
      store.upsert transform.typeName, rawValue, transform
    else
      transform rawValue

Store = Ember.Object.extend
  init: (@schema, @serializers) ->
    @reset()
  reset: ->
    @_cache = {}
    for typeName, type of @schema.types
      @_cache[typeName] = {}
    return
  find: (typeName, id) ->
    @_cache[typeName][id]
  _insert: (model) ->
    util.assert model.get('id'), "cannot insert a model with no id"
    @_cache[model.constructor.typeName][model.get('id')] = model
  upsert: (typeName, data, serializer=@serializers[typeName]) ->
    util.assert data.id?, "cannot upsert data with no id"
    model = @find(typeName, data.id)
    if model?
      @update model, data, serializer
    else
      @create typeName, data, serializer
  update: (model, data, serializer=@serializers[model.constructor.typeName]) ->
    util.assert(data.id == model.get('id'))
    serializer.loadInto(model, data)
    model
  create: (typeName, data, serializer=@serializers[typeName]) ->
    model = @schema.types[typeName].create()
    model.store = this
    serializer.loadInto(model, data)
    if model.get('id')?
      @_insert model
    model

SortedSet = Ember.ArrayProxy.extend
  init: (@collection, @sortDescriptors) ->
    @set 'content', []
    for obj in @collection
      @_insert obj
    @collection.addEnumerableObserver this,
      willChange: (collection, removing, adding) =>
      didChange: (collection, removing, adding) =>
        if adding?
          for obj in adding
            @_insert obj
        if removing?
          @get('content').removeObjects removing
        return
    @_super(arguments...)
  _insert: (obj) ->
    @get('content').replace @_indexToInsert(obj), 0, [obj]
  _indexToInsert: (obj) ->
    content = @get('content')
    start = 0
    end = content.length - 1
    while end >= start
      middle = (start + end) // 2
      switch @_compare(obj, content[middle])
        when -1 then end = middle - 1
        when 0 then return middle
        when 1 then start = middle + 1
    if end < start
      start
    else
      end
  _compare: (a, b) ->
    for {asc, key} in @sortDescriptors
      result = @_simpleCompare(a.get(key), b.get(key))
      if result == 0
        continue
      return result * (if asc then 1 else -1)
    return 0
  _simpleCompare: (a, b) ->
    if a < b then -1
    else if a == b then 0
    else 1

window.EMS = {Schema, Store, SortedSet, Serializer}
