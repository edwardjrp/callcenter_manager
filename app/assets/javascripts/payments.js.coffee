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
      $('#checkout_cart_net').html("<strong> Monto neto: </strong> #{window.to_money(data.order_reply.netamount)}")
      $('#checkout_cart_tax').html("<strong>  Impuestos: </strong> #{window.to_money(data.order_reply.taxamount)}")
      $('#checkout_cart_total').html("<strong> Monto de la orden: </strong> #{window.to_money(data.order_reply.payment_amount)}")
      _.each data.items, (item)->
        $("#cart_product_#{item.cart_product_id}").find('.item_price').html(window.to_money(item.priced_at))
      # console.log data.order_reply
      if data.order_reply.can_place == 'Yes'
        $('#actions').append('<a href="#" id="place_order_button" class="btn bottom-margin-1"><i class="icon-shopping-cart"></i> Colocar orden</a>') unless $('#place_order_button').size() > 0
        $("<div class='purr'>Hay cupones incompletos.<div>").purr() if data.order_reply.status == '6'
      else
        $('#place_order_button').remove() if $('#place_order_button').size() > 0
        $("<div class='purr'>Esta order fue rechazada por Pulse, verifique los requisitos. La tienda puede estar cerrada.<div>").purr()

    $('#exonerate_cart').on 'click', (event)->
      event.preventDefault()
      target = $(event.currentTarget)
      $('#exonerate_cart_modal').modal('show')


    $('#exonerate_cart_modal_button').on 'click', (event)->
      event.preventDefault()
      target = $(event.currentTarget)
      form = $('#exonerate_cart_form')
      $.ajax
        type: 'POST'
        url: form.attr('action')
        datatype: 'JSON'
        data: form.serialize()
        beforeSend: (xhr) ->
          xhr.setRequestHeader("Accept", "application/json")
        success: (cart) ->
          console.log cart
          $('#exonerate_cart_modal').modal('hide')
          $('#checkout_cart_exoneration').html("<strong>Exonerado:</strong> #{cart.exonerated}")
        error: (response) ->
          $("<div class='purr'>#{response.responseText}<div>").purr()



    $('#discount_cart').on 'click', (event)->
      event.preventDefault()
      target = $(event.currentTarget)
      $('#discount_cart_modal').modal('show')

    $('#discount_cart_modal_button').on 'click', (event)->
      event.preventDefault()
      target = $(event.currentTarget)
      form = $('#discount_cart_form')
      $.ajax
        type: 'POST'
        url: form.attr('action')
        datatype: 'JSON'
        data: form.serialize()
        beforeSend: (xhr) ->
          xhr.setRequestHeader("Accept", "application/json")
        success: (cart) ->
          $('#discount_cart_modal').modal('hide')
          $('#checkout_cart_discount').html("<strong>Descuento:</strong> RD$ #{(Number(cart.discount)).toFixed(2)}")
        error: (response) ->
          $("<div class='purr'>#{response.responseText}<div>").purr()


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

    $('.checkout_input').on 'focus', (event)->
      target = $(event.currentTarget)
      target.css('background-color','#F78181')

    $('.checkout_input').on 'blur', (event)->
      target = $(event.currentTarget)
      target.css('background-color','white')

    $('.checkout_input').on 'change', (event)->
      target = $(event.currentTarget)
      $('#actions').find('#place_order_button').remove()
      if Number(target.val()) < 1 then target.val('1')
      socket.emit 'cart_products:update', { id: target.closest('tr').data('cart-product-id'), quantity: target.val() }, (error, cart_product) ->
        if error
          $("<div class='purr'>No se puedo realizar la actualización<div>").purr()
          target.val(target.data('orig'))
        else
          target.data('orig', cart_product.quantity)
          target.css('background-color','white')
          target.effect('highlight')
