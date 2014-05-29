// Generated by CoffeeScript 1.7.1
(function() {
  var Mixable, _;

  _ = require('lodash');

  Mixable = (function() {
    function Mixable() {
      this.initialize();
    }

    Mixable.prototype.initialize = function() {};

    Mixable.addToObj = function(objectName, dictionary) {
      if (_.isUndefined(this.prototype[objectName])) {
        this.prototype[objectName] = {};
      }
      if (_.isObject(this.prototype[objectName])) {
        return this.prototype[objectName] = _.extend(dictionary, this.prototype[objectName]);
      }
    };

    Mixable.after = function(target, after) {
      var previous;
      previous = this.prototype[target] || function() {};
      return this.prototype[target] = function() {
        previous.apply(this, arguments);
        return after.apply(this, arguments);
      };
    };

    Mixable.around = function(target, wrapper) {
      return this.prototype[target] = _.wrap(this.prototype[target], wrapper);
    };

    Mixable.before = function(target, before) {
      var previous;
      previous = this.prototype[target] || function() {};
      return this.prototype[target] = function() {
        before.apply(this, arguments);
        return previous.apply(this, arguments);
      };
    };

    Mixable.clobber = function(name, thing) {
      return this.before('initialize', function() {
        return this[name] = thing;
      });
    };

    Mixable.hasMixin = function(mixin) {
      return _.indexOf(this.constructor.mixins, mixin);
    };

    Mixable.prototype.hasMixin = function(mixin) {
      return _.indexOf(this.mixins, mixin);
    };

    Mixable.mixin = function(mixin, options) {
      this.mixins = this.mixins || [];
      return mixin.call(this, options);
    };

    return Mixable;

  })();

  module.exports = Mixable;

}).call(this);