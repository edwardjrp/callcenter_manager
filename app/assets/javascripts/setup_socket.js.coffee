jQuery ->
  window.socket = io.connect("http://#{$('meta[name=\'node_url\']').attr('content')}")
  window.telephony = io.connect('http://192.168.85.80:8880')
