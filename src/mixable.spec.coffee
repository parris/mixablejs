_ = require('lodash')

Mixable = require('./mixable.coffee')

newName = 'Parris'

order = []

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

describe 'Mixable', ->

    beforeEach ->
        order = []

        class @Mixed extends Mixable
            name: 'Default'

            events:
                'click .js-hi': 'default'
                'click .js-hi3': 'default'

            initialize: ->
                super
                order.push 1

            add: (x, y)->
                1 + x + y

        @Mixed.mixin objectCounterMixin
        @Mixed.mixin moreMixin, {}

    describe 'before creation', ->

        it 'can add mixins', ->
            @Mixed.numberAfterCreated.should.equal 0

        it 'detects if a mixin is mixed', ->
            (@Mixed.hasMixin objectCounterMixin).should.be.ok

    describe 'after creation', ->

        beforeEach ->
            @mixInstance1 = new @Mixed
            @mixInstance2 = new @Mixed

        describe 'hasMixin', ->

            it 'detects if a mixin is mixed', ->
                (@mixInstance1.hasMixin moreMixin).should.be.ok

        describe 'clobber', ->

            it 'allows clobbering of instance variables', ->
                @mixInstance1.name.should.equal newName

        describe 'before and after', ->

            it 'allows for running method after another method', ->
                @Mixed.numberAfterCreated.should.equal 2

            it 'allows for running method before another method', ->
                @Mixed.numberAfterCreated.should.equal 2

            it 'calls before and after for initialize in the correct order', ->
                order[0].should.equal 0
                order[1].should.equal 1
                order[2].should.equal 2

        describe 'addToObj', ->

            it 'does not clobber', ->
                @mixInstance1.events['click .js-hi'].should.equal 'default'
                @mixInstance1.events['click .js-hi3'].should.equal 'default'

            it 'adds keys to an object', ->
                @mixInstance1.events['click .js-hi2'].should.equal 'moreMixin'

            it 'creates an object if it does not exist', ->
                @mixInstance1.ninjas.should.be.ok

        describe 'around', ->

            it 'returns the result of the first function to the second', ->
                @mixInstance1.add(1, 1).should.equal 4
