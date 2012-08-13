# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  if $('#addresses_list').size() > 0
    $('#addresses_list').on 'click', '.drag_street', (event)->
      event.preventDefault()
    $( ".drag_street" ).draggable
      axis: 'y'
      helper: 'clone'
      handle: $(this)
    $( ".drag_street" ).droppable
      accept: ".drag_street"
      drop: (event, ui)->
        if(confirm("Desea agregar todas las direcciones relacionadas con la calle #{ui.draggable.find('a').text()} a la calle #{$(this).find('a').text()}"))
          console.log 'marge street addresses'
