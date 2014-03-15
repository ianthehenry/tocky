gui = require('nw.gui')
win = gui.Window.get()

document.cookie = 'chat.sessions=s%3Aj%3A%7B%7D.%2BShmKj0o2LB6DTbltC3MJEmnnoQOXWjYMX0%2BS2T2ZTA;'

window.Tocky = Ember.Application.create
  LOG_TRANSITIONS: true
  LOG_VIEW_LOOKUPS: true
  LOG_ACTIVE_GENERATION: true
  LOG_MODULE_RESOLVER: true

Tocky.ApplicationView = Ember.View.extend
  elementId: 'body'

Tocky.RoomController = Ember.ObjectController.extend
  actions:
    sendMessage: ->
      text = @get('nextMessageText')
      @set('nextMessageText', "")
      if text.trim().length == 0
        return

      message = @store.createRecord 'message',
        user: 'me'
        content: text
        time: new Date()
        isUnread: false
        room: @get('model')
      message.save()

Tocky.SmartTextComponent = Ember.TextArea.extend
  becomeFocused: util.on 'didInsertElement', ->
    @$().focus()
  keyDown: (e) ->
    if e.which == 13 and not e.shiftKey
      @sendAction('enter-down')
      e.preventDefault()

TockyAdapter = DS.RESTAdapter.extend
  host: 'http://localhost:3000'

Tocky.ApplicationAdapter = TockyAdapter
Tocky.MessageAdapter = TockyAdapter.extend
  createRecord: (store, type, record) ->
    serializer = store.serializerFor(type.typeKey)
    data = serializer.serialize record, { includeId: true }
    url = [@urlPrefix(), 'rooms', record.get('room.id'), 'messages'].join('/')
    return @ajax url, 'POST', { data }

$(window).on 'keydown', (e) ->
  if e.which == 82 and e.metaKey
    gui.App.clearCache()
    win.reloadIgnoringCache()

# RegExp.quote = (str) -> str.replace /[.?*+^$[\]\\(){}|-]/g, '\\$&'

# getCookie = (cookieName, res) ->
#   cookies = res.headers['set-cookie']

#   regex = /// #{ RegExp.quote(cookieName) } = ([^]+) (&|;) ///
#   result = null
#   for cookie in cookies
#     match = regex.exec(cookie)
#     if match?
#       return match[1]
#   return null

# http = require('http')
# req = http.request
#   hostname: 'localhost'
#   port: 3000
#   method: 'POST'
#   path: '/sessions/auth'
#   headers:
#     'X-Whatever': 'cool'
#     'Origin': 'localhost'
# , (res) ->
#   chatSession = getCookie('chat.session', res)
#   document.cookie = 'chat.sessions=' + chatSession
#   console.log("cookie = #{ chatSession }")

# req.on 'error', (e) ->
#   console.log("problem with request: #{ e.message }")
#   debugger

# req.end()
