# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  $('#clear_product_search').on 'click', (event)->
    event.preventDefault()
    $('#clear_product_search').closest('form')[0].reset()
