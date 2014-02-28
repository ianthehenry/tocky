window.Tocky = Ember.Application.create();

Tocky.ApplicationView = Ember.View.extend({
  elementId: 'body'
});

Tocky.ApplicationAdapter = DS.FixtureAdapter.extend();
