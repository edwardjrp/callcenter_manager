class @ItemFactory
  constructor: (@el, @category, @cart, @options = {})->


  validate: ->
    errors = []
    errors.push 'No ha seleccionado un producto' unless _.values(@options['selected_matchups']).length > 0 and _.values(@options['selected_matchups']).length <=2
    errors.push 'No ha seleccionado un sabor' unless @options['selected_flavor']?
    errors.push 'No ha seleccionado un tamaño' unless @options['selected_size']?
    if @category.hasOptions()
      errors.push 'No ha establecido opciones' unless @scan()? and _.any(@scan())
      errors.push 'La catidad a agregar al carrito no es valida' unless @options['item_quantity'] > 0 
      errors.push 'Ha seleccionado deben ser mayores a cero' unless @validate_quantities()
    result = errors
    errors = []
    $("<div class='purr'>#{window.to_sentence(result)}<div>").purr() if _.any(result)
    _.isEmpty(result)

  scan: ->
    if @category.isMulti() and @category.hasSides()
      set_options = _.filter($(@el).find('.option_box_sides'), (option) => @multi_conditions(option))
    else
      set_options = _.filter($(@el).find('.option_box'), (option) => $(option).data('quantity')? and not _.isUndefined($(option).data('quantity')))
    set_options

  multi_quantity_scan: ->
    quantities = _.filter($(@el).find('.option_box_sides'), (option) => @multi_quantity_check(option))

  validate_quantities: ->
    if @category.isMulti() and @category.hasSides()
      sum = _.inject @multi_quantity_scan(), ((memo, opt) ->
        if _.isNaN(Number($(opt).data('quantity-first'))) then first = 0 else first = Number($(opt).data('quantity-first'))
        if _.isNaN(Number($(opt).data('quantity-second'))) then second = 0 else second = Number($(opt).data('quantity-second'))
        memo + Number(first + second)
        ), 0
    else
      sum = _.inject @scan(), ((memo, opt) ->
        memo + Number($(opt).data('quantity'))
        ), 0
    sum > 0

  build_options: ->
    if @category.isMulti() and @category.hasSides()
      options_first= []
      options_second= []
      options_first = _.filter($(@el).find('.option_box_sides'), (option)=> @multi_presence_first(option))
      options_second = _.filter($(@el).find('.option_box_sides'), (option)=> @multi_presence_second(option))
      @merge_options(options_first, options_second)
    else
      recipe = _.map @scan(), (opt) ->
        if _.isNaN($(opt).data('quantity')) or $(opt).data('quantity') == 1 then q = '' else q = $(opt).data('quantity')
        if $(opt).data('part')? and not _.isUndefined($(opt).data('part')) and not $(opt).data('part') == 'W'
          "#{q}#{$(opt).data('code')}-#{$(opt).data('part')}"
        else
          "#{q}#{$(opt).data('code')}"
      recipe.join(',')

  merge_options: (options_first, options_second) ->
    if _.any(options_second)
      first_build = _.map options_first, (opt1) ->
        if _.isNaN($(opt1).data('quantity-first')) or $(opt1).data('quantity-first') == 1 then q1 = '' else q1 = $(opt1).data('quantity-first')
        {code:$(opt1).data('code'), quantity: q1 }
        

      second_build = _.map options_second, (opt2) ->
        if _.isNaN($(opt2).data('quantity-second')) or $(opt2).data('quantity-second') == 1 then q2 = '' else q2 = $(opt2).data('quantity-second')
        {code:$(opt2).data('code'), quantity: q2 }
        
      common_options = window.objectIntersection(first_build, second_build)
      left_option = window.objectDifference(first_build, second_build)
      rigth_option = window.objectDifference(second_build, first_build)
      commons = _.map common_options, (copt)->
        "#{copt.quantity}#{copt.code}"
      lefties = _.map left_option, (lopt)->
        "#{lopt.quantity}#{lopt.code}-1"
      righties = _.map rigth_option, (ropt)->
        "#{ropt.quantity}#{ropt.code}-2"

      _.flatten([commons, lefties, righties]).join(',')

    else
      recipe = _.map options_first, (opt) ->
        if _.isNaN($(opt).data('quantity-first')) or $(opt).data('quantity-first') == 1 then q = '' else q = $(opt).data('quantity-first')
        unless $(opt).data('part-first') == 'W'
          "#{q}#{$(opt).data('code')}-#{$(opt).data('part-first')}"
        else
          "#{q}#{$(opt).data('code')}"
      recipe.join(',')
    

    

  multi_presence_first: (opt) ->
    $(opt).data('quantity-first')? and  $(opt).data('part-first')?

  multi_presence_second: (opt) ->
    $(opt).data('quantity-second')? and  $(opt).data('part-second')?

  multi_conditions: (opt)->
    (not _.isUndefined($(opt).data('quantity-first')))  or (not _.isUndefined($(opt).data('quantity-second')))

  multi_quantity_check: (opt)->
    $(opt).data('quantity-first')? or $(opt).data('part-first')?

  multi_part_check: (opt)->
    $(opt).data('quantity-second')? or $(opt).data('part-second')?


  build: ->
    if @validate()
      product = _.find(_.values(@options['selected_matchups'])[0].get('products'), (product)=> product.get('flavorcode') == @options['selected_flavor'] and  product.get('sizecode').toString() == @options['selected_size'].toString()) || @category.baseProduct()
      quantity = @options['item_quantity']
      bind_id = _.find(_.values(@options['selected_matchups'])[1].get('products'), (product)=> product.get('flavorcode') == @options['selected_flavor'] and  product.get('sizecode').toString() == @options['selected_size'].toString()).id if _.values(@options['selected_matchups'])[1]?
      bind_id = null if _.isUndefined(bind_id)
      options = @build_options()
      cart = @cart
      { product_id: product.id, product: product, quantity: quantity, options: options, cart_id: cart.id, bind_id: bind_id }
    else
      null
