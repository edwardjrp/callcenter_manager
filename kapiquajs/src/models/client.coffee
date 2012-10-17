Client = require('./schema').Client
_ = require('underscore')


Client.prototype.last_phone = (cb) ->
  me = this
  me.phones { order: 'id' }, (err, phones)->
    if err
      console.error err.stack
      cb(err)
    else
      target = _.find( phones, (phone)-> phone.id == me.target_phone_id )
      target_phone = target || _.first(phones)
      cb(err, target_phone)


Client.prototype.last_address = (cb) ->
  me = this
  me.addresses { order: 'id' }, (err, addresses)->
    if err
      console.error err.stack
      cb(err)
    else
      target = _.find( addresses, (address)-> address.id == me.target_address_id )
      target_address = target || _.first(address)
      cb(err, target_address)

Client.prototype.simplified = ->
  JSON.parse(JSON.stringify(this))

module.exports = Client