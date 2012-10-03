Setting = require('./schema').Setting
YAML = require('libyaml')

Setting.node_url = (cb)->
  @all {var: 'node_url'}, (err, result) ->
    if err
      console.error(err)
      cb(err)
    else
      cb(err, YAML.parse(result.value)[0])


Setting.priceStoreId = (cb)->
  @all {var: 'price_store_id'}, (err, result) ->
    if err
      console.error(err)
      cb(err)
    else
      cb(err, YAML.parse(result.value)[0])



Setting.priceStoreIp = (cb)->
  @all {var: 'price_store_ip'}, (err, result) ->
    if err
      console.error(err)
      cb(err)
    else
      cb(err, YAML.parse(result.value)[0])

Setting.pulsePort = (cb)->
  @all {var: 'pulse_port'}, (err, result) ->
    if err
      console.error(err)
      cb(err)
    else
      cb(err, YAML.parse(result.value)[0])


Setting.kapiqua = (cb)->
  Setting.all {}, (err, results) ->
    if err
      console.error(err)
      cb(err)
    else
      kapiquaConfig = {}
      for result in results
        kapiquaConfig[result.var] = YAML.parse(result.value)[0]
      cb(err, kapiquaConfig)

# olo2 url
# Setting.node_url = (cb)->
#   @all {var: 'node_url'}, (err, result) ->
#     if err
#       console.error(err)
#       cb(err)
#     else
#       cb(result)



module.exports = Setting