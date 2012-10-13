# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  socket = window.socket

  if $('#payments').size() > 0
    # console.log 'emit price'
    $('#actions').on 'click', '#place_order_button', (event)->
      event.preventDefault()
      target = $(event.currentTarget)
      socket.emit('cart:place',  $('#checkout_cart').data('id')) unless target.hasClass('disabled')
      target.addClass('disabled')
    socket.on 'cart:place:completed', (data)->
      $.ajax
        type: 'POST'
        url: "/carts/#{data.id}/completed"
        datatype: 'SCRIPT'
        data: data
        beforeSend: (xhr) ->
          xhr.setRequestHeader("Accept", "application/json")
        complete: ->
          window.location = '/'

    $('.checkout_input').restric('alpha').restric('spaces')
    socket.emit 'cart:price', $('#checkout_cart').data('id')
    socket.on 'cart:priced', (data)->
      $('#checkout_cart_net').html("<strong> Monto neto: </strong>RD$ #{Number(data.order_reply.netamount).toFixed(2)}")
      $('#checkout_cart_tax').html("<strong>  Impuestos: </strong>RD$ #{Number(data.order_reply.taxamount).toFixed(2)}")
      $('#checkout_cart_total').html("<strong> Monto de la orden: </strong>RD$ #{Number(data.order_reply.payment_amount).toFixed(2)}")
      _.each data.items, (item)->
        $("#cart_product_#{item.cart_product_id}").find('.item_price').html("RD$ #{Number(item.priced_at).toFixed(2)}")
      # console.log data.order_reply
      if data.order_reply.can_place == 'Yes'
        $('#actions').append('<a href="#" id="place_order_button" class="btn bottom-margin-1"><i class="icon-shopping-cart"></i> Colocar orden</a>') unless $('#place_order_button').size() > 0
        $("<div class='purr'>Hay cupones incompletos.<div>").purr() if data.order_reply.status == '6'
      else
        $('#place_order_button').remove() if $('#place_order_button').size() > 0
        $("<div class='purr'>Esta order fue rechazada por Pulse, verifique los requisitos. La tienda puede estar cerrada.<div>").purr()

    $('#abandon_cart').on 'click', (event)->
      event.preventDefault()
      target = $(event.currentTarget)
      $('#abandon_cart_modal').modal('show')

    $('#abandon_cart_modal_button').on 'click', (event)->
      event.preventDefault()
      target = $(event.currentTarget)
      form = $('#abandon_cart_form')
      $.ajax
        type: 'POST'
        url: form.attr('action')
        datatype: 'JSON'
        data: form.serialize()
        beforeSend: (xhr) ->
          xhr.setRequestHeader("Accept", "application/json")
        success: (response) ->
          window.location = '/'
        error: (response) ->
          $("<div class='purr'>#{response.responseText}<div>").purr()
