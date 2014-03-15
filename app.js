var gui = require('nw.gui');
var win = gui.Window.get();

document.cookie = "chat.sessions=s%3Aj%3A%7B%7D.%2BShmKj0o2LB6DTbltC3MJEmnnoQOXWjYMX0%2BS2T2ZTA;";

window.Tocky = Ember.Application.create({
  LOG_TRANSITIONS: true,
  LOG_VIEW_LOOKUPS: true,
  LOG_ACTIVE_GENERATION: true
});

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
        content: text,
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

var TockyAdapter = DS.RESTAdapter.extend({
  host: 'http://localhost:3000'
});

Tocky.ApplicationAdapter = TockyAdapter;
Tocky.MessageAdapter = TockyAdapter.extend({
  createRecord: function(store, type, record) {
    var serializer = store.serializerFor(type.typeKey);
    var data = serializer.serialize(record, { includeId: true });
    var url = [this.urlPrefix(), 'rooms', record.get('room.id'), 'messages'].join('/');
    return this.ajax(url, "POST", { data: data });
  }
});

$(window).on('keydown', function(e) {
  if (e.which == 82 && e.metaKey) {
    gui.App.clearCache();
    win.reloadIgnoringCache();
  }
})

// RegExp.quote = function(str) {
//   return str.replace(/[.?*+^$[\]\\(){}|-]/g, "\\$&")
// }

// var getCookie = function(cookieName, res) {
//   var cookies = res.headers['set-cookie'];
//   var regex = new RegExp(RegExp.quote(cookieName) + "=([^;]+)(&|;)");
//   var result = null;
//   for (var i = 0; i < cookies.length; i++) {
//     match = regex.exec(cookies[i])
//     if (match != null) {
//       return match[1];
//     }
//   }
//   return null;
// }

// var http = require('http');
// var req = http.request({
//   hostname: 'localhost',
//   port: 3000,
//   method: 'POST',
//   path: '/sessions/auth',
//   headers: {
//     'X-Whatever': 'cool',
//     'Origin': 'localhost'
//   }
// }, function(res) {
//   var chatSession = getCookie('chat.session', res)
//   document.cookie = "chat.sessions=" + chatSession;
//   console.log("cookie = " + chatSession);
// });

// req.on('error', function(e) {
//   console.log('problem with request: ' + e.message);
//   debugger;
// });
// req.end();
