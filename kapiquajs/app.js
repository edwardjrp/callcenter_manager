
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
  app.post('/cart_products', function(req, res){
    res.header('Access-Control-Allow-Origin', 'http://localhost:3000');
    res.contentType('application/json');
    cart_product = req.body['cart_product']
    client.query('INSERT INTO cart_products( "cart_id","quantity","product_id","options", "created_at", "updated_at" ) values ($1, $2, $3, $4, $5, $6)  RETURNING "id"',[cart_product['cart_id'],cart_product['quantity'],cart_product['product_id'],cart_product['options'], new Date(), new Date()], function(err, result){
      if(err){
        res.send(JSON.stringify(err.message));
        console.log(err.message)
      }else{
        res.send(_.first(result["rows"]));
      }
    });
  });
  
});

app.listen(3030, function(){
  console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env);
});
