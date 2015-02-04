# tocky

Tocky was the sequel to Wocky, a which was an experimental client for an experimental JabbR server. Neither Tocky nor Wocky ever got off the ground.

But it was a testing bed for a couple of technologies, namely:

- Ember.js
- node-webkit

This was developed against Ember 1.5.0-beta.2 and node-webkit 0.8.5. Ember 1.9.1 is out now and node-webkit rebranded to nw.js and is on 0.11.5. So things might be better. I was using very new technologies.

## Thoughts

I like the idea of node-webkit. Debugging tools weren't that horrible. I remember it being so difficult to upgrade to 0.9 that I eventually gave up. The changes weren't well documented, and the installation itself is cumbersome. It's something I would consider using again, given the right moivation, but I'll probably take a look at atom-shell first.

Ember.js was interesting. I had been doing a lot of iOS development before working on Tocky, and the general DOM situation is a nightmare when it comes to actually writing applications. So I was pleased by Ember's philosophy of "shield you from the DOM as much as possible."

In practice this unpleasant for a few reasons:

- There is an incredible volume of magic behind the scenes. I spent a *lot* of time reading the Ember source code to figure out how to use it.
- The only way place to get information about how to write Ember was the Ember official docs. Very little knowledge of non-Ember web application was reusable.
- If you ever "misuse" Ember, or do something the developers didn't expect, the error messages and assertions were indecipherable.
    - The Ember debugging tools are actually very pleasant, but they only work for a... working Ember app. As most of my time as a newcomer to Ember was trying to figure out exactly the incantations Ember expected, they weren't useful.
- The documentation for Ember was incredibly long, yet failed to include any realistic examples of using Ember. There's was a lot about what you could or should do, but no examples of what that code looked like. Since Ember is so idiosyncratic that any code that looks slightly different than it expects won't work, this was frustrating.
- ember-data didn't work at all. And I mean at all.
    - This is not a core part of Ember, but it was one of the pieces that attracted me to the project in the first place. Fortunately, it was replaceable, but I spent far longer than I would care to admit struggling to get it working.
    - At the time there were lots of open source alternatives, all of which worked for exactly one payload type. I ended up writing [my own](app/ems.coffee) which, of course, only works for this project.
    - I see that at time of writing they're up from 1.0.0-beta.7 all the way to 1.0.0-beta.15-canary.
- Ember's rendering was very slow, and as a result the whole application felt sluggish. I don't know if that's still the case.

Remember that all of these complaints apply to Ember circa March 2014. It's come a long way, and I hope it's better now.

## Features

- websocket-based message streaming
- unread message indicators
- multiple room selection
- login/logout with authenticated state handled properly (it would redirect to the right place after you logged in)
