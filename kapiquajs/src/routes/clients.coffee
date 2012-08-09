async = require('async')
request = require('request')
_ = require('underscore')

class Client

  @olo_index: (data, respond, socket) ->
    console.log 'querying olo2 clients list'

  @olo_show: (data, respond, socket) ->
    console.log 'querying olo2 clients show'

  @olo_with_phone: (data, respond, socket) ->
    console.log 'processing'
    request.get {headers: {}, uri: 'http://localhost:4000/api/users.json' }, (err, res, res_data) ->
      if err
        console.log err
      else
        respond(res_data)

    respond({clients: 'Queried for the clients'})
    console.log 'querying olo2 clients list'


module.exports = Client