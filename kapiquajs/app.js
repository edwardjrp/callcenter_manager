
/**
 * Module dependencies.
 */

var express = require('express')
  , _ = require('underscore')
  , pg = require('pg')
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
  app.get('/carts/:cart_id/cart_products', function(req, res){
    console.log(req.param("cart_id"))
    res.header('Access-Control-Allow-Origin', '*');
    res.contentType('application/json');
    client.query('SELECT * FROM users LIMIT 1', function(err, result){
      res.send(_.first(result["rows"]));
    });
    console.log('this happends after');
  });
  
});

app.listen(3030, function(){
  console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env);
});
