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
      @create typeName, data
  update: (model, data) ->
    util.assert(data.id == model.get('id'))
    for own key, value of data when key != 'id'
      model.set(key, value)
    model
  create: (typeName, data) ->
    @_insert @schema.models[typeName].create data

SortedSet = Ember.ArrayProxy.extend
  _simpleCompare: (a, b) ->
    if a < b then -1
    else if a == b then 0
    else 1
  _compare: (a, b) ->
    for descriptor in @sortDescriptors
      util.assert descriptor[0] in ['+', '-'], "Invalid descriptor #{descriptor}!"
      ascending = descriptor[0] == '+'
      key = descriptor[1...]
      result = @_simpleCompare(a.get(key), b.get(key))
      if result == 0
        continue
      return result * (if ascending then 1 else -1)
    return 0
  _indexToInsert: (obj) ->
    content = @get('content')
    start = 0
    end = content.length - 1
    while end >= start
      middle = (start + end) // 2
      switch @_compare(obj, content[middle])
        when -1
          end = middle - 1
        when 0
          return middle
        when 1
          start = middle + 1
    if end < start
      start
    else
      end

  _insert: (obj) ->
    @get('content').replace @_indexToInsert(obj), 0, [obj]

  init: (@collection, @sortDescriptors) ->
    @set 'content', []
    @collection.addEnumerableObserver this,
      willChange: (collection, removing, adding) =>
      didChange: (collection, removing, adding) =>
        if adding?
          for obj in adding
            @_insert obj
        if removing?
          @get('content').removeObjects removing
    @_super(arguments...)

window.EMS = {Schema, Store, SortedSet}

