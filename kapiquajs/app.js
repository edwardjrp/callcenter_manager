
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
  cart_product = req.body
  console.log(cart_product.cart)
  console.log(cart_product.product.id)
  console.log(cart_product.bind_id)
  console.log(cart_product.options)
  console.log(cart_product.quantity)  
  console.log(cart_product.updated_at)
  // INSERT INTO cart_products( "cart_id","quantity","product_id", "bind_id","options", "created_at", "updated_at" ) values ($1, $2, $3, $4, $5, $6, $7)  RETURNING "id"',[cart_product['cart_id'],cart_product['quantity'],cart_product['product_id'],cart_product['bind_id'],cart_product['options'], new Date(), new Date()]
  var save_cart_product = client.query('INSERT INTO cart_products( "cart_id","quantity","product_id", "bind_id","options", "created_at", "updated_at" ) values ($1, $2, $3, $4, $5, $6, $7)  RETURNING "id"',
              [cart_product.cart,cart_product.quantity,cart_product.product.id,cart_product.bind_id,cart_product.options, new Date(), new Date() ]);
  save_cart_product.on('end', function(cart_product_result) {
      var get_current_cart = client.query('SELECT * FROM carts WHERE "id" = $1 LIMIT 1', [cart_product.cart]);
      get_current_cart.on('row',function(current_cart){
         res.send(current_cart);
      })
      get_current_cart.on('error',function(current_cart_error){
         res.send(current_cart_error);
      })
  });
  save_cart_product.on('error', function(cart_product__error) {
     res.send(JSON.stringify(cart_product__error.message));
  });
})

process.on('uncaughtException', function (err) {
    console.log(err);
});
app.listen(3030, function(){
  console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env);
});
