# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  if $('#addresses_list').size() > 0
    $('#addresses_list').on 'shown', "li .city_tab", (event) ->
      target = $(event.target)
      $.ajax
        type: 'GET'
        url: '/admin/areas'
        datatype: 'JSON'
        data: {city_id: target.data('city-id')}
        beforeSend: (xhr) ->
          xhr.setRequestHeader("Accept", "application/json")
        success: (areas) ->
          $("#city_#{target.data('city-id')}").html(JST['admin/addresses/areas'](areas: areas))
        error: ()->
          window.show_alert('Un error impidio cargar el listado de zonas para esta ciudad','error')
    
    $('#addresses_list').on 'shown', "li .area_tab", (event) ->
      target = $(event.target)
      $.ajax
        type: 'GET'
        url: '/admin/streets'
        datatype: 'JSON'
        data: { area_id: target.data('area-id')}
        beforeSend: (xhr) ->
          xhr.setRequestHeader("Accept", "application/json")
        success: (streets) ->
          $("#area_#{target.data('area-id')}").html(JST['admin/addresses/streets'](streets: streets))
        error: ()->
          window.show_alert('Un error impidio cargar el listado de calles para esta zona','error')
        
    $('#addresses_list').on 'click', "#add_city", (event) ->
      target =  $(event.currentTarget)
      $('#admin_addresses_city_actions').modal('show')
      $('#admin_addresses_city_actions').find('.modal-footer').remove()
      $('#admin_addresses_city_actions').find('.modal-body').html(JST['admin/addresses/new_city_form'])

    $('#addresses_list').on 'click', "#create_city", (event) ->
      event.preventDefault()
      form = $(event.currentTarget).closest('form')
      $.ajax
        type: 'POST'
        url: form.attr('action')
        datatype: 'JSON'
        data: form.serialize()
        beforeSend: (xhr) ->
          xhr.setRequestHeader("Accept", "application/json")
        success: (city) ->
          $('#admin_addresses_city_actions').modal('hide')
          $('#cities_tabs').append("<li><a class='city_tab' data-city-id='#{city.id}' data-toggle='tab' href='#city_#{city.id}'>#{city.name}</a></li>")
          $('#cities_contents').append("<div class='tab-pane city_pane' id='city_#{city.id}'>Cargando ...</div>")
          $(".city_tab[data-city-id='#{city.id}']").effect("highlight", {}, 500)
        error: (response)->
          $("<div class='purr'>#{response.data}<div>").purr()