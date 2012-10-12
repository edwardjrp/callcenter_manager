async = require('async')
request = require('request')
crypto = require('crypto')
_ = require('underscore')

class Client

  @olo_index: (data, respond, socket) ->
    page = data.page
    request.get {headers: {}, uri: "http://localhost:4000/api/users.json?access_token=#{@access_token()}&page=#{page}" }, (err, res, res_data) ->
      if err
        respond({type: 'error', data: "Hubo un error opteniendo la respuesta desde olo: #{err}"})
      else
        if res_data? and res_data != 'null'
          respond({type: 'success', data: JSON.parse(res_data)})
        else
          respond({type: 'success', data: []})

  @olo_show: (data, respond, socket) ->
    request.get {headers: {}, uri: "http://localhost:4000/api/users/#{data.id}.json?access_token=#{@access_token()}" }, (err, res, res_data) ->
      if err
        respond({type: 'error', data: "Hubo un error opteniendo la respuesta desde olo: #{err}"})
      else
        if res_data? and res_data != 'null'
          respond({type: 'success', data: JSON.parse(res_data)})
        else
          respond({type: 'success', data: []})

  @olo_with_phone: (data, respond, socket) ->
    request.get {headers: {}, uri: "http://localhost:4000/api/users/with_phone.json?access_token=#{@access_token()}&phone=#{data.phone}&ext=#{data.ext}" }, (err, res, res_data) ->
      if err
        respond({type: 'error', data: "Hubo un error opteniendo la respuesta desde olo: #{err}"})
      else
        if res_data? and res_data != 'null'
          respond({type: 'success', data: JSON.parse(res_data)})
        else
          respond({type: 'success', data: []})

  @access_token: ->
    date = new Date() if date == null || _.isUndefined(date)
    crypto.createHash('md5').update("kapiqua-access-#{date.getDay()}-#{date.getHours()}").digest("hex")

module.exports = Client