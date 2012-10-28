# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  socket = window.socket

  $('#clear_product_search').on 'click', (event)->
    event.preventDefault()
    $(this).closest('form')[0].reset()
    $(this).closest('form').find("input[type='text']").val('')

  $('.test_store_connection').on 'click', (event) ->
    event.preventDefault()
    target = $(event.currentTarget)
    socket.emit "stores:schedule", {store_id: target.data('store-id')}, (err, response) ->
      if err
        if err.code == "ETIMEDOUT"
          $("<div class='purr'>El tiempo de respuesta se agotó, y no obtuvo respuesta de la tienda.<div>").purr({removeTimer: 15000})
        else
          $("<div class='purr'>Un error no permitio contactar esta tienda.<div>").purr({removeTimer: 15000})
      else
        console.log response


  $('.hide_schedule').on 'click', (event)->
    event.preventDefault()
    target = $(event.currentTarget)
    schedule = target.next()
    wdays = ['Lunes','Martes','Miercoles','Jueves','Viernes','Sabado','Domingo']
    i = 0
    _.each $(schedule).find('tr'), (row) ->
      if wdays[i]
        $(row).find('td:first').before("<td>#{wdays[i]}</td>")
      else
        $(row).remove()
      i += 1
    modal = schedule.next()
    modal.modal('show')
    modal.find('.modal-body').html(schedule.html())
