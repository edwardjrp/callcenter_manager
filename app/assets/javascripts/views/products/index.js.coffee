class Kapiqua25.Views.ProductsIndex extends Backbone.View

  template: JST['products/index']
  
  initialize: ->
    _.bindAll(this, 'render', 'show_popover', 'select_specialty', 'colorize_button', 'decolorize_button')
    @selected_matchups = []
    @max_selectable_matchups = 1
    if @model.isMulti() then @max_selectable_matchups = 2 else @max_selectable_matchups = 1
  
  events: ->
    'mouseenter .specialties': 'show_popover'
    'click .specialties':'select_specialty'
  #   'click .flavors':'select_flavor'
  #   'click .sizes':'select_size'
  #   'click .btn-success':'add_to_cart'
  #   "click table.option_table td":'modify_option'
  #   'mouseenter .option_box': 'option_scale_up'
  #   'mouseleave .option_box': 'option_scale_down'
    
  render: ->
    # model = current category
    $(@el).html(@template(model: @model))
    $(@el).find('input').restric('alpha').restric('spaces')
    this
  
  select_specialty: (event)->
    event.preventDefault()
    target = $(event.currentTarget)
    console.log @max_selectable_matchups
    matchup = @model.matchups().getByCid(target.attr('id'))
    if _.include(@selected_matchups, matchup)
      if @selected_matchups.length > 0
        @selected_matchups = _.without(@selected_matchups, matchup)
        @decolorize_button(matchup.cid)
    else
      if @selected_matchups.length < @max_selectable_matchups
        @selected_matchups.push matchup
        @colorize_button(matchup.cid, 'specialties_container')


  decolorize_button: (id)->    
    $("##{id}").removeClass('btn-primary') if $("##{id}").hasClass('btn-primary')
    $("##{id}").removeClass('btn-danger')if $("##{id}").hasClass('btn-danger')

  colorize_button: (id, scope_class)->    
    if $(@el).find(".#{scope_class}").find('.btn-primary').size() == 0
      $("##{id}").addClass('btn-primary')
    else if $(@el).find(".#{scope_class}").find('.btn-primary').size() == 1
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