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
