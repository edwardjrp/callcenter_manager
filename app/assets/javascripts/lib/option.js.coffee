class @Option
  constructor: (@recipe, products) ->
    @product = _.find(products, (p)=> p.get('productcode') == @code())

  @regexp: /^([0-9]{0,2}\.?[0|7|5]{0,2})([A-Z]{1,}[a-z]{0,})(?:\-([W12]))?/


  quantity: () -> 
    @value_or_default() if @recipe and @recipe.match(Option.regexp)

  code: ()->
    @recipe.match(Option.regexp)[2] if @recipe and @recipe.match(Option.regexp)

  part: ()->
    @recipe.match(Option.regexp)[3] || 'W' if @recipe and @recipe.match(Option.regexp)

  toString: () =>
    return '' unless @product?
    if @quantity() == 0 then q = '' else q = @quantity()
    if @part() == 'W' then "#{q}#{@product.get('productname')}" else "#{q}#{@product.get('productname')} a la #{@partMap()}"

  toJSON: ()->
    { quantity: @quantity() , code: @code(), part: @part() }

  value_or_default: ()->
    if @recipe.match(Option.regexp)[1] == '' then  1 else @recipe.match(Option.regexp)[1]


  partMap: ()->
    switch @part()
      when '1' then 'Izquierda'
      when '2' then'Derecha'
      else
        'Completa'
  