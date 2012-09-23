jQuery ->
  socket = window.socket
  socket.on 'connect', () -> 
    socket.emit 'register', { full_name: $('#chatbox').data('full_name'), idnumber: $('#chatbox').data('idnumber'), role: $('#chatbox').data('role') }, (response)->
      console.log response


  socket.on 'register_client', (operators) ->  
    $('#chatbox').find('.operator_tab').remove()
    $('#chatbox').find('.operator_pane').remove()
    for operator in operators
      $('#chatbox').find('.nav-tabs').append("<li class='operator_tab'><a href ='##{operator.idnumber}' data-toggle = 'tab'>#{operator.full_name}</a></li>")
      $('#chatbox').find('.tab-content').append(JST['chat/operator_tab'](operator: operator))

  socket.on 'set_admin', (data) ->
    $('#chatbox').find('#admin_tab').remove()
    $('#chatbox').find('#admin_pane').remove()
    $('#chatbox').find('.nav-tabs').append("<li id='admin_tab' ><a href ='#admin_pane' data-toggle = 'tab'>administradores</a></li>")
    $('#chatbox').find('.tab-content').append(JST['chat/admin_tab']())
    $('#admin_pane').find('.chatdisplay').append($('<p>').append($('<b>').text(data.full_name), window.truncate(data, 30)))
  
  $('#utils .top-tabs a').on 'click', (event)->
    event.preventDefault()
    target = $(".tab-pane##{$(this).attr('href').replace(/#/,'')}")
    if $(this).closest('li').hasClass('active')
      target.removeClass('active').hide()
      $(this).closest('li').removeClass('active')
    else
      target.addClass('active').show()
      $(this).closest('li').addClass('active')
      

  socket.on 'server_message', (data) ->
    console.log data
    $('#chatbox').find("##{data.idnumber}").find('.chatdisplay').append($('<p>').append($('<b>').text(data.full_name), window.truncate(data.msg, 30))) if $('#chatbox').find("##{data.to}")
    $('#chatbox').find("#admin_pane").find('.chatdisplay').append($('<p>').append($('<b>').text(data.full_name), window.truncate(data.msg, 30))) if $('#chatbox').find("#admin_pane")

  $('#chatbox').on 'submit', 'form', (event)->
    event.preventDefault()
    target = $(event.currentTarget)
    socket.emit 'send_message', { msg: target.find('.send_message').val(), to: target.closest('.active').attr('id'), idnumber: $('#chatbox').data('idnumber'), role: $('#chatbox').data('role') } , (data) ->
      target.prev('.chatdisplay').append($('<p>').append($('<b>').text(data.full_name), window.truncate(data.msg, 30)))

    target[0].reset()
    target.find("input[type='text']").val('')
    
#   socket.on 'chat', (data)->
#     message(data)    
    
#   socket.on 'reconnect', () ->
#     $('#lines').remove();
#     message({user:'System', msg:' Reconnected to the server'});
    
#   socket.on 'error', (err)->
#     console.log err
#     window.show_alert(err, 'error')
#     err_data = {user: 'System', msg:  (err ? err : 'Se ha perdido la conexion')}
#     message(err_data);
      
#   $('#chat_send').submit (event)->
#     event.preventDefault()
#     unless $('#chat_message').val() == ''
#       socket.emit('chat', {user: me(), msg: $('#chat_message').val()})
#       $('#chat_message').val('')
  
# message = (data) ->
#   $('#chatdisplay').append($('<p>').append($('<b>').text(data.user), window.truncate(data.msg, 30)))
#   $('#chatdisplay').children().first().remove() if $('#chatdisplay').children().size() > 50
#   $("#chatdisplay").scrollTop($("#chatdisplay")[0].scrollHeight);

# me = ()->
#   "#{$('#current_username').text()} : "
    
# prepare = (msg) ->
#   sent = new Date()
#   "enviado-#{sent.toString()}: #{msg}"