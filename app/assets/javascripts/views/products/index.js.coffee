class Kapiqua25.Views.ProductsIndex extends Backbone.View

  template: JST['products/index']
  
  initialize: ->
    _.bindAll(this, 'render', 'select_specialty', 'select_flavor','select_size', 'selection_marker', 'mark_matchup')
  
  events: ->
    'click .specialties':'select_specialty'
    'click .flavors':'select_flavor'
    'click .sizes':'select_size'
    'click .btn-success':'add_to_cart'
    "click table.option_table td":'modify_option'
    'mouseenter .specialties': 'show_popover'
    'mouseenter .option_box': 'option_scale_up'
    'mouseleave .option_box': 'option_scale_down'
    
  render: ->
    $(@el).html(@template(collection: @collection, options:@options))
    $(@el).find('input').restric('alpha').restric('spaces')
    this
  
  add_to_cart: (event)->
    event.preventDefault()
    options = @options.matchups.getByCid($($(@el).find('.specialties_container').find('.btn-primary')).attr('id'))?.get('options') if @options.category.get('has_options') == true
    options_secondary = @options.matchups.getByCid($($(@el).find('.specialties_container').find('.btn-danger')).attr('id'))?.get('options') if @options.category.get('has_options') == true and @options.category.get('multi') == true
    flavor = $($(@el).find('.flavors_container').find('.btn-primary')).data('flavorcode').toString() if $($(@el).find('.flavors_container').find('.btn-primary')).data('flavorcode')
    size = $($(@el).find('.sizes_container').find('.btn-primary')).data('sizecode').toString() if $($(@el).find('.sizes_container').find('.btn-primary')).data('sizecode')
    products = new Kapiqua25.Collections.Products()
    products.reset(@collection)
    if (flavor? and size?) and (flavor != '' and size != '')
      if options? and @options.category.get('has_options') == true
        product = _.first(products.where({options: options, flavorcode: flavor, sizecode:size}))
        product_secondary = _.first(products.where({options: options_secondary, flavorcode: flavor, sizecode:size})) if options_secondary? and @options.category.get('multi') == true
      else
        product = _.first(products.where({flavorcode: flavor, sizecode:size}))
    else
      window.show_alert('La selección no esta completa', 'alert')
    selected_quantity= $(@el).find('.cart_product_quantity').val() || 1
    selected_quantity = 1 if selected_quantity <= 0
    selected_quantity = 1 unless _.isNumber(selected_quantity)
    #  if type_unit false
    unless @options.category.get('type_unit') == true
      # this does not parses the sides yet
      selected_options = $(@el).find('.options_container').find('.primary_selected').closest('.option_box')
      selected_options_secondary = $(@el).find('.options_container').find('.secondary_selected').closest('.option_box') if product_secondary? and @options.category.get('multi') == true
      
      build_options = []
      assemble_options = []
      reverse_option_map = {1:'0.75', 2:'', 3:'1.5', 4:'2', 5:'3'}
      _.each selected_options, (op)->
        productcode = $(op).data('productcode')
        quantity = reverse_option_map[$(op).find('.primary_selected').length]
        console.log $(op).find('.primary_selected').length
        if ($(op).find('.primary_selected').hasClass('options_whole') or _.isEmpty($(@el).find('.specialties_container').find('.btn-danger'))) then part = '' else part = '1' 
        assemble_options.push({productcode: productcode, quantity: quantity, part: part })

        

      if _.any(selected_options_secondary)
        _.each selected_options_secondary, (op)->
          productcode = $(op).data('productcode')
          quantity = reverse_option_map[$(op).find('.secondary_selected').length]
          if ($(op).find('.primary_selected').hasClass('options_whole') or _.isEmpty($(@el).find('.specialties_container').find('.btn-primary'))) then part = '' else part = '2'
          found_opt = _.filter assemble_options, (asm_opt) -> (asm_opt.productcode ==  productcode and asm_opt.quantity == quantity)
          if _.any(found_opt) then _.first(found_opt).part = '' else assemble_options.push({productcode: productcode, quantity: quantity, part: part })
      build_options = _.map assemble_options, (asm_opt)-> if asm_opt.part != '' then "#{asm_opt.quantity}#{asm_opt.productcode}-#{asm_opt.part}" else "#{asm_opt.quantity}#{asm_opt.productcode}"
    else
      selected_options = $(@el).find('.options_container').find('.unit_option_setter')
      build_options=[]
      _.each selected_options, (op)->
        productcode = $(op).closest('.option_box').data('productcode')
        if ($(op).val() == '1') then quantity = '' else quantity = $(op).val()
        build_options.push("#{quantity}#{productcode}")
    #  end type_unit false

    if product?
      cart_product = new Kapiqua25.Models.CartProduct()
      cart_product.set({cart: @model, quantity: selected_quantity,product: product, options: build_options.join(','), bind_id: product_secondary?.id})
      cart_product.save()
      # $(@el).find('.cart_product_quantity').val('1')
      @render()
      current_category_pane = $("##{@options.category.get('name')}")
      current_category_pane.find("[data-bproduct='true']").trigger('click') if (current_category_pane.find("[data-bproduct='true']").size() > 0 and current_category_pane.find('.specialties_container').find('.btn-primary').size() == 0)
    else
      if options? and @options.category.get('has_options') == true
        window.show_alert('No existe el producto con el flavorcode seleccionado', 'alert') if _.any( products.where({options: options,sizecode:size}))
        window.show_alert('No existe el producto con el sizecode seleccionado', 'alert') if _.any( products.where({options: options,flavorcode: flavor}))
      else
        window.show_alert('No existe el producto con el flavorcode seleccionado', 'alert') if _.any(products.where({sizecode:size}))
        window.show_alert('No existe el producto con el sizecode seleccionado', 'alert') if _.any(products.where({flavorcode: flavor}))
        window.show_alert('No existe el producto con esta selección', 'alert') if _.any(products.where({flavorcode: flavor})) and _.any(products.where({sizecode:size}))
    
  select_specialty: (event)->
    event.preventDefault()
    $("##{@options.category.get('name')}")
    .find('.flavors_container')
    .find('.btn-primary')
    .removeClass('btn-primary') unless $("##{@options.category.get('name')}").find('.flavors_container').find('.btn-primary').hasClass('hidden')
    $("##{@options.category.get('name')}")
    .find('.sizes_container')
    .find('.btn-primary')
    .removeClass('btn-primary') unless $("##{@options.category.get('name')}").find('.sizes_container').find('.btn-primary').hasClass('hidden')
    @selection_marker($(event.currentTarget))
    unless @options.category.get('type_unit') == true
      primary_matchup = @options.matchups.getByCid($($(event.target).parent().find('.btn-primary')).attr('id'))
      secondary_matchup = @options.matchups.getByCid($($(event.target).parent().find('.btn-danger')).attr('id')) if @options.category.get('multi') == true
      @mark_matchup(@options.category,primary_matchup, secondary_matchup)
    else
      current_matchup = @options.matchups.getByCid($($(event.target).parent().find('.btn-primary')).attr('id'))
      @filter_size_and_flavor(current_matchup)
      $("##{@options.category.get('name')}").find('.unit_option_setter').val('0')
      _.each current_matchup.get('parsed_options'), (parsed_option) =>
        target = $("##{@options.category.get('name')}_#{parsed_option.product.get('productcode')}")
        target.find('input.unit_option_setter').val(parsed_option.quantity)
          
          
  select_flavor: (event)->
    event.preventDefault()
    target = $(event.currentTarget)
    unless target.hasClass('disabled') 
      @selection_marker(target)
    
  
  select_size: (event)->
    event.preventDefault()
    target = $(event.currentTarget)
    unless target.hasClass('disabled') 
      @selection_marker(target)
      
  selection_marker: (target)->
    if _.any(target.parent().find('.btn-primary'))
      unless @options.category.get('multi') == true and (target.parent()[0] == $(@el).find('.specialties_container')[0])
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
      target.removeClass('btn-danger') if target.hasClass('btn-danger') and (target.parent()[0] == $(@el).find('.specialties_container')[0])
    
  
  
  mark_matchup: (category, primary_matchup,secondary_matchup)->
    $('table.option_table td').css('background-color','transparent').removeClass('primary_selected').removeClass('secondary_selected')
    option_map = {0.75: 1, 1: 2, 1.5: 3, 2:4, 3: 5}
    unless primary_matchup? or secondary_matchup?
      $(".sizes").removeClass('disabled')
      $(".flavors").removeClass('disabled')
    if primary_matchup?
      if category.get('has_sides') == true then main_class =  'options_left' else main_class =  'options_whole'
      @add_selection_class(category, primary_matchup,'primary_selected', main_class)
      @filter_size_and_flavor(primary_matchup)
    if category.get('has_sides') == true
      unless secondary_matchup?
        if primary_matchup?
          @add_selection_class(category, primary_matchup,'primary_selected', 'options_rigth')
          @filter_size_and_flavor(primary_matchup)
      if secondary_matchup?
        @add_selection_class(category, secondary_matchup,'secondary_selected', 'options_rigth')
        @filter_size_and_flavor(secondary_matchup)
      unless  primary_matchup?
        if secondary_matchup?
          @add_selection_class(category, secondary_matchup,'secondary_selected', 'options_left')
          @filter_size_and_flavor(secondary_matchup)  

  filter_size_and_flavor: (matchup)->
    $("##{@options.category.get('name')}").find(".sizes").addClass('disabled')
    $("##{@options.category.get('name')}").find(".flavors").addClass('disabled')
    if matchup?
      for el_size in matchup.get('valid_sizes')
        $("##{@options.category.get('name')}").find(".#{el_size}").removeClass('disabled')
      for el_flavor in matchup.get('valid_flavors')
        $("##{@options.category.get('name')}").find(".#{el_flavor}").removeClass('disabled')



 
  add_selection_class: (category, primary_matchup, selection_class, side_class) ->
    if selection_class == 'primary_selected' then color = '#0073CC' else color = '#DA4E49'
    option_map = {0.75: 1, 1: 2, 1.5: 3, 2:4, 3: 5}
    _.each primary_matchup.get('parsed_options'), (parsed_option) =>
      target = $("##{category.get('name')}_#{parsed_option.product.get('productcode')}")
      for i in [0..(option_map[parsed_option.quantity]-1)]
        $(target.find("td.#{side_class}")[i]).css('background-color', color).addClass(selection_class) if i <= option_map[parsed_option.quantity]
             
             
  modify_option: (event)->
    target = $(event.currentTarget)
    target_to_clear = @markdown_remove($(event.currentTarget), 'primary_selected')
    if @options.category.get('multi') == true
      target_to_clear = @markdown_remove($(event.currentTarget), 'secondary_selected')
      
    primary_prensent = _.any($(@el).find('.specialties_container').find('.btn-primary'))
    secondary_prensent = _.any($(@el).find('.specialties_container').find('.btn-danger')) if @options.category.get('multi') == true
    
    unless target == target_to_clear
      if @options.category.get('has_sides') == true then main_class =  'options_left' else main_class =  'options_whole'
      @markdown_add(target,main_class, 'primary_selected', primary_prensent )
      if @options.category.get('has_sides') == true
        @markdown_add(target,'options_rigth', 'primary_selected', primary_prensent )

        if @options.category.get('multi') == true
          @markdown_add(target,'options_rigth', 'secondary_selected', secondary_prensent )              
          if target.hasClass('options_left') and not (primary_prensent? and primary_prensent == true)
            for target_option in target.closest('table').find('.options_left')
              unless _.indexOf(target.closest('table').find('.options_left'), target_option) > _.indexOf(target.closest('table').find('.options_left'), target[0])
                $(target_option).css('background-color', '#DA4E49').addClass('secondary_selected')

  markdown_add: (target, target_class, class_to_add, selection_present)->
    if class_to_add == 'primary_selected' then color = '#0073CC' else color = '#DA4E49'
    if target.hasClass(target_class) and selection_present? and selection_present == true
      for target_option in target.closest('table').find(".#{target_class}")
        unless _.indexOf(target.closest('table').find(".#{target_class}"), target_option) > _.indexOf(target.closest('table').find(".#{target_class}"), target[0])
          $(target_option).css('background-color', color).addClass(class_to_add)
  
  markdown_remove: (target, target_class)->
    if  target.hasClass(target_class)
      for target_option in target.closest('table').find(".#{_.without(target.attr('class').split(' '), target_class)}")
        if _.indexOf(target.closest('table').find(".#{_.without(target.attr('class').split(' '), target_class)}"), target_option) >= _.indexOf(target.closest('table').find(".#{_.without(target.attr('class').split(' '), target_class)}"), target[0])
          $(target_option).css('background-color', 'transparent').removeClass('primary_selected')        
      target
  
  
      
  show_popover: (event)->
    target_specialty = $(event.target)
    unless target_specialty.data('options') == ''
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