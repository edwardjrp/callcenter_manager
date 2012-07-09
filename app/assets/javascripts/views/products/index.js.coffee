class Kapiqua25.Views.ProductsIndex extends Backbone.View

  template: JST['products/index']
  
  events: ->
    'click .specialties':'select_specialty'
    'mouseenter .option_box': 'option_scale_up'
    'mouseleave .option_box': 'option_scale_down'
    
  
  render: ->
    $(@el).html(@template(collection: @collection, options:@options))
    this
    
  select_specialty: (event)->
    event.preventDefault()
    console.log $(event.target)
  
  option_scale_up: (event)->
    target_option = $(event.target) 
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
    target_option = $(event.target) 
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