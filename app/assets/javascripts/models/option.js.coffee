class Kapiqua25.Models.Option extends Backbone.RelationalModel
  
  product: ()->
    _.find(@get('products'), (p)=> p.get('productcode') == @code())

  @regexp: /^([0-9]{0,2}\.?[0|7|5]{0,2})([A-Z]{1,}[a-z]{0,})(?:\-([W12]))?/


  quantity: () -> 
    @value_or_default() if @get('recipe') and @get('recipe').match(Option.regexp)

  code: ()->
    @get('recipe').match(Option.regexp)[2] if @get('recipe') and @get('recipe').match(Option.regexp)

  part: ()->
    @get('recipe').match(Option.regexp)[3] || 'W' if @get('recipe') and @get('recipe').match(Option.regexp)

  toString: () =>
    return '' unless @product()?
    if @quantity() == 0 then q = '' else q = @quantity()
    if @part() == 'W' then "#{q}#{@product().get('productname')}" else "#{q}#{@product().get('productname')} a la #{@partMap()}"

  toJSON: ()->
    { quantity: @quantity() , code: @code(), part: @part() , product: @product() }

  value_or_default: ()->
    if @get('recipe').match(Option.regexp)[1] == '' then  1 else @get('recipe').match(Option.regexp)[1]


  configure: (el, configurable_type) ->
    switch configurable_type
      when 'with_units'
        el.find('input').val(@quantity())
        console.log el.find('input')
        el.data('quantity',@quantity() )
      when 'amount'
        el.find('a.amount_selection').html("#{@amountMap()}<b class='caret'></b>")
        el.find('.dropdown').css('background-color', '#A9C4F5')
        el.data('quantity',@quantity() )
      when 'multi_and_sides'
        console.log 'pending'

  teardown: (el, configurable_type) ->
    switch configurable_type
      when 'with_units'
        el.find('input').val('0')
        el.data('quantity', 0)
      when 'amount'
        el.find('a.amount_selection').html("Nada<b class='caret'></b>")
        el.find('.dropdown').css('background-color', 'white')
        el.data('quantity','' )
      when 'multi_and_sides'
        console.log 'pending'


  amountMap: ()->
    switch @quantity()
      when 0.75 then 'Poco'
      when 1 then 'Normal'
      when 1.5 then 'Extra'
      when 2 then 'Doble'
      when 3 then'Triple'
      else
        'Nada'

  partMap: ()->
    switch @part()
      when '1' then 'Izquierda'
      when '2' then'Derecha'
      else
        'Completa'