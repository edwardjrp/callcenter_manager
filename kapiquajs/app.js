
/**
 * Module dependencies.
 */

var express = require('express')
  , _ = require('underscore')
  , pg = require('pg')
  , Builder= require('./db/query_builder')
  , qbuilder = new Builder()
  , request = require('request');

var app = module.exports = express.createServer();

// Configuration

app.configure(function(){
  app.set('pg_connection', 'postgres://radhamesbrito:siriguillo@localhost/kapiqua_development')
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
pg.connect(app.set('pg_connection'),function(err, client){
  app.post('/cart_products', function(req, res){
    res.header('Access-Control-Allow-Origin', 'http://localhost:3000');
    res.contentType('application/json');
    cart_product = req.body['cart_product']
    fields = _.keys(cart_product)
    values = _.values(cart_product)
    client.query('SELECT * FROM carts LIMIT 1', function(err, result){
      res.send(_.first(result["rows"]));
      console.log(qbuilder.create('cart_products', cart_product));
      console.log("fields"+ fields);
      console.log("values"+ values)
    });
  });
  
});

app.listen(3030, function(){
  console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env);
});
