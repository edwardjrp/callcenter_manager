jQuery ->
  if $('#current_role').size() > 0
    role = $('#current_role').data('role')
    $("#user_roles_#{role}").attr('checked', 'checked')

  switch window.getParameterByName('search')
    when 'completed'
      $('.search_cart_btn').removeClass('active')
      $('#btn_completed').addClass('active')
    when 'incomplete'
      $('.search_cart_btn').removeClass('active')
      $('#btn_incomplete').addClass('active')
    when 'abandoned'
      $('.search_cart_btn').removeClass('active')
      $('#btn_abandoned').addClass('active')
    when 'comm_failed'
      $('.search_cart_btn').removeClass('active')
      $('#btn_comm_failed').addClass('active')
    else
      $('.search_cart_btn').removeClass('active')

