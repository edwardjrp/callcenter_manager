class Kapiqua25.Models.CartProduct extends Backbone.RelationalModel
  url: ()->
    "http://localhost:3030/cart_products"
  
  sync: (method, model, options)=>
    methodMap = {'create': 'POST','update': 'PUT','delete': 'DELETE','read':   'GET'}
    
    type = methodMap[method]
    
    params = {type: type, dataType: 'json'}
    
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
        this.get('cart').set(response)
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