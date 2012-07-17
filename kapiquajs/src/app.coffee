# 
# Module dependencies.


express = require('express')
_ = require('underscore')
pg = require('pg')
util = require('util')
request = require('request')
Config = require('./config')

app = module.exports = express.createServer()
# Configuration

app.configure ->
  app.use(express.logger({ immediate: true, format: 'dev' }))
  app.use(express.bodyParser())
  app.use(express.methodOverride())
  app.use(app.router)


app.configure 'development', ->
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true }))


app.configure 'production', ->
  app.use(express.errorHandler())

# Routes
Config.setup()
client = Config.getConnection()


app.post '/cart_products', (req, res)->
  res.header('Access-Control-Allow-Origin', 'http://localhost:3000')
  res.header('Access-Control-Allow-Methods', '*')
  res.contentType('application/json')
  cart_product = req.body

  save_cart_product = client.query('INSERT INTO cart_products( "cart_id","quantity","product_id", "bind_id","options", "created_at", "updated_at" ) values ($1, $2, $3, $4, $5, $6, $7)  RETURNING "id"',
                       [cart_product.cart,cart_product.quantity,cart_product.product.id,cart_product.bind_id,cart_product.options, new Date(), new Date() ]);
              
  save_cart_product.on 'end', (cart_product_result)->
    
    get_current_cart = client.query('SELECT * FROM carts WHERE "id" = $1 LIMIT 1', [cart_product.cart])
    
    get_current_cart.on 'row', (current_cart)->
      
      get_cart_products = client.query('SELECT * FROM cart_products WHERE cart_id = $1', [current_cart.id])
      
      cart_products = []
      
      get_cart_products.on 'row', (current_cart_product)->
        get_current_product = client.query('SELECT * FROM products WHERE id = $1 LIMIT 1', [current_cart_product.product_id]);
        
        get_current_product.on 'row', (product)->
          current_cart_product.product = product
          cart_products.push(current_cart_product)
          
      get_cart_products.on 'end', (cartProductsResult)->
        current_cart.cart_products = cart_products
        res.send(current_cart)

    get_current_cart.on 'error', (current_cart_error)->
      res.send(current_cart_error)


  save_cart_product.on 'error', (cart_product_error)->
      res.send(JSON.stringify(cart_product_error.message))

process.on 'uncaughtException', (err)->
    console.log(err)

app.listen 3030, ->
  console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env)
