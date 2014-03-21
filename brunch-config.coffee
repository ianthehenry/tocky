exports.config =
  conventions:
    assets: /^app\/static\//
  modules:
    definition: false
    wrapper: false
  paths:
    public: 'build'
  files:
    javascripts:
      joinTo:
        'js/vendor.js': /^bower_components/
        'js/app.js': /^app/
      order:
        before: [
          'bower_components/jquery/jquery.js'
          'bower_components/handlebars/handlebars.js'
          'bower_components/ember/ember.js'
          'bower_components/ember-data/ember-data.js'
          'app/util.coffee'
        ]
    templates:
        precompile: true
        root: 'templates/'
        defaultExtension: 'hbs'
        joinTo: 'js/app.js' : /^app/
    stylesheets:
      joinTo:
        'css/app.css': /^app\/styles/
