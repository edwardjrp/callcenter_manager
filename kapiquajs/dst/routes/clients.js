var Client, async, request, _;

async = require('async');

request = require('request');

_ = require('underscore');

Client = (function() {

  function Client() {}

  Client.olo_index = function(data, respond, socket) {
    var page;
    page = data.page;
    return request.get({
      headers: {},
      uri: "http://localhost:4000/api/users.json?page=" + page
    }, function(err, res, res_data) {
      if (err) {
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
  };

  Client.olo_show = function(data, respond, socket) {
    return request.get({
      headers: {},
      uri: "http://localhost:4000/api/users/" + data.id + ".json"
    }, function(err, res, res_data) {
      if (err) {
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
  };

  Client.olo_with_phone = function(data, respond, socket) {
    return request.get({
      headers: {},
      uri: "http://localhost:4000/api/users/with_phone.json?phone=" + data.phone + "&ext=" + data.ext
    }, function(err, res, res_data) {
      if (err) {
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
  };

  return Client;

})();

module.exports = Client;
