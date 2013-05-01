jQuery ->

  if $('#dashboard_screen').size() > 0
    $('#fullscreen').on 'click', (event)->
      event.preventDefault()
      $('#dashboard_screen').toggleFullScreen()

    $('.data_filter').on 'click', (event) ->
      target = $(event.currentTarget)
      if target.is(':checked')
        $("##{target.val()}").show()
      else
        $("##{target.val()}").hide()
          
    dashboard_interval = setInterval(dashboard_refresh, 30000)
  else
    clearInterval(dashboard_interval) if dashboard_interval


dashboard_refresh = ->
  $.getScript('/admin')