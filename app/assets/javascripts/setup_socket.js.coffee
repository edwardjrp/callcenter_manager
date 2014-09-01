jQuery ->
  window.socket = io.connect("http://#{$('meta[name=\'node_url\']').attr('content')}")
  window.telephony = io.connect('http://192.168.85.80:8880')
  #window.telephony = io.connect('http://localhost:8888')
  window.user_id = window.pad($('meta[name=\'user_id\']').attr('content'), 11)
  window.user_name = $('meta[name=\'user_name\']').attr('content')
  window.user_role = $('meta[name=\'user_role\']').attr('content')
