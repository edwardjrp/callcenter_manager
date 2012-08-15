jQuery ->
  if $('#client_merge').size() > 0
    $('#client_merge').smartWizard
      labelNext: 'Siguiente'
      labelPrevious: 'Anterior'
      labelFinish: 'Terminar'

  $('#client_search').find('.client_merge_search').on 'click', (event)->
    event.preventDefault()
    console.log 'clicked'
    $.ajax
      type: 'GET'
      url: $('#client_search').attr('action')
      data: $('#client_search').serialize()
      datatype: 'JSON'
      beforeSend: (xhr)->
        xhr.setRequestHeader("Accept", "application/json")
      success: (response)->
        console.log response
      error: (err)->
        console.log err

