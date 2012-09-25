jQuery ->
  $('#clear_tax_ids_search').click (event) ->
    event.preventDefault()
    target = $(event.currentTarget)
    target.closest('form')[0].reset()
    target.closest('form').find("input[type='text']").val('')
