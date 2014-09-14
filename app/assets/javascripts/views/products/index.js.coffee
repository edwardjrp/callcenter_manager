class Kapiqua25.Views.ProductsIndex extends Backbone.View

  template: JST['products/index']
  
  initialize: ->
    _.bindAll(this,
      'render',
      'show_popover',
      'hide_popover',
      'select_specialty',
      'colorize_button',
      'decolorize_button',
      'select_flavor',
      'select_size',
      'gray_out_flavors',
      'gray_out_sizes',
      'onEditing',
      'onRemove')
    @selected_matchups = {}
    @selected_flavor = null
    @selected_flavor = @model.availableFlavors()[0] if @model.availableFlavors().length == 1
    @selected_size = null
    @selected_size = @model.availableSizes()[0] if @model.availableSizes().length == 1
    @max_selectable_matchups = 1
    if @model.isMulti() then @max_selectable_matchups = 2 else @max_selectable_matchups = 1
    Backbone.pubSub.on('editing', @onEditing)
    Backbone.pubSub.on('removed', @onRemove)
    @editing = false
    @edit_item = null
    @second_edit_item = null
    @edit_cart_product = null
    @matchup_original_recipe = null
    @matchup_secondary_recipe = null
  
  events: ->
    'mouseenter .specialties': 'show_popover'
    'mouseout .specialties': 'hide_popover'
    'click .specialties':'select_specialty'
    'click a.flavors':'select_flavor'
    'click a.sizes':'select_size'
    'click .amount_control .dropdown-menu a' : 'set_amount'
    'click .option_box_sides button' : 'set_side'
    'click .amount_control_multi_sides_first ul.left_selection li a' : 'set_first_amount'
    'click .amount_control_multi_sides_second ul.right_selection li a' : 'set_second_amount'
    'click .adder input[type=button]' : 'add_to_cart'
    'change .unit_amounts' : 'set_unit_amounts'


  onEditing: (data) ->
    if data.category is @model
      @editing = true
      target_matchup = _.find data.category.matchups().models, (matchup)=>
        _.include(matchup.get('products'), data.product)

      if data.cart_product.get('bind_id')?
        secondary = @model.mainProducts().get(data.cart_product.get('bind_id'))
        target_secondary_matchup = _.find data.category.matchups().models, (matchup)=>
          _.include(matchup.get('products'), secondary)
      @edit_cart_product = data.cart_product
      
      @matchup_original_recipe = target_matchup.get('recipe')
      @matchup_secondary_recipe = target_secondary_matchup.get('recipe')

      left_options = _.map _.compact(_.map(data.cart_product.get('options').split(','), (opt)-> opt.match(/(.*)\-1$/g))), (item) -> _.first(item)
      rigth_options = _.map _.compact(_.map(data.cart_product.get('options').split(','), (opt)-> opt.match(/(.*)\-2$/g))), (item) -> _.first(item)
      common_options = _.map _.compact(_.map(data.cart_product.get('options').split(','), (opt)-> opt.match(/(.*)[^\-\d]$/g))), (item) -> _.first(item)

      for option in common_options
        do (option) ->
          left_options.push("#{option}-1")
          rigth_options.push("#{option}-2")

      @edit_item = target_matchup.set(recipe: left_options.join(','))
      @second_edit_item = target_secondary_matchup.set(recipe: rigth_options.join(','))
      @apply_selection(@edit_item)
      @apply_selection(@second_edit_item)

      @selected_flavor = data.product.get('flavorcode')
      $(@el).find('.flavors_container').find(".#{data.product.get('flavorcode')}").addClass('btn-primary')
      @selected_size = data.product.get('sizecode')
      $(@el).find('.sizes_container').find(".#{data.product.get('sizecode')}").addClass('btn-primary')


    
  render: ->
    # model = current category
    $(@el).html(@template(model: @model))
    $(@el).find('input').restric('alpha').restric('spaces')
    $(@el).find('.dropdown-toggle.left_selection').dropdown()
    @clear()
    @clear_edit()
    this


  add_to_cart:  (event)->
    event.preventDefault()
    target = $(event.currentTarget)
    # console.log @selected_matchups
    item = new ItemFactory(@el, @model, @options.cart, {selected_matchups: @selected_matchups, selected_flavor: @selected_flavor, selected_size: @selected_size, item_quantity: $(@el).find('.cart_product_quantity').val()}).build()
    # console.log item
    if @editing
      console.log item.product
      cart_product = @edit_cart_product.set({ product: item.product ,product_id: item.product_id, cart_id: item.cart_id, options: item.options, bind_id: item.bind_id }) # falta editar productos
      cart_product.save()
    else 
      cart_product = _.first(@options.cart.get('cart_products').where({ product_id: item?.product_id, cart_id: item?.cart_id, options: item?.options, bind_id: item?.bind_id }))
      if cart_product?
        cart_product.set({ quantity: (Number(cart_product.get('quantity')) + Number(item.quantity)) })
        cart_product.save()
      else
        @options.cart.get('cart_products').create({ product_id: item.product_id, product: item.product, quantity: item.quantity, options: item.options, cart_id: item.cart_id, bind_id: item.bind_id })
    @clear()
    # @clear_edit() if @editing
    @render()

  onRemove: (data) ->
    @render() if @editing and _.isEqual(data.cart_product, @edit_cart_product)

  clear: ->
    @selected_matchups = {}
    @selected_flavor = null
    @selected_flavor = @model.availableFlavors()[0] if @model.availableFlavors().length == 1
    @selected_size = null
    @selected_size = @model.availableSizes()[0] if @model.availableSizes().length == 1

  clear_edit: ->
    @editing = false
    @edit_cart_product =  null
    if  @edit_item?
      @edit_item.set({recipe: @matchup_original_recipe})
      @second_edit_item.set({recipe: @matchup_secondary_recipe }) if @second_edit_item?
    @edit_item = null
    @second_edit_item = null

  set_unit_amounts: (event)->
    event.preventDefault()
    target = $(event.currentTarget)
    target.closest('.option_box').data('quantity', target.val())

  set_side: (event)->
    event.preventDefault()
    target = $(event.currentTarget)
    target.siblings('button').removeClass('active')
    target.addClass('active')
    target.closest('.option_box_sides').find('.amount_control_multi_sides_first').data('quantity-first', 1)
    target.closest('.option_box_sides').find('.amount_control_multi_sides_first').find('a.left_selection').html("Normal<b class='caret'></b>").css('background-color', '#A9C4F5')
    target.closest('.option_box_sides').data('part-first', target.data('part-first'))

  set_first_amount: (event)->
    event.preventDefault()
    target = $(event.currentTarget)
    target.closest('.amount_control_multi_sides_first').find('a.left_selection').html("#{target.html()}<b class='caret'></b>")
    if  _.values(@selected_matchups).length  == 2 
      scope_class = target.closest(".amount_control_multi_sides_first").find('a.left_selection')
    else
      scope_class = target.closest(".amount_control_multi_sides_first")
    if target.html().match(/Nada/)
      scope_class.css('background-color', 'transparent')
    else
      scope_class.css('background-color', '#A9C4F5')
    target.closest('.option_box_sides').find('.amount_control_multi_sides_first:first').data('quantity-first', target.data('quantity-first'))


  set_second_amount: (event)->
    event.preventDefault()
    target = $(event.currentTarget)
    target.closest('.amount_control_multi_sides_second').find('a.right_selection').html("#{target.html()}<b class='caret'></b>")
    if target.html().match(/Nada/)
      target.closest(".amount_control_multi_sides_second").find('a.right_selection').css('background-color', 'transparent')
    else
      target.closest(".amount_control_multi_sides_second").find('a.right_selection').css('background-color', '#EED3D7')
    target.closest('.option_box_sides').find('.amount_control_multi_sides_second:first').data('quantity-second', target.data('quantity-second'))

  set_amount: (event)->
    event.preventDefault()
    target = $(event.currentTarget)
    target.closest('.amount_control').find('a.amount_selection').html("#{target.html()}<b class='caret'></b>")
    if target.html().match(/Nada/)
      target.closest('.amount_control').css('background-color', 'transparent')
    else
      target.closest('.amount_control').css('background-color', '#A9C4F5')
    target.closest('.option_box').data('quantity', target.data('quantity'))

  
  select_specialty: (event)->
    event.preventDefault()
    target = $(event.currentTarget)
    matchup = @model.matchups().getByCid(target.attr('id'))
    $("<div class='purr'>El producto no esta disponible en el sabor seleccionado<div>").purr() unless @current_flavor_compatible(matchup)
    $("<div class='purr'>El producto no esta disponible en el tamaño seleccionado<div>").purr() unless @current_size_compatible(matchup)

    unless not @current_flavor_compatible(matchup) or not @current_size_compatible(matchup)
      @apply_selection(matchup)
    @gray_out_flavors()
    @gray_out_sizes()


  apply_selection: (matchup)->
    if _.include(_.values(@selected_matchups), matchup)
      if _.values(@selected_matchups).length > 0
        @selected_matchups = window.objectWithoutVal(@selected_matchups, matchup)
        @deassign_options(matchup)
        @decolorize_button(matchup.cid)
    else
      if _.values(@selected_matchups).length < @max_selectable_matchups
        if @selected_matchups['first']? then  @selected_matchups['second'] = matchup else @selected_matchups['first'] = matchup
        @colorize_button(matchup.cid, 'specialties_container')
        @assign_options(matchup)

  assign_options: (matchup) ->
    if _.values(@selected_matchups).length < 2 and _.any(matchup.defaultOptions())
      for opt in matchup.defaultOptions()
        if opt.product()?
          target = $(@el).find('.options_container').find("#product_#{opt.product().get('id')}")
          opt.configure(target, @model.configurableType())
    else if _.values(@selected_matchups).length == 2 and _.any(matchup.defaultOptions())
      @prepare_multi()
      for position in _.keys(@selected_matchups)
        for opt in @selected_matchups[position].defaultOptions()
          if opt.product()?
            target = $(@el).find('.options_container').find("#product_#{opt.product().get('id')}")
            opt.configureHalf(target, position)

  deassign_options: (matchup) ->
    if _.values(@selected_matchups).length == 0 and _.any(matchup.defaultOptions())
      $(@el).find('.dropdown').css('background-color', 'white')
      for opt in matchup.defaultOptions()
        if opt.product()?
          target = $(@el).find('.options_container').find("#product_#{opt.product().get('id')}")
          opt.teardown(target, @model.configurableType())
    else if _.values(@selected_matchups).length == 1 and _.any(matchup.defaultOptions())
      @rollback_multi()
      @reset()
      for position in _.keys(@selected_matchups)
        for opt in @selected_matchups[position].defaultOptions()
          if opt.product()?
            target = $(@el).find('.options_container').find("#product_#{opt.product().get('id')}")
            opt.teardownHalf(target, position)
      @colorize_button(@selected_matchups['first'].cid, 'specialties_container')
      @assign_options(@selected_matchups['first'])

  shift: ()->
    @selected_matchups['first'] = @selected_matchups['second']
    delete @selected_matchups['second']
    @selected_matchups['first']



  prepare_multi: () ->
    $(@el).find('.btn-group').hide()
    for dropdown in $(@el).find('.dropdown')
      if $(dropdown).css('background-color') != 'white'
        $(dropdown).find('a.left_selection').css('background-color', $(dropdown).css('background-color'))
        $(dropdown).css('background-color', 'white')
    $(@el).find('.amount_control_multi_sides_second').removeClass('hidden')

  reset: ()->
    scope = $(@el).find('.option_box_sides')
    scope.css('background-color', 'white')
    scope.find('a.left_selection').html("Nada<b class='caret'></b>").css('background-color', 'transparent')
    scope.find('a.right_selection').html("Nada<b class='caret'></b>").css('background-color', 'transparent')
    scope.find('.amount_control_multi_sides_second').addClass('hidden')
    scope.find('.btn-group').find('button').removeClass('active')
    scope.find('.dropdown').css('background-color', 'white')
    $(@el).find('.option_box_sides').removeData('part-first')
    $(@el).find('.option_box_sides').removeData('quantity-first')
    @shift() if @selected_matchups['second']?

  rollback_multi: ()->
    $(@el).find('.btn-group').show()
    $(@el).find('.dropdown').css('background-color', '#A9C4F5')
    $(@el).find('.amount_control_multi_sides_second').addClass('hidden')


  current_flavor_compatible: (matchup)->
    not @selected_flavor?  or (@selected_flavor? and _.include(matchup.acceptedFlavors(), @selected_flavor))


  current_size_compatible: (matchup)->
    not @selected_size? or (@selected_size? and _.include(matchup.acceptedSizes(), @selected_size.toString()))


  gray_out_flavors: () ->
    if _.isEmpty(_.values(@selected_matchups))
      $(@el).find(".flavors_container").find('.flavors').removeClass('disabled') 
    else
      allowed_flavors =  _.intersection.apply(_, _.map(_.values(@selected_matchups), (matchup)-> matchup.acceptedFlavors()))
      for button in $(@el).find(".flavors_container").find('.flavors')
        if _.isEmpty(allowed_flavors) or _.include(allowed_flavors,  $(button).data('flavorcode'))
          $(button).removeClass('disabled')
        else
          $(button).addClass('disabled').removeClass('btn-primary')


  gray_out_sizes: () ->
    if _.isEmpty(_.values(@selected_matchups))
      $(@el).find(".sizes_container").find('.sizes').removeClass('disabled') 
    else
      allowed_sizes =  _.intersection.apply(_, _.map(_.values(@selected_matchups), (matchup)-> matchup.acceptedSizes()))
      for button in $(@el).find(".sizes_container").find('.sizes')
        if _.isEmpty(allowed_sizes) or _.include(allowed_sizes,  $(button).data('sizecode').toString())
          $(button).removeClass('disabled')
        else
          $(button).addClass('disabled')


  select_flavor: (event)->
    event.preventDefault()
    target = $(event.currentTarget)
    if @selected_flavor?
      @selected_flavor = null
      @decolorize_button(target.attr('id'))
    else
      @selected_flavor = target.data('flavorcode')
      @colorize_button(target.attr('id'), 'flavors_container')

  select_size: (event)->
    event.preventDefault()
    target = $(event.currentTarget)
    if @selected_size?
      @selected_size = null
      @decolorize_button(target.attr('id'))
    else
      @selected_size = target.data('sizecode')
      @colorize_button(target.attr('id'), 'sizes_container')



  decolorize_button: (id)->    
    $("##{id}").removeClass('btn-primary') if $("##{id}").hasClass('btn-primary')
    $("##{id}").removeClass('btn-danger')if $("##{id}").hasClass('btn-danger')

  colorize_button: (id, scope_class)-> 
    if scope_class == 'specialties_container'
      if @selected_matchups['first']?
        $("##{@selected_matchups['first'].cid}").addClass('btn-primary').removeClass('btn-danger') unless $("##{@selected_matchups['first'].cid}").hasClass('disabled')
      if @selected_matchups['second']?
        $("##{@selected_matchups['second'].cid}").addClass('btn-danger')
    else
      if $(@el).find(".#{scope_class}").find('.btn-primary').size() == 0
        $("##{id}").addClass('btn-primary') unless $("##{id}").hasClass('disabled')


  resetCartProduct: ()->
    @options.cart_product = new Kapiqua25.Models.CartProduct()

  show_popover: (event)->
    if @model.hasOptions()
      target = $(event.currentTarget)
      matchup = @model.matchups().getByCid(target.attr('id'))
      if matchup? and matchup.nifftyOptions() != ''
        options = { animate: true, title:'Opciones', content: matchup.nifftyOptions() }
        target.popover(options)
        target.popover('show')

  #Added after upgrade, mouseout popup was not hiding after leaving the element
  hide_popover: (event)->
    if @model.hasOptions()
      target = $(event.currentTarget)
      target.popover('hide')