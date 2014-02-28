window.Wocky = Ember.Application.create();

Wocky.ApplicationView = Ember.View.extend({
  elementId: 'body'
});

Wocky.ApplicationAdapter = DS.FixtureAdapter.extend();
