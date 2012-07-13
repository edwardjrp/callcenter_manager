class Kapiqua25.Views.ProductsIndex extends Backbone.View

  template: JST['products/index']
  
  initialize: ->
    _.bindAll(this, 'render', 'select_specialty', 'select_flavor','select_size', 'selection_marker', 'mark_matchup')
  
  events: ->
    'click .specialties':'select_specialty'
    'click .flavors':'select_flavor'
    'click .sizes':'select_size'
    'mouseenter .specialties': 'show_popover'
    'mouseenter .option_box': 'option_scale_up'
    'mouseleave .option_box': 'option_scale_down'
    
  render: ->
    $(@el).html(@template(collection: @collection, options:@options))
    this
    
  select_specialty: (event)->
    event.preventDefault()
    @selection_marker($(event.target))
    primary_matchup = @options.matchups.getByCid($($(event.target).parent().find('.btn-primary')).attr('id'))
    secondary_matchup = @options.matchups.getByCid($($(event.target).parent().find('.btn-danger')).attr('id')) if @options.category.get('multi') == true
    @mark_matchup(@options.category,primary_matchup, secondary_matchup, $(event.target))
  
  select_flavor: (event)->
    event.preventDefault()
    @selection_marker($(event.target))
    
  
  select_size: (event)->
    event.preventDefault()
    @selection_marker($(event.target))  
      
  selection_marker: (target)->
    if _.any(target.parent().find('.btn-primary'))
      unless @options.category.get('multi') == true
        target_to_clear = target.parent().find('.btn-primary')
        target_to_clear.removeClass('btn-primary')
        target.addClass('btn-primary') unless ($(target_to_clear)[0] == target[0])
      else
        unless target.hasClass('btn-primary')
          target_to_clear = target.parent().find('.btn-danger')
          target_to_clear.removeClass('btn-danger')
          target.addClass('btn-danger') unless ($(target_to_clear)[0] == target[0])
        else
          target.removeClass('btn-primary')
          target.removeClass('btn-danger')
    else
      target.addClass('btn-primary') unless target.hasClass('btn-danger')
      target.removeClass('btn-danger') if target.hasClass('btn-danger')
    
  
  
  mark_matchup: (category, primary_matchup,secondary_matchup , sender)->
    $('table.option_table td').css('background-color','transparent').removeClass('primary_selected').removeClass('secondary_selected')
    option_map = {'0.75': 1, '1': 2, '1.5': 3, '2':4, '3': 5}
    if primary_matchup?
      _.each primary_matchup.get('parsed_options'), (parsed_option) =>
        target = $("##{category.get('name')}_#{parsed_option.product.get('productcode')}")
        for i in [0..(option_map[parsed_option.quantity]-1)]
          $(target.find('td.options_left')[i]).css('background-color', '#0073CC').addClass('primary_selected') if i <= option_map[parsed_option.quantity]
    unless secondary_matchup?
      if primary_matchup?
        _.each primary_matchup.get('parsed_options'), (parsed_option) =>
          target = $("##{category.get('name')}_#{parsed_option.product.get('productcode')}")
          for i in [0..(option_map[parsed_option.quantity]-1)]
            $(target.find('td.options_rigth')[i]).css('background-color', '#0073CC').addClass('primary_selected') if i <= option_map[parsed_option.quantity]
    if secondary_matchup?
      _.each secondary_matchup.get('parsed_options'), (parsed_option) =>
        target = $("##{category.get('name')}_#{parsed_option.product.get('productcode')}")
        for i in [0..(option_map[parsed_option.quantity]-1)]
          $(target.find('td.options_rigth')[i]).css('background-color', '#DA4E49').addClass('secondary_selected') if i <= option_map[parsed_option.quantity]
    unless  primary_matchup?
      if secondary_matchup?
        _.each secondary_matchup.get('parsed_options'), (parsed_option) =>
          target = $("##{category.get('name')}_#{parsed_option.product.get('productcode')}")
          for i in [0..(option_map[parsed_option.quantity]-1)]
            $(target.find('td.options_left')[i]).css('background-color', '#DA4E49').addClass('secondary_selected') if i <= option_map[parsed_option.quantity]
          
 
             

      
  show_popover: (event)->
    target_specialty = $(event.target)
    options = {animate: true, title:'Opciones', content: target_specialty.data('options')}
    target_specialty.popover(options)
    target_specialty.popover('show')  
      
  option_scale_up: (event)->
    target_option = $(event.currentTarget) 
    target_option.parent().css('z-index', 1000)
    increase_size = 30
    w = 80
    h = 50
    target_option.stop().animate
      top:  ("-#{increase_size}px ") 
      left: ("-#{increase_size}px")
      height:"#{(h+2*increase_size)}px"
      width: "#{(w+2*increase_size)}px"
      200
          
    
    
  
  option_scale_down: (event)->    
    target_option = $(event.currentTarget) 
    w = 80
    h = 50
    target_option.stop().animate
      top:  ("0px ") 
      left: ("0px")
      height:"#{h}px"
      width: "#{w}px"
      200
      ->
        target_option.parent().css('z-index', 1)  