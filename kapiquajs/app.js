
/**
 * Module dependencies.
 */

var express = require('express')
  , _ = require('underscore')
  , pg = require('pg')
  , util = require('util')
  , request = require('request');

var app = module.exports = express.createServer();
// Configuration

app.configure(function(){
  app.set('pg_connection', 'postgres://radhamesbrito:siriguillo@localhost/kapiqua_development')
  app.use(express.logger({ immediate: true, format: 'dev' }));
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(app.router);
});

app.configure('development', function(){
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true }));
});

app.configure('production', function(){
  app.use(express.errorHandler());
});

// Routes
var client = new pg.Client(app.settings.pg_connection);
client.connect();
app.post('/cart_products', function(req, res){
  res.header('Access-Control-Allow-Origin', 'http://localhost:3000');
  res.header('Access-Control-Allow-Methods', '*')
  res.contentType('application/json');
  // console.log(util.inspect(res, true, 1));
  console.log(util.inspect(req.headers, true, 1));
  console.log(util.inspect(res._headers, true, 1));
  // console.log(util.inspect(res, true, null));
  // INSERT INTO cart_products( "cart_id","quantity","product_id","options", "created_at", "updated_at" ) values ($1, $2, $3, $4, $5, $6)  RETURNING "id"',[cart_product['cart_id'],cart_product['quantity'],cart_product['product_id'],cart_product['options'], new Date(), new Date()]
  var query = client.query('SELECT * from users LIMIT 1');
  query.on('row', function(row) {
     res.send(row);
  });
  query.on('error', function(query_error) {
     res.send(JSON.stringify(query_error.message));
  });
})

process.on('uncaughtException', function (err) {
    console.log(err);
});
app.listen(3030, function(){
  console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env);
});
