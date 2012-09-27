class @Option
  constructor: (@recipe, @products) ->

  regexp: /^([0-9]{0,2}\.?[0|7|5]{0,2})([A-Z]{1,}[a-z]{0,})(?:\-([W12]))?/


  quantity: () -> 
    @value_or_default() if @recipe
  
  product: ()->
    _.find(@products, (product)=> product.get('productcode') == @code())

  code: ()->
    @recipe.match(@regexp)[2] if @recipe

  part: ()->
    @recipe.match(@regexp)[3] || 'W' if @recipe

  toString: () =>
    return '' unless @product()?
    if @quantity() == 0 then q = '' else q = @quantity()
    if @part() == 'W' then "#{q}#{@product().get('productname')}" else "#{q}#{@product().get('productname')} a la #{@partMap()}"

  toJSON: ()->
    { quantity: @quantity() , code: @code(), part: @part() }

  value_or_default: ()->
    if @recipe.match(@regexp)[1] == '' then  1 else @recipe.match(@regexp)[1]


  partMap: ()->
    switch @part()
      when '1' then 'Izquierda'
      when '2' then'Derecha'
      else
        'Completa'
  