class Kapiqua25.Collections.CartProducts extends Backbone.Collection
  url: ()->
    "/cart_products"
    
  model: Kapiqua25.Models.CartProduct
