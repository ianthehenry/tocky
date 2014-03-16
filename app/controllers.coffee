Tocky.ApplicationController = Ember.Controller.extend
  savedTransition: null

Tocky.RoomController = Ember.ObjectController.extend
  actions:
    sendMessage: ->
      text = @get('nextMessageText')
      @set('nextMessageText', "")
      if text.trim().length == 0
        return

      message = @store.createRecord 'message',
        content: text
        time: new Date()
        isUnread: false
        room: @get('model')
      @get('model.messages').then (messages) ->
        messages.pushObject(message)
      message.save()

Tocky.MessagesController = Ember.ArrayController.extend
  needs: ['room']
  itemController: 'message'

Tocky.MessageController = Ember.ObjectController.extend
  text: util.prop 'model.content', -> @get('model.content')

Tocky.LoginController = Ember.Controller.extend
  email: "user@user.user"
  password: "user"
