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
  $('.container>.row>.span12').prepend($("<div class=\"alert alert-#{type}\"><button class=\"close\" data-dismiss=\"alert\">×</button>#{msg}</div>"))
    
# end alert

# del 
@del = (el)->
  throw "Missing arguments" if !el?
  el.remove() if el.length > 0
  
  
@strip = (string) ->
  if _.isString(string)
    string.replace(/^\s(.+)\s$/,'$1')
  else 
    throw 'NO A STRING'
    
@to_sentence = (string_array)->
  (_.flatten([(_.without(string_array, _.last(string_array))).join(', '), _.last(string_array)])).join(' y ')

# end del
