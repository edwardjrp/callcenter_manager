module ApplicationHelper
  
  def set_state_class(state_value)
    state_value ? 'btn-primary' : 'btn-inverse'
  end
  
  def number_to_cedula(idnumber)
    idnumber= idnumber.to_s.strip unless idnumber.nil?
    begin
      if idnumber.length == 11
        return idnumber.gsub(/([0-9]{3})([0-9]{7})([0-9]{1})/,"\\1-\\2-\\3")
     elsif idnumber.length == 9
        return idnumber.gsub(/([0-9]{1})([0-9]{2})([0-9]{5})([0-9]{1})/,"\\1-\\2-\\3-\\4")
     else
       return idnumber
     end
    rescue
      return idnumber
    end
  end

  def availability(value)
    value == true ? '<span class="label label-info">Disponible</span>'.html_safe : '<span class="label label-warning">Agotado</span>'.html_safe
  end

  def availability_class(value)
    value == true ? '' : 'unavailable'
  end

  def coupon_effective(coupon)
    coupon.effective_today? ? 'Disponible' : 'No disponible hoy'
  end

  def critical_class(cart)
    cart.message_mask == 9 ? 'error' : ''
  end

  def current_roles(user)
    if user.roles.include? :operator
      'operator'
    else
      'admin'
    end
  end
end
