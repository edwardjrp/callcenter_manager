module ApplicationHelper
  
  def set_state_class(state_value)
    state_value ? 'btn-primary' : 'btn-inverse'
  end
end
