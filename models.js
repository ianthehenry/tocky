Wocky.Message = DS.Model.extend({
  text: DS.attr('string'),
  isUnread: DS.attr('boolean'),
  room: DS.belongsTo('room')
});

Wocky.Room = DS.Model.extend({
  name: DS.attr('string') //,
  // messages: DS.hasMany('message')
});

Wocky.Room.FIXTURES = [
  {
    id: 1,
    name: "Council Room",
    messages: [
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
