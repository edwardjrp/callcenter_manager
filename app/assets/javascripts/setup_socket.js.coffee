jQuery ->
  window.socket = io.connect("http://#{$('meta[name=\'node_url\']').attr('content')}")