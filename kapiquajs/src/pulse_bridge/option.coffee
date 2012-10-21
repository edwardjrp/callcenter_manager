_ = require('underscore')

class Option
  constructor: (@recipe)->

  @regexp: /^([0-9]{0,2}\.?[0|7|5]{0,2})([A-Z]{1,}[a-z]{0,})(?:\-([W12]))?/


  quantity: () -> 
    @value_or_default() if @recipe.match(Option.regexp)

  code: ()->
    @recipe.match(Option.regexp)[2] if @recipe.match(Option.regexp)

  part: ()->
    @recipe.match(Option.regexp)[3] || 'W' if @recipe.match(Option.regexp)


  value_or_default: ()->
    if @recipe.match(Option.regexp)[1] == '' then  1 else @recipe.match(Option.regexp)[1]


  toPulse: ->
    { quantity: @quantity().toString(), code: @code(), part: @part()}

  @collection: (recipe_list)->
    results = []
    recipes = recipe_list?.split(',') || recipe_list
    for recipe in _.compact(recipes)
      results.push new Option(recipe) if recipe?
    results

  @pulseCollection: (recipe_list)->
    results = []
    recipes = recipe_list?.split(',') || recipe_list
    for recipe in _.compact(recipes)
      results.push new Option(recipe).toPulse() if recipe?
    results

module.exports = Option


