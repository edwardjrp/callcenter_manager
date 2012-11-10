class Option

  attr_reader :part, :code, :quantity, :category, :recipe

  def initialize(category, recipe)
    @category = category
    @recipe = recipe
  end

  def product
    Product.where(category_id: category.id).find_by_productcode(code)
  end 

  def regexp
    /^([0-9]{0,2}\.?[0|7|5]{0,2})([A-Z]{1,}[a-z]{0,})(?:\-([W12]))?/
  end

  def quantity
    @quantity = value_or_default
  end

  def code
    @code = recipe.match(regexp)[2]
  end

  def part
    @part = recipe.match(regexp)[3] || 'W'
  end

  def to_s
    return '' if product.nil?
    q = 'SIN ' if quantity == 0
    part == 'W' ? "#{q}#{product.productname}" : "#{q}#{product.productname} a la #{part_map}"
  end

  def to_hash
    { quantity: quantity , code: code, part: part }
  end


  def part_map
    case part
      when '1' then
        'Izquierda'
      when '2' then
        'Derecha'
      else
        'Completa'
    end
  end


  private

    def normlize_quantity
      (recipe.match(regexp)[1].to_f == recipe.match(regexp)[1].to_i) ? recipe.match(regexp)[1].to_i : recipe.match(regexp)[1].to_f
    end

    def value_or_default
      (recipe.match(regexp)[1].blank? ? 1 : normlize_quantity)
    end
end
