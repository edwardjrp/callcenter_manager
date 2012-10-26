jQuery ->

  if $('#dashboard_screen').size() > 0
    $('#fullscreen').on 'click', (event)->
      event.preventDefault()
      $('#dashboard_screen').toggleFullScreen()

    $('#dashboard_data_filter').on 'change', (event) ->
      target = $(event.currentTarget)
      switch target.val()        
        when 'users_carts_count'
          $('.dashboard_datatable').hide()
          $('#users_carts_count').show()
        when 'users_payment_average'
          $('.dashboard_datatable').hide()
          $('#users_payment_average').show()
        when 'stores_carts_count'
          $('.dashboard_datatable').hide()
          $('#stores_carts_count').show()
        when 'stores_payment_average'
          $('.dashboard_datatable').hide()
          $('#stores_payment_average').show()
        else
          $('.dashboard_datatable').show()
          
    window.dashboard_refresh()
  else
    clearInterval(window.dashboard_refresh)


window.dashboard_refresh = ->
    setInterval ->
        $.getScript('/admin')
      ,
      30000