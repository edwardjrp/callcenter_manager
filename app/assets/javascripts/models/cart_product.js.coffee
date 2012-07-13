class Kapiqua25.Models.CartProduct extends Backbone.RelationalModel
  relations:[
      type: Backbone.HasOne
      key: 'product'
      relatedModel: 'Kapiqua25.Models.Product'
      collectionType: 'Kapiqua25.Collections.Products'
      reverseRelation:
        key: 'cart_products'
        includeInJSON: 'id'
    ]
    
Kapiqua25.Models.CartProduct.setup()