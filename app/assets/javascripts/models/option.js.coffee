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

  configureHalf: (el, position)->
    if position == 'first'
      el.find('.dropdown').find('a.left_selection').css('background-color', '#A9C4F5')
      el.find('a.left_selection').html("#{@amountMap()}<b class='caret'></b>")
      el.closest('.option_box_sides').data('part-first', @part())
      el.closest('.option_box_sides').find('.amount_control_multi_sides_first:first').data('quantity-first', @quantity())
    if position == 'second'
      el.find('.dropdown').find('a.right_selection').css('background-color', '#EED3D7')
      el.find('a.right_selection').html("#{@amountMap()}<b class='caret'></b>")
      el.closest('.option_box_sides').data('part-second', @part())
      el.closest('.option_box_sides').find('.amount_control_multi_sides_second:first').data('quantity-second', @quantity())


  teardownHalf: (el, position)->
    if position == 'first'
      el.find('.dropdown').find('a.left_selection').css('background-color', 'transparent')
      el.find('a.left_selection').html("Nada<b class='caret'></b>")
      el.closest('.option_box_sides').removeData('part-first')
      el.closest('.option_box_sides').find('.amount_control_multi_sides_first:first').removeData('quantity-first')
    if position == 'second'
      el.find('.dropdown').find('a.right_selection').css('background-color', 'transparent')
      el.find('a.right_selection').html("Nada<b class='caret'></b>")
      el.closest('.option_box_sides').removeData('part-second')
      el.closest('.option_box_sides').find('.amount_control_multi_sides_second:first').removeData('quantity-second')

  configure: (el, configurable_type) ->
    switch configurable_type
      when 'with_units'
        el.find('input').val(@quantity())
        el.closest('.option_box').data('quantity',@quantity() )
      when 'amount'
        el.find('a.amount_selection').html("#{@amountMap()}<b class='caret'></b>")
        el.find('.dropdown').css('background-color', '#A9C4F5')
        el.closest('.option_box').data('quantity',@quantity() )
      when 'multi_and_sides'
        el.find('.btn-group').find("button.#{@partMap()}").trigger('click')
        el.find('a.left_selection').html("#{@amountMap()}<b class='caret'></b>")
        el.find('.dropdown').css('background-color', '#A9C4F5')
        el.closest('.option_box_sides').data('part-first',@part() )
        el.closest('.option_box_sides').find('.amount_control_multi_sides_first:first').data('quantity-first',@quantity() )
        

  teardown: (el, configurable_type) ->
    switch configurable_type
      when 'with_units'
        el.find('input').val('0')
        el.closest('.option_box').removeData('quantity')
      when 'amount'
        el.find('a.amount_selection').html("Nada<b class='caret'></b>")
        el.find('.dropdown').css('background-color', 'white')
        el.closest('.option_box').removeData('quantity')
      when 'multi_and_sides'
        el.find('.btn-group').find("button.#{@partMap()}").trigger('click').removeClass('active')
        el.find('a.left_selection').html("Nada<b class='caret'></b>")
        el.find('.dropdown').css('background-color', 'white')
        el.closest('.option_box_sides').removeData('part-first')
        el.closest('.option_box_sides').find('.amount_control_multi_sides_first:first').removeData('quantity-first')


  amountMap: ()->
    switch Number(@quantity())
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