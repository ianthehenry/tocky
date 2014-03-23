meMixin = Ember.Mixin.create
  me: (key) ->
    me = @get('controllers.authenticated').get('model')
    if key then me.get(key) else me



moment.lang 'en',
  calendar:
    lastDay: '[Yesterday at] LT',
    sameDay: 'LT',
    nextDay: '[Tomorrow at] LT',
    lastWeek: '[Last] dddd [at] LT',
    nextWeek: '[Next] dddd [at] LT',
    sameElse: 'ddd, MMM D YYYY [at] LT'

Tocky.ApplicationController = Ember.Controller.extend
  savedTransition: null

Tocky.AuthenticatedController = Ember.ObjectController.extend
  socketState: Ember.computed.alias('wocket.state')

Tocky.RoomController = Ember.ObjectController.extend meMixin,
  needs: ['authenticated']
  messages: util.prop 'model', ->
    new EMS.SortedSet @get('model.messages'), ['+time']
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
  formatTime: (jsDate) -> moment(jsDate).calendar()
  time: util.prop 'model.time', ->
    @formatTime(@get('model.time'))
  isRepeatSender: util.getter ->
    prevSender = @get('previousMessage.user')
    currentSender = @get('model.user')
    return prevSender == currentSender
  isRepeatTime: util.getter ->
    @formatTime(@get('model.time')) == @formatTime(@get('previousMessage.time'))
  showTimeStamp: Ember.computed.or('isNewSender', 'isNewTime')
  isNewTime: Ember.computed.not('isRepeatTime')
  isNewSender: Ember.computed.not('isRepeatSender')
  quiet: Ember.computed.and('isRepeatSender', 'isRepeatTime')
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
