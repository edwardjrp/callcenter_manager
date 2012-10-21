jQuery ->
  $('#client_side_coupons_list').dataTable
    "bLengthChange": false
    "sEmptyTable": "No hay cupones disponible"
    "oLanguage":
      "sSearch": "Filtrar:"
      "sInfoFiltered": " - filtrando de un total de _MAX_ cupones"
      "sInfo": "Mostrando _START_ to _END_ de  _TOTAL_ cupones"
      "oPaginate":
        "sPrevious": "Anterior"
        "sNext": "Siguiente"