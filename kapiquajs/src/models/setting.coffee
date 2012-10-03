Setting = require('./schema').Setting


Setting.node_url = (cb)->
  @all {var: 'node_url'}, (err, result) ->
    if err
      console.error(err)
      cb(err)
    else
      cb(result)


Setting.priceStoreId = (cb)->
  @all {var: 'price_store_id'}, (err, result) ->
    if err
      console.error(err)
      cb(err)
    else
      cb(result)



Setting.priceStoreIp = (cb)->
  @all {var: 'price_store_ip'}, (err, result) ->
    if err
      console.error(err)
      cb(err)
    else
      cb(result)



Setting.pulsePort = (cb)->
  @all {var: 'pulse_port'}, (err, result) ->
    if err
      console.error(err)
      cb(err)
    else
      cb(result)


# olo2 url
# Setting.node_url = (cb)->
#   @all {var: 'node_url'}, (err, result) ->
#     if err
#       console.error(err)
#       cb(err)
#     else
#       cb(result)



module.exports = Address