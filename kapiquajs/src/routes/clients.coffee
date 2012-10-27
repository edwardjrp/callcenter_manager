async = require('async')
request = require('request')
crypto = require('crypto')
Setting = require('../models/setting')
_ = require('underscore')

class Client

  @olo_index: (data, respond, socket) ->
    page = data.page
    Setting.kapiqua (sett_err, settings) ->
      if sett_err
        socket.emit 'cart:place:error', 'Fallo la lectura de la configuración'
        console.error sett_err.stack
      else
        request.get {headers: {}, uri: "http://#{settings.olo_url}/api/users.json?access_token=#{Client.access_token()}&page=#{page}" }, (err, res, res_data) ->
          if err
            console.error err.stack
            respond({type: 'error', data: "Hubo un error opteniendo la respuesta desde olo: #{err}"})
          else
            if res_data? and res_data != 'null'
              respond({type: 'success', data: JSON.parse(res_data)})
            else
              respond({type: 'success', data: []})

  @olo_show: (data, respond, socket) ->
    Setting.kapiqua (sett_err, settings) ->
      if sett_err
        socket.emit 'cart:place:error', 'Fallo la lectura de la configuración'
        console.error sett_err.stack
      else
        request.get {headers: {}, uri: "http://#{settings.olo_url}/api/users/#{data.id}.json?access_token=#{Client.access_token()}" }, (err, res, res_data) ->
          if err
            console.error err.stack
            respond({type: 'error', data: "Hubo un error opteniendo la respuesta desde olo: #{err}"})
          else
            if res_data? and res_data != 'null'
              respond({type: 'success', data: JSON.parse(res_data)})
            else
              respond({type: 'success', data: []})

  @olo_with_phone: (data, respond, socket) ->
    Setting.kapiqua (sett_err, settings) ->
      if sett_err
        socket.emit 'cart:place:error', 'Fallo la lectura de la configuración'
        console.error sett_err.stack
      else
        request.get {headers: {}, uri: "http://#{settings.olo_url}/api/users/with_phone.json?access_token=#{Client.access_token()}&phone=#{data.phone}&ext=#{data.ext}" }, (err, res, res_data) ->
          if err
            console.error err.stack
            respond({type: 'error', data: "Hubo un error opteniendo la respuesta desde olo: #{err}"})
          else
            if res_data? and res_data != 'null'
              respond({type: 'success', data: JSON.parse(res_data)})
            else
              respond({type: 'success', data: []})

  @olo_with_idnumber: (data, respond, socket) ->
    pad = (number, length) ->
      str = '' + number
      while (str.length < length)
        str = '0' + str
      str
    Setting.kapiqua (sett_err, settings) ->
      if sett_err
        socket.emit 'cart:place:error', 'Fallo la lectura de la configuración'
        console.error sett_err.stack
      else
        request.get {headers: {}, uri: "http://#{settings.olo_url}/api/users/with_idnumber.json?access_token=#{Client.access_token()}&idnumber=#{pad(data.idnumber, 11)}" }, (err, res, res_data) ->
          if err
            console.error err.stack
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