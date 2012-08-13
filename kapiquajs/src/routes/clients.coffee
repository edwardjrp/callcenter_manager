async = require('async')
request = require('request')
_ = require('underscore')

class Client

  @olo_index: (data, respond, socket) ->
    page = data.page
    request.get {headers: {}, uri: "http://localhost:4000/api/users.json?page=#{page}" }, (err, res, res_data) ->
      if err
        respond({type: 'error', data: "Hubo un error opteniendo la respuesta desde olo: #{err}"})
      else
        if res_data? and res_data != 'null'
          respond({type: 'success', data: JSON.parse(res_data)})
        else
          respond({type: 'success', data: []})

  @olo_show: (data, respond, socket) ->
    request.get {headers: {}, uri: "http://localhost:4000/api/users/#{data.id}.json" }, (err, res, res_data) ->
      if err
        respond({type: 'error', data: "Hubo un error opteniendo la respuesta desde olo: #{err}"})
      else
        if res_data? and res_data != 'null'
          respond({type: 'success', data: JSON.parse(res_data)})
        else
          respond({type: 'success', data: []})

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