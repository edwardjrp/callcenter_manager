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
    target.next('img').removeClass('hidden')
    socket.emit "stores:schedule", {store_id: target.data('store-id')}, (err, response) ->
      if err
        if err.code == "ETIMEDOUT"
          $("<div class='purr'>El tiempo de respuesta se agotó, y no obtuvo respuesta de la tienda.<div>").purr({removeTimer: 15000})
        else
          $("<div class='purr'>Un error no permitio contactar esta tienda.<div>").purr({removeTimer: 15000})
      else
        window.show_alert("Comunicación con #{response.name} establecida", 'success')
      target.next('img').addClass('hidden')


  $('.hide_schedule').on 'click', (event)->
    event.preventDefault()
    target = $(event.currentTarget)
    schedule = target.next()
    wdays = ['Lunes','Martes','Miercoles','Jueves','Viernes','Sabado','Domingo']
    i = 0
    $(schedule).find('thead').find('th:first').before('<th>Dia</th>') if $(schedule).find('thead').find('tr').size() < 3
    _.each $(schedule).find('tbody').find('tr'), (row) ->
      if wdays[i]
        $(row).find('td:first').before("<td>#{wdays[i]}</td>") if $(row).find('td').size() < 3
      else
        $(row).remove()
      i += 1
    modal = schedule.next()
    modal.modal('show')
    modal.find('.modal-body').html(schedule.html())
