window.Tocky = Ember.Application.create();

Tocky.ApplicationView = Ember.View.extend({
  elementId: 'body'
});

Tocky.RoomController = Ember.ObjectController.extend({
  actions: {
    sendMessage: function() {
      text = this.get('nextMessageText');
      this.set('nextMessageText', "")
      if (text.trim().length == 0) {
        return;
      }

      var message = this.store.createRecord('message', {
        user: 'me',
        text: text,
        time: new Date(),
        isUnread: false,
        room: this.get('model')
      });
      message.save();
    }
  }
});

Tocky.SmartTextComponent = Ember.TextArea.extend({
  becomeFocused: function() {
    this.$().focus();
  }.on('didInsertElement'),
  keyDown: function(e) {
    if (e.which == 13 && !e.shiftKey) {
      this.sendAction('enter-down');
      e.preventDefault();
    }
  }
});

Tocky.ApplicationAdapter = DS.RESTAdapter.extend({
  host: 'localhost:3000'
});


$.ajax({
  type: 'POST',
  url: 'http://localhost:3000/sessions/auth',
  data: {email:'user@user.user', password: 'user' },
  success: function(body, uselessBullshit, xhr) {
    console.log(xhr);
    debugger
  },
  error: function() {
    console.error(arguments);
  }
});
