class Kapiqua25.Views.ProductsIndex extends Backbone.View

  template: JST['products/index']
  
  initialize: ->
    _.bindAll(this, 'mark_matchup', 'add_markers')
  
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
    current_matchup = @options.matchups.getByCid($($(event.target).parent().find('.btn-primary')).attr('id'))
    @unmark_matchup(_.first(@collection).get('category'),current_matchup) if current_matchup?
    @selection_marker($(event.target))
    current_matchup = @options.matchups.getByCid($($(event.target).parent().find('.btn-primary')).attr('id'))
    @mark_matchup(_.first(@collection).get('category'),current_matchup) if current_matchup?
  
  select_flavor: (event)->
    event.preventDefault()
    @selection_marker($(event.target))
    
  
  select_size: (event)->
    event.preventDefault()
    @selection_marker($(event.target))  
      
  selection_marker: (target)->
    if _.any(target.parent().find('.btn-primary'))
      target_to_clear = target.parent().find('.btn-primary')
      target_to_clear.removeClass('btn-primary')
      target.addClass('btn-primary') unless ($(target_to_clear)[0] == target[0])
    else
      target.addClass('btn-primary')
    
  
  
  mark_matchup: (category, matchup)->
    _.each matchup.get('parsed_options'), (parsed_option) =>
      target = $("##{category.get('name')}_#{parsed_option.product.get('productcode')}")
      option_map = {'0.75': 1, '1': 2, '1.5': 3, '2':4}
      unless _.any(target.find('.option_marker_primary'))
        @add_markers(target) for i in [0..(option_map[parsed_option.quantity]-1)]
        
  unmark_matchup: (category, matchup)->
    _.each matchup.get('parsed_options'), (parsed_option) =>
      target = $("##{category.get('name')}_#{parsed_option.product.get('productcode')}")
      target.find('.option_config').remove()

      
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
          
  
  add_markers: (target)->  
    level_holder= $("<div class='option_config'></div>")
    visual_que= $('<div class= "option_marker"></div>')
    left_marker= $('<div class= "left_primary"></div>')
    right_marker= $('<div class= "right_primary"></div>')
    visual_que.append(left_marker)
    visual_que.append(right_marker)
    level_holder.append(visual_que)
    target.append(level_holder)
  
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