class Kapiqua25.Views.ProductsIndex extends Backbone.View

  template: JST['products/index']
  
  initialize: ->
    _.bindAll(this, 'render', 'select_specialty', 'select_flavor','select_size', 'selection_marker', 'mark_matchup')
  
  events: ->
    'click .specialties':'select_specialty'
    'click .flavors':'select_flavor'
    'click .sizes':'select_size'
    'click .btn-success':'send_test'
    "click table.option_table td":'modify_option'
    'mouseenter .specialties': 'show_popover'
    'mouseenter .option_box': 'option_scale_up'
    'mouseleave .option_box': 'option_scale_down'
    
  render: ->
    $(@el).html(@template(collection: @collection, options:@options))
    this
    
  send_test: (event)->
    event.preventDefault()
    $.ajax
      type: 'POST'
      url: 'http://localhost:3030/carts/43/cart_products'
      data: {test: 'Hello'}
      beforeSend: (xhr)->
        xhr.setRequestHeader("Accept", "application/json")
      success: (res)->
        console.log res
    
  select_specialty: (event)->
    event.preventDefault()
    @selection_marker($(event.target))
    unless @options.category.get('type_unit') == true
      primary_matchup = @options.matchups.getByCid($($(event.target).parent().find('.btn-primary')).attr('id'))
      secondary_matchup = @options.matchups.getByCid($($(event.target).parent().find('.btn-danger')).attr('id')) if @options.category.get('multi') == true
      @mark_matchup(@options.category,primary_matchup, secondary_matchup, $(event.target))
    else
      current_matchup = @options.matchups.getByCid($($(event.target).parent().find('.btn-primary')).attr('id'))
      _.each current_matchup.get('parsed_options'), (parsed_option) =>
        target = $("##{@options.category.get('name')}_#{parsed_option.product.get('productcode')}")
        target.find('input.unit_option_setter').val(parsed_option.quantity)
          
          
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
          
 
             
  modify_option: (event)->
    target = $(event.currentTarget)
    if  target.hasClass('primary_selected')
      for target_option in target.closest('table').find(".#{_.without(target.attr('class').split(' '), 'primary_selected')}")
        if _.indexOf(target.closest('table').find(".#{_.without(target.attr('class').split(' '), 'primary_selected')}"), target_option) >= _.indexOf(target.closest('table').find(".#{_.without(target.attr('class').split(' '), 'primary_selected')}"), target[0])
          $(target_option).css('background-color', 'transparent').removeClass('primary_selected')        
      target_to_clear = target
      
    if  target.hasClass('secondary_selected') and @options.category.get('multi') == true  
      for target_option in target.closest('table').find(".#{_.without(target.attr('class').split(' '), 'secondary_selected')}")
        if _.indexOf(target.closest('table').find(".#{_.without(target.attr('class').split(' '), 'secondary_selected')}"), target_option) >= _.indexOf(target.closest('table').find(".#{_.without(target.attr('class').split(' '), 'secondary_selected')}"), target[0])
          $(target_option).css('background-color', 'transparent').removeClass('secondary_selected')        
      target_to_clear = target
      
    primary_prensent = _.any($(@el).find('.specialties_container').find('.btn-primary'))
    secondary_prensent = _.any($(@el).find('.specialties_container').find('.btn-danger')) if @options.category.get('multi') == true
    
    unless target == target_to_clear
      if target.hasClass('options_left') and primary_prensent? and primary_prensent == true
        for target_option in target.closest('table').find('.options_left')
          unless _.indexOf(target.closest('table').find('.options_left'), target_option) > _.indexOf(target.closest('table').find('.options_left'), target[0])
            $(target_option).css('background-color', '#0073CC').addClass('primary_selected')
      if target.hasClass('options_rigth') and not (secondary_prensent? and secondary_prensent == true )
        for target_option in target.closest('table').find('.options_rigth')
          unless _.indexOf(target.closest('table').find('.options_rigth'), target_option) > _.indexOf(target.closest('table').find('.options_rigth'), target[0])
            $(target_option).css('background-color', '#0073CC').addClass('primary_selected')
      if @options.category.get('multi') == true
        if target.hasClass('options_rigth') and secondary_prensent? and secondary_prensent == true
          for target_option in target.closest('table').find('.options_rigth')
            unless _.indexOf(target.closest('table').find('.options_rigth'), target_option) > _.indexOf(target.closest('table').find('.options_rigth'), target[0])
              $(target_option).css('background-color', '#DA4E49').addClass('secondary_selected')
              
        if target.hasClass('options_left') and not (primary_prensent? and primary_prensent == true)
          for target_option in target.closest('table').find('.options_left')
            unless _.indexOf(target.closest('table').find('.options_left'), target_option) > _.indexOf(target.closest('table').find('.options_left'), target[0])
              $(target_option).css('background-color', '#DA4E49').addClass('secondary_selected')
          
      
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
      ->
        target_option.find('table.option_table td').css('border-color','black').css('border-width','1px')
    
    
  
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
        target_option.find('table.option_table td').css('border-color','none').css('border-width','0px')