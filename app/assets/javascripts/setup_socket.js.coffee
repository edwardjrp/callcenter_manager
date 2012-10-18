jQuery ->
  window.socket = io.connect("http://#{$('meta[name=\'node_url\']').attr('content')}")
  # window.telephony = io.connect('http://192.168.101.70:8880')

  # # console.log window.telephony
  # # if window.telephony?
  # window.telephony.on 'connect', ->
  #   console.log 'connected to telephony'