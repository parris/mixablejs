_ = require('lodash')

class Mixable

    constructor: ->
        @initialize()

    initialize: ->

    @addToObj: (objectName, dictionary) ->
        if _.isUndefined(@prototype[objectName])
            @prototype[objectName] = {}

        if _.isObject(@prototype[objectName])
            @prototype[objectName] = _.extend dictionary, @prototype[objectName]

    @after: (target, after) ->
        previous = @prototype[target] or ->
        @prototype[target] = ->
            previous.apply @, arguments
            after.apply @, arguments

    @around: (target, wrapper) ->
        @prototype[target] = _.wrap @prototype[target], wrapper

    @before: (target, before) ->
        previous = @prototype[target] or ->
        @prototype[target] = ->
            before.apply @, arguments
            previous.apply @, arguments

    @clobber: (name, thing) ->
        @before 'initialize', ->
            @[name] = thing

    @hasMixin: (mixin) ->
        _.indexOf @constructor.mixins, mixin

    hasMixin: (mixin) ->
        _.indexOf @mixins, mixin

    @mixin: (mixin, options) ->
        @mixins = @mixins or []
        mixin.call @, options

module.exports = Mixable
