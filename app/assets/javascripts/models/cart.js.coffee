class Kapiqua25.Models.Cart extends Backbone.RelationalModel
  url: '/carts'

  relations:[
      type: Backbone.HasMany
      key: 'cart_products'
      relatedModel: 'Kapiqua25.Models.CartProduct'
      collectionType: 'Kapiqua25.Collections.CartProducts'
      reverseRelation:
        key: 'cart'
        includeInJSON: 'id'
    ]
    
Kapiqua25.Models.Cart.setup()