gui = require('nw.gui')
win = gui.Window.get()

$(window).on 'keydown', (e) ->
  if e.which == 82 and e.metaKey
    gui.App.clearCache()
    win.reloadIgnoringCache()

document.cookie = 'chat.sessions=s%3Aj%3A%7B%7D.%2BShmKj0o2LB6DTbltC3MJEmnnoQOXWjYMX0%2BS2T2ZTA;'

window.Tocky = Ember.Application.create
  LOG_TRANSITIONS: true
  LOG_ACTIVE_GENERATION: true
  LOG_MODULE_RESOLVER: true

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
