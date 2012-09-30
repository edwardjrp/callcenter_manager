class @ItemFactory
  constructor: (@el, @category, @cart, @options = {})->


  validate: ->
    errors = []
    errors.push 'No ha seleccionado un producto' unless _.values(@options['selected_matchups']).length > 0 and _.values(@options['selected_matchups']).length <=2
    errors.push 'No ha seleccionado un sabor' unless @options['selected_flavor']?
    errors.push 'No ha seleccionado un tamaño' unless @options['selected_size']?
    errors.push 'No ha establecido opciones' unless @scan()? and _.any(@scan())
    errors.push 'Ha seleccionado deben ser mayores a cero' unless @validate_quantities()
    errors.push 'La catidad a agregar al carrito no es valida' unless @options['item_quantity'] > 0 
    result = errors
    errors = []
    $("<div class='purr'>#{window.to_sentence(result)}<div>").purr() if _.any(result)
    _.isEmpty(result)

  scan: ->
    if @category.isMulti() and @category.hasSides()
      set_options = _.filter($(@el).find('.option_box_sides'), (option) => @multi_conditions(option))
    else
      set_options = _.filter($(@el).find('.option_box'), (option) -> $(option).data('quantity')?)
    set_options

  multi_quantity_scan: ->
    quantities = _.filter($(@el).find('.option_box_sides'), (option) => @multi_quantity_check(option))

  validate_quantities: ->
    if @category.isMulti() and @category.hasSides()
      sum = _.inject @multi_quantity_scan(), ((memo, opt) ->
        memo + Number($(opt).data('quantity-first')) + Number($(opt).data('quantity-second') || 0)
        ), 0
    else
      sum = _.inject @scan(), ((memo, opt) ->
        memo + Number($(opt).data('quantity'))
        ), 0
    sum > 0

  build_options: ->
    if @category.isMulti() and @category.hasSides()
      console.log 'pizza options build'
    else
      _.map(@scan(), (opt) -> { quantity: $(opt).data('quantity'), code: $(opt).data('code'), part: $(opt).data('part')} )

  multi_conditions: (opt)->
    $(opt).data('quantity-first')? or $(opt).data('quantity-second')? or $(opt).data('part-first')? or $(opt).data('part-second')?

  multi_quantity_check: (opt)->
    $(opt).data('quantity-first')? or $(opt).data('quantity-second')?

  multi_part_check: (opt)->
    $(opt).data('part-first')? or $(opt).data('part-second')?


  build: ->
    cart_product = new Kapiqua25.Models.CartProduct()
    if @validate()
      if @category.isMulti() and @category.hasSides()
        console.log 'build for pizza'
      else
        product = _.values(@options['selected_matchups'])[0].get('products')[0]
        quantity = @options['item_quantity']
        options = @build_options()
        cart = @cart
        console.log @cart
        console.log _.values(@options['selected_matchups'])[0]
        cart_product.set({product: product, quantity: quantity, options: options, cart: cart})
        console.log cart_product.attributes
    cart_product
