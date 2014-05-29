mixablejs
=========

A non-clobbering mixin class to extend from. See Backbone.Advice and Angus Croll
style mixins for more details.

Should work for both coffeescript and purejs. It only depends on lodash.

Features
--------

- Clobbering/Non-clobbering object member mixing
- Wrapping methods using before, after and wrap methods
- Detect if a mixin has been mixed into an object

Example
------

my_view.coffee

```
    Mixable = require 'mixablejs'
    MyMixins = require './my_mixins'

    class MyView extends Mixable
        name: 'Default'

        events:
            'click .js-hi': 'default'
            'click .js-hi3': 'default'

        initialize: ->
            super
            order.push 1

        add: (x, y)->
            1 + x + y

    MyView.mixin objectCounterMixin
    MyView.mixin moreMixin, {}

    module.exports = MyView

```

my_mixins.coffee

```
    objectCounterMixin = ->
        @numberAfterCreated = 0
        @numberBeforeCreated = 0

        @after 'initialize', ->
            order.push 2
            @constructor.numberAfterCreated += 1

        @before 'initialize', ->
            order.push 0
            @constructor.numberBeforeCreated += 1

        @around 'add', (fn, x, y) ->
            fn(x, y) + 1

    moreMixin = ->
        @clobber 'name', newName

        @addToObj 'events', {
            'click .js-hi': 'moreMixin'
            'click .js-hi2': 'moreMixin'
        }

        @addToObj 'ninjas', {}

    module.exports =
        moreMixin: moreMixin
        objectCounterMixin: objectCounterMixin
```

Checkout mixable.spec.coffee for more info.

Developing
----------

To contribute the following commands might be useful

- `npm test` - runs unit tests
- `npm run-script debug-test` - runs unit tests with breakpoints
- `npm run-script build` - creates a new mixable.js file (do this before publishing)

Change log
----------

# 0.0.1

- Initial release
