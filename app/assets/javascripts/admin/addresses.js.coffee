# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  if $('#addresses_list').size() > 0

    $("#streets").on 'mouseover','#streets_list' , ->
      console.log 'attaching'
      $('.drag').closest("tr").draggable
        helper: 'clone'
        handle: $(this)

      $("#streets table").droppable
        drop: (event, ui) ->
          destination_street = {id: $(this).data('street-id'), name: $(this).data('street-name') }
          origin_street =  {id: ui.draggable.data('street-id'), name: ui.draggable.data('street-name') }
          unless destination_street.id is origin_street.id
            if confirm("¿Desea mover todas las asignaciones de la calle #{origin_street.name} a la calle #{destination_street.name}?")
              $.ajax
                type: 'POST'
                datatype: 'JSON'
                url: "/admin/streets/#{destination_street.id}/merge"
                data: { origin_id: origin_street.id }
                beforeSend: (xhr) ->
                  xhr.setRequestHeader("Accept", "application/json")
                success: (response) ->
                  $("#street_#{response.id}").remove()
                error: (response) ->
                  $("<div class='purr'>#{response.responseText}<div>").purr()
                complete: ->
                  $('#properties_controller').empty()


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
        error: (response) ->
          $("<div class='purr'>#{response.responseText}<div>").purr()
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
        error: (response) ->
          $("<div class='purr'>#{response.responseText}<div>").purr()
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
        error: (response) ->
          $("<div class='purr'>#{response.responseText}<div>").purr()
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
        error: (response) ->
          $("<div class='purr'>#{response.responseText}<div>").purr()
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
          error: (response) ->
            $("<div class='purr'>#{response.responseText}<div>").purr()

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
        error: (response) ->
          $("<div class='purr'>#{response.responseText}<div>").purr()
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
        error: (response) ->
          $("<div class='purr'>#{response.responseText}<div>").purr()
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
          error: (response) ->
            $("<div class='purr'>#{response.responseText}<div>").purr()

    $('#streets').on 'click', '#create_street', (event) ->
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
        success: (street) ->
          $('#streets_list').prepend(JST['admin/addresses/streets'](street: street))
        error: (response) ->
          $("<div class='purr'>#{response.responseText}<div>").purr()
        complete: ->
          form[0].reset()

    $('#streets').on 'click', '.edit', (event) ->
      event.preventDefault()
      target = $(event.currentTarget)
      data_location = target.closest('table')
      $('#properties_controller').empty()
      $('#properties_controller').html(JST['admin/addresses/edit_street_form'](street: {name: data_location.data('street-name'), id: data_location.data('street-id')}, stores: $('#streets').data('stores')))
      $("#street_store_select option[value=#{data_location.data('store-id')}]").attr("selected",true);

    $('#properties_controller').on 'click', '#edit_street_button', (event) ->
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
        success: (street) ->
          $("#street_#{street.id}").html($(JST['admin/addresses/streets'](street: street)).html())
        error: (response) ->
          $("<div class='purr'>#{response.responseText}<div>").purr()
        complete: ->
          $('#properties_controller').empty()

    $('#streets').on 'click', '.trash', (event) ->
      event.preventDefault()
      target = $(event.currentTarget)
      data_location = target.closest('table')
      $('#properties_controller').empty()
      if confirm('¿Desea eliminar esta Calle y todos los elementos asignados a ella ?')
        $.ajax
          type: 'DELETE'
          datatype: 'JSON'
          url: "/admin/streets/#{data_location.data('street-id')}"
          beforeSend: (xhr) ->
            xhr.setRequestHeader("Accept","application/json")
          success: (response) ->
            $("#street_#{response.id}").remove()
          error: (response) ->
            $("<div class='purr'>#{response.responseText}<div>").purr()