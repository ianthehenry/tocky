Tocky.client = new TockyClient()

Tocky.Router.map ->
  @resource 'authenticated', { path: '/' }, ->
    @resource 'rooms', { path: '/rooms' }, ->
      @resource 'room', { path: '/:room_id' }
    @resource 'conversation', { path: 'conversation/:user_id' }

  @resource 'login'

Tocky.AuthenticatedRoute = Ember.Route.extend
  beforeModel: (transition) ->
    applicationController = @controllerFor('application')

    if localStorage.session_id? and localStorage.user_id?
      applicationController.set 'savedTransition', null
      Tocky.client.headers['x-session-id'] = localStorage.session_id
    else
      applicationController.set 'savedTransition', transition
      @transitionTo 'login'
  model: ->
    Tocky.client.find 'user', localStorage.user_id
  afterModel: (model) ->
    @set 'wocket', new Wocket('http://localhost:3000', model, Tocky.client)
  setupController: (controller) ->
    @_super(arguments...)
    controller.set 'wocket', @get('wocket')
  deactivate: ->
    @get('wocket').destroy()
    @_super(arguments...)

  actions:
    logout: ->
      delete localStorage.session_id
      delete localStorage.user_id
      @transitionTo '/login'

Tocky.RoomRoute = Ember.Route.extend
  model: ({room_id}) ->
    Tocky.client.find 'room', room_id
  afterModel: (room) ->
    Tocky.client.loadUserships(room)
    Tocky.client.loadMessages(room)

Tocky.ConversationRoute = Ember.Route.extend
  model: ({user_id}) ->
    Tocky.client.find 'user', user_id
  afterModel: (user) ->
    Tocky.client.loadMessages(user)

Tocky.LoginRoute = Ember.Route.extend
  actions:
    login: ->
      $.ajax 'http://localhost:3000/sessions/auth',
        method: 'POST'
        data: @controllerFor('login').getProperties('email', 'password')
      .then ({session: {id: session_id, user_id}}) =>
        localStorage.session_id = session_id
        localStorage.user_id = user_id
        applicationController = @controllerFor('application')
        transition = applicationController.get('savedTransition')
        if transition
          transition.retry()
        else
          @transitionTo '/rooms'
      .fail =>
        alert "i'm sorry; something horrible has happened"
        debugger
      return
