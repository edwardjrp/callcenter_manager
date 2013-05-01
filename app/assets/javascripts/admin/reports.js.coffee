# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery -> 
  if $('#new_report').size()
    $('#new_report #report_name').change (event) ->
      if _.contains(['Detallado', 'Consolidado', 'ProductsMix'], $(this).val())
        agent_input = $('<div class="control-group text"><label class="text control-label" for="agent">Agente</label><div class="controls"><input type="text" name="options[agent]" id = "agent_field" placeholder = "nombre apellido o cedula"></div></div>')
        $(this).closest('.control-group').after(agent_input) unless $("#agent_field").size() > 0
      else
        $("#agent_field").closest('.control-group').remove()
      if _.contains(['Consolidado', 'ProductsMix'], $(this).val())
        store_input = $('<div class="control-group text"><label class="text control-label" for="store">Tienda</label><div class="controls"><input type="text" name="options[store]" id = "store_field" placeholder = "Store Id"></div></div>')
        $(this).closest('.control-group').after(store_input) unless $("#store_field").size() > 0
      else
        $("#store_field").closest('.control-group').remove()
      if  $(this).val() is 'ProductsMix'
        item_input = $('<div class="control-group text"><label class="text control-label" for="item">Item</label><div class="controls"><input type="text" name="options[item]" id = "item_field" placeholder = "Nombre"></div></div>')
        $(this).closest('.control-group').after(item_input) unless $("#item_field").size() > 0
      else
        $("#item_field").closest('.control-group').remove()
        
  if $('#reports_list').size()
    interval = setInterval(refresh_reports, 30000)
  else
    clearInterval(interval) if interval


refresh_reports = ->
  $.getScript(window.location.href)