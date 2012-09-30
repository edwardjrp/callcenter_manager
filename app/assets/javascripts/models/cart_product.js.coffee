class Kapiqua25.Models.CartProduct extends Backbone.RelationalModel
  url: ()->
    "/cart_products"
  
    
    
  parsed_options: ()->
    return [] if this.get('product').get('category').get('has_options') == false or this.get('options') == ''
    product_options = []
    recipe = this.get('options') 
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

  
  options_array: ()->
    return '' if this.get('product').get('category').get('has_options') == false
    presentation = _.map @parsed_options(), (option) ->
      option.quantity = '' if option.quantity == '1' || option.quantity == 1
      presenter = option.quantity
      presenter += "#{option.product.get('productcode')}"
      if (option.part? and option.part.match(/1|2/)) then part = "-#{option.part}" else part = ''
      presenter += part
      window.strip(presenter)
    presentation
  
  niffty_opions: () ->
    return '' if this.get('product').get('category').get('has_options') == false
    presentation = _.map @parsed_options(), (option) ->
      option.quantity = '' if option.quantity == '1' || option.quantity == 1
      unless option.quantity == 0 || option.quantity == '0' 
        presenter = option.quantity
        presenter += " #{option.product.get('productname')} "
        presenter += option.part.replace(/1/,'Izquierda').replace(/2/, 'Derecha').replace(/W/,'Completa')
        window.strip(presenter)
    to_sentence presentation
  
  
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