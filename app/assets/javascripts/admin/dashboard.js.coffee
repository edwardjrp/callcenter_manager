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
          
    window.dashboard_refresh()
  else
    clearInterval(window.dashboard_refresh)


window.dashboard_refresh = ->
    setInterval ->
        $.getScript('/admin')
      ,
      30000