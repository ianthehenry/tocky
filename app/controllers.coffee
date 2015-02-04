meMixin = Ember.Mixin.create
  me: (key) ->
    me = @get('controllers.authenticated').get('model')
    if key then me.get(key) else me

moment.lang 'en',
  calendar:
    lastDay: '[Yesterday]',
    sameDay: '[]',
    nextDay: '[Tomorrow]',
    lastWeek: '[Last] dddd',
    nextWeek: '[Next] dddd',
    sameElse: 'ddd, MMM D YYYY'

Tocky.ApplicationController = Ember.Controller.extend
  savedTransition: null

Tocky.AuthenticatedController = Ember.ObjectController.extend
  socketState: Ember.computed.alias('wocket.state')
  rooms: util.readOnly ->
    new EMS.SortedSet @get('model').get('rooms'), [{key: 'name', asc: true}]
  conversations: util.readOnly ->
    new EMS.SortedSet @get('model').get('conversations'), [{key: 'name', asc: true}]

Tocky.RoomController = Ember.ObjectController.extend meMixin,
  needs: ['authenticated']
  messages: util.prop 'model', ->
    new EMS.SortedSet @get('model.messages'), [{key: 'time', asc: true}]
  users: util.prop 'model', ->
    new EMS.SortedSet @get('model.users'), [{key: 'name', asc: true}]
  actions:
    sendMessage: ->
      content = @get('nextMessageContent')
      @set('nextMessageContent', "")
      if content.trim().length == 0
        return
      Tocky.client.postMessage @get('model'), content

Tocky.MessageController = Ember.ObjectController.extend
  needs: ['messages']
  htmlContent: util.prop 'model.content', ->
    # TODO: obviously
    @get('model.content')
    .replace(/&/g, '&amp;')
    .replace(/>/g, '&gt;')
    .replace(/</g, '&lt;')
  time: util.prop 'model.time', ->
    moment(@get('model.time')).format('LT')
  date: util.prop 'model.time', ->
    moment(@get('model.time')).calendar()
  isNewSender: util.prop ->
    prevSender = @get('previousMessage.sender')
    currentSender = @get('model.sender')
    return prevSender != currentSender
  isNewTime: util.prop ->
    not moment(@get('model.time')).isSame(@get('previousMessage.time'), 'minute')
  showTimeStamp: Ember.computed.or('isNewSender', 'isNewTime')
  showSender: util.prop ->
    if @get('isNewSender')
      return true
    @get('model.time') - @get('previousMessage.time') > 5 * 60 * 1000
  previousMessage: util.prop ->
    # TODO: quadratic; doesn't update properly
    index = @parentController.indexOf(@get('model'))
    if index == 0
      return null
    else
      return @parentController.objectAt(index - 1)

Tocky.LoginController = Ember.Controller.extend
  email: "user@user.user"
  password: "user"
