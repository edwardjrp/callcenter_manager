var Client, Setting, async, crypto, request, _;

async = require('async');

request = require('request');

crypto = require('crypto');

Setting = require('../models/setting');

_ = require('underscore');

Client = (function() {

  function Client() {}

  Client.olo_index = function(data, respond, socket) {
    var page;
    page = data.page;
    return Setting.kapiqua(function(sett_err, settings) {
      if (sett_err) {
        socket.emit('cart:place:error', 'Falla Lectura de la configuración');
        return console.error(sett_err.stack);
      } else {
        return request.get({
          headers: {},
          uri: "http://" + settings.olo_url + "/api/users.json?access_token=" + (Client.access_token()) + "&page=" + page
        }, function(err, res, res_data) {
          if (err) {
            console.error(err.stack);
            return respond({
              type: 'error',
              data: "Hubo un error opteniendo la respuesta desde olo: " + err
            });
          } else {
            if ((res_data != null) && res_data !== 'null') {
              return respond({
                type: 'success',
                data: JSON.parse(res_data)
              });
            } else {
              return respond({
                type: 'success',
                data: []
              });
            }
          }
        });
      }
    });
  };

  Client.olo_show = function(data, respond, socket) {
    return Setting.kapiqua(function(sett_err, settings) {
      if (sett_err) {
        socket.emit('cart:place:error', 'Falla Lectura de la configuración');
        return console.error(sett_err.stack);
      } else {
        return request.get({
          headers: {},
          uri: "http://" + settings.olo_url + "/api/users/" + data.id + ".json?access_token=" + (Client.access_token())
        }, function(err, res, res_data) {
          if (err) {
            console.error(err.stack);
            return respond({
              type: 'error',
              data: "Hubo un error opteniendo la respuesta desde olo: " + err
            });
          } else {
            if ((res_data != null) && res_data !== 'null') {
              return respond({
                type: 'success',
                data: JSON.parse(res_data)
              });
            } else {
              return respond({
                type: 'success',
                data: []
              });
            }
          }
        });
      }
    });
  };

  Client.olo_with_phone = function(data, respond, socket) {
    return Setting.kapiqua(function(sett_err, settings) {
      if (sett_err) {
        socket.emit('cart:place:error', 'Falla Lectura de la configuración');
        return console.error(sett_err.stack);
      } else {
        return request.get({
          headers: {},
          uri: "http://" + settings.olo_url + "/api/users/with_phone.json?access_token=" + (Client.access_token()) + "&phone=" + data.phone + "&ext=" + data.ext
        }, function(err, res, res_data) {
          if (err) {
            console.error(err.stack);
            return respond({
              type: 'error',
              data: "Hubo un error opteniendo la respuesta desde olo: " + err
            });
          } else {
            if ((res_data != null) && res_data !== 'null') {
              return respond({
                type: 'success',
                data: JSON.parse(res_data)
              });
            } else {
              return respond({
                type: 'success',
                data: []
              });
            }
          }
        });
      }
    });
  };

  Client.access_token = function() {
    var date;
    if (date === null || _.isUndefined(date)) {
      date = new Date();
    }
    return crypto.createHash('md5').update("kapiqua-access-" + (date.getDay()) + "-" + (date.getHours())).digest("hex");
  };

  return Client;

})();

module.exports = Client;
