class @ItemFactory
  constructor: (@el, @category, @options = {})->


  validate: ->
    errors = []
    errors.push 'No ha selectionado un producto' unless _.values(@options['selected_matchups']).length > 0 and _.values(@options['selected_matchups']).length <=2
    errors.push 'No ha selectionado un sabor' unless @options['selected_flavor']?
    errors.push 'No ha selectionado un tamaño' unless @options['selected_size']?
    result = errors
    errors = []
    $("<div class='purr'>#{window.to_sentence(result)}<div>").purr() if _.any(result)
    return _.any(result)


