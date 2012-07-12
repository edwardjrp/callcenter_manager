# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  $('#categories_list select').select2()
  $('#categories_list select').change (event)->
    target = $(this)
    $.ajax
      type: 'POST'
      url: "/admin/categories/#{$(this).data('category-id')}/set_base"
      data: {product_id: target.val()}
      datatype: 'JSON'
      beforeSend: (xhr) ->
        xhr.setRequestHeader("Accept", "application/json")
      success: (product)->
        window.show_alert("#{product.productname} es ahora el producto base de #{product.category.name}", 'success')
      error: (errors)->
        window.show_alert(errors.responseText, 'error')
        
  $('.change_state_option').click (event)->
    event.preventDefault()
    target = $(this)
    $.ajax
      type: 'POST'
      url: "/admin/categories/#{$(this).closest('tr').data('category-id')}/change_options"
      datatype: 'JSON'
      beforeSend: (xhr) ->
        xhr.setRequestHeader("Accept", "application/json")
      success: (category)->
        if category.has_options == true
          window.show_alert("#{category.name} ahora presenta opciones", 'success')
          window.replaceClass(target, 'btn-inverse', 'btn-primary')
        else
          window.show_alert("#{category.name} ahora no presentará opciones", 'success')
          window.replaceClass(target, 'btn-primary', 'btn-inverse')
        target.text(category.has_options)
      error: (errors)->
        window.show_alert(errors.responseText, 'error')
        
  $('.change_state_unit').click (event)->
    event.preventDefault()
    target = $(this)
    $.ajax
      type: 'POST'
      url: "/admin/categories/#{$(this).closest('tr').data('category-id')}/change_units"
      datatype: 'JSON'
      beforeSend: (xhr) ->
        xhr.setRequestHeader("Accept", "application/json")
      success: (category)->
        if category.type_unit == true
          window.show_alert("#{category.name} ahora presenta opciones como unidades", 'success')
          window.replaceClass(target, 'btn-inverse', 'btn-primary')
        else
          window.show_alert("#{category.name} ahora no presentará opciones como unidades", 'success')
          window.replaceClass(target, 'btn-primary', 'btn-inverse')
        target.text(category.type_unit)
      error: (errors)->
        window.show_alert(errors.responseText, 'error')
  
  $('.change_state_multi').click (event)->
    event.preventDefault()
    target = $(this)
    $.ajax
      type: 'POST'
      url: "/admin/categories/#{$(this).closest('tr').data('category-id')}/change_multi"
      datatype: 'JSON'
      beforeSend: (xhr) ->
        xhr.setRequestHeader("Accept", "application/json")
      success: (category)->
        if category.multi == true
          window.show_alert("#{category.name} permite la seleción de mitad y mitad", 'success')
          window.replaceClass(target, 'btn-inverse', 'btn-primary')
        else
          window.show_alert("#{category.name} no permite la seleción de mitad y mitad", 'success')
          window.replaceClass(target, 'btn-primary', 'btn-inverse')
        target.text(category.multi)
      error: (errors)->
        window.show_alert(errors.responseText, 'error')
        
  $('.change_state_hidden').click (event)->
    event.preventDefault()
    target = $(this)
    $.ajax
      type: 'POST'
      url: "/admin/categories/#{$(this).closest('tr').data('category-id')}/change_hidden"
      datatype: 'JSON'
      beforeSend: (xhr) ->
        xhr.setRequestHeader("Accept", "application/json")
      success: (category)->
        if category.hidden == true
          window.show_alert("#{category.name} NO sera mostrada a los agentes", 'success')
          window.replaceClass(target, 'btn-inverse', 'btn-primary')
        else
          window.show_alert("#{category.name} sera mostrada a los agentes", 'success')
          window.replaceClass(target, 'btn-primary', 'btn-inverse')
        target.text(category.hidden)
      error: (errors)->
        window.show_alert(errors.responseText, 'error')
