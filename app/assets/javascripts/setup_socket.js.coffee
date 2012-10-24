jQuery ->
  window.socket = io.connect("http://#{$('meta[name=\'node_url\']').attr('content')}")
  window.telephony = io.connect('http://192.168.85.80:8880')

  # # console.log window.telephony
  if window.telephony?
    window.telephony.on 'connect', ->
      socket.emit "identificacion",{ cedula: '00118981216' }
      console.log "conected as 00118981216"
      # socket.emit "identificacion",{ cedula: $('#current_username').data('idnumber') }

    socket.on 'bridge', (agente) ->
      console.log agente
      if $('#client_search_phone').size() > 0
        $("input#yourinput").autocomplete("search","");
        $('#client_search_phone').autocomplete("search","#{agente.cliente}")
        if $('.ui-menu-item a').size == 1
           $('.ui-menu-item a:first').trigger('click')
      else 
        windows.show_alert "Ha entrado una llamada desde #{agente.cliente} y no se encontro el formulario para colocarla", 'alert'