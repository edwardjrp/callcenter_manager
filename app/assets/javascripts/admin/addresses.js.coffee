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
        