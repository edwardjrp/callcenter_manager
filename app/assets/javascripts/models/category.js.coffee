class Kapiqua25.Models.Category extends Backbone.RelationalModel
  relations:[
      type: Backbone.HasMany
      key: 'products'
      relatedModel: 'Kapiqua25.Models.Product'
      collectionType: 'Kapiqua25.Collections.Products'
      reverseRelation:
        key: 'category'
        includeInJSON: 'id'
    ]

Kapiqua25.Models.Category.setup()