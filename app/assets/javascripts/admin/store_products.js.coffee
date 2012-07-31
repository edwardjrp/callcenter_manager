# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  $('.store_product_change_state_available').on 'click', (event)->
    event.preventDefault()
    change_state($(event.currentTarget))
  
  $('.create_store_product').one 'click', (event)->
    event.preventDefault()
    $.ajax
      type: 'Post'
      url: $(event.currentTarget).attr('href')
      data: {store_product: {product_id: $(event.currentTarget).closest('tr').data('product-id'), store_id: $(event.currentTarget).closest('table').data('store-id')}}
      beforeSend: (xhr) ->
        xhr.setRequestHeader("Accept", "application/json")
      success: (data)->
        $(event.currentTarget).removeClass('create_store_product')
        $(event.currentTarget).addClass('btn').addClass('btn-inverse').addClass('store_product_change_state_available').attr('href', "/admin/store_products/#{data.id}")
        $(event.currentTarget).text(data.available)
        $(event.currentTarget).on 'click', (event)->
          event.preventDefault()
          change_state($(event.currentTarget))
        
        
        
change_state = (target)->
  $.ajax
    type: 'PUT'
    url: $(event.currentTarget).attr('href')
    data: {store_product: {product_id: $(event.currentTarget).closest('tr').data('product-id'), store_id: $(event.currentTarget).closest('table').data('store-id')}}
    beforeSend: (xhr) ->
      xhr.setRequestHeader("Accept", "application/json")
    success: (data)->
      target.text(data.available)
      if target.hasClass('btn-primary') then target.removeClass('btn-primary').addClass('btn-inverse') else target.removeClass('btn-inverse').addClass('btn-primary')