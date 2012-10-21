var Option, _;

_ = require('underscore');

Option = (function() {

  function Option(recipe) {
    this.recipe = recipe;
  }

  Option.regexp = /^([0-9]{0,2}\.?[0|7|5]{0,2})([A-Z]{1,}[a-z]{0,})(?:\-([W12]))?/;

  Option.prototype.quantity = function() {
    if (this.recipe.match(Option.regexp)) {
      return this.value_or_default();
    }
  };

  Option.prototype.code = function() {
    if (this.recipe.match(Option.regexp)) {
      return this.recipe.match(Option.regexp)[2];
    }
  };

  Option.prototype.part = function() {
    if (this.recipe.match(Option.regexp)) {
      return this.recipe.match(Option.regexp)[3] || 'W';
    }
  };

  Option.prototype.value_or_default = function() {
    if (this.recipe.match(Option.regexp)[1] === '') {
      return 1;
    } else {
      return this.recipe.match(Option.regexp)[1];
    }
  };

  Option.prototype.toPulse = function() {
    return {
      quantity: this.quantity().toString(),
      code: this.code(),
      part: this.part()
    };
  };

  Option.collection = function(recipe_list) {
    var recipe, recipes, results, _i, _len, _ref;
    results = [];
    recipes = (recipe_list != null ? recipe_list.split(',') : void 0) || recipe_list;
    _ref = _.compact(recipes);
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      recipe = _ref[_i];
      if (recipe != null) {
        results.push(new Option(recipe));
      }
    }
    return results;
  };

  Option.pulseCollection = function(recipe_list) {
    var recipe, recipes, results, _i, _len, _ref;
    results = [];
    recipes = (recipe_list != null ? recipe_list.split(',') : void 0) || recipe_list;
    _ref = _.compact(recipes);
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      recipe = _ref[_i];
      if (recipe != null) {
        results.push(new Option(recipe).toPulse());
      }
    }
    return results;
  };

  return Option;

})();

module.exports = Option;
