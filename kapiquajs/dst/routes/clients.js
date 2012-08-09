var Client, async, request, _;

async = require('async');

request = require('request');

_ = require('underscore');

Client = (function() {

  function Client() {}

  Client.olo_index = function(data, respond, socket) {
    return console.log('querying olo2 clients list');
  };

  Client.olo_show = function(data, respond, socket) {
    return console.log('querying olo2 clients show');
  };

  Client.olo_with_phone = function(data, respond, socket) {
    console.log('processing');
    request.get({
      headers: {},
      uri: 'http://localhost:4000/api/users.json'
    }, function(err, res, res_data) {
      if (err) {
        return console.log(err);
      } else {
        return console.log(res_data);
      }
    });
    respond({
      clients: 'Queried for the clients'
    });
    return console.log('querying olo2 clients list');
  };

  return Client;

})();

module.exports = Client;
