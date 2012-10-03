var Option;

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

  Option.collection = function(recipe_list) {
    var recipe, recipes, results, _i, _len;
    results = [];
    recipes = recipe_list.split(',') || recipe_list;
    for (_i = 0, _len = recipes.length; _i < _len; _i++) {
      recipe = recipes[_i];
      if (recipe != null) {
        results.push(new Option(recipe));
      }
    }
    return results;
  };

  return Option;

})();

module.exports = Option;
