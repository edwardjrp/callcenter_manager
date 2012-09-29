class Kapiqua25.Views.ProductsIndex extends Backbone.View

  template: JST['products/index']
  
  initialize: ->
    _.bindAll(this,
      'render',
      'show_popover',
      'select_specialty',
      'colorize_button',
      'decolorize_button',
      'select_flavor',
      'select_size',
      'gray_out_flavors',
      'gray_out_sizes')
    @selected_matchups = []
    @selected_flavor = null
    @selected_flavor = @model.availableFlavors()[0] if @model.availableFlavors().length == 1
    @selected_size = null
    @selected_size = @model.availableSizes()[0] if @model.availableSizes().length == 1
    @max_selectable_matchups = 1
    if @model.isMulti() then @max_selectable_matchups = 2 else @max_selectable_matchups = 1
  
  events: ->
    'mouseenter .specialties': 'show_popover'
    'click .specialties':'select_specialty'
    'click .flavors':'select_flavor'
    'click .sizes':'select_size'
    'mouseenter .option_box_sides':'show_options'
    'mouseleave .option_box_sides':'hide_options'
  #   'click .btn-success':'add_to_cart'
  #   "click table.option_table td":'modify_option'
  #   'mouseenter .option_box': 'option_scale_up'
  #   'mouseleave .option_box': 'option_scale_down'
    
  render: ->
    # model = current category
    $(@el).html(@template(model: @model))
    $(@el).find('input').restric('alpha').restric('spaces')
    this
  
  show_options: (event)->
    target = $(event.currentTarget)
    target.find('.options_list').show()

  hide_options: (event)->
    target = $(event.currentTarget)
    target.find('.options_list').hide()

  select_specialty: (event)->
    event.preventDefault()
    target = $(event.currentTarget)
    matchup = @model.matchups().getByCid(target.attr('id'))

    $("<div class='purr'>El producto no esta disponible en el sabor seleccionado<div>").purr() unless @current_flavor_compatible(matchup)
    $("<div class='purr'>El producto no esta disponible en el tamaño seleccionado<div>").purr()   unless @current_size_compatible(matchup)

    unless not @current_flavor_compatible(matchup) or not @current_size_compatible(matchup)
      @apply_selection(matchup)
    @gray_out_flavors()
    @gray_out_sizes()


  apply_selection: (matchup)->
    if _.include(@selected_matchups, matchup)
      if @selected_matchups.length > 0
        @selected_matchups = _.without(@selected_matchups, matchup)
        @decolorize_button(matchup.cid)
    else
      if @selected_matchups.length < @max_selectable_matchups
        @selected_matchups.push matchup
        @colorize_button(matchup.cid, 'specialties_container')


  current_flavor_compatible: (matchup)->
    not @selected_flavor?  or (@selected_flavor? and _.include(matchup.acceptedFlavors(), @selected_flavor))


  current_size_compatible: (matchup)->
    not @selected_size? or (@selected_size? and _.include(matchup.acceptedSizes(), @selected_size.toString()))


  gray_out_flavors: () ->
    if _.isEmpty(@selected_matchups)
      $(@el).find(".flavors_container").find('.flavors').removeClass('disabled') 
    else
      allowed_flavors =  _.intersection.apply(_, _.map(@selected_matchups, (matchup)-> matchup.acceptedFlavors()))
      for button in $(@el).find(".flavors_container").find('.flavors')
        if _.isEmpty(allowed_flavors) or _.include(allowed_flavors,  $(button).data('flavorcode'))
          $(button).removeClass('disabled')
        else
          $(button).addClass('disabled')

  gray_out_sizes: () ->
    if _.isEmpty(@selected_matchups)
      $(@el).find(".sizes_container").find('.sizes').removeClass('disabled') 
    else
      allowed_sizes =  _.intersection.apply(_, _.map(@selected_matchups, (matchup)-> matchup.acceptedSizes()))
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
    if $(@el).find(".#{scope_class}").find('.btn-primary').size() == 0
      $("##{id}").addClass('btn-primary') unless $("##{id}").hasClass('disabled')
    else if $(@el).find(".#{scope_class}").find('.btn-primary').size() == 1 and scope_class == 'specialties_container'
      $("##{id}").addClass('btn-danger')


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