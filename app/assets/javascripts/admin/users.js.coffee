jQuery ->
  if $('#current_role').size() > 0
    role = $('#current_role').data('role')
    $("#user_roles_#{role}").attr('checked', 'checked')