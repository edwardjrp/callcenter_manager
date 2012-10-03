jQuery ->
  socket = window.socket
  
  socket.on 'cart:price:error', (msg) ->
    $("<div class='purr'>#{msg}<div>").purr()