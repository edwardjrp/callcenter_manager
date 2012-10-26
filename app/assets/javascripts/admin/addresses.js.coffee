# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  if $('#addresses_list').size() > 0
    $('.city_link').on 'click', (event) ->
      event.preventDefault()
      target = $(event.currentTarget)
      target.next('img').removeClass('hidden')
      data_location = target.closest('table')
      $.ajax
        type: 'GET'
        datatype: 'JSON'
        url: '/addresses/areas'
        data: { city_id: data_location.data('city-id') }
        beforeSend: (xhr) ->
          xhr.setRequestHeader("Accept", "application/json")
        success: (areas) ->
          $('#areas').empty()
          $('#streets').empty()
          $('#areas').append(JST['admin/addresses/new_area_form'](city_name: data_location.data('city-name'), city_id: data_location.data('city-id')))
          $('#areas').append("<div id='areas_list'</div>")
          for area in areas
            $('#areas_list').append(JST['admin/addresses/areas'](area: area))
        complete: ->
          target.next('img').addClass('hidden')

    $('#areas').on 'click', '.area_link', (event) ->
      event.preventDefault()
      target = $(event.currentTarget)
      target.next('img').removeClass('hidden')
      data_location = target.closest('table')
      $.ajax
        type: 'GET'
        datatype: 'JSON'
        url: '/addresses/streets'
        data: { area_id: data_location.data('area-id') }
        beforeSend: (xhr) ->
          xhr.setRequestHeader("Accept", "application/json")
        success: (streets) ->
          $('#streets').empty()
          $('#streets').append(JST['admin/addresses/new_street_form'](area_name: data_location.data('area-name'), area_id: data_location.data('area-id')))
          $('#streets').append("<div id='streets_list'</div>")
          for street in streets
            $('#streets_list').append(JST['admin/addresses/streets'](street: street))
        complete: ->
          target.next('img').addClass('hidden')


    $('#add_city').on 'click', (event) ->
      event.preventDefault()
      target = $(event.currentTarget)
      form = target.closest('form')
      $.ajax
        type: 'POST'
        datatype: 'JSON'
        url: form.attr('action')
        data: form.serialize()
        beforeSend: (xhr) ->
          xhr.setRequestHeader("Accept","application/json")
        success: (city) ->
          $('#cities_list').prepend(JST['admin/addresses/city'](city: city))
        complete: ->
          form.find('.add_city').text('')
          form[0].reset()

    $('#cities_list').on 'click', '.edit', (event) ->
      event.preventDefault()
      target = $(event.currentTarget)
      data_location = target.closest('table')
      $('#properties_controller').empty()
      $('#properties_controller').html(JST['admin/addresses/edit_city_form'](city: {name: data_location.data('city-name'), id: data_location.data('city-id')}))

    $('#properties_controller').on 'click', '#edit_city_button', (event) ->
      event.preventDefault()      
      target = $(event.currentTarget)
      form = target.closest('form')
      $.ajax
        type: 'PUT'
        datatype: 'JSON'
        url: form.attr('action')
        data: form.serialize()
        beforeSend: (xhr) ->
          xhr.setRequestHeader("Accept","application/json")
        success: (city) ->
          $("#city_#{city.id}").html($(JST['admin/addresses/city'](city: city)).html())
        complete: ->
          $('#properties_controller').empty()

    $('#cities_list').on 'click', '.trash', (event) ->
      event.preventDefault()
      target = $(event.currentTarget)
      data_location = target.closest('table')
      $('#properties_controller').empty()
      if confirm('¿Desea eliminar esta ciudad y todos los elementos asignados a ella ?')
        $.ajax
          type: 'DELETE'
          datatype: 'JSON'
          url: "/admin/cities/#{data_location.data('city-id')}"
          beforeSend: (xhr) ->
            xhr.setRequestHeader("Accept","application/json")
          success: (response) ->
            $("#city_#{response.id}").remove()

    $('#areas').on 'click', '#create_area', (event) ->
      event.preventDefault()
      target = $(event.currentTarget)
      form = target.closest('form')
      $.ajax
        type: 'POST'
        datatype: 'JSON'
        url: form.attr('action')
        data: form.serialize()
        beforeSend: (xhr) ->
          xhr.setRequestHeader("Accept","application/json")
        success: (area) ->
          $('#areas_list').prepend(JST['admin/addresses/areas'](area: area))
        complete: ->
          form[0].reset()

    $('#areas').on 'click', '.edit', (event) ->
      event.preventDefault()
      target = $(event.currentTarget)
      data_location = target.closest('table')
      $('#properties_controller').empty()
      $('#properties_controller').html(JST['admin/addresses/edit_area_form'](area: {name: data_location.data('area-name'), id: data_location.data('area-id')}))

    $('#properties_controller').on 'click', '#edit_area_button', (event) ->
      event.preventDefault()
      target = $(event.currentTarget)
      form = target.closest('form')
      $.ajax
        type: 'PUT'
        datatype: 'JSON'
        url: form.attr('action')
        data: form.serialize()
        beforeSend: (xhr) ->
          xhr.setRequestHeader("Accept","application/json")
        success: (area) ->
          $("#area_#{area.id}").html($(JST['admin/addresses/areas'](area: area)).html())
        complete: ->
          $('#properties_controller').empty()


    $('#areas').on 'click', '.trash', (event) ->
      event.preventDefault()
      target = $(event.currentTarget)
      data_location = target.closest('table')
      $('#properties_controller').empty()
      if confirm('¿Desea eliminar esta zona y todos los elementos asignados a ella ?')
        $.ajax
          type: 'DELETE'
          datatype: 'JSON'
          url: "/admin/areas/#{data_location.data('area-id')}"
          beforeSend: (xhr) ->
            xhr.setRequestHeader("Accept","application/json")
          success: (response) ->
            $("#area_#{response.id}").remove()



    $('#streets').on 'click', '.edit', (event) ->
      event.preventDefault()
      target = $(event.currentTarget)
      data_location = target.closest('table')
      $('#properties_controller').empty()
      $('#properties_controller').html(JST['admin/addresses/edit_street_form'](street: {name: data_location.data('street-name'), id: data_location.data('street-id')}))












