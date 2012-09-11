# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  if $('#mailboxes').size() > 0
    $('#nuevos').trigger('click')
    $('#clear_cart_search').on 'click', (event)->
      event.preventDefault()
      $('#clear_cart_search').closest('form')[0].reset()

    $('#mailboxes').on 'change', (event)->
      target = $(event.currentTarget)
      cart_ids = _.map($('.tab-pane.active').find('input.select_for_move:checked'), (el)-> $(el).closest('tr').data('cart-id'))
      $.ajax
        type: 'PUT'
        url: '/admin/carts/assign'
        datatype: 'JSON'
        data: {cart_ids: cart_ids, destination: target.val()}
        beforeSend: (xhr) ->
          xhr.setRequestHeader("Accept", "application/json")
        success: ()->
          console.log 'HELLO'
          for order_row in $('.tab-pane.active').find('input.select_for_move:checked').closest('tr')
            $(order_row).appendTo($("#cart_#{target.val()}").find('tbody'))
          $("##{target.val()}").trigger('click')
        error: (response)->
          console.log 'response'

        complete: (response)->
          console.log response


  $('#q_created_at_gteq').datepicker
    dateFormat: 'yy-mm-dd'
    
  $('#q_created_at_lteq').datepicker
    dateFormat: 'yy-mm-dd'