# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  if $('#payments').size() > 0
    socket = window.socket

    $('.coocking_instructions_select').on 'change', (event)->
      target = $(event.currentTarget)
      cart_product_id = target.data('cart-product-id')
      $('#loader img').show()
      $.ajax
        type: 'PUT'
        datatype: 'JSON'
        url: "/carts/#{cart_product_id}/coocking_instructions"
        data: { coocking_instructions: target.val() }
        beforeSend: (xhr) ->
          xhr.setRequestHeader("Accept", "application/json")
        success: (cart_product) ->
          show_alert "#{cart_product.product.productname} estará #{cart_product.coocking_instructions}", 'success'
        complete: ->
          $('#loader img').hide()


    $('#actions').on 'click', '#place_order_button', (event)->
      event.preventDefault()
      target = $(event.currentTarget)
      payment_attributes = {}
      payment_attributes['cart_id'] = $('#checkout_cart').data('id')
      payment_attributes['city'] = $('#target_city').text() if $('#target_city')?
      payment_attributes['area'] = $('#target_area').text() if $('#target_area')?
      payment_attributes['street'] = $('#target_street').text() if $('#target_street')?
      if $('#cash_payment').is(':checked')
        payment_attributes['payment_type'] = 'CashPayment'
      else if $('#credit_payment').is(':checked')
        if $('#cardnumber').val() != '' and $('#cardapproval').val() != ''
          payment_attributes['payment_type'] = 'CreditCardPayment'
          payment_attributes['cardnumber'] = $('#cardnumber').val()
          payment_attributes['cardapproval'] = $('#cardapproval').val()
        else
          $("<div class='purr'>La información de pago no esta completa.<div>").purr({removeTimer: 15000})
      else
        $("<div class='purr'>La información de pago no esta completa.<div>").purr({removeTimer: 15000})
      if $('#fiscal_info').val()? and $('#fiscal_info').val() != ''
        payment_attributes['rnc'] = $('#fiscal_info').val().split('/')[0]
        payment_attributes['fiscal_type'] = $('#fiscal_info').val().split('/')[1]
        payment_attributes['fiscal_name'] = $('#fiscal_info').val().split('/')[2]
      unless target.hasClass('disabled')
        socket.emit('cart:place',  payment_attributes) 
        $('#loader img').show()
      target.addClass('disabled')

    $('.checkout_cart_remove_coupon').on 'click', (event) ->
      event.preventDefault()
      target = $(event.currentTarget)
      if confirm('¿Seguro que desea remover este cupón?')
        socket.emit "cart_coupons:delete", { id: target.closest('tr').data('cart-coupon-id') }

    socket.on 'cart_coupon:removed', (coupon_id)->
      $("#cart_coupon_{data.id}").remove()
      $('#checkout_client_side_coupons_list').remove() if $('#checkout_client_side_coupons_list').find('body').children().length == 0

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

    socket.on 'cart:place:comm_failed', (data) ->
      $("<div class='purr'>Un error de comunicacion ha impedido colocar la orden, esta orde sera procesada por un uservisor<div>").purr({isSticky: true})
      setTimeout ->
        $.ajax
          type: 'POST'
          url: "/carts/release"
          dataType: "script"
          beforeSend: (xhr) ->
            xhr.setRequestHeader("Accept", "text/javascript")
          complete: ->
            window.location = '/'
        ,
          5000
      


    $('.checkout_input').restric('alpha').restric('spaces')

    socket.emit 'cart:price', $('#checkout_cart').data('id')

    socket.on 'cart:priced', (data)->
      $('#checkout_cart_net').html("<strong> Monto neto: </strong> #{window.to_money(data.order_reply.netamount)}")
      $('#checkout_cart_tax').html("<strong>  Impuestos: </strong> #{window.to_money(data.order_reply.taxamount)}")
      $('#checkout_cart_total').html("<strong> Monto de la orden: </strong> #{window.to_money(data.order_reply.payment_amount)}")
      $('#checkout_cart_exoneration').html("<strong>Exonerado:</strong> N/A")
      $('#checkout_cart_discount').html("<strong>Descuento:</strong> RD$ 0.00")
      $('#loader img').hide()
      _.each data.items, (item)->
        $("#cart_product_#{item.cart_product_id}").find('.item_price').html(window.to_money(item.priced_at))
      # console.log data.order_reply
      if data.order_reply.can_place == 'Yes'
        $('#actions').append('<a href="#" id="place_order_button" class="btn bottom-margin-1"><i class="icon-shopping-cart"></i> Colocar orden</a>') unless $('#place_order_button').size() > 0
        $("<div class='purr'>Hay cupones incompletos.<div>").purr({removeTimer: 15000}) if data.order_reply.status == '6'
      else
        $('#place_order_button').remove() if $('#place_order_button').size() > 0
        $("<div class='purr'>Esta order fue rechazada por Pulse, verifique los requisitos. La tienda puede estar cerrada.<div>").purr({removeTimer: 15000})

    $('#exonerate_cart').on 'click', (event)->
      event.preventDefault()
      target = $(event.currentTarget)
      $('#exonerate_cart_modal').modal('show')


    $('#exonerate_cart_modal_button').on 'click', (event)->
      event.preventDefault()
      target = $(event.currentTarget)
      form = $('#exonerate_cart_form')
      $('#loader img').show()
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
          $("<div class='purr'>#{response.responseText}<div>").purr({removeTimer: 15000})
        complete: ->
          $('#loader img').hide()



    $('#discount_cart').on 'click', (event)->
      event.preventDefault()
      target = $(event.currentTarget)
      $('#discount_cart_modal').modal('show')

    $('#discount_cart_modal_button').on 'click', (event)->
      event.preventDefault()
      target = $(event.currentTarget)
      form = $('#discount_cart_form')
      $('#loader img').show()
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
          $("<div class='purr'>#{response.responseText}<div>").purr({removeTimer: 15000})
        complete: ->
          $('#loader img').hide()


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
          $("<div class='purr'>#{response.responseText}<div>").purr({removeTimer: 15000})

    $('#cash_payment').on 'click', (event)->
      $('#creditcard_number').addClass('hidden')
      $('#creditcard_approval').addClass('hidden')

    $('#credit_payment').on 'click', (event)->
      $('#creditcard_number').removeClass('hidden')
      $('#creditcard_approval').removeClass('hidden')

    socket.on 'cart:empty', (data)->
      window.location = '/builder'

    $('.checkout_cart_remove_item').on 'click', (event)->
      event.preventDefault()
      target = $(event.currentTarget)
      table = target.closest('table')
      if confirm('¿Seguro que desea remover el producto de la orden?')
        $('#actions').find('#place_order_button').remove()
        $('#loader img').show()
        socket.emit 'cart_products:delete', { id: target.closest('tr').data('cart-product-id') }, (error, cart_product_id) ->
          $('#loader img').hide()
          if error
            $("<div class='purr'>No se puedo remover el elemento<div>").purr({removeTimer: 15000})
          else
            $("#cart_product_#{cart_product_id}").remove()
            $("<div class='purr'>Los descuentos y exoneraciones deben ser solicitados luego de cada cambio a la orden<div>").purr({removeTimer: 15000})
            table.find('td').effect('highlight', { color: '#1175AE'})
        

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
      $('#loader img').show()
      socket.emit 'cart_products:update', { id: target.closest('tr').data('cart-product-id'), quantity: target.val() }, (error, cart_product) ->
        $('#loader img').hide()
        if error
          $("<div class='purr'>No se puedo realizar la actualización<div>").purr({removeTimer: 15000})
          console.log error
          target.val(target.data('orig'))
        else
          target.data('orig', cart_product.quantity)
          target.css('background-color','white')
          target.closest('tr').find('td').effect('highlight', { color: '#1175AE'})

    socket.on 'cart:place:error', (msg) ->
      $("<div class='purr'>#{msg}<div>").purr({isSticky: true})