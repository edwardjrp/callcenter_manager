class Kapiqua25.Models.CartProduct extends Backbone.RelationalModel
  url: ()->
    "http://localhost:3030/cart_products"
  
  
  
  parsed_options: ()->
    product_options = []
    recipe = this.get('product').get('options')
    options = this.get('product').get('category').get('products').where({options: 'OPTION'})
    if _.any(recipe.split(','))
      _.each _.compact(recipe.split(',')), (code) ->
        core_match = code.match(/^([0-9]{0,2}\.?[0|7|5]{0,2})([A-Z]{1,}[a-z]{0,})(?:\-([L12]))?/)
        if core_match?
          core_match[1] = '1' if not core_match[1]? or core_match[1] == ''
          current_quantity = core_match[1]
          current_product = _.find(options, (op)-> op.get('productcode') == core_match[2])
          current_part =  core_match[3] || ''
          product_option = {quantity: Number(current_quantity), product: current_product, part: current_part}
          product_options.push product_option
    product_options


  niffty_opions: () ->
    presentation = _.map @parsed_options(), (option) ->
      option.quantity = '' if option.quantity == '1' || option.quantity == 1
      presenter = option.quantity
      presenter += " #{option.product.get('productname')} "
      presenter += option.part.replace(/1/,'Izquierada').replace(/2/, 'Derecha').replace(/W/,'Completa')
      window.strip(presenter)
    to_sentence presentation
  
  
  sync: (method, model, options)=>
    methodMap = {'create': 'POST','update': 'PUT','delete': 'DELETE','read':'GET'}
    type = methodMap[method]
    
    params = {type: type, dataType: 'json'}
    
    current_cart = this.get('cart')
    
    params.url = this.url()
    
    if ((not options.data?) && model? and (method == 'create' || method == 'update'))
      params.contentType = 'application/json'
      params.data = this.toJSON()
    
    if ( params.type != 'GET' and !Backbone.emulateJSON)
      params.processData = false
    $.ajax
      type: type
      url: params.url
      data: this.toJSON()
      beforeSend: (xhr)->
        xhr.setRequestHeader("Accept", params.contentType)
      success: (response)=>
        current_cart.set(response)
      error: (response)->
        response
  
  
  relations:[
      type: Backbone.HasOne
      key: 'product'
      relatedModel: 'Kapiqua25.Models.Product'
      collectionType: 'Kapiqua25.Collections.Products'
      reverseRelation:
        key: 'cart_products'
        includeInJSON: 'id'
    ]
  defaults:
    options: ''
    quantity: 1
    updated_at: new Date()
      
Kapiqua25.Models.CartProduct.setup()