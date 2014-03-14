Tocky.ApplicationRoute = Ember.Route.extend({
  model: function() {
    var messages = [
      {
        id: 1,
        user: "varys",
        text: "guys did you know @stannis is the master of ships?"
      },
      {
        id: 2,
        user: "selmy",
        text: "whoa i never really thought about that"
      },
      {
        id: 3,
        user: "stannis",
        text: "guys come on we've been doing this for years now"
      },
      {
        id: 4,
        user: "stannis",
        text: "how do you not know what my job is"
      },
      {
        id: 5,
        user: "renly",
        text: "apparently i'm the master of laws"
      },
      {
        id: 6,
        user: "renly",
        text: "lol"
      },
      {
        id: 7,
        user: "littlefinger",
        text: "haha this wiki is great"
      }
    ]

    var rooms = [
      {
        id: 1,
        name: "Council Room",
        messages: [1, 2, 3, 4, 5, 6, 7]
      },
      {
        id: 2,
        name: "tournaments"
      },
      {
        id: 3,
        name: "kiwihouse"
      },
      {
        id: 4,
        name: "a very long room name"
      },
      {
        id: 5,
        name: "goldcloaks"
      }
    ]

    for(var i = 0; i < messages.length; i++) {
      this.store.push('message', messages[i]);
    }
    for(var i = 0; i < rooms.length; i++) {
      this.store.push('room', rooms[i]);
    }
  }
})

Tocky.Router.map(function() {
  this.resource('rooms', { path: '/rooms' }, function() {
    this.resource('room', { path: '/:room_id' });
  });
});

Tocky.RoomsRoute = Ember.Route.extend({
  model: function() {
    return this.store.find('room');
  }
});

