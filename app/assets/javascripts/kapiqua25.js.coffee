window.Kapiqua25 =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  init: -> 
    new Kapiqua25.Routers.Categories()
    Backbone.history.start()

$(document).ready ->
  Kapiqua25.init() if $('#builder').length > 0

  window.socket.emit 'cart:price', $('#cart').data('cart').id if $('#cart').size() > 0 and $('#cart').data('cart')?
