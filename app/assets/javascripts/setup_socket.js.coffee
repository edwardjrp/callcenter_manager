jQuery ->
  window.socket = io.connect("http://#{$('meta[name=\'node_url\']').attr('content')}")
  window.telephony = io.connect('http://192.168.85.80:8880')

  # # console.log window.telephony
  if window.telephony?
    window.telephony.on 'connect', ->
      agent_id = window.pad($('#current_username').data('idnumber'), 11)
      socket.emit "identificacion",{ cedula: agent_id }
      console.log "connected to telephony as #{agent_id}"

      window.telephony.on 'bridge', (phone) ->
        console.log phone
        if $('#client_search_phone').size() > 0
          $('#client_search_phone').autocomplete("search","#{phone}")
          $('#client_search_phone').val(phone)
          if $('.ui-menu-item a').size == 1
             $('.ui-menu-item a:first').trigger('click')
        else 
          windows.show_alert "Ha entrado una llamada desde #{phone} y no se encontro el formulario para colocarla", 'alert'