class Kapiqua25.Views.ProductsIndex extends Backbone.View

  template: JST['products/index']
  
  # initialize: ->
  #   _.bindAll(this, 'render', 'select_specialty', 'select_flavor','select_size', 'selection_marker', 'mark_matchup')
  
  # events: ->
  #   'click .specialties':'select_specialty'
  #   'click .flavors':'select_flavor'
  #   'click .sizes':'select_size'
  #   'click .btn-success':'add_to_cart'
  #   "click table.option_table td":'modify_option'
  #   'mouseenter .specialties': 'show_popover'
  #   'mouseenter .option_box': 'option_scale_up'
  #   'mouseleave .option_box': 'option_scale_down'
    
  render: ->
    # model = current category
    $(@el).html(@template(model: @model))
    $(@el).find('input').restric('alpha').restric('spaces')
    this
  
  