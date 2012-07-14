class Kapiqua25.Models.CartProduct extends Backbone.RelationalModel
  url: ()->
    "http://localhost:3030/cart_products"
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
      updated_at: new Date()
      
Kapiqua25.Models.CartProduct.setup()