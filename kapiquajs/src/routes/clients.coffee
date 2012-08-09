async = require('async')
request = require('request')
_ = require('underscore')

class Client

  @olo_index: (data, respond, socket) ->
    console.log 'querying olo2 clients list'

  @olo_show: (data, respond, socket) ->
    console.log 'querying olo2 clients show'

  @olo_with_phone: (data, respond, socket) ->
    request.get {headers: {}, uri: "http://localhost:4000/api/users/with_phone.json?phone=#{data.phone}&ext=#{data.ext}" }, (err, res, res_data) ->
      if err
        respond({type: 'error', data: "Hubo un error opteniendo la respuesta desde olo: #{err}"})
      else
        if res_data? and res_data != 'null'
          respond({type: 'success', data: JSON.parse(res_data)})
        else
          respond({type: 'success', data: []})


module.exports = Client