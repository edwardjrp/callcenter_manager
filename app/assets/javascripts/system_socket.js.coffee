jQuery ->
  socket = window.socket

  socket.on 'system:cart:placed', (data)->
    $('#system_wide').find('.chatdisplay').children().first().remove() if $('#system_wide').find('.chatdisplay').children().size() > 50
    $('#system_wide').find('.chatdisplay').append($('<p>').append("Orden completada <a href='/admin/carts/#{data.id}'>#{data.id}</a>"))

  socket.on 'system:cart:comm_failed', (data)->
    $('#system_wide').find('.chatdisplay').children().first().remove() if $('#system_wide').find('.chatdisplay').children().size() > 50
    $('#system_wide').find('.chatdisplay').append($('<p>').append("Falló la comunicación, para la orden <a href='/admin/carts/#{data.id}'>#{data.id}</a>"))
    window.system_alert.play()

  socket.on 'system:cart:price:error', (data)->
    $('#system_wide').find('.chatdisplay').children().first().remove() if $('#system_wide').find('.chatdisplay').children().size() > 50
    $('#system_wide').find('.chatdisplay').append($('<p>').append("No se pudo pedir precio para la orden <a href='/admin/carts/#{data.id}'>#{data.id}</a>"))
    window.system_alert.play()



