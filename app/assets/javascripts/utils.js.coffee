# popover
@show_popover = (owner, title, msg) ->
  throw "Missing arguments" if !owner? or  !title? or !msg?
  client_found_popover_options = {animation:false, placement: "bottom", trigger:"manual", title: title, content: msg}
  owner.popover(client_found_popover_options)
  owner.popover('show')
  
@hide_popover = (owner)->
  throw "Missing arguments" if !owner?
  owner.popover('hide') if $('.popover').length > 0
# end popover

# alert
@show_alert = (msg, type)->
  throw "Missing arguments" if !msg? or  !type?
  $(window).scrollTop(0)
  if $('.alert').size() > 0
    $('.alert').replaceWith("<div class=\"alert alert-#{type}\"><button class=\"close\" data-dismiss=\"alert\">×</button>#{msg}</div>")
  else
    $('.container>.row:first>.span12').prepend($("<div class=\"alert alert-#{type}\"><button class=\"close\" data-dismiss=\"alert\">×</button>#{msg}</div>"))
    
# end alert

# del 
@del = (el)->
  throw "Missing arguments" if !el?
  el.remove() if el.length > 0
  
  
@strip = (string) ->
  if _.isString(string)
    string.replace(/^\s(.+)\s$/,'$1')
  else 
    throw 'NOT A STRING'
    
@to_sentence = (string_array)->
  string_array = _.compact(string_array)
  return string_array[0] if string_array.length == 1
  (_.flatten([(_.without(string_array, _.last(string_array))).join(', '), _.last(string_array)])).join(' y ')


@to_phone = (string)->
  string = string.toString() if string? and _.isNumber(string)
  return string if string.length != 10
  if _.isString(string)
    string.replace(/(\d{3})(\d{3})(\d{4})/,'$1-$2-$3')
  else 
    throw 'NOT A STRING'
       
@to_idnumber = (string)->
  string = string.toString() if string? and _.isNumber(string)
  return string if string.length != 11
  if _.isString(string)
    string.replace(/(\d{3})(\d{7})(\d{1})/,'$1-$2-$3')
  else 
    throw 'NOT A STRING'
  
# end del

@truncate = (text, max_width)->
  zero_width_space = "&#8203;"
  if (text.length < max_width) then return text else return text.match(new RegExp(".{1,#{max_width}}", 'g')).join(zero_width_space)



# classes
  
@replaceClass = (element,old_class, new_class)->
  element.removeClass(old_class) if element.hasClass(old_class)
  element.addClass(new_class)
