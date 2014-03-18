Tocky.Router.map ->
  @resource 'authenticated', { path: '/' }, ->
    @resource 'rooms', { path: '/rooms' }, ->
      @resource 'room', { path: '/:room_id' }

  @resource 'login'

Tocky.AuthenticatedRoute = Ember.Route.extend
  beforeModel: (transition) ->
    applicationController = @controllerFor('application')

    if localStorage.session_id? and localStorage.user_id?
      applicationController.set 'savedTransition', null
      TockyAdapter.headers =
        'x-session-id': localStorage.session_id
    else
      applicationController.set 'savedTransition', transition
      @transitionTo 'login'
  model: ->
    @store.find 'user', localStorage.user_id
  actions:
    logout: ->
      delete localStorage.session_id
      delete localStorage.user_id
      @transitionTo '/login'

Tocky.RoomsRoute = Ember.Route.extend
  model: -> @modelFor('authenticated').get('rooms')

Tocky.LoginRoute = Ember.Route.extend
  actions:
    login: ->
      $.ajax 'http://localhost:3000/sessions/auth',
        method: 'POST'
        data: @controllerFor('login').getProperties('email', 'password')
        success: ({session: {id: session_id, user_id}}) =>
          localStorage.session_id = session_id
          localStorage.user_id = user_id
          applicationController = @controllerFor('application')
          transition = applicationController.get('savedTransition')
          if transition
            transition.retry()
          else
            @transitionTo '/rooms'
        error: =>
          alert "i'm sorry; something horrible has happened"
          debugger
      return

